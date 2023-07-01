#!/bin/bash

########################### Localiza la carpeta principal

location=$( cat "/tmp/location" )

blnview=0
until [ $blnview -eq 1 ];do
	clear
	sh "$location/desing/titles.sh" listfun
	echo " 
		\t\t┌───────────┐  ┌──────────────┐  ┌─────────┐
		\t\t│ 1-Docente │  │ 2-No Docente │  │ 0-Atrás │
		\t\t└───────────┘  └──────────────┘  └─────────┘
		"
	echo -n "\t\t\t"; read -p "Elija una opción: " option
	
	case $option in 
	
################################ Lista docente
	
	1)
		clear
		sh "$location/desing/titles.sh" teaching
		mysql -uroot -proot -D 'proyecto' -e "
		select epersona.CI as 'Cédula de Identidad', primer_nombre as 'Primer Nombre', 
		segundo_nombre as 'Segundo Nombre',primer_apellido as 'Primer Apellido',
		segundo_apellido as 'Segundo Apellido', docente.caracter as 'Carácter'
		from epersona, docente 
		where epersona.CI=docente.CI
		order by epersona.primer_nombre, primer_apellido, segundo_apellido, docente.caracter;"
		
		sh "$location/desing/wait.sh"
		
########################################## log

	sh "$location/log.sh" "Listó Funcionarios"
	
	;;
	
####################### Lista no docente

	2)
		clear
		sh "$location/desing/titles.sh" functionary
		mysql -uroot -proot -D 'proyecto' -e "
		select epersona.CI as 'Cédula de Identidad', primer_nombre as 'Primer Nombre', 
		segundo_nombre as 'Segundo Nombre', primer_apellido as 'Primer Apellido', 
		segundo_apellido as 'Segundo Apellido', no_docente.cargo as 'Cargo' 
		from epersona, no_docente 
		where epersona.CI=no_docente.CI
		order by epersona.primer_nombre, primer_apellido, segundo_apellido, no_docente.cargo;"
				
		sh "$location/desing/wait.sh"
					
########################################## log

	sh "$location/log.sh" "Listó Funcionarios"
	
	;;

##################### Salir

	0)
		blnview=1
	;;
	
#################### Opción incorrecta
	
	*)
		sh "$location/desing/message_box.sh" incorrect
	;;
	esac
done

