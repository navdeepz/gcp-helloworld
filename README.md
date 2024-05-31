# gcp-helloworld

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