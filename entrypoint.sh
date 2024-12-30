#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m' # Без цвета

client_mods="$CLIENT_MODS"


function startGame() {		

	clearKeys
	
	if [ ${#client_mods} -gt 0 ]; then
		for elem in $client_mods; do
			rm -r /root/servers/dayz-server/$elem
			ln -s /root/servers/dayz-server/steamapps/workshop/content/221100/$elem /root/servers/dayz-server/$elem

			if compgen -G "/root/servers/dayz-server/steamapps/workshop/content/221100/$elem/keys/*" > /dev/null; then
				ln -s /root/servers/dayz-server/steamapps/workshop/content/221100/$elem/keys/* /root/servers/dayz-server/keys/
			fi

			if compgen -G "/root/servers/dayz-server/steamapps/workshop/content/221100/$elem/Keys/*" > /dev/null; then
				ln -s /root/servers/dayz-server/steamapps/workshop/content/221100/$elem/Keys/* /root/servers/dayz-server/keys/
			fi
		done
	fi
	
	cd /root/servers/dayz-server/
	cmd="./DayZServer \
     -config=serverDZ.cfg \
     -port=2302 \
     -BEpath=battleye \
     -profiles=profiles \
     -dologs \
     -adminlog \
     -netlog \
     -freezecheck"

	if [ ${#client_mods} -gt 0 ]; then
		cmd+=" -mod=$(echo $client_mods | sed 's/ /;/g')"
	fi

	exec $cmd
}

function updateGame() {
	echo -e "${GREEN}[DD] Downloading/Update dayz server${NC}"
	
	SERVER_DIR="/root/servers/temp_dayz_update"
		
	steamcmd \
	+force_install_dir $SERVER_DIR \
	+login $STEAM_USER $STEAM_PASSWORD \
	+app_update 223350 validate \
	+quit
	
	if [ ${#client_mods[@]} -gt 0 ]; then
		steamcmd_command="+login $STEAM_USER $STEAM_PASSWORD"
		
		for elem in ${client_mods[@]}; do
			echo -e "${GREEN}[DD] Adding mod ${elem} to download queue${NC}"
			steamcmd_command+=" +workshop_download_item 221100 $elem"
		done

		steamcmd_command+=" validate +quit"

		echo -e "${GREEN}[DD] Executing SteamCMD to download all mods${NC}"
		steamcmd +force_install_dir $SERVER_DIR $steamcmd_command
		echo
	fi

	rsync -av /root/servers/temp_dayz_update/ /root/servers/dayz-server/
}

function clearKeys() {
    find /root/servers/dayz-server/keys/ -type f ! -name "dayz.bikey" -exec rm -f {} +
}

case "$1" in
    start)
		if [ "$CONFIGURATION" == "Release" ]; then
			updateGame
		fi
		
        startGame
    ;;
    update)
        updateGame
    ;;
    *)
        exec "$@"
    ;;
esac
