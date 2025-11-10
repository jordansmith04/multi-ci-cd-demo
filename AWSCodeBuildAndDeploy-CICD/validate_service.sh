#!/bin/bash
# CodeDeploy script to perform a simple health check

echo "--- Running ValidateService Hook: Checking application health ---"

CONTAINER_PORT="8080"
HEALTH_CHECK_URL="http://127.0.0.1:$CONTAINER_PORT/"
MAX_ATTEMPTS=10
ATTEMPT_COUNT=0

# Loop to check health endpoint
until [ $ATTEMPT_COUNT -ge $MAX_ATTEMPTS ]
do
  RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_CHECK_URL)
  
  if [ "$RESPONSE_CODE" == "200" ]; then
    echo "Health check successful! Application is running (HTTP $RESPONSE_CODE)."
    exit 0
  fi
  
  ATTEMPT_COUNT=$((ATTEMPT_COUNT+1))
  echo "Attempt $ATTEMPT_COUNT/$MAX_ATTEMPTS: Health check failed (HTTP $RESPONSE_CODE). Waiting 5 seconds..."
  sleep 5
done

echo "Health check failed after $MAX_ATTEMPTS attempts. Deployment failed."
exit 1