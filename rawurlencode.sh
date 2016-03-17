string="${1}"
strlen=${#string}
encoded=""

for (( pos=0 ; pos<strlen ; pos++ )); do
  c=${string:$pos:1}
  case "$c" in
    [-_.~a-zA-Z0-9] ) o="${c}" ;;
    " " ) o="+" ;;
    * ) printf -v o '%%%02x' "'$c"
   esac
  encoded+="${o}"
done
echo "${encoded}"
