# Assignment 5 — Sharing the Docker Container on Docker Hub

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will publish a Dockerized React application to Docker Hub, remove the local image tags, pull the image again from Docker Hub, and run it to verify that it can be downloaded and deployed from a container registry.

---

# Task 1 — Publish a Docker Image to Docker Hub

## Goal

Tag a locally built React image, publish it to Docker Hub, remove the local copy, pull it again from Docker Hub, and run it successfully.

### Evidence

#### Screenshot 1 — Public Docker Hub Repository

Add a screenshot of Docker Hub showing your newly created public repository:

```text
my-react-app
```

![Screenshot 1](screenshots/a5-s01-hub-repo-public.png)

---

#### Screenshot 2 — Successful Docker Login

Add a screenshot of the terminal showing:

```text
Login Succeeded
```

Ensure that your full name is visible and that no password, Personal Access Token, or device code is exposed.

![Screenshot 2](screenshots/a5-s02-login-succeeded.png)

---

#### Screenshot 3 — Correctly Tagged Image

Add a screenshot of the terminal showing:

```bash
docker image ls <YOUR_DOCKERHUB_USERNAME>/my-react-app
```

The output must show the `latest` tag.

![Screenshot 3](screenshots/a5-s03-tagged-image.png)

---

#### Screenshot 4 — Successful Docker Push

Add a screenshot of the terminal showing successful completion of:

```bash
docker push <YOUR_DOCKERHUB_USERNAME>/my-react-app:latest
```

The output must include a pushed status or image digest.

![Screenshot 4](screenshots/a5-s04-push.png)

---

#### Screenshot 5 — Published `latest` Tag in Docker Hub

Add a screenshot of your Docker Hub repository showing the uploaded `latest` image tag.

![Screenshot 5](screenshots/a5-s05-hub-latest-tag.png)

---

#### Screenshot 6 — Local Image Removed and Pulled Again

Add a screenshot of the terminal showing:

- The targeted local image tags removed
- Successful `docker pull` output
- `docker image ls` showing the pulled image

![Screenshot 6](screenshots/a5-s06-removed-and-pulled.png)

---

#### Screenshot 7 — Running Pulled Image

Add a screenshot of the terminal showing:

```bash
docker ps
```

The output must show the running `react-container` with:

```text
0.0.0.0:80->80/tcp
```

![Screenshot 7](screenshots/a5-s07-react-container-ps.png)

---

#### Screenshot 8 — React Application in Browser

Add a browser screenshot showing the React application at:

```text
http://<YOUR-VM-PUBLIC-IP>
```

Ensure that the VM public IP is visible in the address bar. Add your full name as a clear caption directly below the screenshot.

![Screenshot 8](screenshots/a5-s08-browser-react-app.png)

**Victor Durojaiye**

---

# Docker Hub Repository URL

**Repository URL:** `https://hub.docker.com/r/kingjaiye/my-react-app`

---

# Registry and Image Tagging Notes

Write a short explanation covering:

- Why image tagging is required before pushing to Docker Hub
- Why a container registry is useful in DevOps workflows
- Why production deployments should use versioned image tags instead of relying only on `latest`

**Why tag before pushing.** Docker reads the registry, account and repository from the image name. `react-multistage:latest` has no account in its name, so Docker Hub wouldn't know where to put it. Tagging it as `kingjaiye/my-react-app:latest` points it at my repository. A tag is only a name: `react-multistage:latest`, `kingjaiye/my-react-app:latest` and `kingjaiye/my-react-app:1.0.0` all had the same image ID, `b93e4125279b`.

**Why a registry is useful.** The image is built once and any machine can pull it. The EC2 VM never built this app and never logged in to Docker Hub. It pulled the public image and ran it. The digest was the same on my laptop and on the VM (`sha256:b93e4125…`), so it's provably the same image. Before the pull test, I removed every local tag pointing at the image, so the pull really came from Docker Hub.

**Why production should use versioned tags.** `latest` is a label that moves to whatever was pushed last, so it doesn't tell you which version is running, and a rollback has nothing fixed to return to. I also pushed `1.0.0`, which points at the same digest today but won't move when a new `latest` is pushed. For the strongest guarantee, deploy by digest (`@sha256:...`), which can never change.

**Security.** I logged in with a short-lived, Read & Write access token instead of my password, typed into a hidden prompt and passed with `--password-stdin`, so it never appeared on screen or in shell history. Docker Desktop stores it in Windows Credential Manager, not in plain text. The VM needed no credentials at all. One caveat: the image includes JavaScript source maps, which is fine for this public sample app but would be turned off (`GENERATE_SOURCEMAP=false`) for a private one.

---

# LinkedIn Requirement

## Goal

Create a LinkedIn post about publishing a Docker container image to Docker Hub.

Include:

- Assignment title: **Publish a Docker Container Image to Docker Hub**
- Your Docker Hub repository URL
- What you published
- How you verified the remote image by pulling and running it
- Key learning outcomes

### Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/victor-jaiye_devopsmicrointernship-docker-dockerhub-share-7516234418802442240-xWG4/`

---

#### LinkedIn Post Screenshot

![LinkedIn Post](screenshots/a5-linkedin-post.png)

---

# Submission Instructions

- Complete all steps in sequence.
- Include Screenshots 1–8 exactly as specified.
- Include your Docker Hub repository URL.
- Include the Registry and Image Tagging Notes.
- Include the LinkedIn post URL and screenshot.
- Ensure that your full name is visible in all terminal screenshots.
- Add your full name as a clear caption below the browser screenshot.
- Do not expose passwords, Personal Access Tokens, device codes, credentials, or other sensitive information.

---

# Completion Checklist

- [x] Public `my-react-app` repository created
- [x] Docker login completed successfully
- [x] `react-multistage:latest` tagged correctly
- [x] Image pushed to Docker Hub
- [x] `latest` tag verified in Docker Hub
- [x] Targeted local image tags removed
- [x] Image pulled again from Docker Hub
- [x] Pulled image runs successfully
- [x] React application is accessible through the VM public IP
- [x] Docker Hub repository URL included
- [x] Registry and image-tagging notes completed
- [x] LinkedIn post URL and screenshot included
- [x] All required screenshots included
- [x] Full name visible in terminal screenshots
- [x] Browser screenshot has a full-name caption
- [x] No passwords, tokens, or credentials exposed
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
