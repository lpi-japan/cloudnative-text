# Chapter 2: Standardizing the Practice Environment – Aligning Assumptions for Observation


## 1. Why Align the Environment?

In learning Kubernetes, behavior changes depending on the environment.

When the same operations yield different results,  
the problem lies in the assumptions of the environment, not in Kubernetes.

Proceeding without addressing this leads to not knowing what is being observed.

Much of the time spent on things unrelated to the essence of learning  
comes from this gap in assumptions.


## 2. How This Part Handles It

In this part, the impact of environment differences is minimized.

The purpose is not to perform operations, but to observe behavior itself.  
Therefore, in this part, a pre-configured environment is used as the assumption.

In this textbook, the **KillerCoda** environment is used.

KillerCoda is a hands-on environment for learning Kubernetes  
and cloud-native technologies in a browser.

It can be started easily using a Google account or similar,  
and the pre-configured environment can be used immediately  
without installation or setup on a local PC.

In this textbook, it is used not to learn environment setup,  
but as the foundation for observing Kubernetes behavior.

Cloud-native design is built on the assumptions that things break and that recovery is possible.

The main characteristics are as follows.

- Usable with only a browser
- No prior environment setup required
- Initial state is guaranteed
- Easy to start over after failure

This makes it possible to enter practice  
with elements other than "what to learn" removed as much as possible.


## 3. The Role of the Environment

The environment used here is not one that closely resembles production, nor is it feature-rich.  
It is one that reduces differences unrelated to the essence of learning.

The ability to restore immediately after breaking, and to try from the same state any number of times —  
these properties allow focus on change and behavior.

However, in actual environments, the assumptions differ.

- Network configuration
- Storage
- Resource limits

These change significantly depending on the environment.

What is addressed here does not reproduce all of those.  
It is simply the foundation for understanding structure and behavior.


## 4. Confirmation Before Entering Practice

What matters here is not the environment itself.  
It is being conscious of what assumptions the observation is being made under.

Without this alignment of assumptions,  
what is being observed becomes unclear.

With this, the assumptions for entering practice are in place.  
Then, what actually happens within this environment?

