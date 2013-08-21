% run_PBPK.m

close all
clear M P t x

P = PBPK.initialize();
M = PBPK.getOdeMat(P);
[t,x] = ode45(@(t,x)PBPK.ode(t,x,M),[0 100],[0 0 0 0 0 0 10]);
plot(t,x)