FROM node:18 as node
FROM php:8.1-apache

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY ./php.ini "$PHP_INI_DIR/php.ini"

RUN mkdir -p /opt
COPY --from=node /opt/yarn-* /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
  && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npx \
  && npm install -g npm

RUN apt-get update \
 && apt-get -y install libzip-dev libonig-dev libpng-dev imagemagick libmagick++-dev fonts-ipafont geoip-bin libgeoip-dev libssh2-1 libssh2-1-dev\
 && pecl install imagick ssh2\
 && docker-php-ext-install zip pdo_mysql mysqli mbstring gd bcmath\
 && docker-php-ext-enable imagick ssh2\
 && a2enmod rewrite \
 && sed -i -e 's/domain="coder" rights="none" pattern="PDF"/domain="coder" rights="read|write" pattern="PDF"/g' /etc/ImageMagick-6/policy.xml
