FROM php:7.4-apache

ARG PHP_INI_MODEL
ARG PHP_INI_LAMPP
#ARG USER_ID
#ARG GROUP_ID

RUN apt-get update && apt-get upgrade -y && \
    apt-get install zlib1g-dev libpng-dev -y && \
    docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install tokenizer && \
    docker-php-ext-install json && \
    docker-php-ext-install gettext && \
    docker-php-ext-install exif && \
    docker-php-ext-install gd && \
    docker-php-ext-install opcache && \
    docker-php-ext-enable opcache && \
    pecl install xdebug-2.8.1 && \
    docker-php-ext-enable xdebug && \
    a2enmod rewrite headers && \
    cp ${PHP_INI_MODEL} ${PHP_INI_LAMPP} && \
    sed -i '/\[PHP\]/a y2k_compliance = On' ${PHP_INI_LAMPP} && \
    sed -i 's/serialize_precision = .*/serialize_precision = 100/g' ${PHP_INI_LAMPP} && \
    sed -i 's/;realpath_cache_size = .*/realpath_cache_size = 4096k/g' ${PHP_INI_LAMPP} && \
    sed -i 's/;realpath_cache_ttl = .*/realpath_cache_ttl = 120/g' ${PHP_INI_LAMPP} && \
    sed -i 's/max_execution_time = .*/max_execution_time = 5/g' ${PHP_INI_LAMPP} && \
    sed -i 's/max_input_time = .*/max_input_time = 60/g' ${PHP_INI_LAMPP} && \
    sed -i 's/;max_input_nesting_level = .*/max_input_nesting_level = 64/g' ${PHP_INI_LAMPP} && \
    sed -i 's/memory_limit = .*/memory_limit = 64M/g' ${PHP_INI_LAMPP} && \
    sed -i 's/;html_errors = On/html_errors = On/g' ${PHP_INI_LAMPP} && \
    sed -i 's/;docref_root = "\/phpmanual\/"/docref_root = "\/phpmanual\/"/g' ${PHP_INI_LAMPP} && \
    sed -i 's/post_max_size = .*/post_max_size = 25M/g' ${PHP_INI_LAMPP} && \
    sed -i 's/upload_max_filesize = .*/upload_max_filesize = 40M/g' ${PHP_INI_LAMPP} && \
    sed -i 's/max_file_uploads = .*/max_file_uploads = 3/g' ${PHP_INI_LAMPP} && \
#    sed -i '/;date.timezone =/a date.timezone = America/Fortaleza' ${PHP_INI_LAMPP} && \
    sed -i '/\[Pdo_mysql\]/a pdo_mysql.cache_size = 2000' ${PHP_INI_LAMPP} && \
    sed -i 's/mail.add_x_header = .*/mail.add_x_header = On/g' ${PHP_INI_LAMPP}

#
# uncoment the section below to enable external ssl certificate
#
#----------------------------SSL CERTIFICATE-----------------------------
#RUN a2enmod ssl
#COPY ./certificates/my_ssl.crt /etc/ssl/certs/ssl.crt
#COPY ./certificates/my_ssl.key /etc/ssl/private/ssl.key
#ARG APACHE_CONF_FILE
#RUN sed -i '$ a <VirtualHost *:443>' ${APACHE_CONF_FILE} && \
#    sed -i '$ a 	SSLEngine on' ${APACHE_CONF_FILE} && \
#    sed -i '$ a 	SSLCertificateFile "/etc/ssl/certs/ssl.crt"' ${APACHE_CONF_FILE} && \
#    sed -i '$ a 	SSLCertificateKeyFile "/etc/ssl/private/ssl.key"' ${APACHE_CONF_FILE} && \
#    sed -i '$ a </VirtualHost>' ${APACHE_CONF_FILE} && \
#    update-ca-certificates
#------------------------------------------------------------------------

#
# uncoment the section below to fix linux users permission issue
#
#---------------------------USER'S PERMISSIONS---------------------------
#RUN userdel -f www-data &&\
#    if getent group www-data ; then groupdel www-data; fi &&\
#    groupadd -g ${GROUP_ID} www-data &&\
#    useradd -l -u ${USER_ID} -g www-data www-data &&\
#    install -d -m 0755 -o www-data -g www-data /home/www-data &&\
#    chown --changes --silent --no-dereference --recursive \
#          --from=33:33 ${USER_ID}:${GROUP_ID} \
#        /home/www-data \
#        /var/www/html/
#------------------------------------------------------------------------

EXPOSE 80
EXPOSE 443