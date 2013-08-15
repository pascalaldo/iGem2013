function f = ode(t,x,M)
% F = MERGED.ODE.ODE(T,X,D,F) combines the ODEs of decoy model and FNR model.
% D can be generated using Decoy.ODE.initialize()
% F can be generated using FNR.ODE.intialize()
% The output of this ode is:
% 1 - T0, or active FNR
% 2 - T, free and active FNR
% 3 - N, unbound decoy sites
% 4 - TN, bound decoy sites
% 5 - N0, total decoy sites
% 6 - P, unbound promoter sites
% 7 - TP, bound ptomoter sites
% 8 - P0, total promoter sites
% 9 - FNR mRNA
% 10- inactive FNR

% decoy model
f1 = Decoy.ODE.ode(t,x,M);
f2 = FNR.ODE.ode(t,x,M);

f = f1+f2;

% FNR model
b31(1)  = M.values(M.parameters.b31a);
b31(2)  = M.values(M.parameters.b31n);
env = (M.values(M.parameters.oxygen)<10)+1;

f(M.species.N) = f(M.species.N) + b31(env)*x(M.species.TN);
f(M.species.P) = f(M.species.P) + b31(env)*x(M.species.TP);

f(M.species.TN) = f(M.species.TN) - b31(env)*x(M.species.TN);
f(M.species.TP) = f(M.species.TP) - b31(env)*x(M.species.TP);

f(M.species.T0) = f(M.species.T)+f(M.species.TN)+f(M.species.TP); % T0, total T
f(M.species.N0) = f(M.species.N)+f(M.species.TN); % T0, total T
f(M.species.P0) = f(M.species.P)+f(M.species.TP); % T0, total T

f = f(:);

end

