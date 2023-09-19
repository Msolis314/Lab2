## I Ejercicio 

En este ejercicio se buscaba obtener la información de un proceso a partir del id. Para lograrlo se utilizó la opción de `ps -p` esto para poder utilizar el comando `ps` con el id. Además, se hizo uso del *flag* `-o` para determinar cuál de los parámetros del proceso se buscaba observar. Finalmente, el parámetro seguido del = es para solo imprimir el dato del parámetro y no el *heading*.
```bash
#!/bin/bash
echo "ID: $1 "
echo  "Nombre del proceso: $( ps -p $1 -o comm= )"
echo  "Parent process id: $( ps -p $1 -o pid= )"
echo "Usuario propietario: $( ps -p $1 -o user= )"
echo "Porcentaje de uso de CPU: $( ps -p $1 -o %cpu= )"
echo "Consumo de memoria: $( ps -p $1 -o %mem= )"
echo "Estado: $( ps -p $1 -o stat= )"
echo "Path del ejecutable: $( ps -p $1 -o command= )"
```
### I.I Resultados
Para probar el *script* se crea un proceso `sleep 4000` y su id se incerta por parámetro. Como se denota a continuación se imprime correctamente lo solicitado en el ejercicio: 

![alt image](https://github.com/Msolis314/Clases/blob/Msolis314-patch-1/Pasted%20image%2020230914205507.png)

## II Ejercicio 
En este problema se recibe un nombre y un path de un proceso con el fin del mantenerlo activo con el script. Primero, revisa si el proceso está corriendo mediante un `if` y `pidof` si logra obtener un id el `if` lo valora como *true* y establece la variable id; si no, ejecuta el proceso y obtiene su id.
```bash
#!/bin/bash
name=$1
path=$2

if pidof -s "$1"; then
	id=$( pidof -s "$1" )
else
	$path
	id=$( pidof -s "$1" )
fi

```
Luego, en un loop infinito se revisa el estado del proceso usando `ps -q` para que con el id lograr obtener el estado del proceso. Si este estado es diferente a "R" de *Running* ejecuta el path y obtiene de nuevo su id para seguir con la iteración.
```bash
while true;
do
	if  [ "$( ps -q $id -o state --no-headers )" != "R" ]; then
		$path
		id=$( pidof -s "$1" )
	fi
done
```
## III Ejercicio 3 
El objetivo de esta sección era obtener un registro del consumo del porcentaje de consumó de un proceso de memoria y cpu, para luego graficarlo en el tiempo. Para lograrlo primero se ejecuta dicho proceso y luego se crea un archivo con los valores correspondientes a %Mem, %CPU y tiempo. Cabe destacar, que dicho archivo se rescribe cada ejecución del programa. Luego, mediante un `while` se ejecutan una serie de comandos 50 veces con el objetivo de recolectar los datos requeridos.

Usando el comando `pidof -s` se obtiene el id de la version ejecutada del programa más reciente. Seguidamente, se utiliza `ps -p ` con el id obtenido y las opciones de `%cpu=` y `%mem=` para recolectar únicamente los valores y no el *heading*. Además, se utiliza `date "+%s"` para obtener un valor de la fecha en segundos de la iteración. Finalmente, todo se guarda en *log.txt* redirigiendo la salida de un `echo` con las variables.
```bash
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
```
Para realizar lo concerniente a las graficas se hace uso de `gnuplot --persist -e`  para lograr que se muestren durante la ejecución del script.
```bash

gnuplot --persist -e ' set title "Grafico %Mem"; set output "%Mem.png" ; set xlabel "tiempo (s)"; set ylabel "Porcentaje %" ; plot "log.txt" u 3:2 title "%Mem" '


gnuplot --persist -e ' set title "Grafico %CPU"; set output "%CPU.png" ; set xlabel "tiempo (s)"; set ylabel "Porcentaje %" ; plot "log.txt" u 3:1 title "%CPU" '

```
### III.I Resultados
Ingresando el siguiente comando en la terminal `./Ejercicio3.sh "ping -c 20 www.google.com"` para tener un proceso para monitorear como se evidencia en la siguiente imagen.

![Resultados](https://github.com/Msolis314/Clases/blob/main/Lab2.3.1.png)

Se obtienen los siguientes gráficos para el %cpu y  el %mem. 
![CPU](https://github.com/Msolis314/Clases/blob/main/Pasted%20image%2020230914200922.png)
![MEM](https://github.com/Msolis314/Clases/blob/main/Pasted%20image%2020230914201129.png)
## IV Ejercicio 4
Por último, en esta parte del laboratorio se buscaba crear un servicio de monitoreo para un directorio. La primera parte del ejercicio se realizó creando un script que utilizara `inotifywait` para registrar la fecha de las modificaciones en un archivo llamado `log2.txt`.
```bash
#!/bin/bash

echo "Monitoreo de Prueba" >  log2.txt
while true;
do
	
	if  inotifywait -q -q /home/mariana/Lab2/Prueba 1> /dev/null  ; then
		echo " Fecha : $( date "+%D" ) Hora: $( date "+%T" )" >> log2.txt
	fi

done

```
Como se denota en el bloque de código, primero se crea el archivo log2.txt. Luego,  en un loop infinito se utiliza el comando `inotifywait -q -q ` (la doble q es para que no imprima nada) , en un `if` ya que cuando el comando detecta un evento tiene un exit status de 0 que el `if` evalúa como *true*.

A continuación, se agrega una línea al archivo *log2.txt*  con la fecha y hora del evento. Esto utilizando el comando `date` descrito en el ejercicio 3.

La segunda parte del problema consiste en crear un servicio. Para ello se debe ir al directorio `/etc/systemd/system` y crear un archivo en este caso nombrado `ejercicio4.service`

En dicho archivo se especifica la configuración del servicio como se denota en la imagen:

![Service](https://github.com/Msolis314/Clases/blob/main/Pasted%20image%2020230914202831.png)
Siendo en `[Unit]`:
- Description: Una descripción de la funcionalidad del servicio.
- After: Indica cuando debe de iniciar el servicio, en este caso no es necesario pero se le especifica que sea después de haberse iniciado la red.
En `[Service]`:
- ExecStart: El path al script en que consiste el servicio.
- Type: El proceso inicia inmediatamente y no hace Fork en este caso. 
- WorkingDirectory: Es una ruta al directorio donde esta el script del servicio. 
En `[Install]`:
- WantedBy: Indica cuando debería iniciar el servicio, en este caso al inicio del sistema.
Finalmente, se inicio el servicio utilizando los permisos de sudo y siguiente comando:
```bash
sudo systemctl start ejercicio4
```
### IV.I Resultados
Ahora, si se corre el comando de `sudo systemctl status ejercicio4` se obtiene:
![alt image](https://github.com/Msolis314/Clases/blob/main/Pasted%20image%2020230914204540.png)
Por tanto, el servicio ha sido creado y activado exitosamente en el sistema. 
Si se modifica el directorio Prueba a las 8:48 como se evidencia en las siguientes imágenes.
![alt image](https://github.com/Msolis314/Clases/blob/main/Pasted%20image%2020230914204817.png)
![alt image](https://github.com/Msolis314/Clases/blob/main/Pasted%20image%2020230914204848.png)

El archivo *log2.txt* registra lo siguiente:

![alt image](https://github.com/Msolis314/Clases/blob/main/Pasted%20image%2020230914204952.png)

Por tanto, se ha logrado el objetivo del servicio. 
## V Git Hub
[Link Github](https://github.com/Msolis314/Lab2)
