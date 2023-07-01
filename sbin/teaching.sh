#!/bin/bash

##################### Comienza el ingreso de carácter 

	echo "
	\t\t\t┌────────────┐ ┌────────────┐ ┌────────────┐ 
	\t\t\t│ 1-Efectivo │ │ 2-Interino │ │ 3-Suplente │
	\t\t\t└────────────┘ └────────────┘ └────────────┘
	"
	
blncharacter=0
until [ $blncharacter -eq 1 ];do
	
	echo -n "\t\t\t"; read -p "*Elija un carácter: " character
	
	case $character in 
	
	1)
		if [ $2 -eq 0 ];then
			
			mysql -uroot -proot -D 'proyecto' -e "
			insert into docente(CI,caracter) value($1,'Efectivo');"
			blncharacter=1
		else
			mysql -uroot -proot -D 'proyecto' -e "
			update from docente set caracter='Efectivo' where="$1";"
		fi
	;;
	
	2)
		if [ $2 -eq 0 ];then
			
			mysql -uroot -proot -D 'proyecto' -e "
			insert into docente(CI,caracter) value($1,'Interino');"
			blncharacter=1
		else
			mysql -uroot -proot -D 'proyecto' -e "
			update from docente set caracter='Interino' where="$1";"
		fi
	;;
	
	3)
		if [ $2 -eq 0 ];then
			
			mysql -uroot -proot -D 'proyecto' -e "
			insert into docente(CI,caracter) value($1,'Suplente');"
			blncharacter=1
		else
			mysql -uroot -proot -D 'proyecto' -e "
			update from docente set caracter='Suplente' where="$1";"
		fi
	;;
	
	*)
		echo "\t\t\t\t\t\t Opción incorrecta"
		echo "\t\t\t----------------------------------------------------------------------"
	;;
	
	esac
done

