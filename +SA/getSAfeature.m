function feature = getSAfeature(parTemp,M,outID,valuesID,amountsID)
% get features for sensitivity analysis
% the feature is the steady state value of outputOfInterest (specified in
% the function MPSA)

n = 0;                                  % ID counter

M.values(valuesID)      = parTemp(valuesID + n);
n                       = n + length(valuesID);

M.amounts(amountsID)    = parTemp(amountsID + n);

x = Tools.steadystate(300, M);

feature = x(outID);

end