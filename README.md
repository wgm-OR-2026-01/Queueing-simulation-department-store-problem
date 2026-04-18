# Queueing-simulation-Matlab
## Blake Smith
Abstract

Mickey's Department Store wanted recommendations for checkout register
implementation to decrease wait times during peak holiday hours.
The objective was to ensure that no more than 10% of customers wait longer
than 5 minutes before beginning service. I conducted a comparative
analysis using M/M/k Queue Theory equations validated through MATLAB simulations.
Baseline analysis identified $s=7$ as the minimum number of registers required
to maintain $P(W_q > 5) < 0.10$. However, sensitivity analysis revealed
significant system fragility if service times increased beyond initial estimates.
To mitigate operational risks, I recommend implementing $s=8$ registers to provide
a buffer against variable arrival rates and staff experience levels.

`Run_ServiceQueue_baseline_MMKTEST.m`
This service queue provides the calculations based on the 6.5-minute service time
estimate. Calculates theoretical probabilities and runs
simulation samples to get the baseline register amount.

`Run_ServiceQueue_Sensitivity_Increased_Wait_Times_Possible`
This service queue provides the calculations based on an 8 minute service time
estimate. Calculates theoretical probabilities and runs simulations samples
to get the optimal register amount. These results were used to find out
what would happen if service times were varying to analyze risks.

The main class is `ServiceQueue`.
It maintains a list of events, ordered by the time that they occur.
There is one `Arrival` scheduled at any time that represents the arrival of the next customer.
When a customer reaches the front of the waiting queue, they can be moved to a service station.
Once a customer moves into a service slot, a `Departure` event for that customer is scheduled.
There should be one `Departure` event scheduled for each busy service station.
There is one `RecordToLog` scheduled at any time that represents the next time statistics will be added to the log table.

