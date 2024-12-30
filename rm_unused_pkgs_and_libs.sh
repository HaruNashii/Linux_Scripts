#!/bin/bash



if command -v apt &> /dev/null; then 
	sudo apt-get autoremove
	clear && echo "Unused Packages Removed. Yippe!"
fi

if command -v dnf &> /dev/null; then 
	sudo dnf clean
	sudo dnf auto-remove
	clear && echo "Unused Packages Removed. Yippe!"
fi

if command -v pacman &> /dev/null; then 
	PkgsToRm=$(sudo pacman -Qdtq)
	LibsToRm=$(sudo pacman -Qqd)

	sudo pacman -Sc --noconfirm
	sudo pacman -Scc --noconfirm
	sudo rm -rf $HOME/.cache/*

	if [ ${#LibsToRm} -ge 2 ]; then
		sudo pacman -Qqd | sudo pacman -Rsu --noconfirm -
		clear && echo "Unused Libs Removed. Yippe!"
	else 
		echo "No Pacman Unused Libs To Remove. :3"
	fi


	if [ ${#PkgsToRm} -ge 2 ]; then
		sudo pacman -Rsn $PkgsToRm
		clear && echo "Unused Packages Removed. Yippe!"
	else
		echo "No Pacman Unused Packages To Remove. :3"
	fi
fi

if command -v yay &> /dev/null; then
	YayPkgsToRm=$(yay -Qdtq)

	if [ ${#YayPkgsToRm} -ge 2 ]; then
    		yay -Rsn $YayPkgsToRm
    	  	clear && echo "Unused Packages Removed. Yippe!"
    	else
    		echo "No Yay Unused Packages To Remove. :3"
    	fi
fi

if command -v paru &> /dev/null; then
	ParuPkgsToRm=$(paru -Qdtq)

	if [ ${#ParuPkgsToRm} -ge 2 ]; then
    		yay -Rsn $ParuPkgsToRm
    	  	clear && echo "Unused Packages Removed. Yippe!"
    	else
    		echo "No Paru Unused Packages To Remove. :3"
    	fi
fi

if command -v flatpak &> /dev/null; then
	FlatpakCheck=$(flatpak uninstall --unused)

	if [ "$FlatpakCheck" = "Nothing unused to uninstall" ]; then
		echo "No Flatpak Unused Packages To Remove. :3"
    	else 
      		flatpak uninstall --unused
      		clear && echo "Unused Packages Removed. Yippe!"
    	fi
fi

