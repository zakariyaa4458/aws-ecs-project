# Threat Composer – AWS ECS DevOps Deployment

A production-style DevOps project that deploys a containerised React application to AWS using Terraform, Docker, ECS Fargate and GitHub Actions.

The project demonstrates Infrastructure as Code (IaC), automated CI/CD pipelines, secure secret management and a highly available AWS architecture.

---

## Project Overview

This project provisions an entire AWS environment using Terraform and deploys the Threat Composer application automatically through GitHub Actions.

The infrastructure is fully reproducible and can be deployed or destroyed using Terraform.

---

## Architecture

<img width="1519" height="1348" alt="AWS-Infrastructure-Diagram" src="https://github.com/user-attachments/assets/d1910824-db6c-437a-a8af-fb38965cfa0f" />

### Deployment Flow

```
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Terraform Validate
    ├── Terraform Plan
    ├── Docker Build
    ├── Push Image to Amazon ECR
    ├── Terraform Apply
    └── Deployment Verification
                    │
                    ▼
               AWS Infrastructure
```

### Application Flow

```
User
    │
    ▼
Cloudflare DNS
    │
    ▼
Application Load Balancer
    │
    ▼
Amazon ECS (Fargate)
    │
    ▼
Threat Composer Container
    │
    ▼
Amazon RDS MySQL
```

---

# Technologies Used

## Cloud

- AWS ECS (Fargate)
- Amazon ECR
- Amazon RDS MySQL
- Application Load Balancer
- ACM
- CloudWatch Logs
- Systems Manager Parameter Store
- IAM
- VPC
- Route Tables
- Internet Gateway
- NAT Gateway

## Infrastructure as Code

- Terraform

## Containers

- Docker
- Docker Hub
- Amazon ECR

## CI/CD

- GitHub Actions

## Networking

- Cloudflare DNS
- HTTPS
- ACM SSL Certificate

---

# Features

- Infrastructure fully managed with Terraform
- Modular Terraform structure
- Automated CI/CD deployment
- Docker image built automatically
- Docker image pushed to Amazon ECR
- ECS deployment using Fargate
- HTTPS enabled using ACM
- Cloudflare custom domain
- Secure database password stored in AWS Systems Manager Parameter Store
- Application logs stored in CloudWatch
- Infrastructure can be completely destroyed using Terraform

---

# AWS Architecture

- Custom VPC
- Two Availability Zones
- Two Public Subnets
- Two Private Subnets
- Internet Gateway
- NAT Gateway
- Application Load Balancer
- ECS Fargate Service
- Amazon RDS MySQL
- Security Groups following least privilege

---

# CI Pipeline

The Continuous Integration pipeline performs:

- Checkout repository
- Terraform formatting check
- Terraform validation
- Terraform plan
- Docker image build
- Push image to Amazon ECR

---

# CD Pipeline

The Continuous Deployment pipeline performs:

- Terraform Apply
- ECS Deployment
- Infrastructure update
- Deployment verification using curl

# Pipelines working

<img width="1422" height="197" alt="Pipelines-working" src="https://github.com/user-attachments/assets/34abf746-b4da-4bf4-a97b-94878d697e1b" />


# Security

- IAM Roles with least privilege
- Secrets stored in Systems Manager Parameter Store
- HTTPS enforced through Application Load Balancer
- Security Groups restrict traffic between components
- Private subnets used for ECS tasks and RDS

---

# Deployment

```bash
terraform init

terraform plan

terraform apply
```

Destroy infrastructure:

```bash
terraform destroy
```

---

# Skills Demonstrated

- AWS
- Terraform
- Docker
- ECS Fargate
- Infrastructure as Code
- GitHub Actions
- Continuous Integration
- Continuous Deployment
- Cloud Networking
- Linux
- Bash
- IAM
- Cloud Security
- CloudWatch
- DNS
- HTTPS
- Infrastructure Automation

