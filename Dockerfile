FROM debian:latest

#RUN apt-get update
#RUN apt-get install -y nginx php7.1 php7.1-fpm composer openssl pdo-mysql php-mbstring
ENV PATH "$PATH:/root/.composer/vendor/bin"
ADD . .
RUN apt-get update \
        && apt-get -y install wget apt-transport-https lsb-release ca-certificates \
        && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
        && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
        && apt-get update \
        && apt-get -y install nginx php7.1 php7.1-fpm openssl php7.1-xml php7.1-mysql php7.1-mbstring php7.1-zip curl git \
        &&  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
         && composer global require "laravel/lumen-installer=~1.0" \
#       && lumen new lumendir
        && composer install
#ENV PATH "$PATH:/root/.composer/vendor/bin"

#RUN apt-get install -y php-zip \
 #   && composer global require "laravel/lumen-installer=~1.0" \
  #  && lumen new lumen-dir
#RUN sed -i -e "s/;\?date.timezone\s*=\s*.*/date.timezone = Europe\/Kiev/g" /etc/php5/fpm/php.ini

# Define default command.
ADD /vol1/default /etc/nginx/sites-available/

ADD /vol1/php.ini /etc/php/7.1/fpm/
#ADD /index.php /blog/public/
#ENTRYPOINT service nginx start
#WORKDIR /
ADD start.sh .
RUN chmod +x start.sh
CMD ./start.sh
#CMD ["/bin/bash","./start.sh"]
# Expose ports.
EXPOSE 80
