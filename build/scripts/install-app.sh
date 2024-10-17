#!/bin/bash

APP_TMP_DIR="build/out/app-tmp"
VERSION=${VERSION:-"6.4"}

if [ -d "./app/vendor" ]; then
  echo "The app is already installed."
  exit 0
fi

docker run --rm -u "$(id -u)":"$(id -g)" -v "$(pwd)":/app composer create-project symfony/skeleton:"$VERSION.*" $APP_TMP_DIR

docker run --rm -u "$(id -u)":"$(id -g)" -v "$(pwd)/$APP_TMP_DIR":/app composer:lts composer require --dev friendsofphp/php-cs-fixer
docker run --rm -u "$(id -u)":"$(id -g)" -v "$(pwd)/$APP_TMP_DIR":/app composer:lts composer require --dev vimeo/psalm

# shellcheck disable=SC2199
if [[ " $OPTIONS " =~ " webapp " ]]; then
  docker run --rm -u "$(id -u)":"$(id -g)" -v "$(pwd)/$APP_TMP_DIR":/app composer:lts composer require webapp
else
  docker run --rm -u "$(id -u)":"$(id -g)" -v "$(pwd)/$APP_TMP_DIR":/app composer:lts composer require --dev -W symfony/test-pack
fi

cp -R $APP_TMP_DIR/. ./app
rm -rf $APP_TMP_DIR

cp -R ./build/assets/* ./app
cp -R ./build/assets/.env.local ./app

echo "The app installation and setup are completed."
