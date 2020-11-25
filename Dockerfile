FROM php:5.6-apache

ARG UID=root
ARG GID=root
ARG USER

COPY ./apache /etc/apache2/sites-available
COPY ./apache/php.ini /usr/local/etc/php/php.ini
COPY --chown=www-data:www-data ./ssl /var/imported/ssl

# Install
RUN apt-get update \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev \
        apt-utils pngquant libpng-dev curl libssl-dev \
        libmcrypt-dev libicu-dev libxml2-dev git libxslt-dev libzip-dev zip unzip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    &&  /usr/local/bin/docker-php-ext-install zip bcmath gd xml xmlrpc dom session intl mysqli pdo_mysql mbstring soap opcache xsl pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite && a2enmod headers && a2enmod ssl \
    && a2ensite website && a2ensite website-ssl && a2ensite ecommerce && a2ensite ecommerce-ssl \
    && a2ensite moodle && a2ensite moodle-ssl

# Install Composer PHP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

CMD ["apachectl", "-D", "FOREGROUND"]

RUN chown -R ${UID}:${GID} /var/www/html
VOLUME /var/www/html
VOLUME /var/www/moodledata
