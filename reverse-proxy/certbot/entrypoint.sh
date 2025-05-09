#!/usr/bin/env sh
apk update && apk add dcron

domains="$WALLET_DOMAIN $DEMO_ISSUER_DOMAIN"

for domain in $domains; do
  if [ ! -f "/etc/letsencrypt/live/$domain/fullchain.pem" ] || [ ! -f "/etc/letsencrypt/live/$domain/privkey.pem" ]; then
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

echo "0 0 1 * * certbot renew >> /var/log/cron.log 2>&1" >> /etc/crontabs/root
touch /var/log/cron.log
crond -f