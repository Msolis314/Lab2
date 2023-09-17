#!/bin/bash
comands=$( pgrep -l $1 | cut -d " " -f 2)

for line in $comands;
do
	if [ "$2" == $line ]; then
	       name=$2
	fi 
done	
id=$( pgrep $name )
while true;
do 
	for line in id;
	do
		if [ $( ps -p $line -o stat= ) != "R" ]; then
			
echo "$id"

