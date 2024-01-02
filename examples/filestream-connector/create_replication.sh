#!/bin/bash
bootstrap_server="kafka:19092"
topic_name="test-replication"
connector_config_file="filestream-sink-connector.json"
connector_api_url="http://kafka-connect:8083/connectors/"


echo "Creating kafka topic'$topic_name' ."
kafka-topics --create --bootstrap-server "$bootstrap_server" --topic "$topic_name" --replication-factor 1 --partitions 1

echo "Creating connector using file '$connector_config_file'..."
curl -X POST -H "Content-Type: application/json" -d @"$connector_config_file" "$connector_api_url"
