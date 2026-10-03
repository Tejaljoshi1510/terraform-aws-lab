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