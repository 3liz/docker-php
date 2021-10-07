Docker Images for PHP applications
==================================

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

