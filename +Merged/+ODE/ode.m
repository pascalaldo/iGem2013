function f = ode(t,x,data)
% f = ode(t,x) includes the differential equations used in the model
% See details of the model in README.txt

a = FNR.ODE.ode(t,x,data);

b = Decoy.ODE.ode(t,x,data);

f(1) = a(1);
f(2) = a(2);

d1 = x(1)/(sum(x(1:4)));

f(3) = b(1) - d1*a(3);
f(4)

f = f(:);

end

