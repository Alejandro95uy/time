#!/bin/bash

########################### Localizar carpeta temporal y pincipal

location=$( cat "/tmp/location" )
temp="/tmp/Undefined Project/sbin"

	clear
	
	sh "$location/desing/titles.sh" delgro
	sh "$location/desing/menu.sh" course
	
	echo -n "\t\t\t"; read -p "Elija un curso: " course
	case $course in
		
###################### Eliminando grupo del curso CBT

	1)
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group

		mysql -uroot -proot -D 'proyecto' -e "
		select count(ID_grupo) from grupo where nombre_grupo='$group'" > "$temp/countgro"
		grocount=$( sed -n 2p "$temp/countgro" )
			
		if [ $grocount -eq 1 ];then

			idgro=$( mysql -uroot -proot -D 'proyecto' -e "
			select ID_grupo from grupo where nombre_grupo='$group';" | sed -n 2p )
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from componen where ID_grupo =$idgro;"
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from dictan where ID_grupo=$idgro;"
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from grupo where nombre_grupo='$group';"
			
		else
			echo "\t\t\t\t\t Grupo ya eliminado"
			sh "$location/desing/wait.sh"
		fi
		
	;;

###################### Eliminando grupo del curso FPB
		
	2)
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group

		mysql -uroot -proot -D 'proyecto' -e "
		select count(ID_grupo) from grupo where nombre_grupo='$group'" > "$temp/countgro"
		grocount=$( sed -n 2p "$temp/countgro" )
			
		if [ $grocount -eq 1 ];then

			idgro=$( mysql -uroot -proot -D 'proyecto' -e "
			select ID_grupo from grupo where nombre_grupo='$group';" | sed -n 2p )
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from componen where ID_grupo =$idgro;"
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from dictan where ID_grupo=$idgro;"

			mysql -uroot -proot -D 'proyecto' -e "
			delete from grupo where nombre_grupo='$group';"
		else
			echo "\t\t\t\t\t Grupo ya eliminado"
			sh "$location/desing/wait.sh"
		fi
		
	;;
	
###################### Eliminando grupo del curso EMP
		
	3)
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group

		mysql -uroot -proot -D 'proyecto' -e "
		select count(ID_grupo) from grupo where nombre_grupo='$group'" > "$temp/countgro"
		grocount=$( sed -n 2p "$temp/countgro" )
			
		if [ $grocount -eq 1 ];then

			idgro=$( mysql -uroot -proot -D 'proyecto' -e "
			select ID_grupo from grupo where nombre_grupo='$group';" | sed -n 2p )
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from componen where ID_grupo =$idgro;"
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from dictan where ID_grupo=$idgro;"

			mysql -uroot -proot -D 'proyecto' -e "
			delete from grupo where nombre_grupo='$group';"
		else
			echo "\t\t\t\t\t Grupo ya eliminado"
			sh "$location/desing/wait.sh"
		fi
	;;
	
###################### Eliminando grupo del curso EMT
		
	4)
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group

		mysql -uroot -proot -D 'proyecto' -e "
		select count(ID_grupo) from grupo where nombre_grupo='$group'" > "$temp/countgro"
		grocount=$( sed -n 2p "$temp/countgro" )

		if [ $grocount -eq 1 ];then

			idgro=$( mysql -uroot -proot -D 'proyecto' -e "
			select ID_grupo from grupo where nombre_grupo='$group';" | sed -n 2p )
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from componen where ID_grupo =$idgro;"
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from dictan where ID_grupo=$idgro;"

			mysql -uroot -proot -D 'proyecto' -e "
			delete from grupo where nombre_grupo='$group';"
		else
			echo "\t\t\t\t\t Grupo ya eliminado"
			sh "$location/desing/wait.sh"
		fi
		
	;;
	
###################### Eliminando grupo del curso BP
		
	5)
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group

		mysql -uroot -proot -D 'proyecto' -e "
		select count(ID_grupo) from grupo where nombre_grupo='$group'" > "$temp/countgro"
		grocount=$( sed -n 2p "$temp/countgro" )
			
		if [ $grocount -eq 1 ];then
			idgro=$( mysql -uroot -proot -D 'proyecto' -e "
			select ID_grupo from grupo where nombre_grupo='$group';" | sed -n 2p )
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from componen where ID_grupo =$idgro;"
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from dictan where ID_grupo=$idgro;"

			mysql -uroot -proot -D 'proyecto' -e "
			delete from grupo where nombre_grupo='$group';"
		else
			echo "\t\t\t\t\t Grupo ya eliminado"
			sh "$location/desing/wait.sh"
		fi
	;;
	
###################### Eliminando grupo del curso CTT
	
	6)
		echo -n "\t\t\t"; read -p "Nombre del grupo: " group

		mysql -uroot -proot -D 'proyecto' -e "
		select count(ID_grupo) from grupo where nombre_grupo='$group'" > "$temp/countgro"
		grocount=$( sed -n 2p "$temp/countgro" )
			
		if [ $grocount -eq 1 ];then

			idgro=$( mysql -uroot -proot -D 'proyecto' -e "
			select ID_grupo from grupo where nombre_grupo='$group';" | sed -n 2p )
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from componen where ID_grupo =$idgro;"
			
			mysql -uroot -proot -D 'proyecto' -e "
			delete from dictan where ID_grupo=$idgro;"

			mysql -uroot -proot -D 'proyecto' -e "
			delete from grupo where nombre_grupo='$group';"
		else
			echo "\t\t\t\t\t Grupo ya eliminado"
			sh "$location/desing/wait.sh"
		fi
	;;
		
	*)
	 	sh "$location/desing/message_box.sh" incorrect	
	;;
		
	esac
					
########################################## log

		sh "$location/log.sh" "Borró Grupo"
		

