function f = ode(t,x)
% f = ode(t,x) includes the differential equations used in the model
% See details of the model in README.txt

% state variables
a = x(1);       % FNR
b = x(2);       % O2-FNR
c = x(3);       % O2

% Parameters [uM]
a = 0.0682;
b = 408;
kobs = a*c/(b+c);

% ODEs
f(1) = -kobs*x(1);
f(2) = kobs*x(1);
f(3) = 0;

f = f(:);

end

