# check if my .zshrc exist, the script can't run without it :/
if [ ! -f "$PWD/configs/zshrc" ]; then
	echo "can't find my .zshrc config, aborting script..."
	exit 1
fi

# install the zsh and the git (git is for downloading the zsh-autosuggestions plugin)
sudo pacman -Sy --needed -y zsh git

# Install Oh-My-Zsh with the official download command from (https://ohmyz.sh/#install)
# if you are skeptical about this code, you can check the official website of the "Oh-My-Zsh"
# https://ohmyz.sh/
if [ -d "/home/$(whoami)/.oh-my-zsh" ]; then
	echo "Oh-My-Zsh Already Installed, Skipping..."
else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install zsh-autosuggestions on oh-my-zsh config 
# again, if you are skeptical you can check the source code of this autosuggestions on the official github:
# https://github.com/zsh-users/zsh-autosuggestions
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then 
	echo "zsh-autosuggestions Already Installed, Skipping..."
else 
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

# Creates a backup of your own .zshrc file
if [ -f "$HOME/.zshrc" ]; then 
	mkdir -p $PWD/backups
	mv $HOME/.zshrc $PWD/backups
fi

# Install my zsh config, you can find the config inside the folder called configs
# that is in the same directory that this script
if [ -f "$PWD/configs/zshrc" ]; then
	cp $PWD/configs/zshrc $HOME/.zshrc
fi

# wait for 3 seconds to prevent some edge cases errors
sleep 3

# change your shell to zsh
chsh -s /bin/zsh
