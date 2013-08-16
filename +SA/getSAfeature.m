function feature = getSAfeature(parTemp,M,dummyNr,valuesID,amountsID)
%

n = 0;                                  % ID counter

M.values(valuesID)      = parTemp(valuesID + n);
n                       = n + length(valuesID);

M.amounts(amountsID)    = parTemp(amountsID + n);

x = Tools.steadystate(300, M);

feature = x(9)/x(10);

end