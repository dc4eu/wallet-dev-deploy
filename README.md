# SUNET wwWallet dev instance

Docker based setup of wwWallet to run on SUNET's infrastructure.

## Setup

1. **Clone repo.**
2. **Clone wallet apps:** `bash pull-latest.sh`.
3. **Wallet Frontend**
    1. `cd apps/wallet-frontend`
    2. `cp .env.example .env.prod`
    3. Edit env file if necessary (if deploying to prod make sure you change the urls to match your setup). For details refer to [wwWallet/wallet-frontend docs](https://github.com/wwWallet/wallet-frontend)
4. **Wallet Backend Server**
    1. `cd apps-config/wallet-backend-server`
    2. `cp config/config.template.js config/index.js`
    3. Edit `config/index.js` as necessary. For details refer to [wwWallet/wallet-backend-server docs](https://github.com/wwWallet/wallet-backend-server)
        1. You can generate `appSecret` by running `openssl rand -base64 64`.
5. **Certbot & NGINX (if deploying to prod)**
    1. `cd reverse-proxy`
    2. `cp .env.example .env`
    3. Edit the `.env` file to include your domains. `WALLET_DOMAIN` is required.
6. **Build:** `docker compose build`.
7. **Start it up:** `docker compose up` or `docker compose --profile prod up`
8. **Success! 🤞** You should now have the wallet running on the domains you specified in the NGINX config! If you're running locally (without --profile prod), you will find the frontend at http://localhost:3000 and the backend server at http://localhost:8004
9. **Changes**: To fetch the latest commits, you can rerun `bash pull-latest.sh`


## Structure

```bash
.
├── apps                      # Source code of wallet front/backend.
├── apps-config               # Configs for wallet front/backend.
├── reverse-proxy
│   ├── certbot               # Certbot configs.
│   └── nginx                 # Nginx configs.
│
└── compose.yaml              # Docker Compose config.
```

### apps/

Contains clones of repos that are used to build services that are not available as pre-built docker images, or where this would be impractical, like `wallet-frontend` and `wallet-backend-server`.

### apps-config/

Config for wallet apps, right now `wallet-backend-server` only.

### reverse-proxy/

Configuration files for the services making up the reverse proxy.

## Services

### `certbot`
* Dir: `reverse-proxy/certbot`
* Version: `latest`
* Profile: `prod`

Configuration for the certbot service.
The entrypoint.sh file checks for, and if missing, requests SSL certs from Let's Encrypt, as well as a a cron job that renews the certs every month.

It takes 1 environment variable: `WALLET_DOMAIN`. (Possibility to add future services later)

### `nginx`
* Dir: `reverse-proxy/nginx`
* Version: `latest`
* Profile: `prod`

The NGINX web server. Automatically generates the server configuration based on the provided environment variables: `WALLET_DOMAIN`. (Possibility to add future services later)

### `wallet-backend-server`
* Dir: `apps/wallet-backend-server`
* Config: `apps-config/wallet-backend-server`

The wallet backend server.

### `wallet-frontend`
* Dir: `apps/wallet-frontend`

The wallet frontend application.

### `debug-phpmyadmin`
Version: `latest`
Profile: `debug`

For local debugging of wallet database. Doesn't run by default.

## To Do

- [ ] Certs for `wallet-backend-server`.