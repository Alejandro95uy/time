#!/bin/bash

################## localización de la carpeta principal y temporal

location=$( cat "/tmp/location" )
temp="/tmp/Undefined Project/bin"


blnload=0
until [ $blnload -eq 1 ];do

############# menú cargar datos

	clear
	sh "$location/desing/titles.sh" loaddata
	
	sh "$location/desing/menu.sh" loaddata
	
	echo -n "\t\t\t"; read -p "Ingrese una opción: " option

	case $option in 
	
################ ingresar materias
	
		1)
			sh "$location/sbin/add_subjects.sh"
		;;

################### eliminar materia

		2)
			sh "$location/sbin/del_subjects.sh"
		;;
		
#################### listar materias
	
		3)
		
			clear
			sh "$location/desing/titles.sh" listsub
			mysql -uroot -proot -D 'proyecto' -e "
			select ID_materia as 'Identificador', materia as 'Nombre de La Materia' from materia order by materia;"
			sh "$location/desing/wait.sh"
					
########################################## log

		sh "$location/log.sh" "Listo Asignaturas"
		
		;;
	
##################### agregar grupos 
	
		4)
			sh "$location/sbin/add_group.sh"
		;;
	
##################### borrar grupos
	
		5)
			sh "$location/sbin/del_group.sh"
		;;
	
################## listar grupos
	
		6)
			clear
			sh "$location/desing/titles.sh" listgro
			mysql -uroot -proot -D 'proyecto' -e "
			select ID_grupo as 'Identificador', grado as 'Curso', nombre_grupo as 'Nombre del Grupo' 
			from grupo order by grado,nombre_grupo;"
			sh "$location/desing/wait.sh"
					
########################################## log

		sh "$location/log.sh" "Listó Grupo"
		
		;;
		
########################## ingreso de motivo
		
		7)
			sh "$location/sbin/motive.sh"
		;;
################## salir
	
		0)
			blnload=1
		;;

################# opción incorrecta

		*)
			sh "$location/desing/message_box.sh" incorrect
		;;
		esac
done

