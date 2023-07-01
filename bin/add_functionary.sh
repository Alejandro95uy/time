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

######################## Función si es dirección

isaddress(){
	
	echo "$1" > "$temp/address"
	cntrl=$( grep "[[:cntrl:]]" "$temp/address" )
	punct=$( grep "[[:punct:]]" "$temp/address" )
	
	if [ -z "$punct" ] && [ -z "$cntrl" ];then
		rm "$temp/address"
		return 1
	fi
}

######################## Comienzo el agregar funcionario

blnaddfun=0
until [ $blnaddfun -eq 1 ];do
	
	if [ $1 -eq 1 ];then
		
		clear
		sh "$location/desing/titles.sh" config
		sh "$location/desing/titles.sh" sysadmin
	
	else
		clear
		sh "$location/desing/titles.sh" addfun
	fi
	
###################### Inicio del formulario	
	
	echo "\t\t\t\t\t\t(* Campos Requeridos) \n"
	echo "\t\t\t (La cédula de identidad ingréselo sin puntos ni guiones )"
	echo "\t\t\t----------------------------------------------------------------------"
	echo -n "\t\t\t"; read -p "*Cédula de identidad: " idcard
	
		if [ ${#idcard} -eq 8 ];then

			isnumeric "$idcard"
			
			if [ $? -eq 1 ];then 
					 
				sidcard=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from persona where CI=$idcard;" | sed -n 2p )

				if [ "$sidcard" -eq 0 ];then
					
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "*Primer nombre: " name1
			
			if [ -n "$name1" ];then
				
				isletter "$name1"
			
			if [ "$?" -eq 1 ];then
			
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p " Segundo nombre: " name2
				
				isletter $name2
				
			if [ "$?" -eq 1 ];then
				
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "*Primer apellido: " surname1
				
			if [ -n "$surname1" ];then
					
				isletter "$surname1"
						
			if [ $? -eq 1 ];then
				
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "*Segundo apellido: " surname2
							
			if [ -n "$surname2" ];then
							
				isletter "$surname2"
							
			if [ $? -eq 1 ];then
		
		echo "\t\t\t----------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "*Dirección: " address
		echo "\t\t\t----------------------------------------------------------------------"
				
			if [ -n "$address" ];then
				
				isaddress "$address"
	
			if [ $? -eq 1 ];then

###################### Impactar en la base de datos
				
			mysql -uroot -proot -D 'proyecto' -e "
			insert into persona(CI,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,direccion) 
			values ($idcard,'$name1','$name2','$surname1','$surname2','$address');"
		
			sh "$location/sbin/add_phone.sh" $idcard 1
			
################ En caso de ser el primer usuario se impacta en la base de datos como director 

		if [ $1 -eq 1 ];then
				
			mysql -uroot -proot -D 'proyecto' -e "
			insert into no_docente(CI,cargo,permiso) values ($idcard,'Dirección',1);"
		else
		
###################### Log

		sh "$location/log.sh" "Agregó Funcionario"
		
######################## Se elije el tipo de funcionario

			echo " 
			\t┌───────────┐  ┌──────────────┐
			\t│ 1-Docente │  │ 2-No Docente │
			\t└───────────┘  └──────────────┘
			"
			blnchoice=0
			until [ $blnchoice -eq 1 ];do
			
			echo -n "\t\t\t"; read -p "Elija una opción: " option
			case $option in 
				
				1)
					sh "$location/sbin/teaching.sh" $idcard 0
					blnchoice=1
				;;
		
				2)
					sh "$location/sbin/non-teaching.sh" $idcard
					blnchoice=1
				;;
		
				*)
					echo "\t\t\t\t\t\t Error opción incorrecta"
				;;
			esac
			done
		fi
		
########################## Final del agregar funcionario

				echo "\n\t\t\t\t Agregado exitoso \n"
				sh "$location/desing/wait.sh"
				blnaddfun=1
				
############################## Dirección
				else
				 	echo "\t\t\t\t\t\t Dirección invalida"
					sh "$location/desing/wait.sh"
				fi
				
				else
					echo "\t\t\t\t\t\t Campo requerido"
					sh "$location/desing/wait.sh"
				fi
####################################### Segundo apellido		
				else
					echo "\t\t\t\t\t\t Apellido inválido"
					sh "$location/desing/wait.sh"
				fi
							
				else
					echo "\t\t\t\t\t\t Campo requerido"
					sh "$location/desing/wait.sh"
				fi
################################## Primer apellido
				else
					echo "\t\t\t\t\t\t Apellido inválido"
					sh "$location/desing/wait.sh"
				fi
				
				else
					echo "\t\t\t\t\t\t Campo requerido"
					sh "$location/desing/wait.sh"
				fi
###################################### Segundo nombre
				else
					echo "\t\t\t\t\t\t Nombre inválido"
					sh "$location/desing/wait.sh"
				fi
######################################## Primer nombre
				else
					echo "\t\t\t\t\t\t Nombre inválido"
					sh "$location/desing/wait.sh"
				fi
				else
					echo "\t\t\t\t\t\t Campo requerido"
					sh "$location/desing/wait.sh"
				fi
############################################# Control de cedula de identidad

				else
				
				eidcard=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from epersona where CI=$idcard;" | sed -n 2p )	
				
				neidcard=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from nepersona where CI=$idcard;" | sed -n 2p )			
					
					if [ $eidcard -eq 1 ];then
					
						echo "\t\t\t\t\t\t Cédula de identidad existente"
						sh "$location/desing/wait.sh"
				
################################# Cédula de identidad
					
					elif [ $neidcard -eq 1 ];then
					
						sh "$location/sbin/add_non-existent.sh" "$idcard"
						
					else
						
						sh "$location/desing/message_box.sh"
					
					fi
					
						blnaddfun=1
				fi
			else
				echo "\t\t\t\t\t\t Cédula de identidad inválida"
				sh "$location/desing/wait.sh"
			fi
		else
			echo "\t\t\t\t\t\t Cédula de identidad inválida"
			sh "$location/desing/wait.sh"
		fi
done
############# Fin del shell 
