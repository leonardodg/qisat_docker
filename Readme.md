

# Project Docker Qisat
Projeto criado para compilar maquinas para desenvolvimento em docker dos sistemas QiSat
- Ecommerce
- WebSite
- Moodle 2.9

## Images
qisat_www = Dockerfile - php:5.6-apache
qisat_db = docker-composer - mysql:5.7  

## Restare Banco QiSat:

1- crie o banco nome "qisat_dev"

2- crie um volume compartilhado com a pasta ./db

3- Fazer restauranção
$ docker exec -it qisat_db bash
$ mysql -u root -p qisat_dev < /pasta_volume/qisat_dev.sql
$ digite a senhaÇ default "qisat"

4- Configurações do banco:

ecm_alternative_host = set host
ecm_config = set urls
mdl_config = set urls
mdl_url - set url = externalurl


## Arquivos de Configurações

- Projeto Website
    pasta do projeto ./website
    Config: links das integrações - File ./config.json

- Projeto Moodle 2.9
    pasta do projeto ./moodle
    config: banco - pasta moodle_data - url = file ./config.php

- Projeto E-commerce (Cakephp 3)
    pasta do projeto ./e-comemrce
    config: banco - debug = ./config/app.php

- Pasta Apache:
    Arquivos configuração dos vhosts .config
    php.ini

- Pasta DB
    Arquivo para restarar backup do banco
    $ mysqldump -h "localhost" -P 3306 -u "root" -p"qisat" --databases "qisat_dev" -q -F -n -v -r "/var/imported/data/qisat_dev.sql" 2> /var/imported/data/banco_qisat.log > /var/imported/data/bq_op.err

    $ mysql -u root -p qisat_dev < /var/imported/data/qisat_dev.sql

- Pasta ssl
    Arquivos dos certificados ssl
    $ openssl req -x509 -out localecommerce-qisat-dev.crt -keyout localecommerce-qisat-dev.key -newkey rsa:2048 -nodes -sha256 -subj '/CN=local-ecommerce.qisat.dev' -extensions EXT -config <(printf "[dn]\nCN=local-ecomerce.qisat.dev\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS: local-ecommerce.qisat.dev\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

## Config .env
    copy copy.env .env