FROM ubuntu:22.04

LABEL author="Yucel AKIN (yakin68@gmail.com)"

ARG DEBIAN_FRONTEND=noninteractive

# UPDATE PACKAGES
RUN apt-get update

# INSTALL SYSTEM UTILITIES
RUN apt-get install -y \
    apt-utils \
    curl \
    git \
    apt-transport-https \
    software-properties-common \
    g++ \
    build-essential \
    dialog

# INSTALL APACHE2
RUN apt-get install -y apache2
RUN a2enmod rewrite

# INSTALL locales
RUN apt-get install -qy language-pack-en-base \
    && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# INSTALL PHP & LIBRARIES
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install php-pear -y 
RUN apt-get install php8.2 -y




# INSTALL ODBC DRIVER & TOOLS
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
# Automatically accept the terms from Microsoft
RUN apt-get install -y unixodbc unixodbc-dev odbcinst locales
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN apt-get -y install gcc g++ make autoconf libc-dev pkg-config

RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN exec bash

# INSTALL & LOAD SQLSRV DRIVER & PDO
RUN pecl install sqlsrv-5.6.0
RUN echo ";priority=20\nextension=sqlsrv.so" > /etc/php/8.2/cli/conf.d/20-sqlsrv.ini
RUN echo ";priority=20\nextension=sqlsrv.so" > /etc/php/8.2/apache2/conf.d/20-sqlsrv.ini

RUN pecl install pdo_sqlsrv
RUN echo ";priority=30\nextension=pdo_sqlsrv.so" > /etc/php/8.2/cli/conf.d/30-pdo_sqlsrv.ini
RUN echo ";priority=30\nextension=pdo_sqlsrv.so" > /etc/php/8.2/apache2/conf.d/30-pdo_sqlsrv.ini

# INSTALL COMPOSER
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin/ --filename=composer
RUN chmod +x /usr/local/bin/composer

# INSTALL EDITORS
RUN apt-get update && apt-get install nano vim -y

RUN rm -rf /var/www/html && ln -s /app/web/ /var/www/html || true

WORKDIR /app

RUN mkdir -p runtime web/assets && \
    chmod -R 775 runtime web/assets && \
    chown -R www-data:www-data runtime web/assets

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]