Scripts to tests images manually
--------------------------------

You should be into the `tests/` directory to launch sh scripts.


- `phpversion.sh`: should show the php version installed into the container
- `show_errors.sh`: It should show a PHP warning after executing a script with an undefined constant
- `launch_fpm.sh`: it launches the PHP-FPM container and you can go to `http://localhost:9658` with your browser to see
  a "hello" page.
- `launch_web.sh`: it launches the PHP-FPM+NGINX container, then you can go to `http://localhost:9659` with your browser to see
  a "hello" page. Try also `http://localhost:9659/test/info.php` or `http://localhost:9659/foo/`.
- `create_external_file.sh`: It creates a file from inside the containers. The file is `tmp/hello` and should be owned
  by you. It tests if php user inside the containers have the right uid/gid.