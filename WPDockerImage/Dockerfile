FROM ubuntu:latest

RUN apt-get update && apt-get install -y supervisor nginx php-fpm php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-ldap php-zip php-curl curl

#install wp-cli
RUN curl -o /usr/local/sbin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x /usr/local/sbin/wp

#configure supervisord
COPY conf/supervisord.conf /etc/supervisor/supervisord.conf

#configure php
COPY conf/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
COPY conf/custom-php.ini /etc/php/7.2/fpm/conf.d/30-custom-php.ini

#configure nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
COPY conf/wpsite.conf /etc/nginx/sites-available/wpsite.conf
RUN ln -s /etc/nginx/sites-available/wpsite.conf /etc/nginx/sites-enabled/wpsite.conf

#copy actual wordpress files
COPY wordpress /var/www/wordpress
RUN mkdir -m=0755 -p /var/www/wordpress/wp-content/uploads && chown www-data:www-data /var/www/wordpress/wp-content/uploads

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
