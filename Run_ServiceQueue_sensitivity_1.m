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



for k = 7:9 %[output:group:48e37f5c]
    P = zeros(1, k-1);    % initiaizes the row vector the first time
    % clears row vector so I can use this again for the next graph
    % thereafter

     fprintf("***********************************************************************");    %[output:31bfa214] %[output:6f1a213f] %[output:56d0cd0c]
     fprintf("**                                                                   **"); %[output:3d43f3e4] %[output:2df8fea8] %[output:68bd8d06]
     fprintf("**          Theoretical Calculations for P_n, L_q, W_q, L, W         **"); %[output:8d826c7f] %[output:08a2a56e] %[output:61a06fa8]
     fprintf("**                      " + "number of servers k = " + k+ "                      **"); %[output:3ab88b59] %[output:84cecd4b] %[output:40abf12a]
     fprintf("**                                                                   **"); %[output:6c3cb95a] %[output:6079df1d] %[output:58f01074]
     fprintf("***********************************************************************");  %[output:0208606c] %[output:7f0c6592] %[output:174e5020]


    disp(" ");  %[output:092bb1de] %[output:5409df48] %[output:0a41432b]

    %fprintf("The current number of servers in the theoretical calculations is\nk = %d", k);
    

j = 0:(k-1);
terms = ((lambda / mu).^j) ./ factorial(j);
first = sum(terms);
second = (1 / factorial(k)) * (lambda / mu).^k * (1 / (1 - lambda / (k * mu)));
P0 = 1/(first + second);
fprintf("P(0) = %f\n", P0); %[output:08dcd782] %[output:7f995aed] %[output:67bd04c5]
P(1) = P0;


%%%  FIND A WAY TO SAVE ALL THE P(Wq??? > 5) \leq .1   info and just print
%%%  that here ***************

nMax = k-1; 
    fprintf("The probability that some cashiers are busy but there is no line:"); %[output:38e370e9] %[output:49d5bfba] %[output:3ee79fad]
for n = 1:nMax    
    
        
        if  n < k             % 1 <= n <= k 
            
            P(n+1) = (1./ factorial(n))*((lambda / mu).^n)*(P0);   
            fprintf("P(%d) = %f\n", n, P(n+1)); %[output:26dc05ae] %[output:02c249f7] %[output:3c2a672c]
 
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
      fprintf("The number of customers waiting, L_q(%d): %f\n", n,   Lq); %[output:5ec71185] %[output:82f122a8] %[output:4907bdea]
      L = Lq + (lambda./mu);                          
      fprintf("The expected number of customers in the system, L(%d): %f\n", n,  L);                 %[output:61077729] %[output:27a7396c] %[output:177eb492]
      Wq = (Lq./ lambda);                           
      fprintf("The expected time customers wait before beginning service, W_q(%d): %f\n", n,  Wq);    %[output:5457eb56] %[output:16e5cc75] %[output:296a2d37]
      W = (L./ lambda);                           
      fprintf("The  expected time customers spend in the system, including waiting time and service time, W(%d): %f\n", n,  W);  %[output:465f5cfd] %[output:81cd9a6d] %[output:2f35a4ab]
              



    disp(" ");  % this is also needed for aesthetic reasons  %[output:0e3bdf93] %[output:4ce5fcdc] %[output:5128a18f]
    disp(" "); %[output:4cae4bdc] %[output:7ba315c7] %[output:786fd82e]



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


     fprintf("***********************************************************************");    %[output:084d163a] %[output:2b242be5] %[output:79f4cde9]
     fprintf("**                                                                   **"); %[output:6022f168] %[output:06698ace] %[output:00bef058]
     fprintf("**          Simulation Calculations for P_n, L_q, W_q, L, W          **"); %[output:6808d418] %[output:43742ad9] %[output:0a250611]
     fprintf("**                      " + "number of servers k = " + k+ "                      **"); %[output:7c83bc05] %[output:1367aca9] %[output:41cf0279]
     fprintf("**                                                                   **"); %[output:87220a74] %[output:41f6e0c8] %[output:19207363]
     fprintf("***********************************************************************");       %[output:747a079e] %[output:183e6266] %[output:65907eba]

    disp("");
for SampleNum = 1:NumSamples
    fprintf("Working on sample %d\n", SampleNum); %[output:75cee2ce] %[output:36fc0a10] %[output:75b48299]
    q = ServiceQueue( ...
        ArrivalRate=lambda, ...
        DepartureRate=mu, ...
        NumServers=s, ...
        LogInterval=LogInterval);
    q.schedule_event(Arrival(random(q.InterArrivalDist), Customer(1)));
    run_until(q, MaxTime);
    QSamples{SampleNum} = q;
end

%[output:group:7cb9eaae]
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
fprintf("Mean number in system: %f\n", meanNumInSystem); %[output:464c171e] %[output:7309789b] %[output:8cff35f8]
%[text] Make a figure with one set of axes.
fig = figure(); %[output:91c4377a] %[output:3f38bdcd] %[output:26ea03f6]
t = tiledlayout(fig,1,1); %[output:91c4377a] %[output:3f38bdcd] %[output:26ea03f6]
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
    fprintf("These are the y axis P values:"); %[output:050e607f] %[output:39e2dd8f] %[output:393fb58c]
    disp(P); %[output:4a0cd27c] %[output:8e3d7da3] %[output:0b24c200]
    %fprintf("This is PP:");
    %disp(PP);

plot(ax, 0:nMax, P, 'o', MarkerEdgeColor='k', MarkerFaceColor='r'); %[output:91c4377a] %[output:3f38bdcd] %[output:26ea03f6]
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
exportgraphics(fig, PictureFolder + filesep + "Number in system histogram.svg"); %[output:group:5183bb06]
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
fprintf("Mean time in system: %f\n", meanTimeInSystem); %[output:19e35e66] %[output:8740f9d2] %[output:0c37f300]
%[text] Make a figure with one set of axes.
fig = figure(); %[output:53789e1b] %[output:2e14153c] %[output:603da2f2]
t = tiledlayout(fig,1,1); %[output:53789e1b] %[output:2e14153c] %[output:603da2f2]
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
exportgraphics(fig, PictureFolder + filesep + "Time in system histogram.svg"); %[output:group:605843d2]
%%





disp(" "); %[output:4089801b] %[output:6e39ce5e] %[output:47f423eb]
fprintf("Here are the averages of the following values."); %[output:1f05c7f8] %[output:16d8437a] %[output:6d817a68]
%fprintf("The current number of servers in the simulation calculations is\ns = %d", s);
fprintf("Number of Customers in system (L): %f\n", mean(NumInSystem)); %[output:1aa33679] %[output:6ff66c2b] %[output:6782c6c8]
fprintf("Total time customer spends in system (W): %f\n", mean(TimeInSystem)); %[output:8e2008c7] %[output:4efb0270] %[output:15015bec]
fprintf("Number of customers waiting (L_q): %f\n", mean(NumWaiting)); %[output:88403f67] %[output:6eb7e90a] %[output:37f65767]
fprintf("Customer Wait time before service (W_q): %f\n", meanWaitTime); %[output:301d3d0e] %[output:9ac4c272] %[output:4270d036]




disp(" "); %[output:2a92bb42] %[output:24385668] %[output:978ccb9e]
disp(" "); %[output:43032c7e] %[output:6575b3b8] %[output:8d6c073d]
disp(" "); %[output:3311ccda] %[output:3b7ce2e0] %[output:77ea5803]

     fprintf("*****************************************************************************");    %[output:8585369b] %[output:681d7f07] %[output:58308d16]
     fprintf("**                                                                         **"); %[output:61107f47] %[output:9594d438] %[output:7a2c4c81]
     fprintf("**            Comparing Theoretical and Simulation Calculations            **"); %[output:031c60a9] %[output:0f39eca7] %[output:09b2f5f6]
     fprintf("**                         " + "number of servers k = " + k+ "                         **"); %[output:000c36b2] %[output:30f33817] %[output:97b5f683]
     fprintf("**                                                                         **"); %[output:7bb131ec] %[output:6606f665] %[output:9cf4f947]
     fprintf("*****************************************************************************"); %[output:033408ed] %[output:8e39f1be] %[output:49e17bf4]

Error_1 = (abs(Lq - mean(NumWaiting))./Lq)*100;
Error_2 = (abs(L - mean(NumInSystem))./L)*100;
Error_3 = (abs(Wq - mean(ExpectedWaitingTime))./Wq)*100;
Error_4 = (abs(W - mean(TimeInSystem))./W)*100;


% Header with fixed spacing
fprintf('%-18s %-18s %-18s %-18s\n', 'Value Type', 'Theoretical', 'Simulation', 'Error Percent'); %[output:56ffdcc3] %[output:627dde3d] %[output:87c507b2]

% Data rows using fixed-width floats
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'Lq', Lq, mean(NumWaiting), Error_1); %[output:3c2d6e5f] %[output:9713f82d] %[output:0a05ed13]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'L', L, mean(NumInSystem), Error_2); %[output:47fd2f81] %[output:23a09383] %[output:10cc0b66]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'Wq', Wq, mean(ExpectedWaitingTime), Error_3); %[output:7566ae6b] %[output:6ffca567] %[output:2f9b5bd8]
fprintf('%-18s %-18.4f %-18.4f %-18.4f\n', 'W', W, mean(TimeInSystem), Error_4); %[output:888c57a0] %[output:1534be93] %[output:7aeb7c10]



%fprintf("Customer Wait time before service (W_q) matrix printed out: ");
%fprintf("(W_q): %f\n ", ExpectedWaitingTime);

longWaits = ExpectedWaitingTime(ExpectedWaitingTime > 5);
disp(" ");    %[output:613df5e5] %[output:8c3f1058] %[output:99f12283]

%fprintf("These are the wait times that are greater than 5 minutes:");
%fprintf("(W_q): %f\n ",longWaits);
fprintf("These are the total number of customer wait times:  " + length(ExpectedWaitingTime)); %[output:96352b6d] %[output:78c522db] %[output:3c2684c4]
fprintf("These are the total number of customer wait times W_q > 5 minutes:  " + length(longWaits)); %[output:3fb67f18] %[output:1c1c2914] %[output:08a81aaa]
P_of_Wq_greatherthan_5min = length(longWaits)/length(ExpectedWaitingTime);

disp(" ");   %[output:2bb67868] %[output:07d0ed1e] %[output:49d4d01d]
fprintf(2,"The theoretical Wq has us waiting  " + Wq + "  minutes."); %[output:07ada7e7] %[output:3931047c] %[output:941ae129]
fprintf("When s = " +s+", P( W_q > 5 minutes) = " + P_of_Wq_greatherthan_5min); %[output:5b70ad8c] %[output:5bc5a91f] %[output:241a1686]
disp(" ");  %[output:0e3d618f] %[output:3cfad722] %[output:0ad640f8]

if s == 7
    fprintf(2,"P(W_q > 5 minutes) > 10 percent "); %[output:0c1ae538]
elseif s == 8
   fprintf(2,"P(W_q > 5 minutes) > 10 percent");    %[output:5d785a62]
else 
   fprintf(2,"P(W_q > 5 minutes) < 10 percent");  %[output:77c00196]
   fprintf(2, "The minimum number of servers recommended to meet the goal is s = 9."); %[output:44356fa3]
end









disp(" "); %[output:85bb77f4] %[output:31a2dd48] %[output:021aacfa]
disp(" "); %[output:407b98c3] %[output:507c752b] %[output:490ef293]
disp(" "); %[output:71b2f952] %[output:540ea648] %[output:73bb95c2]
disp(" "); %[output:9f54f9c2] %[output:9d407ce6] %[output:658005a4]
disp(" "); %[output:89296080] %[output:90251beb] %[output:526fd79e]



     %P = zeros(1, k-1);    % clears row vector so I can use this again for the next graph
end % this ends the s = k loop %[output:group:81bed6e5]

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
%[output:6f1a213f]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:19e35e66]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 12.411171\n","truncated":false}}
%---
%[output:53789e1b]
%   data: {"dataType":"image","outputData":{"dataUri":"data:,","height":400,"width":534}}
%---
%[output:4089801b]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:1f05c7f8]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:1aa33679]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 9.952319\n","truncated":false}}
%---
%[output:8e2008c7]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 12.411171\n","truncated":false}}
%---
%[output:88403f67]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 3.953458\n","truncated":false}}
%---
%[output:301d3d0e]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 4.688431\n","truncated":false}}
%---
%[output:2a92bb42]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:43032c7e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3311ccda]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:8585369b]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:61107f47]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:031c60a9]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:000c36b2]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 7                         **","truncated":false}}
%---
%[output:7bb131ec]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:033408ed]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:56ffdcc3]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:3c2d6e5f]
%   data: {"dataType":"text","outputData":{"text":"Lq                 8.0771             3.9535             51.0535           \n","truncated":false}}
%---
%[output:47fd2f81]
%   data: {"dataType":"text","outputData":{"text":"L                  14.4771            9.9523             31.2548           \n","truncated":false}}
%---
%[output:7566ae6b]
%   data: {"dataType":"text","outputData":{"text":"Wq                 10.0964            4.6884             53.5632           \n","truncated":false}}
%---
%[output:888c57a0]
%   data: {"dataType":"text","outputData":{"text":"W                  18.0964            12.4112            31.4163           \n","truncated":false}}
%---
%[output:613df5e5]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:96352b6d]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  17989","truncated":false}}
%---
%[output:3fb67f18]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  6037","truncated":false}}
%---
%[output:2bb67868]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:07ada7e7]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  10.0964  minutes.","truncated":false}}
%---
%[output:5b70ad8c]
%   data: {"dataType":"text","outputData":{"text":"When s = 7, P( W_q > 5 minutes) = 0.33559","truncated":false}}
%---
%[output:0e3d618f]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:0c1ae538]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) > 10 percent ","truncated":false}}
%---
%[output:85bb77f4]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:407b98c3]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:71b2f952]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:9f54f9c2]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:89296080]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:56d0cd0c]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:91c4377a]
%   data: {"dataType":"image","outputData":{"dataUri":"data:,","height":400,"width":534}}
%---
%[output:2df8fea8]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:68bd8d06]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:08a2a56e]
%   data: {"dataType":"text","outputData":{"text":"**          Theoretical Calculations for P_n, L_q, W_q, L, W         **","truncated":false}}
%---
%[output:61a06fa8]
%   data: {"dataType":"text","outputData":{"text":"**          Theoretical Calculations for P_n, L_q, W_q, L, W         **","truncated":false}}
%---
%[output:84cecd4b]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 8                      **","truncated":false}}
%---
%[output:40abf12a]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 9                      **","truncated":false}}
%---
%[output:6079df1d]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:58f01074]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:7f0c6592]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:174e5020]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:5409df48]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:0a41432b]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:7f995aed]
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.001311\n","truncated":false}}
%---
%[output:67bd04c5]
%   data: {"dataType":"text","outputData":{"text":"P(0) = 0.001526\n","truncated":false}}
%---
%[output:49d5bfba]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:3ee79fad]
%   data: {"dataType":"text","outputData":{"text":"The probability that some cashiers are busy but there is no line:","truncated":false}}
%---
%[output:02c249f7]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.008391\nP(2) = 0.026852\nP(3) = 0.057283\nP(4) = 0.091653\nP(5) = 0.117316\nP(6) = 0.125137\nP(7) = 0.114411\n","truncated":false}}
%---
%[output:3c2a672c]
%   data: {"dataType":"text","outputData":{"text":"P(1) = 0.009766\nP(2) = 0.031252\nP(3) = 0.066672\nP(4) = 0.106675\nP(5) = 0.136543\nP(6) = 0.145646\nP(7) = 0.133162\nP(8) = 0.106530\n","truncated":false}}
%---
%[output:82f122a8]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(7): 1.830580\n","truncated":false}}
%---
%[output:4907bdea]
%   data: {"dataType":"text","outputData":{"text":"The number of customers waiting, L_q(8): 0.645483\n","truncated":false}}
%---
%[output:27a7396c]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(7): 8.230580\n","truncated":false}}
%---
%[output:177eb492]
%   data: {"dataType":"text","outputData":{"text":"The expected number of customers in the system, L(8): 7.045483\n","truncated":false}}
%---
%[output:16e5cc75]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(7): 2.288225\n","truncated":false}}
%---
%[output:296a2d37]
%   data: {"dataType":"text","outputData":{"text":"The expected time customers wait before beginning service, W_q(8): 0.806853\n","truncated":false}}
%---
%[output:81cd9a6d]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(7): 10.288225\n","truncated":false}}
%---
%[output:2f35a4ab]
%   data: {"dataType":"text","outputData":{"text":"The  expected time customers spend in the system, including waiting time and service time, W(8): 8.806853\n","truncated":false}}
%---
%[output:4ce5fcdc]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:5128a18f]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:7ba315c7]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:786fd82e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:2b242be5]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:79f4cde9]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:06698ace]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:00bef058]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:43742ad9]
%   data: {"dataType":"text","outputData":{"text":"**          Simulation Calculations for P_n, L_q, W_q, L, W          **","truncated":false}}
%---
%[output:0a250611]
%   data: {"dataType":"text","outputData":{"text":"**          Simulation Calculations for P_n, L_q, W_q, L, W          **","truncated":false}}
%---
%[output:1367aca9]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 8                      **","truncated":false}}
%---
%[output:41cf0279]
%   data: {"dataType":"text","outputData":{"text":"**                      number of servers k = 9                      **","truncated":false}}
%---
%[output:41f6e0c8]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:19207363]
%   data: {"dataType":"text","outputData":{"text":"**                                                                   **","truncated":false}}
%---
%[output:183e6266]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:65907eba]
%   data: {"dataType":"text","outputData":{"text":"***********************************************************************","truncated":false}}
%---
%[output:36fc0a10]
%   data: {"dataType":"text","outputData":{"text":"Working on sample 1\nWorking on sample 2\nWorking on sample 3\nWorking on sample 4\nWorking on sample 5\nWorking on sample 6\nWorking on sample 7\nWorking on sample 8\nWorking on sample 9\nWorking on sample 10\nWorking on sample 11\nWorking on sample 12\nWorking on sample 13\nWorking on sample 14\nWorking on sample 15\nWorking on sample 16\nWorking on sample 17\nWorking on sample 18\nWorking on sample 19\nWorking on sample 20\nWorking on sample 21\nWorking on sample 22\nWorking on sample 23\nWorking on sample 24\nWorking on sample 25\nWorking on sample 26\nWorking on sample 27\nWorking on sample 28\nWorking on sample 29\nWorking on sample 30\nWorking on sample 31\nWorking on sample 32\nWorking on sample 33\nWorking on sample 34\nWorking on sample 35\nWorking on sample 36\nWorking on sample 37\nWorking on sample 38\nWorking on sample 39\nWorking on sample 40\nWorking on sample 41\nWorking on sample 42\nWorking on sample 43\nWorking on sample 44\nWorking on sample 45\nWorking on sample 46\nWorking on sample 47\nWorking on sample 48\nWorking on sample 49\nWorking on sample 50\nWorking on sample 51\nWorking on sample 52\nWorking on sample 53\nWorking on sample 54\nWorking on sample 55\nWorking on sample 56\nWorking on sample 57\nWorking on sample 58\nWorking on sample 59\nWorking on sample 60\nWorking on sample 61\nWorking on sample 62\nWorking on sample 63\nWorking on sample 64\nWorking on sample 65\nWorking on sample 66\nWorking on sample 67\nWorking on sample 68\nWorking on sample 69\nWorking on sample 70\nWorking on sample 71\nWorking on sample 72\nWorking on sample 73\nWorking on sample 74\nWorking on sample 75\nWorking on sample 76\nWorking on sample 77\nWorking on sample 78\nWorking on sample 79\nWorking on sample 80\nWorking on sample 81\nWorking on sample 82\nWorking on sample 83\nWorking on sample 84\nWorking on sample 85\nWorking on sample 86\nWorking on sample 87\nWorking on sample 88\nWorking on sample 89\nWorking on sample 90\nWorking on sample 91\nWorking on sample 92\nWorking on sample 93\nWorking on sample 94\nWorking on sample 95\nWorking on sample 96\nWorking on sample 97\nWorking on sample 98\nWorking on sample 99\nWorking on sample 100\n","truncated":false}}
%---
%[output:75b48299]
%   data: {"dataType":"text","outputData":{"text":"Working on sample 1\nWorking on sample 2\nWorking on sample 3\nWorking on sample 4\nWorking on sample 5\nWorking on sample 6\nWorking on sample 7\nWorking on sample 8\nWorking on sample 9\nWorking on sample 10\nWorking on sample 11\nWorking on sample 12\nWorking on sample 13\nWorking on sample 14\nWorking on sample 15\nWorking on sample 16\nWorking on sample 17\nWorking on sample 18\nWorking on sample 19\nWorking on sample 20\nWorking on sample 21\nWorking on sample 22\nWorking on sample 23\nWorking on sample 24\nWorking on sample 25\nWorking on sample 26\nWorking on sample 27\nWorking on sample 28\nWorking on sample 29\nWorking on sample 30\nWorking on sample 31\nWorking on sample 32\nWorking on sample 33\nWorking on sample 34\nWorking on sample 35\nWorking on sample 36\nWorking on sample 37\nWorking on sample 38\nWorking on sample 39\nWorking on sample 40\nWorking on sample 41\nWorking on sample 42\nWorking on sample 43\nWorking on sample 44\nWorking on sample 45\nWorking on sample 46\nWorking on sample 47\nWorking on sample 48\nWorking on sample 49\nWorking on sample 50\nWorking on sample 51\nWorking on sample 52\nWorking on sample 53\nWorking on sample 54\nWorking on sample 55\nWorking on sample 56\nWorking on sample 57\nWorking on sample 58\nWorking on sample 59\nWorking on sample 60\nWorking on sample 61\nWorking on sample 62\nWorking on sample 63\nWorking on sample 64\nWorking on sample 65\nWorking on sample 66\nWorking on sample 67\nWorking on sample 68\nWorking on sample 69\nWorking on sample 70\nWorking on sample 71\nWorking on sample 72\nWorking on sample 73\nWorking on sample 74\nWorking on sample 75\nWorking on sample 76\nWorking on sample 77\nWorking on sample 78\nWorking on sample 79\nWorking on sample 80\nWorking on sample 81\nWorking on sample 82\nWorking on sample 83\nWorking on sample 84\nWorking on sample 85\nWorking on sample 86\nWorking on sample 87\nWorking on sample 88\nWorking on sample 89\nWorking on sample 90\nWorking on sample 91\nWorking on sample 92\nWorking on sample 93\nWorking on sample 94\nWorking on sample 95\nWorking on sample 96\nWorking on sample 97\nWorking on sample 98\nWorking on sample 99\nWorking on sample 100\n","truncated":false}}
%---
%[output:7309789b]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 7.779333\n","truncated":false}}
%---
%[output:8cff35f8]
%   data: {"dataType":"text","outputData":{"text":"Mean number in system: 6.824562\n","truncated":false}}
%---
%[output:3f38bdcd]
%   data: {"dataType":"image","outputData":{"dataUri":"data:,","height":400,"width":534}}
%---
%[output:26ea03f6]
%   data: {"dataType":"image","outputData":{"dataUri":"data:,","height":400,"width":534}}
%---
%[output:39e2dd8f]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:393fb58c]
%   data: {"dataType":"text","outputData":{"text":"These are the y axis P values:","truncated":false}}
%---
%[output:8e3d7da3]
%   data: {"dataType":"text","outputData":{"text":"    0.0013    0.0084    0.0269    0.0573    0.0917    0.1173    0.1251    0.1144\n\n","truncated":false}}
%---
%[output:0b24c200]
%   data: {"dataType":"text","outputData":{"text":"    0.0015    0.0098    0.0313    0.0667    0.1067    0.1365    0.1456    0.1332    0.1065\n\n","truncated":false}}
%---
%[output:8740f9d2]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 9.706175\n","truncated":false}}
%---
%[output:0c37f300]
%   data: {"dataType":"text","outputData":{"text":"Mean time in system: 8.456668\n","truncated":false}}
%---
%[output:2e14153c]
%   data: {"dataType":"image","outputData":{"dataUri":"data:,","height":400,"width":534}}
%---
%[output:603da2f2]
%   data: {"dataType":"image","outputData":{"dataUri":"data:,","height":400,"width":534}}
%---
%[output:6e39ce5e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:47f423eb]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:16d8437a]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:90251beb]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:9d407ce6]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:540ea648]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:507c752b]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:31a2dd48]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:5d785a62]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) > 10 percent","truncated":false}}
%---
%[output:3cfad722]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:5bc5a91f]
%   data: {"dataType":"text","outputData":{"text":"When s = 8, P( W_q > 5 minutes) = 0.13541","truncated":false}}
%---
%[output:3931047c]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  2.2882  minutes.","truncated":false}}
%---
%[output:07d0ed1e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:1c1c2914]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  2500","truncated":false}}
%---
%[output:78c522db]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  18463","truncated":false}}
%---
%[output:8c3f1058]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:1534be93]
%   data: {"dataType":"text","outputData":{"text":"W                  10.2882            9.7062             5.6574            \n","truncated":false}}
%---
%[output:6ffca567]
%   data: {"dataType":"text","outputData":{"text":"Wq                 2.2882             1.9761             13.6421           \n","truncated":false}}
%---
%[output:23a09383]
%   data: {"dataType":"text","outputData":{"text":"L                  8.2306             7.7793             5.4826            \n","truncated":false}}
%---
%[output:9713f82d]
%   data: {"dataType":"text","outputData":{"text":"Lq                 1.8306             1.6236             11.3081           \n","truncated":false}}
%---
%[output:627dde3d]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:8e39f1be]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:6606f665]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:30f33817]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 8                         **","truncated":false}}
%---
%[output:0f39eca7]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:9594d438]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:681d7f07]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:3b7ce2e0]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:6575b3b8]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:24385668]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:9ac4c272]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 1.976063\n","truncated":false}}
%---
%[output:6eb7e90a]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 1.623576\n","truncated":false}}
%---
%[output:4efb0270]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 9.706175\n","truncated":false}}
%---
%[output:6ff66c2b]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 7.779333\n","truncated":false}}
%---
%[output:6d817a68]
%   data: {"dataType":"text","outputData":{"text":"Here are the averages of the following values.","truncated":false}}
%---
%[output:6782c6c8]
%   data: {"dataType":"text","outputData":{"text":"Number of Customers in system (L): 6.824562\n","truncated":false}}
%---
%[output:15015bec]
%   data: {"dataType":"text","outputData":{"text":"Total time customer spends in system (W): 8.456668\n","truncated":false}}
%---
%[output:37f65767]
%   data: {"dataType":"text","outputData":{"text":"Number of customers waiting (L_q): 0.585865\n","truncated":false}}
%---
%[output:4270d036]
%   data: {"dataType":"text","outputData":{"text":"Customer Wait time before service (W_q): 0.714074\n","truncated":false}}
%---
%[output:978ccb9e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:8d6c073d]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:77ea5803]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:58308d16]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:7a2c4c81]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:09b2f5f6]
%   data: {"dataType":"text","outputData":{"text":"**            Comparing Theoretical and Simulation Calculations            **","truncated":false}}
%---
%[output:97b5f683]
%   data: {"dataType":"text","outputData":{"text":"**                         number of servers k = 9                         **","truncated":false}}
%---
%[output:9cf4f947]
%   data: {"dataType":"text","outputData":{"text":"**                                                                         **","truncated":false}}
%---
%[output:49e17bf4]
%   data: {"dataType":"text","outputData":{"text":"*****************************************************************************","truncated":false}}
%---
%[output:87c507b2]
%   data: {"dataType":"text","outputData":{"text":"Value Type         Theoretical        Simulation         Error Percent     \n","truncated":false}}
%---
%[output:0a05ed13]
%   data: {"dataType":"text","outputData":{"text":"Lq                 0.6455             0.5859             9.2362            \n","truncated":false}}
%---
%[output:10cc0b66]
%   data: {"dataType":"text","outputData":{"text":"L                  7.0455             6.8246             3.1356            \n","truncated":false}}
%---
%[output:2f9b5bd8]
%   data: {"dataType":"text","outputData":{"text":"Wq                 0.8069             0.7141             11.4989           \n","truncated":false}}
%---
%[output:7aeb7c10]
%   data: {"dataType":"text","outputData":{"text":"W                  8.8069             8.4567             3.9763            \n","truncated":false}}
%---
%[output:99f12283]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:3c2684c4]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times:  18677","truncated":false}}
%---
%[output:08a81aaa]
%   data: {"dataType":"text","outputData":{"text":"These are the total number of customer wait times W_q > 5 minutes:  854","truncated":false}}
%---
%[output:49d4d01d]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:941ae129]
%   data: {"dataType":"text","outputData":{"text":"The theoretical Wq has us waiting  0.80685  minutes.","truncated":false}}
%---
%[output:241a1686]
%   data: {"dataType":"text","outputData":{"text":"When s = 9, P( W_q > 5 minutes) = 0.045725","truncated":false}}
%---
%[output:0ad640f8]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:77c00196]
%   data: {"dataType":"text","outputData":{"text":"P(W_q > 5 minutes) < 10 percent","truncated":false}}
%---
%[output:44356fa3]
%   data: {"dataType":"text","outputData":{"text":"The minimum number of servers recommended to meet the goal is s = 9.","truncated":false}}
%---
%[output:021aacfa]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:490ef293]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:73bb95c2]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:658005a4]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
%[output:526fd79e]
%   data: {"dataType":"text","outputData":{"text":" \n","truncated":false}}
%---
