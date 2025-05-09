#!/usr/bin/env bash
TAG=v0.2.7-1
ROOT_DIR=$PWD

declare -A repos

repos=(
    ['wallet-frontend']='https://github.com/wwwallet/wallet-frontend'
    ['wallet-backend-server']='https://github.com/wwwallet/wallet-backend-server'
    ['wallet-ecosystem']='https://github.com/wwwallet/wallet-ecosystem'
)

for key in ${!repos[@]}; do
    if [ ! -d "$ROOT_DIR/apps/$key" ]; then
        git clone --recurse-submodules ${repos[${key}]} $ROOT_DIR/apps/$key --branch $TAG
    else
        cd $ROOT_DIR/apps/$key && git pull ${repos[${key}]} $TAG --recurse-submodules;
    fi
done
