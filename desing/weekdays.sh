#!/bin/bash

monday(){
echo "
	\t  ╔═══════════╗ -------------- ----------------- -------------- --------------- --------------
	\t  ║   Lunes   ║ |   Martes   | |   Miércoles   | |   Jueves   | |   Viernes   | |   Sábado   | 
	\t╔═╝           ╚════════════════════════════════════════════════════════════════════════════════════════╗
	"
	return 1
}

tuesday(){
echo "
	\t  ------------- ╔════════════╗ ----------------- -------------- --------------- --------------
	\t  |   Lunes   | ║   Martes   ║ |   Miércoles   | |   Jueves   | |   Viernes   | |   Sábado   | 
	\t╔═══════════════╝            ╚═════════════════════════════════════════════════════════════════════════╗
	"
	return 1
}

wednesday(){
echo "
	\t  ------------- -------------- ╔═══════════════╗ -------------- --------------- --------------
	\t  |   Lunes   | |   Martes   | ║   Miércoles   ║ |   Jueves   | |   Viernes   | |   Sábado   | 
	\t╔══════════════════════════════╝               ╚═══════════════════════════════════════════════════════╗
	"
	return 1
}

thursday(){
echo "
	\t  ------------- -------------- ----------------- ╔════════════╗ --------------- --------------
	\t  |   Lunes   | |   Martes   | |   Miércoles   | ║   Jueves   ║ |   Viernes   | |   Sábado   | 
	\t╔════════════════════════════════════════════════╝            ╚════════════════════════════════════════╗
	"
	return 1
}

friday(){
echo "
	\t  ------------- -------------- ----------------- -------------- ╔═════════════╗ --------------
	\t  |   Lunes   | |   Martes   | |   Miércoles   | |   Jueves   | ║   Viernes   ║ |   Sábado   | 
	\t╔═══════════════════════════════════════════════════════════════╝             ╚════════════════════════╗
	"
	return 1
}

saturday(){
echo "
	\t  ------------- -------------- ----------------- -------------- --------------- ╔════════════╗
	\t  |   Lunes   | |   Martes   | |   Miércoles   | |   Jueves   | |   Viernes   | ║   Sábado   ║ 
	\t╔═══════════════════════════════════════════════════════════════════════════════╝            ╚═════════╗
	"
	return 1
}
	$1
	if [ $? -ne 1 ];then
		
		location=$( cat "/tmp/location" )
		sh "$location/desing/message_box.sh" incorrect
	fi
	
