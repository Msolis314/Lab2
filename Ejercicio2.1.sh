#!/bin/bash
name=$1
path=$2

 
if pidof -s "$1"; then
	id=$( pidof -s "$1" )
else
	$path
	id=$( pidof -s "$1" )
fi
echo $id
echo $( ps -q $id -o state --no-headers )
if  [ "$( ps -q $id -o state --no-headers )" != "R" ]; then
               $path
fi

#while true;
#do
#	if  [ "$( ps -q $id -o state --no-headers )" != "R" ]; then
#		$path
#	fi
#done

