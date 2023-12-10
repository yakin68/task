FROM php:7.1-apache

# Install SQL Server driver for PHP
RUN apt-get update && \
    apt-get install -y unixODBC-dev && \
    pecl install sqlsrv && \
    docker-php-ext-enable sqlsrv && \
    pecl install pdo_sqlsrv && \
    docker-php-ext-enable pdo_sqlsrv
    
COPY QuickDbTest.php /var/www/html/

CMD ["php", "/var/www/html/QuickDbTest.php"]
