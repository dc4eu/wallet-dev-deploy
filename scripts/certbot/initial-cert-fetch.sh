#!/usr/bin/env bash

# =========================================================================
# Insert demo Issuer and Verifier data into Wallet database
# =========================================================================

docker compose run --publish 80:80 certbot;