function err = doseResponse()
% ERR = MASTER.DOSERESPONSE() calculates and plots the dose response of O2
% or FNR on promoter occupancy.
% Detailed info to be continued

M = FNR.ODE.initialize();
tspan = [0 10];

[t,x] = ode45(@(t,x)Decoy.ODE.ode(t,x,M),tspan,x0);

end