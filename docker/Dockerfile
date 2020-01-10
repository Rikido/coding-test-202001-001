FROM centos:centos7

LABEL maintainer="rikido.kazumasa.tanaka <k.tanaka@rikido.net>"




RUN yum update -y && \
    yum install -y epel-release && \
    yum upgrade -y && \
    yum install -y htop && \
    yum install -y nginx && \
    yum install -y net-tools && \
	yum -y install openssh-server && \
	yum -y install wget which vim
	
RUN yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum -y install --enablerepo=remi-php72 php php-common php-opcache php-mbstring php-xdebug php-mysql php-mysqlnd php-zip php-pdo php-cli php-devel php-pear php-xml php-gd php-fpm


RUN wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
RUN bash mariadb_repo_setup
RUN yum -y install MariaDB-server MariaDB-client

COPY mysql.client.cnf /etc/my.cnf.d/mysql-clients.cnf
COPY mysql.server.cnf /etc/my.cnf.d/server.cnf

RUN mkdir -p /var/log/mysql/
RUN chmod -R 777 /var/log/mysql


EXPOSE 80
EXPOSE 443
EXPOSE 3306


RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
# RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer


COPY xdebug.ini /etc/php.d
COPY www.conf /etc/php-fpm.d/

COPY startup.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/startup.sh

COPY nginx.test.conf /etc/nginx/conf.d/

RUN echo "/usr/local/bin/startup.sh" >> /etc/rc.local


RUN sed -i -e "s/#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN sed -i -e "s/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g" /etc/ssh/sshd_config
RUN sed -i -e "s/PasswordAuthentication yes/#PasswordAuthentication yes/g" /etc/ssh/sshd_config


RUN sed -i -e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" /etc/php-fpm.d/www.conf

RUN sed -i -e "s/;listen.owner = nobody/listen.owner = nginx/g" /etc/php-fpm.d/www.conf
RUN sed -i -e "s/;listen.group = nobody/listen.group = nginx/g" /etc/php-fpm.d/www.conf


RUN mkdir -p /var/www/test


COPY init.sql /tmp/
