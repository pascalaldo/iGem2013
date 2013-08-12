clear all
close all

D = Decoy.ODE.initialize();
F = FNR.ODE.initialize();

tspan = [0,10];
x0 = D.amounts;
x0(1) = F.amounts(3);
x0(9) = F.amounts(1);
x0(10) = F.amounts(2);

% full ode
[t,x] = ode45(@(t,x)Merged.ODE.ode(t,x,D,F),tspan,x0);
plot(t,x)

% FNR ode
[s,y] = ode45(@(t,x)FNR.ODE.ode(t,x,F),tspan,F.amounts);
figure
plot(s,y)