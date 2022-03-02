#!/bin/bash

domain=$1

subdomain(){

mkdir -p output_passive_subdomains/$domain/target


echo "🔁 Started crt.sh"
curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > output_passive_subdomains/$domain/target/crt.txt
printf "✅ Done crt.sh\n\n"

echo "🔁 Started Subfinder"
subfinder -d $domain -silent > output_passive_subdomains/$domain/target/subfinder.txt
printf "✅ Done Subfinder\n\n"

echo "🔁 Started assetfinder"
assetfinder --subs-only output_passive_subdomains/$domain | tee output_passive_subdomains/$domain/target/assetfinder.txt
printf "✅ Done assetfinder\n\n"

echo "🔁 Started Amass"
amass enum -passive -silent -d $domain > output_passive_subdomains/$domain/target/amass.txt
printf "✅ Done Amass\n\n"
 
cat output_passive_subdomains/$domain/target/*.txt > output_passive_subdomains/$domain/target/all-subd.txt
cat output_passive_subdomains/$domain/target/all-subd.txt | sort -u > output_passive_subdomains/$domain/target/uniq-subd.txt

cat output_passive_subdomains/$domain/target/uniq-subd.txt | httpx > output_passive_subdomains/$domain/target/live.txt

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

printf "Total crt-subdomains         :  $(wc -l output_passive_subdomains/$domain/target/crt.txt)\n"
printf "Total subfinder-subdomains   :  $(wc -l output_passive_subdomains/$domain/target/subfinder.txt)\n"
printf "Total assetfinder-subdomains :  $(wc -l output_passive_subdomains/$domain/target/assetfinder.txt)\n"
printf "Total amass-subdomains       :  $(wc -l output_passive_subdomains/$domain/target/amass.txt)\n"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

printf "Total all-subdomains  :  $(wc -l output_passive_subdomains/$domain/target/all-subd.txt)\n"
printf "Total uniq-subdomians :  $(wc -l output_passive_subdomains/$domain/target/uniq-subd.txt)\n"
printf "Total live-subdomians :  $(wc -l output_passive_subdomains/$domain/target/live.txt)\n"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


}
subdomain






