#!/bin/bash
ROOTDIR="/app/"

COMMAND="$1"
shift

if [ "$COMMAND" == "" ]; then
    echo "Error: command is missing"
    exit 1;
fi

function composerLaunch() {

    APPDIR="$2"
    if [ "$APPDIR" == "" ]; then
        echo "directory path missing";
        exit 1
    fi

    if [ ! -d "$APPDIR" ]; then
        echo "directory does not exists";
        exit 1
    fi

    if [ ! -f "$APPDIR/composer.json" ]; then
        echo "composer.json does not exists into the given directory";
        exit 1
    fi

    if [ "$1" == "install" -a -f $APPDIR/composer.lock ]; then
        rm -f $APPDIR/composer.lock
    fi
    composer $1 --prefer-dist --no-progress --no-ansi --no-interaction --working-dir=$APPDIR/
    chown -R $APP_USER_NAME:$APP_GROUP_NAME $APPDIR/vendor $APPDIR/composer.lock
}

case $COMMAND in
    composer-install)
        composerLaunch install $1;;
    composer-update)
        composerLaunch update $1;;
    *)
        echo "helpers.sh: wrong command"
        exit 2
        ;;
esac

