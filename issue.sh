#!/bin/bash

[ -z "$1" ] && echo 'provide a Jira ticket to open in your browser. Eg. \n\nissue.sh lugg-227\n\nwill open the Jira issue LUGG-227 in your browser' && exit 1;

OS=`uname`
instance='https://isubit.atlassian.net'

if [ "$OS" = 'Darwin' ]; then
  ISSUE=$1
  
  if [[ $ISSUE != *"-"* ]]; then
    # TODO: If issue doesn't contain a dash attempt to normalize with a dash
    
    # If $ISSUE is just a number, assume it's against luggage
    re='^[0-9]+$'
    if [[ $ISSUE =~ $re ]]; then
      ISSUE=LUGG-$ISSUE
    fi
  fi
  
  # if you have a Jira app, use that. http://stackoverflow.com/questions/6682335/how-can-check-if-particular-application-software-is-installed-in-mac-os
  APPLESCRIPT=`cat <<EOF
  
  on run argv
    try
      tell application "Finder"
        set appname to name of application file id "com.fluidapp.FluidApp.Jira"
        return 1
      end tell
    on error err_msg number err_num
      return 0
    end try
  end run

EOF`
  
  retcode=`osascript -e "$APPLESCRIPT"`
  
  if [ $retcode = 1 ]; then
    open -b com.fluidapp.FluidApp.Jira $instance/browse/$ISSUE
  else
    open $instance/browse/$1
  fi
  
else
  echo "This command only works on Mac OS X"
fi
