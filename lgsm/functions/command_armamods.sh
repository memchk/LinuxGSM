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
core_exit.sh