## Chapter 4: Points to Note When Deploying to a Local Environment – More Freedom Means More Responsibility

Through Chapter 3, using KillerCoda for practice, the following were experienced firsthand.

- Basic behavior of Kubernetes
- Design under the assumption that things break
- A world where people do not operate directly

From here, the environment changes.

### 1. Differences Between Learning Environments and Local Environments

In a learning environment such as KillerCoda:

- The initial state is in order
- Dependencies are aligned
- Unexpected gaps are few

These are the assumptions.

In a local environment, on the other hand:

- OS
- Container execution environment
- Network configuration
- Resource limits

All of these become environment-dependent.  
This does not mean Kubernetes has become more difficult.

**It simply means there is no longer anything absorbing the assumptions.**

### 2. Points Where Environment Differences Become Visible

#### 2-1. Network

In a local environment:

- Port-forwarding becomes necessary
- Name resolution does not work as expected
- External access is not possible

These problems arise.

This is not abnormal.

It occurs because the network boundary and DNS configuration  
in a local environment differ from those in a learning environment.

#### 2-2. Resources (CPU / Memory)

In a local environment:

- Insufficient memory
- CPU contention
- Forced process termination

These occur.

Containers go down, Pods restart.  
This is not a Kubernetes problem.

In many cases, **Linux is dropping processes to protect resources.**  
Kubernetes does not prevent that.

**It operates under the assumption that this occurs.**

These tend to occur in local environments, but can similarly occur in remote environments as well.  
What matters is that this is not a Kubernetes problem — it is a property of the foundation, and is part of the assumption.

#### 2-3. Storage

In a local environment:

- Volumes do not work as expected
- Data does not persist
- Permission issues block progress

These problems appear.

Here too, the same applies.  
Kubernetes does not hold storage.

The actual dependencies are:

- OS
- File system
- Mounts

### 3. Freedom and Responsibility

In a local environment:

- Configuration can be set freely
- Structure can be decided independently

On the other hand, the reason when things do not work must also be taken on by the person themselves.  
This is not difficulty.

**It is simply that where responsibility lies has changed.**

### 4. Connection to the Assumptions of Part 1

All the gaps encountered up to this point connect back to Part 1.

- Environments change
- Networks go down
- Resources run out
- People cannot control everything

The reason these surface in a local environment  
is that the assumptions the learning environment was absorbing have been removed.

Kubernetes is not a mechanism for hiding those.  
**It is a mechanism for reducing the burden on people, under the assumption that those things occur.**

### 5. Summary

When the environment changes, where responsibility lies also changes.  
Which assumptions, and who is taking them on?

Whether one is conscious of that determines the design.

Proceeding from here into design with these assumptions in hand.
