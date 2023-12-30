#!/bin/bash

CONFIG_DIR="$CONFLUENT_HOME/etc/kafka-connect"
PROPERTIES_FILE="connect-worker.properties"
PROPERTIES_FILE_PATH="$CONFIG_DIR/$PROPERTIES_FILE"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Error: Configuration directory $CONFIG_DIR does not exist."
    exit 1
fi

# Generating properties file
echo "Generating properties file as $PROPERTIES_FILE_PATH/"
source connect_env_to_props.sh "$PROPERTIES_FILE_PATH"

echo -e "\n$PROPERTIES_FILE configs\n"
cat "$PROPERTIES_FILE_PATH"


echo -e "\n\nStarting Kafka Connect from $CONFLUENT_PACKAGE in distributed mode\n"
# Starts kafka Connect in connect-distributed mode and return 1 if error
if ! connect-distributed "$PROPERTIES_FILE_PATH"; then
    echo "Error: Kafka Connect terminated with exit code 1."
    exit 1
fi
