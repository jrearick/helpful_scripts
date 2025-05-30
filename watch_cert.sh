#!/bin/bash

set -e

[ -z "$1" ] && echo -e "Example:\n$0 www.example.com" && exit 1;

# 900 seconds = 15 mins
# 300 seconds = 5 mins
durationSleep=300;

original=$(echo | openssl s_client -showcerts -servername $1 -connect $1:443 2>/dev/null | openssl x509 -inform pem -noout -text);

echo "Original Record: ";
echo $original;

echo "";
echo "Watching SSL cert every $durationSleep seconds...";
echo "";

stop=0;
while [ $stop -lt 1 ]
do
  new=$(echo | openssl s_client -showcerts -servername $1 -connect $1:443 2>/dev/null | openssl x509 -inform pem -noout -text);
  
  if [[ "$new" !=  "$original" ]]
  then
    stop=1;

    echo "Cert Record Updated!"
    echo $new;
    
    # Ring the bell to get attention.
    echo -e "\a"&
    say "SSL Certificate Updated!"&
    
  else
    printf "."
    sleep $durationSleep;
  fi
done
