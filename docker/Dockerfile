FROM php:7.1-apache
RUN apt-get update && apt-get -y install nano apt-utils libxml2-dev gnupg \
    && apt-get install -y zlib1g-dev \
    && apt-get install -y libzip-dev \
    && docker-php-ext-install zip 

RUN apt-get -y install libicu-dev gcc g++ make autoconf libc-dev pkg-config libssl-dev apt-transport-https libgss3 

# Install MS ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update
    
# Automatically accept the terms from Microsoft
RUN apt-get install -y unixodbc unixodbc-dev odbcinst locales
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN apt-get -y install gcc g++ make autoconf libc-dev pkg-config
RUN apt-get update     
RUN pecl install sqlsrv-5.6.0 pdo_sqlsrv-5.6.0

#RUN echo "extension=/usr/lib/php/2*/sqlsrv.so" >> /etc/php/7.1/apache2/php.ini
#RUN echo "extension=/usr/lib/php/2*/pdo_sqlsrv.so" >> /etc/php/7.1/apache2/php.ini
#RUN echo "extension=/usr/lib/php/2*/sqlsrv.so" >> /etc/php/7.1/cli/php.ini
#RUN echo "extension=/usr/lib/php/2*/pdo_sqlsrv.so" >> /etc/php/7.1/cli/php.ini 

COPY QuickDbTest.php /var/www/html/

COPY ./docker-php.conf /etc/apache2/conf-available/
RUN chmod 644 /etc/apache2/conf-available/docker-php.conf

# Enable the necessary Apache module
RUN a2enmod rewrite

CMD ["php", "/var/www/html/QuickDbTest.php"]
