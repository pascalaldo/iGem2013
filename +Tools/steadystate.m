function steady = steadystate(tmax, M)
%STEADYSTATE Summary of this function goes here
%   Detailed explanation goes here

x0 = M.amounts; %(uM) [mRNA inactiveFNR activeFNR]

if strcmp(M.info.model, 'FNR')
    ode = @FNR.ODE.ode;
else
    ode = @Decoy.ODE.ode;
end

% Integrate ODEs:
tspan = [0 tmax]; %(s)
d(sprintf('Simulated time: %d seconds', tspan(2)));
[t,x] = ode45(@(t,x)ode(t,x,M),tspan,x0); %Runge-Kutta

steady = x(end,:);

end

