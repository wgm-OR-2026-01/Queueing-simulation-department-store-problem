%[text] # Run samples of the ServiceQueue simulation Savannah Jellings
%[text] Collect statistics and plot histograms along the way.
%%
%[text] ## Set up
%[text] We'll measure time in minutes
%[text] Arrival rate: 0.8 customers per minute
lambda = 0.8; % compute 1/1.25
%[text] Departure (service) rate: customers served per minute
mu = 1/8;
%[text] Number of serving stations
for s = 1:10
    fprintf("\n===== Testing s = %d =====\n", s);
%[text] Run 100 samples of the queue.
NumSamples = 100;
%[text] Each sample is run up to a maximum time.
MaxTime = 240; % 4 hours = 240 minutes
%[text] Make a log entry every so often
LogInterval = 5; % 5 minute intervals
%%
%[text] ## Numbers from theory for M/M/s queue
%[text] Compute $P\_n$ = probability of finding the system in state $n$ in the long term.
    rho = lambda / (s * mu);

    % Compute P0 (probability of 0 customers in system)
    sum1 = sum((lambda/mu).^(0:s-1) ./ factorial(0:s-1));
    sum2 = (lambda/mu)^s / (factorial(s) * (1 - rho));
    P0 = 1 / (sum1 + sum2);

    % Compute P_n
    nMax = 20;
    P = zeros(1, nMax+1);
    for n = 0:nMax
        if n < s
            P(n+1) = (lambda/mu)^n / factorial(n) * P0;
        else
            P(n+1) = (lambda/mu)^n / (factorial(s) * s^(n-s)) * P0;
        end
    end
%%
%[text] ## Run simulation samples
%[text] This is the most time consuming calculation in the script, so let's put it in its own section.  That way, we can run it once, and more easily run the faster calculations multiple times as we add features to this script.
%[text] Reset the random number generator.  This causes MATLAB to use the same sequence of pseudo-random numbers each time you run the script, which means the results come out exactly the same.  This is a good idea for testing purposes.  Under other circumstances, you probably want the random numbers to be truly unpredictable and you wouldn't do this.
    rng("default");
%[text] We'll store our queue simulation objects in this list.
    QSamples = cell([NumSamples, 1]);
%[text] The statistics come out weird if the log interval is too short, because the log entries are not independent enough.  So the log interval should be long enough for several arrival and departure events happen.
% Run simulation samples
    for SampleNum = 1:NumSamples
        fprintf("Working on sample %d\n", SampleNum);
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

% Compute simulation L_q
    NumWaitingSamples = cell([NumSamples, 1]);
    for SampleNum = 1:NumSamples
        q = QSamples{SampleNum};
        NumWaitingSamples{SampleNum} = q.Log.NumWaiting;
    end
%[text] ## Join numbers from all sample runs.
%[text] `vertcat` is short for "vertical concatenate", meaning it joins a bunch of arrays vertically, which in this case results in one tall column.
    NumInSystem = vertcat(NumInSystemSamples{:});

    NumWaiting = vertcat(NumWaitingSamples{:});
%[text] 
%[text] MATLAB-ism: When you pull multiple items from a cell array, the result is a "comma-separated list" rather than some kind of array.  Thus, the above means
%[text] `NumInSystem = vertcat(NumInSystemSamples{1}, NumInSystemSamples{2}, ...)`
%[text] which concatenates all the columns of numbers in NumInSystemSamples into one long column.
%[text] This is roughly equivalent to "splatting" in Python, which looks like `f(*args)`.
%%
%[text] ## Pictures and stats for number of customers in system
%[text] Print out mean number of customers in the system.
    meanNumInSystem = mean(NumInSystem);
    fprintf("Mean number in system: %f\n", meanNumInSystem);

    meanNumWaiting = mean(NumWaiting);
    fprintf("Mean number waiting: %f\n", meanNumWaiting);
%[text] Make a figure with one set of axes.
    fig = figure();
    t = tiledlayout(fig,1,1);
    ax = nexttile(t);
%[text] MATLAB-ism: Once you've created a picture, you can use `hold` to cause further plotting functions to work with the same picture rather than create a new one.
    hold(ax, "on");
%[text] Start with a histogram.  The result is an empirical PDF, that is, the area of the bar at horizontal index n is proportional to the fraction of samples for which there were n customers in the system.  The data for this histogram is counts of customers, which must all be whole numbers.  The option `BinMethod="integers"` means to use bins $(-0.5, 0.5), (0.5, 1.5), \\dots$ so that the height of the first bar is proportional to the count of 0s in the data, the height of the second bar is proportional to the count of 1s, etc. MATLAB can choose bins automatically, but since we know the data consists of whole numbers, it makes sense to specify this option so we get consistent results.
    h = histogram(ax, NumInSystem, Normalization="probability", BinMethod="integers");
%[text] Plot $(0, P\_0), (1, P\_1), \\dots$.  If all goes well, these dots should land close to the tops of the bars of the histogram.
    plot(ax, 0:nMax, P, 'o', MarkerEdgeColor='k', MarkerFaceColor='r');
%[text] Add titles and labels and such.
    title(ax, "Number of customers in the system");
    xlabel(ax, "Count");
    ylabel(ax, "Probability");
    legend(ax, "simulation", "theory");
%[text] Set ranges on the axes. MATLAB's plotting functions do this automatically, but when you need to compare two sets of data, it's a good idea to use the same ranges on the two pictures.  To start, you can let MATLAB choose the ranges automatically, and just know that it might choose very different ranges for different sets of data.  Once you're certain the picture content is correct, choose an x range and a y range that gives good results for all sets of data.  The final choice of ranges is a matter of some trial and error.  You generally have to do these commands *after* calling `plot` and `histogram`.
%[text] This sets the vertical axis to go from $0$ to $0.3$.
    ylim(ax, [0, 0.3]);
%[text] This sets the horizontal axis to go from $-1$ to $21$.  The histogram will use bins $(-0.5, 0.5), (0.5, 1.5), \\dots$ so this leaves some visual breathing room on the left.
    xlim(ax, [-1, 21]);
%[text] MATLAB-ism: You have to wait a couple of seconds for those settings to take effect or `exportgraphics` will screw up the margins.
    pause(2);
%[text] Save the picture as a PDF file.
    exportgraphics(fig, "Number in system histogram.pdf");
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

% Compute simulation W_q
    TimeWaitingSamples = cell([NumSamples, 1]);
    for SampleNum = 1:NumSamples
        q = QSamples{SampleNum};
        TimeWaitingSamples{SampleNum} = cellfun(@(c) c.BeginServiceTime - c.ArrivalTime, q.Served');
    end
%[text] ### Join them all into one big column.
    TimeInSystem = vertcat(TimeInSystemSamples{:});

    TimeWaiting = vertcat(TimeWaitingSamples{:});
%%
%[text] ## Pictures and stats for time customers spend in the system
%[text] Print out mean time spent in the system.
    meanTimeInSystem = mean(TimeInSystem);
    fprintf("Mean time in system: %f\n", meanTimeInSystem);

% mean waiting part

    meanTimeWaiting = mean(TimeWaiting);
    fprintf("Mean time waiting: %f\n", meanTimeWaiting);

% Customers waiting over 5 min
    percentOver5 = sum(TimeWaiting > 5) / length(TimeWaiting);

    fprintf("s = %d → Wq > 5 = %.3f\n", s, percentOver5);

% No more than 10% of customers wait over 5 min
    if percentOver5 <= 0.10
        fprintf("Minimum number of registers needed: %d\n", s);
        break;
    end
%[text] Make a figure with one set of axes.
    fig = figure();
    t = tiledlayout(fig,1,1);
    ax = nexttile(t);
%[text] This time, the data is a list of real numbers, not integers.  The option `BinWidth=...` means to use bins of a particular width, and choose the left-most and right-most edges automatically.  Instead, you could specify the left-most and right-most edges explicitly.  For instance, using `BinEdges=0:0.5:60` means to use bins $(0, 0.5), (0.5, 1.0), \\dots$
    h = histogram(ax, TimeInSystem, Normalization="probability", BinWidth=5/60);
%[text] Add titles and labels and such.
    title(ax, "Time in the system");
    xlabel(ax, "Time");
    ylabel(ax, "Probability");
%[text] Set ranges on the axes.
    ylim(ax, [0, 0.2]);
    xlim(ax, [0, 2]);
%[text] Wait for MATLAB to catch up.
    pause(2);
%[text] Save the picture as a PDF file.
    exportgraphics(fig, "Time in system histogram.pdf");
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":35.8}
%---
