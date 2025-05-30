#!/bin/bash

set -e

[ -z "$1" ] && echo -e "Example:\n$0 example.com txt 8.8.8.8" && exit 1;

DOMAIN=$1
TYPE=$2
NAMESERVER=$3

# Be a good citizen and don't spam query.
# 900 seconds = 15 mins
durationSleep=900;

echo
if [ -z $TYPE ];
then
  TYPE="A"
fi

if [ -z $NAMESERVER ];
then
  echo "NAMESERVER: system"
else
  echo "NAMESERVER: $NAMESERVER"
  NAMESERVER="@$NAMESERVER"
fi

echo "DOMAIN: $DOMAIN"
echo "TYPE: $TYPE"
echo

original_response=$(dig -t $TYPE $DOMAIN $NAMESERVER +short)
# When multiple values exist, they come in random order. Alphabetize them.
original=$(echo "$original_response" | sort) 


echo "Original Record: ";
if [ -z "${original}" ]
then
  echo "Not Found"
else
  echo "$original";
fi

echo "";
echo "Watching DNS every $durationSleep seconds...";
echo "";

stop=0;
while [ $stop -lt 1 ]
do
  new_response=$(dig -t $TYPE $DOMAIN $NAMESERVER +short);
  # When multiple values exist, they come in random order. Alphabetize them.
  new=$(echo "$new_response" | sort)
  
  if [[ "$new" !=  "$original" ]]
  then
    stop=1;

    echo "DNS Record Updated!"
    echo "$new";
    
    # Ring the bell to get attention.
    echo -e "\a";
    say "DNS Rec-ord Updated!"&
    
  else
    printf "."
    sleep $durationSleep;
  fi
done
