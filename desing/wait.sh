#!/bin/bash

########################## variable wait1 esta en varias partes del programa que es la espera de un mensaje

unset width height

width=$( tput cols )
height=$( tput lines )

for i in `seq 1 $width` ;do

	line="$line-"

done

tput cup $(( $height - 4 )) $width
echo $line
tput cup $(( $height - 2 )) $(( ( $width - 34 ) / 2 ))
read -p "Presione [ Enter ] para continuar " wait1
