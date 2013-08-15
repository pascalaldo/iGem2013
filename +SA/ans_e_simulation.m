function feature = ans_e_simulation(parIndex,parTemp,outIndex)
% calculates the feature for MPSA
% in this function, the feature is the area under the curve.
% the output of interest is specified by outIndex,
% e.g. if outIndex = 26, it means STAT3N*-STAT3N*
% the inputs of analysis are specified by parIndex
% the value of scaled inputs are given by parTemp
load BIOMD0000000151

tspan = [1 86400];
pTemp = p;                      % the local matrix for parameters
pTemp(parIndex) = parTemp;


[t, x] = ode15s(@BIOMD0000000151, tspan, x0, [], pTemp, u0, modelStruct);
feature = polyarea(t,x(:,outIndex));
