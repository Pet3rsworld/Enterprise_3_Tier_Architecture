# 🚀 Enterprise 3-Tier Architecture

*A highly available, fault-tolerant networking infrastructure deploying NGINX, EC2 Auto Scaling and AWS RDS through Terraform.*

## 🛠️ Core Technologies

*   **Infrastructure as Code (IaC):** HashiCorp Terraform 
*   **Compute:** AWS EC2, Auto Scaling Groups (ASG), Application Load Balancer (ALB)
*   **Database:** AWS RDS
*   **Networking:** Custom VPC, NAT Gateways, Public & Private Subnets
*   **CI/CD Pipeline:** GitHub Actions
*   **Tools:** Git, Linux Shell Scripting, macOS (zsh)

## 🧠 Project Purpose

The purpose of this project is to demonstrate a real-world enterprise scaling network as well as security deployments by building a 3-Tier Architecture from scratch that showcases the following:
*   **VPC Subnet Isolation:** Securing the compute and database layers inside private subnets and using NAT gateways to access the internet for outbound updates/patches.
*   **High Availability:** Deploying our infrastructure on multiple Availability Zones to guarantee fault tolerance and instant failover.
*   **Strict Security Groups:** Added security groups that are chained so that only the ALB can reach the EC2 instances, and only EC2 instances can reach the Database.
*   **Terraform Modules & Variables:** Allow us to use logic that is repeatable and reproducible without creating everything from scratch again.

## 🏗️ Architecture Overview

```
[ Internet Traffic ] 
       │
       ▼
 [ Internet Gateway ] ────► [ Application Load Balancer ] (Public Subnets, Tier 1)
                                  │
                                  ▼
                    [ EC2 Auto Scaling Group ] (Private Subnets, Tier 2)
                                  │
                                  ▼
                         [ AWS RDS Database ] (Private Subnets, Tier 3)
```

## 🥞 Application Stack

| Layer | Technology |
| :--- | :--- |
| **Frontend Server** | NGINX |
| **Compute** | AWS EC2 with Auto Scaling Groups |
| **Traffic Routing** | AWS Application Load Balancer (ALB) |
| **Network** | VPC & Public + Private Subnets |
| **Database** | AWS RDS Relational Database |
| **Security** | AWS Security Groups |
| **CI/CD** | GitHub Actions |

## 🗄️ Infrastructure Blueprint

```
AWS Cloud
├── Custom VPC
│   ├── Public App Subnets (Internet Facing)
│   │   ├── Internet Gateway
│   │   ├── NAT Gateways
│   │   └── Application Load Balancer
│   ├── Private Compute Subnets (Isolated)
│   │   └── EC2 Instances
│   └── Private Database Subnets (Isolated)
│       └── RDS Database (Secure connection string config)
├── Terraform Remote State
│   └── S3 Bucket & DynamoDB (State Locking)
```

## ⚙️ CI/CD Pipeline

The CI/CD workflow is handled by `.github/workflows/terraform.yml` which intercepts all merges to cleanly validate the codebase:
1.  **Code Checkout:** GitHub Actions runner provisions the environment.
2.  **Format Verification:** Runs `terraform fmt -check` to ensure that spacing formatting is of the standard.
3.  **Logic Validation:** Executes `terraform validate` to guarantee clean configurations.
4.  **Execution Preview:** Generates `terraform plan` output to evaluate the exact resources before allowing a final branch to merge.

## 📂 Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── terraform.yml          # GitHub Actions Pipeline
├── modules/
│   ├── networking/                # VPC, Subnets, IGW, NAT, Routes
│   ├── security/                  # Security Groups 
│   ├── database/                  # RDS Instance & Subnet Group
│   ├── compute/                   # ALB, Auto Scaling, Launch Templates
|   └── backend/                   # S3 & DynamoDB for remote state 
├── main.tf                        # Root Terraform folder with modules
├── variables.tf                   # Root variables
└── outputs.tf                     # Final Load Balancer URL output
```

## 💻 Local Development & Deployment Commands

For the purpose of deploying this 3 tier architecture on your local computer, authenticate through AWS CLI and follow the following comands on your CLI:

```bash
# Initialize Terraform
terraform init

# Validate execution plan
terraform plan

# Inject Secure Database Passwords
export TF_VAR_rds_password="SuperSecret123!"

# Apply the infrastructure
terraform apply
```
*note: After completion retrieve the Output ALB link through your CLI, copy and paste it to your browser of choice to verify the 3 tier architecture.*

## ⚠️ Disclaimer!!!

*This project is designed to showcase a 3-tier enterprise architecture.Therefore, it should be noted that some resources are not free. NAT Gateways cost roughly ~$0.045 per hour. Always make sure you use `terraform destroy` upon complettion to avoid any unexpected AWS billing.*

## 🧑‍💻 Author & Links

* **Name:** Peter Mkhatshwa
* **Focus:** Cloud Computing