% Master.run
% This part combines the stochastic model (Decoy) and the ODE model (FNR).

close all
clear xstep x tt tstepODE tstepDecoy tODE t oxygen i amountPlus M;

tt = 10;                       % Assign total simulation time
x = [0.16 4.63 0.08];          % (uM) [mRNA inactiveFNR activeFNR]
oxygen = @(t)(00);

M = Decoy.initialize('data/msb20127-s2.xml');

% Initialization
i = 1;
t(i) = 0;
tODE = 0;

while t(i) < tt
    % Update FNR amount from ODE model
    M.amounts(2,i) = Master.mol2nr(M,x(end,3));
    M.amounts(1,i) = M.amounts(2,i)+ M.amounts(7,i) + M.amounts(4,i);
    
    % run the stochastic simulation
    [tstepDecoy,amountPlus] = Decoy.stepSim(M);
    M.amounts = [M.amounts amountPlus];

    % update the stochastic/master time vector
    i = i + 1;
    t(i) = t(i-1) + tstepDecoy;
    
    % run the ODE simulation
    if i==2                                 % For the first loop
        [tstepODE,xstep] = ode45(@(t,x)FNR.ode(t,x,oxygen(t)),t,x);
        tODE = [tODE; tstepODE];            % Update ODE time vector
        x = [x; xstep];                          % Update ODE species vector
    else
        [tstepODE,xstep] = ode45(@(t,x)FNR.ode(t,x,oxygen(t)),t([i-1,i]),x(end,:));
        tODE = [tODE; tstepODE];            % Update ODE time vector
        x = [x; xstep];                          % Update ODE species vector
    end
end

% Plot the stochastic result and ODE result in one figure
plotyy(tODE,x,t,M.amounts)

% Plot the promoter binding ratio
figure
stairs(t,M.amounts(7,:)./M.amounts(8,:));