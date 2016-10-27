#!/bin/bash

set -e

[ -z "$1" ] && echo -e "Example:\n$0 www.ent.iastate.edu" && exit 1;

# 900 seconds = 15 mins
durationSleep=900;

original=$(dig $1 |grep -A1 "ANSWER SECTION"|tail -1);

echo "Original Record: ";
echo $original;

echo "";
echo "Watching DNS every $durationSleep seconds...";
echo "";

stop=0;
while [ $stop -lt 1 ]
do
  new=$(dig $1 |grep -A1 "ANSWER SECTION"|tail -1);
  
  if [[ "$new" !=  "$original" ]]
  then
    stop=1;

    echo "DNS Record Updated!"
    echo $new;
    
    # Ring the bell to get attention.
    echo -e "\a\a\a\a";
    say "DNS Record Updated!"
    
  else
    sleep $durationSleep;
  fi
done
