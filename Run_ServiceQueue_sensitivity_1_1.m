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
%[text] mu = 1/8 = 0.125
mu = 0.125;         % this is the updated value
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
%[text] 5\*mu = 5(0.125) =  0.625 \< .8 = lambda   --     not a stable system 
%[text] 6\* mu = 6(0.125)  = 0.75 \< .8 = lambda   --     not a stable system 
%[text] 7\* mu = 7(0.125)  = 0.875  \> .8 = lambda    --   system is stable
%[text] This is why we will iterate our loop for k = 7:8.       
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
%[text] n: total number of customers in the system
%[text] The n values are calucated based upon the k values. 
%[text] n \< k : There are empty registers. Each new customer goes straight to a cashier.
%[text] n \\geq k : All registers are full. Any new customer must wait.
%[text] k = 6 , 7, 8
%[text] n = 0, 1, 2, 3, 4, 5, 6
%[text] set up keeps us in the n \< k state as much as possible with the only concern when 6 = n \\geq k = 6 
%[text] This is why  n = 1:6.  
%[text] 



for k = 7:9 %[output:group:48e37f5c]
    P = zeros(1, k-1);    % initiaizes the row vector the first time
    % clears row vector so I can use this again for the next graph
    % thereafter

     fprintf("***********************************************************************");    %[output:31bfa214] %[output:540ea648] %[output:658005a4]
     fprintf("**                                                                   **"); %[output:3d43f3e4] %[output:9d407ce6] %[output:526fd79e]
     fprintf("**          Theoretical Calculations for P_n, L_q, W_q, L, W         **"); %[output:8d826c7f] %[output:90251beb] %[output:2b6f5ced]
     fprintf("**                      " + "number of servers k = " + k+ "                      **"); %[output:3ab88b59] %[output:56d0cd0c] %[output:65be948d]
     fprintf("**                                                                   **"); %[output:6c3cb95a] %[output:68bd8d06] %[output:5343d375]
     fprintf("***********************************************************************");  %[output:0208606c] %[output:61a06fa8] %[output:53504477]


    disp(" ");  %[output:092bb1de] %[output:40abf12a] %[output:574b422e]

    %fprintf("The current number of servers in the theoretical calculations is\nk = %d", k);
    

j = 0:(k-1);
terms = ((lambda / mu).^j) ./ factorial(j);
first = sum(terms);
second = (1 / factorial(k)) * (lambda / mu).^k * (1 / (1 - lambda / (k * mu)));
P0 = 1/(first + second);
fprintf("P(0) = %f\n", P0); %[output:08dcd782] %[output:58f01074] %[output:34a4b202]
P(1) = P0;


%%%  FIND A WAY TO SAVE ALL THE P(Wq??? > 5) \leq .1   info and just print
%%%  that here ***************

nMax = k-1; 
    fprintf("The probability that some cashiers are busy but there is no line:"); %[output:38e370e9] %[output:174e5020] %[output:96438f20]
for n = 1:nMax    
    
        
        if  n < k             % 1 <= n <= k 
            
            P(n+1) = (1./ factorial(n))*((lambda / mu).^n)*(P0);   
            fprintf("P(%d) = %f\n", n, P(n+1)); %[output:26dc05ae] %[output:0a41432b] %[output:9adb8ea0]
 
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
      fprintf("The number of customers waiting, L_q(%d): %f\n", n,   Lq); %[output:5ec71185] %[output:67bd04c5] %[output:0824aa85]
      L = Lq + (lambda./mu);                          
      fprintf("The expected number of customers in the system, L(%d): %f\n", n,  L);                 %[output:61077729] %[output:3ee79fad] %[output:91f61cc8]
      Wq = (Lq./ lambda);                           
      fprintf("The expected time customers wait before beginning service, W_q(%d): %f\n", n,  Wq);    %[output:5457eb56] %[output:3c2a672c] %[output:25caef97]
      W = (L./ lambda);                           
      fprintf("The  expected time customers spend in the system, including waiting time and service time, W(%d): %f\n", n,  W);  %[output:465f5cfd] %[output:4907bdea] %[output:327fc453]
              



    disp(" ");  % this is also needed for aesthetic reasons  %[output:0e3bdf93] %[output:177eb492] %[output:88fc6caf]
    disp(" "); %[output:4cae4bdc] %[output:296a2d37] %[output:3d93432d]



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


     fprintf("***********************************************************************");    %[output:084d163a] %[output:2f35a4ab] %[output:4ccfe7fa]
     fprintf("**                                                                   **"); %[output:6022f168] %[output:5128a18f] %[output:3669c3ec]
     fprintf("**          Simulation Calculations for P_n, L_q, W_q, L, W          **"); %[output:6808d418] %[output:786fd82e] %[output:595a10b9]
     fprintf("**                      " + "number of servers k = " + k+ "                      **"); %[output:7c83bc05] %[output:79f4cde9] %[output:4b9cf28a]
     fprintf("**                                                                   **"); %[output:87220a74] %[output:00bef058] %[output:5586be8d]
     fprintf("***********************************************************************");       %[output:747a079e] %[output:0a250611] %[output:5373c7d5]

    disp("");
for SampleNum = 1:NumSamples
    fprintf("Working on sample %d\n", SampleNum); %[output:75cee2ce] %[output:41cf0279] %[output:7da58f2d]
    q = ServiceQueue( ...
        ArrivalRate=lambda, ...
        DepartureRate=mu, ...
        NumServers=s, ...
        LogInterval=LogInterval);
    q.schedule_event(Arrival(random(q.InterArrivalDist), Customer(1)));
    run_until(q, MaxTime);
    QSamples{SampleNum} = q;
end


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
fprintf("Mean number in system: %f\n", meanNumInSystem); %[output:464c171e] %[output:19207363] %[output:8c0edd1b]
%[text] Make a figure with one set of axes.
fig = figure(); %[output:53789e1b] %[output:6e760152] %[output:36a2bd75]
t = tiledlayout(fig,1,1); %[output:53789e1b] %[output:6e760152] %[output:36a2bd75]
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
    fprintf("These are the y axis P values:"); %[output:050e607f] %[output:65907eba] %[output:8c8dfa1a]
    disp(P); %[output:4a0cd27c] %[output:75b48299] %[output:5f33ccea]
    %fprintf("This is PP:");
    %disp(PP);

plot(ax, 0:nMax, P, 'o', MarkerEdgeColor='k', MarkerFaceColor='r'); %[output:53789e1b] %[output:6e760152] %[output:36a2bd75]
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
exportgraphics(fig, PictureFolder + filesep + "Number in system histogram.svg");
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
fprintf("Mean time in system: %f\n", meanTimeInSystem); %[output:4089801b] %[output:393fb58c] %[output:6db784cd]
%[text] Make a figure with one set of axes.
fig = figure(); %[output:3f38bdcd] %[output:26ea03f6] %[output:148462d7]
t = tiledlayout(fig,1,1); %[output:3f38bdcd] %[output:26ea03f6] %[output:148462d7]
ax = nexttile(t);
%[text] This time, the data is a list of real numbers, not integers.  The option `BinWidth=...` means to use bins of a particular width, and choose the left-most and right-most edges automatically.  Instead, you could specify the left-most and right-most edges explicitly.  For instance, using `BinEdges=0:0.5:60` means to use bins $(0, 0.5), (0.5, 1.0), \\dots$
h = histogram(ax, TimeInSystem, Normalization="probability", BinWidth=5/60);
%[text] Add titles and labels and such.
title(ax, "Time in the system when s = "+ s);
xlabel(ax, "Time");
ylabel(ax, "Probability");
%[text] Set ranges on the axes.
ylim(ax, [0, 0.02]);            % *********changed this from .2 to .02
xlim(ax, [0, 3.0]);             % *********changed this from 2 to 3
%[text] Wait for MATLAB to catch up.
pause(2);
%[text] Save the picture.
exportgraphics(fig, PictureFolder + filesep + "Time in system histogram.pdf");
exportgraphics(fig, PictureFolder + filesep + "Time in system histogram.svg");
%%





disp(" "); %[output:39e2dd8f] %[output:0c37f300] %[output:2f798257]
fprintf("Here are the averages of the following values."); %[output:8e3d7da3] %[output:47f423eb] %[output:421981d7]
%fprintf("The current number of servers in the simulation calculations is\ns = %d", s);
fprintf("Number of Customers in system (L): %f\n", mean(NumInSystem)); %[output:8740f9d2] %[output:6d817a68] %[output:6cccf0e5]
fprintf("Total time customer spends in system (W): %f\n", mean(TimeInSystem)); %[output:6e39ce5e] %[output:6782c6c8] %[output:5e01c543]
fprintf("Number of customers waiting (L_q): %f\n", mean(NumWaiting)); %[output:16d8437a] %[output:15015bec] %[output:9d00e040]
fprintf("Customer Wait time before service (W_q): %f\n", meanWaitTime); %[output:6ff66c2b] %[output:37f65767] %[output:0b4dcbaa]




disp(" "); %[output:4efb0270] %[output:4270d036] %[output:16aab4d4]
disp(" "); %[output:6eb7e90a] %[output:978ccb9e] %[output:50734d55]
disp(" "); %[output:9ac4c272] %[output:8d6c073d] %[output:818f2c6b]

     fprintf("*****************************************************************************");    %[output:24385668] %[output:77ea5803] %[output:986a1ce4]
     fprintf("**                                                                         **"); %[output:6575b3b8] %[output:58308d16] %[output:7147d8dc]
     fprintf("**            Comparing Theoretical and Simulation Calculations            **"); %[output:3b7ce2e0] %[output:7a2c4c81] %[output:45e8d4f8]
     fprintf("**                         " + "number of servers k = " + k+ "                         **"); %[output:681d7f07] %[output:09b2f5f6] %[output:2ede3732]
     fprintf("**                                                                         **"); %[output:9594d438] %[output:97b5f683] %[output:8896f7bf]
     fprintf("*****************************************************************************"); %[output:0f39eca7] %[output:9cf4f947] %[output:79755abf]

Error_1 = (abs(Lq - mean(NumWaiting))./Lq)*100;
Error_2 = (abs(L - mean(NumInSystem))./L)*100;
Error_3 = (abs(Wq - mean(ExpectedWaitingTime))./Wq)*100;
Error_4 = (abs(W - mean(TimeInSystem))./W)*100;


% Header with fixed spacing
fprintf('%-18s %-18s %-18s %-18s\n', 'Value Type', 'Theoretical', 'Simulation', 'Error Percent'); %[output:30f33817] %[output:49e17bf4] %[output:264c4b8a]

% Data rows using fixed-width floats
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'Lq', Lq, mean(NumWaiting), Error_1); %[output:6606f665] %[output:87c507b2] %[output:369e5b5a]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'L', L, mean(NumInSystem), Error_2); %[output:8e39f1be] %[output:0a05ed13] %[output:3bd87fe8]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'Wq', Wq, mean(ExpectedWaitingTime), Error_3); %[output:627dde3d] %[output:10cc0b66] %[output:26b62cf9]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'W', W, mean(TimeInSystem), Error_4); %[output:9713f82d] %[output:2f9b5bd8] %[output:7ced1923]



%fprintf("Customer Wait time before service (W_q) matrix printed out: ");
%fprintf("(W_q): %f\n ", ExpectedWaitingTime);

longWaits = ExpectedWaitingTime(ExpectedWaitingTime > 5);
disp(" ");    %[output:23a09383] %[output:7aeb7c10] %[output:7139d483]

%fprintf("These are the wait times that are greater than 5 minutes:");
%fprintf("(W_q): %f\n ",longWaits);
fprintf("These are the total number of customer wait times:  " + length(ExpectedWaitingTime)); %[output:6ffca567] %[output:99f12283] %[output:6048f7b3]
fprintf("These are the total number of customer wait times W_q > 5 minutes:  " + length(longWaits)); %[output:1534be93] %[output:3c2684c4] %[output:384512bf]
P_of_Wq_greatherthan_5min = length(longWaits)/length(ExpectedWaitingTime);

disp(" ");   %[output:8c3f1058] %[output:08a81aaa] %[output:9d4a21ad]
fprintf(2,"The theoretical Wq has us waiting  " + Wq + "  minutes."); %[output:78c522db] %[output:49d4d01d] %[output:4cda5438]
fprintf("When s = " +s+", P( W_q > 5 minutes) = " + P_of_Wq_greatherthan_5min); %[output:1c1c2914] %[output:941ae129] %[output:972fcab7]
disp(" ");  %[output:07d0ed1e] %[output:241a1686] %[output:171fd0aa]

if s == 7
    fprintf(2,"P(W_q > 5 minutes) > 10 percent "); %[output:3931047c]
elseif s == 8
   fprintf(2,"P(W_q > 5 minutes) > 10 percent");    %[output:0ad640f8]
else 
   fprintf(2,"P(W_q > 5 minutes) < 10 percent");  %[output:8d8105c9]
   fprintf(2, "The minimum number of servers recommended to meet the goal is s = 9."); %[output:08e64e52]
end









disp(" "); %[output:5bc5a91f] %[output:77c00196] %[output:4fb123fa]
disp(" "); %[output:3cfad722] %[output:44356fa3] %[output:430be251]
disp(" "); %[output:5d785a62] %[output:021aacfa] %[output:98456d83]
disp(" "); %[output:31a2dd48] %[output:490ef293] %[output:170cd708]
disp(" "); %[output:507c752b] %[output:73bb95c2] %[output:3ec4c492]



     %P = zeros(1, k-1);    % clears row vector so I can use this again for the next graph
end % this ends the s = k loop

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":59.8}
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
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 7                      **","truncated":false}}
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
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.000744\n","truncated":false}}
%---
%[output:38e370e9]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:26dc05ae]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.004760\nP(2) = 0.015233\nP(3) = 0.032497\nP(4) = 0.051995\nP(5) = 0.066553\nP(6) = 0.070990\n","truncated":false}}
%---
%[output:5ec71185]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(6): 8.077101\n","truncated":false}}
%---
%[output:61077729]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(6): 14.477101\n","truncated":false}}
%---
%[output:5457eb56]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(6): 10.096377\n","truncated":false}}
%---
%[output:465f5cfd]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(6): 18.096377\n","truncated":false}}
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
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 7                      **","truncated":false}}
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
%[output:464c171e]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 9.952319\n","truncated":false}}
%---
%[output:050e607f]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:4a0cd27c]
%   data: {"dataType":"text","outputData":{"text":"    0.0007    0.0048    0.0152    0.0325    0.0520    0.0666    0.0710\n\n","truncated":false}}
%---
%[output:540ea648]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:4089801b]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 12.411171\n","truncated":false}}
%---
%[output:3f38bdcd]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJkAAABzCAYAAACLg6BeAAAQAElEQVR4AezdWchdxZYH8OI+CO18pVFRE3AABVFpGjES1BcDgoigpkFbCYTGqUVtJxCJRn0QnIjgLASEtEKLQRFB0JcITsi1cUJsbAVH1IbrhBcEsfMrXLn725757Drf+U5KXKldq1atWrXqv2vVrl37fH\/6rf5XPVDYA39K9b\/qgcIeqCAr7OCqPqUKsoqC4h6oICvu4tpABVnFQHEPVJAVd\/GUDSxA9QqyBRjEee9CBdm8j9AC2FdBtgCDOO9dqCCb9xFaAPsqyBZgEOe9CxVk8z5CC2DfgoNsAUZoAbpQQbYAgzjvXaggm\/cRWgD7loDs3XffTSeccEI64ogj\/kD4yh9++OFc9tJLLxXvftdtda2vuAPmrIFJ\/bcEZMcdd1x6++2308cff5xuuOGG3MVHH3005\/GVZ+YK+eebb75J1113Xfrpp59WiMV\/N9OAzuJG\/nuL5a6WgGyUZi699NIMutNPP30U8alkpmkLwNavX5++\/PLLqWxYjsoAdueddy5H00XaHBtkHCCcussM5GmnnZYuuOCCdMkll+Qwquyee+7JPNeIbFhvViGPj8w0UdZOm20pIyts068uwlPWJG1cffXV6bPPPkuvv\/56Wrt2bRLqQ2bLli27bG3XZyu9SFvNelE\/0rCPLJJXFjoij6edpj5l6gTJk1M3AHbxxRfnmRifHeqHPDl8feVP43DLLbcs6Zc2Qz70qxPUrGssI69O6FdPu9qPeuP6bxDIQufQ9P33309XXHFFHtBVq1alBx54IG3cuDHnDznkkHTZZZel8847L3399deJ47744otc9uyzz6YXX3wx6cjQRn4X+PHHH9Nee+2VZ9Nzzjkn1286gNjee++dOIIta9asSa+88kpqhvpjjjkm17ck2L59ewqHStmHb8mwbt263C8DQG+TtPnQQw\/lZQVZtsjjaxO9\/PLLOVSr\/+abb6Zjjz02HX744RnwZKOdZl0RAl9blip33313lr\/wwgsTe7Sl\/Nprr818csgNdcopp6R33nknaVu\/jjrqqF157bGNbBA\/nXrqqem7777LY\/Pzzz8nY6P8o48+yrbrQ9iNj8b1Xycg23\/\/\/dNBBx2U9txzz3TooYcmg3v88cfn\/OrVqxOgHXzwwenkk0\/O4OIQdyuH64COuIt0YBjts88+eWYix4lAB7zyo9IZZ5yRRdV3waHSF154ITX1k2OrgVPei\/TDTLJ58+a8ngXmGDw33yeffJIHmh4Dqiz09KobZc3UTaKf7ME3M0vxpYjdxoB+\/pYnF3kyvYgMPl36yU55Y\/Ltt99m0NFHDz4KO0b1XycgAywAY0A\/uvnmm5OZS+fJPP300wkQhbO33nor6RD+cpPBPPvss3PYMauxJ0DoOgiYzCzy+qAvQpZZC685eG3wDqurfi9ij1DGPnY27YobvVe9Qbzmjf7UU0\/lCeKiiy7K4Hr11VfzkiNANUhPlLGLfexkL34nIKNoEP3666\/p8ssvTxpnBNnHHnsshyzT\/9U710833XQT9rKTm8DNwK4gDyC9DBPKyACZ2dssYHYiG4P3xBNP5JBuxsZThgbVVd6LhE\/tBdHRS24cnhnKDGvW\/eCDD9KJJ56YlzZC6KZNmzLo3ECj6uzlv+Ig++WXX3K8Z+Rrr72W1wsGhOHWCBaV1isBPnJdkJnVDDuOLncsO4QO9Syc2cdO+SZZv7lbrScPPPDAdP\/99+dQGyEkBu\/zzz9PdBpIPDqG1Q0dZJFZ0eCZEeW1qW165Kcl+ulgq7aFXTMjHtDpn+th1M9\/xUG2xx575DXZgw8+mNdt7kaDb3FqZnOH33fffem5554b1oexyg2ogTXLAPQoA2LRzT6zkUG0ePYkK7y1G2\/L6ovw2Zz1DB5wINehY1hd9roRhRvrPTPgtm3b8ozILvZZ\/NMTOqdJA1RhJ1ABF52AIx2F2NPLf31BxlmmZRWbDTT5jNmxY0cSEgwqco2nrJ2nJ3h0I\/J4ytoUa454khIempvCYQs5zkdNMLkrQ6cBk9dm9EkqT0\/IBQ8fyUdZO1VGJoh9bRl5NxKguA4aVJfv+JDe8A+g6zseyjbvVMZ3ZMirt5OV2EFWnV55vCapp367jnbYGbLabPKUyeOHTPDwkXxfkEWlaVML4bPOOmvJ4zadQhC+cvk2CQk2Uj3xmE1skfSSBaonn3wyP7VaS9122225LbJbt27NfJ11h91+++0Jv91Wqbyw2w6VpdqaZ73FQAZE1jPCokWlcGKmCZI3PVs79XKQ2Um4c6cKH2QATtokcqZ2d6PZ4rDDDsv7YvLucCn5QTqUd0m2Y4Q5YU3\/7XF1qX+l6SoGMlO16deaSLgwy5hRmgQEQNR2mkEyiwlvygDROg6g5JuEF3J02dPBa8q4tpf222+\/5XWhvEUu20rQe++9l6688sq8jJDKl2hnFjr5ib+moWIgC6PMJBb1QBe8YWlz53mQbIBxkIwycnfccUd+1cUOjrv++utz3oxT6YK+vuAn\/uLHSakIyKx7bEwKl9ZMriNMNlN8sm3jY+Zq89v5mLna\/GYewCz6zXCxQOW0N954I9111115tjGjdk10X3XVVStWP3+wn5\/4q+nTca+LgMzsFU8rni5cN8NkXOOTbRsd4ImwFzNbhMWmPF7IAVQzzMoDmLWdJ65mPddCsDVTCTr33HOTQSqhm87S+rVx0kkncdPUVARkU1u1UwHweH8GKLHgj8X7zuJd\/5OzmWtG9J7QXWdPSr0AWMxguyrli\/rPrDxQBGQGXChshsZe12TI9uosYAhxgGWfzI66WY+8rQ9Pr+qZKc8\/\/\/z8JsETq3ek1l0A56nWE16zbeFbvUqz80ARkAGDUBhhsV9Khmy\/7gpx6npKBRxy5NsPEgBJDgEdOfLq4TUpyslUmo0HioBsNqbXVlaKB4qATEgTCid9ulwpzqt2juaBIiAT0oRC4Up4ct0MWXGNT3Y0U6vUSvVAEZCtVGdUu8t4YFKQlbGmal1ID8wEZPasvLppbiXI4y+kV2unlnigOMgAyaaoPa9Yi8XmKr7yJRbVzMJ5oDjIvBJypmrDhg27nOe10Y033piPJStP9b+F9kBxkHl6PPPMM5d8v2j2cirCuz3lC+3h2rkyf5Ek9sliDebVji95vHTF86rIWahZn1St4708Higyk5md7IHFGqxfSoZsv677WggoberGu8peso5qk0O93k2q630n8Peqv5C8OepUEZB10T\/AcWzHQ8IkZ\/zDBgBz\/PmHH34IVk1n7IGZgMzsYpZpk1dP\/WYXZ8ScA\/OQILzyC8BJm0Su1xl\/MtoFMJ+P7bvvvliVlsEDxUEGRNZe9957b\/7BEGf9gcX6zBGdXuHSg4FZzFkxPomTsgAl3yS8kANIWyV4ZLzS8morQIpXafYeKA4yXTKLHHnkkfkLa5+JAYMtjOeff77nJ2q2NeLXZdTvRwHGfuXD+KO0MUxHLR\/ugeIgMwv59O3xxx9Pvkb2pPnMM88kWxj91knqOBo9zHxgNXMNk+tX7hRtv7LKT8n5\/i78UBxkgOCjBL8p5nN4H9lec8012XYzWa9wqQ7wRNiLmS3CYq78+z94IRczG97vxQOTrs6wD2xkBRf6hrUL84uDLIy89dZb8w\/RWSfZ0gA8YIrydgoo05zxb+sbL1+leWCUaEJuGM0MZMMMaZc7Um02s2if5Ix\/W1\/NL58H5hZkXDLNGX\/1g5z3911Ar9AcMjUt54GZgMxaydGe5j6ZPH65rlXN8+KB4iADJEd6hD5rMWSfjAPwlbuutLgeKA4yT4b1qM\/iAmiUnhUHmXVQPeozylB0K2MP0EkXabeax9dWAmR5F997yViD2YBdqUd9DJLBQq7Hd\/Efa9DThb5+evD9Go91r1T+j1bMjlMEZGavHTt27Pp1a+uwXkSG7Oy6O3pLBgYQDJLBQq7xkTJpL434zfLI4yF6mvpCR1uObJOUk5XiN\/X4yXo8ZKcerf7ndXnXnrx6yDWZIPkmP\/J4XVERkHVlXGk9BqKXU\/FiAMn8079ck44+\/V\/zgBnMKJPKNwesWTfK\/+3f\/2PJ73\/RGQBo1icPfP1IOXkpmaae4OG75rt\/+POBkkzsYmfbFrJ0Bj\/yZLt6tzszkDkfFuFTKp97v4z\/+NVtTjUAYYZrg4cAAX\/PPx+U\/vHI410mdaJMqr6BRa4NGL66Urz\/efcvSZ6CSAMA9KmLyEd5r1Q5fdIoDz1xIzTbcI3IB4jatiijM\/iRZw+++tPSTEDmhGv8eLCw6S6Rx5+2A9PUN1CcChhsQhyL6I0BdB2kjusoi7yULqDpVR7ykZJB6jXTKO+XhnyUq4uaN0K7jE0BIrJRHmlbZ+QjVWcaKg4y58k+\/PDD\/McUYv0l9VNQ+Mqn6cA0dcPJBsGdiwBlkHOjTrQb+UjbdYMf8u00yiNtl7fzo8o164VN\/eq2+ZGPtKlrkuviIAOoo48+esnXSoDlJ9PxlU9ieJd1YhAinca509Ttsk9NXX+wqVk4g+viINMH7yCdgl2zZk3+w1hSeXzlJUlItgYc9DFKDEKkJe3ZHXXPBGQc61SF9ViQPH5J8nDhGLfXWIM+RilpQ9Wdynx3OS+OdZhxlI9R5sXeRbWj+Exm\/eWbR5+mzdKJXrybxRx+1G4c6QY8efS3v34jScPS\/\/vfd9LPf\/16JNm\/jaiza7mSNuaOT\/FPcZBZ2Fvg+4BkCjvHrurFfL\/NRMeKHb3+9C8vZr3D0g9f+s\/03\/9170iyw3SVKi9lIz\/xV+78hP8UB5mZzE+ge39pAd4k7zeVT2j7wGoxc\/US4jR\/zMER8EpPDPyDFvzEX738OCqvOMjMZN5RxoK\/meIrH9XYceR8P+AMW4THmNkifHKcp9zxaU3+OffdpR4\/jeP3XrLFQdar0VnxAGqUj1FmZc\/u2k5RkMUelRDpJwNm7WTbJGaz9scos7Zjd2+vGMgAzFrM+0A\/TeCLI\/tWs3a4DV8h2s8V+KBE++wAfFQK\/NaapZ6qPanbXGY\/0h\/96orYbr1Mt3a0N43uIiBjpPeS3k9acxlcm6ERuqYxeNq6QOXlfIA\/\/tLvtHqb9fV\/\/fr16dNPP22yO7m2NcOv27Zty+f13MAeXqYFQtM4D2mbNm3K+o2bV4D61JQZ57oIyMYxYNayHgT6\/QpQF7YY7HXr1iUfyaxevboLlUt0eKB55JFH8ofSCpp\/rVi+CzL7+wibLksNv2Xij9LKT0K7Jcg8EHCWAbNmAzz5LsisLTQDWhf6huloPzUPkx+33Cs5v1niJybGrRvyswZZtLssqVDjLcCyNF6oUaHNzBwzT1fN8JWjT2ZkhxkseybVXQxk0O9PA1o8IsZaB5l+5ZHF5TSxftxOx8w1br15lfdw5abZvHlz5ybylbWemcxaepqHiyIgg3obrZ7qBhEZsp17aIBCoTLCo7vVIOENqDKXRQDGMEAACNcliO5plxRFQFais13pBChbK2ZQf3jVmf61a9d2pX4m8nZDgwAAAl9JREFUegJgFuhdN+jGEyY9hdPNT\/zlt+XkJ6HdDmTWLtYYXgsJ5\/GXfidx3nLUiUHfvn17PgBq2YGmCWfNfpi5tmzZkvwEK738xF\/81pQb53q3AxnneBMQYXwa59HVjywD\/JKQp81+MpPw6bXMCPsj1adJ9PWq025jWt27Jch6ObbyfvdAgaSCrIBTq8qlHqggW+qPmivggQqyAk6tKpd6oIJsqT86yXn892TWi2xAW7j7wMV7zk4anHMlFWQFBsgTazz1+Un5VatWJW878ADsgAMOKNDq\/KqsIFuGsbGt4VWNdBman3mTFWSdunw0ZcJkhMu4dm4rwquNVdTMNzXb8Y8y182yebyuIJuDUfn+++\/TV199lQ8JCq9OVjBLePUX7hyytNOPB3zet3pxjVzjKZtXqiCbg5HZb7\/90oYNG7Ilzm35Qijep3rXmgt2\/uO9ojC7cePG5PUPco2nbKfIXP5fQTaXw9LbqDig6NhUhEvXPmJW1rvW8nMryJZ\/DEa2ID5YFlKF0iBPrN43jqxoxoIVZDN2+DTNCY8eGLZu3ZoiPFr4O5oT+Wn0l6pbQVbKs4X0OhHhEGGcMHbWy9EcACzU5NRq5wlkU3dmHhXYmG2HM\/tjFutSFNfsb+d71XdYcaWESn2qIOOFSkU9UEFW1L1VOQ9UkPFCpaIeqCAr6t6qnAcqyHihUlEPVJAVde+CKZ+wOxVkEzquVhvdAxVko\/uqSk7ogQqyCR1Xq43ugQqy0X1VJSf0QAXZhI6r1Ub3QAXZ6L6qkhN6oIJsQseNX233rVFBtvuO\/cx6\/v8AAAD\/\/5ZwTCgAAAAGSURBVAMAuqN8c1UVMNUAAAAASUVORK5CYII=","height":400,"width":534}}
%---
%[output:39e2dd8f]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:8e3d7da3]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:8740f9d2]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 9.952319\n","truncated":false}}
%---
%[output:6e39ce5e]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 12.411171\n","truncated":false}}
%---
%[output:16d8437a]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 3.953458\n","truncated":false}}
%---
%[output:6ff66c2b]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 4.688431\n","truncated":false}}
%---
%[output:4efb0270]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:6eb7e90a]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:9ac4c272]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:24385668]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:6575b3b8]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:3b7ce2e0]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:681d7f07]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 7                         **","truncated":false}}
%---
%[output:9594d438]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:0f39eca7]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:30f33817]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:6606f665]
%   data: {"dataType":"text","outputData":{"text":"Lq                 8.0771             3.9535             51.0535           \n","truncated":false}}
%---
%[output:8e39f1be]
%   data: {"dataType":"text","outputData":{"text":"L                  14.4771            9.9523             31.2548           \n","truncated":false}}
%---
%[output:627dde3d]
%   data: {"dataType":"text","outputData":{"text":"Wq                 10.0964            4.6884             53.5632           \n","truncated":false}}
%---
%[output:9713f82d]
%   data: {"dataType":"text","outputData":{"text":"W                  18.0964            12.4112            31.4163           \n","truncated":false}}
%---
%[output:23a09383]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:6ffca567]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  17989","truncated":false}}
%---
%[output:1534be93]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  6037","truncated":false}}
%---
%[output:8c3f1058]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:78c522db]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  10.0964  minutes.","truncated":false}}
%---
%[output:1c1c2914]
%   data: {"dataType":"text","outputData":{"text":"When s = 7, P( W_q > 5 minutes) = 0.33559","truncated":false}}
%---
%[output:07d0ed1e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3931047c]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) > 10 percent ","truncated":false}}
%---
%[output:5bc5a91f]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3cfad722]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:5d785a62]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:31a2dd48]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:507c752b]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:658005a4]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:9d407ce6]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:526fd79e]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:90251beb]
%   data: {"dataType":"text","outputData":{"text":"**          Theoretical Calculations for P_n, L_q, W_q, L, W         **","truncated":false}}
%---
%[output:2b6f5ced]
%   data: {"dataType":"text","outputData":{"text":"**          Theoretical Calculations for P_n, L_q, W_q, L, W         **","truncated":false}}
%---
%[output:56d0cd0c]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 8                      **","truncated":false}}
%---
%[output:65be948d]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 9                      **","truncated":false}}
%---
%[output:68bd8d06]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:5343d375]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:61a06fa8]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:53504477]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:40abf12a]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:574b422e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:58f01074]
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.001311\n","truncated":false}}
%---
%[output:34a4b202]
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.001526\n","truncated":false}}
%---
%[output:174e5020]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:96438f20]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:0a41432b]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.008391\nP(2) = 0.026852\nP(3) = 0.057283\nP(4) = 0.091653\nP(5) = 0.117316\nP(6) = 0.125137\nP(7) = 0.114411\n","truncated":false}}
%---
%[output:9adb8ea0]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.009766\nP(2) = 0.031252\nP(3) = 0.066672\nP(4) = 0.106675\nP(5) = 0.136543\nP(6) = 0.145646\nP(7) = 0.133162\nP(8) = 0.106530\n","truncated":false}}
%---
%[output:67bd04c5]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(7): 1.830580\n","truncated":false}}
%---
%[output:0824aa85]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(8): 0.645483\n","truncated":false}}
%---
%[output:3ee79fad]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(7): 8.230580\n","truncated":false}}
%---
%[output:91f61cc8]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(8): 7.045483\n","truncated":false}}
%---
%[output:3c2a672c]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(7): 2.288225\n","truncated":false}}
%---
%[output:25caef97]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(8): 0.806853\n","truncated":false}}
%---
%[output:4907bdea]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(7): 10.288225\n","truncated":false}}
%---
%[output:327fc453]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(8): 8.806853\n","truncated":false}}
%---
%[output:177eb492]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:88fc6caf]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:296a2d37]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3d93432d]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:2f35a4ab]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:4ccfe7fa]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:5128a18f]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:3669c3ec]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:786fd82e]
%   data: {"dataType":"text","outputData":{"text":"**          Simulation Calculations for P_n, L_q, W_q, L, W          **","truncated":false}}
%---
%[output:595a10b9]
%   data: {"dataType":"text","outputData":{"text":"**          Simulation Calculations for P_n, L_q, W_q, L, W          **","truncated":false}}
%---
%[output:79f4cde9]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 8                      **","truncated":false}}
%---
%[output:4b9cf28a]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 9                      **","truncated":false}}
%---
%[output:00bef058]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:5586be8d]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:0a250611]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:5373c7d5]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:41cf0279]
%   data: {"dataType":"text","outputData":{"text":"Working on sample 1\nWorking on sample 2\nWorking on sample 3\nWorking on sample 4\nWorking on sample 5\nWorking on sample 6\nWorking on sample 7\nWorking on sample 8\nWorking on sample 9\nWorking on sample 10\nWorking on sample 11\nWorking on sample 12\nWorking on sample 13\nWorking on sample 14\nWorking on sample 15\nWorking on sample 16\nWorking on sample 17\nWorking on sample 18\nWorking on sample 19\nWorking on sample 20\nWorking on sample 21\nWorking on sample 22\nWorking on sample 23\nWorking on sample 24\nWorking on sample 25\nWorking on sample 26\nWorking on sample 27\nWorking on sample 28\nWorking on sample 29\nWorking on sample 30\nWorking on sample 31\nWorking on sample 32\nWorking on sample 33\nWorking on sample 34\nWorking on sample 35\nWorking on sample 36\nWorking on sample 37\nWorking on sample 38\nWorking on sample 39\nWorking on sample 40\nWorking on sample 41\nWorking on sample 42\nWorking on sample 43\nWorking on sample 44\nWorking on sample 45\nWorking on sample 46\nWorking on sample 47\nWorking on sample 48\nWorking on sample 49\nWorking on sample 50\nWorking on sample 51\nWorking on sample 52\nWorking on sample 53\nWorking on sample 54\nWorking on sample 55\nWorking on sample 56\nWorking on sample 57\nWorking on sample 58\nWorking on sample 59\nWorking on sample 60\nWorking on sample 61\nWorking on sample 62\nWorking on sample 63\nWorking on sample 64\nWorking on sample 65\nWorking on sample 66\nWorking on sample 67\nWorking on sample 68\nWorking on sample 69\nWorking on sample 70\nWorking on sample 71\nWorking on sample 72\nWorking on sample 73\nWorking on sample 74\nWorking on sample 75\nWorking on sample 76\nWorking on sample 77\nWorking on sample 78\nWorking on sample 79\nWorking on sample 80\nWorking on sample 81\nWorking on sample 82\nWorking on sample 83\nWorking on sample 84\nWorking on sample 85\nWorking on sample 86\nWorking on sample 87\nWorking on sample 88\nWorking on sample 89\nWorking on sample 90\nWorking on sample 91\nWorking on sample 92\nWorking on sample 93\nWorking on sample 94\nWorking on sample 95\nWorking on sample 96\nWorking on sample 97\nWorking on sample 98\nWorking on sample 99\nWorking on sample 100\n","truncated":false}}
%---
%[output:7da58f2d]
%   data: {"dataType":"text","outputData":{"text":"Working on sample 1\nWorking on sample 2\nWorking on sample 3\nWorking on sample 4\nWorking on sample 5\nWorking on sample 6\nWorking on sample 7\nWorking on sample 8\nWorking on sample 9\nWorking on sample 10\nWorking on sample 11\nWorking on sample 12\nWorking on sample 13\nWorking on sample 14\nWorking on sample 15\nWorking on sample 16\nWorking on sample 17\nWorking on sample 18\nWorking on sample 19\nWorking on sample 20\nWorking on sample 21\nWorking on sample 22\nWorking on sample 23\nWorking on sample 24\nWorking on sample 25\nWorking on sample 26\nWorking on sample 27\nWorking on sample 28\nWorking on sample 29\nWorking on sample 30\nWorking on sample 31\nWorking on sample 32\nWorking on sample 33\nWorking on sample 34\nWorking on sample 35\nWorking on sample 36\nWorking on sample 37\nWorking on sample 38\nWorking on sample 39\nWorking on sample 40\nWorking on sample 41\nWorking on sample 42\nWorking on sample 43\nWorking on sample 44\nWorking on sample 45\nWorking on sample 46\nWorking on sample 47\nWorking on sample 48\nWorking on sample 49\nWorking on sample 50\nWorking on sample 51\nWorking on sample 52\nWorking on sample 53\nWorking on sample 54\nWorking on sample 55\nWorking on sample 56\nWorking on sample 57\nWorking on sample 58\nWorking on sample 59\nWorking on sample 60\nWorking on sample 61\nWorking on sample 62\nWorking on sample 63\nWorking on sample 64\nWorking on sample 65\nWorking on sample 66\nWorking on sample 67\nWorking on sample 68\nWorking on sample 69\nWorking on sample 70\nWorking on sample 71\nWorking on sample 72\nWorking on sample 73\nWorking on sample 74\nWorking on sample 75\nWorking on sample 76\nWorking on sample 77\nWorking on sample 78\nWorking on sample 79\nWorking on sample 80\nWorking on sample 81\nWorking on sample 82\nWorking on sample 83\nWorking on sample 84\nWorking on sample 85\nWorking on sample 86\nWorking on sample 87\nWorking on sample 88\nWorking on sample 89\nWorking on sample 90\nWorking on sample 91\nWorking on sample 92\nWorking on sample 93\nWorking on sample 94\nWorking on sample 95\nWorking on sample 96\nWorking on sample 97\nWorking on sample 98\nWorking on sample 99\nWorking on sample 100\n","truncated":false}}
%---
%[output:19207363]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 7.779333\n","truncated":false}}
%---
%[output:8c0edd1b]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 6.824562\n","truncated":false}}
%---
%[output:53789e1b]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJkAAABzCAYAAACLg6BeAAAQAElEQVR4AezdC6hdxXoH8DlRETU+Wnxcn0QNaDE+KogGMeb2GhBEhFjr40rNVYgJDZjUR9Q25iFqq6aNIL4uvsAqXqtVRBswVuMDX2h9REvAG99eEgO+9QpVu3+rmcM66+5zzt5r77XPOvtMyHdmzcz3fTPzzX99M2tm1tqTfk7\/kgUqtsCkkP4lC1RsgQSyig2c1IeQQJZQULkFEsgqN3EqIIEsYaByCySQVW7iDgvoA\/EEsj7oxLo3IYGs7j3UB\/VLIOuDTqx7ExLI6t5DfVC\/BLI+6MS6NyGBrO491Af163OQ9UEP9UETEsj6oBPr3oQEsrr3UB\/Ub1SQffPNN+Gss84KBxxwQDj88MPDW2+91QfN7l0TLrrooq7a7ZZbbsn6Ys2aNb1rRIcljQqyF198MaBLLrkkvPHGG+HQQw\/tsMj2xIF66dKl7Qn1EfemTZsCoLrZx1uz9Jv+GxVkY9kwFTz77LPDt99+O5bV6Kjs66+\/vvTNCWCnnXZa+PTTTzuqw1gIuzEefvjhrOgMZBIMhyg\/JHLJc+fOzRivvfbabNhsdkdFF04ekSPESMcff\/ygHFlDrzR5eABJmeSQfHzyFyxYEL7++uvw0EMPhbzMcPUlRx6vu4g+hB+5Ruqr7Ej5PPL0yFMHuk4++eSA1FN9ydMTSRx\/M6I7ykV9yjj\/\/POzYY+OaK+8vDosXLgwfPTRR9lIcuyxxw6ZqqxatWpQXhl5WfroRbHsfH7+Wt3xRRKXH3XEuDTl5PWJRzkhGXxk9Jm+O+WUU8IkjE888UR45JFHwoYNG8L8+fODjDVr1oQTTjgh3HbbbeSC4fLee+8NkydPzuLxD4UAiI\/87Nmzw4UXXjhokB9\/\/DG89tpr4dxzz\/0Tj8SQ11xzTTjkkEPCm2++mZVlaL7nnnvC7rvvHm688caw4447BjrXrl2bpY1U31gnHXPcccdlOo855pgMpFOnTh2M33zzzYP1y+tT9ieffBKWLVsWVWXhhx9+GK6++urMI0kgzx6xveLAJ68Vevvtt4MbSHn77rtvuOOOOwJb5GXZGZDka8Pzzz8\/ZKpy8MEHZ\/2lHjo0drCQY5CufrNmzcrKAvC8ftfqrO6Rl53FpSsTPfPMM1ndyL\/yyitZX+2\/\/\/5BOcrV7\/oO75VXXhnwzZs3L+szfQdXkwiqSJxrKUjDVq9erR4jEsOoBP7DDjss4y0OD1tttVU48sgjw5577hmOPvro8MILLwSdtmLFiozfH8Z2p+6xxx6Z4VRSepE0oJX6ahxdOmqvvfbKgEp\/jEe9UR+QMxxgH3XUUUEZ8iJfzI9xoRuLRwLIdueqUd\/2228f9t577wDY3333HbUt04knnpjxunlcvPvuu4Kg37RfeyXgc9MBgngzatYWtpoxY0ZwQ7z33nvZDUqPNHlRD0CzAQcUHUHMi+GkL774Il4PCc0DgGhIYiHCMAzEUAxWyB4Sveqqq8K6devC9OnTM8O+\/vrrATCBDmN0rXm3Kz1PGzduDCPVN87ddtlllwBkedmRroFcXZTt7lSGsprJuBndlPKinCE1D0p5Y0l5WwKBukQQuo40WlsiUHnRInh5LkQXm7Gdm64ZZibpEIxF4gHyiC3miwMWgAEawElrRoZMw+W0adMyT4Z\/0aJFmddyl3DXKsyLko9u13WeAGek+u6www559pavle1ON7yg0TwTb40PyHhxdzhv0HKBFTPyZIYpdYw0rzGENSt2pLbw7rwuL2VK5VoaPbAhnX5lKZM9THXk52mS4YEC47AMqGQ0blZ8JFIQ94lfJ+E1R4uTQyDcbbfdsjnZTz\/9FO6\/\/\/6w0047hf322y+YM7n7eYHHH388fP7559lcSIcDLtkiqOJwVra+ofAv6otDQqzPcHckcXMRd612ko\/zxjhs4ekWsQFbtKNPv\/FkvA85c87YH+J5Gq0tsX8\/\/vjj7AFMX0ujQ\/vZgQ4eceXKlZJDtEMMJU6CZO7fZJ+QiR9kmvRjGI3cITwRt0zeHa1ABauQfJ7M5N8E190QdeqkBx54IHz55Zdh\/fr12fDJy5nwkpXvJgD8aKhO6xvLjmFeH4BLj+W7LhK7mOxqp\/ayG\/tpZ5G30zgb6FgewnCuQ0fTWawf28X+KMoWeZu1xZDJSyHXUYf25vtd\/4vTiSfy0jlJAkNze6g4VBCSTineZiQPTyQykc91TL\/11lsDF5ufIAKSeORxLS3Kx7rl6xXTyOTTdUpRP948TzGuHGl0oXz56iFOJ914Ub5NZMhLb0byYvlFfXTSrQx5zeTztlVujLsODQGhOkhvRLP\/MU06Es8ymvyRhyeS+jZhG3yqzOcpM8oJxWM+J6Pd0jOQxYwqQkOQNaY4HMcyxKXLj2kprJ8FDLuGXx7VTVGmhpWBDIgMcYYgcx5u0\/ASSZwLNu8oU\/EkU60FPCWam5oW6EM7L2VLrAxk0V2aT5iHmedxnXkyVJS9O8o2OMm1ZgH9on\/0l1C8Nck\/5aoMZLEoc41HH310yGp1zKs69FR0ww03BGHVZSX9w1ugEpCZZ1maMFx6InIdh8l8KB3v8NXrLAe4Esg6s2E3pCsBGe\/licnThacX19xukaTj7UZDko76WqASkNW3ufmapeteWaASkBkCDYX5obHZNR68vWpsKmdsLFAJyAyBhsLi8FiM48E7Nk1PpfbKApWArFeVT+WMDwtUAjJDoKFwrJ8ux0cX9H8tKwGZIdBQmJ4u+x9ArbSwEpC1UnDimTgWKAuyiWOh1NKOLdATkMXN1vwyhs1X6R23ICmovQVKgcx2jY3vVuipp54KZ5xxRthmm22ys2Q2W2+\/\/fbw1VdfZenyW9FThscBSD3w0ksvZa+VldHRDzL6ix3GitoGmQpffPHF2buUvNFodN5554V33nknPPvss4MyMU2669F0lM1XT4a1f1lWRz\/IsYN+Y4uxoFIg4xmuu+66Qc\/EOyW6t5b2uOCCC4L+Glcgi3eCFxwcZkP77LNPTB5XoXqrfz+Td13HulPa9mTFCrtDuOPxOKyot\/oX29QX8Ro1oisg447\/8m\/+Phx7\/j+PGzrohF+P+TBSIxxUWpWOQRZrt\/2f7RF2PeCw8UMH\/v9nFWL9m4WWWHhoBy+b5beaZpvNSzPeexhORh4evN5p9L7kcLzjLb1rIBtvDW+lvs61e6Bx8LIV\/k54fBbBsg4dXi0b7tU0+eONEsi29BgPYlM\/LhjzXnlPJs6rxU8+ufb9LfwOAvBEeOigKy+7pYgsiOnkED3vv\/9+8GkGb+J7OyjvyeiiE69QPOrg7aQjZWcF1PBPAtmWTvGmtbfVnXnzhri33eMHXLawZAu6PkpngdZC73PPPZd97cbbWN5PjHwjhZ999lnw8Rnl0OOdRrRkyZLguxrewo7ywLRw4cJw5plnZt8NEYrn60UPGfXFH2XrFCaQbekNr9X7xgavIMkwWfyACxD4XIB3RS3h+O6EIdXHaci0Qj5Y4vsgPJilE5\/RGk7OR2wAUN3wCMW\/\/\/570abfncgyavYngWxLh8T3RHmxuXPnZl923Lx585bc7gWGNUD1lSOezMdnuqe9npoSyLb0i3kQMsn3IrKvD23JajnwFaKff\/45mMT7JJY355sJ82DIl5BG8mQ8prfs41AsFN9uu+2aqa1tWtdAtvn3b4bNG8YPfff5xiGd4jV8X400XPqEgu2YXXfddQjPaBFDoV0E8pdffnn2iayiDC9mPif0RSPzOaAEUB\/fM\/GPMobiVatWhfvuuy\/7PqxQvDiMR\/66hh2DjFFtXaxf82\/h+VsXjxv679\/9S\/Z5UfXXOTrUPMxEGvFoMc01ctrXqd98OlnLDZYdYjp5b80jcmRcG5Jd04MnfuUIjzwniaMuId15fnLisRxl4iGv7tLF60ZdAdl43SxX7wiyunVMP9WnY5Axho4yxxhvpN7qn6haC3QFZFVU8f3GAuVdd90V7mrQ008\/XUURSWePLFAFyDqu+vLly8Ov9t8\/\/PSb34S\/aNCGX\/4yHN+IA1zHypOCnlugdiADpC+WLQu\/b5ji3AYd3SDh2oZne6MBOPmNpK7\/t11jg7q4PdT1giagwlqBzBB5ZQNI\/zpMR0iXP0x2R8mWEXwguSMlNRZ2HMviL+r1GbragewfRuko+VV4Mz+\/w\/jCH374IauFfULrZraA4r4gT2dDXHrcsMbME4rn08mQtZFNxiq\/BV\/89PCc5MSrpvx7Dg5rPvjgg9leLNAhba+qDrUD2SGjtHS0\/FHEh82+7LLLgqdN4bbbbpv9cBZQ6ACLp0KAsMjqBxGsc9mwtngKTAApHtPF8xvZ1sAALv4yiNX7gw46KPu9qGEr1cWMeKg0HtYENPWJJB6B18ViM1W1Apkave3PCCR\/ypQpI3B0J6u4GU6rIdU2kBV9HgvA\/A7TBx98kP2Ygg1sfMJmG9lW+f2cELACmw12\/L2gwUOlWw5rRtA5zVwEXrfrUyuQzZkzJ1w1SgvvnjIlzJw5M4zVPxvavBqPhazCO1XRSn2s1jux4bQHsAFdK3Jd52koHASd08wF4DWyu\/q\/ViDTsiV33hkWuWhC0v9qzpwmOb1Jsr\/o9KqzZ0o0vzLc2BS3cW0IlC4Ub7aRfc4554THHnssABvQ4a8LReB1uz61AxlvdngDaAc2WnpHg15qkPD4KVPCLo2ljaVLlzZSuv8fgAYGBkJ+4l8sBSj8lpKfBjJcxg1rsjauxfPpzTaybaLT28uhUnljSbUDGWPMmTMnPPnee+GAp54K\/9MA3KQGrW3EqwKYMgHI0Gej+aSTTgqupdl0lmYTGl\/cyI5DJR7pQjL59CgbN7LxOQJkvjaWQ6V69JJqCTIGMLmfOXNmADgkbbyTA4seGoAYKHvZnk0bN2W\/qhufeGPcQ0gxrdvLGaVBll\/cMxFO9OKQdadm9oie7YgjjhiVt5l8mTTLL8D89msvhv\/6z0eycv\/3zw8Mb617K4s3S7OUQaZb1DbIrCU5P5Zf3DP5TXTW4Adl6mQL61\/669\/\/6e\/Cf\/zjX4eHVswJv7vxyiwUR8W0U089tVv4yvSUAplzWOYpdSA\/zurTVOpy0003ZYubfmhfHA384Q\/h3gKd34gf26Biurh0r715AEB0DKV6flhlpDrqr3aOYXEkGTq69KdtkClXJdqpdJW806dPD\/Y8p02bFrbeeutgtd5ra7HMJTffHO7\/4x\/DMTla3Lj+VYN+3aB3GjTQIOHiX\/wiTL300rB48eJw+umnZxT1jOdQf+m3saJSIGu1svbsPNIjk95W5drh8+RmzcnTGg9miSE\/qfbQ0GxJ5M7GksjfNpZEevkE2067+om3MpABmC0Xk1Vv\/wCAxcsqjOc8\/IYNG4L9QUsMxTIAzZLIukWLwsm77RYubdCS3\/42WBLp1hOsp7S4Qe6msiFuE7xYlzJxeoqb6fnyzAHtn5bRTaaZfn2lHZH0J94yVAnIGGD9+vUhehUdv3LlyuBtoE6MUaaBUcZep47ksAAABG1JREFU4auvvhrWrVsXnnzyybBixYrAuDG\/09C+ptfo3FQjAb7dctTRm1R2GqIsG9qAjxvyPPmyhleO+e2EzfSTZy9vpmsLciNLL0OVgKxMRaqWYTSfITCUWnU3T7H9061ygcxWknclu6XTFAPAdDYAR73FN8vtHhg13NyRp5VwOP1AbG916tSpragZlWdCgSwazXqVux\/wRrVQiwx08WLmhoYYw02LosOy2WUwBaAzzwTQ4razYmj\/NKZLa4WG0w\/E1tfmzp2bve9pGtAugPPl9xpk+bJ7dh3vzCoLBLLZs2dnH0YxB7W\/yVNUUSYw5YfPbpdBP9Bqh6HSCGB4ZscyZVUGMkawheKuRu6K\/J0urdM7pNUGR8\/VKn8ZPnMWRNYcdNasWWH16tWiXSceLD98drsA9Td\/FtLt5IitJvuu4u1SJSAz74mbxe6E4QgP3nYrXYbfUMnbkHVHdnPOQWczUmaz9E7TgIwOHieGAwMDIaZL6zbtvPPOpfVXArJuN7Ab+nR4nBy7I92ZTrB2QzfQWkaIw6Mntpdffjl0S3+xjh4uPGTEBxce05DWrRtWO7RHu5R99913h06Oik8YkJnkeuS3cm8Yv+KKK0IcDhiyEzIcO0\/ma4mmAd3WX6xbLC+eX+OVyy5hFHWLs9WMGTOCBw7t6VT\/hAEZ482bNy+bmBu+GVJat4gXWbt2bSX63Qw+2KKMWF\/XsTz7loAX89oNm+nP26pT\/RMKZO0af0LyV9DoBLIKjJpUDrVAAtlQe6RYBRZIIKvAqEnlUAskkA21R1sxWy0WlD2BIdfS2lIyAZgTyEp2srUwq\/qWRTytItcOTPYCaI7eoJLV76lYAllJc1ugBDKP+lGFExO+7x9f\/o3pEz1MICuBAJ7K7oEjNnnxyZMnB2tKeeDxeA4wGk6F4mSspltVz5\/W4JmQfKvuhl88ZFHkFQIyivxk6koJZCV6xp6hUwqj7RUC44IFC4IDm4bT+fPnB3HprRTrt5asvJP1IxZOdgApEDvxgeKmfCv6xoongaxCy\/sxCOptzwiBQhjTXY9EviwUZQDaJvVI\/HXNSyAr0TM6fGBgIPvlkZHEnfowR7OhPRJfv+clkJXoYfuGTj04\/VAUN0dC0p38cMLUSVPxiUoJZCV73kE+3xkzCY8qTNalyZMWh8k4PJqox3Qb2o6AOxzoIcA8zcOE\/H6jBLKSPerkAkDF4zae\/hz1kSaPWh7PG1teB5Rv4i4uXT4w+pEvYLS+5vU86a2QJ1ug9fQJpK3IjBVPnUA2VjYoXS6wxOM2ngBdS8srBDgvg8gXisd819LkkV2+fHmIT4uOIkmL+vDyekLy8slZMuEVpdWVEsjq2jN9VK8Esj7qzLo2JYGsrj3TR\/VKIOujzqxrUxLI6tozfVSvBLI+6szKm1KygASykoZLYq1bIIGsdVslzpIWSCArabgk1roFEshat1XiLGmBBLKShktirVsggax1WyXOkhZIICtpuPbFJq5EAtnE7fuetfz\/AAAA\/\/+LWpEWAAAABklEQVQDALH8+qCX92L6AAAAAElFTkSuQmCC","height":400,"width":534}}
%---
%[output:6e760152]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJkAAAByCAYAAABA33P7AAAQAElEQVR4AezdeahdRZ4H8HrpP2x3B1zalcQOGBWVEcSoGKNtwEZFiDijtjNGBU0gYDJxH2IWMbZLpiOIGkU7MrYyI4pB7A6oJHHct3GJioMd49q4wLjbCnbmfM6kwnnXe9+979xz3zvvpkJ+r05V\/X6\/qvrV9\/yqTlWdc8dtTP+SBXpsgXEh\/UsW6LEFEsh6bOCkPoQEsoSCnlsggaznJk4FJJAlDPTcAglkPTdxlwX0gXgCWR90Yt2bkEBW9x7qg\/olkPVBJ9a9CQlkde+hPqhfAlkfdGLdm5BAVvce6oP69TnI+qCH+qAJCWR90Il1b0JbkH399dfhzDPPDPvuu2845JBDwmuvvVb3NtWqfhdddFGldrv11lvzvnj00Udr1c6hKtMWZM8880xAl1xySXjllVfCQQcdNJS+yvOAesGCBZXrHSsKP\/nkkwCobvaxUudYT\/2m\/9qCLAqMRqiCZ511Vvjmm29Go\/hKyrzhhhtK35wAdtppp4WPPvqokrqMpBI3xoMPPpgXmYNMguEQFYdELvn888\/PGa+77rp82Gx2R0UXTh6RI8RIxxxzzGY5soZeafLwAJIyySH5+OTPnj07fPXVV+GBBx4IRZlW9SVHHq+7iD6EH7lG6qvsSMU88vTIUwe6Tj755IDUU33J0xNJHH8zojvKRX3KuOCCC\/Jhj45or6K8OsyZMye8\/\/77+Uhy1FFHDZqqLFu2bLO8Moqy9NGLYtnF\/OK1uuOLJC4\/6ohxacop6hOPckIy+MjoM313yimnhHEYH3nkkbBy5cqwfv36MGvWrCCDwPHHHx9uu+02csFwec8994Ttttsuj8c\/FAIgPvLTp08P8+bNG2SQyNsYMuQ111wTDjzwwPDqq6\/mZRma77777rDrrruGm266KWy\/\/faBzrVr1+ZpQ9U36tcxRx99dK5z8uTJOUgnTpy4OX7LLbdsrl9Rn7I\/\/PDDsHDhwqgqD997772wZMmS3CNJIM8esb3iwCevE3r99deDG0h5e++9d7jzzjsDWxRl2RmQ5GvDk08+OWiqMmnSpLy\/1EOH6i\/yQo5BuvpNmzYtLwvA5RdJndU98rKzuHRloscffzyvG\/nnn38+76sJEyYE5ShXv+s7vFdddVXAN3PmzLzP9B1cjSOoInGupSANW7VqVbE+Ta8ZRiXwH3zwwTlP4\/Dw448\/hpdeeimce+65LYc9xnan7rbbbrnhVDJX1vBHAzqpr8bRpaP22GOPHKj0x3hUG\/UBOcMB9mGHHRaUIS\/yxfwYF7qxeCSAHO5cNerbZpttwp577hkA+9tvv6W2YzrhhBNyXjePi7ffflsQVq1atbm9EvC56QBBvBk1awtbTZkyJbgh3nnnnfwGpUeavKgHoNmAA4qOIObFcNznn38erweF5gFANCixIcIwDMRQDNaQnUd\/9rOfhUMPPTTsvvvu4fDDDw9PP\/104BkWL16ce0Xgwxhda9HtSi\/Sxx9\/HIaqb5y77bTTTgHIirJDXQO5m0TZ7k5lKKuZjJvRTSkvyhlSi6CUN5pUtCUQqEsEoetI7drixsTLizaCl+dC8tmM7dx0zTAzTodgbCQeoIjYxnxxwAIwQAM4aa3o6quvDuvWrQtHHHFEfve+\/PLL+ZyCEVTWncaLko9u13WRAGeo+m677bZF9o6vY\/mGF9TOM\/HW+ICMF3eH8wYdF9hjRp7cMKWOkWZmQ1izYodqC+\/O6\/JSplSupdEDG9LpV5Yy2cNUR36RxhkeKDAOy4BKRuNmxYciBXGf+IEErzlanBxGEMqfMWNGPqd46qmn8uFh7ty5+YRWJwEpj8bt6nDAJdsIqjicla2v+hUp6otDAm\/EK7W6I8mai7hrtZN8nDfGYQtPVcQGbDEcffqNJ+N9yJlzxv4QL1K7tsT+\/eCDD\/IHMH0tjQ7tZwc6eMSlS5dKDtEOMZQ4DpK5f5N9QiZ+kGnSj6EduUNMHHkk8u5oBSpYhU499dQcVOZlxx13XDjyyCPDPvvsE0zMddJ9990Xfvjhh\/DCCy8EQxbAmfCSle8mAPxoqG7rGxr+FfUBuOxYvutGYheTXe3UXnZjP3Zo5O02zgY6lodgGx3aTmdj\/dgu9kejbCNvs7YYMnkp5Drq0N5iv+t\/cTrxRF46x0lgaG4PNQ4VhKRTircZycMTiUzkA7KYfscddwQutjhBBCTztMhTzKMj1q1Yr5hGppiuUxr14y3yNMaLZdBXLF\/dxOmkGy\/SPryR6JTejOTF8hv10Um3MuQ1ky\/aVrkx7hq\/UD2ki6OYJh2JS29G8vBEUt9mfMWhMuYrM8oJxWMeJ6Pd0nOQxYwUjjELjEB1DbuGXx7VTVGmyJ6DzDzHQmac88VKikuXH9NSWB8LeEo0NzUtMI2w81K2dj0DGRCZR6mgibWx2Rwmkrhx3uS2bOWTXO8swGsZyg13QvGypfUMZHFMNmk1nnuYUOEidVv5so1OciNrgZ6BLDbDhPahhx7Kly9i2kiFHr1vvPHGIBypMlM5P7VAT0BmnmW9yXDpsdt1HCaLoXS8P61WNSnAlUBWjS270dITkPFeHss9wnpEdl0cJuO1dLzdNCDJ1t8CPQFZ\/ZutholGygI9AZkh0FBYHBqbXePBO1KNTeWMjgV6AjJDoKEwDoutQjx4R6fpqdSRskBPQDZSlU\/ljA0L9ARkhkBD4Wg\/XY6NLuj\/WvYEZIZAQ+GW\/nS5YcOGsGLFipzWrFnT\/2hq0cKegKxFWX2fXATVokWLwq8mTAh\/O+ecsH9G6489NhyTxVesWNH3dmhsYFmQNerZ4uNFUK3PQPX5woXhz5lVzs3o8IyEazPP9l9ZHl5gW7NmTZbT\/\/9LgcxKuj3JTmn16tXhpJNOyo9bx6UMcemd6ijD5wCkLnz22WfzU7hldHQic+2114a3f\/vb8Ief\/zwckJHwH7PwmQa6NouvyehvGe\/GWbPC6l\/\/OkzZf\/9AvpNyyvLoL3YYLRo2yFT44osvzt+ldBSkEzrvvPPCG2+8MaiN4tI7kS\/Lo54KtbVUVkcncsuXLw9P7r57OHMTbdwUxngMl2fp8v49C6\/KSPjB998H8p2UU5aHHfQbW4wGlQIZz3D99dfnp1ydpEh0T21tceGFFwb9NaZAFu8ELzg4K5ZocqizDbyGGPtstMJhe7JmFXWXlJ0vjKacejdrT0qr1gJdg0xHGfPLzhdGU0691b9ak9ZEW42qUQnIjPl\/\/w\/\/Eo664NoxQ\/sd\/5u2c5V4zt2ZuG76zA6I9xkcSW+lRx4evN5p9L5kK96xlt41yGKDt\/m73cLO+x48duiX\/\/\/tjlj\/ZqFz7R5qnIlrll9lms8ifPnll7lKr5a1ejUtZxhjfyoD2Rhr90+qy4PYb43reLxX0ZOJG9rjJ59c+\/4Wfnu0PBEeOugqyhYLi+nkED12CnyawZv23g4qejK66MQrFI86eDvpSNnFcup0nUC2qTe8ae1tdceSvCHuc07xAy6bWPIFXR+l87BiofeJJ57Iv3bjRRnvJ0a+ocJPP\/00+C6IcujxTiOaP39+8MkGb2FHeWCaM2dOOOOMM\/KvHQnFi\/Wih4z64o+ydQoTyDb1htfqfWODV5BkmGz8gAsQ+FyA1\/gs4fjuhCHVx2nIdEI+WLLLLrvki9mWPnzhqJWcj9gAoLrhEYp\/9913ok2\/O5Fn1OxPAtmmDomv8PFivutgaPrss8825VYXGNYA1QdmeDLfBalOez01JZBt6hfzIGSSv3LlyrDDDjtsyuk88BWijRs3BpN4H47zUnMzaR4M+RLSUJ6Mx\/QCdByKheJbb711M7W1TasMZJ\/9+dXw2fqxQ9\/+78eDOsVr+L4aabj0drvtmJ133nkQT7uIoXCvvfbKP4d6xRVX5F8vapThxcznhL5oZD4HlADq43sm\/lHGULxs2bJw77335ocLhOKNw3jkr2vYNcgY1dbFW4\/+ITy5\/NIxQ\/\/9n\/+Wf\/lR\/XWODjUPM5FGPFpMc40cxHQgs5hO1nKDZYeYTt4LzYgcGdeGZNf04LExrkw88hzyjLqEdBf5yYnHcpSJhzw90sXrRpWAbKxulqt3BFndOqaf6tM1yBhDR5ljjDVSb\/VP1FsLVAKyXlRxw4YN+dn4LekEaS\/sWAedtQSZ48npfHwd4FFNHXoBsq5qxnN93uJ8\/CvnnJN7t64KaCFsu8YGdeP2UAv2lDwMC9QKZIbIqzIg\/a5FA6TLb5HdVbJlhC+++KIrHUm4uQVqB7J\/bV7PzanyebvNCRVd+PkdZ8uE33\/\/fa7VPqF1M5vYcV+Qp7MhLt2uAA+IWSheTCdD1kY2Gav8Fnzx08NzkhPvZ6odyA5sY+12+W3EW2ZffvnlwdOmcKuttsp\/OAsobP1YPBUChEVWP4hgncuGtcVTYAJI8ZguXtzItgYGcPGXQaze77fffvnvRbWsVIUZzvxpA3IzVai6rapagUxtX\/dnCJI\/fvz4ITiqyWrcDKfVkGobyI4AjwVgfofp3XffzX9MwQY2PmGzjWyr\/H5OCFiBzQY7\/pGg4htbI30iuFYgmzFjRri6jcXvGj8+TJ06NYzWPxvavAGPhazCO1XRSX2s1jux4bQHsAFdJ3JV8MSTy\/FE8P33358fXdIW1EvvViuQMeb83\/8+zHXRhKQfN2NGk5yRSbK\/6PSqs2dKNL8yBNoUt3FtCJQuFG+2kX322WeHhx9+OAAb0OEfCdp8ctmJ4KzAomfTBt4tAi\/LrvR\/7UDGmx2SAe2XWTPvzOjZjITHjB8fdsqWNhYsWJClVP8fgAYGBkJx4t9YClD4LSU\/DWS4jBvWZG1cixfTm21k20SndySHSuU1UvRs3suI3g3QAK6Rt9t47UCmQTNmzAiPvfNO2Hf16vBmBrhxGa3N4r0CmDIByNBno\/nEE08MrqXZdJZmExpf3MiOQyUe6UIyxfQoGzey8TkCZL42kkOlchtpm+I7GZu8WwReI2+38VqCTKNM7qdOnRoADkkb6+TAoocGIAbKurUnAq\/qetUWZFU3tA76eEOerujZRqpen3z8SfBUG5dVYrxZmvlalQ8CpUFWXHfxdJLomUFPa3WxhzU+QP6fPy4PTyy\/JLz44HLREOPN0tQ9Z6roz7BBZsHSIUVoN0lMdGb+Ukhd7WAyr7\/uXXFb+I\/bfpeTOWYxLr2YVvU5u1IgUwmVqgOdfvrp4YADDgh+S3PevHn5CvrNN9+8+Ss73pM86i9\/Cfc00AVZfCCjf8pofkbCvbKVfvxDt6u+X\/BpVW\/9NZyzfhxJRU4sVzNskJFSieFUupe8S5YsCZMmTQq+deZNo9tvvz1YHpg8eXL+tZ1LL700\/OqWW8Jv\/vrX8EZGAxkJ\/\/iLX4R\/vuyycOyf\/hQGsvwJGT3+5psBf5Ttl1B\/6bfRolIg67SyNoatGyFPVp3KDZfPeXgTavuDlhga5T2dWhJZN3duOHmXXcJlGc3PwGhJpKonWBPouEGuvTbEbYI31qVMnJ7GzfRijNQnUgAABLJJREFUeYZq+6dldJNppt9Cs3ZE0pd4y1DPQKZS9vVMIv0MoaFMxctUsgoZe4UvvvhiWLduXXjsscfC4sWLA+NWoZsO+5peo9PeoQCPdzikjt6kstMQ5QDKBnzckLd7sDBbqI75wwmb6SfPXt5M1xbkRpZehnoCMnfZW2+9FayOWw\/iXZYuXRq8csZAZSrarQyj+QyB+lh1N4TY\/ulWb5QHMltJ3pWMad2GvD+A6WwAjvoa3yw3PXBDs3vk6SRspV8f2VudOHFiJ2ra8vQEZG1LHQUGIItGsxLv7pdWVVXo4sWs5BtiqvDa1tVMAegs1hOgxW1nxdD+aUyX1gm10g\/Elj68Sa8tpgHDBXCx\/C0CZPHOLDa86msgmz59ev5hFNMD+5s8RdXl0AdMxeFTWpVEP9Bqh6HSCGB4Zscy5Yw0yMrUsWuZ6Lm6VjSEAnMWhMX0YNq0aWHVqlWilRMPVhw+qy5A\/U1thHQ7OWIHwL6r+HCpZyBzp9mn424R11scTqR164aH01hDJW9Dxh1Z5ZyDzmakzGbp3aYBGR08TgwHBgZCTJdWNe24446l9fcEZCbX8UQCd9uK8OCt2iDN9OnwODl2R7oznWBtxjvcNKC1jBCHR09szz33XKhKf2N9PFx4yIgPLjymIa0qW2qH9miXsu+6667QzVHxnoBMxepGJrke+S2w8rBXXnlliMNBt3U1HDtP5muJPHTV+hvrF8uL59d45bJLGI26xdlqypQpwQOH9nSrf4sBGePNnDkzn5jzrAwprSriRdauXdsT\/W4GH2xRRqyv61ie7STAi3nDDZvpL9qqW\/1bFMiGa\/zEX40FEsiqsWP\/aOlBSxLIemDUpHKwBRLIBtsjxXpggQSyLoxqq8Vanycw5FpaFyr7UjSBrGS3Wguzqm9ZxNMqcu07\/yMBNKdcUMnqj6hYAllJc1ugBDKP+lGFExO+7x9f\/o3pW3qYQFYCATyV3QNHbIri1qqsKRWBx+M5wGg4FYqTsZpuVb14WoNnQvKtuht+8ZBFkVcIyCjyk6krJZCV6Bl7hk4p\/HSvcLAyYJw9e3Zwls5wOmvWrCAufTBn85jfWrLyTtbRcic7gBSInfhAcVO+uYZ6pCaQ9bAf\/BgE9bZnhEAhjOmuhyJfFooyAG2Teij+uuYlkJXoGR0+MDCQ\/\/LIUOJOfZij2dAeiq\/f8xLISvSwfUOnHpx+aBQ3R0LSnfxwwtRJU\/EtlRLISva8g3y+M2YSHlWYrEuTJy0Ok3F4NFGP6R4SHAF3ONBDgHmahwn5\/UYJZCV71MkFgIrHbTz9OeojTR61PJ6XabypJd\/EXVy6fGD0I1\/AaH3N63nSOyFPtkDr6RNIO5EZLZ4Esi4sDyzxuI0nQNfSiioBzssg8oXiMd+1NHlkFy1aFOLToqNI0qI+vLyekLx8cpZMeEVpdaU6gayuNkr16tICCWRdGjCJt7dAAll7GyWOLi2QQNalAZN4ewskkLW3UeLo0gIJZF0aMIm3t0ACWXsbJY5ogZJhAllJwyWxzi2QQNa5rRJnSQskkJU0XBLr3AIJZJ3bKnGWtEACWUnDJbHOLZBA1rmtEmdJCySQlTTc8MW2XIn\/AwAA\/\/\/uy816AAAABklEQVQDADfVaq1nqQDVAAAAAElFTkSuQmCC","height":400,"width":534}}
%---
%[output:36a2bd75]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJkAAABzCAYAAACLg6BeAAAQAElEQVR4AezdCYwdRXoH8LIBsYA5EnEsp2xwBBHmCBIBC2F7s1hCQojIhAgIEV6IjK21hB1uEuNLwAZwYiTEtYIdNgTEEggIwRphgs0hDAgC2IC8AtuAYYVBwtwQBUj\/el3enubNzHv9Xs\/0vGlrPldX1fd9VfXVv7+qrurqN\/r7+l9tgZItMDrU\/2oLlGyBGmQlG7hWH0INshoFpVugBlnpJq4LqEFWY6B0C9QgK93EbRbQBeI1yLqgE6vehBpkVe+hLqhfDbIu6MSqN6EGWdV7qAvqV4OsCzqx6k2oQVb1HuqC+nU5yLqgh7qgCTXIuqATq96EGmRV76EuqN+AIPv888\/DmWeeGQ488MBwxBFHhNWrV3dBswevCRdeeGFH7XbzzTenfbF8+fLBa0SbJQ0IslWrVgV08cUXh1deeSUcdthhbRbZmjhQz58\/vzWhLuLetGlTAFQ3+3Brln7TfwOCbCgbpoJnnXVW+OKLL4ayGm2Vfd111xW+OQHstNNOC++\/\/35bdRgKYTfGAw88kBadgkyC4RBlh0QuecaMGSnjNddckw6bje6o6MLJI3KEGGny5Mlb5cgaeqXJwwNIyiSH5OOTP3v27PDZZ5+F+++\/P2Rl+qovOfJ43UX0IfzINVJfZUfK5pGnR5460HXyyScHpJ7qS56eSOL4GxHdUS7qU8Z5552XDnt0RHtl5dVhzpw54d13301HkuOOO67XVGXp0qVb5ZWRlaWPXhTLzuZnr9UdXyRx+VFHjEtTTlafeJQTksFHRp\/pu1NOOSWMxvjYY4+FBx98MKxbty7MmjUryFi+fHk44YQTwq233kouGC7vuuuuMGbMmDQe\/6MQAPGRnzZtWrjgggu2GuTbb78NL730UjjnnHN+4JEY8uqrrw6HHnpoePXVV9OyDM133nln2HPPPcMNN9wQdt5550DnypUr07T+6hvrpGOOP\/74VOexxx6bgnT8+PFb4zfddNPW+mX1Kfu9994LCxYsiKrS8J133glXXXVV6pEkkGeP2F5x4JPXDL322mvBDaS8\/fffP9x+++2BLbKy7AxI8rXhmWee6TVVOeSQQ9L+Ug8dGjtYyDFIV7+pU6emZQF4Vr9rdVb3yMvO4tKViZ588sm0buRfeOGFtK\/GjRsXlKNc\/a7v8C5evDjgmzlzZtpn+g6uRhNUkTjXUpCGLVu2TD36JYZRCfyHH354ypsfHrbZZptw1FFHhb333jscc8wx4dlnnw06bdGiRSm\/\/xjbnbrXXnulhlNJ6XnSgGbqq3F06ah99tknBSr9MR71Rn1AznCAffTRRwdlyIt8MT\/GhW4sHgkgW52rRn077rhj2HfffQNgf\/nll9Q2TSeeeGLK6+Zx8eabbwqCftN+7ZWAz00HCOKNqFFb2GrSpEnBDbF+\/fr0BqVHmryoB6DZgAOKjiDmxXD05s2b43Wv0DwAiHol5iIMw0AMxWC57F7RK6+8MqxZsyZMnDgxNezLL78cABPoMEbXmnW70rP0wQcfhP7qG+duu+22WwCyrGx\/10CuLsp2dypDWY1k3IxuSnlRzpCaBaW8oaSsLYFAXSIIXUcaqC0RqLxoHrw8F6KLzdjOTdcIM6N1CMY88QBZxObzxQELwAAN4KQ1IkOm4XLChAmpJ8M\/d+7c1Gu5S7hrFeZFyUe36zpLgNNffXfaaacse9PXynanG17QQJ6Jt8YHZLy4O5w3aLrAkhl5MsOUOkaamQxhjYrtry28O6\/LS5lSuZZGD2xIp19ZymQPUx35WRpteKDAOCwDKhmNmxXvjxTEfeLXSXjN0eLkEAj32GOPdE723XffhXvuuSfssssu4YADDgjmTO5+XuCRRx4JH3\/8cToX0uGASzYPqjicFa1vyP2L+uKQEOvT1x1J3FzEXaud5OO8MQ5beDpFbMAWrejTbzwZ70POnDP2h3iWBmpL7N+NGzemD2D6Whod2s8OdPCIS5YskRyiHWIocTQkc\/8m+4RM\/CDTpB\/DQOQO4Ym4ZfLuaAUqWIXk82Qm\/ya47oaoUyfde++94ZNPPglr165Nh09ezoSXrHw3AeBHQ7Vb31h2DLP6AFx6LN91ntjFZFc7tZfd2E8787ztxtlAx\/IQhnMdOpDOfP3YLvZHXjbP26gthkxeCrmOOrQ32+\/6X5xOPJGXztESGJrbQ\/mhgpB0SvE2Inl4IpGJfK5j+i233BK42OwEEZDEI49raVE+1i1br5hGJpuuU\/L68WZ58nHlSKMLZctXD3E66caLsm0iQ156I5IXy8\/ro5NuZchrJJ+1rXJj3HVIBITqID2Jpn8xTToSTzMa\/CcPTyT1bcC29akym6fMKCcUj\/mcjHZLT0EWM8oIDUHWmOJwHMsQly4\/ptVh9Sxg2DX88qhuiiI1LA1kQGSIMwSZ83CbhpdI4lyweUeRitcy5VrAU6K5qWmBPrTzUrTE0kAW3aX5hHmYeR7XmSVDRdG7o2iDa7nmLKBf9I\/+Eoo3J\/lDrtJAFosy13jooYd6rVbHvLJDT0XXX399EJZdVq2\/bwuUAjLzLEsThktPRK7jMJkNpePtu3rt5QBXDbL2bNgJ6VJAxnt5YvJ04enFNbebJ+l4O9GQWkd1LVAKyKrb3GzNyr\/esGFD6OnpSWnFihXlF1jREkoBmSHQUJgdGhtd48FbUdu0Va2FCxeGn44bF7772c\/Cnye07ic\/CZOTeE9PT1t6h6NwKSAzBBoK88NjPo4H73A0XKM6R88FYJsXLAhvJUznJHRMQsKViWd7JQHcSANaKSBLbDri\/gCL59qUgOjXCcD+rQ8LnJ+kX5zwANqKFSuSWPf\/lQIyQ6ChcKifLger+wAmeq6\/TAr9p4Qa\/S1MEn+a0C8SGklDaCkgMwQaCkfC06UhcnHimaLn2pAA6NCE8n89ScLmhEbiEFoKyBJbjpg\/IMt7rtdyrQe8xUlaBGJy2etPOqD2SuyiSFGQdZEJ2msKkGU91\/RE3ZUJZf+ALA\/EbL5r+T09PS67jgYFZHGzNbuMYfNVejdYNO+55iWNmptQ\/AOyLBBjejYcKD\/LO9yuC4HMdo2N72boiSeeCKeffnrYbrvt0nfJbLbedttt4dNPP03T5TejpwiPFyB1yHPPPZceKyuioz8Zb\/rusMMO4cof\/SisytAhyfXXCR2U0PyEXkzokYSyPPnrXyf5ZdVTf7HDUFHLIFPhiy66KD1LyRsNROeee254\/fXXw1NPPbVVJqZJdz2QjqL56smw9i+L6uhP7rLLLgvo+733Dmfm6NEkLv3fk\/DhhIR5nmz8twnPo48+utVG\/ZXbah476De2GAoqBDJ33LXXXrvVM\/FONd1VSXucf\/75QX8NK5DFO8EBBy+zof322y8mD6tQvdW\/m8lZ16HulJY9Wb7C7hDuuFUXXgV+9Vb\/fJu6Il6hRnQEZNzxX\/ztP4bjzvuXYUMHn\/B3Qz6MVAgHpValbZDF2u34J3uF3Q88fPjQQX\/4rEKsf6PQEguP68XLRvnNptlmc2jGuYe+ZOThwetMo\/OSffEOt\/SOgWy4NbyZ+nqv3QONFy+b4W+Hx2cRLOvQ4WhZX0fT5A83qkG2pcd4EJv6ccGY98p6MnFeLX7yybXvb+H3IgBPhIcOurKyW4pIg5hODtFj18CnGZzEdzoo68noohOvUDzq4O2kI2WnBVTwvxpkWzrFSWun1b3z5oS40+7xAy5bWNIFXR+ls0Broffpp59Ov3bjNJbziZGvv\/DDDz8MPj6jHHqcaUTz5s0LvqvhFHaUB6Y5c+aEM844I\/1uiFA8Wy96yKgv\/ihbpbAG2ZbecKzeNzZ4BUmGyfwHXIDA5wKcFbWE47sThlQfpyHTDPlgie+D8GCWTnxGqy85H7EBQHXDIxT\/6quvRBt+dyLNqNh\/Nci2dEg8J8qLzZgxI\/2y40cffbQlt3OBYQ1QfeWIJ\/Pxmc5pr6amGmRb+sU8CJnkO4js60NbspoOfIXo+++\/DybxPonl5HwjYR4M+RJSf56Mx3TKPg7FQnH7pY30VjWtYyD76K1Xw0frhg99+fEHvfrEMXxfjTRc+oSC7Zjdd9+9F89AEUOhXQTyl19+efqJrLwML2Y+J\/RFI\/M5oATQzZs3BxP\/KGMoXrp0abj77rvT78MKxfPDeOSvatg2yBjV1sXa5f8RnrnlkmFD\/\/Obf00\/L6r+OkeHmoeZSCMeLaa5Rt729dZvNp2s5QbLDjGdvFPziBwZ14Zk1\/TgiV85wiPPm8RRl5DuLD858ViOMvGQV3fp4lWjjoBsuG6Wq3cEWdU6ppvq0zbIGENHmWMMN1Jv9a+pXAt0BGRlVHHDhg3pyeuenp6wYsWKMoqodQ6SBcoAWdtVj2cY69PXbZuyEgoqBzKea\/OCBYN++tp2jQ3q\/PZQJXppmFeiUiAzRDoa5ohYI7tKl98or900ywg+kNyunlr+hxaoHMgcDfthNf+YIp+3+2NKZ678\/I4XGIXffPNNqtQ+oXUzW0BxX5CnsyEuPW5YY+YJxbPpZMjayCZjld+CL356eE5y4t1MlQPZQEfDBsov2lkOhHjaFG6\/\/fbpD2cBha0fi6dCgLDI6gcRrHPZsLZ4CkwAKR7TxbMb2dbAAC7+MojV+4MPPjj9vaiidR4ucpUCGaPlzzBKy5L8sWPHZpNKuc5vhivEkGobyIo+jwVgfofp7bffTn9MwQY2PmGjjWyr\/H5OCFiBzQY7\/m6nSoFs+vTpIX\/6Ot8Bd4wdG6ZMmRKG6p8NbV6Nx0JW4b1V0Ux9rNZ7Y8PbHsAGdM3IdYLHK\/LqjTZu3NgJlU3rqBTI1Hrer34VsqevpUWS\/lfTp8fooIf2F7296t0zhZtfGQJtitu4NgRKF4o32sg+++yzw8MPPxyADejwDwZlz57+w8\/nhvvuuy99Pw7okPloWfWoHMh4syMSoB2UtPj2hJ5LSDh57NiwW7K0MX\/+\/CSl838ANGrUqJCd+OdLAQq\/peSngQyXccOarI1r8Wx6o41sm+j0DvZQGQ\/6OEDzu9UvBie13CCRxCPw1K+TVDmQadz06dPD4+vXhwOfeCK8kQBudEIrk3hZAFMmABn6bDSfdNJJwbU0m87SbELjixvZcajEI11IJpseZeNGNj6vAJmvDeZQqdwd40GfLQdoIuicMAM8wymgAR3+TlIlQaaBJvdTpkwJAIekDXfywqKHBiAGysFsz6YPNqW\/qhufeD\/\/31HhuzE\/TmmHHxs3Qth38lnhz\/76go7\/7kFhkEG+sbymVb3mNv3ZI3q2I488smmZ\/vQ1k2f5BZhfe2lV+O\/fPpiW+39\/elBYvWZ1Gs+mvfXepvDq79an8zUynaKWQWYtyftj2YkkF1vTmaV8LKVduxoC9dd\/\/uLn4b\/++W\/C\/Yumh9\/csDgNxVE+7dRTT+0UvlI9hUDmPSzzlCqQH2f1aSp1ufHGG9PFTT+0L45G\/f734a4GdF6SJu\/vk3BeQsL9kkVYR97I9U3V\/LBKf\/XV3Uss8QAABXNJREFUX628hsWRpOjo0H8tg0y5KtFKpcvknThxYrDnOWHChLDtttsGq\/WOrcUy5910U7jn66\/DsTm6JIlPSWj0pZeGUQnPuISefOONcMkll4Qo2y2h\/tJvQ0WFQNZsZe3ZeaRHJr3NyrXC58nNmpOnNR7MEkN2Uu2hoa8lkQO2LIngQa2UW\/M2b4HSQAZgtlxMTp3+AQCLl81XrXlO78OvW7cu2B+0xJCXBCBLImvmzg0n77FHuDSheb\/8ZejkkoitorhB7qayIW4TPF+XInF68pvp2fLM2+yfFtFNppF+faUdkfQn3iJUCsgYYO3atSF6FR2\/ZMmS4DRQO8Yo0sAoY6\/wxRdfDGvWrAmPP\/54WLRoUWDcmN9uaF\/TMTo3VX+Ab7UcdXSSyk5DlGVDG\/BxQ54nX5B45ZjfSthIP3n2cjJdW5AbWXoRKgVkRSpStgyj+QyBodSqu3mK7Z9OlQtktpKcleyUTlMMANPZABz15k+W2z0wari5I08zYV\/6gdje6vjx45tRMyDPiAJZNJr1Knc\/4A1ooSYZ6OLFzA0NMYabJkX7ZLPLYApAZ5YJoMVtZ8XQ\/mlMl9YM9aUfiK2vzZgxIz3vaRrQKoCz5Q82yLJlD9p1vDPLLBDIpk2bln4YxRzU\/iZPUUaZwJQdPjtdBv1Aqx2GSiOA4Zkdi5RVGsgYwRaKuxq5K7J3urR275BmGxw9V7P8RfjMWRBZc9CpU6eGZcuWiXaceLDs8NnpAtTf\/FlItzdHvKVh31W8VSoFZOY9cbPYndAX4cHbaqWL8BsqeRuy7shOzjnobETKbJTebhqQ0cHjxHDUqFEhpkvrNO26666F9ZcCsk43sBP6dHicHLsj3ZneYO2EbqC1jBCHR09szz\/\/fOiU\/nwdPVx4yIgPLjymIa1TN6x2aI92KfuOO+4I7bwqPmJAZpLrkd8qvmH8iiuuCHE4YMh2yHDsfTJfSzQN6LT+fN1iefH9NV656BJGXrc4W02aNCl44NCedvWPGJAx3syZM9OJueGbIaV1iniRlStXlqLfzeCDLcqI9XUdy7NvCXgxr9Wwkf6srdrVP6JA1qrxRyR\/CY2uQVaCUWuVvS1Qg6y3PepYCRaoQVaCUWuVvS1Qg6y3PVqK2WqxoOwJDLmW1pKSEcBcg6xgJ1sLs6pvWcTTKnLthcnBAJpXb1DB6g+qWA2ygua2QAlkHvWjCm9M+L5\/PPwb00d6WIOsAAJ4KrsHXrHJio8ZMyZYU8oCj8fzAqPhVChOxmq6VfXs2xo8E5Jv1d3wi4csirxCQEaRn0xVqQZZgZ6xZ+gthYH2CoFx9uzZwQubhtNZs2YFcenNFOu3lqy8k\/UjFt7sAFIg9sYHipvyzegbKp4aZCVa3o9BUG97RggUwpjuuj\/yZaEoA9A2qfvjr2peDbICPaPDR40alf7ySH\/i3vowR7Oh3R9ft+fVICvQw\/YNvfXg7Ye8uDkSku7ND2+YetNUfKRSDbKCPe9FPt8ZMwmPKkzWpcmTFofJODyaqMd0G9peAfdyoIcA8zQPE\/K7jWqQFexRby4AVHzdxtOfV32kyaOWx3Niy3FA+Sbu4tLlA6Mf+QJG62s+MCO9GfJkC7SePoG0GZmh4qkSyIbKBoXLBZb4uo0nQNfSsgoBzmEQ+ULxmO9amjyyCxcuDPFp0atI0qI+vLyekLx8cpZMeEVpVaUaZFXtmS6qVw2yLurMqjalBllVe6aL6lWDrIs6s6pNqUFW1Z7ponrVIOuiziy9KQULqEFW0HC1WPMWqEHWvK1qzoIWqEFW0HC1WPMWqEHWvK1qzoIWqEFW0HC1WPMWqEHWvK1qzoIWqEFW0HCti41ciRpkI7fvB63l\/w8AAP\/\/L9DpwwAAAAZJREFUAwAfIhKvu0xwgwAAAABJRU5ErkJggg==","height":400,"width":534}}
%---
%[output:65907eba]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:8c8dfa1a]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:75b48299]
%   data: {"dataType":"text","outputData":{"text":"    0.0013    0.0084    0.0269    0.0573    0.0917    0.1173    0.1251    0.1144\n\n","truncated":false}}
%---
%[output:5f33ccea]
%   data: {"dataType":"text","outputData":{"text":"    0.0015    0.0098    0.0313    0.0667    0.1067    0.1365    0.1456    0.1332    0.1065\n\n","truncated":false}}
%---
%[output:393fb58c]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 9.706175\n","truncated":false}}
%---
%[output:6db784cd]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 8.456668\n","truncated":false}}
%---
%[output:26ea03f6]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJkAAAByCAYAAABA33P7AAAQAElEQVR4AezdW8hdRZYH8KIfhPHeMl5QE\/ACCqIyDGIgqC8GRBFBzYCOEgiDiiPqeAPBaNQHwRsRFC8PASGjMGpQRBH0JYKiSDOoiDg6Cl5RG9obNghi96866+v97T63b59T5zvnpMSV2rVq1apVq\/67Vu3atc\/3u9\/qf9UDhT3wu1T\/qx4o7IEKssIOrupTqiCrKCjugQqy4i6uDVSQVQwU90AFWXEXj9nAAlSvIFuAQZz1LlSQzfoILYB9FWQLMIiz3oUKslkfoQWwr4JsAQZx1rtQQTbrI7QA9i04yBZghBagCxVkCzCIs96FZSB7991308knn5yOPvrofyB85Y888kgue+WVV4r3bdJtTVpfcQfMWANd\/bcMZCeeeGJ6++2308cff5xuuumm3MXHHnss5\/GVZ+ac\/PPNN9+kG264If30009zYvHfzTSg07iR\/95iuatlIBulmSuuuCKD7swzzxxFfCyZcdoCsI0bN6Yvv\/xyLBtWozKA3X333avRdJE2VwwyDhBO3WUG8owzzkgXX3xxuvzyy3MYVXbfffdlnmtENqw3q5DHR2aaKGunzbaUkRW26VcX4Slrkjauvfba9Nlnn6U33ngjrV+\/Pgn1IbNt27YlW9v12Uov0lazXtSPNOwji+SVhY7I42mnqU+ZOkHy5NQNgF122WV5JsZnh\/ohTw5fX\/nTONx2223L+qXNkA\/96gQ16xrLyKsT+tXTrvaj3kr9t2KQRUPN9L333ktXXXVVHtA1a9akhx56KG3evHkpf+edd6boBMd98cUXuey5555LL7\/8ctKRpr5B1z\/++GPaZ5998mx6\/vnn5\/pNB6i77777Jo5gy7p169Jrr72WmqH++OOPz\/UtCXbu3JnCoVL24VsybNiwIfeL7fQ2SZsPP\/xwXlaQZYs8vjbRq6++mkO1+m+99VY64YQT0lFHHZUBTzbaadYVIfC1Zaly7733ZvlLLrkksUdbyq+\/\/vrMJ4fcUKeddlp65513krb169hjj13Ka49tZIP46fTTT0\/fffdd+vrrr9PPP\/+cjI3yjz76KNuuD2E3Plqp\/waBjL6R6MADD0yHHnpo2nvvvdMRRxyRDO5JJ52U8wcffHAOWVdeeWUCRnTKKaekQw45JDtcB3TEXZRG+G+\/\/fbLMxNRTgQ6DpIflc4666wsqr4LDpW+9NJLqamfnMEzcMp7kVnHTLJ169a8ngXmGDx9\/eSTT\/JA02NAlYWeXnWjrJm6SfSTPfhmZim+FLHbGNB\/+OGHL\/Uj8mR6UVOXfrKTnDH59ttvM+joowcfhR2j+m8iIAMsAGNAm\/baa6\/EyMMOOyxddNFFibPcZe5oQBTO3D3uonbd1ciz77zzzsthx6zGhgCh6yBgMrPI64O+CFlmLbzm4LXBO6yu+r2IPUIZ+9jZtCtu9F71BvGMQ9zoTz31VJ4gLr300gyu119\/PS85AlSD9EQZu9jHTvbiTwRkFA2jW2+9NQmP7rizzz47rV27dqnKIJAuCU3pgn3sFJaCPID0al4oIwNkZm+zgNmJbAzeE088kUO6gcRThgbVVd6LhE\/tBdHRS24lPDOUGdas+\/777ydR5sILL8whdMuWLRl0bqBRdfby31RA9uuvvybhEsIh\/cUXX0xXX331EujwAvWjdmaYnJkVeIfJNcvdsWyJMGTh3F70hrz1m7vVelLof\/DBB3OIihASg\/f555\/n2dtA4qk\/rG7oIIvMigbPjCivTW3TIz8u0U8HW7Ut7JoZ8YBO\/1wPo37+Kw6yX375JS8qGSjmIwvTG2+8MQGdO\/yWW27JA0FmUmRADaxZxp04yoBYdJstzEYGUVj3JCu8te1qy+qL8Nmc9QwecCDXoWNYXfaaGd141ntmwB07duQZkV3ss\/inJ3SOkwaowk6gAi46AUc6CrGnl\/\/6goyzTMsqNhto8hmza9euJCQYVOQaT5n8008\/nT788MMklUdk6EauTz311PT88883m8nXzbYwhIfmpnC7nEyTolw7+hF51+SkyvDlUfDwkTx+L1JGJoh9veTcSIDSLBtUl+\/4kF7+4TNA13c8FDYrI0NePW2wg6w6vfJ4TVJP\/XYd7bAzZLXZ5CmTxw+Z4OEj+b4gi0qrmQpX7tx+IStsi\/BBtjljucYLko8600iFXeHXjAoME29zThQWB5mnrXPPPXfZng7f2LPBVy7fJsCxWy+8Cln24XrJAs6TTz65tO92xx135LbIbt++PfPdUabx2K9rtzXpvO0YYU5YszSwxzXpNuZJXzGQAZEZiJM9uVizxIwilbcGsEDv5TCP5zEDWKOQAThpk8hZP5jyhaQjjzwyb77KCyNS8oN0KJ8kmbW0DdxS+UnqnzddxUBmPSDGW3hbk7S3BQYNgJnALOZJh0MB0ZMiQMk3CS\/kDKY9ObymjGsbtr\/99lveNJb3JMW2Sm\/k2b6fH\/iJv8ahYiALo8wkFvVAF7xhqY1ZG7TD5AKMo8jddddd+X0qOzjO062QVuni7Jd+fuAn\/hrm40HlRUBmPWT3W7i0ZnItRLYJn2zbwJi52vx2PmauNr+ZB0RbAWa4eAritDfffDPdc889+clYSJs00X3NNdfMrX7+YD8\/8VfTpyu9LgIys1c8EnuEdS08tgmfbNvoAE+EvZjZIiw25fFCDqCaYVYewKztPNY367kWgq0ZS9AFF1yQDFIJ3XSW1q8NW0v8NC4VAdm4RqkPPF7SAkos+GPxrjyInBMOZkQvo911Nj7VC4DFDBZ1\/pbWf6flgSIgM+BCYTs8tvNkyPbqLGAIcYDlWIvXNmY98rY+PL2qZ6b04t2d54nVO1LrLoDzVGsbodmu8K1epel5oAjIgEEobIfHdp4M2X7dFeLU8ZQKOOTItx8kAJIcAjpy5NXDa1KUk6k0HQ8UAdl0TK+tzIsHioBMSBMKuz5dzovzqp2jeaAIyIQ0oVC4Ep5cN0NWXOOTHc3UKjWvHigCsnl1RrW7jAe6gqyMNVXrQnpgKiCzZ+W1RXMrQR5\/Ib1aO7XMA8VBBkg2Re15xVosNlfxlS+zqGYWzgPFQeaVkIN7mzZtWnKe10Y333xzPnKtPNX\/FtoDxUHm6fGcc85Z9pGs2cupCO\/2lC+0h2vnyvxFktgnizWYVzs+F\/PqB8+rIueXpnVStY7z6nqgyExmdrIHFmuwfikZsv1cMO4Z\/9DrPaf3ncAfvIVPZ6iDRUA2if6Ne8Y\/bAAwZ+x\/+OGHYNV0yh6YCsicfBAm2+TVU7\/ZxRkx58A8JAiv\/BJPpa6DyPU6469cuwDmG8X9998fq9IqeKA4yIDI2uv+++\/Pv0rjrD+wWJ85otMrXHowaB4+jJOyANX2EZ4zZfgAaasET94rLa+2AqR4TRrliHdTvl5380BxkDHLLHLMMcfkz\/h9iwgMtjBeeOGF\/JNSZJpkW2MUAAQYm3VXcu2A40rk9zRZR68n0efiIDML+fTt8ccfTz5596T57LPPJlsY\/dZJ6jgaPayDwGrmGibXr3xSx4v76Z93vs8LJ9GH4iADBB8l+OE6v7ngI9vrrrsu224m6xUu1QGeCHsxs0VYzJV3\/4MXcjGz4e0urskYHhjlRh9FfXGQhRG33357\/rVD6yRbGoAHTFHeTgFlnDP+bX0ry1fpSXpgaiBbqdGOVJvNLNq7nPFfaXvzJG8taTNbOg92zyzIOG+cM\/7qBznv77uAXqE5ZNqpAZzFgWSXD26dYpHKI7Yi1+2+rHZ+KiCzVuKU5j6ZPP5qOyDaNzgxSK4NIBv\/4z\/\/Kz3zzDPLPuVXrp406sgHBV8Zklcmbebx0Kh8cp740Np\/3ZCkKGxlr2ty9A4iMr1sGVSna1lxkAGSIz1Cn7UYsk\/GYHzlrleDDBBnI4NjkAJUygzk\/737hxRlypG8ASIb+SYQleMHyZOX4km1qc9S+SYfry0febLq\/dPvD5Fk8LP1X\/7tunTcmf+egac+UkeaBXf\/I4\/ftB1vd\/FSgjfKNtJShQEXxUHmyXBWj\/o88MADGUAAYqACVPh8FgMZA4hHhqw6ABh5gw8oSDl+Wz74UvUNtmtEXopCl+vgk488vUH4rvf+\/aHpn485yWUGWuiQktEWkmdj03aAQsqliBzKCsf8pzjIrINm9ahPDGAbVPhNvzYHMIBn4MhEPupEGvxI2\/LaNNgxkCFnoJtgCn67vrZRtOc6iO7QIdWGtpB81AndeM2ZTVt4IRd6u6YlQJZ38b2XjDWYDdhZPOoTTm47M\/iDnNqvTr+6bfnIRxptGWDXbT1tOTKoLYcXslEW+UiDTxYBZXNmk8dvy+F1oSIgM3vt2rUr\/9UPa7B+RIZsF8MnWaeLM1dapy0f+UijPwGEyEfalgt+r7QtG\/lI23WizSiPfFuua74IyLoaU+ulFAM9TV+022znx7VlaiBzPizCp1R+XONr\/fnwwFRA5oRr\/Hiw0GlxK48\/H26qVo7jgeIgc57sgw8+SPHTT4y1DpPHV45XaXE9UBxkAHXcccct+1oJsPxkOr7yku41WwrPfvzFUeySbc2N7ikbWhxk+uMdpFOw69aty399TSqPr7wUWfc5YesNw6C\/BVCq\/ar3bx6YCsg05VSF9ViQPH5Jcs5slO8EStpQdacy313OgmO9EzWLOZfGnjhtC3jylabngeIzmfWXbx6nvR7yznTYC94\/\/+mb7Olh6R\/\/\/53085++Hkn2zyPqnLRcSRtzx8f4pzjILOwt8H1AMoadK64aM1evis6uO9\/\/6R9ezsXD0g9e+e\/0v\/9z\/0iyw3SVKi9lIz\/xV+58x3+Kg8xM5ifQvb\/0lNck7zeVd7R9YDVHux0vivAYM5vwyWn+mIMj4JWeGPgHLfiJvwY6e0hhcZCZybyjjAV\/M8VXPsTGzsUA1e87AY7zlLtyWpf2pDr81HkAdlcsDrLd7axK4gnWbNb+TmBVjNmDGy0KstgIFSL9ZMBq+NlenNnTl+TO+rPB\/hmbUCm7LANKPfB4iLK5zH6kP\/o1KWK7pQzd2tHeOLqLgQzArMW8p\/TTBL44mrQzunQcqLw3Dbvij7B20dWvjkHauHFj+vTTT\/uJdObbmvFKbseOHfkoFd9aV44LhKZB1s9btmzJ+iexiV0EZJzsvSRnWHOZQRgb66Nmh6Z97UGg3w+0TMIWg71hw4bk+4W1a9dOQuUyHR5oHn300fwNq4LmH5KVnwSZ\/X0fS5elhp+Z8PdC5btQEZB1MWRadYDMA4H2DJg1G578JMgNJTQD2iT0DdPRfGoeJtul3Cs5Pyfh6\/8u9dXZo0Am1HgLoOOLQkKbmTlmnkn1i698E2BG9p5ZROqqe9og62rnROrFzDURZTOgxLrXTbN169aJW8NX1npmMsuccdbTxUBmivWnAT2hIHeExbYYL488wVi\/TdxDAxQKlREe3a0GCW9AlZksAjCGAQJAuC5BdI+7pCgCMlOrjVZbB4OIDNkSzumnE6A89QK3v4npG8P169f3E59JfgDMQML6GwAAAl5JREFUAn3SBrrxhElP4XTzE3\/52S\/5LlQEZF0MmVYdaxdrDLv2Ztr4I6zTan\/cdmLQd+7cmc\/miQhonHDWtMnMtW3btuTXMenlJ\/7it6bcSq73OJBxjjcBMcOO4zy6+pEZ2o+8eNrsJ9OFT68IEPZHqk9d9PWq025jXN17JMh6Obbyynmggqycb+dTcwGrK8gKOLWqXO6BCrLl\/qi5Ah6oICvgVI\/\/nsx6kb1BC3cfuHjPWaD5mVNZQVZgSDyxxlOfX\/tes2ZN\/rE6PAA76KCDCrQ6uyoryFZhbGxreFUjXYXmp95kBdnUXZ6SMBnhMq4dhYrwamMVNfNNM+34R5nrZtksXleQTXRUuin7\/vvv01dffZUPCQqvTlbQJLz642MOWdrpxwM+71u9uEau8ZTNKlWQzcDIHHDAAWnTpk3ZEue2fLwR71O9a80Ff\/3He0VhdvPmzcnrH+QaT9lfRWby\/wqymRyW3kbFAUUnWiJcuvYRs7LetVafW0G2+mMwsgXxwbKQKpQGeWL1vnFkRVMWrCCbssPHaU549MCwffv2FOHRwt\/RnMiPo79U3QqyUp4tpNeJCIcI4\/Cns16O5gBgoSbHVltBNrYLByuwMdsOZ\/bHLNalKK5paud71XdYcV5CpT7NEsjYU2kBPVBBtoCDOmtdqiCbtRFZQHsqyBZwUGetSxVkszYiC2hPBdkCDuqsdamCbNZGZJbt6WhbBVlHx9Vqo3uggmx0X1XJjh6oIOvouFptdA9UkI3uqyrZ0QMVZB0dV6uN7oEKstF9VSU7eqCCrKPjVl5tz63xFwAAAP\/\/a4UAQQAAAAZJREFUAwDL+cRxJa8Z1gAAAABJRU5ErkJggg==","height":400,"width":534}}
%---
%[output:148462d7]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJkAAABzCAYAAACLg6BeAAAQAElEQVR4AezdaahdxZYH8OJ9ENr5SaOiJuAACqLSNGIkqF8MCCKCmgZtJRAapxa1nUAkGvWD4EQEZyEgpBVaDIoIgn6J4IQ8GyfExlZwRG14TvhAEPv+Clfcd7997hnr3HPPLXGldq1atWrVqv+uVbt27XP\/9Fv9r3qgsAf+lOp\/1QOFPVBBVtjBVX1KFWQVBcU9UEFW3MW1gQqyioHiHqggK+7iMRuYg+oVZHMwiLPehQqyWR+hObCvgmwOBnHWu1BBNusjNAf2VZDNwSDOehcqyGZ9hObAvjkH2RyM0Bx0oYJsDgZx1rtQQTbrIzQH9i0C2bvvvptOOOGEdMQRR\/wd4St\/+OGHc9lLL71UvPuTbmvS+oo7YMYaGNV\/i0B23HHHpbfffjt9\/PHH6YYbbshdfPTRR3MeX3lmrpB\/vvnmm3Tdddeln376aYVY\/IeZBnQaN\/IfLZa7WgSyQZq59NJLM+hOP\/30QcTHkhmnLQDbuHFj+vLLL8eyYTkqA9idd965HE0XaXNokHGAcOouM5CnnXZauuCCC9Ill1ySw6iye+65J\/NcI7JhvVmFPD4y00RZO222pYyssE2\/ughPWZO0cfXVV6fPPvssvf7662n9+vVJqA+Zbdu27ba1XZ+t9CJtNetF\/UjDPrJIXlnoiDyedpr6lKkTJE9O3QDYxRdfnGdifHaoH\/Lk8PWVP43DLbfcsqhf2gz50K9OULOusYy8OqFfPe1qP+oN67+lQBY6+6bvv\/9+uuKKK\/KArlmzJj3wwANp8+bNOX\/IIYekyy67LJ133nnp66+\/Thz3xRdf5LJnn302vfjii0lH+jbyu8CPP\/6Y9tprrzybnnPOObl+0wHE9t5778QRbFm3bl165ZVXUjPUH3PMMbm+JcHOnTtTOFTKPnxLhg0bNuR+GQB6m6TNhx56KC8ryLJFHl+b6OWXX86hWv0333wzHXvssenwww\/PgCcb7TTrihD42rJUufvuu7P8hRdemNijLeXXXntt5pNDbqhTTjklvfPOO0nb+nXUUUftzmuPbWSD+OnUU09N3333XR6bn3\/+ORkb5R999FG2XR\/Cbnw0rP8mArL9998\/HXTQQWnPPfdMhx56aDK4xx9\/fM6vXbs2AdrBBx+cTj755AwuDnG3crgO6Ii7SAf60T777JNnJnKcCHTAKz8onXHGGVlUfRccKn3hhRdSUz85tho45V2kH2aSrVu35vUsMMfgufk++eSTPND0GFBloaerbpQ1UzeJfrIH38wsxZcidhsD+vlbnlzkyXQRGXy69JOd8sbk22+\/zaCjjx58FHYM6r+JgAywAIwBvejmm29OZi6dJ\/P0008nQBTO3nrrraRD+MtNBvPss8\/OYcesxp4AoesgYDKzyOuDvghZZi285uC1wduvrvpdxB6hjH3sbNoVN3pXvaV4zRv9qaeeyhPERRddlMH16quv5iVHgGopPVHGLvaxk734EwEZRUvRr7\/+mi6\/\/PKkcUaQfeyxx3LIMv1fvbB+uummm7CXndwEbgZ2BXkA6TJMKCMDZGZvs4DZiWwM3hNPPJFDuhkbTxlaqq7yLhI+tRdER5fcMDwzlBnWrPvBBx+kE088MS9thNAtW7Zk0LmBBtXZ5b\/iIPvll19yvGfka6+9ltcLBoTh1ggWldYrAT5ykyAzqxl2GF3uWHYIHepZOLOPnfJNsn5zt1pPHnjggen+++\/PoTZCSAze559\/nug0kHh09KsbOsgis6LBMyPKa1Pb9MiPS\/TTwVZtC7tmRjyg0z\/X\/aiX\/4qDbI899shrsgcffDCv29yNBt\/i1MzmDr\/vvvvSc889168PQ5UbUANrlgHoQQbEopt9ZiODaPHsSVZ4azfeltUX4bM56xk84ECuQ0e\/uux1Iwo31ntmwB07duQZkV3ss\/inJ3SOkwaowk6gAi46AUc6CLGny389QcZZpmUVmw00+YzZtWtXEhIMKnKNp6ydpyd4dCPyeMraFGuOeJISHpqbwmELOc5HTTC5K0OnAZPXZvRJKk9PyAUPH8lHWTtVRiaIfW0ZeTcSoLgOWqou3\/EhveEfQNd3PJRtXlDGd2TIq7fASuwgq05XHq9J6qnfrqMddoasNps8ZfL4IRM8fCTfE2RRadzUQviss85a9LhNpxCEr1y+TUKCjVRPPGYTWyRdskD15JNP5qdWa6nbbrstt0V2+\/btma+z7rDbb7894bfbKpUXdtuhslRbs6y3GMiAyHpGWLSoFE7MNEHypmdrpy4HmZ2EO3eq8EEG4KRNImdqdzeaLQ477LC8LybvDpeSX0qH8kmS7RhhTljTf3tck9S\/0nQVA5mp2vRrTSRcmGXMKE0CAiBqO80gmcWEN2WAaB0HUPJNwgs5uuzp4DVlXNtL++233\/K6UN4il20l6L333ktXXnllXkZI5Uu0Mw2d\/MRf41AxkIVRZhKLeqALXr+0ufO8lGyAcSkZZeTuuOOO\/KqLHRx3\/fXX57wZp9IFPX3BT\/zFj6NSEZBZ99iYFC6tmVxHmGym+GTbxsfM1ea38zFztfnNPIBZ9JvhYoHKaW+88Ua666678mxjRp000X3VVVetWP38wX5+4q+mT4e9LgIys1c8rXi6cN0Mk3GNT7ZtdIAnwl7MbBEWm\/J4IQdQzTArD2DWdp64mvVcC8HWTCXo3HPPTQaphG46S+vXxkknncRNY1MRkI1t1YIC4PH+DFBiwR+L94Xi3f+Ts5lrRvSe0F1nT0q9AFjMYLsr5Yv6z7Q8UARkBlwobIbGrmsyZLs6CxhCHGDZJ7OjbtYjb+vD06t6Zsrzzz8\/v0nwxOodqXUXwHmq9YTXbFv4Vq\/S9DxQBGTAIBRGWOyVkiHbq7tCnLqeUgGHHPn2gwRAkkNAR468enhNinIylabjgSIgm47ptZWV4oEiIBPShMJRny5XivOqnYN5oAjIhDShULgSnlw3Q1Zc45MdzNQqtVI9UARkK9UZ1e4yHhgVZGWsqVrn0gNTAZk9K69umlsJ8vhz6dXaqUUeKA4yQLIpas8r1mKxuYqvfJFFNTN3HigOMq+EnKnatGnTbud5bXTjjTfmY8nKU\/1vrj1QHGSeHs8888xF3y+avZyK8G5P+Vx7uHauzF8kiX2yWIN5teNLHi9d8bwqchZq2idV63gvjweKzGRmJ3tgsQbrlZIh26vrvhYCSpu68a6yS9ZRbXKo692kut53An9X\/bnkzVCnioBsEv0DHMd2PCSMcsY\/bAAwx59\/+OGHYNV0yh6YCsjMLmaZNnn11Gt2cUbMOTAPCcIrvwCctEnkus74k9EugPl8bN9998WqtAweKA4yILL2uvfee\/MPhjjrDyzWZ47odIVLDwZmMWfF+CROygKUfJPwQg4gbZXgkfFKy6utAClepel7oDjIdMkscuSRR+YvrH0mBgy2MJ5\/\/vnOT9Rsa8Svy6jfiwKMvcr78Qdpo5+OWt7fA8VBZhby6dvjjz+efI3sSfOZZ55JtjB6rZPUcTS6n\/nAaubqJ9er3CnaXmWVn5Lz\/ZPwQ3GQAYKPEvymmM\/hfWR7zTXXZNvNZF3hUh3gibAXM1uExVz593\/wQi5mNrzfi5dMJnWGfclGVnChb1gnYX5xkIWRt956a\/4hOuskWxqAB0xR3k4BZZwz\/m19w+X\/kDbb2dNrEh4JKb5Uftqk3ZLtDxJNBunz1EA2iDFNGUeqzWYW7aOc8W\/qWuo6BspgIXnyUnnfHXqZ3yQ8v68mxZfKq9Os2ytPBinXRpA8fi9SHrJS7Ub7ynrVW27+zIKMY8Y5469+kPP+vgtoh2YL\/xgog4XkAUYqb13yT\/9yTTr69H\/N6tb+84a8VlGurJnHa9btlQcIpFwbQfL4uaGFf1wDU5DykJU22ye7UCVJyUvlZ4GmAjJrJU5p7pPJ4y+nEwxEDBQ7moBp8vf880HpH488nkj6hz8fmFOyLpp5dQBBqlzalccDRuXk6JHK47MLkeOnIOXkQl4a7SsDrn\/79\/\/IX4OrSxceoo+8tJnHQ734ysal4iADJEd6hD5rMWSfjOH4yl0vB3GsdmOgIo2BjDyZNrXLIt+u25UHCL\/JRmfUixQ\/AEIu6kcacpHSgdQDxv959y+JrLr04CHXQNcGIR8g5U05QDTT0z0uFQeZJ8NZPerD6V0ObA9gl0wvXrturzwgdOnABxCgUR71I8XromZID1m6yErpBKQ2CPGUoaZcAE79cak4yKyDZvWoD6eO68BR6wcQ2vWDP6xtzZAeOkNXpKGzmQcuM5k6Tb58yLseh0qALO\/iey8ZazAbsLN41CecOo4DS9UtYVtbZ+QDZNGX4Eca\/FHTIiAze+3atWv3r1tbh3URGbKjGl\/rTcYDvZYNk9GeyhxanJRxVc90PDCpsNjL2iIzWVdjzodF+JTKd8lV3vQ9MKmw2MvyqYDMCdf48WBh0+OxPH4vwyp\/fjxQHGTOk3344Yf5jynE+kvqp6Dwlc+PO2tPujxQHGQAdfTRRy\/6Wgmw\/GQ6vvIuwyqvoAemrLo4yPTHO0inYNetW5f\/MJZUHl95SRKSrQH7fYxS0obVrnsqIONkpyqsx4Lk8UuShwvHuL3GWupjlJI2VN1zvoXhMOMgH6NUIJT1QPGZzPrLN48+TSvblcXavXg3izn8qCSOdAOePPrbX7+RpH7p\/\/3vO+nnv349kOzfBtQ5abmSNuaOj\/FPcZBZ2Fvg+4BkDDuHrurFfK9TBI4VO3r96V9ezHr7pR++9J\/pv\/\/r3oFk++kqVV7KRn7ir9z5Ef8pDjIzmZ9A9\/7SArxJ3m8qH9H2JavFzNUlxGn+mIMj4JWeWPIPWvATf3X5cVBecZCZybyjjAV\/M8VXPqixw8j5fsAZtgiPMbNF+OQ4T7nD07r8c+6rpR4\/DeP3LtniIOtqdFo8gBrkY5Rp2bNa2ykKstijEiL9ZMC0nWybxGzW\/hhl2nas9vaKgQzArMW8p\/TTBL44sm81bYfb8BWi\/VyBD0q0zw7AR6XAb61Z6qnak7rNZfYj\/dGvSRHbrZfp1o72xtFdBGSM9F7S+0lrLoNrMzRC1zgGj1sXqLycD\/DHX\/odV2+zvv5v3Lgxffrpp032RK5tzfDrjh078nk9N7CHl3GB0DTOQ9qWLVuyfuPmFaA+NWWGuS4CsmEMmLasB4FevwI0CVsM9oYNG5KPZNauXTsJlYt0eKB55JFH8ofSCpp\/rVh+EmT29xE2XZYafsvEH6WVH4VWJcg8EHCWAbNmAzz5SZBZW2gGtEno66ej\/dTcT37Ycq\/k\/GaJn5gYtm7ITxtk0e6ypEKNtwDL0nihRoU2M3PMPJNqhq98sWRGdpjBsmdU3cVABv3+NKDFI2KsdZDpVx5ZXI4T64ftdMxcw9abVXkPV26arVu3TtxEvrLWM5NZS4\/zcFEEZFBvo9VT3VJEhuzEPbSEQqEywqO71SDhLVFlJosAjGGAABCuSxDd4y4pioCsRGcnpROgbK2YQf3hnkm0QAAAAmhJREFUVZ+DrV+\/flLqp6InAGaBPukG3XjCpKdwuvmJv\/y2nPwotOpAZu1ijeG1kHAef+l3FOctR50Y9J07d+YDoJYdaJxw1uyHmWvbtm3JT7DSy0\/8xW9NuWGuVx3IOMebgAjj4ziPrl5kGeCXhDxt9pIZhU+vZUbYH6k+jaKvq067jXF1r0qQdTm28n73QIGkgqyAU6vKxR6oIFvsj5or4IEKsgJOrSoXe6CCbLE\/JpLz+O\/JrItsQFu4+8DFe86JNDjjSirICgyQJ9Z46vOT8mvWrEneduAB2AEHHFCg1dlVWUG2DGNjW8OrGukyND\/1JivIJurywZQJkxEu49q5rQivNlZRM9\/UbMc\/ylw3y2bxuoJsBkbl+++\/T1999VU+JCi8OlnBLOHVX7hzyNJOPx7wed\/qxTVyjadsVqmCbAZGZr\/99kubNm3Klji35QuheJ\/qXWsuWPjHe0VhdvPmzcnrH+QaT9mCyEz+X0E2k8PSbVQcUHRsKsKlax8xK+uutfzcCrLlH4OBLYgPloVUoTTIE6v3jQMrmrJgBdmUHT5Oc8KjB4bt27enCI8W\/o7mRH4c\/aXqVpCV8mwhvU5EOEQYJ4yd9XI0BwALNTm22lkC2didmUUFNmbb4cz+mMW6FMU1+9v5rvoOK66UUKlPFWS8UKmoByrIirq3KueBCjJeqFTUAxVkRd1blfNABRkvVCrqgQqyou6dM+UjdqeCbETH1WqDe6CCbHBfVckRPVBBNqLjarXBPVBBNrivquSIHqggG9FxtdrgHqggG9xXVXJED1SQjei44aut3hoVZKt37KfW8\/8HAAD\/\/wadW2YAAAAGSURBVAMACeCLc3PzlUIAAAAASUVORK5CYII=","height":400,"width":534}}
%---
%[output:0c37f300]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:2f798257]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:47f423eb]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:73bb95c2]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:421981d7]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:6d817a68]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 7.779333\n","truncated":false}}
%---
%[output:6cccf0e5]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 6.824562\n","truncated":false}}
%---
%[output:6782c6c8]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 9.706175\n","truncated":false}}
%---
%[output:490ef293]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:5e01c543]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 8.456668\n","truncated":false}}
%---
%[output:15015bec]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 1.623576\n","truncated":false}}
%---
%[output:9d00e040]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 0.585865\n","truncated":false}}
%---
%[output:37f65767]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 1.976063\n","truncated":false}}
%---
%[output:021aacfa]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:0b4dcbaa]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 0.714074\n","truncated":false}}
%---
%[output:4270d036]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:16aab4d4]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:978ccb9e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:44356fa3]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:50734d55]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:8d6c073d]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:818f2c6b]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:77ea5803]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:77c00196]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:986a1ce4]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:58308d16]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:7147d8dc]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:7a2c4c81]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:0ad640f8]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) > 10 percent","truncated":false}}
%---
%[output:45e8d4f8]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:09b2f5f6]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 8                         **","truncated":false}}
%---
%[output:2ede3732]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 9                         **","truncated":false}}
%---
%[output:97b5f683]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:241a1686]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:8896f7bf]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:9cf4f947]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:79755abf]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:49e17bf4]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:941ae129]
%   data: {"dataType":"text","outputData":{"text":"When s = 8, P( W_q > 5 minutes) = 0.13541","truncated":false}}
%---
%[output:264c4b8a]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:87c507b2]
%   data: {"dataType":"text","outputData":{"text":"Lq                 1.8306             1.6236             11.3081           \n","truncated":false}}
%---
%[output:369e5b5a]
%   data: {"dataType":"text","outputData":{"text":"Lq                 0.6455             0.5859             9.2362            \n","truncated":false}}
%---
%[output:0a05ed13]
%   data: {"dataType":"text","outputData":{"text":"L                  8.2306             7.7793             5.4826            \n","truncated":false}}
%---
%[output:49d4d01d]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  2.2882  minutes.","truncated":false}}
%---
%[output:3bd87fe8]
%   data: {"dataType":"text","outputData":{"text":"L                  7.0455             6.8246             3.1356            \n","truncated":false}}
%---
%[output:10cc0b66]
%   data: {"dataType":"text","outputData":{"text":"Wq                 2.2882             1.9761             13.6421           \n","truncated":false}}
%---
%[output:26b62cf9]
%   data: {"dataType":"text","outputData":{"text":"Wq                 0.8069             0.7141             11.4989           \n","truncated":false}}
%---
%[output:2f9b5bd8]
%   data: {"dataType":"text","outputData":{"text":"W                  10.2882            9.7062             5.6574            \n","truncated":false}}
%---
%[output:08a81aaa]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:7ced1923]
%   data: {"dataType":"text","outputData":{"text":"W                  8.8069             8.4567             3.9763            \n","truncated":false}}
%---
%[output:7aeb7c10]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:7139d483]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:99f12283]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  18463","truncated":false}}
%---
%[output:3c2684c4]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  2500","truncated":false}}
%---
%[output:6048f7b3]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  18677","truncated":false}}
%---
%[output:384512bf]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  854","truncated":false}}
%---
%[output:9d4a21ad]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:4cda5438]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  0.80685  minutes.","truncated":false}}
%---
%[output:972fcab7]
%   data: {"dataType":"text","outputData":{"text":"When s = 9, P( W_q > 5 minutes) = 0.045725","truncated":false}}
%---
%[output:171fd0aa]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:8d8105c9]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) < 10 percent","truncated":false}}
%---
%[output:08e64e52]
%   data: {"dataType":"text","outputData":{"text":"The minimum number of servers recommended to meet the goal is s = 9.","truncated":false}}
%---
%[output:4fb123fa]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:430be251]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:98456d83]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:170cd708]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3ec4c492]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
