# Multiple CI/CD Pipeline Demo

This project demonstrates a comprehensive, multi-platform Continuous Integration and Continuous Deployment (CI/CD) pipeline for a simple containerized Python Flask application.

The goal is to automate the entire lifecycle: code change → build → test → containerize → push to registry → deployment.

## Key Highlights & Skills Demonstrated

| Feature    | Tool(s) | Skill |
| -------- | ------- | ------- | 
| Containerization  | Docker   |  Dockerfile best practices, image optimization |
| CI/CD Automation | GitHub Actions, GitLab CI, AWS CodeBuild, Jenkins | Workflow authoring, environment setup, secret management |
| Container Registry    | Amazon ECR (Elastic Container Registry)  | Authentication flows, image tagging, and publishing |
| Deployment | AWS CodeDeploy / ECS | Infrastructure as Code (IaC) principles, deployment hooks, application monitoring (conceptual) |
| Application | Python Flask | Simple web service setup for demonstration |


### Repository Structure
<pre>
.
├── Github-CICD
|   ├── .github/workflows/ci-cd.yml   # GitHub Actions Workflow
|   ├── task-definition.json          # Defines ECS task
├── Gitlab-CICD
|   ├── .gitlab-ci.yml                # GitLab CI/CD Pipeline
├── AWSCodeBuildAndDeeploy-CICD
|   ├── buildspec.yml                 # AWS CodeBuild application
|   ├── appspec.yml                   # AWS CodeDeploy Application 
|   ├── install_docker.sh             # Install Docker on EC2
|   ├── start_container.sh            # Runs application container on EC2
|   ├── validate_service.sh           # Verify application is running 
├── Jenkins-CICD
|   ├── Jenkinsfile                   # Jenkins Declarative Pipeline
└── FlaskApp
   ├── Dockerfile                # Defines the Python environment container
   ├── app.py                    # The simple Flask application
   ├── test_app.py               # Unit tests for Flask application
   └── requirements.txt          # Python dependencies
</pre>


### Configuration Notes

Registry: All CI/CD workflows are configured to push the resulting Docker image to AWS ECR.

Deployment: The target deployment environment is assumed to be AWS ECS or EC2.

Secrets: All API keys, AWS credentials, ECR repository names, and region details are managed via encrypted secrets in the respective CI/CD platforms (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, ECR_REGISTRY_URL, etc.).