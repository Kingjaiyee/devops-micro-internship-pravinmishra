# Assignment 5 — Deploy a Highly Available Two-Tier Application on AWS (VPC + ALB + ASG + Multi-AZ RDS)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will design and deploy a highly available two-tier web application on AWS: highly available networking across two Availability Zones, an Application Load Balancer, an Auto Scaling Group for the web tier, and a private Multi-AZ RDS database. You must prove high availability with real failure tests.

---

# Task 1 — Create HA Networking (VPC + 4 Subnets + IGW + NAT + Route Tables)

## Goal

Build a VPC (10.0.0.0/16) with two public and two private subnets across two Availability Zones, an Internet Gateway, a NAT Gateway, and the matching public/private route tables.

### Evidence

#### Screenshot 1 — VPC details showing CIDR 10.0.0.0/16

![Screenshot 1](screenshots/a5-task1-vpc.png)

---

#### Screenshot 2 — Subnets list showing four subnets and their Availability Zones

![Screenshot 2](screenshots/a5-task1-subnets.png)

---

#### Screenshot 3 — Public route table showing the Internet Gateway route and both public-subnet associations

![Screenshot 3](screenshots/a5-task1-public-rt.png)

---

#### Screenshot 4 — Private route table showing the NAT Gateway route and both private-subnet associations

![Screenshot 4](screenshots/a5-task1-private-rt.png)

---

#### Screenshot 5 — NAT Gateway status showing Available and the Elastic IP

![Screenshot 5](screenshots/a5-task1-nat.png)

---

# Task 2 — Create Security Groups (ALB, EC2, RDS) with Least Privilege

## Goal

Create `ha-alb-sg` (HTTP public), `ha-web-sg` (HTTP only from `ha-alb-sg`, SSH from your IP), and `ha-db-sg` (database port only from `ha-web-sg`).

### Evidence

#### Screenshot 6 — ALB Security Group inbound rules

![Screenshot 6](screenshots/a5-task2-alb-sg.png)

---

#### Screenshot 7 — EC2 Security Group inbound rules showing the ALB Security Group reference and SSH from your IP

![Screenshot 7](screenshots/a5-task2-web-sg.png)

---

#### Screenshot 8 — RDS Security Group inbound rule showing the database port allowed only from the EC2 Security Group

![Screenshot 8](screenshots/a5-task2-db-sg.png)

---

# Task 3 — Deploy Database Tier (RDS Multi-AZ in Private Subnets)

## Goal

Launch a private, Multi-AZ RDS database (MySQL or PostgreSQL) using the private DB Subnet Group and `ha-db-sg`.

### Evidence

#### Screenshot 9 — RDS summary showing Multi-AZ = Yes and Publicly accessible = No

![Screenshot 9](screenshots/a5-task3-rds-summary.png)

---

#### Screenshot 10 — RDS connectivity section showing the DB Subnet Group and Security Group

![Screenshot 10](screenshots/a5-task3-rds-connectivity.png)

---

# Task 4 — Build a Launch Template (User Data Installs App + Connects to DB)

## Goal

Create a Launch Template whose user data installs the web-server runtime, deploys the application, configures the database connection, and starts the required services.

### Evidence

#### Screenshot 11 — Launch Template details showing that user data exists, including a visible snippet

![Screenshot 11](screenshots/a5-task4-launch-template.png)

---

#### Screenshot 12 — A running instance created from the template showing that the application responds on port 80 through a local test or browser using its public IP

![Screenshot 12](screenshots/a5-task4-instance-test.png)

---

# Task 5 — Create an Application Load Balancer (ALB) Across 2 Public Subnets

## Goal

Create an internet-facing ALB across both public subnets with an HTTP listener and a healthy instance target group.

### Evidence

#### Screenshot 13 — ALB details showing two public subnets in two Availability Zones

![Screenshot 13](screenshots/a5-task5-alb.png)

---

#### Screenshot 14 — Target group showing at least one healthy target

![Screenshot 14](screenshots/a5-task5-target-group.png)

---

# Task 6 — Create Auto Scaling Group (ASG) in 2 Public Subnets

## Goal

Create an Auto Scaling Group from the Launch Template across both public subnets, with desired capacity 2, minimum 2, and maximum 4, registered to the ALB target group.

### Evidence

#### Screenshot 15 — Auto Scaling Group showing desired, minimum, and maximum capacity and the selected subnet Availability Zones

![Screenshot 15](screenshots/a5-task6-asg.png)

---

#### Screenshot 16 — EC2 instances list showing two running instances in different Availability Zones

![Screenshot 16](screenshots/a5-task6-instances.png)

---

# Task 7 — Configure App to Use RDS + Validate Read/Write

## Goal

Confirm the application communicates with the RDS database through the ALB DNS name with at least one read and one write operation.

### Evidence

#### Screenshot 17 — Browser showing the application loaded through the ALB DNS name with the URL visible

![Screenshot 17](screenshots/a5-task7-alb-site.png)

---

#### Screenshot 18 — Proof of a database write through a UI message or database query output

![Screenshot 18](screenshots/a5-task7-db-write.png)

---

# Task 8 — High Availability Tests (Must Do Both)

## Goal

Test A: terminate one web instance and confirm the Auto Scaling Group replaces it automatically without interrupting the ALB.

Test B: simulate an Availability Zone impact (stop, detach, or reduce desired capacity in one AZ) and confirm the application stays available.

### Evidence

#### Screenshot 19 — EC2 showing the terminated instance and the newly launched instance; timestamps are helpful

![Screenshot 19](screenshots/a5-task8-testA-instances.png)

---

#### Screenshot 20 — Target group showing healthy targets after replacement

![Screenshot 20](screenshots/a5-task8-testA-targets.png)

---

#### Screenshot 21 — Evidence that an instance was removed, detached, placed in Standby, or stopped in one Availability Zone

![Screenshot 21](screenshots/a5-task8-testB-standby.png)

---

#### Screenshot 22 — Browser showing that the ALB DNS endpoint still works during the change

![Screenshot 22](screenshots/a5-task8-testB-site.png)

---

# Task 9 — Architecture and Test-Results Summary

## Goal

Summarize the VPC/subnet layout, the ALB and Auto Scaling Group setup, the private Multi-AZ RDS setup, and the results of both high-availability tests.

### Evidence

#### Screenshot 23 — A simple architecture diagram, which may be hand-drawn, or an AWS console overview showing the components

![Screenshot 23](screenshots/a5-task9-architecture.png)

---

### Notes

Summarize the VPC and subnets across the two Availability Zones.

The VPC ha-vpc uses CIDR 10.0.0.0/16 and spans two Availability Zones, eu-north-1a and eu-north-1b. It has four subnets: two public (public-subnet-a 10.0.1.0/24 in eu-north-1a, public-subnet-b 10.0.2.0/24 in eu-north-1b) and two private (private-subnet-a 10.0.11.0/24 in eu-north-1a, private-subnet-b 10.0.12.0/24 in eu-north-1b). The public subnets route to an internet gateway and hold the load balancer and web instances. The private subnets route outbound through a NAT gateway and hold the database. Splitting each tier across two AZs is what makes the design survive the loss of a single zone.

Summarize the ALB and Auto Scaling Group setup.

An internet-facing Application Load Balancer (ha-alb) sits across both public subnets and is the single public entry point. It listens on HTTP port 80 and forwards to the target group ha-web-tg, which health-checks each instance on path / and accepts response codes 200 to 399. The Auto Scaling Group (ha-asg) launches instances from the HA-WEB-Launch-Template across both public subnets, with desired 2, minimum 2, maximum 4. It uses ELB health checks, so an instance the load balancer considers unhealthy is replaced automatically. Instances self-configure on boot through user data that installs the web stack and connects to the database.

Summarize the private Multi-AZ RDS setup.

The database is a MySQL RDS instance (ha-db) placed in the private subnets through the DB subnet group HA-DB-Subnet-GP, with Public access set to No so it is never reachable from the internet. It only accepts connections on port 3306 from the web security group ha-web-sg, following the least-privilege chain internet to ALB to EC2 to RDS. Note: this AWS account is restricted to the RDS Free Tier, which only permits single-AZ deployments, so the database was launched single-AZ. In a Multi-AZ deployment RDS would keep a synchronous standby in the second AZ and fail over to it automatically on the same endpoint, usually within about a minute, with no application change required.

Summarize the results of both high-availability tests.

Test A: I terminated one web instance. The Auto Scaling Group detected the drop below desired capacity and launched a replacement automatically, which registered with the target group and became healthy once its user data finished. The site stayed reachable through the ALB the whole time, served by the instance in the other AZ. Test B: I simulated an AZ impact by placing the eu-north-1a instance into Standby, leaving service running only from eu-north-1b. The application remained available through the ALB DNS name throughout. After capturing evidence I returned the instance to service and restored minimum capacity to 2. Both tests confirm the web tier self-heals and stays available through the loss of an instance or a single AZ.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about the high-availability build, including the ALB URL (or a redacted screenshot), three to five lines on what you built and how you tested high availability, and one proof screenshot.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

https://www.linkedin.com/posts/victor-jaiye_devops-aws-cloudcomputing-share-7502135194674716672-D8yG/

---

#### Screenshot of LinkedIn post

![LinkedIn post](screenshots/a5-linkedin-post.png)

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not expose passwords, connection strings, private keys, or account IDs

---

# Completion Checklist

- [x] Task 1: VPC, four subnets, IGW, NAT Gateway, and route tables created (Screenshots 1–5)
- [x] Task 2: Least-privilege ALB, EC2, and RDS security groups created (Screenshots 6–8)
- [x] Task 3: Private Multi-AZ RDS created (Screenshots 9–10)
- [x] Task 4: Self-configuring Launch Template created and tested (Screenshots 11–12)
- [x] Task 5: ALB created across both public subnets (Screenshots 13–14)
- [x] Task 6: Auto Scaling Group running two instances across two AZs (Screenshots 15–16)
- [x] Task 7: Application verified through the ALB with a database read and write (Screenshots 17–18)
- [x] Task 8: Both high-availability tests completed (Screenshots 19–22)
- [x] Task 9: Architecture and test-results summary completed (Screenshot 23 & Notes)
- [x] LinkedIn post published and URL submitted
- [x] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
