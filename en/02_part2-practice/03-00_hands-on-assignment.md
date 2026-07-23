## Chapter 3: Hands-On Assignment – Experiencing Kubernetes Behavior Firsthand

### 1. Purpose of This Chapter

In this chapter, Kubernetes resources are actually handled  
and their behavior is observed.

The purpose here  
is not to memorize operations.

It is to experience firsthand what Kubernetes handles automatically,  
and what the person no longer needs to do.

The goal is to see how the assumptions organized in Part 1  
and the environment aligned in Part 2  
actually appear as behavior.

### 2. How to Observe in This Chapter

In the hands-on work, the following perspectives are kept in mind.

Not "what did I do" but "what happened on its own"  
Not "avoiding failure" but "how does it recover after breaking"

Kubernetes is a mechanism for reducing human operations.  
In this chapter, by intentionally breaking and intentionally recovering, that design is confirmed.

### 3. Main Resources Appearing in This Chapter

In this chapter, several Kubernetes resources are handled.  
There is no need to memorize the details here.

For now, simply grasp what role each one holds.

| Resource | Role |
|----------|------|
| Pod | The unit that executes a container |
| Deployment | The mechanism that maintains Pod state |
| Service | The mechanism that provides stable access to Pods |
| ConfigMap | The mechanism that manages configuration information |
| Secret | The mechanism that manages sensitive information |
| Volume | The mechanism that retains data |
| Ingress / Gateway | The mechanism that handles external connectivity |

These are not independent functions.

Kubernetes keeps the system viable  
by separating each role while combining them.

What matters is not memorizing the names.

Confirm through actual behavior why the roles are separated.

#### 3-1. Pod / Deployment / Service – Separation of Execution Unit and Responsibility

■ Question  
When units are separated,  
who keeps them viable?

■ Operation (Overview)

- Create a Pod
- Delete a Pod
- Use a Deployment
- Change the replica count
- Access through a Service

■ Observation

- What happened when a Pod was deleted?
- What processing occurred that was not instructed?
- What is Deployment absorbing?

Pods are treated under the assumption that they break.

Kubernetes is not designed to prevent breakage —  
it is designed to restore when something breaks.

#### 3-2. ConfigMap / Secret / Volume – Separating Configuration from Execution

■ Question  
Why is configuration separated from execution?

■ Operation (Overview)

- Create a ConfigMap
- Reference it from a Pod
- Delete the Pod
- Confirm the state after recreation

■ Observation

- What remains after the Pod disappears?
- Where is the configuration?
- Why is it not held within the Pod?

Pods are disposable.

In Kubernetes, the assumption is not long-running operation —  
it is replacement.

#### 3-3. Ingress / Gateway – Where Is the Boundary Placed?

■ Question  
Where is external connectivity handled?

■ Observation

- The difference between Service and Ingress
- Why Ingress does not work on its own
- What is actually handling the processing

Kubernetes is a mechanism that defines not the method of communication,  
but "how it is intended to be handled."

#### 3-4. kubectl – Used for Observation, Not Operation

In this chapter, the following commands are used.

- get
- describe
- logs
- exec

What matters is that in this textbook, kubectl is not used as a tool for operations.

- Viewing state
- Viewing change
- Viewing the gap

That is what it is used for.

### 4. Summary of This Chapter

What was done in this chapter is not memorizing operations.

It is confirming, as actual behavior,  
how Kubernetes behaves under the assumption that things break.

- Pods disappear
- Deployments restore them
- Configuration moves outside
- Responsibilities are separated
- Communication is separated

All of these rest on the assumptions organized in Part 1.

kubectl is the window for viewing that state.

The experience up to this point was made viable on the KillerCoda environment.  
When the environment changes, the assumptions taken on also change.

Proceeding to the next chapter to confirm that.
