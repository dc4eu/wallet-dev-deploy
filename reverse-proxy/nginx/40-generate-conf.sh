#!/usr/bin/env sh

templates_dir="/templates"
output_dir="/etc/nginx/conf.d"

rm -f $output_dir/*.conf

for domain in WALLET_DOMAIN DEMO_ISSUER_DOMAIN; do
    value=$(eval "echo \$$domain")

    if [ -n "$value" ]; then
        name=$(echo "$domain" | tr '[:upper:]' '[:lower:]')
        template_name="$name.conf.template"
        template_path="$templates_dir/$template_name"
        output_path="$output_dir/$name.conf"

        if [ -f "$template_path" ]; then
            envsubst "\$$value" < "$template_path" > "$output_path"
        else
            echo "Template $template_path not found!"
        fi
    fi

done