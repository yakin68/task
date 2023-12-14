sudo usermod -aG docker $USER

newgrp docker



docker exec -it myapp bash

docker-compose up -d

docker build -t myapp .
$ docker run -d --name myapp myapp
$ docker run -d -p 80:80 --name myapp -v "$PWD":/var/www/html php:7.1-apache

1. using xaamp with php version 7.1
2. Download and install odbc driver https://www.microsoft.com/en-us/download/confirmation.aspx?id=36434
3. Download and extract https://github.com/Microsoft/msphpsql/releases/tag/v4.1.3-Windows
4. Following files are required from 7.1 folder download in step 3.
    php_pdo_sqlsrv_7_ts.dll
    php_sqlsrv_7_ts.dll
5. Copy above files into ext folder(xampp -> php ->ext)
6. Add following line in php.ini
    extension=php_pdo_sqlsrv_7_ts.dll
    extension=php_sqlsrv_7_ts.dll
7. Restart Apache if already running.
8. Check php_info to ensure driver are loaded.
@yakin68
Comment


curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc

curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list

sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18
# optional: for bcp and sqlcmd
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
source ~/.bashrc
# optional: for unixODBC development headers
sudo apt-get install -y unixodbc-dev

Linux ve macOS'ta aşağıdaki komutları çalıştırın:
sudo pecl install sqlsrv-5.11.1
sudo pecl install pdo_sqlsrv-5.11.1
