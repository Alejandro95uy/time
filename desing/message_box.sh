#!/bin/bash

###################### Localizar carpeta principal

location=$( cat "/tmp/location" )

invalid(){
	
	clear
	echo " \n
		\t\t ┌──────────────────────────────────────┐
		\t\t │                                      │
		\t\t │   ✘ Cédula de identidad incorrecta   │
		\t\t │                                      │
		\t\t └──────────────────────────────────────┘
	"
	sh "$location/desing/wait.sh"
	return 1
}

incorrect(){

	clear
	echo "	\n
		\t\t ┌─────────────────────────────────┐
		\t\t │                                 │
		\t\t │   ✘ Esa opción no es correcta   │
		\t\t │                                 │
		\t\t └─────────────────────────────────┘
	"
	sh "$location/desing/wait.sh"
	return 1
}

boot(){

	clear
	echo "\n
	\t\t\t ┌─────────────────────────────┐
	\t\t\t │                             │
	\t\t\t │  Finalizando Configuración  │
	\t\t\t │                             │
	\t\t\t └─────────────────────────────┘
	"
	sleep 2
	clear
	echo "\n
	\t\t\t ┌─────────────────────────────┐
	\t\t\t │                             │
	\t\t\t │   Configuración finalizada  │
	\t\t\t │                             │ 
	\t\t\t └─────────────────────────────┘
	"
	sh "$location/desing/wait.sh"
	return 1
}

nodata(){

	clear
	echo "	\n
		\t\t ┌──────────────────────────────────┐
		\t\t │                                  │
		\t\t │  ✘ No hay registros disponibles  │
		\t\t │  para esos datos                 │
		\t\t │                                  │
		\t\t └──────────────────────────────────┘
	"
	sh "$location/desing/wait.sh"
	return 1
}


motive(){

	echo "	\n
		\t\t ┌─────────────────────────────────┐
		\t\t │                                 │
		\t\t │   ✘ No hay motivos ingresados   │
		\t\t │                                 │
		\t\t └─────────────────────────────────┘
	"
	sh "$location/desing/wait.sh"
	return 1
}

	$1 
	if [ $? -ne 1 ];then	
		
		clear
		echo "\n
		\t\t ┌────────────────────────────────────────────────────────┐
		\t\t │                                                        │
		\t\t │   ✘ Error interno comuníquese con el soporte técnico   │
		\t\t │                                                        │
		\t\t └────────────────────────────────────────────────────────┘\n"
		sh "$location/desing/wait.sh"
	fi

