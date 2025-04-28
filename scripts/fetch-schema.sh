#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SERVER_DIR="$PROJECT_ROOT/server"
CLIENT_DIR="$PROJECT_ROOT"

echo "Starting Apollo Server..."
cd "$SERVER_DIR"
npm start &

SERVER_URL="http://localhost:4000/graphql"
TIMEOUT=20
ELAPSED=0
while ! curl --silent --output /dev/null "$SERVER_URL"; do
  if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
    echo "Error: Server did not start within $TIMEOUT seconds."
    exit 1
  fi
  echo "Waiting for Apollo Server to start..."
  sleep 2
  ELAPSED=$((ELAPSED + 2))
done
echo "Apollo Server is running!"

echo "Fetching GraphQL schema..."
cd "$CLIENT_DIR"
./gradlew :features:reminder:downloadServiceApolloSchemaFromIntrospection --no-daemon

echo "Stopping Apollo Server..."
pkill -f "node .*server"

echo "Done!"