#!/bin/bash

blue='\033[0;34m'
bcyan="\033[1;36m"
cyan='\033[0;36m'
reset='\033[0m'
test='\033[0;100m'
ports='81,300,591,593,832,981,1010,1311,1099,2082,2095,2096,2480,3000,3128,3333,4243,4567,4711,4712,4993,5000,5104,5108,5280,5281,5601,5800,6543,7000,7001,7396,7474,8000,8001,8008,8014,8042,8060,8069,8080,8081,8083,8088,8090,8091,8095,8118,8123,8172,8181,8222,8243,8280,8281,8333,8337,8443,8500,8834,8880,8888,8983,9000,9001,9043,9060,9080,9090,9091,9200,9443,9502,9800,9981,10000,10250,11371,12443,15672,16080,17778,18091,18092,20720,32000,55440,55672'

figlet  -f dcp1 "MYRA" -w 135 | lolcat
printf "\n${bcyan}"
printf "${bcyan}This script automates the recon process by integration of some open source tools.\n"
printf "${bcyan}Put the domain.txt file in ~/hunt. All the output generated by the script will be stored in the same folder${reset}\n\n"

# Get the dirs and create the output directory.
printf "Enter the folder name"
read folder_name
domains="${folder_name}/domains.txt"
mkdir Output 2>/dev/null
#mkdir Output/${folder_name} 2>/dev/null
out_folder=Output/${folder_name}
mkdir ${out_folder} 2>/dev/null

printf "${cyan}DNS bruteforce using PureDNS\n"
sleep 2
if [ ! -s "resolvers.txt" ] || [[ $(find resolvers.txt -mtime +100 -print) ]]; then
  echo -e "Resolvers seem older than 1 day\nGenerating custom resolvers${reset}"
  rm -r resolvers.txt 2>>/dev/null
  cowsay "DNSValidator"
  sleep 4
  dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 200 -o resolvers.txt > /dev/null 2>&1
fi

printf "${cyan}"
cowsay "Starting DNS bruteforce"
printf "${reset}"
while read domain ; do puredns bruteforce ~/wordlist/best-dns-wordlist.txt $domain --resolvers ~/resolvers.txt | tee -a ${out_folder}/subs.txt ; done < "$domains"

printf "${cyan}"
cowsay "Starting Subfinder"
printf "${reset}"
subfinder -dL ${domains} -o ${out_folder}/subfinder.txt
cat ${out_folder}/subfinder.txt | anew ${out_folder}/subs.txt
rm subfinder.txt

printf "${cyan}"
cowsay "Starting Amass"
printf "${reset}"
amass enum -df ${domains} -o ${out_folder}/amass.txt
cat ${out_folder}/amass.txt | anew ${out_folder}/subs.txt
rm amass.txt

printf "${cyan}"
cowsay "Starting Portscan"
printf "${reset}"
httpx -silent -t 50 -timeout 10 -l ${out_folder}/subs.txt -p ${ports} -sc -cl -title -o ports.txt

printf "${cyan}"
cowsay "Probing working http and https servers"
printf "${reset}"
httpx -l ${out_folder}/subs.txt -o ${out_folder}/alive.txt

printf "${cyan}"
cowsay "Crawl and gather js endpoints"
printf "${reset}"
gospider -S ${out_folder}/alive.txt -q -a -t 5 -c 10 --sitemap -o ${out_folder}/urls.txt
cat ${out_folder}/urls.txt  | grep -Eo 'https?://[^ ]+' | sed 's/]$//' | unfurl -u domains > ${out_folder}/sub_scrape.txt

printf "${cyan}"
cowsay "Subdomain Takeover Scan"
NtHiM -f ${out_folder}/alive.txt -o ${out_folder}/sub_tko.txt



printf "Done${reset}\n"
