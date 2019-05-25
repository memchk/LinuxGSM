#!/bin/bash
# LinuxGSM command_armamods.sh function
# Author: Carson Page
# Contributor: memchk
# Website: https://linuxgsm.com
# Description: Installs arma 3 workshop mods correctly.

local commandname="ARMAMODS"
local commandaction="Install Arma Mods"
local function_selfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

check.sh

# Create a temporary file to store the steamcmd script
scriptfile="$(mktemp)"

echo "DepotDownloadProgressTimeout 6000
force_install_dir ${serverfiles}
login ${steamuser} ${steampass}" >> $scriptfile

for mod in "${workshopmods[@]}"; do
    modid=$(echo "$mod" | awk '{print $2}')
    echo "workshop_download_item 107410 ${modid} validate" >> $scriptfile
done

echo "quit" >> $scriptfile

${steamcmddir}/steamcmd.sh +runscript $scriptfile 

# Create mods folder if it does not exist, clear existing symlinks
mkdir -p "$serverfiles/mods"
find "$serverfiles/mods/" -maxdepth 1 -type l -delete

modstring="mods=\""

for mod in "${workshopmods[@]}"; do
    modname=$(echo "$mod" | awk '{print $1}')
    modid=$(echo "$mod" | awk '{print $2}')
    ln -s "$serverfiles/steamapps/workshop/content/107410/$modid" "$serverfiles/mods/@$modname"
    modstring="${modstring}mods/@$modname\\;"
done

modstring="${modstring}\""

find "$serverfiles/keys/" -maxdepth 1 -type l -delete

if [ ! -d "$serverfiles/a3_keys" ]; then
    cp -r "$serverfiles/keys" "$serverfiles/a3_keys"
    rm -r "$serverfiles/keys"
    mkdir -p "$serverfiles/keys"
fi

ln -s "$serverfiles/a3_keys/a3.bikey" "$serverfiles/keys/"

for mod in "${workshopmods[@]}"; do
    modname=$(echo "$mod" | awk '{print $1}')
    modid=$(echo "$mod" | awk '{print $2}')
    find "$serverfiles/mods/@${modname}/" -type f -name "*.bikey" -exec ln -sf {} "$serverfiles/keys/" \;
done

fn_print_complete_nl "Paste the next line into your lgsm cfg:\n${modstring}"

core_exit.sh