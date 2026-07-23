# Preface {.unlisted .unnumbered}
The Non-Profit Organization LPI-Japan is pleased to announce the development and public release of the **Cloud Native Textbook** (hereafter referred to as "this textbook") on the internet, intended for use in cloud native engineer education.

This textbook was developed in response to requests from many educational institutions and engineers for teaching materials and learning environments that allow learners to study cloud native principles and practice from the **basics**.

The textbook is published under the license attached to it (Creative Commons License).

To remain current with the latest technological trends, this textbook will be updated from time to time.

For the most up-to-date information regarding this textbook, please refer to the following webpage:

```
https://linuc.org/textbooks/cloudnative/
```

## Purpose of This Textbook {.unlisted .unnumbered}
The purpose of this textbook is to help engineers who already meet the **LinuC Level 2** bar understand the structure and principles of cloud native technology and learn through hands-on practice.

Rather than memorizing procedures for Kubernetes or containers, we emphasize grasping **why** each design exists as a structural question.

### Areas Not Covered in This Textbook {.unlisted .unnumbered}
To keep the practical procedures concise, descriptions of basic Linux operations and system administration (which are covered in the **LinuC Level 1** scope) are kept to a bare minimum. Self-directed research is also part of learning, so some details are intentionally left for you to explore. If something is unclear, please look it up and deepen your understanding on your own.

## Intended Learning Environment {.unlisted .unnumbered}
This textbook is designed for self-study. Hands-on work is concentrated in Part 2; Part 1 and Part 3 onward are primarily reading material. See Part 2 for detailed procedures.

### Part 2 Hands-on (Standard) {.unlisted .unnumbered}
Part 2 uses **KillerCoda** as the standard hands-on environment. KillerCoda is a browser-based environment for learning Kubernetes and related topics. Exercises start from a running Kubernetes cluster and proceed by applying YAML with `kubectl`. You can begin with a Google account or similar, without installing tools or building an environment on your local PC. See Part 2, Chapter 2 for details.

### Prerequisites {.unlisted .unnumbered}
The network used for exercises is assumed to have **Internet access**, which is required for KillerCoda and for referring to this textbook's web page (`https://linuc.org/textbooks/cloudnative/`).

Part 2 uses **kubectl**, but the goal is to observe cluster state rather than memorize commands. Basic Linux skills (shell, file operations, and so on) at the **LinuC Level 1** level are assumed.

### Local Environment (Optional) {.unlisted .unnumbered}
You may also run Kubernetes locally with Minikube, Kind, k3s, Docker Desktop, and similar tools. Behavior and prerequisites vary by environment, so this textbook standardizes on KillerCoda. Part 2, Chapter 4 summarizes points to watch when moving exercises to a local environment.

### Classroom Use {.unlisted .unnumbered}
Even when many learners study together in a classroom, each learner is expected to use KillerCoda individually in a browser. If KillerCoda is blocked on your network, confirm connectivity in advance. If an instructor provides a shared Kubernetes environment, verify beforehand that Part 2 procedures work there as written.

## Overall Flow {.unlisted .unnumbered}
This textbook proceeds as follows:

### Prologue: What Is Cloud Native? {.unlisted .unnumbered}
How to use this textbook and why cloud native matters.

### Part 1: Foundations {.unlisted .unnumbered}
Containers, Kubernetes, and the difference between cloud and on-premises—understanding the principles.

### Part 2: Practice {.unlisted .unnumbered}
Hands-on work in KillerCoda and similar environments to experience how Kubernetes behaves.

### Part 3: Application {.unlisted .unnumbered}
Microservices, continuous delivery, and service-to-service communication—delivering and connecting applications.

### Part 4: Operations {.unlisted .unnumbered}
Monitoring, tracing, and security—making systems visible and keeping them safe.

### Part 5: Expansion {.unlisted .unnumbered}
Business and social context, FinOps, and connections with AI—turning technology into value.

### Part 6: Summary {.unlisted .unnumbered}
A structural recap of what you have learned.

### Appendix: Gateway to Practice {.unlisted .unnumbered}
Certifications such as KCNA and a learning roadmap.

## About the Authors and Creators {.unlisted .unnumbered}
This textbook is developed as an **open project**. From the planning stage onward, members exchange ideas and share preliminary research, writing, and review.

### Toshiyuki Tashibu (SHINESOFT CORPORATION) {.unlisted .unnumbered}
We created this textbook hoping it will support everyone who is starting to learn cloud native technology and those who guide that learning. Cloud native spans many technologies and open source projects, so understanding individual tools alone makes it hard to see the whole picture.
This book emphasizes structural understanding—why each mechanism was needed and what problem its design solves—rather than a single product or implementation recipe.
We hope it serves as a useful entry point into cloud native learning.

## Contributors {.unlisted .unnumbered}

### Tomohiro Katsumura (Nomura Research Institute, Ltd.) {.unlisted .unnumbered}
Cloud native technology can feel daunting to start because the domain is broad and the product landscape is large. Yet it is hard to stay competitive in today's business environment without it. We hope this book helps everyone who sets out to learn cloud native technology.

### Kanta Koto (Nomura Research Institute, Ltd.) {.unlisted .unnumbered}
In daily work I often touched Kubernetes and other cloud native technologies, but I found it difficult to explain systematically what "cloud native" means. Writing this book was a valuable opportunity to reorganize those concepts and connections. We hope it helps readers learn and understand.

### Daiki Takasao (Nomura Research Institute, Ltd.) {.unlisted .unnumbered}
When I learned Kubernetes and other cloud native technologies, I had no textbook that showed the whole landscape and had to feel my way forward. I joined this project hoping a broad overview textbook would ease that path for others. We hope this book is a good way to start exploring cloud native technology.

## Copyright {.unlisted .unnumbered}
The copyright of this textbook belongs to the **LPI-Japan**, a Non-Profit Organization.

Copyright© LPI-Japan. All Rights Reserved.

## Rights Regarding Use {.unlisted .unnumbered}
This textbook is licensed under the **Creative Commons Attribution-NonCommercial-NoDerivs 4.0 International (CC BY-NC-ND 4.0)** license.

![CC BY-NC-ND 4.0](image/Ch0/by-nc-nd.png){width=200px}


### Attribution {.unlisted .unnumbered}
Please indicate that the copyright of this textbook belongs to the **LPI-Japan**, a Non-Profit Organization.

### Non-Commercial {.unlisted .unnumbered}
This textbook may be used freely as teaching material for non-commercial purposes.

Use for commercial purposes, primarily aimed at commercial gain or monetary compensation, requires permission from LPI-Japan. However, in education where this textbook is used, if no fee is charged for the textbook itself, it can basically be used even in commercial education.
In such cases, and for any other inquiries, please feel free to contact the LPI-Japan Secretariat.

\* Commercial use is defined as follows:
In a for-profit company or non-profit organization, conducting training or lectures using copies of this textbook while charging learners more than the printing cost of this textbook, with commercial gain or monetary compensation as the primary aim.

### NoDerivatives (No Alteration) {.unlisted .unnumbered}
Please use this textbook without making any alterations. Any modifications to this textbook are carried out by **LPI-Japan** or by organizations authorized by LPI-Japan.

## Feedback {.unlisted .unnumbered}
We welcome feedback on Slack, which anyone can join. Please participate actively. For details on joining Slack, see the textbook web page below.

```
https://linuc.org/textbooks/cloudnative/
```

![https://linuc.org/textbooks/cloudnative/](image/Ch0/QR_cloudnative.png){width=25%}

## Inquiries Regarding Use of This Textbook {.unlisted .unnumbered}
LPI-Japan (Specified Non-Profit Organization) Secretariat

```
Inquiries: https://lpij.tayori.com/f/textbookinfo/
```

![https://lpij.tayori.com/f/textbookinfo/](image/Ch0/QR_toiawase.png){width=25%}
