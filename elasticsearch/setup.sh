#!/usr/bin/bash

ELASTIC_PASSWORD=$1
KIBANA_SYSTEM_PASSWORD=$2

until curl -s -u "elastic:$ELASTIC_PASSWORD" --cacert /usr/share/elasticsearch/config/certs/elastic-ca.pem https://localhost:9200; do
    echo "Waiting for Elasticsearch..."
    sleep 5
done
# Set password for kibana_system user
curl -u "elastic:${ELASTIC_PASSWORD}" -X POST -d "{\"password\":\"${KIBANA_SYSTEM_PASSWORD}\"}" https://localhost:9200/_security/user/kibana_system/_password -k -H "Content-Type: application/json"

echo "Elasticsearch setup complete"

wait
