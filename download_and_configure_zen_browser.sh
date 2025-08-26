#!/bin/bash
# ^ define o script como script bash, para ser executado pelo propio bash


#======VARIAVEIS=======
bin_directory="$HOME/.local/bin"
desktop_file_directory="$HOME/.local/share/applications"
file_to_download="$(curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | grep browser_download_url | cut -d\" -f4 | grep x86_64.AppImage)"
#======================


# cria a pasta do binario (se ela nao existir)
mkdir -p $bin_directory
# cria a pasta do atalho do desktop (se ela nao existir)
mkdir -p $desktop_file_directory
# cria a pasta do icone do osu (se ela nao existir)
mkdir -p $icon_file_directory


# verifica se o zen browser ja esta instalado, se estiver, nao baixa ele denovo :)
if [ ! -f "$bin_directory/zen-x86_64.AppImage" ]; then
	# entra na pasta do binario
	cd $bin_directory
	# mostra um texto no terminal avisando que o Download do zen browser comecou
        echo "Baixando o zen browser, Por favor Espere..."
	# baixa a ultima versao do zen browser, usando o comando "curl"
        curl -sLOJ $file_to_download
	# adiciona a permissao para executar o zen browser
	chmod a+x "$bin_directory/zen-x86_64.AppImage"
fi


# verifica se o atalho do zen ja esta criado, se estiver, nao baixa ele denovo :)
if [ ! -f "$desktop_file_directory/zen.desktop" ]; then
	# mostra um texto no terminal avisando que esta criando o atalho do zen browser
        echo "Criando o atalho do zen browser, Por favor Espere..."
	# cria o atalho do zen browser
	echo "[Desktop Entry] 
	Name=Zen
	Comment=A Browser Made For MultiTasking
	Exec=$bin_directory/zen-x86_64.AppImage'
	Icon=$icon_file_directory/zen_icon.png
	Terminal=false 
	Type=Application
	Categories=Utilities;"  >> "$desktop_file_directory/zen.desktop"
fi 


# volta para a pasta principal do usuario
cd $HOME


# mostra um texto no terminal avisando que o script terminou de rodar :)
echo "Script Finalizado e zen browser baixado :3"
