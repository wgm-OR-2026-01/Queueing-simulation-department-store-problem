%[text] # Run samples of the ServiceQueue simulation
%[text] Collect statistics and plot histograms along the way.
PictureFolder = "Pictures";
mkdir(PictureFolder); %[output:02aaa248]
%%
%[text] ## Set up
%[text] We'll measure time in minutes (need to change code from hours to minutes \*\*\*\*\*)
%[text] Arrival rate:  1 every 75 seconds = 1 every 1.25 minutes = 1 per 1.25 minutes = 1/1.25 = 0.8
%[text] These peak periods last about four hours. So we need to multiply by 4 hours = 4(60) = 240 minutes
%[text] lambda (4 hours)(60 min) = 0.8(240) = 192 total number of customers in 4 hours or 240 minutes
%[text] 
lambda = 0.8;
%[text] Departure (service) rate:  6.5 minutes  for each customer to be served
%[text] mu = 1/6.5 = 0.1538
mu = 0.1538;
%[text] 
%[text] 
%[text] ## Calculating the Number of Servers to Iterate Thru
%[text] k = s: number of servers
%[text] We are told that  there’s room for up to eight registers in the checkout area.
%[text] Since we can have up to 8 servers, we know that k can go thru 1 to 8.
%[text] However, we can further narrow down our code using some theory.
%[text] service rate: k\*mu 
%[text] lambda: cutomer arrival rate
%[text] We want the service rate to be greater than the customer arrival rate to be successful.
%[text] k \*mu \<= lambda means that the system is not stable   --      means customers are arriving faster than departing
%[text] k \*mu \> lambda means that the system is  stable    --     means customers are departing faster than arriving 
%[text] 5\*mu = 5(0.1538) =  0.769 \< .8 = lambda   --     not a stable system 
%[text] 6\* mu = 6(0.1538)  = 0.9228 \> .8 = lambda    --   system is stable
%[text] This is why we will iterate our loop for k = 6:8.       
%[text] 
%%
%[text] rho = (lambda)/(k\*mu) \< 1
%[text] is our desired ratio to keep the system stable.
%[text] We will need 
%[text]  k \> (lambda)/(mu) 
%[text] many servers for a stable system.
%[text]  k \> (0.8)/(0.1538)  \\approx 5.2
%[text] The minimum number of servers that we will need is 6 for our system to be stable.
%[text] 
%%
%[text] Run 100 samples of the queue.
%[text] The number of samples represents the number of shifts that we simulate.
NumSamples = 100;                                            
%[text] Each sample is run up to a maximum time.
%[text] Run each sample of the queue for a simulated time of 4 hours  to match the given length of the peak period.
%[text] These peak periods last about four hours. So we need to multiply by 4 hours = 4(60) = 240 minutes
MaxTime = 960;              % only change is the run time of the simulation
%[text] Make a log entry every so often
%[text] Change  the LogInterval to 1 every 5 minutes.  
LogInterval = 5/60;
%%
%[text] ## Numbers from theory for M/M/1 queue
%[text] 
%[text] The Formulas Used for P\_0 and P\_n
%[text] \\$\\f{1}{P\_0} = \\sum \\limits ^{k-1}\_{n=0} \\f{(\\f{\\lambda}{\\mu})^n}{n!} + \\f{1}{k!}(\\f{\\lambda}{\\mu})^k\\cdot \\f{1}{1-\\f{\\lambda}{k\\mu}}\\$
%[text] \\$P\_{n+1 } =  P\_n   (\\f{\\lambda\_n}{mu\_{n+1}})     \\$
%[text] You may find the formulas for L\_q, W\_q, L, and W in the code and straight forward.
%[text] 
%[text] Update the calculation of the 𝑃𝑛 ’s so that it works  for any number 𝑠 of registers (serving stations).
%[text] 
%[text] # Theoretical Calcultaions for Calculations of P\_n, L\_q, W\_q, L, W
%[text] 
%[text] The n values are calucated based upon the k values. 
%[text] n \< k : There are empty registers. Each new customer goes straight to a cashier.
%[text] n \\geq k : All registers are full. Any new customer must wait.
%[text] k = 6 , 7, 8
%[text] n = 0, 1, 2, 3, 4, 5, 6
%[text] set up keeps us in the n \< k state as much as possible with the only concern when 6 = n \\geq k = 6 
%[text] This is why  n = 1:6.  
%[text] 



for k = 6:8 %[output:group:48e37f5c]
    P = zeros(1, k-1);    % initiaizes the row vector the first time
    % clears row vector so I can use this again for the next graph
    % thereafter

     fprintf("***********************************************************************");    %[output:31bfa214] %[output:375b326c] %[output:80c43d15]
     fprintf("**                                                                   **"); %[output:3d43f3e4] %[output:92b301c8] %[output:709ebe6e]
     fprintf("**          Theoretical Calculations for P_n, L_q, W_q, L, W         **"); %[output:8d826c7f] %[output:3b692bea] %[output:0bd6c21c]
     fprintf("**                      " + "number of servers k = " + k+ "                      **"); %[output:3ab88b59] %[output:941dab7f] %[output:40c4d5fd]
     fprintf("**                                                                   **"); %[output:6c3cb95a] %[output:7a7182bd] %[output:186be3a7]
     fprintf("***********************************************************************");  %[output:0208606c] %[output:5d52c996] %[output:35cf5e78]


    disp(" ");  %[output:092bb1de] %[output:7b77f549] %[output:19ed4b9f]

    %fprintf("The current number of servers in the theoretical calculations is\nk = %d", k);
    

j = 0:(k-1);
terms = ((lambda / mu).^j) ./ factorial(j);
first = sum(terms);
second = (1 / factorial(k)) * (lambda / mu).^k * (1 / (1 - lambda / (k * mu)));
P0 = 1/(first + second);
fprintf("P(0) = %f\n", P0); %[output:08dcd782] %[output:314a84c8] %[output:324e3e8d]
P(1) = P0;


%%%  FIND A WAY TO SAVE ALL THE P(Wq??? > 5) \leq .1   info and just print
%%%  that here ***************

nMax = k-1; 
    fprintf("The probability that some cashiers are busy but there is no line:"); %[output:38e370e9] %[output:72cbf97d] %[output:102307de]
for n = 1:nMax    
    
        
        if  n < k             % 1 <= n <= k 
            
            P(n+1) = (1./ factorial(n))*((lambda / mu).^n)*(P0);   
            fprintf("P(%d) = %f\n", n, P(n+1)); %[output:26dc05ae] %[output:9c8ae4ca] %[output:875c1461]
 
        else     %  k <= n                   
        
        fprintf("The probability that all cashiers are busy \n" + ...
            "and customers are either being served or waiting in line:");
        P(n+1) = (1./ factorial(k) * k^(n-k))*((lambda / mu).^n)*(P0);    
        fprintf("P(%d) = %f\n", n, P(n+1));
    
        end
 
end 
      
      top = ((lambda / mu).^k)*(lambda / (k*mu)); 
      bottom = factorial(k) *(1- (lambda / (k*mu))).^2;
      Lq = (top./ bottom)*(P0);                           % expected number of customers waiting
      fprintf("The number of customers waiting, L_q(%d): %f\n", n,   Lq); %[output:5ec71185] %[output:266f758c] %[output:3c6d3671]
      L = Lq + (lambda./mu);                          
      fprintf("The expected number of customers in the system, L(%d): %f\n", n,  L);                 %[output:61077729] %[output:25e0de42] %[output:1dd6cd7e]
      Wq = (Lq./ lambda);                           
      fprintf("The expected time customers wait before beginning service, W_q(%d): %f\n", n,  Wq);    %[output:5457eb56] %[output:3584c254] %[output:7a3870a5]
      W = (L./ lambda);                           
      fprintf("The  expected time customers spend in the system, including waiting time and service time, W(%d): %f\n", n,  W);  %[output:465f5cfd] %[output:3b3e95d3] %[output:7516ff1b]
              



    disp(" ");  % this is also needed for aesthetic reasons  %[output:0e3bdf93] %[output:188a9c2c] %[output:185d039b]
    disp(" "); %[output:4cae4bdc] %[output:406c3077] %[output:1306c3db]



%[output:group:48e37f5c]
%%
%[text] # Running simulation samples
%[text] This is the most time consuming calculation in the script, so let's put it in its own section.  That way, we can run it once, and more easily run the faster calculations multiple times as we add features to this script.
%[text] Reset the random number generator.  This causes MATLAB to use the same sequence of pseudo-random numbers each time you run the script, which means the results come out exactly the same.  This is a good idea for testing purposes.  Under other circumstances, you probably want the random numbers to be truly unpredictable and you wouldn't do this.
rng("default");
%[text] We'll store our queue simulation objects in this list.
QSamples = cell([NumSamples, 1]);
%[text] The statistics come out weird if the log interval is too short, because the log entries are not independent enough.  So the log interval should be long enough for several arrival and departure events happen.

s = k; 


     fprintf("***********************************************************************");    %[output:084d163a] %[output:035f4a4e] %[output:51083173]
     fprintf("**                                                                   **"); %[output:6022f168] %[output:20fa5b6b] %[output:688e1c16]
     fprintf("**          Simulation Calculations for P_n, L_q, W_q, L, W          **"); %[output:6808d418] %[output:4c769c65] %[output:4cb52585]
     fprintf("**                      " + "number of servers k = " + k+ "                      **"); %[output:7c83bc05] %[output:744ad40d] %[output:1a7907d0]
     fprintf("**                                                                   **"); %[output:87220a74] %[output:02b225d9] %[output:1e3e776b]
     fprintf("***********************************************************************");       %[output:747a079e] %[output:80ddafa8] %[output:5d57a3db]

    disp("");
for SampleNum = 1:NumSamples
    fprintf("Working on sample %d\n", SampleNum); %[output:75cee2ce] %[output:0115b2f5] %[output:82d96a0f]
    q = ServiceQueue( ...
        ArrivalRate=lambda, ...
        DepartureRate=mu, ...
        NumServers=s, ...
        LogInterval=LogInterval);
    q.schedule_event(Arrival(random(q.InterArrivalDist), Customer(1)));
    run_until(q, MaxTime);
    QSamples{SampleNum} = q;
end

%[output:group:21d6a552]
%%
%[text] ## Collect measurements of how many customers are in the system
%[text] Count how many customers are in the system at each log entry for each sample run.  There are two ways to do this.  You only have to do one of them.
%[text] ### Option one: Use a for loop.
NumInSystemSamples = cell([NumSamples, 1]);
for SampleNum = 1:NumSamples
    q = QSamples{SampleNum};
    % Pull out samples of the number of customers in the queue system. Each
    % sample run of the queue results in a column of samples of customer
    % counts, because tables like q.Log allow easy extraction of whole
    % columns like this.
    NumInSystemSamples{SampleNum} = q.Log.NumWaiting + q.Log.NumInService;
end



%%
%[text] # System Calculation for L\_q
%[text] (Number of Customers Waiting in the System)
%%

NumWaitingInSystemSamples = cell([NumSamples, 1]);
for SampleNum = 1:NumSamples
    q = QSamples{SampleNum};
    NumWaitingInSystemSamples{SampleNum} = q.Log.NumWaiting;
end
NumWaitingInSystemSamples = cellfun(@(q) q.Log.NumWaiting, ...
    QSamples, UniformOutput= false);

NumWaiting = vertcat(NumWaitingInSystemSamples{:});
meanNumWaiting = mean(NumWaiting);
%fprintf("Mean number waiting (L_q): %f\n", meanNumWaiting);


%%
%[text] # 
%[text] # System W\_q  and L  Calculation 
%[text] 
%[text] Ricky, the customer relations specialist, says that during these peak periods, they’d like to have  no more than 10% of customers wait more than 5 minutes before reaching a cashier.
%[text] customer waiting in the queue (W\_q)
%[text] P(W\_q \> 5) \\le 0.10
%[text] %% \\$\\$P(W\_q \> t) = C(s, \\rho) e^{-s\\mu(1-\\rho)t}\\$\\$
%%
WaitingTimeInSystemSamples = cell([NumSamples, 1]);
for SampleNum = 1:NumSamples
    q = QSamples{SampleNum};
    % The next command has many parts.
    %
    % q.Served is a row vector of all customers served in this particular
    % sample.
    % The ' on q.Served' transposes it to a column.
    %
    % The @(c) ... expression below says given a customer c, compute its
    % departure time minus its arrival time, which is how long c spent in
    % the system.
    %
    % cellfun(@(c) ..., q.Served') means to compute the time each customer
    % in q.Served spent in the system, and build a column vector of the
    % results.
    %
    % The column vector is stored in TimeInSystemSamples{SampleNum}.
    WaitingTimeInSystemSamples{SampleNum} = ...
        cellfun(@(c) c.BeginServiceTime - c.ArrivalTime , q.Served');
end
WaitingTimeInSystemSamples = cellfun( ...
    @(q) cellfun(@(c) c.BeginServiceTime - c.ArrivalTime , q.Served'), ...
    QSamples, ...
    UniformOutput=false);
ExpectedWaitingTime = vertcat(WaitingTimeInSystemSamples{:});
meanWaitTime = mean(ExpectedWaitingTime);
%fprintf("Mean waiting time (W_q): %f\n", meanWaitTime);
%%
%[text] ### Option two: Map a function over the cell array of ServiceQueue objects.
%[text] The `@(q) ...` expression is shorthand for a function that takes a `ServiceQueue` as input, names it `q`, and computes the sum of two columns from its log.  The `cellfun` function applies that function to each item in `QSamples`. The option `UniformOutput=false` tells `cellfun` to produce a cell array rather than a numerical array.
NumInSystemSamples = cellfun( ...
    @(q) q.Log.NumWaiting + q.Log.NumInService, ...
    QSamples, ...
    UniformOutput=false);
%[text] ## Join numbers from all sample runs.
%[text] `vertcat` is short for "vertical concatenate", meaning it joins a bunch of arrays vertically, which in this case results in one tall column.
NumInSystem = vertcat(NumInSystemSamples{:});
%[text] MATLAB-ism: When you pull multiple items from a cell array, the result is a "comma-separated list" rather than some kind of array.  Thus, the above means
%[text] `NumInSystem = vertcat(NumInSystemSamples{1}, NumInSystemSamples{2}, ...)`
%[text] which concatenates all the columns of numbers in NumInSystemSamples into one long column.
%[text] This is roughly equivalent to "splatting" in Python, which looks like `f(*args)`.
%%
%[text] ## Pictures and stats for number of customers in system
%[text] Print out mean number of customers in the system.
meanNumInSystem = mean(NumInSystem);
fprintf("Mean number in system: %f\n", meanNumInSystem); %[output:109bb632] %[output:14cc19a7] %[output:92483fd7]
%[text] Make a figure with one set of axes.
fig = figure(); %[output:39e03126] %[output:509f0b6f] %[output:623d1abc]
t = tiledlayout(fig,1,1); %[output:39e03126] %[output:509f0b6f] %[output:623d1abc]
ax = nexttile(t);
%[text] MATLAB-ism: Once you've created a picture, you can use `hold` to cause further plotting functions to work with the same picture rather than create a new one.
hold(ax, "on");
%[text] Start with a histogram.  The result is an empirical PDF, that is, the area of the bar at horizontal index n is proportional to the fraction of samples for which there were n customers in the system.  The data for this histogram is counts of customers, which must all be whole numbers.  The option `BinMethod="integers"` means to use bins $(-0.5, 0.5), (0.5, 1.5), \\dots$ so that the height of the first bar is proportional to the count of 0s in the data, the height of the second bar is proportional to the count of 1s, etc. MATLAB can choose bins automatically, but since we know the data consists of whole numbers, it makes sense to specify this option so we get consistent results.
h = histogram(ax, NumInSystem, Normalization="probability", BinMethod="integers");
%[text] Plot $(0, P\_0), (1, P\_1), \\dots$.  If all goes well, these dots should land close to the tops of the bars of the histogram.
% Since I only want certain values from the matrix P, I am collecting them
% so that the graph will work properly
%if s == 6
   % PP = P(1:7);
    
%elseif s == 7
    %PP = P(8:14);
    
%elseif s == 8
    %PP = P(15:21);
    
%end
    fprintf("These are the y axis P values:"); %[output:603993fa] %[output:3b7fbf88] %[output:513dd4bb]
    disp(P); %[output:1d53fe13] %[output:11d87885] %[output:9a7681f6]
    %fprintf("This is PP:");
    %disp(PP);

plot(ax, 0:nMax, P, 'o', MarkerEdgeColor='k', MarkerFaceColor='r'); %[output:39e03126] %[output:509f0b6f] %[output:623d1abc]
%[text] Add titles and labels and such.
title(ax, "Number of customers in the system when s = " + s);
xlabel(ax, "Count");
ylabel(ax, "Probability");
legend(ax, "simulation", "theory");
%[text] Set ranges on the axes. MATLAB's plotting functions do this automatically, but when you need to compare two sets of data, it's a good idea to use the same ranges on the two pictures.  To start, you can let MATLAB choose the ranges automatically, and just know that it might choose very different ranges for different sets of data.  Once you're certain the picture content is correct, choose an x range and a y range that gives good results for all sets of data.  The final choice of ranges is a matter of some trial and error.  You generally have to do these commands *after* calling `plot` and `histogram`.
%[text] This sets the vertical axis to go from $0$ to $0.3$.
ylim(ax, [0, 0.18]);   % ******** I changed this from .3 to .18
%[text] This sets the horizontal axis to go from $-1$ to $21$.  The histogram will use bins $(-0.5, 0.5), (0.5, 1.5), \\dots$ so this leaves some visual breathing room on the left.
xlim(ax, [-1, 15 ]);      % ******** I changed this from 21 to 15
%[text] MATLAB-ism: You have to wait a couple of seconds for those settings to take effect or `exportgraphics` will screw up the margins.
pause(2);
%[text] Save the picture.
exportgraphics(fig, PictureFolder + filesep + "Number in system histogram.pdf");
exportgraphics(fig, PictureFolder + filesep + "Number in system histogram.svg"); %[output:group:4fad17c0]
%%
%[text] ## Collect measurements of how long customers spend in the system
%[text] This is a rather different calculation because instead of looking at log entries for each sample `ServiceQueue`, we'll look at the list of served  customers in each sample `ServiceQueue`.
%[text] ### Option one: Use a for loop.
TimeInSystemSamples = cell([NumSamples, 1]);
for SampleNum = 1:NumSamples
    q = QSamples{SampleNum};
    % The next command has many parts.
    %
    % q.Served is a row vector of all customers served in this particular
    % sample.
    % The ' on q.Served' transposes it to a column.
    %
    % The @(c) ... expression below says given a customer c, compute its
    % departure time minus its arrival time, which is how long c spent in
    % the system.
    %
    % cellfun(@(c) ..., q.Served') means to compute the time each customer
    % in q.Served spent in the system, and build a column vector of the
    % results.
    %
    % The column vector is stored in TimeInSystemSamples{SampleNum}.
    TimeInSystemSamples{SampleNum} = ...
        cellfun(@(c) c.DepartureTime - c.ArrivalTime, q.Served');
end

%[text] ### Option two: Use `cellfun` twice.
%[text] The outer call to `cellfun` means do something to each `ServiceQueue` object in `QSamples`.  The "something" it does is to look at each customer in the `ServiceQueue` object's list `q.Served` and compute the time it spent in the system.
TimeInSystemSamples = cellfun( ...
    @(q) cellfun(@(c) c.DepartureTime - c.ArrivalTime, q.Served'), ...
    QSamples, ...
    UniformOutput=false);
%[text] ### Join them all into one big column.
TimeInSystem = vertcat(TimeInSystemSamples{:});
%fprintf("Total time customer spends in system (W): %f\n", TimeInSystem);
%%
%[text] ## Pictures and stats for time customers spend in the system
%[text] Print out mean time spent in the system.
meanTimeInSystem = mean(TimeInSystem);
fprintf("Mean time in system: %f\n", meanTimeInSystem); %[output:17b95a6e] %[output:748d7df6] %[output:0d1da693]
%[text] Make a figure with one set of axes.
fig = figure(); %[output:65327210] %[output:740ae506] %[output:39ca9a5f]
t = tiledlayout(fig,1,1); %[output:65327210] %[output:740ae506] %[output:39ca9a5f]
ax = nexttile(t);
%[text] This time, the data is a list of real numbers, not integers.  The option `BinWidth=...` means to use bins of a particular width, and choose the left-most and right-most edges automatically.  Instead, you could specify the left-most and right-most edges explicitly.  For instance, using `BinEdges=0:0.5:60` means to use bins $(0, 0.5), (0.5, 1.0), \\dots$
h = histogram(ax, TimeInSystem, Normalization="probability", BinWidth=5/60);
%[text] Add titles and labels and such.
title(ax, "Time in the system");
xlabel(ax, "Time");
ylabel(ax, "Probability");
%[text] Set ranges on the axes.
ylim(ax, [0, 0.02]);            % *********changed this from .2 to .02
xlim(ax, [0, 3.0]);             % *********changed this from 2 to 3
%[text] Wait for MATLAB to catch up.
pause(2);
%[text] Save the picture.
exportgraphics(fig, PictureFolder + filesep + "Time in system histogram.pdf");
exportgraphics(fig, PictureFolder + filesep + "Time in system histogram.svg"); %[output:group:0eab3473]
%%





disp(" "); %[output:9b959381] %[output:3be219bb] %[output:7f4453af]
fprintf("Here are the averages of the following values."); %[output:86d2e856] %[output:3eb42ba4] %[output:02e11338]
%fprintf("The current number of servers in the simulation calculations is\ns = %d", s);
fprintf("Number of Customers in system (L): %f\n", mean(NumInSystem)); %[output:130aa806] %[output:8491a73a] %[output:1b9a6429]
fprintf("Total time customer spends in system (W): %f\n", mean(TimeInSystem)); %[output:01eacda0] %[output:6c18579e] %[output:9ea42615]
fprintf("Number of customers waiting (L_q): %f\n", mean(NumWaiting)); %[output:7d021786] %[output:792832f2] %[output:68a46f42]
fprintf("Customer Wait time before service (W_q): %f\n", meanWaitTime); %[output:6741a305] %[output:9989961c] %[output:8372b3f2]




disp(" "); %[output:55e0259a] %[output:3410d47e] %[output:2ea1ecee]
disp(" "); %[output:7dec1d9f] %[output:62d31f09] %[output:26503bb5]
disp(" "); %[output:06e5d3e0] %[output:322af45d] %[output:3c766584]

     fprintf("*****************************************************************************");    %[output:867e3901] %[output:8c0b332d] %[output:4e8abf7e]
     fprintf("**                                                                         **"); %[output:5631dcd5] %[output:8800e3f9] %[output:3e06d1cd]
     fprintf("**            Comparing Theoretical and Simulation Calculations            **"); %[output:0712e8fd] %[output:22061dd9] %[output:1694e765]
     fprintf("**                         " + "number of servers k = " + k+ "                         **"); %[output:3bdefb70] %[output:6d3bff00] %[output:5f28097b]
     fprintf("**                                                                         **"); %[output:1972b98f] %[output:9f4f8e90] %[output:7d654a85]
     fprintf("*****************************************************************************"); %[output:2c91879d] %[output:3753138b] %[output:2bf85785]

Error_1 = (abs(Lq - mean(NumWaiting))./Lq)*100;
Error_2 = (abs(L - mean(NumInSystem))./L)*100;
Error_3 = (abs(Wq - mean(ExpectedWaitingTime))./Wq)*100;
Error_4 = (abs(W - mean(TimeInSystem))./W)*100;


% Header with fixed spacing
fprintf('%-18s %-18s %-18s %-18s\n', 'Value Type', 'Theoretical', 'Simulation', 'Error Percent'); %[output:637feb61] %[output:95c2eed1] %[output:3f3104c1]

% Data rows using fixed-width floats
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'Lq', Lq, mean(NumWaiting), Error_1); %[output:81cf9d01] %[output:4f5bf76b] %[output:299de24f]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'L', L, mean(NumInSystem), Error_2); %[output:9837fd27] %[output:6ff374f7] %[output:29e65669]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'Wq', Wq, mean(ExpectedWaitingTime), Error_3); %[output:7378f90d] %[output:2bc26e38] %[output:0742ccf2]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'W', W, mean(TimeInSystem), Error_4); %[output:8ecc4d2f] %[output:3192541a] %[output:337410ae]



%fprintf("Customer Wait time before service (W_q) matrix printed out: ");
%fprintf("(W_q): %f\n ", ExpectedWaitingTime);

longWaits = ExpectedWaitingTime(ExpectedWaitingTime > 5);
disp(" ");    %[output:18864f5c] %[output:72d6fd2e] %[output:3036df99]

%fprintf("These are the wait times that are greater than 5 minutes:");
%fprintf("(W_q): %f\n ",longWaits);
fprintf("These are the total number of customer wait times:  " + length(ExpectedWaitingTime)); %[output:615eea0a] %[output:638fe84b] %[output:77c2cf61]
fprintf("These are the total number of customer wait times W_q > 5 minutes:  " + length(longWaits)); %[output:1ea6d50a] %[output:8d7cedd8] %[output:33063950]
P_of_Wq_greatherthan_5min = length(longWaits)/length(ExpectedWaitingTime);

disp(" ");   %[output:9f90231f] %[output:228897f5] %[output:5ba4e189]
fprintf(2,"The theoretical Wq has us waiting  " + Wq + "  minutes."); %[output:751b01d3] %[output:9d3b0304] %[output:6982ddf2]
fprintf("When s = " +s+", P( W_q > 5 minutes) = " + P_of_Wq_greatherthan_5min); %[output:08152a2b] %[output:180b3b7d] %[output:56f75ea0]
disp(" ");  %[output:0f84fb57] %[output:01719c83] %[output:21155a46]

if s == 6
    fprintf(2,"P(W_q > 5 minutes) > 10 percent "); %[output:6d119e1d]
elseif s == 7
   fprintf(2,"P(W_q > 5 minutes) < 10 percent");   %[output:18d5376d]
   fprintf(2, "The minimum number of servers recommended to meet the goal is s = 7.");  %[output:89b9413e]
else 
   fprintf(2,"P(W_q > 5 minutes) < 10 percent");  %[output:2b460479]
end









disp(" "); %[output:27278128] %[output:82e84a63] %[output:3cb8d803]
disp(" "); %[output:0e242b39] %[output:516eb98d] %[output:87fc373e]
disp(" "); %[output:277cde13] %[output:5069fa2f] %[output:566a9f7f]
disp(" "); %[output:3ffbb453] %[output:70a80eb6] %[output:5899fe8b]
disp(" "); %[output:8967faed] %[output:3d5b141c] %[output:0cfe22b6]



     %P = zeros(1, k-1);    % clears row vector so I can use this again for the next graph
end % this ends the s = k loop %[output:group:59468c4c]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":52.5}
%---
%[output:02aaa248]
%   data: {"dataType":"warning","outputData":{"text":"Warning: Directory already exists."}}
%---
%[output:31bfa214]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:3d43f3e4]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:8d826c7f]
%   data: {"dataType":"text","outputData":{"text":"**          Theoretical Calculations for P_n, L_q, W_q, L, W         **","truncated":false}}
%---
%[output:3ab88b59]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 6                      **","truncated":false}}
%---
%[output:6c3cb95a]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:0208606c]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:092bb1de]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:08dcd782]
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.003204\n","truncated":false}}
%---
%[output:38e370e9]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:26dc05ae]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.016664\nP(2) = 0.043340\nP(3) = 0.075146\nP(4) = 0.097719\nP(5) = 0.101658\n","truncated":false}}
%---
%[output:5ec71185]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(5): 4.314453\n","truncated":false}}
%---
%[output:61077729]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(5): 9.516013\n","truncated":false}}
%---
%[output:5457eb56]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(5): 5.393066\n","truncated":false}}
%---
%[output:465f5cfd]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(5): 11.895016\n","truncated":false}}
%---
%[output:0e3bdf93]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:4cae4bdc]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:084d163a]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:6022f168]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:6808d418]
%   data: {"dataType":"text","outputData":{"text":"**          Simulation Calculations for P_n, L_q, W_q, L, W          **","truncated":false}}
%---
%[output:7c83bc05]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 6                      **","truncated":false}}
%---
%[output:87220a74]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:747a079e]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:75cee2ce]
%   data: {"dataType":"text","outputData":{"text":"Working on sample 1\nWorking on sample 2\nWorking on sample 3\nWorking on sample 4\nWorking on sample 5\nWorking on sample 6\nWorking on sample 7\nWorking on sample 8\nWorking on sample 9\nWorking on sample 10\nWorking on sample 11\nWorking on sample 12\nWorking on sample 13\nWorking on sample 14\nWorking on sample 15\nWorking on sample 16\nWorking on sample 17\nWorking on sample 18\nWorking on sample 19\nWorking on sample 20\nWorking on sample 21\nWorking on sample 22\nWorking on sample 23\nWorking on sample 24\nWorking on sample 25\nWorking on sample 26\nWorking on sample 27\nWorking on sample 28\nWorking on sample 29\nWorking on sample 30\nWorking on sample 31\nWorking on sample 32\nWorking on sample 33\nWorking on sample 34\nWorking on sample 35\nWorking on sample 36\nWorking on sample 37\nWorking on sample 38\nWorking on sample 39\nWorking on sample 40\nWorking on sample 41\nWorking on sample 42\nWorking on sample 43\nWorking on sample 44\nWorking on sample 45\nWorking on sample 46\nWorking on sample 47\nWorking on sample 48\nWorking on sample 49\nWorking on sample 50\nWorking on sample 51\nWorking on sample 52\nWorking on sample 53\nWorking on sample 54\nWorking on sample 55\nWorking on sample 56\nWorking on sample 57\nWorking on sample 58\nWorking on sample 59\nWorking on sample 60\nWorking on sample 61\nWorking on sample 62\nWorking on sample 63\nWorking on sample 64\nWorking on sample 65\nWorking on sample 66\nWorking on sample 67\nWorking on sample 68\nWorking on sample 69\nWorking on sample 70\nWorking on sample 71\nWorking on sample 72\nWorking on sample 73\nWorking on sample 74\nWorking on sample 75\nWorking on sample 76\nWorking on sample 77\nWorking on sample 78\nWorking on sample 79\nWorking on sample 80\nWorking on sample 81\nWorking on sample 82\nWorking on sample 83\nWorking on sample 84\nWorking on sample 85\nWorking on sample 86\nWorking on sample 87\nWorking on sample 88\nWorking on sample 89\nWorking on sample 90\nWorking on sample 91\nWorking on sample 92\nWorking on sample 93\nWorking on sample 94\nWorking on sample 95\nWorking on sample 96\nWorking on sample 97\nWorking on sample 98\nWorking on sample 99\nWorking on sample 100\n","truncated":false}}
%---
%[output:109bb632]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 9.155487\n","truncated":false}}
%---
%[output:603993fa]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:1d53fe13]
%   data: {"dataType":"text","outputData":{"text":"    0.0032    0.0167    0.0433    0.0751    0.0977    0.1017\n\n","truncated":false}}
%---
%[output:375b326c]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:17b95a6e]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 11.439455\n","truncated":false}}
%---
%[output:65327210]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAcAAAAFQCAYAAAAoQ64wAAAQAElEQVR4AeydX0hdWZ7vf8zbGGNmYFBa7WZ0hHmo0TAwoiDoiwFpCQUJM6BjM5eqS5XDLbDvxDikoOmBgYRRa+hANWUCJQQchWkihCYgxIdREEw7lyLa\/VAX2zTpaKM03Y3a9mNPPqtcp48nx3P20eM++883ZJ2919+9fp+1z\/q6\/ux9\/uj3+icCIiACIiACKSTwR6Z\/IiACIiACIpBCAhLAFDZ6xmSdiIAIiECKCUgAU9z4Ml0EREAE0kxAApjm1pftaSYg20Ug9QQkgKm\/BQRABERABNJJQAKYznaX1SIgAmkmINsdAQmgw6APERABERCBtBGQAKatxWWvCIiACIiAI5BSAXS260MEREAERCDFBCSAKW58mS4CIiACaSYgAUxz6yfA9sPDQxscHLTm5ua3XE9Pj\/3sZz9z8aQhLSaX2y0uLrprcyy17I2NDfvud7\/rsnF+9epVm5qacv4ofcBudHTU9vb2olQt1UUEzkVAAngufMpcaQLV1dU2OztrW1tb9vDhQ1edsbEx519aWrI\/\/\/M\/d\/GkIa1LUOaP3t5edz2OpRSNmHz00Uf229\/+tpRsFUn7L\/\/yL7a2tlaRa+uiInBRBCSAF0VW5UaCACMXRn84zhldMcr65JNP3KiNkSPnxHPOqBFhovKk9+HEkZfwXMfIj3iOPg\/5PvzwQ3eN7DJ9XtJ9+9vftp\/\/\/Oc2Pz\/vRqm\/+93vXPQXX3xh1JEyGXW5wDcf5KFcwnGn1edNUiMfaXDkIS\/1w8+RNNhJ3UiL349ASYPz6bgOdaSu165dM9L5vKTD+bQc8cM02wauQThh5Od6lXG6qgj8gYAE8A8sdJYSAgcHB3bp0iVbX1+3zs5O+\/73v2\/vvfeePXnyxH7zm9\/Y+Pi4I8GoZ3t721ZXV93oknA6eBdZ5OMnP\/mJMbrzZSIg2VkYjX7ve9+zr3\/963bjxg03Sv3jP\/5jl4T6raysGCPZZ8+eOcEhImh9qCPXY0TM9anLzMyMtbW1uestLCxQnLMfUevr6zME8t69e\/bOO++4cOr0r\/\/6r27Kc3h42NWRulKfpqYmQ7wbGhpcWup569atTD0p\/Be\/+IW9ePHC5aMuLS0tjuOf\/MmfGNfheqSTE4FKEpAAVpK+rl0RApcvX7auri5DhOrr650oIA51dXVGB02lGOEw5dfe3m61tbUZ8djc3CS6qKMcysNxHjQfBVMn6oZoIIa7u7tOiEqtzwcffGDkRYgQMezAHsrBPoQQUcN2rotD7MmH2DKFTB7Cs93Lly8NUe3u7nYMYUk81+KIQ1Q5YoPnXVVVZYgm4XIiUAkCudeUAOYSkV8E3hCgM2c0yOiFqTtGioyWggoZHT0d\/puiSv6PaORmKqU+1BVHGYgZ9WdUiB9hwi5GvwghgojIIbiMgkmDCCKKfuqUsGxHXRBmRsSU\/e677xr+oGyyy9K5CFSSgASwkvR17cgS8CM3pgLZYOPd5ORkRepcSn0QMzb9UGemJ6mwn85E2BiR\/uAHP3DTvQgi8Tg28ZAHAWRkyJGpU+KyHXVhVEfZpPeOUWZ2Op2LQNQJSACj3kLlrJ\/KCkyAURGjI0ZJTBcygmK0wzFwIWVMWEp92LTiN5sMDQ25dU4\/IvXlsJaHECKIVBMb\/YYY0nznO98h2PKNRlkDZK1weXnZrR1mX89l0ocIxISABDAmDaVqhk+AdTCEg+lEphIZ8TBKKldNEBpElmlWxOdXv\/pVwaKD1oeRGLs1mZpE4Fivu3Pnjluv4wJ+1Me1qQNhHD\/99FNDGBF67GX06+0lD1PAsGBkyAYeNghRPlOh7PpsbW2lKDkRiA0BCWBsmkoVLUaAzprpOATAp\/XTgUwJck4cm0J8Z82Upt\/sgQhwThj5SU8+ysSRl\/Bc56\/L0echH+e5Zebm5VqUzXURQermr0N5xHEkH+VRLmE4n464XOfLJR1ltra25iYxRC07ECakJQ+OMnw8dSAMx7m3Cz+OMNJyzPZTR8qkbF9\/bOCc9HIiUEkCEsBK0te1RSBEAn6aM3d0F2IVdCkRiBSBSAggzwSx44ypF\/4K5ouajxJrDaTB+bUY0pKHMBxp8uVVmAiknUD2qC17dJd2LqmwX0bmJRAJAWSnGc8+MXXCugRrIrm15e0RT58+dQ\/T8oDv9PS0W4Bn\/WFgYMC9ioqHfj\/77DPz4phbhvwiIAIiIAIi4AlUXAAZ\/bGbzO82Y10CP+G+khx5MwZbr3m2ioV3njvigVz+kmWdgTR+dxrn+dzr16+dgLKIL7cqFqtioO+B7oFy3wP0s\/n63yiGVVwAPRQvgPjZXXZ0dMTpCcco0S+e7+\/vu7dcZCdAEBFGBDI73MyMRrl9+7Z75yLTrXKDYjEoBvoe6B4o9z1AP0t\/m9sHR9EfGQE8LxzWAj\/++GO7e\/eue3VVbnk0yPPnz21iYsK9d5GdaElzIyMjzuwk20ibyc7ZRN3DaWjPNNjov5v0s\/S3rjOK+EdkBDD7NUo8e8VUZy67nZ0dt+5HeE1NjfFGCs5ZH3z\/\/fft888\/N7ZbE3aao+zOzk73cHDSjh0dHc7sJNtIm5VqJ3ni6GRncr6naWtL1xHF4KPiAsiUJi\/V9QLIC3rxE57NjxfuMr3J1CjvMWQ9kDU\/xI8HeOfm5vKO\/LLL0LkIiIAIiIAIeAIVF0AqwuuaGN3xGANH\/ITzSAOOc0Z2\/f39buTGT6\/wZgvC+WkV3l7Buh\/5cWndBdrY2GhMtXCETVId9snO5LTuxbZnNDilwcZokC6tFpEQQEZ7zB\/zGARH\/JjB7k4c5zjOSZP7ZgnCsh1voyB92lxavmSyM1l3dhraMw02xvGujIQAxhGc6iwCIiACIhBtAsVqJwEsRkjxIiACIiACiSQgAUxks8ooERABERCBYgQkgMUIxTledRcBERABETiVgATwVDSKEAEREAERSDIBCWCSW1e2pZmAbBcBEShCQAJYBJCiRUAEREAEkklAApjMdpVVIiACaSYg2wMRkAAGwqREIiACIiACSSMgAUxai8oeERABERCBQAQSKoCBbFciERABERCBFBOQAKa48WW6CIiACKSZgAQwza2fUNtllgiIgAgEISABDEJJaURABERABBJHQAKYuCaVQSKQZgKyXQSCE5AABmellCIgAiIgAgkiIAFMUGPKFBEQARFIM4FSbZcAlkpM6UVABERABBJBIFQB3Nvbs56eHmtubrbBwUE7PDx8CyJhxJGGtOTJToT\/+vXrtrGxkQkeHR11ZZJnamoqE64TERABERABETiNQKgCOD4+bgMDA7a+vu7qs7q66o7ZHzMzM1ZfX29bW1vW3t5u8\/PzmWhE79q1a\/bq1atM2OLioq2trRllPXnyxGZnZ0+IYyZhGk5kowiIgAiIQGACoQkgIzeEqqWlxaqrq627u9sWFhZOVJTR3\/LyspGGiL6+PsNPOPkfPXpkDx48sCtXrhDtXF1dndXU1LhzPogjjPN87vnz504sX79+nS9aYSIgAiIgAiUSoD9lELK9vV1izsomD00AMROhyhannZ2dvNOgXgDJA9CjoyOrra21yclJu3TpEsEZ19raanfv3jVGhvfu3bO5uTmXNpMg5+T+\/ftu+vXx48c5MfKKQKwJqPIiUDEC9KcsXd2+fbtidTjLhUMVwLNUsFge1vwQvpWVFbtz545985vfLDgFOjEx4aZJb968WaxoxYuACIiACAQgQH\/K8tPIyEiA1NFJEqoA7u\/v2+7ubsZ61vqYDs0EHJ9sbm4en5k1NDRYVVVVxp97QlqmUymnqanJGhsbDTHMTef9lNfZ2enS+TAdRUAERCDWBCpcefpd+tWOjo4K16S0y4cmgExhsqkFwWJNj7U91viyq4uIIWakIZw1QvyE48\/nmC6lLMpkqpQpU8LypVWYCIiACIiACHgCoQkgFxwbG3NrdG1tbW6nZ29vL8HGNCYOz9DQkLE2yCMNHPETfpobHh52ZVEmf4Gwy9SXe1oehYuACIiACIhAqALIKHBpack94sCGFo8fEcPhZ7THXDKPQXDET7h3bHphxMfRh01OTroyyePL8XE6ioAIiIAIiEA+AqEKYL4KKEwEREAEREAEKkFAAlgJ6rpmWQmoMBEQARE4CwEJ4FmoKY8IiIAIiEDsCUgAY9+EMkAE0kxAtovA2QlIAM\/OTjlFQAREQARiTEACGOPGU9VFQAREIM0Ezmu7BPC8BJVfBERABEQglgQkgLFsNlVaBERABETgvAQkgOclWMn8urYIiIAIiMCZCUgAz4xOGUVABERABOJMQAIY59ZT3dNMQLaLgAick4AE8JwAlV0EREAERCCeBCSA8Ww31VoERCDNBGR7WQhIAMuCUYWIgAiIgAjEjYAEMG4tpvqKgAiIgAiUhUBMBbAstqsQERABERCBFBOQAKa48WW6CIiACKSZgAQwza0fU9tVbREQAREoB4FQBXBvb896enqsubnZBgcH7fDw8C0bCCOONKQlT3Yi\/NevX7eNjY1M8OLioiuTPKOjo5lwnYiACIiACIjAaQRCFcDx8XEbGBiw9fV1V5\/V1VV3zP6YmZmx+vp629rasvb2dpufn89EI3rXrl2zV69enQi7f\/++URblHhwcnBDHTEKdiIAIJICATBCB8hEITQAZua2trVlLS4tVV1dbd3e3LSwsnLCE0d\/y8rJLQ0RfX5\/hJ5z8jx49sgcPHtiVK1eIdm5lZcX6+\/uttrbWlUt8a2uri8v38fz5cyeWr1+\/zhetMBEQAREQgRIJ0J8yCNne3i4xZ2WThyaAmFlTU2N1dXWcOrezs5N3GhSRdAnefAD06OjICdzk5KRdunTpTejJ\/1988YVdvXrVTYMWmwJltMgU6+PHj08WIp8IiIAIiMCZCNCf0q\/evn37TPmDZip3ulAFsNyVp7zNzU1j2pORIH+BMMpkTZC4fG5iYsJmZ2ft5s2b+aIVJgIiIAIiUCIB+lP61ZGRkRJzVjZ5qAK4v79vu7u7GYtZ62M6NBNwfIKoHZ9aQ0ODVVVVee9bR0aLvhzSkT47f24G4js7O62xsTE3Sn4REAEREIEzEKA\/pV\/t6Og4Q+7KZQlNAFmjY1ML4sSaHmt7rPFlm44YsjZIGsJZI8RPOP58rqury7788ktjjZCpUqZMEcV8aWMfJgNEQAREQATKRiA0AaTGY2NjNjc3Z21tbW6nZ29vL8E2NTXlHJ6hoSFjbZBHGjjiJ\/w0x4YXNsHw1weOXaa+3NPyKFwEREAEREAEQhVARoFLS0vuEQc2tHj8w8PDhsPPaI+5ZB6D4IifcO8QPEaPHH0YeUmP49yH6ygCCSIgU0RABMpMIFQBLHPdVZwIiIAIiIAInJmABPDM6JRRBERABEIioMtcCAEJ4IVgVaEiIAIiIAJRJyABjHoLqX4iIAIiIAIXQiAmAnghtqtQERABERCBFBOQAKa48WW6CIiACKSZgAQwza0fE9tVTREQARG4CAISwIug1SXe4AAAEABJREFUqjJFQAREQAQiT0ACGPkmUgVFIM0EZLsIXBwBCeDFsVXJIiACIiACESYgAYxw46hqIiACIpBmAhdtuwTwogmrfBEQAREQgUgSkABGsllUKREQAREQgYsmIAG8aMLnKV95RUAEREAELoyABPDC0KpgERABERCBKBOQAEa5dVS3NBOQ7SIgAhdMQAJ4wYBVvAiIgAiIQDQJhCqAe3t71tPTY83NzTY4OGiHh4dvUSGMONKQljzZifBfv37dNjY2soPd+ejoqOGcRx8iIAIiEFcCqncoBEIVwPHxcRsYGLD19XVn3Orqqjtmf8zMzFh9fb1tbW1Ze3u7zc\/PZ6IRvWvXrtmrV68yYf5kcXHxRFofrqMIiIAIiIAI5CMQmgAycltbW7OWlharrq627u5uW1hYOFEnRn\/Ly8suDRF9fX2Gn3DyP3r0yB48eGBXrlwhOuOIm56etm9961uZMJ2IgAiIgAiIQCECoQkglaipqbG6ujpOndvZ2ck7DdrS0uLi+dje3rajoyOrra21yclJu3TpEsEnHCPL9957z772ta+dCM\/nef78uTHyfP36db5ohYmACIiACJRIgP6UfpX+usSsFU0eqgBehKVMfVJub28vh6Lu\/v37bv3x8ePHRdMqgQiIgAiIQHEC9Kfs3bh9+3bxxBFKEaoA7u\/v2+7ubsZ81vqYDs0EHJ9sbm4en5k1NDRYVVVVxp97wjQq64RsmmEkyHmhjTATExM2OztrN2\/ezC1K\/ogQUDVEQATiRYD+lH51ZGQkVhUPTQCZwmRTC+LGmh5re6zxZdNCDFkbJA3hiBt+wvHnc0yLsmEGNzY2Zjdu3HBTpfnSEoagdnZ2WmNjI145ERABERCBcxKgP6Vf7ejoOGdJ4WYPTQAxC4Gam5uztrY2t9PTT1tOTU0ZjjRDQ0PG2iAjOo74CZcTARFIAwHZKALhEQhVABkFLi0tuUccGLl5M4eHhw2Hn9EeQ2lGdBzxE+5da2ur2xnK0Yf5I2Vkl+vDdRQBERABERCBXAKhCmDuxeUXAREQAREQAU8g7KMEMGziup4IiIAIiEAkCEgAI9EMqoQIiIAIiEDYBCSAYRMvdD3FiYAIiIAIhEZAAhgaal1IBERABEQgSgQkgFFqDdUlzQRkuwiIQMgEJIAhA9flREAEREAEokFAAhiNdlAtREAE0kxAtleEgASwIth1UREQAREQgUoTkABWugV0fREQAREQgYoQiIgAVsR2XVQEREAERCDFBCSAKW58mS4CIiACaSYgAUxz60fEdlVDBERABCpBQAJYCeq6pgiIgAiIQMUJSAAr3gSqgAikmYBsF4HKEZAAVo69riwCIiACIlBBAhLACsLXpUVABEQgzQQqbbsEsNItoOuLgAiIgAhUhECoAri3t2c9PT3W3Nxsg4ODdnh4+JbRhBFHGtKSJzsR\/uvXr9vGxoYLxk860uOmpqZcuD5EQAREQAREoBCBUAVwfHzcBgYGbH193dVpdXXVHbM\/ZmZmrL6+3ra2tqy9vd3m5+cz0YjetWvX7NWrV5kwXybpnzx5Yp999pktLi5m4iN9osqJgAiIgAhUjEBoAshIbW1tzVpaWqy6utq6u7ttYWHhhOGM\/paXl10aIvr6+gw\/4eR\/9OiRPXjwwK5cuUK0c5OTkzY8POzOm5qa7J133nHn+hABERABERCBQgRCE0AqUVNTY3V1dZw6t7Ozk3caFJF0Cd58bG9v29HRkdXW1hpid+nSpTeh+f+\/fPnSDg4OrK2tLX+CN6HPnz83Rp6vX79+49N\/EagYAV1YBBJDgP6UfpX+Ok5GlSyAjMRYcxsdHY2UndTr448\/trt37zqxPK1y9+\/fd+uPjx8\/Pi2JwkVABERABEogQH\/K3o3bt2+XkKvySUsWQEZiS0tLxvQkm05wV69ezWxKKWTS\/v6+7e7uZpKw1sd0aCbg+GRzc\/P4zKyhocGqqqoy\/nwnrA2+\/\/779vnnn1tra2u+JJmwiYkJm52dtZs3b2bCdCICIiACoRJI2MXoT+lXR0ZGYmVZyQLorevt7XUbVdh8wsaVoaEht7sTQcy3CQXhZFML4saaHmt7iKgvjyNiyNogafCzRoifcPz5HOL36aef2tzcXMGRn8+LoHZ2dlpjY6MP0lEEREAEROAcBOhP6Vc7OjrOUUr4Wc8kgAgYw13EDnfv3j1bWVlxgsg88PT0tDElmWvO2NiYEyrW6Bj9IaKk4dEFHOcIKWuDlMsRP+H5HPXg2s+ePXPrfuTB5RPgfPkVJgIiIAIikF4CJQsgwtbf3595VIERIENfP0pjpIefYy5Wwpg+3drachtafDy7OHH4KYf8ueUSh2OKk9Ejx+y0pPfOCyvp5URABERABEQgH4GSBZBCmEZkNMe5dwgjo0KOPkxHERABERABEYgqgcACiLCx+5N5XqY5OTLd6B1+jCy2YYU0cukmIOtFQAREIAoEAgugn7704sfRTzn6I1OXTEtGwTDVQQREQAREQAQKEQgsgL4QhBCh4+jDdBQBERCBYASUSgSiQyCwADIFyhrfj3\/848wLrf30pz8yRUq66JinmoiACIiACIhAfgKBBZARHyO\/v\/qrvzK\/k9NPffoj4aTLfymFioAIiIAIpJlA1GwPLIBRq7jqIwIiIAIiIALnIRBYAJnaZIrTT3fmOxJPuvNUSHlFQAREQAREIAwCgQWQqU2mOP10Z74j8aQLo+KxvIYqLQIiIAIiEBkCgQWQkZ02wUSm3VQRERABERCBcxIILICM7LQJ5py0lT3NBGS7CIhAxAgEFsCI1VvVEQEREAEREIFzETiTAPIrDEyHZm+EwU\/4uWqjzCIgAiKQRAKyKZIEShZARO6DDz448WsQbIjh540IJz6SlqpSIiACIiACIpBFoGQBPDo6ctlzfw3C+328S6QPERABERABEYgogZIFkM0w\/Er73\/7t32Z+9JYdovgJJ\/5tWxUiAiIgAiIgAtEiEFgAETkedGfdb3x83H7+858bP4GEnyP+ubm5jChGy0zVRgREQAREQAROEggsgIzseNCd9b7THPGkO3kJ+dJOQPaLgAiIQBQJBBbAi6w8G2fYRcpoklEmo81815uamjLS4BYXF08kIc\/169dtY2PjRLg8IiACIiACIpCPwJkEMFuIECPvColXvov7sJmZmcyu0vb2dpufn\/dRmSPC9vTpU+OHeB8+fGjT09OGcJKAuGvXrtmrV6\/wyomACESGgCoiAtElULIAMtJCiJ48eWI3btwwxIgpUc4HBgas1ClQRGx5edlaWlocpb6+PsNPuAs4\/lhZWbHLly9bVVWVtbW12cHBgb18+dKtOT569MgePHhgV65cOU6tgwiIgAiIgAgUJlCyAFIcQlRXV+dEa2FhgSDjMQiEC4F0ASV+eAEk2\/b2tuV7nIJnDaurq0li+\/v7tru76wR3cnLSLl265MKLfTx\/\/tyNIl+\/fl0sqeJFQAREQAQCEKA\/ZXaOvjs7edTPSxZARmAYxTRlV1eX\/ehHP3LrbvjjYPz9+\/eN9cbHjx9jhpwIiIAIiMA5CdCf0q\/evn37nCWFm71kAWQE9r3vfc9NUzIKxOh3333XeDTiO9\/5jhuRncWEzc3NTLaGhgY31ZkJOD7Z2dnJrPvV1NQY1z+OCnyYmJgwXup98+bNwHmUUAREQARE4HQC9Kf0qyMjI6cnimBMyQKIDazzYSzH4eFhYw0Q19vbS3RJDkHlAXovgEyp4ic8uyBGm6z7MTW6vr7u1gObmpqykwQ6R1x5brGxsTFQ+nMlUmYREAERSAEB+lP61Y6OjlhZeyYBLLeFQ0NDxuiO3aQc8XMNdpviOG9tbbX+\/n738P2tW7fszp07liuSpJMTAREQAREQgSAEziSA7NBk6hPB8g4\/4UEumpsGIWNEySiSI37SMLrEcY7jnDQvXrwwBJEw7\/CzCYejD9NRBCpIQJcWARGIOIGSBRCR41cf2JGJGHmHn3DiI26zqicCIiACIiACVrIAsgYHNx574Oid9\/t4H66jCIiACKSOgAyOBYGSBZCNL2xS4dcf\/DN\/HPETTnwsLFclRUAEREAEUk0gsAAicrzqjDU\/Hnng1x\/Y9YOfI379GkSq7yUZLwIiIAKxIhBYABnZLS0tZR558Gt\/2UfiSWcWKwaqrAiIgAiIQAoJBBbAbDZsdGHXJ6M\/7\/ATnp1O5yIgAiIgAiIQVQIlCyAix25Pdn1mj\/7wE058VI1VvcIhoKuIgAiIQBwIlCyAfpen3\/XpjfR+H+\/DdRQBERABERCBKBIoWQBZ42O0x+\/v8Tt8GMURP+HEEyYnAiKQRgKyWQTiQ6BkAcQ0fn7oH\/\/xH42XYLMGyBE\/4cTLiYAIiIAIiEDUCZxJADHKv5bMrwPiJ1xOBERABEQgnQTiZvWZBTBuhqq+IiACIiACIpBNoGQB5IF4HnngmF2QzkVABERABEQgTgRKFkA2ubDZhV+Aj5OhodRVFxEBERABEYgNgZIFkJHf2tqa8To0NsBkO16VRnxsrFdFRUAEREAEUkugZAFkBMgrz\/zml+wj4cSnlqYMTzMB2S4CIhAzAiULYMzsU3VFQAREQAREIC+BkgSQB96vXr1qftpzcXExb6EKFAEREIFUEZCxsSQQWAB5x+e9e\/fsk08+cb8I8eTJE7t\/\/76VsuZHWtYJEVB2klJmLjXCiCMNacnj00xNTeUV39HR0Uw4aXx6HUVABERABETgNAKBBdC\/47Otrc2V1dTUZOwG3d3ddf4gH2ycGRgYsPX1dZd8dXXVHbM\/ZmZmXLmsLba3t5vfbcro8+nTp0aehw8f2vT0tCGWjELZlEM4ojw7O2ukzS5T5yIgAiIgAiKQSyCwAOZmxH9wcGBfCSC+wo6RHELV0tJi1dXV1t3dbQsLCycyIWjLy8tGGiL6+voMP+ErKyt2+fJlq6qqMkSYa798+dLq6uqspqaG5M5duXLFhTmPPkRABERABETgFALnEsBTyjw1GKFCsHyCnZ0dN4rzfn\/0Aoh\/e3vb\/OiTESfiSfj+\/r4T39bWVrt7967xMm6maOfm5qzQTtTnz5+7UeTr168pRk4EREAEROCcBOhPmYWjvz5nUaFmL0kAMa6zs9OttzEKw2B+A5D1Olzuml0YlrDmh\/AxQrxz545985vfLDgFyrola4yPHz8Oo3qpuIaMFAERSDcB+lP61du3b8cKRGABZFTFc36szZ3miCfdaQT8qM3HZ4\/ofBjHzc1NDs41NDS4aU882SNGP5okLdOpjAxZl2xsbDTEkPT53MTEhLFOePPmzXzRChMBERABESiRAP0p\/erIyEiJOSubPLAAnreaCCObWhAs1vRY22ONL7tcRAwxIw3hrBHiJ7yrq8tY92M6lE00rAcieEyXUhZlEscolTDy53MIKqNYhDJfvMJEQARKIaC0ImBGf0q\/2tHRESscoQkgVMbGxow1OqZPGf319vYSbExj4vAMDQ0ZI6V6tKcAABAASURBVD2mVDniJ5y1vv7+fgPyrVu3jOlOhHF4eNjtGqVM4thl6ssln5wIiIAIiIAI5CMQqgAyCmSalCnU7B\/PRcRwVBBRYyhNGo74CceRhvAXL14YgkgYjrIIx5GGMDkREAEREIGLJRD30kMVwLjDUv1FQAREQASSQ0ACmJy2lCUiIAIiIAIlEJAAlgDrraQKEAEREAERiC0BCWBsm04VFwEREAEROA8BCeB56ClvmgnIdhEQgZgTkADGvAFVfREQAREQgbMRkACejZtyiYAIpJmAbE8EAQlgIppRRoiACIiACJRKQAJYKjGlFwEREAERSASBMwpgImyXESIgAiIgAikmIAFMcePLdBEQARFIMwEJYJpb\/4y2K5sIiIAIJIGABDAJrSgbREAEREAESiYgASwZmTKIQJoJyHYRSA4BCWBy2lKWiIAIiIAIlEBAAlgCLCUVAREQgTQTSJrtEsCktajsEQEREAERCERAAhgIkxKJgAiIgAgkjUCoAri3t2c9PT3W3Nxsg4ODdnh4+BZPwogjDWnJ4xNNTU25vMQtLi76YOOcMNzo6GgmvOwnKlAEREAERCAxBEIVwPHxcRsYGLD19XUHcHV11R2zP2ZmZqy+vt62trasvb3d5ufnXfTGxoY9ffrUyPPw4UObnp52Akr4\/fv3XTjlHhwcGGEukz5EQAREQARE4BQCoQkgI7m1tTVraWmx6upq6+7utoWFhRPVYvS3vLzs0hDR19dn+AlfWVmxy5cvW1VVlbW1tRlC9\/LlSyO8v7\/famtrXbkPHjyw1tZWssuJQDkJqCwREIGEEQhNAOFWU1NjdXV1nDq3s7PjRnHOk\/WBSHrv9va2HR0dOS8jQ8QTz\/7+vu3u7nJqX3zxhV29etVNjxabAn3+\/LkbLb5+\/drl1YcIiIAIiMD5CNCfMjtHf32+ksLNHaoAXoRpm5ubbjTISJAGYJTJmuBp12K6lDXGx48fn5ZE4SIgAiJwkoB8BQnQn9Kv3r59u2C6qEWGKoDZozZAZI\/o8HuHqPnzhoYGN+2JP3vE6EeTjBZ9OUyPkj47P\/my3cTEhM3OztrNmzezg3UuAiIgAiJwRgL0p\/SrIyMjZyyhMtlCE0DW6NjUgjixpsfaHmt82WYzvcnaIGkIZ40QP+FdXV1upMd0KJtdWA9samoywr\/88ktjjZE4huCIIvnzOQSys7PTGhsb80UrTAREQAREoEQC9Kf0qx0dHSXmrGzygAJYnkqOjY3Z3Nyc28TCqK23t9cVzOMNODxDQ0PGSI9HGjjiJ5yNLWx2AfKtW7fszp07btNLdjhx7DL15ZJPTgREQAREQATyEQhVABkFLi0tuUccJicnM\/UZHh42HAGM9hhK8xgER\/yE40hD+IsXL07s9PThxHFOWjkREAEREAERKEQgVAEsVBHFRZeAaiYCIiACSSQgAUxiq8omERABERCBogQkgEURKYEIpJmAbBeB5BKQACa3bWWZCIiACIhAAQISwAJwFCUClSbg37DBSx4KOdJVuq66fvQIcF8Uum98HOny1T7pYRLApLew7IstATql\/\/1\/\/q\/75RTeslHI8QYO3sbhO7R8R8qLLQxVvGQCtDf3RaH7xseRjvQlXyTmGSSAMW9AVf\/8BPji5xOM3DDSnf9qwUvgev9\/4\/\/ZX\/\/dP1nXh\/92qvvL3r833nFLJ+Y7tHxH4ikzeA2UspwEYJ97T+Xzk64c16Uc7oug9w\/py3HdOJUhASzUWooLRIAvTr4vcm4Y6QIVGGIi6oQw5BOM3DDSkT7E6rlLVf1pnf1Zc9vp7i\/aXLpCHZ0XyUrU31Uu5R9w5\/7Jvafy+UlXbDTPd4syg2ANev8EKStpaSSASWvRkO3hS8gXNt8XOTeMdOX8YpfDVOqflL+SC3Z0xyJZDmZpKoP7A7Ep5khXiAvxpdxnfFdyvz+5ftJQbqHrKq4wAQlgYT6KLUKAL2ASvth5xOPkiCshAkJbFevMg8TT7kVujYpFU7diNpCmWAVJg8jkCk8+P+lIX6zMoPdZodE80+Ea0RcjHSxeAhiMk1IVIaAvdhFAEYn2PweWrxMvJYzNOUE6\/LDNpk7UrZgtN\/7XR0baQvUjnj8YgopRodkNXtJf6Fq5cUG\/T7n55C+NgASwNF4lp+ZLVI6\/Rku+cEQzlOuLHYQr3ElXThR0iJR7XlfuegW1MUhnTlmF0jH6YHNOOW2grGJMSUPdCjnSULdi9f\/l1nphAcy6SNB7ttAfF4wQs4qM5Gk57u1Shb7SICSAZ2wBvmjFvrDEc+MX+2uUNJR3xqokMluxLyPMinElnnTlZFuok+N6QR31KjRi4N65iM4kaGdeMN3xdHCxNsKGIOxJA49i7EgTlFmQ+pf7i1NMdMt9Pcor1Aal3j\/luLdpI+oVF5c6ASx0w5T7C8sXmusV+2KQhk4gLjdNGPUs9mWEWSGuF7VOEuSa8CmUjhEU9aez4B45zRFPWVF1xdoIu7Ch2L1NPDzizqwSoluoDWBfyr1TjD9lFUrjv3Oki4s7RQDjUv3S61nohinnFzb7ZqjEF6N0MtHKUeiLhoBQ24JceWzgeKRC2nK5oNcsmO64XoVszL5\/ylX3cpcTpP4IGwIX5NppYBaEQylpCrWB\/54ELS8I\/4JpLug7F7T+Z0mXOgEsdsOU7Qsbw5vhLDfQReUp+EU7FpCLunZY5Ra0MQb3TyXqX85r8l1n1uc0V+oUYlj3TfZ1CvJIyPck295yn6dOAHXDfHUL8Vf5aV\/87HDSfZVDnyKQLAJBZoOSZbGsySWQOgHMBRAnP2KULU7nOWd9gCnfYo50XDdOnFRXEQhCoNBsUBymoIPYqDSFCYQqgHt7e9bT02PNzc3uBb+Hh4dv1Y4wOmXSkJY8PtHU1JTLS9zi4qIPzhxHR0cNlwmI0Umx6RjELsjzTbAL4rhekA6AdIV23sVhmihGt0EEqlr+KnAPcf+e5ip1DxWcDYrBFHT5Wyp9JYYqgOPj4zYwMGDr6+uONF8Id5L1MTMzY\/X19ba1tWXt7e02Pz\/vYjc2Nuzp06dGnocPH9r09LQhli7yzQeC6NO+8cbuf7HpGEQtyPNNGB5E2EgXtAMoVDdGiJQVZVeoA65U5xtlXuWuW6H7h\/s6DvdQuZmovGgQCE0AGcmtra1ZS0uLVVdXW3d3ty0sLJyggKAtLy+7NET09fUZfsJXVlbs8uXLVlVVZW1tbXZwcGAvX74kmVE2gvitb33L+c\/7UajDRIAvotMsi2gdL3oHFbagnArVrdSdZkGvWc50hTpgdb7lJJ2\/rEL3j6Ya8zOrVGjarhuaAAK2pqbG6urqOHVuZ2fnxCjOBb75QCTfHNx\/xObo6MidMzJEPPHs7+\/b7u4up8bI8r333rOvfe1rzl\/o45c\/XTfeAnH066\/y5ktbqMO8qL9Yyy1a+ew6a1jBuh2L7lnLDiNfoQ44DgIeBqOLvEbB+0dTjReJPrSy6U+L9auhVaaEC4UqgCXUK3BSpj5J3Nvby6Go+3LxP2zlwT\/bq\/9+dmraQh2m\/mI9FVtkIwp2wDEQ8MiCVcVE4JgA\/Sn96hf\/+e\/HIfE4hCqA2aM28GSP6PB7t7m56U+toaHBTXsSkD1i9KNJplFZ+2NjDCNBzgtthPHi9o2\/uUaRJ92xr2CHqb9YjynpIAIiIAJfEaA\/jePgIDQBrK2tdZtaEDfW9FjbY43vK3xffTK9ydogaQhB3PAT3tXV5db9mA5lEw3rgU1NTTY5Oek2zLBpZmxszG7cuOHCyJ\/PeXHjmC9eYSIgAiIgAqURoD91P9ocsxmV0AQQnAjU3Nyc28TC6M9PW\/J4A440Q0NDxkiPER1H\/IS3trZaf3+\/dXZ22q1bt+zOnTtuMw1xciJQBgIqQgREIGUEQhVARoFLS0tuxMbIzbMeHh42HH5Ge7Ozsy4NR\/yE40jDSO\/FixeGIBKW7YjPLjc7TuciIAIiIAIikE0gVAHMvrDORUAERCAyBFSRVBKQAKay2WW0CIiACIiABFD3gAiIgAiIQCoJHAtgKm2X0SIgAiIgAikmIAFMcePLdBEQARFIMwEJYJpb\/9h2HURABEQgjQQkgGlsddksAiIgAiJgEkDdBCKQagIyXgTSS0ACmN62l+UiIAIikGoCEsBUN7+MFwERSDOBtNsuAUz7HSD7RUAERCClBCSAKW14mS0CIiACaSeQbgFMe+vLfhEQARFIMQEJYIobX6aLgAiIQJoJSADT3Prptl3Wi4AIpJyABDDlN4DMFwEREIG0EpAAprXlZbcIpJmAbBeBNwQkgG8g6L8IiIAIiED6CIQqgHt7e9bT02PNzc02ODhoh4eHbxEnjDjSkJY8PtHU1JTLS9zi4qILJp50hOFI4yL0IQIiIAIiIAJvE8iEhCqA4+PjNjAwYOvr664Cq6ur7pj9MTMzY\/X19ba1tWXt7e02Pz\/vojc2Nuzp06dGnocPH9r09LQTUF8m6Z88eWKfffaZeXF0GfUhAiIgAiIgAnkIhCaAjNTW1taspaXFqqurrbu72xYWFk5UidHf8vKyS0NEX1+f4Sd8ZWXFLl++bFVVVdbW1mYHBwf28uVLm5yctOHhYZJbU1OTvfPOO+5cHyIgAiIgAiJQiEBoAkglampqrK6ujlPndnZ23CjOebI+EEnv3d7etqOjI+dlZIh44tnf37fd3V1OMw5BRBgRyExgzskvf7puv9xat6Nfn8ybkyzRXhknAiIgAuUkQH8ax341VAEsJ\/Dcshhhfvzxx3b37l2rra3Njc74v1z8D1t58M\/26r+fZcJ0IgIiIAIicHYC9Kf0q1\/857+fvZAK5AxVAHNHbdkjumzbNzc3M96GhgY37UlA9ogxezTJ+uD7779vn3\/+ubW2tpL0VPfXf\/dP1vXhv9k3\/ubaqWkUIQLJJSDLRKD8BOhP6Vf\/svfvy1\/4BZYYmgAyKmNTC+LGmh5re6zxZdvG9CZrg6QhnDVC\/IR3dXW5dT+mQ9lEw3oga36I36effmpzc3MFR36Uh6v60zr7s+Y244hfTgREQARE4HwE6E\/pV\/\/sL9rOV1DIuUMTQOwaGxtzQsUaHaO\/3t5ego1HF3B4hoaGjJEejzRwxE84I7v+\/n7r7Oy0W7du2Z07dwi2e\/fu2bNnz9zGGPLgtAvUodGHCIiACJwgIM9JAqEKIKPApaUl94gDuzd9VdjFicPPaG92dtal4YifcBxpeNzhxYsXbqqTONIQlu28sJJHTgREQAREQATyEQhVAPNVQGEiIAIiIAIiUAkC6RLAShDWNUVABERABCJJQAIYyWZRpURABERABC6agATwogmr\/KgQUD1EQARE4AQBCeAJHPKIgAiIgAikhYAEMC0tLTtFIM0EZLsI5CEgAcwDRUEiIAIiIALJJyABTH4by0IREAERSDOBU22XAJ6KRhEiIAIiIAJJJiABTHLryjYREAEREIFTCUgAT0WTnAhZIgIiIAIi8DYBCeDbTBRPMHe7AAAIdElEQVQiAiIgAiKQAgISwBQ0skxMMwHZLgIicBoBCeBpZBQuAiIgAiKQaAISwEQ3r4wTARFIMwHZXpiABLAwH8WKgAiIgAgklIAEMKENK7NEQAREQAQKE0i2ABa2XbEiIAIiIAIpJpAIAZyamrLm5mbnFhcXU9ycMl0EREAERCAogdgL4MbGhj19+tRWV1ft4cOHNj09bYeHh0HtV7rkEpBlIiACIlCQQOwFcGVlxS5fvmxVVVXW1tZmBwcH9vLly4JGK1IEREAEREAEYi+ANGF9fb1VV1dzavv7+7a7u+vO83388qfr9sut\/O7o11\/lK5SGvOVMF9WygtpZzvpX4ppxr7+YnfwuZ9ozwd\/zOLR5vr43imGJEMAgYBsbG62jo8O+XPwPW3nwz3ndF\/\/5766oQmnIW850US0rqJ3lrH8lrhn3+ovZye9ykPYMkiYo16Dp4n7NUupPP0t\/6zrTiH8kQgB3dnYy6341NTVWV1f3FnYaZGJiwmZnZ+XEQPeA7gHdAxd0D9DP0t++1QmHFxD4SrEXwK6uLrfud3R0ZOvr6249sKmpKS8AGqWzs9PkxED3gO4B3QMXcw\/Qz+btgCMYGHsBbG1ttf7+fidqt27dsjt37mTWAyPIW1USAREQARGICIHYCyAch4eHbWtry168eGEIImFpdrJdBERABESgOIFECGBxM5VCBERABERABE4SkACe5CGfCMScgKovAiIQlIAEMCgppRMBERABEUgUgVQIIO8H9e8K5b2hSWjBvb096+npce8\/HRwczDwGkm0br4m7evWqS4P9o6Oj2dGxPud1d9hN28bakKzKc2+e1kZJbEvfhtybuNNsz0IUi1PaEXtwfEf5ruZW\/KLaM\/c6YftpQ+zGwSHs65d6vcQLIDff\/fv37cmTJ87x3lDCSgUVtfTj4+M2MDDgHv2gbrwLlWO2440477zzjkvDJqHJycns6Nie037s\/M1nc1yNouOgTU+rfxLbcmZmxniLE\/cmbbm2tmZx6DRPayPCETb6GOzBrvb2dvv2t7\/91h+oSWxP\/hjlmWweR6O\/5ZlreMAlqi7xAkhj8Ho0Ho7n+UDeG0pYVBskSL0QADqLlpYW98hHd3e3LSwsvJV1c3PTdTD+NXFvJYhhAKMGhOL73\/++ff3rX4+hBW9XmU6\/r6\/Pbty48XbkcUgS23J4eNj8H2W1tbWGWBybG9sDu9B\/+MMfGvZgBO3KMdclsT17e3vdywV8f3PlypW8LyXJZVFJf7IE8BSSDQ0N7mXZPpqbz5\/H9Zj7xhv+8kIcvD2cLy8v2\/z8vJsCZSo06n+N+boXOvLlotP0HUyhtHGJQwjoPE6rb1LbMtte\/qj78ssvjRdbZIfH\/Zw\/TPkDlfvW25L09mQ2491333XPZ0f9e5oKAfQ3XpqOfOGYgmAaBvfJJ5\/YRx99ZHQ0aeKQBFuT3pYIAtOEIyMjiXqOl5E99x9\/4HD0LuntyR+ozLLxB7hn4G2P2jEVAri9vW28Ks3DZ+rQn8f1yLQu6wi+\/qyl8MXy\/twjU8C\/\/\/3vC\/5SRm6emPlTU90ktSV\/kLGWzRucCo2C49a4jIKoM2LAsZBLUnt6O+mL6JOiPtuWeAHkNwKZLkQs+J1Afi+QMN9QcTwyrcB6CTcXfz3zl1buWgPhH374oflpT343kXf0sQ4aR5vTXOektiXix8jv888\/T9TID\/Hj+5g78vP3cFLbk00w2I6dtC37FOCAP6ou8QKIWDC1wpw0jnPCotogQes1NjZmc3Nz7keA+UvL\/\/XMlAOOv8CY8hwaGnJrgJ999pnekxoUbkTS0Y64pLYlm5nYLclLqdk2j8PeM+GPSCZEgHX3Dz74wH3vsInHdRA9bMMltT19H4TNtCkjex8WkeZ5qxqJF0AsphFYB8NxTljcHSK+tLTk3oGaPc3CX5047GNHGu9HxW6O+AlPgvP2J6U9aRPaEcc5jnbEcU7b0YZJaktsxZ5s5+3F5jg67sdsezhnLR7RwzYcdiWxPbEru029rYRH1aVCAKMKX\/USAREQARE4N4EzFyABPDM6ZRQBERABEYgzAQlgnFtPdRcBERABETgzAQngmdFFJ6NqIgIiIAIiUDoBCWDpzJRDBEomwC5AdgOyQy7XEc77IzmSruTClUEEROBMBCSAZ8KmTCJQGgF2AbIbkF2BvCiYZzI54iecl3tzJF1pJSu1CIjAWQlIAM9KTvlEoIwEeH7MjwB5mPi73\/1u5ueu8PP8GCPH3He6Ekc4jjRlrJKKEoHEE5AAJr6JZWAcCfzXf\/2X\/eAHP3A\/4fXs2TPjrT+MFq9du2aPHj1yJiF4vASd9y4ymuRlBwipi9RHKgjIyPMRkACej59yi8CFEOBVdzzsz3siv\/GNb9g\/\/MM\/uOv499iyVsgr8PwvDfBgNeKIULqE+hABEShKQAJYFJESiED4BLzQFbsyrxNj+hPHK7gkgMWIKV4E\/kAg3gL4Bzt0JgKpJPDw4UP3OjymR3G8iiqVIGS0CJyBgATwDNCURQQqTYDdokx\/Tk9PG9OhvH2\/p6fHWBesdN10fRGICwEJYFxaSvXMJZB6Py8b5pdA+Hkv3r7PuiFhqQcjACIQkIAEMCAoJROBchFgwwobWDj6MvkVAf8cINOYXsjYCPPDH\/4w83t5hBPv83HO1CeOcx+uowiIQHECEsDijJRCBEQgagRUHxEoAwEJYBkgqggREAEREIH4EZAAxq\/NVGMREAERSDOBstkuASwbShUkAiIgAiIQJwISwDi1luoqAiIgAiJQNgISwLKhDK8gXUkEREAEROD8BCSA52eoEkRABERABGJIQAIYw0ZTldNMQLaLgAiUi4AEsFwkVY4IiIAIiECsCEgAY9VcqqwIiECaCcj28hL4HwAAAP\/\/nmpA+AAAAAZJREFUAwDxVDSAtZ\/sFwAAAABJRU5ErkJggg==","height":0,"width":0}}
%---
%[output:9b959381]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:86d2e856]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:130aa806]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 9.155487\n","truncated":false}}
%---
%[output:01eacda0]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 11.439455\n","truncated":false}}
%---
%[output:7d021786]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 3.984826\n","truncated":false}}
%---
%[output:6741a305]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 4.967395\n","truncated":false}}
%---
%[output:55e0259a]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:7dec1d9f]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:06e5d3e0]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:867e3901]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:5631dcd5]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:0712e8fd]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:3bdefb70]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 6                         **","truncated":false}}
%---
%[output:1972b98f]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:2c91879d]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:637feb61]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:81cf9d01]
%   data: {"dataType":"text","outputData":{"text":"Lq                 4.3145             3.9848             7.6400            \n","truncated":false}}
%---
%[output:9837fd27]
%   data: {"dataType":"text","outputData":{"text":"L                  9.5160             9.1555             3.7886            \n","truncated":false}}
%---
%[output:7378f90d]
%   data: {"dataType":"text","outputData":{"text":"Wq                 5.3931             4.9674             7.8929            \n","truncated":false}}
%---
%[output:8ecc4d2f]
%   data: {"dataType":"text","outputData":{"text":"W                  11.8950            11.4395            3.8298            \n","truncated":false}}
%---
%[output:18864f5c]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:615eea0a]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  76172","truncated":false}}
%---
%[output:1ea6d50a]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  26460","truncated":false}}
%---
%[output:9f90231f]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:751b01d3]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  5.3931  minutes.","truncated":false}}
%---
%[output:08152a2b]
%   data: {"dataType":"text","outputData":{"text":"When s = 6, P( W_q > 5 minutes) = 0.34737","truncated":false}}
%---
%[output:0f84fb57]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:6d119e1d]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) > 10 percent ","truncated":false}}
%---
%[output:27278128]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:0e242b39]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:277cde13]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3ffbb453]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:8967faed]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:80c43d15]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:39e03126]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAcAAAAFQCAYAAAAoQ64wAAAQAElEQVR4AeydfWwd13nmX+8WXYASpThVSFhkshHNhdE6pGB02bAgTAUFhdLWKk5EOLVoGknsJmISZ+1GH7sy6tqCUQkW5dRC\/CEJDWEhNOUkS9ZCqg0LMWjELgHKgteg5LR2lhUdWWQjOug6kiLsHwG69zfhuR5e3u87vDP3ziPo5ZzvOed35s4z58zMmX\/3b\/onAiIgAiIgAjEk8O9M\/0RABERABEQghgQkgDHs9GST5RABERCBGBOQAMa489V0ERABEYgzAQlgnHtfbY8zAbVdBGJPQAIY+0NAAERABEQgngQkgPHsd7VaBEQgzgTUdo+ABNDDoD8iIAIiIAJxIyABjFuPq70iIAIiIAIegZgKoNd2\/REBERABEYgxAQlgjDtfTRcBERCBOBOQAIbc+7t27bKmpiYbHx9P1oSwTZs22cLCQjIsCMdKlZurbrSNNmLUIVf6IOIvXLhgTzzxRNqiohZIXTdu3GhHjhwpuGrXr183mHKs4O7t7TUMd8GFrXAG+oO2rvBushbP\/otlnbXgMkS6uvM7WonzQxmaELldSAAj0iWDg4MWxZNWEHjGxsastrbWTp48aYcOHQqiyKxlIAYPP\/yw\/epXv8qaLiqRLS0tNj09bf39\/QVX6cknn7Rz584VnK\/cGRD3V199tdy7rZr9IX59fX32zDPP2NTUlNeugwcPelv9KZ6ABLB4doHm5KAeGhpaViaiyBU9hpuTO1d\/XPXjJxzbsWOHN5Lk6vbll182tlwpki610EcffdRLSzyjMxePmzCMfbAv4lw4ZRHHlnC\/kZY8xGOc8IhnOzo6ateuXbN77rlnyUiXeMyVTz7qzY+dcPZDmZTtbytu4imbPJg\/He179913jf3ChvSUQRrSYuSlDOJIg+XDMLUc6k451Jm6UwZbyqNs2sD+MBdGer+5vK5O5KGujJjIR3mk8efBTXraSFs3b95s\/\/iP\/0iwx3r79u1eH1MOdfYiEn\/IQ5lYpvokknmjUdJgrgzKwU39SIPhJow4DDd5MPZFGhhxsvYfA7Bh\/6TDXFpXBhxdPGVyTJMOc2kp2xn7II4tYdQr1U85\/\/qv\/0q0vfHGG2l\/I5nq5cKpE3WjbMqjvl6BKX\/oL\/qNdJirV0qyvL2Tk5P2oQ99yFpbW62urs7OnDlTlovJvCtYoQklgBHoOEZHjY2NduLEiaKmPX\/yk58YIx5GWDTn2LFjdvr0aduzZ48nAv4fHyfLBx980M6fP2\/t7e321FNPefvkB7tz504vD3ENDQ32aEIo+eFTprOLFy8u++FxErj33nutra3NiGf\/nPDYL6Oabdu2JUeAXV1drihv6\/ZLHvZ7++2324EDB3KOhsn34osvevXl4oHC2Ofq1avt2WeftY9+9KPGfoeHh+3GjRuWqX7kw\/JhCItHE0xgQ13hCzPqQhkYJ3lOVuyXeiFQtI2+YR\/pLnLIl2r005133uld7XPiO378eGoSb8RIG2kr\/f17v\/d7XppLly7Z\/v37vRH3+++\/7x0DRNAfMKI+1G1ubs4YQRLnN9qTji0nXvqYESd9juEmjDjKphzKhg1lUBZ9jp\/jHA742S\/7Jy31IS\/1Iz\/21ltvGf1IHCxOnTrlHbO015VLOmcIAxyYbaCf5ufnvaiZmRnvWMJPPT\/84Q974a6fqBfsqCcRuepFH7rfmp8teZ2xf45hjmWOE+rsfmcuDVv26RdJhBJDZCmDNM5ox5o1a+yhhx7yLmzSpXFptc2fgAQwf1YrlpITHFeV\/NA5YRa6I35oGzZssPr6eu8qkR86J6Tm5uZlRXGS4GSBUCCE7JMfKSdtEnd0dBhxnZ2dxgkK8SAc6+7uZrPMyE85Lh5hxfKZ1mW\/tN\/VCeHAqMOyHaUJ4MQJszNZroiz1c9Nk+bDcHZ21jgBwob6wYoqXblyhY1nLs7zLP758pe\/bKQpZJoTsaA\/a2pqDMHlBJ56UlwsftkGnuTFcHPyJBHi4Pqf44PjJFu56djSx\/Q1TDHchFE+hp+LDU76tJfpXcL9liqc9D31cvUkLXWjjrQBFo5rumOa9KQlD+157733vGOX8ImJCXvzzTe9fvPXc\/369d5xTnmIIf2TT73gSZ0w3P46sz+\/Ie70PaLK8Ukd\/fGwgREXjX7LdPxz7D3yyCPeRRG\/Tcr1lyd3bgKpKSSAqURC8jOFxUmDq9vXXnut7LXgh8yJgGlKrkI5+XGFy4khV2XIy0mKk0KutKnx5E0Ny8fPyQNmpKWu1Dnd1Bjx7KPY+pHfGSxg5PYHK\/yU79L4t1wEYIRxIqSO\/lEO4ZmMk2sxPCkPwUQ4cTtDPBEHBIo6URcuHDiR+i9ySJ+NrV+s\/IJKvs9\/\/vPeSN\/tI9MUIRw5ttg\/9aA+5MnEkbLzMcQMkaBcyv\/a177mCeEPf\/hDL7ufJ2m9QN+ffOqVjq2vCM\/JxREXl3gQQZilG7EVMgKkLC4SKIu+pR6MvhFt4mTFEZAAFsdtRXJxAqHgy5cvsymrcUJAJJiiclejXJ1yMsxVEfIiBJxAcqVNjScvJ6ti8vJADXVlmoxyuXjgpILbb+yj2Pr5y+EECiOmzdivM6Z5\/emcmxMhV\/OkIw\/h6abCCF9poy6MejiJclKmTli6kQl1ycSWUQwjLaYk3377bW\/amzDycKxwzDAydKLGxQJxfoMjAs8FH3Vwxj796Qp1uxH53\/\/93xsjevwcW9\/5znc8P7Mk2coMsl5M89IuWDvmqdPfjhfp\/MYxQ3\/568ox7PzE0ZfOr23xBCSAxbMLPCc\/CDeqcYW7g91dqXNy4WrZxRe0TSQmL1fIjAiYouTHyVUlJ4tEtDElSRxXrBhuwrMZ+SmHEQHp+NFjXAVTf8IymX+\/pOHhBTdy4EfPCQxxdNOPpMEYSTF6YMvJhpMpJ1VOYsT7LVv9Vq1a5U+a1c0JlBMr02pwYcTJPZx0oktB\/nie4EMUuHLnCp74chtTgPQ\/xxAjBzjDO7UeMM3GlnIYaWG4yQ8PjhcM\/969e73RIH2I328IJiLqRjD+\/fnTFep2\/cPDQAjEJz7xCU\/4KMdNoeLOZEHVy8+WMh9\/\/HFvl+lYeBF5\/OF3wm+B3y7lww6GlJ9HdiXJQEACmAFMWMGMFBAT\/\/4ZGXLwcwJ1ouWPL8RN2ZzAEQVOYM8995z3VBniyyPWXLETh+DyEEIuAWPf\/Ai\/\/\/3ve4\/jc+Jkuo9RGcJEfDbz75e8PJDg6uREjanGxx57zD72sY8li6JsWLEv8nFi4ERDXTBODoRxkidTsfUjrzNYwAQ2MIIVzGiDS+PfMjLkgob6kx7eCAPl+NOV4kaAEDWODUZz2cryMyM9YpzuPpI\/XSpbyqctHEcYbsJok58NbeZiAeEnnhM4W8K5MGC\/7J960If0JfslTbFGHRA68sMFP0KIP1\/xCaJeHH8cwxzL8KN9HMultI9jjGONYw5msKOutE1WPAEJYPHsAsnJtA8nLn40FMgWP4abMA5+ppaYJmF6hDjy8QPHj+EmvYsjHz848rDFTx7iSU84ZVI2cRjpCMdIR3n+cOLxpzPSkoe8mD8t+03dl78M0pIH86fzl\/mDH\/zAMOpOW8mPwJDHGeUQjrFPwqkT5WC4CcNcWsqiTAy3S0d+yiGdP72LJwwjnnRwpO7UCb8zyiEdRjzpXJzbEkacy0se6sq+qBN1w3C7PG7L\/ikb27Jli5EOIy35KYfyzMzLwj5Ii7l0XkTKH3860rKflCRLpj+Jc\/sjPeYv37WRcMqmfsTjxwjzl+Hq7PK5eLawIpz0qUY85bn6Uo7fTz7yk468pPPHZ6qXC6fOuF1bKZ9yUs3th7KxTOlS82Xzu7pSnqtHtvSKy01AApibkVKIgAgsEmDKlBEIXkZtbGUiUKkEQhdAd++AqQKmq5jfzgSTuK1bt5r\/ngs\/SPJiTK1kyqtwERCB0gkwkmEEwsiSUVDpJaqEshDQTtISCF0AeTKKeXp+VO6+TbqaInrcT+ElXxfPzXNuBvPABU8vMi1AOhevrQiIgAiIgAhkIhCqADL644EMd4OaG9f4CfdXmJEfK2EcPXrU1q5dm4ziiT9WR3ABxBHm\/P4trxYglBhuf5zcIiACIiAC8SMQqgA63E4A8fOEXeqLuUy1MPWS+sg6N5pZ8omRIUsPsZQYaSnHb5cvX7bdu3d7q+TzmPbIyIg\/Wm4REAEREIEYEoiEABbLnXt+CB\/vrvF4+d13373k\/qArlxHf2bNnbWBgwHtKrqenx0VpKwIiIAIiEFMCkRBA\/xJIvN+S74vC5OO9Hx5L5iVYFpRGDDP1JWXzBBvpMqVRePURUItEQAREIB2BUAUQ4ULAEDIqx0oi+AnHn8uYOnX3DJk2ZfqUsFz5FC8CIiACIiACoQog+FkpgkV6eY2BLX7Cmd7EcGcyXmblCVJWo2BkxzfQeFk0U3qFi4AIxI2A2isCmQmELoCM9nh9gdcg2OKnuogbhtsZD70w4mPrwng4hrxYanqXRlsREAEREAERSCUQugCmVkh+ERABERABEQiCQK4yJIC5CCleBERABESgKglIAKuyW9UoEYgnAV55YrEL2ZStBAP4VtORJQGspt5MbYv8IhAjApyc\/QtesOiFrDe5AEgQLOAL52o5rCSA1dKTaocIxJwAJ2b\/ghc8VCcb9hb\/CILDI488YvCFc7UcahLAaulJtUMElhKIrc8teMGrUVFY9II6UJdKt09+8pNVd0xJAKuuS9UgERABCDBSYcouiKm\/UsqgDtSFOsmiRUACGK3+UG1EQAQCIoDoMGV3x+e+YR07ng7Fbuu6P+e0IZ91y7XoRzYkafP7MvB1nZdfftkLYT+k9zz6YxJAHQQiIAJVTaDm5npb19Qajt3ampMtq1et5CIes7Oz9tOf\/tSrB\/thf55HfySAOgZEQAREoFwE+GD3xo0bjaUf2eJnRMbIjO+e7tixw7Zu3erFE7Zr1y7PzZaRHFvSUV\/iyYvbGfGUjTFte+XKFeOLOd\/5zneM9Bh5KIt40mEujP2zHjNhmzZtMrcvV361bat0BFht3aT2iIAIVAMBvlbzzDPPGEs3Tk9Pm39ZR9rHesj79+\/33uE7ceKEdXd3e27Cf\/GLX5AkoyFWX\/jCF7yyz58\/b7W1tZ6A8am4Bx54wBj9ucxDQ0PGOsrUg\/cFBwcHjfKvXbtmf\/EXf+GV0dbWZpTj8lTjVgJYjb2qNomACESSwLZt2+ypp57yRnVuBOiv6G233WZ82o0wnmZloX8+D4dYEZbN6urq7Oc\/\/7lXNvkQtmzpEVfiKd+JJfshL+Fx+LKOBJCellUVATVGBKJKAJE6c+aMN8JiJHj8+PGCqsoIjWlNMrnPyOHGmE79h3\/4B69sRm7t7e0EZzQ+P0ckn5KjXOqGP04mAYxTb6utIhBDAr\/45\/P2i4vh2I3\/e2UJce7BcX8N27lzp33+859fEp\/Nw0jtjjvusHvuuccb5b311ltLktfX19uPf\/xjL66jo8OLC3x\/lwAAEABJREFUc2L56quvGvcHvcDEHz47x7Qq9UAoH3zwQVu3bl0iJl7\/JYDx6m+1VgSqnMAHzeMFdJ7+fHv8ZZs8+t9CsTe+903jBXLqQs24D8d9N8zdA+SpTMIZgfF5Nz4Jh5vVW9jiJxw36ciL\/e3f\/q2RFyOc+DOLo0vKPnr0qBfPfUb8lEE60lMm5VMO5sJIQzmuroTjrlaTAFZrz6pdIhBzAojO6EvPBbYUGIJRjA0MDBh1iXl3RLL5EsBIdosqJQIiEAQBhIcpvjCNOgTRFpWRm0ChKSSAhRJTehEQAREQgaogIAGsim5UI0RABCqBAC+ga1my6PSUBDA6fVF6TVSCCIhAIAT27dtn9910k72QsK9v2GD4gyjYvyxZEOWpjNIISABL46fcIiACVUbgpZdess88+aS9kmjXVxP2rXfe8fxBiKB\/WbJE0ca7eLyKgLEcGWH+VyVwE8bIMdvSZX\/yJ39iX\/rSl4x3AUlPPgy3LDOB0AXQ37G51p5jqR\/WyXOdTLM4aDh4MP97LsTJRCBGBNTUgAiMffGLtjGlLPz\/lBDFlOCCvemWJeM1hGPHjnliyLntjTfe8JYgI5yX3TnHZVq6jAo8\/\/zz9t3vftd+\/\/d\/31hqjXMq+Vh1hnhZZgKhC6C\/Y1l7bnR0NG1tOTA2b95sly5dSsYTdvjwYW+tPFY+YDUDwpIJ5BABERCBAgl0ZkhP+DuJ0WCG6KKC3XJkvMS+atUq48X106dPG8uRcVHP+RAxo3CXlhfi3dJlbMlLPIJHWgQTv3ufD7csPYFQBZArlYmJCXNrztHB+An3V5eRH0sG8WLn2rVrk1Fc7WzZssXoaF7sJJ6XPpMJUhx8G4z18fhOWEqUvCIgAiLgEZjw\/i7\/808f\/7h9PGHLY4ILQcy40OeCnhEg1t\/f7+2A6VIcaZcuS0RwHkREv\/nNbxrn0kSQ\/ucgEKoAuro5AcQ\/NzdndDBuZ3QsKxTQuS7MbZkuYFFZrpZyTYEyWmQefWRkxGXXVgREQASWEPjdxFTn9JIQM\/zrvvCFlNDivKnLkvlL4QKe5c7cCJDzGiO6fJcuu\/POO+2mm27yRpD+cuVOTyASApi+arlDGe4z7clIkJHduXPnjIMlU05WZGAlh56enkxJFC4CIhBzAk888YS9mhDB+xIcXkjY1xOjPvyEJ7wl\/UfgUpclo0DC3UM2jPgY+TljOTJmuDh3pYYxMGCAQBnOuJWUGubitF1KIBICiJC5avEJEOa4nT\/blpEjn+9YvXq1kYe8\/rJS8xLf3t6uZYlSwcgvAiKwhABi98q\/\/ZvdPTtr30oY\/iUJIujhqc9CF9iOYDPKWqVQBZCrms7OTnOixRw3fsLzocCK52+\/\/bb30UemTZk+RRTzyas0IiACIpCLwErf88u1\/0LiGTkyumQ0WUi+OKcNVQAB75\/b5vMc+AnnagbDncnoaB6CYVSHbd++3Vv9PFN6hVcnAbVKBPwE3MNu3BaRTXlPyQfBgQGGn3M1uEMXQEZ7bm6bLX7AcjWD4XaG4PGUKFsXRho3L47bhWsrAiIQLwIsOs2nh9zDbjzwJuu1oBjs3r17yaedquHoCl0AqwGi2iACIhAWgQ\/2iwC6B924mJYNB\/4pKPjC+QPqle2SAFZ2\/6n2IiACPgKcnLkdImu3lWAAXx\/uindKACu+C9UAERABEYgngVJbLQEslaDyi4AIiIAIVCQBCWBFdpsqLQIiIAIiUCoBCWCpBMPMr32LgAiIgAgUTUACWDQ6ZRQBERABEahkAhLASu491T3OBNR2ERCBEglIAEsEqOwiIAIiIAKVSUACWJn9plqLgAjEmYDaHggBCWAgGFWICIiACIhApRGQAFZaj6m+IiACIiACgRCoUAEMpO0qRAREQAREIMYEJIAx7nw1XQREQATiTEACGOfer9C2q9oiIAIiEAQBCWAQFFWGCIiACIhAxRGQAFZcl6nCIhBnAmq7CARHQAIYHEuVJAIiIAIiUEEEJIAV1FmqqgiIgAjEmUDQbZcABk1U5YmACIiACFQEAQlgRXSTKikCIiACIhA0gdAF8Pr169bb22tNTU22adMmW1hYyNhG4rZu3WoXLlxYlmbXrl2GLYuopgC1RQREQAREIDACoQvg0NCQrV+\/3i5evGhtbW02OjqatnGI3ubNm+3SpUvL4sfHxzPmW5ZYASIgAiIgAiKQIBCqADL6m5iYsObm5kRVzLq7uw0\/4V7A4h9GfsePH7ejR4\/a2rVrF0N\/syFucHDQHnjggd8EZPl79uxZm5qassuXL2dJpSgRiCQBVUoERCBgAqEKoGuLE0D8c3NzduPGDZxJq6urs0OHDtmqVauSYc5x8OBBe\/DBB+2WW25xQRm3hw8f9qZbR0ZGMqZRhAiIgAiIQDwIREIAi0XN1Cd5u7q62OS0gYEBGx4etp6enpxplUAEREAEIkNAFVkRApEQwJmZmWTjGhoarKamJunP5hgbG\/Pu\/fEADSNB7h9mexCGstvb262xsTFbsYoTAREQARGIAYFQBXD16tXW2dlpTgARNPyE58OeaVEensH27Nlj27Zt86ZK88mrNCIgAiIgAvEmEKoAgr6vr8\/m5+e91yDY4if8yJEjhuE2018REAEREAERCJZA6ALIaI\/7cozi2OKnif39\/YbhdtbS0uI9JcrWhbktaRkROr+2IiACIiACIpCNQOgCmK1yihMBCMhEQAREYCUISABXgqrKFAEREAERiDwBCWDku0gVFIE4E1DbRWDlCEgAV46tShYBERABEYgwAQlghDtHVRMBERCBOBNY6bZLAFeasMoXAREQARGIJAEJYCS7RZUSAREQARFYaQISwJUmXEr5yisCIiACIrBiBCSAK4ZWBYuACIiACESZgAQwyr2jusWZgNouAiKwwgQkgCsMWMWLgAiIgAhEk4AEMJr9olqJgAjEmYDaXhYCEsCyYNZOREAEREAEokZAAhi1HlF9REAEREAEykIgogJYlrZrJyIgAiIgAjEmIAGMceer6SIgAiIQZwISwDj3fkTbrmqJgAiIQDkISADLQVn7EAEREAERiBwBCWDkukQVEoE4E1DbRaB8BCSA5WOtPYmACIiACESIQOgCeP36devt7bWmpibbtGmTLSwsZMRD3NatW+3ChQteGvzkIS925MgRL1x\/REAEREAEKo9AuWscugAODQ3Z+vXr7eLFi9bW1majo6NpGSB6mzdvtkuXLiXjDx48aNu3b\/fynjx50l588UUbHx9PxsshAiIgAiIgApkIhCqAjP4mJiasubnZq193d7fhJ9wLWPzDSO\/48eN29OhRW7t27WKo2aFDh6y\/v9\/zb9iwwW6\/\/XbPrT8iIAIiIAIikItAqALoKucEEP\/c3JzduHEDZ9Lq6uo8sVu1alUyLNUxOztr165ds9bW1tSopP\/s2bM2NTVlly9fToZFyqHKiIAIiIAIlI1AJASw1NYyQnzsscds\/\/79hlhmKu\/w4cPe\/caRkZFMSRQuAiIgAiIQEwKREMCZmZkk7oaGBqupqUn6czm4N\/jQQw\/Zt7\/9bWtpacmafGBgwIaHh62npydrOkWKQAgEtEsREIEyEwhVAFevXm2dnZ3mBHBsbMzzE54PB8TvueeesxMnTmQd+bmyENf29nZrbGx0QdqKgAiIgAjElECoAgjzvr4+m5+f916DYIufcF5pwHCnMx6UOXDggJ0+fdq778drEJieAk1HS2EiIAKRJqDKhUIgdAFktMe0JK9BsMUPCZ7uxHA7Y4qTp0TZko705PNbV1eXS66tCIiACIiACGQkELoAZqyZIkRABERABERgBQlERABXsIUqWgREQAREQATSEJAApoGiIBEQAREQgeonIAGs\/j6OfAtVQREQAREIg4AEMAzq2qcIiIAIiEDoBCSAoXeBKiACcSagtotAeAQkgOGx155FQAREQARCJCABDBG+di0CIiACcSYQdtslgGH3gPYvAiIgAiIQCgEJYCjYtVMREAEREIGwCUgAw+wB7VsEREAERCA0AhLA0NBrxyIgAiIgAmESkACGSV\/7jjMBtV0ERCBkAoEI4MLCgm3atMl27doVcnO0exEQAREQARHIj0AgAlhXV2dnzpyx7u5u77t+fJdv48aNxgdr86uGUomACIhAjAioqZEgEIgAupbwLT73bb6hoSHr6+tLCuL4+LhLpq0IiIAIiIAIhE4gMAG8fv269fb2JgXvwIEDNjk5aQji1NSUDQ4OGlOlobdYFRABERABERCBBIFABBBh27Jli61fv94TPESPr7Xz1fbEPowpUvxs8ZvprwiIgAiIgAiESyAQAaQJDQ0NtmfPHpxJQxgZFbJNBsohAiIgAiIgAhEgUJIAImw8\/dne3m5Mc7LlARhn+GljTU0NG5kIeATC+LNv3z6776ab7IWEfX3DBsMfRj20TxEQgegQKEkAmdLk6U8nfmyZ\/vQbU59uKjQ6zVZN4kTgpZdess88+aS9kmj0VxP2rXfe8fwSwQQM\/ReBGBMoSQAdN4QQoWPrwkrd+h+qYZTJaDNTmcRt3bpVr11kAhTz8LEvftE2pjDA\/08JUUwJlnfFCWgHIhAdAiUJIMLDPb4333zTexHeTX36t7nEKxMKXqNwD9W0tbXZ6Oho2qS8a7h582a7dOlS2ngFikBnBgSEv5MYDWaIVrAIiECVEyhJABnxMfL7xCc+4b0I75\/6dG6mSElXCEdGfxMTE9bc3Oxl4wV7\/IR7AYt\/EODjx4\/b0aNHbe3atYuh2sSNwOXLl7170EzBp7OJDEBO\/9Zv2c9\/\/vOMeSk3Q1YFi4AIFEEgallKEsCVbowTQPYzNzdnN27cwJk0hPXQoUO2atWqZFg2x9mzZ72TnU5s2ShVVhx9uXv3bu8dVGYj0tnffehDNp3SLPw\/Xr06az7KpfyUrPKKgAhUCYGSBJARGFOc\/inPVDfxpIsCr8OHD3snvJGRkShUJ5Z1QFDSjdJcGA+mpD6t6eLSbbmowe743DesY8fTae2\/\/Pdj1n\/vw3ZfgvgLCbv\/Iw2en\/BMeW7rut8ol\/omsui\/CIhAFRIoSQAZgZ05cyb58rub9vRviSddMexmZmaS2XjPsNTXKQYGBowp256enmS5ZXXEfGeICaOqdKM0wj796U\/bZ55c\/rTmXXfd5V24kCbVKA+sNTfX27qm1ozWnhDAW773lr3+\/I+sLmH4s6Vfd2srxcpEQASqmEBJAsjIjhNS0A\/B8NpEZ2enOQEcGxsz\/ISX0heIKO8mNjY2llKM8hZJAAFkVJVptPZH772X9mnNP37\/\/bQjO0ZvjNQKqc6axOivkPRKKwIiUL0EShJARnaMqIJ+CAbcLKQ9Pz\/vrS3KFj\/hPPW5Y8cOS30ghjhZZRDINFrjqcx0LSD8t2t\/J\/3ornJGaumapjAREIEQCZQkgCtZb0Z7iCvTqWzxs7+WlhbvqU\/nd2E8JUocflllEsj0tOZkYtSmkVtl9qlqLWhU68gAABAASURBVAJRJhCYADIiYzrU\/xAMfsKjDEB1iw6BnyXu0\/F0pr9G+C9+6rP+ILlFoPIIqMaRJBCIACJyX\/7yl5d8DYKRGy+yE058JFuvSkWKAA+mpHtak\/BIVVSVEQERqAoCgQigez8v9WsQzu\/iq4KYGrGiBBC71Kc1V3SHKlwERCC2BAIRQB6G4SnNe++913gyFJps8RNeV1dHkEwE8iage355o1JCERCBIgmUJICIHC+6c9\/v4MGD9u677xqvGeBni\/\/EiRNJUSyyjsomAiIgAiIgAoETKEkAGfnxojv3+zIZ8aQLvOYqsGIIqKIiIAIiEEUCJQlgFBukOomACIiACIhAPgQCE8AjR454L60z\/ek3pkiZKs2nMkojAiJQbQTUHhGILoFABBCBO3XqlJ08edK2bdtmx44d89YHxb19+3bTFGh0DwDVTAREQATiSiAQAQRebW2t1dfXe9\/wY+1OwngNghVaEEj8MhEQAREQgfgQiHpLAxFA95WG0dFR6+josNdee81YsxM\/3\/GLOgTVTwREQAREIH4EAhFA1uV89tlnjdEeo0CWQLvnnnuMVyMef\/xxTYHG77hSi0VABEQg8gQCEUBayX0+Fq1m29\/f790D5NWIrq4uouNpanXFE+DzTVNTUxak8VmoigejBohAFRAITACrgIWaIALLCBw+fDjjx3iZ6SjG+IivRHAZagWIQNkJBCaALHjNycD\/CgR+wsveKu1QBAIikOnjvXyMN4dZuvjbuu43RpUSwIA6SMWIQAkEAhFARI6vPvD1B6Y9neEnnPgS6qisIhAagZqb621dU2twdmtraG3RjkVABJYSCEQA3dceeO3BX7zzu3h\/nNwiIAIiULUE1LCKIBCIAPLgC1994OsP7p0\/tvgJJ74iaKiSIiACIiACsSFQkgAicix1xn0\/Xnng6w98BQI\/W\/z6GkRsjiU1VAREQAQqikBJAsjIjq89uHt+H2wvJl+DIJ50FUVFlRUBERABEah6AiUJoJ8OD7rw1CejP2f4Cfenk1sEREAEREAEokAgEAFE5Hjak6c+\/aNA\/IQTn6mxxCGUiCbTqUyrpkvr\/9rE+Ph4MsmuXbuSX6EgTTJCjtAIaMciIAIiUAkEAhFA95Sne+rTNdz5XbwL92+HhoYMoUQ429rajPVD\/fG4WVeUr02wGgdfmhgcHDSEEyE8d+6ct0oHX6JgJRrSkkcmAiIgAiIgAtkIBCKA3ONDxDZv3uwtgs0OESL8hBNPWKohYqwf2tzc7EV1d3d764kS7gUs\/pmcnDS+NsGi262trXbt2jWbnZ31vj6xZs2axVRma9eu9cKSAXKIgAiUmYB2JwKVQyAQAaS5hw4dsq985SvGIthMZ7LFTzjx2cwJIGn4ekS6ESNCyqLbpLl69apduXLFWlpabP\/+\/YbQHjhwwHjiNJPYko8VOBhFahUOaMhEQAREIN4EAhNAMPoXwWZKEz\/hK2Xc80P4GCHu3bvX7r777uQINN0+3bqOIyMj6aIVJgIiIAIiUAKBSssaqAAW2\/iZmZlk1oaGBmOqMxmw6Jifn\/fu++Fl2pPPLpGPF+0ZGW7YsMEaGxsNMSRNOhsYGDDuE\/b09KSLVpgIiIAIiECMCAQigDy5yZOcbAthh3AhYAgZ+cbGxgw\/4fid8ZFd7vsxNXr+\/HnvfiCCx9Qp9xC5Z0gc06eEuXypW8SVF\/QRytQ4+UVABERABOJFIBAB5L4b9+jSPcGZC2dfX58xuuO+IVv85GF6E8PNvb4tW7YY4rVz505juhORZIqV\/fJgDHHbt2+3UL8\/SGVlIpAHAXc\/mnvSQZjua+cBXUlEIIVAIALIyI\/XEVgODSHzW7Z3+6gLQsa0JPcM2eInHHHDcGO4STM9Pe09\/EIYxkM2hGOkIUxWHgL79u2z+266yV5I2NcTU9D4y7Pnyt+Lux\/NzEkQpm8MVv4xoRaUn0AgAsgIkCXPEKFUI5z48jdNeyyFACOKbCOTv\/zLv7TPPPmkvZLYyVcT9q133vH8X\/rSl7z3MtPlZYo6kbRa\/xfUrjs+94203wtM9w3BXGH6xmBB6JVYBJIEAhHAZGlyVAUBxO9Pv\/Znlm1kcuHP\/9w2prQW\/7W\/\/uuM+RilpGSJrbcmyO8M6huDsT2O1PDSCJQsgLzwvnHjxuRyZKzOUlqVlDtsAgjgTy+8btlGKZ0ZKkl4y2f\/a9rRDSOVDNkULAKVTUC1r0gCJQkgT1\/yHt4zzzzjff2B5ci4t8E9wYqkoUovIZBtlDKxJOUHnsmPNFhT+122rql1uWmk8gEouURABEInUJIA8uoBLeApTLa8msBTmazSgl9WvQR+du\/DNp3SPPwXP\/XZlFB5RUAERCCaBEoSwA+a9IGL9\/UkgB\/wqFZXe0IA+xN2X6KBLyTs\/sTIDz\/hCa\/+i4AIiEDkCQQugJFvsSoYGAHE7pbvvWWvP\/8jq0sY\/sAKV0EiIAIisMIEShZAHm3nJXTe\/WMqlMff+QYgfizXe4Ar3D4VXwYCaxKjvzLsRrsQAREQgUAJlCSAvN\/He36p7\/75\/cSTLtBaqzAREAEREAERKJFASQJY4r6VXQREoOIJqAEiULkEJICV23equQiIgAiIQAkEJIAlwFNWEYgSgaAX2OZ+PosiRKmNqku0CFR6bSSAld6Dqr8ILBJgEYpsy9cVE8fydRLBRcDaVB0BCWDVdakaFFcC2Zauy7Wgdrp4lq5jVCkBjOsRVf3tlgCW0sfKKwIRIpBt6bq0S9OlW67OH6al6yLUu6rKShCQAK4EVZUpAiIgAiIQeQISwMh3kSoYUQKqlgiIQIUTkABWeAeq+iIgAiIgAsURkAAWx025REAE4kxAba8KAhLAquhGNUIEREAERKBQAhLAQokpvQiIgAiIQFUQKFIAg2v79evXjRd0c3054siRI0YabHx8PFkB3IRhu3btSobLIQIiIAIiIALZCIQugENDQ7Z+\/XrjCxJtbW02Ojq6rL4XLlywU6dOGUszHTt2zAYHBw3hJJzVLwg\/f\/688TFewpYVoAAREAEREAERSCEQqgAiYhMTE9bc3OxVq7u72\/AT7gUs\/pmcnLTa2lqrqakxvjmI0M3OzhrhW7ZsMT63tHr1ajt69Ki1tLQs5tJmpQioXBEQARGoBgKhCqAD6AQQ\/9zcnN24cQPnEmOUiMgRePXqVbty5QpOe+ONN2zjxo3e9GiuKVCWdWK0qKWdPHT6IwIiIAKxJhAJASy2B2ZmZrxpT0aCCNu5c+eMe4KZymO6lPuNIyMjmZIoXAREIIWAu3DkNzY1NeXdiijVrYvQFMjyhkIgEgKIkLnWNzQ0eFOdzu+28\/Pz3n0\/\/GvWrLH6+npv6tSNDJkeJa+\/LNL6bWBgwIaHh62np8cfLLcIiEAWAu7CkYvHoExfmcgCXFFlIxCqADKl2dnZaU60xsbGDD\/hfgIdHR3eSI+pUR524X7ghg0bjPC3337bFhYWvGlTpk\/906n+MnAjkO3t7dbY2IhXJgIikAcBfWUiD0gxSVJtzQxVAIHZ19dnjO54jYEtfsJ57QHDzYMtPOyCeO3cudP27t1riKQ\/nLjt27dbV1cXWWQiIAIBEdBXJgICqWIiRyB0AUTImJbkNQi2+KHU399vGG4MN2mmp6eXPOnpwonDTVqZCIiACIiACOQiELoA5qpgpOJVGREQAREQgaohIAGsmq5UQ0RABERABAohIAEshJbSxpmA2i4CIlBlBCSAVdahao4IiIAIiEB+BCSA+XFSKhEQgTgTUNurkoAEsCq7VY0SAREQARHIRUACmIuQ4kVABERABKqSQJ4CWJVtV6NEQARCJBD0GqNaXzTEzqzQXUsAK7TjVG0RqHQCQa8xqvVFK\/2IKH\/9JYDlZ15xe1SFRWAlCAS5xuhtXfcbI0qNAleip6q3TAlg9fatWiYCkSYQ6Bqjt7ZGuq2qXDQJSACj2S+qlQhEhICqIQLVS0ACWL19q5aJgAiIgAhkISABzAJHUSIgAiIQZwLV3nYJYLX3sNonAiIgAiKQloAEMC2WygnkqbepqSkL0ubm5ioHgGoqAiIgAkUSkABmAxfxOMSPd596e3stSKPMiDdd1RMBERCBkglIAEtGGF4BCCDvPuV6n+rff\/ij9gezs7YrYRvffdfwd+x42jIZ71SF1yrtWQREQATKQ0ACWB7OK7qXbO9TLVz6Z\/sfr0\/YK4kafDVhf\/PrX3v+mUTYuqZWS2t6pypBymQiIAJVTkACWOUdfPMLe21jShvx\/8fvP5cSKq8IVD4BZkSCvB9OWcy0VD4ZtSAdAQlgOipVFNaZoS2EX31vLkOsgkWgMgkEtr6o774698QlgpV5POSqdegCeP36de8BjqamJtu0aZMtLCykrfORI0eMNNj4+PiyNLt27TJsWUTMAyYytH\/yIw22JmEZohUsAhVJINf98Ez3vTOFcz+cUaUEsCIPh5yVDl0Ah4aGbP369Xbx4kVra2uz0dHRZZW+cOGCnTp1ynvU\/9ixYzY4OGgIp0uIIKbL5+LjvP3ZvQ\/bdAoA\/Bc\/9dmUUHlFoPIJZLsfnvZ+d6b74C5c98Mr\/6DI0oIMApglR4BRiNjExIQ1Nzd7pXZ3dxt+wr2AxT+Tk5NWW1trNTU11traateuXbPZ2VkvlhEjgvjAAw94fv1ZSqA9IYD9CbsvEfxCwu5PjPrwE57w6r8IiIAIxJZAqALoqDsBxM9L2Ddu3MC5xBglrl692gu7evWqXblyxXMfPHjQHnzwQbvllls8f7Y\/TGXE8aY2YnfL996y15\/\/kdUlDH82TooTAREQgTgQiIQAFguaqU\/ydnV1sclp7gb5yMhIzrTVmCDfe37V2Ha1SQREQARSCURCAGdmZpL1amho8KY6kwGLjvn5+eR9vzVr1lh9fb2NjY159wx5MIaRIPcBsz0IMzAwYMPDw9bT07NYqjYiIAIiIAJxJRCqADKl2dnZaU4AETT8hPs7pKOjw7vvx9To+fPnvfuBGzZssEOHDnkPz\/AAzZ49e2zbtm1emD+v3424tre3W2Njoz9YbhEQgSQBOUQgPgRCFUAw9\/X1GaM7RnFs8RPOaw8Y7paWFtuyZYshXjt37rS9e\/daqkiSTiYCIiACIiAC+RIIXQARMqYlGcWxxU\/l+\/v7DcON4SbN9PS0IYiE+Y14RoT+MLlFQAREIAgC7gE6HqILyqL4bmEQrCqpjNAFsJJgqa4iIALxJOAeoAv6qysSwXCPJwlguPy1dxEQgQogoBVmKqCTiqiiBNAPTW4REAERSENAK8ykgVIFQRLAKuhENUEEREAERKBwAhLAwpkpR3USUKtEQARiRkACGLMOV3NFQASiQ0BPl4bbFxLAcPlr7yIgAlEgEFId9HRpSOAXdysBXAShjQiIgAiUm4CeLi038aX7kwAu5SGfCIiACJSNgJ4uLRvqtDtaFMC0cQoUAREQAREQgaolIAGs2q5Vw0RABERABLIRkABmoxOs+yJ6AAANm0lEQVSTODVTBESguggE\/XRptS7ZJgGsruNerREBERABC\/rp0j\/92p9ZNYqgBFA\/FhGINQE1vhoJBPl06W1d99tPL7wuAazGA0VtEgEREIFqIxDo06W3tlYbnmR7NAJMopBDBERABOJFIO6tlQDG\/QhQ+0VABEQgDwKFPFiTR3GRSCIBjEQ3qBIiIAIiEG0ChTxYE+2WfFC7eAvgBxzkEgEREAERyEKgkAdrshQTqSgJYKS6Q5URAREQgWgSKOTBmmi2YHmtJIDLmSgkHgTUShEQgZgTCF0Ar1+\/br29vdbU1GSbNm2yhYWFtF1y5MgRLw3pxsfHvTSkJQ9hGGm8CP0RAREQAREQgRwEQhfAoaEhW79+vV28eNHa2tpsdHR0WZUvXLhgp06dsqmpKTt27JgNDg4awnnw4EHbvn27l\/fkyZP24osvmhPHZYUoQAREQAQcAW1FIEEgVAFExCYmJqy5uTlRFbPu7m7DT7gXsPhncnLSamtrraamxlpbW+3atWs2Oztrhw4dsv7+fi\/Vhg0b7Pbbb\/fc+iMCIiACIiACuQiEKoCuck4A8c\/NzdmNGzdwLjFGiatXr\/bCrl69aleuXPHc7g+CiDAikC4sdeveY6nGNe1S2yq\/CIiACIhAWgLJwEgIYLI2RTq4F\/jYY4\/Z\/v37ra6uLmMp7j2WkZGRjGkUIQIiIAIiEA8CkRDAmZmZJO2GhgZvqjMZsOiYn5\/37vvhXbNmjdXX1+M07g8+9NBD9u1vf9taWlq8sEx\/BgYGbHh42Hp6ejIlUbgIiIAIiEBMCIQqgExpdnZ2mhPAsbExw0+4n39HR4d334+p0fPnz3v3A7nnh\/g999xzduLEiawjP1cW4tre3m6NjY0uqGxbpl15iCeb7du3z+676SZ7IWFfT9zTxJ8tPdPFxTRAeURABERABMxCFUA6oK+vzxjd8RoDW\/yE80oDhpuR3ZYtWwzx2rlzp+3du5dgO3DggJ0+fdp7MIb8WBSfAkX8du\/e7b3uwSsf6ezTn\/60febJJ+2VRMu+mrBvvfOO57\/rrrsy5qPMRFL9FwEREAERKIJA6ALIaI9pSV6DYIufdvB0J4Ybw02a6elpb6qTdKQnzG9dXV0kj5QhgDyAk20poT967z3bmFJr\/H\/8\/vvWsePptMZ3ulKyyCsCOQgoWgREwBEIXQBdReKwrbm53tY1taa1zgwACP\/t2t9Jm2ddFX+nKwMOBYuACIhAYAQkgIGhLK2giQzZJz\/SYGsSliFawSIgAiKQNwElXEpAAriUR2i+n937sE2n7B3\/xU99NiVUXhEQAREQgSAISACDoBhAGe0JAexP2H2Jsl5I2P2JUR9+whNe\/RcBERABEQiYQLwEMGB4QReH2N3yvbfs9ed\/ZHUJwx\/0PlSeCIiACIjAbwhIAH\/DIVJ\/dc8vUt2hyoiACFQpAQlglXasmrWMgAJEQATKQOAPPr62DHsJZhcSwGA4qhQREAEREIEEgdfe+WXib2X8lwBWRj+pliIgAqUQUF4RSENAApgGioJEQAREQASqn4AEsPr7WC0UAREQgTgTyNh2CWBGNIoQAREQARGoZgISwGruXbVNBERABEQgIwEJYEY01ROhloiACIiACCwnIAFczkQhIiACIiACMSAgAYxBJ6uJcSagtouACGQiIAFMQ+by5cs2NTUVmM3NzaXZi4JEQAREQATCJCABTKGP+O3evdt6e3uz2l133WXP\/uEf2v9O2NN33mn4M+WhvJTdyCsCIiACK05AO8hOQAKYwgcBPHv2rN3xuW9Yx46n09rNt7Xbj99\/315J5P1qwv7m17\/2\/LW3\/ue06W\/ruj+RSv9FQAREQASiREACmKE3am6ut3VNrWntP42dsI0p+fD\/7vj306Zfd2trSmp5RUAEREAEwiZQ3QK4QnQ7M5RL+NX3dL8vAx4Fi4AIiECkCFS8AB45csSampo8Gx8fLwvciQx7mfxIg+lbfhngRCD4V7\/6lV24cMHYRqA6qkIeBOgr9VkeoCKSxPUXt5IiUqWs1ahoAeSHcerUKe9pzWPHjtng4KBdv349a4ODiPzZvQ\/bdEpB+C9+6rMpofKGSGDZrvlxvvnmmxLAZWSiG6A+i27fpKuZ6y8JYDo6AYdNTk5abW2t1dTUWGtrq127ds1mZ2cD3svy4toTAtifsPsSUS8k7P7EyA8\/4Qmv\/ouACIiACFQAgYoeAcJ3\/fr1tnr1apx29epVu3LliudO94enO3O93+fe2Vu4smALC5mtadPn7P89\/UN74o8fsSv9zxr+TOm5KqI+ucrMlD9TuMpdSI7m8mHreHGMZGLqwl3afMp1efLZrkS5K1EmbYlCua4OufrMpUv2V5bfLm3L11Rucb8xzneVYBUvgPlAbmxstE9+8pN2+PDhrO\/28R6fe2fvp\/\/zqP2vo3uy2htD+6xm\/qz9n1efyZru9VePetXMp8xc+\/THq9w9VggD+us\/zPxdzv6CcSHlkj5fW4lyV6JM2hOFcvPtsyjUFWb5WiXVt5C60l+bfueXxjnXO+lF\/E\/FC+D8\/Hzyvt+aNWusvr5+GXI6Y2BgwIaHh\/O2Ey8ds+8e+6vAjH0HXSb1U7l\/5fVp3NnqONBxwPkAW4ljoZAyn3liZ9gCuEwDMgVUtAB2dHR49\/1u3Lhh58+f9+4HbtiwIW1bEcH29naTiYGOAR0DOgZW7hjgXJv2JBzBwIoWwJaWFtuyZYsnajt37rS9e\/cm7wdGkLWqJAIiIAIiECECFS2AcOzv77eLFy\/a9PS0IYiExd3UfhEQAREQgdwEKl4AczdRKURABERABERgOQEJ4HImChGBCiagqouACORLQAKYLymlEwEREAERqCoCEsAiu5N1R90apKxHWmQxylZGArt27fLWjKXfNm7c6K0LWsbda1d5EuAl9a1bty7pH\/3e8oMXVqp0fVYJvzcJYBFHDJ3NS\/UnT540jPVICSuiKGUpEwHWiOWdUdaM1UNTZYJexG5Y33fz5s126dKlZG5+W\/q9JXFEzpGuzyrl9yYBLOJw4p1Dll3jpXveO2Q9UsKKKEpZykSAd0VZK5Y+K9MutZsCCSB0x48ft6NHj9ratWuTuflt6feWxBEpR6Y+q5TfW3UJYBkPjYaGBm8RbrfLmZkZ59Q2ggQ4if7kJz+xe+65x5sGZXomgtWMdZXq6urs0KFDtmrVqmUc9HtbhiQSAZn6rFJ+bxLASBxGqsRKE+jq6vLeF2X6kx8n06G6d7vS1FV+XAlUyu9NAljkEcpXIxjmu+zNzc3OqW04BPLeK18P4SsiGrXnjSz0hPq9hd4FRVcgyr83CWAR3cq3B1l4m0+08P1B7i0RVkRRylImAjxF6KY9uW9x7tw56+7uLtPetZtSCPDb0u+tFILlz1spvzcJYBHHBvPejzzyiHc\/iXtKuAkroihlKRMBpmTYFa9AtLe3W1tbm7kwwmXRJcBvi98YvzUMN2FLaixPpAi431bUf28SwCIPGzqY+0kY7iKLUbYyEuABC\/oLw13GXWtXBRBgTd+JiYkla\/vyG6PfMNwFFKekZSCQrs\/4jdFfGO4yVKPgXUgAC0amDCIgAiIgAhEiUHRVJIBFo1NGERABERCBSiYgAazk3lPdRUAEREAEiiYgASwaXXQyqiYiIAIiIAKFE5AAFs5MOUSgYAK8dM8Tcc54TLzgQvLMwGseqYtJ55lVyUQgVgQkgLHqbjU2DAKI34kTJ2xqaspbjYbtU089ZcGIYBgt0j5FoDoISACrox\/ViogSYDSG+D3++OPm3l1ji39wcNBYNZ+q85K+Gx0imIQR19vbmxRKynIjO1bgx028y4egkufRRx811j3t6+tb8kkhypSJgAh8QEAC+AELuUQgcAKsO0qhrGbC1hnvsg0PDxvLRCF4rEzDyJDPa7344otJ0XPp0235ZFBnZ6c3qty2bZshqKR79tln7fbbb7ehoaEl79IRJ6suAmpNaQQkgKXxU24RyEkg9UsGqRlYk3T79u3eCJEXivke3tjYWGqyZX4+GdTR0eGFa1k3D4P+iEBBBCSABeFSYhEonEDqQs7+Epiy5MsU\/rB8F1ZHAPV9Qz85uUWgMAKVLYCFtVWpRaDsBNzUp5sKdRXgHt6OHTs8L1+m8ByLfxgRLjqXbFh8\/Ze\/\/OWSMHlEQASKJyABLJ6dcopATgI88ML0Jk998hALGdg+\/PDDdscdd3j3ABnx8aAM4Qjj6dOnzT+l6aZDJycnTQIIQZkIBENAAhgMR5VSfgIVs8f+\/n5DBNvb240nNtniJ5xGsOXrFITztYOvfOUr3pcqeEBm7969hiCS71\/+5V\/sYx\/7GFmyWk1NjdXW1pqeAs2KSZEiYBJAHQQiUAYCiByr4jvD798tq+Wni+OhmOnpae9Jz3379tkPfvAD78lOwnEzwqQc\/1OlCCdPmJKPdMTLREAElhOQAC5nohAREIGoE1D9RCAAAhLAACCqCBEQAREQgcojIAGsvD5TjUVABEQgzgQCa7sEMDCUKkgEREAERKCSCEgAK6m3VFcREAEREIHACEgAA0NZvoK0JxEQAREQgdIJSABLZ6gSREAEREAEKpCABLACO01VjjMBtV0ERCAoAhLAoEiqHBEQAREQgYoiIAGsqO5SZUVABOJMQG0PlsD\/BwAA\/\/9MCgVZAAAABklEQVQDAMkBPoAQmDiIAAAAAElFTkSuQmCC","height":0,"width":0}}
%---
%[output:92b301c8]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:709ebe6e]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:3b692bea]
%   data: {"dataType":"text","outputData":{"text":"**          Theoretical Calculations for P_n, L_q, W_q, L, W         **","truncated":false}}
%---
%[output:0bd6c21c]
%   data: {"dataType":"text","outputData":{"text":"**          Theoretical Calculations for P_n, L_q, W_q, L, W         **","truncated":false}}
%---
%[output:941dab7f]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 7                      **","truncated":false}}
%---
%[output:40c4d5fd]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 8                      **","truncated":false}}
%---
%[output:7a7182bd]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:186be3a7]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:5d52c996]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:35cf5e78]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:7b77f549]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:19ed4b9f]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:314a84c8]
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.004706\n","truncated":false}}
%---
%[output:324e3e8d]
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.005226\n","truncated":false}}
%---
%[output:72cbf97d]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:102307de]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:9c8ae4ca]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.024479\nP(2) = 0.063665\nP(3) = 0.110386\nP(4) = 0.143544\nP(5) = 0.149331\nP(6) = 0.129459\n","truncated":false}}
%---
%[output:875c1461]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.027182\nP(2) = 0.070694\nP(3) = 0.122572\nP(4) = 0.159392\nP(5) = 0.165817\nP(6) = 0.143751\nP(7) = 0.106819\n","truncated":false}}
%---
%[output:266f758c]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(6): 1.082949\n","truncated":false}}
%---
%[output:3c6d3671]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(7): 0.369048\n","truncated":false}}
%---
%[output:25e0de42]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(6): 6.284510\n","truncated":false}}
%---
%[output:1dd6cd7e]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(7): 5.570609\n","truncated":false}}
%---
%[output:3584c254]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(6): 1.353686\n","truncated":false}}
%---
%[output:7a3870a5]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(7): 0.461310\n","truncated":false}}
%---
%[output:3b3e95d3]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(6): 7.855637\n","truncated":false}}
%---
%[output:7516ff1b]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(7): 6.963261\n","truncated":false}}
%---
%[output:188a9c2c]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:185d039b]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:406c3077]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:1306c3db]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:035f4a4e]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:51083173]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:20fa5b6b]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:688e1c16]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:4c769c65]
%   data: {"dataType":"text","outputData":{"text":"**          Simulation Calculations for P_n, L_q, W_q, L, W          **","truncated":false}}
%---
%[output:4cb52585]
%   data: {"dataType":"text","outputData":{"text":"**          Simulation Calculations for P_n, L_q, W_q, L, W          **","truncated":false}}
%---
%[output:744ad40d]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 7                      **","truncated":false}}
%---
%[output:1a7907d0]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 8                      **","truncated":false}}
%---
%[output:02b225d9]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:1e3e776b]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:80ddafa8]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:5d57a3db]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:0115b2f5]
%   data: {"dataType":"text","outputData":{"text":"Working on sample 1\nWorking on sample 2\nWorking on sample 3\nWorking on sample 4\nWorking on sample 5\nWorking on sample 6\nWorking on sample 7\nWorking on sample 8\nWorking on sample 9\nWorking on sample 10\nWorking on sample 11\nWorking on sample 12\nWorking on sample 13\nWorking on sample 14\nWorking on sample 15\nWorking on sample 16\nWorking on sample 17\nWorking on sample 18\nWorking on sample 19\nWorking on sample 20\nWorking on sample 21\nWorking on sample 22\nWorking on sample 23\nWorking on sample 24\nWorking on sample 25\nWorking on sample 26\nWorking on sample 27\nWorking on sample 28\nWorking on sample 29\nWorking on sample 30\nWorking on sample 31\nWorking on sample 32\nWorking on sample 33\nWorking on sample 34\nWorking on sample 35\nWorking on sample 36\nWorking on sample 37\nWorking on sample 38\nWorking on sample 39\nWorking on sample 40\nWorking on sample 41\nWorking on sample 42\nWorking on sample 43\nWorking on sample 44\nWorking on sample 45\nWorking on sample 46\nWorking on sample 47\nWorking on sample 48\nWorking on sample 49\nWorking on sample 50\nWorking on sample 51\nWorking on sample 52\nWorking on sample 53\nWorking on sample 54\nWorking on sample 55\nWorking on sample 56\nWorking on sample 57\nWorking on sample 58\nWorking on sample 59\nWorking on sample 60\nWorking on sample 61\nWorking on sample 62\nWorking on sample 63\nWorking on sample 64\nWorking on sample 65\nWorking on sample 66\nWorking on sample 67\nWorking on sample 68\nWorking on sample 69\nWorking on sample 70\nWorking on sample 71\nWorking on sample 72\nWorking on sample 73\nWorking on sample 74\nWorking on sample 75\nWorking on sample 76\nWorking on sample 77\nWorking on sample 78\nWorking on sample 79\nWorking on sample 80\nWorking on sample 81\nWorking on sample 82\nWorking on sample 83\nWorking on sample 84\nWorking on sample 85\nWorking on sample 86\nWorking on sample 87\nWorking on sample 88\nWorking on sample 89\nWorking on sample 90\nWorking on sample 91\nWorking on sample 92\nWorking on sample 93\nWorking on sample 94\nWorking on sample 95\nWorking on sample 96\nWorking on sample 97\nWorking on sample 98\nWorking on sample 99\nWorking on sample 100\n","truncated":false}}
%---
%[output:82d96a0f]
%   data: {"dataType":"text","outputData":{"text":"Working on sample 1\nWorking on sample 2\nWorking on sample 3\nWorking on sample 4\nWorking on sample 5\nWorking on sample 6\nWorking on sample 7\nWorking on sample 8\nWorking on sample 9\nWorking on sample 10\nWorking on sample 11\nWorking on sample 12\nWorking on sample 13\nWorking on sample 14\nWorking on sample 15\nWorking on sample 16\nWorking on sample 17\nWorking on sample 18\nWorking on sample 19\nWorking on sample 20\nWorking on sample 21\nWorking on sample 22\nWorking on sample 23\nWorking on sample 24\nWorking on sample 25\nWorking on sample 26\nWorking on sample 27\nWorking on sample 28\nWorking on sample 29\nWorking on sample 30\nWorking on sample 31\nWorking on sample 32\nWorking on sample 33\nWorking on sample 34\nWorking on sample 35\nWorking on sample 36\nWorking on sample 37\nWorking on sample 38\nWorking on sample 39\nWorking on sample 40\nWorking on sample 41\nWorking on sample 42\nWorking on sample 43\nWorking on sample 44\nWorking on sample 45\nWorking on sample 46\nWorking on sample 47\nWorking on sample 48\nWorking on sample 49\nWorking on sample 50\nWorking on sample 51\nWorking on sample 52\nWorking on sample 53\nWorking on sample 54\nWorking on sample 55\nWorking on sample 56\nWorking on sample 57\nWorking on sample 58\nWorking on sample 59\nWorking on sample 60\nWorking on sample 61\nWorking on sample 62\nWorking on sample 63\nWorking on sample 64\nWorking on sample 65\nWorking on sample 66\nWorking on sample 67\nWorking on sample 68\nWorking on sample 69\nWorking on sample 70\nWorking on sample 71\nWorking on sample 72\nWorking on sample 73\nWorking on sample 74\nWorking on sample 75\nWorking on sample 76\nWorking on sample 77\nWorking on sample 78\nWorking on sample 79\nWorking on sample 80\nWorking on sample 81\nWorking on sample 82\nWorking on sample 83\nWorking on sample 84\nWorking on sample 85\nWorking on sample 86\nWorking on sample 87\nWorking on sample 88\nWorking on sample 89\nWorking on sample 90\nWorking on sample 91\nWorking on sample 92\nWorking on sample 93\nWorking on sample 94\nWorking on sample 95\nWorking on sample 96\nWorking on sample 97\nWorking on sample 98\nWorking on sample 99\nWorking on sample 100\n","truncated":false}}
%---
%[output:14cc19a7]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 6.111535\n","truncated":false}}
%---
%[output:92483fd7]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 5.449680\n","truncated":false}}
%---
%[output:509f0b6f]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAcAAAAFQCAYAAAAoQ64wAAAQAElEQVR4AeydfWwd13nmX7fdLkCJUtwq5Fpkk1Bm19k6pOAtiLAgQgUthTLRKk5E2LVkGkmcNGJsB3asj60MuLbhhbQW5dRCZJkSEMJCaMqJQcZCqi0XolGbWQJyBMOg5Di2lys5isRUdNB1JEX\/FGh7f2Oe6+Hl\/b5DztyZR9DLOd9zzu\/MzHPPmZkzv\/Nv+icCIiACIiACCSTwO6Z\/IiACIiACIpBAAhLABHZ6uslyiIAIiECCCUgAE9z5aroIiIAIJJmABDDJva+2J5mA2i4CiScgAUz8ISAAIiACIpBMAhLAZPa7Wi0CIpBkAmq7R0AC6GHQHxEQAREQgaQRkAAmrcfVXhEQAREQAY9AQgXQa7v+iIAIiIAIJJiABDDBna+mi4AIiECSCUgAQ+797du325o1a2x8fDxdE8LWrVtns7Oz6bAgHItVbqG60TbaiFGHQumDiD9z5ow98sgjWYuKWiB1Xbt2rQ0MDJRctatXrxpMOVZwb9myxTDcJRe2yBnoD9q6yLvJWzz7L5d13oIXOZI+5vzx22JcIxa5GZErXgIYkS4ZHBy0KF60gsAzNjZmtbW1duzYMdu3b18QReYtAzG477777Le\/\/W3edFGJbGlpsampKevr6yu5So8++qidOnWq5HxLnQFxf\/HFF5d6t7HZH+fN2bNnDTt8+LDXrs2bN1tdXZ3n1p\/yCEgAy+MWeK6TJ0\/a0NDQgnIRRX7RY7i5uPPLj1+E+AnHtm7d6o0k+XX73HPPGVt+LZIus9AHHnjAS0s8ozMXj5swjH2wL+JcOGURx5Zwv5GWPMRjXPCIZzs6OmpXrlyxW2+9dd5Il3jMlU8+6s2vdMLZD2VStr+tuImnbPJg\/nS075e\/\/KWxX9iQnjJIQ1qMvJRBHGmwYhhmlkPdKYc6U3fKYEt5lE0b2B\/mwkjvN5fX1Yk81JURE\/kojzT+PLhJTxtp6\/r16+3NN98k2GPNxZG8lEOdvYjUH\/IQjuWqTyqZNxolDebKoBzc1I80GG7CiMNwkwdjX6SB0d69e716uWMANuyfdJhL68qAo4unTI5p0mEuLWU7Yx\/EsSWMemX6Keef\/\/mfibbXX3896zmSq14unDpRN8qmPOrrFZjxh\/6i30iHuXplJCvZSz34sdze3m69vb0l51eG+QQkgPN5hOJjdNTY2GhHjx4ta9rzZz\/7mTHiYYRFA\/iFeOLECdu5c6cnAv6Tj4vl3XffbadPnzZOoscff9zbJyfstm3bvDzENTQ02AMpoeSEo0xn\/ALl16jzs+UicNttt1lbW1v6FyoXPPbLqGbTpk3pEWBXVxdZ0ub2S53Z780332x79uwpOBom3zPPPOPVlx8PFMg+ly9fbk899ZT90R\/9kbHf4eFhu3btmuWqH\/mwYhjC4oEUE9hQV\/jCjLpQBobQT05OGvulXggUbaNv2Ee2HznkyzT66TOf+YxRxkc+8hE7cuRIZhJvxEgbaSv9\/Sd\/8idemvPnz9vu3bu9Eff777\/vHQNE0B8woj6Ue\/HiRWMESZzfaE82tow26GNGnPQ5hpsw4iibcigbNpRBWfQ5fo5zOOBnv+yftNSHvNSP\/Nhbb71l9CNxsDh+\/Lh3zNJeVy7pnLW2tnp9zmwD\/TQzM+NFTU9Pe8cSfur5B3\/wB1646yfqBTvqSUShetGH7lzzsyWvM\/bPMcyxzHFCnd155tKwZZ9+kUQoMUSWMkiTafDCOIc51jPj5S+NgASwNF6LkpoLHL8qOdG5YJa6E060pqYmq6+vN8riROeC1NzcvKAoLpZcLDh5OInYJycpF20Sd3R0GHGdnZ3GBQrxIBzr7u5ms8DITzkuHmHF+KWa60R2hbBf6uzqhHBg1MGlybflwgmzV155Jef0ar76uWnSYhieO3fOuADChvrBirpdunSJjWcuzvPM\/fnGN75hpCllmhOxoD9ramoMweUCXojl3O68Y4C8GGwRAeIQB9f\/HB8cJ\/nKzcaWPqavYYrhJozyMfz82OCiT3uZ3iXcb5nCSd9TL1dP0lI36kgbYOG4ZjumSU9a8tCe9957zzt2CZ+YmLA33njD6zd\/PVevXu0d55SHGNI\/xdQLntQJw+2vM\/vzG0JF3yOqHJ\/U0R8PGxjxo9Jv+Y5\/fx\/6y5K7OAKZqSSAmURC8jOFxUWDX7c\/\/elPl7wWnMhcCJii4lcoFz9+4XJhKFQZ8nKR4qJQKG1mPHkzw4rxc\/GAGWmpK3XONjVGPPsot37kdwYLGLn9wQo\/5bs0\/i0\/AjDCuBBSR\/8oh\/BcxsW1HJ6Uh2AinLidIZ6IAwJFnagLPxwyf+SQPh9bv1hlXoy\/\/OUveyN9t49cU4Rw5Nhi\/9SD+pAnF0fqVIwhZvxAoVzKv\/feez0h\/Id\/+Acvu58nab1A359i6pWNra8Iz8mPI35c4kEEYZZtVFfqCDBToClfVhkBCWBl\/ALNzQWEAi9cuMBmSY0LAiLBFJX7NcqvUy6GhSpCXoSAC0ihtJnx5OViVU5epmKpK9NklMuPBy4quP3GPsqtn78cLqAwYtqM\/Tpjmtefzrm5EPJrnnTkITzbVBjhi23UhVEPIy0uytQJyzYyoS652DKKYaTFlOTbb7\/tTXsTRh6OFY4ZRoZO1PixQJzf4IjA84OPOjhjn\/50pbrdiPwf\/\/EfjRE9fo6t73\/\/+56fWZJ8ZQZZL6Z5aResHfPM6W\/Hi3R+45ihvzLrCld+KPhHsplp5C+NgASwNF6LmpoTwo1q3I44EbhwuV\/q7iRw8SVtU4k5gfiFzIiAKUpOTn6hcrFIRRtTksTxixXDTXg+Iz\/lMCIgHSc9xq9g6k9YLvPvlzQ8vOBGDggXFzDE0U0\/kgZjJMXogS0XGy6mXFS5iBHvt3z1W7ZsmT9pXjcXUC6sTKvBhREn93CyiS4F+eN5YAFRKGYEQd7FMC6c9D\/HEKMJOMM7c18wzceWchhpYbjJDw+OFwz\/rl27vNEgfYjfbwgmIsr9Q+rh358\/Xalu1z88DMQ586lPfcoTPspxU6i4c1lQ9aJNji1lPvzww94us7HwIor8wwiZH2DZjvEii1CyDAISwAwgYXsZKSAm\/nowMkQIuIA60fLHl+KmbC7giAIXsAMHDniPUiO+Tz75pPGLnTgEl4cQCgkY++Ykf+GFF7zH8blwMt3HqAxhIj6f+fdLXh5IcHVyosZU40MPPWQf+9jH0kVRNqzYF\/kQdS401AXjAksYFyIylVs\/8jqDBUxgAyNYwYw2uDT+LSNDftBQf9LDG2GgHH+6StwIEKLGscFoLl9ZfmakR4y5P5WZx58uky1paQvHEYabMNrkZ0Ob+bGA8BPvfugQzg8D9sv+qQd9SF+yX9KWa9QBoSM\/XPAjhPiLFZ8g6sXxxzHMsQw\/2sexXGn7aIcsWAISwGB5llwa0z5cuDhpyMwWP4abMC6wTC0xTcL0CHHk4wTHj+EmvYsjHyccedjiJw\/xpCecMimbOIx0hGOkozx\/OPH4sxlpyUNezJ+W\/Wbuy18GacmD+dP5y\/zxj39sGHWnreRHYMjjjHIIx9gn4dSJcjDchGEuLWVRJobbpSM\/5ZDOn97FE4YRTzo4UnfqhN8Z5ZAOI550Ls5tCSPO5SUPdWVf1Im6YbhdHrdl\/5SNbdiwwXv61KUlP+VQnpl5WdgHaTGXzovI+ONPR1r2k5Fk3vQncW5\/pMf85bs2Ek7ZtIV4\/Bhh\/jJcnV0+F88WVoSTPtOIpzxXX8rx+8lHftKRl3T++Fz1cuHUGbdrK+VTTqa5\/VA2litdZr58fupM3Sk7XzrFFU9AAlg8K6UUgcQTYMqUURsgGLWxlYlAtRIIXQDdvQOmCpiuYv48F0ziNm7caP57LpyQ5MWYWsmVV+EiIAKVE2Akw4iGkSWjoMpLVAlLQkA7yUogdAHkySjm6Tmp3H2bbDVF9Lifwku+Lp6b59xI54ELnl5keoJ0Ll5bERABERABEchFIFQBZPTHAxnuBjU3rvET7q8wIz9Wwjh06JCtXLkyHcXTUCtWrEj7iSMsHeBz8GoBQonh9kXJKQIiIAIikEACoQqg4+0EED9P2PlXHyGMqRamXjIfWedmMEs+MTJk6SGWEiMtefx24cIF27Fjh7dKPo9pj4yM+KPlFgEREAERSCCBSAhgudy554fw8e4aj5d\/\/vOfn3d\/0JXLiO\/VV1+1\/v5+7ym5np4eF6WtCIiACIhAQglEQgB5wdPx592gzGWcXFzmlny898NjybwEy4LSiGFmOuenbJ5gI50L0zb+BNRCERABEchGIFQBRLgQMISMyrGSCH7C8Rcypk7dPUOmTZk+JaxQPsWLgAiIgAiIQKgCCH5WimCRXl5jYIufcKY3Mdy5jBdDeYKU1SgY2fENNF5szZVe4SIgAkkjoPaKQG4CoQsgoz1eX+A1CLb4qS7ihuF2xkMvjPjYujAejiEvlpnepdFWBERABERABDIJhC6AmRWSXwREQAREQASCIFCoDAlgIUKKFwEREAERiCUBCWAsu1WNEoFkEuCVJxa7kJ20xWAA3zgdWRLAOPVmZlvkF4EEEeDi7F\/wgkUvZFvSC4AEwQK+cI7LYSUBjEtPqh0ikHACXJj9C17wUJ1s2Fv8IwgO999\/v8EXznE51CSAcelJtUME5hNIrM8teMGrUVFY9II6UJdqt09\/+tOxO6YkgLHrUjVIBEQAAoxUmLILYuqvkjKoA3WhTrJoEZAARqs\/VBsREIGACCA6TNndcvuD1rH1iVDspq47C04b8lm3Qot+5EOSNb8vA1\/Xee6557wQ9kN6z6M\/JgHUQSACIhBrAjXX19uqNa3h2I2tBdmyetViLuJx7tw5e+edd7x6sB\/253n0RwKoY0AEREAElooAH+xeu3atsfQjW\/yMyBiZ8d3TrVu32saNG714wrZv3+652TKSY0s66ks8eXE7I56yMaZtL126ZHwx5\/vf\/76RHiMPZRFPOsyFsX\/WYyZs3bp15vblyo\/bNqYjwLh1k9ojAiIQBwJ8rebJJ580lm6cmpoy\/7KOtI\/1kHfv3u29w3f06FHr7u723IT\/+te\/JklOQ6y+8pWveGWfPn3aamtrPQHjU3F33XWXMfpzmYeGhox1lKkH7wsODg4a5V+5csX+9m\/\/1iujra3NKMflieNWAhjHXlWbREAEIklg06ZN9vjjj3ujOjcC9Ff0pptuMj7tRhhPs7LQP5+HQ6wIy2d1dXX2T\/\/0T17Z5EPY8qVHXImnfCeW7Ie8hCfhyzoSQHpaFisCaowIRJUAIvXKK694IyxGgkeOHCmpqozQmNYkk\/uMHG6M6dSf\/OQnXtmM3Nrb2wnOaXx+jkg+JUe51A1\/kkwCmKTeVltFIIEEfv3\/Ttuvz4Zj1\/7\/pXnEuQfH\/TVs27Zt9uUvf3lefD4PI7VbbrnFbr31Vm+U99Zbb81LXl9fby+\/\/LIX19HR4cU5sXzxxReN+4NeYOoPn51jWpV6IJR33323rVq1KhWTMRC09wAAEABJREFUrP8SwGT1t1orAjEn8GHzeAGdpz\/fHn\/OJg\/991Ds9R9+x3iBnLpQM+7Dcd8Nc\/cAeSqTcEZgfN6NT8LhZvUWtvgJx0068mJ\/\/\/d\/b+TFCCf+lbnRJWUfOnTIi+c+I37KIB3pKZPyKQdzYaShHFdXwnHH1SSAce1ZtUsEEk4A0Rl99kBgS4EhGOVYf3+\/UZeEd0ckmy8BjGS3qFIiIAJBEEB4mOIL06hDEG1RGYUJlJpCAlgqMaUXAREQARGIBQEJYCy6UY0QARGoBgK8gK5lyaLTUxLA6PRF5TVRCSIgAoEQeOyxx+yO666zgyn7VlOT4Q+iYP+yZEGUpzIqIyABrIyfcouACMSMwLPPPmtffPRRez7VrntS9t133\/X8QYigf1myVNHGu3i8ioCxHBlh\/lclcBPGyDHf0mV\/9Vd\/ZX\/9139tvAtIevJhuGW5CYQugP6OLbT2HEv9sE6e62SaxUHDwYP533MhTiYCCSKgpgZEYOyrX7W1GWXh\/3lKFDOCS\/ZmW5aM1xAOHz7siSHXttdff91bgoxwXnbnGpdr6TIq8PTTT9sPfvAD+9M\/\/VNjqTWuqeRj1RniZbkJhC6A\/o5l7bnR0dGsteXAWL9+vZ0\/fz4dT9j+\/fu9tfJY+YDVDAhLJ5BDBERABEok0JkjPeHvpkaDOaLLCnbLkfES+7Jly4wX10+cOGEsR8aPeq6HiBmFu7S8EO+WLmNLXuIRPNIimPjd+3y4ZdkJhCqA\/FKZmJgwt+YcHYyfcH91GfmxZBAvdq5cuTIdxa+dDRs2GB3Ni53E89JnOkGGg2+DsT4e3wnLiJJXBERABDwCE97fhX9+\/olP2CdStjAmuBDEjB\/6\/KBnBIj19fV5O2C6FEfWpctSEVwHEdHvfOc7xrU0FaT\/BQiEKoCubk4A8V+8eNHoYNzO6FhWKKBzXZjbMl3AorL8Wio0BcpokXn0kZERl11bERABEZhH4L+kpjqn5oWY4V\/1la9khJbnzVyWzF8KP+BZ7syNALmuMaIrdumyz3zmM3bdddd5I0h\/uXJnJxAJAcxetcKhDPeZ9mQkyMju1KlTxsGSKycrMrCSQ09PT64kChcBEUg4gUceecReTIngHSkOB1P2rdSoDz\/hKW9F\/xG4zGXJKJBw95ANIz5Gfs5YjowZLq5dmWEMDBggUIYzbiVlhrk4becTiIQAImSuWnwChDlu58+3ZeTI5zuWL19u5CGvv6zMvMS3t7drWaJMMPKLgAjMI4DYPf9v\/2afP3fOvpsy\/PMSRNDDU5+lLrAdwWYsaZVCFUB+1XR2dpoTLea48RNeDAVWPH\/77be9jz4ybcr0KaJYTF6lEQEREIFCBBb7nl+h\/ZcSz8iR0SWjyVLyJTltqAIIeP\/cNp\/nwE84v2Yw3LmMjuYhGEZ12ObNm73Vz3OlV3g8CahVIuAn4B5247aI7KT3lHwQHBhg+DnHwR26ADLac3PbbPEDll8zGG5nCB5PibJ1YaRx8+K4Xbi2IiACySLAotN8esg97MYDb7ItFhSDHTt2zPu0UxyOrtAFMA4Q1QYREIGwCHy4XwTQPejGj2nZcOCfgoIvnD+kXt0uCWB1959qLwIi4CPAxZnbIbJ2WwwG8PXhrnqnBLDqu1ANEAEREIFkEqi01RLASgkqvwiIgAiIQFUSkABWZbep0iIgAiIgApUSkABWSjDM\/Nq3CIiACIhA2QQkgGWjU0YREAEREIFqJiABrObeU909Anzdo9CLvqyzmPmF70J5KNfbQTT\/qFYiIAIVEpAAVghQ2cMlgEjxgm6+l32\/8IUv2BcffdSeT1X1npR99913Pf\/nPve5vC8JUy7lp7LovwiIQAwJSABj2KlJahICxdJXt9z+oHVsfSKr\/fl772X9wvdfvv9+1vSUc1PXnUa5lJ8knmprlRBQNQMhIAEMBKMKCZtAzfX1tmpNa1brzFE5wn+\/9g+z5ll1Y2uOXAoWARGICwEJYFx6Uu3ISWAiR8zkRxtsRcpyRCtYBEQg5gSqVABj3itqXqAEfnHbfTaVUSL+s5\/9UkaovCIgAkkiIAFMUm9HoK3cUyv09GUp8cV8oqU9JYB9Kbsj1f6DKbszNerDT3jKq\/8iIAIJJSABTGjHh9FsxI8nK\/M9sVlMnD8N5RXTFsTuhh++Za89\/ZLVpQx\/MfmURgREIL4EJIDx7dvItQwB5MnKfE9s8gRmKcbTmqU0VPf8SqGltCIQbwISwHj3byRbl++JzenXJuxf\/uZ2+7OU\/euT3zb8uZ7u9ML1tGYk+3jxKqWSRSA4AhLA4FiqpAoJvPnyj2zghQPpF9afe++i5z+ZCquwaGUXAREQgQUEJIALkCggLALXH9yV9YX1j0sAw+oS7VcEIkUg6MpIAIMmqvLKJsCL6dkyE345NRrMFqcwERABESiXgASwXHLKFzgBvbAeOFIVKAIikIdA6AJ49epVb0HiNWvW2Lp162x2djZndYnbuHGjnTlzZkGa7du3G7YgIk4BMW+LXliPeQereSIQMQKhC+DQ0JCtXr3azp49a21tbTY6OpoVEaK3fv16O3\/+\/IL48fHxnPkWJFZAZAnwbh4vqOuF9ch2kSomArEiEKoAMvqbmJiw5uZmD2p3d7fhJ9wLmPvDyO\/IkSN26NAhW7ly5VzoBxviBgcH7a677vogIM9f3kFjlRHeR8uTTFEhEkAEb9AL69l6QGEiIAIBEwhVAF1bnADiZ2mra9eu4UxbXV2d7du3z5YtW5YOc469e\/fa3XffbTfccIMLyrndv3+\/N906MjKSM40iokFAL6xHox9UCxGIM4FICGC5gJn6JG9XVxebgtbf32\/Dw8PW09NTMK0SiIAIiEBkCKgii0IgEgI4PT2dblxDQ4PV1NSk\/fkcY2Nj3r0\/HqBhJMj9w3wPwlB2e3u7NTY25itWcSIgAiIgAgkgEKoALl++3Do7O80JIIKGn\/Bi2DMtysMz2M6dO23Tpk3eVGkxeZVGBERABEQg2QRCFUDQ9\/b22szMjDGKY4uf8IGBAcNwm+mvCIiACIiACARLIHQBZLTHfTlGcWzx08S+vj7DcDtraWnxnhJl68LclrSMCJ1fWxEQAREQARHIRyB0AcxXOcWJAARkIiACIrAYBCSAi0FVZYqACIiACESegAQw8l2kCopAkgmo7SKweAQkgIvHViWLgAiIgAhEmIAEMMKdo6qJgAiIQJIJLHbbJYCLTVjli4AIiIAIRJKABDCS3aJKiYAIiIAILDYBCeBiE66kfOWNPIHHHnvM7rjuOjuYsm81NRn+yFdaFRQBEfAISAA9DPojAqUTePbZZ+2Ljz5qz6ey3pOy7777rueXCKZg6L8IVAEBCWAVdJKqGE0CY1\/9qq3NqBr+n6dEMSO4HK\/yiIAILDIBCeAiA1bx8SXQmaNphL+bGg3miFawCIhARAhIACPSEapG9RGYyFHln3\/iE\/aJlOWIVrAIFCagFEtCQAK4JJi1k2ol8Oqrr9rJkyezWu3Xv25TGQ3DP\/3JT2ZN78q5cOFCRi55RUAEwiAgAQyDuvZZNQT2799vW7ZsyWovvfSSffYjH7E7Uq05mLIv\/d7vef633347a3pXzo4dO0wimAKm\/yIQMoGICmDIVLR7EZgjcMvtD1rH1idy2n\/7m8P2H\/7nD+0n\/2PYlqcMf770N3XdaYwqJYBzgLURgRAJSABDhK9dR59AzfX1tmpNa0H7T\/\/5vxZM45VzY2v0G60aikBCCEgAE9LR1dRM1VUEREAEloKABHApKGsfIiACIiACkSMgAYxcl6hCIpBkAmq7CCwdAQng0rHWnkRABERABCJEIHQBvHr1qvfI+Jo1a2zdunU2OzubEw9xGzdutDNnznhp8JOHvNjAwIAXrj8iIAIiIALVR2Cpaxy6AA4NDdnq1avt7Nmz1tbWZqOjo1kZIHrr16+38+fPp+P37t1rmzdv9vIeO3bMnnnmGRsfH0\/HyyECIiACIiACuQiEKoCM\/iYmJqy5udmrX3d3t+En3AuY+8NI78iRI3bo0CFbuXLlXKjZvn37rK+vz\/M3NTXZzTff7Ln1RwREQAREQAQKEQhVAF3lnADiv3jxol27dg1n2urq6jyxW7ZsWTos03Hu3Dm7cuWKtbbmfs+KF5BZjiqyLyFnNkp+ERABERCBRSMQCQGstHWMEB966CHbvXu3IZa5ynPLWo2MjORKonAREAEREIGEEIiEAE5PT6dxNzQ0WE1NTdpfyMG9wa997Wv2ve99z1paWvIm7+\/vt+HhYevp6cmbTpEiEAIB7VIERGCJCYQqgMuXL7fOzk5zAjg2Nub5CS+GA+J34MABO3r0aN6RnysLcW1vb7fGxkYXpK0IiIAIiEBCCYQqgDDv7e21mZkZ4zUGtvgJ55UGDHc240GZPXv22IkTJ7z7fuTH9BRoNloKEwERiDQBVS4UAqELIKM9piV5DYItfkjwdCeG2xlTnDwlypZ0pCef37q6ulxybSsgwINCPDAUpPGAUwVVUlYREAERCJRA6AIYaGtUWCAEED++Wee+XxfUljIDqaAKEQEREIEACEREAANoiYoIjAACyCsjhb6Fl++7d9ni+BZeYJVUQSIgAiJQIQEJYIUA45y92G\/hed+5K+Kbeav0Lbw4Hy5qmwhUHQEJYNV1WfwqrBaJgAiIQBgEJIBhUNc+RUAEREAEQicgAQy9C1QBEUgyAbVdBMIjIAEMj33V7\/nkCwfsV7d\/0v44ZbP3\/oXhr\/pGqQEiIAKJISABTExXB9vQN1\/+kQ2kBPD5VLH3pOy59y56folgCob+i4AIFEUg7EQSwLB7oEr3f\/3BXbY2o+74P54SxYxgeUVABEQgkgQkgJHsluhXqjNHFQm\/nBoN5ohWsAiIgAhEhoAEMMyuqOJ9T+So++RHG2xFynJEK1gEREAEIkNAAhiZrqiuivzitvtsKqPK+M9+9ksZofKKgAiIQDQJSACj2S+Rr1V7SgD7UnZHqqYHU3ZnatSHn\/CUV\/8LE1AKERCBkAkEIoCzs7O2bt062759e8jN0e6XkgBid8MP37LXnn7J6lKGfyn3r32JgAiIQCUEAhHAuro6e+WVV6y7u9v7rh\/f5Vu7dq3xwdpKKqe81UFA9\/yqo59UywgRUFUiQSAQAXQt4Vt87tt8Q0ND1tvbmxbE8fFxl0xbERABERABEQidQGACePXqVeO7cYz+sD179tjk5KQhiHxUdXBw0JgqDb3FqoAIiIAIiIAIpAgEIoAI24YNG2z16tWe4CF6fK2dr7an9mFMkeJni99Mf0VABERABEQgXAKBCCBNaGhosJ07d+JMG8LIqJBtOlAOERABERABEYgAgYoEEGHj6c\/29nZjmpMt05\/O8NPGmpoaNjIR8AjojwiIgAhEgUBFAsiUJk9\/OvFjy\/Sn35j6dFOhUWiw6iACIiACIiACEKhIACkAQwgROrb4gzD\/QzWMMhlt5iqXuI0bN+q1i1yAFOgbB90AABAASURBVC4CkSGgiohAdAhUJIAID\/f43njjDe9FeDf16d8WEq9cKHiNwj1U09bWZqOjo1mT8q7h+vXr7fz581njFSgCIiACIiAC2QhUJICM+Bj5fepTn\/JehPdPfTo3U6Sky7bzXGGM\/iYmJqy5udlLwgv2+An3Aub+IMBHjhyxQ4cO2cqVK+dCtREBERABEYgigajVqSIBXOzGOAFkPxcvXrRr167hTBvCum\/fPlu2bFk6LJ\/j1Vdf9R7WuXDhQr5kihMBERABEUgAgYoEkBEYU5z+Kc9MN\/GkiwLL\/fv3ey\/rj4yMRKE6qoMIiIAIiECIBCoSQEZgr7zySvrldzft6d8ST7py2jg9PZ3OxnuGlb5O0d\/fb0zZ9vT0pMtdUod2JgIiIAIiEBkCFQkgI7vFeAiG1yY6OzvNCeDY2JjhJ7wScogo7yY2NjZWUozyioAIiIAIxIBARQLIyI4RVdAPwcCVhbRnZma8xbTZ4iecpz63bt1qmQ\/EECcTgQgTUNVEQAQiRqAiAVzMtjDaQ1yZTmWLn\/21tLR4T306vwvjKVHi8MtEQAREQAREoBCBwASQERnTof6HYPATXqgSihcBERCBWBNQ4yJJIBABROS+8Y1vzPsaBCM3XmQnnPhItl6VEgEREAERSCyBQATQvZ+X+TUI53fxiaWshouACIiACESOQCACyMMwPKV52223pT96yxOi+Amvq6uLXMNVIREQAREQgWQTqEgAETledOe+3969e+2Xv\/yl8ZoBfrb4jx49mhbFZKNW60XgQwJuVSK+oBKEaXWjD9nKJQLFEqhIABn58aI79\/tyGfGkK7ZCShc\/AmrRQgJuVSIeFAvCvn7vt00iuJCzQkQgH4GKBDBfwYoTARHITeCW2x+0jq1PBGI3dd1p75x5TQKYG7diRCArgcAEcGBgwHtpnelPvzFFylRp1r0rUAQSSqDm+npbtaY1GLuxNcIUVTURiC6BQAQQgTt+\/LgdO3bMNm3aZIcPH\/bWB8W9efNm0xRodA8A1UwEREAEkkogEAEEXm1trdXX13vf8GPtTsJ4DYIVWhBI\/DIREAEREIHkEIh6SwMRQPeVhtHRUevo6LCf\/vSnxpqd+PmOX9QhqH4iIAIiIALJIxCIALIu51NPPWWM9hgF8lTbrbfearwa8fDDD2sKNHnHlVosAiIgApEnEIgA0kru87FoNdu+vj7vHiCvRnR1dRGdTFOrRUAEREAEIksgMAGMbAtVMREQAREQARHIQiAwAWTBa6Y+\/a9A4Cc8y34VJAJxJ6D2iYAIRJxAIAKIyPHVB77+wLSnM\/yEEx9xDqqeCIiACIhAwggEIoDuaw+89uDn5\/wu3h8ntwiIgAjEloAaVhUEAhFAHnzhqw98\/cG988cWP+HEVwUNVVIEREAERCAxBCoSQESOpc6478crD3z9ga9A4GeLX1+DSMyxpIaKgAiIQFURqEgAGdnxtQd3z+\/D7dn0axDEk66qqKiyIiACIiACsSdQkQD66fCgC099Mvpzhp9wfzq5RUAEREAERCAKBAIRQESOpz156tM\/CsRPOPG5GkscQoloMp3KtGq2tP6vTYyPj6eTbN++Pf0VCtKkI+QIjYB2LAIiIALVQCAQAXRPebqnPl3Dnd\/Fu3D\/dmhoyBBKhLOtrc1YP9Qfj5t1RfnaxMmTJ70vTQwODhrCiRCeOnXKCOdLFKxEQ1ryyERABERABEQgH4FABJB7fIjY+vXrvUWw2SFChJ9w4gnLNESM9UObm5u9qO7ubm89UcK9gLk\/k5OTxtcmWHS7tbXVrly5YufOnfO+PrFixYq5VGYrV670wtIBcoiACCwxAe1OBKqHQCACSHP37dtn3\/zmN41FsJnOZIufcOLzmRNA0vD1iGwjRoSURbdJc\/nyZbt06ZK1tLTY7t27DaHds2eP8cRpLrEl36uvvuqNFi9cuIBXJgIiIAIikGACgQkgDP2LYDOliZ\/wxTLu+SF8jBB37dpln\/\/859Mj0Gz73L9\/v3G\/cWRkJFu0wkRABERABCogUG1ZAxXAchs\/PT2dztrQ0GBMdaYD5hwzMzPefT+8THvy2SXy8aI9I8OmpiZrbGw0xJA02ay\/v9+4T9jT05MtWmEiIAIiIAIJIhCIAPLkJiMrtqWwQ7gQMISMfGNjY4afcPzO+Mgu9\/2YGj19+rR3PxDBY+qUe4jcMySO6VPCXL7MLeLKC\/oIZWac\/CIgAiIgAskiEIgAct+Ne3TZnuAshLO3t9cY3XHfkC1+8jC9ieHmXt+GDRsM8dq2bZsx3YlIMsXKfnkwhrjNmzdbqN8fpLIyERABERCBqiAQiAAy8uN1BJZDQ8j8lu\/dPgghZExLcs+QLX7CETcMN4abNFNTU97DL4RhPGRDOEYawmQiIAIiIAIiUIhAIALICJAlzxChTCOc+EIVUbwIVDkBVV8ERKDKCAQigFXWZlVXBERABERABKxiAeSF97Vr16aXI2N1FnEVAREQgUQRUGOrkkBFAsjTl7yH9+STT3pff2A5Mt61455gVdJQpUVABERABBJDoCIB5NUDSPEUJlteTeCpTFZpwS8TAREQAREQgagSqEgAP2zUhy7e15MAfshDLhEQAREQgWgSCFwAo9lM1UoEREAEREAE5hOoWABZfYWX0Hn3j6lQPk3ENwDxY4XeA5xfHfmqkYDqLAIiIALVSKAiAeT9Pt7zy3z3z+8nnnTVCKca6syXLfjREaTxo6Ya2q46ioAIiEAlBCoSwEp2rLyVE0D8duzY4X3hgrVYgzLKrLx2KiEZBNRKEaheAhLA6u07QwD5xuEttz9oHVufCMxu6rqziqkkt+ocC0HOBFAWx1hyiarlcScgAYxBD9dcX2+r1rQGZze2xoBK8prAO7hBzQK4cpgNkAgm71gqtsXVnk4CWO09qPqLwByBxZgJYFQpAZwDrE3sCEgAY9elalBSCWgmIKk9r3aXS0ACWC458slEQAREQASqloAEsGq7ThUXAREQARGohIAEsBJ6VZL35AsH7Fe3f9L+OGWz9\/6F4a+Sqke5mqqbCIhAlROQAFZ5Bxaq\/psv\/8gGUgL4fCrhPSl77r2Lnl8imIKh\/yIgAokmIAGMefdff3CXrc1oI\/6Pp0QxI1heERCBYgkoXSwISABj0Y25G9GZI4rwy6nRYI5oBYuACIhA7AlIAGPexRM52jf50QZbkbIc0QoWAREQgdgTKFMAg+Ny9epVby3LQl+OGBgYMNJg4+Pj6QrgJgzbvn17OlyODwj84rb7bOoDZ\/ov\/rOf\/VLaL4cIiIAIJJFA6AI4NDRkq1evNr4g0dbWZqOjowv64cyZM3b8+HFjbcLDhw\/b4OCgIZyEs\/wT4adPnzY+xkvYggISHNCeEsC+lN2RYnAwZXemRn34CU959V8EREAEEksgVAFExCYmJqy5udnrgO7ubsNPuBcw92dyctJqa2utpqbG+OYgQnfu3DkjfMOGDcbnlpYvX26HDh2ylpaWuVzaOAKI3Q0\/fMtee\/olq0sZfhdXzlZ5REAERCAOBEIVQAfQCSB+vkV37do1nPOMUSIiR+Dly5ft0qVLOO3111+3tWvXetOjhaZAWdeQ0WJS1zbUPT\/vkNEfERABEfAIREIAvZqU8Wd6etqb9mQkiLCdOnXKuCeYqyimS1nlfmRkJFcShYuACOQloEgRiA+BSAggQuaQNjQ0eFOdzu+2MzMz3n0\/\/CtWrLD6+npv6tSNDJkeJa+\/LNL6rb+\/34aHh62np8cfLLcIiIAIiEACCYQqgExpdnZ2mhOtsbExw0+4vy86Ojq8kR5Tozzswv3ApqYmI\/ztt9+22dlZI47pU\/90qr8M3Ahke3u7NTY24pWJgAiIgAiUQCBuSUMVQGD29vYaozteY2CLn3Bee8Bw82ALD7sgXtu2bbNdu3YZIukPJ27z5s3W1dVFFpkIiIAIiIAI5CUQugAiZExL8hoEW\/zUuK+vzzDcGG7STE1NzXvS04UTh5u0MhEQAREQAREoRCB0ASxUwUjFqzIiIAIiIAKxISABjE1XqiEiIAIiIAKlEJAAlkJLaZNMQG0XARGIGQEJYMw6VM0RAREQAREojoAEsDhOSiUCIpBkAmp7LAlIAGPZrWqUCIiACIhAIQISwEKEFC8CIiACIhBLAkUKYCzbrkaJgAiIgAgkmIAEMMGdr6aLgAiIQJIJSACT3PtFtl3Jkk3AfUaML64EZUn9JFmyj6TotV4CGL0+UY1EIFIE3GfE+JRYULZjxw6TCEaqmxNZGQlgIrtdjRaBYgmY3XL7g9ax9YnA7KauO41RpQSw+D5QysUhIAFcHK4qVQRiQ6Dm+npbtaY1OLuxNTZs1JDqJiABrO7+U+1FQAREYNEIxL1gCWDce1jtEwEREAERyEpAApgViwJFQAREQATiTkACmK+HFScCIiACIhBbAhLA2HatGiYCIiACIpCPgAQwHx3FJZmA2i4CIhBzAhLAmHewmicCIiACIpCdgAQwOxeFioAIJJmA2p4IAqEL4NWrV43lldasWWPr1q2z2dnZrOAHBgaMNNj4+PiCNNu3bzdsQYQCREAEREAERCALgdAFcGhoyFavXm1nz561trY2Gx0dXVDNM2fO2PHjx42FeA8fPmyDg4OGcLqECGK2fC5eWxEQAREQARHIJJBDADOTLY4fEZuYmLDm5mZvB93d3YafcC9g7s\/k5KTV1tZaTU2Ntba22pUrV+zcuXNeLCNGBPGuu+7y\/PojAiIgAiIgAsUQCFUAXQWdAOK\/ePGiXbt2Dec8Y5S4fPlyL+zy5ct26dIlz7137167++677YYbbvD8+f6wAC+jSC3Cm4+S4kRABEQgGQQiIYDlombqk7xdXV1sCpr7rMvIyEjBtElOoLaLgAiIQBIIREIAp6en06wbGhq8qc50wJxjZmYmfd9vxYoVVl9fb2NjY949Qx6MYSTIfcB8D8L09\/fb8PCw9fT0zJWqjQiIgAiIQFIJhCqATGl2dnaaE0AEDT\/h\/g7p6Ojw7vsxNXr69GnvfmBTU5Pt27fPe3iGB2h27txpmzZt8sL8ef1uxLW9vd0aGxv9wXKLgAikCcghAskhEKoAgrm3t9cY3TGKY4ufcF57wHC3tLTYhg0bDPHatm2b7dq1yzJFknQyERABERABESiWQOgCiJAxLckoji1+Kt\/X12cYbgw3aaampgxBJMxvxDMi9IfJLQIiIAIiUDyBpKUMXQCTBlztFQER+ICAeyqbJ7ODMD3d\/QFX\/S2egASweFZKKQIiECAB91Q2K0EFYV+\/99smEQywgxJQlATQ38lyi4AILBmBW25\/0Dq2PhGI3dR1p71z5jUJ4JL1Xjx2JAGMRz+qFSJQdQRqrq+3VWtag7EbW6uu\/apw+AQkgOH3gWoQDQKqhQiIQMIISAAT1uFqrgiIgAiIwAcEJIAfcNBfERCBJBNQ2xNJQAKYyG5Xo0VABERABCSAOgZEQAREQAQSSWB\/qIKIAAAOAklEQVROABPZdjVaBERABEQgwQQkgAnufDVdBERABJJMQAKY5N6fa7s2IiACIpBEAhLAJep1lmgKYr1DfxkXL15cotprNyJQHQSCXl+U841ztzpar1qWSkACWCqxMtJzAu3YscOCWO\/QXwZlllEdZREBH4F4OYNeX5TzjfOMczhepNQaCEgAobDIxsnDL9Mg1z5kDUXWP1zkqqt4EagqAotxjnHucg5XFQhVtigCEsCiMAWTqNDah9OvTdi\/\/M3t9mcp+9cnv234866VqPUPg+kYlRIbAoXOsbznU7Z1SWN+jsWm48tsiASwTHBBZ3vz5R\/ZwAsH7PlUwfek7Ln3Lnr+k6mwlFf\/RUAEREAEAiYgAQwYaLnFXX9wl63NyIz\/4xLADCryioAIiEAwBJItgMEwDKSUzhylEH45NRrMEa1gERABERCBMglIAMsEF3S2iRwFTn60wVakLEe0gkVABERABMokIAEsE1zQ2X5x2302lVEo\/rOf\/VJGqLwBEVAxIiACCScQugBevXrVez9uzZo1tm7dOpudnc3aJQMDA0YabHx83EtDWvIQhpHGi6jCP+0pAexL2R2puh9M2Z2pUR9+wlNe\/RcBERABEQiYQOgCODQ0ZKtXr7azZ89aW1ubjY6OLmjimTNn7Pjx48aqDIcPH7bBwUFDOPfu3WubN2\/28h47dsyeeeYZc+K4oJAqCEDsbvjhW\/ba0y9ZXcrwV0G1VUURqD4CqrEIpAiEKoCI2MTEhDU3N6eqYtbd3W34CfcC5v5MTk5abW2t1dTUWGtrq125csXOnTtn+\/bts76+Pi9VU1OT3XzzzZ672v\/onl+196DqHzcCvAzPD\/AgTS\/Xh3+UhCqArvlOAPGzvuW1a9dwzjNGicuXL\/fCLl++bJcuXfLc7g+CiDAikC4sc+sOYh14mWTkFwERyEdAS6zlo1N1cekKR0IA07Up08G9wIceesh2795tdXV1OUtxB\/HIyEjONIoQAREQgUwCWmItk0g8\/JEQwOnp6TTNhoYGb6ozHTDnmJmZ8e774V2xYoXV19fjNO4Pfu1rX7Pvfe971tLS4oXl+tPf32\/Dw8PW09OTK4nCRUAERGABAS2xtgBJLAJCFUCmNDs7O80J4NjYmOEn3E+3o6PDu+\/H1Ojp06e9+4Hc80P8Dhw4YEePHs078nNlIa7t7e3W2NjoghK5VaNFQAREQATMQhVAOqC3t9cY3fEaA1v8hPNKA4abkd2GDRsM8dq2bZvt2rWLYNuzZ4+dOHHCezCG\/Fg1PwXqNUp\/REAEREAEloRA6ALIaI9pSV6DYIuflvN0J4Ybw02aqakpb6qTdKQnzG9dXV0kl4mACGQloEAREAFHIHQBdBXRVgREQAREQASWkoAEcClpa18iIAIiECIB7Xo+AQngfB7yiYAIiMCSEXDvJusF+yVDPm9HEsB5OOQRAREQgaUj4N5N3rJli7cmchDbHTt2mBb7KK4PkyWAxTFRKhEQARFYEgJ6wX5JMOfciQQwJxpFiIAIiMDiEtAL9ovLt1DpEsBChBQfFwJqhwiIgAjMIyABnIdDHhEQARGofgJBP1wT13uKEsDqP9bVAhEQgUIEEhYf9MM1cX2wRgKYsBNDzRUBEYg\/gSAfrrmp605jRBnHUaAEMP7nglooAiKQMAKBPlxzY6tHDxEs9n1FL0N0\/uSsiQQwJxpFiIAIiIAIOAKlTKu6PFHfSgCj3kOqnwiIgAhEgEAp06oRqG5RVZAAFoWpuhOp9iIgAiJQKYFSplUr3ddS5ZcALhVp7UcEREAERCBSBCSAWbqDp50K3ex97LHH7I7rrrODKftWU5Phz5Xn4sWLWfaiIBFYCgLahwiIQC4CEsAMMojf1+\/9dt6Fab\/whS\/YFx991J5P5b0nZd99913P\/7nPfS5rPt6hSSXTfxEQAREQgQgRkABmdAYC+M6Z1yzfDd8\/f+89W5uRD\/9fvv++dWx9YoHxHk1GcnlFQAREYNEJaAf5CUgAc\/Cpub7eVq1pzWqdOfIQ\/vu1f7gwz9x7NDmyKVgEREAERCAEAhLAMqBP5Mgz+dEGW5GyHNEKFgEREAERiBCBeAvgIoH+xW332VRG2fjPfvZLGaHyioAIiIAIRJVA1QvgwMCArVmzxrPx8fEl4dyeEsC+lN2R2tvBlN2ZGvXhJzzl1f+IEvjtb39rZ86cMbYRraKqlUGAvlKfZUCJsNf1F89SRLia6apVtQByYhw\/ftx4\/eDw4cM2ODhoV69eTTduMR2I3e8emLBH\/vJ+s0eOGv7F3J\/KLpnAggycnG+88YYEcAGZ6Aaoz6LbN9lq5vpLApiNTsBhk5OTVltbazU1Ndba2mpXrlyxc+fOBbyX\/MX9bs1H8idQrAiIgAiIQCQJVPUIEKKrV6+25cuX47TLly\/bpUuXPHe2P8WsZu5eWp+9NGuzs\/mNXzvsh33mS+vSFVNmvnIy41TubHo0Vwxbx6tQf8HZpS2mXNIXa4tR7mKUSXuiUK6rQ6E+c+nS\/VXg3KV9xZjKLe8c47pYDVb1AlgM5MbGRvv0pz9txaxm7l5af+d\/HbL\/c2hnXnt96DH7j9P\/2\/7vi0\/mTffai4e8ahZTZqF9+uNV7k4rhUGx\/QXjUsolfbG2GOUuRpm0JwrlFttnUagrzIq1aqpvKXWlv9b94W+Ma6530Yv4n6oXwJmZmfR9vxUrVlh9ff0C5HRGf3+\/DQ8PF21Hnz1sPzj8d4EZ+w66TOqncv\/O69Oks9VxoOOA6wG2GMdCKWU++ci2sAVwgQbkCqhqAezo6PDu+127ds1Onz7t3Q9samrK2lZEsL293WRioGNAx4COgcU7BrjWZr0IRzCwqgWwpaXFNmzY4Inatm3bbNeuXen7gRFkrSqJgAiIgAhEiEBVCyAc+\/r67OzZszY1NWUIImFJN7VfBERABESgMIGqF8DCTVQKERABERABEVhIQAK4kIlCRKCKCajqIiACxRKQABZLSulEQAREQARiRUACWGZ3su6oW4OU9UjLLEbZlpDA9u3bvTVj6be1a9d664Iu4e61qyIJ8IL6xo0b5\/WPzrfi4IWVKlufVcP5JgEs44ihs3mp\/tixY4axHilhZRSlLEtEgDVieWeUNWP10NQSQS9jN6zvu379ejt\/\/nw6N+eWzrc0jsg5svVZtZxvEsAyDifeOWTZNV66571D1iMlrIyilGWJCPCuKGvF0mdLtEvtpkQCCN2RI0fs0KFDtnLlynRuzi2db2kckXLk6rNqOd\/iJYBLeGg0NDR4i3C7XU5PTzunthEkwEX0Zz\/7md16663eNCjTMxGsZqKrVFdXZ\/v27bNly5Yt4KDzbQGSSATk6rNqOd8kgJE4jFSJxSbQ1dXlvS\/K9CcnJ9Ohune72NRVflIJVMv5JgEs8wjlqxEM81325uZm59Q2HAJF75Wvh\/AVEY3ai0YWekKdb6F3QdkViPL5JgEso1v59iALb\/OJFr4\/yL0lwsooSlmWiABPEbppT+5bnDp1yrq7u5do79pNJQQ4t3S+VUJw6fNWy\/kmASzj2GDe+\/777\/fuJ3FPCTdhZRSlLEtEgCkZdsUrEO3t7dbW1mYujHBZdAlwbnGOca5huAmbV2N5IkXAnVtRP98kgGUeNnQw95Mw3GUWo2xLSIAHLOgvDPcS7lq7KoEAa\/pOTEzMW9uXc4x+w3CXUJySLgGBbH3GOUZ\/YbiXoBol70ICWDIyZRABERABEYgQgbKrIgEsG50yioAIiIAIVDMBCWA1957qLgIiIAIiUDYBCWDZ6KKTUTURAREQAREonYAEsHRmyiECJRPgpXueiHPGY+IlF1JkBl7zyFxMusisSiYCiSIgAUxUd6uxYRBA\/I4ePWonT570VqNh+\/jjj1swIhhGi7RPEYgHAQlgPPpRrYgoAUZjiN\/DDz9s7t01tvgHBweNVfOpOi\/pu9EhgkkYcVu2bEkLJWW5kR0r8OMm3uVDUMnzwAMPGOue9vb2zvukEGXKREAEPiQgAfyQhVwiEDgB1h2lUFYzYeuMd9mGh4eNZaIQPFamYWTI57WeeeaZtOi59Nm2fDKos7PTG1Vu2rTJEFTSPfXUU3bzzTfb0NDQvHfpiJPFi4BaUxkBCWBl\/JRbBAoSyPySQWYG1iTdvHmzN0LkhWK+hzc2NpaZbIGfTwZ1dHR44VrWzcOgPyJQEgEJYEm4lFgESieQuZCzvwSmLPkyhT+s2IXVEUB939BPTm4RKI1AdQtgaW1VahFYcgJu6tNNhboKcA9v69atnpcvU3iOuT+MCOec8zYsvv6b3\/xmXpg8IiAC5ROQAJbPTjlFoCABHnhhepOnPnmIhQxs77vvPrvlllu8e4CM+HhQhnCE8cSJE+af0nTToZOTkyYBhKBMBIIhIAEMhqNKWXoCVbPHvr4+QwTb29uNJzbZ4iecRrDl6xSE87WDb37zm96XKnhAZteuXYYgku9Xv\/qVfexjHyNLXqupqbHa2lrTU6B5MSlSBEwCqINABJaAACLHqvjO8Pt3y2r52eJ4KGZqasp70vOxxx6zH\/\/4x96TnYTjZoRJOf6nShFOnjAlH+mIl4mACCwkIAFcyEQhIiACUSeg+olAAAQkgAFAVBEiIAIiIALVR0ACWH19phqLgAiIQJIJBNZ2CWBgKFWQCIiACIhANRGQAFZTb6muIiACIiACgRGQAAaGcukK0p5EQAREQAQqJyABrJyhShABERABEahCAhLAKuw0VTnJBNR2ERCBoAhIAIMiqXJEQAREQASqioAEsKq6S5UVARFIMgG1PVgC\/w4AAP\/\/clE0eQAAAAZJREFUAwA76qiAvlv0eQAAAABJRU5ErkJggg==","height":0,"width":0}}
%---
%[output:623d1abc]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAcAAAAFQCAYAAAAoQ64wAAAQAElEQVR4Aeyde4wV153nf15ls1Lziic2vaaZjBv3rDPj0Mg7aqWlVppoptm0zWA7IHsMxorjZEL7pXjMYwdLHoO8gg2NM0axMSCl1yhtcBJ1j9kMOz2irQmdbQ0EWVaDk9jZXnAIkKEdzThA0P6XvZ8y57r69q37rHurbtUX8es67zrnc6rqe8+pqlP\/7nf6JwIiIAIiIAIpJPDvTP9EQAREQAREIIUEJIAp7PRsk+UQAREQgRQTkACmuPPVdBEQARFIMwEJYJp7X21PMwG1XQRST0ACmPpDQABEQAREIJ0EJIDp7He1WgREIM0E1HaPgATQw6A\/IiACIiACaSMgAUxbj6u9IiACIiACHoGUCqDXdv0RAREQARFIMQEJYIo7X00XAREQgTQTkABG3PsbNmywRYsW2ejoaLYmhC1dutSmpqayYWE4alVusbrRNtqIUYdi6cOIP3XqlD377LN5i4pbIHVdsmSJ7dmzp+yqXblyxWDKsYJ7zZo1huEuu7AaZ6A\/aGuNd1OwePZfKeuCBdchkuODcwiLax\/XAUOou5AAhoqz8sIGBgYsjhetylv0Uc6RkRGbM2eOHTp0yHbu3PlRRI1ciMHjjz9uv\/3tb2u0h3CLXbx4sU1MTFhfX1\/ZBW\/ZssVOnDhRdr56Z+Di\/frrr9d7t4nZHz8id+zYYfv27fPOo5\/85CdG3yemgRE1RAIYEfjc3R47dswGBwdzgz1R5NcehkBycWd0yK9+\/IRj69at80aS\/Lp99dVXjS2\/FEmXW+iTTz7ppSWeE8vF4yYMYx\/sizgXTlnEsSXcb6QlD\/EYFzzi2Q4PD9vly5ft7rvvnjbSJR5z5ZOPevMrnXD2Q5mU7W8rbuIpmzyYPx3t++Uvf2nsFzakpwzSkBYjL2UQRxqsFIa55VB3yqHO1J0y2FIeZdMG9oe5MNL7zeV1dSIPdWXERD7KI40\/D27S00baumzZMvvpT39KsMd69erVXh9TDnX2IjJ\/yEOZWFB9Msm80ShpMFcG5eCmfqTBcBNGHIabPBj7Ig2MuHj7jwHYsH\/SYS6tKwOOLp4yOaZJh7m0lO2MfRDHljDqleunnH\/9138l2t56662850hQvVw4daJulE151NcrMOcP\/UW\/kQ5z9cpJVrJ3cnLS+xHZ3Nxs2Cc+8Qm7cOGCd30ouRAlnEFAAjgDSf0DGB0tXLjQDh48WNG0J78GGfEwwqL2\/Eo8cuSIbdq0yRMB\/8nHxfLhhx+2kydPWmdnpz333HPePjlh169f7+UhrqWlxZ7MCCUnPmU6O3369IxRHBeBe++91zo6Oox49s8Fj\/0yqlm5cqV38lK\/np4eV5S3dfslD\/u97bbbbPv27UVPbPK9\/PLLXn358UBh7HP27Nn2wgsv2O\/\/\/u8b+z1w4IBdvXrVgupHPqwUhrB4MsMENtQVvjCjLpSBcZEfHx839ku9ECjaRtvZR74fOeTLNfrpc5\/7nFEGF7v9+\/fnJvFGjLSRttLff\/zHf+ylOXv2rG3bts0bKXzwwQfeMUAE\/QEj6kO558+fzzuKoD352M6fP9\/rY0ac9DmGm34njrLZD2XDhjIoiz7Hz3EOB\/yMXtg\/aakPeakf+bF33nnH6EfiYHH48GHvmKW9rlzSOWtvb\/f6nNkG+glxIA7hcH7q+Xu\/93sEez8S6CfqBTvqSUSxetGH7lzzsyWvM\/bHMcyxzHFCnd155tKwZZ9+kUQoMUSWMkjjrKury3NevHjRMPbd3d1tHO9ehP5UREACWBG2cDNxgeNXJSc6F8xyS+dEa21tzf4y5ETngtTW1jajKC6WXCw4cRBC9slJysWAxJxoxHFycYFCPAjHent72cww8lOOi0dYsVKmddkv7Xd1Qjgw6jBjR3kCuHDC7OjRozOE2SUvVD83TVoKwzNnzhgXQNhQP1ixDy5IbDEXh9vZ1772Ne+iVc40J2LBL\/2mpiZDcLmg514UXfm5W3iSF8ONCJAGcXD9z\/HBcVKo3Hxs6WP6GqYYbsIoH8PPjw0u+rSX6V3C\/ZYrnPQ99XL1JC11o460ARaOa75jmvSkJQ\/tef\/9941jl\/CxsTF7++23vX7z13PBggWeeFAeP1row1LqBU\/qhOH215n9+Q1xp+8RVY5P6uiPhw2M+NHot3zHP2mff\/55ozxmUh555BHvB5C\/PLmLE8hNIQHMJRKRnyksLhr8uv3xj39c91pwInMh4OTiVygXP35lcmEoVhnycpHiolAsbW48eXPDSvFzQYAZaakrdc43NUY8+6i0fuR3BgsYuf3BCj\/luzT+LT8CMMK4cFFH\/yiH8CDj4loJT8pDMBFO3M4QT8QBgaJO1IUfDgiF\/0cO6Qux9YuVX1DJ96Uvfckb6bt9BE0RwpFji\/1TD+pDniCOlF2KIWb8QKFcyn\/sscc8IfyHf\/gHL7ufJ2m9QN+fUuqVj62vCM\/JjyN+XOJBBGGWb1RXzgiQ44ZjiBExZTJbxDQv+5BVTkACWDm70HNyAaHQc+fOsamrcUFAJJiicr9G+XXKxbBYRciLEHABKZY2N568XKwqycsDNdSViwLl8uOBiwpuv7GPSuvnL4cLKIyYNmO\/zpjm9adzbi6E\/JonHXkIzzcVRnitjbow6mGkxQWUOmH5RibUJYgtoxhGWkxJvvvuu96UKGHk4VjhmGFk6ESNHwvE+Q2OCDw\/+KiDM\/bpT1eu243I\/+mf\/skY0ePn2PrOd77j+ZklKVRmmPVimpd2wdoxz53+drxI5zeOGfrLX1f\/jw140wdMPzNq9aeTuzwCEsDyeNU0NSeEG9W4HXEicOFyv9S5uPBr2cWXtc0kJi+\/kBkRMEXJyckvVC4WmWhjSpI4frFiuAkvZOSnHE5S0nHSY\/wKpv6EBZl\/v6ThV60bOSBcXMAQRzf9SBqMX8SMHthyseFiykWVixjxfitUv1mzZvmTFnRzAeXCyrQaXBhxcg8nn+hSkD9+7dq13j3XUkYQ5K2FMQVI\/3MMceGEM7xz9wXTQmwph5EWhpv88OB4wfBv3rzZGw3Sh\/j9lnsB9+\/Pn65ct+sfHgbinPnMZz7jCR\/luClU3EEWVr38bCnzmWee8XaZj4UXUcIf8vr7DvGL8lgqocoNkUQCGLNuYqSAmPirxcgQIeBXtRMtf3w5bsrmAo4ocAF78cUXjZMU8eUeA7\/YiUNweQihmICxb\/J\/\/\/vf9x7H58LppmoQJuILmX+\/5OWBBFcnJ2pMNT799NP2qU99KlsUZcOKfZEPUedCQ10wfiETxkWeTJXWj7zOYAET2MAIVjCjDS6Nf8vIkB801J\/08EYYKMefrho3AsSFkWOD0VyhsvzMSM8FlPtTuXn86XLZkpa2cBxhuAmjTX42tJkfCwg\/8e6HDuH8MGC\/7J960If0JfslbaVGHRA68sMFP0KIHwFhW8zCqBfHH8cwxzL8aB\/HcjXt41iiDMqCGe2AN23ELauMgASwMm6h5WLahwsXJw2FssWP4SaMCyxTS0yTMD1CHPk4+PFjuEnv4sjHCUcetvjJQzzpCadMyiYOIx3hGOkozx9OPP58RlrykBfzp2W\/ufvyl0Fa8mD+dP4yf\/CDHxhG3Wkr+bkokMcZ5RCOsU\/CqRPlYLgJw1xayqJMDLdLR37KIZ0\/vYsnDCOedHCk7tQJvzPKIR1GPOlcnNsSRpzLSx7qyr6oE3XDcLs8bsv+KRtbvny59\/SpS0t+yqE8M\/OysA\/SYi6dF5Hzx5+OtOwnJ8m06U\/i3P5Ij\/nLd20knLJpC\/H4McL8Zbg6u3wuni2sCCd9rhFPea6+lOP3k4\/8pCMv6fzxQfVy4dQZt2sr5VNOrrn9UDYWlC43XyE\/ZVAWRr9Sh0LpFVecgASwOCOlEAERuEaAKVM3AmHUdi1YGxFoSAKRC6C7d8BUAdNVzJ8HkSRuxYoV5r\/nwglJXoyplaC8ChcBEaiegBuFaARSPcu6lqCd5SUQuQDyZBTz9Azr3X2bfDVF9Lifwku+Lp6b59wM5oELnl5keoJ0Ll5bERABERABEQgiEKkAMvrjgQx3g5ob1\/gJ91eYkR8rYezdu9fmzZuXjeKJv7lz52b9xBGWDfA5eLUAocRw+6LkFAEREAERSCGBSAXQ8XYCiJ8n7HJfzOVmL1MvuY+sc6OZJZ8YGbL0EC+HkpZy\/Hbu3DnbuHGjt0o+j2kPDQ35o+UWAREQARFIIYFYCGCl3Lnnh\/Dx7hqPl995553T7g+6chnxHT9+3Pr7+72n5FatWuWitBUBERABEUgpgVgIoH8JJN4Nyl3GKahvyMd7PzyWzEuwLCiNGAalp2yeYCNdUBqFJ4+AWiQCIiAC+QhEKoAIFwKGkFE5VhLBTzj+YsbUqbtnyLQp06eEFcuneBEQAREQARGIVADBz0oRLNLLawxs8RPO9CaGO8h4mZUnSFmNgpEd30Djxdag9AoXARFIGwG1VwSCCUQugIz2eH2B1yDY4qe6iBuG2xkPvTDiY+vCeDiGvFhuepdGWxEQAREQARHIJRC5AOZWSH4REAEREAERCINAsTIkgMUIKV4EREAERCCRBCSAiexWNUoE0kmAV55Y7EJ2zGrBAL5JOrIkgEnqzdy2yC8CKSLAxdm\/4AWLXsjWZBcACYMFfOGclMNKApiUnlQ7RCDlBLgw+xe84KE62QFv8Y8wOHz96183+MI5KYeaBDApPal2iMB0Aqn1uQUveDUqDoteUAfq0uj22c9+NnHHlAQwcV2qBomACECAkQpTdmFM\/VVTBnWgLtRJFi8CEsB49YdqIwIiEBIBRIcpu9vve8q61n0jEru154Gi04Z81q3Yoh+FkOTN78vA13VeffVVL4T9kN7z6I9JAHUQiIAIJJpA0\/XNdsOi9mjslvaibFm9qpaLeJw5c8Z+\/vOfe\/VgP+zP8+iPBFDHgAiIgAjUiwAf7F6yZImx9CNb\/IzIGJnx3dN169bZihUrvHjCNmzY4LnZMpJjSzrqSzx5cTsjnrIxpm0vXrxofDHnO9\/5jpEeIw9lEU86zIWxf9ZjJmzp0qXm9uXKT9o2oSPApHWT2iMCIpAEAnyt5vnnnzeWbpyYmDD\/so60j\/WQt23b5r3Dd\/DgQevt7fXchP\/6178mSaAhVg899JBX9smTJ23OnDmegPGpuAcffNAY\/bnMg4ODxjrK1IP3BQcGBozyL1++bH\/zN3\/jldHR0WGU4\/IkcSsBTGKvqk0iIAKxJLBy5Up77rnnvFGdGwH6K3rrrbcan3YjjKdZWeifz8MhVoQVsvnz59u\/\/Mu\/eGWTD2ErlB5xJZ7ynViyH\/ISnoYv60gA6WlZogjka8zWrVvt\/uuus90Ze6K11fDnS6cwEaglAUTq6NGj3giLkeD+\/fvL2h0jNKY1yeQ+I4cbYzr1Rz\/6kVc2I7fOzk6CA43PzxHJp+Qol7rhT5NJANPU2ylt6yuvvGL3bNlir2Xa\/2jGvvXee55\/a0YUM179TziBX\/\/fk\/br09HY1X+7WsvucQAAEABJREFUOI0u9+C4v4atX7\/evvSlL02LL+RhpHb77bfb3Xff7Y3y3nnnnWnJm5ub7Yc\/\/KEX19XV5cU5sXz99deN+4NeYOYPn51jWpV6IJQPP\/yw3XDDDZmYdP2XAKarv1PZ2pEvf9mW5LQc\/88yopgTLG\/DE\/ioAbyAztOf746+auN7\/2sk9tb3vmm8QE5dqBn34bjvhrl7gDyVSTgjMD7vxifhcLN6C1v8hOMmHXmxv\/\/7vzfyYoQTf\/Toh6NLyt67d68Xz31G\/JRBOtJTJuVTDubCSEM5rq6E406qSQCT2rNqV5ZAd9Y13UH4e5nR4PRQ+ZJCANEZfuXF0JYCQzAqsf7+fqMuSeGapHZIAJPUmyltCy88c8M\/yMYCuBz52Me8hwaC8lFuQFYFNwgBhIcpviiNOjQIroavZrkNkACWS0zpY0UAkWKpKd5pCrJ\/\/MQnbCKn1vh\/OHt2wZXyKZfyc7LKKwIikBACEsCEdGRam4FAFVvu6s\/\/ep\/13fu43Z+BtDtjD9zY4vkJD1oi69YSlrDKFKX\/IlAWAV5A17JkZSGraWIJYE3x1rnwFO+uqchyV50ZAbzpe+\/Ymy+9YfMzhp8HJAKthCWsUow78U3furU2r834lyVLPMQGaKAEsAE6SVUMj8DczOgvvNJUUhIJ1PK1Gf+yZLDjXTxeRcBYjoww\/6sSuAlj5MgUP+kw0hLmli77i7\/4C\/vLv\/xL411A0pMPwy0LJhC5ANKJrmOLrT3HUj+sk+c6mWZxIHBAYP73XIiTiUCKCKipIRGo5Wsz+ZYl4zWEffv2GWLIte2tt97yliAjnJfducYFLV1Gk1966SX77ne\/a3\/yJ39iLLXGNZV8rDpDvCyYQOQC6O9Y1p4bHh7OW1sOjGXLltnZs2ez8YTt2rXLWyuPlQ9YzYCwbAI5YkeAe3ZBT10Snm\/qifAgO3\/+fOzaqAo1NgFej8nXAsLDfm3GLUfGS+yzZs0yXlw\/cuSIsRwZP+q5HiJm1Mel5YV4t3QZW\/ISj+CRFsHE797nwy3LTyBSAeSXytjYmLk15+hg\/IT7q8vIjyWDeLFz3rx52Sh+7SxfvtzoaF7sJJ6XPrMJchw8LMGFlItwTpS8dSAA95UPPR745OVdd91l92yZuWLLHXfcEZiHJzXrUHXtIkUEgl6b+dnNN9vNGaslCsSMH\/r8oGcEiPX19Xm7ZISII+\/SZZkIroOI6De\/+U3jWpoJ0v8iBCIVQFc3J4D4+UVPB+N2RseyQgGd68LclukCFpXl11KxKVBGi0y3Dg0Nueza1pEAAsiSVLff95Tle\/ryT99\/P++KLV\/44IO86SmDpzXr2ATtKgUE\/ijzI4zXZPxNxX\/DQw\/5gyp25y5L5i+IH\/Asd+ZGgFzXGNGVunTZ5z73Obvuuuu8EaS\/XLnzE4iFAOavWvFQhvtMezISZGR34sQJ42AJysmKDKzksGrVqqAkCq8DgaaAJzaZYsq3e8I\/PueT+T9oqqc18yFTWBUEnn32WXs9I4LutZknMqM+\/IRXUayXFYHLXZaMCMKZ\/sfNiI+RnzOWI2OGi2tXbhgDAwYI5HPGraTcMBen7XQCsRBAhMxVi0+AMMft\/IW2jBz5fMfs2bONPOT1l5Wbl\/jOzk4tS5QLJib+oKmn8RtbTE9vxqSTUlINxO613\/3O7jxzxr6VMfxxbzpPfZa7wHbc21Tr+kUqgPyq6e7uNidazHHjJ7yUhrPi+bvvvmvcI2TalOlTRLGUvEoTPwK\/uPdxY6rJXzP8pz\/\/RX+Q3CJQNwK1vucXZkMYOTK6ZDQZZrlJLitSAQSsf26bz3PgJ5xfMxjuIKOjeQiGUR22evVqb\/XzoPQKjzcBXk7Pt2IL4YVqrjgR8BNwD7txW0R2zHtKPgwODDD8nJPgjlwAGe25uW22+AHLrxkMtzMEj6dE2bow0rh5cdwuXNvGJIDY3ZSzYktjtkS1rjcBFp3m00PuYTceeJOtCXyCulw2PHENXzjXu29rtb\/IBbBWDVO5jU1A9\/wau\/\/qV\/uP9sSF2T3oxo9p2YHQPwUFXzh\/RL2xXRLAxu4\/1V4ERMBHgIszt0NknVYLBvD14W54pwSw4btQDRABERCBdBKottUSwGoJKr8IiIAIiEBDEpAANmS3qdIiIAIiIALVEpAAVkswyvzatwiIgAiIQMUEJIAVo1NGERABERCBRiYgAWzk3lPd00xAbRcBEaiSgASwSoDKLgIiIAIi0JgEJICN2W+qtQiIQJoJqO2hEJAAhoJRhYiACIiACDQaAQlgo\/WY6isCIiACIhAKgQYVwFDarkJEQAREQARSTEACmOLOV9NFQAREIM0EJIBp7v0GbbuqLQIiIAJhEJAAhkFRZaSWwNatW+3+666z3Rl7orXV8KcWhhouAg1GQALYYB2m6saHwCuvvGL3bNlir2Wq9GjGvvXee55fIpiBUbP\/KlgEwiMgAQyPpUpKGYGRL3\/ZluS0Gf\/PMqKYEyyvCIhADAlIAGPYKapSYxDoDqgm4e9lRoMB0QoWARGokEDY2SSAYRNVeakhMBbQ0p\/dfLPdnLGAaAWLgAjEhIAEMCYdoWo0HoE\/ykx1TuRUG\/8NDz2UEyqvCIhAHAlELoBXrlyxNWvW2KJFi2zp0qU2NTUVyIm4FStW2KlTp2ak2bBhg2EzIpIUoLbEisCzzz5rr2dE8P5MrXZn7InMqA8\/4Rmv\/ouACMScQOQCODg4aAsWLLDTp09bR0eHDQ8P50WG6C1btszOnj07I350dDQw34zEChCBMggcP37cjh07Fmhf+MIX7Ml\/\/mf75Guv2QMHDxr+QumJO3fuXBk1UFIREIFaEYhUABn9jY2NWVtbm9e+3t5ew0+4F3DtDyO\/\/fv32969e23evHnXQj\/cEDcwMGAPPvjghwEF\/rqLmS5ABSApahqBXbt2eTMUzFIUss2bN5eUjjI2btxoFRyD0+oljwiIQPUEIhVAV30ngPjPnz9vV69exZm1+fPn286dO23WrFnZMOfYsWOHPfzww3bTTTe5oMCtu5gNDQ0FplGECPgJ3H7fU9a17huh2a09Dxg\/xCSAfspyi0A0BGIhgJU2nalP8vb09LApav39\/XbgwAFbtWpV0bRKIAIQaLq+2W5Y1B6e3dJOsTIRKI+AUteEQCwEcHJyMtu4lpYWa2pqyvoLOUZGRrx7fzxAw0iQ+4eFHoSh7M7OTlu4cGGhYhUnAiIgAiKQAgKRCuDs2bOtu7vbnAAiaPgJL4U906I8PINt2rTJVq5c6U2VlpJXaURABERABNJNIFIBBP3atWvtwoUL3msQbPETvmfPHsNwm+mvCIiACIiACIRLIHIBZLTHfTlGcWzx08S+vj7DcDtbvHix95QoWxfmtqRlROj82oqACIiACIhAIQKRC2ChyilOBCAgEwEREIFaEJAA1oKqyhQBERABEYg9AQlg7LtIFRSBNBNQ20WgdgQkgLVjq5JFQAREQARiTEACGOPOUdVEQAREIM0Eat12CWCtCat8ERABERCBWBKQAMayW1QpERABERCBWhOQANaacDXlK68IiIAIiEDNCEgAa4ZWBYuACIiACMSZgAQwzr0TYd34XA8fbw3T+NRVhE1qtF2rviIgAjUmIAGsMeBGLB7x27hxo61ZsyZUo8xG5KE6i4AIJJOABDCZ\/VpVqxBAPtpai4\/BVlUxZRaBtBBQO+tCQAJYF8yNuZOm65vthkXt4dkt7Y0JQrUWARFIJAEJYCK7VY0SAREQAREoRiCmAlis2ooXAREQAREQgeoISACr46fcIiACIiACDUpAAtigHZfkaqttIiACIlAPAhLAelBO6D6Off9F+9V9n7Y\/zNjUY39m+BPaVDVLBEQggQQkgAns1Ho06ac\/\/DvbkxHA1zI7ezRjr75\/3vNLBDMw9L8KAsoqAvUjIAGsH+tE7en63ZttSU6L8P9BRhRzguUVAREQgVgSiFwAr1y54q02smjRIlu6dKlNTU0FgiJuxYoVdurUKS8NfvKQF9uzZ48Xrj+1J9AdsAvCL2VGgwHRChYBERCBQAL1johcAAcHB23BggV2+vRp6+josOHh4bwMEL1ly5bZ2bNns\/E7duyw1atXe3kPHTpkL7\/8so2Ojmbj5agdgbGAosdvbLG5GQuIVrAIiIAIxIZApALI6G9sbMza2to8IL29vYafcC\/g2h9Gevv377e9e\/favHnzroWa7dy50\/r6+jx\/a2ur3XbbbZ5bf2pP4Bf3Pm4TObvBf\/rzX8wJlVcEREAE4kkgUgF0SJwA4ueLAVevXsWZtfnz53tiN2vWrGxYruPMmTN2+fJla28PXm6L9S35ugFrXebmj4W\/gSrRmRHAvozdn6nz7ow9cGOL4Sc849V\/ERABEYg9gVgIYLWUGCE+\/fTTtm3bNkMsg8rbtWuXd79xaGgoKInCyyCA2N30vXfszZfesPkZw19GdiUVAREQgUgJxEIAJycnsxBaWlqsqakp6y\/m4N7gV77yFfv2t79tixcvLpi8v7\/fDhw4YKtWrSqYTpHlEdA9v\/J4BaRWsAiIQJ0JRCqAs2fPtu7ubnMCODIy4vkJL4UD4vfiiy\/awYMHC478XFmIa2dnpy1cuNAFaSsCIiACIpBSApEKIMzXrl1rFy5cMF5jYIufcF5pwHDnMx6U2b59ux05csS770d+TE+B5qOlMBEQgVgTUOUiIRC5ADLaY1qS1yDY4ocET3diuJ0xxclTomxJR3ry+a2np8cl11YEREAEREAEAglELoCBNVOECIiACIiACNSQQEwEsIYtVNEiIAIiIAIikIeABDAPFAWJgAiIgAgkn4AEMPl9HPsWqoIiIAIiEAUBCWAU1LVPERABERCByAlIACPvAlVABNJMQG0XgegISACjY689i4AIiIAIREhAAhghfO1aBERABNJMIOq2SwCj7gHtXwREQAREIBICEsBIsGunIiACIiACUROQAEbZA9q3CIiACIhAZAQkgJGh145FQAREQASiJCABjJK+9p1mAoFt37p1q91\/3XW2O2NPtLYa\/sDEihABEaiYQCgCODU1ZUuXLrUNGzZUXBFlFAERMHvllVfsni1b7LUMjEcz9q333vP8EsEMDP0XgZAJhCKA8+fPt6NHj1pvb6\/3XT++y7dkyRLjg7Uh11fFiUCiCYx8+cu2JKeF+H+WEcWcYHkbmYDqHgsCoQigawnf4nPf5hscHLS1a9dmBXF0dNQl01YERCCAQHeB8Pcyo8GAaAWLgAhUQCA0Abxy5YqtWbMmK3jbt2+38fFxQxCPHTtmAwMDxlRpBXVUFhFIDYGxgJb+7Oab7eaMBUQrWAREoAICoQggwrZ8+XJbsGCBJ3iIHl9r56vt1IkpUvxs8Zvprwikm8Dx48eNH4a5NuerX7WJHDT4Jz\/96bzpXf5z587l5JJXBESgGIFQBJCdtLS02KZNm3BmDWFkVMg2GyiHCIiA7dq1y5sx4fzw2xtvvHmTKVAAABAASURBVGGf\/8Qn7P4Mo90Z++LHPub533333bzpXd6vPvZXJhHMANN\/ESiDQFUCiLDx9GdnZ6f365QtD8A4w09dmpqa2MhEwCOgP2a33\/eUda37Rl7787\/eZ\/\/+v3\/PfvTfDtjsjOEPSkv4rT0P2M9PvSkB1IElAmUSqEoAmdLk6U+mYRA7tkx\/+o2pTzcVWmbdlFwEEkug6fpmu2FRe0H7j\/\/pPxeMz+a\/pT2xnNQwEaglgaoE0FUMIUTo2Lqwarf+h2oYZTLaDCqTuBUrVui1iyBACheB2BBQRUQgPgSqEkCEh3sQb7\/9tvcivJv69G+LiVcQCl6jcA\/VdHR02PDwcN6kvGu4bNkyO3v2bN54BYqACIiACIhAPgJVCSAjPkZ+n\/nMZ7wX4f1Tn87NFCnp8u08KIzR39jYmLW1tXlJeMEeP+FewLU\/CPD+\/ftt7969Nm\/evGuh2oiACIiACMSRQNzqVJUA1roxTgDZz\/nz5+3q1as4s4aw7ty502bNmpUNK+Rwj57rablClBQnAiIgAukgUJUAMgJjitM\/5ZnrJp50ccDpHj0fGhqKQ3VUBxEQAREQgQgJVCWAjMCOHj2affndTXv6t8STrpI2Tk5OZrPxnmG1r1P09\/cbU7arVq3KlltXh3YmAiIgAiIQGwJVCSAju1o8BMNrE93d3eYEcGRkxPATXg05RJTXNRYuXFhNMcorAiIgAiKQAAJVCSAjO0ZUYT8EA1cW0r5w4YK3tihb\/ITz1Oe6dess94EY4mQiEGMCqpoIiEDMCFQlgLVsC6M9xJXpVLb42d\/ixYu9pz6d34XxlChx+GUiIAIiIAIiUIxAaALIiIzpUP9DMPgJL1YJxYuACIhAogmocbEkEIoAInJf+9rXpn0NgpEbL7ITTnwsW69KiYAIiIAIpJZAKALo3s\/L\/RqE87v41FJWw0VABERABGJHIBQB5GEYntK89957sx+95QlR\/ITPnz8\/dg1XhURABERABNJNoCoBROR40Z37fjt27LBf\/vKXxmsG+NniP3jwYFYU041arRcBERABEYgTgaoEkJEfL7pzvy\/IiCddnBqtutSXgPYmAiIgAnEkUJUAxrFBqpMIiIAIiIAIlEIgNAHcs2eP99I6059+Y4qUqdJSKqM0IiACSSOg9ohAfAmEIoAI3OHDh+3QoUO2cuVK27dvn7c+KO7Vq1ebpkDjewCoZiIgAiKQVgKhCCDw5syZY83Nzd43\/Fi7kzBeg2CFFgQSv0wEREAERCA9BOLe0lAE0H2lYXh42Lq6uuzHP\/6xsWYnfr7jF3cIqp8IiIAIiED6CIQigKzL+cILLxijPUaBLIF29913G69GPPPMM5oCTd9xpRaLgAiIQOwJhCKAtJL7fCxazbavr8+7B8irET09PUSn09RqERABERCB2BIITQBj20JVTAREQAREQATyEAhNAFnwmqlP\/ysQ+AnPs18FiUDSCah9IiACMScQigAicnz1ga8\/MO3pDD\/hxMecg6onAiIgAiKQMgKhCKD72gOvPfj5Ob+L98fJLQIiIAKJJaCGNQSBUASQB1\/46gNff3Dv\/LHFTzjxDUFDlRQBERABEUgNgaoEEJFjqTPu+\/HKA19\/4CsQ+Nni19cgUnMsqaEiIAIi0FAEqhJARnZ87cHd8\/toezr7GgTxpGsoKqqsCIiACIhA4glUJYB+OjzowlOfjP6c4Sfcn05uERABERABEYgDgVAEEJHjaU+e+vSPAvETTnxQY4lDKBFNplOZVs2X1v+1idHR0WySDRs2ZL9CQZpshByREdCORUAERKARCIQigO4pT\/fUp2u487t4F+7fDg4OGkKJcHZ0dBjrh\/rjcbOuKF+bOHbsmPeliYGBAUM4EcITJ04Y4XyJgpVoSEsemQiIgAiIgAgUIhCKAHKPDxFbtmyZtwg2O0SI8BNOPGG5hoixfmhbW5sX1dvb660nSrgXcO3P+Pi48bUJFt1ub2+3y5cv25kzZ7yvT8ydO\/daKrN58+Z5YdkAOURABOpMQLsTgcYhEIoA0tydO3faI488YiyCzXQmW\/yEE1\/InACShq9H5BsxIqQsuk2aS5cu2cWLF23x4sW2bds2Q2i3b99uPHEaJLbkO378uDdaPHfuHF6ZCIiACIhAigmEJoAw9C+CzZQmfsJrZdzzQ\/gYIW7evNnuvPPO7Ag03z537dpl3G8cGhrKF60wERABERCBKgg0WtZQBbDSxk9OTmaztrS0GFOd2YBrjgsXLnj3\/fAy7clnl8jHi\/aMDFtbW23hwoWGGJImn\/X39xv3CVetWpUvWmEiIAIiIAIpIhCKAPLkJiMrtuWwQ7gQMISMfCMjI4afcPzO+Mgu9\/2YGj158qR3PxDBY+qUe4jcMySO6VPCXL7cLeLKC\/oIZW6c\/CIgAiIgAukiEIoAct+Ne3T5nuAshnPt2rXG6I77hmzxk4fpTQw39\/qWL19uiNf69euN6U5EkilW9suDMcStXr3aIv3+IJWViYAIiIAINASBUASQkR+vI7AcGkLmt0Lv9kEIIWNaknuGbPETjrhhuDHcpJmYmPAefiEM4yEbwjHSECYTAREQAREQgWIEQhFARoAseYYI5RrhxBeriOIrI8ATrbwHGaYxlVxZbVKdS40XARFoMAKhCGCDtTkx1UX8Nm7c6D3Zyj3YsIwyEwNJDREBERCBAAJVCyAvvC9ZsiS7HBmrswTsS8EhE0AAebfx9vuesq513wjNbu15IOSaqjgRSDgBNa8hCVQlgDx9yXt4zz\/\/vPf1B5Yj41077gk2JI0GrXTT9c12w6L28OyW9gYloWqLgAiIQOkEqhJAXj1gVzyFyZZXE3gqk1Va8MtEQAREQAREIK4EqhLAjxr1kYv39SSAH\/GQSwREQAREIJ4EQhfAeDYz3bU69v0X7Vf3fdr+MGNTj\/2Z4U83EbVeBERABMyqFkAemecldN79YyqUx\/H5BiB+rNh7gOqE2hL46Q\/\/zvZkBPC1zG4ezdir75\/3\/GGKYKZY\/RcBERCBhiNQlQDyfh\/v+eW+++f3E0+6hiOTkApfv3uzLclpC\/4\/yIhiTrC8IiACIpAqAlUJYKpINWhjuwPqTfilzGgwIFrBIlAiASUTgcYlIAFs3L4rqeZjAanGb2yxuRkLiFawCIiACCSegAQw4V38i3sft4mcNuI\/\/fkv5oTKKwIiIALlEWj01BLARu\/BIvXvzAhgX8buz6TbnbEHMqM+\/IRnvPqfIAKsCsRDaGEaqw0lCJGaIgLTCEgAp+FIpgexu+l779ibL71h8zOGP5ktTXerWIUprPVgXTmsCysRTPdxleTWSwCr6d0Gy6t7fg3WYWVWtxZrwjKqlACW2RFK3jAEJIAN01WqqAgUJqA1YQvzUawI5BKQAOYSkV8ESiOgVCIgAg1OQALY4B2o6ouACIiACFRGQAJYGTflEgERSDMBtT0RBCSAiehGNUIEREAERKBcAhLAcokpvQiIgAiIQCIIVCiA4bX9ypUrxjtHxb4csWfPHiMNNjo6mq0AbsKwDRs2ZMPlEAEREAEREIFCBCIXwMHBQVuwYIHxBYmOjg4bHh6eUd9Tp07Z4cOHjRUu9u3bZwMDA4ZwEs7Lv4SfPHnS+BgvYTMKUIAIiIAIiIAI5BCIVAARsbGxMWtra\/Oq1dvba\/gJ9wKu\/RkfH7c5c+ZYU1OT8c1BhO7MmTNG+PLly43PLc2ePdv27t1rixcvvpZLm1oRULkiIAIikAQCkQqgA+gEEP\/58+ft6tWrOKcZo0REjsBLly7ZxYsXcdpbb71lS5Ys8aZHi02BsqoFo0WtbOGh0x8REAERSDWBWAhgpT0wOTnpTXsyEkTYTpw4YdwTDCqP6VLuNw4NDQUlUbgIiEBBAooUgeQQiIUAImQOaUtLizfV6fxue+HCBe++H\/65c+dac3OzN3XqRoZMj5LXXxZp\/dbf328HDhywVatW+YPlFgEREAERSCGBSAWQKc3u7m5zojUyMmL4Cff3RVdXlzfSY2qUh124H9ja2mqEv\/vuuzY1NeVNmzJ96p9O9ZeBG4Hs7Oy0hQsX4pWJgAiIgAiUQSBpSSMVQGCuXbvWGN3xGgNb\/ITz2gOGmwdbeNgF8Vq\/fr1t3rzZEEl\/OHGrV6+2np4esshEQAREQAREoCCByAUQIWNaktcg2OKnxn19fYbhxnCTZmJiYtqTni6cONyklYmACIiACIhAMQKRC2CxCsYqXpURAREQARFIDAEJYGK6Ug0RAREQAREoh4AEsBxaSptmAmq7CIhAwghIABPWoWqOCIiACIhAaQQkgKVxUioREIE0E1DbE0lAApjIblWjREAEREAEihGQABYjpHgREAEREIFEEihRABPZdjVKBERABEQgxQQkgCnufDVdBERABNJMQAKY5t4vse1KJgIiIAJJJCABTGKvqk0iIAIiIAJFCUgAiyJSAhFIMwG1XQSSS0ACmNy+VctEQAREQAQKEJAAFoCjKBEQARFIM4Gkt10CmPQeVvtEQAREQATyEpAA5sWiQBEQAREQgaQTkAAW6mHFiYAIiIAIJJaABDCxXauGiUA4BI4fP27Hjh0L1c6dOxdO5VSKCFRBQAJYBTxlTTQBNe4agV27dtmaNWtCtY0bN5pE8BpgbSIjIAGMDL12LAKNQeD2+56yrnXfCM1u7XnAGFVKABuj\/5NcSwlgkntXbROBEAg0Xd9sNyxqD89uaQ+hVjUuQsWngkDkAnjlyhVvamXRokW2dOlSm5qaygt+z549RhpsdHR0RpoNGzYYNiNCASIgAiIgAiKQh0DkAjg4OGgLFiyw06dPW0dHhw0PD8+o5qlTp+zw4cPeTfh9+\/bZwMCAIZwuIYKYL5+L11YEREAEREAEcgkECGBustr4EbGxsTFra2vzdtDb22v4CfcCrv0ZHx+3OXPmWFNTk7W3t9vly5ftzJkzXiwjRgTxwQcf9Pz6IwIiIAIiIAKlEIhUAF0FnQDiP3\/+vF29ehXnNGOUOHv2bC\/s0qVLdvHiRc+9Y8cOe\/jhh+2mm27y\/IX+cOOdx7l1870QJcWJgAiIQDoIxEIAK0XN1Cd5e3p62BQ19zj30NBQ0bRpTqC2i4AIiEAaCMRCACcnJ7OsW1pavKnObMA1x4ULF7L3\/ebOnWvNzc02MjLi3TPkwRhGgtwHLPQgTH9\/vx04cMBWrVp1rVRtREAEREAE0kogUgFkSrO7u9ucACJo+An3d0hXV5d334+p0ZMnT3r3A1tbW23nzp3ewzM8QLNp0yZbuXKlF+bP63cjrp2dnbZw4UJ\/sNwiIAJZAnKIQHoIRCqAYF67dq0xumMUxxY\/4bz2gOFevHixLV++3BCv9evX2+bNmy1XJEknEwEREAEREIFSCUQugAgZ05KM4tjip\/J9fX2G4cZwk2ZiYsIQRML8RjwjQn+Y3CIgAiIgAqUTSFvKyAUwbcDVXhEQAREQgXgQkADGox9UCxEQAREQgToTkAAhKI34AAAOlElEQVT6gcstAiIgAiKQGgISwNR0tRoqAiIgAiLgJyAB9NOQO80E1HYREIGUEZAApqzD1VwREAEREIEPCUgAP+SgvyIgAmkmoLankoAEMJXdrkaLgAiIgAhIAHUMiIAIiIAIpJLANQFMZdvVaBEQAREQgRQTkACmuPPVdBEQARFIMwEJYJ16n4\/w8jHeQrZ161a7\/7rrbHfGnmhtNfyF0vPx4DCqrzJEIAoCx48ft0LHd7lxnGNRtEP7bFwCEsA69B0n5saNG23NmjWBdtddd9k9W7bYa5n6PJqxb733nue\/4447AvNQZiap\/otAQxLYtWtX4LFd6FwJiuN84FxrSBiqdCQEJIB1wM5Jya\/d2+97yrrWfSOv\/en779uSnLrg\/8IHH+RNTzm39jyQk0NeESiXQHTpC50PHN\/lGOcC5xjnWnQt0p4bjYAEsI491nR9s92wqD2vdQfUg\/CPz\/lk3jw33NIekEvBIhB\/AoXOh6DzJDBc50L8OzyGNZQAxqRTxgLqMX5ji83NWEC0gkVABESgYgJpzygBjMkR8It7H7eJnLrgP\/35L+aEyisCIiACIhAGAQlgGBRDKKMzI4B9Gbs\/U9bujD2QGfXhJzzj1X8REAEREIGQCaRbAEOGWW1xiN1N33vH3nzpDZufMfzVlqn8IiACIiAC+QlIAPNziTRU9\/wixa+di4AIpISABDAlHa1mziCgABEQgZQTiFwAr1y54r0Mu2jRIlu6dKlNTU3l7ZI9e\/YYabDR0VEvDWnJQxhGGi9Cf0RABERABESgCIHIBXBwcNAWLFhgp0+fto6ODhseHp5R5VOnTtnhw4e9ZZP27dtnAwMDhnDu2LHDVq9e7eU9dOiQvfzyy+bEcUYhChABERABR0BbEcgQiFQAEbGxsTFra2vLVMWst7fX8BPuBVz7Mz4+bnPmzLGmpiZrb2+3y5cv25kzZ2znzp3W19fnpWptbbXbbrvNc+uPCIiACIiACBQjEKkAuso5AcTPAs9Xr17FOc0YJc6ePdsLu3Tpkl28eNFzuz8IIsKIQLqw3C1LJbHArpZLyiUjvwiIgAikhkC2obEQwGxtKnRwL\/Dpp5+2bdu22fz58wNLcYvvDg0NBaZRhAiIgAiIQDoIxEIAJycns7RbWlq8qc5swDXHhQsXvPt+eOfOnWvNzc04jfuDX\/nKV+zb3\/62LV682AsL+tPf328HDhywVatWBSVRuAiIgAiIQEoIRCqATGl2d3ebE8CRkRHDT7iff1dXl3ffj6nRkydPevcDueeH+L344ot28ODBgiM\/Vxbi2tnZaQsXLnRBqdyq0SIgAiIgAmaRCiAdsHbtWmN0x2sMbPETzisNGG5GdsuXLzfEa\/369bZ582aCbfv27XbkyBHvwRjyY3oK1EOjPyKQSgLuPj\/3+sMyPTOQ3EMpcgFktMe0JK9BsMUPbp7uxHBjuEkzMTHhTXWSjvSE+a2np4fkMhEQgbwEkh3o7vOvWbPGe784jO3GjRtNIpjM4yZyAUwmVrVKBEQgCgJhfmSXD\/LqQ7tR9GL99ikBrB9r7UkERKDGBEL9yC4fr07Yh3ZrjL\/hipcANlyXqcIiIAIiIAJhEJAAhkFRZYiACIiACDQcgXQJYMN1jyosAiIgAiJQKwISwFqRVbkiIAIiIAKxJiABjHX3qHIhElBRIiACIjCNgARwGg55REAERGAmAb1gP5NJEkIkgEnoRbVBBESgMIEqY\/WCfZUAY5pdAhjTjlG1REAE4kNAL9jHpy\/CrIkEMEyaKksERCCRBPSCfUN3a2DlJYCBaBQhAiIgAiKQZAISwCT3rtomAiIgAiIQSEACGIgmORFqiQiIgAiIwEwCEsCZTLxPnxT7ltjWrVvt\/uuus90Ze6K11fAH5Tl\/\/nyevShIBEQg7QT0ekW0R4AEMIc\/3\/3i+1+FviN211132T1btthrmbyPZuxb773n+e+444683yCjvEwy\/ReBCAhol3EmoNcrou0dCWAOfwSQX2WFHnv+0\/fftyU5+fB\/4YMPjG+I5RrfFMtJLq8IiIAIWKHrTO51pBQ\/1xquX1zHhLc4AQlgAKOm65vtBr4Hlse6A\/IQ\/vE5n5yZT98UCyCmYBFIN4FC15mg60\/B8JxrTbrpFm+9BLA4oxkpxmaEfBgwfmOLzc3Yhz79FQEREIFoCDAKDHomoZLwpI4oJYAVHJ+\/uPdxm8jJh\/\/057+YEyqvCIiACNSfQNj3Fr\/62F95DwfWvyW13WOyBbBG7DozAtiXsfsz5e\/O2AOZUR9+wjNe\/RcBERCBSAmEeW+R+4o\/P\/WmDQ0NWamjx0gbX8bOG14A9+zZY4sWLfJsdHS0jKZXlxSxm\/s\/3rRX+l6wWTv+p+GvrkTlrjWB3\/72t3bq1CljW+t9qfxwCNBX6rPyWYZ6b\/HafcVyRpWNMmXa0ALIiXH48GHvV8m+fftsYGDArly5Uv7RUmEOTs6zF\/9NF9QK+dU424zi6a+3335b\/TWDTHwD1Gfx6ZtSRpV\/eM96+39t\/6VhpksbWgDHx8dtzpw51tTUZO3t7Xb58mU7c+ZMfI4Y1UQEREAEEkKgpFFlZrT4u4\/PbpgWN7QAQnnBggU2e\/aHwC9dumQXL14kOK+V8mSUW7Vl6uKUTU0VNn6dsiP2WSitS1dKmYXKyY1TuVPZ0VwpbB2vYv0FZ5e2lHJJX6rVotxalEl74lCuq0OxPnPpsv1V5NylfaWYyi3\/HJMAogoxsoULF9pnP\/tZK2UO263a8vP\/tdf+995NBe2twa32Hyb\/0f7P688XTPfm63s9GqWUWWyf\/niVu8nKYVBqf8G4nHJJX6rVotxalEl74lBuqX0Wh7rCrFRrpPqWU1f6a+knf2Ncc72LXsz\/NPwI8MKFC9n7fnPnzrXm5uYZyOmM\/v5+O3DgQMl28JV99t19fxuase+wy6R+KvdvvT5NO1sdBzoOuB5gtTgWyinz+WfXRy2AMzQgKKChBbCrq8u773f16lU7efKkdz+wtbU1b1sRwc7OTpOJgY4BHQM6Bmp3DHCtzXsRjmFgQwvg4sWLbfny5Z6orV+\/3jZv3py9HxhD1qqSCIiACIhAjAg0tADCsa+vz06fPm0TExOGIBKWdlP7RUAEREAEihNoeAEs3kSlEAEREAEREIGZBCSAM5koRAQamICqLgIiUCoBCWCppJROBERABEQgUQQkgBV2J+uOujVIWY+0wmKUrY4ENmzY4K0ZS78tWbLEWxe0jrvXrkokwAvqK1asmNY\/Ot9KgxdVqnx91gjnmwSwgiOGzual+kOHDhnGeqSEVVCUstSJAGvE8s4oa8bqoak6Qa9gN6zvu2zZMjt79mw2N+eWzrcsjtg58vVZo5xvEsAKDifeOWTZNV66571D1iMlrIKilKVOBHhXlLVi6bM67VK7KZMAQrd\/\/37bu3evzZs3L5ubc0vnWxZHrBxBfdYo51uyBLCOh0ZLS4u3CLfb5eTkpHNqG0MCXER\/8pOf2N133+1NgzI9E8NqprpK8+fPt507d9qsWbNmcND5NgNJLAKC+qxRzjcJYCwOI1Wi1gR6enq890WZ\/uTkZDpU925rTV3lp5VAo5xvEsAKj1C+GsEw32Vva2tzTm2jIVDyXvl6CF8R0ai9ZGSRJ9T5FnkXVFyBOJ9vEsAKupVvD7LwNp9o4fuD3FsirIKilKVOBHiK0E17ct\/ixIkT1tvbW6e9azfVEODc0vlWDcH6522U800CWMGxwbz317\/+de9+EveUcBNWQVHKUicCTMmwK16B6OzstI6ODnNhhMviS4Bzi3OMcw3DTdi0GssTKwLu3Ir7+SYBrPCwoYO5n4ThrrAYZasjAR6woL8w3HXctXZVBgHW9B0bG5u2ti\/nGP2G4S6jOCWtA4F8fcY5Rn9huOtQjbJ3IQEsG5kyiIAIiIAIxIhAxVWRAFaMThlFQAREQAQamYAEsJF7T3UXAREQARGomIAEsGJ08cmomoiACIiACJRPQAJYPjPlEIGyCfDSPU\/EOeMx8bILKTEDr3nkLiZdYlYlE4FUEZAApqq71dgoCCB+Bw8etGPHjnmr0bB97rnnLBwRjKJF2qcIJIOABDAZ\/ahWxJQAozHE75lnnjH37hpb\/AMDA8aq+VSdl\/Td6BDBJIy4NWvWZIWSstzIjhX4cRPv8iGo5HnyySeNdU\/Xrl077ZNClCkTARH4iIAE8CMWcolA6ARYd5RCWc2ErTPeZTtw4ICxTBSCx8o0jAz5vNbLL7+cFT2XPt+WTwZ1d3d7o8qVK1cagkq6F154wW677TYbHByc9i4dcbJkEVBrqiMgAayOn3KLQFECuV8yyM3AmqSrV6\/2Roi8UMz38EZGRnKTzfDzyaCuri4vXMu6eRj0RwTKIiABLAuXEotA+QRyF3L2l8CUJV+m8IeVurA6AqjvG\/rJyS0C5RFobAEsr61KLQJ1J+CmPt1UqKsA9\/DWrVvnefkyhee49ocR4TXntA2Lr\/\/mN7+ZFiaPCIhA5QQkgJWzU04RKEqAB16Y3uSpTx5iIQPbxx9\/3G6\/\/XbvHiAjPh6UIRxhPHLkiPmnNN106Pj4uEkAISgTgXAISADD4ahS6k+gYfbY19dniGBnZ6fxxCZb\/ITTCLZ8nYJwvnbwyCOPeF+q4AGZzZs3G4JIvl\/96lf2qU99iiwFrampyebMmWN6CrQgJkWKgEkAdRCIQB0IIHKsiu8Mv3+3rJafL46HYiYmJrwnPbdu3Wo\/+MEPvCc7CcfNCJNy\/E+VIpw8YUo+0hEvEwERmElAAjiTiUJEQATiTkD1E4EQCEgAQ4CoIkRABERABBqPgASw8fpMNRYBERCBNBMIre0SwNBQqiAREAEREIFGIiABbKTeUl1FQAREQARCIyABDA1l\/QrSnkRABERABKonIAGsnqFKEAEREAERaEACEsAG7DRVOc0E1HYREIGwCEgAwyKpckRABERABBqKgASwobpLlRUBEUgzAbU9XAL\/HwAA\/\/+R\/d3pAAAABklEQVQDAIYXnYBObkALAAAAAElFTkSuQmCC","height":0,"width":0}}
%---
%[output:3b7fbf88]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:513dd4bb]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:11d87885]
%   data: {"dataType":"text","outputData":{"text":"    0.0047    0.0245    0.0637    0.1104    0.1435    0.1493    0.1295\n\n","truncated":false}}
%---
%[output:9a7681f6]
%   data: {"dataType":"text","outputData":{"text":"    0.0052    0.0272    0.0707    0.1226    0.1594    0.1658    0.1438    0.1068\n\n","truncated":false}}
%---
%[output:748d7df6]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 7.682093\n","truncated":false}}
%---
%[output:0d1da693]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 6.850801\n","truncated":false}}
%---
%[output:740ae506]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAcAAAAFQCAYAAAAoQ64wAAAQAElEQVR4Aeydb0hd2533f8y7McbMQFGq6WV0hHlxR8NAJYKgbxSkEi4kzICOZR7ufbjX4bmQPhNjyYXSgYGEMd7SwC3XBK4QsAotEUIJCPHFKAhm7EOIti\/yYE1Jo0W5tEWtfdnJZzXr9Hhy\/uyjx332n2\/IOnuvv3v9Pmu7vmf92fv8xR\/1TwREQAREQARSSOAvTP9EQAREQAREIIUEJIApbPSMyToRAREQgRQTkACmuPFlugiIgAikmYAEMM2tL9vTTEC2i0DqCUgAU38LCIAIiIAIpJOABDCd7S6rRUAE0kxAtjsCEkCHQR8iIAIiIAJpIyABTFuLy14REAEREAFHIKUC6GzXhwiIgAiIQIoJSABT3PgyXQREQATSTEACmObWT4DtBwcHNjQ0ZC0tLW+5np4e++Uvf+niSUNaTK60W1hYcNfmWG7Z6+vr9t3vftdl4\/zChQs2OTnp\/FH6gN3o6Kjt7u5GqVqqiwiciIAE8ET4lLnaBGpra21mZsY2Nzft3r17rjpjY2POv7i4aH\/zN3\/j4klDWpegwh+9vb3uehzLKRox+fjjj+33v\/99Odmqkvbf\/\/3fbXV1tSrX1kVF4LQISABPi6zKjQQBRi6M\/nCcM7pilPXpp5+6URsjR86J55xRI8JE5Unvw4kjL+G5jpEf8Rx9HvJ99NFH7hrZZfq8pPvWt75lv\/rVr2xubs6NUv\/whz+46KdPnxp1pExGXS7w9Qd5KJdwXKH6vE5q5CMNjjzkpX74OZIGO6kbafH7EShpcD4d16GO1LWvr89I5\/OSDufTcsQP02wbuAbhhJGf61XH6aoi8GcCEsA\/s9BZSgjs7+\/bmTNnbG1tzTo7O+0HP\/iBvf\/++\/bw4UP73e9+Z+Pj444Eo56trS1bWVlxo0vC6eBdZImPn\/\/858bozpeJgGRnYTT6\/e9\/3772ta\/Z5cuX3Sj1L\/\/yL10S6re8vGyMZB8\/fuwEh4ig9aGOXI8RMdenLtPT09be3u6uNz8\/T3HOfkStv7\/fEMhbt27Zu+++68Kp03\/8x3+4Kc+RkRFXR+pKfZqbmw3xbmpqcmmp57Vr1zL1pPBf\/\/rX9uzZM5ePurS2tjqOf\/VXf2Vch+uRTk4EqklAAlhN+rp2VQicPXvWurq6DBFqbGx0ooA4NDQ0GB00lWKEw5RfR0eH1dfXZ8RjY2OD6JKOcigPx3nQfBRMnagbooEY7uzsOCEqtz4ffvihkRchQsSwA3soB\/sQQkQN27kuDrEnH2LLFDJ5CM92L168MES1u7vbMYQl8VyLIw5R5YgNnndNTY0hmoTLiUA1COReUwKYS0R+EXhNgM6c0SCjF6buGCkyWgoqZHT0dPiviyr7P6KRm6mc+lBXHGUgZtSfUSF+hAm7GP0ihAgiIofgMgomDSKIKPqpU8KyHXVBmBkRU\/Z7771n+IOyyS5L5yJQTQISwGrS17UjS8CP3JgKZIONdxMTE1Wpczn1QczY9EOdmZ6kwn46E2FjRPrjH\/\/YTfciiMTj2MRDHgSQkSFHpk6Jy3bUhVEdZZPeO0aZ2el0LgJRJyABjHoLVbJ+KiswAUZFjI4YJTFdyAiK0Q7HwIVUMGE59WHTit9sMjw87NY5\/YjUl8NaHkKIIFJNbPQbYkjzne98h2DLNxplDZC1wqWlJbd2mH09l0kfIhATAhLAmDSUqhk+AdbBEA6mE5lKZMTDKKlSNUFoEFmmWRGf3\/zmN0WLDlofRmLs1mRqEoFjve7GjRtuvY4L+FEf16YOhHH87LPPDGFE6LGX0a+3lzxMAcOCkSEbeNggRPlMhbLrs62tjaLkRCA2BCSAsWkqVbQUATprpuMQAJ\/WTwcyJcg5cWwK8Z01U5p+swciwDlh5Cc9+SgTR17Cc52\/Lkefh3yc55aZm5drUTbXRQSpm78O5RHHkXyUR7mE4Xw64nKdL5d0lNnW1pabxBC17ECYkJY8OMrw8dSBMBzn3i78OMJIyzHbTx0pk7J9\/bGBc9LLiUA1CUgAq0lf1xaBEAn4ac7c0V2IVdClRCBSBCIhgDwTxI4zpl74Fswfaj5KrDWQBufXYkhLHsJwpMmXV2EikHYC2aO27NFd2rmkwn4ZmZdAJASQnWY8+8TUCesSrInk1pa3Rzx69Mg9TMsDvlNTU24BnvWHwcFB9yoqHvr9\/PPPzYtjbhnyi4AIiIAIiIAnUHUBZPTHbjK\/24x1CfyE+0py5M0YbL3m2SoW3nnuiAdy+SbLOgNp\/O40zvO5V69eOQFlEV9uRSxWxEB\/B7oHKn0P0M\/m63+jGFZ1AfRQvADiZ3fZ4eEhp0cco0S\/eL63t+fecpGdAEFEGBHI7HAzMxrl+vXr7p2LTLfKDYnFkBjo70D3QKXvAfpZ+tvcPjiK\/sgI4EnhsBb4ySef2M2bN92rq3LLo0GePHlit2\/fdu9dZCda0tzVq1ed2Um2kTaTnTOJuofT0J5psNH\/bdLP0t+6zijiH5ERwOzXKPHsFVOduey2t7fduh\/hdXV1xhspOGd98IMPPrAvvvjC2G5NWCFH2Z2dne7h4KQdL1686MxOso20Wbl2kieOTnYm5+80bW3pOqIYfFRdAJnS5KW6XgB5QS9+wrP58cJdpjeZGuU9hqwHsuaH+PEA7+zsbN6RX3YZOhcBERABERABT6DqAkhFeF0TozseY+CIn3AeacBxzshuYGDAjdz46RXebEE4P63C2ytY9yM\/Lq27QM+fP29MtXCETVId9snO5LTu6bZnNDilwcZokC6vFpEQQEZ7zB\/zGARH\/JjB7k4c5zjOSZP7ZgnCsh1voyB92lxa\/shkZ7Lu7DS0ZxpsjONdGQkBjCM41VkEREAERCDaBErVTgJYipDiRUAEREAEEklAApjIZpVRIiACIiACpQhIAEsRinO86i4CIiACIlCQgASwIBpFiIAIiIAIJJmABDDJrSvb0kxAtouACJQgIAEsAUjRIiACIiACySQgAUxmu8oqERCBNBOQ7YEISAADYVIiERABERCBpBGQACatRWWPCIiACIhAIAIJFcBAtiuRCIiACIhAiglIAFPc+DJdBERABNJMQAKY5tZPqO0ySwREQASCEJAABqGkNCIgAiIgAokjIAFMXJPKIBFIMwHZLgLBCUgAg7NSShEQAREQgQQRkAAmqDFligiIgAikmUC5tksAyyWm9CIgAiIgAokgEKoA7u7uWk9Pj7W0tNjQ0JAdHBy8BZEw4khDWvJkJ8J\/6dIlW19fzwSPjo66MskzOTmZCdeJCIiACIiACBQiEKoAjo+P2+DgoK2trbn6rKysuGP2x\/T0tDU2Ntrm5qZ1dHTY3NxcJhrR6+vrs5cvX2bCFhYWbHV11Sjr4cOHNjMzc0QcMwnTcCIbRUAEREAEAhMITQAZuSFUra2tVltba93d3TY\/P3+kooz+lpaWjDRE9Pf3G37CyX\/\/\/n27e\/eunTt3jmjnGhoarK6uzp3zQRxhnOdzT548cWL56tWrfNEKEwEREAERKJMA\/SmDkK2trTJzVjd5aAKImQhVtjhtb2\/nnQb1AkgegB4eHlp9fb1NTEzYmTNnCM64trY2u3nzpjEyvHXrls3Ozrq0mQQ5J3fu3HHTrw8ePMiJkVcEYk1AlReBqhGgP2Xp6vr161Wrw3EuHKoAHqeCpfKw5ofwLS8v240bN+wb3\/hG0SnQ27dvu2nSK1eulCpa8SIgAiIgAgEI0J+y\/HT16tUAqaOTJFQB3Nvbs52dnYz1rPUxHZoJeHOysbHx5sysqanJampqMv7cE9IynUo5zc3Ndv78eUMMc9N5P+V1dna6dD5MRxEQARGINYEqV55+l3714sWLVa5JeZcPTQCZwmRTC4LFmh5re6zxZVcXEUPMSEM4a4T4CcefzzFdSlmUyVQpU6aE5UurMBEQAREQARHwBEITQC44Njbm1uja29vdTs\/e3l6CjWlMHJ7h4WFjbZBHGjjiJ7yQGxkZcWVRJt9A2GXqyy2UR+EiIAIiIAIiEKoAMgpcXFx0jziwocXjR8Rw+BntMZfMYxAc8RPuHZteGPFx9GETExOuTPL4cnycjiIgAiIgAiKQj0CoApivAgoTAREQAREQgWoQkABWg7quWVECKkwEREAEjkNAAngcasojAiIgAiIQewISwNg3oQwQgTQTkO0icHwCEsDjs1NOERABERCBGBOQAMa48VR1ERABEUgzgZPaLgE8KUHlFwEREAERiCUBCWAsm02VFgEREAEROCkBCeBJCVYzv64tAiIgAiJwbAISwGOjU0YREAEREIE4E5AAxrn1VPc0E5DtIiACJyQgATwhQGUXAREQARGIJwEJYDzbTbUWARFIMwHZXhECEsCKYFQhIiACIiACcSMgAYxbi6m+IiACIiACFSEQUwGsiO0qRAREQAREIMUEJIApbnyZLgIiIAJpJiABTHPrx9R2VVsEREAEKkEgVAHc3d21np4ea2lpsaGhITs4OHjLBsKIIw1pyZOdCP+lS5dsfX09E7ywsODKJM\/o6GgmXCciIAIiIAIiUIhAqAI4Pj5ug4ODtra25uqzsrLijtkf09PT1tjYaJubm9bR0WFzc3OZaESvr6\/PXr58eSTszp07RlmUu7+\/f0QcMwl1IgIikAACMkEEKkcgNAFk5La6umqtra1WW1tr3d3dNj8\/f8QSRn9LS0suDRH9\/f2Gn3Dy379\/3+7evWvnzp0j2rnl5WUbGBiw+vp6Vy7xbW1tLi7fx5MnT5xYvnr1Kl+0wkRABERABMokQH\/KIGRra6vMnNVNHpoAYmZdXZ01NDRw6tz29nbeaVBE0iV4\/QHQw8NDJ3ATExN25syZ16FH\/z99+tQuXLjgpkFLTYEyWmSK9cGDB0cLkU8EREAEROBYBOhP6VevX79+rPxBM1U6XagCWOnKU97GxoYx7clIkG8gjDJZEyQun7t9+7bNzMzYlStX8kUrTAREQAREoEwC9Kf0q1evXi0zZ3WThyqAe3t7trOzk7GYtT6mQzMBb04QtTen1tTUZDU1Nd771pHRoi+HdKTPzp+bgfjOzk47f\/58bpT8IiACIiACxyBAf0q\/evHixWPkrl6W0ASQNTo2tSBOrOmxtscaX7bpiCFrg6QhnDVC\/ITjz+e6urrs+fPnxhohU6VMmSKK+dLGPkwGiIAIiIAIVIxAaAJIjcfGxmx2dtba29vdTs\/e3l6CbXJy0jk8w8PDxtogjzRwxE94IceGFzbB8O0Dxy5TX26hPAoXAREQAREQgVAFkFHg4uKie8SBDS0e\/8jIiOHwM9pjLpnHIDjiJ9w7BI\/RI0cfRl7S4zj34TqKQIIIyBQREIEKEwhVACtcdxUnAiIgAiIgAscmIAE8NjplFAEREIGQCOgyp0JAAngqWFWoCIiACIhA1AlIAKPeQqqfCIiACIjAqRCIiQCeiu0qVAREQAREIMUEJIApbnyZLgIiIAJpJiABTHPrx8R2VVMEREAEToOABPA0Oo4xhgAAEABJREFUqKpMERABERCByBOQAEa+iVRBEUgzAdkuAqdHQAJ4emxVsgiIgAiIQIQJSAAj3DiqmgiIgAikmcBp2y4BPG3CKl8EREAERCCSBCSAkWwWVUoEREAEROC0CUgAT5vwScpXXhEQAREQgVMjIAE8NbQqWAREQAREIMoEJIBRbh3VLc0EZLsIiMApE5AAnjJgFS8CIiACIhBNAqEK4O7urvX09FhLS4sNDQ3ZwcHBW1QII440pCVPdiL8ly5dsvX19exgdz46Omo459GHCIiACMSVgOodCoFQBXB8fNwGBwdtbW3NGbeysuKO2R\/T09PW2Nhom5ub1tHRYXNzc5loRK+vr89evnyZCfMnCwsLR9L6cB1FQAREQAREIB+B0ASQkdvq6qq1trZabW2tdXd32\/z8\/JE6MfpbWlpyaYjo7+83\/IST\/\/79+3b37l07d+4c0RlH3NTUlH3zm9\/MhOlEBERABERABIoRCE0AqURdXZ01NDRw6tz29nbeadDW1lYXz8fW1pYdHh5afX29TUxM2JkzZwg+4hhZvv\/++\/bVr371SHg+z5MnT4yR56tXr\/JFK0wEREAERKBMAvSn9Kv012VmrWryUAXwNCxl6pNye3t7OZR0d+7cceuPDx48KJlWCURABERABEoToD9l78b169dLJ45QilAFcG9vz3Z2djLms9bHdGgm4M3JxsbGmzOzpqYmq6mpyfhzT5hGZZ2QTTOMBDkvthHm9u3bNjMzY1euXMktSv6IEFA1REAE4kWA\/pR+9erVq7GqeGgCyBQmm1oQN9b0WNtjjS+bFmLI2iBpCEfc8BOOP59jWpQNM7ixsTG7fPmymyrNl5YwBLWzs9POnz+PV04EREAEROCEBOhP6VcvXrx4wpLCzR6aAGIWAjU7O2vt7e1up6eftpycnDQcaYaHh421QUZ0HPETLicCIpAGArJRBMIjEKoAMgpcXFx0jzgwcvNmjoyMGA4\/oz2G0ozoOOIn3Lu2tja3M5SjD\/NHysgu14frKAIiIAIiIAK5BEIVwNyLyy8CIiACIiACnkDYRwlg2MR1PREQAREQgUgQkABGohlUCREQAREQgbAJSADDJl7seooTAREQAREIjYAEMDTUupAIiIAIiECUCEgAo9QaqkuaCch2ERCBkAlIAEMGrsuJgAiIgAhEg4AEMBrtoFqIgAikmYBsrwoBCWBVsOuiIiACIiAC1SYgAax2C+j6IiACIiACVSEQEQGsiu26qAiIgAiIQIoJSABT3PgyXQREQATSTEACmObWj4jtqoYIiIAIVIOABLAa1HVNERABERCBqhOQAFa9CVQBEUgzAdkuAtUjIAGsHntdWQREQAREoIoEJIBVhK9Li4AIiECaCVTbdglgtVtA1xcBERABEagKgVAFcHd313p6eqylpcWGhobs4ODgLaMJI440pCVPdiL8ly5dsvX1dReMn3Skx01OTrpwfYiACIiACIhAMQKhCuD4+LgNDg7a2tqaq9PKyoo7Zn9MT09bY2OjbW5uWkdHh83NzWWiEb2+vj57+fJlJsyXSfqHDx\/a559\/bgsLC5n4SJ+ociIgAiIgAlUjEJoAMlJbXV211tZWq62tte7ubpufnz9iOKO\/paUll4aI\/v5+w084+e\/fv2937961c+fOEe3cxMSEjYyMuPPm5mZ799133bk+REAEREAERKAYgdAEkErU1dVZQ0MDp85tb2\/nnQZFJF2C1x9bW1t2eHho9fX1htidOXPmdWj+\/y9evLD9\/X1rb2\/Pn+B16JMnT4yR56tXr1779F8EqkZAFxaBxBCgP6Vfpb+Ok1FlCyAjMdbcRkdHI2Un9frkk0\/s5s2bTiwLVe7OnTtu\/fHBgweFkihcBERABESgDAL0p+zduH79ehm5qp+0bAFkJLa4uGhMT7LpBHfhwoXMppRiJu3t7dnOzk4mCWt9TIdmAt6cbGxsvDkza2pqspqamow\/3wlrgx988IF98cUX1tbWli9JJuz27ds2MzNjV65cyYTpRAREQARCJZCwi9Gf0q9evXo1VpaVLYDeut7eXrdRhc0nbFwZHh52uzsRxHybUBBONrUgbqzpsbaHiPryOCKGrA2SBj9rhPgJx5\/PIX6fffaZzc7OFh35+bwIamdnp50\/f94H6SgCIiACInACAvSn9KsXL148QSnhZz2WACJgDHcRO9ytW7dseXnZCSLzwFNTU8aUZK45Y2NjTqhYo2P0h4iShkcXcJwjpKwNUi5H\/ITnc9SDaz9+\/Nit+5EHl0+A8+VXmAiIgAiIQHoJlC2ACNvAwEDmUQVGgAx9\/SiNkR5+jrlYCWP6dHNz021o8fHs4sThpxzy55ZLHI4pTkaPHLPTkt47L6yklxMBERABERCBfATKFkAKYRqR0Rzn3iGMjAo5+jAdRUAEREAERCCqBAILIMLG7k\/meZnm5Mh0o3f4MbLUhhXSyKWbgKwXAREQgSgQCCyAfvrSix9HP+Xoj0xdMi0ZBcNUBxEQAREQAREoRiCwAPpCEEKEjqMP01EEREAEghFQKhGIDoHAAsgUKGt8P\/vZzzIvtPbTn\/7IFCnpomOeaiICIiACIiAC+QkEFkBGfIz8\/v7v\/978Tk4\/9emPhJMu\/6UUKgIiIAIikGYCUbM9sABGreKqjwiIgAiIgAichEBgAWRqkylOP92Z70g86U5SIeUVAREQAREQgTAIBBZApjaZ4vTTnfmOxJMujIrH8hqqtAiIgAiIQGQIBBZARnbaBBOZdlNFREAEREAETkggsAAystMmmBPSVvY0E5DtIiACESMQWAAjVm9VRwREQAREQAROROBYAsivMDAdmr0RBj\/hJ6qNMouACIhAEgnIpkgSKFsAEbkPP\/zwyK9BsCGGnzcinPhIWqpKiYAIiIAIiEAWgbIF8PDw0GXP\/TUI7\/fxLpE+REAEREAERCCiBMoWQDbD8Cvt\/\/iP\/5j50Vt2iOInnPi3bVWICIiACIiACESLQGABROR40J11v\/HxcfvVr35l\/AQSfo74Z2dnM6IYLTNVGxEQAREQARE4SiCwADKy40F31vsKOeJJd\/QS8qWdgOwXAREQgSgSCCyAp1l5Ns6wi5TRJKNMRpv5rjc5OWmkwS0sLBxJQp5Lly7Z+vr6kXB5REAEREAERCAfgWMJYLYQIUbeFROvfBf3YdPT05ldpR0dHTY3N+ejMkeE7dGjR8YP8d67d8+mpqYM4SQBcX19ffby5Uu8ciIgApEhoIqIQHQJlC2AjLQQoocPH9rly5cNMWJKlPPBwUErdwoUEVtaWrLW1lZHqb+\/3\/AT7gLefCwvL9vZs2etpqbG2tvbbX9\/3168eOHWHO\/fv2937961c+fOvUmtgwiIgAiIgAgUJ1C2AFIcQtTQ0OBEa35+niDjMQiEC4F0AWV+eAEk29bWluV7nIJnDWtra0lie3t7trOz4wR3YmLCzpw548JLfTx58sSNIl+9elUqqeJFQAREQAQCEKA\/ZXaOvjs7edTPyxZARmAYxTRlV1eX\/fd\/\/7dbd8MfB+Pv3LljrDc+ePAAM+REQAREQAROSID+lH71+vXrJywp3OxlCyAjsO9\/\/\/tumpJRIEa\/9957xqMR3\/nOd9yI7DgmbGxsZLI1NTW5qc5MwJuT7e3tzLpfXV2dcf03UYEPt2\/fNl7qfeXKlcB5lFAEREAERKAwAfpT+tWrV68WThTBmLIFEBtY58NYjiMjI8YaIK63t5foshyCygP0XgCZUsVPeHZBjDZZ92NqdG1tza0HNjc3ZycJdI648tzi+fPnA6U\/USJlFgEREIEUEKA\/pV+9ePFirKw9lgBW2sLh4WFjdMduUo74uQa7TXGct7W12cDAgHv4\/tq1a3bjxg3LFUnSyYmACIiACIhAEALHEkB2aDL1iWB5h5\/wIBfNTYOQMaJkFMkRP2kYXeI4x3FOmmfPnhmCSJh3+NmEw9GH6SgCVSSgS4uACEScQNkCiMjxqw\/syESMvMNPOPERt1nVEwEREAEREAErWwBZg4Mbjz1w9M77fbwP11EEREAEUkdABseCQNkCyMYXNqnw6w\/+mT+O+AknPhaWq5IiIAIiIAKpJhBYABE5XnXGmh+PPPDrD+z6wc8Rv34NItX3kowXAREQgVgRCCyAjOwWFxczjzz4tb\/sI\/GkM4sVA1VWBERABEQghQQCC2A2Gza6sOuT0Z93+AnPTqdzERABERABEYgqgbIFEJFjtye7PrNHf\/gJJz6qxqpe4RDQVURABEQgDgTKFkC\/y9Pv+vRGer+P9+E6ioAIiIAIiEAUCZQtgKzxMdrj9\/f4HT6M4oifcOIJk0sGAf+Wd970XsiRJhnWyoqTE1AJIhAfAmULIKbx80P\/+q\/\/arwEmzVAjvgJJz7Kzv8ckjrz0q2EsF3+Xx+7X89gjbeQ+9\/\/5\/8aaUuXqBQiIAIiEB0CxxJAqu9fS+bXAfETHnXnfw5JnXnplkLUvtxcs3\/4p3+zro\/+M6\/7u95\/tv+\/\/v8kgKVxKoUIJJ5A3Aw8tgDGzVBfX3XmnkTwY81fN9hXWtrzu79tdwWVGlkz4kZQXWJ9iIAIiEAECJQtgDwQz+iJYwTqX3YVgnTmZReqDFZqZM09w49lSgR1s4iACESFQNkCyCYXNrvwC\/BRMSIy9UhxRYqNrJk+ZaqUUaIEMMU3iUwXgYgRKFsAGfmtrq4ar0NjA0y241VpxEfMRlUnDwGEiGnJYm5raytPzvxBRUfWTJ++mSrNn1uhIiACIhA+gbIFkBEgrzzzm1+yj4QTH74Z6bhiENEiTSkapGE6kmnJYo40pcqqVjw2FBNvH0e6kOqoy4iACMSMQNkCGDP7ql5dOmDfGZ\/0iCAVEyziSMM1ixlOPNORQaYti5VTrTjqj53YW8qRjvTVqmtY18XGk95fPj9lhVVvXUcEqkmgLAHkgfcLFy6Yn\/ZcWFioZt2rem06Cd9hFDvSAZfqpIPGlxKtctfZ4jptCftSLNK07giPIM9rBr3PuGcps6p\/YHG7uOobSwKBBZB3fN66dcs+\/fRT94sQDx8+dDv\/ylnzIy3rhAgof4yUmUuNMOJIQ1ry+DSTk5N5xXd0dDQTThqf\/rSOdA50EtSzlCvVUSNa1DPoaKyoaKVsna0oixStO3I\/BnleM+h9xj1LmaSXizcB2rHYF3QfR7p4W3q82gcWQP+Oz\/b2Pz331dzcbOwG3dnZCXxlNs4MDg7a2tqaywN8d5L1MT097cplbbGjo8P8blNGn48ePTLy3Lt3z6ampgyxZBTKphzCEeWZmRkjbVaRFT\/lZqGTqKRoqTOveDMlokDuNe7tYs5vVip6D735clQ0TYq+NCTi5ihhBPdO0C\/qpCN9iSITFx1YAPNZvr+\/b38SwHyxR8MYySFUra2tVltba93d3TY\/P38kEYK2tLRkpCGiv7\/f8BO+vLxsZ8+etZqaGkOEufaLFy+soaHB6urqSO7cuXPnXJjznPKHOpPTAcW5ndYAABAASURBVMwfYpAO\/3SuHp1S4UDHVGqWgTTRqXU8agLbYveYjyNdPCx6u5bUPegXddKR\/u1Skh1yIgEsFw1ChWD5fNvb224U5\/3+6AUQP99u\/eiTESfiSfje3p4T37a2Nrt586bxMm6maGdnZ63YTtQvf7FmTBcd\/jb4yJXryVWGAH9ovnMpdCy1nlXpDp8\/\/EJ1yQ4nXWUoBCuF68Er6ExDsFKDpeK62bbnnlO3YCVFLxV15x4q9cWCeNKRPnpWBK9RGF\/UYcQ9Qn8dvGbVT1mWAGJcZ2enW29jFIbB\/AYg63W43DW7MMxjzQ\/hY4R448YN+8Y3vlF0CvT5wg9t+e637eVPH4dRvVRcoxwjg7wxhi8oxTp9v25aznULpeUPl06Ozq6UIx3pC5V1WuFhdGC5dS\/VTnxJqSQLyqI\/qYSjrFx7sv3EI\/DF7rE0baLKZnPc8wcPHriX5vM3ctwyqpEvsAAyquI5P9bmCjniSVfIED9q8\/HZIzofxnFjY4ODc01NTW7aE0\/2iNGPJknLdCojQ9Ylz58\/b4gh6fM5f9O\/8\/W+fNEKO2UCnj8dTD7nxa1op\/9mPStoVensCnWsxOGC1It0dJ5BrxvndMV40EZ8SakUC8rhF0VKfQEJGk8nTJml+Be9x7QeWgrfkfgrV64Y+y+uXr1qcfoXWABPahTCyKYWBIs1Pdb2WOPLLhcRQ8xIQzhrhPgJ7+rqMtb9mA5lEw3rgQge06WURZnEMUoljPz5nL\/pOeaLT0IYHXWhDp9wGFXLTrgXfLH2KXU6xUYzdJawCFqvUmzhG8QF6aCpV7VcUR5vvoD8icWK25hWyOYgdpKGXxQpJbqwKJaGL1SIM\/WiTNLLhUOAgQezgxcvXgznghW6SmgCSH3HxsaMNTqmTxn99fb2EmxMY+LwDA8PGyM9plQ54iectb6BgQED8rVr14zpToRxZGTE7RqlTOLYZerLJd9xHH9Ahf6gCa+mgASxp1iHz7do3+kHKSsJaYp1mnSY5dhYii18gzjaIO6ddBAW5dgZRHSLpjmlL1Dl3B\/F0tLe9B+lHOmKlaO4yhEIVQAZBTJNyhRq9o\/nImI4zELUGEqThiN+wnGkIfzZs2eGIBKGoyzCcaQh7CSu1B82f9QnKf+08xbr8P235NOuQ5TKL9ppvhnNBK1vULbF0iG6fMmKe0dXzEZ\/nyXBziD3Bm1ZStjoN5L25SgImyinCVUAowwiu25B\/rCz00ftvGiHH\/FvyVFjmVufoGyLpitTdHPrEBV\/URtTdJ8hfkHEjS8DQfoW0lFmVNo5yfWQAOZpXf1h54GiIBEQgbwEECtEq5i4Meonc9C+hfJKjSi5LmXKHZ+ABPD47MyUVwREoCSBUp151NfUg9a\/qLiVOeovtQzDVCqjTolgyduvaAIJYFE8ihSB0yMQtGM9vRqEU3KpzpyOPJyaHO8q1ah\/sdFk2tZXj9dqwXJJAINxUioRyCVwYn81OtYTV\/oYBQTpzI9RbGhZqlH\/oqPJFK2vnnYjSwBPm7DKF4ECBKrRsRaoyqkGV6MzLza6LnfKtRr1D9oglbQz6DWTlE4CmKTWlC2xIhDljjVWIPNUttjouiJTrnmuWY2gtNh5WmwlgKdFVuWKgAhUjUCx0bXfkVm1ylXwwpW0s9hokh2pSdxwIwGs4M2ookRABKJBoOjouswdmdGwKH8tKmlnsdEku055XysvvUYMC7lyp5fzWxVe6DEFMLwK6koiIAIiIAKnT6DUaJL3tTJ9jBgWcsSffk0rdwUJYOVYqiQREAERiC2BIKPJYiLpH8+IEwAJYJxaKyJ1VTVEQATSSaCoSMbw8QwJYDrvY1ktAiIgAqknIAFM\/S0gACJQDgGlFYHkEJAAJqctZYkIiIAIiEAZBCSAZcBSUhEQARFIM4Gk2S4BTFqLyh4REAEREIFABCSAgTApkQiIgAiIQNIIhCqAu7u71tPTYy0tLcaDlAcHB2\/xJIw40pCWPD7R5OSky0vcwsKCDzbOCcONjo5mwit+ogJFQAREQAQSQyBUARwfH7fBwUFbW1tzAHmdjjvJ+pienrbGxkbb3Ny0jo4Om5ubc7Hr6+v26NEjI8+9e\/dsamrKEEvCeYUP4ZS7v79vhLlM+hABERABERCBAgRCE0BGcqurq9ba2mq1tbXW3d1t8\/PzR6qFoC0tLbk0RPT39xt+wpeXl+3s2bNWU1Nj7e3thtC9ePHCCB8YGLD6+npX7t27d62trY3sciJQSQIqSwREIGEEQhNAuNXV1VlDQwOnzm1vb7tRnPNkfSCS3svLVQ8PD52XkSHiiWdvb892dnY4tadPn9qFCxfc9GipKdAvf7FmX26u2eFv\/5TXFaAPERABERCBYxOgP41jvxqqAB6bbpGMGxsbbjTISJBpUEaZrAkWyvJ84Ye2fPfb9vKnjwslUbgIiIAIHCUgX1EC9Kf0q09\/9L2i6aIWGaoAZo\/aAJE9osPvHaLmz5uamty0J\/7sEaMfTTJa9OUwPUr67Pzky3b+Za7vfL0vO1jnIiACIiACxyRAf6qXYReBxxodm1oQJ9b0WNtjjS87C9ObrA2ShnDWCPET3tXV5UZ6TIey2YX1wObmZiP8+fPnxhojcUyZIorkz+f8y1w55otXmAiIgAiIQHkE6E+\/ktyXYZcHo1DqsbExm52ddZtYGLX19va6pDzegMMzPDxsjPR4pIEjfsLZ2MJml87OTrt27ZrduHHDbXrJDieOXaa+XPLJiYAIiIAIiEA+AqFOgTIKXFxcdI84TExMZOozMjJiOAIY7c3MzLg0HPETjiMNj0c8e\/bsyE5PH04c56SVEwEREAEREIFiBEIVwGIVUVx0CahmIiACIpBEAhLAJLaqbBIBERABEShJQAJYEpESiECaCch2EUguAQlgcttWlomACIiACBQhIAEsAkdRIiACIpBmAkm3XQKY9BaWfSIgAiIgAnkJSADzYlGgCIiACIhA0glIAIu1sOJEQAREQAQSS0ACmNimlWEiIAIiIALFCEgAi9FRXJoJyHYREIGEE5AAJryBZZ4IiIAIiEB+AhLA\/FwUKgIikGYCsj0VBCSAqWhmGSkCIiACIpBLQAKYS0R+ERABERCBVBAoIICpsF1GioAIiIAIpJiABDDFjS\/TRUAERCDNBCSAaW79ArYrWAREQATSQEACmIZWlo0iIAIiIAJvEQhVAHd3d62np8daWlpsaGjIDg4O3qoQYcSRhrTk8YkmJyddXuIWFhZ8cOY4OjpquEyATkRABMokoOQikB4CoQrg+Pi4DQ4O2tramiO8srLijtkf09PT1tjYaJubm9bR0WFzc3Muen193R49emTkuXfvnk1NTR0RUATRp3UZ9CECIiACIiACRQiEJoCM5FZXV621tdVqa2utu7vb5ufnj1SN0d\/S0pJLQ0R\/f7\/hJ3x5ednOnj1rNTU11t7ebvv7+\/bixQuSGWUjiN\/85jedXx8iIAIiIALlE0hbjtAEELB1dXXW0NDAqXPb29tHRnEu8PUHIvn64P5vbW3Z4eGhO2dkiHji2dvbs52dHU6NkeX7779vX\/3qV52\/2MeXv1izLzfX7PC3f8pbLK3iREAEREAEShOgP41jvxqqAJbGWH4Kpj7J1dvby6Gke77wQ1u++217+dPHJdMqgQiIgAiIQGkC9Kf0q09\/9L3SiSOUIlQBzB61wSB7RIffu42NDX9qTU1NbtqTgOwRox9NMo3K2h8bYxgJcl5sI8w\/\/NO\/WddH\/2nvfL2PIo86+URABERABMomQH9Kv\/p3vf9cdt5qZghNAOvr692mFsSNNT3W9ljjyzae6U3WBklDOOKGn\/Curi637sd0KJtoWA9sbm62iYkJt2GGTTNjY2N2+fJlF0b+fK7mrxvsKy3txjFfvMJEQAREQATKI0B\/Sr\/6lb9tLy9jlVOHJoDYiUDNzs66TSyM\/vy0JY834EgzPDxsjPQY0XHET3hbW5sNDAxYZ2enXbt2zW7cuOE20xAnJwIVIKAiREAEUkYgVAFkFLi4uOhGbIzcPOuRkRHD4We0NzMz49JwxE84jjSM9J49e2YIImHZjvjscrPjdC4CIiACIiAC2QRCFcDsC+tcBERABCJDQBVJJQEJYCqbXUaLgAiIgAhIAHUPiIAIiIAIpJLAGwFMpe0yWgREQAREIMUEJIApbnyZLgIiIAJpJiABTHPrv7FdBxEQARFIIwEJYBpbXTaLgAiIgAiYBFA3gQikmoCMF4H0EpAAprftZbkIiIAIpJqABDDVzS\/jRUAE0kwg7bZLANN+B8h+ERABEUgpAQlgShteZouACIhA2gmkWwDT3vqyXwREQARSTEACmOLGl+kiIAIikGYCEsA0t366bZf1IiACKScgAUz5DSDzRUAERCCtBCSAaW152S0CaSYg20XgNQEJ4GsI+i8CIiACIpA+AqEK4O7urvX09FhLS4sNDQ3ZwcHBW8QJI440pCWPTzQ5OenyErewsOCCiScdYTjSuAh9iIAIiIAIiMDbBDIhoQrg+Pi4DQ4O2tramqvAysqKO2Z\/TE9PW2Njo21ublpHR4fNzc256PX1dXv06JGR5969ezY1NeUE1JdJ+ocPH9rnn39uXhxdRn2IgAiIgAiIQB4CoQkgI7XV1VVrbW212tpa6+7utvn5+SNVYvS3tLTk0hDR399v+AlfXl62s2fPWk1NjbW3t9v+\/r69ePHCJiYmbGRkhOTW3Nxs7777rjvXhwiIgAiIgAgUIxCaAFKJuro6a2ho4NS57e1tN4pznqwPRNJ7t7a27PDw0HkZGSKeePb29mxnZ4fTjEMQEUYEMhOYc\/LlL9bsy801O\/zt0bw5yRLtlXEiIAIiUEkC9Kdx7FdDFcBKAs8tixHmJ598Yjdv3rT6+vrc6Iz\/+cIPbfnut+3lTx9nwnQiAiIgAiJwfAL0p\/SrT3\/0veMXUoWcoQpg7qgte0SXbfvGxkbG29TU5KY9CcgeMWaPJlkf\/OCDD+yLL76wtrY2khZ0\/\/BP\/2ZdH\/2nvfP1voJpFCECySUgy0Sg8gToT+lX\/673nytf+CmWGJoAMipjUwvixpoea3us8WXbxvQma4OkIZw1QvyEd3V1uXU\/pkPZRMN6IGt+iN9nn31ms7OzRUd+lIer+esG+0pLu3HELycCIiACInAyAvSn9Ktf+dv2kxUUcu7QBBC7xsbGnFCxRsfor7e3l2Dj0QUcnuHhYWOkxyMNHPETzshuYGDAOjs77dq1a3bjxg2C7datW\/b48WO3MYY8OO0CdWj0IQIiIAJHCMhzlECoAsgocHFx0T3iwO5NXxV2ceLwM9qbmZlxaTjiJxxHGh53ePbsmZvqJI40hGU7L6zkkRMBERABERCBfARCFcB8FVCYCIiACIiACFSDQLoEsBqEdU0REAEREIFIEpAARrJZVCkREAEREIHTJiABPG3CKj8qBFQPERABEThCQAJ4BIc8IiACIiACaSEgAUy7RRGSAAAIz0lEQVRLS8tOEUgzAdkuAnkISADzQFGQCIiACIhA8glIAJPfxrJQBERABNJMoKDtEsCCaBQhAiIgAiKQZAISwCS3rmwTAREQAREoSEACWBBNciJkiQiIgAiIwNsEJIBvM1GICIiACIhACghIAFPQyDIxzQRkuwiIQCECEsBCZBQuAiIgAiKQaAISwEQ3r4wTARFIMwHZXpyABLA4H8WKgAiIgAgklIAEMKENK7NEQAREQASKE0i2ABa3XbEiIAIiIAIpJpAIAZycnLSWlhbnFhYWUtycMl0EREAERCAogdgL4Pr6uj169MhWVlbs3r17NjU1ZQcHB0HtV7rkEpBlIiACIlCUQOwFcHl52c6ePWs1NTXW3t5u+\/v79uLFi6JGK1IEREAEREAEYi+ANGFjY6PV1tZyant7e7azs+PO8318+Ys1+3Izvzv87Z\/yFUtD3kqmi2pZQe2sZP2rcc2411\/Mjv4tZ9ozwX\/ncWjzfH1vFMMSIYBBwJ4\/f94uXrxozxd+aMt3v53XPf3R91xRxdKQt5LpolpWUDsrWf9qXDPu9Rezo3\/LQdozSJqgXIOmi\/s1y6k\/\/Sz9retMI\/6RCAHc3t7OrPvV1dVZQ0PDW9hpkNu3b9vMzIycGOge0D2ge+CU7gH6Wfrbtzrh8AICXyn2AtjV1eXW\/Q4PD21tbc2tBzY3N+cFQKN0dnaanBjoHtA9oHvgdO4B+tm8HXAEA2MvgG1tbTYwMOBE7dq1a3bjxo3MemAEeatKIiACIiACESEQewGE48jIiG1ubtqzZ88MQSQszU62i4AIiIAIlCaQCAEsbaZSiIAIiIAIiMBRAhLAozzkE4GYE1D1RUAEghKQAAYlpXQiIAIiIAKJIpAKAeT9oP5dobw3NAktuLu7az09Pe79p0NDQ5nHQLJt4zVxFy5ccGmwf3R0NDs61ue87g67adtYG5JVee7NQm2UxLb0bci9iStkexaiWJzSjtiD42+Uv9Xcip9We+ZeJ2w\/bYjdODiEff1yr5d4AeTmu3Pnjj18+NA53htKWLmgopZ+fHzcBgcH3aMf1I13oXLMdrwR591333Vp2CQ0MTGRHR3bc9qPnb\/5bI6rUXQctGmh+iexLaenp423OHFv0parq6sWh06zUBsRjrDRx2APdnV0dNi3vvWtt76gJrE9+TLKM9k8jkZ\/yzPX8IBLVF3iBZDG4PVoPBzP84G8N5SwqDZIkHohAHQWra2t7pGP7u5um5+ffyvrxsaG62D8a+LeShDDAEYNCMUPfvAD+9rXvhZDC96uMp1+f3+\/Xb58+e3INyFJbMuRkRHzX8rq6+sNsXhjbmwP7EL\/yU9+YtiDEbQrx1yXxPbs7e11Lxfw\/c25c+fyvpQkl0U1\/ckSwAIkm5qa3MuyfTQ3nz+P6zH3jTd880IcvD2cLy0t2dzcnJsCZSo06t\/GfN2LHfnjotP0HUyxtHGJQwjoPArVN6ltmW0vX+qeP39uvNgiOzzu53wx5Qsq9623JentyWzGe++9557PjvrfaSoE0N94aTryB8cUBNMwuE8\/\/dQ+\/vhjo6NJE4ck2Jr0tkQQmCa8evVqop7jZWTP\/ccXHI7eJb09+YLKLBtfwD0Db3vUjqkQwK2tLeNVaR4+U4f+PK5HpnVZR\/D1Zy2FPyzvzz0yBfzHP\/6x6C9l5OaJmT811U1SW\/KFjLVs3uBUbBQct8ZlFESdEQOOxVyS2tPbSV9EnxT12bbECyC\/Ech0IWLB7wTye4GE+YaK45FpBdZLuLn49sw3rdy1BsI\/+ugj89Oe\/G4i7+hjHTSONqe5zkltS8SPkd8XX3yRqJEf4sffY+7Iz9\/DSW1PNsFgO3bStuxTgAP+qLrECyBiwdQKc9I4zgmLaoMErdfY2JjNzs66HwHmm5b\/9syUA45vYEx5Dg8PuzXAzz\/\/XO9JDQo3IuloR1xS25LNTOyW5KXUbJvHYe+x8EckEyLAuvuHH37o\/u6wicd1ED1swyW1PX0fhM20KSN7HxaR5nmrGokXQCymEVgHw3FOWNwdIr64uOjegZo9zcK3Thz2sSON96NiN0f8hCfBefuT0p60Ce2I4xxHO+I4p+1owyS1JbZiT7bz9mJzHB33Y7Y9nLMWj+hhGw67ktie2JXdpt5WwqPqUiGAUYWveomACIiACJyYwLELkAAeG50yioAIiIAIxJmABDDOrae6i4AIiIAIHJuABPDY6KKTUTURAREQAREon4AEsHxmyiECZRNgFyC7Adkhl+sI5\/2RHElXduHKIAIicCwCEsBjYVMmESiPALsA2Q3IrkBeFMwzmRzxE87LvTmSrrySlVoEROC4BCSAxyWnfCJQQQI8P+ZHgDxM\/N3vfjfzc1f4eX6MkWPuO12JIxxHmgpWSUWJQOIJSAAT38QyMI4E\/uu\/\/st+\/OMfu5\/wevz4sfHWH0aLfX19dv\/+fWcSgsdL0HnvIqNJXnaAkLpIfaSCgIw8GQEJ4Mn4KbcInAoBXnXHw\/68J\/Kdd96xf\/mXf3HX8e+xZa2QV+D5XxrgwWrEEaF0CfUhAiJQkoAEsCQiJRCB8Al4oSt1ZV4nxvQnjldwSQBLEVO8CPyZQLwF8M926EwEUkng3r177nV4TI\/ieBVVKkHIaBE4BgEJ4DGgKYsIVJsAu0WZ\/pyamjKmQ3n7fk9Pj7EuWO266foiEBcCEsC4tJTqmUsg9X5eNswvgfDzXrx9n3VDwlIPRgBEICABCWBAUEomApUiwIYVNrBw9GXyKwL+OUCmMb2QsRHmJz\/5Seb38ggn3ufjnKlPHOc+XEcREIHSBCSApRkphQiIQNQIqD4iUAECEsAKQFQRIiACIiAC8SMgAYxfm6nGIiACIpBmAhWzXQJYMZQqSAREQAREIE4EJIBxai3VVQREQAREoGIEJIAVQxleQbqSCIiACIjAyQlIAE\/OUCWIgAiIgAjEkIAEMIaNpiqnmYBsFwERqBQBCWClSKocERABERCBWBGQAMaquVRZERCBNBOQ7ZUl8D8AAAD\/\/1VfX00AAAAGSURBVAMA2AFPgM4ZQMUAAAAASUVORK5CYII=","height":0,"width":0}}
%---
%[output:39ca9a5f]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAcAAAAFQCAYAAAAoQ64wAAAQAElEQVR4Aeydb0hd2533f8y7McZM4RKpppfRCn1xR0OhEkHQNwakEi4kTEFrGbj34V6Hp5A+jbHkQunAQEKNtzRwyzWBKwSsQkuEUAJCfDEKghn7EKIzL\/JgzZBGB+UyHdSxL\/vks5p1uj05nrOPHvfZf76Xu87ea63fWnv9Putkf11\/9j5\/9Sf9JwIiIAIiIAIZJPBXpv9EQAREQAREIIMEJIAZ7PScyzoRAREQgQwTkABmuPPlugiIgAhkmYAEMMu9L9+zTEC+i0DmCUgAM\/8VEAAREAERyCYBCWA2+11ei4AIZJmAfHcEJIAOgz5EQAREQASyRkACmLUel78iIAIiIAKOQEYF0PmuDxEQAREQgQwTkABmuPPlugiIgAhkmYAEMMu9nwLf9\/b2bGBgwJqbm98K3d3d9h\/\/8R8uHxtscbnSYW5uzl2bY7l1r66u2k9+8hNXjPPz58\/b+Pi4i8fpA3bDw8O2vb0dp2apLSJwLAISwGPhU+FqE6itrbWpqSlbX1+3e\/fuueaMjIy4+Pz8vP3t3\/6ty8cGW2dQ4Y+enh53PY7lVI2YfP\/737f\/+Z\/\/KadYVWz\/6Z\/+yZaXl6tybV1UBE6KgATwpMiq3lgQYOTC6I\/AOaMrRlmffvqpG7UxcuScfM4ZNSJMNB57n04eZUnPD4z8yOfoy1Du448\/dtcI1unLYveDH\/zAfv\/739vMzIwbpf7xj3902U+fPjXaSJ2Mulzi6w\/KUC\/phMPa89rUKIcNgTKUpX3EOWKDn7QNW+J+BIoNwdtxHdpIWy9evGjY+bLYEbwtR+IwDfrANUgnjfJcrzpBVxWBvxCQAP6Fhc4yQmB3d9dOnTplKysr1tHRYb\/4xS\/sgw8+sIcPH9p\/\/\/d\/2+joqCPBqGdjY8OWlpbc6JJ0bvAus8THv\/\/7vxujO18nAhIswmj05z\/\/uX3ta1+zy5cvu1HqX\/\/1XzsT2re4uGiMZB8\/fuwEh4yw7aGNXI8RMdenLZOTk9bW1uauNzs7S3XOf0Stt7fXEMhbt27Ze++959Jp0z\/\/8z+7Kc+hoSHXRtpKe5qamgzxbmxsdLa089q1a7l2Uvl\/\/ud\/2rNnz1w52tLS0uI4\/s3f\/I1xHa6HnYIIVJOABLCa9HXtqhA4ffq0dXZ2GiLU0NDgRAFxqK+vN27QNIoRDlN+7e3tdvbs2Zx4rK2tkV0yUA\/1ETgPW46KaRNtQzQQw62tLSdE5bbno48+MsoiRIgYfuAP9eAfQoio4TvXJSD2lENsmUKmDOnB8OLFC0NUu7q6HENYks+1OBIQVY744HnX1NQYokm6gghUg0D+NSWA+UQUF4HXBLiZMxpk9MLUHSNFRkthhYwbPTf811WV\/T+ikV+onPbQVgJ1IGa0n1EhcYQJvxj9IoQIIiKH4DIKxgYRRBT91ClpwUBbEGZGxNT9\/vvvG\/GwbIJ16VwEqklAAlhN+rp2bAn4kRtTgWyw8WFsbKwqbS6nPYgZm35oM9OTNNhPZyJsjEh\/\/etfu+leBJF8Apt4KIMAMjLkyNQpecFAWxjVUTf2PjDKDNrpXATiTkACGPceqmT7VFdoAoyKGB0xSmK6kBEUox2OoSupoGE57WHTit9sMjg46NY5\/YjU18NaHkKIINJMfPQbYrD58Y9\/TLIVGo2yBsha4cLCgls7DF7PFdKHCCSEgAQwIR2lZkZPgHUwhIPpRKYSGfEwSqpUSxAaRJZpVsTnv\/7rv4pWHbY9jMTYrcnUJALHet2NGzfceh0X8KM+rk0bSOP42WefGcKI0OMvo1\/vL2WYAoYFI0M28LBBiPqZCmXXZ2trK1UpiEBiCEgAE9NVamgpAtysmY5DALytnw5kSpBz8tgU4m\/WTGn6zR6IAOekUR57ylEngbKk5wd\/XY6+DOU4z68zvyzXom6uiwjSNn8d6iOPI+Woj3pJI3g78vKDrxc76mxtbc03MUQtmAgTbClDoA6fTxtII3Du\/SJOIA1bjsE4baRO6vbtxwfOsVcQgWoSkABWk76uLQIREvDTnPmjuwiboEuJQKwIxEIAeSaIHWdMvfBXMP9QC1FirQEbgl+LwZYypBGwKVRWaSKQdQLBUVtwdJd1LpnwX04WJBALAWSnGc8+MXXCugRrIvmt5e0Rjx49cg\/T8oDvxMSEW4Bn\/aG\/v9+9ioqHfj\/\/\/HPz4phfh+IiIAIiIAIi4AlUXQAZ\/bGbzO82Y12COOm+kRx5MwZbr3m2ioV3njvigVz+kmWdARu\/O43zQuHVq1dOQFnEV1gSiyUx0L8DfQcq\/R3gPlvo\/hvHtKoLoIfiBZA4u8v29\/c5PRAYJfrF852dHfeWi6ABgogwIpDBdDMzOuX69evunYtMtyoMiMWAGOjfgb4Dlf4OcJ\/lfpt\/D45jPDYCeFw4rAV+8skndvPmTffqqvz66JAnT57Y7du33XsX2YmWtnD16lXndpp9pM\/k51SqvsNZ6M8s+Oj\/bXKf5X7rbkYx\/4iNAAZfo8SzV0x15rPb3Nx0636k19XVGW+k4Jz1wQ8\/\/NC++OILY7s1aYcF6u7o6HAPB6fteOHCBed2mn2kz8r1kzJJDPIzPf9Os9aX7kaUgI+qCyBTmrxU1wsgL+glTnqQHy\/cZXqTqVHeY8h6IGt+iB8P8E5PTxcc+QXr0LkIiIAIiIAIeAJVF0AawuuaGN3xGANH4qTzSAOBc0Z2fX19buTGT6\/wZgvS+WkV3l7Buh\/lCVndBXru3DljqoUjbNIa8E9+pqd3T7Y\/48EpCz7Gg3R5rYiFADLaY\/6YxyA4EscNdncSOCdwjk3+myVICwbeRoF91kJW\/pHJz3R9s7PQn1nwMYnfylgIYBLBqc0iIAIiIALxJlCqdRLAUoSULwIiIAIikEoCEsBUdqucEgEREAERKEVAAliKUJLz1XYREAEREIFDCUgAD0WjDBEQAREQgTQTkACmuXflW5YJyHcREIESBCSAJQApWwREQAREIJ0EJIDp7Fd5JQIikGUC8j0UAQlgKEwyEgEREAERSBsBCWDaelT+iIAIiIAIhCKQUgEM5buMREAEREAEMkxAApjhzpfrIiACIpBlAhLALPd+Sn2XWyIgAiIQhoAEMAwl2YiACIiACKSOgAQwdV0qh0QgywTkuwiEJyABDM9KliIgAiIgAikiIAFMUWfKFREQARHIMoFyfZcAlktM9iIgAiIgAqkgEKkAbm9vW3d3tzU3N9vAwIDt7e29BZE08rDBljJBI+KXLl2y1dXVXPLw8LCrkzLj4+O5dJ2IgAiIgAiIwGEEIhXA0dFR6+\/vt5WVFdeepaUldwx+TE5OWkNDg62vr1t7e7vNzMzkshG9ixcv2suXL3Npc3Nztry8bNT18OFDm5qaOiCOOcMsnMhHERABERCB0AQiE0BGbghVS0uL1dbWWldXl83Ozh5oKKO\/hYUFw4aM3t5eI0465e\/fv2937961M2fOkO1CfX291dXVuXM+yCON80LhyZMnTixfvXpVKFtpIiACIiACZRLgfsogZGNjo8yS1TWPTABxE6EKitPm5mbBaVAvgJQB6P7+vp09e9bGxsbs1KlTJOdCa2ur3bx50xgZ3rp1y6anp51tziDv5M6dO2769cGDB3k5iopAogmo8SJQNQLcT1m6un79etXacJQLRyqAR2lgqTKs+SF8i4uLduPGDfv2t79ddAr09u3bbpr0ypUrpapWvgiIgAiIQAgC3E9Zfrp69WoI6\/iYRCqAOzs7trW1lfOetT6mQ3MJb07W1tbenJk1NjZaTU1NLp5\/gi3TqdTT1NRk586dM8Qw387Hqa+jo8PZ+TQdRUAERCDRBKrceO673FcvXLhQ5ZaUd\/nIBJApTDa1IFis6bG2xxpfsLmIGGKGDemsERInnXihwHQpdVEnU6VMmZJWyFZpIiACIiACIuAJRCaAXHBkZMSt0bW1tbmdnj09PSQb05gEIoODg8baII80cCRO+mFhaGjI1UWd\/AXCLlNf72FllC4CIiACIiACkQogo8D5+Xn3iAMbWjx+RIxAnNEec8k8BsGROOk+sOmFER9HnzY2NubqpIyvx+fpKAIiIAIiIAKFCEQqgIUaoDQREAEREAERqAYBCWA1qOuaFSWgykRABETgKAQkgEehpjIiIAIiIAKJJyABTHwXygERyDIB+S4CRycgATw6O5UUAREQARFIMAEJYII7T00XAREQgSwTOK7vEsDjElR5ERABERCBRBKQACay29RoERABERCB4xKQAB6XYDXL69oiIAIiIAJHJiABPDI6FRQBERABEUgyAQlgkntPbc8yAfkuAiJwTAISwGMCVHEREAEREIFkEpAAJrPf1GoREIEsE5DvFSEgAawIRlUiAiIgAiKQNAISwKT1mNorAiIgAiJQEQIJFcCK+K5KREAEREAEMkxAApjhzpfrIiACIpBlAhLALPd+Qn1Xs0VABESgEgQiFcDt7W3r7u625uZmGxgYsL29vbd8II08bLClTNCI+KVLl2x1dTWXPDc35+qkzPDwcC5dJyIgAiIgAiJwGIFIBXB0dNT6+\/ttZWXFtWdpackdgx+Tk5PW0NBg6+vr1t7ebjMzM7lsRO\/ixYv28uXLA2l37twx6qLe3d3dA+KYM9SJCIhACgjIBRGoHIHIBJCR2\/LysrW0tFhtba11dXXZ7OzsAU8Y\/S0sLDgbMnp7e4046ZS\/f\/++3b17186cOUO2C4uLi9bX12dnz5519ZLf2trq8gp9PHnyxInlq1evCmUrTQREQAREoEwC3E8ZhGxsbJRZsrrmkQkgbtbV1Vl9fT2nLmxubhacBkUkncHrD4Du7+87gRsbG7NTp069Tj34\/9OnT+38+fNuGrTUFCijRaZYHzx4cLASxURABERABI5EgPsp99Xr168fqXzYQpW2i1QAK9146ltbWzOmPRkJ8hcIo0zWBMkrFG7fvm1TU1N25cqVQtlKEwEREAERKJMA91Puq1evXi2zZHXNIxXAnZ0d29raynnMWh\/TobmENyeI2ptTa2xstJqaGh9968ho0deDHfbB8vkFyO\/o6LBz587lZykuAiIgAiJwBALcT7mvXrhw4Qilq1ckMgFkjY5NLYgTa3qs7bHGF3QdMWRtEBvSWSMkTjrxQqGzs9OeP39urBEyVcqUKaJYyDbxaXJABERABESgYgQiE0BaPDIyYtPT09bW1uZ2evb09JBs4+PjLhAZHBw01gZ5pIEjcdIPC2x4YRMMf30Q2GXq6z2sjNJFQAREQAREIFIBZBQ4Pz\/vHnFgQ4vHPzQ0ZATijPaYS+YxCI7ESfcBwWP0yNGnURZ7Auc+XUcRSBEBuSICIlBhApEKYIXbrupEQAREQARE4MgEJIBHRqeCIiACIhARAV3mRAhIAE8EqyoVAREQARGIOwEJYNx7SO0TAREQARE4EQIJEcAT8V2VioAIiIAIZJiABDDDnS\/XRUAERCDLBCSAWe79hPiuZoqACIjASRCQyXo\/swAAEABJREFUAJ4EVdUpAiIgAiIQewISwNh3kRooAlkmIN9F4OQISABPjq1qFgEREAERiDEBCWCMO0dNEwEREIEsEzhp3yWAJ01Y9YuACIiACMSSgAQwlt2iRomACIiACJw0AQngSRM+Tv0qKwIiIAIicGIEJIAnhlYVi4AIiIAIxJmABDDOvaO2ZZmAfBcBEThhAhLAEwas6kVABERABOJJIFIB3N7etu7ubmtubraBgQHb29t7iwpp5GGDLWWCRsQvXbpkq6urwWR3Pjw8bAQX0YcIiIAIJJWA2h0JgUgFcHR01Pr7+21lZcU5t7S05I7Bj8nJSWtoaLD19XVrb2+3mZmZXDaid\/HiRXv58mUuzZ\/Mzc0dsPXpOoqACIiACIhAIQKRCSAjt+XlZWtpabHa2lrr6uqy2dnZA21i9LewsOBsyOjt7TXipFP+\/v37dvfuXTtz5gzZuUDexMSEfe9738ul6UQEREAEREAEihGITABpRF1dndXX13PqwubmZsFp0JaWFpfPx8bGhu3v79vZs2dtbGzMTp06RfKBwMjygw8+sK9+9asH0gtFnjx5Yow8X716VShbaSIgAiIgAmUS4H7KfZX7dZlFq2oeqQCehKdMfVJvT08Ph5Lhzp07bv3xwYMHJW1lIAIiIAIiUJoA91P2bly\/fr20cYwsIhXAnZ0d29rayrnPWh\/TobmENydra2tvzswaGxutpqYmF88\/YRqVdUI2zTAS5LzYRpjbt2\/b1NSUXblyJb8qxWNCQM0QARFIFgHup9xXr169mqiGRyaATGGyqQVxY02PtT3W+IK0EEPWBrEhHXEjTjrxQoFpUTbMEEZGRuzy5ctuqrSQLWkIakdHh507d46oggiIgAiIwDEJcD\/lvnrhwoVj1hRt8cgEELcQqOnpaWtra3M7Pf205fj4uBGwGRwcNNYGGdFxJE66ggiIQBYIyEcRiI5ApALIKHB+ft494sDIzbs5NDRkBOKM9hhKM6LjSJx0H1pbW93OUI4+zR+pI1ivT9dRBERABERABPIJRCqA+RdXXAREQAREQAQ8gaiPEsCoiet6IiACIiACsSAgAYxFN6gRIiACIiACUROQAEZNvNj1lCcCIiACIhAZAQlgZKh1IREQAREQgTgRkADGqTfUliwTkO8iIAIRE5AARgxclxMBERABEYgHAQlgPPpBrRABEcgyAfleFQISwKpg10VFQAREQASqTUACWO0e0PVFQAREQASqQiAmAlgV33VRERABERCBDBOQAGa48+W6CIiACGSZgAQwy70fE9\/VDBEQARGoBgEJYDWo65oiIAIiIAJVJyABrHoXqAEikGUC8l0EqkdAAlg99rqyCIiACIhAFQlIAKsIX5cWAREQgSwTqLbvEsBq94CuLwIiIAIiUBUCkQrg9va2dXd3W3Nzsw0MDNje3t5bTpNGHjbYUiZoRPzSpUu2urrqkoljhz1hfHzcpetDBERABERABIoRiFQAR0dHrb+\/31ZWVlyblpaW3DH4MTk5aQ0NDba+vm7t7e02MzOTy0b0Ll68aC9fvsyl+Tqxf\/jwoX3++ec2NzeXy4\/1iRonAiIgAiJQNQKRCSAjteXlZWtpabHa2lrr6uqy2dnZA44z+ltYWHA2ZPT29hpx0il\/\/\/59u3v3rp05c4ZsF8bGxmxoaMidNzU12XvvvefO9SECIiACIiACxQhEJoA0oq6uzurr6zl1YXNzs+A0KCLpDF5\/bGxs2P7+vp09e9YQu1OnTr1OLfz\/ixcvbHd319ra2gobvE598uSJMfJ89erV65j+F4GqEdCFRSA1BLifcl\/lfp0kp8oWQEZirLkNDw\/Hyk\/a9cknn9jNmzedWB7WuDt37rj1xwcPHhxmonQREAEREIEyCHA\/Ze\/G9evXyyhVfdOyBZCR2Pz8vDE9yaYTwvnz53ObUoq5tLOzY1tbWzkT1vqYDs0lvDlZW1t7c2bW2NhoNTU1uXihE9YGP\/zwQ\/viiy+stbW1kEku7fbt2zY1NWVXrlzJpelEBERABCIlkLKLcT\/lvnr16tVEeVa2AHrvenp63EYVNp+wcWVwcNDt7kQQC21CQTjZ1IK4sabH2h4i6uvjiBiyNogNcdYIiZNOvFBA\/D777DObnp4uOvLzZRHUjo4OO3funE\/SUQREQARE4BgEuJ9yX71w4cIxaom+6JEEEAFjuIvYEW7dumWLi4tOEJkHnpiYMKYk890ZGRlxQsUaHaM\/RBQbHl0gcI6QsjZIvRyJk14o0A6u\/fjxY7fuRxlCIQEuVF5pIiACIiAC2SVQtgAibH19fblHFRgBMvT1ozRGesQ55mMljenT9fV1t6HF57OLk0CceiifXy95BKY4GT1yDNpi74MXVuwVREAEREAERKAQgbIFkEqYRmQ0x7kPCCOjQo4+TUcREAEREAERiCuB0AKIsLH7k3lepjk5Mt3oA3GcLLVhBRuFbBOQ9yIgAiIQBwKhBdBPX3rx4+inHP2RqUumJePgmNogAiIgAiIgAsUIhBZAXwlCiNBx9Gk6ioAIiEA4ArISgfgQCC2ATIGyxvdv\/\/ZvuRda++lPf2SKFLv4uKeWiIAIiIAIiEBhAqEFkBEfI7+\/+7u\/M7+T0099+iPp2BW+lFJFQAREQASyTCBuvocWwLg1XO0RAREQAREQgeMQCC2ATG0yxemnOwsdycfuOA066bL+Zdhs4ikUeKnrSbdB9YuACIiACFSfQGgBZGqTKU4\/3VnoSD521Xfr8Bb4l2Gznlko8DLXExPBw5ulHBEQAREQgYgJhBZARnYIRtI3wXzzOz+0zo9\/WjB8o+e7xghRAhjxt1CXEwEREIEqEAgtgIzs0rAJpuYr9fZOc1vh8PXDf0ewCn2jS6aLgLwRARGIGYHQAhizdqs5IiACIiACInAsAkcSQH6FgenQ4EYY4qQfqzUqLAIiIAJpJCCfYkmgbAFE5D766KMDvwbBhhh+3oh08mPpqRolAiIgAiIgAgECZQvg\/v6+K57\/axA+7vOdkT5EQAREQAREIKYEyhZANsPwK+1\/\/\/d\/n\/vRW3aIEied\/Ld9VUoxAuw6LfRMYn4adsXqUZ4IiIAIiEB4AqEFEJHjQXfW\/UZHR+33v\/+98RNIxDkSn56ezoli+Cak2xLRyhey\/DjPHrKGWipgR33pJhbOOzjkcywUxy5cjbISARHIGoHQAsjIjgfdWe87LJCPXRYgcmMtdMPNT0O0Sgkbzx4Wez6R5xaT\/Ixipb8PsA\/DFe7YYV\/pNqg+ERCB5BMILYAn6SobZ7hZMZpklMlos9D1xsfHDRvC3NzcARPKXLp0yVZXVw+kn0SEGyo3VtpcKpQSN4SNNhZ9PpHnFvWMIphcgH8prvqjwaHShwiIQBECRxLAoBAhRj4UE68ibbDJycncrtL29nabmZl5yxxhe\/TokTHCunfvnk1MTBjCiSF5Fy9etJcvXxI98VDODZjGFBW3FAgbPOiXUgE7eFQqFOWqPxoqhfmY9ai4CMSXQNkCyEgLIXr48KFdvnzZECOmRDnv7++3cqdAEbGFhQVraWlxlHp7e4046S7hzcfi4qKdPn3aampqrK2tzXZ3d+3FixduzfH+\/ft29+5dO3PmzBvraA66AZshamFHw9hhH03v6CoiIAIiUJxA2QJIdQhRfX29E63Z2VmSjMcgEC4E0iWU+eEFkGIbGxtW6HEKnjWsra3FxHZ2dmxra8sJ7tjYmJ06dcqll\/r48ncr9uX6iu3\/YauUaSzzmforNtKKWmC4Hm3SGmYsvy5qlAhEQoD7APcl7t3BC8b9vGwBZASGU0xTdnZ22r\/+67+6dTfiSXD++dwvbfHuj+zlbx\/jRuJCqV+z+F\/\/+\/+4UVmlHPNfbL7chYLvc42GK0Vc9YhA8gg8ePDA2A\/BLE+SWl+2ADIC+\/nPf+6mKRkF4vT7779vPBrx4x\/\/2I3IjgJgbW0tV6yxsdFNdeYS3pxsbm7m1v3q6uqM67\/JCn3wI5V3v3UxdJk4Gfr2s8kjP7Ch5v+t\/t9QAlhK2LzY8YWmjw8L5MeJj9oiAiIQPYErV64YP5Zw9epVS9J\/ZQsgzrHOh7Mch4aGjDVAQk9PD9llBQSVB+i9ADKlSpz0YEWMNln3Y2p0ZWXFrQc2NTUFTUKd+5EKx1AFjmN0AmVp93F\/zQLxQ7gOE7VgeqnpTUT3BNxUlSIgAgkicO7cOfdc+IULFyxJ\/x1JACvt4ODgoDG6YzcpR+Jcg92mBM5bW1utr6\/PQb527ZrduHHD8kUSOwVzv2noR3CFjogaodhoktGlF7dKiG6c+4U\/CApxyk\/DLs5+qG0iIALlETiSALJDk1ECguUDcdLLu\/yfrREyRpSMIjkSJ4fRJYFzAufYPHv2zBBE0nwgziYcjj7tqEfEIf\/mF4z7da+j1n\/S5UqtEzL6ow1Fhe2EHiMoxTbI+bDzSvJH1ODB97dUwI61jsPa5dOp08xArCACIhBjAmULICLHrz6wIxMx8oE46eTH2N9QTQsrIKEqq4JR2JFdFZpmpdiWEiHyEaJKtR2xQpTDMMOOa9OGYgEb6q1EG6nHC2uxI3aVuF6l66Bdxdrt87Cr9LVVnwiUIlC2ALIGR6U89sDRBx\/3+T49iccwN8M4+1WNkV1YHmHZFrPzU7Nhr4lw+Rtt\/tGPJsMyK9YuP23M9Urd0MnPb0uhOGJaTGx9HnalRqdcMyyzSthxPdrl21jsiB32lbhuLOpQIxJBoGwBZOMLm1T49Qf\/zB9H4qSTnwjPizQy7M2wSBXKOoRAWLZF7cp8e06xUSc33kOaWjC5aLsC08aIYCFB82lct5gg+DzqCSu6peokv5RI0r5KCRH1lNN+7AtCV6IInBCB0AKIyPGqM9b8eOSBX3\/gVyCIcySuX4M4oV5StcciUExAyh1Nhm1IMdFF3MIKA9cLK7ql\/OSaiCDXLxawqaQYhW0\/viqIQJQEQgsgI7v5+fncIw9+7S94JB87syhd0LVEoDiBojfgMkeTxa\/0l9xSYoRl0XYFRpPYhglF63vjZ7F2BadwS40UKymQYXyTjQicBIHQAhi8OBtd+AuS0Z8PxEkP2ulcBLJKIIwYVYNN0XYFRLfUCJY3DpUSSb++Wg0\/dU0RCEOgbAFE5Njtya7P4OiPOOnkh7mwbNJLQJ4ln0CxkSLTxrxxiKlS\/vA9LJBfDgmmaFmDPCxo1FkOTdmGIVC2APpdnn7Xp7+Ij\/t8n66jCIhA8ggUHSmWMZ1ajuelRp0IqkSwHKKyLUWgbAFkjY\/RHr+\/x+\/wcQGOxEknnzQFERCBdBMoLJJtlntV3xuhDEuh1KiTEWKpaVdGj9UQSa7JtYsFbMKykF00BMoWQJrFzw\/94z\/+o\/ESbNYAORInnXwFERABESiXQFFBfSOmpUaJTMdGPVJE2FgT5drFAjbYlstF9idH4EgCSHP8a8n8OiBx0hVEQARE4KQIFBslBnexRik0XIs10WJt8+um2J4Um5uoWVwAABAASURBVDjUm7Q2HFkAk+ao2isCIpB8AkVHiYFdrNXwtGjb3oxgq9EuXfNwAmULIA\/EM8zneHi1yhEBERCB6hFgvTCO63Gl2kWbNUqM7ntTtgCyyYXNLvwCfHTNTMiV1EwREIFYECi1Vlit9bhS7WJwEfUaZiw6rEqNKFsAGfktLy8br0NjA0ww8Ko08qvkiy4rAiIgAo5AXNfjirWrWmuYDlhGP8oWQEaAvPLMb34JHkknP6Ms5Xa2Ccj7GBGI63pc0XZVeQ0zRt0XWVPKFsDIWqYLiYAIiIAIxIYAa5OsURYLSXv9XVkCyAPv58+fNz\/tOTc3F5vOUUNEQAREoNIEQt\/0K3zhuG2WgQNrk6xRFgvYVBjFiVYXWgB5x+etW7fs008\/db8I8fDhQ2NBt5w1P2xZJ0RAgUid+d6RRh422FLG24yPjxcU3+Hh4Vw6Nt5eRxEQARE4KoFq3vS5t3IfLBYQG9pYzD\/yi43YwuYhyIQwa5jF2hO3vNAC6N\/x2dbW5nxoamoydoNubW25eJgPNs709\/fbysqKMwe+Owl8TE5OunpZW2xvbze\/25TR56NHj4wy9+7ds4mJCUMsGYWyKYd0RHlqasqwDVSpUxEQAREomwDiUa2bfhihoW2lXg2HSBYT0bB51APAtK1hhhZAnM8Pu7u79mcBzM95O85IDqFqaWmx2tpa6+rqstnZ2QOGCNrCwoJhQ0Zvb68RJ31xcdFOnz5tNTU1hghz7RcvXlh9fb3V1dVh7sKZM2dcmovoQwREQASOSaAaN\/2w1yw1UkQkw4gpiIrZ8SYbbNIWjiWA5cJAqBAsX25zc9ON4nzcH70AEmdR1Y8+GXEinqTv7Ow48W1tbbWbN28aL+NminZ6etqK7UT98ncr9uX6iu3\/IfzIlespiIAIiEDcCIQRrbBiWtSuxJtsuJ8m8b5algAiRh0dHW69jVEY0478BiDrdYT8Nbsoviys+SF8jBBv3Lhh3\/72t4tOgT6f+6Ut3v2Rvfzt4yial4lryEkREIHqEDiOaFWyxdxPua8+\/dXPKlntidcVWgAZVfGcH2tzhwXysTus1X7U5vODIzqfxnFtbY2DC42NjW7ak0hwxOhHk9gyncrIkHXJc+fOGWKIfaHg\/2J691sXC2UrTQREQAREoEwC3E\/9g\/xlFq2qeWgBPG4rEUY2tSBYrOmxtscaX7BeRAwxw4Z01giJk97Z2Wms+zEdyiYa1gMRPKZLqYs6yWOUShrlCwX\/FxPHQvlKEwERKIdAcm1ZH2MW67DAvSS53kXbcu6n7ncgS0yVRtuq0leLTABpysjIiLFGx\/Qpo7+enh6SjWlMApHBwUFjpMeUKkfipLPW19fXZ0zBXrt2zZjuRBiHhobcrlHqJI9dpr5eyimIgAiIQCECpTaQ+J2PhcoqLR0EIhVARoFMkzKFGvzxXESMAFJEjUcZsOFInHQCNqQ\/e\/bMEETSCNRFOgEb0hREQAREoBgBvxzC1F2hkNadj8WYlJuXdPtIBTDpsNR+ERCB9BDITdvxDs5CIWHTeenpmeg8kQBGx1pXEgEREAERiBEBCeBxOkNlRUAEREAEEktAApjYrlPDRUAEREAEjkNAAngceiqbZQLyXQREIOEEJIAJ70A1XwREQARE4GgEJIBH46ZSIiACWSYg31NBQAKYim6UEyIgAiIgAuUSkACWS0z2IiACIiACqSBwRAFMhe9yQgREQAREIMMEJIAZ7ny5LgIiIAJZJiABzHLvH9F3FRMBERCBNBCQAKahF+WDCIiACIhA2QQkgGUjUwERyDIB+S4C6SEgAUxPX8oTERABERCBMghIAMuAJVMREAERyDKBtPkuAUxbj8ofERABERCBUAQkgKEwyUgEREAERCBtBCIVwO3tbevu7rbm5mYbGBiwvb29t3iSRh422FLGG42Pj7uy5M3Nzflk45w0wvDwcC694ieqUAREQAREIDUEIhXA0dFR6+\/vt5WVFQdwaWnJHYMfk5OT1tDQYOvr69be3m4zMzMue3V11R49emSUuXfvnk1MTDgBJf3OnTsunXp3d3eNNFdIHyIgAiIgAiJwCIHIBJCR3PLysrW0tFhtba11dXXZ7OzsgWYx+ltYWHA2ZPT29hpx0hcXF+306dNWU1NjbW1thtC9ePHCSO\/r67OzZ8+6eu\/evWutra0UVxCBShJQXSIgAikjEJkAwq2urs7q6+s5dWFzc9ON4lwk8IFI+ujGxobt7++7KCNDxJPIzs6ObW1tcWpPnz618+fPu+nRUlOgX\/5uxb5cX7H9P\/y5rKtAHyIgAiIgAkcmwP00iffVSAXwyHSLFFxbW3OjQUaCTI8yymRN8LAiz+d+aYt3f2Qvf\/v4MBOli4AIiMBBAooVJcD9lPvq01\/9rKhd3DIjFcDgqA0QwREdcR8QNX\/e2Njopj2JB0eMfjTJaNHXw\/Qo9sHylAuGb37nh9b58U\/t3W9dDCbrXAREQARE4IgEuJ9yX\/1Gz3ePWEN1ikUmgKzRsakFcWJNj7U91viCbjO9ydogNqSzRkic9M7OTjfSYzqUzS6sBzY1NRnpz58\/N9YYyWPKFFGkfKFQ85V6e6e5zTgWyleaCIiACIhAeQS4n3JffefrbeUVrLJ1SAGsTCtHRkZsenrabWJh1NbT0+Mq5vEGApHBwUFjpMcjDRyJk87GFja7dHR02LVr1+zGjRtu00swnTx2mfp6KacgAiIgAiIgAoUIRCqAjALn5+fdIw5jY2O59gwNDRmBBEZ7U1NTzoYjcdIJ2PB4xLNnzw7s9PTp5HGOrYIIiIAIiIAIFCMQqQAWa4jy4ktALRMBERCBNBKQAKaxV+WTCIiACIhASQISwJKIZCACWSYg30UgvQQkgOntW3kmAiIgAiJQhIAEsAgcZYmACIhAlgmk3XcJYNp7WP6JgAiIgAgUJCABLIhFiSIgAiIgAmknIAEs1sPKEwEREAERSC0BCWBqu1aOiYAIiIAIFCMgASxGR3lZJiDfRUAEUk5AApjyDpZ7IiACIiAChQlIAAtzUaoIiECWCcj3TBCQAGaim+WkCIiACIhAPgEJYD4RxUVABERABDJB4BABzITvclIEREAERCDDBCSAGe58uS4CIiACWSYgAcxy7x\/iu5JFQAREIAsEJIBZ6GX5KAIiIAIi8BaBSAVwe3vburu7rbm52QYGBmxvb++tBpFGHjbYUsYbjY+Pu7Lkzc3N+eTccXh42Ai5BJ2IgAiUSUDmIpAdApEK4OjoqPX399vKyoojvLS05I7Bj8nJSWtoaLD19XVrb2+3mZkZl726umqPHj0yyty7d88mJiYOCCiC6G1dAX2IgAiIgAiIQBECkQkgI7nl5WVraWmx2tpa6+rqstnZ2QNNY\/S3sLDgbMjo7e014qQvLi7a6dOnraamxtra2mx3d9devHiBmVE3gvi9733PxfUhAiIgAiJQPoGslYhMAAFbV1dn9fX1nLqwubl5YBTnEl9\/IJKvD+7\/jY0N29\/fd+eMDBFPIjs7O7a1tcWpMbL84IMP7Ktf\/aqLF\/v48ncr9uX6iu3\/4c9li9kqTwREQAREoDQB7qdJvK9GKoClMZZvwdQnpXp6ejiUDM\/nfmmLd39kL3\/7uKStDERABERABEoT4H7KffXpr35W2jhGFpEKYHDUBoPgiI64D2tra\/7UGhsb3bQnCcERox9NMo3K2h8bYxgJcl5sI8w3v\/ND6\/z4p\/buty5S5cGgmAiIgAiIQNkEuJ9yX\/1Gz3fLLlvNApEJ4NmzZ92mFsSNNT3W9ljjCzrP9CZrg9iQjrgRJ72zs9Ot+zEdyiYa1gObmppsbGzMbZhh08zIyIhdvnzZpVG+UKj5Sr2909xmHAvlK00EREAERKA8AtxPua++8\/W28gpW2ToyAcRPBGp6etptYmH056ctebyBgM3g4KAx0mNEx5E46a2trdbX12cdHR127do1u3HjhttMQ56CCFSAgKoQARHIGIFIBZBR4Pz8vBuxMXLzrIeGhoxAnNHe1NSUs+FInHQCNoz0nj17ZggiacFAfrDeYJ7ORUAEREAERCBIIFIBDF5Y5yIgAiIQGwJqSCYJSAAz2e1yWgREQAREQAKo74AIiIAIiEAmCbwRwEz6LqdFQAREQAQyTEACmOHOl+siIAIikGUCEsAs9\/4b33UQAREQgSwSkABmsdflswiIgAiIgEkA9SUQgUwTkPMikF0CEsDs9r08FwEREIFME5AAZrr75bwIiECWCWTddwlg1r8B8l8EREAEMkpAApjRjpfbIiACIpB1AtkWwKz3vvwXAREQgQwTkABmuPPlugiIgAhkmYAEMMu9n23f5b0IiEDGCUgAM\/4FkPsiIAIikFUCEsCs9rz8FoEsE5DvIvCagATwNQT9LwIiIAIikD0CkQrg9va2dXd3W3Nzsw0MDNje3t5bxEkjDxtsKeONxsfHXVny5ubmXDL52JFGwMZl6EMEREAEREAE3iaQS4lUAEdHR62\/v99WVlZcA5aWltwx+DE5OWkNDQ22vr5u7e3tNjMz47JXV1ft0aNHRpl79+7ZxMSEE1BfJ\/YPHz60zz\/\/3Lw4uoL6EAEREAEREIECBCITQEZqy8vL1tLSYrW1tdbV1WWzs7MHmsTob2FhwdmQ0dvba8RJX1xctNOnT1tNTY21tbXZ7u6uvXjxwsbGxmxoaAhza2pqsvfee8+d60MEREAEREAEihGITABpRF1dndXX13PqwubmphvFuUjgA5H00Y2NDdvf33dRRoaIJ5GdnR3b2triNBcQRIQRgcwl5p18+bsV+3J9xfb\/cLBsnlmqo3JOBERABCpJgPtpEu+rkQpgJYHn18UI85NPPrGbN2\/a2bNn87Nz8edzv7TFuz+yl799nEvTiQiIgAiIwNEJcD\/lvvr0Vz87eiVVKBmpAOaP2oIjuqDva2truWhjY6Ob9iQhOGIMjiZZH\/zwww\/tiy++sNbWVkwPDd\/8zg+t8+Of2rvfuniojTJEIL0E5JkIVJ4A91Puq9\/o+W7lKz\/BGiMTQEZlbGpB3FjTY22PNb6gb0xvsjaIDemsERInvbOz0637MR3KJhrWA1nzQ\/w+++wzm56eLjryoz5CzVfq7Z3mNuNIXEEEREAEROB4BLifcl995+ttx6so4tKRCSB+jYyMOKFijY7RX09PD8nGowsEIoODg8ZIj0caOBInnZFdX1+fdXR02LVr1+zGjRsk261bt+zx48duYwxlCNoF6tDoQwREQAQOEFDkIIFIBZBR4Pz8vHvEgd2bvins4iQQZ7Q3NTXlbDgSJ52ADY87PHv2zE11kocNacHghZUyCiIgAiIgAiJQiECkAlioAUoTAREQAREQgWoQyJYAVoOwrikCIiACIhBLAhLAWHaLGiUCIiACInDSBCSAJ01Y9ceFgNohAiIgAgcISAAP4FBEBERABEQgKwQkgFnpafkpAlkmIN9FoAABCWABKEoSAREQARFIPwFVd0GiAAAIu0lEQVQJYPr7WB6KgAiIQJYJHOq7BPBQNMoQAREQARFIMwEJYJp7V76JgAiIgAgcSkACeCia9GTIExEQAREQgbcJSADfZqIUERABERCBDBCQAGagk+VilgnIdxEQgcMISAAPI6N0ERABERCBVBOQAKa6e+WcCIhAlgnI9+IEJIDF+ShXBERABEQgpQQkgCntWLklAiIgAiJQnEC6BbC478oVAREQARHIMIFUCOD4+Lg1Nze7MDc3l+HulOsiIAIiIAJhCSReAFdXV+3Ro0e2tLRk9+7ds4mJCdvb2wvrv+zSS0CeiYAIiEBRAokXwMXFRTt9+rTV1NRYW1ub7e7u2osXL4o6rUwREAEREAERSLwA0oUNDQ1WW1vLqe3s7NjW1pY7L\/Tx5e9W7Mv1wmH\/D38uV8yGspW0i2tdYf2sZPurcc2kt1\/MDv5bzvVniv+dJ6HPC91745iWCgEMA\/bcuXN24cIFez73S1u8+6OC4emvfuaqKmZD2UraxbWusH5Wsv3VuGbS2y9mB\/8th+nPMDZhuYa1S\/o1y2k\/91nut+5mGvOPVAjg5uZmbt2vrq7O6uvr38JOh9y+fdumpqYUxEDfAX0H9B04oe8A91nut2\/dhKNLCH2lxAtgZ2enW\/fb39+3lZUVtx7Y1NRUEACd0tHRYQpioO+AvgP6DpzMd4D7bMEbcAwTEy+Ara2t1tfX50Tt2rVrduPGjdx6YAx5q0kiIAIiIAIxIZB4AYTj0NCQra+v27NnzwxBJC3LQb6LgAiIgAiUJpAKASztpixEQAREQARE4CABCeBBHoqJQMIJqPkiIAJhCUgAw5KSnQiIgAiIQKoIZEIAeT+of1co7w1NQw9ub29bd3e3e\/\/pwMBA7jGQoG+8Ju78+fPOBv+Hh4eD2Yk+53V3+E3fJtqRQOP5bh7WR2nsS9+HfDcJh\/keQJSIU\/oRfwj8G+Xfan7DT6o\/868TdZw+xG8CHKK+frnXS70A8uW7c+eOPXz40AXeG0pauaDiZj86Omr9\/f3u0Q\/axrtQOQYDb8R57733nA2bhMbGxoLZiT2n\/9j5W8jnpDrFjYM+Paz9aezLyclJ4y1OfDfpy+XlZUvCTfOwPiIdYeMegz\/41d7ebj\/4wQ\/e+gM1jf3JH6M8k83jaNxveeYaHnCJa0i9ANIZvB6Nh+N5PpD3hpIW1w4J0y4EgJtFS0uLe+Sjq6vLZmdn3yq6trbmbjD+NXFvGSQwgVEDQvGLX\/zCvva1ryXQg7ebzE2\/t7fXLl++\/Hbmm5Q09uXQ0JD5P8rOnj1riMUbdxN7YBf6b37zG8MfnKBfOeaHNPZnT0+Pe7mAv9+cOXOm4EtJ8llUM54uATyEZGNjo3tZts\/my+fPk3rMf+MNf3khDt4fzhcWFmxmZsZNgTIVGve\/xnzbix35x8VN099gitkmJQ8h4OZxWHvT2pdBf\/mj7vnz58aLLYLpST\/nD1P+QOV7631Je38ym\/H++++757Pj\/u80EwLov3hZOvIPjikIpmEIn376qX3\/+983bjRZ4pAGX9PelwgC04RXr15N1XO8jOz5\/vEHDkcf0t6f\/IHKLBt\/gHsG3ve4HTMhgBsbG8ar0jx8pg79eVKPTOuyjuDbz1oK\/7B8PP\/IFPCf\/vSnor+UkV8mYfHMNDdNfckfZKxl8wanYqPgpHUuoyDajBhwLBbS1J\/eT+5F3JPiPtuWegHkNwKZLkQs+J1Afi+QNN9RSTwyrcB6CV8u\/nrmL638tQbSP\/74Y\/PTnvxuIu\/oYx00iT5nuc1p7UvEj5HfF198kaqRH+LHv8f8kZ\/\/Dqe1P9kEg+\/4Sd+yTwEOxOMaUi+AiAVTK8xJEzgnLa4dErZdIyMjNj097X4EmL+0\/F\/PTDkQ+AuMKc\/BwUG3Bvj555\/rPalh4cbEjn4kpLUv2czEbkleSs22eQL+Hgl\/TAohAqy7f\/TRR+7fHT7xuA6ih2+EtPanvwfhM33KyN6nxaR73mpG6gUQj+kE1sEInJOW9ICIz8\/Pu3egBqdZ+KuTgH\/sSOP9qPjNkTjpaQje\/7T0J31CPxI4J9CPBM7pO\/owTX2Jr\/gTDN5ffE5i4PsY9Idz1uIRPXwj4Fca+xO\/gn3qfSU9riETAhhX+GqXCIiACIjAsQkcuQIJ4JHRqaAIiIAIiECSCUgAk9x7arsIiIAIiMCRCUgAj4wuPgXVEhEQAREQgfIJSADLZ6YSIlA2AXYBshuQHXL5gXTeH8kRu7IrVwEREIEjEZAAHgmbColAeQTYBchuQHYF8qJgnsnkSJx0Xu7NEbvyapa1CIjAUQlIAI9KTuVEoIIEeH7MjwB5mPgnP\/lJ7ueuiPP8GCPH\/He6kkc6AZsKNklViUDqCUgAU9\/FcjCJBP7lX\/7Ffv3rX7uf8Hr8+LHx1h9GixcvXrT79+87lxA8XoLOexcZTfKyA4TUZeojEwTk5PEISACPx0+lReBECPCqOx725z2R7777rv3DP\/yDu45\/jy1rhbwCz\/\/SAA9WI44IpTPUhwiIQEkCEsCSiGQgAtET8EJX6sq8TozpTwKv4JIAliKmfBH4C4FkC+Bf\/NCZCGSSwL1799zr8JgeJfAqqkyCkNMicAQCEsAjQFMREag2AXaLMv05MTFhTIfy9v3u7m5jXbDabdP1RSApBCSASekptTOfQObjvGyYXwLh5714+z7rhqRlHowAiEBIAhLAkKBkJgKVIsCGFTawcPR18isC\/jlApjG9kLER5je\/+U3u9\/JIJ9+X45ypTwLnPl1HERCB0gQkgKUZyUIERCBuBNQeEagAAQlgBSCqChEQAREQgeQRkAAmr8\/UYhEQARHIMoGK+S4BrBhKVSQCIiACIpAkAhLAJPWW2ioCIiACIlAxAhLAiqGMriJdSQREQARE4PgEJIDHZ6gaREAEREAEEkhAApjATlOTs0xAvouACFSKgASwUiRVjwiIgAiIQKIISAAT1V1qrAiIQJYJyPfKEvj\/AAAA\/\/\/aIow8AAAABklEQVQDAIe0N4B5BJA0AAAAAElFTkSuQmCC","height":0,"width":0}}
%---
%[output:3be219bb]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:7f4453af]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3eb42ba4]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:18d5376d]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) < 10 percent","truncated":false}}
%---
%[output:3d5b141c]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:70a80eb6]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:5069fa2f]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:516eb98d]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:82e84a63]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:89b9413e]
%   data: {"dataType":"text","outputData":{"text":"The minimum number of servers recommended to meet the goal is s = 7.","truncated":false}}
%---
%[output:01719c83]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:180b3b7d]
%   data: {"dataType":"text","outputData":{"text":"When s = 7, P( W_q > 5 minutes) = 0.087512","truncated":false}}
%---
%[output:9d3b0304]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  1.3537  minutes.","truncated":false}}
%---
%[output:228897f5]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:8d7cedd8]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  6629","truncated":false}}
%---
%[output:638fe84b]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  75750","truncated":false}}
%---
%[output:72d6fd2e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3192541a]
%   data: {"dataType":"text","outputData":{"text":"W                  7.8556             7.6821             2.2092            \n","truncated":false}}
%---
%[output:2bc26e38]
%   data: {"dataType":"text","outputData":{"text":"Wq                 1.3537             1.2579             7.0743            \n","truncated":false}}
%---
%[output:6ff374f7]
%   data: {"dataType":"text","outputData":{"text":"L                  6.2845             6.1115             2.7524            \n","truncated":false}}
%---
%[output:4f5bf76b]
%   data: {"dataType":"text","outputData":{"text":"Lq                 1.0829             1.0053             7.1728            \n","truncated":false}}
%---
%[output:95c2eed1]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:3753138b]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:9f4f8e90]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:6d3bff00]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 7                         **","truncated":false}}
%---
%[output:22061dd9]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:8800e3f9]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:8c0b332d]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:322af45d]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:62d31f09]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3410d47e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:9989961c]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 1.257923\n","truncated":false}}
%---
%[output:792832f2]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 1.005271\n","truncated":false}}
%---
%[output:6c18579e]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 7.682093\n","truncated":false}}
%---
%[output:8491a73a]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 6.111535\n","truncated":false}}
%---
%[output:02e11338]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:1b9a6429]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 5.449680\n","truncated":false}}
%---
%[output:9ea42615]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 6.850801\n","truncated":false}}
%---
%[output:68a46f42]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 0.330180\n","truncated":false}}
%---
%[output:8372b3f2]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 0.415555\n","truncated":false}}
%---
%[output:2ea1ecee]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:26503bb5]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3c766584]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:4e8abf7e]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:3e06d1cd]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:1694e765]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:5f28097b]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 8                         **","truncated":false}}
%---
%[output:7d654a85]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:2bf85785]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:3f3104c1]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:299de24f]
%   data: {"dataType":"text","outputData":{"text":"Lq                 0.3690             0.3302             10.5321           \n","truncated":false}}
%---
%[output:29e65669]
%   data: {"dataType":"text","outputData":{"text":"L                  5.5706             5.4497             2.1708            \n","truncated":false}}
%---
%[output:0742ccf2]
%   data: {"dataType":"text","outputData":{"text":"Wq                 0.4613             0.4156             9.9184            \n","truncated":false}}
%---
%[output:337410ae]
%   data: {"dataType":"text","outputData":{"text":"W                  6.9633             6.8508             1.6150            \n","truncated":false}}
%---
%[output:3036df99]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:77c2cf61]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  75875","truncated":false}}
%---
%[output:33063950]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  1485","truncated":false}}
%---
%[output:5ba4e189]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:6982ddf2]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  0.46131  minutes.","truncated":false}}
%---
%[output:56f75ea0]
%   data: {"dataType":"text","outputData":{"text":"When s = 8, P( W_q > 5 minutes) = 0.019572","truncated":false}}
%---
%[output:21155a46]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:2b460479]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) < 10 percent","truncated":false}}
%---
%[output:3cb8d803]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:87fc373e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:566a9f7f]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:5899fe8b]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:0cfe22b6]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
