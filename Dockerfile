FROM debian:latest
ENV PATH "$PATH:/root/.composer/vendor/bin"
ADD ./ .
RUN apt-get update \
        && apt-get -y install wget apt-transport-https lsb-release ca-certificates \
        && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
        && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
        && apt-get update \
        && apt-get -y install nginx php7.1 php7.1-fpm openssl php7.1-xml php7.1-mysql php7.1-mbstring php7.1-zip curl git \
        &&  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
        && composer global require "laravel/lumen-installer=~1.0" \
        && composer install

# Define default command.
ADD  /vol1/default /etc/nginx/sites-available/

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
