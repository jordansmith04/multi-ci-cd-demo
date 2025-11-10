# CI/CD Pipeline Demo - AWS CodePipeline, CodeBuild, CodeDeploy to ECS

This guide outlines the setup for the complete AWS-native CI/CD pipeline, automating the process from source code in GitHub to a deployed container in either AWS ECS or an EC2 instance.

## The pipeline is orchestrated by AWS CodePipeline, with two main stages:

CodeBuild (CI): Runs unit tests, builds the Docker image, and pushes it to ECR. (Defined by buildspec.yml).

CodeDeploy (CD): Handles the deployment of the new container image to the target environment. (Defined by appspec.yml or imagedefinitions.json).

## Prerequisites (AWS Infrastructure)

You must manually provision the following AWS resources before setting up the CodePipeline.

### 1. Code Source and Registry

Source: The pipeline will be triggered by changes in this GitHub repository.

ECR Repository: Create an ECR Repository named ci-cd-demo-repo.

### 2. Deployment Target (Choose One)

| Target | CodeDeploy Role | Required Files |
| ------ | -------- | -------| 
| ECS (Fargate) | Used for blue/green deployment strategy. | imagedefinitions.json |
| EC2 Fleet | Used for in-place or rolling deployment. | appspec.yml and the scripts/ directory |

### 3. IAM Roles

Ensure the following IAM roles exist with the necessary trust policies:

- CodePipeline Service Role: Allows interaction with S3, CodeBuild, and CodeDeploy.

CodeBuild Service Role: Must have permissions to:

- Read from the source artifact bucket.

- Push and Pull images to/from ECR (ecr:GetAuthorizationToken, ecr:BatchCheckLayerAvailability, ecr:PutImage, etc.).

- Write logs to CloudWatch.

CodeDeploy Service Role: Permissions to interact with the target (ECS or EC2).

## Configuration File Overview

### 1. buildspec.yml (CodeBuild)

This file defines the Continuous Integration steps:

pre_build: Installs dependencies and executes the Python unit tests (python3 -m unittest test_app.py) as a mandatory Quality Gate.

build: Builds the Docker image and tags it with the commit SHA.

post_build: Logs into ECR, pushes the image, and generates the imagedefinitions.json artifact for the CodeDeploy stage.

### 2. appspec.yml (CodeDeploy - EC2 Path)

This file is used if you are deploying to a fleet of EC2 instances running Docker.

It directs CodeDeploy to copy all files to /home/ec2-user/ci-cd-demo/.

It defines hooks (BeforeInstall, ApplicationStart, ValidateService) that execute the shell scripts found in the scripts/ directory to manage the container lifecycle.

## Execution Setup (AWS Console)

### 1. Create CodeBuild Project

1. Navigate to AWS CodeBuild.

2. Create a new project.

3. Set the Source to GitHub and point it to this repository.

4. Under Buildspec, select Use a buildspec file and ensure the name is buildspec.yml.

5. Under Environment, enable the Privileged setting to allow Docker builds.

### 2. Create CodeDeploy Application

1. Navigate to AWS CodeDeploy.

2. Create an Application (e.g., ci-cd-flask-app).

3. Create a Deployment Group, selecting your target type (EC2/On-Premises or ECS).

### 3. Create CodePipeline

1. Navigate to AWS CodePipeline.

2. Create a new pipeline.

3. Source Stage: Select GitHub (Version 2) and point it to the main branch of this repository.

4. Build Stage: Select the CodeBuild project created in step 1.

5. Deploy Stage: Select the CodeDeploy Application and Deployment Group created in step 2.

### 4. Running the Pipeline

The pipeline will automatically start when created.

Any subsequent push to the main branch of the GitHub repository will trigger the pipeline, running tests, building, pushing to ECR, and deploying to the target environment.