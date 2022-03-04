#!/bin/bash

domain=$1

subdomain(){

mkdir -p output_passive_subdomains/$domain/subdomains

echo "🔁 Started crt.sh"
curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > output_passive_subdomains/$domain/subdomains/crt.txt
printf "✅ Done crt.sh\n\n"

echo "🔁 Started Subfinder"
subfinder -d $domain -silent > output_passive_subdomains/$domain/subdomains/subfinder.txt
printf "✅ Done Subfinder\n\n"

echo "🔁 Started assetfinder"
assetfinder --subs-only output_passive_subdomains/$domain | tee output_passive_subdomains/$domain/subdomains/assetfinder.txt
printf "✅ Done assetfinder\n\n"

echo "🔁 Start bufferover.run"
curl -s https://dns.bufferover.run/dns?q=.$domain | jq -r .FDNS_A[] | cut -d',' -f2 | sort -u > output_passive_subdomains/$domain/subdomains/bufferover.txt
printf "✅ Done bufferover.run\n\n"

echo "🔁 Start riddler.io"
curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u > output_passive_subdomains/$domain/subdomains/riddle.txt
printf "✅ Done riddle.io\n\n"

echo "🔁 Started Amass"
amass enum -passive -silent -d $domain > output_passive_subdomains/$domain/subdomains/amass.txt
printf "✅ Done Amass\n\n"

 
cat output_passive_subdomains/$domain/subdomains/*.txt > output_passive_subdomains/$domain/subdomains/all-subd.txt
cat output_passive_subdomains/$domain/subdomains/all-subd.txt | sort -u > output_passive_subdomains/$domain/subdomains/uniq-subd.txt
cat output_passive_subdomains/$domain/subdomains/uniq-subd.txt | httpx > output_passive_subdomains/$domain/subdomains/live.txt

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

printf "Total crt-subdomains         :  $(wc -l output_passive_subdomains/$domain/subdomains/crt.txt)\n"
printf "Total subfinder-subdomains   :  $(wc -l output_passive_subdomains/$domain/subdomains/subfinder.txt)\n"
printf "Total assetfinder-subdomains :  $(wc -l output_passive_subdomains/$domain/subdomains/assetfinder.txt)\n"
printf "Total bufferover-subdomains  :  $(wc -l output_passive_subdomains/$domain/subdomains/bufferover.txt)\n"
printf "Total riddler-subdomains     :  $(wc -l output_passive_subdomains/$domain/subdomains/riddle.txt)\n"
printf "Total amass-subdomains       :  $(wc -l output_passive_subdomains/$domain/subdomains/amass.txt)\n"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

printf "Total all-subdomains  :  $(wc -l output_passive_subdomains/$domain/subdomains/all-subd.txt)\n"
printf "Total uniq-subdomians :  $(wc -l output_passive_subdomains/$domain/subdomains/uniq-subd.txt)\n"
printf "Total live-subdomians :  $(wc -l output_passive_subdomains/$domain/subdomains/live.txt)\n"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

}
subdomain
