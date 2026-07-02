# Chapter 3: Security and Access Control – What to Restrict to Prevent Breakage


## 1. The Moment of Distribution Is When "Places That Can Be Broken" Increase

What is addressed here is a system divided into multiple services.

Security here does not mean only protecting against attacks.  
It also includes the meaning of controlling operations so as not to break the system.

As applications are divided, services increase,  
APIs increase, and communication routes increase.

In this structure, points at which the system can be operated continue to increase.

- Which services can be accessed?
- Which resources can be operated?
- Which configurations can be changed?

Without appropriately controlling these, unintended operations are performed,  
impact reaches areas that should not be touched, and information leakage occurs.


## 2. The Risk of "Being Breakable"

In a cloud-native environment:

- Deployment
- Configuration changes
- Resource operations

These operations can be performed flexibly.

While this is a powerful characteristic,  
it is also the ability to break the system.

Even beginners can handle strong permissions, so unintended changes or deletions  
may impact the system as a whole.

In this state, it becomes ambiguous who can operate how far,  
and a single operation impacts the whole.

The system cannot be operated stably.

Security is not only for protection against attacks.  
**It is a mechanism for preventing accidents and controlling the scope of impact.**


## 3. Access Control (RBAC)

What becomes necessary to address this problem is access control.

In Kubernetes, RBAC (Role Based Access Control) is used  
to define operational permissions for users and services.

The purpose of RBAC is not to grant permissions.

It lies in limiting how far operations can be performed and controlling the scope of impact.  
It is not a design that increases "what can be done" — **it is a design that restricts "the range that can be broken."**


## 4. Policy Management

Access control alone is insufficient.

- What operations are permitted?
- What configurations are allowed?

These must be managed as consistent rules.

As a mechanism for such policy management,  
OPA (Open Policy Agent) is used.

The purpose of policy is not to increase rules.

It lies in preventing unordered operations and maintaining consistent control.  
In a flexible environment such as Kubernetes, without governance things easily break down.


## 5. Secrets Management

The handling of sensitive information is the same.

- Database passwords
- API keys
- Authentication tokens

These are not mere configuration.

If they are leaked, the impact extends to the system as a whole.

- From where can they be referenced?
- Where can they be used?

That range must be controlled.


## 6. The Question That Remains

Is it sufficient to be able to control?

- How far to restrict?
- At what granularity to manage?
- What range to permit?

How is that design determined?

