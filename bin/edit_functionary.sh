#!/bin/bash

###################### localización de la carpeta temporal y principal

temp="/tmp/Undefined Project/bin"
location=$( cat "/tmp/location" )

#################### función si es letra

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

################## función si es numero

isaddress(){
	
	echo "$1" > "$temp/address"
	cntrl=$( grep "[[:cntrl:]]" "$temp/address" )
	punct=$( grep "[[:punct:]]" "$temp/address" )
	
	if [ -z "$punct" ] && [ -z "$cntrl" ];then
		rm "$temp/address"
		return 1
	fi
}

################## ejecución del search (busca funcionario)

	sh "$location/sbin/search.sh"
	idcard=$( cat "/tmp/Undefined Project/sidcard" )
	
################ Extracción de datos del funcionario buscada

	mysql -uroot -proot -D 'proyecto' -e "
	select * from epersona where CI='$idcard';" | sed -n 2p | tr "\t" ";" > "$temp/person"
	
	   name1=$( cut -d ";" -f 2 "$temp/person" )
	   name2=$( cut -d ";" -f 3 "$temp/person" )
	surname1=$( cut -d ";" -f 4 "$temp/person" )
	surname2=$( cut -d ";" -f 5 "$temp/person" )
	 address=$( cut -d ";" -f 6 "$temp/person" )
	 rm "$temp/person"

blnedit=0
until [ $blnedit -eq 1 ];do
	
	clear
	sh "$location/desing/titles.sh" editfun
	 
################# Presentación de los datos del funcionario encontrado

		echo "
	 	\t\t                ╔══════════════════╗
	 	\t\t                ║ Datos Personales ║
	 	\t\t╔═════════════════════════════════════════════════════════╗
	 	\t\t                                                                 
	 	\t\t        Cédula de identidad: $idcard	
	 	\t\t ---------------------------------------------------------
	 	\t\t        Primer nombre: $name1
	 	\t\t ---------------------------------------------------------
	 	\t\t        Segundo nombre: $name2
	 	\t\t ---------------------------------------------------------
	 	\t\t        Primer apellido: $surname1
	 	\t\t ---------------------------------------------------------
	 	\t\t        Segundo apellido: $surname2	
	 	\t\t ---------------------------------------------------------
		\t\t                                                        
		\t\t╚═════════════════════════════════════════════════════════╝\n"
		echo "\t\t\t\t ¿Es el funcionario que va a modificar?"
		echo "\t\t\t\t  (Responda con S(si) o N(no))"
		echo -n "\t\t\t\t"; read -p "Respuesta: " answer 
	
################# confirmación de la edición
	
	if [ -z "$answer" ];then
	 	
	 	sh "$location/desing/message_box.sh" incorrect
	else
	
	if [ $answer = "s" ] || [ $answer = "S" ];then
	
		clear
		sh "$location/desing/titles.sh" editfun
		
		echo "
		\t\t\t    ╔═══════════════════════════════╗
		\t\t\t    ║ Cédula de identidad: $idcard ║
		\t\t\t    ╚═══════════════════════════════╝
		\t--------------------------------------------------------------------------------
		\t\t\t\t    Datos Personales
		\t--------------------------------------------------------------------------------\n"
		
		echo "\t\t\t (En caso de no querer modificar los campos siguiente, déjelo en blanco que no serán modificados )"
		echo "\t\t\t--------------------------------------------------------------------------------"
		
	#echo -n "\t\t\t Cédula de identidad: $idcard	\t"; read -p "Nueva cédula de identidad: " newidcard
		 
	echo -n "\t\t\t Primer nombre: $name1 		\t"; read -p "Nuevo primer nombre: " newname1
		echo "\t\t\t--------------------------------------------------------------------------------"
		
		if [ -n "$newname1" ];then
			
			blnedit=1
			
			isletter "$newname1"
			
			if  [ $? -eq 1 ];then
				
				mysql -uroot -proot -D 'proyecto' -e "
				update persona set primer_nombre='$newname1' where CI='$idcard';"
			else 
				echo "\t\t\t\t Nombre invalido"
			fi
		fi
			
	echo -n "\t\t\t Segundo nombre: $name2 		\t"; read -p "Nuevo segundo nombre: " newname2
		echo "\t\t\t--------------------------------------------------------------------------------"
	
		if [ -n "$newname2" ];then	
			
			isletter "$newname2"
			
			if [ $? -eq 1 ];then
				
				mysql -uroot -proot -D 'proyecto' -e "
				update persona set segundo_nombre='$newname2' where CI='$idcard';"
			else
				echo "\t\t\t\t Nombre invalido"
			fi
		fi
	
	echo -n "\t\t\t Primer apellido: $surname1 		\t"; read -p "Nuevo primer apellido: " newsurname1
		echo "\t\t\t--------------------------------------------------------------------------------"
	
		if [ -n "$newsurname1" ];then
			
			isletter "$newsurname1"
			
			if [ $? -eq 1 ];then
				
				mysql -uroot -proot -D 'proyecto' -e "
				update persona set primer_apellido='$newsurname1' where CI='$idcard';"
			else
				echo "\t\t\t\t Apellido invalido"
			fi
		fi
		
	echo -n "\t\t\t Segundo apellido: $surname2 		\t"; read -p "Nuevo segundo apellido: " newsurname2
		echo "\t\t\t--------------------------------------------------------------------------------"
	
		if [ -n "$newsurname2" ];then
			
			isletter "$newsurname2"
			
			if [ $? -eq 1 ];then
				
				mysql -uroot -proot -D 'proyecto' -e "
				update persona set segundo_apellido='$newsurname2' where CI='$idcard';"
			else
				echo "\t\t\t\t Apellido invalido"
			fi
		fi
	
	echo -n "\t\t\t Dirección : $address 			"; read -p "Nueva dirección: " newaddress
		echo "\t\t\t--------------------------------------------------------------------------------"
		
		if [ -n "$newaddress" ];then
			
			isaddress "$newaddress"
			
			if [ $? -eq 1 ];then
				
				mysql -uroot -proot -D 'proyecto' -e "
				update persona set direccion="$newaddress" where CI='$idcard';"
			else
				echo "\t\t\t\t Dirección invalida"
			fi
		fi
	sh "$location/sbin/edit_phone.sh" "$idcard"

blnadd=0
until [ $blnadd -eq 1 ];do
	
	echo "\t\t\t\t ¿Quieres agregar más datos?"
	echo "\t\t\t\t  (Responda con S(si) o N(no))"
	echo -n "\t\t\t\t"; read answer
	
	if [ -z "$answer" ];then
	 	
	 	echo "\t\t\t\t\t\t Opción incorrecta"
		echo "\t\t\t--------------------------------------------------------------------------------"
	else
	
	if [ $answer = "s" ] || [ $answer = "S" ];then

############################# Agregando datos
	
		sh "$location/sbin/add_phone.sh" "$idcard" 0
	
		echo " 
			\t┌───────────┐  ┌──────────────┐  ┌───────────┐
			\t│ 1-Docente │  │ 2-No Docente │  │  0-Salir  │
			\t└───────────┘  └──────────────┘  └───────────┘
		"
			
			blnchoice=0
			until [ $blnchoice -eq 1 ];do
			
				echo -n "\t\t\t"; read -p "Elija una opción: " option
				case $option in 
				
				1)
					sh "$location/sbin/teaching.sh" $idcard 1
	 				blnadd=1
					blnchoice=1
				;;
		
				2)
					sh "$location/sbin/non-teaching.sh" $idcard
	 				blnadd=1
					blnchoice=1
				;;
			
				0)
					blnchoice=1
	 				blnadd=1
				;;
			
				*)
					echo "\t\t\t\t\t\t Error opción incorrecta"
					echo "\t\t\t--------------------------------------------------------------------------------"
				;;
			
				esac
			done
	
	elif [ $answer = "n" ] || [ $answer = "N" ];then
	 	
	 	blnadd=1
	 	echo "\t\t\t\t Operación cancelada"
	 	sh "$location/desing/wait.sh"
	else
	 	echo "\t\t\t\t Opción incorrecta"
		echo "\t\t\t--------------------------------------------------------------------------------"
	fi
	fi
	 
done

###################### log

sh "$location/log.sh" "Editó Funcionario"

	blnedit=1
###################### funcionario editado
	
	elif [ $answer = "n" ] || [ $answer = "N" ];then
	 	
	 	blnedit=1
	 	echo "\t\t\t\t Operación cancelada"
	 	sh "$location/desing/wait.sh"
	
	else
	 	sh "$location/desing/message_box.sh" incorrect	
	fi
	fi
done

