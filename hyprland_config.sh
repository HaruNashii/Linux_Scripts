#!/bin/bash



# instala o hyprland, o terminal e o aplicativo de papel de parede do hyprland
if command -v dnf &> /dev/null; then
	sudo dnf install hyprland alacritty hyprpaper xdg-desktop-portal-hyprland grim slurp playerctl
else 
	echo "comando DNF nao encontrado????, wtf voces nao estavam usando o Fedora???"
fi 

# instala a configuracao do hyprland e do aplicativo de papel de parede
rm -rf $HOME/.config/hypr
cp -rf $PWD/configs/hypr/ $HOME/.config/

# move o wallpaper para a pasta que o aplicativo de papel de parede ler
mkdir -p $HOME/Pictures/wallpapers
cp -f $PWD/configs/images/osu1.png $HOME/Pictures/wallpapers/

# instala a configuracao do terminal do hyprland
rm -rf $HOME/.config/alacritty
cp -rf $PWD/configs/alacritty $HOME/.config/alacritty

# instala a configuracao da barra do hyprland 
rm -rf $HOME/.config/waybar
cp -rf $PWD/configs/waybar $HOME/.config/waybar

# instala a configuracao do app launcher do hyprland 
rm -rf $HOME/.config/wofi
cp -rf $PWD/configs/wofi $HOME/.config/wofi

echo "pronto, agora e so logar no Hyprland :3"
