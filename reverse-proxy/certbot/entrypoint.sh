#!/usr/bin/env sh
apk update && apk add dcron

domains="$WALLET_DOMAIN $DEMO_ISSUER_DOMAIN $DEMO_VERIFIER_DOMAIN"

obtained_certs=false

for domain in $domains; do
  if [ ! -f "/etc/letsencrypt/live/$domain/fullchain.pem" ] || [ ! -f "/etc/letsencrypt/live/$domain/privkey.pem" ]; then
    obtained_certs=true

    certbot certonly \
      --standalone \
      --register-unsafely-without-email \
      --agree-tos \
      --no-eff-email \
      -d "$domain" || {
        exit 42;
      };
  fi
done

if [ "$obtained_certs" = true ]; then
  exit 0;
fi

echo "0 0 1 * * certbot renew --webroot --webroot-path /var/www/certbot  >> /var/log/cron.log 2>&1" >> /etc/crontabs/root
touch /var/log/cron.log
crond -f