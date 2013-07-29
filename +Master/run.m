% Master.run
% This part combines the stochastic model (Decoy) and the ODE model (FNR).

tt = 100;                       % Assign total simulation time
x0 = [0.16 4.63 0.08];          % (uM) [mRNA inactiveFNR activeFNR]

M = Master.initialize('data/msb20127-s2.xml',x0(3));

% Initialization
i = 1;
t(i) = 0;

while t(i) < tt
    % run the stochastic simulation
    [tstep,amountPlus] = stepSim(M);
    M.amount = [M.amount amountPlus];
    
    % update the time vector
    i = i + 1;
    t(i) = t(i-1) + tstep;
    
    % run the ODE simulation
    
end
