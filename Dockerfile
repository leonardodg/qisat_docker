FROM php:5.6-apache

ARG UID=root
ARG GID=root
ARG USER

COPY ./apache /etc/apache2/sites-available
COPY ./apache/php.ini /usr/local/etc/php/php.ini
COPY --chown=www-data:www-data ./ssl /var/imported/ssl

# en_US config
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 
ENV LANG en_US.UTF-8

# Install
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y zip unzip git nano curl gnupg ruby-full mysql-client pngquant \
        libfreetype6-dev libjpeg62-turbo-dev libpng-dev libssl-dev g++ libmcrypt4 zlib1g-dev libmcrypt-dev libicu-dev libxml2-dev libxslt-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    &&  /usr/local/bin/docker-php-ext-install pcntl zip bcmath gd xml xmlrpc dom session intl mysqli pdo_mysql mbstring soap opcache xsl pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite && a2enmod headers && a2enmod ssl

# Install Composer PHP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN chown -R ${UID}:${GID} /var/www/html/ && chmod -R 777 /var/www/html/
VOLUME /var/www/html

CMD ["apachectl", "-D", "FOREGROUND"]