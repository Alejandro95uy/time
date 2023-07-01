#!/bin/bash

################### Comienza el ingreso de cargo


	echo "
	┌──────────┐ ┌───────────────┐ ┌─────────────────┐ ┌───────────┐ ┌───────────────┐ ┌───────────┐ 
	│1-Auxiliar│ │2-Administrador│ │3-Educadores(UAL)│ │4-Adscripto│ │5-Laboratorista│ │6-Dirección│
	└──────────┘ └───────────────┘ └─────────────────┘ └───────────┘ └───────────────┘ └───────────┘
	"
blnnon=0
until [ $blnnon -eq 1 ];do

	echo -n "\t\t\t"; read -p "*Elija un cargo: " position
	
	case $position in
	
	1)		
		mysql -uroot -proot -D 'proyecto' -e "insert into no_docente(CI,cargo) values ($1,'Auxiliar');"
		blnnon=1
	;;
	
	2)		
		mysql -uroot -proot -D 'proyecto' -e "insert into no_docente(CI,cargo) values ($1,'Administrador');"
		blnnon=1
	;;
	
	3)		
		mysql -uroot -proot -D 'proyecto' -e "insert into no_docente(CI,cargo) values ($1,'Educadores(UAL)');"
		blnnon=1
	;;
	
	4)		
		mysql -uroot -proot -D 'proyecto' -e "insert into no_docente(CI,cargo) values ($1,'Adscripto');"
		blnnon=1
	;;
	
	5)		
		mysql -uroot -proot -D 'proyecto' -e "insert into no_docente(CI,cargo) values ($1,'Laboratorista');"
		blnnon=1
	;;
	
	6)		 
		mysql -uroot -proot -D 'proyecto' -e "insert into no_docente(CI,cargo) values ($1,'Dirección');"
		blnnon=1
	;;
	
	*)
		echo "\t\t\t\t Opción incorrecta"
		echo "\t\t\t----------------------------------------------------------------------"
	;;
	
	esac
done

