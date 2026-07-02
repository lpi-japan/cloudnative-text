# Chapter 4: Fundamentals of Linux and Networking – Putting Words to the Foundation That Underlies Everything


## 1. Why Return to the Foundation Now?

Cloud and Kubernetes  
appear to be self-contained on their own layer.

In reality, however,  
everything they do depends on the layer beneath them.

The assumptions have not disappeared.

**They have simply become invisible.**

Through abstraction, things have become easier to handle,  
and with that, opportunities to be aware of those assumptions have decreased.


## 2. The Assumption of Linux

Much of the mechanism behind both containers and Kubernetes is built on Linux capabilities and concepts.

Processes are isolated,  
resources (computational resources such as CPU, memory, and network) are distributed,  
and boundaries are maintained.

Through this mechanism,  
multiple processes can be handled independently within a single system.

Containers are not a new mechanism.

They use this already-existing assumption  
**and give it a form that can be treated as an execution unit.**

Therefore, they are created when needed  
and discarded when no longer needed.


## 3. Resources Are Not Always Stable

CPU and memory cannot always be used in the same way.

As load changes, behavior changes,  
and depending on the situation, processing slows down or stops.

These are not exceptions.

**They are unavoidable properties of handling finite resources.**  
In an abstracted environment, these constraints become difficult to see.

But they have not disappeared —  
they have simply become invisible.


## 4. The Assumption of Networking

The network does not always connect.

Latency occurs, ordering is disrupted,  
connections drop without warning.

For example, when communication is slow,  
the cause may not be immediately clear.

These are not exceptions.

**They are properties that arise within a finite environment, and are part of its assumptions.**


## 5. Failure Is an Assumption

With containers, units are separated,  
and with Kubernetes, they come to be controlled.

However, the foundation on which these run  
continues to change and remains uncertain.

A state in which some parts are functioning and others are failing  
is not exceptional.

This state cannot be eliminated.

What is needed is  
**a structure from which recovery is possible when failure occurs.**


## 6. Who Takes Responsibility for the Assumptions?

These assumptions are always taken on somewhere.

Resource constraints and network uncertainty  
cannot simply be left unaddressed.

Does the application take them on directly?  
Does a control mechanism such as Kubernetes absorb them?  
Does the cloud environment abstract them and make them invisible?

Somewhere, they are always taken on.

Where responsibility lies  
changes the meaning of design.


## 7. The Question That Remains

What has been examined up to this point is not new technology.  
Everything rests on assumptions that already existed.

Then, in order to treat those assumptions as assumptions,  
how is state understood, and how are judgments made?

