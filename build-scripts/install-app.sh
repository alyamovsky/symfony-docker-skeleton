#!/bin/bash



COMPOSER_CMD_PREFIX="docker run --rm -u $(id -u):$(id -g) -v $(pwd):/app composer:lts"
COMPOSER_CMD=$COMPOSER_CMD_PREFIX+" composer:lts"

APP_DIR="app_new"

$COMPOSER_CMD create-project symfony/skeleton:"6.4.*" $APP_DIR

cd $APP_DIR || exit

COMPOSER_CMD=$COMPOSER_CMD_PREFIX" -w $(pwd)/$APP_DIR+" composer:lts"

# shellcheck disable=SC2199
if [[ " $@ " =~ " webapp " ]]; then
    echo "$COMPOSER_CMD"
    $COMPOSER_CMD require webapp
fi

#mkdir -p app/tests
cp -R ../assets/tests/* $APP_DIR/tests/

cp ../phpunit.xml.dist $APP_DIR/

echo "Installation and setup completed."
