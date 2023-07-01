#!/bin/bash

################################## localizar carpeta del programa y tempral

location=$( cat "/tmp/location" )
temp="/tmp/Undefined Project"


blnmain=0
until [ $blnmain -eq 1 ];do
	
##################### Login
	
	clear
	sh "$location/desing/titles.sh" login1
	echo "\t\t----------------------------------------------------------------------"
	echo -n "\t\t\t"; read -p "Cédula de identidad: " user
	echo "\t\t----------------------------------------------------------------------"
	
	validuser=$( mysql -uroot -proot -D 'proyecto' -e "
	select epersona.CI from epersona, no_docente 
	where epersona.CI=no_docente.CI and no_docente.CI=$user and no_docente.permiso=1;" | sed -n 2p )
	
	if [ "$user" -eq "$validuser" ];then
	
		stty -echo
		echo -n "\t\t\t"; read -p "Verificación Cédula de identidad: " password
		echo
		stty echo
		echo "\t\t----------------------------------------------------------------------"
	
		mysql -uroot -proot -D 'proyecto' -e "
		select * from no_docente where CI=$user;" | sed -n 2p | tr "\t" ";" > "$temp/sysadmin"
	
		idcard=$( cut -d ";" -f 1 "$temp/sysadmin" )
		position=$( cut -d ";" -f 2 "$temp/sysadmin" )
		permission=$( cut -d ";" -f 3 "$temp/sysadmin" )

############################### confirmando y distingiendo el usuario ingresado
	
		if [ "$user" -eq "$idcard" ] && [ "$password" -eq "$idcard" ];then
		
			if [ "$permission" -eq 1 ];then
		
				if [ $position = "Dirección" ];then
					
					sh "$location/menu/menu_admin.sh"
					blnmain=1
	
				elif [ $position = "Administrador" ];then
					
					sh "$location/menu/menu_user.sh"
					blnmain=1
	
				else
					sh "$location/desing/message_box.sh" invalid
		
				fi
			fi
		else
			sh "$location/desing/message_box.sh" invalid
			
		fi
	
	else
		sh "$location/desing/message_box.sh" invalid
	fi
done

