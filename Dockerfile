# Mapserver 6.2.0
FROM ubuntu:trusty

MAINTAINER Alberto Asuero <alberto.asuero@geographica.gs>

# Ensure the package repository is up to date
RUN apt-get update && apt-get -y build-dep mapserver \
&& apt-get -y install wget && mkdir -p /usr/local/src 

WORKDIR /usr/local/src
RUN wget http://download.osgeo.org/mapserver/mapserver-6.2.0.tar.gz && tar -xzf mapserver-6.2.0.tar.gz && cd mapserver-6.2.0 \
	&& ./configure           \
--prefix=/usr         \
--with-pdf            \
--with-freetype       \
--with-agg            \
--with-eppl           \
--with-proj           \
--with-threads        \
--with-sde            \
--with-geos           \
--with-ogr            \
--with-gdal           \
--with-tiff           \
--with-postgis        \
--with-mygis          \
--with-wfs            \
--with-wcs            \
--with-wmsclient      \
--with-wfsclient      \
--with-sos            \
--with-fribidi-config \
--with-gd && make && make install

# TODO: Improve using NGINX
RUN apt-get -y install apache2 && a2enmod cgi && echo "Mapserver 6.2.0" > /var/www/html/index.html
#WORKDIR /usr/local/src/mapserver-6.2.0


#ADD scripts /scripts
#RUN chmod +x /scripts/*

EXPOSE 80

CMD /bin/bash -c "source /etc/apache2/envvars  && /usr/sbin/apache2 -D FOREGROUND"
