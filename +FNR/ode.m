function f = ode(t,x)
% f = ode(t,x) includes the differential equations used in the model
% See details of the model in README.txt

% state variables
a = x(1);       % O2
b = x(2);       % FNR
c = x(3);       % O2-FNR
d = x(4);       % product

% parameters [uM]
kplus = 80000;
kminus = 408;
k2 = 0.0682;

% ODEs
f(1) = kminus*c - kplus*a*b;
f(2) = kminus*c - kplus*a*b;
f(3) = kplus*a*b - kminus*c - k2*c;
f(4) = k2*c;

f = f(:);
end

