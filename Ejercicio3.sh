#!/bin/bash
n=0
$1 $2 &
echo " #%CPU #MEM #TIME" > log.txt
while [ $n -lt 30 ];
do
	id=$( pidof -s  $1 $2 )
	var1=$( ps -p $id -o %cpu= )
	var2=$( ps -p $id -o %mem= )
	time=$( date "+ %s" )
	echo "$var1 $var2 $time" >> log.txt
	n=$(( n+1))
done

