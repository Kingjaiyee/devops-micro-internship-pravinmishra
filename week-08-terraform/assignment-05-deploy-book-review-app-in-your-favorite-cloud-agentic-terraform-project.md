# Capstone Assignment — Deploy the Book Review App Using Terraform and Claude Code Agentic AI

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Student Details

**Full Name:** Victor Durojaiye  
**Cloud Platform:** AWS  
**GitHub Repository URL:** https://github.com/Kingjaiyee/devops-micro-internship-pravinmishra  
**Public Application URL / Load-Balancer DNS:** http://book-review-dev-public-alb-1499392855.eu-north-1.elb.amazonaws.com

---

## Purpose

Deploy the Book Review App using Terraform on AWS or Azure in a secure, highly available, production-style three-tier architecture. Use Claude Code, specialized subagents, Terraform MCP, and validation hooks to support the engineering workflow while keeping all infrastructure-changing operations under human control.

---

# Task 0 — Prepare the Project and Agentic AI Environment

## Goal

Prepare the Book Review App project and configure the provided Claude Code Agentic AI starter kit with project context, specialized subagents, Terraform MCP, validation hooks, and safety guardrails.

## Evidence

### Screenshot 1 — Project `CLAUDE.md`

Add a screenshot of the project `CLAUDE.md` showing the three-tier architecture, security boundaries, Terraform requirements, and human-approval rules.

![CLAUDE.md](screenshots/cap-task0-claude-md.png)

---

### Screenshot 2 — Terraform Engineer Subagent

Add a screenshot showing the Terraform Engineer subagent configuration.

![Terraform Engineer subagent](screenshots/cap-task0-terraform-engineer.png)

---

### Screenshot 3 — Architecture and Security Reviewer Subagent

Add a screenshot showing the Architecture and Security Reviewer subagent configuration.

![Architecture and Security Reviewer subagent](screenshots/cap-task0-security-reviewer.png)

---

### Screenshot 4 — Terraform MCP Connection

Add a screenshot showing Terraform MCP connected and available.

![Terraform MCP connected](screenshots/cap-task0-mcp-connected.png)

---

### Screenshot 5 — Validation Hooks

Add a screenshot showing the configured Claude Code validation hooks.

![Validation hooks](screenshots/cap-task0-hooks.png)

---

# Task 1 — Design the Three-Tier Architecture

## Goal

Design the required secure, highly available three-tier architecture and create an architecture diagram before building the infrastructure.

The diagram must show:

- VPC or VNet
- Availability Zones or equivalent availability locations
- Six subnets
- Internet connectivity
- NAT or outbound design
- Public load balancer
- Web Tier
- Internal load balancer
- Application Tier
- Managed MySQL
- Read replica
- Main traffic flow

## Architecture Diagram

![Three-tier architecture diagram](screenshots/cap-architecture-diagram.png)

---

# Task 2 — Build the Terraform Networking and Security Layers

## Goal

Create the modular Terraform project and implement the network and security layers across the required public and private subnets.

## Evidence

### Screenshot 6 — Modular Terraform Project Structure

Add a screenshot showing the modular Terraform project structure.

![Modular Terraform project structure](screenshots/cap-task2-project-structure.png)

---

### Screenshot 7 — Six-Subnet Architecture

Add a screenshot showing the six-subnet architecture across two availability locations.

![Six-subnet architecture](screenshots/cap-task2-six-subnets.png)

---

### Screenshot 8 — Public and Private Tier Separation

Add a screenshot showing the public and private tier separation, including routing and security boundaries.

![Public and private tier separation](screenshots/cap-task2-tier-separation.png)

---

# Task 3 — Build the Load-Balancing and Compute Layers

## Goal

Deploy the public and internal load balancers and the Web and Application compute resources required by the Book Review App.

## Evidence

### Screenshot 9 — Web and Application Compute

Add a screenshot showing the Web and Application compute resources in their required subnets.

![Web and application compute](screenshots/cap-task3-compute-subnets.png)

---

### Screenshot 10 — Public Load Balancer

Add a screenshot showing the internet-facing public load balancer.

![Public load balancer](screenshots/cap-task3-public-alb.png)

---

### Screenshot 11 — Internal Load Balancer

Add a screenshot showing the private internal load balancer.

![Internal load balancer](screenshots/cap-task3-internal-alb.png)

---

### Screenshot 12 — Healthy Targets

Add a screenshot showing healthy target groups or backend pools.

![Healthy targets](screenshots/cap-task3-healthy-targets.png)

---

# Task 4 — Build the Managed MySQL Database Layer

## Goal

Deploy a private, highly available managed MySQL database with a read replica and restrict database connectivity to the Application Tier.

## Evidence

### Screenshot 13 — Managed MySQL Database

Add a screenshot showing the managed MySQL database deployment.

![Managed MySQL database](screenshots/cap-task4-mysql.png)

---

### Screenshot 14 — High Availability

Add a screenshot showing the Multi-AZ or high-availability configuration.

![Multi-AZ configuration](screenshots/cap-task4-multi-az.png)

---

### Screenshot 15 — Read Replica

Add a screenshot showing the read replica configuration.

![Read replica configuration](screenshots/cap-task4-read-replica.png)

---

### Screenshot 16 — Private Database Access

Add a screenshot showing that the database is private and accepts MySQL traffic only from the Application Tier.

![Private database access](screenshots/cap-task4-private-access.png)

---

# Task 5 — Validate, Review, and Apply the Terraform Configuration

## Goal

Validate the Terraform configuration, review the execution plan using both Agentic AI and human judgment, and apply the infrastructure changes only after all required checks pass.

## Evidence

### Screenshot 17 — Terraform Validation

Add a screenshot showing successful `terraform validate` output.

![terraform validate](screenshots/cap-task5-validate.png)

---

### Screenshot 18 — Terraform Plan

Add a screenshot showing the Terraform plan output.

![terraform plan](screenshots/cap-task5-plan.png)

---

### Screenshot 19 — Terraform Apply

Add a screenshot showing successful `terraform apply` completion.

![terraform apply](screenshots/cap-task5-apply.png)

---

# Task 6 — Deploy and Configure the Book Review Application

## Goal

Deploy and configure the Book Review App across the Web, Application, and Database tiers and verify the complete application functionality.

## Evidence

### Screenshot 20 — Homepage

Add a screenshot showing the Book Review App homepage through the public endpoint.

![Homepage](screenshots/cap-task6-homepage.png)

---

### Screenshot 21 — Login or Authentication

Add a screenshot showing successful login or authentication.

![Login](screenshots/cap-task6-login.png)

---

### Screenshot 22 — Book Data

Add a screenshot showing the book listing or book details.

![Book data](screenshots/cap-task6-books.png)

---

### Screenshot 23 — Review Functionality

Add a screenshot showing the review functionality working successfully.

![Review functionality](screenshots/cap-task6-review.png)

---

### Screenshot 24 — Backend or API Evidence

Add a screenshot showing that the backend or API is working successfully.

![Backend API evidence](screenshots/cap-task6-api-evidence.png)

---

### Screenshot 25 — Database Reads and Writes

Add a screenshot showing successful database reads and writes.

![Database reads and writes](screenshots/cap-task6-db-records.png)

## Public Application URL

**Public Application URL / DNS:** http://book-review-dev-public-alb-1499392855.eu-north-1.elb.amazonaws.com

---

# Task 7 — Demonstrate the Agentic AI Workflow

## Goal

Demonstrate how Claude Code assisted with Terraform generation, architecture and security review, and evidence-based troubleshooting while infrastructure-changing decisions remained under human control.

You do not need to submit your complete Claude Code conversation history. Include only focused evidence.

## Evidence

### Screenshot 26 — AI-Assisted Terraform Generation

Add a screenshot showing one useful example of AI-assisted Terraform generation or improvement.

![AI-assisted Terraform generation](screenshots/cap-task7-ai-terraform.png)

---

### Screenshot 27 — Architecture or Security Review

Add a screenshot showing one structured architecture or security review result.

![Architecture and security review](screenshots/cap-task7-security-review.png)

---

### Screenshot 28 — AI-Assisted Troubleshooting

Add a screenshot showing one AI-assisted troubleshooting interaction based on collected evidence.

![AI-assisted troubleshooting](screenshots/cap-task7-troubleshooting.png)

---

# Task 8 — Complete the Final Architecture Review

## Goal

Review the completed infrastructure against the original capstone requirements and resolve significant architecture, security, reliability, and cost issues.

Confirm that the final review covers:

- Tier separation
- Availability
- Public exposure
- Routing
- Security rules
- Load balancing
- Database privacy
- Secrets
- Terraform quality
- Module structure
- Reliability
- Obvious cost risks

Use Screenshot 27 as the focused evidence for the structured architecture or security review.

The final Architecture and Security Reviewer pass was run against the live deployment and returned 20 PASS, 6 WARN and 0 FAIL. `terraform fmt -check -recursive` and `terraform validate` were both clean.

Confirmed passing: the six-subnet plan across two Availability Zones; database subnets whose route table carries only the local route, verified in both the code and in AWS; the only CIDR-based security group rules being port 80 on the public load balancer and SSH from my own /32, with every tier-to-tier rule referencing a source security group; port 3001 reachable only from the internal load balancer and 3306 only from the application tier; the RDS security group having no egress at all; secrets held as ephemeral variables passed only to write-only arguments, with the state files searched and found to contain nulls; the web instance role explicitly denied read access to the application tier's secrets; IMDSv2 required on every instance; and encryption on both the EBS volumes and RDS storage.

The six warnings, and what I decided about each:

1. Standalone instances rather than an Auto Scaling group. Accepted. Two instances per tier across two Availability Zones meets the availability requirement, but nothing replaces a failed instance automatically. This is the limitation I would close first in a real deployment.
2. A single NAT gateway. Accepted and commented in the code. It affects outbound traffic from the application tier only, and a second gateway roughly doubles that part of the cost.
3. No RDS deletion protection and no final snapshot. Deliberate, so teardown is clean and leaves no billable snapshot. Both would be wrong in production.
4. The seeding race between the two application instances is reduced but not eliminated. The cause is in the application code, not the infrastructure. The boot stagger plus the restart watchdog recovers from it.
5. `terraform plan` was not rerun for drift before teardown. This gap was closed by destroying the stack rather than by a drift check.
6. The Ubuntu image lookup always takes the most recent image. A newer image would make the next plan propose replacing all four instances. That is expected behaviour rather than drift, and worth knowing before reading such a plan.

One residual risk the review did not raise, which I want on the record: the backend reads its credentials from a `.env` file, so the database password exists in plain text on the application instances at runtime. It is written with mode 600 and never appears in user data, Terraform outputs, state or the repository, but the file itself is the weak point in the chain. A production deployment would close it with runtime secret injection rather than a file on disk.

---

# Task 9 — Answer the Reflection Questions

## Goal

Reflect on the architecture, Terraform implementation, and Agentic AI workflow. Answer each question briefly in your own words.

## Architecture

### 1. Why did you separate the Web, Application, and Database tiers?

So that reaching one tier does not mean reaching the next. The web tier is exposed to the internet because it has to be, and it is the tier most likely to be compromised. Putting the application and database in their own private subnets with their own security groups means an attacker who gets a shell on a web instance still has to get past another boundary to reach the API, and another to reach the data. It also lets each tier be sized, patched and replaced on its own.

### 2. Why is the Application Tier private?

Nothing outside the VPC needs to talk to it. The browser talks to the public load balancer, and Nginx on the web tier forwards API calls to the internal load balancer. Giving the application instances public IPs would add an internet-facing attack surface that buys nothing. They still reach out through the NAT gateway for package installs and Parameter Store, but nothing can start a connection inward.

### 3. Why is MySQL private?

Because a database has no reason to accept connections from the internet, and the cost of getting that wrong is the whole dataset. It sits in subnets whose route table has no route to the internet gateway or the NAT gateway, `publicly_accessible` is false, and its security group allows 3306 from the application security group only. Not from a CIDR range, from a security group, so it does not matter what addresses the application instances happen to get.

### 4. Why are multiple Availability Zones used?

An Availability Zone is a failure domain. Everything in a single zone can go down together. Spreading the subnets, the load balancers and the database standby across two zones means a zone failure degrades the system instead of ending it. My honest limitation is the single NAT gateway: if its zone fails, the application tier loses outbound access. That was a deliberate cost trade-off, and I would fix it before calling this production ready.

### 5. What is the difference between Multi-AZ/high availability and a read replica?

Multi-AZ keeps a synchronous standby in the other Availability Zone that you cannot connect to. It exists to take over automatically if the primary fails, and the writer endpoint follows it across. A read replica is asynchronous, has its own endpoint, and can be read from right now, which takes read load off the writer. It does not fail over on its own. One is for surviving failure, the other is for handling load, and neither substitutes for the other.

## Terraform

### 6. How did you divide your Terraform into modules?

Five modules by responsibility: network, security, load-balancer, compute and database, with a separate secrets module for the Parameter Store entries. The split follows what changes together. Route tables and subnets change as one unit, so they live together. Security groups sit on their own because every other module consumes them and none of them should be editing them. The root module holds the provider, the variables and the wiring.

### 7. How do the modules communicate through variables and outputs?

The network module outputs the VPC ID and the three groups of subnet IDs. The security module outputs five security group IDs. The load balancer module outputs both DNS names and both target group ARNs. The root passes those into the compute and database modules as inputs. Nothing reaches across into another module's internals. A useful side effect is that dependency order falls out of the data: I never told Terraform to build the VPC before the database, but because the database module takes subnet IDs the network module produces, the ordering is implied.

### 8. What did you specifically check in `terraform plan`?

The resource count against what I expected, and zero destroy or replace lines on a first build. Then the things that would quietly break the architecture: that `internal = true` on the internal load balancer, that `publicly_accessible` was false on both database instances, that the only `0.0.0.0/0` rules were the ones I had authorised, and that no secret value appeared anywhere in the output. I also learned what plan cannot tell you. It will not catch an AWS API constraint: a security group rule description containing an apostrophe passed validate and plan, then failed 22 minutes into the apply, after the database had already been built. And a plan that proposes replacing all four instances may just mean Canonical published a new image, because the AMI lookup takes the latest.

## Agentic AI

### 9. What was the purpose of `CLAUDE.md`?

It is the context the agent starts from, so I am not restating the architecture in every prompt and it is not filling gaps with guesses. It records the three-tier design, the six-subnet plan, the security boundaries, the ports, and the rule that infrastructure changes need my approval. I extended it as the build went on: the application's real ports and environment variable names taken from the repository rather than assumed, the decision that `NEXT_PUBLIC_API_URL` must be the public load balancer, and an explicit note that allow-all egress on the web and app security groups is a reviewed exception. That last one matters, because otherwise a reviewer keeps flagging a decision I had already made on purpose.

### 10. What work did the Terraform Engineer subagent perform?

Module design and the Terraform itself, one phase at a time: network, then security groups, then load balancers, then secrets and database, then compute and the two bootstrap templates. It also researched current provider documentation through MCP, explained its design choices before writing files, and ran fmt and validate after each phase. It never applied anything.

### 11. What did the Architecture and Security Reviewer identify?

Its most valuable finding was that the AWS managed policy `AmazonSSMManagedInstanceCore`, which I attached to the web role for Session Manager, grants `ssm:GetParameter` on every parameter in the account. That silently undid the separation I had just built, where only the application tier could read the database password. The fix was an explicit Deny on the web role, and I verified it afterwards on the running instances: the same command returns the parameter on an application instance and `AccessDenied` on a web one. It also flagged the ALB egress rules as too broad, and I scoped both. The more useful lesson was about its limits: in an earlier pass it returned a clean PASS on tagging and hardcoded values while missing two real issues that had already been identified. A PASS from a reviewer is evidence, not proof.

### 12. Why did you use Terraform MCP instead of relying only on Claude's existing Terraform knowledge?

Because provider arguments change and remembered syntax goes stale. A concrete case: `aws_eip` used to take `vpc = true`, which fails on provider 6.x, where the correct argument is `domain = "vpc"`. Another: the write-only arguments `value_wo` and `password_wo`, which keep secrets out of state entirely, are recent enough that they would not have come up from memory. MCP meant those came from the current documentation rather than from a plausible guess.

### 13. What was the purpose of your validation hooks?

To make the boring checks automatic and deterministic. Whenever a Terraform file changed, the hook ran fmt and validate and returned the result, so formatting and syntax errors surfaced immediately instead of at plan time. It matters that these are hooks rather than instructions: an instruction is something the agent may or may not follow, while a hook runs regardless. The same settings file also put `terraform apply` and `terraform destroy` behind an approval prompt and denied reads of `.env`, `.pem`, `.key` and state files.

### 14. Describe one real issue Claude helped you troubleshoot.

Before writing any deployment code, it inspected the application repository and found that the frontend builds its API URLs two different ways: `page.js` calls `${NEXT_PUBLIC_API_URL}/api/books` while `services/api.js` calls `${NEXT_PUBLIC_API_URL}/books` for login, registration, book details and reviews. No single value of that variable works for both through an `/api/` proxy. It would have looked like the homepage working and login failing, which is an unpleasant thing to debug at the end. We resolved it with `/api` in the variable plus a small Nginx rewrite. In the same pass it found a seeding race: if both application instances start together and both see an empty user table, one hits a unique constraint, and the error is caught and logged but the process never reaches `app.listen`, so it sits dead on port 3001 while systemd thinks it is fine. We staggered the second instance and added a watchdog that marks the service failed if the port is not answering, so the restart policy actually fires.

### 15. Describe one recommendation you reviewed, modified, or rejected instead of accepting blindly.

Two worth mentioning, in opposite directions. I rejected one: the reviewer suggested adding a self-referencing rule to the RDS security group in case it blocked replication. Same-region replication does not traverse those rules, so it would have weakened "3306 from the application tier only" to solve a problem that did not exist. I left it, and the replica came up healthy, which settled it. The one I accepted was a correction to my own spec. I had written that both tiers should get the same instance profile with read access to the database password. The agent stopped and asked why the web tier needed it. It does not: it runs Nginx and Next.js and never touches the database. I had copied a permission rather than thinking about it, and the internet-facing tier would have been holding credentials it had no use for. I took its version.

---

# Task 10 — Publish the Mandatory LinkedIn Post

## Goal

Publish a LinkedIn post describing the capstone, the technical work completed, the Agentic AI workflow, and the lessons learned.

Write the post in your own words, include at least one project image or other proof, and ensure that it can be viewed by the submission reviewer.

## LinkedIn Post URL

**LinkedIn Post URL:** https://www.linkedin.com/posts/victor-jaiye_devops-terraform-aws-share-7509612345103507457-_6Ul/

---

# Submission Instructions

- Complete Tasks 0–10 in sequence.
- Include all Screenshots 1–28 exactly as specified.
- Ensure that your full name is visible in the required screenshots.
- Include the selected cloud platform.
- Include the completed architecture diagram.
- Include the modular Terraform project structure.
- Include the working public application URL or public load-balancer DNS.
- Include all required Agentic AI workflow evidence.
- Answer all 15 reflection questions briefly in your own words.
- Include the published LinkedIn post URL.
- Do not expose cloud credentials, database passwords, SSH private keys, JWT secrets, access tokens, account IDs, Terraform state containing sensitive values, or other confidential information.
- Review all screenshots and project files carefully before submitting through GitHub.

---

# Completion Checklist

- [x] Selected AWS or Azure
- [x] Added and reviewed the Agentic AI starter files
- [x] Configured `CLAUDE.md`
- [x] Configured the Terraform Engineer subagent
- [x] Configured the Architecture and Security Reviewer subagent
- [x] Connected Terraform MCP
- [x] Configured validation hooks and safety guardrails
- [x] Created the architecture diagram
- [x] Created the six-subnet design
- [x] Configured public Web Tier routing
- [x] Kept the Application Tier private
- [x] Kept the Database Tier private
- [x] Configured tier-specific Security Groups or NSGs
- [x] Restricted backend port `3001`
- [x] Restricted MySQL port `3306` to the Application Tier
- [x] Created the public load balancer
- [x] Created the internal load balancer
- [x] Configured listeners and health checks
- [x] Deployed the Web Tier compute resources
- [x] Deployed the private Application Tier compute resources
- [x] Provisioned private managed MySQL
- [x] Configured Multi-AZ or high availability
- [x] Configured a read replica
- [x] Created the modular Terraform project
- [x] Used variables, outputs, and module dependencies
- [x] Used current Terraform documentation through MCP
- [x] Used hooks for deterministic validation
- [x] Completed `terraform fmt`
- [x] Completed `terraform validate`
- [x] Reviewed `terraform plan`
- [x] Completed the Terraform Engineer review
- [x] Completed the Architecture and Security review
- [x] Applied the infrastructure only after human approval
- [x] Deployed and configured the backend
- [x] Deployed and configured the frontend
- [x] Configured Nginx where required
- [x] Configured the internal backend endpoint
- [x] Configured the public frontend endpoint
- [x] Verified the homepage
- [x] Verified login or authentication
- [x] Verified book data
- [x] Verified review functionality
- [x] Verified the backend API
- [x] Verified database reads and writes
- [x] Verified healthy load-balancer targets
- [x] Included AI-assisted Terraform generation evidence
- [x] Included one architecture or security review
- [x] Included one AI-assisted troubleshooting example
- [x] Completed the final architecture review
- [x] Answered all 15 reflection questions
- [x] Published the mandatory LinkedIn post
- [x] Added the LinkedIn post URL
- [x] Captured all 28 required screenshots
- [x] Confirmed that my full name is visible in the required screenshots
- [x] Checked that no secrets or sensitive information are exposed

---

## About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory), focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations through hands-on experience.

---

## Resources

- Book Review App Repository: [https://github.com/pravinmishraaws/book-review-app](https://github.com/pravinmishraaws/book-review-app)
- DMI Official Website: [https://dmi.pravinmishra.com](https://dmi.pravinmishra.com)
- University: [https://university.pravinmishra.com](https://university.pravinmishra.com)
- Discord Community: [https://discord.pravinmishra.com](https://discord.pravinmishra.com)
- Blog: [https://dmi.pravinmishra.com/blog](https://dmi.pravinmishra.com/blog)
- YouTube Playlist: [https://www.youtube.com/playlist?list=PLFeSNDtI4Cho](https://www.youtube.com/playlist?list=PLFeSNDtI4Cho)
- Pravin Mishra on LinkedIn: [https://www.linkedin.com/in/pravin-mishra-aws-trainer/](https://www.linkedin.com/in/pravin-mishra-aws-trainer/)
- CloudAdvisory on LinkedIn: [https://www.linkedin.com/company/thecloudadvisory/](https://www.linkedin.com/company/thecloudadvisory/)

---

*This submission is part of the DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
