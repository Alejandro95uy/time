#!/bin/bash

#################### localización de la carpeta temporal y principal

location=$( cat "/tmp/location" )
temp="/tmp/Undefined Project/search"

################### función si es letras

isletter(){
	
	echo "$1" > "$temp/letter"
	digit=$( grep "[[:digit:]]" "$temp/letter" )
	punct=$( grep "[[:punct:]]" "$temp/letter" )
	cntrl=$( grep "[[:cntrl:]]" "$temp/letter" )

	if [ -z "$digit" ] && [ -z "$punct" ] && [ -z "$cntrl" ];then
		rm "$temp/letter"
		return 1
	fi
}

################# función si es número

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


blnsearch=0
whsearch=0
while [ $whsearch -eq 0 ];do

clear
sh "$location/desing/titles.sh" search

############################################# Cédula de identidad

echo "\t\t\t (La cédula de identidad ingréselo sin puntos ni guiones )"
echo "\t\t\t----------------------------------------------------------------------"
echo -n "\t\t\t"; read -p "Cédula de identidad: " sidcard

##################################### solo cédula de identidad								

if [ -n "$sidcard" ];then
	if [ ${#sidcard} -eq 8 ];then
		isnumeric "$sidcard"
		if [ $? -eq 1 ];then
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where CI=$sidcard;" > "$temp/countid"
			sidcount=$( wc -c "$temp/countid" | cut -c 1,2 )
		else
			sidcount=1
			echo "\t\t\t\tCédula Invalida"
			sh "$location/desing/wait.sh"
		fi
	else
			sidcount=1
			echo "\t\t\t\t Cédula Invalida"
			sh "$location/desing/wait.sh"
	fi
else
	sidcount=0
fi

############################################### si no hay coincidencia con la cédula

if [ $sidcount -eq 0 ];then

############################################## Primer nombre

echo "\t\t\t----------------------------------------------------------------------"						
echo -n "\t\t\t"; read -p "Primer nombre: " sname1					

############################################## Solo Primer nombre

if [ -n "$sname1" ];then
									
	isletter "$sname1"
	if [ $? -eq 1 ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where primer_nombre='$sname1';" > "$temp/countsn1"
		sn1count=$( sed -n 2p "$temp/countsn1" )
	
		if [ $sn1count -eq 1 ];then
					
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where primer_nombre='$sname1';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
			blnsearch=1
			whsearch=1
		fi
	else
		echo "\t\t\t\t Nombre invalido"
		sh "$location/desing/wait.sh"
		blnsearch=1
	fi
fi

if [ $blnsearch -ne 1 ];then

############################################# segundo nombre

echo "\t\t\t----------------------------------------------------------------------"						
echo -n "\t\t\t"; read -p "Segundo nombre: " sname2

	isletter "$sname2"
	if [ $? -eq 1 ];then								

################ solo segundo nombre

	if [ -z "$sname1" ] && [ -n "$sname2" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where segundo_nombre='$sname2';" > "$temp/countsn2_1"
		sn2count_1=$( sed -n 2p "$temp/countsn2_1" )
	
		if [ $sn2count_1 -eq 1 ];then
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where segundo_nombre='$sname2';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
			blnsearch=1
			whsearch=1
		fi
	fi

################################################ con primer y segundo nombre

	if [ -n "$sname1" ] && [ -n "$sname2" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where primer_nombre='$sname1' and 
		segundo_nombre='$sname2';" > "$temp/countsn2_2"
		sn2count_2=$( sed -n 2p "$temp/countsn2_2" )
	
		if [ $sn2count_2 -eq 1 ];then
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where primer_nombre='$sname1' and 
			segundo_nombre='$sname2'" | sed -n 2p > "/tmp/Undefined Project/sidcard"
			blnsearch=1
			whsearch=1
		fi
	fi
	else
		echo "\t\t\t\t Nombre invalido"
		sh "$location/desing/wait.sh"
		blnsearch=1
	fi
fi

if [ $blnsearch -ne 1 ];then

################################################################ Primer Apellido

echo "\t\t\t----------------------------------------------------------------------"		
echo -n "\t\t\t"; read -p "Primer apellido: " ssurname1	

	isletter "$ssurname1"
	if [ $? -eq 1 ];then
	
################################################ solo primer apellido			

	if [ -z "$sname1" ] && [ -z "$sname2" ] && [ -n "$ssurname1" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where primer_apellido='$ssurname1';" > "$temp/countssn1_1"
		ssn1count_1=$( sed -n 2p "$temp/countssn1_1" )

		if [ $ssn1count_1 -eq 1 ];then
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where primer_apellido='$ssurname1';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
			blnsearch=1
			whsearch=1
		fi
	fi
	
################################################# con segundo nombre y primer apellido
	
	if [ -z "$sname1" ] && [ -n "$sname2" ] && [ -n "$ssurname1" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where segundo_nombre='$sname2' 
		and primer_apellido='$ssurname1';" > "$temp/countssn1_2"
		ssn1count_2=$( sed -n 2p "$temp/countssn1_2" )
	
		if [ $ssn1count_2 -eq 1 ];then
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where segundo_nombe='$sname2' and 
			primer_apellido='$ssurname1';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
			blnsearch=1
			whsearch=1
		fi
	
	fi

################################################## con primer nombre y primer apellido

	if [ -n "$sname1" ] && [ -z "$sname2" ] && [ -n "$ssurname1" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where primer_nombre='$sname1' 
		and primer_apellido='$ssurname1';" > "$temp/countssn1_3"
		ssn1count_3=$( sed -n 2p "$temp/countssn1_3" )
	
		if [ $ssn1count_3 -eq 1 ];then
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where primer_nombre='$sname1' 
			and primer_apellido='$ssurname1'" | sed -n 2p > "/tmp/Undefined Project/sidcard"
			blnsearch=1
			whsearch=1
		fi
	fi

############################################### con primer y segundo nombre y primer apellido

	if [ -n "$sname1" ] && [ -n "$sname2" ] && [ -n "$ssurname1" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where primer_nombre='$sname1' and 
		segundo_nombre='$sname2' and primer_apellido='$ssurname1';" > "$temp/countssn1_4"
		ssn1count_4=$( sed -n 2p "$temp/countssn1_4" )
	
		if [ $ssn1count_4 -eq 1 ];then
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where primer_nombre='$sname1' and 
			segundo_nombre='$sname2' and primer_apellido='$surname1';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
			blnsearch=1
			whsearch=1
		fi
	fi
	else
		echo "\t\t\t\t Apellido invalido"
		sh "$location/desing/wait.sh"
		blnsearch=1
	fi
fi

if [ $blnsearch -ne 1 ];then

################################################## Segundo Apellido

echo "\t\t\t----------------------------------------------------------------------"								
echo -n "\t\t\t"; read -p "Segundo apellido: " ssurname2

	isletter "$ssurname2"
	if [ $? -eq 1 ];then

######################################################## solo segundo apellido									

	if [ -z "$sname1" ] && [ -z "$sname2" ] && [ -z "$ssurname1" ] && [ -n "$surname2" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where segundo_apellido='$ssurname2';" > "$temp/countssn2_1"
		ssn2count_1=$( sed -n 2p "$temp/countssn2_1" )
	
		if [ $ssn2count_1 -eq 1 ];then
			
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where segundo_nombre='$ssurname2'" | sed -n 2p > "/tmp/Undefined Project/sidcard"
			blnsearch=1
			whsearch=1
		fi
	fi

############################################### con segundo nombre, primer y segundo apellido
	
	if [ -z "$sname1" ] && [ -n "$sname2" ] && [ -n "$ssurname1" ] && [ -n "$ssurname2" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where segundo_nombre='$sname2' 
		and primer_apellido='$ssurname1' and segundo_apellido='$ssurname2';" | sed -n 2p > "$temp/countssn2_2" 
		ssn2count_2=$( sed -n 2p "$temp/countssn2_2" )
	
		if [ $ssn2count_2 -eq 1 ];then
				
			blnsearch=1
			whsearch=1
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where segundo_nombre='$sname2' and
			 primer_apellido='$ssurname1' and segundo_apellido='$ssurname2';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
		fi
	fi

############################################# con primer nombre, primer y segundo apellido

	if [ -n "$sname1" ] && [ -z "$sname2" ] && [ -n "$ssurname1" ] && [ -n "$ssurname2" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where primer_nombre='$sname1' 
		and primer_apellido='$ssurname1' and segundo_apellido='$ssurname2';" > "$temp/countssn2_3"
		ssn2count_3=$( sed -n 2p "$temp/countssn2_3" )
	
		if [ $ssn2count_3 -eq 1 ];then
				
			blnsearch=1
			whsearch=1
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where primer_nombre='$sname1' 
			and primer_apellido='$ssurname1' and segundo_apellido='$ssurname2';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
		fi
	fi

############################################### con primer y segundo nombre y segundo apellido

	if [ -n "$sname" ] && [ -n "$sname2" ] && [ -z "$ssurname1" ] && [ -n "$surname2" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where primer_nombre='$sname1' and 
		segundo_nombre='$sname2' and segundo_apellido='$ssurname';" > "$temp/countssn2_4"
		ssn2count_4=$( sed -n 2p "$temp/countssn2_4" )
	
		if [ $ssn2count_4 -eq 1 ];then
				
			blnsearch=1
			whsearch=1
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where primer_nombre='$sname1' and 
			segundo_nombre='$sname2' and segundo_apellido='$surname2';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
		fi
	fi

################################################ con primer y segundo nombre y primer apellido

	if [ -n "$sname1" ] && [ -n "$sname2" ] && [ -n "$ssurname1" ] && [ -z "$ssurname2" ] ;then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where primer_nombre='$sname1' and 
		segundo_nombre='$sname2' and primer_apellido='$ssurname1';" > "$temp/countssn2_5"
		ssn2count_5=$( sed -n 2p "$temp"/countssn2_5 )
	
		if [ $ssn2count_5 -eq 1 ];then
				
			blnsearch=1
			whsearch=1
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where primer_nombre='$sname1' 
			and segundo_nombre='$sname2' and primer_apellido='$ssurname1';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
		fi
	fi
	
############################################### con primer nombre y segundo apellido
	
	if [ -n "$sname1" ] && [ -z "$sname2" ] && [ -z "$ssurname1" ] && [ -n "$ssurname2" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where primer_nombre='$sname1' 
		and segundo_apellido='$ssurname2';" > "$temp/countssn2_6"
		ssn2count_6=$( sed -n 2p "$temp/countssn2_6" )
		
		if [ $ssn2count_6 -eq 1 ];then
				
			blnsearch=1
			whsearch=1
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where primer_nombre='$sname1' and 
			segundo_apellido='$ssurname2';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
		fi
	fi
									
######################################### con primer y segundo nombre, primer y segundo apellido

	if [ -n "$sname1" ] && [ -n "$sname2" ] && [ -n "$ssurname1" ] && [ -n "$ssurname" ];then
			
		mysql -uroot -proot -D 'proyecto' -e "
		select count(CI) from epersona where primer_nombre='$sname1' and 
		segundo_nombre='$sname2' and primer_apellido='$ssurname1' and 
		segundo_apellido='$ssurname2';" > "$temp/countssn2_7"
		ssn2count_7=$( sed -n 2p "$temp/countssn2_7" )
	
		if [ $ssn2count_7 -eq 1 ];then
				
			blnsearch=1
			whsearch=1
				
			mysql -uroot -proot -D 'proyecto' -e "
			select CI from epersona where priemr_nombre='$sname1' and 
			segundo_nombre='$sname2' and primer_apellido='$ssurname1' and 
			segundo_apellido='$ssurname2';" | sed -n 2p > "/tmp/Undefined Project/sidcard"
		fi
	fi
	else
		echo "\t\t\t\t Apellido invalido"
		sh "$location/desing/wait.sh"
		blnsearch=1
	fi
fi

######################################################### Todos los campos

if [ $blnsearch -ne 1 ];then
		
	mysql -uroot -proot -D 'proyecto' -e "
	select CI as 'Cédula de Identidad', primer_nombre as 'Primer Nombre', segundo_nombre as 'Segundo Nombre',
	primer_apellido as 'Primer Apellido', segundo_apellido as 'Segundo Apellido' 
	from epersona where primer_nombre='$sname1' or segundo_nombre='$sname2'
	or primer_apellido='$ssurname1' or segundo_apellido='$ssurname2';"
	 
	mysql -uroot -proot -D 'proyecto' -e "
	select * from epersona where primer_nombre='$sname1' or segundo_nombre='$sname2'
	or primer_apellido='$ssurname1' or segundo_apellido='$ssurname2';" > "$temp/result"
	 result=$( cat "$temp/result" )
	 
	 if [ -n "$result" ];then
	 
########################################### Ingreso de cédula para varios resultados

	echo "\t\t\t----------------------------------------------------------------------"
	echo -n "\t\t\t"; read -p "Ingrese la Cédula de identidad que esta buscando: " searchid
			
			if [ -n "$searchid" ];then
					
				mysql -uroot -proot -D 'proyecto' -e "
				select CI from epersona where CI=$searchid;" | sed -n 2p > "/tmp/Undefined Project/sidcard"
				correct=$( cat "/tmp/Undefined Project/sidcard" )
				
				if [ -n $correct ];then
					
					blnsearch=1
					whsearch=1
				else
					echo "\t\t\t\t Cédula incorrecta"
					sh "$location/desing/wait.sh"
				fi
			else
				echo "\t\t\t\t Cédula invalida"
				sh "$location/desing/wait.sh"
					#blnsearch=1
					#whsearch=1
				
			fi
	else
		echo "\t\t\t\t No se a encontrado coincidencia"
		sh "$location/desing/wait.sh"
	fi
fi

####################################### Encontrado por la CI

elif [ $sidcount -eq 1 ];then
	echo
else		
	mysql -uroot -proot -D 'proyecto' -e "
	select CI from epersona where CI=$sidcard;" | sed -n 2p > "/tmp/Undefined Project/sidcard"
	whsearch=1
fi
done

