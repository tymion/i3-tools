#!/bin/sh

FILE_NAME=

# DIRECTORIES PATH
export LOCAL_SCRIPTS_PATH=$HOME/bin

if [ -z $XDG_CONFIG_HOME ]; then
    export XDG_CONFIG_HOME=$HOME/.config
fi
export CUSTOM_CONFIG_PATH=$XDG_CONFIG_HOME/polvention

clean_up () {
    rm $CUSTOM_CONFIG_PATH/pid.$FILE_NAME
}

signal_listener() {
    FILE_NAME=`basename $1`
    trap clean_up exit TERM INT HUP
}
