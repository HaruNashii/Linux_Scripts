#!/bin/bash

# check if the command "cpupower" exist
if command -v cpupower &> /dev/null; then
	clear
	# set the energy mode of your CPU to perfomance
	sudo cpupower frequency-set --governor performance
	echo "cpu power mode defined to 'perfomance'."
else 
	clear && echo "cpupower command not found, please download it first!!"
fi
