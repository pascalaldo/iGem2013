% compareRun.m shows the results using extracted ODE and using SimBiology
% toolbox. If the ODEs are right then the results should be the same.

clear all
close all

%% Run with the extracted ODEs
M = Decoy.ODE.initialize();
tspan = [0 0.16];
x0 = M.amounts;
[t,x] = ode45(@(t,x)Decoy.ODE.ode(t,x,M),tspan,x0);
plot(t,x)
title('extracted ODE')

%% Run with the SimBiology toolbox
sbioM = sbmlimport('data/msb20127-s2.xml');
[T,X,NAMES] = sbiosimulate(sbioM);
figure;
plot(T,X)
title('SimBiology toolbox')