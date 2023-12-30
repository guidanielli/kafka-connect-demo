#!/bin/bash

PROPERTIES_FILE="$1"
ENV_PREFIX="CONNECT_"

if [ -f "$PROPERTIES_FILE" ]; then
  rm -f "$PROPERTIES_FILE" || {
    echo "Error: Failed to remove existing properties file $PROPERTIES_FILE"
    exit 1
  }
fi

declare -A props


for env_var in $(printenv); do
    IFS='=' read -r env_name val <<< "$env_var"

    if [[ $env_name == $ENV_PREFIX* ]]; then
        raw_name=${env_name#$ENV_PREFIX}
        raw_name=$(tr '[:upper:]' '[:lower:]' <<< "$raw_name")
        raw_name=$(echo "$raw_name" | sed 's/\([^_]\)_\([^_]\)/\1.\2/g')
        raw_name=$(echo "$raw_name" | sed 's/\([^_]\)__\([^_]\)/\1-\2/g')
        raw_name=$(echo "$raw_name" | sed 's/\([^_]\)___\([^_]\)/\1_\2/g')
        
        props["$raw_name"]=$val
    fi
done

for key in "${!props[@]}"; do
    echo "$key=${props[$key]}" >> "$PROPERTIES_FILE" || {
        echo "Error: Failed to write property $key to $PROPERTIES_FILE"
        exit 1
    }
done
