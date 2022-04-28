#!/bin/bash

#Colours section
cyan='\033[0;36m'
reset='\033[0m'

if [ ! -s "resolvers.txt" ]; then
  printf "${cyan}Setup script has run previously. To force execution, delete '.ins_check'.${reset}"

echo "${cyan}This script requires root privillege. Run with sudo"
echo "Please install Go, Rust and Python manually before running this script${reset}"
sleep 5


# Make intro look more aesthetical
mkdir .tmp
wget "https://raw.githubusercontent.com/ritikx01/figlet_fonts/main/Delta%20Corps%20Priest%201.flf" -O .tmp/dcp1.flf
mv .tmp/dcp1.flf /usr/share/figlet
apt install figlet lolcat cowsay

mkdir ~/Toools 2>/dev/nul
#DNS validator
git clone https://github.com/vortexau/dnsvalidator.git ~/Tools/dnsvalidator
cd ~/Tools/dnsvalidator
python3 setup.py install
#MassDNS
git clone https://github.com/blechschmidt/massdns.git ~/Tools/massdns
cd ~/Tools/massdns
make 
sudo cp bin/massdns /usr/local/bin
#PureDNS
go install github.com/d3mondev/puredns/v2@latest
#Subfinder
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
# Amass
go install -v github.com/OWASP/Amass/v3/...@master
#httpx
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
#gospider
GO111MODULE=on go get -u github.com/jaeles-project/gospider
#NtHiM
cargo install NtHiM


#Installation check
touch .ins_check
echo "This file is generated by the script to check if the setup.sh is executed or not. Please do not delete this file" > .ins_check
