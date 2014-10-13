#!/bin/bash

EXITO() {
printf "\033[1;32m${1}\033[0m\n"
}

#VARIABLES
DIR_APACHE=/var/www
FECHA=`date +%F-%Hh-%Mm-%Ss`
DIR_RESPALDOS=$HOME/respaldos/feng_$FECHA
BACKUP_DB=$DIR_RESPALDOS/db_fengoffice.sql
REPOSITORIO='http://sourceforge.net/projects/opengoo/files/fengoffice'

mkdir -p $DIR_RESPALDOS
echo "Introduzca el directorio de apache donde se encuentre el Feng Office que desee actualizar. Ejemplo1: fengoffice. Ejemplo2: fo_prueba."
read DIR_FENG

EXITO "Iniciando respaldo de los directorios de Feng Office"
sleep 1
cp -rv $DIR_APACHE/$DIR_FENG $DIR_RESPALDOS
EXITO "Respaldo finalizado"
sleep 1

EXITO "Iniciando respaldo de la base de datos"
echo "Por favor, ingrese el usuario de la base de datos"
read USERDB

echo "Por favor, ingrese el nombre de la base de datos"
read DB

echo "Por favor, ingrese la contraseña de la base de datos"
read PASSDB

echo `mysqldump -u $USERDB -p$PASSDB -d $DB > $BACKUP_DB`
EXITO "Base de datos respaldada en $BACKUP_DB"
sleep 1

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

EXITO "Copiando archivos de la nueva versión de Feng Office"
sleep 1
cp -rv /tmp/fengoffice/* $DIR_APACHE/$DIR_FENG

EXITO "Otorgando permisos a cache/ config/ tmp/ upload/"
echo "Ingrese la contraseña de super usuario"
sleep 1
su -c "
    chmod -R 777 $DIR_APACHE/$DIR_FENG/cache/
    chmod -R 777 $DIR_APACHE/$DIR_FENG/config/
    chmod -R 777 $DIR_APACHE/$DIR_FENG/tmp/
    chmod -R 777 $DIR_APACHE/$DIR_FENG/upload/
"

VERSION_FORM=`cat $DIR_APACHE/$DIR_FENG/version.php|grep return|cut -d \' -f2`
EXITO "Iniciando actualización de Feng Office desde la versión $VERSION_FROM a la versión $VERSION"
sleep 1
php $DIR_APACHE/$DIR_FENG/public/upgrade/console.php $VERSION_FROM $VERSION

rm $DIR_APACHE/$DIR_FENG/cache/autoloader.php
EXITO "Actualización culminada. Recuerde borrar la caché del navegador para evitar cualquier estático antiguo que quede presente."
