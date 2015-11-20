FROM debian:8.2
MAINTAINER Facundo Bianco < vando [at] van [dot] do >

ENV TERM xterm
ENV LD_LIBRARY_PATH /usr/local/lib
ENV PATH $PATH:/usr/local/sbin:/usr/local/bin

ADD http://wald.intevation.org/frs/download.php/2067/openvas-libraries-8.0.3.tar.gz /usr/local/src/
ADD http://wald.intevation.org/frs/download.php/2071/openvas-scanner-5.0.3.tar.gz /usr/local/src/
ADD http://wald.intevation.org/frs/download.php/2075/openvas-manager-6.0.3.tar.gz /usr/local/src/
ADD http://wald.intevation.org/frs/download.php/1987/openvas-cli-1.4.0.tar.gz /usr/local/src/
ADD http://wald.intevation.org/frs/download.php/2079/greenbone-security-assistant-6.0.3.tar.gz /usr/local/src/
ADD http://nmap.org/dist/nmap-5.51.6.tgz /usr/local/src/
ADD http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml /tmp/

COPY bin/* /usr/local/bin/
RUN find /usr/local/bin -type f -not -executable -exec chmod +x {} \;

RUN apt-get update && apt-get install -y --no-install-recommends \
    alien bison build-essential clang cmake doxygen flex gnupg libgcrypt11-dev libglib2.0-dev libgnutls28-dev \
    libgpgme11-dev libhiredis-dev libksba-dev libldap2-dev libmicrohttpd-dev libpcap-dev libsqlite3-dev \
    libssh-dev libxml2-dev libxslt1-dev net-tools nsis openssh-client pkg-config redis-server rpm rsync sqlfairy \
    sqlite3 texlive-latex-base uuid-dev wget xmltoman xsltproc
    
RUN for SRC in openvas-libraries-8.0.3 openvas-manager-6.0.3 openvas-scanner-5.0.3 openvas-cli-1.4.0 \
               greenbone-security-assistant-6.0.3 ; \
    do \
       tar -C /usr/local/src -zxf /usr/local/src/${SRC}.tar.gz ; \
       cd /usr/local/src/${SRC} ; \
       cmake . && \
       make &&\
       make doc &&\
       make install ; \
    done

RUN tar -C /usr/local/src -zxf /usr/local/src/nmap-5.51.6.tgz
RUN cd /usr/local/src/nmap-5.51.6 ; ./configure && make && make install 

RUN openvas-mkcert -q
RUN openvas-mkcert-client -n -i
RUN openvas-certdata-sync
RUN openvas-nvt-sync
RUN openvas-scapdata-sync

RUN wget -qO - http://www.openvas.org/OpenVAS_TI.asc | gpg --homedir=/usr/local/etc/openvas/gnupg --import -
RUN echo 'C3B468D2288C68B9D526452248479FF648DB4530:6' | \
    gpg --homedir=/usr/local/etc/openvas/gnupg --import-ownertrust

RUN echo "nasl_no_signature_check = no" >> /usr/local/etc/openvas/openvassd.conf
RUN echo "alias checkopenvas8='/usr/local/bin/openvas-check-setup --v8'" >> /root/.bashrc
RUN ln -s /usr/local/var/log/openvas /var/log

COPY conf/redis.conf /etc/redis/redis.conf
RUN mkdir /var/dump
RUN redis-server /etc/redis/redis.conf && \
    openvasmd --create-user=admin --role=Admin && \
    openvasmd --user=admin --new-password=admin

RUN openvassd && openvasmd && openvasmd --rebuild --progress -v
RUN openvas-portnames-update /tmp/service-names-port-numbers.xml

EXPOSE 80 443
CMD ["/usr/local/bin/openvas8.run"]
