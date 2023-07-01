#!/bin/bash

##################### Localizar carpeta principal y de archivos
files="/home/`whoami`/.time/backup"
location=$( cat "/tmp/location" )

blndb=0
until [ "$blndb" -eq 1 ];do
	
	clear
	sh "$location/desing/titles.sh" databases
	
	echo "
		\t┌─────────────┐  ┌───────────────┐  ┌───────────┐
		\t│ 1-Respaldar │  │  2-Restaurar  │  │  0-Atrás  │
		\t└─────────────┘  └───────────────┘  └───────────┘
	"
	echo -n "\t\t\t"; read -p "Elija una opción: " option
	
	case $option in 

#################### Respaldo de base de datos

	1)
		clear
		sh "$location/desing/titles.sh" databases
	
		echo "\n
		\t\t ┌───────────────────────┐
		\t\t │ Respaldando datos ... │
		\t\t └───────────────────────┘
		"
		
		mysqldump -uroot -proot -B 'proyecto' > "$files/`date +%d-%m-%Y`.sql"
		sleep 2
		
		clear
		sh "$location/desing/titles.sh" databases
	
		echo "\n
		\t\t ┌───────────────────────┐
		\t\t │ Datos respaldados ... │
		\t\t └───────────────────────┘
		"
		sh "$location/desing/wait.sh"
		
	;;

################# Restauración de base de datos
	
	2)
		clear
		sh "$location/desing/titles.sh" databases
	
		echo "\n
		\t\t ┌───────────────────────┐
		\t\t │ Restaurando datos ... │
		\t\t └───────────────────────┘
		"
		db=$( ls $files -lt | sed -n 2p | tr " " ";" | cut -d ";" -f 9 )
		
		mysql -uroot -proot -D 'proyecto' -e "drop database proyecto;"
		mysql -uroot -proot -e "create database proyecto;"
		mysql -uroot -proot -D 'proyecto' < "$files/$db"
		
		sleep 2
		
		clear
		sh "$location/desing/titles.sh" databases
	
		echo "\n
		\t\t ┌───────────────────────┐
		\t\t │ Datos restaurados ... │
		\t\t └───────────────────────┘
		"
		sh "$location/desing/wait.sh"
	
	;;
	
	0)
		blndb=1
	;;
	
	*)
		sh "$location/desing/message_box.sh" incorrect
	;;
	
	esac

done
