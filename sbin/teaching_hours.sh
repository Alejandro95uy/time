#!/bin/bash

################################### Localiza carpeta temporal y principal

temp="/tmp/Undefined Project/sbin"
location=$( cat "/tmp/location" )

##################### Función donde extrae y muestra los datos

person(){
	
	idcard=$( cat "/tmp/Undefined Project/sidcard" )
		 
	mysql -uroot -proot -D 'proyecto' -e "
	select * from persona where CI='$idcard';" | sed -n 2p | tr "\t" ";" > "$temp/person"
	
	   name1=$( cut -d ";" -f 2 "$temp/person" )
	   name2=$( cut -d ";" -f 3 "$temp/person" )
	surname1=$( cut -d ";" -f 4 "$temp/person" )
	surname2=$( cut -d ";" -f 5 "$temp/person" )
	
	name="Nombre: "$name1" "$name2" "$surname1" "$surname2" - Docente"

	unset lname
	
	for i in `seq 1 ${#name}` ;do
				
		lname="$lname─"
				
	done
		clear
		sh "$location/desing/titles.sh" schedule
		
		echo "\t\t\t\t    ┌─$lname─┐"
		echo "\t\t\t\t    │ $name  │"
		echo "\t\t\t\t    └─$lname─┘"
		
}

####################### Función de presentación de grado y materia

subgra(){
				
	person
	
	echo "\t\t\t\t\t ╔═══════════════════════════════════════════╗"
	echo "\t\t\t\t\t  \t $grade"
	echo "\t\t\t\t\t  -------------------------------------------"
	echo "\t\t\t\t\t  \t Asignatura: $sub "
	echo "\t\t\t\t\t ╚═══════════════════════════════════════════╝"
				
	echo "\t\t\t---------------------------------------------------------------------------------------------------"
}
############################ Comprobar si existe el grupo

group(){
	
	if [ -n "$2" ];then
	
	idgroup=$( mysql -uroot -proot -D 'proyecto' -e "
		select ID_grupo from grupo where grado='$1' and nombre_grupo='$2';" | sed -n 2p )
	
	if [ -z "$idgroup" ];then
		
		echo "\n\t\t\t El grupo no esta ingresado ¿Quieres ingresarlo?"
	 	echo "\t\t\t\t(Responda con S(si) o N(no)) "
	echo "\t\t\t---------------------------------------------------------------------------------------------------"
	 	echo -n "\t\t\t" ; read -p "Respuesta: " answer
	 	
		if [ "$answer" = "S" ] || [ "$answer" = "s" ] ;then		
			
			mysql -uroot -proot -D 'proyecto' -e "
			insert into grupo(grado,nombre_grupo) values ('$1','$2');"
			
			idgroup=$( mysql -uroot -proot -D 'proyecto' -e "
			select ID_grupo from grupo where grado='$1' and nombre_grupo='$2';" | sed -n 2p )
			
		elif [ "$answer" = "N" ] || [ "$answer" = "n" ];then
		 	
		 	echo "\t\t\t\t Operación cancelada"
		 	sh "$location/desing/wait.sh"
			
		elif [ -z "$answer" ];then
		 	
		 	sh "$location/desing/message_box.sh" incorrect
		
		else
		 	
		 	sh "$location/desing/message_box.sh" incorrect
		fi
	fi
			
			return "$idgroup"
		
	else
		 sh "$location/desing/message_box.sh" incorrect
	fi
}

######################### Ingreso de materia

blnteacher=0	
until [ $blnteacher -eq 1 ];do
	
	person
	echo "\t\t\t---------------------------------------------------------------------------------------------------"
	echo -n "\t\t\t"; read -p "Materia: " subjects
	
	if [ -n "$subjects" ];then
	
	idsubjects=$( mysql -uroot -proot -D 'proyecto' -e "
		  select ID_materia from materia where materia='$subjects';" | sed -n 2p )
	
	
	if [ -z "$idsubjects"  ];then
		
		echo "\n\t\t\t La asignatura no esta ingresada ¿Quieres ingresarla?"
	 	echo "\t\t\t\t(Responda con S(si) o N(no)) "
	echo "\t\t\t---------------------------------------------------------------------------------------------------"
	 	echo -n "\t\t\t" ; read -p "Respuesta: " answer
		
		if [ "$answer" = "S" ] || [ "$answer" = "s" ] ;then
			
			mysql -uroot -proot -D 'proyecto' -e "
			insert into materia (materia) values ('$subjects');"
		
			idsubjects=$( mysql -uroot -proot -D 'proyecto' -e "
			select ID_materia from materia where materia='$subjects';" | sed -n 2p "$temp/idsubjects" )
			
			
		elif [ "$answer" = "N" ] || [ "$answer" = "n" ];then
		 	
		 	echo "\t\t\t\t Operación cancelada"
		 	sh "$location/desing/wait.sh"
			
		elif [ -z "$answer" ];then
		 	
		 	sh "$location/desing/message_box.sh" incorrect
		else
		 	
		 	sh "$location/desing/message_box.sh" incorrect
		fi
	fi
	
	else
		sh "$location/desing/message_box.sh" incorrect
	fi

	if [ -n "$idsubjects" ];then
	
	sub=$( mysql -uroot -proot -D 'proyecto' -e "
		select materia from materia where ID_materia='$idsubjects';" | sed -n 2p )

	
####################### Ingreso del grupo
	
		blngro=0
		until [ $blngro -eq 1 ];do
			
			person
			
			echo "\t\t\t\t    ╔═══════════════════════════════════════════╗"
			echo "\t\t\t\t     \t Asignatura: $sub "
			echo "\t\t\t\t    ╚═══════════════════════════════════════════╝"
			
			sh "$location/desing/menu.sh" course
			echo -n "\t\t\t"; read -p "Elija un curso: " course
			
		case "$course" in
			
			1)
				grade="Ciclo Básico Tecnológico"
				
				subgra
				
				echo -n "\t\t\t"; read -p "Grupo: " group
				group "$grade" "$group"
			;;
			
			2)
				grade="Formación Básica Profesional"
				
				subgra
				
				echo -n "\t\t\t"; read -p "Grupo: " group
				group "$grade" "$group"
			;;
			
			3)
				grade="Educación Media Profesional"
				
				subgra
				
				echo -n "\t\t\t"; read -p "Grupo: " group
				group "$grade" "$group"
			;;
			
			4)
				grade="Educación Media tecnológica"
				
				subgra
				
				echo -n "\t\t\t"; read -p "Grupo: " group
				group "$grade" "$group"
			;;
			
			5)
				grade="Bachillerato Profesional"
				
				subgra
				
				echo -n "\t\t\t"; read -p "Grupo: " group
				group "$grade" "$group"
			;;
			
			6)
				grade="Capacitaciones"
				
				subgra
				
				echo -n "\t\t\t"; read -p "Grupo: " group
				group "$grade" "$group"
			;;
			
			*)
		 		sh "$location/desing/message_box.sh" incorrect
			;;
		esac

#################### Inserciones en la tablas		
		
		verify1=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(ID_grupo) from componen 
			where ID_grupo='$idgroup' and ID_materia='$idsubjects';" | sed -n 2p )
			
		verify2=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(CI) from dictan 
			where CI='$1' and ID_grupo='$idgroup' and ID_materia='$idsubjects';" | sed -n 2p )
			
		if [ $verify1 -eq 0 ];then
			
			mysql -uroot -proot -D 'proyecto' -e "
			insert into componen(ID_grupo,ID_materia) values ($idgroup,$idsubjects)"
		fi
		
		if [ $verify2 -eq 0 ];then
			
			mysql -uroot -proot -D 'proyecto' -e "
			insert into dictan(CI,ID_grupo,ID_materia) values ($1,$idgroup,$idsubjects);"
			
		fi
			
		if [ -n "$idsubjects" ] && [ -n "$idgroup" ];then
			
			blngro=1
			blnteacher=1
			
		fi
		
		done
	fi
done

################ Función para la elección del turno

turn(){
	
	echo "
	\t\t    ┌────────────┐ ┌──────────────┐ ┌────────────┐ 
	\t\t    │ 1-Matutino │ │ 2-Vespertino │ │ 3-Nocturno │ 
	\t\t    └────────────┘ └──────────────┘ └────────────┘ 
	"
	echo -n "\t\t\t"; read -p "Elija un turno: " turn
	
	case $turn in
	
	1)
		sh "$location/sbin/turn_hours.sh" morning $idcard $idgroup $idsubjects $weekdays $days
	;;
	
	2)
		sh "$location/sbin/turn_hours.sh" afternoon $idcard $idgroup $idsubjects $weekdays $days
	;;
	
	3)
		sh "$location/sbin/turn_hours.sh" evening $idcard $idgroup $idsubjects $weekdays $days
	;;
	
	*)
		sh "$location/desing/message_box.sh" incorrect
	;;
	
	esac

}

blnschedule=0
until [ $blnschedule -eq 1 ];do
		
	subgra

################## elección del día de la semana 
	
	echo "
	\t  ┌─────────┐ ┌──────────┐ ┌─────────────┐ ┌──────────┐ ┌───────────┐ ┌──────────┐ ┌────────────┐ 
	\t  │ 1-Lunes │ │ 2-Martes │ │ 3-Miércoles │ │ 4-Jueves │ │ 5-Viernes │ │ 6-Sábado │ │ 0-Terminar │
	\t  └─────────┘ └──────────┘ └─────────────┘ └──────────┘ └───────────┘ └──────────┘ └────────────┘
	"
	echo -n "\t\t\t"; read -p "Elija días de la semana: " wkdays
	
	case $wkdays in
		
		1)
			weekdays="Lunes"
			days="monday"
			turn 
		;;
		
		2)
			weekdays="Martes"
			days="tuesday"
			turn 
		;;
		
		3)
			weekdays="Miércoles"
			days="wednesday"
			turn 
		;;
		
		4)
			weekdays="Jueves"
			days="thursday"
			turn 
		;;
		
		5)
			weekdays="Viernes"
			days="friday"
			turn 
		;;
		
		6)
			weekdays="Sábado"
			days="saturday"
			turn 
		;;

		0)
			blnschedule=1
		;;
		
		*)
			sh "$location/desing/message_box.sh" incorrect
		;;
	esac
done

