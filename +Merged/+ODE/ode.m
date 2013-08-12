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
b = FNR.ODE.ode(t,x([9 10 1]),M.FNR);

% Calculate the change ratio of total active FNR
f(1) = b(3);
d = (f(1) + x(1)) / x(1);
% Update the free and bound FNR
x(2) = x(2) * d;
if x(4) < x(5)
    x(4) = x(4) * d;
    if x(4) > x(5)
        x(4) = x(5);
    end
else
    x(4) = x(5)
end;
if x(7) < x(8)
    x(7) = x(7) * d;
    if x(7) > x(8)
        x(7) = x(8);
    end
else
    x(7) = x(8);
end;


f(3) = a(3);                % N, unbound decoy sites
f(5) = a(5);                % N0, total decoy sites
f(6) = a(6);                % P, unbound promoter sites
f(8) = a(8);                % P0, total promoter sites
f(9) = b(1);                % FNR mRNA
f(10) = b(2);               % inactive FNR


f(2) = a(2);            % T, free and active FNR
f(4) = a(4);            % TN, bound decoy sites
f(7) = a(7);            % TP, bound promoter sites

f = f(:);

end

