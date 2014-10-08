#!/bin/bash

EXITO() {
printf "\033[1;32m${1}\033[0m\n"
}

echo "Introduzca la versión a la que quiere actualizar"
read VERSION
EXITO "Ha seleccionado la version $VERSION"
sleep 1

mkdir -p /tmp/fengoffice/
cd /tmp/fengoffice/

EXITO "Descargando la version $VERSION"
wget -c http://sourceforge.net/projects/opengoo/files/fengoffice/fengoffice_$VERSION/fengoffice_$VERSION.zip

unzip fengoffice_$VERSION.zip
rm fengoffice_$VERSION.zip

EXITO "Iniciando respaldo de los directorios de Feng Office"
sleep 1
rsync -avzhP /var/www/fengoffice ~/respaldos/
EXITO "Respaldo finalizado"
sleep 1

EXITO "Iniciando respaldo de la base de datos"
mkdir -p ~/respaldos/fengoffice/

mysqldump fengoffice > ~/respaldos/fengoffice/fengoffice.sql
EXITO "Respaldo finalizado"
sleep 1

EXITO "Iniciando actualización de Feng Office a la versión $VERSION"
sleep 1
rsync -avzhP /tmp/fengoffice /var/www/

EXITO "Otorgando permisos a cache/ config/ tmp/ upload/"
sleep 1
cd /var/www/fengoffice/
chmod -R o+w cache/ config/ tmp/ upload/
EXITO "Actualización culminada"
