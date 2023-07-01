#!/bin/bash

####################### Localización de la carpeta temporal y principal 

temp="/tmp/Undefined Project/sbin"
location=$( cat "/tmp/location" )

################### Función Mostrar datos

data(){
	
	idcard=$( cat "/tmp/Undefined Project/sidcard" )
	
######################## Búsqueda de datos
		 
	mysql -uroot -proot -D 'proyecto' -e "
	select * from persona where CI='$idcard';" | sed -n 2p | tr "\t" ";" > "$temp/person"
	
	   name1=$( cut -d ";" -f 2 "$temp/person" )
	   name2=$( cut -d ";" -f 3 "$temp/person" )
	surname1=$( cut -d ";" -f 4 "$temp/person" )
	surname2=$( cut -d ";" -f 5 "$temp/person" )
	
	character=$( mysql -uroot -proot -D 'proyecto' -e "
			select caracter from docente where CI='$idcard'" | sed -n 2p )
			
	subjects=$( mysql -uroot -proot -D 'proyecto' -e "
			select materia from materia where ID_materia=$2;" | sed -n 2p )
			
	group=$( mysql -uroot -proot -D 'proyecto' -e "
			select nombre_grupo from grupo where ID_grupo=$1;" | sed -n 2p )
			
	grade=$( mysql -uroot -proot -D 'proyecto' -e "
			select grado from grupo where ID_grupo=$1;" | sed -n 2p )
	clear
	sh "$location/desing/titles.sh" schedule

	name="Nombre: "$name1" "$name2" "$surname1" "$surname2" - Carácter: "$character""
	
	sg="Asignatura: "$subjects" | Grupo: "$group""
	


#################### Presentar datos
	
	echo "\t\t\t    ╔═══════════════════════════════════════════════════════════════════╗"
	echo "\t\t\t\t  $name"
	echo "\t\t\t     -------------------------------------------------------------------"
	echo "\t\t\t\t\t  \t $grade"
	echo "\t\t\t     -------------------------------------------------------------------"
	echo "\t\t\t\t\t  \t $sg "
	echo "\t\t\t    ╚═══════════════════════════════════════════════════════════════════╝"
	
	sh "$location/desing/weekdays.sh" "$3"
	
}

#################### comienzo del shell

	data $3 $4 $6
	
	sh "$location/desing/turn.sh" $1
	
	echo "\t\t\t ( Para dejar de ingresar Horas deje el campo en blanco y presione [ Enter ] )"
	echo "\t\t\t ---------------------------------------------------------------------------------------------------"

case $1 in

########################## Ingresos turno Matutino

morning)

	blnmor=0
	until [ "$blnmor" -eq 1 ];do
	
	echo -n "\t\t\t"; read -p "Elija un rango de Hora: " hours
	echo "\t\t\t ---------------------------------------------------------------------------------------------------"
	
	if [ -z "$hours" ];then
	
		blnmor=1
		echo "\n\t\t\t\t\t Agregados con Éxito \n"
		sh "$location/desing/wait.sh"
	else
		
		case $hours in 
	
			1)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='07:30' and salida='08:15' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'07:30','08:15','$5','Matutino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
					
				
				fi
			;;
		
			2)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='08:15' and salida='09:00' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'08:15','09:00','$5','Matutino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			3)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='09:05' and salida='09:50' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'09:05','09:50','$5','Matutino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			4)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='09:55' and salida='10:40' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'09:55','10:40','$5','Matutino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			5)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='10:45' and salida='11:30' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'10:45','11:30','$5','Matutino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			6)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='11:35' and salida='12:20' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'11:35','12:20','$5','Matutino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			7)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='12:20' and salida='13:05' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'12:20','13:05','$5','Matutino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			*)
				echo "\t\t\t\t\t Error Horas no existentes"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
			;;
		esac
	fi
	done
;;

################################# Ingreso de Turno vespertino

afternoon)

	blnaft=0
	until [ $blnaft -eq 1 ];do
	
	echo -n "\t\t\t"; read -p "Elija un rango de Hora: " hours
	echo "\t\t\t ---------------------------------------------------------------------------------------------------"
	
	if [ -z "$hours" ];then
		
		blnaft=1
		echo "\n\t\t\t\t\t Agregados con Éxito\n "
		sh "$location/desing/wait.sh"
	else
	
		case $hours in 
			0)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='12:35' and salida='13:20' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'12:35','13:20','$5')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			1)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='13:20' and salida='14:05' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'13:20','14:05','$5','Vespertino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			2)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='14:05' and salida='14:50' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'14:05','14:50','$5','Vespertino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			3)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='14:55' and salida='15:40' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'14:55','15:40','$5','Vespertino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			4)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente
				 where entrada='15:45' and salida='16:30' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'15:45','16:30','$5','Vespertino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			5)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='16:35' and salida='17:20' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'16:35','17:20','$5','Vespertino')"
				
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				fi
			;;
		
			6)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='17:25' and salida='18:10' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'17:25','18:10','$5','Vespertino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			7)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='18:10' and salida='18:50' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'18:10','18:50','$5','Vespertino')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			*)
				echo "\t\t\t\t\t Error Horas no existentes"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
			;;
		esac
	fi
	done
;;

########################## Ingreso de Turno Nocturno

evening)

	blneve=0
	until [ $blneve -eq 1 ];do
	
	echo -n "\t\t\t"; read -p "Elija un rango de Hora: " hours
	echo "\t\t\t ---------------------------------------------------------------------------------------------------"
	
	if [ -z "$hours" ];then
		
		blneve=1
		echo "\n\t\t\t\t\t Agregados con Éxito \n"
		sh "$location/desing/wait.sh"
	else
		case $hours in 	
			0)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='18:15' and salida='18:55' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'18:15','18:55','$5','Nocturno')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			1)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='19:00' and salida='19:40' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'19:00','19:40','$5','Nocturno')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			2)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='19:40' and salida='20:20' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'19:40','20:20','$5','Nocturno')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			3)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='20:25' and salida='21:05' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'20:25','21:05','$5','Nocturno')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			4)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='21:10' and salida='21:50' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'21:10','21:50','$5','Nocturno')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			5)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='21:55' and salida='22:35' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'21:55','22:35','$5','Nocturno')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			6)
				verify=$( mysql -uroot -proot -D 'proyecto' -e "
				select count(CI) from horarios_docente 
				where entrada='22:35' and salida='23:15' and CI='$2' and dia_semana='$5';" | sed -n 2p )
				
				if [ $verify -eq 0 ];then
				
					mysql -uroot -proot -D 'proyecto' -e "
					insert into horarios_docente(CI,ID_grupo,ID_materia,entrada,salida,dia_semana,turno)
					values ($2,$3,$4,'22:35','23:15','$5','Nocturno')"
				
				else
					
					echo "\t\t\t\t\t Error horas ya ingresadas"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
				
				fi
			;;
		
			*)
				echo "\t\t\t\t\t Error Horas no existentes"
		echo "\t\t\t ---------------------------------------------------------------------------------------------------"
			;;
		esac
	fi
	done
;;

##################### Error inesperado

*)
	sh "$location/desing/message_box.sh"
;;	
esac

					
########################################## log

	sh "$location/log.sh" "Asignó Horas - docente"
	
	
