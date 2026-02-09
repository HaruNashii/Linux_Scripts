# install keyd
sudo pacman -S --needed --noconfirm keyd

# create the directory of the keyd config file
sudo mkdir -p /etc/keyd

# create the config file for the keyd
sudo tee /etc/keyd/default.conf > /dev/null <<'EOF'
[ids]
*

[main]
rightshift = slash
EOF

# start keyd and enable the keyd to start on system boot
sudo systemctl enable --now keyd
