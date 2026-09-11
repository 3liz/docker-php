CHANGELOG
==========

1.10.0 - 2026-09-11
-------------------

- Use debian trixie for the image PHP 8.4
- Use debian bookworm for the image PHP 8.1
- Drop support of PHP 7.4

1.9.0 - 2025-12-10
------------------

- New image with PHP 8.5 + trixie

1.8.1 - 2024-11-26
------------------

- Add missing extensions for PHP 8.4

1.8.1 - 2024-11-22
------------------

- New image with PHP 8.4 + bookworm

1.8.0 - 2024-11-14
------------------

- Build experimental PHP 8.4 images with bookworm
- Use debian bookworm for PHP 8.2 and 8.3

1.7.0 - 2024-07-02
------------------

- build & tests: use `docker compose`

1.6.1 - 2024-01-05
------------------

- Fix uid/gid on /home/userphp/*

1.6.0 - 2023-12-14
------------------

- New image with PHP 8.3
- Drop support for PHP 8.0
- New images including nginx + php-fpm
- Ability to configure the default virtual host of the web image

1.5.0 - 2023-11-08
------------------

- Build experimental PHP 8.3 images with bullseye
- build: Use the same Dockerfile to build images for cli and fpm

1.4.0 - 2023-02-03
------------------

- New image with PHP 8.2
- Fix php.ini: put new configuration into conf.d

1.3.2 - 2022-03-21
------------------

- Remove some output in the php-cli image

1.3.1 - 2022-03-14
------------------

- optimize the size of the first layer.
- fix: setup display_errors only with the root user

1.3.0 - 2022-01-19
------------------

- Pass all entrypoint arguments to entrypoint subscripts.
- Fix typo in some scripts
- Remove support of APP_USER_NAME and APP_GROUP_NAME variables

1.2.0 - 2021-12-08
------------------

- Support of APP_USER_NAME and APP_GROUP_NAME variables

1.1.0 - 2021-12-07
------------------

- Build fix
- Use bullseye

1.0.0 - 2021-12-07
-----------------

Initial release. Available PHP version: 7.4, 8.0, 8.1, with debian buster.
Images with only cli, and Images with only fpm.

