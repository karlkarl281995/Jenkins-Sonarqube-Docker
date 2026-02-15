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

Got it. I’ll keep it clean and professional from here on.

Below is the streamlined version of **Step 3 onward**, formatted in a way you can drop directly into VS Code as a README or internal runbook.

---

## Step 3 – Create Jenkins Freestyle Project

1. Open Jenkins:

   ```
   http://<EC2_PUBLIC_IP>:8080
   ```

2. Click **New Item**

3. Name the job:

   ```
   mk1-basic
   ```

4. Select **Freestyle project**

5. Click **OK**

---

## Step 4 – Connect GitHub Repository

Inside the job configuration:

### Source Code Management

* Select **Git**
* Repository URL:

  ```
  https://github.com/<username>/<repo>.git
  ```
* Branch:

  ```
  */main
  ```

If the repository is private, add GitHub credentials (Personal Access Token) in Jenkins credentials and select them here.

Save.

---

## Step 5 – Enable Webhook Trigger

Inside the job configuration:

Under **Build Triggers**, enable:

```
GitHub hook trigger for GITScm polling
```

Save.

---

## Step 6 – Add Docker Build and Deploy Step

Edit the job again.

Under **Build → Add Build Step → Execute shell**, add:

```bash
echo "Stopping old container..."
docker stop mk1-container || true
docker rm mk1-container || true

echo "Building Docker image..."
docker build -t mk1-app .

echo "Running new container..."
docker run -d -p 80:80 --name mk1-container mk1-app
```

Save.

---

## Step 7 – Configure GitHub Webhook

In GitHub:

Repository → Settings → Webhooks → Add webhook

Payload URL:

```
http://<EC2_PUBLIC_IP>:8080/github-webhook/
```

Content type:

```
application/json
```

Event:

```
Just the push event
```

Save.

---

## Step 8 – Test Pipeline

Push a commit:

```bash
git commit -m "test pipeline"
git push
```

Jenkins should automatically:

* Trigger the job
* Pull the repository
* Build the Docker image
* Stop the previous container
* Start the new container

Verify deployment at:

```
http://<EC2_PUBLIC_IP>
```

---

If you’d like, next we can:

* Refactor this into a Jenkinsfile version
* Improve the Docker deployment (tagging, cleanup, build numbers)
* Move into CloudWatch monitoring
* Do a structured IAM refresher

Let me know the direction you want to take.
