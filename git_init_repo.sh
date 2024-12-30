#!/bin/bash

if command -v git &> /dev/null; then
	git init 
	git add .
	git commit -m "first commit"
	git branch -M main
	clear
	read -p "Your remote url: " remote_url 
	git remote add origin $remote_url 
	git push -u origin main
else
	echo "git command not found, please download it before using this script!!!"
fi
