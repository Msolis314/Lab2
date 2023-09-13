#!/bin/bash
echo "ID: $1 "
echo  "Nombre del proceso: $( ps -p $1 -o comm= )"
echo  "Parent process id: $( ps -p $1 -o pid= )"
echo "Usuario propietario: $( ps -p $1 -o user= )"
echo "Porcentaje de uso de CPU: $( ps -p $1 -o %cpu= )"
echo "Consumo de memoria: $( ps -p $1 -o %mem= )"
echo "Estado: $( ps -p $1 -o stat= )"
echo "Path del ejecutable: $( ps -p $1 -o command= )"
