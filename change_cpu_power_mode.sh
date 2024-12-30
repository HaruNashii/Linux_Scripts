#!/bin/bash

# check if the command "cpupower" exist
if command -v cpupower &> /dev/null; then

	x=1
	clear 
	echo "What CPU Power Mode you want to Use?"
	echo "1 = perfomance, 2 = powersave"
	read -p "asnwer : " answer
	while [ $x -le 2 ]; do
		    case $answer in
		        [1]*)
				# set the energy mode of your CPU to powersave
				sudo cpupower frequency-set --governor performance
				clear
				echo "cpu power mode defined to 'perfomance'."
		            	break
		            	;;
		        [2]*)
				# set the energy mode of your CPU to powersave
				sudo cpupower frequency-set --governor powersave
				clear
				echo "cpu power mode defined to 'powersave'."
		            	break
		            	;;
		        *)
				echo "Invalid input. Please enter either '1' for (perfomance) or '2' for (powersave)."
			    	read -p "asnwer : " answer
		            	;;
		    esac
	done

else 
	clear && echo "cpupower command not found, please download it first!!"
fi
