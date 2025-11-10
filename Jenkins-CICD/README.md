# CI/CD Pipeline Demo - Jenkins to ECS

This guide provides the setup steps required to run the automated build, test, and deployment pipeline using the provided Jenkinsfile. This pipeline is designed to execute when changes are pushed to your repository.

## The Jenkins pipeline performs the following end-to-end steps:

1. Checkout the source code.

2. Run Unit Tests (Quality Gate) in a Python container.

3. Build the Docker image.

4. Authenticate to AWS ECR using stored credentials.

5. Push the tagged image to ECR.

6. Deploy the new image by updating the AWS ECS Task Definition and forcing a service redeployment.

### Prerequisites (Jenkins Environment)

To successfully execute this pipeline, your Jenkins environment must meet these requirements:

### 1. Required Plugins

Install the following plugins via the Jenkins Plugin Manager:

- Pipeline: Enables Declarative Pipeline syntax.

- Docker Pipeline: Allows Jenkins to interact with the Docker daemon and build images.

- AWS Steps Plugin (or CloudBees AWS Credentials Plugin): Enables the withAWS block for credential management.

### 2. Jenkins Agent Configuration

The pipeline is configured to run on a Jenkins agent labeled 'jenkins-worker'. This agent must have access to:

- Docker Daemon: The agent needs access to the host's Docker socket to build and push images.

- Internet Access: To pull base images (Python, Docker, AWS CLI) and communicate with AWS services.

#### Jenkins Credentials Configuration

The pipeline requires one secret credential stored in the Jenkins Credentials Manager.

1. Navigate to Jenkins > Manage Jenkins > Manage Credentials.

2. Select your scope (e.g., Global credentials).

3. Click "Add Credentials".

4. Kind: Select "AWS Credentials".

5. ID: This ID must match the ID specified in the Jenkinsfile environment block: aws-ecr-ecs-creds.

6. Enter your AWS Access Key and Secret Key for an IAM user/role with ECR and ECS deployment permissions.

#### Jenkins Job Setup

Follow these steps to create the Multibranch Pipeline job:

1. Navigate to Jenkins > New Item.

2. Enter an item name (e.g., ci-cd-flask-pipeline).

3. Select "Pipeline" or "Multibranch Pipeline" (recommended).

4. In the Configuration page:

- Definition: Select "Pipeline script from SCM".

- SCM: Select "Git".

- Repository URL: Enter the URL for this project's repository.

- Credentials: Select the appropriate Git credentials (if the repo is private).

- Script Path: Ensure this is set to the default: Jenkinsfile.

## Execution and Verification

### 1. First Run

Save the job configuration.

Jenkins will automatically detect the Jenkinsfile in the repository and start the pipeline.

### 2. Monitoring Stages

Watch the Console Output for the pipeline run and confirm the following stages pass in order:

1. Checkout: Code is retrieved.

2. Test: Unit tests run successfully (using the Python Docker agent).

3. BuildAndPush: The image is built, ECR login succeeds, and the image is pushed with the commit SHA tag (${IMAGE_TAG}).

4. DeployECS: The pipeline successfully registers a new Task Definition and forces the ECS service update.

### 3. Verification

Confirm the new container deployment is visible in the AWS ECS console and the running application displays the latest commit SHA as its version number.