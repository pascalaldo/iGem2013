% Master.run
% This part combines the stochastic model (Decoy) and the ODE model (FNR).

tt = 100;       % Assign total simulation time

M = Decoy.initialize('data/msb20127-s3.xml');