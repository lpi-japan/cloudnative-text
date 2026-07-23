# 3-2 Hands-On: ConfigMap / Secret / Volume – Separating Configuration from Execution


Assumed environment: KillerCoda (Kubernetes cluster running)  
All subsequent operations use kubectl.

## 0. Pre-Check

Confirm that the Deployment created in the previous hands-on exists.
```bash
kubectl get deployment
kubectl get pod
```

If Pods are running, that is sufficient.



## 1. Create a ConfigMap (Place Configuration Outside the Pod)

#### Define a ConfigMap.
```bash
cat <<EOF > configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  MESSAGE: "Hello from ConfigMap"
EOF
```

#### Create the ConfigMap.
```bash
kubectl apply -f configmap.yaml
```

#### Confirm.
```bash
kubectl get configmap
```



## 2. Reference the ConfigMap from a Pod

#### Configure it to read the ConfigMap as an environment variable.

```bash
cat <<EOF > deployment-config.yaml
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
        env:
        - name: MESSAGE
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: MESSAGE
        ports:
        - containerPort: 80
EOF
```

#### Apply it.
```bash
kubectl apply -f deployment-config.yaml
```

#### Confirm the Pod.
```bash
kubectl get pod
```

#### Confirm the environment variable.
```bash
kubectl exec -it $(kubectl get pod -l app=sample -o jsonpath='{.items[0].metadata.name}') -- env | grep MESSAGE
```

#### Observation
- The configuration is visible inside the Pod
- However, the definition is outside the Pod

**Configuration is defined outside the Pod**



## 3. Delete the Pod (Does the Configuration Remain?)

#### Delete the Pod.
```bash
kubectl delete pod -l app=sample
```

#### Confirm the Pod again.
```bash
kubectl get pod
```

#### Once the new Pod starts, confirm the environment variable again.
```bash
kubectl exec -it $(kubectl get pod -l app=sample -o jsonpath='{.items[0].metadata.name}') -- env | grep MESSAGE
```

#### Observation
- The Pod was replaced
- The configuration is still in use

**The Pod does not "own" the configuration**



## 4. Change the ConfigMap (Where Does the Configuration Take Effect?)

#### Change the ConfigMap.
```bash
kubectl edit configmap app-config
```

#### Change the content of MESSAGE and save.
```bash
MESSAGE: "Hello updated ConfigMap"
```

#### Restart the Pod.
```bash
kubectl delete pod -l app=sample
```

#### Confirm the environment variable again.
```bash
kubectl exec -it $(kubectl get pod -l app=sample -o jsonpath='{.items[0].metadata.name}') -- env | grep MESSAGE
```

#### Observation
- Configuration changes take effect when the Pod is recreated
- Configuration and execution are separated

**Changing the configuration does not change the Pod definition**



## 5. Use a Volume (Thinking About Where Data Is Placed)

#### Create a Deployment that uses a Volume.
```bash
cat <<EOF > deployment-volume.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: volume-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: volume-sample
  template:
    metadata:
      labels:
        app: volume-sample
    spec:
      containers:
      - name: app
        image: busybox
        command: ["/bin/sh", "-c"]
        args: ["echo hello > /data/message.txt && sleep 3600"]
        volumeMounts:
        - name: data-volume
          mountPath: /data
      volumes:
      - name: data-volume
        emptyDir: {}
EOF
```

#### Apply it.
```bash
kubectl apply -f deployment-volume.yaml
```

#### Confirm the data.
```bash
kubectl exec -it $(kubectl get pod -l app=volume-sample -o jsonpath='{.items[0].metadata.name}') -- cat /data/message.txt
```



## 6. Delete the Pod (Does the Data Remain?)

```bash
kubectl delete pod -l app=volume-sample
```

#### Once the new Pod starts, confirm again.
```bash
kubectl exec -it $(kubectl get pod -l app=volume-sample -o jsonpath='{.items[0].metadata.name}') -- ls /data
```

#### Observation
- The data is gone
- emptyDir shares its fate with the Pod


**The lifetime of data is determined by the type of Volume**



## 7. On Secrets (Not Practiced Here)
The concept of Secret is the same as ConfigMap.  
However, because the use case differs, no operations are performed here.

What matters is not "whether it is kept secret" but "whether it is outside the Pod."



## 8. Summary (What Was Confirmed in This Hands-On)

#### ConfigMap

- Places configuration outside the Pod
- Configuration remains even when the Pod disappears
- Configuration changes take effect when the Pod is recreated

#### Secret

- Places sensitive information outside the Pod
- Handled in the same way as ConfigMap

#### Volume

- Makes the lifetime of state explicit
- emptyDir shares its fate with the Pod

What was confirmed in this hands-on is that a Pod is an execution unit,  
not a place for storing state or configuration.

Then, where is external connectivity handled?  
Proceeding to Ingress / Gateway.
