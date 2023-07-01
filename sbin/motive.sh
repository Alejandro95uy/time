#!/bin/bash

##################### Localizar carpeta principal y temporal
temp="/tmp/Undefined Project/bin"
location=$( cat "/tmp/location" )

####################### Función si es letra

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

#################### Función ingresar datos

entry(){

	echo -n "\t\t\t"; read -p "Motivo: " motive
		
	if [ -z "$motive" ];then
			
		blnmot=1
	else
		isletter "$motive"
		
		if [ $? -eq 1 ];then 
		
			countm=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(motivo) from motivo where motivo='$motive';" | sed -n 2p )
		
			if [ $countm -eq 0 ];then
		
				mysql -uroot -proot -D 'proyecto' -e "
				insert into motivo(motivo) values ('$motive');"
			else
				echo "\t\t\t\t Motivo ya ingresado"
				sh "$location/desing/wait.sh"
			fi
		else
			echo "\t\t\t\t Motivo incorrecto"
			sh "$location/desing/wait.sh"
		fi
	fi
}

######################### Comienzo ingreso de motivos

blnmot=0
until [ $blnmot -eq 1 ];do

	clear
	sh "$location/desing/titles.sh" motive

echo "\n\t     ( Para dejar de agregar motivos presione [Enter] al siguiente campo dejándolo vacío )"
echo "\t\t\t----------------------------------------------------------------------"

	count=$( mysql -uroot -proot -D 'proyecto' -e "
	select count(motivo) from motivo;" | sed -n 2p )
	
	if [ $count -ne 0 ];then
		
		for loop in `seq 1 $count` ;do
		
			loop=$(( $loop + 1 ))
		
			mot=$( mysql -uroot -proot -D 'proyecto' -e "
				select motivo as 'Motivos' from motivo;" | sed -n $loop\p )
			
			line=""
				for i in `seq 1 ${#mot}` ;do
				
					line="$line─"
				
				done
				
				
			echo "\t\t\t\t┌─$line─┐"
			echo "\t\t\t\t│ $mot │"
			echo "\t\t\t\t└─$line─┘"
		done
		
		entry
		
	else
		entry
	fi
	
done

