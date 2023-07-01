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

	
##################### Borrar Asignaturas
	
	clear
	sh "$location/desing/titles.sh" delsub
	echo -n "\t\t\t"; read -p "Materia: " subjects
		
		isletter "$subjects"
		
		if [ $? -eq 1 ];then

			subcount=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(ID_materia) from materia where materia='$subjects';" | sed -n 2p ) 
				
			if [ $subcount -eq 1 ];then
					
				idsub=$( mysql -uroot -proot -D 'proyecto' -e "
				select ID_materia from materia where materia='$subjects';" | sed -n 2p )
				
				mysql -uroot -proot -D 'proyecto' -e "
				delete from horarios_docente where ID_materia=$idsub;"
				
				mysql -uroot -proot -D 'proyecto' -e "
				delete from componen where ID_materia=$idsub;"
				
				mysql -uroot -proot -D 'proyecto' -e "
				delete from dictan where ID_materia=$idsub;"
				
				mysql -uroot -proot -D 'proyecto' -e "
				delete from materia where materia='$subjects';"
				
				echo "\t\t\t Asignatura eliminada"
				sh "$location/desing/wait.sh"
					
			else
				echo "\t\t\t\t\t Asignatura ya eliminada"
				sh "$location/desing/wait.sh"
				
			fi
		else
			echo "\t\t\t\t\t Solo se permite escribir con letra la Asignatura"
			sh "$location/desing/wait.sh"
		fi
					
########################################## log

		sh "$location/log.sh" "Borró Asignatura"
	
