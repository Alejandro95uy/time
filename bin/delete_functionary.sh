#!/bin/bash

#################### Localización de la carpeta temporal y principal

temp="/tmp/Undefined Project/bin"
location=$( cat "/tmp/location" )

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

######################### Elección del eliminado

blnop=0
until [ $blnop -eq 1 ];do

	clear
	sh "$location/desing/titles.sh" delfun

	echo "\t\t\t\t  ¿Que eliminación desea?\n
		\t\t┌───────────┐  ┌───────────┐
		\t\t│ 1-Parcial │  │  2-Total  │
		\t\t└───────────┘  └───────────┘
	"
	echo -n "\t\t\t"; read -p "Elija una opción: " option
	
	if [ -n "$option" ];then
		
		isnumeric "$option"
		
		if [ $? -ne 1 ];then
		
			sh "$location/desing/message_box.sh" incorrect
		else
			blnop=1
		fi
	else
		
		sh "$location/desing/message_box.sh" incorrect
	fi
done	
################# Ejecución del search (busca funcionario) 

	sh "$location/sbin/search.sh"		

################ Extracción de datos del funcionario buscado
	
	idcard=$( cat "/tmp/Undefined Project/sidcard" )
	
	mysql -uroot -proot -D 'proyecto' -e "
	select * from epersona where CI='$idcard';" | sed -n 2p | tr "\t" ";" > "$temp/person"
	
	   name1=$( cut -d ";" -f 2 "$temp/person" )
	   name2=$( cut -d ";" -f 3 "$temp/person" )
	surname1=$( cut -d ";" -f 4 "$temp/person" )
	surname2=$( cut -d ";" -f 5 "$temp/person" )
	 
	 rm "$temp/person"	
	 	
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
	 
blndel=0
until [ $blndel -eq 1 ];do
	
	clear
	sh "$location/desing/titles.sh" delfun
	 
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
	echo "\t\t\t\t¿Seguro que quieres eliminar al funcionario?"
	echo "\t\t\t\t       (Responda con S(si) o N(no)) "
	echo -n "\t\t\t\t" ; read -p "Respuesta: " answer

############### confirmación del borrado 
	
	if [ -z "$answer" ];then
	 	
	 	sh "$location/desing/message_box.sh" incorrect
	else
	
	if [ $answer = "s" ] || [ $answer = "S" ];then
	 	
	adm=$( mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from admin where CI=$idcard;" | sed -n 2p )
	
	if [ $adm -eq 0 ];then
###################### log

sh "$location/log.sh" "Eliminó Funcionario"
	 	
	 	if [ $option -eq 2 ];then
	 	
########################## Eliminación permanente

		 	if [ $teaching -eq 1 ];then	
			 		
			 	mysql -uroot -proot -D 'proyecto' -e "
			 	delete from docente where CI='$idcard';"
			 		
			 	mysql -uroot -proot -D 'proyecto' -e "
			 	delete from horarios_docente where CI='$idcard';"
			 		
			 	mysql -uroot -proot -D 'proyecto' -e "
			 	delete from dictan where CI='$idcard';"
		 	fi
		 	
		 	if [ $nonteaching -eq 1 ];then
		 			
		 		mysql -uroot -proot -D 'proyecto' -e "
		 		delete from no_docente where CI='$idcard';"
		 			
		 		mysql -uroot -proot -D 'proyecto' -e "
		 		delete from horario_no where CI='$idcard';"
		 	fi
		 		
		 	mysql -uroot -proot -D 'proyecto' -e "
		 	delete from tel_per where ci=$idcard;"	
		 		
		 	mysql -uroot -proot -D 'proyecto' -e "
		 	delete from persona where ci=$idcard;"
		 	
		 	blndel=1
		 	echo "\n\t\t\t\t\t Funcionario eliminado"
		 	sh "$location/desing/wait.sh"

####################### Eliminación Parcial
		 	
		 elif [ $option -eq 1 ];then
		 		
		 	mysql -uroot -proot -D 'proyecto' -e "
		 	update persona set existencia=0 where CI="$idcard";"
		 	blndel=1
		 	echo "\n\t\t\t\t\t Funcionario eliminado"
		 	sh "$location/desing/wait.sh"
		 
		 else
		 	sh "$location/desing/message_box.sh" 
		 fi
	else
		echo "\n\t\t\t\t\t  No se puede eliminar funcionario "
		echo "\t\t\t\t se debe retirar los permisos de administrador del sistema\n"
		sh "$location/desing/wait.sh"
	fi
	
########################## Operación Cancelada
	 	
	elif [ $answer = "n" ] || [ $answer = "N" ];then
	 	
	 	blndel=1
	 	echo "\t\t\t\t\t Operación cancelada"
	 	sh "$location/desing/wait.sh"
	
	else
	 	sh "$location/desing/message_box.sh" incorrect	
	fi
	fi
done

