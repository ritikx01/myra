#!/bin/bash

blue='\033[0;34m'
bcyan="\033[1;36m"
cyan='\033[0;36m'
reset='\033[0m'
test='\033[0;100m'

figlet  -f dcp1 "MYRA" -w 135 | lolcat
printf "\n${bcyan}"
printf "${bcyan}This script automates the recon process by integration of some open source tools.\n"
printf "${bcyan}Put the domain.txt file in ~/hunt. All the output generated by the script will be stored in the same folder${reset}\n\n"

printf "${cyan}DNS bruteforce using PureDNS\n"
sleep 2
if [ ! -s "resolvers.txt" ] || [[ $(find resolvers.txt -mtime +100 -print) ]]; then
  echo -e "Resolvers seem older than 1 day\nGenerating custom resolvers${reset}"
  rm -r resolvers.txt 2>>/dev/null
  cowsay "DNSValidator" | lolcat
  sleep 4
  dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 200 -o resolvers.txt
fi









printf "Done${reset}\n"
