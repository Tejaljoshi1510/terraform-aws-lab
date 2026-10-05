# terraform-aws-lab
architecture:
                         Users
                           │
                           ▼
                       Route 53
                    app.example.com
                           │
                           ▼
                    ┌─────────────┐
                    │     ALB     │
                    │   Public    │
                    └──────┬──────┘
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                  EC2-1         EC2-2
                 Private       Private
                    │             │
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │     RDS     │
                    │ PostgreSQL  │
                    │   Private   │
                    └─────────────┘

                    Lambda
                       │
                       │ query
                       ▼
                      RDS

And underneath everything:
                         VPC
                          │
          ┌───────────────┴───────────────┐
          │                               │
     Public Subnets                 Private Subnets
          │                               │
      ALB / NAT                       EC2 / RDS

✅ 1. VPC
       ↓
✅ 2. Public EC2 + Security Group
       ↓
➡️ 3. RDS PostgreSQL
       ↓
4. Lambda → RDS
       ↓
5. ALB → EC2
       ↓
6. Route 53 → ALB
       ↓
7. Move EC2 to private subnet
       ↓
8. Multi-AZ / NAT / production improvements

                         VPC
                          │
              ┌───────────┴───────────┐
              │                       │
             AZ-1                    AZ-2
              │                       │
       ┌──────┴──────┐         ┌──────┴──────┐
       │             │         │             │
    Public-A      Private-A  Public-B      Private-B
       │             │         │             │
      EC2           RDS       future ALB     RDS

database flow
The RDS PostgreSQL database is created by Terraform.

The SQL schema is stored separately in:

database/schema.sql

For learning/testing, the schema can be executed using the PostgreSQL `psql` client from the EC2 instance:

Laptop → SSH → EC2 → PostgreSQL connection → RDS

`schema.sql` contains only SQL statements. SSH commands and database connection commands are executed separately.

In a production environment, database schema changes should be managed through a migration tool and CI/CD pipeline rather than manually through SSH.

