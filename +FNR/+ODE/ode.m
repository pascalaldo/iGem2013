function f = ode(t,x,data)
% f = ode(t,x) includes the differential equations used in the model
% See details of the model in README.txt

env = (data.oxygen<10)+1;

%% State Variables
x1 = x(1); % FNR mRNA
x2 = x(2); % Inactive FNR
x3 = x(3); % Active FNR

%% Parameters [uM]
% par(1) = off state (aerobic)
% par(2) = on state (anaerobic)
% 
a1      = data.values(4);
a1max   = data.values(5);
a21     = data.values(6);
a22     = data.values(7);
b22     = data.values(8);
b1(1)   = data.values(9);
b1(2)   = data.values(10);
b21(1)  = data.values(11);
b21(2)  = data.values(12);
b31(1)  = data.values(13);
b31(2)  = data.values(14);
g13     = data.values(15);
x4      = data.values(16);
x5      = data.values(17);
x6      = data.oxygen;
x3c     = data.values(18);

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

