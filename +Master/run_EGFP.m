% run_EGFP
close all

RATE = 5; % the expression rate of EGFP at maximum promoter occupancy
HALFLIFE = 26*24;  % in min
k = log(0.5)/HALFLIFE;

M = Merged.ODE.initialize();
ode = @Merged.ODE.ode;

x0 = M.amounts;
% M.values(M.parameters.oxygen)

% Integrate ODEs:
tspan = [0 500]; %(min)
d(sprintf('Simulated time: %d minutes', tspan(2)));
[t,x] = ode45(@(t,x)ode(t,x,M),tspan,x0); %Runge-Kutta
rrate = Tools.expressionrate(M,x);
% tstep = t(:) - [0;t(1:end-1)];

prdt = zeros(length(t),1);
for i = 2:length(t)
    prdt(i) = -prdt(i-1)*k + (t(i)-t(i-1)) * rrate(i);
end

plot(t,prdt);