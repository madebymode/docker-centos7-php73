FROM centos:7
MAINTAINER madebymode

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://repo.ius.io/ius-release-el7.rpm
#php73 is archived
RUN yum-config-manager --enable ius-archive

RUN yum update -y \
    && yum install -y --nogpgcheck --setopt=tsflags=nodocs \
        php73-cli \
        php73-common \
        php73-fpm \
        php73-gd \
        php73-mbstring \
        php73-mysqlnd \
        php73-xml \
        php73-json \
        php73-intl \
        zip \
        unzip \
    && yum clean all && yum history new

RUN sed -e 's/127.0.0.1:9000/9000/' \
        -e '/allowed_clients/d' \
        -e '/catch_workers_output/s/^;//' \
        -e '/error_log/d' \
        -i /etc/php-fpm.d/www.conf
        
#fixes  ERROR: Unable to create the PID file (/run/php-fpm/php-fpm.pid).: No such file or directory (2)        
RUN sed -e '/^pid/s//;pid/' -i /etc/php-fpm.conf    

#composer 1.10
RUN curl -sS https://getcomposer.org/installer | php -- --version=1.10.17 --install-dir=/usr/local/bin --filename=composer

CMD ["php-fpm", "-F"]

EXPOSE 9000
