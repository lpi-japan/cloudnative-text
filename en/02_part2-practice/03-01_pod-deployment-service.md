## 3-1 Hands-On: Pod / Deployment / Service – Break, Restore, Delegate

Assumed environment: KillerCoda (Kubernetes cluster running)  
All subsequent operations use kubectl.

### 0. Pre-Check (Viewing the Current State)

##### First, confirm the state in which nothing has happened.

```bash
kubectl get pod
```

##### Observation

- In a state where nothing has been created, nothing exists
- **Kubernetes** "does not start anything on its own"

**If nothing is defined, nothing happens**

### 1. Create a Pod (A Single Execution Unit)

##### Create a Pod definition file.

```bash
cat <<EOF > pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: sample-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
EOF
```

##### Create the Pod.

```bash
kubectl apply -f pod.yaml
```

##### Confirm the state.

```bash
kubectl get pod
```

##### Confirm the Pod details.

```bash
kubectl describe pod sample-pod
```

##### Observation

- A Pod is "a single execution unit"
- Kubernetes manages it but does not protect it

**The Pod runs but is not maintained**

##### ※ Note

Kubernetes does not manage "what is running" —  
it is a mechanism that operates based on "what the state should be."

This Pod has no definition stating "it should continue to exist."

Therefore, even if it is deleted, from Kubernetes's perspective  
no "gap from the Desired State" has occurred.

**What has no defined state to protect is not maintained**

### 2. Delete the Pod (Break It)

##### Delete the Pod.

```bash
kubectl delete pod sample-pod
```

##### Confirm the state again.

```bash
kubectl get pod
```

##### Observation

- The Pod is gone and does not return
- Kubernetes "does not protect a standalone Pod"

**When it breaks, it ends**

##### Question

- What would happen if this were production?
- Would a person recreate it every time?

### 3. Manage the Pod Using a Deployment

##### Create a Deployment definition file.

```bash
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sample
  template:
    metadata:
      labels:
        app: sample
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
EOF
```

##### Create the Deployment.

```bash
kubectl apply -f deployment.yaml
```

##### Confirm the Pod.

```bash
kubectl get pod
```

##### Delete the Pod. (Break it again)

```bash
kubectl delete pod -l app=sample
```

##### Confirm again immediately.

```bash
kubectl get pod
```

##### Observation

- The Pod is automatically recreated
- No instruction was given

**State is maintained**  
**What is protecting it is not a person but the mechanism**

### 4. Change the Replica Count (Changing State)

##### Change the replica count of the Deployment.

```bash
kubectl scale deployment sample-deployment --replicas=3
```

##### Confirm the Pods.

```bash
kubectl get pod
```

##### Observation

- Three Pods exist
- Only the "count" is specified, not individual instances

**The person specifies only the state**

### 5. Access a Pod Through a Service

##### Create a Service.

```bash
kubectl expose deployment sample-deployment \
  --type=ClusterIP \
  --name=sample-service \
  --port=80
```

##### Confirm the Service.

```bash
kubectl get service
```

##### Confirm access through the Service.

```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl http://sample-service
```

##### Observation

- No Pod was specified directly
- The Service is in between

**The entry point is handled, not the instance**

### 6. Summary (What Was Confirmed in This Hands-On)

What was experienced in this hands-on is the following distinction.

#### Pod

- Execution unit
- Breaks
- Not protected

#### Deployment

- Management unit
- Maintains state
- Makes judgments in place of people

#### Service

- Connection point
- Conceals instances
- Separates responsibility

Kubernetes  
is not a mechanism for running containers.

**It is a mechanism for maintaining state.**  

Up to this point, the flow of break, restore, and delegate has been experienced.  
Then, where is that state and configuration held?
