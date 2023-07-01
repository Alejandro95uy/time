#!/bin/bash

################## localización de la carpeta principal y temporal

location=$( cat "/tmp/location" )
temp="/tmp/Undefined Project/bin"

################ función si es letra

isletter(){
	
	echo "$1" > "$temp/letter"
	digit=$( grep "[[:digit:]]" "$temp/letter" )
	punct=$( grep "[[:punct:]]" "$temp/letter" )
	cntrl=$( grep "[[:cntrl:]]" "$temp/letter" )

	if [ -z "$digit" ] && [ -z "$punct" ] && [ -z "$cntrl" ];then
		rm "$temp/letter"
		return 1
	fi
}


#################### Agregar Asignaturas 

	clear
	
	sh "$location/desing/titles.sh" addsub
	
	echo "\t\t\t( Para dejar de agregar asignaturas presione [Enter] al siguiente campo dejándolo vacío )"

	blnsub=0
	until [ $blnsub -eq 1 ];do
		
		echo "\t\t\t-----------------------------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "Materia: " subjects
		
		if [ -n "$subjects" ];then
		
			isletter "$subjects"
			
			if [ $? -eq 1 ];then

				subcount=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(ID_materia) from materia where materia='$subjects';" | sed -n 2p ) 
				
				if [ $subcount -eq 0  ];then

					mysql -uroot -proot -D 'proyecto' -e "
					insert into materia (materia) values ('$subjects');"
	
				else
					echo "\t\t\t\t\t Asignatura ya ingresada"
				fi
			
			else
				echo "\t\t\t\t\t Solo se permite escribir con letra la Asignatura"
			fi
		
		elif [ -z "$subjects" ];then
		
			blnsub=1
		fi
	done
					
########################################## log

sh "$location/log.sh" "Agregó Asignaturas"

