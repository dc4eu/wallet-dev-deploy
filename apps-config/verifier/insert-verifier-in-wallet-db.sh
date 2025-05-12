#!/usr/bin/env bash

if [ ! $1 ]; then
    exit 13
fi

docker compose exec -it backend-db bash -c "mariadb -uroot -proot wallet -e \"DELETE FROM verifier; INSERT INTO verifier (name, url) VALUES ('Friendly Demo Verifier', '$1')\""
		