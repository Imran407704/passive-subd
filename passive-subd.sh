#!/bin/bash

domain=$1

subdomain(){

mkdir -p output_passive_subdomains/$domain


echo "🔁 Started crt.sh"
curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > output_passive_subdomains/$domain/crt.txt
printf "✅ Done crt.sh\n\n"

echo "🔁 Started Subfinder"
subfinder -d $domain -silent > output_passive_subdomains/$domain/subfinder.txt
printf "✅ Done Subfinder\n\n"

echo "🔁 Started assetfinder"
assetfinder --subs-only output_passive_subdomains/$domain | tee output_passive_subdomains/$domain/assetfinder.txt
printf "✅ Done assetfinder\n\n"

echo "🔁 Started Amass"
amass enum -passive -silent -d $domain > output_passive_subdomains/$domain/amass.txt
printf "✅ Done Amass\n\n"
 
cat output_passive_subdomains/$domain/*.txt > output_passive_subdomains/$domain/all-subd.txt
cat output_passive_subdomains/$domain/all-subd.txt | sort -u > output_passive_subdomains/$domain/uniq-subd.txt

cat output_passive_subdomains/$domain/uniq-subd.txt | httpx > output_passive_subdomains/$domain/live.txt

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

printf "Total crt-subdomains         :  $(wc -l output_passive_subdomains/$domain/crt.txt)\n"
printf "Total subfinder-subdomains   :  $(wc -l output_passive_subdomains/$domain/subfinder.txt)\n"
printf "Total assetfinder-subdomains :  $(wc -l output_passive_subdomains/$domain/assetfinder.txt)\n"
printf "Total amass-subdomains       :  $(wc -l output_passive_subdomains/$domain/amass.txt)\n"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

printf "Total all-subdomains  :  $(wc -l output_passive_subdomains/$domain/all-subd.txt)\n"
printf "Total uniq-subdomians :  $(wc -l output_passive_subdomains/$domain/uniq-subd.txt)\n"
printf "Total live-subdomians :  $(wc -l output_passive_subdomains/$domain/live.txt)\n"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


}
subdomain





