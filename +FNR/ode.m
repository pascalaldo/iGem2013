function f = ode(t,x,oxygen,data)
% f = ode(t,x) includes the differential equations used in the model
% See details of the model in README.txt

env = (oxygen<10)+1;

%% State Variables
x1 = x(1); % FNR mRNA
x2 = x(2); % Inactive FNR
x3 = x(3); % Active FNR

%% Parameters [uM]
% par(1) = off state (aerobic)
% par(2) = on state (anaerobic)

a1      = data.values(data.toID('a1'));
a1max   = data.values(data.toID('a1max'));
a21     = data.values(data.toID('a21'));
a22     = data.values(data.toID('a22'));
b22     = data.values(data.toID('b22'));
b1(1)   = data.values(data.toID('b1a'));
b1(2)   = data.values(data.toID('b1n'));
b21(1)  = data.values(data.toID('b21a'));
b21(2)  = data.values(data.toID('b21n'));
b31(1)  = data.values(data.toID('b31a'));
b31(2)  = data.values(data.toID('b31n'));
g13     = data.values(data.toID('g13'));
x4      = data.values(data.toID('x4'));
x5      = data.values(data.toID('x5'));
x6      = oxygen;
x3c     = data.values(data.toID('x3c'));

%% ODEs
if x3 < x3c
    f(1) = a1max - b1(env)*x1;
else
    f(1) = a1*(x3^g13) - b1(env)*x1;
end
f(2) = a21*x1 + 2*a22*x3*x6 - b21(env)*x2*x4 - 2*b22*(x2^2)*x5;
f(3) = b22*(x2^2)*x5 - a22*x3*x6 - b31(env)*x3;

f = f(:);

end

