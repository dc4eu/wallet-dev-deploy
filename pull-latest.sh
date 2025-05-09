#!/usr/bin/env bash

ROOT_DIR=$PWD

declare -A repos

repos=(
    ['wallet-frontend']='https://github.com/wwwallet/wallet-frontend'
    ['wallet-backend-server']='https://github.com/wwwallet/wallet-backend-server'
    ['wallet-ecosystem']='https://github.com/wwwallet/wallet-ecosystem'
)

for key in ${!repos[@]}; do
    if [ ! -d "$ROOT_DIR/apps/$key" ]; then
        git clone --recurse-submodules ${repos[${key}]} $ROOT_DIR/apps/$key
    else
        cd $ROOT_DIR/apps/$key && git pull --recurse-submodules;
    fi
done
