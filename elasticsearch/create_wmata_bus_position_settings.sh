#!/bin/sh

# Load environment variables from file
#export $(egrep -v '^#' ../app/.env | xargs)

export ES_USERNAME="elastic"
export ES_PASSWORD="eOHt7mLwh7CmCZM1B2HQs8Qp"
export ES_URL="https://myoung-demo.es.us-east-1.aws.found.io:443"

echo "Creating WMATA bus position Elasticseach setttings ..."

echo "Uploading component template: mappings"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_component_template/wmata-bus-position-mappings?pretty" -H 'Content-Type: application/json' -d @wmata_bus_position_index_mappings.json

echo "Uploading component template: setttings"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_component_template/wmata-bus-position-settings?pretty" -H 'Content-Type: application/json' -d @wmata_bus_position_index_settings.json

echo "Uploading index template"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_index_template/wmata-bus-position?pretty" -H 'Content-Type: application/json' -d @wmata_bus_position_index_template.json

echo "Uploading ILM policy"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_ilm/policy/wmata-bus-position?pretty" -H 'Content-Type: application/json' -d @wmata_bus_position_lifecycle_policy.json

echo "Uploading routes enrich policy"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_enrich/policy/wmata-bus-routes-policy?pretty" -H 'Content-Type: application/json' -d @wmata_bus_routes_policy.json

echo "Uploading stops enrich policy"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_enrich/policy/wmata-bus-stops-policy?pretty" -H 'Content-Type: application/json' -d @wmata_bus_stops_policy.json

echo "Uploading trips enrich policy"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_enrich/policy/wmata-bus-trips-policy?pretty" -H 'Content-Type: application/json' -d @wmata_bus_trips_policy.json

echo "Executing routes lookup policy"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_enrich/policy/wmata-bus-routes-policy/_execute?pretty"

echo "Executing stops lookup policy"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_enrich/policy/wmata-bus-stops-policy/_execute?pretty"

echo "Executing trips lookup policy"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_enrich/policy/wmata-bus-trips-policy/_execute?pretty"

echo "Uploading lookup policy"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_ingest/pipeline/wmata-bus-lookup?pretty" -H 'Content-Type: application/json' -d @wmata_bus_position_lookup_policy.json

echo "Creating data stream"
curl -X PUT --user ${ES_USERNAME}:${ES_PASSWORD} "${ES_URL}/_data_stream/wmata-bus-position?pretty"


