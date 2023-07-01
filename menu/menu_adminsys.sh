#!/bin/bash

#################### Localizar carpeta principal

location=$( cat "/tmp/location" )


blnsys=0
until [ "$blnsys" -eq 1 ];do
	
##################### Menú administrador
	
	clear
	sh "$location/desing/titles.sh" adminmenu
	
	sh "$location/desing/menu.sh" sysadmin
	
	echo -n "\t\t\t"; read -p "Elija una opción: " option
	
	case $option in 
	
		1)
			sh "$location/adminsys/sysadmin.sh"
		;;
	
		2)
			sh "$location/adminsys/databases.sh"
		;;
	
		3)
			sh "$location/adminsys/view_log.sh"
		;;
	
		0)
			blnsys=1
		;;
	
		*)
			sh "$location/desing/message_box.sh" incorrect
		;;
	esac
done

