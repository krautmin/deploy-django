# Deploy Django on Linode
Template to deploy Django with a PostgreSQL database on Linode with GitHub Actions, Terraform, Ansible and Docker. I did this for a client but the project fell flat in the end, but at least i can salvage some parts. In the end this will deploy a Django project with 1 or more Django instances connected to a managed PostgreSQL database cluster on Linode with seperate instances for Redis caches which are also used as a broker for the dedicated Celery workers. Uses netdata for monitoring, ufw/iptables and Linodes managed firewall for security and S3-compatible object storage for files. 
Based on the awesome eBook ["Understanding Databases"](https://www.linode.com/de/content/understanding-databases-ebook/) by the guys at [Coding For Entrepreneurs](https://www.codingforentrepreneurs.com/) (the corresponding Repo is located [here](https://github.com/codingforentrepreneurs/deploy-django-linode-mysql)) and extended by me.

## Original Features
* CI/CD with Git, GitHub, and GitHub Actions
* Django on Docker and DockerHub (as well as using WatchTower for automated container updates)
* ~~Load balancing with Nginx~~
* ~~Production databases with managed MySQL by Linode~~
* Local/development use of production-like databases
* Terraform to provision Infrastructure on Linode
* Ansible to configure infrastructure on Linode (in tandem with Terraform)
* Django-based file uploads and Django static files on Linode Object Storage

## Extended Features
* Changed from (self-hosted) NGINX Load Balancer to a managed Load Balancer from Linode (NodeBalancer)
* Changed to a managed PostgreSQL database from Linode (only available for a short time, before it was MySQL only on Linode)
* Everything behind the Load Balancer uses internal IPs to communicate
* Added Firewall rules (Linodes managed Firewall via Terraform and ufw on all instances)
* Added netdata for monitoring
* Configures PostgreSQL database on first execution/provisioning (see caveat below)

## Known Problems & Missing Features
+ There are some GitHub Actions deprecation warnings when running the complete workflow
+ The extraction of private IPs relies on a positional argument and should probably be replaced by some awk magic
+ Only rudimentary integration of logging features
+ No automatic Let's Encrypt integration
+ "Hardcoded" for usage with eu-central-1 (Frankfurt) Linode region
+ At the moment the SQL code that configures the PostgreSQL database also wipes it everytime it is executed
+ When it becomes available on Linode i will switch to a managed Redis Cache

## Works in 4 stages:
1. Tests the Django project in a GitHub Actions instance by running a test suite (Django's internal testing tools atm)
2. Collects all static files and copies them to the S3 Object Storage/Linode Bucket
3. Creates a Docker Container from the GitHub Repo and pushes it to Docker Hub
4. Provisions the infrastructure on Linode with Terraform and configures it with Ansible
