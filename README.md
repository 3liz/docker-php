Docker Images for PHP applications
==================================

Images providing a PHP environment, with some preloaded extension. 

Work in progress.

To build images
---------------

To build the php-cli image:

```
make build-cli
```

To build the php-fpm image:

```
make build-fpm
```

You can set the PHP_VERSION to the version of PHP you want.

```
make build-fpm PHP_VERSION=8.0
```

To run images
-------------

Simple example:

```
docker run -i 3liz/php-cli:7.4 php --version
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

If files are created in a volume, probably you would like an other id, so
a specific user on the host could access to this files.

You can change the id, by providing environment variable containing these id,
at the start of the container. Variables should be `APP_USER_ID` and `APP_GROUP_ID`.

In most of case, during development, you would like to set with your own user id:

```

export APP_USER_ID=$(id -u)
export APP_GROUP_ID=$(id -g)

docker run -i -e APP_GROUP_ID -e APP_USER_ID 3liz/php-fpm:7.4
```

In the `php-cli` image, to run a script with `userphp`, don't use the `--user`
parameter, but call your script with `exec_userphp`:

```

export APP_USER_ID=$(id -u)
export APP_GROUP_ID=$(id -g)

docker run -i -e APP_GROUP_ID -e APP_USER_ID 3liz/php-cli:7.4 exec_userphp touch /app/hello
```

Application mount
-----------------

There is a directory into the image, `/app`, owned by `userphp` and `groupphp`.
You can mount a volume at this path. It could contain a PHP application.



Inheriting from the image
-------------------------

You would want to use the image at a base image for your own images.

You would like call your own scripts at startup, like any entrypoint.
Just put your scripts into `/bin/entrypoint.d/`. They will be called by
the main entrypoint of the `php-cli`/`php-fpm` image.

```dockerfile
FROM 3liz/php-cli:7.4

# exemple to install a specific extension
RUN apt-get -y install php7.4-other-extension

# exemple to add an additional entrypoint script
COPY my-entrypoint-script.sh /bin/entrypoint.d/

```



