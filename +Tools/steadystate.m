function steady = steadystate(tmax, M)
%STEADYSTATE Summary of this function goes here
%   Detailed explanation goes here

x0 = M.amounts; % [uM]

if strcmp(M.info.model, 'FNR')
    ode = @FNR.ODE.ode;
elseif strcmp(M.info.model, 'Decoy')
    ode = @Decoy.ODE.ode;
else
    ode = @Merged.ODE.ode;
end

% Integrate ODEs:
tspan = [0 tmax]; %(s)
%d(sprintf('Simulated time: %d seconds', tspan(2)));
[t,x] = ode45(@(t,x)ode(t,x,M),tspan,x0); %Runge-Kutta

%figure(5); plot(t,x);

steady = x(end,:);

end

