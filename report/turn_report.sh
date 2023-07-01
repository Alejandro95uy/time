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

######################### Cambiar el formato de la fecha

fecha(){
	
	days=$( echo "$1" | cut -d "/" -f 1 )
	month=$( echo "$1" | cut -d "/" -f 2 )
	year=$( echo "$1" | cut -d "/" -f 3)

	fecha="$year-$month-$days"
	
}
	
###################### Comienza informe por turno
	
	clear
	sh "$location/desing/titles.sh" rturn
	
	echo "\n\t\t  (El formato de la fecha es dd/mm/YYYY, solo con números debe ingresar los "\/" para ser ingresado correctamente )"
	echo "\t\t\t---------------------------------------------------------------------------------------------------"
	
blnrturn=0
until [ $blnrturn -eq 1 ];do

	echo -n "\t\t\t"; read -p "Fecha: " fdate
		
		isdate "$fdate"
			
		
	if [ $? -eq 1 ];then
	
	blnturn=0
	until [ $blnturn -eq 1 ];do	
		
		unset line
		for i in `seq 1 ${#fdate}` ;do
				
			line="$line─"
				
		done
		
		blnrturn=1	
		
		clear
		sh "$location/desing/titles.sh" rturn
		
		echo "\t\t\t\t\t┌────────$line─┐"
		echo "\t\t\t\t\t│ Fecha: $fdate │"
		echo "\t\t\t\t\t└────────$line─┘"
		
		echo "
		\t\t    ┌────────────┐ ┌──────────────┐ ┌────────────┐ 
		\t\t    │ 1-Matutino │ │ 2-Vespertino │ │ 3-Nocturno │ 
		\t\t    └────────────┘ └──────────────┘ └────────────┘ 
		"
			
		echo -n "\t\t\t"; read -p "Elija un turno: " turn
	
		case $turn in
	
		1)
			fecha "$fdate"
			
			quantity=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(distinct(horarios_marcados.CI)) 
				from horarios_marcados, epersona, horario_no, horarios_docente
				where epersona.CI=horarios_marcados.CI and
				horarios_marcados.m_entrada<='13:00' and 
				horarios_marcados.m_entrada>='07:00' and horarios_marcados.fecha='$fecha';"| sed -n 2p )
			
			if [ $quantity -ne 0 ];then
			
				unset ql
				
				for i in `seq 1 ${#quantity}` ;do
				
					ql="$ql─"
				
				done
			clear
			sh "$location/desing/titles.sh" rturn
			
			echo "\t\t\t\t\t┌────────$line───────────────────┐"
			echo "\t\t\t\t\t│ Fecha: $fdate | Turno: Matutino │"
			echo "\t\t\t\t\t└────────$line───────────────────┘"
			
			echo "\t\t\t\t    ┌──────────────────────────────────────────$ql─┐"
			echo "\t\t\t\t    │ Cantidad de funcionarios que asistieron: $quantity │"
			echo "\t\t\t\t    └──────────────────────────────────────────$ql─┘\n"
			
			mysql -uroot -proot -D 'proyecto' -e "
			select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
			epersona.primer_apellido as 'Apellido', horarios_marcados.m_entrada as 'Marca de Entrada',
			horarios_marcados.m_salida as 'Marca de Salida', motivo.motivo as 'Motivo' 
			from horarios_marcados, epersona, motivo
			where epersona.CI=horarios_marcados.CI and horarios_marcados.ID_motivo=motivo.ID_motivo and
			horarios_marcados.m_entrada<='13:00' and 
			horarios_marcados.m_entrada>='07:00' and horarios_marcados.fecha='$fecha';"
			
			echo "\n"
			sh "$location/desing/wait.sh"
			blnturn=1
	
###################### Logs

sh "$location/log.sh" "Generó informe - Diario por turno"
			
			( sh "$location/desing/titles.sh" rturn
			
			echo "\t\t\t\t\t┌────────$line───────────────────┐"
			echo "\t\t\t\t\t│ Fecha: $fdate | Turno: Matutino │"
			echo "\t\t\t\t\t└────────$line───────────────────┘"
			
			echo "\t\t\t\t    ┌──────────────────────────────────────────$ql─┐"
			echo "\t\t\t\t    │ Cantidad de funcionarios que asistieron: $quantity │"
			echo "\t\t\t\t    └──────────────────────────────────────────$ql─┘\n"
			
			mysql -uroot -proot -D 'proyecto' -e "
			select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
			epersona.primer_apellido as 'Apellido', horarios_marcados.m_entrada as 'Marca de Entrada',
			horarios_marcados.m_salida as 'Marca de Salida', motivo.motivo as 'Motivo' 
			from horarios_marcados, epersona, motivo
			where epersona.CI=horarios_marcados.CI and horarios_marcados.ID_motivo=motivo.ID_motivo and
			horarios_marcados.m_entrada<='13:00' and 
			horarios_marcados.m_entrada>='07:00' and horarios_marcados.fecha='$fecha';" | tr "\t" ";" | column -s ';' -t ) > "$files/turno_`date +%d-%m-%Y-%H:%M`"
		
		lp -o orientation-requested=4 -o media=A4 "$files/turno_`date +%d-%m-%Y-%H:%M`"

	
###################### Logs

sh "$location/log.sh" "Imprimió informe - Diario por turno"
			
			else
				sh "$location/desing/message_box.sh" nodata
				blnturn=1
			fi
		;;
	
		2)
			fecha "$fdate"
			
			quantity=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(distinct(horarios_marcados.CI)) 
				from horarios_marcados, epersona
				where epersona.CI=horarios_marcados.CI and 
				horarios_marcados.m_entrada<='18:00' and 
				horarios_marcados.m_entrada>='13:00' and horarios_marcados.fecha='$fecha';"| sed -n 2p )
			
			if [ $quantity -ne 0 ];then
			
				unset ql
				
				for i in `seq 1 ${#quantity}` ;do
				
					ql="$ql─"
				
				done
			clear
			sh "$location/desing/titles.sh" rturn
			
			echo "\t\t\t\t\t┌────────$line─────────────────────┐"
			echo "\t\t\t\t\t│ Fecha: $fdate | Turno: Vespertino │"
			echo "\t\t\t\t\t└────────$line─────────────────────┘"
			
			echo "\t\t\t\t┌──────────────────────────────────────────$ql─┐"
			echo "\t\t\t\t│ Cantidad de funcionarios que asistieron: $quantity │"
			echo "\t\t\t\t└──────────────────────────────────────────$ql─┘\n"
			
			mysql -uroot -proot -D 'proyecto' -e "
			select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
			epersona.primer_apellido as 'Apellido', horarios_marcados.m_entrada as 'Marca de Entrada',
			horarios_marcados.m_salida as 'Marca de Salida', motivo.motivo as 'Motivo'  
			from horarios_marcados, epersona, motivo
			where epersona.CI=horarios_marcados.CI and horarios_marcados.ID_motivo=motivo.ID_motivo and
			horarios_marcados.m_entrada<='18:00' and 
			horarios_marcados.m_entrada>='13:00' and horarios_marcados.fecha='$fecha';"
			
			sh "$location/desing/wait.sh"
			blnturn=1
	
###################### Logs

sh "$location/log.sh" "Generó informe - Diario por turno"
			
			( sh "$location/desing/titles.sh" rturn
			
			echo "\t\t\t\t\t┌────────$line─────────────────────┐"
			echo "\t\t\t\t\t│ Fecha: $fdate | Turno: Vespertino │"
			echo "\t\t\t\t\t└────────$line─────────────────────┘"
			
			echo "\t\t\t\t┌──────────────────────────────────────────$ql─┐"
			echo "\t\t\t\t│ Cantidad de funcionarios que asistieron: $quantity │"
			echo "\t\t\t\t└──────────────────────────────────────────$ql─┘\n"
			
			mysql -uroot -proot -D 'proyecto' -e "
			select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
			epersona.primer_apellido as 'Apellido', horarios_marcados.m_entrada as 'Marca de Entrada',
			horarios_marcados.m_salida as 'Marca de Salida', motivo.motivo as 'Motivo'  
			from horarios_marcados, epersona, motivo
			where epersona.CI=horarios_marcados.CI and horarios_marcados.ID_motivo=motivo.ID_motivo and
			horarios_marcados.m_entrada<='18:00' and 
			horarios_marcados.m_entrada>='13:00' and horarios_marcados.fecha='$fecha';" | tr "\t" ";" | column -s ';' -t ) > "$files/turno_`date +%d-%m-%Y-%H:%M`"
		
			lp -o orientation-requested=4 -o media=A4 "$files/turno_`date +%d-%m-%Y-%H:%M`"

	
###################### Logs

sh "$location/log.sh" "Imprimió informe - Diario por turno"

			else
				sh "$location/desing/message_box.sh" nodata
				blnturn=1
			fi
		;;
	
		3)
			fecha "$fdate"
			quantity=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(distinct(horarios_marcados.CI)) 
				from horarios_marcados, epersona
				where epersona.CI=horarios_marcados.CI and 
				horarios_marcados.m_entrada<='23:50' and 
				horarios_marcados.m_entrada>='18:00' and horarios_marcados.fecha='$fecha';"| sed -n 2p )
			
			if [ $quantity -ne 0 ];then
			
				unset ql
				
				for i in `seq 1 ${#quantity}` ;do
				
					ql="$ql─"
				
				done
			clear
			sh "$location/desing/titles.sh" rturn
			
			echo "\t\t\t\t\t┌────────$line───────────────────┐"
			echo "\t\t\t\t\t│ Fecha: $fdate | Turno: Nocturno │"
			echo "\t\t\t\t\t└────────$line───────────────────┘"
			
			echo "\t\t\t\t┌──────────────────────────────────────────$ql─┐"
			echo "\t\t\t\t│ Cantidad de funcionarios que asistieron: $quantity │"
			echo "\t\t\t\t└──────────────────────────────────────────$ql─┘\n"
			
			mysql -uroot -proot -D 'proyecto' -e "
			select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
			epersona.primer_apellido as 'Apellido', horarios_marcados.m_entrada as 'Marca de Entrada',
			horarios_marcados.m_salida as 'Marca de Salida', motivo.motivo as 'Motivo' 
			from horarios_marcados, epersona, motivo
			where epersona.CI=horarios_marcados.CI and horarios_marcados.ID_motivo=motivo.ID_motivo and
			horarios_marcados.m_entrada<='23:50' and 
			horarios_marcados.m_entrada>='18:00' and horarios_marcados.fecha='$fecha';"
			
			sh "$location/desing/wait.sh"
			blnturn=1
	
###################### Logs

sh "$location/log.sh" "Generó informe - Diario por turno"
			
			( sh "$location/desing/titles.sh" rturn
			
			echo "\t\t\t\t\t┌────────$line───────────────────┐"
			echo "\t\t\t\t\t│ Fecha: $fdate | Turno: Nocturno │"
			echo "\t\t\t\t\t└────────$line───────────────────┘"
			
			echo "\t\t\t\t┌──────────────────────────────────────────$ql─┐"
			echo "\t\t\t\t│ Cantidad de funcionarios que asistieron: $quantity │"
			echo "\t\t\t\t└──────────────────────────────────────────$ql─┘\n"
			
			mysql -uroot -proot -D 'proyecto' -e "
			select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
			epersona.primer_apellido as 'Apellido', horarios_marcados.m_entrada as 'Marca de Entrada',
			horarios_marcados.m_salida as 'Marca de Salida', motivo.motivo as 'Motivo' 
			from horarios_marcados, epersona, motivo
			where epersona.CI=horarios_marcados.CI and horarios_marcados.ID_motivo=motivo.ID_motivo and
			horarios_marcados.m_entrada<='23:50' and 
			horarios_marcados.m_entrada>='18:00' and horarios_marcados.fecha='$fecha';" | tr "\t" ";" | column -s ';' -t ) > "$files/turno_`date +%d-%m-%Y-%H:%M`"
		
		lp -o orientation-requested=4 -o media=A4 "$files/turno_`date +%d-%m-%Y-%H:%M`"

	
###################### Logs

sh "$location/log.sh" "Imprimió informe - Diario por turno"
			
			else
				sh "$location/desing/message_box.sh" nodata
				blnturn=1
			fi
		;;
	
		*)
			sh "$location/desing/message_box.sh" incorrect
		;;
	
		esac
	done
	
	else
			echo "\t\t\t\t\t Fecha invalida"
	echo "\t\t\t---------------------------------------------------------------------------------------------------"
	
	fi
done
