export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export PATH=$PATH:/home/beth/.spicetify:/home/beth/.local/bin:/home/beth/.cargo/bin

zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 7

ZSH_THEME="robbyrussell"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
	git
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

alias update="topgrade -y"
alias remove="sh /home/beth/Code/bash/Linux_scripts/rm_unused_pkgs_and_libs.sh"
alias list="sudo pacman -Qe"
alias neofetch="hyfetch --distro=arch"
alias fastfetch="hyfetch --distro=arch"
alias fetch="hyfetch --distro=arch"
alias hyfetch="hyfetch --distro=arch"
