#!/bin/bash

########################### Localización de la carpeta principal

location=$( cat "/tmp/location" )

###################### Logs

sh "$location/log.sh" "Inicio como administrador"

blnadmin=0
until [ $blnadmin -eq 1 ];do

######################## Menú Principal

	clear
	sh "$location/desing/titles.sh" mainmenu
	
	sh "$location/desing/menu.sh" adminmenu
	
	echo -n "\t\t\t"; read -p "Ingrese una opción: " option
	
	case $option in
		
		1)
			sh "$location/bin/add_functionary.sh" 0
		;;
		
		2)
			sh "$location/bin/edit_functionary.sh"
		;;
		
		3)
			sh "$location/bin/delete_functionary.sh"
		;;
		
		4)
			sh "$location/menu/load_data_menu.sh"
		;;
		
		5)
			sh "$location/bin/schedule.sh"
		;;
		
		6)
			sh "$location/bin/view_data.sh"
		;;
		
		7)
			sh "$location/menu/reports_menu.sh"
		;;
		
		8)
			sh "$location/menu/menu_adminsys.sh"
		;;
		
		0)
			blnadmin=1
			clear
		;;
		
		*)
			sh "$location/desing/message_box.sh" incorrect
		;;
	esac
done

