# Figure Asset Directory for the Textbook

This directory stores figure files used by the Cloud Native Textbook.  
Place SVG figures used in the body text, along with related files, here.

---

## Purpose

This book is not merely a procedure guide; its purpose is to help readers
understand why a given technology or structure becomes necessary.

Figures are created the same way: not to explain technology elements,
but to support structural understanding.

---

## Naming Convention

Use names that correspond to figure numbers.

Examples

* figure_P-1.svg
* figure_1-1.svg
* figure_1-2.svg
* figure_3-1.svg
* figure_3-3.svg
* figure_4-1.svg
* figure_4-2.svg
* figure_4-2.1.svg

When keeping revised versions, append a version suffix.

Examples

* figure_3-1_v2.svg
* figure_4-2_v3.svg

Place the final version without a version suffix.

---

## Figure Numbering Scheme

Figure numbers correspond to where they appear.

* P-x : Prologue
* 1-x : Part 1
* 2-x : Part 2
* 3-x : Part 3
* 4-x : Part 4
* 5-x : Part 5

Use decimal form for supplemental figures of the same base figure.

Examples

* Figure 4-2
* Figure 4-2.1
* Figure 4-2.2

---

## Required Primary Figures

Figures that strongly affect body comprehension.  
Targets places where missing figures make structural understanding difficult.

### Figure P-1

Technological evolution as a change in assumptions

### Figure 1-1

Change in execution unit: from VM to container

### Figure 1-2

Kubernetes declarative control loop

### Figure 3-1

Complexity does not disappear — only its location changes

### Figure 3-3

Where communication control is placed

### Figure 4-1

The moment things become distributed, the whole becomes invisible

### Figure 4-2

A request passing through multiple services

### Figure 4-2.1

Reconstructing the flow of processing with Trace and Span

---

## Supplemental Figures That Accelerate Understanding

Understandable from body text alone, but figures accelerate comprehension.

### Figure 1-2.1

Kubernetes architecture: role division between Control Plane and Worker Node

### Figure 1-3

Difference in assumptions between cloud and on-premise

### Figure 3-2

GitOps flow: defining the flow of change

### Figure 3-4

Latency propagates upstream

### Figure 4-1.1

Coverage of monitoring and observability

---

## Editorial Policy

Review figures in this priority order.

1. Consistency with the body text
2. Reader understanding
3. PDF readability
4. Design improvement

Prefer "readers do not misunderstand" over structural redesign.  
Also assume meaning is complete only as a set with the body text, not as a figure alone.
