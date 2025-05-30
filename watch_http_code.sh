#!/bin/bash

set -e

[ -z "$1" ] && echo -e "Example:\n$0 http://www.example.com" && exit 1;

# Number of seconds between checks.
# Be a good citizen and don't spam query.
# 900 seconds = 15 mins
durationSleep=300;

original=$(curl -s -I --insecure $1 |grep "HTTP/");

echo "Original HTTP Code:";
echo $original;

echo "";
echo "Watching $1 every $durationSleep seconds...";
echo "";

stop=0;
while [ $stop -lt 1 ]
do
  new=$(curl -s -I --insecure $1 |grep "HTTP/")
  
  if [[ "$new" != "$original" ]]
  then
    stop=1;
    
    echo "HTTP Code Changed!";
    echo $new;
     
    # Ring the bell to get attention.
    echo -e "\a\a";
    say "HTTP Code Changed!" &
    
  else
    printf '.'
    sleep $durationSleep;
  fi
done
