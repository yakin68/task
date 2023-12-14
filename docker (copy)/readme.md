sudo usermod -aG docker $USER

newgrp docker



docker exec -it myapp bash

docker-compose up -d

docker build -t myapp .
$ docker run -d --name myapp myapp
$ docker run -d -p 80:80 --name myapp -v "$PWD":/var/www/html php:7.1-apache
