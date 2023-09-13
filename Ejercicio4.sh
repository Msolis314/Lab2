#!/bin/bash



echo "Monitoreo de Prueba" >  log2.txt
while true;
do
	
	if  inotifywait /home/mariana/Lab2/Prueba   ; then
		echo " Fecha : $( date "+%D" ) Hora: $( date "+%T" )" >> log2.txt
	fi

done
