# Kait Mounce
# Queueing-simulation-department-store-problem

A queueing simulation in Matlab.

Baseline repository for the department store problem.

#
## Abstract

This analysis evaluates the performance of Mickey's Department Store 
checkout system during peak hours using both theoretical queuing models and 
simulations. The system is modeled as an M/M/s queue with multiple 
cashiers. A baseline analysis is conducted using estimated service times, 
followed by a sensitivity analysis to account for slower service due to 
less experienced staff. Results are used to determine the minimum number 
of cashiers required to a service goal that limits excessive customer wait 
times. The findings highlight the impact of staffing levels and service 
variability on system performance and provide recommendations for 
improving efficiency.  

#
## Files Description

#### Run_ServiceQueue_Baseline_7Registers.m
This file implements the baseline queueing simulation for Mickey's 
Department Strore checkout system using the original service time estimate 
of 6.5 minutes per customer. The model assumes Poisson arrivals and 
exponential service times and evaluates system performance over a 4-hour
peak period. The simulation is used to estimate key performance metrics, 
such as average wait time and customers waiting more than five minutes, for
different numbers of cashiers. 


#### Run_ServiceQueue_Sensitivity.m
This file extends the baseline simulation by implementing an average 
service time of 8 minutes per customer to reflect less experienced or 
temporary staff. The purpose of this analysis is to evaluate how increased 
service times impact system performance and staffing requirements. The 
simulation is run under the same conditions as the baseline model, allowing
for direct comparison and identification of the number of cashiers needed
to maintain acceptable wait times. 