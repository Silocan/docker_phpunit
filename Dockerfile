FROM php:8.1

RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        subversion \
        wget \
        zip \
        unzip \
        rsync \
        bash \
        openssh-client \
        pkg-config \
        libssl-dev && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://phar.phpunit.de/phpunit-8.phar -O /usr/local/bin/phpunit && \
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

## 
RUN curl -sSLf \
    -o /usr/local/bin/install-php-extensions \
    https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions


RUN install-php-extensions bcmath calendar curl gd intl ldap mysqli opcache pdo pdo_mysql redis soap xml xdebug zip && \
    pecl install mongodb-1.21.2 && \
    docker-php-ext-enable mongodb;

# Installation de Vault
ENV VAULT_VERSION="1.7.0"
ENV VAULT_ZIP="vault_${VAULT_VERSION}_linux_amd64.zip"

RUN wget https://releases.hashicorp.com/vault/$VAULT_VERSION/$VAULT_ZIP && \
	unzip $VAULT_ZIP -d /usr/sbin && rm $VAULT_ZIP
