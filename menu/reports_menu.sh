#!/bin/bash

################################## Localización de la carpeta prinicpal
location=$( cat "/tmp/location" )


blnrep=0
until [ "$blnrep" -eq 1 ];do

######################## Menú de informes

	clear
	sh "$location/desing/titles.sh" reports
	
	sh "$location/desing/menu.sh" reports
	
	echo -n "\t\t\t\t"; read -p "Ingrese una opción: " option
	
	case $option in
		
		1)
			sh "$location/report/report_motive.sh"
		;;	
	
		2)
			sh "$location/report/turn_report.sh"
		;;
		
		3)
			sh "$location/report/report_person.sh"
		;;
		
		4)
			sh "$location/report/weekly_report.sh"
		;;
	
		0)	
			blnrep=1
		;;
		
		*)
			sh "$location/desing/message_box.sh" incorrect
		;;
	
	esac
done

