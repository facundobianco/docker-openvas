# Docker container for openVAS 8

This installs [OpenVAS 8](http://www.openvas.org/news_archive.html#openvas8)
(released 2015-04-02) in Debian 8 (*jessie*).

The `Dockerfile` was created following the steps in:

* [Proturk Security blog](http://proturk.com/blog/install-openvas-8-on-debian-8-jessie)
* [Docker container for OpenVAS8](https://github.com/sergekatzmann/openvas8-complete)

### Plus

* Use NMap with its NVTs
* Use openVAS' GPG key
* Updates service name and transport protocol port number registry
* Generates reports in PDF format

## How to use it

On a terminal, run

```
docker build -t openvas .
```

I waited >= 495 minutes (8hs) to build this container on a CPU [Intel i5-2430M](http://ark.intel.com/products/53450) 
with RAM 12GB. The longest process was `openvasmd --rebuild` because it needs to reload 43955 NVTs.

Start the container

```
docker run -d -p 80:80 -p 443:443 --name openvas openvas
```

### Access

Login into [GSA](https://localhost/login/login.html)

* **USER:** admin
* **PASS:** admin

[Change this password](https://localhost/omp?cmd=edit_user&user_id=0c185d9e-9903-47d2-9eea-9a7521539e86)
after your first login.
