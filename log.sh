#!/bin/bash

############################## Localización de la carpeta temporal

temp="/tmp/Undefined Project"
log="/home/`whoami`/.time/log"

############################ Crear carpeta de ubicación del logs

if [ ! -d "$log/`date +%Y`" ];then
	
	mkdir "$log/`date +%Y`"
	
fi

######################### Crear archivo log

if [ ! -f "$log/`date +%Y`/`date +%m-%Y`" ];then

	echo "\t\t   Fecha; Hora;   Usuario;    Acción" >> "$log/`date +%Y`/`date +%m-%Y`"
	echo "\t\t---------------;-----;----------------;-------------------------" >> "$log/`date +%Y`/`date +%m-%Y`"
fi

####################### Iniciando log

idcard=$( cut -d ";" -f 1 "$temp/sysadmin" )

user=$( mysql -uroot -proot -D 'proyecto' -e "
	select epersona.primer_nombre, epersona.primer_apellido 
	from epersona, admin 
	where epersona.CI=admin.CI and admin.CI=$idcard;" | sed -n 2p )

echo "\t\t`date +%a-%d-%b-%Y`;`date +%H:%M`;"$user";$1" >> "$log/`date +%Y`/`date +%m-%Y`"

