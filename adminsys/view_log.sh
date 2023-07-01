#!/bin/bash

##################### Localizar carpeta del log y principal

location=$( cat "/tmp/location" )
temp="/tmp/Undefined Project"
log="/home/`whoami`/.time/log/`date +%Y`"

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

blnlog=0
until [ $blnlog -eq 1 ];do
	
################# Ver registros
	
	clear
	sh "$location/desing/titles.sh" log
	echo "
	Enero|Febrero|Marzo|Abril|Mayo|Junio|Julio|Agosto|Septiembre|Octubre|Noviembre|Diciembre
	  1  |   2   |  3  |  4  |  5 |  6  |  7  |   8  |    9     |   10  |   11    |   12
	" | column -s '|' -t
	
	echo
	echo -n "\t\t\t"; read -p "Ingrese el número del mes: " month
	
	if [ -n "$month" ];then
			
		if [ ${#month} -le 2 ];then 
				
			isnumeric "$month"
			
			if [ $? -eq 1 ];then
				
				if [ $month -ge 1 ] && [ $month -le 12 ];then
	
					exists=$( ls "$log" | grep "$month-`date +%Y`" )
	
					if [ -n "$exists" ];then
					
						clear
						sh "$location/desing/titles.sh" log
						column -s ';' -t "$log/$month-`date +%Y`" | more
						echo "\n"
						read wait1
				 		sh "$location/desing/wait.sh"
					 	blnlog=1
				 	else
				 		echo
				 		echo "\t\t\t\t No existe registros"
				 		sh "$location/desing/wait.sh"
					fi
					
				else
					sh "$location/desing/message_box.sh" incorrect 
				fi
			else
				sh "$location/desing/message_box.sh" incorrect 
			fi
			 
		else
			sh "$location/desing/message_box.sh" incorrect 
	 	fi
	else
		sh "$location/desing/message_box.sh" incorrect 
	fi
done

