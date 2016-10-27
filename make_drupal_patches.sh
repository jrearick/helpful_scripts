#!/bin/bash

# Example: make_drupal_patches.sh 7.44 7.50
# Creates patches between the versions given for both git sourced Drupal and manually 
# downloaded Drupal. Patch files are placed in ~/drupal_patches/
#
# Assumes Drupal 7.

set -e

[ -z "$1" ] && echo "From Version Required" && exit 1;
[ -z "$2" ] && echo "To Version Required" && exit 1;

FROM=$1
TO=$2

# Create git patch
cd /tmp
rm -Rf drupal-patch
# Shallow checkout of just the 7.x branch to save time.
git clone git://git.drupal.org/project/drupal.git --branch 7.x --single-branch drupal-patch
cd drupal-patch
git diff --binary $FROM $TO > ~/drupal_patches/$FROM-to-$TO-git.patch
cd /tmp
rm -Rf drupal-patch

# Create downloaded patch
cd /tmp
mkdir drupal-patch
cd drupal-patch
drush dl drupal-$FROM
drush dl drupal-$TO
diff -ur drupal-$FROM drupal-$TO > ~/drupal_patches/$FROM-to-$TO-download.patch ||:
cd /tmp
rm -Rf drupal-patch

echo "Created git patch:"
echo "git apply -v ~/drupal_patches/$FROM-to-$TO-git.patch"
echo
echo "Created download patch:"
echo "patch -p1 < ~/drupal_patches/$FROM-to-$TO-download.patch"
echo 
