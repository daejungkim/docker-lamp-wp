#
# Dockerfile that builds container with Apache and PHP
# When not using vagrant, run it manually with: docker build - < Dockerfile
#


# Image: PHP
#
# VERSION               0.0.1

FROM     ubuntu
MAINTAINER Jonas Colmsjö "jonas@gizur.com"


# -----------------------------------------------------------------------------------
# PREPARATIONS 
#


#
# Install some nice tools (mainly used for debugging)
#

RUN apt-get install -y curl lynx git


#
# Install Apache and PHP
#

RUN apt-get install -y apache2 php5 php5-curl php5-mysql 

# -----------------------------------------------------------------------------------
# SETUP THE APP
#

# Bundle everything and install
ADD . /var/www
ADD ./conf/etc /etc
#ADD ./conf/usr /usr
RUN rm /var/www/index.html

#RUN cd /var/www && curl -sS https://getcomposer.org/installer | php
#RUN mv /var/www/composer.phar /var/www/composer
#RUN cd /var/www && ./composer install

EXPOSE  8080 8443
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

