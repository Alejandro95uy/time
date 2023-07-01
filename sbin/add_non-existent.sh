#!/bin/bash

#################### localización de la carpeta temporal y principal

temp="/tmp/Undefined Project/bin"
location=$( cat "/tmp/location" )

################ Extracción de datos del funcionario buscada
	
	idcard=$( echo $1 )

	mysql -uroot -proot -D 'proyecto' -e "
	select * from nepersona where CI='$idcard';" | sed -n 2p | tr "\t" ";" > "$temp/nperson"
	
	   name1=$( cut -d ";" -f 2 "$temp/nperson" )
	   name2=$( cut -d ";" -f 3 "$temp/nperson" )
	surname1=$( cut -d ";" -f 4 "$temp/nperson" )
	surname2=$( cut -d ";" -f 5 "$temp/nperson" )
	 rm "$temp/nperson"	
	 	
	 teaching=$( mysql -uroot -proot -D 'proyecto' -e "
	 select count(CI) from docente where CI='$idcard'" | sed -n 2p )
	 	
	 nonteaching=$( mysql -uroot -proot -D 'proyecto' -e "
	 select count(CI) from no_docente where CI='$idcard'" | sed -n 2p )
	 
	 if [ $teaching -eq 1 ];then
	 	functionary="Docente"
	 	
	 elif [ $nonteaching -eq 1 ];then
		 	
		functionary=$( mysql -uroot -proot -D 'proyecto' -e "
		select cargo from no_docente where CI='$idcard'" | sed -n 2p )
	 fi
	 
blnadd=0
until [ $blnadd -eq 1 ];do
	 
	 clear
	 sh "$location/desing/titles.sh" addfun
	 
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
	 	\t\t        \t $functionary
	 	\t\t                                                        
	 	\t\t╚═════════════════════════════════════════════════════════╝\n"	 
	echo "\t\t\t\t¿Seguro que quieres agregar al funcionario?"
	echo "\t\t\t\t       (Responda con S(si) o N(no)) "
	echo -n "\t\t\t\t" ; read -p "Respuesta: " answer
	
	if [ -z "$answer" ];then
	 	
		sh "$location/desing/message_box.sh" incorrect
		
	else
	
		if [ $answer = "s" ] || [ $answer = "S" ];then
	
			mysql -uroot -proot -D 'proyecto' -e "
			update persona set existencia=1 where CI="$idcard";"
		
		 	blnadd=1
			echo "\t\t\t\t Funcionario agregado"
			sh "$location/desing/wait.sh"
		
###################### Log

		sh "$location/log.sh" "Agregó Funcionario"
		
		elif [ $answer = "n" ] || [ $answer = "N" ];then
		 	
		 	blnadd=1
		 	echo "\t\t\t\t Operación cancelada"
		 	sh "$location/desing/wait.sh"
		else
		 	
			 sh "$location/desing/message_box.sh" incorrect
			 	
		fi
	fi
done
