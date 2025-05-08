#!/usr/bin/env sh

echo "0 0 1 * * nginx -s reload >> /var/log/cron.log 2>&1" >> /etc/crontabs/root
touch /var/log/cron.log
crond
