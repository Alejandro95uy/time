#!/bin/bash

############################## Localizar carpeta temporal

temp="/tmp/Undefined Project/sbin"

############################ Función es número

isnumeric(){
	
	echo "$1" > "$temp/phone"
	alpha=$( grep "[[:alpha:]]" "$temp/phone" )
	punct=$( grep "[[:punct:]]" "$temp/phone" )
	cntrl=$( grep "[[:cntrl:]]" "$temp/phone" )
	blank=$( grep "[[:blank:]]" "$temp/phone" )
	
	if [ -z "$alpha" ] && [ -z "$punct" ] && [ -z "$cntrl" ] && [ -z "$blank" ];then
		rm "$temp/phone"
		return 1
	fi
}

echo "\n\t\t( Para dejar de agregar teléfonos presione [Enter] al siguiente campo dejándolo vacío )"

####################### Ingreso de teléfonos

blnphone=0
until [ $blnphone -eq 1 ];do
	
	echo "\t\t\t----------------------------------------------------------------------"
	echo -n "\t\t\t"; read -p " Teléfono: " phone
	
	if [ -n "$phone" ];then
		
		if [ ${#phone} -ge 8 ] && [ ${#phone} -le 9 ];then
			
			isnumeric $phone
			
			if [ $? -eq 1 ];then
					
				sphone=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(telefono) from tel_per 
				where ci=$1 and telefono='$phone'" | sed -n 2p )
		
				if [ $sphone -eq 0 ];then
						
					mysql -uroot -proot -D 'proyecto' -e "
					insert into tel_per(ci,telefono) value ($1,$phone);"
				else
					echo "\t\t\t\t\t Error ya esta ingresado"
				fi
			else
				echo "\t\t\t\t\t Teléfono inválido"
			fi
		else
			echo "\t\t\t\t\t Teléfono inválido"
		fi
			
################################# Dejar de ingresar

	elif [ -z "$phone" ];then
		
		if [ $2 -eq 1 ];then	
			
			cphone=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(CI) from tel_per where CI=$1;" | sed -n 2p )
			
			if [ $cphone -ne 0 ];then
		
		echo "\t\t\t----------------------------------------------------------------------"
				
				blnphone=1
			
			else
				
				echo "\t\t\t\t\t Debes ingresar al menos un teléfono"
			
			fi
		else
		
		echo "\t\t\t----------------------------------------------------------------------"
			
			blnphone=1
		fi
	fi
done

