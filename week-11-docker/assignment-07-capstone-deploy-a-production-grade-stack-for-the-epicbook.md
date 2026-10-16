# Assignment 7 — Capstone: Deploy a Production-Grade Stack for The EpicBook

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook application as a production-oriented Docker Compose stack on a cloud VM. You will use optimized container images, isolated networks, health checks, persistent MySQL storage, a selected reverse proxy, logging, backup and restore testing, and reliability procedures.

---

# Task 0 — App Discovery and Architecture

## Goal

Review the EpicBook repository and design the intended application architecture.

### Evidence

#### Screenshot 1 — EpicBook Project Structure

Add a terminal screenshot showing the EpicBook project structure after cloning the repository.

![Screenshot 1](screenshots/a7-s01-project-structure.png)

---

#### Screenshot 2 — Architecture Diagram

Add a screenshot of your architecture diagram showing:

- Public user
- Reverse proxy
- Frontend
- Backend
- Database
- Docker networks
- Public and private ports
- Persistent database storage

Add your full name inside the diagram or as a clear caption below it.

![Screenshot 2](screenshots/a7-s02-architecture-diagram.png)

**Victor Durojaiye**

---

#### Screenshot 3 — Environment Variables and Ports Document

Add a screenshot showing the contents of:

```text
docs/02-env-and-ports.md
```

It must document environment-variable names, internal ports, persistent-data details, and the health-check method. Do not expose real credentials or values.

![Screenshot 3](screenshots/a7-s03-env-and-ports-doc.png)

---

# Task 1 — Create Production Docker Images

## Goal

Create optimized production images for the EpicBook backend and frontend.

### Evidence

#### Screenshot 4 — Backend Dockerfile

Add a screenshot showing `backend/Dockerfile`, including:

- Dependency stage
- Minimal runtime stage
- Production startup command
- Internal backend port
- Non-root user configuration

![Screenshot 4](screenshots/a7-s04-backend-dockerfile.png)

---

#### Screenshot 5 — Frontend Dockerfile

Add a screenshot showing `frontend/Dockerfile`, including:

- Nginx runtime image
- Static frontend files copied to the Nginx web root

![Screenshot 5](screenshots/a7-s05-frontend-dockerfile.png)

---

#### Screenshot 6 — Docker Ignore Files

Add a screenshot showing both:

```text
backend/.dockerignore
frontend/.dockerignore
```

![Screenshot 6](screenshots/a7-s06-dockerignore-files.png)

---

#### Screenshot 7 — Docker Image Builds and Size Comparison

Add a terminal screenshot showing successful builds of:

- Baseline backend image
- Optimized backend image
- Frontend image

The screenshot must also show the baseline and optimized backend image-size comparison.

![Screenshot 7](screenshots/a7-s07-image-builds-sizes.png)

---

#### Screenshot 8 — Backend Running as Non-Root User

Add a terminal screenshot showing the optimized backend container running as a non-root user.

![Screenshot 8](screenshots/a7-s08-backend-non-root.png)

---

### Notes

Write a short note covering:

- Baseline and optimized backend image sizes
- The image-size reduction achieved
- One Docker layer-caching optimization used
- The security benefit of running the backend as a non-root user

The baseline backend image (`epicbook-backend:baseline`, full `node:22`, `npm install`, whole folder) is 430 MB. The optimized image (`epicbook-backend:1.0`, multi-stage on `node:22-alpine`, production dependencies only) is 65.9 MB, both measured by CONTENT SIZE.

That is an 84.7% reduction ((430 − 65.9) ÷ 430 × 100); the baseline is 6.5 times larger.

Layer caching: `package.json` and `package-lock.json` are copied and `npm ci --omit=dev` runs in its own stage before any app code, so a code change reuses the cached dependency layer. I also moved `eslint` and `eslint-plugin-import` out of `dependencies`, so lint tools no longer ship in the image.

Before building, `npm audit` found 5 critical and 12 high advisories in the production dependencies (including `mysql2` 2.1.0 and `sequelize` 6.3.0). Upgrading `mysql2` to 3.x and letting `npm audit fix` raise the rest within their ranges brought that to 0 critical and 0 high, and a test run against MySQL 8.4 with the real seed data confirmed the app still worked.

Non-root: the backend runs as `node` (uid 1000), and the code and `node_modules` stay root-owned. If the app were compromised, the attacker could not change the code or the installed packages and would have no root inside the container to work from.

---

# Task 2 — Create the Docker Compose Stack and Networks

## Goal

Create one Docker Compose stack containing the reverse proxy, frontend, backend, and MySQL database.

### Evidence

#### Screenshot 9 — Docker Compose Services

Add a screenshot showing `docker-compose.yml` with all four services:

```text
reverse-proxy
frontend
backend
database
```

![Screenshot 9](screenshots/a7-s09-compose-services.png)

---

#### Screenshot 10 — Networks and Named Volume

Add a screenshot showing:

- `front-tier` network
- `back-tier` network
- `db_data` named volume

![Screenshot 10](screenshots/a7-s10-networks-volume.png)

---

#### Screenshot 11 — Docker Compose Validation

Add a terminal screenshot showing successful Docker Compose validation without exposing environment-variable values or secrets.

![Screenshot 11](screenshots/a7-s11-compose-validation.png)

---

# Task 3 — Configure Health Checks and Startup Dependencies

## Goal

Configure health checks and ensure services start only after their dependencies are healthy.

### Evidence

#### Screenshot 12 — Backend Health Endpoint

Add a screenshot showing the backend application configuration for the `/health` endpoint.

![Screenshot 12](screenshots/a7-s12-backend-health-endpoint.png)

---

#### Screenshot 13 — MySQL and Backend Health Checks

Add a screenshot showing `docker-compose.yml` with health checks for MySQL and the backend.

![Screenshot 13](screenshots/a7-s13-db-backend-healthchecks.png)

---

#### Screenshot 14 — Frontend and Reverse-Proxy Health Checks

Add a screenshot showing:

- Frontend health check
- Reverse-proxy health check
- `depends_on` conditions using `service_healthy`

![Screenshot 14](screenshots/a7-s14-frontend-proxy-healthchecks.png)

---

#### Screenshot 15 — Running Healthy Services

Add a terminal screenshot showing Docker Compose service status. The database, backend, frontend, and reverse proxy must be running successfully.

![Screenshot 15](screenshots/a7-s15-healthy-services.png)

---

#### Screenshot 16 — Public Health Endpoint

Add a terminal screenshot showing a successful response from the public application health endpoint through the reverse proxy.

![Screenshot 16](screenshots/a7-s16-public-health.png)

---

#### Screenshot 17 — Health-Check and Startup-Order Document

Add a screenshot showing the contents of:

```text
docs/03-healthchecks-and-depends-on.md
```

Explain the health-check method for each service and the startup dependency order.

![Screenshot 17](screenshots/a7-s17-healthchecks-doc.png)

---

# Task 4 — Configure the Reverse Proxy and Same-Origin Routing

## Goal

Use either Nginx or Traefik as the only public entry point for the EpicBook application.

### Evidence

#### Screenshot 18 — Selected Reverse-Proxy Configuration

Add a screenshot showing the configuration for your selected reverse proxy.

It must show routes for:

- Static frontend assets
- Application pages
- API requests
- Health endpoint

![Screenshot 18](screenshots/a7-s18-proxy-config.png)

---

#### Screenshot 19 — Only Reverse Proxy Publishes Port 80

Add a screenshot of `docker-compose.yml` showing that only the `reverse-proxy` service publishes port 80.

![Screenshot 19](screenshots/a7-s19-only-proxy-port-80.png)

---

#### Screenshot 20 — Reverse-Proxy Route Testing

Add a terminal screenshot showing successful requests through the selected reverse proxy to:

- Application page
- One API endpoint
- One static asset
- Health endpoint

![Screenshot 20](screenshots/a7-s20-route-tests.png)

---

#### Screenshot 21 — EpicBook Application Through Public IP

Add a browser screenshot showing the EpicBook application loaded through the VM public IP address.

Add your full name as a clear caption below the screenshot.

![Screenshot 21](screenshots/a7-s21-browser-public-ip.png)

**Victor Durojaiye**

---

#### Screenshot 22 — Proxy Routing and CORS Document

Add a screenshot showing the contents of:

```text
docs/04-proxy-routing-and-cors.md
```

Explain the proxy routes and state whether CORS was required and why.

![Screenshot 22](screenshots/a7-s22-proxy-routing-cors-doc.png)

---

# Task 5 — Prove Data Persistence, Backup, and Restore

## Goal

Verify MySQL persistence and perform a controlled backup and restore drill.

### Evidence

#### Screenshot 23 — MySQL Volume Configuration

Add a terminal screenshot showing the `db_data` named volume and its MySQL mount configuration.

![Screenshot 23](screenshots/a7-s23-db-volume.png)

---

#### Screenshot 24 — Test Data Before Backup

Add a terminal screenshot showing the selected test data before the backup and restore drill.

![Screenshot 24](screenshots/a7-s24-test-data-before.png)

---

#### Screenshot 25 — Successful Backup Creation

Add a terminal screenshot showing successful backup creation and the backup file stored in the host backup directory.

![Screenshot 25](screenshots/a7-s25-backup-created.png)

---

#### Screenshot 26 — Controlled Data-Loss Test

Add a terminal screenshot showing that the selected test record was removed during the controlled data-loss test.

![Screenshot 26](screenshots/a7-s26-controlled-data-loss.png)

---

#### Screenshot 27 — Restore Verification

Add a terminal screenshot showing successful restore and verification that the deleted test record is available again.

![Screenshot 27](screenshots/a7-s27-restore-verified.png)

---

#### Screenshot 28 — Persistence After Down/Up Cycle

Add a terminal screenshot showing that database data remains available after a non-destructive Docker Compose down/up cycle.

Do not use `docker compose down -v`.

![Screenshot 28](screenshots/a7-s28-persistence-down-up.png)

---

#### Screenshot 29 — Persistence and Backup Document

Add a screenshot showing the contents of:

```text
docs/05-persistence-and-backup.md
```

Include the backup plan and restore procedure.

![Screenshot 29](screenshots/a7-s29-persistence-backup-doc.png)

---

# Task 6 — Configure Logging and Observability

## Goal

Configure useful reverse-proxy and backend logs without exposing sensitive information.

### Evidence

#### Screenshot 30 — Logging Configuration

Add a screenshot showing:

- Configuration for the selected reverse proxy
- Proxy log format
- Docker Compose host log-directory bind mount

![Screenshot 30](screenshots/a7-s30-logging-config.png)

---

#### Screenshot 31 — Persistent Proxy Logs and Backend Logs

Add a terminal screenshot showing:

- Selected reverse-proxy logs available from the host directory after a proxy restart
- Backend logs displayed through Docker Compose

![Screenshot 31](screenshots/a7-s31-proxy-backend-logs.png)

---

### Notes

Write a short note covering:

- The selected reverse proxy
- Host path used for reverse-proxy logs
- How backend logs are viewed
- Whether JSON or standard text logs were used
- Why passwords, tokens, headers, and database connection strings must not appear in logs

Reverse proxy: Nginx (`nginx:alpine`), the only container with a published port (80).

Proxy log path: `./logs/proxy` on the VM (`/home/ubuntu/theepicbook/logs/proxy`), bind-mounted to `/var/log/nginx`, holding `access.json` and `error.log`. After `docker compose restart reverse-proxy` the access log kept all 138 earlier lines and the next request was appended as line 139, so the logs live on the host, not in the container.

Backend logs: the app writes to stdout and I read them with `docker compose logs backend`. Every service uses the `json-file` driver with rotation at 10 MB × 3 files, so logs cannot fill the disk.

Format: the proxy access log is JSON, one object per request (time, client address, method, path, status, bytes, request time, upstream address, status and time, user agent). The Nginx error log is standard text.

No secrets in logs: logs get copied, shipped and read by far more people and tools than the app's credentials are meant for, and they are kept for a long time. A password, token, session cookie, `Authorization` header or database connection string in a log is a leaked credential. So the proxy logs only the path (no query string) and no headers except the user agent, Sequelize SQL logging is off in production, and the database password reaches MySQL tools through `MYSQL_PWD` inside the container. Check: 0 hits for either database password in the proxy logs or the compose logs, and 0 `authorization`, `cookie` or `bearer` strings in the access log.

---

# Task 7 — Deploy and Verify the Stack on a Cloud VM

## Goal

Deploy the completed Docker Compose stack on an AWS or Azure VM and verify public access.

### Evidence

#### Screenshot 32 — VM Public IP and Inbound Rules

Add a cloud-console screenshot showing:

- VM public IP address
- SSH port 22 restricted to your IP address
- HTTP port 80 allowed from Anywhere

![Screenshot 32](screenshots/a7-s32-vm-inbound-rules.png)

---

#### Screenshot 33 — Cloud VM Stack Verification

Add a VM terminal screenshot showing:

- Docker Compose service status
- Successful public health or API response
- No published database, frontend, or backend ports

![Screenshot 33](screenshots/a7-s33-vm-stack-verification.png)

---

#### Screenshot 34 — EpicBook Application on Cloud VM

Add a browser screenshot showing the EpicBook application loaded through the VM public IP address.

Add your full name as a clear caption below the screenshot.

![Screenshot 34](screenshots/a7-s34-browser-cloud-vm.png)

**Victor Durojaiye**

---

### Notes

Write a short note covering:

- Cloud provider used
- VM operating system
- Public port exposed
- Security rules configured
- Confirmation that the application and backend API worked through the reverse proxy

Cloud provider: AWS, region eu-north-1 (Stockholm), one t3.small EC2 instance with an Elastic IP (16.16.86.142), provisioned with Terraform. Docker Engine and Compose were installed by cloud-init from Docker's official apt repository.

VM operating system: Ubuntu 24.04 LTS, 20 GB encrypted gp3 disk, IMDSv2 required.

Public port: only 80/tcp, published by the reverse-proxy container. The frontend, backend and database have no host ports; from outside, 3306, 8080 and 3000 are closed and /proxy-health returns 403.

Security rules: the security group allows SSH (22) only from my home IP as a /32 and HTTP (80) from anywhere. I verified the SSH host key from the EC2 console output before the first login. Secrets live only in a git-ignored .env on the VM (mode 600), generated on the server.

Verification through the reverse proxy on the public IP: / returned 200 (text/html), /api/cart returned 200 (JSON), /assets/css/style.css returned 200 (text/css), and /health returned {"status":"ok","database":"up"}. The browser loaded the home page and the gallery through http://16.16.86.142.

---

# Task 8 — Automate Deployment with CI/CD (Optional)

## Goal

Optionally automate image build, image push, and deployment through GitHub Actions or Azure Pipelines.

### Optional Evidence

#### Optional Screenshot — Successful CI/CD Pipeline Run

Add a screenshot showing a successful pipeline run with build, image push, deployment, and verification stages.

![Optional Screenshot](screenshots/a7-s08-optional-cicd-run.png)

---

### Optional Notes

Write a short note covering:

- CI/CD platform used
- Image-tagging method
- Registry used
- Deployment trigger
- Manual approval or secret-handling approach

CI/CD platform: GitHub Actions (`.github/workflows/deploy.yml` on `capstone/docker`) with three jobs: build and push, deploy, verify.

Image tagging: both images are tagged with the first 12 characters of the commit SHA (this run: `028e5d576488`), never `latest`. The deploy script writes the tag to `IMAGE_TAG` in the VM's `.env`, so a later manual `docker compose up` uses the same images. Rolling back means running `scripts/deploy.sh` with an older tag.

Registry: GitHub Container Registry (`ghcr.io/kingjaiyee/epicbook-backend` and `epicbook-frontend`), pushed with the built-in `GITHUB_TOKEN`. Only the build job has `packages: write`. The packages are public, so the VM pulls them with no registry credentials.

Deployment trigger: a push to `capstone/docker` that changes the backend, frontend, proxy config, Compose file, deploy script or workflow. It can also be run manually (`workflow_dispatch`).

Approval and secrets: the deploy job runs in a `production` environment that needs my approval and only allows `capstone/docker`. AWS access uses OIDC: the job gets a short-lived token, and the IAM role trusts only this repository's `production` environment. The role can only run AWS's shell-script command on this one instance through SSM. No AWS keys or SSH keys are stored in GitHub, and SSH on the VM stays limited to my IP. The only stored secret is the role ARN, as an environment secret.

Finding: the first deploy failed with "Not authorized to perform sts:AssumeRoleWithWebIdentity". Decoding the token's claims showed that GitHub now puts immutable owner and repo IDs in the subject (`repo:Kingjaiyee@15925018/theepicbook@1311342257:environment:production`). I updated the trust policy to that exact value instead of loosening it with wildcards.

Result: build, deploy and verify all passed. The VM runs the commit's images, `/health` is up, and the drill record survived the redeploy.

---

# Task 9 — Perform Reliability Tests and Create an Operations Runbook

## Goal

Test controlled service failures and document safe operating procedures.

### Evidence

#### Screenshot 35 — Backend Failure and Recovery

Add a terminal screenshot showing:

- Backend failure test
- Expected unavailable response through the reverse proxy
- Backend restart
- Successful health-check recovery

![Screenshot 35](screenshots/a7-s35-backend-failure-recovery.png)

---

#### Screenshot 36 — Database Failure and Recovery

Add a terminal screenshot showing:

- Database outage test
- Failed database-dependent request
- Database restart
- Successful application recovery

![Screenshot 36](screenshots/a7-s36-database-failure-recovery.png)

---

### Notes

Write a short operations runbook covering:

- Safe restart procedure for reverse proxy, frontend, backend, and database
- Backup and restore procedure
- Secret-rotation approach
- Database recovery procedure
- What to check when the application returns an error
- Results of backend and database reliability tests

**Safe restarts.** One service at a time: `docker compose restart <service>`, then `docker compose up -d --wait <service>` to confirm it is healthy before touching the next. For a full restart, `docker compose up -d --wait` brings services up in order (database → backend; frontend in parallel; reverse-proxy last) because of the `service_healthy` conditions. A proxy restart is a few seconds of downtime; a database restart makes `/health` return 503 until it is healthy again. Never `docker compose down -v` on this stack.

**Backup and restore.** `./scripts/backup.sh` writes a checked, gzipped `mysqldump` to `./backups` (planned daily, 7 kept, copied off the VM). To restore: pick the newest dump and `gzip -t` it, `docker compose stop backend`, pipe the dump into `mysql` in the database container, start the backend, wait for healthy, and verify row counts and `/health` (full steps in `docs/05-persistence-and-backup.md`).

**Secret rotation.** The `MYSQL_*` values only take effect when the database is first created, so changing `.env` alone does not change a password. To rotate the app password: generate a new value with `openssl rand -hex 24`, run `ALTER USER` in MySQL as root, update `.env` (mode 600), then `docker compose up -d backend` so the backend gets the new connection URL, and check `/health`. The GitHub deploy uses OIDC with no stored AWS keys, so there is no long-lived deploy secret to rotate.

**Database recovery.** If `database` is unhealthy: `docker compose logs database`, check disk space (`df -h`) and that the `epicbook_db_data` volume exists, then `docker compose restart database` and wait for healthy. If the data itself is damaged, restore from the newest backup as above.

**When the app returns an error.** `502` from the proxy means the backend is down or unreachable (`docker compose ps`, `docker compose logs backend`). `503` from `/health` means the backend is up but the database is not. Broken styling or images point to `frontend`. `logs/proxy/access.json` shows the upstream address, status and time for each request, and `logs/proxy/error.log` shows why the proxy failed.

**Test results.** Backend stopped: `/` and `/health` returned 502 through the proxy. After `docker compose start backend` it was healthy in about 5 seconds and `/health` returned 200. Database stopped: `/health` returned 503 (`database: down`) within about 3 seconds while the backend stayed up, with 0 crash lines in its logs. After the restart the database was healthy in about 5 seconds and the app reconnected without a backend restart (`/health`, `/` and `/api/cart` all 200).

**Known app issue.** `DELETE /api/cart/delete` empties the whole cart table, needs no login and never sends a response. It is left as found and flagged here rather than changed.

---

# Final Public Application URL

**EpicBook URL:** `http://16.16.86.142`

Replace the placeholder with your working public URL.

---

# GitHub Repository URL

**Your Fork or Repository URL:** `https://github.com/Kingjaiyee/theepicbook/tree/capstone/docker`

---

# LinkedIn Requirement

## Goal

Create a professional LinkedIn post of 6–10 lines about your EpicBook capstone deployment.

Your post must include:

- The architectural decision that most improved reliability
- Your biggest image-size reduction, with numbers
- Key production-hardening lessons
- A deployment verification image

### Evidence

**LinkedIn Post URL:** `https://www.linkedin.com/posts/victor-jaiye_devopsmicrointernship-docker-dockercompose-share-7516996166220181504-AMrC/`

#### LinkedIn Post Screenshot

![LinkedIn Post](screenshots/a7-linkedin-post.png)

---

# Submission Checklist

- [x] EpicBook repository reviewed and architecture diagram created
- [x] Environment variables, ports, persistence, and health-check details documented
- [x] Backend and frontend production Dockerfiles created
- [x] Backend runs as a non-root user
- [x] Docker image-size comparison completed
- [x] Docker Compose stack includes reverse proxy, frontend, backend, and database
- [x] `front-tier` and `back-tier` networks configured
- [x] `db_data` named volume configured
- [x] MySQL, backend, frontend, and reverse-proxy health checks configured
- [x] Startup dependencies use `service_healthy`
- [x] Nginx or Traefik selected as the only public reverse proxy
- [x] Only reverse-proxy port 80 is publicly published
- [x] Same-origin routing configured and CORS used only when required
- [x] Backup, restore, and persistence testing completed
- [x] Reverse-proxy and backend logs verified
- [x] Cloud VM deployment verified through the public IP
- [x] Backend and database reliability tests completed
- [x] Screenshots 1–36 included
- [x] Required notes completed
- [x] LinkedIn post URL and screenshot included
- [x] Full name visible in required screenshots or captions
- [x] No passwords, tokens, private keys, account IDs, or other sensitive information exposed

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

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*
