# CI/CD Pipeline Demo - GitLab CI to ECS

This guide focuses specifically on configuring the GitLab CI/CD pipeline to deploy the containerized Flask application to AWS Elastic Container Service (ECS) using Fargate.

### The pipeline automates the following steps upon a push to the main branch:

1. Run Unit Tests (Quality Gate).

2. Build the Docker image.

3. Log in to ECR and push the tagged image.

4. Register a new ECS Task Definition revision (using the updated image).

5. Force a new deployment on the ECS Service.

## Prerequisites (AWS Infrastructure)

Before running the GitLab CI/CD workflow, you must have the following AWS resources provisioned:

### 1. ECR Repository

Create an ECR Repository named ci-cd-demo-repo.

### 2. ECS Cluster & Service

Create an ECS Cluster (e.g., ci-cd-demo-cluster).

Create an ECS Service (e.g., ci-cd-demo-service) that runs on the cluster, referencing the container name ci-cd-flask-container.

Ensure the ECS Service is configured for Fargate launch type.

### 3. IAM Roles & Permissions

GitLab Runner User/Role: The AWS credentials defined in GitLab variables must belong to an IAM user or role with the following policies attached:

Permissions to push/pull images to ECR.

Permissions to run ECS Actions: ecs:RegisterTaskDefinition, ecs:UpdateService.

ECS Task Execution Role: Ensure the role referenced in task-definition.json (ecsTaskExecutionRole) exists and has policies like AmazonECSTaskExecutionRolePolicy.

## GitLab CI/CD Variables

The pipeline relies on several variables defined in your GitLab Project Settings (Settings > CI/CD > Variables). They must be set as Masked variables for security:

| Secret Name | Description | 
| -------- | ------- |
| AWS_ACCESS_KEY_ID | The Access Key ID for the IAM user/role. Credentials for ECR login and ECS deployment |
| AWS_SECRET_ACCESS_KEY | The Secret Access Key for the IAM user/role. Credentials for ECR login and ECS deployment | 
| AWS_ACCOUNT_ID | Your 12-digit AWS Account ID. Used to construct the full ECR registry URL and populate task-definition.json. | 

## Configuration Adjustments

Check the variables section in .gitlab-ci.yml and ensure AWS_REGION, ECS_CLUSTER_NAME, and ECS_SERVICE_NAME match your AWS setup.

## Execution and Verification

### 1. Initial Deployment

- Commit all project files (including the updated .gitlab-ci.yml and task-definition.json) to the main branch of your GitLab repository.

- Action: GitLab CI will automatically detect the push and start the pipeline.

### 2. Monitoring

1. Navigate to Build > Pipelines in your GitLab project.

2. Confirm that the test stage passes.

3. Confirm the build_push stage successfully logs into ECR and pushes the image.

4. Confirm the ecs_deploy stage registers a new Task Definition and updates the service.

### 3. Verification

Check the AWS ECS console to ensure a new deployment has started for your target service. The service will be using the image tagged with the GitLab commit SHA.