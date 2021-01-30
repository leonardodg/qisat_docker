# Project Docker Qisat
Projeto criado para compilar imagem da maquina apache para desenvolvimento em docker padrão de servidor QiSat

## Images
servidor web = Dockerfile - php:5.6-apache

## Arquivos de Configurações
- Config Hosts
    edit file hosts in S.O.
    [seuip] => teste.qisat.local

- Projeto Folder
    pasta do projeto ./html

- Pasta Apache:
    Arquivos configuração dos vhosts .config
    php.ini

- Pasta ssl
    Arquivos dos certificados ssl
    $ openssl req -x509 -days 1024 -out teste-qisat-local.crt -keyout teste-qisat-local.key -newkey rsa:2048 -nodes -sha256 -subj '/CN=teste.qisat.local' -extensions EXT -config <(printf "[dn]\nCN=teste.qisat.local\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS: teste.qisat.local\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

## Config .env
    copy copy.env .env