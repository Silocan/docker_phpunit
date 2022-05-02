FROM php:7.4

RUN apt-get update && \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libgmp-dev \
        libxml2-dev \
        zlib1g-dev \
        libncurses5-dev \
        libldap2-dev \
        libicu-dev \
        libmemcached-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libonig-dev \ 
        libzip-dev \
        curl \
        git \
        subversion \
        wget \
        zip \
        unzip \
        rsync \
        openssh-client \
        autoconf \
        build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://phar.phpunit.de/phpunit-6.phar --no-check-certificate -O /usr/local/bin/phpunit && \
    chmod +x /usr/local/bin/phpunit

# Composer 
RUN set -ex; \     
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \     
    chmod +x /usr/local/bin/composer

## ----- Set LOCALE to UTF8
RUN apt update && apt install -y locales && \
    echo "fr_FR.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen fr_FR.UTF-8 && \
    /usr/sbin/update-locale LANG=fr_FR.UTF-8

ENV LOCALTIME Europe/Paris
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8

RUN pecl install mongodb

RUN echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini

RUN docker-php-ext-configure mysqli && \
    docker-php-ext-install mysqli && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd && \
    docker-php-ext-install soap && \
    docker-php-ext-install intl && \
#    docker-php-ext-install mcrypt && \
    docker-php-ext-install gmp && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install zip && \
    docker-php-ext-install pcntl && \
    docker-php-ext-install ftp && \
    docker-php-ext-install sockets && \
    docker-php-ext-install bcmath 

# Installation de Vault
ENV VAULT_VERSION="1.7.0"
ENV VAULT_ZIP="vault_${VAULT_VERSION}_linux_amd64.zip"

RUN wget https://releases.hashicorp.com/vault/$VAULT_VERSION/$VAULT_ZIP && \
	unzip $VAULT_ZIP -d /usr/sbin && rm $VAULT_ZIP
