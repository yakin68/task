FROM FROM php:7.1-apache

COPY . /var/www/html/

# Install system packages
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd xdebug
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip
# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# composer install
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/web-root

RUN chown www-data:www-data /var/www/web-root

COPY --chown=www-data:www-data composer.json composer.lock /var/www/web-root/

USER www-data

RUN --mount=type=cache,target=/home/www-data/.composer,uid=82,gid=82 composer install --no-scripts

COPY --chown=www-data:www-data . /var/www/web-root

RUN composer dump-autoload

EXPOSE 80
CMD ["php-fpm"]


