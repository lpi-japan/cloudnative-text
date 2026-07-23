## Chapter 4: Operations and Troubleshooting – A Design for Continuing to Make Judgments

### 1. Operations Means "Keeping Things Going"

A system does not end once it is running.  
It must continuously provide services.

However, in a cloud-native environment,  
containers are dynamically created and deleted,  
services are distributed, and configuration continues to change.

In this state:

- Everything cannot be grasped
- Everything cannot be continuously tracked

Even so, services cannot be stopped.

- Where is the problem?
- How far has the impact spread?
- How far should a response go?

These must be judged each time they occur.

Operations is not about knowing everything.  
**It is about continuing to make judgments in order to keep things going, based on limited information.**

### 2. What Is Being Done in Failure Response?

Failures cannot be completely prevented.  
What matters is being able to respond appropriately when they occur.

In general, failure response proceeds in the following flow:

- Detect
- Grasp the situation
- Identify the cause
- Restore
- Prevent recurrence

However, in actual operations, it is not always possible to proceed in order.  
What is needed first is to restore the service.

- Whether to investigate deeply
- Whether to temporarily work around

A judgment must be made on how far to respond.

However, this judgment is made in a state of incomplete information.

- The cause is unknown
- It cannot be reproduced
- The same failure repeats

Without the ability to make a judgment, operations cannot remain viable.

### 3. Why Tools Become Necessary

For this problem,  
it is not possible for people to continue directly tracking state.

- Entering a Pod to continue investigating
- Manually changing state

Such operations can resolve things temporarily,  
but they break the structure of the system and cause problems over the long term.

Kubernetes is a mechanism that manages declaratively.

Ad hoc operations continue to generate drift from the original state.

Furthermore:

- It is necessary to grasp distributed services across them
- It is necessary to track past state and changes
- It is necessary to combine multiple pieces of information and make judgments

kubectl alone cannot respond to this state.

Therefore, a mechanism for handling:

- Metrics
- Logs
- Tracing

these pieces of information in an integrated manner becomes necessary.

What matters is not the tools.  
It is being in a state where information necessary for judgment can be handled.

### 4. The Assumption of Continuing to Improve

Failure response does not end with restoration.

- Why did it occur?
- How can it be prevented?
- Which observation was insufficient?

These must be reviewed.

However, what matters is not making everything perfect.

- How far to respond?
- Where to accept limitations?

By repeatedly making these judgments,  
the stability of the system gradually increases.

### 5. Design for Reliability (SRE)

The idea that supports this judgment is SRE.

In SRE:

- SLI (indicators)
- SLO (objectives)

These are defined, and:

- How far to maintain quality?
- How much failure to accept?

is decided.

Reliability is a state in which quality is visualized as a number  
and a judgment can be made on how far to respond.

Not everything can be protected.  
That is precisely why it is necessary to decide what to protect.

### 6. Summary

Operations is not about grasping everything.

It is about continuing to make judgments based on limited information  
within a system that is distributed and continues to change.

State is understood through observation,  
impact is limited through control,  
and on top of that, how far to respond is decided.

Not everything can be prevented.  
Not everything can be understood.

That is precisely why:

- How far to look
- How far to control
- How far to accept

these judgments become necessary.

Technology exists to support those judgments.
