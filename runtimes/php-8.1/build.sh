#!/bin/sh

# Prepare separate directory to prevent changign user's files
cp -R /usr/code/* /usr/builds

# Install User Function Dependencies if package.json exists
cd /usr/builds
if [[ ! -f "composer.json" ]]; then
    mv /usr/local/src/composer.json.fallback /usr/builds/composer.json
else
    php /usr/local/src/prepare.php
fi

# Merge the node_modules from the server into the user's node_modules to be restored later.
cd /usr/local/src/
composer update --no-interaction --ignore-platform-reqs --optimize-autoloader --no-scripts --prefer-dist --no-dev
cp -r /usr/local/src/vendor /usr/builds/vendor

# Finish build by preparing tar to use for starting the runtime
cd /usr/builds
tar --exclude code.tar.gz -zcf /usr/code/code.tar.gz .
