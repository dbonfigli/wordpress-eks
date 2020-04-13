# Wordpress Docker Image

This dockerfile create an ubuntu based docker image with nginx + php-fpm and a wordpress, ready to be served.

To create the image first move your wordpress files in a directory called "wordpress" at the root of this directory (if you don't have a custom wordpress installation, download it with ```wget https://wordpress.org/latest.zip && unzip latest.zip```), then create the image with:

```bash
docker build -t wpdocker:0.2 .
```

This image does not take env variables, if you want to change wordpress config you should mount volumes with your custom config files.

Nginx / php-fpm run as www-data user (uid/gid 33, default for ubuntu), wordpress is installed with root:root owner/group to avoid security holes, so plugins / new themes cannot be installed inline, ideally you should install new plugins / themes first in your dev environment, then copy the resulting files in WPDockerImage/wordpress and build the image again with the new files.

/var/www/wordpress/wp-content/uploads is writable by www-data.
