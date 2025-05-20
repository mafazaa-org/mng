#!/usr/bin/bash

rm -rf c

source ./.env

docker run --rm -v ./c:/c docker.elastic.co/elasticsearch/elasticsearch:9.0.1 /bin/bash -c "
    /usr/share/elasticsearch/bin/elasticsearch-certutil ca --out /c/elastic-ca.p12 --pass '$CA_PASSWORD' --ca-dn 'CN=Mafazaa Elasticsearch CA' &&
    /usr/share/elasticsearch/bin/elasticsearch-certutil cert --ca /c/elastic-ca.p12 --ca-pass '$CA_PASSWORD' --out /c/elastic-certificates.p12 --pass '$CERT_PASSWORD' --name elasticsearch --dns localhost,elasticsearch --ip 127.0.0.1,172.27.0.2"

openssl pkcs12 -in ./c/elastic-ca.p12 -passin "pass:$CA_PASSWORD" -out ./c/elastic-ca.pem -clcerts -nokeys
