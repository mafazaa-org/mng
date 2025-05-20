#!/usr/bin/bash

rm -rf c

source ./.env

docker run --rm -v ./c:/c docker.elastic.co/elasticsearch/elasticsearch:9.0.1 /bin/bash -c "
    /usr/share/elasticsearch/bin/elasticsearch-certutil ca --out /c/elastic-ca.p12 --pass '$CA_PASSWORD' --ca-dn 'CN=Mafazaa Elasticsearch CA' &&
    /usr/share/elasticsearch/bin/elasticsearch-certutil cert --ca /c/elastic-ca.p12 --ca-pass '$CA_PASSWORD' --out /c/elastic-certificates.p12 --pass '$CERT_PASSWORD' --name elasticsearch --dns localhost,elasticsearch --ip 127.0.0.1,172.27.0.2"

openssl pkcs12 -in ./c/elastic-ca.p12 -passin "pass:$CA_PASSWORD" -out ./c/elastic-ca.pem -clcerts -nokeys

openssl pkcs12 -in ./c/elastic-certificates.p12 -passin "pass:$CERT_PASSWORD" -out ./c/elastic-certificates.pem -clcerts -nokeys

openssl req -x509 -newkey rsa:4096 -nodes -keyout "./c/kibana.key" -out "./c/kibana.crt" -days 365 \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost" \
    -addext "subjectAltName=DNS:localhost,kibana,IP:127.0.0.1"
