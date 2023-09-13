#!/bin/bash
name=$1
path=$2

id=$( pidof -s "$1" )
echo $id
while true;
do
	if  [ $( ps -p $id -o stat= ) != "R" ]; then
		$path
	fi
done

