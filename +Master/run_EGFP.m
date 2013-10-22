% run_EGFP

RATE = 5; % the expression rate of EGFP at maximum promoter occupancy
DEGRA = 1/26/24;  % in min-1

M = Merged.ODE.initialize();
ode = @Merged.ODE.ode;

x0 = M.amounts;
% M.values(M.parameters.oxygen)

% Integrate ODEs:
tspan = [0 500]; %(min)
d(sprintf('Simulated time: %d minutes', tspan(2)));
[t,x] = ode45(@(t,x)ode(t,x,M),tspan,x0); %Runge-Kutta
rrate = Tools.expressionrate(M,x);
tstep = t(:) - [0;t(1:end-1)];

rprod = tstep .* rrate;  % raw production
nprod = rprod - tstep*DEGRA;  % net production
prod = cumsum(nprod);

