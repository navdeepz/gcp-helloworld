# gcp-helloworld

## Project Introduction
This project aims to deploy a scalable web application on Google Cloud Platform (GCP) using Google Kubernetes Engine (GKE). The application, written in Python, connects to a PostgreSQL database and utilizes Redis for caching. The setup ensures high availability and scalability, leveraging GCP's external load balancer for public access. The infrastructure is managed using Terraform, and the application is deployed and updated through Jenkins pipelines.

On the Kubernetes side, the project uses Helm for Kubernetes package management, ensuring consistent and repeatable deployments. The GKE cluster is configured to support auto-scaling, allowing it to handle increased traffic seamlessly. Kubernetes Secrets and ConfigMaps are used to securely manage sensitive information such as database credentials and configuration details. An external load balancer is set up to direct traffic to the appropriate services within the GKE cluster, ensuring optimal performance and availability. 

```
# gcp-helloworld/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
├── webapp/
│   ├── app.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── helm/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── configmap.yaml
│           └── secret.yaml
└── monitoring/
    └── opentelemetry_config.yaml
```

**Initialize Database**
Run the following SQL commands to create the table and insert the message:

```
CREATE TABLE hello (id serial PRIMARY KEY, message VARCHAR (50) NOT NULL);
INSERT INTO hello (message) VALUES ('Hello World');
```



**For Jenkins pipelines, assumption that following plugins are installed and available**
Terraform Plugin
Kubernetes Plugin
Docker Pipeline Plugin
Google OAuth Credentials Plugin

Configured Credentials:

Add GCP service account key JSON file as a secret file credential.
Add Google Container Registry (GCR) credentials.
Add Kubernetes cluster configuration (kubeconfig) as a secret file.

**Create GCS bucket for state file**
```
gsutil mb -p <gcp-project-id> gs://nav-test-terraform-state-bucket
```


**Create a tfvars file in the /terraform direcrtory to pass values**

terraform.tfvars
```
# Project Configuration
project_id = "gcp-project-id"
region     = "us-central1" 

# GKE Cluster Configuration
cluster_name           = "nav-test-cluster"
max_node_count         = 2

```

**Monitoring not implemented yet**

## Disclaimer

This project is intended for educational purposes and demonstration of cloud-native application deployment using GCP, GKE, and associated tools. It is not recommended for production use without thorough testing and security audits. The configurations and setups provided are basic and should be customized to meet the specific needs and security requirements of your application and organization.
