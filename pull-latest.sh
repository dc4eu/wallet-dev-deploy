#!/usr/bin/env bash

declare -A repos

repos=(
    ['wallet-frontend']='https://github.com/wwwallet/wallet-frontend'
    ['wallet-backend-server']='https://github.com/wwwallet/wallet-backend-server'
)

for key in ${!repos[@]}; do
    if [ ! -d "$PWD/apps/$key" ]; then
        git clone ${repos[${key}]} apps/$key
    else
        cd $PWD/apps/$key && git pull;
    fi
done
