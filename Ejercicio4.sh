#!/bin/bash



echo "Monitoreo de Prueba" >  log2.txt
while true;
do
	
	if  inotifywait -q -q /home/mariana/Lab2/Prueba 1> /dev/null  ; then
		echo " Fecha : $( date "+%D" ) Hora: $( date "+%T" )" >> log2.txt
	fi

done
