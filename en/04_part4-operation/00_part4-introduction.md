# Part 4: Operations Step – Making Things Visible and Protecting Them



In Part 3, the structure for dividing, delivering, and connecting applications was organized.

However, merely moving judgment outside as a structure  
is not enough to know whether the system is functioning correctly.

In a distributed system, the internal state is not directly visible.  
What is visible is only the behavior that appears as a result.

- Response is slow
- Errors are returned
- Processing stops

Such phenomena can be observed, but where the cause lies cannot be determined without further investigation.

- Is it a problem in the application?
- Is it a problem in the network?
- Is it a problem in the database?

Without the ability to make that judgment, response is delayed.  
Without knowing the cause, the same failure repeats.

**In this state, stable operations cannot remain viable.**


Even when the structure is in order, if the state cannot be determined, the whole cannot be maintained.  
What is needed here is not the ability to directly look inside.

**It is the perspective of inferring state from information that can be observed.**

What is happening in the system right now?  
And where does that judgment come from?


