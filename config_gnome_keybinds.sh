#!/bin/bash



if command -v gsettings &> /dev/null; then
KEYBIND="org.gnome.desktop.wm.keybindings"
# to see all gsettings list-keys org.gnome.desktop.wm.keybindings
#[CONFIGURE]    [TYPE]    [WHAT IT WILL DO]     [WHAT KEY TO BIND]

# remove tray bindings
gsettings set org.gnome.shell.keybindings switch-to-application-1 []
gsettings set org.gnome.shell.keybindings switch-to-application-2 []
gsettings set org.gnome.shell.keybindings switch-to-application-3 []
gsettings set org.gnome.shell.keybindings switch-to-application-4 []
gsettings set org.gnome.shell.keybindings switch-to-application-5 []
gsettings set org.gnome.shell.keybindings switch-to-application-6 []
gsettings set org.gnome.shell.keybindings switch-to-application-7 []
gsettings set org.gnome.shell.keybindings switch-to-application-8 []
gsettings set org.gnome.shell.keybindings switch-to-application-9 []

# change the app workspace (Windows + Shift + [any number])
gsettings set "$KEYBIND" "move-to-workspace-1" "['<Super><Shift>1']"
gsettings set "$KEYBIND" "move-to-workspace-2" "['<Super><Shift>2']"
gsettings set "$KEYBIND" "move-to-workspace-3" "['<Super><Shift>3']"
gsettings set "$KEYBIND" "move-to-workspace-4" "['<Super><Shift>4']"
gsettings set "$KEYBIND" "move-to-workspace-5" "['<Super><Shift>5']"
gsettings set "$KEYBIND" "move-to-workspace-6" "['<Super><Shift>6']"
gsettings set "$KEYBIND" "move-to-workspace-7" "['<Super><Shift>7']"
gsettings set "$KEYBIND" "move-to-workspace-8" "['<Super><Shift>8']"
gsettings set "$KEYBIND" "move-to-workspace-9" "['<Super><Shift>9']"
gsettings set "$KEYBIND" "move-to-workspace-10" "['<Super><Shift>0']"

# change current workspace (Windows + [any number])
gsettings set "$KEYBIND" "switch-to-workspace-1" "['<Super>1']"
gsettings set "$KEYBIND" "switch-to-workspace-2" "['<Super>2']"
gsettings set "$KEYBIND" "switch-to-workspace-3" "['<Super>3']"
gsettings set "$KEYBIND" "switch-to-workspace-4" "['<Super>4']"
gsettings set "$KEYBIND" "switch-to-workspace-5" "['<Super>5']"
gsettings set "$KEYBIND" "switch-to-workspace-6" "['<Super>6']"
gsettings set "$KEYBIND" "switch-to-workspace-7" "['<Super>7']"
gsettings set "$KEYBIND" "switch-to-workspace-8" "['<Super>8']"
gsettings set "$KEYBIND" "switch-to-workspace-9" "['<Super>9']"

# close the window (Windows + Q)
gsettings set "$KEYBIND" "close" "['<Super>q']"

# toggle the maximize on one app (Windows + W)
gsettings set "$KEYBIND" "toggle-maximized" "['<Super>w']"

# toggle the fullscreen on one app (F11)
gsettings set "$KEYBIND" "toggle-fullscreen" "['>Super>F11']"

# minimize the app (Windows + S)
gsettings set "$KEYBIND" "minimize" "['<Super>s']"

# minimize all apps in the current workspace (Windows + Shift + S)
gsettings set "$KEYBIND" "show-desktop" "['<Super><Shift>s']"

else
	echo "the command gsettings was not found, are you sure you are in GNOME?"
fi
