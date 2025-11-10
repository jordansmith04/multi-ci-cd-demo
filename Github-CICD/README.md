# CI/CD Pipeline Demo - GitHub Actions to ECS

This guide focuses specifically on the GitHub Actions pipeline configuration for continuous integration and deployment of the containerized Flask application to AWS Elastic Container Service (ECS) using Fargate.

## The pipeline automates the following steps upon a push to the main branch:

1. Checkout code.

2. Install Python dependencies.

3. Run Unit Tests (Quality Gate).

4. Configure AWS credentials and log in to ECR.

5. Build the Docker image.

6. Push the tagged image to ECR.

7. Update the ECS Service with the new Task Definition revision.

## Prerequisites (AWS Infrastructure)

Before running the GitHub Actions workflow, you must have the following AWS resources provisioned in the us-east-1 region (or your chosen region, matching the workflow file):

### 1. ECR Repository

Create an ECR Repository named ci-cd-demo-repo.

### 2. ECS Cluster & Service

1. Create an ECS Cluster (e.g., ci-cd-demo-cluster).

2. Create an ECS Service (e.g., ci-cd-demo-service) that runs on the cluster, referencing the container name ci-cd-flask-container (as defined in task-definition.json).

3. Ensure the ECS Service is configured for Fargate launch type.

### 3. IAM Roles & Permissions

GitHub Actions User/Role: The AWS credentials used in GitHub Secrets must belong to an IAM user or role with the following policies attached:

AmazonEC2ContainerRegistryPowerUser (or equivalent ECR permissions to push/pull).

Permissions to run ECS Actions: ecs:RegisterTaskDefinition, ecs:DescribeServices, ecs:UpdateService.

ECS Task Execution Role: Ensure the role referenced in task-definition.json (ecsTaskExecutionRole) exists and has policies like AmazonECSTaskExecutionRolePolicy to allow the ECS agent to pull images and write logs.

## GitHub Secrets Configuration

The workflow requires the following secrets to be configured in your GitHub Repository Settings (Settings > Security > Secrets and variables > Actions):

| Secret Name | Description | 
| -------- | ------- |
| AWS_ACCESS_KEY_ID | The Access Key ID for the IAM user/role with deployment permissions. |
| AWS_SECRET_ACCESS_KEY | The Secret Access Key for the IAM user/role. | 

## Configuration Adjustments

Before running, you must customize the following parameters in your repository:

### 1. Workflow Variables (.github/workflows/ci-cd.yml)

Update the env section of this file to match your actual AWS resource names:

env:
  AWS_REGION: us-east-1          # Must match your region
  ECR_REPOSITORY: ci-cd-demo-repo
  ECS_CLUSTER: ci-cd-demo-cluster # <-- MATCH YOUR CLUSTER NAME
  ECS_SERVICE: ci-cd-demo-service # <-- MATCH YOUR SERVICE NAME


### 2. Task Definition (task-definition.json)

The Task Definition is generic, but you must ensure the IAM roles match your account structure:

Replace ${AWS_ACCOUNT_ID} placeholders with your actual 12-digit AWS Account ID (you may need to manually update this file after it is committed).

## Execution and Verification

### 1. Initial Deployment

Commit all project files (app.py, Dockerfile, task-definition.json, .github/workflows/ci-cd.yml, etc.) to the main branch of your GitHub repository.

Action: GitHub Actions will automatically detect the push and start the CI/CD pipeline.

### 2. Monitoring

Navigate to the Actions tab in your GitHub repository to watch the workflow execute.

Confirm the "Run Unit Tests" step passes.

Confirm the "Build, Tag, and Push image to ECR" step pushes the new image tag (based on the commit SHA).

Confirm the "Deploy Amazon ECS Task Definition" step successfully updates your ECS service.

### 3. Verification

Check the AWS ECS console to ensure a new deployment has started for your target service.

Access the running application via the associated Load Balancer or EC2 Public IP to see the message: Version: <COMMIT_SHA> (The commit SHA is used as the version number).