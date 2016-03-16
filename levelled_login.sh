#Parse the input, get security level
case "$1" in
  low) echo "Logging in at a low security level."; LEVEL=$1;;
  medium) echo "Logging in at a medium security level."; LEVEL=$1;;
  high) echo "Logging in at a high security level."; LEVEL=$1;;
  impossible) echo "Logging in at an impossible security level."; LEVEL=$1;;
  * ) echo "Please specify a security level!\nUsage: $0 {low|medium|high|impossible}"; exit 1;;
esac
#Login to main page with known details
CSRF=$(curl -s -c dvwa.cookie 192.168.178.98/dvwa/login.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
curl -s -L -b dvwa.cookie -d $"username=admin&password=password&Login=Login&user_token=${CSRF}" 192.168.178.98/dvwa/login.php > /dev/null
#Change To the desired level (not actually necessary, makes it look like actual user traffic to the server)
CSRFSEC=$(curl -s -L -c dvwa.cookie.${LEVEL} -b dvwa.cookie 192.168.178.98/dvwa/security.php | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
curl -s -L -b dvwa.cookie.${LEVEL} -c dvwa.cookie.${LEVEL} -d $"security=${LEVEL}&seclev_submit=Submit&user_token=${CSRFSEC}" 192.168.178.98/dvwa/security.php > /dev/null
#Write cookie content to environment for convenience (ergo: script must be sourced when calling it)
export SESSIONID="$(grep PHPSESSID dvwa.cookie | awk -F ' ' '{print $7}')"
export SECURITY="${LEVEL}"
rm -f dvwa.cookie*
