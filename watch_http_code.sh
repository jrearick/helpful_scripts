#!/bin/bash

set -e

[ -z "$1" ] && echo -e "Example:\n$0 http://www.example.com" && exit 1;

# Number of seconds between checks.
# 900 seconds = 15 mins
durationSleep=900;

original=$(curl -s -I $1 |grep "HTTP/");

echo "Original HTTP Code:";
echo $original;

echo "";
echo "Watching $1 every $durationSleep seconds...";
echo "";

stop=0;
while [ $stop -lt 1 ]
do
  new=$(curl -s -I $1 |grep "HTTP/");
  
  if [[ "$new" != "$original" ]]
  then
    stop=1;
    
    echo "HTTP Code Changed!";
    echo $new;
     
    # Ring the bell to get attention.
    echo -e "\a\a";
    say "HTTP Code Changed!" &
    
  else
    sleep $durationSleep;
  fi
done
