#!/bin/bash

EXITO() {
printf "\033[1;32m${1}\033[0m\n"
}

#VARIABLES
DIR_APACHE='/var/www'
DIR_RESPALDOS='$HOME/respaldos'
REPOSITORIO='http://sourceforge.net/projects/opengoo/files/fengoffice'

echo "Introduzca la versión a la que quiere actualizar. La última probada en este escript fue la 2.7.1.1"
read VERSION
EXITO "Ha seleccionado la versión $VERSION"
sleep 1

mkdir -p /tmp/fengoffice/
cd /tmp/fengoffice/

EXITO "Descargando la versión $VERSION"
wget -c $REPOSITORIO/fengoffice_$VERSION/fengoffice_$VERSION.zip

unzip fengoffice_$VERSION.zip
rm fengoffice_$VERSION.zip

EXITO "Iniciando respaldo de los directorios de Feng Office"
sleep 1
rsync -avzhP $DIR_APACHE/fengoffice $DIR_RESPALDOS
EXITO "Respaldo finalizado"
sleep 1

EXITO "Iniciando respaldo de la base de datos"
mkdir -p $DIR_RESPALDOS/fengoffice/

echo "Por favor, ingrese el usuario de la base de datos"
read USERDB

echo "Por favor, ingrese el nombre de la base de datos"
read DB

echo "Por favor, ingrese la contraseña de la base de datos"
read PASSDB

mysqldump -u $USERDB -p$PASSDB -d $DB > ~/respaldos/fengoffice/fengoffice.sql
EXITO "Base de datos respaldada en $DIR_RESPALDOS/fengoffice/fengoffice.sql"
sleep 1

EXITO "Iniciando actualización de Feng Office a la versión $VERSION"
sleep 1
rsync -avzhP /tmp/fengoffice $DIR_APACHE

EXITO "Otorgando permisos a cache/ config/ tmp/ upload/"
sleep 1
cd $DIR_APACHE/fengoffice/
chmod -R o+w cache/ config/ tmp/ upload/
EXITO "Actualización culminada"
