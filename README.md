# Deploy Django on Linode
Template to deploy Django with a PostgreSQL database on Linode with GitHub Actions, Terraform, Ansible and Docker. Based on the awesome eBook ["Understanding Databases"](https://www.linode.com/de/content/understanding-databases-ebook/) by the guys at [Coding For Entrepreneurs](https://www.codingforentrepreneurs.com/) (the corresponding Repo is located [here](https://github.com/codingforentrepreneurs/deploy-django-linode-mysql)) and extended by me.

## Original Features
* CI/CD with Git, GitHub, and GitHub Actions
* Django on Docker and DockerHub (as well as using WatchTower)
* ~~Load balancing with Nginx~~
* ~~Production databases with managed MySQL by Linode~~
* Local/development use of production-like databases
* Terraform to provision Infrastructure on Linode
* Ansible to configure infrastructure on Linode (in tandem with Terraform)
* Django-based file uploads and Django static files on Linode Object Storage

## Extended Features
* Changed from (self-hosted) NGINX Load Balancer to a managed Load Balancer from Linode (NodeBalancer)
* Changed to a managed PostgreSQL database from Linode (only available for a short time, before it was MySQL only)
* Everything behind the Load Balancer uses internal IPs to communicate
* Added Firewall rules (Linodes managed Firewall via Terraform and ufw on all instances)
* Added netdata for monitoring

## Known Problems & Missing Features
+ There are some GitHub Actions deprecation warnings when running the complete workflow
+ The extraction of private IPs relies on a positional argument and should probably be replaced by some awk magic
+ Only rudimentary integration of logging features
+ No automatic Let's Encrypt integration
+ "Hardcoded" for usage with eu-central-1 (Frankfurt) Linode region
+ If it becomes available at Linode i will switch to a managed Redis Cache

## How to Use
Basically just clone the repo and fill in this list of GitHub Actions Secrets (i will update this with a more detailed explanation on how to fill in these variables - until then it's probably wise to look it up in the eBook this is based on):
- ALLOWED_HOST: The Domain your Django Project runs on
- DJANGO_SECRET_KEY
- DJANGO_VM_COUNT: The Number of Django Nodes running behind the load balancer (default=3)
- DOCKERHUB_APP_NAME: The name of your App on DockerHub (create a new app on Docker Hub if you haven't already. Should be private(!))
- DOCKERHUB_TOKEN: A Docker Hub API Key
- DOCKERHUB_USERNAME: Your Docker Hub Username
- LINODE_BUCKET: The domain of your bucket
- LINODE_BUCKET_REGION: The region you created the S3 Object Storage in (e.g. eu-central-1)
- LINODE_BUCKET_ACCESS_KEY: You can get the two keys from your Linode Account
- LINODE_BUCKET_SECRET_KEY
- LINODE_IMAGE: Something like g6-standard-1 meaning a Linode with 1 CPU and 2GB of RAM 
- LINODE_OBJECT_STORAGE_DEVOPS_BUCKET
- LINODE_OBJECT_STORAGE_DEVOPS_TF_KEY
- LINODE_OBJECT_STORAGE_DEVOPS_ACCESS_KEY
- LINODE_OBJECT_STORAGE_DEVOPS_SECRET_KEY
- LINODE_PA_TOKEN: A Linode API Key for your Account
- LINODE_DB_TYPE
- LINODE_INSTANCE_TYPE
- NETDATA_TOKEN
- NETDATA_ROOM_DJANGO
- NETDATA_ROOM_REDIS
- NETDATA_ROOM_WORKERS
- POSTGRES_DATABASE
- POSTGRES_DB_PORT
- POSTGRES_USER
- REDIS_PORT
- ROOT_USER_PW
- SSH_DEVOPS_KEY_PUBLIC: Generate a SSH Key and copy the contents of the public key here...
- SSH_DEVOPS_KEY_PRIVATE: ...and the private key here
- SSL_CERT: You have copy the two keys generated with Let's Encrypt for your domain here...
- SSL_KEY: $...automation will come soon

In the end this will deploy a Django project with 1 or more Django instances connected to a managed PostgreSQL database cluster with a seperate instance for a Redis Cache which is also used as a Broker for the dedicated Celery instance.

Works in 4 stages:
1. Tests the Django project in a GitHub Actions instance by running a test suite (Django's internal testing tools atm)
2. Collects all static files and copies them to the S3 Object Storage/Linode Bucket
3. Creates a Docker Container from the GitHub Repo and pushes it to Docker Hub
4. Provisions the infrastructure on Linode with Terraform and configures it with Ansible

