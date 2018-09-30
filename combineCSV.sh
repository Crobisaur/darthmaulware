#!/bin/bash

touch drones.csv
touch drones_unsorted.csv

rm drones.csv drones_unsorted.csv

cat drones*.csv > drones_unsorted.csv

sort -k3 -t, drones_unsorted.csv > drones.csv

rm drones_unsorted.csv