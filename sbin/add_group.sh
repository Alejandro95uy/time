#!/bin/bash

#################### localización de la carpeta temporal y principal

temp="/tmp/Undefined Project/sbin"
location=$( cat "/tmp/location" )

	clear
	
	sh "$location/desing/titles.sh" addgro
	sh "$location/desing/menu.sh" course
	
	echo -n "\t\t\t"; read -p "Elija un curso: " course
	case $course in

###################### Ingresando grupo del curso Ciclo Básico Tecnológico
	
	1)
		clear
		sh "$location/desing/titles.sh" addgro
		echo "
		\t\t\t    ╔════════════════════════════╗
		\t\t\t    ║  Ciclo Básico Tecnológico  ║
		\t\t\t    ╚════════════════════════════╝
		\n\t\t( Para dejar de agregar grupos presione [Enter] al siguiente campo dejándolo vacío )"
	
	blncbt=0
	until [ $blncbt -eq 1 ];do
		
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group
		
		if [ -n "$group" ];then
		
			grocount=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(ID_grupo) from grupo where nombre_grupo='$group'" | sed -n 2p  )
			
			if [ $grocount -eq 0 ];then

				mysql -uroot -proot -D 'proyecto' -e "
				insert into grupo(grado,nombre_grupo) values ('Ciclo Básico Tecnológico','$group');"
			
			else
				echo "\t\t\t\t\t Grupo ya ingresado"
			fi
			
		elif [ -z "$group" ];then
		
			blncbt=1
		
		fi
	done
	;;

###################### Ingresando grupo del curso Formación Profesional Básica
		
	2)
		clear
		sh "$location/desing/titles.sh" addgro
		echo "
		\t\t\t    ╔════════════════════════════════╗
		\t\t\t    ║  Formación Profesional Básica  ║
		\t\t\t    ╚════════════════════════════════╝
		\n\t\t( Para dejar de agregar grupos presione [Enter] al siguiente campo dejándolo vacío )"
	
	blnfpb=0
	until [ "$blnfpb" -eq 1 ];do
	
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group
		
		if [ -n "$group" ];then

			grocount=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(ID_grupo) from grupo where nombre_grupo='$group'" | sed -n 2p )
			
			if [ $grocount -eq 0 ];then

				mysql -uroot -proot -D 'proyecto' -e "
				insert into grupo(grado,nombre_grupo) values ('Formación Profesional Básica','$group');"
			else
				echo "\t\t\t\t\t Grupo ya ingresado"
			fi
			
		elif [ -z "$group" ];then
		
			blnfpb=1
			
		fi
	done
	;;

###################### Ingresando grupo del curso Educación Media Profesional
		
	3)
		clear
		sh "$location/desing/titles.sh" addgro
		echo "
		\t\t\t    ╔═══════════════════════════════╗
		\t\t\t    ║  Educación Media Profesional  ║
		\t\t\t    ╚═══════════════════════════════╝
		\n\t\t( Para dejar de agregar grupos presione [Enter] al siguiente campo dejándolo vacío )"
	
	blnemp=0
	until [ $blnemp -eq 1 ];do
	
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group
		
		if [ -n "$group" ];then
		
			grocount=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(ID_grupo) from grupo where nombre_grupo='$group'" | sed -n 2p )
			
			if [ $grocount -eq 0 ];then

				mysql -uroot -proot -D 'proyecto' -e "
				insert into grupo(grado,nombre_grupo) values ('Educación Media Profesional','$group');"
			
			else
				echo "\t\t\t\t\t Grupo ya ingresado"
			fi
			
		elif [ -z "$group" ];then
			
			blnemp=1
			
		fi
	done
	;;

###################### Ingresando grupo del curso Educación Media tecnológica
	
	4)
		clear
		sh "$location/desing/titles.sh" addgro
		echo "
		\t\t\t    ╔═══════════════════════════════╗
		\t\t\t    ║  Educación Media tecnológica  ║
		\t\t\t    ╚═══════════════════════════════╝
		\n\t\t( Para dejar de agregar grupos presione [Enter] al siguiente campo dejándolo vacío )"
	
	blnemt=0
	until [ $blnemt -eq 1 ];do
	
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group
		
		if [ -n "$group" ];then

			grocount=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(ID_grupo) from grupo where nombre_grupo='$group'" | sed -n 2p  )
			
			if [ $grocount -eq 0 ];then

				mysql -uroot -proot -D 'proyecto' -e "
				insert into grupo(grado,nombre_grupo) values ('Educación Media Tecnológica','$group');"
			else
				echo "\t\t\t\t\t Grupo ya ingresado"
			fi
		
		elif [ -z "$group" ];then
			
			blnemt=1
			
		fi
	done
	;;

###################### Ingresando grupo del curso Bachillerato Profesional 
		
	5)
		clear
		sh "$location/desing/titles.sh" addgro
		echo "
		\t\t\t    ╔════════════════════════════╗
		\t\t\t    ║  Bachillerato Profesional  ║
		\t\t\t    ╚════════════════════════════╝
		\n\t\t( Para dejar de agregar grupos presione [Enter] al siguiente campo dejándolo vacío )"
	
	blnbp=0
	until [ $blnbp -eq 1 ];do
	
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group
		
		if [ -n "$group" ];then
		
			grocount=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(ID_grupo) from grupo where nombre_grupo='$group'" | sed -n 2p )
			
			if [ $grocount -eq 0 ];then

				mysql -uroot -proot -D 'proyecto' -e "
				insert into grupo(grado,nombre_grupo) values ('Bachillerato Profesional','$group');"
			
			else
				echo "\t\t\t\t\t Grupo ya ingresado"
			fi
		
		elif [ -z "$group" ];then
		
			blnbp=1
		
		fi
	done
	;;

###################### Ingresando grupo del curso Capacitaciones
		
	6)
		clear
		sh "$location/desing/titles.sh" addgro
		echo "
		\t\t\t\t    ╔══════════════════╗
		\t\t\t\t    ║  Capacitaciones  ║
		\t\t\t\t    ╚══════════════════╝
		\n\t\t( Para dejar de agregar grupos presione [Enter] al siguiente campo dejándolo vacío )"
	
	blnctt=0
	until [ $blnctt -eq 1 ];do
	
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group
		
		if [ -n "$group" ];then

			grocount=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(ID_grupo) from grupo where nombre_grupo='$group'" |  sed -n 2p )
			
			if [ $grocount -eq 0 ];then

				mysql -uroot -proot -D 'proyecto' -e "
				insert into grupo(grado,nombre_grupo) values ('Capacitaciones','$group');"
			
			else
				echo "\t\t\t\t\t Grupo ya ingresado"
			fi
		
		elif [ -z "$group" ];then
			
			blnctt=1
			
		fi
	done
	;;
	
	*)
	 	sh "$location/desing/message_box.sh" incorrect
	;;
	
	esac
					
########################################## log

		sh "$location/log.sh" "Agregó Grupo"
		

