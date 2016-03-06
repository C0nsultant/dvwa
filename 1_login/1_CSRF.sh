#Get an idea of what a login looks like
# curl -s -i -L 192.168.178.98/dvwa > root.html 
#
#Capture raw HTTP from a login attempt
# mitmproxy 
#
#Use that data to replay a login attempt
# curl -s -i -L -d $'username=username&password=password&Login=Login&user_token=5660512c80e2ba3f7f9e2ac1dacb6856' 192.168.178.98/dvwa/login.php > test.html
#
#Check for differences between server's replies
# diff root.html test.html
