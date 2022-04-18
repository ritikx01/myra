#!/bin/bash

#Colours section
cyan='\033[0;36m'
reset='\033[0m'

if [ ! -s "resolvers.txt" ]; then
  printf "${cyan}Setup script has run previously. To force execution, delete '.ins_check'.${reset}"

echo "${cyan}This script requires root privillege. Run with sudo"
echo "Please install Go and Python manually before running this script${reset}"
sleep 5


# Make intro look more aesthetical
mkdir .tmp
wget "https://raw.githubusercontent.com/ritikx01/figlet_fonts/main/Delta%20Corps%20Priest%201.flf" -O .tmp/dcp1.flf
mv .tmp/dcp1.flf /usr/share/figlet
apt install figlet lolcat cowsay

#Installation check
touch .ins_check
echo "This file is generated by the script to check if the setup.sh is executed or not. Please do not delete this file" > .ins_check
