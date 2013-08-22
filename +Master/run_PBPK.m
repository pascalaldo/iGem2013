% run_PBPK.m

close all
clear M P t x

P = PBPK.initialize();
M = PBPK.getOdeMat(P);
[t,x] = ode45(@(t,x)PBPK.ode(t,x,M),[0 1],[0 0 0 0 0 0 0 0 750 0]);
plot(t,x)