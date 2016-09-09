FROM php:fpm
MAINTAINER Diego Gullo <diego_gullo@bizmate.biz>

COPY oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb .
COPY oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb .

#RUN curl -vs https://packagecloud.io/gpg.key 2>&1 | apt-key add - \
#    && echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list

RUN apt-get update && apt-get install -y libaio1 git  \
    && dpkg -i oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb \
    && dpkg -i oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb \
    && export LD_LIBRARY_PATH="/usr/lib/oracle/12.1/client64/lib" \
    && instantclient,/usr/lib/oracle/12.1/client64/lib | pecl install oci8 \
    && docker-php-ext-enable oci8

RUN apt-get install -y zlib1g-dev \
    && pecl install xdebug \
    && docker-php-ext-install  opcache  \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install zip

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so