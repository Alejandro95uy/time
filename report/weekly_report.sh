#!/bin/bash

###################### Localizar carpeta principal y temporal

location=$( cat "/tmp/location" )
temp="/tmp/Undefined Project/report"
files="/home/`whoami`/.time/print"

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

################## Función si es fecha

isdate(){

format=$( echo "$1" | grep "/" )
	
if [ -n "$format" ];then
	
	days=$( echo "$1" | cut -d "/" -f 1 )
	month=$( echo "$1" | cut -d "/" -f 2 )
	year=$( echo "$1" | cut -d "/" -f 3)
		
		isnumeric "$days"
			
	if [ $? -eq 1 ] && [ ${#days} -ge 1 ] && [ ${#days} -le 2 ];then
			
			isnumeric "$month"
			
		if [ $? -eq 1 ] && [ ${#month} -ge 1 ] && [ ${#month} -le 2 ] ;then
				
				isnumeric "$year"
				
			if [ $? -eq 1 ] && ( [ ${#year} -eq 2 ] || [ ${#year} -eq 4 ] );then
				
				if [ "$days" -ge 1 ] && [ "$days" -le 31 ];then
					
					if [ "$month" -ge 1 ] && [ "$month" -le 12 ];then
						
						return 1
						
					fi
				fi
				
			fi
		fi
	fi
fi

}


	clear
	sh "$location/sbin/search.sh"
	
####################### Extracción de datos del funcionario buscado
	
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
	

	clear
	sh "$location/desing/titles.sh" rweekly
	
	echo "
		\t\t\t       ╔═══════════════════════════════╗
		\t\t\t       ║ Cédula de identidad: $idcard ║
		\t\t\t       ╚═══════════════════════════════╝
		\t--------------------------------------------------------------------------------------
		\t\t\t     "$name1" "$name2" "$surname1" "$surname2" - "$functionary"
		\t--------------------------------------------------------------------------------------\n"
	cal -3
	
	echo "\n\t\t  (El formato de la fecha es dd/mm/YYYY, solo con números debe ingresar los "\/" para ser ingresado correctamente )"
	echo "\t\t\t---------------------------------------------------------------------------------------------------"
	
blnweek=0
until [ "$blnweek" -eq 1 ];do

	echo -n "\t\t\t"; read -p "Fecha: " fdate1
		
		if [ -z "$fdate1" ];then
			
			blnweek=1
		fi
		
		isdate "$fdate1"
		
	if [ $? -eq 1 ];then
	
		echo "\t\t\t---------------------------------------------------------------------------------------------------"
		echo -n "\t\t\t"; read -p "Fecha: " fdate2
		
		isdate "$fdate2"
		
		if [ $? -eq 1 ];then
			
			days1=$( echo "$fdate1" | cut -d "/" -f 1 )
			month1=$( echo "$fdate1" | cut -d "/" -f 2 )
			year1=$( echo "$fdate1" | cut -d "/" -f 3)
			
			days2=$( echo "$fdate2" | cut -d "/" -f 1 )
			month2=$( echo "$fdate2" | cut -d "/" -f 2 )
			year2=$( echo "$fdate2" | cut -d "/" -f 3)
			
			if [ "$days1" -lt "$days2" ] && [ "$month1" -le "$month1" ] && [ "$year1" -eq "$year2" ];then
			
				fecha1="$year1-$month1-$days1"
				fecha2="$year2-$month2-$days2"
			
				cdate=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(distinct(CI)) from horarios_marcados
				where horarios_marcados.CI='$idcard' and horarios_marcados.fecha>='$fecha1'
				and horarios_marcados.fecha<='$fecha2';" | sed -n 2p )
				
				if [ $cdate -ne 0 ];then
				
				qhours=$( mysql -uroot -proot -D 'proyecto' -e "
				select  SEC_TO_TIME(SUM(TIME_TO_SEC(TIMEDIFF(m_salida, m_entrada)))) 
				from horarios_marcados 
				where CI='$idcard' and fecha>='$fecha1'and fecha<='$fecha2';" | sed -n 2p )
				
				for i in `seq 1 ${#qhours}` ;do
				
					ql="$ql─"
				
				done
				
				clear
				sh "$location/desing/titles.sh" rweekly
	
	echo "
		\t\t\t       ╔═══════════════════════════════╗
		\t\t\t       ║ Cédula de identidad: $idcard ║
		\t\t\t       ╚═══════════════════════════════╝
		\t--------------------------------------------------------------------------------------
		\t\t\t     "$name1" "$name2" "$surname1" "$surname2" - "$functionary"
		\t--------------------------------------------------------------------------------------"
				
			echo "\t\t\t\t\t┌───────────────────────────────$ql─┐"
			echo "\t\t\t\t\t│ Cantidad de horas realizadas: $qhours │"
			echo "\t\t\t\t\t└───────────────────────────────$ql─┘\n"
				
				mysql -uroot -proot -D 'proyecto' -e "
				select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
				epersona.primer_apellido as 'Apellido', date_format(horarios_marcados.fecha,'%d/%m/%Y') as 'Fecha',
				horarios_marcados.m_entrada as 'Entrada', horarios_marcados.m_salida as 'Salida', motivo.motivo as 'Motivo'
				from horarios_marcados, epersona, motivo
				where horarios_marcados.CI='$idcard' and horarios_marcados.CI=epersona.CI and 
				horarios_marcados.ID_motivo=motivo.ID_motivo and horarios_marcados.fecha>='$fecha1'
				and horarios_marcados.fecha<='$fecha2';"
				
				sh "$location/desing/wait.sh"
				
				blnweek=1
		
###################### Logs

sh "$location/log.sh" "Generó informe - Semanal por persona"


		( sh "$location/desing/titles.sh" rweekly
	
		echo "
		\t\t\t       ╔═══════════════════════════════╗
		\t\t\t       ║ Cédula de identidad: $idcard ║
		\t\t\t       ╚═══════════════════════════════╝
		\t--------------------------------------------------------------------------------------
		\t\t\t     "$name1" "$name2" "$surname1" "$surname2" - "$functionary"
		\t--------------------------------------------------------------------------------------"
				
			echo "\t\t\t\t\t┌───────────────────────────────$ql─┐"
			echo "\t\t\t\t\t│ Cantidad de horas realizadas: $qhours │"
			echo "\t\t\t\t\t└───────────────────────────────$ql─┘\n"
				
				mysql -uroot -proot -D 'proyecto' -e "
				select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
				epersona.primer_apellido as 'Apellido', date_format(horarios_marcados.fecha,'%d/%m/%Y') as 'Fecha',
				horarios_marcados.m_entrada as 'Entrada', horarios_marcados.m_salida as 'Salida', motivo.motivo as 'Motivo'
				from horarios_marcados, epersona, motivo
				where horarios_marcados.CI='$idcard' and horarios_marcados.CI=epersona.CI and 
				horarios_marcados.ID_motivo=motivo.ID_motivo and horarios_marcados.fecha>='$fecha1'
				and horarios_marcados.fecha<='$fecha2';" | tr "\t" ";" | column -s ';' -t ) > "$files/semanal_`date +%d-%m-%Y-%H:%M`"
				
				lp -o orientation-requested=4 -o media=A4 "$files/semanal_`date +%d-%m-%Y-%H:%M`"
		
###################### Logs

sh "$location/log.sh" "Imprimió informe - Semanal por persona"

				else
					
					sh "$location/desing/message_box.sh" nodata
					blnweek=1
				fi
			
			else
		
				echo "\t\t\t\t\t Rango de fecha invalido"
		echo "\t\t\t---------------------------------------------------------------------------------------------------"
			
			fi
		
		else
		
			echo "\t\t\t\t\t Fecha invalida"
		echo "\t\t\t---------------------------------------------------------------------------------------------------"
		
		fi
		
	else
		echo "\t\t\t\t\t Fecha invalida"
	echo "\t\t\t---------------------------------------------------------------------------------------------------"
	
	fi		
done

