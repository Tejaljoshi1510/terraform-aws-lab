# AWS Infrastructure with Terraform

## Overview

This project provisions AWS infrastructure using Terraform custom modules.

The infrastructure includes:

* VPC and networking
* Public and private subnets across multiple Availability Zones
* Internet Gateway and route tables
* EC2 instances
* RDS PostgreSQL
* Lambda function connected to RDS
* Application Load Balancer (ALB)
* Route 53 DNS record
* Security Groups and IAM roles

The infrastructure is organized using reusable Terraform modules.

---

## Architecture

```text
                         Internet
                            |
                            ↓
                        Route 53
                            |
                            ↓
                     Public ALB :80
                            |
                            ↓
                     Target Group
                            |
                            ↓
                      EC2 :80
                            |
                            ↓
                  RDS PostgreSQL :5432
                            ↑
                            |
                         Lambda
```

### Network Layout

```text
VPC: 10.0.0.0/16

├── Public Subnet A
├── Public Subnet B
├── Private Subnet A
└── Private Subnet B
```

The ALB is deployed across multiple public subnets.

RDS is deployed in private subnets.

Lambda is configured inside the VPC and connects to RDS through PostgreSQL port `5432`.

---

## Project Structure

```text
terraform-project/
│
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
│
├── database/
│   └── schema.sql
│
└── modules/
    │
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── ec2/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── rds/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── lambda/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── lambda_function.py
    │
    ├── alb/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── route53/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

# Terraform Modules

## 1. VPC Module

Creates:

* VPC
* Public subnets
* Private subnets
* Multiple Availability Zones
* Internet Gateway
* Public route table
* Route table associations

Example:

```text
VPC
├── Public Subnet A
├── Public Subnet B
├── Private Subnet A
└── Private Subnet B
```

---

## 2. EC2 Module

Creates:

* EC2 instance
* EC2 Security Group

The EC2 instance is deployed inside a subnet.

The Security Group controls inbound and outbound traffic.

In the final architecture, EC2 receives HTTP traffic only from the ALB Security Group.

```text
ALB-SG
   |
   | HTTP :80
   ↓
EC2-SG
   |
   ↓
EC2
```

---

## 3. RDS Module

Creates:

* RDS PostgreSQL instance
* RDS subnet group
* RDS Security Group

RDS is deployed in private subnets.

PostgreSQL traffic is allowed only from trusted Security Groups.

```text
EC2-SG ────────┐
               ├──→ RDS :5432
Lambda-SG ─────┘
```

RDS is not publicly accessible.

---

## 4. Database Schema

Terraform creates the RDS infrastructure and initial database.

The database schema is stored separately:

```text
database/schema.sql
```

The SQL file contains database objects such as:

* Schemas
* Tables
* Constraints
* Relationships

Example:

```text
application
├── users
├── products
└── orders
```

For learning/testing, the schema can be executed using the PostgreSQL `psql` client from an EC2 instance:

```text
Laptop
   |
   | SSH
   ↓
EC2
   |
   | PostgreSQL :5432
   ↓
RDS
```

The `schema.sql` file contains only SQL statements.

In a production environment, database schema changes should be managed through a database migration tool and CI/CD pipeline rather than manually through SSH.

---

# 5. Lambda Module

Creates:

* AWS Lambda function
* IAM execution role
* Lambda Security Group
* VPC configuration

The Lambda function uses Python and connects to PostgreSQL.

```text
Lambda
   |
   | PostgreSQL :5432
   ↓
RDS
```

The Lambda function queries the:

```text
application.users
```

table.

The PostgreSQL `psycopg2` driver is packaged with the Lambda deployment package.

For production, database credentials should be stored in **AWS Secrets Manager** instead of directly in Lambda environment variables.

---

# 6. Application Load Balancer

Creates:

* Internet-facing ALB
* ALB Security Group
* Target Group
* Health Check
* Listener
* EC2 target registration

Traffic flow:

```text
Internet
   ↓
ALB :80
   ↓
Target Group
   ↓
EC2 :80
```

The ALB performs health checks on the EC2 instance and sends traffic only to healthy targets.

---

# 7. Route 53

Creates a Route 53 DNS record pointing to the ALB.

Example:

```text
app.example.com
       ↓
    Route 53
       ↓
      ALB
       ↓
      EC2
```

An AWS Alias record is used to point the Route 53 record to the ALB.

---

# Security

The project follows basic AWS security practices:

* RDS is private.
* RDS port `5432` is allowed only from trusted Security Groups.
* EC2 receives HTTP traffic from the ALB Security Group.
* ALB accepts HTTP traffic from the internet.
* Lambda uses its own Security Group.
* IAM roles are used for Lambda permissions.
* Database credentials should not be committed to Git.
* Production deployments should use AWS Secrets Manager for database credentials.

---

# Terraform Variables and Outputs

The root module defines project-level variables.

Example:

```text
Root variables
      ↓
Module input variables
      ↓
Resources
      ↓
Module outputs
      ↓
Root outputs
```

Example:

```hcl
module.vpc.vpc_id
module.vpc.private_subnet_ids
module.ec2.instance_id
module.rds.db_endpoint
module.lambda.lambda_function_arn
module.alb.alb_dns_name
```

This allows modules to remain reusable and loosely coupled.

---

# Terraform Workflow

Initialize Terraform:

```bash
terraform init
```

Format the configuration:

```bash
terraform fmt -recursive
```

Validate the configuration:

```bash
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Create the infrastructure:

```bash
terraform apply
```

View outputs:

```bash
terraform output
```

Destroy the infrastructure when no longer required:

```bash
terraform destroy
```

---

# Important Terraform Concepts Demonstrated

This project demonstrates:

* Custom Terraform modules
* Variables
* Variable types
* Lists
* Outputs
* Module output referencing
* Resource dependencies
* `depends_on`
* `count`
* Multi-AZ infrastructure
* Security Group references
* Reusable module design
* Terraform plan and apply workflow

---

# Implementation Order

The infrastructure is implemented in the following order:

```text
1. VPC
      ↓
2. Public/Private Subnets
      ↓
3. Internet Gateway + Routes
      ↓
4. EC2
      ↓
5. RDS PostgreSQL
      ↓
6. Database Schema
      ↓
7. Lambda → RDS
      ↓
8. ALB → EC2
      ↓
9. Route 53 → ALB
      ↓
10. Validation and Testing
```

---

# Production Improvements

For a production deployment, the architecture can be further improved by:

* Moving EC2 completely into private subnets
* Using NAT Gateway or VPC endpoints where required
* Using AWS Secrets Manager for database credentials
* Using RDS Multi-AZ
* Using multiple EC2 instances/Auto Scaling
* Using HTTPS with ACM certificates
* Using HTTPS listener on the ALB
* Using database migration tooling
* Using remote Terraform state with locking
* Running Terraform through CI/CD
* Adding CloudWatch monitoring and alarms
* Adding WAF to the ALB
* Restricting IAM permissions using least privilege
