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
a = Decoy.ODE.ode(t,x(1:8),M.Decoy);

% FNR model
b = FNR.ODE.ode(t,x([9 10 2]),M.FNR);
b31(1)  = M.FNR.values(13);
b31(2)  = M.FNR.values(14);
env = (M.oxygen<10)+1;

f(1) = b(3) - b31(env)*x(1);                % T0, total T
f(3) = a(3) + b31(env)*x(4);                % N, unbound decoy sites
f(5) = a(5);                % N0, total decoy sites
f(6) = a(6) + b31(env)*x(7);                % P, unbound promoter sites
f(8) = a(8);                % P0, total promoter sites
f(9) = b(1);                % FNR mRNA
f(10) = b(2);               % inactive FNR


f(2) = b(3) + a(2);            % T, free and active FNR
f(4) = a(4) - b31(env)*x(4);            % TN, bound decoy sites
f(7) = a(7) - b31(env)*x(7);            % TP, bound promoter sites

f = f(:);

end

