#!/bin/bash

########################## Localizar carpeta temporal y principal

temp="/tmp/Undefined Project/sbin"
location=$( cat "/tmp/location" )

####################### Función mostrar datos

data(){
	
	idcard=$( cat "/tmp/Undefined Project/sidcard" )
		 
	mysql -uroot -proot -D 'proyecto' -e "
	select * from persona where CI='$idcard';" | sed -n 2p | tr "\t" ";" > "$temp/person"
	
	   name1=$( cut -d ";" -f 2 "$temp/person" )
	   name2=$( cut -d ";" -f 3 "$temp/person" )
	surname1=$( cut -d ";" -f 4 "$temp/person" )
	surname2=$( cut -d ";" -f 5 "$temp/person" )
	functionary=$( mysql -uroot -proot -D 'proyecto' -e "
			select cargo from no_docente where CI='$idcard'" | sed -n 2p )
	clear
	sh "$location/desing/titles.sh" schedule
	echo "
		\t\t\t         ╔═══════════════════════════════╗
		\t\t\t         ║ Cédula de identidad: $idcard ║
		\t\t\t         ╚═══════════════════════════════╝
		\t--------------------------------------------------------------------------------------
		\t\t\t    "$name1" "$name2" "$surname1" "$surname2" - "$functionary"
		\t--------------------------------------------------------------------------------------"
	
	if [ $1 -eq 1 ];then
		
		sh "$location/desing/weekdays.sh" "$2"
	fi

}

###################### Función si es número

isnumeric(){
	
	echo "$1" > "$temp/number"
	alpha=$( grep "[[:alpha:]]" "$temp/number" )
	punct=$( grep "[[:punct:]]" "$temp/number" )
	cntrl=$( grep "[[:cntrl:]]" "$temp/number" )
	blank=$( grep "[[:blank:]]" "$temp/number" )
	
	if [ -z "$alpha" ] && [ -z "$punct" ] && [ -z "$cntrl" ] && [ -z "$blank" ];then
		rm "$temp/number"
		return 1
	fi
}

##################### Función si es hora

ishour(){

	hour=$( echo "$1" | grep ":" )
	
	if [ -n "$hour" ];then
	
		hh=$( echo "$1" | cut -d ":" -f 1 )
		mm=$( echo "$1" | cut -d ":" -f 2 )
		
		if ( [ ${#hh} -eq 2 ] || [ ${#hh} -eq 1 ] ) && [ ${#mm} -eq 2 ];then
			
			isnumeric "$hh"
		
			if [ $? -eq 1 ];then
				
				isnumeric "$mm"
			
				if [ $? -eq 1 ];then
				
					if [ $hh -ge 00 ] && [ $hh -le 23 ] && [ $mm -ge 00 ] && [ $mm -le 59 ];then
			
						return 1
					fi
				fi
			fi
		fi
	fi
}

schedule(){
######################### Comienza el ingreso de hora

blnhours=0
until [ "$blnhours" -eq 1 ];do
	
	data 1 "$3"
	
	echo "\n\t\t  (El formato de la hora es HH:mm de 24hs, debe ingresar los "\:" para ser ingresado correctamente )"
	echo "\t\t\t ---------------------------------------------------------------------------------------------------"
	
	echo -n "\t\t\t";read -p "Hora de Entrada: " entry

	ishour "$entry"
	
	if [ $? -eq 1 ];then
	
	echo "\t\t\t ---------------------------------------------------------------------------------------------------"
	echo -n "\t\t\t"; read -p "Hora de salida: " departure
	echo "\t\t\t ---------------------------------------------------------------------------------------------------"

		ishour "$departure"
		
		if [ $? -eq 1 ];then
			
			entry1=$( echo "$entry" | tr -d ":"  )
			
			departure1=$( echo "$departure" | tr -d ":" )
			
			if [ "$entry1" -lt "$departure1" ];then
			
			verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horario_no 
				where CI='$1' and entrada='$entry' and salida='$departure' 
				and dia_semana='$2';" | sed -n 2p )
			
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horario_no(CI,dia_semana,entrada,salida) 
					values ($1,'$2','$entry','$departure');"
					
					echo "\t\t\t\t\t Agregado con éxito"
					sh "$location/desing/wait.sh"
				blnhours=1
########################################## log

	sh "$location/log.sh" "Asignó Horas - no docente"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
					sh "$location/desing/wait.sh"
		echo "\t\t ---------------------------------------------------------------------------------------------------"
					
				blnhours=1
				
				fi
			
			else
				echo "\t\t\t\t\t El parámetro de hora es incorrecto"
				sh "$location/desing/wait.sh"
			fi
			
		else
			echo "\t\t\t\t\t Hora incorrecta"
			sh "$location/desing/wait.sh"
		fi
		
	else
		echo "\t\t\t\t\t Hora incorrecta"
		sh "$location/desing/wait.sh"
	fi
done

}

	idcard=$( cat "/tmp/Undefined Project/sidcard" )
	
blnschedule=0
until [ $blnschedule -eq 1 ];do
		
		data 0

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
			schedule "$idcard" "$weekdays" "$days"
		;;
		
		2)
			weekdays="Martes"
			days="tuesday"
			schedule "$idcard" "$weekdays" "$days"
		;;
		
		3)
			weekdays="Miércoles"
			days="wednesday"
			schedule "$idcard" "$weekdays" "$days"
		;;
		
		4)
			weekdays="Jueves"
			days="thursday"
			schedule "$idcard" "$weekdays" "$days"
		;;
		
		5)
			weekdays="Viernes"
			days="friday"
			schedule "$idcard" "$weekdays" "$days"
		;;
		
		6)
			weekdays="Sábado"
			days="saturday"
			schedule "$idcard" "$weekdays" "$days"
		;;

		0)
			blnschedule=1
		;;
		
		*)
			sh "$location/desing/message_box.sh" incorrect
		;;
	esac
done

