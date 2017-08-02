FROM ubuntu:latest
MAINTAINER timwr <timrlw@gmail.com>

RUN apt-get update && \
	apt-get install -y --no-install-recommends htop nano net-tools curl file autoconf \
	ssh git ruby ruby-dev postgresql man make patch g++ libxslt1-dev libreadline-dev \
	libssl-dev libpq5 libpq-dev zlib1g-dev libreadline5 libsqlite3-dev libpcap-dev \
	libxml2-dev libyaml-dev build-essential autoconf libpcre3-dev liblua5.2-dev \
	nginx supervisor nmap openjdk-8-jdk \
	vim

#RUN git clone --depth=1 https://github.com/nmap/nmap.git && \
	#cd nmap && \
	#./configure --without-zenmap && \
	#make -j 2 && \
	#make install

WORKDIR /root

RUN git clone https://github.com/rapid7/metasploit-framework.git && \
	cd metasploit-framework && \
	gem install bundler && \
	bundle install && \
	ln -s $PWD/msf* /usr/bin/

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
	chown -R www-data:www-data /var/lib/nginx && \
	rm -rf /var/www/html/*

ADD files/certbot-auto /root/certbot-auto
RUN /root/certbot-auto --os-packages-only -n

ADD files/database.yml /root/metasploit-framework/config/
ADD files/setup.sh /root/setup.sh
ADD files/supervisord.conf /etc/supervisord.conf
ADD files/debug.keystore /root/debug.keystore
ADD files/resources/ /root/metasploit-framework/
ADD files/nginx.conf /etc/nginx/sites-available/default
ADD files/localhost.crt /etc/nginx/ssl/nginx.crt
ADD files/localhost.key /etc/nginx/ssl/nginx.key
ADD files/ssl.sh /root/ssl.sh

EXPOSE 80 443 3333 4433 4444 5555 6666 7777 8000 8080 8888 9999

CMD ["/bin/bash", "/root/setup.sh"]

