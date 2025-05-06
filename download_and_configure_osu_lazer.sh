#!/bin/bash
# ^ define o script como script bash, para ser executado pelo propio bash


#======VARIAVEIS=======
bin_directory="$HOME/.local/bin"
desktop_file_directory="$HOME/.local/share/applications"
icon_file_directory="$HOME/Pictures/icons"
file_to_download="$(curl -s https://api.github.com/repos/ppy/osu/releases/latest | grep browser_download_url | cut -d\" -f4 | grep .AppImage)"
#======================


# cria a pasta do binario (se ela nao existir)
mkdir -p $bin_directory
# cria a pasta do atalho do desktop (se ela nao existir)
mkdir -p $desktop_file_directory
# cria a pasta do icone do osu (se ela nao existir)
mkdir -p $icon_file_directory


# verifica se o osu ja esta instalado, se estiver, nao baixa ele denovo :)
if [ ! -f "$bin_directory/osu.AppImage" ]; then
	# entra na pasta do binario
	cd $bin_directory
	# mostra um texto no terminal avisando que o Download do osu!lazer comecou
        echo "Baixando o osu!lazer, Por favor Espere..."
	# baixa a ultima versao do osu!lazer, usando o comando "curl"
        curl -sLOJ $file_to_download
	# adiciona a permissao para executar o osu!lazer
	chmod a+x "$bin_directory/osu.AppImage"
fi


# verifica se o atalho do osu ja esta criado, se estiver, nao baixa ele denovo :)
if [ ! -f "$desktop_file_directory/osu.desktop" ]; then
	# mostra um texto no terminal avisando que esta criando o atalho do osu!lazer
        echo "Criando o atalho do osu!lazer, Por favor Espere..."
	# cria o atalho do osu
	echo "[Desktop Entry] 
	Name=osu!(lazer) 
	Comment=Rhythm is just a *click* away!
	Exec=gamemoderun '$bin_directory/osu.AppImage'
	Icon=$icon_file_directory/lazer.png
	Terminal=false 
	Type=Application
	Categories=Game;"  >> "$desktop_file_directory/osu.desktop"
fi 


# verifica se o icon do osu ja esta instalado, se estiver nao baixa ele denovo :)
if [ ! -f "$icon_file_directory/lazer.png" ]; then
	# mostra um texto no terminal avisando que o Download do icone do osu!lazer comecou
        echo "Baixando o icone do osu!lazer, Por favor Espere..."
	# entra na pasta do icone
	cd $icon_file_directory
	# baixa a ultima versao do icone do osu!lazer, usando o comando "curl"
	curl -sLOJ https://raw.githubusercontent.com/ppy/osu/master/assets/lazer.png
fi 


# volta para a pasta principal do usuario
cd $HOME


# mostra um texto no terminal avisando que o script terminou de rodar :)
echo "Script Finalizado e osu baixado :3"
