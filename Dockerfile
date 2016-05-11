FROM php:fpm
MAINTAINER Diego Gullo <diegogullo@gmail.com>

COPY oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb .
COPY oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb .

RUN apt-get update && apt-get install -y libaio1 \
    && dpkg -i oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb \
    && dpkg -i oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb \
    && export LD_LIBRARY_PATH="/usr/lib/oracle/12.1/client64/lib" \
    && instantclient,/usr/lib/oracle/12.1/client64/lib | pecl install oci8 \
    && docker-php-ext-enable oci8