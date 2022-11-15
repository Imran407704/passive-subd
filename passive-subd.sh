#!/bin/bash

domain=$1

subdomain(){

mkdir -p output_passive_subdomains/$domain

echo "🔁 Started Subfinder"
subfinder -d $domain -silent > output_passive_subdomains/$domain/subfinder.txt
printf "✅ Total subfinder-subdomains   :  $(wc -l output_passive_subdomains/$domain/subfinder.txt)\n\n"

echo "🔁 Started assetfinder"
assetfinder -subs-only $domain > output_passive_subdomains/$domain/assetfinder.txt
printf "✅ Total assetfinder-subdomains :  $(wc -l output_passive_subdomains/$domain/assetfinder.txt)\n\n"

echo "🔁 Start riddler.io"
curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u > output_passive_subdomains/$domain/riddler.txt
printf "✅ Total riddler-subdomains     :  $(wc -l output_passive_subdomains/$domain/riddler.txt)\n\n"

echo "🔁 Started Amass"
amass enum -passive -norecursive -noalts -config /home/imran407704/.config/amass/config/config.ini -d $domain > output_passive_subdomains/$domain/amass.txt
printf "✅ Total amass-subdomains       :  $(wc -l output_passive_subdomains/$domain/amass.txt)\n\n"

echo "🔁 Started WaybackMachine"
curl -sk "http://web.archive.org/cdx/search/cdx?url=*.$domain&output=txt&fl=original&collapse=urlkey&page=" | awk -F/ '{gsub(/:.*/, "", $3); print $3}' | sort -u > output_passive_subdomains/$domain/WaybackMachine.txt
printf "✅ Total WaybackMachine         :  $(wc -l output_passive_subdomains/$domain/WaybackMachine.txt)\n\n"

echo "🔁 Started crt.sh"
curl -sk "https://crt.sh/?q=%.$domain&output=json" | tr ',' '\n' | awk -F'"' '/name_value/ {gsub(/\*\./, "", $4); gsub(/\\n/,"\n",$4);print $4}' > output_passive_subdomains/$domain/crt.txt
printf "✅ Total crt-subdomains         :  $(wc -l output_passive_subdomains/$domain/crt.txt)\n\n"

echo "🔁 Started jldc"
curl -s "https://jldc.me/anubis/subdomains/$domain" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u > output_passive_subdomains/$domain/jldc.txt
printf "✅ Total jldc                   :  $(wc -l output_passive_subdomains/$domain/jldc.txt)\n\n"

echo "🔁 Started findomain"
findomain -t $domain --unique-output output_passive_subdomains/$domain/findomain.txt
printf "✅ Total findomain                   :  $(wc -l output_passive_subdomains/$domain/findomain.txt)\n\n"


cat output_passive_subdomains/$domain/*.txt > output_passive_subdomains/$domain/all-subd.txt
cat output_passive_subdomains/$domain/all-subd.txt | sort -u > output_passive_subdomains/$domain/uniq-subd.txt
cat output_passive_subdomains/$domain/uniq-subd.txt | httpx > output_passive_subdomains/$domain/live.txt

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

printf "Total subfinder-subdomains   :  $(wc -l output_passive_subdomains/$domain/subfinder.txt)\n"
printf "Total assetfinder-subdomains :  $(wc -l output_passive_subdomains/$domain/assetfinder.txt)\n"
printf "Total riddler-subdomains     :  $(wc -l output_passive_subdomains/$domain/riddler.txt)\n"
printf "Total amass-subdomains       :  $(wc -l output_passive_subdomains/$domain/amass.txt)\n"
printf "Total WaybackMachine         :  $(wc -l output_passive_subdomains/$domain/WaybackMachine.txt)\n"
printf "Total crt-subdomains         :  $(wc -l output_passive_subdomains/$domain/crt.txt)\n"
printf "Total jldc                   :  $(wc -l output_passive_subdomains/$domain/jldc.txt)\n"
printf "Total findomain              :  $(wc -l output_passive_subdomains/$domain/findomain.txt)\n\n"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

printf "Total all-subdomains  :  $(wc -l output_passive_subdomains/$domain/all-subd.txt)\n"
printf "Total uniq-subdomians :  $(wc -l output_passive_subdomains/$domain/uniq-subd.txt)\n"
printf "Total live-subdomians :  $(wc -l output_passive_subdomains/$domain/live.txt)\n"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

}
subdomain
