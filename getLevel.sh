#!/bin/bash

#to use this type sudo ./getLevel.sh <regexp> <x> <y> <z>  
#e.g. sudo ./getLevel.sh 8A:15:04 3 5 2
#output power levels are in dBm

if [ "$1" == "--help" ]
then
  echo "Usage: `sudo $0` [regexp] [x] [y] [z]"
  exit 0
fi

touch drones_$HOSTNAME.csv

while true; do

	a=0
	b=0
	c=0
	x=0
	signaled=''
	timestamp=$( date --utc +%Y%m%d_%H%M%S%z )
	sudo rm drones_$HOSTNAME.csv

	while read line
	do
	   #echo $line
	   case $line in
	    *ESSID* )
	        line=${line#*ESSID:}
	        essid[$a]=${line//\"/}
	        a=$((a + 1))
	        ;;
	    *Address*)
	        line=${line#*Address:}
	        address[$b]=$line
	        b=$((b + 1))
	        ;;
	    *Signal*)
	        line=${line#*Signal level=}
	        signal[$c]=$line
		signal[$c]=${signal[$c]%%d*}
		#echo $signaled
		#signal[$c]=${signal[$c]%%d*}
	        c=$((c + 1))
	        ;;
	   esac
	done < <(sudo iwlist scan 2> /dev/null)
	
	while [ $x -lt ${#essid[@]} ]; do
	  #echo ${address[$x]}
	  #echo $r 
	
	  if [[ ${address[$x]} =~ $1 ]]
	  then
		echo $HOSTNAME,$timestamp,${address[$x]},${essid[$x]},$2,$3,$4,${signal[$x]} >> drones_$HOSTNAME.csv
	  fi
	  (( x++ ))
	done
	sleep 10
done