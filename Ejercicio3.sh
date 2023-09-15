#!/bin/bash
n=0
$1 $2 &
echo " #%CPU #MEM #TIME" > log.txt
while [ $n -lt 50 ];
do
	id=$( pidof -s  $1 $2 )
	var1=$( ps -p $id -o %cpu= )
	var2=$( ps -p $id -o %mem= )
	time=$( date "+ %s" )
	echo "$var1 $var2 $time" >> log.txt
	n=$(( n+1))
done


gnuplot --persist -e ' set title "Grafico %Mem"; set output "%Mem.png" ; set xlabel "tiempo (s)"; set ylabel "Porcentaje %" ; plot "log.txt" u 3:2 title "%Mem" '


gnuplot --persist -e ' set title "Grafico %CPU"; set output "%CPU.png" ; set xlabel "tiempo (s)"; set ylabel "Porcentaje %" ; plot "log.txt" u 3:1 title "%CPU" '



