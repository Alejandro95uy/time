#!/bin/bash

#################### Localización de la carpeta temporal

temp="/tmp/Undefined Project/sbin"

##################### Función si es número

isnumeric(){
	
	echo "$1" > "$temp/number"
	alpha=$( grep "[[:alpha:]]" "$temp/number" )
	punct=$( grep "[[:punct:]]" "$temp/number" )
	blank=$( grep "[[:blank:]]" "$temp/number" )
	cntrl=$( grep "[[:cntrl:]]" "$temp/number" )
	
	if [ -z "$alpha" ] && [ -z "$punct" ] && [ -z "$blank" ] && [ -z "$cntrl" ];then
		rm "$temp/number"
		return 1
	fi
}

################ obtención de la cantidad de registros

	mysql -uroot -proot -D 'proyecto' -e "
	select count(ci) from tel_per where ci='$1';" > "$temp/qphone"
	qphone=$( sed -n 2p "$temp/qphone" )

################ Comienzo de la edición

loop=0
number=1
until [ $loop -eq $qphone ];do
	
	loop=$(( $loop + 1 ))
	number=$(( $number + 1 ))
		
	mysql -uroot -proot -D 'proyecto' -e "
	select telefono from tel_per where ci='$1';" > "$temp/phone"
	phone=$( sed -n $number\p "$temp/phone" )

	echo "\t\t\t--------------------------------------------------------------------------------"
	echo -n "\t\t\t Teléfono: $phone 			\t"; read -p "Nuevo teléfono: " newphone
	
	if [ -n "$newphone" ];then
		
		if [ ${#newphone} -ge 8 ] && [ ${#newphone} -le 9 ];then
			
			isnumeric "$newphone"
			
			if [ $? -eq 1 ];then
					
				mysql -uroot -proot -D 'proyecto' -e "
				update tel_per set telefono='$newphone' where ci='$1' and telefono='$phone';"
				
		echo "\t\t\t--------------------------------------------------------------------------------"
			
			else
				echo "\t\t\t\t Teléfono invalido"
		echo "\t\t\t--------------------------------------------------------------------------------"
			fi
			
		else
			echo "\t\t\t\t Teléfono invalido"
		echo "\t\t\t--------------------------------------------------------------------------------"
		fi
	fi
done

	echo "\t\t\t--------------------------------------------------------------------------------"

