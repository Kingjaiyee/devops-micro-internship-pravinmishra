# Assignment 4 — Docker Volumes and Bind Mounts

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will use Docker Bind Mounts and Docker Volumes to persist logs and application data outside a container’s lifecycle. You will verify that data remains available after containers are removed and recreated.

---

# Task 1 — Persist Nginx Logs Using a Bind Mount

## Goal

Deploy an Nginx container with a Bind Mount and verify that its log files remain on the VM host after the container is removed.

### Evidence

#### Screenshot 1 — Nginx Image Pull

Add a screenshot of the terminal showing successful completion of:

```bash
docker pull nginx:alpine
```

![Screenshot 1](screenshots/a4-s01-pull-nginx.png)

---

#### Screenshot 2 — Host Log Directory

Add a screenshot of the terminal showing the created host directory:

```text
$HOME/nginx-logs
```

![Screenshot 2](screenshots/a4-s02-host-log-dir.png)

---

#### Screenshot 3 — Running Nginx Container with Port Mapping

Add a screenshot of the terminal showing:

```bash
docker ps
```

The output must show the `myweb` container with:

```text
0.0.0.0:80->80/tcp
```

![Screenshot 3](screenshots/a4-s03-myweb-ps.png)

---

#### Screenshot 4 — Nginx Welcome Page

Add a browser screenshot showing the Nginx Welcome Page at:

```text
http://<YOUR-VM-PUBLIC-IP>
```

Ensure that the VM public IP is visible in the address bar. Add your full name as a clear caption directly below the screenshot.

![Screenshot 4](screenshots/a4-s04-browser-myweb.png)

**Victor Durojaiye**

---

#### Screenshot 5 — Bind-Mounted Log Files

Add a screenshot of the terminal showing the host log files and access-log content from:

```text
$HOME/nginx-logs
```

The output must show `access.log`, `error.log`, and an access-log entry created when you opened the Nginx page.

![Screenshot 5](screenshots/a4-s05-bind-mounted-logs.png)

---

#### Screenshot 6 — Nginx Container Removed

Add a screenshot of the terminal showing successful completion of:

```bash
docker stop myweb
docker rm myweb
```

![Screenshot 6](screenshots/a4-s06-myweb-removed.png)

---

#### Screenshot 7 — Logs Persist After Container Removal

Add a screenshot of the terminal showing that `access.log` and `error.log` still exist in:

```text
$HOME/nginx-logs
```

The access log must retain its content after the container has been removed.

![Screenshot 7](screenshots/a4-s07-logs-persist.png)

---

# Task 2 — Share Persistent Data Using a Docker Volume

## Goal

Deploy backend and frontend containers that share data through a named Docker Volume. Verify that the data remains after both containers are removed and recreated.

### Evidence

#### Screenshot 8 — Project File Structure

Add a screenshot of the terminal showing the `two-tier-app` project structure, including separate `backend` and `frontend` directories with a `Dockerfile` and `index.js` file in each.

![Screenshot 8](screenshots/a4-s08-project-structure.png)

---

#### Screenshot 9 — Custom Docker Network

Add a screenshot of the terminal showing `mynetwork` in:

```bash
docker network ls
```

![Screenshot 9](screenshots/a4-s09-mynetwork.png)

---

#### Screenshot 10 — Docker Volume

Add a screenshot of the terminal showing `shared-data` in:

```bash
docker volume ls
```

![Screenshot 10](screenshots/a4-s10-shared-data-volume.png)

---

#### Screenshot 11 — Backend Dockerfile

Add a screenshot of the terminal showing the completed backend `Dockerfile`.

![Screenshot 11](screenshots/a4-s11-backend-dockerfile.png)

---

#### Screenshot 12 — Backend Image Build

Add a screenshot of the terminal showing successful completion of the `backend-app:latest` image build.

![Screenshot 12](screenshots/a4-s12-backend-build.png)

---

#### Screenshot 13 — Running Backend Container

Add a screenshot of the terminal showing:

```bash
docker ps
```

The output must show the running `backend` container.

![Screenshot 13](screenshots/a4-s13-backend-ps.png)

---

#### Screenshot 14 — Frontend Dockerfile

Add a screenshot of the terminal showing the completed frontend `Dockerfile`.

![Screenshot 14](screenshots/a4-s14-frontend-dockerfile.png)

---

#### Screenshot 15 — Frontend Image Build

Add a screenshot of the terminal showing successful completion of the `frontend-app:latest` image build.

![Screenshot 15](screenshots/a4-s15-frontend-build.png)

---

#### Screenshot 16 — Running Backend and Frontend Containers

Add a screenshot of the terminal showing:

```bash
docker ps
```

The output must show both `backend` and `frontend` containers running. Only `frontend` must have the published port mapping:

```text
0.0.0.0:80->80/tcp
```

![Screenshot 16](screenshots/a4-s16-backend-frontend-ps.png)

---

#### Screenshot 17 — Backend Write Operation

Add a screenshot of the terminal showing a successful backend write operation to the shared Docker Volume.

The output must include:

```text
Data written: Hello from Backend!
```

![Screenshot 17](screenshots/a4-s17-backend-write.png)

---

#### Screenshot 18 — Frontend Reads Shared Data

Add a browser screenshot showing:

```text
Hello from Backend!
```

Add your full name as a clear caption directly below the screenshot.

![Screenshot 18](screenshots/a4-s18-browser-hello.png)

**Victor Durojaiye**

---

#### Screenshot 19 — First Shared-Data Update

Add a browser screenshot showing:

```text
Test Data 1
```

Add your full name as a clear caption directly below the screenshot.

![Screenshot 19](screenshots/a4-s19-browser-test-data-1.png)

**Victor Durojaiye**

---

#### Screenshot 20 — Second Shared-Data Update

Add a browser screenshot showing:

```text
Test Data 2 - New Update
```

Add your full name as a clear caption directly below the screenshot.

![Screenshot 20](screenshots/a4-s20-browser-test-data-2.png)

**Victor Durojaiye**

---

#### Screenshot 21 — Container Removal and Recreation

Add a screenshot of the terminal showing the `frontend` and `backend` containers removed and recreated using the same `shared-data` Docker Volume.

![Screenshot 21](screenshots/a4-s21-remove-recreate.png)

---

#### Screenshot 22 — Data Persists After Recreation

Add a browser screenshot showing:

```text
Test Data 2 - New Update
```

This proves that the `shared-data` Docker Volume outlived both application containers.

Add your full name as a clear caption directly below the screenshot.

![Screenshot 22](screenshots/a4-s22-browser-after-recreate.png)

**Victor Durojaiye**

---

# Storage Persistence Notes

Write a short explanation covering:

- The difference between a Bind Mount and a Docker Volume
- How Task 1 proved Bind Mount persistence
- How Task 2 proved Docker Volume persistence
- Why Docker Volumes are commonly used for application data

**Bind mount vs Docker volume.** A bind mount maps a host folder I choose into the container. In Task 1 that was `$HOME/nginx-logs` mapped to `/var/log/nginx`. A Docker volume is storage that Docker creates and manages by name. `shared-data` lives under `/var/lib/docker/volumes/shared-data/_data`, and I never had to pick or create that folder. Docker also fills an empty volume from the image on first mount, which is how `/data` came out owned by the non-root `node` user.

**How Task 1 proved bind mount persistence.** Nginx wrote `access.log` and `error.log` straight into `$HOME/nginx-logs` on the VM, owned by `root:root` with mode 644, because the Nginx master runs as root. After `docker stop` and `docker rm`, `docker ps -a` showed no `myweb`, but both files and my `GET /` line were still on the host. One side effect: the mount hides the image's links from the log files to stdout. A test container logged 0 requests in `docker logs` and 1 in `access.log`.

**How Task 2 proved volume persistence.** The backend wrote "Hello from Backend!" to `/data/message.txt`, and the frontend served the same file, because both mount `shared-data`. Updates to "Test Data 1" and "Test Data 2 - New Update" showed on a browser refresh. I then removed both containers, confirmed `shared-data` was still listed, and created new ones. The page still showed "Test Data 2 - New Update", so the data outlived both containers. The frontend mounts the volume read-only: a write attempt failed with "Read-only file system". Both containers run as the non-root `node` user.

**Why volumes are used for application data.** A volume's lifecycle is separate from any container. It's managed with Docker commands (`create`, `ls`, `inspect`, `rm`), it doesn't depend on the host's folder layout or file permissions, and several containers can share it. Bind mounts suit cases where the host needs direct access to the files, like reading logs. Volumes suit data the application owns.

---

# Public Application URL

**Application URL:** `http://51.20.196.139`

---

# LinkedIn Requirement

## Goal

Create a LinkedIn post about Docker Volumes and Bind Mounts, including one difference between them, how you verified persistent storage, and your key learning outcomes.

### Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/victor-jaiye_devopsmicrointernship-docker-dockervolumes-share-7515523159320834049-lGWp`

---

#### LinkedIn Post Screenshot

![LinkedIn Post](screenshots/a4-linkedin-post.png)

---

# Submission Instructions

- Complete all tasks in sequence.
- Include Screenshots 1–22 exactly as specified.
- Include the Storage Persistence Notes section.
- Include the public application URL.
- Include the LinkedIn post URL and screenshot.
- Ensure that your full name is visible in all terminal screenshots.
- Add your full name as a clear caption below every browser screenshot.
- Do not expose private keys, passwords, access keys, tokens, account IDs, or other sensitive information.

---

# Completion Checklist

- [x] Nginx image pulled successfully
- [x] Host log directory created
- [x] Bind Mount configured successfully
- [x] Nginx logs remain after container removal
- [x] Custom Docker network created
- [x] Docker Volume created
- [x] Backend Dockerfile and image created
- [x] Frontend Dockerfile and image created
- [x] Both containers mount `shared-data`
- [x] Backend writes data to the Docker Volume
- [x] Frontend reads the same data from the Docker Volume
- [x] Updated data appears after browser refresh
- [x] Data remains after frontend and backend containers are removed and recreated
- [x] All required screenshots included
- [x] Storage Persistence Notes completed
- [x] Public application URL included
- [x] LinkedIn post URL and screenshot included
- [x] Full name visible in terminal screenshots
- [x] Browser screenshots have full-name captions
- [x] No sensitive information exposed

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
