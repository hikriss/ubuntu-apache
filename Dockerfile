FROM ubuntu:16.04

VOLUME ["/var/www"]

RUN apt-get update && \
    apt-get install -y apache2
    
RUN mkdir -p /var/lock/apache2 /var/run/apache2    

ADD apache_default /etc/apache2/sites-enabled/000-default.conf
COPY run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

EXPOSE 80
CMD ["/usr/local/bin/run"]