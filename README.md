Docker Images for PHP applications
==================================

Images providing a PHP environment, with some preloaded extension.

Three flavour of images are available:
- `3liz/liz-php-cli` : provides only the php shell command 
- `3liz/liz-php-php` : launch a PHP-FPM server (fast-cgi)
- `3liz/liz-php-web` : launch a web server (nginx) and php-fpm

And each of them are available in version 7.4, 8.1, 8.2 and 8.3.

Features
========

* Based on Debian Bullseye-slim
* Use packages from packages.sury.org, made by the maintainer of the official debian packages of PHP.
* List of extensions:
  - all extensions built within the PHP binary of the debian package
  - other: bcmath, bz2, curl, dba, gd, imap, intl, json, ldap, mbstring, memcache, memcached, mysql, pgsql,
    redis, soap, sqlite3,xml, uuid, yaml, zip
* Composer is also installed.
* Other softwares : curl, wget, git, unzip, gnupg2
* possibility to setup at startup the uid/gid of the user that run php, so generated files into volumes could be owned 
  by the corresponding user on the host for example. 
* possibility to extend the entrypoint script.
* possibility to enable the display of errors for debug 

To build images
===============

To build the php-cli and the php-fpm image:

```
make build
```

You can set the PHP_VERSION to the version of PHP you want.

```
make build PHP_VERSION=8.1
```

To run images
=============

Simple example that launch `php --version` :

```
docker run -i 3liz/liz-php-cli:8.3 php --version
```

environment variables
---------------------

- `APP_USER_ID`: id of the user `userphp` that run scripts into php-cli/php-fpm (see below)
- `APP_GROUP_ID`: id of the group `groupphp` that run scripts into php-cli/php-fpm (see below)
- `DISPLAY_ERRORS`: `on` to display php errors in results (`display_errors` into `php.ini`)


Setting user id and group id
----------------------------

In the image there are a user `userphp` and a group `groupphp`. The fpm process
is running PHP with this group and user. By default, their id are `1000`.
It means that files created by the PHP application will be owned by `userphp` and `groupphp`,
with the id `1000`.

If files are created in a volume, probably you would like another id, so
a specific user on the host could access to these files.

You can change the id, by providing environment variable containing this id,
at the start of the container. Variables should be `APP_USER_ID` and `APP_GROUP_ID`.

In most of case, during development, you would like to set with your own user id:

```

export APP_USER_ID=$(id -u)
export APP_GROUP_ID=$(id -g)

docker run -i -e APP_GROUP_ID -e APP_USER_ID 3liz/liz-php-fpm:8.3
```

In the `php-cli` image, to run a script with `userphp`, don't use the `--user`
parameter, but call your script with `exec_userphp`:

```

export APP_USER_ID=$(id -u)
export APP_GROUP_ID=$(id -g)

docker run -i -e APP_GROUP_ID -e APP_USER_ID 3liz/liz-php-cli:8.3 exec_userphp touch /app/hello
```

Application mount
-----------------

There is a directory into the image, `/app`, owned by `userphp` and `groupphp`.
You can mount a volume at this path. It could contain a PHP application.



Providing your entrypoint scripts
---------------------------------

You would like to call your own scripts at startup, like any entrypoint.
Just put your scripts into `/bin/entrypoint.d/`. They will be called by
the main entrypoint of the image, with the same parameters given to the main entrypoint.

```dockerfile
FROM 3liz/liz-php-cli:8.3

# exemple to install a specific extension
RUN apt-get -y install php8.3-other-extension

# exemple to add an additional entrypoint script
COPY my-entrypoint-script.sh /bin/entrypoint.d/

```

Using the web image
===================

To use the `3liz/liz-php-web` image, you can use the environment variables and mounts
described above, but also the following additional setup.

By default, there is virtualhost defining a default web site, which have
the document root at `/app` and configuring the access to php-fpm (into a `snippets/php.conf` nginx file).
Here is this virtualhost:

```
server {
    listen 80;
    server_name _;
    root /app/;

    index index.php index.html;

    include snippets/root_location.conf;
    include snippets/php.conf;
}
```

`root_location.conf` is a file defining the `/` location:

```
    location / {
        try_files $uri $uri/ =404;
    }

```

It may be enough for little internal application without reverse proxy. But you 
may need to enhance this definition in production environment.

You can enhance it by two ways: by setting some environment variables, or by providing 
your own nginx configuration

Customizing the default virtual host
------------------------------------

The default virtual host describe above can be modified by setting these environment
variables:

- `WEB_ROOT_DIRECTORY`: the full path to the document root (files accessible from the web). Default: `/app/`.
- `SERVER_NAME`: the name for the `server_name` configuration parameter. Default: `_`
- `NGINX_HEADER`: nginx configuration instructions to add above the `include snippets/root_location.conf;`. Default: `""`.
- `NGINX_FOOTER`: nginx configuration instructions to add after the `include snippets/php.conf;`. Default: `""`.


Providing your own virtual host configuration file
--------------------------------------------------

If the default virtual host configuration does not correspond to your need (for example with
an SSL configuration), you can provide your own configuration file. 

Mount (or into a derived image, install) your file at the location `/etc/nginx/sites-enabled/site.conf`. 


Using the image behind a reverse proxy
--------------------------------------

You may want also to put the container behind a reverse proxy (in fact the default 
virtual host configuration is for a backend web server).

If you have a frontend web server which runs nginx, you may configure the access
to your `3liz/liz-php-web` container (located at the address `myapp`), using a 
configuration file like this: 

```
server {
    listen       443 ssl;
    server_name  myapp.example.com;

    include snippets/ssl.conf;

    ssl_certificate /etc/ssl/certs/mycert.chain.crt;
    ssl_certificate_key /etc/ssl/private/mycert.key;

    location / {
        proxy_pass http://myapp:80;
        proxy_http_version 1.1;
        proxy_set_header Host       $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_connect_timeout 10;
        proxy_send_timeout 60;
        proxy_read_timeout 60;
        send_timeout 60;
    }
}
```

Access to logs of the web image
-------------------------------

Logs of Nginx and PHP-Fpm are stored into `/var/log/docker-php/` so you can mount
a volume on this directory to access easily to logs. 



