if command -v pacman &> /dev/null; then
	# install nvidia drivers
	sudo pacman -S --needed nvidia nvidia-utils lib32-nvidia-utils nvidia-setting vulkan-icd-loader egl-wayland
else
	echo "pacman package manager not found, this script doesn't support others distro YET!!!, executing only configs"
fi

# change the nvidia kernel module to support wayland
# necessary to use (gnome on wayland/hyprland, etc)
sudo echo options nvidia_drm modeset=1 | sudo tee /etc/modprobe.d/nvidia_drm.conf

# if user is using GDM enable the GDM to choose Wayland sessions
if ! [ -x "$(command -v git)" ]; then
	sudo ln -s /dev/null /etc/udev/rules.d/61-gdm.rule
fi

# regenerate the kernel modules
sudo mkinitcpio -p linux
