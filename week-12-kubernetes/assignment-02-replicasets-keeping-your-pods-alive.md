# Assignment 2 — ReplicaSets: Keeping Your Pods Alive

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this guided lab, you will create an NGINX ReplicaSet, verify it maintains three Pods, test its auto-healing behavior by deleting a Pod, and scale it from three to five replicas.

---

# Task 1 — Set Up Your Working Directory

## Goal

Create the `~/k8s-labs/replicasets` working directory.

### Evidence

#### Screenshot 1 — Terminal showing the `~/k8s-labs/replicasets` working directory

![ReplicaSets folder](./screenshots/a2-s01-replicasets-folder.png)

**Notes:** I created `~/k8s-labs/replicasets` next to `pods/` in my lab git repo. Before starting, I checked that the context was `docker-desktop` and that no `app=nginx` Pods or ReplicaSets were left from Assignment 1. A leftover Pod with that label would be adopted by the new ReplicaSet and counted as one of its replicas. The solution doc's screenshots use `~/k8s-labs/pods/replicasets`, so I followed the template path instead.

---

# Task 2 — Create and Apply the ReplicaSet

## Goal

Write `nginx-replicaset.yaml` (apiVersion `apps/v1`, kind `ReplicaSet`, 3 replicas, `selector.matchLabels` matching `template.metadata.labels` as `app: nginx`, image `nginx:1.21.1`), apply it, and confirm three Pods are created.

### Evidence

#### Screenshot 2 — `nginx-replicaset.yaml` and terminal output showing three running Pods

![ReplicaSet with three Pods](./screenshots/a2-s02-replicaset-three-pods.png)

**Notes:** I checked the manifest with `kubectl apply --dry-run=server`, committed it (`03b3458`), applied it, and waited with `kubectl wait --for=condition=Ready pod -l app=nginx`. The ReplicaSet showed `DESIRED 3 CURRENT 3 READY 3`, with Pods `9r7bc`, `q4646` and `vkds6` all `1/1 Running`. Each Pod has an ownerReference to `nginx-replicaset`, which is how Kubernetes links a Pod to its controller. The selector `app: nginx` must match the template label, or the API rejects the ReplicaSet. `nginx:1.21.1` is pinned, which is better than `latest`, but it is a 2021 image with known CVEs. I kept it because the template specifies it.

---

# Task 3 — Test ReplicaSet Auto-Healing

## Goal

Delete one Pod managed by `nginx-replicaset` and confirm Kubernetes creates a replacement, restoring the desired count of three.

### Evidence

#### Screenshot 3 — Terminal showing the deleted Pod and the newly created replacement, with the desired count remaining three

![Auto-healing](./screenshots/a2-s03-auto-healing.png)

**Notes:** I deleted `nginx-replicaset-9r7bc`. Its events end with `Killing`. Running `kubectl get pods` straight after the delete already showed the replacement `nginx-replicaset-2st4h` at `1/1 Running`, 1 second old. It started that fast because the image was already on the node. The ReplicaSet events show a fourth `SuccessfulCreate` for `2st4h`, and the count stayed `3 3 3`. I did not create anything by hand. The controller saw 2 Pods where it wanted 3 and made one more from the template.

---

# Task 4 — Scale and Inspect the ReplicaSet

## Goal

Change `replicas` from 3 to 5, reapply the manifest, and confirm five Pods are managed, then inspect the ReplicaSet with `describe` and `get pods -o wide`.

### Evidence

#### Screenshot 4 — Terminal showing five Pods and the `nginx-replicaset` details

![Scaled to five with describe](./screenshots/a2-s04-scaled-five-describe.png)

Completed manifest (also committed as [manifests/a2-nginx-replicaset.yaml](./manifests/a2-nginx-replicaset.yaml)):

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
  labels:
    app: nginx
spec:
  replicas: 5
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.21.1
        ports:
        - containerPort: 80
```

**Notes:**
- **Scale-up:** I changed `replicas: 3` to `replicas: 5` in the file. The git diff was one line, committed as `2d8ad9e`. Reapplying printed `configured`, not `created`, because the ReplicaSet already existed.
- **describe:** it shows `Selector: app=nginx`, `Replicas: 5 current / 5 desired`, `Pods Status: 5 Running`, and the template image `nginx:1.21.1`.
- **`get pods -o wide`:** it shows five Pods on `desktop-control-plane`, each with its own IP. The two new ones are `r2492` and `w72h2`, 15 seconds old next to Pods 30 and 38 minutes old.
- **Events:** there are six `SuccessfulCreate` lines in total: 3 at the start, 1 replacement and 2 from the scale-up.
- **Why Deployments are preferred:** a ReplicaSet only keeps the Pod count right. If I changed the image in its template, the Pods already running would keep the old image. Only Pods created after the change would get the new one. There is no rolling update and no revision history to roll back to. A Deployment manages ReplicaSets for you. On a template change it creates a new ReplicaSet, moves Pods across a few at a time, and keeps the old ReplicaSet so it can roll back.
- **Cleanup:** I deleted the ReplicaSet, which also removed its five Pods, and confirmed `No resources found in default namespace.`

---

# Submission Instructions

- Add all required screenshots in your submission
- Include the completed `nginx-replicaset.yaml` manifest

---

# Completion Checklist

- [x] Task 1: Lab directory created (Screenshot 1)
- [x] Task 2: ReplicaSet created with three Pods (Screenshot 2)
- [x] Task 3: Auto-healing observed after deleting a Pod (Screenshot 3)
- [x] Task 4: Scaled to five Pods and inspected (Screenshot 4)
- [x] Understood why Deployments are preferred for rolling updates and rollbacks

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
