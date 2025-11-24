csgo_legacy_path="$HOME/.steam/steam/steamapps/common/Counter-Strike Global Offensive/csgo.sh"
steamlinuxruntime_path="$HOME/.steam/steam/steamapps/common/SteamLinuxRuntime/run-in-scout-on-soldier"

if [ ! -f "$csgo_legacy_path" ]; then
	echo "CSGO Legacy Not Downloaded, Please Download It First!!!"
	exit 1
fi

if [ ! -f "$steamlinuxruntime_path" ]; then
	echo "SteamLinuxRuntime Not Downloaded, Please Download It First!!!"
	exit 1
fi

clear
"$steamlinuxruntime_path" -- "$csgo_legacy_path" "-steam"
