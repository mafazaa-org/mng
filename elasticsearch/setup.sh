#!/usr/bin/bash

ELASTIC_PASSWORD=$1
KIBANA_SYSTEM_PASSWORD=$2

until curl -s -u "elastic:$ELASTIC_PASSWORD" --cacert /usr/share/elasticsearch/config/certs/elastic-ca.pem https://localhost:9200; do
    echo "Waiting for Elasticsearch..."
    sleep 5
done
# Set password for kibana_system user
/usr/share/elasticsearch/bin/elasticsearch-reset-password -u kibana_system -a -b -f <<<"$KIBANA_SYSTEM_PASSWORD"

echo "Elasticsearch setup complete"

wait
