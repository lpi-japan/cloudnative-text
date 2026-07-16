## 3. CKA / CKAD / CKS — Differences from Intermediate and Advanced Certifications, and How to Approach Them

### Intermediate Certifications Change the Scope of Responsibility

Where KCNA examines structural understanding of cloud native as a whole,  
CKA, CKAD, and CKS each address different roles and scopes of responsibility.

What matters is not **"which certification is higher."**  
It is which domain to engage with deeply, and which responsibility to take on.

That distinction shapes the direction of learning.


### CKA (Certified Kubernetes Administrator)

#### ■ Keeping a distributed environment running without stopping.

CKA is a certification centered on the operation and management of Kubernetes clusters.

Through node management, cluster configuration, network settings, failure response, and scaling,  
it addresses **"keeping a distributed environment stably maintained."**

More than building a system,  
this certification demands an operational practice of grasping state  
and responding to change within an environment where failures and changes continue to occur.

> "**Why does operation itself become design?**"


### CKAD (Certified Kubernetes Application Developer)

#### ■ Building with continuous change as the baseline assumption.

CKAD is a certification covering the design and deployment of applications that run on Kubernetes.

Through Deployment, ConfigMap, Secret, Service, Helm, CI/CD, and related tools,  
it addresses **"application design with change as the baseline assumption."**

Rather than making an application self-contained in isolation,  
the focus is on how to connect it within a distributed environment  
and how to continuously apply changes to it.

This domain concerns application design for the cloud native era.

> "**Why do applications also become distributed by assumption?**"


### CKS (Certified Kubernetes Security Specialist)

#### ■ Maintaining safety while permitting change.

CKS is a certification that specializes in security within Kubernetes environments.

Through RBAC, NetworkPolicy, Supply Chain Security, Runtime Security, and related topics,  
it addresses how far to permit, where to apply control, and how to maintain safety.

In cloud native environments, as systems become more distributed, connection points and Responsibility Boundaries also multiply.

Furthermore, Kubernetes is not a self-contained system.

Systems are kept viable through the combination of multiple technologies and OSS components:  
applications, containers, operating systems, networks, and more.

For that reason, CKS requires not only understanding of Kubernetes configuration  
but also understanding of the surrounding technologies and infrastructure layers.

Security does not become viable through any single component alone.  
It must be considered while maintaining awareness of boundaries and Responsibility Boundaries across the entire system.

Within that, how to design boundaries,  
how to control risk, and how to maintain safety while preserving flexibility —  
these questions form the center of this domain.

CKS is both a Kubernetes security certification  
and a certification for thinking about how to protect an entire cloud native environment.

> "**Why do Responsibility Boundaries become more critical as systems become more distributed?**"

> > [!WARNING]  
> CKA certification is required to register for CKS.


### Where to Begin

There is no single correct order for learning.

What matters is **"which domain one wants to deepen."**

| Interest | Next Option |
|---|---|
| Organize the overall cloud native landscape | KCNA |
| Deepen Kubernetes operations | CKA |
| Deepen application design | CKAD |
| Deepen security and boundary control | CKS |

> ※ KCNA provides a starting point for those who want to organize the structural understanding developed in this textbook within a knowledge framework.

Certifications are not a destination.  
They are one perspective for deepening understanding.

Building on the structural understanding developed in this textbook,  
what matters is thinking about which responsibilities and roles one wants to develop further,  
and connecting to the next stage of learning.
