#!/bin/bash

###################### localización de la carpeta principal y temporal

temp="/tmp/Undefined Project/bin"
location=$( cat "/tmp/location" )

##################### función donde extrae y muestra los datos

person(){
	
	idcard=$( cat "/tmp/Undefined Project/sidcard" )
		 
	mysql -uroot -proot -D 'proyecto' -e "
	select * from persona where CI='$idcard';" | sed -n 2p | tr "\t" ";" > "$temp/person"
	
	   name1=$( cut -d ";" -f 2 "$temp/person" )
	   name2=$( cut -d ";" -f 3 "$temp/person" )
	surname1=$( cut -d ";" -f 4 "$temp/person" )
	surname2=$( cut -d ";" -f 5 "$temp/person" )
	

	 
	 if [ $teaching -eq 1 ];then
	 	func=1
	 	functionary="Docente"
	 	
	 elif [ $nonteaching -eq 1 ];then
		 func=2
		functionary=$( mysql -uroot -proot -D 'proyecto' -e "
			select cargo from no_docente where CI='$idcard'" | sed -n 2p )
	 fi

		clear
		sh "$location/desing/titles.sh" schedule
		echo "
		\t\t\t       ╔═══════════════════════════════╗
		\t\t\t       ║ Cédula de identidad: $idcard ║
		\t\t\t       ╚═══════════════════════════════╝
		\t--------------------------------------------------------------------------------------
		\t\t\t     "$name1" "$name2" "$surname1" "$surname2" - "$functionary"
		\t--------------------------------------------------------------------------------------"
	return $func
}

############################ comienza la asignación de horas

blnsche=0
until [ $blnsche -eq 1 ];do

	clear
	sh "$location/desing/titles.sh" schedule
	
	echo "
	\t\t\t\t┌───────────┐  ┌────────────┐  ┌─────────┐
	\t\t\t\t│ 1-Agregar │  │ 2-Eliminar │  │ 0-Atrás │
	\t\t\t\t└───────────┘  └────────────┘  └─────────┘ 
	"
	echo -n "\t\t\t\t"; read -p "Elija una opción: " option

case $option in
	
1) 
	blnsche=1
	sh "$location/sbin/search.sh"
		
	idcard=$( cat "/tmp/Undefined Project/sidcard" )
	
	teaching=$( mysql -uroot -proot -D 'proyecto' -e "
	select count(CI) from docente where CI='$idcard'" | sed -n 2p )
	 	 
	nonteaching=$( mysql -uroot -proot -D 'proyecto' -e "
	select count(CI) from no_docente where CI='$idcard'" | sed -n 2p )
	  
	 if [ $teaching -eq 1 ];then
	 	
	 	func=1
	 	
	 elif [ $nonteaching -eq 1 ];then
		
		func=2
	 fi
	 
	case $func in
		
		1)
			sh "$location/sbin/teaching_hours.sh" "$idcard" "$weekdays" "$days"
		;;
	
		2)
			sh "$location/sbin/non-teaching_hours.sh" "$idcard" "$weekdays" "$days"
		;;
	esac
	
;;

##################### elimina todas las horas

2)
	blnsche=1
	sh "$location/sbin/search.sh"
	
	blndelhs=0
	until [ "$blndelhs" -eq 1 ];do
	
		person	 
		echo "\t\t\t¿Seguro que quieres eliminar todas las hora del funcionario?"
		echo "\t\t\t       (Responda con S(si) o N(no)) "
		echo -n "\t\t\t" ; read -p "Respuesta: " answer
		 	
		if [ -z "$answer" ];then
		 	
			sh "$location/desing/message_box.sh" incorrect
		
		else
			
			if [ $answer = "s" ] || [ $answer = "S" ];then
			
				if [ $func -eq 1 ];then
				 	
				 	mysql -uroot -proot -D 'proyecto' -e "
				 	delete from horarios_docente where CI='$idcard';"
			
				elif [ $func -eq 2 ];then
			 		
			 		mysql -uroot -proot -D 'proyecto' -e "
			 		delete from horario_no where CI='$idcard';"
				fi
			
				echo "\t\t\t\t Horas eliminadas"
				sh "$location/desing/wait.sh"
				blndelhs=1
			 	
			elif [ $answer = "n" ] || [ $answer = "N" ];then
			 	
			 	echo "\t\t\t\t Operación cancelada"
			 	sh "$location/desing/wait.sh"
				blndelhs=1
			else
			 	
				sh "$location/desing/message_box.sh" incorrect	
			fi
		fi
	done
;;

################## opción incorrecta

0)
	blnsche=1
;;

*)
	sh "$location/desing/message_box.sh" incorrect	
;;

esac
done

