#!/bin/bash/

###################### Localizar carpeta principal y temporal

location=$( cat "/tmp/location" )
temp="/tmp/Undefined Project/report"
files="/home/`whoami`/.time/print"

blnrmo=0
until [ $blnrmo -eq 1 ];do

########################## Comienza el informe por motivo

	clear
	sh "$location/desing/titles.sh" rmotive
	
	
	count=$( mysql -uroot -proot -D 'proyecto' -e "
	select count(motivo) from motivo;" | sed -n 2p )
	
	if [ $count -ne 0 ];then
		
###################### Muestra motivos

		for loop in `seq 1 $count` ;do
		
			nro=$(( $loop + 1 ))
			
			mot=$( mysql -uroot -proot -D 'proyecto' -e "
				select motivo as 'Motivos' from motivo;" | sed -n $nro\p )
			
			line=""
				
				for i in `seq 1 ${#mot}` ;do
				
					line="$line─"
				
				done
				
			linen=""
				for i in `seq 1 ${#loop}` ;do
				
					linen="$linen─"
				
				done	
			
			echo "$loop;$mot" >> "$temp/motivos"
				
			echo "\t\t\t\t┌──$linen$line─┐"
			echo "\t\t\t\t│ $loop-$mot │"
			echo "\t\t\t\t└──$linen$line─┘"
		done

################### Ingrese motivo
	
	echo -n "\t\t\t"; read -p "Elija un motivo: " option
	
	if [ $option -gt 0 ] && [ $option -le $loop ];then
	
########################## Extra datos del motivo elegido

		nline=$( cut -d ";" -f 1 "$temp/motivos" | grep -n $option | cut -d ":" -f 1 )
		
		motive=$( sed -n $nline\p "$temp/motivos" | cut -d ";" -f 2 )
		
		idmotive=$( mysql -uroot -proot -D 'proyecto' -e "
			select ID_motivo from motivo where motivo='$motive';" | sed -n 2p )
	
			rm "$temp/motivos"
			
			count1=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(distinct(fecha)) from horarios_marcados 
				where ID_motivo=$idmotive;" | sed -n 2p )
				
			if [ $count1 -eq 1 ];then

####################### Muestra resultado en caso de ver una fecha
				
				quantity=$( mysql -uroot -proot -D 'proyecto' -e "
					select count(distinct(CI)) from horarios_marcados 
					where ID_motivo='$idmotive';"| sed -n 2p )
			
				unset ql
				
				for i in `seq 1 ${#quantity}` ;do
				
					ql="$ql─"
				
				done
				
				lmot=""
				for i in `seq 1 ${#motive}` ;do
				
					lmot="$lmot─"
				
				done
				
				clear
				sh "$location/desing/titles.sh" rmotive
			
				echo "\t\t\t\t\t┌─────────$lmot─┐"
				echo "\t\t\t\t\t│ Motivo: $motive │"
				echo "\t\t\t\t\t└─────────$lmot─┘"
			
				echo "\t\t\t\t┌──────────────────────────────────────────$ql─┐"
				echo "\t\t\t\t│ Cantidad de funcionarios que asistieron: $quantity │"
				echo "\t\t\t\t└──────────────────────────────────────────$ql─┘\n"
				
				mysql -uroot -proot -D 'proyecto' -e "
				select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
				epersona.primer_apellido as 'Apellido', date_format(horarios_marcados.fecha,'%e/%c/%Y') as 'Fecha', 
				horarios_marcados.m_entrada as 'Marca de Entrada', horarios_marcados.m_salida as 'Marca de Salida', 
				motivo.motivo as 'Motivo'
				from horarios_marcados, epersona, motivo 
				where motivo.ID_motivo=horarios_marcados.ID_motivo and horarios_marcados.CI=epersona.CI and
				horarios_marcados.ID_motivo=$idmotive;"
				
				
				sh "$location/desing/wait.sh"
			
				blnrmo=1
				blndate=1

###################### Logs

sh "$location/log.sh" "Generó informe - Diario por motivo"
				
				(sh "$location/desing/titles.sh" rmotive
			
				echo "\t\t\t\t\t┌─────────$lmot─┐"
				echo "\t\t\t\t\t│ Motivo: $motive │"
				echo "\t\t\t\t\t└─────────$lmot─┘"
			
				echo "\t\t\t\t┌──────────────────────────────────────────$ql─┐"
				echo "\t\t\t\t│ Cantidad de funcionarios que asistieron: $quantity │"
				echo "\t\t\t\t└──────────────────────────────────────────$ql─┘\n"
				
				mysql -uroot -proot -D 'proyecto' -e "
				select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
				epersona.primer_apellido as 'Apellido', date_format(horarios_marcados.fecha,'%e/%c/%Y') as 'Fecha', 
				horarios_marcados.m_entrada as 'Marca de Entrada', horarios_marcados.m_salida as 'Marca de Salida', 
				motivo.motivo as 'Motivo'
				from horarios_marcados, epersona, motivo 
				where motivo.ID_motivo=horarios_marcados.ID_motivo and horarios_marcados.CI=epersona.CI and
				horarios_marcados.ID_motivo=$idmotive;" | tr "\t" ";" | column -s ';' -t ) > "$files/motivo_`date +%d-%m-%Y-%H:%M`"
				lp -o orientation-requested=4 -o media=A4 "$files/motivo_`date +%d-%m-%Y-%H:%M`"

	
###################### Logs

sh "$location/log.sh" "Imprimió informe - Diario por motivo"			
			
			elif [ $count1 -eq 0 ];then
				
				sh "$location/desing/message_box.sh" nodata
			else
			
########################### En caso de ser varias fechas

			blndate=0
			until [ $blndate -eq 1 ];do
				
				clear
				sh "$location/desing/titles.sh" rmotive
				
				lmot=""
				for i in `seq 1 ${#motive}` ;do
				
					lmot="$lmot─"
				
				done
				
				echo "\t\t\t\t┌─$lmot─┐"
				echo "\t\t\t\t│ $motive │"
				echo "\t\t\t\t└─$lmot─┘"
				
				for loop in `seq 1 $count1` ;do
		
					l=$(( $loop + 1 ))
		
					fdte=$( mysql -uroot -proot -D 'proyecto' -e "
						select distinct(date_format(fecha,'%d/%m/%Y')) as 'Fecha' 
						from horarios_marcados where ID_motivo=$idmotive;" | sed -n $l\p )
				
					line=""
					
						for i in `seq 1 ${#fdte}` ;do
				
							line="$line─"
				
						done
					
					linen=""
					
						for i in `seq 1 ${#loop}` ;do
				
							linen="$linen─"
				
						done	
			
					echo "$loop;$fdte" >> "$temp/fechas"
				
					echo "\t\t\t\t┌──$linen$line─┐"
					echo "\t\t\t\t│ $loop-$fdte │"
					echo "\t\t\t\t└──$linen$line─┘"
				
				done
		
			echo -n "\t\t\t"; read -p "Elija una fecha: " opt

			if [ $option -gt 0 ] && [ $opt -le $loop ];then

##################### Extraer datos de la fecha elegida
	
				nline1=$( cut -d ";" -f 1 "$temp/fechas" | grep -n $opt | cut -d ":" -f 1 )
		
				fech=$( sed -n $nline1\p "$temp/fechas" | cut -d ";" -f 2 )
		
				fecha=$( mysql -uroot -proot -D 'proyecto' -e "
					select date_format(fecha,'%d/%m/%Y') from horarios_marcados 
					where date_format(fecha,'%d/%m/%Y')='$fech' 
					and ID_motivo='$idmotive';" | sed -n 2p )
		
				rm "$temp/fechas"
		
				if [ -n "$fecha" ];then	
		
##################### Muestra resultado en caso de ver varias fecha
			
			quantity=$( mysql -uroot -proot -D 'proyecto' -e "
			select count(distinct(CI)) from horarios_marcados 
			where ID_motivo='$idmotive' and 
			date_format(horarios_marcados.fecha,'%d/%m/%Y')='$fecha';" | sed -n 2p )
			
			for i in `seq 1 ${#quantity}` ;do
				
				ql="$ql─"
				
			done
			
			clear
			sh "$location/desing/titles.sh" rmotive
			
			echo "\t\t\t\t    ┌─────────$lmot──────────$line─┐"
			echo "\t\t\t\t    │ Motivo: $motive | Fecha: $fdte │"
			echo "\t\t\t\t    └─────────$lmot──────────$line─┘"
			
			echo "\t\t\t\t┌──────────────────────────────────────────$ql─┐"
			echo "\t\t\t\t│ Cantidad de funcionarios que asistieron: $quantity │"
			echo "\t\t\t\t└──────────────────────────────────────────$ql─┘\n"
			
			mysql -uroot -proot -D 'proyecto' -e "
			select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
			epersona.primer_apellido as 'Apellido',
			horarios_marcados.m_entrada as 'Marca de Entrada', horarios_marcados.m_salida as 'Marca de Salida'
			from horarios_marcados, epersona, motivo 
			where motivo.ID_motivo=horarios_marcados.ID_motivo and horarios_marcados.CI=epersona.CI and
			horarios_marcados.ID_motivo='$idmotive' and date_format(horarios_marcados.fecha,'%d/%m/%Y')='$fecha';"
			
				sh "$location/desing/wait.sh"
			
				blnrmo=1
				blndate=1
	
###################### Logs

sh "$location/log.sh" "Generó informe - Diario por motivo"

	
			( sh "$location/desing/titles.sh" rmotive
			
			echo "\t\t\t\t    ┌─────────$lmot──────────$line─┐"
			echo "\t\t\t\t    │ Motivo: $motive | Fecha: $fdte │"
			echo "\t\t\t\t    └─────────$lmot──────────$line─┘"
			
			echo "\t\t\t\t┌──────────────────────────────────────────$ql─┐"
			echo "\t\t\t\t│ Cantidad de funcionarios que asistieron: $quantity │"
			echo "\t\t\t\t└──────────────────────────────────────────$ql─┘\n"
			
			mysql -uroot -proot -D 'proyecto' -e "
			select horarios_marcados.CI as 'Cédula de Identidad', epersona.primer_nombre as 'Nombre',
			epersona.primer_apellido as 'Apellido',
			horarios_marcados.m_entrada as 'Marca de Entrada', horarios_marcados.m_salida as 'Marca de Salida'
			from horarios_marcados, epersona, motivo 
			where motivo.ID_motivo=horarios_marcados.ID_motivo and horarios_marcados.CI=epersona.CI and
			horarios_marcados.ID_motivo='$idmotive' and 
			date_format(horarios_marcados.fecha,'%d/%m/%Y')='$fecha';" | tr "\t" ";" | column -s ';' -t ) > "$files/motivo_`date +%d-%m-%Y-%H:%M`"
			lp -o orientation-requested=4 -o media=A4 "$files/motivo_`date +%d-%m-%Y-%H:%M`"
	
###################### Logs

sh "$location/log.sh" "Imprimió informe - Diario por motivo"
				
				else
					sh "$location/desing/message_box.sh"
				fi
				
			else
				sh "$location/desing/message_box.sh" incorrect
			fi
			
		done
		
		fi
	
	else
		sh "$location/desing/message_box.sh" incorrect
	fi


		
	else
		sh "$location/desing/message_box.sh" motive
		blnrmo=1
	fi

done

