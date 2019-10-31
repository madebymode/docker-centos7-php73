FROM centos:7
MAINTAINER madebymode

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://repo.ius.io/ius-release-el7.rpm
# Update and install latest packages and prerequisites
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
    && yum clean all && yum history new

RUN sed -e 's/127.0.0.1:9000/9000/' \
        -e '/allowed_clients/d' \
        -e '/catch_workers_output/s/^;//' \
        -e '/error_log/d' \
        -i /etc/php-fpm.d/www.conf

CMD ["php-fpm", "-F"]

EXPOSE 9000
