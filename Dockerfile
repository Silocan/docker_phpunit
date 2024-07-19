FROM php:7.2

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
    curl -sS https://getcomposer.org/installer | php -- --version=1.10.16 --install-dir=/usr/local/bin --filename=composer; \     
    chmod +x /usr/local/bin/composer

## ----- Set LOCALE to UTF8
RUN apt update && apt install -y locales && \
    echo "fr_FR.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen fr_FR.UTF-8 && \
    /usr/sbin/update-locale LANG=fr_FR.UTF-8

ENV LOCALTIME Europe/Paris
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8

## 
RUN curl -sSLf \
    -o /usr/local/bin/install-php-extensions \
    https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions


RUN install-php-extensions blackfire xdebug intl opcache pdo gd zip bcmath xml mysqli curl calendar pdo_mysql redis mongodb-1.15.1 ldap soap mbstring ftp;

# Installation de Vault
ENV VAULT_VERSION="0.10.4"
ENV VAULT_ZIP="vault_${VAULT_VERSION}_linux_amd64.zip"

RUN wget https://releases.hashicorp.com/vault/$VAULT_VERSION/$VAULT_ZIP && \
	unzip $VAULT_ZIP -d /usr/sbin && rm $VAULT_ZIP
