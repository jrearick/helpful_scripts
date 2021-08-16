#!/bin/bash

set -e

# TODO: detect if we're in a backdrop root directory, if not fail out.
echo "Assuming we're in the backdrop root directory."

# Get the current version number
CURRENT_VERSION=$(php -r "include 'core/includes/bootstrap.inc'; echo BACKDROP_VERSION;")
echo "Current version is $CURRENT_VERSION"

# Get the new version number
NEW_VERSION=$(curl -sS "https://api.github.com/repos/backdrop/backdrop/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo "New version is $NEW_VERSION"

if [ "$CURRENT_VERSION" = "$NEW_VERSION" ]; then
  echo "Versions are the same. Exiting"
  exit
fi

# Backup the core directory
mv core core.bak.$CURRENT_VERSION

# Install the new core directory
curl -sS -O -L https://github.com/backdrop/backdrop/archive/refs/tags/$NEW_VERSION.tar.gz
tar -xzf $NEW_VERSION.tar.gz
mv backdrop-$NEW_VERSION/core ./core

# clean up
rm $NEW_VERSION.tar.gz
rm -Rf backdrop-$NEW_VERSION

# Instructions
echo
echo
echo "All done..."
echo
echo "We backed up your core directory to core.bak.$CURRENT_VERSION. If you don't want to accidentally commit these backups, you can add the following to your .gitignore file:" | fold -s
echo " core.bak.*"
echo
echo "Be sure to read *ALL* the release notes between $CURRENT_VERSION and $NEW_VERSION to see if you need to update any scaffold files like .htaccess, robots.txt, etc. Visit the releases page at " | fold -s
echo " https://github.com/backdrop/backdrop/releases/"
echo
