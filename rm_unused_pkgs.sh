#!/bin/bash

PkgsToRm=$(sudo pacman -Qdtq)


if command -v flatpak &> /dev/null; then
FlatpakCheck=$(flatpak uninstall --unused)
    if [ "$FlatpakCheck" = "Nothing unused to uninstall" ]; then
      echo "No Flatpak Unused Packages To Remove. :3"
    else 
      flatpak uninstall --unused
      clear 
      echo "Unused Packages Removed. Yippe!"
    fi
fi

if [ ${#PkgsToRm} -ge 2 ]; then
	sudo pacman -Rsn $PkgsToRm
  clear
  echo "Unused Packages Removed. Yippe!"
else
	echo "No Pacman Unused Packages To Remove. :3"
fi

if command -v yay &> /dev/null; then
YayPkgsToRm=$(yay -Qdtq)
    if [ ${#YayPkgsToRm} -ge 2 ]; then
    	yay -Rsn $YayPkgsToRm
      clear
      echo "Unused Packages Removed. Yippe!"
    else
    	echo "No Yay Unused Packages To Remove. :3"
    fi
fi

if command -v paru &> /dev/null; then
ParuPkgsToRm=$(paru -Qdtq)
    if [ ${#ParuPkgsToRm} -ge 2 ]; then
    	yay -Rsn $ParuPkgsToRm
      clear
      echo "Unused Packages Removed. Yippe!"
    else
    	echo "No Paru Unused Packages To Remove. :3"
    fi
fi
