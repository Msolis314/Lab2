#!/bin/bash
name=$1
path=$2

id=$( pgrep $1 )
for line in $id;
do
	if [ $( ps -p $line -o stat= ) != "R" ]; then
		$path
	else
		echo "Running"
	fi
done
