#!/bin/bash
name=$1
path=$2

 
if pidof -s "$1"; then
	id=$( pidof -s "$1" )
else
	$path
	id=$( pidof -s "$1" )
fi


while true;
do
	if  [ "$( ps -q $id -o state --no-headers )" != "R" ]; then
		$path
		id=$( pidof -s "$1" )
	fi
done

