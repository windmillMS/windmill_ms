#!/bin/bash

DOCKER_COMPOSE_FILE="docker-compose.yml"

# Parse ports from the docker-compose file
ports=$(grep -E '^\s+- "[0-9]+:[0-9]+' "$DOCKER_COMPOSE_FILE" | grep -oE '[0-9]+:[0-9]+' | cut -d':' -f2)

# Check if ports are in use
for port in $ports; do
    if [[ $(netstat -tuln | grep ":$port") ]]; then
        echo "Port $port is already in use."
        # Stop and remove containers using the port
        docker-compose -f "$DOCKER_COMPOSE_FILE" down
        exit 1
    fi
done

echo "All ports are free."
exit 0