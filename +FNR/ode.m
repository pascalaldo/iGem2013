function f = ode(t,x,oxygen)
% f = ode(t,x) includes the differential equations used in the model
% See details of the model in README.txt

% Set environment to anaerobic
env = (oxygen<10)+1;

%% State Variables
x1 = x(1); % FNR mRNA
x2 = x(2); % Inactive FNR
x3 = x(3); % Active FNR

%% Parameters [uM]
% par(1) = off state (aerobic)
% par(2) = on state (anaerobic)

a1      = 0.0871;
a1max   = 0.135;
a21     = 0.484;
a22     = 4.09;
b22     = 2.6;
b1(1)   = 0.838;
b1(2)   = 0.613;
b21(1)  = 0.0821;
b21(2)  = 0.0634;
b31(1)  = 0.0231;
b31(2)  = 0.0148;
g13     = -0.464;
x4      = 0.196;
x5      = 0.455;
x6      = oxygen;
x3c     = 0.389;

%% ODEs
if x(3) < x3c
    f(1) = a1max - b1(env)*x(1);
else
    f(1) = a1*(x3^g13) - b1(env)*x(1);
end
f(2) = a21*x1 + 2*a22*x3*x6 - b21(env)*x2*x4 - 2*b22*(x2^2)*x5;
f(3) = b22*(x2^2)*x5 - a22*x3*x6 - b31(env)*x3;

f = f(:);

end

