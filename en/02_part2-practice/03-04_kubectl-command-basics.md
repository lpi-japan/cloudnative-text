## 3-4 kubectl Command Basics – A Tool for "Viewing State," Not for Operating

In the hands-on work of this chapter, several kubectl commands are used.  
There is no need to memorize all options and usage here.

What matters is not misunderstanding the role of kubectl.

The role of kubectl is not to directly operate and manage resources.  
kubectl has commands such as delete and scale that change state.

However, in essence, it is a tool for confirming and understanding:

- What state is the cluster currently in?
- What is happening compared to the Desired State?

In this chapter,

- get
- describe
- logs

are the focus, using kubectl in the way of observing state.

### 1. What Is kubectl?

kubectl is an interface for confirming cluster state  
and communicating state.

kubectl itself does not make judgments or manage resources.

- Kubernetes makes the judgments
- kubectl only "communicates" and "views"

### 2. kubectl get

##### View the current state as a list

```bash
kubectl get pod
kubectl get deployment
kubectl get service
```

get is the command for confirming "what currently exists" as a list.

What can be understood here is:

- Whether it exists
- The count
- The rough state

Detailed reasons cannot be determined.  
**Confirm existence and state**

### 3. kubectl describe

##### View the detailed state

```bash
kubectl describe pod sample-pod
```

describe is the command for confirming "why it is in this state right now."

- Events
- Errors
- Scheduling results

If get is for confirming an overview of resources as a list,  
describe is a tool for confirming the detailed state of individual resources.

**Confirm the history and reason**

### 4. kubectl apply

##### Communicate the Desired State

```bash
kubectl apply -f deployment.yaml
```

apply is the command for communicating to Kubernetes the declaration "I want it to be in this state."  
What matters here is that it is not an operational command.

Kubernetes compares:

- The current state
- The declared state

and acts to close that gap.  
**Declare the Desired State**

### 5. kubectl delete

##### Break the state

```bash
kubectl delete pod sample-pod
```

delete is the command for deleting a resource.  
However, in Kubernetes, deletion does not necessarily mean the end.

When a management unit such as a Deployment exists:

- The state breaks
- It is automatically restored

This is the behavior that occurs.  
**Break the state and observe the behavior**

### 6. kubectl scale

##### Change only the count

```bash
kubectl scale deployment sample-deployment --replicas=3
```

scale is the command for changing only "how many should exist."

- Which Pods to increase
- Where to place them

These are determined by Kubernetes.

**Specify only the count**

### 7. kubectl expose

##### Create a connection point

```bash
kubectl expose deployment sample-deployment --type=ClusterIP --port=80
```

expose is the command for exposing a resource through a Service.

Here too,

- Which Pod to connect to
- Processing when Pods increase or decrease

There is no need for a person to think about these.  
The Service takes on that responsibility.

**Define the connection point**

### 8. kubectl logs / exec

##### Tools for "looking inside"

```bash
kubectl logs <pod-name>
kubectl exec -it <pod-name> -- /bin/sh
```

These are commands for confirming what is happening inside a container.

They are not for staying inside for troubleshooting.  
They are tools for observation only.

**Observe the inside**

### 9. Summary

The correspondence to understand at this point is as follows.

| Command | Role |
|-----------|-------------------------|
| get | View what currently exists |
| describe | View the detailed state |
| apply | Declare the Desired State |
| delete | Break the state and observe behavior |
| scale | Change only the count |
| expose | Create a connection point |
| logs / exec | Observe the inside |

kubectl is not a tool for operating Kubernetes.

It is a window for exchanging state.  
It is sufficient to grasp only this relationship.

Proceeding to the next chapter.
