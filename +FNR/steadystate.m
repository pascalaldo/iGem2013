function steady = steadystate(O2, tmax)
%STEADYSTATE Summary of this function goes here
%   Detailed explanation goes here

x0 = [0.16 4.63 0.08]; %(uM) [mRNA inactiveFNR activeFNR]

oxygen = @(t)(O2);

% Integrate ODEs:
tspan = [0 tmax]; %(s)
d(sprintf('Simulated time: %d min', tspan(2)));
[t,x] = ode45(@(t,x)FNR.ode(t,x,oxygen(t)),tspan,x0); %Runge-Kutta

steady = x(end,:);

end

