FROM php:5.6-apache

ARG UID=root
ARG GID=root
ARG USER

COPY ./apache /etc/apache2/sites-available
COPY ./apache/php.ini-development /usr/local/etc/php/php.ini
COPY --chown=www-data:www-data ./ssl /var/imported/ssl

COPY ./apache/sources.list /etc/apt/sources.list
RUN apt clean && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt list --upgradable

# en_US config
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 
ENV LANG en_US.UTF-8

# Install
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev \
        apt-utils pngquant libpng-dev curl libssl-dev nano curl gnupg ruby-full ruby-dev build-essential \
        libmcrypt-dev libicu-dev libxml2-dev git libxslt-dev libzip-dev zip unzip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    &&  /usr/local/bin/docker-php-ext-install zip bcmath gd xml xmlrpc dom session intl mysqli pdo_mysql mbstring soap opcache xsl pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite && a2enmod headers && a2enmod ssl \
    && a2ensite website && a2ensite website-ssl && a2ensite ecommerce && a2ensite ecommerce-ssl \
    && a2ensite moodle && a2ensite moodle-ssl \
     && a2ensite indicadores && a2ensite indicadores-ssl

# Install Composer PHP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN curl -sL https://deb.nodesource.com/setup_10.x  | bash -
RUN apt-get -y install nodejs
RUN /usr/bin/npm install -g gulp
# RUN gem update && gem install sass && gem install compass
RUN gem install ffi -v 1.9.25 && gem install sass -v 3.4.25 && gem install chunky_png -v 1.3.8 && gem install rb-inotify -v 0.9.7 && gem install multi_json -v 1.11.2 && gem install compass -v 1.0.3 --no-update-sources
RUN export PATH=$PATH:~/.gem/ruby/2.3.0/bin

RUN chown -R ${UID}:${GID} /var/www/html/ && chmod -R 777 /var/www/html/
VOLUME /var/www/html
VOLUME /var/www/moodledata

CMD ["bash","-c","cd /var/www/html/website/ && /usr/bin/npm install && /usr/bin/npm start"] 
CMD ["apachectl", "-D", "FOREGROUND"]