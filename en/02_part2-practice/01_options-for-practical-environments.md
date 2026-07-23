## Chapter 1: Options for Practice Environments – Where to Run Kubernetes

### 1. Why Start with the Environment?

There is not one environment for practicing Kubernetes.

Even with the same operations, results change when the environment is different.  
Following the steps exactly but it does not work.  
It is written as described but the behavior is different.

In these situations, the problem is not Kubernetes.  
The assumptions of the environment being used are simply different.

When the assumptions of the environment differ, what is handled automatically  
and what must be handled by the person changes.

Without understanding that difference, "why it does not work" becomes unclear.

### 2. Aligning Assumptions

What matters is not which environment to use.

It is whether one is consciously aware of what assumptions the environment operates under.  
What is automatically provided by the environment, and what must be taken on by the person, changes significantly depending on the environment.

For example, in a local environment,  
tools such as Minikube, Kind, k3s, or Docker Desktop are used,  
and it is necessary to take on part of the setup and control oneself.

On the other hand, as a pre-configured environment,  
there are options such as KillerCoda where the execution environment is provided.

Neither is superior.

In this part, in order to focus on "observing behavior,"  
the impact of environment differences and assumption gaps is minimized as much as possible.

Therefore, a pre-configured environment is used as the assumption.

What matters is that this choice is not made because it is "convenient,"  
but because it allows focus on observation.

### ■ Main Options for Running Kubernetes

※ Note on the execution environment addressed in this chapter

Minikube, Kind, k3s, and Docker Desktop  
are Kubernetes execution environments intended primarily for learning and verification.

On the other hand, public cloud environments (AWS, Azure, Google Cloud)  
used in actual service operations  
often use environments with different assumptions.

What matters here is not which is superior.  
It is that the assumptions differ.

The purpose of this chapter is not to decide "which to use in production."

The options addressed are those used as learning environments  
for running Kubernetes and understanding its behavior and assumptions.

Here, representative environments commonly used when trying out Kubernetes are examined.  
What matters is not deciding which is best.

It is understanding the purpose for which each option was created,  
and what assumptions it operates under.

### 3. How This Part Handles the Environment

In this part, the impact of environment differences is minimized.

Before entering practice, it is important to be conscious of the assumptions of the environment.  
With those assumptions established, the behavior of Kubernetes is observed.

The purpose is not to memorize operations.  
It is to observe the behavior of Kubernetes.

Even with the same operations, why does a particular result occur?  
What changes, and what does not?

Capturing that difference is what matters.  
It is fine not to understand immediately.

Confirm repeatedly how the assumptions addressed in Part 1 appear.
