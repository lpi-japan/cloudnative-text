## 3-3 Hands-On: Gateway API and Access Confirmation – Where Does the Responsibility for External Entry Lie?

Assumed environment: Killercoda (Kubernetes cluster running)  
All subsequent operations use kubectl.

### 0. Pre-Check

In the hands-on work up to this point,

- Deployment (nginx)
- Service (ClusterIP)
These are assumed to exist. Proceed on that basis.

##### Confirm.

```bash
kubectl get deployment
kubectl get service
```

If sample-deployment and sample-service exist, that is sufficient.

### 1. Confirm the Role of Service (Internal Connection Point)

##### Confirm access through the Service.

```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl http://sample-service
```

##### Observation

- The access target is not a Pod
- Communication is possible with only the Service name
- The number of Pods and their replacement are not something to be aware of

**Service is the internal connection point**

### 2. Confirm the Assumptions of Gateway API (CRD and Controller)

Gateway API also does not work with the resource alone.  
A Gateway Controller (implementation) is always required.

##### Confirm the CRD.

```bash
kubectl get crd | egrep "gateways.gateway.networking.k8s.io|httproutes.gateway.networking.k8s.io" || true
```

##### Confirm GatewayClass.

```bash
kubectl get gatewayclass
```

If GatewayClass is not present, the Controller may not be installed.  
In that case, skip "3.–5." and reading "7. Responsibility Organization" is sufficient.

**Declaration and execution are separated**

### 3. Create a Gateway (Define the External Entry Point)

##### Confirm GatewayClass.

```bash
kubectl get gatewayclass
```

Confirm the available class name and replace <GATEWAY_CLASS_NAME>.  
(Examples: nginx / istio / envoy, etc.)

##### Create the Gateway.

```bash
cat <<EOF > gateway.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: sample-gateway
spec:
  gatewayClassName: <GATEWAY_CLASS_NAME>
  listeners:
  - name: http
    protocol: HTTP
    port: 80
    hostname: sample.local
EOF
```

##### Apply it.

```bash
kubectl apply -f gateway.yaml
```

##### Confirm the Gateway.

```bash
kubectl get gateway
kubectl describe gateway sample-gateway
```

##### Observation

- The Gateway defines the form of the entry point
- Where to route has not yet been decided

**Gateway is a definition, not an execution**

### 4. Create an HTTPRoute (Define the Flow)

##### Define an HTTPRoute resource.

```bash
cat <<EOF > httproute.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: sample-route
spec:
  parentRefs:
  - name: sample-gateway
  hostnames:
  - sample.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: sample-service
      port: 80
EOF
```

##### Apply it.

```bash
kubectl apply -f httproute.yaml
```

##### Confirm the HTTPRoute.

```bash
kubectl get httproute
kubectl describe httproute sample-route
```

##### Observation

- The flow is defined on the HTTPRoute side
- The role is separated from the Gateway

**Entry point and routing are separate**

### 5. Access Through the Gateway

##### Find the Service associated with the Gateway.

```bash
kubectl get svc -A -l gateway.networking.k8s.io/gateway-name=sample-gateway || true
```

##### Port-forward.

```bash
kubectl -n <NAMESPACE> port-forward svc/<SERVICE_NAME> 8080:80
```

##### Access from a separate terminal.

```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl -H "Host: sample.local" http://localhost:8080
```

If an nginx response is returned, it is successful.

##### Observation

- The Pod behind the Service is not being considered
- Processing proceeds through the flow Gateway → Route → Service

※ If the Service cannot be found or port-forward fails, the Gateway Controller may not be installed.  
Even in that case, if "7. Responsibility Organization" is understood, the purpose of this section is achieved.

### 6. Delete the Pod (Does the Structure Collapse?)

##### Delete the Pod.

```bash
kubectl delete pod -l app=sample
```

##### Access again.

```bash
kubectl run curl --rm -it --image=curlimages/curl --restart=Never -- \
  curl -H "Host: sample.local" http://localhost:8080
```

##### Observation

- The Pod is replaced
- The access method does not change

**The route is maintained**

### 7. Responsibility Organization

Here, the role of each resource is organized.

#### Application (Pod)

- Performs processing
- Does not know the communication route

#### Service

- Handles internal connectivity

#### Gateway

- Defines the external entry point

#### HTTPRoute

- Defines the flow

The responsibility for communication lies outside the application.

### 8. What Was "Not Done" Is Important

In this hands-on, the following were not performed.

- Changing the application configuration
- Specifying IP addresses
- Being aware of Pod names

Even so, a state was achieved in which external access was possible and things continued to work even when Pods changed.  
**What does not need to be done reflects the intent of the design**

### 9. Summary: What Was Confirmed in This Hands-On

##### Pod

- Focuses on processing

##### Service

- Handles internal connectivity

##### Gateway

- Defines the entry point

##### HTTPRoute

- Defines the flow

**Communication is separated.**  
Proceeding to the next chapter with this structure intact.
