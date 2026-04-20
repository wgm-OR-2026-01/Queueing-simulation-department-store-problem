%[text] # Run samples of the ServiceQueue simulation
%[text] Collect statistics and plot histograms along the way.
PictureFolder = "Pictures";
mkdir(PictureFolder); %[output:10889ad2]
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
MaxTime = 240;
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



for k = 6:8 %[output:group:77557e48]
    P = zeros(1, k-1);    % initiaizes the row vector the first time
    % clears row vector so I can use this again for the next graph
    % thereafter

     fprintf("***********************************************************************");    %[output:1380e49d] %[output:1040fda0] %[output:8799e9e0]
     fprintf("**                                                                   **"); %[output:045cb6a4] %[output:72b5c461] %[output:17fa3ba1]
     fprintf("**          Theoretical Calculations for P_n, L_q, W_q, L, W         **"); %[output:6377327e] %[output:64d669bd] %[output:44ab8b54]
     fprintf("**                      " + "number of servers k = " + k+ "                      **"); %[output:27ee7da7] %[output:5459e27a] %[output:2300b28e]
     fprintf("**                                                                   **"); %[output:734a7eb4] %[output:51ca3149] %[output:8a1e1f77]
     fprintf("***********************************************************************");  %[output:46ebf05c] %[output:53e2972f] %[output:5c58c9b8]


    disp(" ");  %[output:6ae29494] %[output:485da3a4] %[output:20ff5073]

    %fprintf("The current number of servers in the theoretical calculations is\nk = %d", k);
    

j = 0:(k-1);
terms = ((lambda / mu).^j) ./ factorial(j);
first = sum(terms);
second = (1 / factorial(k)) * (lambda / mu).^k * (1 / (1 - lambda / (k * mu)));
P0 = 1/(first + second);
fprintf("P(0) = %f\n", P0); %[output:81cf0207] %[output:39c2f664] %[output:970d63a1]
P(1) = P0;


%%%  FIND A WAY TO SAVE ALL THE P(Wq??? > 5) \leq .1   info and just print
%%%  that here ***************

nMax = k-1; 
    fprintf("The probability that some cashiers are busy but there is no line:"); %[output:047cc610] %[output:82672b6a] %[output:92ec6764]
for n = 1:nMax    
    
        
        if  n < k             % 1 <= n <= k 
            
            P(n+1) = (1./ factorial(n))*((lambda / mu).^n)*(P0);   
            fprintf("P(%d) = %f\n", n, P(n+1)); %[output:17ee5c3f] %[output:0b34f5a8] %[output:1e7ee527]
 
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
      fprintf("The number of customers waiting, L_q(%d): %f\n", n,   Lq); %[output:9d846153] %[output:7a534ca0] %[output:79dff8df]
      L = Lq + (lambda./mu);                          
      fprintf("The expected number of customers in the system, L(%d): %f\n", n,  L);                 %[output:66ad6c05] %[output:62789f0b] %[output:28068874]
      Wq = (Lq./ lambda);                           
      fprintf("The expected time customers wait before beginning service, W_q(%d): %f\n", n,  Wq);    %[output:3868df94] %[output:6bb97754] %[output:26083681]
      W = (L./ lambda);                           
      fprintf("The  expected time customers spend in the system, including waiting time and service time, W(%d): %f\n", n,  W);  %[output:540d01ae] %[output:09427105] %[output:1f42c1e4]
              



    disp(" ");  % this is also needed for aesthetic reasons  %[output:449e33f3] %[output:4e5b97f8] %[output:0e12defe]
    disp(" "); %[output:670738e9] %[output:32fcec00] %[output:99a1ee9b]



%[output:group:77557e48]
%%
%[text] # Running simulation samples
%[text] This is the most time consuming calculation in the script, so let's put it in its own section.  That way, we can run it once, and more easily run the faster calculations multiple times as we add features to this script.
%[text] Reset the random number generator.  This causes MATLAB to use the same sequence of pseudo-random numbers each time you run the script, which means the results come out exactly the same.  This is a good idea for testing purposes.  Under other circumstances, you probably want the random numbers to be truly unpredictable and you wouldn't do this.
rng("default");
%[text] We'll store our queue simulation objects in this list.
QSamples = cell([NumSamples, 1]);
%[text] The statistics come out weird if the log interval is too short, because the log entries are not independent enough.  So the log interval should be long enough for several arrival and departure events happen.

s = k; 


     fprintf("***********************************************************************");    %[output:025ebee0] %[output:7852f6c4] %[output:8b3f94e3]
     fprintf("**                                                                   **"); %[output:954ec634] %[output:6a3d9e88] %[output:7d3ce198]
     fprintf("**          Simulation Calculations for P_n, L_q, W_q, L, W          **"); %[output:2911ca8a] %[output:81277a28] %[output:726cf92d]
     fprintf("**                      " + "number of servers k = " + k+ "                      **"); %[output:947fd8f4] %[output:63ea1ee8] %[output:298f192a]
     fprintf("**                                                                   **"); %[output:906f3391] %[output:2b03527c] %[output:5f71dd71]
     fprintf("***********************************************************************");       %[output:31b6eba4] %[output:1beb860a] %[output:69f1c02b]

    disp("");
for SampleNum = 1:NumSamples
    fprintf("Working on sample %d\n", SampleNum); %[output:9efef906] %[output:4173d140] %[output:67a71a6c]
    q = ServiceQueue( ...
        ArrivalRate=lambda, ...
        DepartureRate=mu, ...
        NumServers=s, ...
        LogInterval=LogInterval);
    q.schedule_event(Arrival(random(q.InterArrivalDist), Customer(1)));
    run_until(q, MaxTime);
    QSamples{SampleNum} = q;
end

%[output:group:68b20e9e]
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
fprintf("Mean number in system: %f\n", meanNumInSystem); %[output:7786672e] %[output:5e1a3a28] %[output:72543099]
%[text] Make a figure with one set of axes.
fig = figure(); %[output:148d8c3a] %[output:46019640] %[output:0af5b532]
t = tiledlayout(fig,1,1); %[output:148d8c3a] %[output:46019640] %[output:0af5b532]
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
    fprintf("These are the y axis P values:"); %[output:53b1d7eb] %[output:3bb0d340] %[output:4fea133a]
    disp(P); %[output:5bc54032] %[output:69eeabae] %[output:2b1b3318]
    %fprintf("This is PP:");
    %disp(PP);

plot(ax, 0:nMax, P, 'o', MarkerEdgeColor='k', MarkerFaceColor='r'); %[output:148d8c3a] %[output:46019640] %[output:0af5b532]
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
exportgraphics(fig, PictureFolder + filesep + "Number in system histogram.svg"); %[output:group:49c95006]
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
fprintf("Mean time in system: %f\n", meanTimeInSystem); %[output:5121b43f] %[output:3e9d5534] %[output:04849e0b]
%[text] Make a figure with one set of axes.
fig = figure(); %[output:181330aa] %[output:3ae6264a] %[output:0ae5de1f]
t = tiledlayout(fig,1,1); %[output:181330aa] %[output:3ae6264a] %[output:0ae5de1f]
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
exportgraphics(fig, PictureFolder + filesep + "Time in system histogram.svg"); %[output:group:92521b57]
%%





disp(" "); %[output:71d8cead] %[output:5a70cffa] %[output:102e68ff]
fprintf("Here are the averages of the following values."); %[output:7fed3cfb] %[output:059defd7] %[output:02354895]
%fprintf("The current number of servers in the simulation calculations is\ns = %d", s);
fprintf("Number of Customers in system (L): %f\n", mean(NumInSystem)); %[output:80f267a0] %[output:4420b29d] %[output:27021228]
fprintf("Total time customer spends in system (W): %f\n", mean(TimeInSystem)); %[output:2b379222] %[output:02a973b9] %[output:232f268c]
fprintf("Number of customers waiting (L_q): %f\n", mean(NumWaiting)); %[output:92b60631] %[output:314fd5ca] %[output:430f2985]
fprintf("Customer Wait time before service (W_q): %f\n", meanWaitTime); %[output:39b27da2] %[output:0b004020] %[output:9b12f944]




disp(" "); %[output:0989713e] %[output:6a1448d1] %[output:7e171a3e]
disp(" "); %[output:1fe4a0a2] %[output:4b929520] %[output:210f177c]
disp(" "); %[output:7d9f080a] %[output:8c0f05ff] %[output:04c9cfc9]

     fprintf("*****************************************************************************");    %[output:98c7a833] %[output:5178a32c] %[output:29e86ce7]
     fprintf("**                                                                         **"); %[output:2728d0bc] %[output:15c65ac7] %[output:49cd06b0]
     fprintf("**            Comparing Theoretical and Simulation Calculations            **"); %[output:7813ad4a] %[output:9f079c11] %[output:587cd2f7]
     fprintf("**                         " + "number of servers k = " + k+ "                         **"); %[output:88aafae7] %[output:5ba6cdeb] %[output:7a5d0a8e]
     fprintf("**                                                                         **"); %[output:9f15e3f3] %[output:2d6823c5] %[output:8cba8b54]
     fprintf("*****************************************************************************"); %[output:84f22b92] %[output:42d00cdf] %[output:8e44d40e]

Error_1 = (abs(Lq - mean(NumWaiting))./Lq)*100;
Error_2 = (abs(L - mean(NumInSystem))./L)*100;
Error_3 = (abs(Wq - mean(ExpectedWaitingTime))./Wq)*100;
Error_4 = (abs(W - mean(TimeInSystem))./W)*100;


% Header with fixed spacing
fprintf('%-18s %-18s %-18s %-18s\n', 'Value Type', 'Theoretical', 'Simulation', 'Error Percent'); %[output:1f05cb68] %[output:2714eaf5] %[output:748db839]

% Data rows using fixed-width floats
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'Lq', Lq, mean(NumWaiting), Error_1); %[output:615682a9] %[output:3f4ef700] %[output:2d340f4b]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'L', L, mean(NumInSystem), Error_2); %[output:49cc97cd] %[output:544fb213] %[output:96f4b22c]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'Wq', Wq, mean(ExpectedWaitingTime), Error_3); %[output:990e2bc0] %[output:06a44e34] %[output:285f4e07]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'W', W, mean(TimeInSystem), Error_4); %[output:21742aa5] %[output:67dc349c] %[output:82b1dedd]



%fprintf("Customer Wait time before service (W_q) matrix printed out: ");
%fprintf("(W_q): %f\n ", ExpectedWaitingTime);

longWaits = ExpectedWaitingTime(ExpectedWaitingTime > 5);
disp(" ");    %[output:832ea036] %[output:96ec7915] %[output:0eb89c3c]

%fprintf("These are the wait times that are greater than 5 minutes:");
%fprintf("(W_q): %f\n ",longWaits);
fprintf("These are the total number of customer wait times:  " + length(ExpectedWaitingTime)); %[output:6606e9e0] %[output:13e96541] %[output:214b20bc]
fprintf("These are the total number of customer wait times W_q > 5 minutes:  " + length(longWaits)); %[output:51446c1e] %[output:1f869a3d] %[output:3b9f2e27]
P_of_Wq_greatherthan_5min = length(longWaits)/length(ExpectedWaitingTime);

disp(" ");   %[output:557b58b9] %[output:6242446b] %[output:6666462a]
fprintf(2,"The theoretical Wq has us waiting  " + Wq + "  minutes."); %[output:46186fd7] %[output:22e1e226] %[output:0b1203c4]
fprintf("When s = " +s+", P( W_q > 5 minutes) = " + P_of_Wq_greatherthan_5min); %[output:882fd88c] %[output:5b4ae521] %[output:2282bfb7]
disp(" ");  %[output:52abbb84] %[output:606347de] %[output:1b74e0e2]

if s == 6
    fprintf(2,"P(W_q > 5 minutes) > 10 percent "); %[output:6005bcc6]
elseif s == 7
   fprintf(2,"P(W_q > 5 minutes) < 10 percent");   %[output:9c3c0db4]
   fprintf(2, "The minimum number of servers recommended to meet the goal is s = 7.");  %[output:9b79610b]
else 
   fprintf(2,"P(W_q > 5 minutes) < 10 percent");  %[output:1fb3d16a]
end









disp(" "); %[output:047da829] %[output:9eb04ea7] %[output:88f9a29e]
disp(" "); %[output:74cf4542] %[output:22c464e7] %[output:1f9be117]
disp(" "); %[output:2f9b35f9] %[output:25c5ec43] %[output:9dc35d2e]
disp(" "); %[output:9a3883ee] %[output:0e9b0c2b] %[output:40a98266]
disp(" "); %[output:01ef87ca] %[output:2fe0329d] %[output:2ff9c356]



     %P = zeros(1, k-1);    % clears row vector so I can use this again for the next graph
end % this ends the s = k loop %[output:group:65708066]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":45.7}
%---
%[output:10889ad2]
%   data: {"dataType":"warning","outputData":{"text":"Warning: Directory already exists."}}
%---
%[output:1380e49d]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:045cb6a4]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:6377327e]
%   data: {"dataType":"text","outputData":{"text":"**          Theoretical Calculations for P_n, L_q, W_q, L, W         **","truncated":false}}
%---
%[output:27ee7da7]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 6                      **","truncated":false}}
%---
%[output:734a7eb4]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:46ebf05c]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:6ae29494]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:81cf0207]
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.003204\n","truncated":false}}
%---
%[output:047cc610]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:17ee5c3f]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.016664\nP(2) = 0.043340\nP(3) = 0.075146\nP(4) = 0.097719\nP(5) = 0.101658\n","truncated":false}}
%---
%[output:9d846153]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(5): 4.314453\n","truncated":false}}
%---
%[output:66ad6c05]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(5): 9.516013\n","truncated":false}}
%---
%[output:3868df94]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(5): 5.393066\n","truncated":false}}
%---
%[output:540d01ae]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(5): 11.895016\n","truncated":false}}
%---
%[output:449e33f3]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:670738e9]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:025ebee0]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:954ec634]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:2911ca8a]
%   data: {"dataType":"text","outputData":{"text":"**          Simulation Calculations for P_n, L_q, W_q, L, W          **","truncated":false}}
%---
%[output:947fd8f4]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 6                      **","truncated":false}}
%---
%[output:906f3391]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:31b6eba4]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:9efef906]
%   data: {"dataType":"text","outputData":{"text":"Working on sample 1\nWorking on sample 2\nWorking on sample 3\nWorking on sample 4\nWorking on sample 5\nWorking on sample 6\nWorking on sample 7\nWorking on sample 8\nWorking on sample 9\nWorking on sample 10\nWorking on sample 11\nWorking on sample 12\nWorking on sample 13\nWorking on sample 14\nWorking on sample 15\nWorking on sample 16\nWorking on sample 17\nWorking on sample 18\nWorking on sample 19\nWorking on sample 20\nWorking on sample 21\nWorking on sample 22\nWorking on sample 23\nWorking on sample 24\nWorking on sample 25\nWorking on sample 26\nWorking on sample 27\nWorking on sample 28\nWorking on sample 29\nWorking on sample 30\nWorking on sample 31\nWorking on sample 32\nWorking on sample 33\nWorking on sample 34\nWorking on sample 35\nWorking on sample 36\nWorking on sample 37\nWorking on sample 38\nWorking on sample 39\nWorking on sample 40\nWorking on sample 41\nWorking on sample 42\nWorking on sample 43\nWorking on sample 44\nWorking on sample 45\nWorking on sample 46\nWorking on sample 47\nWorking on sample 48\nWorking on sample 49\nWorking on sample 50\nWorking on sample 51\nWorking on sample 52\nWorking on sample 53\nWorking on sample 54\nWorking on sample 55\nWorking on sample 56\nWorking on sample 57\nWorking on sample 58\nWorking on sample 59\nWorking on sample 60\nWorking on sample 61\nWorking on sample 62\nWorking on sample 63\nWorking on sample 64\nWorking on sample 65\nWorking on sample 66\nWorking on sample 67\nWorking on sample 68\nWorking on sample 69\nWorking on sample 70\nWorking on sample 71\nWorking on sample 72\nWorking on sample 73\nWorking on sample 74\nWorking on sample 75\nWorking on sample 76\nWorking on sample 77\nWorking on sample 78\nWorking on sample 79\nWorking on sample 80\nWorking on sample 81\nWorking on sample 82\nWorking on sample 83\nWorking on sample 84\nWorking on sample 85\nWorking on sample 86\nWorking on sample 87\nWorking on sample 88\nWorking on sample 89\nWorking on sample 90\nWorking on sample 91\nWorking on sample 92\nWorking on sample 93\nWorking on sample 94\nWorking on sample 95\nWorking on sample 96\nWorking on sample 97\nWorking on sample 98\nWorking on sample 99\nWorking on sample 100\n","truncated":false}}
%---
%[output:7786672e]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 7.873257\n","truncated":false}}
%---
%[output:53b1d7eb]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:5bc54032]
%   data: {"dataType":"text","outputData":{"text":"    0.0032    0.0167    0.0433    0.0751    0.0977    0.1017\n\n","truncated":false}}
%---
%[output:1040fda0]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:5121b43f]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 9.859197\n","truncated":false}}
%---
%[output:181330aa]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAbcAAAFJCAYAAAAYD2OCAAAQAElEQVR4AeydX6gUSb7n49xHR7EXFgV1FnSFeRCVhbUVhPbFHoSZRrCZBV2hGVlcZRx0xz8XHwTBB9mjXmzGRq8PDs24CrdpmUPT0KAvCoJ\/drmo9MAsrsK0CsrA7Ubx1fWTdpzJk6eqTp3KrKrIrI8YJzPjzy8iPpEV34zIyMx\/eOM\/CUhAAhKQQMMI\/EPwnwQkIAEJSKBhBBS3hjXoUKpjphKQgAQSI6C4JdYgFkcCEpCABMoTUNzKM9SCBCRQnoAWJFApAcWtUpwak4AEJCCBFAgobim0gmWQgAQkIIHyBHIWFLccDHclIAEJSKAZBBS3ZrSjtZCABCQggRwBxS0Hw93ZEDCuBCQggXQJKG7pto0lk4AEJCCBHgkobj2CM5kEJFCegBYk0C8Cilu\/yGpXAhKQgASGRkBxGxp6M5aABCQggfIEWltQ3Fpz0VcCEpCABGpMQHGrceNZdAlIQAISaE1AcWvNpRG+Dx48CKtXrw7Lli3r6H79619n4du2bQuvXr3qVPe+hb148SJs2LAhK8e1a9cqy+fcuXPhwIEDk\/bYhwfbSc+a79BmtF2V3AaFhHZoWnvMll1kAAdcHdtxtnUeRHzFbRCUzWMoBOg0xsfHh5L3oDLlouAXv\/hFuHXr1qCyNJ+KCMSLkitXrkyxuH\/\/\/sCF6RRPD2ZNQHGbNbL6JFi5cmW4d+9eePToUeYOHTqUFX7dunXh\/v37mR9hf\/jDH7L9S5cuhblz52ZxBv1nwYIF4fr161k5Nm7cOOjszW+QBMwrI8AFCe6nP\/1pdnHCb5Lf5suXL8Pnn3+exfFP7wQUt97ZNSYlU3dMhzC1xdUko4E4RfinP\/0p4E84jtEQFY9p8CMuafCPjqkVwqKL6WJ4cUt67BCftIRz9cq0Ko5OIF8O4pKGeEVHHYgbr4jZ5u3G+NE+YTjqFMPYRjuE4SgHaQjr5LBD\/Lwr1omw6BdtxXSUnbzxhxtxo8uXgbJ8+OGH4bvvviNq2LlzZza1G7mwhVNMyz5+WeS3f\/L50c4xXsyDuKSJ\/sR\/m2zaf8pKmYmXj8M+ftEeCfM2i\/WnPsQlDY70pIkunw\/hxCVNDGcfP9xszpdiemxHB\/8Y3mpLGWPcVlv4UedWab\/55pvMe82aNYGLOy4sucDkgvPkyZNZmH96J6C49c5uJFL+7ne\/y64qY2URil\/+8pchP91H55o\/5gdPRxvTsCUdHSAdFMezcVzJkpYOK6Yjz3379vV8j\/DOnTth+\/btAdvRJnWIHS4dUnG6j7ibN28OMU5Ml99Sd+zk\/diPU02MphEk\/GLnxj5cbty4wW744IMPshE0HSvcMs8f\/1CGPXv2BMr3o1fLDR09+cApRmAfP8KiH1u40s7s48jjN7\/5TSAuafDDnT17tuV0GZ0yZSYOdaAuOPbxw97z58\/ZDWy\/\/\/77wGhl1apVmR9\/qmwP8pvt+QKT4vlAueBPm7JfpYPPs2fPMpM\/+clPsouSKI6dzq8sgX8gMKNT3GZENNoRmCZhugTHPjTo8CYmJrIpxC1btuAV7t69m3W4dBJ0gvPmzQsxTkxLJ4rLEszyD3ljh6vaOL367bffhsePH0+zRGfLFXAsG1vS5ac7nzx5Ek6dOpXVgTLR2WIoCg4CRT1jWtKfP3+eKOHChQttRfXhw4dZnJiOMlN2Otw41bRp06YsTmTGAfWgPpSDtPnOj\/qSfywn5aLTRSivXr2aCQU2KN\/1t1O7c+bMCcePH8+EO6YlPfv5cpAmOtIShy1+8EHc8KMdaU\/S3rx5k+Bpbv369YE4T58+Da9fv84c+zFi5Ep67MTRSgwnvyrbA+awp\/zUm3zgC2f2iw7RpVzwh3M+3eXLl7Nzu5iG4127dmXnEPFbOdqDURlx8w5Gkc8f\/\/jHydE3cbgwVOAgUc4pbuX4NT41V+SIBW7RokVZfVesWBGWLl2a7ceOOjt4+yd2EnQUjHK4GuUKnQ7jbXCInRz7s3E7duzIRjOkiR0p+706Oj8c6el86GzZx+WFBRGhDjg6HcI7dZLLly8nSojpjh49GhBaOr441QQPOlFEig6YBAgfzCgH5cnzRmjJH5t0ltja9bZTJV0rl+84Y1rSs0\/8vKhyTFkoE\/sLFy7MRIr92La0NW2OXzsX48Q6US\/2lyxZktljlMJoM47mou1oj7bAcUz94cA+rpf2mO35EutNmSkH04lcZMAa5pSJsvTDwZ\/fB8zImzw6XUARrpuZgOI2M6ORjkFnXQSAyNH5Fv05jiMX9qtyjAjofKqyh51OdciLA3Fn4xAdOsWYBkFCWHBxeouOcuvWrVkUxJ5OH8Ghnp988knmzx+EMXZ2HCNO2MF1urLnAoOpP9J04xYvXhwY7eXjUpbZMOd84EIIG9QJxz4XOAgjFwR03oxWWtmusj1a2acsnRyjYEaOMU4UOVgzxYnAxrD8ljYlTjuHSNK++TTswxvu7CPknBN5hnDiPCRc1xsBxa03bqZqQyCKYbwa5co37+LopU3yJLzzHQ9TWvnys88KVDrDdoWljsTDxWk+4uant+LoE1FjapHOFBFgBERcHJ1dHPVhi7Lgj+t0ZY8ovffee0QL5E\/avOvXSCTWifpwDw2R+fnPfx4QLkalp0+fzqbfivXMCtrhT9n26GB6ShDT1pETIynOYSKwj2NfVx8Cilt92qoWJaVjpVOjs2bUQqG5cuUKlqvbTiMO4qbgEBU6ZMqSF6R4ld7uSp6re8KoJ4tBSE+HicCwz2iKURX7iBidPJyOHDmCV8hPpeWZkS8RGBVGget0ZZ8Xg7wIUqZ82bBZpYt1Qsi4h0b98Hs3BRnCn\/\/85yw7Rngwzg66+EPcXtqjC9OTUWAMG85T2DOS+uKLLybvZ7abkaBNoiC22ra7kKBOcKAAXAxwr5rzJ07bxtEc4breCChuvXEzVRsCjGhYiEBwnEZjao1OnC2OsEE6RJaOiw6s23yZHowiTZlJT31InxchjqOjwyKM45gn6eK9OrjAh\/B8XI4ZJcT7XhzTucapS\/LFDo59wgkjDvvRkQ\/L4Fk0EcvBiAO7pKVM1Im6xTRVbqlT7LCxiyDhR\/7UDz\/yZ4TH\/mwcZSZtPI+oT2RBXclnNvaKcZlKpox5+7Q7x\/gTXkxT9pjVmeTBxQDTt3Civagn9S1rf9TTK26jfgb0of5My8URRjTPj5gRTNlOKNrrZksZ6Ji6iVuMgwhxRV1MTx0YjRXjx2PC4urC6MeWzhEu7EdHZxbtt7pSZ1RAfjF+3FIvwjhG4OLIj+PoWpWDTvPixYuBusV4VW\/jtDR244iNMlI\/\/OJojv3ZOMrcS3t0mwdl\/PrrrwPnaT4N7cMIjvC8fxX7\/BZo33yeg2ijKso+LBuzyVdxmw2tmselQ2TqhPs4\/LBidYr+\/JCZTiEunWSMR+eMH9voRzh+xCdd9I82CcMV84zx4pa02CAuNvGnQ+P+Fo59\/HDs44djH79WLm8Tu5SJsrPPNp+G46J\/MT3hsWz5tMV9ykTZiB8d9ovxmKJkqpIOrd2VOvlFG3FLPfK28nHIl\/wJZ8txTMc+foThsENYvm0IJx6OfeJxrhCHuKTBr53Ll4X9GI\/6kx472Cv6Ex792HJMfLYc42ZqD8pLuXHskwbHPn449vFr5SgX5SPf6DgnybdV\/Cr8innOVMYq8hwVG7UXN+7hMEURHcczNV6890CaOMeeT8P0FWHRcZwPd18CZQhwjnJuMRXFlFSvo5kyZTCtBJpOoNbixk1Y3vzA0J4rLbYc49+u4RAqVqgxt00apkv25d50QTiLCGI4W47xb2ezkf5WaiAEmPZiFSFX8APJ0EwkMCIEai1uPPjKTfo4\/cGWY\/xbtR+roBAq7lHEqQbuX7DyDBGLq5XyN+uJxzGrmAhvZVc\/CcyGAOcpF1a4fk97zaZcxpVAkwjUVtwQGt56kL+BTcNwExt\/wjnOO+5xvHnzJrBcPfojXozeWOrL1TNz7jPdV4hp3UpAAh0JGCiBoRGorbjx9D4jrqK4QRJ\/wtnPO8RtbGxsirjFcMQt7ue3iCSjtrisOR\/mvgQkIAEJpEmgtuI2KJy8AgmxZPqyXZ48sMq0pu5W9gUBOcjBc6C55wD9Xbu+sC\/+PRpV3DqAY1Ulz9acOXMm+95Sq6g09MGDB7NvnvF2Ct02WWyTgb+D5p4D9Hf0e636w5T8aitu8RVDraYTeSEp4UXQ3GvjnhvTk8Ww4vRmFLaZHnqlkW\/fvh1OnDiRvf2de3a6S0mx2Lt3b9bctlFa7ZL\/ndhG6bZNsZ3o7+j3sh9Vwn9qK24s\/uA+WFHceBs5\/oQXuSNuY2Nj2QcTYxgrKHk0IC9uCBt+jNo6PfQZbbBFUHnTQL3duuwNDU2rw9q1a2miYBul2762Ubptk+8PYjtlP6jE\/9RW3ODKWx0QIB6K5Zgtx\/hzXHSsjGRZ\/7FjxyY\/Psj76WKnR3yeZ0PY+vXKHfLQDZYA3xRjZMB2sDmbW7cEaBvbqFtaxuuGQK3FjVEV32DihbG88YEtx\/hTeVY6MvePYHGMY5k\/S\/+5GiENQnb69OnsQ5iM4ngOjpelxnDi4Fq9yQR7uvQJ2HEOto16yc026oWaaToRqLW4UbH8A7E8FMsx\/jimJpkvRtA4jo731REXl3+IlpEdx\/gXHf6ERxtuJSABCUggXQK1F7d00VoyCUhAAhLojUD5VIpbeYZakIAEJCCBxAgobok1iMWRgAQkIIHyBBS38gzrbsHyS0ACEmgcAcWtcU1qhSQgAQlIQHHzHJCABMoT0IIEEiOguCXWIBZHAhKQgATKE1DcyjPUggQkIAEJlCdQqQXFrVKcGpOABCQggRQIKG4ptIJlkIAEJCCBSgkobpXirI8xSyoBCUigyQQUtya3rnWTgAQkMKIEFLcRbXirLYHyBLQggXQJKG7pto0lk4AEJCCBHgkobj2CM5kEJCABCZQn0C8Lilu\/yGpXAhKQgASGRkBxGxp6M5aABCQggX4RUNz6RTZFu5ZJAhKQwIgQUNxGpKGtpgQkIIFRIqC4jVJrW1cJlCegBQnUgoDiVotmspASkIAEJDAbAorbbGgZVwISkIAEyhMYgAXFbQCQzUICEpCABAZLQHEbLG9zk4AEJCCBARBQ3AYAebhZmLsEJCCB0SOguI1em1tjCUhAAo0noLg1vomtoATKE9CCBOpGQHGrW4tZXglIQAISmJGA4jYjIiNIQAISkEB5AoO1oLgNlre5SUACEpDAAAgobgOAbBYSkIAEJDBYAorbYHkPKjfzkYAEJDDSBBS3kW5+Ky8BCUigmQQUt2a2q7WSQHkCWpBAjQkobjVuPIsuAQlIQAKtCShurbnoKwEJSEAC5QkMzYLiNjT0ZiwBCUhAAv0ioLj1i6x2JSABCUhgaAQUt6Ghrz5jLUpAAhKQwDsCits7Dv6VgAQkIIEGEVDcGtSYVkUC5QloQQLNIKC4NaMdrYUEJCABCeQIKG45GO5K9S4NoQAAEABJREFUQAISkEB5AilYUNxSaAXLIAEJSEAClRJQ3CrFqTEJSEACEkiBgOKWQiuUKYNpJSABCUhgGgHFbRoSPSQgAQlIoO4EFLe6t6Dll0B5AlqQQOMIJC1ur169Ctu2bQvLli3LHPv4dWqFBw8ehNWrV2fxSXfu3Lm20Qk7cODAtHD8SJt3+E2LqIcEJCABCSRJIGlxO3r0aAbt\/v37AcdB9GO\/6F68eBH27NkTdu\/eHR49ehQmJibC2bNnw7Vr14pRA8I2Pj4+zR\/xfPbsWTh06FBmAzu4kydPTourhwQkIAEJ\/EggsU2y4sYI7M6dO+Hw4cNh7ty5mWMfP8Jacbxy5UpYvHhx2L59exa8cuXKTOguXLgQEC082TICRPSWLFmC1xT3+vXr8PTp07B8+fIp\/h5IQAISkEB9CCQrbs+fPw9jY2Nh4cKFkzSXLl0aECTCJj1zOw8fPgyLFi3KhDB6r1+\/Prx8+TIgWvjdunWLTbh582Z4\/\/33s\/38H2y\/efNmSr75cPclIAEJSCB9AsmKG0LFKGzOnDnTKBJW9GRExnRiqxHXDz\/8EBAt0mzcuDFcunRpigDiH12Mx+gv3nPr5n7b7du3A8L55MmTaKqPW01LQAISGBwB+jX6N2a1BpdruZySFbdy1eo9NcKJGF68eDG758a9PkRzJoH79NNPs8UvX375Ze+Zm1ICEpBAggTo17idc\/DgwQRL17pIiluBy65du8K9e\/cC9+vC23\/c79uxY0e4evVqaHev7220cOLEiWxE+PHHH3Ook0DyBCygBLolQL\/GjNfevXu7TTL0eMmKG9OLDIHjvbI8KcLyx+wjQtxvY+TFcd7Nnz+\/1D007vthI2+zuM8U6rp167J7gsUwjyUgAQnUmQBrHejf1q5dW5tqJCtuCAoLO+I9MIg+fvw4MPdLGMdFh+gxhcj9txjGwpF58+aFVvfuYpz8lulHXN6PMoyNjZUSyLw99yUgAQk0g0C6tUhW3JgWZDXj8ePHs2X8CBb7+BHWCumWLVuyZfzcLyOcaUSW\/DOtyMgOv5ncpk2bpkxB8uzcsWPHwtatW8OCBQtmSm64BCQgAQkkQCBZcYNNfGB71apVAZf3Y5+Hszds2BAQII4RnzNnzmQPbrPScfPmzdlzbqyQJLwbR9xTp04F0mKDoTjCxr24btIbRwISkIAEhk8gaXFjtMVNTN4QgmMfv4gNIbp+\/fqUERWjOhaEEB\/XSZR46wgu2otb7JI2uk42YpoBbM1CAhKQgAS6JJC0uHVZB6NJQAISkIAEphBQ3Kbg8EACDSdg9SQwIgQUtxFpaKspAQlIYJQIKG6j1NrWVQISkEB5ArWwoLjVopkspAQkIAEJzIaA4jYbWsaVgAQkIIFaEFDcEm8miycBCUhAArMnoLjNnpkpJCABCUggcQKKW+INZPEkUJ6AFiQwegQUt9Frc2ssAQlIoPEEFLfGN7EVlIAEJFCeQN0sKG51azHLKwEJSEACMxJQ3GZEZAQJSEACEqgbAcUtxRazTBKQgAQkUIpAJeLG99T4rhrfP9u2bVv2cdFSpTKxBCQgAQlIoASBSsSNj4TyXbVDhw6FW7duZR8WVehKtIpJJVCegBYkMNIEKhG3SHDXrl3h0aNHmSsK3YEDB2I0txKQgAQkIIG+EqhU3PIljUK3ZcuWzPvKlSuB0Zwil+HwjwQkIIH0CdS4hJWLW\/7+G2J29erVMDExkY3mzp8\/HxA5Ba7GZ4xFl4AEJFADApWIW17Q1q1bF7777ruAkDFFee\/evbBy5coMxcaNGwPTlXfv3g2kyTz9IwEJSEACEqiYQCXiFsuEcCFoOIQs+rvthoBxJCABCUigKgKViFtcLcl9tpkKRhxWVpJmpriGS0ACEpCABHohUIm49ZKxaSQggeoJaFECEnhHoBJx4\/7ZRx99FB48ePDOauHvuXPnAg95E68Q5KEEJCABCUigcgKViFvlpdKgBCQgAQkMiUAzsu1Z3F69ehV41RbL\/Vkh+e2334bNmzdnz7Lhl3fj4+Nh69atwftszThprIUEJCCB1An0LG5z584Nly5dyp5f45VbK1asmHyejdWSRcdCktRhWD4JSEACEmgGgZ7FLV99RmRfffXV5PNs+TD3OxIwUAISkIAE+kCgEnHrQ7k0KQEJSEACEuiZQM\/ixspHVkBy3+3x48fZasj8fbbiPnFJ03NJTSgBCbQmoK8EJDCNQM\/ixlQkD2Nz323p0qWB\/eJ9tvwx4aSZVgI9JCABCUhAAhUT6FncKi6H5iQgAQlIYHgEGpdzz+LGFCNTjcXpx3bHxCVN4whaIQlIQAISSI5Az+LGFCNTjfmpx077xCVNcgQskAQkIAEJNI5Az+LWOBIDrJBZSUACEpBAfwkobv3lq3UJSEACEhgCgZ7Fjftn3EfzUYAhtJpZSiCIQAIS6ESgZ3Hj\/hn30XwUoBNewyQgAQlIYBgEeha3YRTWPCUgAQlIoDoCTbakuDW5da2bBCQggRElUKm4xftw+WfduCfH53FGlK\/VloAEJCCBIRCoTNyuXbsW+K4b323LP+\/2wQcfhPXr17f9SvcQ6jycLM1VAhKQgAQGRqAScWNkduHChbBly5ZQ\/G4bxx9++GE4fvx4IN7AamZGEpCABCQwsgQqEbfXr1+Hp0+fhuXLl7cEiT\/hxGsZQU8JSKAbAsaRgAS6JFCJuM2ZMycsXrw4PHz4sGW2+BNOvJYR9JSABCQgAQlUSKAScZs7d244fPhwuHr1ajh37tyU4nGMP+HEmxLogQQkIAEJDJbAiOTWs7gVV0Zu3rw5vHz5MoyPj4f8akmO8d+zZ08gzYhwtZoSkIAEJDBEAj2LW3xDSX5lZKd93mZCmqrryirNvJhyPFMeBw4cmBRgXiHWTnTx\/+ijj1zpORNQwyUgAQkkRqBncUuhHg8ePAj79+8P58+fDwgrW47xb1c+pknv3r0bbt26laVZs2ZN2Ldv37SVnAjbr371q\/DXv\/61naku\/I0iAQlIQALDIFCZuCEGjILyo6j8PmHEqbKSn3\/+eeAxg40bN2Zm2XKMf+ZR+EP+ly9fDkeOHAlxFHno0KFspSdiF6Mz+uOZvTdv3oT58+dHb7cSkIAEJFATApWJG\/fWWBF5\/\/79gGDwzBujqYmJibBkyZJw5syZSUGpgg3PzD179mza4webNm0K+BNezOf58+cBwVq4cOFkECLH6I0VnXiSjmf2GAV+9tlneOkkMFQCZi4BCcyeQCXixoiIqT7eRsKKSJ5riwKzcuXKwCu42o2mQo\/\/eGaOZ+fIq2gCf8KL\/ojb2NhYyItbjBPFjfLzpQNGgTHMrQQkIAEJ1ItAJeJWrDLiwQrJKDC8fusvf\/lLo1dL3r59O7uP9+TJkyIOjyUgAQkMmUC57OnXuHXDwKGcpcGlrkTceDibKclYbMSNfUZKbEfBffrpp9kI9csvvxyF6lpHCUhghAjQrzEDd\/DgwdrUuhJxYyqPKUkWazBFyX2sn\/3sZ+HmzZsZCLbz5s0LiGDmUcEfbCGocToxbxJ\/wvN+7CO63HNrJbqtpjdJ0607ceJEYDrz448\/7jaJ8SQgAQnUggD9Gv3b3r17a1FeClmJuGGIFySzMCMuq2dRCWLHikm2p0+fDoggcatw2Fq0aNG0V3598803AX\/Ci\/kgbmNjYyEvbogx9wvLihuCygrLJUuWFLP1WAISkECtCbAokP5t7dq1talHZeJGjU+ePJmNXhAWRm\/Xr1\/PniVjyzFxqnSffPJJ9sovlu5jly2v+sKf46KjDHyS59ixY5P3\/+IqTxquGN9jCUhAAhKoJ4F\/qGex35WalZinTp0KO3fuzN44wpZj\/InBsn7miXlwm2NcHGEiZowqGbVVPaokH50EShEwsQQkUIpApeLGFB8PayMa0SEuiEypUnZIzJJ9nqeLjuMYnREk88QIWvRjywgzxu80qkQkb9y4EdiSTicBCUhAAvUgUJm4MSXIaIhpvygcbFlowqMAnV6JVQ9UllICEpBArQiMdGErETdGZrzVg7eSFEdJHPNKrOPHj097f+NIk7fyEpCABCTQNwKViBsPa\/NwX7sVh\/gTTry+1UTDEpCABCQggR8JVCJuPFPGUvhWz5yRD\/6EE4\/jJjrrJAEJSEAC6RCoRNxYuHH48OFsWX5+ZSLV5Jjl+YQTDz+dBCQgAQlIoJ8Eeha34spIv8Tdz2bS9mgQsJYSkEBVBHoWNx6IZhk9KyK7ccQlTVUF144EJCABCUigHYGexa2dQf0lIAEJSGB4BMz5HQHF7R0H\/0pAAhKQQIMIVCpuPKi9evXq7FVY8Q0lHOPfIGZWRQISkIAEEidQmbjxhhIWlezevTt7WXK8D8cx\/oQnzmL2xTOFBCQgAQkkSaAScZvpDSW8uYQ3mBAvSQoWSgISkIAEGkWgEnHjzSO8gYQ3kbSigz\/hxGsVrp8ERpiAVZeABPpAoBJx480jvIGEN5G0KiP+hBOvVbh+EpCABCQggSoJVCJuvHlkx44d4cqVK4E3kuQLyDH+hBMvH+a+BCQgAQlUQEAT0whUIm5Y5TtqExMT4ezZs1NWS3KMP+HE00lAAhKQgAT6TaAScWOhCB8lff78ebh3796U1ZIc+7HPfjej9iUgAQlIIE+gEnFjoQgLRri3ljfezH1rJQEJSEACqROoRNxYKMKCkdQra\/kkIAEJSGA0CFQibiwU4ZM2ly5dCr6NZDROHGtZjoCpJSCB\/hKoRNz4\/M2ePXvCkydPAm8jia\/eym83bNgQiNff6mhdAhKQgAQkEEIl4sanbPikTXzlVqst4cQTugQkIAEJVEFAG50IVCJunTIwTAISkIAEJDBoAqXFjYe089OPviB50E1ofhKQgAQkUCRQStwQtviQNlORPKy9f\/\/+aW8pKWZaw2OLLAEJSEACNSLQs7jx4PaNGzcCn7SJD2mz5Rh\/wmvEwaJKQAISkECDCPQsbvHB7SILvwBQJOKxBH4k4EYCEhgYgZ7FrVMJv\/\/++8CruDrFMUwCEpCABCTQLwJ9Ebd+FVa7EpCABEacgNXvkoDi1iUoo0lAAhKQQH0IKG71aStLKgEJSEACXRIoLW7j4+NTvt+2c+fO8PLly2mv4arj67e6ZGg0CUhAAhJIjEDP4sartHilFs+3deOIS5rE6m9xJCABCUiggQR6FrcGsrBKEugDAU1KQALDIKC4DYO6eUpAAhL4kQBfU7l161bo5IjzY3Q3XRJQ3LoEZTQJQIBOxk4IEroqCHA+HTx4MGzbtq2jIw5xq8hzVGwobqPS0tazNAE6FzqZTh0R4cQrnZkGRoIA58rt27fDf\/ovvwvr\/\/v\/bOl+tvG\/BuIQdySgVFRJxa0ikJppPgE6FzqZdh1Rip0QZXakmf65OeffLQz\/ftmq1u4\/rkq\/AgmWUHErNorHEpiBQNuOaMCd0EzChagxkhy1kWY3XIgzQzOPZDBcOG\/auadPn9aGi+JWm1xPzqgAABAASURBVKayoBL4OwE6of\/2m\/\/R8T4Nola3kebfa9jbHlxmEnS4EIe4veXSzFTwgAt82jnC61J7xa0uLfW2nJx87a6ooj9x3kb1\/3AJ9D132vn\/Pvg\/M96roSCpjDQpS78dXDoJOve14vTxl19+WasVitQr\/s6LW+pdli02yKPdtHtkVzafQaVX3AZFumQ+nHhcNbW7oor+xCFuyexMXhMCbYWL+zcDniZNCVk3XD799NOOI9\/UfkudyltlWbthl1JbtyuL4taOTGL+CFY3V1XEIW5ixbc4EkiOwEwjlKH\/lgrE2pU3jkT93U8FprhN5ZH8UVOuqpIHbQEbT6Buv6W25e1yhI74Facz88d1WizSzcmpuHVDqWFxZjrJOeGJ07BqWx0JDJwAvyN+T+3coASFcjB1GW9ftNoSPnBAfcxQccvgjs6fbk5yTnxOdOK2I0NYux9s9CdOu\/RV+pNPzLPMFjtVlmuUbMFuJvbEKcsEG53yGZRYdFMPysrviN9TO0d4N7bKxqEsTLO2m9qs22KRbngobt1QGkAcTr5B\/GjJp5uTnDjEbVV1\/PlRtvvBRn\/iELeVjar8sE8+Mc8yW+xgr6qyjYodmHXzWMJMfLHT6TdAGDY6tTHhqXCnPvyOUhKUtlObDVyAlLS4vXr1KlvNtGzZsuybcZzU+HU6eR88eBBWr16dxSfduXPnpkU\/cODAZHir78zlw7GBw2+aoYo8+BHwo6R+7RzhFWWXmSlzklPebn60xCFulmGf\/mCffLrpQGaKgx3s9VrUbtORBx11GVflCIV6dyoL5e1UN8K7eSyBfIjbyhb+nOPtzv\/oj42Z2rGV\/WH6lfmtzabcsGnXjlWeL7Mp0zDjJi1uR48ezdjcv38\/4DiIfuwX3YsXL8KePXvC7t27A9+Ym5iYCGfPng3Xrl2bjIrY3b17N3u+hThr1qwJ+\/btC1E02T579iwcOnQos0Ec3MmTJydtVL3DD5sTcxR\/tNS93Q8y+hNnJubddCDdxJkpn7Lh1KWbTjx25u222Chblpi+0xJz8icvyh3jt9uW4Yv9bn8DZfJpV\/Ym+HdqR9qwCXWcTR2SFTdGYHfu3AmHDx8Oc+fOzRz7+BHWqpJXrlwJixcvDtu3b8+CV65cmQndhQsXMvFC\/C5fvhyOHDkS4odTETGuauhISfT69evA8fLlyzkcqBu1Hy0dGj86OtBOjjjEHURj0MFyLrRynBfdlKGTDcJw3VzIdBOnm\/LMFGemfChvpweeu+UyUzkIr9NvgHOy1XkS\/XrjAoXe3Ezt2JvV+qZKVtyeP38exsbGwsKFCyfpLl26NCxZsiQQNumZ23n48GFYtGhRJoTRe\/369eHly5cB0SLdmzdvpthE5Bi9kZY0reLgXydHZxR\/YMXtoH9wnbjROVDWmX6UxCFuJ1tVhVVx9duNjTldvCi3mzhV1LubfLqpUxVlqYsNzkcuuma6KBtkfbppx0GWZ9h5JStuiA2jsDlz5kxjRFjRM04nthpx\/fDDD5kgIlxjY2NTxC3aiTaJgx+jP+614fp5v428qnZ164jmdNHRV82onb2ZhLZdurx\/FTby9lLYb2KduuHKhVXxApFj\/HGjyqUbdsOOk6y4DQBMyywQOcTw4sWL2T037vVxD24mgeNE56Tniq6l4QF6+oPrHXYVQluFjd5r0J+UTaxTN6TaXSgyaiP9qHB5\/W\/Pw98e3Q9sqXcdnOJWaKVdu3aFe\/fuBe7Xhbf\/uN+3Y8eOcPXq1dDuXt\/baCH+CLg3wfEwXVU\/uCjYiHbezWZqs50N7M3GzjB5mvfoEmh3ocgrr0aJyl\/\/99Vw85\/\/Mfzrv\/xTbaqdrLgxvUjnx72yIk3Cin6IEPfbGHkVw+bPn59NRXL\/jntuceoxH6+VzRhOOmzE41bbjz\/+OOzduze7J0jHXXQpjOhalbuTXxTs4n2FeNXaKW0Ma2cDm7OxE+0lt7VAjSbQ9kKxy1deNQXOf\/jPH4a6PeidrLghKEUhevz4cUAkCGt10iBQTCFy\/y2G37x5M8ybNy9w7450Y2Nj2f23GM4KSh4NIC1+TD\/i2I8OMRwba32vLsZhxEZHTodNx110+FP2GL8O2yquWtvZqNsPpQ7tZRkl0C8Cc+J98RqJerLixrTg+++\/H44fP54t40ew2MePsFaNuGXLlmwZP\/fLCGcakefcmFZkZMfKyK1bt4Zjx44FRI044+Pj2eMD69at4zBs2rRpyhQk8YhPOtJnkVr8makTZ3qubuI2eULz9oK8m8UJ3tYG9mZhpwVyvSTQFALWow8EkhU36hof2F61alXA5f3Y5+Hs\/BtGEJ8zZ85kD26zynHz5s3Zc24bN24keua4p8bS\/3VvxYw4jNpOnz49+fgAcU+dOhVISzjxEDbSZQba\/LETbwOmIm8uDopTvRwzdV1RFpoZAAHbcQCQzSIjkLS4Mdq6dOlStmqRt4Swj19W8rd\/EKLr169PPpD91itbCMKCEOLjWokSbxshDFdMjw3sEhZdKxvE0w2OAFO+xalejpnuHVwpzKksAduxLEHTd0sgaXHrthKziWfcehJoN+07aqvW6tl6fy+17fh3Fu71l4Di1l++Wq+IQNtpX+\/bVUR4MGZsx8FwNpcQFDfPAgnMmoAJJCCB1Akobqm3kOWTgAQkIIFZE1DcZo2s9wSuFOudnSkl0DQC1qe\/BBS3\/vKdYt2VYlNweCABCUigbwQUt76hnW7YlWLTmegjAQlIoB8ERkPc+kGuB5uuFOsBmkkkIAEJ9EBAcesBmkkkIAEJSCBtAopb2u1j6dIhYEkkIIEaEVDcatRYFlUCEpCABLojoLh1x8lYEpCABMoT0MLACChuA0NtRhKQgAQkMCgCitugSJuPBCQgAQkMjECDxW1gDM1IAhKQgAQSI6C4JdYgFkcCEpCABMoTUNzKM9RCgwlYNQlIoJ4EFLd6tpulloAEJCCBDgQUtw5wDJKABCRQnoAWhkFAcRsGdfOUgAQkIIG+ElDc+opX4xKQgAQkMAwCTRO3YTA0TwlIQAISSIyA4pZYg1gcCUhAAhIoT0BxK89QC00jYH0kIIHaE1Dcat+EVkACEpCABIoEFLciEY8lIAEJlCeghSETUNyG3ABmLwEJSEAC1RNQ3KpnqkUJSEACEhgygUaI25AZmr0EJCABCSRGQHFLrEEsjgQkIAEJlCeguJVnqIVGELASEpBAkwgobk1qTesiAQlIQAIZAcUtw+AfCUhAAuUJaCEdAopbOm1hSSQgAQlIoCICiltFIDUjAQlIQALpEKivuKXD0JJIQAISkEBiBBS3xBrE4khAAhKQQHkCilt5hlqoLwFLLgEJNJSA4tbQhrVaEpCABEaZgOI2yq1v3SUggfIEtJAkAcUtyWaxUBKQgAQkUIaA4laGnmklIAEJSCBJAjUTtyQZWigJSEACEkiMgOKWWINYHAlIQAISKE9AcSvPUAs1I2BxJSCB5hNQ3JrfxtZQAhKQwMgRUNxGrsmtsAQkUJ6AFlInoLil3kKWTwISkIAEZk1AcWuB7MGDB2H16tVh2bJlmTt37lyLWHpJQAISkECqBOogbgNl9+LFi7Bnz56we\/fu8OjRozAxMRHOnj0brl27NtBymJkEJCABCfROQHErsLty5UpYvHhx2L59exaycuXKTOguXLgQXr16lfn5RwISkIAE0iaguBXa5+HDh2HRokVh7ty5kyHr168PL1++DK9fv570c6dmBCyuBCQwUgQUt1xzMzJ79uxZWL58ec733e4PP\/wQnj9\/\/u6gxd+\/\/b\/74W+PWrvX\/\/YuXbs4M4VjN6U4lqW3drYdQ\/A3MPXcqeK3VIWN2Z6bLbrA5LwUt5JNsmTJkrB27drwl2v\/K9z8539s6f71X\/4py6VdnJnCsZtSHMvSuq1T4tLNOZNSeVMqSwd2k7\/vlMo76LLQ39HvZZ1awn8Ut5KNQyOfOHEiXLp0SScDzwHPgcafA\/R39Hslu86+J1fccoi5z8b9Nu675byz3fnz54eFCxdm+8U\/NPS6deuCTgaeA54DTT8H6O+KfWCKx8mK27Bgcb+N+27cf4tluHnzZpg3b16YM2dO9HIrAQlIQAIJE1DcCo2zZcuW8PTp03Dx4sUshAe6ec5tx44dU1ZQZoH+kYAEJCCBJAkoboVmWbBgQThz5kz24DZvKNm8eXP2nNvGjRsLMT1Mn4AllIAERpWA4tai5Xlw+969e9kbSnhLya5du1rE0ksCEpCABFIloLil2jKWSwISSIKAhagnAcWtnu1mqSUgAQlIoAMBxa0DnE5BrKbctm1b9tUA7s2xj1+nNIYNl8CBAweCX3gYbhu0yp1FW\/mvcPhbakVpuH70bbQLfR2O39JwSzRz7mmJ28zlTSbG0aNHs7Lcv38\/4DiIfuzr0iLAj5GXYqdVKkuDsPGS8lOnTk3e4+ZZ0507d\/qi8kROD4SN9qBdWINAf8fjUqlfKCpuPZxA\/CDv3LkTDh8+nD0ewMPf7ONHWA8mTdInAnzCaMOGDeHq1auhLg+f9glFkmZ5hnTFihXZCxBiAT\/55JPw5MmT8Pjx4+jldogEaAdeHH\/o0KGsFPR3PBp148aNpC9AFLesuWb3hxcoj42NTXljydKlS7POk7DZWTN2xQSmmGO0tmbNmkAnqrhNQZPEASuReXUdHWYSBbIQ0wiwevyrr74KPCaVD+R54JS\/lKK45Vury31ez8U331q9sYSwLs0YbQAE6DxPnjw5gJzMoioCXIiMjU29eKzKtnbKE2A25NixY2Hr1q3TBK+89eosKG7VsdSSBCRQkgBfvB8fHw9HjhwZbsdZsh5NTM69NxaV8O5M6sfbnNim6hS3VFvGcklgxAggbCxc4N6ObwRKr\/GZOmYKmUUlXHx8+OGHIeU1BopbD+cQL1duN99MWA8mTSKBkSaQFzamkkcaRg0qz+iNhUBMIada3ATELVU07cvFp2\/evHkT8otHWFHECi\/C2qc0RAISKBKIwnb+\/PmgsBXpDP+Y9mHFMffahl+a7kuguHXPajImq4fef\/\/9cPz48WwpLHPR7ONH2GREdyQggY4EmNbav39\/QNiciuyIamiBq1atyvLmXmi28\/YPX01h9irl+26K29uG6uV\/fGCbhsdhI\/qxrxssAXOrJ4HPP\/888AwV99p480XeMWKoZ62aVWoeAfjiiy\/C3bt3J9\/IdPny5YAfYanWVnHrsWXyN1e5wcqNVvx6NGeyPhOgbWgjp736DHqW5nlMg99PK+dIbpYw+xgdEbt+\/frkW2TYx6+PWZY2rbiVRqgBCUigGQSsRZMIKG5Nak3rIgEJSEACGQHFLcPgHwlIQAISaBKBYYlbkxhaFwlIQAISSIyA4pZYg1gcCUhAAhIoT0BxK89QC8MiYL4SkIAE2hBQ3NqA0VsCEpCABOpLQHGrb9tZcglIoDwBLTSUgOLW0Ia1WukSOHDgwOSbHvJv5Mjv82mR3\/\/+96HCQltoAAAC6UlEQVSO7\/RLl7wlGyUCitsotbZ1TYJA8a0cvJ+Pt6zfv39\/8g0QvE3lt7\/9bajDmyCSgGohJFAgMFBxK+TtoQQkIAEJSKAvBBS3vmDVqATKEzh37tzktCSfG2GK8tSpU4EpyziFyT5fpchPdRKP+PkS8BLimIZtTJeP474EmkRAcWtSa45EXUa7kp999lnYsWNHNn05MTERvv3228BXKZYvX575MbW5ePHisG\/fvuxzTNBCJHnrPp+V4QXFxMEfP4SRfZ0EmkZAcWtai1qfRhPg\/lx8W\/7SpUvDihUrAvfrtm\/fntWbrx988MEHgW9tvX79OjCC4\/Mk+XTEOXz4cCaMfJcrS+gfCTSMgOLWsAa1Os0mwAhtNjVklPbdd9+FTZs2TUkWhfHhw4dT\/EflwHo2n4Di1vw2toYSCExBcq8tOqYyb926JRkJNJaA4tbYprViEnhHYN68eYH7c9xvKzoeS3gXy78SaBaB\/otbs3hZGwnUigAjtPfeey\/cvHlzSrm5F8eqShabTAnwQAINIaC4NaQhrYYEWhFYsGBB2Lp1axgfHw88DhDjcMw+C03Y6iTQNAKKW9NatJn1sVYlCOzatSvwGED+vtuzZ8\/C119\/HRC\/EqZNKoFkCShuyTaNBRsVAtz34nVbLNHP1xlRiq\/fQoTYxy\/GIT7pcOxHf+IQlzTRj8cH8vfbimliPLcSaAoBxa0pLWk9JCCBzgQMHSkCittINbeVlYAEJDAaBBS30WhnaykBCUhgpAj0SdxGiqGVlYAEJCCBxAgobok1iMWRgAQkIIHyBBS38gy10CcCmpWABCTQKwHFrVdyppOABCQggWQJKG7JNo0Fk4AEyhPQwqgSUNxGteWttwQkIIEGE1DcGty4Vk0CEpDAqBKoUtxGlaH1loAEJCCBxAgobok1iMWRgAQkIIHyBBS38gy1UCUBbUlAAhKogIDiVgFETUhAAhKQQFoEFLe02sPSSEAC5QloQQLh\/wMAAP\/\/+u86nAAAAAZJREFUAwCvUltpoXPFgAAAAABJRU5ErkJggg==","height":299,"width":399}}
%---
%[output:71d8cead]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:7fed3cfb]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:80f267a0]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 7.873257\n","truncated":false}}
%---
%[output:2b379222]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 9.859197\n","truncated":false}}
%---
%[output:92b60631]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 2.898188\n","truncated":false}}
%---
%[output:39b27da2]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 3.536028\n","truncated":false}}
%---
%[output:0989713e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:1fe4a0a2]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:7d9f080a]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:98c7a833]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:2728d0bc]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:7813ad4a]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:88aafae7]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 6                         **","truncated":false}}
%---
%[output:9f15e3f3]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:84f22b92]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:1f05cb68]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:615682a9]
%   data: {"dataType":"text","outputData":{"text":"Lq                 4.3145             2.8982             32.8261           \n","truncated":false}}
%---
%[output:49cc97cd]
%   data: {"dataType":"text","outputData":{"text":"L                  9.5160             7.8733             17.2631           \n","truncated":false}}
%---
%[output:990e2bc0]
%   data: {"dataType":"text","outputData":{"text":"Wq                 5.3931             3.5360             34.4338           \n","truncated":false}}
%---
%[output:21742aa5]
%   data: {"dataType":"text","outputData":{"text":"W                  11.8950            9.8592             17.1149           \n","truncated":false}}
%---
%[output:832ea036]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:6606e9e0]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  18370","truncated":false}}
%---
%[output:51446c1e]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  5053","truncated":false}}
%---
%[output:557b58b9]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:46186fd7]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  5.3931  minutes.","truncated":false}}
%---
%[output:882fd88c]
%   data: {"dataType":"text","outputData":{"text":"When s = 6, P( W_q > 5 minutes) = 0.27507","truncated":false}}
%---
%[output:52abbb84]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:6005bcc6]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) > 10 percent ","truncated":false}}
%---
%[output:047da829]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:74cf4542]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:2f9b35f9]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:9a3883ee]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:01ef87ca]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:8799e9e0]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:148d8c3a]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAbcAAAFJCAYAAAAYD2OCAAAQAElEQVR4Aeyde4wV17WnV7du\/ggB2xk5INFYsttonNuoG0W6QEtEQMaN4siycPAlEQTFDhrZECPFNo8R8mBjIwsZ45cGQgdpCCR2o1zHxCixbAUyoblBakAzI+jATUYYLBvQ0L7S2AYTaTK6TH1ldqe6+jzqnKpzTj1+iNVV+7X22t+uU6v2rqpd7df1TwREQAREQARyRqDd9E8EREAEREAEckZAzi1nHdqS5qhSERABEUgZATm3lHWIzBEBERABEYhPQM4tPkNpEAERiE9AGkQgUQJybonilDIREAEREIE0EJBzS0MvyAYREAEREIH4BAIa5NwCMLQrAiIgAiKQDwJybvnoR7VCBERABEQgQEDOLQBDu7UQUF4REAERSC8BObf09o0sEwEREAERqJOAnFud4FRMBEQgPgFpEIFGEZBzaxRZ6RUBERABEWgZATm3lqFXxSIgAiIgAvEJlNYg51aai2JFQAREQAQyTEDOLcOdJ9NFQAREQARKE8i0c7t69aotW7bMOjs7bf78+TYyMjKmlf39\/WXTxmRMOODqxTZsTFh9YuoOHTrk84Efsnbt2mq6m5oOx7TZ1CgAtJU+SPKYoX+D+hpRR6N41KI33M5ayrYyb177oxamjgHHPkK4lvKV8mbauQUb9uGHH9rWrVuDUdqvQIALgc2bN4\/JMX369DHhVgZwaurP+nuAk8TDDz9cv4KMlCxKOzPSHTWZWeo3zm+ei5WaFJXJnBvnRvv2799vSYFBX1Fk165ddu7cOVu5cmVRmpy6dsKePhgYGLCJEyemzr5EDZKywhMYHh62gwcP2qRJk+zAgQP++Wfx4sU+l927d1sSM165cm6QqQaGqwWGv2zJ74RwMJ4rQsJM67z11luj03czZ840OoaRD1Oh5EHI73QFtzhb0p0QDqazT1mXzpYw8Uiwntdff92ffiUPdlU6AFx7yIsE82NDb2+vMdqlDq7waQt1ES4l2IQeJ8H8lCNMGrpd+XLxYV3BcrQJW7lQQQ\/bYDpxldpGutOPnnr6ztlAvYjrc3Qj9D9xCH3ClnzYRbqrnzgnQS7kCYsrg83UH2aHbqeL+rAhrMOFycsVMOGhoSHr6ekx9BN28tFHH40eS+iljEtzW8qQ5oSwSyu3Ddrtyrk2UYZ6iA\/GER8s51hRH3mD4tIog65y7YQhdbiyYWbwIw5Bpzt+yU+9Tj9hBF3oJD4slCcPOmgH6WwJE4+dxCHoJg59f\/3rX4nyJYn+oB50s3U2EUao16+ozJ+gveRHsLFcm1ETroMyQYEtnMkblqNHj9qVK1dsxowZdscdd\/jJ27Zt851cUhd4uXFu06ZN868C+DG\/9tprPqwk\/qDviSeeGFVFhzz66KO2cOHCUedA4s6dO32nx76TcFnicSQcFOwjHIjuB0oYIUw8+0HZuHHjaJ3z5s0reYXvDlKcQrAsttx7773j7ksG85TbxxZsCqbjGJcsWVKzPn5kYV3oXbNmzTh+xAel1rbR5lr7jjrgRFlXN32+aNGicbMCxNMnbMl7zz33+E6k3vaho5RwzAT7k\/pWr15dM3un+8KFC3b\/\/fePHkvEo5++YR8p1ee0i3jSSwnsOCY4NoLpsNy0aZMf9eCDD\/q\/09OnT9v58+f9OP6cOnXKt+e2224bdcbUR1pQoh4ntfQhfIM281vm9wUTVzdtKHde4eIBu9FBOyjDljD7ly5dGh2JnD17lihD\/xe+8AV\/P+n+wG7a5Cu\/8QeWwfPOjWh\/E6Xf\/IwJ\/nEcGLlhq3OKwWOwSnVVk3Pj3GbPnm2rVq3yG8zBWe6Kwc9Q4x83bceWohyMODemkRhS00GccLgaIT0o69ev969GONgZLZHmRpccbByI\/DD48aCPLWGG7OE2EE86+ZjGQldY0MePCpuwjbyUoSzxHOR9fX3m4ihPuwYHB23y5MkExwg2YAuRri2uLPqoj7So4g5qpiCwzXGB3969e32HzZUb6ehkSz5spi7qrNQ2ygSFtlGeLfHV+g4+1OHqDZZ1\/YYeJ\/QpbSAfNlZrnytXy5a+gzl1uHZgI\/WW0sMVMH1FmrMveLzAgN8K+tBBHvIeOXLEPwnXelxSFrl8+bJ9\/PHHvvNyx56zl2OIY4mrdK7W6e\/g7+Xdd99FhS1dutQ\/DqNwLNfOWvvQ9TWMYY1tbW1t\/m+kFB\/f0MAffjezZs3yY5zdbkukc+Q4kRMnTvh85s6dS5IvjegPuNO\/rk1U5BizH5Qo\/RbM7\/Y53qmjnJw8edK6u7td9tEto0EcPhEcF9jIPkLfJeXg2lGYF+EgdQcnJ8ok2oU+rszQNWXKFP\/AZJ+rdLbux8p+WDhpLF++3I\/mPsqKFSv8fXewux8AJyrycvXCljA\/sOCPn4Luh89+KeGg4QRFGicvd2Dx46Ms8fy4+JGxH0U48LEFDvClDPoGPWfIQR08aZJWTdxDKzgq2ssVPc4MXZysypWvp23YXEvfUYf70Tn7sJErS+xy\/ca+E\/qUvnXhetvnypfa0ncwJ4320C726xXKu77EdkYRQV21HpeuLL+PW265xZ9uYqTLtBRx9K070QXr41iFOU6PkxwXLe6kXy9H9NXah+63PGHCBOvo6PCbg7OCedBeP6HMH6eDNvH7Ykt7mFHi98PvCEfJbxvnznnDqUq6PziHIOinDbSF\/XJCH1Xrt3Jl48bDyF0IuWNy3759dc9KBO3JlXOjI5kmooGcnH7zm9+wG0s42Dnog0roEA6IYFyUfcpQ1uV1JxEXjru9du2aXbx40VfjTg5+wPsTDntRkf5jIxlLcSC+VsEZuoOYsvQTDgSpdMVWT9tK2Qx\/+oG6wxKsI5wWNVxv+yrpr7fvyuksxSWY1\/V5MC7KPr+\/7du3j14AclLHydG33H\/ipI8e+p8TurtY4CKOvMyGuAuyejnW2ofljodambuLDtqEo2aLw3jkkUdosjFqclynTp3qz1D4Cd6fpPsjrN+rouL\/qP0WVsIIn74tJ1zccOESLscFAzYSH3T07gKB0T8XA6THkVw5N0AwVObHw\/6ZM2fYlBSu7rjKI5EtYfaTFBwNPzankw7jR+zC7gfEVRZXdVzhBmVl6OlFl9+VD29xwvxQiHc\/JPaRcJi4KOLqDLelXNlgPbSXAzWclxGaayfTJy690hVbI9rm6nXbYB1M6zkb3daNPlz+cifGetrndKZh6\/o86nEZtBnnBCeYcUyjg3RGLFzIsM\/JlNEEv4Xf\/va3xiiHeHdyYx+ph2OtfUg9SUiwTRzHtI024vQ4TnB4zFBQV7idxFWSOP1RSW8wLUq\/BfNnYT93zg3o7qY1++UkeLJmzhcpl7fe+OAPGgfKPRt0uasVd9BSN0IaVzpc8SDsExdVgldEwfuOXDHzg0MPPzh+iOxHEUY5\/DjDbeFJKq7Ywg8YBJ0bU8P8yF09MAiX42LEOTgcIQ7R5Q9uG9G2oH72g3XAC27EM6KkrdhOG4grJaSRh7yOS9T2ldLXqrh6j0t3Je+OXXjSt587OLPgseFO8Dt27PDvbZEHoc1xOFKnGxXU04fUX6+4NrmLasJMP\/J753fAvTVGrDi8Wuqotz+i1lFLvwV1cmxzEVNOuMjBaQbLuH3YsM95D2Gf0S1beMGN\/TiSS+cGUO45lQLjoHKy5sfEicjdUymVP24cN0ipgwPadaK7T0P9CHVgA\/mYxuGHEJyiIT2qMOLgB4QOdKGTOmgv8aRH1UU+WGIL++G24PS4kMBZ4jTJw9U5dSLsE+eEEw9tJ0waeRDaThz1UB\/7Tlw+HAy204ak2ubqCG5pD+2CF9ywj3aTB9tpA\/ulhDTykObspnyl9pG3kcIxx7HnnG2Uumg3Ql5spw0cS3Av1UfkQyiDkI\/8lKNubIApbMmHkA9hH+G+H\/zYZ1srR+qgLtpJPdRXTx9Sf71C\/RyflKd+LgxpC20jDuF3wu+F\/agCJ4T8tfQH+aMIupEo\/RZFX5Q8OEY3w+baxG+GsvQ93NiPI7l0bgDhQQ46jP2gAJWTZDCOsAMdjI+7T\/0vvfTSGDVcyWIDkXQgUxXhugkzJUOeWoUfDg97oCNYljDxpAfjo+xjC3YH8\/IjZqrFOSMeDKG9Lg8\/bsqQz8Wxpe3cQCadsBPsox4Xpk\/CZbGdNpDX5WNLmHjSCccR2kO7wnXTFmyvpps8UdpXTU\/c9HLHfxS99R6X5crR1zxGD1tXP3ndSZ909yCJS4\/KsVQ7qSdOHzobat0Gp0SDow\/aRhvR5y6u2Y8qsEr6PBGsu5x+bA73W7Bc3H1+7\/x2g3qq\/c6CeavtZ9q5uU5hWAyoYGODaeETH\/eyKOOEMOUJs0UPcYQ5qNBFHD8ahtoI+8SRRh7yUoY4toSJv\/\/++\/1XAQgj\/GjJExTqJM0JYZfOCRv7SStV1uULb9FBGSeEg3lq1UvdThdbbEKH0xnkQDqMKEM+wuy7vLAjnXgnlewjD0xdefIS54SwS2NLXtLgj13EuTqpl33iSCMPeSlDHEK7nN2kIaXsD+qinBP0k0Y5J2EbXV63pX7yYg92BW0I1l0u3ulxW3SgC50I9YfrcHnLxVOGsk4IuzKVtuRzZdjCAibhMm6astxokDKURYcTdAf1lGon6UFOrmyQo9ONfvYpE9QFE+IQ9tEBT\/IQV0pII084L\/qph\/igDeX0loun7ehwQjhoB2HS2EaJD+Zhn3KUd4LN2E5aoyRcZ5BP3Doz7dziNl7lRUAEmksgeD\/NTUPVM5pprtWqLYsE5Nyy2GvNsFl1iEATCDD9nOTVehNMVhUZISDnlpGOkpkikAcCwak7pr+YgstDu9SG9BGQc0tfn8giEcgLAbVDBFpGQM6tZehVsQiIgAiIQKMIyLk1iqz0ioAIiIAIxCdQpwY5twrgWFHg1VdfNbYVsilJBERABEQgZQTk3Cp0CE5Nzq0CICWJgAiIQEoJyLmltGNaY5ZqFQEREIF8EJBzy0c\/qhUiIAIiIAIBAnJuARjaFQERiE9AGkQgDQTk3NLQC7JBBERABEQgUQJybonilDIREAEREIH4BOJrkHOLz1AaREAEREAEUkZAzi1lHSJzREAEREAE4hOQc4vPMOsaZL8IiIAI5I6AnFvuulQNEgEREAERkHPTMSACIlCWAKv0DA0NWVVRnswyoo\/LHgAZTpBzy3DnyXQRaCQBTnrr1q2zZcuWSXLMgD6mrxt5LLVCt5xbK6irThHIAAFOeMeOHbMXXnjBBgYGJDlk8KMf\/cjoY\/o6BYdkoibIuSWKU8pEIH8EOjo6rLe3V5JDBnPmzMnfAXujRXJuN0BoIwIiUJ0AV\/hZvP+G3dVbpxx5IiDnlqferKEtyioCtRLAQXB\/Jov34LAb+6O0eWRkxObPn2+HDh2Kkj1ynlr0kve+++6z4eFhX39\/f79\/3\/Pq1at+WH+qE5Bzq85IOURABDwCOAfuz3ztO0\/Y3Eeez4zc1fe9mu4rTZ482QYHB62vr89rdTr+r1y50r\/nJaJqrAAAEABJREFUOXHixHQYlAEr5Nwy0EkyUQTSRGDCl6fYrZ09dmtnRuTOnpL4GA11dnYaMnPmzNFREqMmN3JjnxHU66+\/buQhLyPX8+fP+6M7wsSXG2FR3ukKG0EZyqIDYZ84yixZssROnz5tixYt8keQ2Eq9buTGqJIyiCvn9K9du9aefvrpUfvIQ36XXpStnFtRelrtFAERGCXAyX7fvn3+u2nnzp2zF1980VavXm04ltFMN3Y+\/fRTe\/vtt+3o0aN+\/osXL9r9999v27dvN8ouXLjQ9u7deyN3tA1ObPny5X696Dh16pTNmDHDtmzZYhMmTLA33njDDx84cGDcCBLb16xZY6RRFtvRhU5X+1tvvTVq3\/r1623z5s0l2+by53Er55bHXlWbREAEaiLAFOSgNxXJlGSpgitWrDCmBEmfNWuW4dC6u7v9rPfcc49dunTJ3KjKj6zyh7InT54cdVzonjdvXpVSZp999pnt3r3bVq1aZeigALZjT9DBEnbpc+fOtevXr9vly5fJnjpplEFybo0iK70iIAKpJcCrDe4Vh3qm7aZPn55I2xgpMm2JDVu3bq2q8y9\/+YsxcgzXHw5XVVSADHJuBehkNVEERGAsAUZKvJjOtN7ixYvt4Ycf9u+pBaf2xpZINuScGk526dKl\/vQm04fJ1lJsbXJuRep\/tVUERGAcgW3btpm758V9tXEZGhBBfYwc2fIkZNQqvvjFLxrlzp49O6ZIODwmsaABObeCdryaLQJFJsBDGUwHMoKCA08\/8qoD96cI1ytMD\/KUI\/rQsX\/\/fvvwww\/ZHSdML167ds2Px54o05Jf+tKXjPt\/O3fuHH26k7IHDx60Bx980NelP58TkHP7nIP+ioAIRCOQi1w8hMGDIUwLcr+LR+6feuqp0Yc06m0kenmYA33o5QEQ6gjrI1+wfh4Seemll\/zH\/3GMPLhy1113+a8C8BqABf5RlickXR08Ofnaa6\/Ftj1QRS525dxy0Y1qhAiIQK0EmI7knpsTnAY6cCw8OUk4uE8aQrngVCL5uH\/HfTyX7nTieEgjT1gXelw+8vB6AU9QuqccXTp1IeRxdaDPlQ2WcfVTln0EfUeOHCmc85Nzo\/clIiACkQn863un7F\/PZUeu\/Z9iPQIfuSNbmbEJdcu5NQGyqhCBPBCYNm2asYr8nw+9bkd\/8p8yI\/\/zn17y7cb+PPSD2hCNgJxbNE7KJQKFJ4BzyOq33bAb+wvfiQUCIOeW+85WA0UgOQI4CB6QyJpgd3IUpCkLBOTcstBLslEEREAERKAmAnJuNeFSZhEoJgG1WgSyRkDOLWs9JntFIGcE3n\/\/fduzZ48vhw8fbkrrWOSYT8jwAjQVsuwWCxezJSzJPoFUOzcOPF6EdEI4KnJefOS7RuH8xDl9bktcOJ\/CIiACjSfwzDPP2N133GH\/9oMf2N97cu4b37D5XnjPnj2Nr1w1NJlAc6tLrXPjCooXIHft2uUvKsqWMPHVEOHYSi1lw9Uan6ZggVL3AiTb4AuP1XQrXQREIBkCOLCPN22y9zx1KzyZ4wnbQW8kd9JzdKR7UQ35z0LJQ0ND\/oLJnC9cJXyjzV30MrLjnOHSuLh2aWwJuzTykZ94JHjBzDnrkUceMYQ08gWX\/kIHNhCPHsKS+ARS69z4NhHL2PAmPs1kS5h4wqWEA4MDhHXXSj0dxTpurOfG+m+lyitOBESgOQSYitzsObCXy1RHPOllkmNHc7HME59sWf0DhZ988olNmjTJv5jG8XGuYFkr0nBkfPCTeC6I+VDos88+66\/vyHkHZzl16lS\/LIshcxEddHCU+9rXvuanv\/LKK6j0F2tmh\/KsIMKakW4FEuIl8Qik0rnR2RwcYSdU7aOAHEDgYGXv2bNnsztG+FgfH+2bMmXKmPgcBtQkEUg1gfe90dmTVSwkvZGjt3D1N9988+jiwyyVxdqPrLbP+Yi1Hzdu3GjEU44lrbiQ3rt3r3HewREyI0QaDmrDhg12\/Phx3\/kRh263KDM6nG7SWEvyypUr1tPTQ1CSEIFUOrdKIywOItJLtZ\/RXXD9tXAenBtxy5cvN6YHkODVFWml5NixY\/4BzKrhpdIVJwIiUBsBnNuMKkWqpVcpnlgy5xvOO4zOOGc4cbc+cIB8hmbChAmjdXIBjUMbjQjtcKHOaA3HyXmJRZJxeqFsCsYgkErnFqM9FYtyEDL1wFQDUwulpg9KKXj11VeNq7Q333yzVLLiRCCfBBrcqtNV9JN+++23V8nVvGSmMDlvBKXe+\/WM0hitMWp79913DWfXvJYUo6ZCOTfm1oMraDN9wDw330Lipm+5LmfpHkaEDzzwQLksihcBEaiBwEMPPWTPVcm\/9\/bbbcGCBdbqf4zIGJlxcVzKFm6fMLJjhOfSGY1xIe3C4S2jNEZrv\/zlL41bMDi7cB6F4xFIpXOrdDBxkJEer9l\/K11t+oCc1Nnb22ulHlIhXSICIlA7gY0\/\/ak9XqYY8f\/hoYfKpDY32l0E86CauwhmOpHZHJ5y5NzAOcJNU5K2ZcsW474\/9+bKWcto7ec\/\/7nxIArOrly+jMe3zPxUOjcOJjo8fKXE8J140ushxv01JFiWK6y2tjbDyQXjtS8CItBYAozeZnoO7k6vmt2eHPOE7fzbb7dbNm2yp59+2otpzH\/OIby0zX208DmhVI3cz1+1apX\/8VDuuTHSojyzQehiypIRmEvjPFVtyhIdt912m+HkStWpuHgEUuncaNKDDz5oTBfyCC5htoSJJ1yPcBChw119jYyMGI\/3Ll26dPQpqHr0qowIiEB9BB566CH73fnz1vn739u\/eI6u3ZNBL9xIx+YsxTFx\/wwnxAiLBzzYunTiERd2+SmDEHZpODhuXRCPBMuhM6zblWPEh5NzYW2TI9CenKpkNXFA8Cl1rqy4GmJLmHhqYujvpgUIRxGuvtDhPs\/e60014tiCB2kUPWnNI7tEIIsEeGhkwYIFhqNDstiGemzmgTZGeJqSrIde9TKpdW6YjjPiKsgJYeIRd6VUzjFx5YSQNyjocPrYlisfLKN9ERABEUiKgLswZ9bIvRuXlG7p+RuBVDu3v5mpPREQgeYQUC2NJuAuzAcHB3U7pIGw5dwaCFeqRSAPBNwiBqzEIRnyF3TICwdeYcjDMVqqDXJupagoTgREwH\/1Zc6cOeYWMeAet2SZv6BDXjisW7fO6OOkX3NKw89Hzi0NvSAbRCCFBDjhuQUMeBJQMmB5ZEAf09cpPARjmSTnFgufCotAvglw0uOpYkmv5ZUBfZzHo1jOLeu9KvtFQAREQATGEZBzG4dEESIgAiIgAlknIOeW9R6U\/SIQn4A0iEDuCMi55a5L1SAREAEREAE5Nx0DIiACIiAC8QmkTIOcW8o6ROaIgAiIgAjEJyDnFp+hNIiACIiACKSMgJxbyjokmjnKJQIiIAIiUImAnFslOkoTAREQARHIJAE5t0x2m4wWgfgEpEEE8kxAzi3Pvau2iYAIiEBBCci5FbTj1WwREAERiE8gvRrk3NLbN7JMBERABESgTgJybnWCUzEREAEREIH0EpBzS2\/fhC1TWAREQAREICIBObeIoJRNBERABEQgOwTk3LLTV7JUBOITkAYRKAgBObeCdLSaKQIiIAJFIiDnVqTeVltFQAREID6BTGiQc8tEN8lIERABERCBWgjIudVCS3lFQAREQAQyQUDOLeXdJPNEQAREQARqJyDnVjszlRABERABEUg5ATm3lHeQzBOB+ASkQQSKR0DOrXh9rhaLgAiIQO4JyLnlvovVQBEQARGITyBrGuTcstZjslcEREAERKAqATm3qoiUQQREQAREIGsE5NzS2GOySQREQAREIBaBRJzbyMiIzZ8\/3zo7O23ZsmV29erVWEapsAiIgAiIgAjEIZCIc5s8ebINDg7a+vXrbWhoyHp6euTo4vSKyopAfALSIAKFJpCIc3MEV65caefOnfMl7OjWrl3rsmkrAiIgAiIgAg0lkKhzC1rqHN3ixYv96P379\/ujOTk5H4f+iIAIiED6CWTYwsSdW\/D+G\/fgDh48aAcOHPBHc7t27TKcnBxcho8YmS4CIiACGSCQiHMLOrTe3l778MMPDUfGFOXJkyetu7vbR9HX1+fflztx4oRRxo\/UHxEQAREQARFImEAizs3ZxH02HBqCI3Px2kYhoDwiIAIiIAJJEUjEubmnJbnPVs0w8vBkJWWq5VW6CIiACIiACNRDIBHnVk\/FKiMCIpA8AWkUARH4nEAizo37Z\/fdd58NDw9\/rjX0t7+\/33\/Jm3yhJAVFQAREQAREIHECiTi3xK2SQhEQAREQgRYRyEe1dTs3lthiqS0e9+cJydOnT9uiRYv8d9mIC8rWrVtt6dKlpvts+Tho1AoREAERSDuBup3bxIkTbWBgwH9\/jSW3ZsyYMfo+G09LhoUHSdIOQ\/a1lsCFCxf85ds4npISdLa2VapdBESgFQTqdm5BYxmR\/frXvx59ny2Ypv2KBJR4gwBOaN26df7C28wIJCXoRPeNarQRAREoCIFEnFtBWKmZDSSAAzp27Jh97TtP2NxHnk9E7ur7nqET3Q00XapFQARSSKBu58aTj3zmhivs8+fP+09DBu+zhffJS5kUMpBJKSIw4ctT7NbOnmTkzp4UtayBpki1CIjAOAJ1OzemInkZm\/tud9xxh\/\/Jm\/B9tmCYvJQZZ4EiREAEREAERCBhAnU7t4TtkDoREAEREIHWEchdzXU7N6YYmWoMTz+WC5OXMrkjqAZlmsD7779ve\/bs8eXw4cOZbouMFwER+BuBup0bU4xMNQanHivtk5cyf6taeyLQWgLPPPOM3e1Nqf\/bD35gf+\/JuW98w+Z74T179rTWMNUuAiIQm0Ddzi12zQkoCL5IzoiRh1uIi6KaUWSlJcOi6Kg3j8q1ngAO7ONNm+w9z5QVnszxhO2gN5I76Tk60r0o\/RcBEcgogUw7t03eyQnup06dMoR9F8d+OcGxLVmyxD744INyWRSfYwJMRW72HNjLZdpIPOllkhUtAiKQAQJ1OzccBPfRGC214lUAFmk+fvy4bdiwwVgtBWGfONLKsT906JCxXNj169ft5ptvLpdN8TkiwLtuwRVP\/vCHP9iTVdpH+nPPPTduxZT0vDNXpQFKFoGCE6jbuXH\/jPtorXoV4PLly9bW1mZTpkwZ7UJeSZg2bZqRNhoZ2GHKcvfu3bZr1y7bsWNHIEW7WSHw6UcX7czhX\/ly4czxSGa\/+uqrY1Y+eeKJJ2xGlZKkh8txIacVT6qAU7IIpIRA3c6t1fafPXvWOjo6bMKECeNMIW1cpBfB6A5n3NfX54Wi\/3dX\/rpqj86sETmH3thuhx+927774w32rCff2vR9O+SFcXZW4V941RNWLjldIT9JpM9aun7MSimU41jQcQAhSR4I5LkNmXVuzewUdwX\/5ptvNrNa1RUggAPr9Zxb+AGQYW8k1+U5OtID2cfsTgitevIP3z9JJEkAABAASURBVF5pz43JMT7w8lc67N9\/\/b6xK6VoxZPxoBQjAiklkKhzc\/fheHLRCVM5TAemtP2RzHrhhRf8LyA88MADkfIrU7IEmIo86zkwHvQopZl40kullYub\/sMt9niZROInLvh2mVRFi4AIZIFAYs7NPajBd9uC77vNmzfP5s6dW\/Yr3fVCmj59ul28eNGuXbs2TgVp4yJjRDD9yUMo3M+rW40K1k0A58YDHpUUkF5p9BYu2+U5rzOeg7vTS9jtyTFP2HZ7I7ahJaut1xMvSv9FQAQySqA9CbsZmfGgxuLFiy383TbCCxcutC1bthj5kqgPHTxIwhOPwYdHeGqT+yGkkUeSDwKfjlyM9ABIra3t8hzcgh2\/s3c2\/cye8hzdLzzp88JybLWSVH4RSB+B9iRMYvTEKKrciIl40smXRH3o6O7uttmzZ486TRwnDpQ40sgjyQ8BHvCo1BrSb5rcUSlLybSbvJHatK7Z1uU5OqRkpvREyhIREIGIBNoj5quYjScWOzo6rNxTisSTTr6KimpMdC9s9\/T0GEJxF8c+U6W8i8e9QMKSbBLo8hxPlAdAcFLZbKGsFgERSJpAexIKecSeF6gPHjxo\/f39Y1QSJp508o1JjBlAH4\/2u3t87BPn1PLIP+\/i8U6ei3NbRndHjhwxti5O2\/QS0AMg6e0bWZYxAgUxt27nxmiIUZF7KnLRokV25coV27p1q7k4toSJX716tVGmIFzVzIQJdHmjNz0AkjBUqROBHBNor7dtjIYYFblRU7UteSlTb30qJwJdnoPTAyA6DkRABKIQaI+SSXnqJaBySRPQAyBJE5U+EcgngcScG1OOwWlKpiSDQhp58olRrRIBERABEUgTgcScG\/fWeCKST8+sX7\/eeOeNqcoDBw4YLz9v377dNC2Zpq6XLVkhIDtFQARqJ5CIc2NEduLECWM1Ep5W5L22S5cu+S9t8zQiS3Dt3bu3dutUItUEeGE++CmZOPu8B5nqxso4ERCBTBFIxLmFW8wKITwh6V7aZvmtP\/\/5z3paMgwqw2EcG59\/4cIlCUFXhnHIdBFIOYHimZeIc+PlbKYkHT6cG\/vBpbEIS\/JDAOfG51\/Cn5OZ+8jzYz4TEzXM52TyQ0ctEQERaDWBRJwbU5FMSe7bt88fnXFv7a677rKjR4\/67WM7adKkkt9e8zPoT2YJhD8nc2tnz9jPxEQN63MymT0GZLgIpJFAIs6NhrFA8qxZs+yxxx7z77XxUAnOjicm2b7yyiuGEyRvzkXNyzkBRqxx7i8GyzICzjkuNU8EWkIgMeeG9du2bfO\/e4YTY\/Q2ODhoPDHJljB5JCKQdQLu47VJ3WuUg8v6ESH700ggUeeWxgbKJhFImkCS9xkZBZZ0bkkbLX0iUDACiTo3XgngZW2mIp1wdcvnaArGVc3NMQHdZ8xx56ppuSGQmHPj8zK9vb22dOlSfyqS6UiEB014FWB4eDg30NQQERABEcgAgUKbmIhzY2S2e\/duf1USHiwJEiW8cOFC27Jli\/+gSTBN+yIgAiIgAiLQCAKJODde1maFCVYmKWUk8aSTr1S64kRABERABEQgSQKJODf3Ejdf3C5lHPG85E2+Uul5iFMbREAEREAE0kMgEefGo\/8bNmywgwcPWn9\/\/5jWESaedPKNSVRABERABERABBpAoG7nFn4yUl\/ibkDvSGXBCKi5IiACSRGo27nxUjYvZ\/NEZBQhL2WSMlx6REAEREAERKAcgbqdWzmFihcBEaiNAC9yB5fkiruvl8Jr45+33GrP5wTk3D7noL8NIPDpRxftzOFf+XLhzPEG1JAPlUku58WiCXw+SA4uH8eGWlE\/gUSdGy9qz5w509zqJGwJE1+\/iSqZRQJDb2y3w4\/ebd\/98QZ71pNvbfq+HfLCODvTvzEEklrOi88L8ekgRoJybmMQK1BAAok5N1Yo4aGSVatWjVmhhDDxpOeOrxpUkgAOrNdzbu95qSs8meMJ22FvJNflOTrSvSj9v0EgseW8+LyQPh10g6o2RSeQiHOrtkLJ4sWLjRVMyFd04HlvP1ORZz0H9nKZhhJPeplkRYuACIhAIgQScW6sPMIKJKxEUsoq4kknX6l0xeWHAM7tySrNIV2jt1FI2hEBEWgAgUScGyuPsAIJK5GUspF40slXKl1x+SHw6chFm1GlOdXSqxRXsgiIgAhUJZCIc2PlkRUrVtj+\/ftLrlBCPOnkq2qRMmSewOkqLSD9pskdVXIpWQREIDIBZRxHIBHnhta+vj47cOCA7dy5c8zTkoSJJ518knwT6FrwbXuuShNf\/kqHTeuaXSWXkuMQ4InJuO\/LufJ68jJOT6hsqwi0J1ExD4rwfs3ly5ft5MmTY56WJNzd3Z1ENdKREQLTf7jFHi9jK\/ETPQdYJlnRCRFI8t05vTeXUKdITVMJJOLceFCEB0a4t9ZU61tSmSqtRqDLc15nPAd3p5dxtyfHPGHb7Y3Yhpastl5PvCj9byCBpN6d03tzDewkqW4ogfYktPOgSEeH7qEkwTIvOro8B7dgx+\/snU0\/s6c8R\/cLT\/q8sBxbc3o4sXfn9N5cczpMtSROoD0JjTwowidtBgYGTKuRJEE0Hzpu8kZq3Fvr8hwdko9WJdMKaREBEWgsgfYk1PP5m9WrVxs3nlmNhGW3wjJ\/\/nwjXxL1SYcIiIAIiIAIVCKQiHPjUzZ80qbSp29IJ18lY5QmAiIgAiIQlYDyVSKQiHOrVIHSREAEREAERKDZBGI7t\/7+\/jHvtWmB5GZ3oeoTAREQAREIE4jl3HBs7iVtpiR5WXvNmjXjVikJV5rBsEwWAREQARHIEIG6nRsvbh85csT4pI17SZstYeJJzxAHmSoCIiACIpAjAnU7N\/fidpiFvgAQJqKwCNwgoI0IiEDTCNTt3CpZ+PHHHxtLcVXKozQREAEREAERaBSBhji3RhkrvSIgAiJQcAJqfkQCcm4RQSmbCIiACIhAdgjIuWWnr2SpCIiACIhARAKxndvWrVvHvOf28MMP25UrVyy8DFcWl9+KyFDZRCD3BPR9uNx3ce4aWLdzYyktltTi\/bYoQl7K5I5ghhrE2p\/uA5Rxt3ziKENNl6kxCej7cDEBqnjTCdTt3JpuqSqMRQDHxkcn+ahsEoKuWAYVpnA+Gqrvw+WjH4vUCjm3gvQ2zo2ppSRPUgVBp2Z6BPR9OA+C\/meKgJxbprorvrE6ScVnKA0i0GwCqq92AnJutTNTCREQAREQgZQTkHNLeQfJPBEQAREQgdoJyLmFmSksAiIgAiKQeQJybpnvQjVABERABEQgTEDOLUxEYRGIT0AaREAEWkwg1c7t0KFDY1Y\/IVyN19q1a0fLlFoVJZje2dnp5yWuml6li4AIiIAIZIdAap3b8PCwrVmzxnbt2mWsgMKWMPHl8Pb399uJEyeM1TcoM2vWLHvsscfMfTiV7aVLl2z9+vW+TvIg27ZtK6dS8SIgAiLQGgKqNRaB1Dq3vXv32sKFC62vr89vIFvCxPsRoT8jIyO2b98+27hxo7llvnBiLBOFsyP7tWvXjPD06dMJSkRABERABHJKIJXOzY2wwk7onnvuMUZepIf7g4+jXr9+3aZMmTKahJNj9Hb27Fk\/rlQeP0F\/REAEREAEckUglc6t0giLkRfp4V7AcbW1tY1xbi5P0LkRt3z5cv9eG\/fcPr\/fRmx5YdkqRn8sYVU+l1JEQAREQATSQiCVzq1RcHByn3zyib322mv+PbdTp075I8FqDs6tiP7mm282yjTpFYFCEXAXjFw0xhVddBbq0Inc2EI5t5UrV9rJkyetu7vb+Ddx4kRbsWKFHTx40Co9qPLCCy\/YwMCAPfDAAxSTiEBJAoqMTsBdMCbxhYr\/+OjjJgcXnX1RcqbSuU2YMME6OjqMkVa4I4gnPRzPvTbuuTE9GU4L37sLplPu5ptvDkaN26fO3t5emzZt2rg0RYiACNROIMmvU\/yv4f8u51Z7F+S+RCqdGyOqqVOnjnNu7777rhFPerhncFJtbW0WdG48QcmrAc65Mf2IBMuSv62t9L26YD7ti4AIJEdgwpen2K2dPfHlzp7kjEqFJhmRFIFUOjca9+CDD\/rThe7FbbZMHxJPelh4MnLp0qW2efNmw6mRvnXrVn8EyKiLME9bosNNQZKP\/JSjPHmKLJ9+dNHOHP6VLxfOHC8yCrVdBEQg4wTa02o\/98VefPFFe\/jhh\/0nG9kSJh6beR2A+Xpe3CaMcE+NR\/9xZjwJyajtlVdeMTfS4105dCxatMjXST4cG+UoX2QZemO7HX70bvvujzfYs558a9P37ZAXxtmZ\/omACIhAxgik1rnBEWfECiJOCBOP4LB4yCPsmFhtxOUfHBwcfaGbMgg6bqT7T0yGy5OnaIID6\/Wc23tew1d4MscTtsPeSK7Lc3Ske1H6LwIiIAKZIZBq55YZihk2lKnIs54De7lMG4gnvUyyokVABEQglQTk3FLZLc0zCuf2ZJXqSNforQwkRaeCQJLvzfHenV4tSEW3xjJCzi0WvuwX\/nTkos2o0oxq6VWKK1kEGk4gyffmuJe\/bt06vV7Q8F5rbAVybo3lmwntp6tYSfpNkzuq5FKyCLSOQFLvzc195Hm7q+97xkiwiaO31oHLcc1ybjnu3ChN61rwbXuuSsaXv9Jh07pmV8mlZBFoHYHE3pvj3Tu9O9e6jkyw5vYEdUlVRglM\/+EWe7yM7cRP9BxgmWRFi4AIiEAqCRTOuaWyF1psVJfnvM54Du5Oz47dnhzzhG23N2IbWrLaej3xovRfBERABDJDoD0zlsrQhhLo8hzcgh2\/s3c2\/cye8hzdLzzp88JybA3FLuUiIAINItDeIL1Sm0ECN3kjNe6tdXmODslgE5pksqoRARFIO4H2tBso+0RABERABESgVgJybrUSU34REIFCEOB1AF7oTkJKvVZQCIgtbKScWwvhq2oREIH0EkjyxXC9FN78fpZzaz5z1SgCIpABAkm9GK6XwlvT2cVwbq1hq1pFQAQyTCCxF8P1UnhLjgI5t5ZgV6UiIAIiIAKNJCDn1ki60p0nAmqLCIhAhgjIuWWos2SqCIiACIhANAJybtE4KZcIiIAIxCcgDU0jIOfWNNSqSAREQAREoFkE5NyaRVr1iIAIFJqAXgpvbvfn2Lk1F6RqEwEREIFKBPRSeCU6yafJuSXPVBpFQAREYBwBvRQ+DklDI+TcGoo3nnLWo0tiXTt0XLx4MZ4xBS2tZotAUgT0UnhSJKPpkXOLxqnpuXBsrEe3bNkyS0LQ1fRGqEIREAERaBEBObcWga9WLc6NG9BJTmVUq1PpIiACjSAgna0gIOfWCuo11KmpjBpgKasIFIgAF7\/cckhKuKDOEz45tzz1ptoiAiJQGAJJPn3JrQ9uXeTJweXNuRXmwFZDRUAEik0gqVsWcx953txned58802LMhLMAnk5tyz0kmwUAREQgRCBxG5ZdPbYrTc+yxN1NBhUXUtMAAAOMklEQVQyJZVBObdUdouMaikBVS4CBSUQZTQ4MDCQCTpybpnoJhkpAiIgAo0nEGU02Nvb23hDEqhBzi0BiFIhAiIgAiECCraYgJxbizsgTvWffnTRzhz+lS8XzhyPo0plRUAERCBXBOTcMtqdQ29st8OP3m3f\/fEGe9aTb236vh3ywjg70z8REAERKDiBXDi3ovUhDqzXc27veQ1f4ckcT9gOeyO5Ls\/Rke5F6b8IiIAIFJaAnFvGup6pyLOeA3u5jN3Ek14mWdEiIAIiUAgCcm4Z62ac25NVbCZdo7cqkMYlK0IERCBPBOTcMtabn45ctBlVbK6WXqW4kkVABEQg8wTk3DLYhaer2Ez6TZM7quRSsgiIQNIEpC89BOTc0tMXkSzpWvBte65Kzpe\/0mHTumZXyaVkERABEcgvgfb8Ni2\/LZv+wy32eJnmET\/Rc4BlkhUtAiIgAoUgkF3nVojuKd3ILs95nfEc3J1e8m5PjnnCttsbsQ0tWW29nnhR+i8CIiAChSXQXtiWZ7zhXZ6DW7Djd\/bOpp\/ZU56j+4UnfV5Yji3jHSvzRUAEEiHQnogWKWkJgZu8kRr31ro8R4e0xIhsVyrrRUAEckqgPaftUrNEQAREQAQKTEDOrcCdr6aLgAgkQEAqUklAzi2hbrlw4YINDQ0lJhcvXkzIMqkRAREQgeIRkHNLoM9xbOvWrbNly5YlJuhLwDSpEAEREIFCEsiYc0tnH+Hcjh07Zl\/7zhM295HnE5G7+r6XzsbKKhEQARHIAAE5twQ7acKXp9itnT3JyJ09CVomVSIgAiJQLAJybk3qb1bzZ6V+RF\/NbhL0MtUoWgREIP8E5Nya0MdDb2y3w4\/ebd\/98QZ71pNvbfq+HfLCODrTPxEQAREQgcQJyLkljnSsQhyYvpo9lolCIpB9AmpB2gnIuTWwh5iKPOuN1F4uUwfxpJdJVrQIiIAIiECdBArn3IaHh23mzJnW2dnpS39\/f53oqhfDuT1ZJRvpjO6qZFOyCIiACIhADQSy4NxqaE7lrCMjI7Z69WpbtWqVnTt3zg4cOGA7d+60Q4cOVS5YZ+qnIxdtRpWy1dKrFFeyCIiACIhACQKFcm779++3jo4OW758uY+iu7vbd3S7d++2q1ev+nFJ\/zldRSHpN03uqJJLyY0k8NlnnxkjeraNrEe6oxOgL9Qn0Xk1Kyf98uqrrxrv9jarznrrKZRzO3v2rE2dOtUmTpw4ymvu3Ll25coVu3bt2mhcUjtdC\/TV7KRYxtZTQQE\/2D\/+8Y\/GtkI2JTWRAH2hPmki8IhV0S9ybhFhNSsbI7NLly7Z9OnTx1X5ySef2OXLl8fFuwhWH6m0bqRbB3Lk8ogx9RmUm\/7xcXvcKQptib\/WNXdcGcpzEJG9lE7Sa5Wi6YNP1Da7fBwDlCsnLl9a+wS7025jVPtcvmb3SZ4Y0pao4nhXO7ZdPs5NaZf2tBvYSvumTZtmc+bMMa5UKq0b6daBHP7jsP23dw6Mkf\/9l3bb091n4a9m3\/l3f2f\/tfMf7NrE28bkd+Vxpv\/v391ppXS6PLVsi6YPNlHbfOzIIWv7v1ft9P8YKtkX6EKi6iNvFElaH3UmrbNV+lrVJ1UYVjw+KFtKWsWwlC3l4qLaSL9wTuTc2Mpzc5S65dwqUKIDX3jhBRsYGIgk+599yH71n\/9xnLyza7Pt\/ed\/ts7f\/97+5ac\/tXZPXvfCv339v4zL68qj65+2bza2Li7OFj1F0gcrtXn8sQiXWkQM88+Q46GWfuacyLmxwqkzFUmFcW7cZ+N+G\/fdwuRvvvlmmzJlSjjaD9OJvb29Fle+\/vWv24IFC+yhhx7yJa4+lY\/fJ2IohjoGaj8GOCf6J8eU\/0mtc2sEt+ne\/Tbuu3H\/zek\/evSoTZo0ySZMmOCitBUBERABEcg4gUI5t8WLFxsPf7z22mt+t\/GoMe+5rVixYswTlH6i\/oiACIiACGSWQKGc2+TJk2379u3+i9usULJo0SL\/Pbe+vr7MdqAMr0RAaSIgAkUlUCjnRifz4vbJkyf9FUrOnTtnK1euJFoiAiIgAiKQIwKFc2456js1RQREoAkEVEU2Cci5ZbPfZLUIiIAIiEAFAnJuFeAkmcQTmrwIzr0+hH3ikqxDumojwILZ9EVQ5s+f768YU5sm5U6CAKtp3Hffff46n2F9a9eu9b\/iQV+pj8J0Ghcu1yc8jBf8ugr9Qpj4xllTm+Z0ObfabM9U7k2bNvn2njp1yhACLo59SfMJ8M4j7znRH9x\/RQYHB40Hj5pvTbFr5CS6ZMkS++CDD8aB4LNUJ06cMFbRoI9mzZpljz32WMMWOx9nQEEjKvUJy6Ldcssto31Cv\/AsA880pAWXnFsTeoKrmePHj9uGDRv8Vw54oZx94khrggmqogQBnBsv9tMfJZIV1SQCjKC5yLh+\/bqxoEKwWk6w+\/bts40bN45edKxfv95\/pQdnF8yr\/eQIVOoTauG309HRker3g+Xc6KkGC1c5bW1tY1ZBueOOO4w3\/UlrcPVFUx+pvUwJ80I\/L\/ZHKqBMDSFAP\/DJqV27dtmOHTvG1cHvA6cXXEGIkTWjN06w4wooIjaBan1CBbBP+4WhnBs91WDhQCh3lUNag6uX+hIE+MQRnzpi3VDuFyC6l1MCVIOjGDXTB+XeNcW5tbWNvTB0Jum340gku63WJzg\/Lgz\/9Kc\/jd4HTdv9NojIuUFBUjgCnDS5v8ODPdwvQJYuXWrc92EqrHBA1OCxBBQqS4ALQ1Z6+upXvzr6vvCLL75oy5cvL\/kwUFlFDU6Qc2swYKlPJwFufHMDPPgSP8uzYe3+\/fvZSERABEoQYFqYB6+2bds2mso90xkzZtjevXtH41q9I+fWhB7gvg5XOlzxhKsjLRyncGsIsHg208etqV21liLAvTbuuTHSDqfrtxMm0rowU5ncg2udBeNrToFzG29U3mJK\/UDPnz9vFy5cGPOQSd7aneb28DRY+B4bFx9chOikmZ6e47fT1tZmQefGtDGvBqifWtNPPOE9b968MVOQ7j5cmvpEzq0JxwdTYLNnz7YtW7b47+ZwILBPHGlNMEFVhAj09PT4McEpyK1btxojN6ZY\/ET9aTkBpsC4F7p58+bRl+vVT63tFvekd3AKki+tcGHopvZba+Hntcu5fc6h4X\/dC9ucVBEqdHHsS+IRqLU0J8033njDeIeKJyURngDjkXSmWGrVp\/yNI8B9UR7956KDfmLU9sorr\/jvjDauVmkuR4DfB78Tfi\/0B8LviN8Tv6ty5ZodL+fWJOIcEDzyzFN5CPvENal6VVOCAD\/EwcHB0Se+1CclIDUxilmMI0eOGNtwtTy8wO8Goc\/ou3AehZMnQF+U6hPOXfxe6A8kjX0i55b88SCNIiACmSQgo\/NEQM4tT72ptoiACIiACPgE5Nx8DPojAiIgAiKQJwKtcm55Yqi2iIAIiIAIpIyAnFvKOkTmiIAIiIAIxCcg5xafoTS0ioDqFQEREIEyBOTcyoBRtAiIgAiIQHYJyLllt+9kuQiIQHwC0pBTAnJuOe1YNSsdBFjDkhUcgtLf399y47Br7dq1LbdDBohAowjIuTWKrPQWmgDrh\/KtuDVr1tiBAwdGV0Fhf+fOnUYaeVoBiXr5+nUr6ladItAsAk11bs1qlOoRgVYTYN1QFpI9ePDgmOWkWM6IRWZPnz5tbFttp+oXgbwSkHPLa8+qXS0jwCdBcGqsZl9qDURWVf\/JT35i3\/zmN8fYyHRlcPoyOG3IaIvRXjCOwkwvUoatC8+cOdMI80kf0hBXjs\/F3HvvvTY0NGR8EYG82EtZiQjkiYCcW556sxBtSX8j+fbYlStXrNy3rVh0lhXucXKuNTgfpiuZtmQhWpwPq9\/j0HBsLl+ULXXziRhWaUcXK7jjyHCeONu3337bqJ\/Pk5w8eXLMyDKKfuURgSwQkHPLQi\/JxkwROHv2rE2aNCnyh2gZOTHSe\/HFF0cdDU5o48aN\/ggLR1crAMqig3I4MgS7CEtEoAgE5NyK0MtqY6oJMNLDQL46zdYJ3\/277bbbrFanVItjdXUVbav25p+AnFv++1gtbDIBpiOZGnROq1r1tTqvavrKpfNxyVqnOMvpUrwIpJ2AnFvae0j2ZY5AlBEX99h44IMHPHCGmWukDBaBlBNovHNLOQCZJwJJE+Be16xZs2zfvn2G8wrrd\/fYyENeNx159OjRMVlPnTplH374YdkHU8jcrFEfdUlEIEsE5Nyy1FuyNTMEeM+to6PDFi5caDgzZzj7y5cvt1tuucXWr1\/vR\/PuG\/l4WpJ0InGKPPHIgyAIT1jOmzfPePDE5WFLGfLXIuiaOnWqaZqyFmrKmzUCcm5Z67Fi2pu5VuNABgYGbNWqVbZo0SLjXTOEfeIGBweNUZtr2LZt28bkxaHxnhw60EW+lStX+s4SHehavXq18YQlD5CQXovcc889\/pOYTKHyTlwtZZVXBLJAQM4tC70kGzNLAIfEu2ZBIa5Ug4ivlg8n6PLgIPv6+ox31diiky1hRoOEEZwjThJhnzjyOT3sEycRgTwRkHPLU2+qLSIgAuUJKKVQBOTcCtXdaqwIiIAIFIOAnFsx+lmtFAEREIFCEWiQcysUQzVWBERABEQgZQTk3FLWITJHBERABEQgPgE5t\/gMpaFBBKRWBERABOolIOdWLzmVEwEREAERSC0BObfUdo0MEwERiE9AGopKQM6tqD2vdouACIhAjgnIueW4c9U0ERABESgqgSSdW1EZqt0iIAIiIAIpIyDnlrIOkTkiIAIiIALxCci5xWcoDUkSkC4REAERSICAnFsCEKVCBERABEQgXQTk3NLVH7JGBEQgPgFpEAH7\/wAAAP\/\/uViP\/QAAAAZJREFUAwAsRkbhWb+w9wAAAABJRU5ErkJggg==","height":299,"width":399}}
%---
%[output:72b5c461]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:17fa3ba1]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:64d669bd]
%   data: {"dataType":"text","outputData":{"text":"**          Theoretical Calculations for P_n, L_q, W_q, L, W         **","truncated":false}}
%---
%[output:44ab8b54]
%   data: {"dataType":"text","outputData":{"text":"**          Theoretical Calculations for P_n, L_q, W_q, L, W         **","truncated":false}}
%---
%[output:5459e27a]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 7                      **","truncated":false}}
%---
%[output:2300b28e]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 8                      **","truncated":false}}
%---
%[output:51ca3149]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:8a1e1f77]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:53e2972f]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:5c58c9b8]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:485da3a4]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:20ff5073]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:39c2f664]
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.004706\n","truncated":false}}
%---
%[output:970d63a1]
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.005226\n","truncated":false}}
%---
%[output:82672b6a]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:92ec6764]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:0b34f5a8]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.024479\nP(2) = 0.063665\nP(3) = 0.110386\nP(4) = 0.143544\nP(5) = 0.149331\nP(6) = 0.129459\n","truncated":false}}
%---
%[output:1e7ee527]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.027182\nP(2) = 0.070694\nP(3) = 0.122572\nP(4) = 0.159392\nP(5) = 0.165817\nP(6) = 0.143751\nP(7) = 0.106819\n","truncated":false}}
%---
%[output:7a534ca0]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(6): 1.082949\n","truncated":false}}
%---
%[output:79dff8df]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(7): 0.369048\n","truncated":false}}
%---
%[output:62789f0b]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(6): 6.284510\n","truncated":false}}
%---
%[output:28068874]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(7): 5.570609\n","truncated":false}}
%---
%[output:6bb97754]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(6): 1.353686\n","truncated":false}}
%---
%[output:26083681]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(7): 0.461310\n","truncated":false}}
%---
%[output:09427105]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(6): 7.855637\n","truncated":false}}
%---
%[output:1f42c1e4]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(7): 6.963261\n","truncated":false}}
%---
%[output:4e5b97f8]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:0e12defe]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:32fcec00]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:99a1ee9b]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:7852f6c4]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:8b3f94e3]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:6a3d9e88]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:7d3ce198]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:81277a28]
%   data: {"dataType":"text","outputData":{"text":"**          Simulation Calculations for P_n, L_q, W_q, L, W          **","truncated":false}}
%---
%[output:726cf92d]
%   data: {"dataType":"text","outputData":{"text":"**          Simulation Calculations for P_n, L_q, W_q, L, W          **","truncated":false}}
%---
%[output:63ea1ee8]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 7                      **","truncated":false}}
%---
%[output:298f192a]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 8                      **","truncated":false}}
%---
%[output:2b03527c]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:5f71dd71]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:1beb860a]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:69f1c02b]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:4173d140]
%   data: {"dataType":"text","outputData":{"text":"Working on sample 1\nWorking on sample 2\nWorking on sample 3\nWorking on sample 4\nWorking on sample 5\nWorking on sample 6\nWorking on sample 7\nWorking on sample 8\nWorking on sample 9\nWorking on sample 10\nWorking on sample 11\nWorking on sample 12\nWorking on sample 13\nWorking on sample 14\nWorking on sample 15\nWorking on sample 16\nWorking on sample 17\nWorking on sample 18\nWorking on sample 19\nWorking on sample 20\nWorking on sample 21\nWorking on sample 22\nWorking on sample 23\nWorking on sample 24\nWorking on sample 25\nWorking on sample 26\nWorking on sample 27\nWorking on sample 28\nWorking on sample 29\nWorking on sample 30\nWorking on sample 31\nWorking on sample 32\nWorking on sample 33\nWorking on sample 34\nWorking on sample 35\nWorking on sample 36\nWorking on sample 37\nWorking on sample 38\nWorking on sample 39\nWorking on sample 40\nWorking on sample 41\nWorking on sample 42\nWorking on sample 43\nWorking on sample 44\nWorking on sample 45\nWorking on sample 46\nWorking on sample 47\nWorking on sample 48\nWorking on sample 49\nWorking on sample 50\nWorking on sample 51\nWorking on sample 52\nWorking on sample 53\nWorking on sample 54\nWorking on sample 55\nWorking on sample 56\nWorking on sample 57\nWorking on sample 58\nWorking on sample 59\nWorking on sample 60\nWorking on sample 61\nWorking on sample 62\nWorking on sample 63\nWorking on sample 64\nWorking on sample 65\nWorking on sample 66\nWorking on sample 67\nWorking on sample 68\nWorking on sample 69\nWorking on sample 70\nWorking on sample 71\nWorking on sample 72\nWorking on sample 73\nWorking on sample 74\nWorking on sample 75\nWorking on sample 76\nWorking on sample 77\nWorking on sample 78\nWorking on sample 79\nWorking on sample 80\nWorking on sample 81\nWorking on sample 82\nWorking on sample 83\nWorking on sample 84\nWorking on sample 85\nWorking on sample 86\nWorking on sample 87\nWorking on sample 88\nWorking on sample 89\nWorking on sample 90\nWorking on sample 91\nWorking on sample 92\nWorking on sample 93\nWorking on sample 94\nWorking on sample 95\nWorking on sample 96\nWorking on sample 97\nWorking on sample 98\nWorking on sample 99\nWorking on sample 100\n","truncated":false}}
%---
%[output:67a71a6c]
%   data: {"dataType":"text","outputData":{"text":"Working on sample 1\nWorking on sample 2\nWorking on sample 3\nWorking on sample 4\nWorking on sample 5\nWorking on sample 6\nWorking on sample 7\nWorking on sample 8\nWorking on sample 9\nWorking on sample 10\nWorking on sample 11\nWorking on sample 12\nWorking on sample 13\nWorking on sample 14\nWorking on sample 15\nWorking on sample 16\nWorking on sample 17\nWorking on sample 18\nWorking on sample 19\nWorking on sample 20\nWorking on sample 21\nWorking on sample 22\nWorking on sample 23\nWorking on sample 24\nWorking on sample 25\nWorking on sample 26\nWorking on sample 27\nWorking on sample 28\nWorking on sample 29\nWorking on sample 30\nWorking on sample 31\nWorking on sample 32\nWorking on sample 33\nWorking on sample 34\nWorking on sample 35\nWorking on sample 36\nWorking on sample 37\nWorking on sample 38\nWorking on sample 39\nWorking on sample 40\nWorking on sample 41\nWorking on sample 42\nWorking on sample 43\nWorking on sample 44\nWorking on sample 45\nWorking on sample 46\nWorking on sample 47\nWorking on sample 48\nWorking on sample 49\nWorking on sample 50\nWorking on sample 51\nWorking on sample 52\nWorking on sample 53\nWorking on sample 54\nWorking on sample 55\nWorking on sample 56\nWorking on sample 57\nWorking on sample 58\nWorking on sample 59\nWorking on sample 60\nWorking on sample 61\nWorking on sample 62\nWorking on sample 63\nWorking on sample 64\nWorking on sample 65\nWorking on sample 66\nWorking on sample 67\nWorking on sample 68\nWorking on sample 69\nWorking on sample 70\nWorking on sample 71\nWorking on sample 72\nWorking on sample 73\nWorking on sample 74\nWorking on sample 75\nWorking on sample 76\nWorking on sample 77\nWorking on sample 78\nWorking on sample 79\nWorking on sample 80\nWorking on sample 81\nWorking on sample 82\nWorking on sample 83\nWorking on sample 84\nWorking on sample 85\nWorking on sample 86\nWorking on sample 87\nWorking on sample 88\nWorking on sample 89\nWorking on sample 90\nWorking on sample 91\nWorking on sample 92\nWorking on sample 93\nWorking on sample 94\nWorking on sample 95\nWorking on sample 96\nWorking on sample 97\nWorking on sample 98\nWorking on sample 99\nWorking on sample 100\n","truncated":false}}
%---
%[output:5e1a3a28]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 5.825295\n","truncated":false}}
%---
%[output:72543099]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 5.401927\n","truncated":false}}
%---
%[output:46019640]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAbcAAAFJCAYAAAAYD2OCAAAQAElEQVR4Aeyde4wV153nf93SrDQ94MeuAysaS9CgJdOoG1m7QEusgIybjaPIwsGLIzCKCX\/wiJHG4bVCWey2kZcxxg8kCG3+IJCxYTIek6CZKJ6B7NBokBqY3RUQ2ImEwbJpJNqzWhsIE21Ww9an8Omtrr731n3UvbceX8Svq87rd37nc6rqV+fUqbqt9\/RPBERABERABDJGoNX0TwREQAREQAQyRkDOLWMd2pTmqFIREAERSBgBObeEdYjMEQEREAERqJ2AnFvtDKVBBESgdgLSIAKxEpBzixWnlImACIiACCSBgJxbEnpBNoiACIiACNROIKBBzi0AQ7siIAIiIALZICDnlo1+VCtEQAREQAQCBOTcAjC0WwkB5RUBERCB5BKQc0tu38gyERABERCBKgnIuVUJTsVEQARqJyANIlAvAnJu9SIrvSIgAiIgAk0jIOfWNPSqWAREQAREoHYChTXIuRXmolgREAEREIEUE5BzS3HnyXQREAEREIHCBFLt3O7cuWPLly+3jo4OW7BggQ0PD49qZX9\/f9G0URljDrh6sQ0bY1Yfm7oTJ074fOCHbNq0KUp3Q9PhmDSb6gWAttIHcR4z9G9QXz3qqBePSvSG21lJ2WbmzWp\/RDHlmshxyfFeSGbNmmUXL16MUhOZnmrnFmzdp59+ajt37gxGab8EAW4Etm\/fPirH9OnTR4WbGcCpqT+r7wEunKtXr65eQUpK5qWdKemORJmZGecG1aNHjxp3cexLyiewf\/9+u3r1qq1du7b8QsoZKwHY0weHDx+2cePGxao7ccpkUK4JcHxznHO8OxkcHLRHH33U57Jo0SLr6ury92v5kynnBogDBw4Yw172CwkjAobCbIPphIPx3BESZvj8s5\/9bGT6zg2ZGfkwFUoehPxBfW4fZ0u6E8IuzW0p69LZEnZpwXree+89f\/qVPNhVTjvJiwTzY0NPT48x2qUe7vBpC3URLiTYhB4nwfyUI0waul35YvFhXcFytAlbuVFBD9tgOnGur4hHyE850hCnn\/hq+g5dlEU34voc3QhTJsQh9Alb8mEX6a5+4pwEuZAnLK4M9VJ\/mB26nS7qw4awDhcmrxv1ctHo7u429Lt0tp999tnIsYReyhAfFMqQ5oRwML3QftBuV861ifzUQ3wwjvhgOceK+sgbFJdGGXQVaycMqcOVDTODH3EIOt3xS37qdfoJI+hCJ\/FhoTx50EE7SGdLmHjsJA5BN3Ho+93vfkeUL3H0B\/Wgm62ziTBCvX5FRf4E7SU\/go3F2oyacB2UCQps4UzeKKEfuR5xXerr64vKXlZ6Zpzb5MmTbfz48cbJ\/O6775bV+HIyoW\/Dhg0jWW\/fvm3PP\/+8cXdBZ7iEffv2jZknDpclL46Eg4J9hAORjmXfCWHiXdhtt23bNuKQ5s+fX\/AO3x2kOAVXji22fPOb3xzzXJK0KMEWbArmo+1Lly6tWB8nWVgXejdu3DiGH\/FBqbRttLnSvqMOOFHW1U2fL168eMysAPH0CVvyPvHEE74TqbZ96CgkHDPB\/qS+9evXV8ze6b5+\/bo99dRTI8cS8einb9hHCvU57SKe9EICO44Jjo1gOizdBeu5557zz9NLly7ZtWvXRrJduHDBt4e7d+eMqW8kw5c75R4nlfQhfIM2cy5zfsHky2pLXlewF7vRQTsow5Yw+zdu3Bi54b5y5QpRhv7f+73f8\/fj7g\/spk2+8i\/\/wDJ43fky2t+U029+xjr9wQEeP37cPy62bt1a8LpWoOrIqMw4tzlz5ti6dev8BnNwAswPxPDHTduxRR0HI86NIfWxY8f8TuGCc\/r0aZJHyZYtW\/wpPw527kpIdKNLDjYORE4MLgDoY0uYzg63gXjSycc0FrrCgj5OKhw9tpGXMpQlnoO8t7fXP1mJozztGhgYsAkTJhAcJdiALUS6tgT1UR9p5Yo7uZcsWTKKC\/wOHTrkH9hMWZCOTra0AZupizaUahtlgkLbKM+W+Ki+gw91uHqDZV2\/occJfUrfkg8bo9rnylWypZ9gTh2uHdhIvYX07Nq1y+gr0px9weMFBpwr6EMHech76tQp\/yJc6XFJWeTmzZv2+eef++eDO\/acvRxDHEtTp061mTNnGv0dPF8+\/PBDVNiyZcv847AcjsXaWWkfur6GMayxraWlxT9HCvHxDQ384byZPXu2H+PsdlsinSPHiZw7d87nM2\/ePJJ8qUd\/wJ3+dW2iIseY\/aCU02\/B\/G6f4506isn58+cjpxcZGe7YscM\/HrimxjEd6exrdTtZ2HKQuoOTC2UcbUIfd2bomjhxon9gss9dOlt3srIfFi4aK1as8KOZZ161apW\/7w52dwJwoSIvQ3q2hDnBgic\/Bd2Jz34h4UDhAkUaFy93oHDyUZZ4Ti5OMvbLEQ58bIEDfCmDvgHPGXJQBy+apEWJW7SCo6K93NHjzNDFxapY+Wrahs2V9B11cJeNDc4+bHR3wa7fSHdCn9K3Llxt+1z5Qlv6Duak0R7axX61QnnXl9jOKCKoq9Lj0pXl\/HjooYf8CxUjXaaliKNv3YUuWB\/HKsxxejg\/blrcRb9ajuirtA\/dudzW1mbt7e1+c3BWMA\/a6ycU+eN00CbOL7a0hxklzh\/OIxwl5zbOneuGUxV3f3ANQdBPG2gL+8WEPorqt2Jla41n9M55BStG9bXqC5bPlHOjI5kmooFcnP7qr\/6K3ZqEg52DPqiEjuCACMaVs08Zyrq87iLiwrVu7969a0NDQ74ad3HwA96fcNiLKus\/NpKxEAfiKxWcobuwUpZ+woEgwWkx0oJSTdsK2Qx\/+iGo2+0H63BxlW6rbV+peqrtu2I6C3EJ5nV9HowrZ5\/zb8+ePSM3gFzUcXL0Lc+fuOijh\/7ngs5FjYsbN3HkDd65V8ux0j4sdjxUytzddNAmHDVbHMaaNWtosjFqclwnTZrkz1D4Cd6fuPsjrN+rouT\/cvstrIQRPn1bTLi54cYlXC4Ydn0fdvjBPNXuZ8q5AYGhMicP+5cvX2ZTULi74y6PRLaE2Y9TcDScbE4nd2+cxC7sTiDusrir4w43KGtDqxddflc+vMUJc6IQ704k9pFwmLhyxNUZbkuxssF6aC\/TVOG8jNBcO5k+celHjhwp+hypHm1z9bptsA6m9ZyNbutGHy5\/sQtjNe1zOpOwdX1e7nEZtJnZAjjBjGMaHaQzYuFGhn0upowmOBf+5m\/+xhjlEO9GP+wj1XCstA+pJw4JtonjmLbRRpwexwkOjxkK6gq3k7hSUkt\/lNIbTCun34L549jnuuv6ntkDRslx6HU6MufcaBjDWw4o9otJ8GLNvDRSLG+18cETmo7kmQ263F2KO2ipGyGNOx3ueBD2iStXODi4ayN\/8Lkjd8yccMRzwnEisl+OMMqBZbgtrKTiji28wCDo3Jga5iR39cAgXI6bEefgcIQ4RJc\/uK1H24L62Q\/WAS+4Ec+IkrZiO20grpCQRh7yOi7ltq+QvmbFVXtcujt5d+zCk7697+DMgseGu8Dv3bvXf7ZFHoQ218KROt05UE0fUn+14trkbqoJM\/3I+c55wLM1Rqw4vErqqLY\/yq2jkn4L6uTY5iammHCTg9MMlgnuM2pnhEucayP7cUkmnRtAeeZUCBIHHPFcrDmZuBC5ZyrExy083KYODmjnwNxzGupHqBMbyMc0DidCcIqG9HKFEQcnEDrQhU7qoL3Ek16uLvLBElvYD7cFp8eNBM4Sp0ke7s6pE2GfOCdceGg7YdLIg9B24qiH+th34vLhYLCdNsTVNldHcEt7aBe84IZ9tJs82E4b2C8kpJGHNGc35Uu1j7z1FI45jj3nbMupi3Yj5MV22sCxBPdCfUQ+hDII+chPOerGBpjClnwI+RD2keCdezUcqYO6aCf1UF81fYgt1Qr1c3xSnvq5MaQttI04hPOE84X9cgVOCPkr6Q\/ylyPoRsrpt3L0lZuHG1nqdKzKLVduvkw6NxrPQg46jP2gcLfBRTIYR9hNZQbja92n\/jfffHOUGu5ksYFIDnymKsJ1E2ZKhjyVCicOiz3QESxLmHjSg\/Hl7GMLdgfzchIz1eKcEQtDaK\/LwwFLGfK5OLa0nZV0pBN2gn3U48L0SbgsttMG8rp8bAkTTzrhWoT20K5w3bQF26N0k6ec9kXpqTW92PFfjt5qj8ti5ehrXs+BraufvO6iT7pbSOLSy+VYqJ3UU0sfOhsq3QanRBmtMWpDB22jjey7m2v2yxVYxX2dCNZdTD82h\/stWC6ufZ5NciNQjr5K8qTaublOYVgcvDACIJgWvvDxLIsyTghTnjBbyhNHmIMKXcRx0jDURtgnjjTykJcyxLElTPxTTz3lL3knjHDSkico1EmaE8IunQs29pNWqKzLF96igzJOCAfzVKqXup0uttiEDqczyIF0GFGGfITZd3lhRzrxTkrZRx6YuvLkJc4JYZfGlrykwR+7iHN1Ui\/7xJFGHvJShjiEdjm7SUMK2R\/URTkn6CeNck7CNrq8bkv95MUe7AraEKy7WLzT47boQBc6EeoP1+HyFounDGWdEHZlSm3J58qwhQVMwmXcNGWx0SBlKIsOJ+gO6inUTtKDnFzZIEenG\/3sUyaoCybEIeyjA57kIa6QkEaecF70Uw\/xQRuK6S0WT9vR4YRw0A7CpLEtJz6Yh33KUd4JNmM7afUQWFAX5xr9FXcdqXZuccOQPhEQgfoSCD5PY+qW2qoZzVBOIgKlCMi5laKT5zS1XQQaQIDpZ+7gG1CVqsgZATm3nHW4misCzSQQnLpjSoopuGbao7qzS0DOLbt9q5aJQLMJqH4RaBoBObemoVfFIiACIiAC9SIg51YvstIrAiIgAiJQO4EqNci5lQDHFwV2795tbEtkU5IIiIAIiEDCCMi5legQnJqcWwlAShIBERCBhBKQc0toxzTHLNUqAiIgAtkgIOeWjX5UK0RABERABAIE5NwCMLQrAiJQOwFpEIEkEJBzS0IvyAYREAEREIFYCci5xYpTykRABERABGonULsGObfaGUqDCIiACIhAwgjIuSWsQ2SOCIiACIhA7QTk3GpnmHYNsl8EREAEMkdAzi1zXaoGiYAIiIAIyLnpGBABEShKgK\/0DA4OWqQoT2oZ0cdFD4AUJ8i5pbjzZLoI1JMAF73Nmzfb8uXLJRlmQB\/T1\/U8lpqhW86tGdRVpwikgAAXvDNnztjrr79uhw8flmSQwR\/\/8R8bfUxfJ+CQjNUEObdYcUqZCGSPQHt7u\/X09EgyyGDu3LnZO2C\/bJGc25cgtBEBEYgmwB1+Gp+\/YXd065QjSwTk3LLUmxW0RVlFoFICOAiez6TxGRx2Y385bR4eHrYFCxbYiRMnysledp5K9JL3ySeftIsXL\/r6+\/v7\/eeed+7c8cP6E01Azi2akXKIgAh4BHAOPJ957JkNNm\/Na6mRGb3PVvRcacKECTYwMGC9vb1eq5Pxf+3atf4zz3HjxiXDDpatKgAAEABJREFUoBRYIeeWgk6SiSKQJAJtD0+0Rzq67ZGOlMi07oL4GA11dHQYMmvWrJFREqMmN3JjnxHUe++9Z+QhLyPXa9eu+aM7wsQXG2FR3ukKG0EZyqIDYZ84yixdutQuXbpkixcv9keQ2Eq9buTGqJIyiCvn9G\/atMleeumlEfvIQ36XnpetnFteelrtFAERGCHAxf7IkSP+u2lXr161N954w9avX284lpFMX+7cunXLfv7zn9vp06f9\/ENDQ\/bUU0\/Znj17jLKLFi2yQ4cOfZm7vA1ObMWKFX696Lhw4YLNnDnTduzYYW1tbfb+++\/74WPHjo0ZQWL7xo0bjTTKYju60Olq\/9nPfjZi35YtW2z79u0F2+byZ3Er55bFXlWbREAEKiLAFOSANxXJlGShgqtWrTKmBEmfPXu24dC6urr8rE888YTduHHD3KjKj4z4Q9nz58+POC50z58\/P6KU2W9+8xs7cOCArVu3ztBBAWzHnqCDJezS582bZ\/fu3bObN2+SPXFSL4Pk3OpFVnpFQAQSS4BXG9wrDtVM202fPj2WtjFSZNoSG3bu3Bmp85\/+6Z+MkWO4\/nA4UlEOMsi55aCT1UQREIHRBBgp8WI603pLliyx1atX+8\/UglN7o0vEG3JODSe7bNkyf3qT6cN4a8m3Njm3PPW\/2ioCIjCGwK5du8w98+K52pgMdYigPkaObFkJWW4Vv\/\/7v2+Uu3Llyqgi4fCoxJwG5Nxy2vFqtgjkmQCLMpgOZAQFB1Y\/8qoDz6cIVytMD7LKEX3oOHr0qH366afsjhGmF+\/evevHY08505J\/8Ad\/YDz\/27dv38jqTsoeP37cnnvuOV+X\/twnIOd2n4P+ioAIlEcgE7lYhMHCEKYFed7FkvsXX3xxZJFGtY1EL4s50IdeFoBQR1gf+YL1s0jkzTff9Jf\/4xhZuDJjxgz\/VQBeA7DAP8qyQtLVwcrJd999t2bbA1VkYlfOLRPdqEaIgAhUSoDpSJ65OcFpoAPHwspJwsF90hDKBacSycfzO57juXSnE8dDGnnCutDj8pGH1wtYQelWObp06kLI4+pAnysbLOPqpyz7CPpOnTqVO+cn50bvS0RABMom8I8fXbB\/vJoeufu\/87UEvuyObGbGBtQt59YAyKpCBLJAYPLkycZX5H994j07\/c5\/So38jz9\/07cb+7PQD2pDeQTk3MrjpFwikHsCOIe0\/rYbdmN\/7jsxRwDk3DLf2WqgCMRHAAfBAom0CXbHR0Ga0kBAzi0NvSQbRUAEREAEKiIg51YRLmUWgXwSUKtFIG0E5NzS1mOyVwQyRuDjjz+2gwcP+nLy5MmGtI6PHPMTMrwATYV8dosPF7MlLEk\/gUQ7Nw48XoR0Qrhc5Lz4yO8ahfMT5\/S5LXHhfAqLgAjUn8DLL79sj0+dav\/83e\/aH3py9WtfswVe+ODBg\/WvXDU0mEBjq0usc+MOihcg9+\/f739UlC1h4qMQ4dgKfcqGuzV+moIPlLoXINkGX3iM0q30bBFoxqghWwSrbw0O7PO+PvvIU7HKk7mesB3wRnLnPUdHuhdVl\/98KHlwcND\/YDLXC1cJv9HmbnoZ2XHNcGncXLs0toRdGvnITzwSvGHmmrVmzRpDSCNf8NNf6MAG4tFDWFI7gcQ6N36biM\/Y8CY+zWRLmHjChYQDgwOE764VWh3Fd9z4nhvffytUXnH5IqBRQ\/P6m5uK7Z4De6uICcSTXiS55mhullnxyZavf6Dwiy++sPHjx\/s30zg+rhV81oo0HBk\/+Ek8N8T8UOgrr7zif9+R6w7OctKkSX5ZPobMTXTQwVHuscce89PffvttVPofa2aH8nxBhG9Gui+QEC+pjUAinRudzcERdkJRPwrIAQQOvuw9Z84cdkcJP9bHj\/ZNnDhxVHwGA2pSBAFGBc0aNUSYlovkj73R2Q8iWko6\/RSRLbbkBx98cOTjw3wqi28\/8rV9rkd8+3Hbtm1GPBXySStupA8dOmRcd3CEzAiRhoPaunWrnT171nd+xKHbfZQZHU43aXxL8vbt29bd3U1QEhOBRDq3UiMsDiLSC7Wf0V3w+2vhPDg34lasWGFMDyDBuyvSCsmZM2f8A5ivhhdKV1y6CHBhZVTA6KCQ5cSTXihNcfEQoA9mRqiKSo8oHlsy1xuuO4zOuGY4cY8+cID8DE1bW9tIndxA49BGIkI73KgzWsNxcl3iI8k4vVA2BWsgkEjnVkN7ShblIGTqgakGphYKTR8UUrB7927jLu2DDz4olKy4BBPghoQ766D83d\/9nTEqKGU26a+++qp\/UxMsi75S5TKVVufGXIrQT\/qUKVMicjUumSlMrhtBqfZ5PaM0RmuM2j788EPD2TWuJfmoKVfOjbn14Be0mT5gnpvfQuKhb7Eu59M9jAiffvrpYlkUHwMBHEfQkcSxv3nzZv\/GhJsTJxs2bLCoUQHp7qbGlWOLPuyMobm5VrFy5Up7NYLAoSlTbOHChdbsf4zIGJlxc1zIFh6fMLJjhOfSGY1xI+3C4S2jNEZrf\/EXf2E8gsHZhfMoXBuBRDq3UgcTBxnptTX7\/5eOmj4gJ3X29PRYoUUqpEtqJ4DDwHHgQOIUppQfe2aDzVvz2ojM6H3WGBWUspr02cu2jJShPOXQh62lyiqtPALbfvQj+36RrMT\/0cqVRVIbG+1uglmo5m6CmU7kOGWVI9cGrhFumpK0HTt2GM\/9eTZXzFpGa3\/6p39qLETB2RXLl\/L4ppmfSOfGwUSHh++UGL4TT3o1xHi+hgTLcofV0tJiOLlgvPYbSwCHgeMIOyKcSrWCM6IVbQ9PtEc6ukfk331rrUWNGt76Srv9m3\/\/5EgZv\/w0PfCHZ1zC6G2W5+CmeQoPeHLGE7YLpkyxh\/r67KWXXvJi6vOfawgvbfMcLXxNKFQjz\/PXrVvn\/3goz9wYaVGe2SB0MWXJCMylcZ2KmrJEx6OPPmo4uUJ1Kq42Aol0bjTpueeeM6YLWYJLmC1h4glXIxxE6HB3X8PDw8by3mXLlo2sgqpGr8rERyDsiHynEnBM\/2L8v7LhTz7y5be\/\/e1o5xPI55cr4Yymf2+HMTooZDnx4xZ+q1CS4mImsHLlSvvltWvW8bd\/a\/\/Tc3Stngx44Xo6NtcEHBPPz3BCjLBY4MHWpROPuLDLTxmEsEvDwfHogngkWA6dYd2uHCM+nJwLaxsfgdb4VMWriQOCn1Lnzoq7IbaEiacmhv5uWoBwOcLdFzrcz7P3eFONOLbgQVqOnqTmybpdg+\/vsZPPP27f\/uFWe8WTb\/R9x0544csnf2qV\/uv0nNdlz8GFRw1d3ohtcOl66\/GkUp3KXx0BFo0sXLjQcHRIdVrSV4oFbYzwNCVZn75rrY\/aeLTijLgLckLYaXZ3SsUcE3dOiMvvtuhw+tgWK+\/ya5sMAjiwHs+5hb9mcfGzIev0HB3plVra6Tm4hXt\/ab\/o+7G96Dm6n3jS64Xl2ColqfyVEHA35swauXfjKimvvOURaC0vm3KJQPMI3PIc2BXPgfH+WSEriCe9UFpU3APeSG1y5xzr9BwdEpU\/++lqYb0JuBvzgYEBPQ6pI+zWOuqWahGIhQDOjffOSikjvZrRWymdSrtPgIU+cbyWIR2DY96bbDYTXmG438vZ+yvnlr0+zVyLbg0PlfVeWuYa3uQG8erL3LlzrdD7fjzvliwf8w5l2pjw+g19TF\/HebglQZecWxJ6QTZEEuC9s1KZSH9gQnupLEqrkAAXPPcBA1YCSg5bFhnQx\/R1hYdH4rPLuSW+i2Rgp\/c8rJz30nh2JlrxEuCix6piSY9llQF9HO9RkwxtrckwQ1ZUTSAnBfVeWk46Ws0UgZgIyLnFBFJq6kug0xu96b20+jKWdhHIEoHWLDVGbck2gU7Pwem9tLr0sZSKQOYItGauRWpQpgnovbRMd68aJwKxEZBziw2lFImACIhAjgkkrOlybgnrEJkjAiIgAiJQOwE5t9oZSoMIiIAIiEDCCMi5JaxDyjNHuURABERABEoRkHMrRUdpIiACIiACqSQg55bKbpPRIlA7AWkQgSwTkHPLcu+qbQ0n8PHHH9vBgwd9OXnyZMPrV4UiIAL3Cci53eegvyJQM4GXX37ZHp861f75u9+1P\/Tk6te+Zgu88MGDB2vWLQUikEwCybVKzi25fSPLUkQAB\/Z5X5995Nm8ypO5nrAd8EZy5z1HR7oXpf8iIAINIiDn1iDQqia7BJiK3O45sLeKNJF40oskK1oERKAOBOTc6gC1TiqlNqEEcG4\/iLCNdI3eIiApWQRiJCDnFiNMqconAZzbzIimR6VHFFeyCIhAhQTk3CoEpuwiUIgAvwReKN7FkT5lyhQXbN5WNYtATgjIueWko9XM+hFYuXKlvRqh\/tCUKbZw4ULTPxEQgcYQkHNrDGfVknEC2370I\/t+kTYS\/0crVxZJVbQIpI5AKgyWc0tFN8nIpBNg9DbLc3DTPEMPeHLGE7YLpkyxh\/r67KWXXvJi9F8ERKBRBOTcGkVa9WSGwJkzZ2xwcHCMfPWrX7X\/8md\/Zp\/9yZ\/YwbVr7Zwnrx05Yl\/\/+tfH5HXlr1+\/nhkuaogIJImAnFuSeqOALYpKHoHdu3fb8uXLC8rWrVvtnXfesb\/+67\/2pVg+F79582aTg0teH8ui9BOQc0t\/H6oFDSbw2DMbbN6a12qWGb3PGqNAObcGd6CqywUBObdcdLMaGSeBtocn2iMd3bXLtO44zSqhS0kikD8Ccm7563O1WAREQAQyT0DOLfNdXL8GMp3mFkbUuh0aGqqfodIsAiJQM4G0KZBzS1uPJcReHBuLIdzCiFq36EpI02SGCIhABgjIuWWgE5vRBJwbiyHiXFzRjHaoThEQgWwSkHNLYr+myCYtrkhRZ8lUEcgRgVic2\/DwsC1YsMA6Ojr8d3\/u3LmTI4RqqgiIgAiIQNIIxOLcJkyYYAMDA7Zlyxb\/Swzd3d1ydEnradmTNwJqrwjkmkAszs0RXLt2rV29etWXsKPbtGmTy6atCIiACIiACNSVQKzOLWipc3RLlizxo48ePeqP5uTkfBz6IwIiIALJJ5BiC2N3bsHnbzyDO378uB07dswfze3fv99wcnJwKT5iZLoIiIAIpIBALM4t6NB6enrs008\/NRwZU5Tnz5+3rq4uH0Vvb6\/\/XO7cuXNGGT9Sf0RABERABEQgZgKxODdnE8\/ZcGgIjszFa1sOAeURAREQARGIi0Aszs2tluQ5W5Rh5GFlJWWi8io93QRufTZkl0\/+1Jfrl8+muzGyXgREIFUEYnFuqWqxjG0IgcH399jJ5x+3b\/9wq73iyTf6vmMnvDDOzvSvbgSkWARE4D6BWJwbz8+efPJJu3jx4n2tob\/9\/f3+S97kCyUpmEECOLAez7l95LVtlSdzPWF70RvJdXqOjnQvSv9FQAREoG4EYnFudbNOilNHgKnIK54De6uI5cSTXiRZ0SIgAk0nkA0DqnZufGKLLwVP4HIAABAASURBVMGz3J8VkpcuXbLFixf777IRF5SdO3fasmXLTM\/ZsnHQlGoFzu0HpTJ4aaRr9OaB0H8REIG6EajauY0bN84OHz7sv7\/Gb3nNnDlz5H02VkuGhYUkdWuFFCeGwK3hIZsZYU1UekRxJYuACIhAJIGqnVtQMyOyv\/zLvxx5ny2Ypv2SBDKZeCmiVaQ\/MKE9IpeSRUAERKB6ArE4t+qrV8msEehc+C17NaJRb32l3SZ3zonIpWQREAERqJ5Aa7VFWfnIz9zw3O3atWv+asjgc7bwPnkpU219KpceAtO\/t8O+X8Rc4sd5DrBIsqKrIaAyIiACYwhU7dyYiuRlbJ67TZ061f\/Jm\/BztmCYvJQZY4EiMkeg03Nelz0HN81r2QFPznjCtssbsQ0uXW89nnhR+i8CIiACdSPQWjfNUpxrAp2eg1u495f2i74f24ueo\/uJJ71eWI4t14eFGp9cApmzrLXaFjHFyFRjePqxWJi8lKm2PpVLH4EHvJEaz9Y6PUeHpK8FslgERCCtBFqrNZwpRqYag1OPpfbJS5lq61M5ERABERABESiXQNXOrdwK6pkv+CI5I0YWtxBXTp2MIkt9MqwcHdXmUTkREAEREIH6Eki1c+vr6\/PpXLhwwRACLo79YoJjW7p0qX3yySfFsiheBERABEQgxQSqdm44CJ6jMVpqxqsAfKT57NmztnXrVuNrKQj7xJFWrE9OnDhhfC7s3r179uCDDxbLpngRSDgBmScCIlCKQNXOjednPEdr1qsAN2\/etJaWFps4ceJI+3glYfLkyUbaSGRghynLAwcO2P79+23v3r2BFO2KgAiIgAhkiUDVzq3ZEK5cuWLt7e3W1tY2xhTSxkR6EYzucMa9vb1eqPz\/Z86cMb6fef369fILKacIiIAIJJxAls1LrXNrZKfs3r3bmH794IMPGlmt6hIBERABEaiSQKzOzT2HY+WiE5wC04FV2peIYq+\/\/rr\/CwhPP\/10IuyRESIgAiIgAqUJxObc3EINfrct+L7b\/Pnzbd68eUV\/pbu0ecVTp0+fbkNDQ3b37t0xmUgbE1lDBNOfLELheV7ValRQBERABESgYQRicW6MzFiosWTJEgv\/bhvhRYsW2Y4dO4x8cbWMhSSseAwuHmHVJs\/FSIurHukRAREQARFIH4FYnBujJ0ZRxUZMxJNOvrgQdXV12Zw5c0acJo4TB0ocaXHVIz0ikCACMkUERKBMArE4N1YsMnVXbJUi8aSTr0y7ysrmXtju7u42hEIujn2mSnkXj2eBhCUiIAIiIAL5IBCLc2OJPS9QHz9+3Pr7+0eRI0w86eQblVhjAH0s7XfP+NgnzqllyT\/v4vFOnotzW0Z3p06dMrYuTlsREAERyDyBnDSwaufGaIhRkVsVuXjxYrt9+7bt3LnTXBxbwsSvX7\/eKJMTrmqmCJRNwL1HybuUcQjPncuuXBlFIKMEqnZujIYYFblRU9SWvJTJKEc1SwSqJuDeo+S1mThk8+bNJgdXdXeoYEYIVO3cMtL+OjdD6kUgmsBjz2yweWtei0Vm9D5rjATl3KK5K0e2CcTm3JhyDE5TMiUZFNLIk22cap0IVE6g7eGJ9khHdzwyrbtyA1RCBDJIIDbnxrM1VkTy0zNbtmwx3nljqvLYsWPGy8979uwxTUtm8AhSk+pOQBWIgAhUTiAW58aI7Ny5c8bXSFityHttN27c8F\/aZjUizxEOHTpUuXUqIQIiIAIiIAJVEIjFuYXr5QshrJB0L23z+a1f\/\/rXWi0ZBqWwCIiACDSEQP4qicW58XI2U5IOH86N\/eCnsQhLREAEREAERKARBGJxbkxFMiV55MgRf3TGs7UZM2bY6dOn\/TawHT9+fMHfXvMz6I8IiIAIiIAIxEggFueGPXwgefbs2fbCCy\/4z9pYVIKzY8Uk27fffttwguTNuKh5IiACIiACTSYQm3OjHbt27fJ\/9wwnxuhtYGDAWDHJljB5JCIgAiIgAiJQbwKxOrd6Gyv9IpAbAmqoCIhATQRidW68EsDL2kxFOuE1AH6OpiYrVVgEREAEREAEKiAQm3Pj52V6enps2bJl\/lQk05EIC014FeDixYsVmKWsIiACIiACNRLIdfFYnBsjswMHDvhfJWFhSZAo4UWLFtmOHTv8hSbBNO2LgAiIgAiIQD0IxOLceFl7aGjI+DJJISOJJ518hdIVJwIiIAIiIAJxEojFubmXuPnF7ULGEc9L3uQrlJ6FOLVBBERABEQgOQRicW4s\/d+6dasdP37c+vv7R7WOMPGkk29UogIiIAIiIAIiUAcCVTu38MpI\/RJ3HXpHKnNGQM0VARGIi0DVzo2Xsnk5mxWR5Qh5KROX4dIjAiIgAiIgAsUIVO3ciilUvAiIgAiIQPMIqOb7BOTc7nPQXxEQAREQgQwRiNW58aL2rFmzzH2dhC1h4jPETE0RAREQARFIOIHYnBtfKGFRybp160Z9oYQw8aQnnEXl5qmECIiACIhAIgnE4tyivlCyZMkS4wsm5EskBRklAiIgAiKQKQKxODe+PMIXSPgSSSE6xJNOvkLpimsMgevXr9vg4GAsQn82xurM16IGioAI1IFALM6NL4\/wBRK+RFLIRuJJJ1+hdMXVnwCObfPmzcavNMQh6Kq\/1apBBERABKojEItz48sjq1atsqNHjxb8QgnxpJOvOjNVqlYCOLczZ87YY89ssHlrXqtZZvQ+W6tJKi8CIhAXAekZQyAW54bW3t5eO3bsmO3bt2\/UaknCxJNOPklzCbQ9PNEe6eiuXaZ1N7chql0EREAEShCIxbmxUISprps3b9r58+dHrZYk3NXVVcIEJYmACIiACIhAvARicW4sFGGBAc\/W4jUvidpkkwiIgAiIQNIJxOLcWCjCgpGkN1b2iYAIiIAI5INALM6NhSL8pM3hw4dNXyPJx4GjVtZGQKVFQATqSyAW58bP36xfv95YkcfXSPjsVlgWLFhg5Ktvc6RdBEQAAqyMjeudRs5rdEpEIE0EYnFu\/JQNP2lT6qdvSCdfmuDIVhFIK4Hdu3fH+k6jHFwSjwTZVIpALM6tVAVKEwERaDyBON9nZBQo59b4PlSNtRGo2bn19\/ePeq9NH0iurUOaWfrWZ0N2+eRPfbl++WwzTVHdNRLQ+4w1AlTx1BOoybnh2NxL2kxJ8rL2xo0bx3ylJPWUzDLfhMH399jJ5x+3b\/9wq73iyTf6vmMnvDDOzvRPBERABFJGoGrnxovbp06dMn7Sxr2kzZYw8aSnjEVuzcWB9XjO7SOPwCpP5nrC9qI3kuv0HB3pXpT+i4AIiEBqCFTt3NyL2+GW6hcAwkSSHWYq8ornwN4qYibxpBdJVnQlBJRXBESgYQSqdm6lLPz888+NT3GVyqO0ZBDAuf0gwhTSNXqLgKRkERCBRBGoi3NLVAtlTEkCt4aHbGbJHBaZHlFcySIgAvERkKYyCci5lQkqy9kuRTSO9AcmtEfkUrIIiIAIJIeAnFty+qIplnQu\/Ja9GlHzW19pt8mdcyJyKVkEREAEkkOgtVZTdu7cOeo9t9WrV9vt27ct\/BmuNH5+q1Y2aSk\/\/Xs77PtFjCV+nOcAiyQrWgREQAQSSaBq58antPikFu+3lSPkpUwiKeTcqE7PeV32HNw0j8MBT854wrbLG7ENLl1vPZ54UfovAiIgAqkh0JoaS2VoXQl0eg5u4d5f2i\/6fmwveo7uJ570emE5tlqxq7wIiEAzCLQ2o1LVmUwCD3gjNZ6tdXqODkmmlbJKBERABKIJtEZnUQ4REAEREIFmElDdlROQc6ucmUqIgAiIgAgknICcW8I7SOaJgAiIgAhUTkDOLcxMYREQAREQgdQTkHNLfReqASIgAiIgAmECcm5hIgqLQO0EpEEERKDJBBLt3E6cODHq6yeEo3ht2rRppEyhr6IE0zs6Ovy8xEXpVboIiIAIiEB6CCTWuV28eNE2btxo+\/fvN76AwpYw8cXw9vf327lz52xwcNAvM3v2bHvhhRfM\/XAq2xs3btiWLVv8dPQiu3btKqZS8SIgAiLQHAKqtSYCiXVuhw4dskWLFllvb6\/fQLaEifcjQn+Gh4ftyJEjtm3bNnOf+cKJDQ0N+c6O7Hfv3jXC06dPJygRAREQARHIKIFEOjc3wgo7oSeeeMIYeZEe7g9+HPXevXs2ceLEkSScHKO3K1eu+HGF8vgJ+iMCIiACIpApAol0bqVGWIy8SA\/3Ao6rpaVllHNzeYLOjbgVK1b4z9p45nb\/eRuxxeXMmTP+6O\/69evFMylFBDJMwJ0DTPnXKjqPMnygJKhpiXRu9eKDk\/viiy\/s3Xff9Z+5XbhwwR8JRjm43bt32\/Lly+2DDz6ol2nSKwKJJuDOAc6DWmXz5s0mB5fo7s6EcblybmvXrrXz589bV1eX8W\/cuHG2atUqO378uJVaqPL666\/b4cOH7emnn6aYRAQKEshy5GPPbLB5a16rWWb0PmuMAuXcsny0JKNtiXRubW1t1t7eboy0wpiIJz0cz7M2nrkxPRlOCz+7C6ZT7sEHHwxGjdmnzp6eHps8efKYNEWIQB4ItD080R7p6K5dpnXnAZfamAACiXRujKgmTZo0xrl9+OGHRjzpYXY4qZaWFgs6N1ZQ8mqAc25MPyLBsuRvaSn8rC6YT\/siIAIiUH8CqiEuAol0bjTuueee86cL3YvbbJk+JJ70sLAyctmyZbZ9+3bDqZG+c+dOfwTIqIswqy3R4aYgyUd+ylGePBIREAEREIH0E2hNahN4LvbGG2\/Y6tWr\/ZWNbAkTj828DsCDbV7cJozwTI2l\/zgzVkIyanv77bfNjfR4Vw4dixcv9nWSD8dGOcpLREAEREAEskEgsc4NvDgjviDihDDxCA6LRR5hx8TXRlz+gYGBkRe6KYOg48t0f8VkuDx5JCIgAiIgAukmkGjnlm60sl4EREAERKBZBOTcmkVe9WaDgFohAiKQSAJybonsFhklAiIgAiJQCwE5t1roqawIiIAI1E5AGupAQM6tDlClUgREQAREoLkE5Nyay1+1i4AIiIAI1IFA7pxbHRhKpQiIgAiIQMIIyLklrENkjgiIgAiIQO0E5NxqZygNuSOgBouACCSdgJxb0ntI9omACIiACFRMQM6tYmQqIAIiIAK1E5CG+hKQc6svX2kXAREQARFoAgE5tyZAV5UikHcC\/Br34OCgxSH6Ve+8H02F258P51a47YoVARFoEoHdu3cbP1kVh2zevNnk4JrUkQmuVs4twZ0j00QgqwQee2aDzVvzWs0yo\/dZYxQo55bVI6X6dsm5Vc9OJfNFQK2NkUDbwxPtkY7u2mVad4xWSVWWCMi5Zak31RYREAEREAGfgJybjyGZf5hqieOBOzqGhoaS2UhZJQJ5IqC2NoyAnFvDUFdWEY6NB+VxPHBHB7oqs0C5RUAERCC9BOTcEtp3ODcelMf54D2hTZVZIiACIhA7gQw7t9hZNUWhHrw3BbumRGnpAAAPSUlEQVQqFQERSDkBObeUd6DMFwEREAERGEtAzm0sk9TE3PpsyC6f\/Kkv1y+fTY3daTJUtoqACKSTgJxbOvvNBt\/fYyeff9y+\/cOt9oon3+j7jp3wwjg70z8REAERyDkBObcUHgA4sB7PuX3k2b7Kk7mesL3ojeQ6PUdHuhel\/yKQGwIsvuKVl7iEBV3xwZOmZhCQc2sG9RrqZCryiufA3iqig3jSiyQrWgQySSDOb1W6V2fk4NJ9qMi5paz\/cG4\/iLCZdI3eIiApOVME4nplhu9d6nuV2Tg0subcstErJVpxa3jIZpZIJykqnTwSEcgSgdhemeF7l\/peZSYODTm3FHbjpQibSX9gQntELiWLgAiIQHYJyLmlrG87F37LXo2w+a2vtNvkzjkRuZRclIASREAEUk+gNfUtyGEDpn9vh32\/SLuJH+c5wCLJihYBERCBXBCQc0thN3d6zuuy5+CmebYf8OSMJ2y7vBHb4NL11uOJF6X\/IiACzSOgmptMoLXJ9av6Kgl0eg5u4d5f2i\/6fmwveo7uJ570emE5tiqBqpgIiECmCLRmqjU5a8wD3kiNZ2udnqNDctZ8NVcEREAEihJoLZqSogSZKgIiIAJxE4jzqyd6ITzu3onWJ+cWzUg5REAEckggzq+e8GPBcnCNPYjk3BrLW7UlloAME4HRBOL66om+eDKaa6NCcm6NIq16REAEUkUgtq+e6IsnTel3ObemYFelIiACWSSgNiWHgJxbcvpCloiACIiACMREQM4tJpBSIwIiIAKlCGj1ZSk68ael17nFz0IaRUAERKBuBLT6sm5oCyqWcyuIRZEiIAIiEC8Brb6Ml2eUNjm3KEJlpvMOy+DgoMUlQ0NDZdasbDUQUFERaBgBrb5sGGq\/Ijk3H0Ntf3BsvKS5fPlyi0vQV5tVKi0CIiAC+SUg5xZD3+PceFgc17TDvDWvGS9+xmCaVIiACNSbgPQnkoCcW4zdEtu0Q0e3PaIXP2PsGakSgewR4IY6rscg6OEmPUuU5Nyy1JtqiwiIQG4IxLn6kscpPArJkoNLmXNL73F767Mhu3zyp75cv3w2vQ2R5SIgAokgEPdjEEaCcm6J6Nr0GDH4\/h47+fzj9u0fbrVXPPlG33fshBfG2Zn+iYAIiEAVBPQYpDQ0jdxK86k5FQfW4zm3jzxNqzyZ6wnbi95IrtNzdKR7UfrfQAKqSgREoDABRm88f4uSwqWTFSvnVsf+YCryiufA3ipSB\/GkF0lWtAiIgAg0lEC5z\/EaalSVlcm5VQmunGI4tx9EZCRdo7cISEoWgcQRyKZB5TzHO3z4cCoaL+dWx266NTxkMyP0R6VHFFeyCIiACMRGoJzneD09PbHVV09FuXNuFy9etFmzZllHR4cv\/f399eRrlyK0k\/7AhPaIXEoWAREQARGohEAanFsl7SmZd3h42NavX2\/r1q2zq1ev2rFjx2zfvn124sSJkuWqTexc+C17NaLwW19pt8mdcyJyKVkEREAERKASAq2VZE573qNHj1p7e7utWLHCb0pXV5fv6A4cOGB37tzx4+L+M\/17O+z7RZQSP85zgEWSFd0gAr\/5zW+MET3bBlWpaiII0BfqkwhITUimX1h0kob34XLl3K5cuWKTJk2ycePGjRwW8+bNs9u3b9vdu3dH4uLc6fSc12XPwU3zlB7w5IwnbLu8Edvg0vXW44kXpf\/1JlBCPyfsr371K2NbIpuSGkiAvlCfNBB4mVXRL3JuZcJqVDZGZjdu3LDp06ePqfKLL76wmzdvjol3EVHvfrifpxm+OWxMfYblkc551vniEfvhd162\/\/BvF9uffGO1db90xDoWPFMwP+U5iKi\/mE7yVCJ50webctvs8nEMUK6YuHxJ7RPsTrqN5drn8jW6T7LEkLaUK4531LHt8nFtSrq0Jt3AZto3efJkmzt3rnGnwrfXignfZMPOi7+6aP\/1F8cKyt\/\/t7+3of91y9r+9XS73Tq+YJ5gWV6i\/L\/\/cpqV0hnMH7WfN33wKLfNZ06dsJb\/c8cu\/ffBkv1Srj7qLkfi1kedcetslr5m9UkEw5LHB2ULSbMYFrKlWFy5NtIvXBO5NnLNS7LIuZXoHTrw9ddfN97rKEeOvrLSfvqf\/2Msgq4\/37Pd2MahEz150gcztbn2Y1EMs8+w0nOFayLXxhKXzkQk5ca58ZyN5208dwuTf\/DBB23ixInhaD9MJ\/b09JhEDHQM6BjQMdBjXBP9i2PC\/yTWudWDG8\/beO7G8zen\/\/Tp0zZ+\/Hhra2tzUdqKgAiIgAiknECunNuSJUuMxR\/vvvuu320sNeY9t1WrVo1aQekn6o8IiIAIiEBqCeTKuU2YMMH27Nnjv7jNF0oWL17sv+fW29ub2g6U4aUIKE0ERCCvBHLl3OhkXtw+f\/68\/4WSq1ev2tq1a4mWiIAIiIAIZIhA7pxbhvpOTREBEWgAAVWRTgJybunsN1ktAiIgAiJQgoCcWwk4cSaxQpOXwHnWh7BPXJx1SFdlBPhgNn0RlAULFvhfjalMk3LHQYCvaTz55JP+dz7D+jZt2uT\/igd9pT4K06lfuFifsBgv+Osq9Ath4utnTWWak+XcKrM9Vbn7+vp8ey9cuGAIARfHvqTxBHjnkfeW6A+evyIDAwPGwqPGW5PvGrmILl261D755JMxIPhZqnPnzhlf0aCPZs+ebS+88ELdPnY+xoCcRpTqEz6L9tBDD430Cf3CWgbWNCQFl5xbA3qCu5mzZ8\/a1q1b\/VcOeKGcfeJIa4AJqqIAAZwbL\/bTHwWSFdUgAoygucm4d++e8UGFYLVcYI8cOWLbtm0buenYsmWL\/0oPzi6YV\/vxESjVJ9TCucMvrCT5\/WA5N3qqzsJdTktLy6ivoEydOtV\/05+0OlefN\/VltZcpYV7o58X+sgooU10I0A\/85NT+\/ftt7969Y+rg\/MDpBb8gxMia0RsX2DEFFFEzgag+oQLYJ\/3GUM6NnqqzcCAUu8shrc7VS30BAvzEET91xDdDeV6A6FlOAVB1jmLUTB8Ue9cU59bSMvrG0Jmkc8eRiHcb1Sc4P24M\/+Ef\/mHkOWjSnrdBRM4NCpLcEeCiyfMdFvbwvABZtmyZ8dyHqbDcAVGDRxNQqCgBbgz50tNXv\/rVkfeF33jjDVuxYkXBxUBFFdU5Qc6tzoClPpkEePDNA\/DgS\/x8ng1rjx49ykYiAiJQgADTwiy82rVr10gqz0xnzpxphw4dGolr9o6cWwN6gOc63OlwxxOujrRwnMLNIcDDcaaPm1O7ai1EgGdtPHNjpB1O17kTJtK8MFOZPINrngVja06AcxtrVNZiCp2g165ds+vXr49aZJK1die5PawGCz9j4+aDmxBdNJPTc5w7LS0tFnRuTBvzaoD6qTn9xArv+fPnj5qCdM\/hktQncm4NOD6YApszZ47t2LHDfzeHA4F94khrgAmqIkSgu7vbjwlOQe7cudMYuTHF4ifqT9MJMAXGs9Dt27ePvFyvfmput7iV3sEpSH5phRtDN7XfXAvv1y7ndp9D3f+6F7a5qCJU6OLYl9RGoNLSXDTff\/994x0qVkoirABjSTpTLJXqU\/76EeC5KEv\/uemgnxi1vf322\/47o\/WrVZqLEeD84DzhfKE\/EM4jzifOq2LlGh0v59Yg4hwQLHlmVR7CPnENql7VFCDAiTgwMDCy4kt9UgBSA6OYxTh16pSxDVfL4gXOG4Q+o+\/CeRSOnwB9UahPuHZxvtAfSBL7RM4t\/uNBGkVABFJJQEZniYCcW5Z6U20RAREQARHwCci5+Rj0RwREQAREIEsEmuXcssRQbREBERABEUgYATm3hHWIzBEBERABEaidgJxb7QyloVkEVK8IiIAIFCEg51YEjKJFQAREQATSS0DOLb19J8tFQARqJyANGSUg55bRjlWzkkGAb1jyBYeg9Pf3N9047Nq0aVPT7ZABIlAvAnJu9SIrvbkmwPdD+a24jRs32rFjx0a+gsL+vn37jDTyNAMS9fLr182oW3WKQKMINNS5NapRqkcEmk2A74byIdnjx4+P+pwUnzPiI7OXLl0yts22U\/WLQFYJyLlltWfVrqYR4CdBcGp8zb7QNxD5qvo777xjX\/\/610fZyHRlcPoyOG3IaIvRXjCOwkwvUoatC8+aNcsI85M+pCGuHD8X881vftMGBweNX0QgL\/ZSViICWSIg55al3sxFW5LfSH577Pbt21bst6346CxfuMfJudbgfJiuZNqSD9HifPj6PQ4Nx+bylbOlbn4ihq+0o4svuOPIcJ4425\/\/\/OdG\/fw8yfnz50eNLMvRrzwikAYCcm5p6CXZmCoCV65csfHjx5f9Q7SMnBjpvfHGGyOOBie0bds2f4SFo6sUAGXRQTkcGYJdhCUikAcCcm556GW1MdEEGOlhIL86zdYJv\/v36KOPWqVOqRLH6urK21btzT4BObfs97Fa2GACTEcyNeicVlT1lTqvKH3F0vlxyUqnOIvpUrwIJJ2AnFvSe0j2pY5AOSMunrGx4IMFHjjD1DVSBotAwgnU37klHIDME4G4CfCsa\/bs2XbkyBHDeYX1u2ds5CGvm448ffr0qKwXLlywTz\/9tOjCFDI3atRHXRIRSBMBObc09ZZsTQ0B3nNrb2+3RYsWGc7MGc7+ihUr7KGHHrItW7b40bz7Rj5WS5JOJE6RFY8sBEFYYTl\/\/nxj4YnLw5Yy5K9E0DVp0iTTNGUl1JQ3bQTk3NLWY\/m0N3WtxoEcPnzY1q1bZ4sXLzbeNUPYJ25gYMAYtbmG7dq1a1ReHBrvyaEDXeRbu3at7yzRga7169cbKyxZQEJ6JfLEE0\/4KzGZQuWduErKKq8IpIGAnFsaekk2ppYADol3zYJCXKEGER+VDyfo8uAge3t7jXfV2KKTLWFGg4QRnCNOEmGfOPI5PewTJxGBLBGQc8tSb6otIiACxQkoJVcE5Nxy1d1qrAiIgAjkg4CcWz76Wa0UAREQgVwRqJNzyxVDNVYEREAERCBhBOTcEtYhMkcEREAERKB2AnJutTOUhjoRkFoREAERqJaAnFu15FROBERABEQgsQTk3BLbNTJMBESgdgLSkFcCcm557Xm1WwREQAQyTEDOLcOdq6aJgAiIQF4JxOnc8spQ7RYBERABEUgYATm3hHWIzBEBERABEaidgJxb7QylIU4C0iUCIiACMRCQc4sBolSIgAiIgAgki4CcW7L6Q9aIgAjUTkAaRMD+HwAAAP\/\/91zi5AAAAAZJREFUAwDCa3jhHk9IMgAAAABJRU5ErkJggg==","height":299,"width":399}}
%---
%[output:0af5b532]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAbcAAAFJCAYAAAAYD2OCAAAQAElEQVR4Aeydf4wV15XnT6NEchiwnZUNGhqPMCDZ06ibtXaAlpCAjJs1UcbCxksiCAoErewmRoptfuygDDY28jLGYBsJQps\/CCQ2TMYxCUqiOAHv0EhIDczuCjqw8QqDFdNI4NGsbQgZbVbD1qec21Ov+tX7We+9+vFFnK66v84993Pr1albdevWqFv6JwIiIAIiIAIZIzDK9E8EREAEREAEMkZAzi1jHdqS5qhSERABEUgYATm3hHWIzBEBERABEaifgJxb\/QylQQREoH4C0iACsRKQc4sVp5SJgAiIgAgkgYCcWxJ6QTaIgAiIgAjUTyCgQc4tAEO7IiACIiAC2SAg55aNflQrREAEREAEAgTk3AIwtFsNAeUVAREQgeQSkHNLbt\/IMhEQAREQgRoJyLnVCE7FREAE6icgDSLQKAJybo0iK70iIAIiIAItIyDn1jL0qlgEREAERKB+AsU1yLkV56JYERABERCBFBOQc0tx58l0ERABERCB4gRS7dxu3LhhS5cutcmTJ9vcuXPt2rVrBa3s6+uLTCvIGHPA1Ytt2Biz+tjUHT161OcDP2Tt2rXldDc1HY5Js6lRAGgrfRDnMUP\/BvU1oo5G8ahGb7id1ZRtZd6s9kelTDlfc97muHdCX1Zavly+VDu3YOM+\/PBD27p1azBK+yUIcGBt3ry5IMfUqVMLwq0M4NTUn7X3ACfOxx9\/vHYFKSmZl3ampDsqNpPzz+LFi43zdrAQx2xcDi4zzg1Ahw4dsrjAoC8vsmfPHrt48aL19vbmpcmJayfs6YMDBw7YmDFjEmdfrAZJWe4JcK7GsY0dO9YOHz5sZ8+ete7ubp\/L3r17LY47XplybpApB4YRAUNgtuR3QjgYzxUhYW7r\/OQnPxm+fTd9+nQbHBz0b4EGh9Tkd7qCW5wtepwQDqazT1mXzpYw8QhXOK6eN99807\/9Sh7sKnUAuPaQFwnmxwYOJA4u6uBqiTqoi3AxwSb0OAnmpxxh0tDtykfFh3UFy9EmbOXgRw\/bYDpxpdpGutOPnlr6ztlAvYjrc3Qj9D9xCH3ClnzYRbqrnzgnQS7kCYsrg83UH2aHbqeL+rAhrMOFyetGvQMDA9bV1WXod+lsP\/roo+FjCb2UIT4olCHNCeFgerH9oN2unGsT+amH+GAc8cFyjhX1kTcoLo0y6IpqJwypw5UNM4MfcQg63fFLfup1+gkj6EIn8WGhPHnQQTtIZ0uYeOwkDkE3cej7wx\/+QJQvcfQH9aCbrbOJMEK9fkURf4L2kh\/Bxqg2oyZcB2WCAls4kzdKpk2bZvfee69\/QTdnzpyobDXFZ8a5TZw40bgK4Mf8xhtv1ASjWCH0PfPMM8NJ169ftyeffNLmz59fMKTevXu37\/SGM3o74bJelOFIOCjYRzgQ3Q+UMEKYePaDsnHjxuE6ORCKXeG7gxSnECyLLV\/5yld8pxyMr2QfW7ApmBfHyG0F6gvGl9vnRxbWRZk1a9aM4Ed8UKiLE0albaPN1fYddcCJsq5u+nzhwoUj7goQT5+wJe+CBQt8J1Jr+9BRTDhmgm2mvtWrV9fUl+i\/fPmyPfLII8PHEnHop2\/YR4r1Oe0invRiAjuOCY6NYDosN23a5EctX77c\/52eO3fOLl265Mfxhyt3yt1zzz3Dzpj6SAtKpcdJNX0IX+p29fBb5vcFExdHG6LOK1w8YDc6aAdl2BJm\/8qVK8MjkQsXLhBl6P\/85z\/v78fdH9hNm3zlf\/wDy+B554\/R\/qaSfvMzxvjHPQJxxwFO9Pjx434NEyZM8J2dH4j+UzYlM85t5syZtmrVKr\/BHJzlrhj8jBX+cbft2FKEgxHnxm0khtQ4VU44J06cILlA1q9f79\/y42BntESiG11ysHEg8sPgx4M+toSPHDky4mRPPOnk4zYWusKCPn5U2IRt5KUMZYnnIO\/p6TEXR3na1d\/fb+PGjSNYIHDEFiJdW1xZ9FEfaZWK+3EvWrSogAv89u\/f7x\/U3JojHZ1saQM2Uxd1lmobZYJC2yjPlvhyfQcf6nD1Bsu6fkOPE\/qUviUfNpZrnytXzZa+gzl1uHZgI\/UW07Nt2zajr0hz9gWPFxjwW0EfOshDXk4unGSqPS4pi1y9etU+\/vhj33m5Y8\/ZyzHEscRVOlfr9Hfw9\/LOO++gwpYsWeIfh5VwjGpntX3o+hrGsMa2trY2\/zdSjI9vaOAPv5sZM2b4Mc5utyXSncBxIqdPn\/b5zJ49myRfGtEfcKd\/XZuoyDFmPyiV9Fswv9vneKeOKDlz5ox1dna67AVbynKMwpoLRy4QsJVj0V0IFRSoITCqhjKJLcJB6g5OTpRxGIo+wKNr\/Pjx\/oHJPlfpbN2Plf2w0FHLli3zoxllrVy50t93B7v7AXCiIi9DeraE6fTgj5+C7ofPfjHhxMQJijROXu7A4sdHWeL5cfEjY78S4cDHFjjAlzLo6\/ecIQd18KRJWjlxV2w4KtrLgYwzQxcnq6jytbQNm6vpO+rgKhsbnH3Y6K6CXb+R7oQ+pW9duNb2ufLFtvQdzEmjPbSL\/VqF8q4vsZ1RRFBXtcelK8vv48477zSOF05Y3JYijr51J7pgfRyrMMfp4fy4aHEn\/Vo5oq\/aPnS\/5dGjR1t7e7vfHJwVzIP2+gkRf5wO2sTviy3t4Y4SPPgd4Sj5bePcOW84VXH3B+cQBP20gbawHyX0Ubl+iypbazz9BKNw+WK\/sXCeSsOZcm50JLeJaDwnp5\/97Gfs1iUc7Bz0QSUctBwQwbhK9ilDWZfXnURcuN7tzZs3bWhoyFfjTg5+wPsTDntRFf3HRjIW40B8tYIzdCdWytJPOBAkeFuMtKDU0rZiNsOffgjqdvvBOlxctdta21eqnlr7LkpnMS7BvK7Pg3GV7PP727lz5\/AFICd1nBx9y+1kTvroof85obsTGRdx5OVuiLsgq5VjtX0YdTxUy9xddNAmHDVbHMYTTzxBk41Rk+Mavu0Wd3+E9fsGlPhTab+FVTDCp2+jhIsbLlzC5Qhzi9eN1HD6XABxXHAcbNmyZfg2LnlrlUw5NyAw3AUS++fPn2dTVLi64+qBRLaE2Y9TcDT82JxOrt7oPBd2PyCuslwH08lOekOzF11+Vz68xQnzQyHe\/ZDYR8Jh4ioRV2e4LVFlg\/XQXm5ThfMyQnNt5PaJSz948GDkc6RGtM3V67bBOrhl4mx0Wzf6cPmjToy1tM\/pTMLW9Xmlx2XQZpwTnGDGMY0O0hmxcCHDPidTRhP8Fn71q1+Zu4J3ox\/yILVwrLYPqScOCbaJ45i20UacHscJDo87FNQVbidxpaSe\/iilN5hWSb8F89ezz\/nW9Tl3DRgdo89x4cIg+DyWtFokc84NCO6hNftREjxZcwWBROWtNT74g6ZDeWaDLndbwh201I2QxpUOVzwI+8RVKhwkXLWRP\/jckStmfnDE84Pjh8h+JcIohx9nuC3MpOKKLTzBIOjcuDXMj9zVA4NwOS5GnIPDEeIQXf7gthFtC+pnP1gHvOBGPCNK2orttIG4YkIaecjruFTavmL6WhVX63HpruTdsQtP+vYzB2cWPDbciWzXrl3+sy3yILS5Ho7U6X4DtfQh9dcqrk3uopowtx\/5vfM74NkaI1YcXjV11NofldZRTb8FdXJscxETJVzk4DSDZdiP6iNGt6Qz4uW8w349kknnBlCeORUDwwFHPCdrfkyciNwzFeLjFh5uUwcHtHNg7jkN9SPUiQ3k4zYOP4TgLRrSKxVGHPyA0IEudFIH7SWe9Ep1kQ+W2MJ+uC04PS4kcJY4TfJwdU6dCPvEOeGgpu2ESSMPQtuJox7qY9+Jy4eDwXbaEFfbXB3BLe2hXfCCG\/bRbvJgO21gv5iQRh7SnN2UL9U+8jZSOOY49pyzraQu2o2QF9tpA8cS3Iv1EfkQyiDkIz\/lqBsbYApb8iHkQ9hHglfwtXCkDuqindRDfbX0IbbUKtTP8Ul56ucETVtoG3EIvxN+L+xXKnBCyF9Nf5C\/EkE3Ukm\/VaKvkjzFzsP8ZigbfMZMuFbJpHMDBhM56DD2g8LVBifJYBxhdyszGF\/vPvW\/8sorBWq4ksUGIjnwuVURrpswt2TIU63ww2GyBzqCZQkTT3owvpJ9bMHuYF5+xNxqcc6IiSG01+Xhx00Z8rk4trSdmXSkE3aCfdTjwvRJuCy20wbyunxsCRNPOuF6hPbQrnDdtAXby+kmTyXtK6en3vSo478SvbUel1Hl6GuescDW1U9ed9In3U0kcemVcizWTuqppw+dDdVug7dEGa0xakMHbaON7LuTOvuVCqziPk8E647Sj83hfguWq2ef\/uWCJPw743cffhwTrKea\/VQ7N9cpDIuDJ0YABNPCJz7gUcYJYcoTZkt54ghzUKGLOH40DLUR9okjjTzkpQxxbAkT\/8gjj\/hT3gkjdCp5gkKdpDkh7NI5YWM\/acXKunzhLToo44RwME+1eqnb6WKLTehwOoMcSIcRZchHmH2XF3akE++klH3kgakrT17inBB2aWzJSxr8sYs4Vyf1sk8caeQhL2WIQ2iXs5s0pJj9QV2Uc4J+0ijnJGyjy+u21E9e7MGuoA3BuqPinR63RQe60IlQf7gOlzcqnjKUdULYlSm1JZ8rwxYWMAmXcbcpo0aDlKEsOpygO6inWDtJD3JyZYMcnW70s0+ZoC6YEIewjw54koe4YkIaecJ50U89xAdtiNIbFU\/b0eGEcNAOwqSxrSQ+mId9ylHeCTZjO2mNkGJ9RNvjqivVzi0uCNIjAiLQHALB52nuNlQto5nmWKta0kxAzi3NvddI26VbBJpAgNtQwdFME6pUFTkhIOeWk45WM0UgCQSCt+64\/RXnbagktE82JIeAnFty+kKWiEDWCKg9ItAyAnJuLUOvikVABERABBpFQM6tUWSlVwREQAREoH4CNWqQcysBjhUFduzYYWxLZFOSCIiACIhAwgjIuZXoEJyanFsJQEoSAREQgYQSkHNLaMe0xizVKgIiIALZICDnlo1+VCtEQAREQAQCBOTcAjC0KwIiUD8BaRCBJBCQc0tCL8gGERABERCBWAnIucWKU8pEQAREQATqJ1C\/Bjm3+hlKgwiIgAiIQMIIyLklrENkjgiIgAiIQP0E5NzqZ5h2DbJfBERABDJHQM4tc12qBomACIiACMi56RgQARGIJMAqPQMDA1ZWlCe1jOjjyAMgxQlybinuPJkuAo0kwElv3bp1tnTpUkmGGdDH9HUjj6VW6JZzawV11ZkYAh988IHt27fPl2PHjiXGriQYwgnv5MmT9vLLL9uBAwckGWTw7W9\/2+hj+joBx1ysJsi5xYpTytJE4Pnnn7cH773X\/vWb37Q\/9+Til75kc73wvn370tSMhtva3t5u3d3dkgwymDVrVsOPn1ZVIOfWKvKqt6UEcGAfb9pk73tWrPSEnzjbfm8kd8ZzdKR70fofIsAVfhqfv2F3qCkKZpyAnFvGOANXMgAAEABJREFUOziqeXmO51bkZs+BvRoBgXjSI5JzG42D4PlMGp\/BYTf2V9J5165ds7lz59rRo0cryV5xnmr0kvfhhx+2wcFBX39fX5\/\/3PPGjRt+WH\/KE5BzK89IOTJGAOf2nTJtIl2jt0JIOAeezzzw1Wds9hMvpUbu6\/l6Vc+Vxo0bZ\/39\/dbT01MIoIWh3t5e\/5nnmDFjWmhFuqqWc0tXf8naGAjg3KaV0VMuvUzxTCeP\/uJ4u2tyl901OSUypatofzAamjx5siHTp08fHiUxanIjN\/YZQb355ptGHvIycr106ZI\/uiNMfNQIi\/JOV9gIylAWHQj7xFFm8eLFdu7cOVu4cKE\/gsRW6nUjN0aVlEFcOad\/7dq19txzzw3bRx7yu\/S8bOXc8tLTamcBgXMFoZEB0idNmjQyQTGZIMDJ\/uDBg\/67aRcvXrTt27fb6tWrDccSbuCnn35qP\/\/5z+3EiRN+\/qGhIXvkkUds586dRtn58+fb\/v37w8VKhnFiy5Yt8+tFx9mzZ23atGm2ZcsWGz16tL311lt++PDhwyNGkNi+Zs0aI42y2I4udLpKf\/KTnwzbt379etu8eXPRtrn8WdzKuWWxV9WmYQLcSgtPgLj\/\/vvtxeEcxXde\/Nzn7LbbbvNPZsHy6DP9yxwBbkH2e7ciuSVZrHErV640bgmSPmPGDMOhdXZ2+lkXLFhgV65cMTeq8iPL\/KHsmTNnhh0XuufMmVOmlNnvfvc727t3r61atcrQQQFsx56ggyXs0mfPnm23bt2yq1evkj1x0iiD5NwaRVZ6W04AR8REAm7nhOX63Xfb0xEWEv\/P3rONcBnC6ENvRFFFp4QArza4VxxquW03derUWFrKSJHbltiwdevWsjp\/\/\/vfGyPHcP3hcFlFOcgg55aDTs5SE3lexkQP5NixYyWbhhOKmgDx0Jpd9o9LnrIpnoa9npz0hG3n3e02sHi1\/dVf7xkxYaLaiQmeSv1PKAFGSryYzm29RYsW2eOPP+4\/Uwve2muk6c6p4WSXLFni397k9mEj68ybbjm3PPV4ytv6fI0vXUdNgPiLR3tt3q537Rebvm\/PfmuL\/dCTHi\/c7Tm3ohMmIiYmpBxr7s3ftm2buWdePFdrBhDqY+TIlpmQldb5hS98wSh34cKFgiLhcEFiTgNybjnt+LQ1m5Haxw146fp2b6Q2sWOmdcx71Je0cZG9tRFgUga3AxlBoYHZj4z0eT5FuFbh9iCzHNGHjkOHDtmHH37I7gjh9uLNmzf9eOyp5Lbkn\/zJnxjP\/3bv3j08u5OyR44cseXLl\/u69OczAqM+2+ivCCSXALcieamal6uLWUk86cXSFBc7gUwoZBIGE0O4LcjzLqbcP\/vss8OTNGptJHqZzIE+9DIBhDrC+sgXrJ9JIq+88oo\/\/R\/HyMSV++67z38VgNcALPCPssyQdHUwc\/KNN96o2\/ZAFZnYlXPLRDdmuxE4N16qLtVK0hndlcqjNBEIEuB2JM\/cnOA0SMexMHOScHCfNIRywVuJ5OP5Hc\/xXLrTieMhjTxhXehx+cjD6wXMoHSzHF06dSHkcXWgz5UNlnH1U5Z9BH3Hjx\/PnfOTc6P3JYkmgHObVsbCculliiu5CgL\/9P5Z+6eL6ZGb\/ydfU+Cr6MrWZW1CzXJuTYCsKuonwEvVpbSQrpeuSxGqP23ixInGKvLvHX3TTrz+X1Ij\/\/PvX\/Htxv76KUhDWgjIuaWlp3Js54oVK8q+dL1\/0iSbN2+e6V\/jCOAc0vptN+zG\/sbRkeakEZBzS1qPxG5PNhRu\/N737OmIphD\/lytWRKQqOk4COAgmSKRNsDtODtKVfAJybsnvo9xYyFTs4FJXwX2WzPqX3t4RL11P+dzn7DcLFthDDz00YqksplrnBp4aKgIiUEBAzq0AhwKtIoBjY2krlriKkl\/+8pf2h3vusb\/50z+1h+++2\/7ak1te+L333vO\/dRUuh75WtSdr9ao9IpA2AnJuaeuxjNqLc4taKiv47bC5T263B7+9w1g+CwmmhfdZLiujuDLVLGbD8hoHUm5JtbgaziLHXAzxAjQ6WXaLhYvZEpakn0CinRsHHi9COiFcKXJefOS7RuH8xDl9bktcOJ\/CrSEQtVRW0eWwyn1TTMtltaYTq6i11iXVqqhCWRNDoLmGJNa5cQXFC5B79uzxFxVlS5j4cohwbMWWsuFqjU9TsECpewGSbfCFx3K6lS4CIhAPAUZqjVhSrRLrWCiZZ7psOV+4MnyjzV30MrLjnOHSuLh2aWwJuzTykZ94JHjBzDnriSeeMIQ08gWX\/kIHNhCPHsKS+gkk1rnxbSKWseFNfJrJljDxhIsJBwYHCOuuFZsdxTpuTDJg\/bdi5RUnAiLQHALcimTJNJZOK1Yj8aQXS4sjjovl7u5uY8vqH+j85JNPbOzYsf7FNI6PcwXLWpGGI+ODn8RzQcyHQl944QV\/fUfOOzjJCRMm+GVZDJmL6KCDo9wDDzzgp7\/22muo9BdrZofyrCDCmpFuBRLiJfURSKRzo7M5OMJOqNxHATmAwMHK3jNnzmS3QPhYHx\/tGz9+fEF8BgNqkggkmsAHH3xgLJlWykjSGd2VyhNn2h133DG8+DBLZbH2I6vtcz5i7ceNGzca8dTJklZcSO\/fv9+fpYsj5I4QaTioDRs22KlTp3znRxy63aLM6HC6SWMtyevXr1tXVxdBSUwEEuncSo2wOIhIL9Z+RnfB9dfCeXBuxC1btsy4PYAEr65IKyZMdMBxMumhWLriREAEqiOAcyu3ZFq59OpqrD035xvOO4zOOGc4cY8+cIB8hmb06NHDlXABjUMbjgjtcKHOaA3HyXmJRZJxeqFsCtZBIJHOrY72lCzKQcitB241cGuh2O2DYgp27NjhTzV\/++23iyUrTgSySaDBrWLJtFJVkJ6kJdW4hcl5Iyi1Pq9nlMZojVHbO++8Yzi7UiyUVj2BXDk37q0HV9Dm9gH3ufkWEg99o\/CxdA8jwsceeywqi+JFQASqIJCmJdUYkTEy4+K4WBN5fMLIjhGeS2c0xoW0C4e3jNIYrf3oRz8yHsHg7MJ5FK6PQCKdW6mDiYOM9Pqa\/W+ly90+ICd1dnsPn4tNUiFdIgIiUD2BtCyp5i6CmajmLoK5ncgzN2Y5cm7gHOFuU5K2ZcsW47k\/z+aiyDBa+8EPfmBMRMHZReVLeXzLzE+kc+NgosPDV0oM34knvRZiPF9DgmW5wmprazOcXDBe+yIgAo0lwOht+ve+N2JJtbmTJtmdmzbZc8891zADOIfw0jbP0cLnhGKV8jx\/1apV\/sdDeebGSIvy3A1CF7csGYG5NM5T5W5ZouOee+4xnFyxOhVXH4FEOjeatHz5cuN2IVNwCbMlTDzhWoSDCB3u6uvatWvG9N4lS5YMz4KqRa\/KiIAjwEQJZvghzVptw9Wdxu2KFSvs3UuXbPI\/\/IP9L8\/RjfKk3ws30rE5Tjgmnp\/hhBhhMcGDrUsnHnFhl58yCGGXhoPj0QXxSLAcOsO6XTlGfDg5F9Y2PgKj4lMVryYOCD6lzpUVV0NsCRNPTQz93W0BwpUIV1\/ocJ9n7\/ZuNeLYggdpJXqSmkd2tZaAVtuojT+TRubNm2c4OqQ2LekrxYQ2Rni6JdmYvkusc6O5OCOugpwQJh5xV0pRjokrJ4S8QUGH08c2qnywjPZFoBwBRmqtWm2jnG1KTxYBd2HOXSP3blyyLMyGNYl2btlArFZknQC3IllNg1U1irWVeNKLpSUvThY1moC7MO\/v79fjkAbClnNrIFypzgcBnBuraZRqLemM7krlSWqaW8SAhQwkA\/6KJFnhwCsMST3u6rVLzq1egiqfewI4t3KraZRLTyJEXn2ZNWuWuUUMeMYtWeov6JAVDnzzkD6mr+M8BpOgS84tCb0gG1JPgNU0SjWC9EmTJpXKkrg0TnhuAQNmAkoOWBYZ0Mf0deIOwDoNknOrE6CK549A+Dbd\/fffby+WwfDi5z5nt91224hbWklfr5STHrOKJd2WVQb0sWXwn5xb2jtV9jedQLHbdNfvvtuejrCE+H8eM6bo7SxuCyXdwUU0S9EikGgCcm6J7h4Zl0QCD3z1GZv9xEsF8tCaXfaPS54asdpG593tNrB4tf3VX+8pyE\/5+3q+bowC5dyS2MuyKe0E5NzS3oOyv+kERn9xvN01uWuE\/MWjvTZv17v2i03ft2e\/tcV+6EmPF+72nFux\/HdNScz3u5rOUBWKQKMJyLk1mrD054rA7d5IbWLHTOuY96gvuWq8GisCCSIwKkG2yBQREAEREIG0EkiY3XJuCesQmSMCIiACIlA\/ATm3+hlKgwiIgAiIQMIIyLklrEMqM0e5REAEREAEShGQcytFR2kiIAIiIAKpJCDnlspuk9EiUD8BaRCBLBOQc8ty76ptIiACIpBTAnJuOe14NVsEREAE6ieQXA1ybsntG1kmAiIgAiJQIwE5txrBqZgZayLG9dHGLH80UceKCIhA8wnIuTWfea01Jqocjo0V7ZcuXVp0tftq49GVqAbKGBEQgVQTkHNLdfe1znicGyvaF1shnxXvqxVWyG9da1SzCIhA1gjIuWWtR5vcnqgV8ouugl9kJf3hfFohvzk9p1pEICcE5Nxy0tFqpgiIgAjkiYCcW556W20VAREQgfoJpEKDnFsquklGioAIiIAIVENAzq0aWspbFYFPPxqy88d+7Mvl86eqKqvMIiACIlAPATm3eug1oWxaqxh4a6cde\/JB+9p3N9gLnnx50zfsqBfG2Zn+iYAIiECDCci5NRhwHtXjwLo95\/a+1\/iVnszyhO2gN5Lr8Bwd6V6U\/ouACIhAwwjIuTUMbT4VcyvygufAXo1oPvGkRyQruiEEpFQE8kdAzi1\/fd7QFuPcvlOmBtI1eisDSckiIAJ1EZBzqwufCocJfHptyKaFI0Phcumh7AqKgAgkgEDaTJBzS1uPpcDec2VsJP32ce1lcilZBERABGonIOdWOzuVLEKgY96j9mKR+GDUq3e328SOmcEo7YuACIhArARGxapNyuIhkHItU7+1xZ6OaAPxYzwHGJGsaBEQARGIhUAszu3atWs2d+5cmzx5sv\/5kxs3bsRinJSkk0CH57zOew5uimf+Xk9OesK20xuxDSxebd2eeFH6LwIiIAINIzAqDs3jxo2z\/v5+W79+vfHxyq6uLjm6OMCmWEeH5+Dm7XrXfrHp+\/as5+h+6EmPF5Zja1qnqiIRyDWBUXG2vre31y5evOhL2NGtXbs2zqqkKwUEbvdGajxb6\/AcHZICk2WiCIhARgiMalQ7nKNbtGiRX8WhQ4f80ZycnI9Df0RABEQg+QRSbGHszi34\/I1ncEeOHLHDhw\/7o7k9e\/YYTk4OLsVHjEwXAREQgRQQiMW5BR1ad3e3ffjhh4Yj4xblmTNnrLOz00fR09PjP5c7ffq0UcaP1B8REAEREAERiJlALM7N2cRzNhwagiNz8dpWQgXb8ngAABAASURBVEB5REAEREAE4iIQi3NzsyV5zlbOMPIws5Iy5fIqXQREQAREQARqIRCLc6ulYpURARGIn4A0ioAIfEYgFufG87OHH37YBgcHP9Ma+tvX1+e\/5E2+UJKCIiACIiACIhA7gVicW+xWSaEIiIAIiECLCGSj2pqdG0tsLV261H93jRmS586ds4ULF\/phXgEIytatW23JkiWm52zZOGjUiuYR+OCDD2zfvn2+HDt2rHkVqyYRSDmBmp3bmDFj7MCBA\/77ayy5NW3atOH32ZgtGRYmkqSclcwXgaYSeP755+3Be++1f\/3mN+3PPbn4pS\/ZXC+8b9++ptqhykQgjQRqdm7BxjIi++lPfzr8PlswTfslCShRBIoSwIF9vGmTve+lrvRklids+72R3BnP0ZHuRem\/CIhABIFYnFuEbkWLgAjUQIBbkZs9B\/ZqRFniSY9IVrQIiIBHoGbnxsxHPnPDc7dLly75syGDz9nC++SljFen\/ouACJQggHP7Tol0kkgfHr0RIREBESggULNz41YkL2Pz3O1e7zkA++HnbMEw6ZQpqF0BERCBEQRwbtNGxBZGlEsvzK2QCOSPQM3OLX+o1GIRaB6Bc2WqIn3SpEllcilZBComkLmMNTs3bjFyqzF8+zEqTF7KZI6gGiQCMRNYsWKFvVhG5\/5Jk2zevHmmfyIgAsUJ1OzcuMXIrcbgrcdS++SlTHEzFCsCIhAksPF737OngxGBfeL\/csWKQIx2RUAEwgRqdm5hRa0IB18kZ8TI5BbiKrGFUWSpJcMq0VFrHpUTgXIEGL1N9xzcFC\/jXk9OesJ27qRJduemTfbcc895MfovAiIQRSDVzm2T9yOnYWfPnjWEfRfHfpTg2BYvXmy\/\/e1vo7IoXgSaRuDkyZPGQghhuf\/+++2\/\/t3f2Ud\/+7e2r7fXTnvy0sGD9tBDDxXN78pfvny5abarIhFIKoGanRsOgudojJZa8SoAizSfOnXKNmzYYKyWgrBPHGlRwI8ePWosF3br1i274447orIpXgSaRmDHjh3G76iYcEy\/\/vrr9stf\/tKXf8uzNLLMunXrTA6uad2nihJKoGbnxvMznqO16lWAq1evWltbm40fP34YLa8kTJw40UgbjgzscMty7969tmfPHtu1a1cgRbsi0DoCD3z1GZv9xEuxyH09XzdGgnJuretP1ZwMAjU7t1abf+HCBWtvb7fRo0ePMIW0EZFeBKM7nHFPT48Xqvw\/Jwtu+eiEUTkz5aycwOgvjre7JnfFI1O6Kq9YOXNPIMsAUuvcmtkp7rbR22+\/3cxqVZcIiIAIiECNBGJ1bu45HDMXnfCMgNuBNdqXiGIvv\/yy\/wWExx57LBH2yAgREAEREIHSBGJzbm6iBt9tC77vNmfOHJs9e3bkV7pLmxedOnXqVBsaGrKbN2+OyETaiMg6Irj9ySQUnufVrEYFRUAEREAEmkYgFufGyIyJGosWLbLwd9sIz58\/37Zs2WLki6tlTCRhxmNw8gizNnkuRlpc9UiPCIiACIhA+gjE4twYPTGKihoxEU86+eJC1NnZaTNnzhx2mjhOHChxpMVVj\/SIQIIIyBQREIEKCcTi3JixyK27qFmKxJNOvgrtqiibe2G7q6vLEAq5OPa5Vcq7eDwLJCwRAREQARHIB4FYnBtT7HnZ9MiRI9bX11dAjjDxpJOvILHOAPqY2u+e8bFPnFPLlH\/exeOdPBfntozujh8\/bmxdnLYiIAIikHkCOWlgzc6N0RCjIjcrcuHChXb9+nXbunWruTi2hIlfvXq1USYnXNVMERABERCBFhKo2bkxGmJU5EZN5bbkpUwL26qqRUAEREAEckKgZueWEz51NlPFRUAEREAEWkEgNufGLcfgbUpuSQaFNPK0opGqUwREQAREIF8EYnNuPFtjRiSfnlm\/fr3xzhu3Kg8fPmy8\/Lxz507Tbcl8HVxqbTwEpEUERKB6ArE4N0Zkp0+fNlYjYbYi77VduXLFf2mb2YgswbV\/\/\/7qrVMJERABERABEaiBQCzOLVwvK4QwQ9K9tM3yW++9955mS4ZBKSwCIiACTSGQv0picW68nM0tSYcP58Z+cGkswhIREAEREAERaAaBWJwbtyK5JXnw4EF\/dMaztfvuu89OnDjht4Ht2LFji357zc+gPyIgAiIgAiIQI4FYnBv2sEDyjBkz7KmnnvKftTGpBGfHjEm2r732muEEyZtxUfNEQAREQARaTCA250Y7tm3b5n\/3DCfG6K2\/v9+YMcmWMHkkIiACIiACItBoArE6t0YbK\/0ikBsCaqgIiEBdBGJ1brwSwMva3Ip0wmsAfI6mLitVWAREQAREQASqIBCbc+PzMt3d3bZkyRL\/ViS3IxEmmvAqwODgYBVmKasIiIAIiECdBHJdPBbnxshs7969\/qokTCwJEiU8f\/5827Jliz\/RJJimfREQAREQARFoBIFYnBsvaw8NDRkrkxQzknjSyVcsXXEiIAIiIAIiECeBWJybe4mbL24XM454XvImX7H0LMSpDSIgAiIgAskhEItzY+r\/hg0b7MiRI9bX11fQOsLEk06+gkQFREAEREAERKABBGp2buGZkfoSdwN6RypzRkDNFQERiItAzc6Nl7J5OZsZkZUIeSkTl+HSIwIiIAIiIAJRBGp2blEKFS8CIiACItA6Aqr5MwJybp9xyMXfy5cv28DAQCzC7NdcQFMjRUAEUkkgVufGi9rTp083tzoJW8LEp5JOhozGsa1bt85YMSYOQVeG8KgpIiACGSMQm3NjhRImlaxatapghRLCxJOeMXZmKWoQzu3kyZP2wFefsdlPvFS33Nfz9RS1XqaKgAjkjUAszq3cCiWLFi0yVjAhX94AJ629o7843u6a3FW\/TOlKWtNkjwiIgAgME4jFubHyCM9gWIlkWHNgh3jSyReI1q4IiICZGIiACDSAQCzOjZVHWIGElUiK2Ug86eQrlq44ERABERABEYiTQCzOjZVHVq5caYcOHSq6QgnxpJMvTuOlK14Cn340ZOeP\/diXy+dPxatc2kRABBpHQJpHEIjFuaG1p6fHDh8+bLt37y6YLUmYeNLJJ0kmgYG3dtqxJx+0r313g73gyZc3fcOOemGcnemfCIiACKSMQCzOjYkiTC+\/evWqnTlzpmC2JOHOzs6UYcmXuee90Vq359ze95q90pNZnrAd9EZyHZ6jI92L0n8REAERSA2BWJwbE0WYMMKztdS0vGZDs1WQW5EXPAf2akSziCc9IlnRIiACIpBIArE4NyaKMGEkkS2UUSUJ4Ny+UzKHGekavZWBpGQREIFEEYjFuTFRhE\/aHDhwwLQaSaL6t6wxn14bsmllcpVLL1NcyUUIKEoERKCxBGJxbnz+ZvXq1cYqGKxGwrJbYZk7d66Rr7HNkfZaCJwrU4j028e1l8mlZBEQARFIDoFYnBufsuGTNqU+fUM6+ZLTdFkCgY55j9qL7JSQV+9ut4kdM0vkUJIIiEDzCajGUgRGlUpUWj4ITP3WFns6oqnEj\/EcYESyokVABEQgkQTqdm59fX0F77VpgeRE9nNJozo853Xec3BTvFx7PTnpCdtOb8Q2sHi1dXviRem\/CIiACKSGwKh6LMWxuZe0uSXJy9pr1qwZsUpJPXUkpGzmzejwHNy8Xe\/aLzZ93571HN0PPenxwnJsme96NVAEMklgVK2t4sXt48ePG5+0cS9psyVMPOm16la51hC43Rup8Wytw3N0SGusUK1xEODzRnF9mJaJYnHYJB0i0EwCo2qtzL24HS6vLwCEiSgsAn8k0MTNjh07jFWD4pB169b5M6GbaL6qEoG6CdTs3ErV\/PHHHxtLcZXKozQREIHGEYjzo7SMAjV6a1xfSXNjCDTEuTXGVGkVARGolIA+SlspqdTlk8EVEpBzqxCUsomACIiACKSHgJxbevpKloqACIiACFRIoG7ntnXr1oL33B5\/\/HG7fv26hZfhSuPyWxUyVDYREAEREIGEEajZubGUFktq8X5bJUJeyiSs\/TJHBERABEQggwRqdm4ZZKEmiUADCEilCIhAKwjIubWCuuoUAREQARFoKAE5t4bilXIREAERqJ+ANFRPQM6temYqIQIiIAIikHACcm4J7yCZJwIiIAIiUD0BObcwM4VFQAREQARST0DOLfVdqAaIgAiIgAiECci5hYkoLAL1E5AGERCBFhNItHM7evRoweonhMvxWrt27XCZYquiBNMnT57s5yWunF6li4AIiIAIpIdAYp3b4OCgrVmzxvbs2WOsgMKWMPFRePv6+uz06dPGRxopM2PGDHvqqafMfTiV7ZUrV2z9+vW+TvIg27Zti1KpeBEQARFoDQHVWheBxDq3\/fv32\/z5862np8dvIFvCxPsRoT\/Xrl2zgwcP2saNG80t84UTGxoa8p0d2W\/evGmEp06dSlAiAiIgAiKQUQKJdG5uhBV2QgsWLDBGXqSH+4OPo966dcvGjx8\/nISTY\/R24cIFP65YHj9Bf0RABERABDJFIJHOrdQIi5EX6eFewHG1tbUVODeXJ+jciFu2bJn\/rI1nbp89byM2Wk6ePOmP\/i5fvhydSSkiIAIiIAKJIZBI59YoOji5Tz75xN544w3\/mdvZs2f9kWA5B7djxw5bunSpvf32240yTXpFQAREQARiJJAr59bb22tnzpyxzs5O49+YMWNs5cqVduTIESs1UeXll1+2AwcO2GOPPUYxiQgUJaBIERCB5BBIpHMbPXq0tbe3GyOtMCriSQ\/H86yNZ27cngynhZ\/dBdMpd8cddwSjRuxTZ3d3t02cOHFEmiJEQAREQASSRyCRzo0R1YQJE0Y4t3feeceIJz2MEifV1tZmQefGDEpeDXDOjduPSLAs+dvaij+rC+bTvgiIgAg0noBqiItAIp0bjVu+fLl\/u9C9uM2W24fEkx4WZkYuWbLENm\/ebDg10rdu3eqPABl1EWa2JTrcLUjykZ9ylCePRAREQAREIP0ERiW1CTwX2759uz3++OP+zEa2hInHZl4HYJIHL24TRnimxtR\/nBkzIRm1vfbaa+ZGerwrh46FCxf6OsmHY6Mc5SUiIAIiIALZIJBY5wZenBEriDghTDyCw2KSR9gxsdqIy9\/f3z\/8QjdlEHT8Md2fMRkuTx6JCIiACIhAugkk2rmlG62sFwEREAERaBUBObdWkVe92SCgVoiACCSSgJxbIrtFRomACIiACNRDQM6tHnoqKwIiIAL1E5CGBhCQc2sAVKkUAREQARFoLQE5t9byV+0iIAIiIAINIJA759YAhlIpApkn4L6MMTAw4H8ho56tvq6R+cMlEQ2Uc0tEN8gIEUg2AfdlDBZOqFfWrVtncnDJ7u8sWCfnloVeVBuaTCB\/1T3w1Wds9hMv1S339XzdGAXKueXvGGp2i+Xcmk1c9YlACgmM\/uJ4u2tyV\/0ypSuFrZfJaSQg55bGXpPNIiACqSegBjSWgJxbY\/lKuwiIgAiIQAuwEMvhAAAQAElEQVQIyLm1AHqlVfJcop5ZacGyQ0NDlVarfCIgAiKQegL5cG4p7CYc239+8mmrd2aaK88MtRRikMkiIAIiUBMBObeasDW+EM7tfw\/+d4tzllrjrVYNIiACIpAMAnJuyeiHSCs0Sy0STbMTVJ8IiECKCMi5paizZKoIiIAIiEBlBOTcKuOkXCIgAiJQPwFpaBoBObemoY6\/ok8\/GrLzx37sy+Xzp+KvQBpFQAREIKUE5NxS2nEDb+20Y08+aF\/77gZ7wZMvb\/qGHfXCODvTPxEQARHIOYEMO7fs9iwOrNtzbu97TVzpySxP2A56I7kOz9GR7kXpvwiIgAjkloCcW8q6nluRFzwH9mqE3cSTHpGsaBEQARHIBQE5t5R1M87tO2VsJl2jtzKQKkxWNhEQgXQSkHNLWb99em3IppWxuVx6meJKFgEREIHUE5BzS2EXnitjM+m3j2svk0vJIiACzSGgWlpBQM6tFdTrqLNj3qP2Ypnyr97dbhM7ZpbJpWQRaB0BPlgaXNi7nn2WqmtdS1RzUgmMSqphsiuawNRvbbGnI5KJH+M5wIhkRYtAIgjs2LEj1kXB5eAS0a2JMiJrzi1RcBtlTIfnvM57Dm6KV8FeT056wrbTG7ENLF5t3Z54UfovAoklEOeC4IwC5dwS29UtM2xUy2pWxXUR6PAc3Lxd79ovNn3fnvUc3Q896fHCcmx1YVXhJhHQguBNAp3jakbluO2pb\/rt3kiNZ2sdnqNDUt+gpDRAdoiACKSewKjUt0ANEAEREAEREIEQATm3EBAFRUAERCAGAlLRYgJybi3uAFUvAiIgAiIQPwE5t\/iZSqMIiIAIiECLCWTCubWYoaoXAREQARFIGAE5t4R1iMwRAREQARGon4CcW\/0MpSETBNSINBPgRe56lvAKl9VL4Wk+Gj6zXc7tMw76KwIikGICcS7ntXTpUlu3bp3JwaX4gPBMl3PzIOi\/CIhAugnEtZzX7Cdesvt6vm6MBGtxbummmC3r5dyy1Z9qjQjkkkBsy3lN7rK7pnTlkmHWGi3nlrUeVXtEQAREQAQsvc5NnScCIiACIiACEQTk3CLAKFoEREAERCC9BOTcYuo7Hj6HpxPXEx4aGorJMqkpQUBJIiACGSUg5xZDx+LYmDrMFOK4BH0xmCYVIiACNRJgxmQ9F6jBspwjajRDxWokIOdWI7hgMQ5cfghxT0cO1qF9ERCB5hKo+N25pUut3EUtF6ucJ5rbgnzXJucWY\/9rOnKMMKVKBFpMIK6LVb0315qOlHNrEvdPPxqy88d+7Mvl86eaVKuqEQERqJVAbBerem+u1i6oq1zKnFtdbW1Z4YG3dtqxJx+0r313g73gyZc3fcOOemGcnemfCIiACIhA7ATk3GJHWqgQB9btObf3veiVnszyhO2gN5Lr8Bwd6V6U\/ouACGScAM\/lg5NM6tnX87vyB4ucW3lGNefgVuQFz4G9GqGBeNIjkhXdIAJSKwKtIKAJKs2lLufWQN44t++U0U+6Rm9lIClZBDJAQBNUmtuJcm4N5P3ptSGbVkZ\/ufQyxZUsAiLQEgLVVxr3BJU4b3NyizRrtzrl3Ko\/Rqsqca5MbtJvH9deJpeSRUAERKCQQJy3OXlPj3fx3n77bcPRlZNCS5IZyp1zGxwctOnTp9vkyZN96evra1jPdMx71F4so\/3Vu9ttYsfMMrmULAIiIAKFBOK6zRn8hh0ODkdXTgotSWZoVDLNKrAqtsC1a9ds9erVtmrVKrt48aIdPnzYdu\/ebUePHo2tjrCiqd\/aYk+HI\/8YJn6M5wD\/GNRGBERABComENttzsA37CpxmAcOHKjYxlZmzJVzO3TokLW3t9uyZct85p2dnb6j27t3r924ccOPi\/tPh+e8znsOboqneK8nJz1h2+mN2AYWr7ZuT7wo\/W8hgd\/97nfGiJ5tC81Q1QEC9IX6JACkSbvlHOYXxk8xnvWl4fncqCYxS0Q1Fy5csAkTJtiYMWOG7Zk9e7Zdv37dbt68ORwX906H5+Dm7XrX9q\/aZv\/xPyy0vcv\/xnq8sBybNe9fiZo4kf761782tiWyKamJBOgL9UkTgVdYFf3Csz45twqBNSMbI7MrV67Y1KlTR1T3ySef2NWrV0fEuwiuVEo9YHWfp7l29Zpx67OY\/Mutz9sXJ02zL\/zZv7fb\/mx6ZD5XloOI+kvpdHkr2eZNH0wqbbPLxzFAuShx+ZLaJ9iddBsrtc\/la3afZIkhbalUHO9yx7bLx7kp6TIq6Qa20r6JEyfarFmzjCuVUg9YeQiLnYO\/HrT\/9ovDkXLy+FFr+7837Nz\/GIjM48rjTP\/fv5ti5XS6\/OW2edMHj0rbXGm\/VKqPuiuRuPVRZ9w6W6WvVX1ShmHZ3y3lw9IqhmE7SoUrtZF+4ZzIuZFzXpJFzq1E79CBL7\/8svEAtRI59MIK+\/Hf\/KdYBF1\/v3OzsY1DJ3rypA9manP9x6IYZp9htb8VzomcG0ucOhORlBvnxnM2nrfx3C1M\/o477rDx48eHo\/0wndjd3W0SMdAxoGNAx0C3cU70T44J\/5NY59YIbjxv47kbz9+c\/hMnTtjYsWNt9OjRLkpbERABERCBlBPIlXNbtGiRMfnjjTfe8LuNqca857Zy5cqCGZR+ov6IgAiIgAiklkCunNu4ceNs586d\/ovbrFCycOFC\/z23np6e1HagDC9FQGkiIAJ5JZAr50Yn8+L2mTNn\/BVKLl68aL29vURLREAEREAEMkQgd84tQ32npoiACDSBgKpIJwE5t3T2m6wWAREQAREoQUDOrQScOJOYocmL4DzrQ9gnLs46pKs6AiyYTV8EZe7cuf7qMdVpUu44CLCaxsMPP+yv8xnWt3btWv8rHvSV+ihMp3HhqD5hMl7w6yr0C2HiG2dNdZqT5dyqsz1VuTdt2uTbe\/bsWUMIuDj2Jc0nwDuPvLdEf\/D8Fenv7zcmHjXfmnzXyEl08eLF9tvf\/nYECD5Ldfr0af87Y\/TRjBkz7KmnnmrYYucjDMhpRKk+YVm0O++8c7hP6BfmMjCnISm45Nya0BNczZw6dco2bNjgv3LAC+XsE0daE0xQFUUI4Nx4sZ\/+KJKsqCYRYATNRcatW7eMBRWC1XKCPXjwoG3cuHH4omP9+vX+Kz0sGRXMq\/34CJTqE2rht8MXVpL8frCcGz3VYOEqp62trWAVlHvvvdd\/05+0BlefN\/UVtZdbwrzQz4v9FRVQpoYQoB\/45NSePXts165dI+rg94HTC64gxMia0Rsn2BEFFFE3gXJ9QgWwT\/qFoZwbPdVg4UCIusohrcHVS30RAnziiE8dsWYozwsQPcspAqrBUYya6YOod01xbm1thReGziT9dhyJeLfl+gTnx4Xhb37zm+HnoEl73gYROTcoSHJHgJMmz3eY2MPzAmTJkiXGcx9uheUOiBpcSEChSAJcGLLS0\/333z\/8vvD27dtt2bJlRScDRSpqcIKcW4MBS30yCfDgmwfgwZf4WZ4Naw8dOsRGIgIiUIQAt4WZeLVt27bhVJ6ZTps2zfbv3z8c1+odObcm9ADPdbjS4YonXB1p4TiFW0OAh+PcPm5N7aq1GAGetfHMjZF2OF2\/nTCR1oW5lckzuNZZMLLmBDi3kUZlLabYD\/TSpUt2+fLlgkkmWWt3ktvDbLDwMzYuPrgI0UkzOT3Hb6etrc2Czo3bxrwaoH5qTT8xw3vOnDkFtyDdc7gk9YmcWxOOD26BzZw507Zs2eK\/m8OBwD5xpDXBBFURItDV1eXHBG9Bbt261Ri5cYvFT9SflhPgFhjPQjdv3jz8cr36qbXd4mZ6B29B8qUVLgzdrf3WWvhZ7XJun3Fo+F\/3wjYnVYQKXRz7kvoIVFuak+Zbb71lvEPFTEmEGWBMSecWS7X6lL9xBHguytR\/LjroJ0Ztr732mv\/OaONqleYoAvw++J3we6E\/EH5H\/J74XUWVa3a8nFuTiHNAMOWZWXkI+8Q1qXpVU4QAP8T+\/v7hGV\/qkyKQmhjFXYzjx48b23C1TF7gd4PQZ\/RdOI\/C8ROgL4r1Cecufi\/0B5LEPpFzi\/94kEYREIFUEpDRWSIg55al3lRbREAEREAEfAJybj4G\/REBERABEcgSgVY5tywxVFtEQAREQAQSRkDOLWEdInNEQAREQATqJyDnVj9DaWgVAdUrAiIgAhEE5NwiwChaBERABEQgvQTk3NLbd7JcBESgfgLSkFECcm4Z7Vg1KxkEWMOSFRyC0tfX13LjsGvt2rUtt0MGiECjCMi5NYqs9OaaAOuH8q24NWvW2OHDh4dXQWF\/9+7dRhp5WgGJevn6dSvqVp0i0CwCTXVuzWqU6hGBVhNg3VAWkj1y5EjBclIsZ8Qis+fOnTO2rbZT9YtAVgnIuWW1Z9WulhHgkyA4NVazL7YGIquqv\/766\/bQQw8V2MjtyuDty+BtQ0ZbjPaCcRTm9iJl2Lrw9OnTjTCf9CENceX4XMxXvvIVGxgYML6IQF7spaxEBLJEQM4tS72Zi7Ykv5F8e+z69esW9W0rFp1lhXucnGsNzofbldy2ZCFanA+r3+PQcGwuXyVb6uYTMazSji5WcMeR4Txxtj\/\/+c+N+vk8yZkzZwpGlpXoVx4RSAMBObc09JJsTBWBCxcu2NixYyv+EC0jJ0Z627dvH3Y0OKGNGzf6IywcXbUAKIsOyuHIEOwiLBGBPBCQc8tDL6uNiSbASA8D+eo0Wyd89++ee+6xap1SNY7V1ZW3rdqbfQJybtnvY7WwyQS4HcmtQee0ylVfrfMqpy8qnY9LVnuLM0qX4kUg6QTk3JLeQ7IvdQQqGXHxjI0JH0zwwBmmrpEyWAQSTqDxzi3hAGSeCMRNgGddM2bMsIMHDxrOK6zfPWMjD3nd7cgTJ04UZD179qx9+OGHkRNTyNysUR91SUQgTQTk3NLUW7I1NQR4z629vd3mz59vODNnOPvLli2zO++809avX+9H8+4b+ZgtSTqROEVmPDIRBGGG5Zw5c4yJJy4PW8qQvxpB14QJE0y3KauhprxpIyDnlrYey6e9qWs1DuTAgQO2atUqW7hwofGuGcI+cf39\/caozTVs27ZtBXlxaLwnhw50ka+3t9d3luhA1+rVq40ZlkwgIb0aWbBggT8Tk1uovBNXTVnlFYE0EJBzS0MvycbUEsAh8a5ZUIgr1iDiy+XDCbo8OMienh7jXTW26GRLmNEgYQTniJNE2CeOfE4P+8RJRCBLBOTcstSbaosIiEA0AaXkioCcW666W40VAREQgXwQkHPLRz+rlSIgAiKQKwINcm65YqjGioAIiIAIJIyAnFvCOkTmiIAIiIAI1E9Azq1+htLQIAJSKwIiIAK1EpBzq5WcyomACIiACCSWgJxbYrtGhomACNRPQBrySkDOLa89r3aLgAiIQIYJyLlluHPVNBEQARHIK4E4nVteGardIiACIiACCSMg55awDpE5IiACIiAC9ROQc6ufoTTEcV2SRwAAAC5JREFUSUC6REAERCAGAnJuMUCUChEQAREQgWQRkHNLVn\/IGhEQgfoJSIMI2P8HAAD\/\/\/hfB3QAAAAGSURBVAMACV2u4UiH2o4AAAAASUVORK5CYII=","height":299,"width":399}}
%---
%[output:3bb0d340]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:4fea133a]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:69eeabae]
%   data: {"dataType":"text","outputData":{"text":"    0.0047    0.0245    0.0637    0.1104    0.1435    0.1493    0.1295\n\n","truncated":false}}
%---
%[output:2b1b3318]
%   data: {"dataType":"text","outputData":{"text":"    0.0052    0.0272    0.0707    0.1226    0.1594    0.1658    0.1438    0.1068\n\n","truncated":false}}
%---
%[output:3e9d5534]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 7.309114\n","truncated":false}}
%---
%[output:04849e0b]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 6.756690\n","truncated":false}}
%---
%[output:3ae6264a]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAbcAAAFJCAYAAAAYD2OCAAAQAElEQVR4AeydX6gVV57v15lHUdIDjYLaF3SEfhCVgWsUhPhiGqE7CIYe0BFyWy6O0jbxtsbBB0HwQcY\/g6ENOj7YBByFCZGWEAjoi4Jg9F4GlTT0xVHoqKA0TILiq+OnzDpTp86uffbZVXvvVbU\/4jpVtf781lqfVXt99\/pTtf\/qlf8kIAEJSEACLSPwV8F\/EpCABCQggZYRUNxa1qAjqY6ZSkACEkiMgOKWWINYHAlIQAISqE5AcavOUAsSkEB1AlqQQK0EFLdacWpMAhKQgARSIKC4pdAKlkECEpCABKoTyFlQ3HIwPJWABCQggXYQUNza0Y7WQgISkIAEcgQUtxwMT2dDwLgSkIAE0iWguKXbNpZMAhKQgAT6JKC49QnOZBKQQHUCWpDAoAgoboMiq10JSEACEhgZAcVtZOjNWAISkIAEqhPobEFx68xFXwlIQAISaDABxa3BjWfRJSABCUigMwHFrTOXVvjeu3cvrFq1KixdurSr+9WvfpWFb926Nbx48aJb3QcW9uzZs7B+\/fqsHFevXq0tnzNnzoR9+\/ZN2uMcHhwnPRt+QpvRdnVyGxYS2qFt7dELu\/z9Tv2Ljs8CcXqxZZzOBBS3zlz0bQEBOs6jR4+2oCblVaAD\/PnPfx5u3rxZHskQCYwhAcWtxY2+YsWKcOfOnfDgwYPM7d+\/P6vt2rVrw927dzM\/wn7\/+99n5xcuXAhz587N4gz7z\/z588O1a9eycmzYsGHY2ZvfMAmYV8jf73wGcZcvXw7z5s3L6GzZsiWLk134py8Ciltf2NqViKk7pkWY2mKKi9EA0yL4\/eEPfwj4c45jNETtYxr8iEsa\/KNjioyw6GK6GF48kh47xCct4XFalalVRib5chCXNMQrOupA3EuXLmVBHPN2M8\/Xf6J9wnDU6bX35P9ohzAc5SDNZISSE+wQP++KdSIs+kUzMR1lJ2\/84Ubc6PJloCzvvvtu+Pbbb4kaduzYkU3tRi4c4RTTco5fFvn1n3x+tHOMF\/MgLmmiP\/FfJ5v2n7JSZuLl43COX7RHwrzNYv2pD3FJgyM9aaLL50M4cUkTwznHDzeb+6WYHtvRwT+GdzpSxhi30xF+1LlT2rwfdTty5Eh4\/vx52Lx5c9i5c2c+2PM+CChufUAbpyS\/\/e1vp0x5IRS\/+MUvQn66j841f80Hno42z4l0dIB8iPP+vZzzgSctHVaMT5579uzpe43w1q1bYdu2bVlnEm1Sh9jh0iEVp\/sox6ZNm0KME9Plj9QdO3k\/zvfu3RvofBlNI0j4ffXVVxwyB5fr169n5++88042gqZjhVvm+cMfyrB79+5A+X7w6nggL\/KBU4zAOX6ERT+OcKWdOceRx69\/\/etAXNLghzt9+nRWB87zjtE+ZcaPOlAXHOf4Ye\/p06ecBo7fffdd+MlPfhJWrlyZ+fGnzvYgv9neLzAp3g+UC\/60KeeDdLQBDi5xhmWQ+bXA9oxVUNxmRDTeEeIUJtOYnEODDo8pFKZS+JaJ3+3bt7MOl06CTpDplRgnpuXDiyP+bB15Y4c844f\/m2++CQ8fPpxmis6WKdZYNo6ky093Pnr0KJw4cSKbBqVMdCoYioKDQFHPmJb0Z8+eJUo4d+5cqajev38\/ixPTUWbKTof76aefZmEbN27MjpEZF9SD+lAO0iIOT548IShQX\/KP5aRcdLoI5ZUrVzKhICLlu\/Z6anfOnDkhjgJiWtJzni8HaaIjLXE44gcfxA0\/2pH2JO2NGzcInubWrVuXTak9fvw4vHz5MnOcx4iRK+mxs3r16inTbuRXZ3vAHPaUn3pTDvjCmfOiQ3QpF\/zhnE938eLF7N4upuGaERZxyxztwRQkccscX1QOHz6cBTsdmWGo5Y\/iVgvG9hrhGzligVu4cGFW0eXLl4clS5Zk57Gjzi5e\/4mdBB0FoxymaviGTofxOjjETo7z2bjt27dnoxnSxI6U834dnR+O9HQ+dLac4\/LCgohQB1wcjXbrJJctW4aJENMdOnQoILR0fsePH8\/C4EEnikjRAeOJ8MGMclCePG+ElvyxSWeJrZ1dpq0QlygsMS3pOSevvKhyTVkoE+cLFizIRIrz2La0NW2OX5mLcWKdqBfnixcvzuwh1HTicTQXbUd7tAWOa+oPB85x\/bTHbO+XWG\/KTDmYTuRLBqxhTpkoyyBcZEU7kOcg8hhHm4rbOLb6LOpMZ12MjsjR+Rb9uY4jF87rcowa6HzqsoedbnXIiwNxZ+MQnXwHhSAhLLg4vUVHyTd07CL2dPoIDvX84IMP8M4cwkhHm128\/oM4YQfXbWqULxhM\/b1O0tP\/RYsWBUZ7+ciUZTbMuR\/4IoQN6oTjnC84CCNfCOjEEd1Otutsj072KUs3xyiYkWOME0UO1kxxIrAxLH+kTYlT5hBJ2jefpngeWSHo3BvFcK\/7I6C49cfNVCUEohjyLZTRGt988y6OXkqSJ+FNR0+HT2GY0sqXn3N2oNIZEt7JUUfi4eI0H\/Hy01tx9ImoMbVIZ4oIMAIiLg7BiKM+bFEW\/HHdpkYRpR\/96EdEC+RP2rwb1Egk1on6sIaGyPzsZz8LCBej0pMnT2abX4r1zAra5U\/V9uhiekoQ09aRE\/cu9zAROMdxXrdD+LgHsFsczeKn65+A4tY\/O1N2IEDHSqdGZ82ohSh8gPkGy7fbbiMO4qbgEBU6ZMqSF6T4Lb3smzzf7gmjnmwGIT0dJgLDOaMpRlWcI2J08nA6ePAgXiE\/lZZnRr5EYFQYBY4RECNM\/IsuLwZ5EaRM+bIV01W9jnVCyFhDo374vem0Q\/jjH\/+YZcEID8bZRQ9\/iNtPe\/RgejIKjGHDfQp7RlCfffbZ5Hpm2YwEbRIFsdNxpi8SjGa5B\/jM8NmZLJAnlQkobpURaiBPgBENGxHwi9NoTK3xAeaII2yYDpGl46ID6zVfpgfpcGK5SU99SJ8XIa6joxMmjOuYJ+niWh1c4EN4Pi7XjBLiuhfXdK5x6pJ8sYPjnHDCiMN5dOTDNng2TcRyMOLALmkpE3WibjFNnUfqhHBFmwgSfuRP\/fAnf0Z4nM\/GUWbSzqY9ZmOfqWTKmLfPvco1\/oTPxl6vcaNoMtJW3Hql1ls8xa03TsaaBQGm5eIIIyajo2AEQ2cX\/QZ9pAx0TP3kgwgxvVZMTx0YjZXZJCzuLszHoXOES94v3+l3Wm9hVEB++TScUy\/COEfg4siP6+g6lQNxOH\/+fKBuMV7dxzgtjd04YqOM1A+\/OJrjfDaOMvfTHr3mQRm\/\/PLLwH2aT0P7M4IjPO9f9znT4Iy467bbNnuzqY\/iNhtaDY9Lh8jUCes4eZEp+vNBZjqFuHSSsdp0zvhxjH6E40d80kX\/aJMwXDHPGC8eSYsN4mITfzo01rdwnOOH4xw\/HOf4dXJ5m9ilTJSdc475NFwX\/YvpCY9ly6ctnlMmykb86LBfjMcUJVOViA4jk2I41+QXbcQj9SAsunwc8iV\/wjhyHdNxjh9hOOwQlm8bwomH45x43CvEIS5p8Ctz+bJwHuNRf9JjB3tFf8KjH0euic+Ra9xM7UF5KTeOc9LgOMcPxzl+nRzlonzkGx33JPl2il+HHzzJi3zJvw6b2nhDoPHixhoOUy7Rcf2mauV\/49oDaeIcez4201eERcd1PtxzCVQhwD3KvcVOQtan+h3NVCmDaSXQdgKNFjceGObND0zd8O2HI9f4lzUcQsXuJNYiSMN0yZ7cmy4IZxNBDOfINf5lNlvpb6WGQoBpL3YR+q19KLjNZIwINFrcePCVRfo4\/cGRa\/w7tSG7oBAq1ijiVAPrF+w8Q8TY7cZDpvnFeuJxjT\/hnezqJ4HZEOA+5YsVbtDTXrMpl3El0CYCjRU3hIa3HuQXsGkYFrHxJ5zrvGON49WrVyG\/KwnxYvTGriW+PTP3zTx4Pp3nEpBAXwRMJIGREWisuPGMDyOuorhBEn\/COc87xG1iYmKKuMVwxC2e54+IJKO2uK05H+a5BCQgAQmkSaCx4jYsnLwCCbFk+rIsTx5YZVpTdzP7BQE5yMF7oL33AP1dWV84EP8+jSpuXcCxq5Jna06dOjXlDeb5JDT0Rx99lP3mGW+n0G2VxVYZ+Dlo7z1Af0e\/l+8HUzxvrLjxwCMPPnaaTsSf8CJw1tpYc2N6shhWnN6MwjbTQ6808tdffx2OHTuWvf2dNTvdhaRYfPjhh1lz20ZptUv+c2Ibpds2xXaiv6Pfyz5UCf9prLix+YN1sKK48YZt\/AkvckfcJiYmsh9MjGHsoOTRgLy4IWz4MWrr9tBntMERQeXtBs12a7M3NLStDmvWrKGJgm2UbvvaRum2Tb4\/iO2UfaAS\/9NYcYMrb3VAgHgolmuOXOPPddGxM5Jt\/fwwIKJGOO\/qi50e1zzPhrAN45U75KcbPAF+U4yRAcfB52YO\/RCgbWyjfsiZpoxAo8WNURW\/wcQLY3njA0eu8afC7HRk7h\/B4hrHNn+2\/vNthDQI2cmTJ7MfwkTweA6Ol6XGcOLgOr3JBHu69AnYcQ63jfrJzTbqh5ppuhFotLhRsfwDsTwUyzX+OKYmmS9G0LiOjvfVEReXf4iWkR3X+Bcd\/oRHGx4lIAEJSCBdAo0Xt3TRWjIJSEACEuiPQPVUilt1hlqQgAQkIIHECChuiTWIxZGABCQggeoEFLfqDJtuwfJLQAISaB0Bxa11TWqFJCABCUhAcfMekIAEqhPQggQSI6C4JdYgFkcCEpCABKoTUNyqM9SCBCQgAQlUJ1CrBcWtVpwak4AEJCCBFAgobim0gmWQgAQkIIFaCShuteJsjjFLKgEJSKDNBBS3NreudZOABCQwpgQUtzFteKstgeoEtCCBdAkobum2jSWTgAQkIIE+CShufYIzmQQkIAEJVCcwKAuK26DIalcCEpCABEZGQHEbGXozloAEJCCBQRFQ3AZFNkW7lkkCEpDAmBBQ3Makoa2mBCQggXEioLiNU2tbVwlUJ6AFCTSCgOLWiGaykBKQgAQkMBsCittsaBlXAhKQgASqExiCBcVtCJDNQgISkIAEhktAcRsub3OTgAQkIIEhEFDchgB5tFmYuwQkIIHxI6C4jV+bW2MJSEACrSeguLW+ia2gBKoT0IIEmkZAcWtai1leCUhAAhKYkYDiNiMiI0hAAhKQQHUCw7WguA2Xt7lJQAISkMAQCChuQ4BsFhKQgAQkMFwCittweQ8rN\/ORgAQkMNYEFLexbn4rLwEJSKCdBBS3drartZJAdQJakECDCShuDW48iy4BCUhAAp0JKG6duegrAQlIQALVCYzMguI2MvRmLAEJSEACgyKguA2KrHYlIAEJSGBkBBS3kaGvP2MtSkACEpDAGwKK2xsO\/pWABCQggRYRUNxa1JhWRQLVCWhBAu0goLi1ox2thQQkIAEJ5AgobjkYnkpAAhKQQHUCKVhQ3FJoBcsgAQlIQAK1ElDcasWpMQlIQAISSIGA4pZCK1Qpg2klIAEJvWTuKQAAEABJREFUSGAaAcVtGhI9JCABCUig6QQUt6a3oOWXQHUCWpBA6wgkLW4vXrwIW7duDUuXLs0c5\/h1a4V79+6FVatWZfFJd+bMmdLohO3bt29aOH6kzTv8pkXUQwISkIAEkiSQtLgdOnQog3b37t2A4yL6cV50z549C7t37w67du0KDx48CJcvXw6nT58OV69eLUYNCNvRo0en+SOeT548Cfv3789sYAd3\/PjxaXH1kIAEJCCBHwgkdkhW3BiB3bp1Kxw4cCDMnTs3c5zjR1gnjpcuXQqLFi0K27Zty4JXrFiRCd25c+cCooUnR0aAiN7ixYvxmuJevnwZHj9+HJYtWzbF3wsJSEACEmgOgWTF7enTp2FiYiIsWLBgkuaSJUsCgkTYpGfu5P79+2HhwoWZEEbvdevWhefPnwdEC7+bN29yCDdu3Ahvv\/12dp7\/g+1Xr15NyTcf7rkEJCABCaRPIFlxQ6gYhc2ZM2caRcKKnozImE7sNOL6\/vvvA6JFmg0bNoQLFy5MEUD8o4vxGP3FNbde1tu+\/vrrgHA+evQomhrgUdMSkIAEhkeAfo3+jVmt4eVaLadkxa1atfpPjXAihufPn8\/W3FjrQzRnEriPP\/442\/zy+eef95+5KSUgAQkkSIB+jeWcjz76KMHSdS6S4lbgsnPnznDnzp3Ael14\/Y\/1vu3bt4crV66EsrW+19HCsWPHshHh+++\/z6VOAskTsIAS6JUA\/RozXh9++GGvSUYeL1lxY3qRIXBcK8uTIix\/zTkixHobIy+u8+6tt96qtIbGuh828jaL50yhrl27NlsTLIZ5LQEJSKDJBNjrQP+2Zs2axlQjWXFDUNjYEdfAIPrw4cPA3C9hXBcdoscUIutvMYyNI\/PmzQud1u5inPyR6Udc3o8yTExMVBLIvD3PJSABCbSDQLq1SFbcmBZkN+ORI0eybfwIFuf4EdYJ6ebNm7Nt\/KyXEc40Ilv+mVZkZIffTG7jxo1TpiB5du7w4cNhy5YtYf78+TMlN1wCEpCABBIgkKy4wSY+sL1y5cqAy\/txzsPZ69evDwgQ14jPqVOnsge32em4adOm7Dk3dkgS3osj7okTJwJpscFQHGFjLa6X9MaRgAQkIIHRE0ha3BhtsYjJG0JwnOMXsSFE165dmzKiYlTHhhDi47qJEm8dwUV78Yhd0kbXzUZMM4SjWUhAAhKQQI8Ekha3HutgNAlIQAISkMAUAorbFBxeSKDlBKyeBMaEgOI2Jg1tNSUgAQmMEwHFbZxa27pKQAISqE6gERYUt0Y0k4WUgAQkIIHZEFDcZkPLuBKQgAQk0AgCilvizWTxJCABCUhg9gQUt9kzM4UEJCABCSROQHFLvIEsngSqE9CCBMaPgOI2fm1ujSUgAQm0noDi1vomtoISkIAEqhNomgXFrWktZnklIAEJSGBGAorbjIiMIAEJSEACTSOguKXYYpZJAhKQgAQqEahF3Pg9NX5Xjd8\/27p1a\/bjopVKZWIJSEACEpBABQK1iBs\/Esrvqu3fvz\/cvHkz+2FRha5Cq5hUAtUJaEECY02gFnGLBHfu3BkePHiQuaLQ7du3L0bzKAEJSEACEhgogVrFLV\/SKHSbN2\/OvC9duhQYzSlyGQ7\/SEACEkifQINLWLu45dffELMrV66Ey5cvZ6O5s2fPBkROgWvwHWPRJSABCTSAQC3ilhe0tWvXhm+\/\/TYgZExR3rlzJ6xYsSJDsWHDhsB05e3btwNpMk\/\/SEACEpCABGomUIu4xTIhXAgaDiGL\/h57IWAcCUhAAhKoi0At4hZ3S7LONlPBiMPOStLMFNdwCUhAAhKQQD8EahG3fjI2jQQkUD8BLUpAAm8I1CJurJ+999574d69e2+sFv6eOXMm8JA38QpBXkpAAhKQgARqJ1CLuNVeKg1KQAISkMCICLQj277F7cWLF4FXbbHdnx2S33zzTdi0aVP2LBt+eXf06NGwZcuW4DpbO24aayEBCUggdQJ9i9vcuXPDhQsXsufXeOXW8uXLJ59nY7dk0bGRJHUYlk8CEpCABNpBoG9xy1efEdkXX3wx+TxbPszzrgQMlIAEJCCBARCoRdwGUC5NSkACEpCABPom0Le4sfORHZCsuz18+DDbDZlfZyueE5c0fZfUhBKQQGcC+kpAAtMI9C1uTEXyMDbrbkuWLAmcF9fZ8teEk2ZaCfSQgAQkIAEJ1Eygb3GruRyak4AEJCCB0RFoXc59ixtTjEw1Fqcfy66JS5rWEbRCEpCABCSQHIG+xY0pRqYa81OP3c6JS5rkCFggCUhAAhJoHYG+xa11JIZYIbOSgAQkIIHBElDcBstX6xKQgAQkMAICfYsb62eso\/kowAhazSwlEEQgAQl0I9C3uLF+xjqajwJ0w2uYBCQgAQmMgkDf4jaKwpqnBCQgAQnUR6DNlhS3NreudZOABCQwpgRqFbe4Dpd\/1o01OX4eZ0z5Wm0JSEACEhgBgdrE7erVq4HfdeN32\/LPu73zzjth3bp1pb\/SPYI6jyZLc5WABCQggaERqEXcGJmdO3cubN68ORR\/t43rd999Nxw5ciQQb2g1MyMJSEACEhhbArWI28uXL8Pjx4\/DsmXLOoLEn3DidYygpwQk0AsB40hAAj0SqEXc5syZExYtWhTu37\/fMVv8CSdexwh6SkACEpCABGokUIu4zZ07Nxw4cCBcuXIlnDlzZkrxuMafcOJNCfRCAhKQgASGS2BMcutb3Io7Izdt2hSeP38ejh49GvK7JbnGf\/fu3YE0Y8LVakpAAhKQwAgJ9C1u8Q0l+Z2R3c55mwlp6q4ruzTzYsr1THns27dvUoB5hViZ6OL\/3nvvudNzJqCGS0ACEkiMQN\/ilkI97t27F\/bu3RvOnj0bEFaOXONfVj6mSW\/fvh1u3ryZpVm9enXYs2fPtJ2cCNsvf\/nL8Oc\/\/7nMVA\/+RpGABCQggVEQqE3cEANGQflRVP6cMOLUWclPP\/008JjBhg0bMrMcucY\/8yj8If+LFy+GgwcPhjiK3L9\/f7bTE7GL0Rn98czeq1evwltvvRW9PUpAAhKQQEMI1CZurK2xI\/Lu3bsBweCZN0ZTly9fDosXLw6nTp2aFJQ62PDM3JMnT6Y9frBx48aAP+HFfJ4+fRoQrAULFkwGIXKM3tjRiSfpeGaPUeAnn3yCV+vco0ePspErgl7miNO6ije0QhZbAhKYPYFaxI0REVN9vI2EHZE81xYFZsWKFYFXcJWNpkKf\/3hmjmfnyKtoAn\/Ci\/6I28TERMiLW4wTxY3y80sHjAJjWJuOiNZHH32UtQntUuaIQ9w21d26SEAC40OgFnEr4kI82CEZBYbXb\/3pT39q9W7Jr7\/+OhsNDVIQsF020urVn3Li\/vbvfhvW\/cM\/dXQ\/3fD3gTjkV2zbcb+GSTfWhI87I+ufIoFqZeK+5r5n4FDN0vBS1yJuPJzNlGQsNuLGOSMljuPgPv7442w09Pnnnw+kutxcjKbKRlq9+mODAs756wXhx0tXdnZ\/s5IougKBXtoAvsQrJPVSAo0mQL9GH8P93ZSK1CJuTOUxJclmDaYoWcf66U9\/Gm7cuJFx4Dhv3ryACGYeNfzBFoIapxPzJvEnPO\/HOaLLmlsn0e00vUmaXt2xY8cC05nvv\/9+r0lmFY8Ok9HUTCMujPYSh3i6qQRgzLfTMgd\/XBlfR7xTeXrVHgL0a\/RvH374YWMqVYu4UVtekMzGjLitnk0liB07JjmePHkyIILErcNha+HChdNe+fXVV18F\/Akv5oO4TUxMhLy4IcasF1YVNwSVHZaLFy8uZlvr9ZweRly9xKm1UC0whrDxrZRvp2WOcKpaytcRL3h0LSTApkD6tzVr1jSmdrWJGzU+fvx4NnpBWBi9Xbt2LXuWjCPXxKnTffDBB9krv9i6j12OvOoLf66LjjLwkzyHDx+eXP+LuzxpuGJ8r8eHAOLWbVTG+iQjs\/EhYk0l0GwCf9Xk4rMT88SJE2HHjh3ZG0c4co0\/9WJbP9\/CeXCba1wcYSJmjCoZtdU9qiQfXTMJlI7KWJ8c5sismfgstQSSIVCruDHFx8PaiEZ0iAsiM6gas2Wf5+mi4zrmxQiSeWIELfpxZIQZ43cbVSKS169fDxxJp5OABCQggWYQqE3cmBJkNMS0XxQOjmw04VGAbq\/EagYqSykBCUigUQTGurC1iBsjM97qwVtJiqMkrnkl1pEjR6a9v3GsyVt5CUhAAhIYGIFaxI2HtXm4r2zHIf6EE29gNdGwBCQgAQlI4AcCtYgbz5SxFb7TM2fkgz\/hxOO6jc46DY4AOxnLnj3Dn\/DB5a5lCUigiQRqETc2bhw4cCDblp\/fmQgQrtmeTzjx8NNJoFcCCBfPl7ExqcwRzhsUELoyh51e8xyneHApYxb9iTNOTIZdV\/hG1mVH4gy7XE3Pr29xK+6M9Je4m34rpFl+PtTdnj\/j2TPCEbgy8cOfcGylWctYquEe4QEX+HRzxCHucEs3HrnB9X\/\/+v9kr+6zDept877FjQei2UbPjsheHHFJU2\/xtTYuBEqfP\/vh2bOyV2LFh68RQDqSceHVSz3hARfZ9UJrMHFog\/9\/7\/8F26B+vn2LW\/1F0aIE+idQKn4+fD0jVNnNiGjgEepsg4EXtiEZKG4NaSiLKQEJNI8AI7OydTT82UXea60YZZOmkyOfXu2MS7xaxY0HtVetWpW9Ciu+oYRr\/McFqPWUwEwE6Ig6dVB5P+IMy85M+RjeHwHakPXKmdbSerUef1ark73N\/2t3IL9ebY1DvNrEjTeUsKlk165d2cuS4zoc1\/gT3jqgY1whPkj5zrjfc+yME0bqO1OHR+dFHOKWsSGMOMTt5ohD3DI7KflTzpnuI+KkVOZuZaGsjLZmWk\/rZiMfVmaHTVV\/eXBXccvDen1ei7jN9IYS3lzCG0yI9zrPsfzPjd7tg0t4U8BQVjrNbp1qr2HYwV5T6l61nNS1lw6POMQty48w4pR1ePmNNGWPScxmSqysHHX5Ux\/uhZnuG+IQt658h2GnrvW0Ujs\/bKoaRl2alEct4sabR\/ig8CaSTpXHn3DidQpvux8fxpm2+xJOvCawoJy9dKzUpZfOF3vEHSeX66jCj9n0knc\/dFYwLvtCxOcJXr3YKZvOQiiwkYLjHqC+3i8ptEY7ylCLuPHmEd5AwptIOmHBn3DidQpvux8f3G7bfZlWILzsGzYdXOzMUmLVS8faS5yU6pRSWcpEidHNbISpTDC47+qqL\/c492k3R5yZ8uvlfkEEq+YzUzkMbz6BWsSNN49s3749XLp0KfBGkjwWrvEnnHj5sHE7L\/3g\/vBNva7ObNy4trW+ZaIUpxx7rfdM912vdsriIVrMPCC63RyCTNwyO736d\/uckH9d+fRaniTiWYhpBGoRN6zyO2qXL18Op0+fnrJbkmv8CSeerpxAXZ1ZeQ6GNIlAqSgxhfnDF6IU6oNgMfMw0\/3LiIu4VcvcSz7dZkEY9SOIa00AABAASURBVNVRjqr1SDE9XOBT5lKcQSrjWIu4sVGEb0xPnz4Nd+7cmbJbkmt\/7LMM\/1T\/pnRmU0td\/YpOrw0fpuok0rXQSxsN6\/7tJZ86RnczdfSEp9tisy8Z9ZlpBM6oePaWR5OiFnFjowiKztraaKoxzFzNq24C3TqiJn2Y6uaSkr2mtVEvozs68zLGhHHv8aW9zBFOvDIbTfOnLr2MwJtSr1rEjY0ibBhpSqUtZ1oEZuqI6iptL6OPuvJqm51htVFd3HoZ3XXLi46e+6Ws3mzGIZx43ew0Mawqu1TqXIu4sVGEn7S5cOFC8G0kqTRt9XLw4e00Xcgovbr1\/7YwrA\/TsEYfZdxgGdn9d+2bcTasNkqNRmm9E1rzTI1ZKuWpRdz4+Zvdu9+8\/oW3kcRXb+WP69evD8RLpeKWY2YCZWLAdMzMqdOLUfYtfLa7D2eqWRk3preaym6mOhsugdQI1CJu\/JQNP2kTX7nV6Ug48VIDYHnKCZSJAVMy5anSDSn9Fl7z7sMybnWLaLqkLdlwCJhLNwK1iFu3DAxrLoFSMXBKpmujlnKrWUS7FsJACYw5gcrixkPa+enHcX1BchvXWcb8s2H1JSCBBhOoJG4IW3xIm6lIHtbeu3fvtLeUNJhPLPqMR9dZZkRkBAmEsi+BTd1ok1KTlrFlIxOujTs7u\/HvW9x4cPv69euBn7SJD2lz5Bp\/wrtl3LYw11na1qLWZxAEyr4ENnWjTTdBGbZgl7FlIxMOxuMkcH2LW3xwu\/gBGNdfAHCdpXgneD2NgB6h7EtgUzcpdRMUxGSYTV7GNm5kQogVt4ot8t133wVexVXRjMklIIGWESj9EtjQTUozCcowm6+U7ZhuZOp75DbMRjMvCUhAAikSGIGgVMLA6I31t05u2NOolSrSQ2LFrQdIRpGABCTQBgIpTaMOmqfiNmjC2peABCSQCIGUplEHjaSyuB09enTK77ft2LEjPH\/+PBRfw9XE128NGr72JSABCQyTQNOmUauw6VvceJUWr9Ti+bZeHHFJU6WwppWABCRQF4FxWn+qi1mT7PQtbk2qpGWVwOgImHOqBMZp\/SnVNhhkuRS3QdLVtgQkkCyBcVp\/SrYRBlgwxW2AcDUtAQmkS6BJ60\/pUky3ZIpbum1jySQgAQlIoE8Ciluf4EwmAQlIQALpElDcim3jtQQkIAEJNJ6A4tb4JrQCEpCABCRQJKC4FYl4LYHqBLQgAQmMmIDiNuIGMHsJSEACEqifgOJWP1MtSkACEqhOQAuVCChulfCZWAISkIAEUiSguKXYKpZJAhKQgAQqEVDcMnz+kYAEJCCBNhFQ3NrUmtZFAhKQgAQyAkmL24sXL8LWrVsnfy+Oc\/yykpf8uXfvXli1atVkmjNnzkyLuW\/fvsnwTr8zlw9funRpFhe\/aYb0kECOgKcSkEA6BJIWt0OHDmWk7t69G3BcRD\/Oi+7Zs2dh9+7dYdeuXYHfmLt8+XI4ffp0uHr16mRUxO727dvh5s2bWZzVq1eHPXv2hCiaHJ88eRL279+fhWMHd\/z48UkbnkhAAhKQQNoEkhU3RmC3bt0KBw4cCHPnzs0c5\/gR1gnrpUuXwqJFi8K2bduy4BUrVmRCd+7cuUy8EL+LFy+GgwcPhvjDqYjY48ePM7Ej0cuXLwPXy5Yt41InAQlIYIgEzKouAsmK29OnT8PExERYsGDBZF2XLFkSFi9eHAib9Myd3L9\/PyxcuDATwui9bt268Pz584Boke7Vq1dTbCJyjN5IS5pOcfDXSUACEpBAcwgkK26IDaOwOXPmTKNJWNEzTid2GnF9\/\/33mSAiXBMTE1PELdqJNomDH6M\/19sgoZOABCTQPALJitsQUHbMApFDDM+fP5+tubHWxxrcTBtK\/vIfd8NfHtwNL\/\/zaUe7ekpAAhJoKgH6tab1b4pb4W7buXNnuHPnTmC9Lrz+x3rf9u3bw5UrV0LZWt\/raOFPV\/813PiXfwx\/\/r9XuNRJQAISaA0B+jX6t3\/\/t39uTJ2SFTemF9nYwVpZkSZhRT9EiPU2Rl7FsLfeeiubimT9jjW3OPWYj9fJZgwnHTbidafj3\/7db8O6f\/in8D\/+57udgvVrKwHrJYExIEC\/Rv\/20w1\/35jaJituCEpRiB4+fBgePXqUCVUnwggUU4isv8XwGzduhHnz5gXW7rA5MTGRrb\/FcHZQ8mgAafFj+hHHeXSI4cRE57W6GGfOXy8IP166MnCMfh4lIAEJtIEA\/Rr924\/\/ZmVjqpOsuDEt+Pbbb4cjR45k2\/gRLM7xI6wT4c2bN2fb+FkvI5xpRJ5zY1qRkR07I7ds2RIOHz4cEDXiHD16NHt8YO3atVyGjRs3TpmCJB7xSUf6LJJ\/JCABCdRHQEsDIJCsuFHX+MD2ypUrAy7vxzkPZ+ffMIL4nDp1Kntwm52OmzZtyp5z27BhA9Ezx5oaW\/\/XvhYz4jBqO3ny5OTjA8Q9ceJEIC3hxEPYSJcZ8I8EJCABCSRPIGlxY7R14cKFbNcibwnhHL9IFSG6du3a5APZ+DOqY0MI8XGdRIm3jRCGK6bHBnYJi66TDeLpJCABCUggTQJJi9sgkGlTAhKQgATaT0Bxa38bW0MJSEACY0dAcRu7JrfC1QloQQISSJ2A4pZ6C1k+CUhAAhKYNQHFbdbITCABCUigOgEtDJaA4jZYvlqXgAQkIIEREFDcRgDdLCUgAQlIYLAExkPcBstQ6xKQgAQkkBgBxS2xBrE4EpCABCRQnYDiVp2hFsaDgLWUgAQaREBxa1BjWVQJSEACEuiNgOLWGydjSUACEqhOQAtDI6C4DQ21GUlAAhKQwLAIKG7DIm0+EpCABCQwNAItFrehMTQjCUhAAhJIjIDilliDWBwJSEACEqhOQHGrzlALLSZg1SQggWYSUNya2W6WWgISkIAEuhBQ3LrAMUgCEpBAdQJaGAUBxW0U1M1TAhKQgAQGSkBxGyhejUtAAhKQwCgItE3cRsHQPCUgAQlIIDECiltiDWJxJCABCUigOgHFrTpDLbSNgPWRgAQaT0Bxa3wTWgEJSEACEigSUNyKRLyWgAQkUJ2AFkZMQHEbcQOYvQQkIAEJ1E9AcaufqRYlIAEJSGDEBFohbiNmaPYSkIAEJJAYAcUtsQaxOBKQgAQkUJ2A4ladoRZaQcBKSEACbSKguLWpNa2LBCQgAQlkBBS3DIN\/JCABCVQnoIV0CChu6bSFJZGABCQggZoIKG41gdSMBCQgAQmkQ6C54pYOQ0siAQlIQAKJEVDcEmsQiyMBCUhAAtUJKG7VGWqhuQQsuQQk0FICiltLG9ZqSUACEhhnAorbOLe+dZeABKoT0EKSBBS3JJvFQklAAhKQQBUCilsVeqaVgAQkIIEkCTRM3JJkaKEkIAEJSCAxAopbYg1icSQgAQlIoDoBxa06Qy00jIDFlYAE2k9AcWt\/G1tDCUhAAmNHQHEbuya3whKQQHUCWkidgOKWegtZPglIQAISmDUBxa0Dsnv37oVVq1aFpUuXZu7MmTMdYuklAQlIQAKpEmiCuA2V3bNnz8Lu3bvDrl27woMHD8Lly5fD6dOnw9WrV4daDjOTgAQkIIH+CShuBXaXLl0KixYtCtu2bctCVqxYkQnduXPnwosXLzI\/\/0hAAhKQQNoEFLdC+9y\/fz8sXLgwzJ07dzJk3bp14fnz5+Hly5eTfp40jIDFlYAExoqA4pZrbkZmT548CcuWLcv5vjn9\/vvvw9OnT99cdPj7l\/+4G\/7yoLN7+Z9v0pXFmSkcuynFsSz9tbPtGIKfgan3Th2fpTpszPbe7NAFJueluFVsksWLF4c1a9aEP13913DjX\/6xo\/v3f\/vnLJeyODOFYzelOJalc1unxKWXeyal8qZUli7sJj\/fKZV32GWhv6Pfyzq1hP8obhUbh0Y+duxYuHDhgk4G3gPeA62\/B+jv6Pcqdp0DT6645RCzzsZ6G+tuOe\/s9K233goLFizIzot\/aOi1a9cGnQy8B7wH2n4P0N8V+8AUr5MVt1HBYr2NdTfW32IZbty4EebNmxfmzJkTvTxKQAISkEDCBBS3QuNs3rw5PH78OJw\/fz4L4YFunnPbvn37lB2UWaB\/JCABCUggSQKKW6FZ5s+fH06dOpU9uM0bSjZt2pQ957Zhw4ZCTC\/TJ2AJJSCBcSWguHVoeR7cvnPnTvaGEt5SsnPnzg6x9JKABCQggVQJKG6ptozlkoAEkiBgIZpJQHFrZrtZaglIQAIS6EJAcesCp1sQuym3bt2a\/WoAa3Oc49ctjWGjJbBv377gLzyMtg065c6mrfyvcPhZ6kRptH70bbQLfR2Oz9JoSzRz7mmJ28zlTSbGoUOHsrLcvXs34LiIfpzr0iLAh5GXYqdVKkuDsPGS8hMnTkyucfOs6Y4dO3xReSK3B8JGe9Au7EGgv+NxqdS\/KCpufdxAfCBv3boVDhw4kD0ewMPfnONHWB8mTTIgAvyE0fr168OVK1dCUx4+HRCKJM3yDOny5cuzFyDEAn7wwQfh0aNH4eHDh9HL4wgJ0A68OH7\/\/v1ZKejveDTq+vXrSX8BUdyy5prdH16gPDExMeWNJUuWLMk6T8JmZ83YNROYYo7R2urVqwOdqOI2BU0SF+xE5tV1dJhJFMhCTCPA7vEvvvgi8JhUPpDngVP+pRTFLd9aPZ7zei5+863TG0sI69GM0YZAgM7z+PHjQ8jJLOoiwBeRiYmpXx7rsq2d6gSYDTl8+HDYsmXLNMGrbr0+C4pbfSy1JAEJVCTAL94fPXo0HDx4cLQdZ8V6tDE5a29sKuHdmdSPtzlxTNUpbqm2jOWSwJgRQNjYuMDajm8ESq\/xmTpmCplNJXz5ePfdd0PKewwUtz7uIV6uXDbfTFgfJk0igbEmkBc2ppLHGkYDKs\/ojY1ATCGnWtwExC1VNOXl4qdvXr16FfKbR9hRxA4vwspTGiIBCRQJRGE7e\/ZsUNiKdEZ\/Tfuw45i1ttGXpvcSKG69s5qMye6ht99+Oxw5ciTbCstcNOf4ETYZ0RMJSKArAaa19u7dGxA2pyK7ohpZ4MqVK7O8WQvNTl7\/4VdTmL1Ked1NcXvdUP38jw9s0\/A4bEQ\/znXDJWBuzSTw6aefBp6hYq2NN1\/kHSOGZtaqXaXmEYDPPvss3L59e\/KNTBcvXgz4EZZqbRW3Plsmv7jKAisLrfj1ac5kAyZA29BGTnsNGPQszfOYBp+fTs6R3CxhDjA6Inbt2rXJt8hwjt8As6xsWnGrjFADEpBAOwhYizYRUNza1JrWRQISkIAEMgKKW4bBPxKQgAQk0CYCoxK3NjG0LhKQgAQkkBgBxS2xBrE4EpCABCRQnYDiVp2hFkZFwHwlIAEJlBBQ3ErA6C0BCUhAAs0loLg1t+0suQQkUJ2AFlpKQHFracNarXQJ7Nu3b\/JND\/k3cuTP+WmR3\/3ud6GJ7\/RLl7wlGycCits4tbZ1TYJA8a0cvJ+Pt6zfvXtMZ7YYAAACzElEQVR38g0QvE3lN7\/5TWjCmyCSgGohJFAgMFRxK+TtpQQkIAEJSGAgBBS3gWDVqASqEzhz5szktCQ\/N8IU5YkTJwJTlnEKk3N+lSI\/1Uk84udLwEuIYxqOMV0+jucSaBMBxa1NrTkWdRnvSn7yySdh+\/bt2fTl5cuXwzfffBP4VYply5ZlfkxtLlq0KOzZsyf7OSZoIZK8dZ+fleEFxcTBHz+EkXOdBNpGQHFrW4tan1YTYH0uvi1\/yZIlYfny5YH1um3btmX15tcP3nnnncBvbb18+TIwguPnSfLpiHPgwIFMGPldriyhfyTQMgKKW8sa1Oq0mwAjtNnUkFHat99+GzZu3DglWRTG+\/fvT\/Eflwvr2X4Cilv729gaSiAwBclaW3RMZd68eVMyEmgtAcWttU1rxSTwhsC8efMC63OstxUdjyW8ieVfCbSLwODFrV28rI0EGkWAEdqPfvSjcOPGjSnlZi2OXZVsNpkS4IUEWkJAcWtJQ1oNCXQiMH\/+\/LBly5Zw9OjRwOMAMQ7XnLPRhKNOAm0joLi1rUXbWR9rVYHAzp07A48B5Nfdnjx5Er788suA+FUwbVIJJEtAcUu2aSzYuBBg3YvXbbFFP19nRCm+fgsR4hy\/GIf4pMNxHv2JQ1zSRD8eH8ivtxXTxHgeJdAWAopbW1rSekhAAt0JGDpWBBS3sWpuKysBCUhgPAgobuPRztZSAhKQwFgRGJC4jRVDKysBCUhAAokRUNwSaxCLIwEJSEAC1QkobtUZamFABDQrAQlIoF8Cilu\/5EwnAQlIQALJElDckm0aCyYBCVQnoIVxJaC4jWvLW28JSEACLSaguLW4ca2aBCQggXElUKe4jStD6y0BCUhAAokRUNwSaxCLIwEJSEAC1QkobtUZaqFOAtqSgAQkUAMBxa0GiJqQgAQkIIG0CChuabWHpZGABKoT0IIEwn8BAAD\/\/380U54AAAAGSURBVAMA6K09aSqPXcgAAAAASUVORK5CYII=","height":299,"width":399}}
%---
%[output:0ae5de1f]
%   data: {"dataType":"image","outputData":{"dataUri":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAbcAAAFJCAYAAAAYD2OCAAAQAElEQVR4AeydX8gVR57369lLUZKBQUGdBV1hLkRlYY2CEG\/MIMwEwTALukIYeXGVcYjvaBy8EAQvZI0uhjHoeOEQcBQ2REZCIKA3CoLRfVlUMpAXR2GighKYBMVb10+beuinPX2ec073c051n49Yp6vr768+dZ76nqqu7v6H5\/6TgAQkIAEJtIzAPwT\/SUACEpCABFpGQHFrWYeOpDlWKgEJSCAxAopbYh2iORKQgAQkUJ2A4ladoSVIQALVCViCBGoloLjVitPCJCABCUggBQKKWwq9oA0SkIAEJFCdQK4ExS0HQ68EJCABCbSDgOLWjn60FRKQgAQkkCOguOVg6O2HgGklIAEJpEtAcUu3b7RMAhKQgAQGJKC4DQjObBKQQHUCliCBmSKguM0UWcuVgAQkIIGREVDcRobeiiUgAQlIoDqBziUobp25GCoBCUhAAg0moLg1uPM0XQISkIAEOhNQ3DpzaUXo7du3w4oVK8LixYu7ul\/96ldZ\/ObNm8PTp0+7tX3G4h4\/fhzWrl2b2XHp0qXa6jl58mTYs2fPZHn44cFxMrDhHvqMvquT27CQ0A9t649+2BX\/Rvl7JayfMkzbmYDi1pmLoS0gwMB5+PDhFrSkvAn8KPj5z38erl27Vp7ImCQJIGJbtmwJT548mbQPP2HETQbqGYiA4jYQtmZkWrZsWbh582a4e\/du5vbu3ZsZvnr16nDr1q0sjLg\/\/vGPmf\/s2bNh9uzZWZphf8ydOzdcvnw5s2PdunXDrt76hknAujICH3\/8cSZsP\/nJT7IfJ\/xAwY\/AEZcl8mNgAorbwOjak5GlO5aGWNpiiYvZQFwi\/POf\/xwIJx7HbIiWxzyEkZY8hEfHEhlx0cV8Mb54JD\/lkJ68xPPrlWUaHH\/4eTtISx7SFR1tIO358+ezKI75crPAFx+xfOJwtOlF8OT\/WA5xOOwgz2SCEg\/lkD7vim0iLobFYmI+bKduwuFG2ujyNmDLW2+9Fb755huShm3btmVLu5ELRzjFvPgJyxK\/+MjXRz\/HdLEO0pInhpP+RbZX\/mMrNpMunwY\/YbE8MubLLLaf9pCWPDjykye6fD3Ek5Y8MR4\/Ybh+vi\/F\/JQdHfxjfKcjNsa0nY7wo82d8sawlStXBn7c4fDHcI\/VCChu1fi1Pvdvf\/vb7FdlbChC8Ytf\/CLkl\/sYXPPn\/MEz0MY8HMnHAMgAxXk\/jl+y5GXAivmoc9euXQNfI7x+\/Xpg+YeyY5m0IQ64DEjF5T7SbtiwIcQ0MV\/+SNspJx+Gf\/fu3YHBl9k0gkTYF198wSFzcLly5Urmf\/PNN7MZNAMr3LLAHz6wYefOnQH7fgjqeKAu6oFTTICfMOJiGEe40s\/4cdTx61\/\/OpCWPIThTpw4kbUBf94x28dmwmgDbcHhJ4zyHj16hDdw\/O677wIzlOXLl2dhfNTZH9TX7\/cFJsXvA3bBnz7FX7dbsmRJVuSNGzey\/qRP8RMY4\/DrOhKYNlBxmxbReCeIS5gsY+KHBgPehQsXsiXEjRs3EhT4o+SPk0GCQXDOnDkhpol5GURxWYY+P6ibclhGjcurX331Vbh3794rJTHYssQabeNIvvxy5\/3798PRo0ezNmATgy0FRcFBoGhnzEv+U6dOkSScPn26VFTv3LmTpYn5sBnbGXDjUtP69euzNJEZJ7SD9mAHeRGHhw8fEhVoL\/VHO7GLQRehvHjxYiYUJMS+yy+WdmfNmhUOHTqULXnFvOTHn7eDPNGRlzQcCYMP4kYY\/Uh\/kvfq1atEv+LWrFkTSPPgwYPw7NmzzOGPCSNX8lMOMxRmKjGe+ursD5jDHvtpN\/XAF874iw7RxS74wzmf79y5c5n4FPNwvn379uw7RPpOjv7It5M80ZGXvqY\/sReHnzDiYjqPgxFQ3AbjNja5+EWOWODmz5+ftXvp0qVh0aJFmT8O1NnJi484SDBQMMthqYZf6AwYL6JDHOTw9+O2bt2azWbIEwdS\/IM6BhIc+Rl8GGzx4\/LCgojQBlycjXYbJOMv7pjvwIEDAaFl4Dty5AjFB3gwiDKQMQATiPDBDDuwJ88boaV+ymSwpKztLwZV8nVyiEsUlpiX\/PhJnxdVzrEFm\/DPmzcvEyn8sW\/pa\/qcsDIX08Q20S78CxcuzMpDqPnxE2dzsexYHn2B45z2wwE\/bpD+6Pf7EtuNzdjBciIiA2uYYxO21OngQV8UyySMuGK45\/0RUNz64zV2qRmsi41G5Bh8i+Gcx5kL\/rocMwIGn7rKo5xubciLA2n7cYgOg2LMgyAhLLi4vMVAuWnTpiwJYs9AxoBGO999990snA+EkYEWPw5xohxct6VRfmCw9EeeXtyCBQsCs718WmzphznfB34IUQZtwuHnBw7CyA8CBA\/R7VR2nf3RqXxs6eaYBTNzjGmiyMGaJU4ENsblj\/QpacocIkn\/5vNEP\/1JPXxfEFH40N+EERfTeRyMgOI2GDdzlRCIYshsgNkaf7R5F2cvJdmTCGagZ8DHGJa08vbjZwcqgyHxnRxtJB0uLvORLr+8FWefiBpLiwxoiAAzINLiEIw466MsbCEc121pFFF6\/fXXSRaon7x5N1Mzkdgm2sM1NETmZz\/7WUC4mJUeO3Ys2\/xSbGdmaJePqv3RpegpUSxbR058d\/kOkwA\/Dn9dDsGj7ykvzmLp7\/gDgTjSEK8bjIDiNhg3c5UQYGBlUGOwZtZCMv5I+QXLr9tuMw7SpuAYZBiQsSUvSPFXetkveX7dE0c72QxCfgZMBAY\/sylmVfgRMQZ5OO3fv5+gkF9KyzOjXhIwK4wCxwyIGSbhRZcXg7wIYlPetmK+quexTQgZ19BoH2EvB+8Q\/vKXv2RVMIDDODvp4YO0g\/RHD0VPJoExbPiewp7Z9SeffDJ5PbNsRYI+iYLY6Vj2Q6JTH\/H9icu2\/LgizaSBevomoLj1jcwM3Qgwo2EjAmlYWmHAiEstHHHEDdMhstjBANZrvSwPRpHGZvLTHvLnRYjz6BiEieM81km+eK0OLvAhPp+Wc2YJ8boX5wyucemSeikHh5944kiDPzrqYRs8myaiHcw4KJe82ESbaFvMU+eRNiFcsUwEiTDqp32EUz8zPPz9OGwmLz8Geu2PfspnaRAb8+VTD+eEE99PedOlhUtkFfsITvjJS\/+RBr9uMAKK22DczNWFAMtycYYRkzFQMIMZ5h8sNjAwRRv6OSJCLK8V89MGZmNlZREXdxfm0zA4wiUfxmAWy2cDRVGsmBVQXz4PftpFHH7yxJkf59F1sgNxOHPmTKBtMV3dx7gsTblxxoaNtI+wOJvD34\/D5kH6o9c6sPHzzz8PfE\/zeegfZnDE58Pr8NOHnb4r9Dn9V0cdbSujn\/Yobv3Qanha\/phYOuE6Tl5kiuH8IbOcQtr8HxmDM2EcIwriCSM9+WJ4LJM4XLHOmC4eyUsZpKVMwhnQuL6Fw08YDj9hOPyEdXL5MikXm7AdP8d8Hs6L4cX8xEfb8nmLfmzCNtJHR\/nFdCxRslSJ6DAzKcZzTn2xjHikHcRFl09DvdRPHEfOYz78hBGHoxzi8n1DPOlw+EnHd4U0pCUPYWUubwv+mI72k59yKK8YTnwM48g56TlyjpuuP7AXu3H4yYPDTxgOP2GdHHZhH\/VGx3eSejulryMMe7Ar1scxz62OOsa1jMaLG9dwWHKJjvPpOjNeeyBPXGPP52H5irjoOM\/H65dAFQJ8R\/lusZOQ61ODzmaq2GBeCbSdQKPFjRuGefID03h+8XDknPCyjkOo2InE2jZ5WC7ZlXvSBfFsIojxHDknvKzMVobbqKEQYNmLXYTMGoZSoZVIYEwINFrcuPGVi\/RxGs+Rc8I79R+7oBAqrlHEpQauX7DzDBGLu5XyF+tJxzm7mIjvVK5hEuiHAN9TfljhZnrZqx+7TCuBNhForLghNDz1IH8Bm47hIjbhxHOed1zjeP78eWC7egxHvJi9sdWXX8+suU93XSHm9SgBCXQlYKQERkagseLGPT7MuIriBknCicefd4jbxMTEFHGL8Yhb9OePiCSztritOR+nXwISkIAE0iTQWHEbFk4egYRYsnxZVic3rLKsqbuWvUFADnLwO9De7wDjXdlYOCPhAxaquHUBx65K7q05fvx49r6lTknp6Pfffz975xlPp9BtlsVmGfh30N7vAOMd416n8TClsMaKG4+m4RE1nZYTCSe+CJprbVxzY3myGFdc3ozCNt1Nr3Tyl19+GT744IPs6e9cs9OdTYrFe++9l3W3fZRWv+T\/TuyjdPum2E+Md4x72R9Vwh+NFTc2f3AdrChuPI2ccOKL3BG3iYmJ7IWJMY4dlNwakBc3hI0wZm3cZBnTdjsiqDzdoNludfaEhra1YdWqVVnX2Ufp9q99lG7f5MeD2E\/ZH1TiH40VN7jyVAcEiJtiOefIOeGcFx07I9nWf\/DgwcmXD\/KsvjjokZ772RC2mXrkDnXohkuAd4oxM+A43JqtrVcC9I191Cst0\/VCoNHixqyKdzDxwFie+MCRc8JpPDsdWftHsDjHsc2frf\/8GiEPQnbs2LHsRZjM4rgPjoelxnjS4Do9yYTydOkTcOAcbh8NUpt9NAg183Qj0Ghxo2H5G2K5KZZzwnEsTbJejKBxHh3PqyMtLn8TLTM7zgkvOsKJj2V4lIAEJCCBdAk0XtzSRatlEpCABCQwGIHquRS36gwtQQISkIAEEiOguCXWIZojAQlIQALVCShu1Rk2vQTtl4AEJNA6Aopb67rUBklAAhKQgOLmd0ACEqhOwBIkkBgBxS2xDtEcCUhAAhKoTkBxq87QEiQgAQlIoDqBWktQ3GrFaWESkIAEJJACAcUthV7QBglIQAISqJWA4lYrzuYUpqUSkIAE2kxAcWtz79o2CUhAAmNKQHEb04632RKoTsASJJAuAcUt3b7RMglIQAISGJCA4jYgOLNJQAISkEB1AjNVguI2U2QtVwISkIAERkZAcRsZeiuWgAQkIIGZIqC4zRTZFMvVJglIQAJjQkBxG5OOtpkSkIAExomA4jZOvW1bJVCdgCVIoBEEFLdGdJNGSkACEpBAPwQUt35omVYCEpCABKoTGEIJitsQIFuFBCQgAQkMl4DiNlze1iYBCUhAAkMgoLgNAfJoq7B2CUhAAuNHQHEbvz63xRKQgARaT0Bxa30X20AJVCdgCRJoGgHFrWk9pr0SkIAEJDAtAcVtWkQmkIAEJCCB6gSGW4LiNlze1iYBCUhAAkMgoLgNAbJVSEACEpDAcAkobsPlPazarEcCEpDAWBNQ3Ma6+228BCQggXYSUNza2a+2SgLVCViCBBpMQHFrcOdpugQkIAEJdCaguHXmYqgEJCABCVQnMLISFLeRobdiCUhAAhKYKQKK20yRtVwJSEACEhgZAcVtZOjrr9gSJSABCUjgJQHF7SUHPyUgAQlIoEUEFLcWdaZNkUB1ApYggXYQUNza0Y+2QgISkIAEcgQUtxwMPEhQRAAAEABJREFUvRKQgAQkUJ1ACiUobin0gjZIQAISkECtBBS3WnFamAQkIAEJpEBAcUuhF6rYYF4JSEACEniFgOL2ChIDJCABCUig6QQUt6b3oPZLoDoBS5BA6wgkLW5Pnz4NmzdvDosXL84cfsK69cLt27fDihUrsvTkO3nyZGly4vbs2fNKPGHkzTvCXklogAQkIAEJJEkgaXE7cOBABu3WrVsBx0kMw190jx8\/Djt37gw7duwId+\/eDRcuXAgnTpwIly5dKiYNCNvhw4dfCUc8Hz58GPbu3ZuVQTm4I0eOvJLWAAlIQAIS+IFAYodkxY0Z2PXr18O+ffvC7NmzM4efMOI6cTx\/\/nxYsGBB2LJlSxa9bNmyTOhOnz4dEC0COTIDRPQWLlxI0BT37Nmz8ODBg7BkyZIp4Z5IQAISkEBzCCQrbo8ePQoTExNh3rx5kzQXLVoUECTiJgNznjt37oT58+dnQhiD16xZE548eRIQLcKuXbvGIVy9ejW88cYbmT\/\/QdnPnz+fUm8+Xr8EJCABCaRPIFlxQ6iYhc2aNesVisQVA5mRsZzYacb1\/fffB0SLPOvWrQtnz56dIoCERxfTMfuL19x6ud725ZdfBoTz\/v37sagZPFq0BCQggeERYFxjfGNVa3i1VqspWXGr1qzBcyOciOGZM2eya25c60M0pxO4Dz\/8MNv88umnnw5euTklIAEJJEiAcY3LOe+\/\/36C1nU2SXErcNm+fXu4efNm4HpdePGP631bt24NFy9eDGXX+l4kCx988EE2I3znnXc41UkgeQIaKIFeCTCuseL13nvv9Zpl5OmSFTeWF5kCx2tleVLE5c\/xI0Jcb2PmxXnevfbaa5WuoXHdjzLyZRb9LKGuXr06uyZYjPNcAhKQQJMJsNeB8W3VqlWNaUay4oagsLEjXgOD6L179wJrv8RxXnSIHkuIXH+LcWwcmTNnTuh07S6myR9ZfsTlw7BhYmKikkDmy9MvAQlIoB0E0m1FsuLGsiC7GQ8dOpRt40ew8BNGXCekGzduzLbxc72MeJYR2fLPsiIzO8Kmc+vXr5+yBMm9cwcPHgybNm0Kc+fOnS678RKQgAQkkACBZMUNNvGG7eXLlwdcPgw\/N2evXbs2IECcIz7Hjx\/Pbtxmp+OGDRuy+9zYIUl8L460R48eDeSlDKbiCBvX4nrJbxoJSEACEhg9gaTFjdkWFzF5QggOP2ERG0J0+fLlKTMqZnVsCCE9rpso8dQRXCwvHimXvNF1KyPmGcLRKiQgAQlIoEcCSYtbj20wmQQkIAEJSGAKAcVtCg5PJNByAjZPAmNCQHEbk462mRKQgATGiYDiNk69bVslIAEJVCfQiBIUt0Z0k0ZKQAISkEA\/BBS3fmiZVgISkIAEGkFAcUu8mzRPAhKQgAT6J6C49c\/MHBKQgAQkkDgBxS3xDtI8CVQnYAkSGD8Citv49bktloAEJNB6Aopb67vYBkpAAhKoTqBpJShuTesx7ZWABCQggWkJKG7TIjKBBCQgAQk0jYDilmKPaZMEJCABCVQiUIu48T413qvG+882b96cvVy0klVmloAEJCABCVQgUIu48ZJQ3qu2d+\/ecO3atezFogpdhV4xqwSqE7AECYw1gVrELRLcvn17uHv3buaKQrdnz56YzKMEJCABCUhgRgnUKm55S6PQbdy4MQs+f\/58YDanyGU4\/JCABCSQPoEGW1i7uOWvvyFmFy9eDBcuXMhmc6dOnQqInALX4G+MpktAAhJoAIFaxC0vaKtXrw7ffPNNQMhYorx582ZYtmxZhmLdunWB5cobN24E8mSBfkhAAhKQgARqJlCLuEWbEC4EDYeQxXCPvRAwjQQkIAEJ1EWgFnGLuyW5zjadYaRhZyV5pktrvAQkIAEJSGAQArWI2yAVm0cCEqifgCVKQAIvCdQiblw\/e\/vtt8Pt27dfllr4PHnyZOAmb9IVojyVgAQkIAEJ1E6gFnGr3SoLlIAEJCCBERFoR7UDi9vTp08Dj9piuz87JL\/66quwYcOG7F42wvLu8OHDYdOmTcHrbO340tgKCUhAAqkTGFjcZs+eHc6ePZvdv8Yjt5YuXTp5Pxu7JYuOjSSpw9A+CUhAAhJoB4GBxS3ffGZkn3322eT9bPk4\/V0JGCkBCUhAAjNAoBZxmwG7LFICEpCABCQwMIGBxY2dj+yA5LrbvXv3st2Q+etsRT9pyTOwpWaUgAQ6EzBUAhJ4hcDA4sZSJDdjc91t0aJFAX\/xOlv+nHjyvGKBARKQgAQkIIGaCQwsbjXbYXESkIAEJDA6Aq2reWBxY4mRpcbi8mPZOWnJ0zqCNkgCEpCABJIjMLC4scTIUmN+6bGbn7TkSY6ABklAAhKQQOsIDCxurSNRsUFffvll4H6\/Mnf\/\/v3JGvRIQAISkMDMElDcauL74YcfZk9sYfdoJ\/f+++8HBa4m2BYjAQlIYBoCA4sb18+4jsZA7q0AIfzzv\/42rPn3\/+jofrru3wIzO8Vtmm+j0X0QMKkEJNCNwMDixvUzrqN5K8BLvLN+NC\/8ePHyzu6flr9MVPETcSxb9ozhpKlYjdklIAEJNJ7AwOLW+JY3rAGIFkubzJS7OdKQtmHN01wJSGAEBNpcpeLWkN5FsFjadPmzIR2mmRKQwEgJ1Cpu8Tpc\/l43Zhm8HmekrWxR5cNY\/mwRLpsiAQmMKYHaxO3SpUuB97rx3rb8\/W5vvvlmWLNmTelbuseGe0INZRYYr9GVHUmTkMmaIgEJSKAvArWIGzOz06dPh40bN4bie9s4f+utt8KhQ4cC6fqyzsS1E0C0\/s+v\/2\/X2xaYbQ\/r2h32lAlsDCdN7SAsUAISaDWBWsTt2bNn4cGDB2HJkiUdYRFOPOk6JjBwaAQQiv9\/+\/8lcesCtiCiiGk3RxrSlkEiLgph2ZE0ZfkbFK6pEpBAjwRqEbdZs2aFBQsWhDt37nSslnDiSdcxgYFDJ9DLtTs2sMykWCA41FFlkwxlIH7dxJE40pB26KCtUAISGAmBWsRt9uzZYd++feHixYvh5MmTUxrCOeHEk25KpCdJE+j21BWWNusSi16EtgwUNlQVyLKyDZdAKwmMSaMGFrfizsgNGzaEJ0+ehMOHD4f8bknOCd+5c2cgz5hwbUUzy2ZUPHGFpU2EJZWGVhHIVNqgHRKQQH0EBha3+ISS\/M7Ibn6eZkKe+kx\/WRK7NPNiyvnLmPLPPXv2TAowjxArE13C33777bHd6VkqGD88cYUZU9myJeEpiV\/5t8EYCUigjQQGFrcUYNy+fTvs3r07nDp1KiCsHDknvMw+lklv3LiRPcGfPCtXrgy7du16ZScnwvbLX\/4y\/O1vfysrqofwdifptmwZr3N9+umnGWvErujYZNQ0Qgh2sR35c+JTahP25O0r+olPyV5tkUBdBGoTN8SAWVB+FpX3E0eaugynnI8\/\/jhwm8G6des4DRw5JzwLKHxQ\/7lz58L+\/ftDnEXu3bs32+nJH31MzuyPe\/aeP38eXnvttRjssUCgbNmSB0izdMnMjo0cCF0nR1yhyKRPEQKuNXZqSwwjnnQpNAQ7YBxt63QknnQp2KsNEqiTQG3ixrU1dkTeunUrIBjc88bM6MKFC2HhwoXh+PHjk4JSRwO4Z+7hw4ev3H6wfv36QDjxxXoePXoUEKx58+ZNRiFyzN7Y0Ukg+bhnj1ngRx99RJCuhEDpsiUPkP5h6XI6ASwpOslgRIBrjWVtQtCJJ123BhDPj6lujjSxjEGPlMEPjG72Ek+6QeswnwRSJVCLuDEjYqmPp5GwI5L72qLALFu2LLthuGw2FQb8xz1zLGtRV7EIwokvhiNuExMTIS9uMU0UN+znTQfMAmNcXUcGkm4DWrc42tSrHd3q6aecXuvrlm7WEN6W0K3+fFw3LrDvdZAvbdMPgp6vs+inDmZLnWZR+TDSkLaYf5DzKvYOUp95JJACgVrErdgQxIMdklFgePzW119\/3erdkt\/+9Vb49u6t8Ozvj4o4Js+nu0aVH9yKfga7yYKm8XSrp59ypqmmcdHduMAbNnUJShkcykdky2ZT+SVd0paVY7gE+iNQLTXfRX4ADvvHcRWraxE3bs5mSTIagrjhZ6bEcRzc15f+FK7+4Xfhb\/99sbS5ZQMay1lkKouPAx5penF1ldNLXU1KMx0XRIc\/4mG0qXQ2lVvSnc4ObGXAKXNNGoima6vxoyXAxrD4A3C0lvReey3ixlIeS5Js1mCJkutYP\/3pT8PVq1czSzjOmTMnIIJZQA0flIWgxuXEfJGEE58Pw4\/ocs2tk+h2Wt4kT68uDpz\/+C9vlWYpHdB+WM4qje9jwKPyusqhrDa5NnFB2JhpMuCUOeKH1X\/YUyayMZw0w7LHeuol8M477wQu17z33nuhKf9qETcaywOS2ZgRt9WzqQSxY8ckx2PHjgVEkLR1OMqaP3\/+K4\/8+uKLLwLhxBfrQdwmJiZCXtwQY64XVhW3WT9cW5r1o3nFaj2XQO0EEApmmvFHFbP7oosrAtNVTjlRgDodqatbGcQjpGUiG8NJQ9puZRmXJgE2BbKDfNWqVWka2MGq2sSNso8cOZKpO8LC7O3y5cvZ\/WccOSdNne7dd9\/NHvnF1n3K5cijvgjnvOiwgVfyHDx4cPL6X9zlSccV03sugdQJxB9VP2Z2X3Q\/rAhM14aq1yIRLARyOqElDWmns8d4CdRB4B\/qKGRUZbAT8+jRo2Hbtm3ZE0c4ck44NrGtn1+N3LjNOS7OMBEzZpXM2uqeVVKPTgKVCAwxc12iVIfQDrHZVtVyArWKG0t83KyNaESHuCAyM8WRLfvcTxcd57EuZpCsEyNoMYwjM8yYvtusEpG8cuVK4Eg+nQSGSYCZTqdlQsLq3CyiKA2zV61rWARqEzeWBJkNsewXhYMjG024FaDbI7GG1VjrkUCTCHRbLuT61TDbMiyhHWabxqCusW5iLeLGzIynevBUkuIsiXMeiXXo0KFXnt841uRtvASmITDdcuE02WuNTkloa21YQwrjWiUz9jJHfEOaMjQzaxE3btZmmaRsxyHhxJNuaC2zIgk0nEBKy4UpCW3Du7Vv8xEuZupc4ilzxJOu78JbnKEWceOeMu4t63TPGewIJ550nLfR2SYJtJlASkLbZs6d2oZosSxc9gODWz6IJ12n\/OMaVou4sXFj37592bb8\/M5EoHLO9nziSUeYTgKpEmCQKFv6YfUhVbu1q\/0ESn9g9HjLR\/sJTW3hwOJW3Bnpm7ingvWsmQRGe22pmcy0WgIpEhhY3Lghmm307IjsxZGWPClC0Kb0CZTNqOqeTZUt\/fD0D5Z\/eiFVZiszwrrt7cWepqRhWQ1G3RxpmtIe7RwtgYHFbbRmW\/u4ESibUXEhvU4WpUs\/PP2jx+WfMlvZDFC3vXW2fZRlIVqwgVE3RxrSdrOV+G4CSRxpupXRSxxlUFZVRzm91NdrGtO9JKC4veTgZ+IEymZUvc6mhtm8Mlv7mRoDLGQAABAASURBVP0N095h1lU2qyUcNx070nQTA+IQwG4CSRxpSDto28lLGZRV1VEOT90vE0ln+4P1Uq3ixo3aK1asyB6FFZ9Qwjnhg5lnLgm8JFA6o+pxNvWylOF8ltrax+xvOJYOv5ayWS0DPNZUZYfoIIBVRRJburle66GMXmyh\/WUiSRzlDMPRrjKRJbxJQlubuPGEEjaV7NixI3tYcrwOxznhxA+jc4Zah5VJQAJ9ESgb6OuegfcikoggA3aZY6CfrnG91NNLmjIuw5zt016EtExkCSd+OiapxNcibtM9oYQnl\/AEE9Kl0nDtkIAEhk+gdKAfwQy8bBbJII5jIGfAHwalUi5DnO3TVgQ\/BaGtg3kt4saTR5iu8iSSTkYRTjzpOsUbJoExJmDTR0RgukGcgZ4Bf0Tm9V0t9pbNQgnvtS0pCG3fje+QoRZx48kjPIGEJ5F0qCMQTjzpOsUbJgEJSGDYBNoyiEduKc1Eo02jPNYibjx5ZOvWreH8+fOBJ5LkG8Q54cSTLh+nXwISkEC\/BLrNUFgh6re8bunL6qq7nm429BT3IlHbZqIvmlTpfy3ihgW8R+3ChQvhxIkTU3ZLck448aTTSUACEqhCoNsMhetkVcou5i2rq+56ivUOct62meggDPJ5ahE3NopwAfbRo0fh5s2bU3ZLcu7LPvPI9UtAAlUITDdDqVJ2MW9ZXXXv7izW63l1ArWIGxtFmKZzba26SamXoH0SkMAoCQxzhlJa1wh2d46SeRPrrkXc2CjChpEmAtBmCUhAAhJoH4FaxI2NIrzS5uzZs8GnkbTvS2KL6idgiRKQwMwSqEXceP3Nzp07A\/dR8DSS+Oit\/HHt2rWBdDPbHEuXgAQkIAEJhFCLuPEqG15pEx+51elIPOmELgEJSEACdRCwjG4EahG3bhUYJwEJSEACaRAou2+PJ5iwKTANK+uxorK4cZN2fvnRByTX0zGWIgEJSKBuAmX37XErV4r37lVpfyVxQ9jiTdosRXKz9u7du195SkkVAxPJqxkSkIAEGk+g7L69Yb59YFgQBxY3bty+cuVK4JU28SZtjpwTTvywGmE9EpCABCQwPYHS+\/aG+PaB6a2sJ8XA4hZv3C6a4RsAikQ8l8APBDxIQAJDIzCwuHWz8Lvvvgs8iqtbGuMkIAEJSEACM0VgRsRtpoy1XAlIQAJjTsDm90hAcesRlMkkIAEJSKA5BBS35vSVlkpAAhKQQI8EKovb4cOHp7y\/bdu2beHJkyeh+BiuJj5+q0eGJpOABCQggcQIDCxuPEqLR2pxf1svjrTkSaz9miMBCUhAAi0kMLC4tZCFTZLADBCwSAlIYBQEFLdRULdOCUhAAhKYUQKK24zitXAJSEAC1QlYQv8EFLf+mZlDAhKQgAQSJ6C4Jd5BmicBCUhAAv0TUNyKzDyXgAQkIIHGE1DcGt+FNkACEpCABIoEFLciEc8lUJ2AJUhAAiMmoLiNuAOsXgISkIAE6ieguNXP1BIlIAEJVCdgCZUIKG6V8JlZAhKQgARSJKC4pdgr2iQBCUhAApUIKG4ZPj8kIAEJSKBNBBS3NvWmbZGABCQggYxA0uL29OnTsHnz5sn3xeEnLLO85OP27dthxYoVk3lOnjz5Sso9e\/ZMxnd6z1w+fvHixVlawl4pyAAJ5AjolYAE0iGQtLgdOHAgI3Xr1q2A4ySG4S+6x48fh507d4YdO3YE3jF34cKFcOLEiXDp0qXJpIjdjRs3wrVr17I0K1euDLt27QpRNDk+fPgw7N27N4unHNyRI0cmy9AjAQlIQAJpE0hW3JiBXb9+Pezbty\/Mnj07c\/gJI64T1vPnz4cFCxaELVu2ZNHLli3LhO706dOZeCF+586dC\/v37w\/xxamI2IMHDzKxI9OzZ88C50uWLOFUJwEJSGCIBKyqLgLJitujR4\/CxMREmDdv3mRbFy1aFBYuXBiImwzMee7cuRPmz5+fCWEMXrNmTXjy5ElAtMj3\/PnzKWUicszeyEueTmkI10lAAhKQQHMIJCtuiA2zsFmzZr1Ck7hiYFxO7DTj+v777zNBRLgmJiamiFssJ5ZJGsKY\/Xm9DRI6CUhAAs0jkKy4DQFlxyoQOcTwzJkz2TU3rvVxDW66DSXf\/vVW+PburfDs7486lmugBCQggaYSYFxr2vimuBW+bdu3bw83b94MXK8LL\/5xvW\/r1q3h4sWLoexa34tk4etLfwpX\/\/C78Lf\/vsipTgISkEBrCDCuMb79z3\/9Z2PalKy4sbzIxg6ulRVpElcMQ4S43sbMqxj32muvZUuRXL\/jmltcesyn61RmjCcfZcTzTsd\/\/tffhjX\/\/h\/hH\/\/lrU7RhrWVgO2SwBgQYFxjfPvpun9rTGuTFTcEpShE9+7dC\/fv38+EqhNhBIolRK6\/xfirV6+GOXPmBK7dUebExER2\/S3Gs4OSWwPISxjLjzj80SGGExOdr9XFNLN+NC\/8ePHywDGGeZSABCTQBgKMa4xvP\/6n5Y1pTrLixrLgG2+8EQ4dOpRt40ew8BNGXCfCGzduzLbxc72MeJYRuc+NZUVmduyM3LRpUzh48GBA1Ehz+PDh7PaB1atXcxrWr18\/ZQmSdKQnH\/mzRH5IQAISqI+AJc0AgWTFjbbGG7aXL18ecPkw\/NycnX\/CCOJz\/Pjx7MZtdjpu2LAhu89t3bp1JM8c19TY+r\/6hZiRhlnbsWPHJm8fIO3Ro0cDeYknHcJGvqwAPyQgAQlIIHkCSYsbs62zZ89muxZ5Sgh+wiJVhOjy5cuTN2QTzqyODSGkx3USJZ42QhyumJ8yKJe46DqVQTqdBCQgAQmkSSBpcZsJZJYpAQlIQALtJ6C4tb+PbaEEJCCBsSOguI1dl9vg6gQsQQISSJ2A4pZ6D2mfBCQgAQn0TUBx6xuZGSQgAQlUJ2AJM0tAcZtZvpYuAQlIQAIjIKC4jQC6VUpAAhKQwMwSGA9xm1mGli4BCUhAAokRUNwS6xDNkYAEJCCB6gQUt+oMLWE8CNhKCUigQQQUtwZ1lqZKQAISkEBvBBS33jiZSgISkEB1ApYwNAKK29BQW5EEJCABCQyLgOI2LNLWIwEJSEACQyPQYnEbGkMrkoAEJCCBxAgobol1iOZIQAISkEB1AopbdYaW0GICNk0CEmgmAcWtmf2m1RKQgAQk0IWA4tYFjlESkIAEqhOwhFEQUNxGQd06JSABCUhgRgkobjOK18IlIAEJSGAUBNombqNgaJ0SkIAEJJAYAcUtsQ7RHAlIQAISqE5AcavO0BLaRsD2SEACjSeguDW+C22ABCQgAQkUCShuRSKeS0ACEqhOwBJGTEBxG3EHWL0EJCABCdRPQHGrn6klSkACEpDAiAm0QtxGzNDqJSABCUggMQKKW2IdojkSkIAEJFCdgOJWnaEltIKAjZCABNpEQHFrU2\/aFglIQAISyAgobhkGPyQgAQlUJ2AJ6RBQ3NLpCy2RgAQkIIGaCChuNYG0GAlIQAISSIdAc8UtHYZaIgEJSEACiRFQ3BLrEM2RgAQkIIHqBBS36gwtobkEtFwCEmgpAcWtpR1rsyQgAQmMMwHFbZx737ZLQALVCVhCkgQUtyS7RaMkIAEJSKAKAcWtCj3zSkACEpBAkgQaJm5JMtQoCUhAAhJIjIDilliHaI4EJCABCVQnoLhVZ2gJDSOguRKQQPsJKG7t72NbKAEJSGDsCChuY9flNlgCEqhOwBJSJ6C4pd5D2icBCUhAAn0TUNw6ILt9+3ZYsWJFWLx4ceZOnjzZIZVBEpCABCSQKoEmiNtQ2T1+\/Djs3Lkz7NixI9y9ezdcuHAhnDhxIly6dGmodliZBCQgAQkMTkBxK7A7f\/58WLBgQdiyZUsWs2zZskzoTp8+HZ4+fZqF+SEBCUhAAmkTUNwK\/XPnzp0wf\/78MHv27MmYNWvWhCdPnoRnz55NhulpGAHNlYAExoqA4pbrbmZmDx8+DEuWLMmFvvR+\/\/334dGjRy9POnx++9db4du7nd2zv7\/MV5ZmunjKTSmNtgzWz\/ZjCP4NTP3u1PG3VEcZ\/X43OwyByQUpbhW7ZOHChWHVqlXh60t\/Clf\/8LuO7n\/+6z+zWsrSTBdPuSml0ZbOfZ0Sl16+MynZm5ItXdhN\/n2nZO+wbWG8Y9zLBrWEPxS3ip1DJ3\/wwQfh7NmzOhn4HfA70PrvAOMd417FoXPGsytuOcRcZ+N6G9fdcsGZ97XXXgvz5s3L\/MUPOnr16tVBJwO\/A34H2v4dYLwrjoEpnicrbqOCxfU2rrtx\/S3acPXq1TBnzpwwa9asGORRAhKQgAQSJqC4FTpn48aN4cGDB+HMmTNZDDd0c5\/b1q1bp+ygzCL9kIAEJCCBJAkoboVumTt3bjh+\/Hh24zZPKNmwYUN2n9u6desKKT1Nn4AWSkAC40pAcevQ89y4ffPmzewJJTylZPv27R1SGSQBCUhAAqkSUNxS7RntkoAEkiCgEc0koLg1s9+0WgISkIAEuhBQ3LrA6RbFbsrNmzdnbw3g2hx+wrrlMW60BPbs2RN8w8No+6BT7Wzayr+Fw7+lTpRGG8bYRr8w1uH4WxqtRdPXnpa4TW9vMikOHDiQ2XLr1q2A4ySG4delRYA\/Rh6KnZZVWoOw8ZDyo0ePTl7j5l7Tbdu2+aDyRL4eCBv9Qb+wB4HxjtulUv+hqLgN8AXiD\/L69eth37592e0B3PyNnzDiBijSLDNEgFcYrV27Nly8eDE05ebTGUKRZLHcQ7p06dLsAQjRwHfffTfcv38\/3Lt3LwZ5HCEB+oEHx+\/duzezgvGOW6OuXLmS9A8QxS3rrv4+eIDyxMTElCeWLFq0KBs8ieuvNFPXTGBKcczWVq5cGRhEFbcpaJI4YScyj65jwEzCII14hQC7xz\/77LPAbVL5SO4HTvlNKYpbvrd69PN4Lt751umJJcT1WIzJhkCAwfPIkSNDqMkq6iLAD5GJiak\/Husq23KqE2A15ODBg2HTpk2vCF710usrQXGrj6UlSUACFQnwxvvDhw+H\/fv3j3bgrNiONmbn2hubSnh2Ju3jaU4cU3WKW6o9o10SGDMCCBsbF7i24xOB0ut8lo5ZQmZTCT8+3nrrrZDyHgPFbYDvEA9XLltvJm6AIs0igbEmkBc2lpLHGkYDGs\/sjY1ALCGnam4C4pYqmnK7ePXN8+fPQ37zCDuK2OFFXHlOYyQggSKBKGynTp0KCluRzujP6R92HHOtbfTW9G6B4tY7q8mU7B564403wqFDh7KtsKxF4yeMuMmEeiQgga4EWNbavXt3QNhciuyKamSRy5cvz+rmWmjmefHBW1NYvUr5upvi9qKjBvkfb9im43GUEcPw64ZLwNqaSeDjjz8O3EPFtTaefJF3zBia2ap2Wc0tAJ988km4cePG5BOZzp07FwgjLtXWKm4D9kz+4ioXWLnQStiAxZlthgnQN\/SRy14zDLrP4rlNg7+fTs6ZXJ8wZzA5Inb58uXJp8jXgGL7AAADf0lEQVTgJ2wGq6xctOJWGaEFSEAC7SBgK9pEQHFrU2\/aFglIQAISyAgobhkGPyQgAQlIoE0ERiVubWJoWyQgAQlIIDECiltiHaI5EpCABCRQnYDiVp2hJYyKgPVKQAISKCGguJWAMVgCEpCABJpLQHFrbt9puQQkUJ2AJbSUgOLW0o61WekS2LNnz+STHvJP5Mj7ebXI73\/\/+9DEZ\/qlS17LxomA4jZOvW1bkyBQfCoHz+fjKeu3bt2afAIET1P5zW9+E5rwJIgkoGqEBAoEhipuhbo9lYAEJCABCcwIAcVtRrBaqASqEzh58uTksiSvG2GJ8ujRo4Ely7iEiZ+3UuSXOklH+rwFPIQ45uEY8+XT6JdAmwgobm3qzbFoy3g38qOPPgpbt27Nli8vXLgQvvrqq8BbKZYsWZKFsbS5YMGCsGvXrux1TNBCJHnqPq+V4QHFpCGcMIQRv04CbSOguLWtR21PqwlwfS4+LX\/RokVh6dKlget1W7ZsydrN2w\/efPPNwLu2nj17FpjB8XqSfD7S7Nu3LxNG3suVZfRDAi0joLi1rENtTrsJMEPrp4XM0r755puwfv36KdmiMN65c2dK+Lic2M72E1Dc2t\/HtlACgSVIrrVFx1LmtWvXJCOB1hJQ3FrbtTZMAi8JzJkzJ3B9juttRcdtCS9T+SmBdhGYeXFrFy9bI4FGEWCG9vrrr4erV69OsZtrceyqZLPJlAhPJNASAopbSzrSZkigE4G5c+eGTZs2hcOHDwduB4hpOMfPRhOOOgm0jYDi1rYebWd7bFUFAtu3bw\/cBpC\/7vbw4cPw+eefB8SvQtFmlUCyBBS3ZLtGw8aFANe9eNwWW\/TzbUaU4uO3ECH8hMU0pCcfDn8MJw1pyRPDuH0gf72tmCem8yiBthBQ3NrSk7ZDAhLoTsDYsSKguI1Vd9tYCUhAAuNBQHEbj362lRKQgATGisAMidtYMbSxEpCABCSQGAHFLbEO0RwJSEACEqhOQHGrztASZoiAxUpAAhIYlIDiNig580lAAhKQQLIEFLdku0bDJCCB6gQsYVwJKG7j2vO2WwISkECLCShuLe5cmyYBCUhgXAnUKW7jytB2S0ACEpBAYgQUt8Q6RHMkIAEJSKA6AcWtOkNLqJOAZUlAAhKogYDiVgNEi5CABCQggbQIKG5p9YfWSEAC1QlYggTC\/wIAAP\/\/eSK+QAAAAAZJREFUAwBiPXxpvBrNIwAAAABJRU5ErkJggg==","height":299,"width":399}}
%---
%[output:5a70cffa]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:102e68ff]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:059defd7]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:9c3c0db4]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) < 10 percent","truncated":false}}
%---
%[output:2fe0329d]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:0e9b0c2b]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:25c5ec43]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:22c464e7]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:9eb04ea7]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:9b79610b]
%   data: {"dataType":"text","outputData":{"text":"The minimum number of servers recommended to meet the goal is s = 7.","truncated":false}}
%---
%[output:606347de]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:5b4ae521]
%   data: {"dataType":"text","outputData":{"text":"When s = 7, P( W_q > 5 minutes) = 0.064591","truncated":false}}
%---
%[output:22e1e226]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  1.3537  minutes.","truncated":false}}
%---
%[output:6242446b]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:1f869a3d]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  1197","truncated":false}}
%---
%[output:13e96541]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  18532","truncated":false}}
%---
%[output:96ec7915]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:67dc349c]
%   data: {"dataType":"text","outputData":{"text":"W                  7.8556             7.3091             6.9571            \n","truncated":false}}
%---
%[output:06a44e34]
%   data: {"dataType":"text","outputData":{"text":"Wq                 1.3537             1.0131             25.1631           \n","truncated":false}}
%---
%[output:544fb213]
%   data: {"dataType":"text","outputData":{"text":"L                  6.2845             5.8253             7.3071            \n","truncated":false}}
%---
%[output:3f4ef700]
%   data: {"dataType":"text","outputData":{"text":"Lq                 1.0829             0.8263             23.7034           \n","truncated":false}}
%---
%[output:2714eaf5]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:42d00cdf]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:2d6823c5]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:5ba6cdeb]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 7                         **","truncated":false}}
%---
%[output:9f079c11]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:15c65ac7]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:5178a32c]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:8c0f05ff]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:4b929520]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:6a1448d1]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:0b004020]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 1.013057\n","truncated":false}}
%---
%[output:314fd5ca]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 0.826253\n","truncated":false}}
%---
%[output:02a973b9]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 7.309114\n","truncated":false}}
%---
%[output:4420b29d]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 5.825295\n","truncated":false}}
%---
%[output:02354895]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:27021228]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 5.401927\n","truncated":false}}
%---
%[output:232f268c]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 6.756690\n","truncated":false}}
%---
%[output:430f2985]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 0.358740\n","truncated":false}}
%---
%[output:9b12f944]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 0.444726\n","truncated":false}}
%---
%[output:7e171a3e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:210f177c]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:04c9cfc9]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:29e86ce7]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:49cd06b0]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:587cd2f7]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:7a5d0a8e]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 8                         **","truncated":false}}
%---
%[output:8cba8b54]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:8e44d40e]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:748db839]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:2d340f4b]
%   data: {"dataType":"text","outputData":{"text":"Lq                 0.3690             0.3587             2.7933            \n","truncated":false}}
%---
%[output:96f4b22c]
%   data: {"dataType":"text","outputData":{"text":"L                  5.5706             5.4019             3.0281            \n","truncated":false}}
%---
%[output:285f4e07]
%   data: {"dataType":"text","outputData":{"text":"Wq                 0.4613             0.4447             3.5950            \n","truncated":false}}
%---
%[output:82b1dedd]
%   data: {"dataType":"text","outputData":{"text":"W                  6.9633             6.7567             2.9666            \n","truncated":false}}
%---
%[output:0eb89c3c]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:214b20bc]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  18674","truncated":false}}
%---
%[output:3b9f2e27]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  474","truncated":false}}
%---
%[output:6666462a]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:0b1203c4]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  0.46131  minutes.","truncated":false}}
%---
%[output:2282bfb7]
%   data: {"dataType":"text","outputData":{"text":"When s = 8, P( W_q > 5 minutes) = 0.025383","truncated":false}}
%---
%[output:1b74e0e2]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:1fb3d16a]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) < 10 percent","truncated":false}}
%---
%[output:88f9a29e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:1f9be117]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:9dc35d2e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:40a98266]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:2ff9c356]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
