Mk1 - Personal Tech Project
Technology Stack
* Git – Version control system for managing code changes
* Docker – Containerization to package applications and dependencies
* AWS – Cloud infrastructure for hosting resources
* Terraform – Infrastructure as Code (IaC) for automated provisioning
* Jenkins – CI/CD automation for build, test, and deployment
Project Workflow
1. Infrastructure Provisioning with Terraform
    * Terraform provisions an EC2 instance with pre-installed Java, Docker, and Jenkins.
    * The instance is connected to Jenkins via GitHub webhooks.
    * If Terraform updates the infrastructure, a new instance is created, requiring Jenkins reconfiguration.
2. CI/CD Automation with Jenkins and Docker
    * Once the instance is set up, Jenkins automates Docker container creation and CI/CD pipelines.
    * GitHub webhooks trigger a Jenkins build whenever code is updated and pushed.
    * Jenkins pulls the latest code, builds a new Docker container, and deploys it to host the website.
This ensures a fully automated and seamless deployment pipeline, dynamically provisioning infrastructure and continuously updating the application.
