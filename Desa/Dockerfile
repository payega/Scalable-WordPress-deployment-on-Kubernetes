FROM wordpress:4.7.5-php7.1-apache

#Copiamos los ficheros de configurasion de apache para SSL preconstruidos con nombre de variable de entorno
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY ssl-params.conf /etc/apache2/conf-available/ssl-params.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

#Copiamos los certificados
COPY altamira.crt /tmp/altamira.crt
COPY altamira.key /tmp/altamira.key

# Altamira necesita upload_max_filesize = 8M
COPY user.ini /usr/src/wordpress/.user.ini

# Reconfiguramos apache2
RUN a2enmod ssl
RUN a2enmod headers
RUN a2ensite default-ssl
RUN a2enconf ssl-params

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
