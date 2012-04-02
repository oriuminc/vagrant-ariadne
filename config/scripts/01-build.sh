#!/bin/bash

# Bail if non-zero exit code
set -e

# Check for existence of ENV variables.
: ${PROJECT:?}
: ${SERVER_ROOT_PASSWORD:?}
: ${ACCOUNT_PASS:?}
: ${ACCOUNT_MAIL:?}

BUILD_FILE="/vagrant/data/${PROJECT}/local.${PROJECT}.build"
BUILD_DEST="/mnt/www/html/${PROJECT}"

# Drush make the site structure
drush make ${BUILD_FILE} ${BUILD_DEST} \
  --working-copy \
  --yes

# Install Drupal site.
# Will want to change admin password and email in later script.
ACCOUNT_PASS="admin"
ACCOUNT_MAIL="vagrant@localhost"
drush site-install ${PROJECT} \
  --db-url="mysqli://root:${SERVER_ROOT_PASSWORD}@localhost/${PROJECT}" \
  --root=${BUILD_DEST} \
  --account-pass=${ACCOUNT_PASS} \
  --account-mail=${ACCOUNT_MAIL} \
  --yes

chmod u+w ${BUILD_DEST}/sites/default/settings.php

for f in ${BUILD_DEST}/profiles/${PROJECT}/includes/*.settings.php
do
  # Concatenate newline and snippet, then append to settings.php
  echo "" | cat - $f | tee -a ${BUILD_DEST}/sites/default/settings.php
done

chmod u-w ${BUILD_DEST}/sites/default/settings.php
