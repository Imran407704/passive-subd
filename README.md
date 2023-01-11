
# Passive-subd

This is a Simple Bash Script For Automating the Process of gathering the Passive Subdomain Enumeration from various tools like Subfinder, Assetfinder, Amass etc... Very Useful for Bug Bounty Hunters :)

# How to use ?
```
git clone https://github.com/Imran407704/passive-subd.git
```
```
cd passive-subd
```
```
chmod +x passive-subd.sh 
```
```
./passive-subd.sh TARGET.TLD
./passive-subd.sh bugcrowd.com 
```
All in one Command 
```
git clone https://github.com/Imran407704/passive-subd; cd passive-subd; chmod +x passive-subd.sh
```
## Install this tools 1st

[Subfinder](https://github.com/projectdiscovery/subfinder)

```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
```
[Assetfinder](https://github.com/tomnomnom/assetfinder)
```
go install -v github.com/tomnomnom/assetfinder@latest
```
[Amass](https://github.com/OWASP/Amass)
```
go install -v github.com/OWASP/Amass/v3/...@master
```

[Findomain](https://github.com/Findomain/Findomain)
Linux Installation Docs
```
https://github.com/Findomain/Findomain/blob/master/docs/INSTALLATION.md#installation-in-linux-using-compiled-artifacts
```

[httpx](https://github.com/projectdiscovery/httpx)
```
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
```
