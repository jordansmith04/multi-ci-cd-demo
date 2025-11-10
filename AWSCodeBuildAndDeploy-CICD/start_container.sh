#!/bin/bash
# CodeDeploy script to pull the new Docker image and start the container

echo "--- Running ApplicationStart Hook: Starting Application Container ---"

# --- Variables ---
# Replace with your actual ECR details (these would ideally be passed via CodeDeploy parameters)
AWS_REGION="us-east-1"
ECR_REPOSITORY="ci-cd-demo-repo"
CONTAINER_NAME="ci-cd-flask-app"
CONTAINER_PORT="8080"

# Assuming the latest image tag (or a specific tag passed during deployment)
# For simplicity, we use the 'latest' tag here, but using the commit SHA is better practice.
IMAGE_TAG="latest" 

# Find the AWS Account ID (CodeDeploy environment needs permissions)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
IMAGE_FULL_URI="$ECR_URI/$ECR_REPOSITORY:$IMAGE_TAG"

# Login to ECR
echo "Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

# Stop and remove any existing container
echo "Stopping and removing old container if exists..."
if [ $(docker ps -a -q -f name=$CONTAINER_NAME) ]; then
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Pull the latest image
echo "Pulling new image: $IMAGE_FULL_URI"
docker pull $IMAGE_FULL_URI

# Start the new container
echo "Starting new container: $CONTAINER_NAME"
docker run -d \
    --name $CONTAINER_NAME \
    -p 80:$CONTAINER_PORT \
    $IMAGE_FULL_URI

echo "Container started successfully."