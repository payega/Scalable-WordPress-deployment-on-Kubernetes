FROM wordpress:4.7.5-php7.1-apache

#Domain tiene el nombre del dominio que se corresponde con el nombre de certificados
#tendremos una imagen diferente por entorno porque cada uno tiene su certificados
ARG DOMAIN
ENV DOMAIN $DOMAIN

#Esta variable especifica el puerto de servicio para kubernetes para poder hacer el redirect en 000-default.conf
ENV SSL_REDIRECT localhost:443

#Copiamos los ficheros de configurasion de apache para SSL preconstruidos con nombre de variable de entorno
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY ssl-params.conf /etc/apache2/conf-available/ssl-params.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# La toolchain copiara los certificados del domino al directorio de certificados
RUN mkdir /var/certs
COPY ${DOMAIN}.crt /var/certs/${DOMAIN}.crt
COPY $DOMAIN.key /var/certs/$DOMAIN.crt

# Altamira necesita upload_max_filesize = 8M
COPY user.ini /usr/src/wordpress/.user.ini

#Hacemos que el directorio sea un volumen para simplificar el cambio de certificados
VOLUME /var/certs

# Reconfiguramos apache2
RUN a2enmod ssl
RUN a2enmod headers
RUN a2ensite default-ssl
RUN a2enconf ssl-params

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]