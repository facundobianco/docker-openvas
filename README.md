# Docker container for openVAS 8

This installs [OpenVAS 8](http://www.openvas.org/news_archive.html#openvas8)
(released 2015-04-02) in Debian 8 (*jessie*).

The `Dockerfile` was created following the steps in:

* [Proturk Security blog](http://proturk.com/blog/install-openvas-8-on-debian-8-jessie)
* [Docker container for OpenVAS8](https://github.com/sergekatzmann/openvas8-complete)

### Plus

* Installs NMap
* Uses openVAS' GPG key
* Updates service name and transport protocol port number registry

## How to use it

On a terminal, run

```
docker build -t openvas .
```

I got > 45min to build this container (CPU [Intel i5-2430M](http://ark.intel.com/products/53450) 
with RAM 12GB).

### Access

Please, before your first login, change this password.

* **USER:** admin
* **PASS:** admin

### Check openVAS installation

Inside the container run

```
checkopenvas8
```

## TODO

* Add niktos
