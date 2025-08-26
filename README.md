# SUNET wwWallet dev instance

Docker based setup of wwWallet to run on SUNET's infrastructure.

## Requirements

* Git
* Docker and Docker Compose installed
* If deploying to prod:
    * a publicly accessible vm with 3 domains pointed to it for the Wallet, Issuer and Verifier services
    * ports `80` and `443` open

## Setup

Besides cloining the repo, this is what you need to do:

### 1. Clone wallet codebase and build Docker images

After cd'ing into the directory you cloned this project to, run `bash pull-latest.sh` to pull the wwWallet repos into `apps/`.

> [!NOTE]
> You might get an error when the script attempts to fetch the submodules of the `wallet-ecosystem` project, this is due to 
> how that repo has configured it's submodules. As a **temporary fix**, edit `apps/wallet-ecosystem/.git/config` like so:
>```diff
>// ...
>[submodule "wallet-backend-server"]
>-   url = git@github.com:wwwallet/wallet-backend-server.git
>+   url = https://github.com/wwwallet/wallet-backend-server.git
>[submodule "wallet-enterprise"]
>-	url = git@github.com:wwwallet/wallet-enterprise.git
>+	url = https://github.com/wwwallet/wallet-enterprise.git
>[submodule "wallet-frontend"]
>-	url = git@github.com:wwwallet/wallet-frontend.git
>+	url = https://github.com/wwwallet/wallet-frontend.git
>```
> After this, you need to run `bash pull-latest.sh` again to fetch the submodules.

> [!NOTE]
> As of writing, you need to manually update the `wallet-enterprise` submodule inside `apps/wallet-ecosystem`:
>```bash
> cd apps/wallet-ecosystem/wallet-enterprise \
> && git checkout v0.2.9 \
> && git pull origin v0.2.9
>```

> [!NOTE]
> As of writing, you need to manually update the `wallet-common` submodule inside `apps/wallet-ecosystem/lib`:
>```bash
> cd apps/wallet-ecosystem/lib/wallet-common \
> && git checkout v0.2.9 \
> && git pull origin v0.2.9
>```

Now you're ready to build *most* of the Docker images we need:
```bash
docker compose build backend-server issuer verifier
```


### 2. Frontend config and build

You need to configure the frontend before you can build it. In order to do this:
1. `cd apps/wallet-frontend`
2. `cp .env.example .env.prod`
3. Edit `.env.prod` file if necessary (if deploying to prod make sure you change the urls to match your setup). For details refer to [wwWallet/wallet-frontend docs](https://github.com/wwWallet/wallet-frontend)
4. Build the Docker image `docker compose build frontend`.


### 3. Configure Issuer, Verifier and Backend

> [!Note]
> Make sure that `appSecret` is the same in each of the `backend-server`, `issuer` and `verifier` configs.
> You can generate `appSecret` by running `openssl rand -base64 64`.

#### 3.1 Issuer
1. `cd apps-config/issuer`
2. `cp config/config.template.js config/index.js`
3. Edit `config/index.js` as necessary. For details refer to [wwWallet/wallet-ecosystem](https://github.com/wwWallet/wallet-ecosystem). 

#### 3.2 Verifier
1. `cd apps-config/verifier`
2. `cp config/config.template.js config/index.js`
3. Edit `config/index.js` as necessary. For details refer to [wwWallet/wallet-ecosystem](https://github.com/wwWallet/wallet-ecosystem). 

#### 3.3 Backend
1. `cd apps-config/wallet-backend-server`
2. `cp config/config.template.js config/index.js`
3. Edit `config/index.js` as necessary. For details refer to [wwWallet/wallet-backend-server](https://github.com/wwWallet/wallet-backend-server).
4. Add the trusted root cert, Verifier and Issuer details to the database by running: `bash scripts/backend-db/insert-issuer-verifier-data.sh` and enter Issuer and Verifier urls where prompted.


### 4. Reverse proxy (if deploying to prod)

The Caddy service is in the `prod` profile, which means that it won't start by default.

1. `cd reverse-proxy`
2. `cp .env.example .env`
3. Edit the `.env` file to include your domains.


### 5. Start

At this point, you should be good to start up the services:
```bash
docker compose --profile prod up
```

> [!TIP]
> If you're running locally:
> 1. you can include `--profile debug` to get a instance of PHPMyAdmin on http://localhost:8080.
> 2. You shouldn't use `--profile prod`, as it will not work locally.

## Structure

```bash
.
├── apps                      # Source code of wallet front/backend and issuer/verifier.
├── apps-config               # Configs for wallet front/backend and issuer/verifier.
├── reverse-proxy             # Caddy config.
├── scripts                   # Misc. scripts.

│
└── compose.yaml              # Docker Compose config.
```

### apps/

Contains clones of repos that are used to build services that are not available as pre-built docker images, or where this would be impractical, like `wallet-frontend` and `wallet-backend-server`.

### apps-config/

Config for wallet apps, right now `wallet-backend-server` only.

### reverse-proxy/

Configuration files for the services making up the reverse proxy.
