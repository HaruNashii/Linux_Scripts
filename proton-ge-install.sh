#!/bin/bash



#======STRINGS=======
tmp_working_directory="/tmp/proton-ge-custom"
proton_ge_version_tar_file=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep -oP '"name": "\K[^"]+' | grep .tar.gz)
proton_ge_version=$(echo $proton_ge_version_tar_file | sed 's/.tar.gz$//')
steam_proton_folder="$HOME/.steam/root/compatibilitytools.d/"
file_to_download="$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep .tar.gz)"
#====================



# limpa as mensagens antigas do terminal
clear

# verifica se a pasta temporaria existe, e se ela nao existir, cria ela
mkdir -p $tmp_working_directory

# verifica se a pasta onde deve ficar o proton ge existe, se nao existir, cria ela
mkdir -p $steam_proton_folder

# entra na pasta temporaria
cd $tmp_working_directory

# verifica se a pasta do proton ge ja esta na pasta que deveria estar, se estiver, cancela tudo, pq a ultima versao ja esta instalada :3
if [ ! -d "$steam_proton_folder$proton_ge_version" ]; then
    if [ ! -f "$tmp_working_directory/$proton_ge_version_tar_file" ]; then
	# mostra um texto no terminal avisando que o Download do proton-ge comecou
        echo "Downloading Proton-GE, Please Wait..."
	# baixa a ultima versao do proton ge, usando o comando "curl"
        curl -sLOJ $file_to_download
    fi 
fi

# limpa as mensagens antigas do terminal
clear

# verifica se a pasta do proton ge ja esta na pasta que deveria estar, se nao estiver, e ja baixou o arquivo, extrai ele para a pasta necessaria
if [ -d "$steam_proton_folder$proton_ge_version" ]; then
    # mostra um texto no terminal avisando que a versao do proton-ge ja instalado, ja e a mais recente
    echo "Your Proton-GE Is Already The Latest Version."
else
    # mostra um texto no terminal avisando que o proton-ge esta sendo extraido
    echo "Extracting Proton-GE To Steam Proton Folder..."

    # extrai o proton ge, para a pasta que deve estar
    tar -xf GE-Proton*.tar.gz -C $steam_proton_folder

    # limpa as mensagens antigas do terminal
    clear

    # mostra um texto no terminal avisando que todo o processo foi concluido
    echo "All done :3"
fi



cd $HOME
