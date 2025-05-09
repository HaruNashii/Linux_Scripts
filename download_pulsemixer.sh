#!/bin/bash
# ^ define o script como script bash, para ser executado pelo propio bash

# defina o local da pasta destino do binario
bin_directory="$HOME/.local/bin"

# verifica se o pulsemixer ja esta instalado, se estiver, nao baixa ele denovo :)
if [ ! -f "$bin_directory/pulsemixer" ]; then

	# cria a pasta do binario (se ela nao existir)
	mkdir -p $bin_directory
	# entra na pasta do binario
	cd $bin_directory
	# mostra um texto no terminal avisando que o Download do pulsemixer comecou
        echo "Baixando o pulsemixer, Por favor Espere..."
	# baixa a ultima versao do pulsemixer, usando o comando "curl"
	curl https://raw.githubusercontent.com/GeorgeFilipkin/pulsemixer/master/pulsemixer > pulsemixer
	# adiciona a permissao para executar o pulsemixer
	chmod a+x "$bin_directory/pulsemixer"
else 
	# mostra um texto no terminal avisando que o pulsemixer ja esta instalado
	echo "Pulsemixer ja esta instalado, Saindo..."
fi

