#!/usr/bin/env bash

# =========================================================================
# Insert demo Issuer and Verifier data into Wallet database
# =========================================================================


SERVICE_NAME='backend-db'

docker compose up -d $SERVICE_NAME

# Get the container ID
CONTAINER_ID=$(docker compose ps -q $SERVICE_NAME)

# Wait for the container to be running
echo "Waiting for container to be running..."
until [ "$(docker inspect -f '{{.State.Running}}' $CONTAINER_ID 2>/dev/null)" == "true" ]; do
  sleep 1
done

# Wait until MySQL responds to ping
echo "Waiting for MySQL to be ready..."
until docker exec "$CONTAINER_ID" mariadb -uroot -proot --silent &> /dev/null; do
  sleep 1
done

echo 'Inserting demo trusted root cert';
CERT='MIICMzCCAdqgAwIBAgIUdgESbTG9nxSXVImFdFHHAHGJ9RwwCgYIKoZIzj0EAwIwIDERMA8GA1UEAwwId3dXYWxsZXQxCzAJBgNVBAYTAkdSMB4XDTI1MDMwNjE1MzczM1oXDTM1MDMwNDE1MzczM1owIDERMA8GA1UEAwwId3dXYWxsZXQxCzAJBgNVBAYTAkdSMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE0Fm2MNVdwcARMDwXVaNJwcy1G182BhnFhv7pDmqs4EFGlPvkG9oA02gBKeddJd7wcngcIH1cbpS64iG4r9d5R6OB8TCB7jASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUfHj4bzyvo4unHysGt+pNa0XsBaIwHwYDVR0jBBgwFoAUfHj4bzyvo4unHysGt+pNa0XsBaIwOgYDVR0fBDMwMTAvoC2gK4YpaHR0cDovL3VzZXJzLnVvYS5nci9+cHN0YW1hdG9wL2NhLWNybC5wZW0wIAYDVR0RBBkwF4YVaHR0cDovL3d3dy53YWxsZXQub3JnMCoGA1UdEgQjMCGGFWh0dHA6Ly93d3cud2FsbGV0LmNvbYIId3dXYWxsZXQwCgYIKoZIzj0EAwIDRwAwRAIgGMfgLwOXvEk0sD3nEtCuwkZRzX9vyYZ/hfg6VPrJszACIHBsYf7toXfUFjr6y1nAJ/oXP9l/fWBDydcQIq+Vnfem'
docker compose exec -it backend-db bash -c "mariadb -uroot -proot wallet -e \"DELETE FROM trusted_root_certificate WHERE certificate = '$cert'; INSERT INTO trusted_root_certificate (certificate) VALUES ('$cert')\"" || {
    echo 'Error inserting truster root cert';
    exit 2;
}

read -p "Enter demo Issuer URL: " demo_issuer_url
if [ "$demo_issuer_url" == '' ]; then
    echo "Not enough input: $demo_issuer_url";
    exit 3;
fi
docker compose exec -it backend-db bash -c "mariadb -uroot -proot wallet -e \"DELETE FROM credential_issuer WHERE credentialIssuerIdentifier = '$demo_issuer_url'; INSERT INTO credential_issuer (credentialIssuerIdentifier, clientId, visible) VALUES ('$demo_issuer_url', '1233', 1)\"" || {
    echo 'Error inserting demo Issuer';
    exit 4;
}

read -p "Enter demo Verifier URL: " demo_verifier_url
if [ "$demo_verifier_url" == '' ]; then
    echo "Not enough input: $demo_verifier_url";
    exit 5;
fi
docker compose exec -it backend-db bash -c "mariadb -uroot -proot wallet -e \"DELETE FROM verifier WHERE url = '$demo_verifier_url'; INSERT INTO verifier (name, url) VALUES ('Friendly Demo Verifier', '$demo_verifier_url')\"" || {
    echo 'Error inserting demo Verifier';
    exit 6;
}
		
docker compose down $SERVICE_NAME;