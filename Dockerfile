FROM php:7.4-apache

COPY --from=composer:1 /usr/bin/composer /usr/bin/composer
COPY ./php.ini "$PHP_INI_DIR/php.ini"