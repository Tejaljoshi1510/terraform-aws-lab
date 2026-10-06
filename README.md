# AWS Infrastructure with Terraform

## 1. What gets created

This project creates a small AWS application environment using Terraform custom modules.

The main resources are:

* VPC with public and private subnets
* Subnets across multiple Availability Zones
* Internet Gateway and route tables
* NAT Gateway for private subnet outbound access
* EC2 instance
* Security Groups
* PostgreSQL RDS
* Lambda function connected to RDS
* Application Load Balancer
* Route 53 DNS record
* IAM role and policies for Lambda

The main idea is to keep the application entry point public through the ALB while keeping the database private.

### Traffic flow

```text
Internet
   |
Route 53
   |
ALB - Public Subnets
   |
Target Group
   |
EC2
   |
RDS - Private Subnets

Lambda
   |
   +----> RDS
```

The ALB communicates with EC2 using the EC2 private IP. EC2 does not need a public IP for ALB-to-EC2 communication.

---

# 2. Repository Layout

```text
terraform-project/
│
├── README.md
│
├── env/
<<<<<<< HEAD
│   │
=======
>>>>>>> 8505718 (terraform.auto.tfvars file)
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── terraform.tf
│       └── terraform.auto.tfvars
│
├── database/
│   └── schema.sql
│
└── modules/
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

<<<<<<< HEAD
# Terraform Modules
=======
`env/dev` is the root Terraform configuration for the development environment.

The `modules` directory contains reusable Terraform modules.

The modules are not executed separately. Terraform is run from `env/dev`, which calls the required modules.

---

# 3. Prerequisites
>>>>>>> 8505718 (terraform.auto.tfvars file)

Before running the project, I need:

* Terraform installed
* AWS CLI installed
* AWS credentials configured
* Required AWS permissions
* An existing S3 bucket for the Terraform backend
* A Route 53 hosted zone if the DNS record is being created

The project uses the AWS provider:

```text
hashicorp/aws
```

The AWS region used for this project is:

```text
ap-south-1
```

---

# 4. How to run

Terraform commands should be run from the development environment:

```bash
cd env/dev
```

Initialize the project:

```bash
terraform init
```

Format the Terraform files:

```bash
terraform fmt -recursive
```

Validate the configuration:

```bash
terraform validate
```

Check what Terraform is going to create:

```bash
terraform plan
```

Create the infrastructure:

```bash
terraform apply
```

After the apply completes, Terraform displays the configured outputs.

To check the outputs again:

```bash
terraform output
```

I should review the `terraform plan` before running `apply`, especially when creating resources such as RDS, NAT Gateway and ALB because they can generate AWS charges.

---

# 5. Outputs

The root module exposes useful information from the child modules.

Some of the outputs are:

```text
VPC ID
Public subnet IDs
Private subnet IDs
EC2 instance ID
RDS endpoint
RDS port
Lambda function name
Lambda function ARN
ALB DNS name
Route 53 record name
```

The flow of values is:

```text
Resource
   |
Module output
   |
Root module
   |
Root output
```

For example:

```hcl
module.vpc.vpc_id
module.vpc.private_subnet_ids
module.ec2.instance_id
module.rds.db_endpoint
module.lambda.lambda_function_arn
module.alb.alb_dns_name
```

This allows the modules to communicate through inputs and outputs instead of hardcoding resource IDs.

---

# 6. Destroy instructions

When the development environment is no longer required, the infrastructure can be removed with:

```bash
cd env/dev
terraform destroy
```

Terraform shows the resources that will be deleted before asking for confirmation.

The S3 backend bucket is separate from the resources managed by this project, so `terraform destroy` does not delete the backend bucket.

For this project, destroying the environment is important because resources such as NAT Gateway, ALB, EC2 and RDS can continue to generate charges while they are running.

---

# 7. Backend information

The Terraform backend is configured in:

```text
env/dev/terraform.tf
```

The project uses an S3 backend for storing Terraform state.

Example:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "terraform-project/dev/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

The backend bucket needs to exist before running:

```bash
terraform init
```

Since the state is stored remotely, I should not expect a local `terraform.tfstate` file in `env/dev`.

All the modules used by the development environment are managed through the same root Terraform state.

For team usage, remote state is useful because the Terraform state does not need to be shared manually between developers.

---

# 8. Security notes

The application uses separate Security Groups for the different components.

### ALB

The ALB accepts HTTP traffic from the internet:

```text
Internet → ALB :80
```

### EC2

EC2 accepts application traffic only from the ALB Security Group:

```text
ALB-SG → EC2-SG :80
```

This is better than allowing HTTP directly from the internet to EC2.

### RDS

RDS is not publicly accessible.

Database access is restricted to the required Security Groups:

```text
EC2-SG → RDS-SG :5432

Lambda-SG → RDS-SG :5432
```

I prefer Security Group references here instead of allowing the complete private subnet CIDR because the rule is based on the workload rather than the IP range.

### Lambda

Lambda has its own Security Group and is deployed inside the VPC.

The Lambda execution role provides the permissions required for logging and VPC networking.

### Database credentials

Database credentials should not be committed to Git.

For a production implementation, I would use AWS Secrets Manager instead of keeping database passwords directly in Terraform variables or Lambda environment variables.

---

# 9. Cost considerations

Some of the resources in this project can incur AWS charges.

The main ones are:

* EC2
* RDS
* NAT Gateway
* Elastic IP
* Application Load Balancer
* Data transfer

The NAT Gateway is especially important to consider for a small development environment because it has an hourly cost and data processing charges.

For development, I should destroy the environment when I am finished:

```bash
terraform destroy
```

For production, cost optimization could include:

* Right-sizing EC2 and RDS
* Savings Plans or Reserved Instances where appropriate
* Auto Scaling
* Stopping non-production resources when not required
* Using VPC endpoints where appropriate instead of routing all AWS service traffic through NAT

---

# 10. Environment and secret handling

Environment-specific configuration is kept under:

```text
env/dev/
```

The development values are stored in:

```text
env/dev/terraform.auto.tfvars
```

For example, development-specific values can include:

```text
VPC CIDR
Availability Zones
Public subnet CIDRs
Private subnet CIDRs
EC2 instance type
Database name
Database username
```

The reusable modules do not contain development-specific values.

This allows the same modules to be reused for other environments later.

For example:

```text
env/
├── dev/
├── staging/
└── prod/
```

All of them can use the same:

```text
modules/
```

Sensitive values such as database passwords should not be committed to Git.

Also, `sensitive = true` only prevents Terraform from displaying the value normally in CLI output. The value can still exist in Terraform state, so the remote state must also be protected.

---

# Terraform Modules

## VPC

The VPC module creates the networking required by the application.

It includes:

* VPC
* Public subnets
* Private subnets
* Availability Zones
* Internet Gateway
* Route tables
* Route associations
* NAT Gateway where required

The module provides outputs such as:

```text
vpc_id
public_subnet_ids
private_subnet_ids
```

These values are passed to the other modules.

---

## EC2

The EC2 module creates:

* EC2 instance
* EC2 Security Group

The application instance is associated with the required subnet.

In the final architecture, the ALB is the entry point to the application:

```text
ALB-SG
   |
   | TCP 80
   ↓
EC2-SG
```

---

## RDS

The RDS module creates:

* PostgreSQL RDS instance
* DB subnet group
* RDS Security Group

RDS is placed in private subnets and is configured as:

```text
publicly_accessible = false
```

The database listens on:

```text
5432
```

Only the required application Security Groups are allowed to connect.

---

## Lambda

The Lambda module creates:

* Lambda function
* IAM execution role
* IAM policy attachments
* Lambda Security Group
* VPC configuration

The Lambda function connects to PostgreSQL:

```text
Lambda
   |
   | TCP 5432
   ↓
RDS
```

The Lambda function contains a query against the application database.

The PostgreSQL `psycopg2` dependency is included in the Lambda deployment package.

---

## ALB

The ALB module creates:

* Internet-facing Application Load Balancer
* ALB Security Group
* Target Group
* Listener
* Health check
* EC2 target registration

Traffic flows as:

```text
Internet
   |
   ↓
ALB
   |
   ↓
Target Group
   |
   ↓
EC2
```

The ALB checks the health of the EC2 target before sending traffic.

---

## Route 53

The Route 53 module creates a DNS record pointing to the ALB.

The flow is:

```text
Application DNS
      |
      ↓
Route 53
      |
      ↓
ALB
```

An AWS Alias record is used for the ALB.

---

# Database Schema

The SQL schema is stored separately from the Terraform infrastructure:

```text
database/schema.sql
```

The file contains SQL for creating the application database objects.

For example:

```text
application
├── users
├── products
└── orders
```

Terraform creates the RDS infrastructure and initial database.

The SQL file is responsible for the application-level schema.

For learning and testing, the schema can be executed from an EC2 instance using the PostgreSQL `psql` client:

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

In a production environment, I would use a database migration process through CI/CD instead of manually connecting through SSH.

---

# Important Terraform Concepts Used

This project covers the following Terraform concepts:

* Custom modules
* Module inputs
* Module outputs
* Variables
* Variable types
* Lists
* `count`
* Resource dependencies
* Implicit dependencies
* `depends_on`
* Data sources
* Security Group references
* Multi-AZ resources
* Remote Terraform state
* Environment-specific configuration
* Terraform plan/apply workflow

One important design principle used in this project is to let Terraform infer dependencies through resource references whenever possible.

`depends_on` is used only when Terraform cannot automatically understand a dependency.

---

# Deployment Order

The infrastructure is logically built around the following dependencies:

```text
VPC
 |
 +---- Public/Private Subnets
 |
 +---- Internet Gateway / Routes
 |
 +---- EC2
 |
 +---- RDS
 |
 +---- Lambda
 |
 +---- ALB
 |
 +---- Route 53
```

Terraform determines the actual creation order from the dependency graph.

For example:

```text
VPC
 ↓
Private Subnets
 ↓
RDS

VPC
 ↓
Public Subnets
 ↓
ALB
 ↓
EC2 Target
```

I don't manually create each resource in this order. Terraform builds the dependency graph and handles the ordering.

---

# Production Improvements

This project is mainly designed to demonstrate the required AWS and Terraform concepts.

For a production setup, I would improve it further by:

* Keeping EC2 instances in private subnets
* Using an Auto Scaling Group
* Running EC2 across multiple Availability Zones
* Using RDS Multi-AZ
* Using HTTPS with ACM
* Adding WAF to the ALB
* Using Secrets Manager for database credentials
* Using database migration tooling
* Using CloudWatch monitoring and alarms
* Applying least-privilege IAM policies
* Using VPC endpoints where appropriate
* Using CI/CD for Terraform
* Adding Terraform security and validation checks
* Using separate state/configuration for each environment
* Adding appropriate state locking and access controls

The current project provides the basic foundation while keeping the Terraform configuration modular and reusable.
