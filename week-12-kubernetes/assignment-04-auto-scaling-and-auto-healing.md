# Assignment 4 — Auto-Scaling & Auto-Healing: Let Kubernetes React for You

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this guided lab, you will prove Deployment auto-healing by deleting a Pod, then configure a CPU-based Horizontal Pod Autoscaler that maintains between two and five NGINX Pods.

---

# Task 1 — Set Up the Lab Directory

## Goal

Create the `~/k8s-labs/autoscaling` working directory.

### Evidence

#### Screenshot 1 — Terminal showing the `autoscaling` directory

![Autoscaling folder](./screenshots/a4-s01-autoscaling-folder.png)

**Notes:** I created `~/k8s-labs/autoscaling` in my lab git repo. Before starting, I checked that the context was `docker-desktop`, that `default` had no Deployments, HPAs or Pods, and that Metrics Server was not installed yet. The `v1beta1.metrics.k8s.io` APIService was `NotFound` and `kubectl top nodes` returned `Metrics API not available`.

---

# Task 2 — Prove Deployment Auto-Healing

## Goal

Create `demo-autohealing` (two replicas), delete one Pod, and confirm the desired count of two is restored automatically.

### Evidence

#### Screenshot 2 — Deleted Pod and replacement Pod with the replica count restored

![Auto-healing](./screenshots/a4-s02-auto-healing.png)

Manifest ([manifests/a4-autohealing-deployment.yaml](./manifests/a4-autohealing-deployment.yaml)):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-autohealing
  labels:
    app: autoheal
spec:
  replicas: 2
  selector:
    matchLabels:
      app: autoheal
  template:
    metadata:
      labels:
        app: autoheal
    spec:
      containers:
      - name: nginx
        image: nginx
```

**Notes:** I applied the Deployment and waited for `rollout status`, then deleted `demo-autohealing-69b848f547-dhg79`. Its events end with `Killing`. Within 4 seconds the ReplicaSet created `demo-autohealing-69b848f547-6ztcm`. That is the third `SuccessfulCreate` in its events, and the Deployment went back to `2/2`. Auto-healing only puts back the count I asked for. It never changes that count. Changing it in response to load is the HPA's job. `image: nginx` has no tag, so this pulls `latest`. I kept it as the lab gives it.

---

# Task 3 — Create the HPA-Ready Deployment and Enable Metrics

## Goal

Deploy `nginx-deployment` with CPU `requests: 100m` / `limits: 200m`, then enable Metrics Server (Minikube addon or manifest + kubelet TLS patch for kind) and confirm it reports `READY 1/1`.

### Evidence

#### Screenshot 3 — Deployment resources plus successful Metrics Server status

![Resources and Metrics Server](./screenshots/a4-s03-resources-metrics-server.png)

Manifest ([manifests/a4-hpa-deployment.yaml](./manifests/a4-hpa-deployment.yaml)):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
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
        resources:
          requests:
            cpu: "100m"
          limits:
            cpu: "200m"
```

**Notes:**
- **Requests and limits:** `nginx-deployment` has `requests.cpu: 100m` and `limits.cpu: 200m`. The HPA measures utilization against the request, so 50m of use is 50%. Without a CPU request, the HPA cannot calculate a percentage.
- **Metrics Server source:** my cluster is Docker Desktop's kind-type cluster, so I used the manifest and the patch instead of the Minikube addon. I did not apply `releases/latest` straight from the internet. I downloaded `components.yaml` first and checked it: Metrics Server `v0.9.0`, sha256 `1cec29a5...`. I committed that file to my lab repo and applied that exact file.
- **TLS patch:** I then patched in `--kubelet-insecure-tls`. That turns off certificate checks between Metrics Server and the kubelet. It is acceptable on a local cluster but not in production, where the kubelet should have certificates Metrics Server can verify.
- **Result:** `metrics-server` showed `READY 1/1`, the `v1beta1.metrics.k8s.io` APIService was `AVAILABLE True`, and `kubectl top pods` returned CPU and memory for all four Pods.
- **Kept for later:** I left Metrics Server installed for the rest of Week 12.

---

# Task 4 — Create and Inspect the HPA

## Goal

Create an HPA (imperatively via `kubectl autoscale` or declaratively via `autoscaling/v2`) targeting `nginx-deployment` with min 2, max 5, and 50% target CPU utilization.

### Evidence

#### Screenshot 4 — `kubectl get hpa` and `kubectl describe hpa nginx-hpa` output

![HPA get and describe](./screenshots/a4-s04-hpa-get-describe.png)

Manifest ([manifests/a4-hpa-nginx.yaml](./manifests/a4-hpa-nginx.yaml)):

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: nginx-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nginx-deployment
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

**Notes:** I used only the declarative `autoscaling/v2` method. Two HPAs on one Deployment would fight each other, and `kubectl autoscale --cpu-percent` is deprecated. After about 45 seconds, `kubectl get hpa` showed `cpu: 0%/50%` with min 2, max 5 and 2 replicas. Describe showed `AbleToScale True`, `ScalingActive True (ValidMetricFound)` and `ScalingLimited False (DesiredWithinRange)`. The Pods were idle, so the HPA stayed at the minimum of 2.

---

# Task 5 — Optionally Generate CPU Load

## Goal

Generate CPU load inside an NGINX Pod (`yes > /dev/null`) and monitor whether the HPA increases replicas.

### Evidence

#### Screenshot 5 — HPA output showing current metrics and any replica increase

![HPA scale-up](./screenshots/a4-s05-hpa-scale-up.png)

**Notes:**
- **Load:** I ran `kubectl exec deploy/nginx-deployment -- timeout 240 sh -c 'yes > /dev/null'` in the background, so the load stopped on its own after 4 minutes. Then I watched with `kubectl get hpa nginx-hpa -w`.
- **Scale-up:** TARGETS went from `0%` to `31%` to `100%/50%`, and REPLICAS went from 2 to 4. `kubectl top` showed the loaded Pod at 183m to 200m, its limit, while the others sat near 0m. The HPA event was `SuccessfulRescale New size: 4; reason: cpu resource utilization (percentage of request) above target`. I never ran `kubectl scale`.
- **Why 4 and not 5:** one Pod at its 200m limit, averaged over 2 Pods with 100m requests, is 100%. The HPA's formula, ceil(2 × 100 / 50), gives 4. At 4 Pods the average settled at `50%/50%`, exactly on target, so it had no reason to go to 5.
- **Scale-down:** I ran cleanup before the 5-minute stabilization window ended, so I did not observe the scale-down back to 2.

---

### Notes

Write a short note describing what the lab demonstrated.

The lab showed two different behaviours. Auto-healing keeps the count I set: when I deleted a `demo-autohealing` Pod, the ReplicaSet replaced it within seconds and stayed at 2. Autoscaling changes the count itself: the HPA read CPU from Metrics Server, compared it with 50% of each Pod's 100m request, and raised `nginx-deployment` from 2 to 4 when one Pod was pushed to its 200m limit. Three parts have to be in place for that. The Pods need a CPU request to measure against, Metrics Server has to be running to report usage, and the HPA needs a target and min/max bounds. The numbers matched the HPA formula: 100% against a 50% target doubled the count, and at 4 Pods the average landed on 50%. Two things I would do differently in production. I would keep pinning what I install, as I did with Metrics Server v0.9.0, instead of using a `latest` URL. And I would not use `--kubelet-insecure-tls`.

Cleanup: I deleted the HPA and both Deployments with `kubectl delete -f` and confirmed `No resources found in default namespace.` Metrics Server stays in `kube-system` until the end of Week 12.

---

# Submission Instructions

- Add all required screenshots in your submission
- Include the completed YAML manifests used in the lab

---

# Completion Checklist

- [x] Task 1: Lab directory created (Screenshot 1)
- [x] Task 2: Auto-healing observed (Screenshot 2)
- [x] Task 3: HPA-ready Deployment applied and Metrics Server verified (Screenshot 3)
- [x] Task 4: HPA created and inspected (Screenshot 4)
- [x] Task 5: CPU load generated and scaling observed (Screenshot 5, optional)
- [x] Reflection notes written (Notes)

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
