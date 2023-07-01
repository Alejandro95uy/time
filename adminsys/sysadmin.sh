#!/bin/bash

########################### Localización de la carpeta principal

location=$( cat "/tmp/location" )

########################## Comienza la opción adminsys

blnsys=0
until [ $blnsys -eq 1 ];do

	clear
	sh "$location/desing/titles.sh" sysadmin
	
		echo " 
		\t┌───────────┐  ┌──────────┐  ┌──────────┐ ┌─────────┐
		\t│ 1-Agregar │  │ 2-Borrar │  │ 3-Listar │ │ 0-Atrás │
		\t└───────────┘  └──────────┘  └──────────┘ └─────────┘
		"
echo -n "\t\t\t"; read -p "Elija una opción: " option

case $option in 

########################## Agregar Administrador del sistema

1)
	clear
	sh "$location/desing/titles.sh" sysadmin
	echo -n "\t\t\t"; read -p "Ingrese la Cédula de Identidad: " idcard
	
	countid=$( mysql -uroot -proot -D 'proyecto' -e "
	select count(CI) from admin where CI='$idcard';" | sed -n 2p )
	
	countno=$( mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from no_docente where cargo='Administrador' or cargo='Dirección' and CI='$idcard';" | sed -n 2p )
	
	if [ $countid -eq 0 ];then
	
		if [ $countno -eq 1 ];then
		
			mysql -uroot -proot -D 'proyecto' -e "
			update no_docente set permiso='1' where CI='$idcard' and permiso='0';"
			
			echo "\n\t\t\t\t Agregado con éxito"
			sh "$location/desing/wait.sh"
					
########################################## log

	sh "$location/log.sh" "Agregó Administrador"
		
		else
	
			echo "\n\t\t\t\t No puede ser administrador"
			sh "$location/desing/wait.sh"
	
		fi
		
	else
	
		echo "\n\t\t\t\t Ya es un administrador"
		sh "$location/desing/wait.sh"
	
	fi
	
;;

########################### Borrar Administrador del Sistema

2)
	clear
	sh "$location/desing/titles.sh" sysadmin
	echo -n "\t\t\t"; read -p "Ingrese la Cédula de Identidad: " idcard
	
	countid=$( mysql -uroot -proot -D 'proyecto' -e "
	select count(CI) from admin where CI='$idcard';" | sed -n 2p )
	
	
	if [ $countid -eq 1 ];then
	
		mysql -uroot -proot -D 'proyecto' -e "
		update no_docente set permiso='0' where CI='$idcard' and permiso='1';"
		
		echo "\t\t\t\t Eliminado con éxito"
		sh "$location/desing/wait.sh"
					
########################################## log

	sh "$location/log.sh" "Eliminó Administrador"
		
	else
	
		echo "\t\t\t\t No es un administrador"
		sh "$location/desing/wait.sh"
	
	fi
;;

########################## Listar administrador del sistema

3)
	clear
	sh "$location/desing/titles.sh" sysadmin
	
	mysql -uroot -proot -D 'proyecto' -e "
	select CI as 'Cédula de Identidad', primer_nombre as 'Primer Nombre', 
	segundo_nombre as 'Segundo Nombre', primer_apellido as 'Primer Apellido', 
	segundo_apellido as 'Segundo Apellido', cargo as 'Cargo' from admin;"
	
	sh "$location/desing/wait.sh"
					
########################################## log

	sh "$location/log.sh" "Listó Administrador"
;;

####################### Salir

0)
	blnsys=1
;;

##################### Opción incorrecta

*)
	sh "$location/desing/message_box.sh" incorrect
;;

esac
done

