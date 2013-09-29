function feature = getSAfeature(parTemp,M,outID,valuesID,amountsID)
% get features for sensitivity analysis
% the feature is the steady state value of outputOfInterest (specified in
% the function MPSA)

n = 0;                                  % ID counter

M.values(valuesID)      = parTemp(valuesID + n);
n                       = n + length(valuesID);

M.amounts(amountsID)    = parTemp(amountsID + n);

% x = Tools.steadystate(300, M);
% 
% feature = x(outID);

if strcmp(M.info.model, 'FNR')
    ode = @FNR.ODE.ode;
elseif strcmp(M.info.model, 'Decoy')
    ode = @Decoy.ODE.ode;
else
    ode = @Merged.ODE.ode;
end
x0 = M.amounts;
tspan = [0 500];
[t,x] = ode45(@(t,x)ode(t,x,M),tspan,x0); %Runge-Kutta
expRate = Tools.expressionrate(M,x);
feature = expRate(end);

end