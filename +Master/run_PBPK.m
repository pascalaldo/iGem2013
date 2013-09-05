% run_PBPK.m

close all
clear M P t x k y

% drug part
P = PBPK.initialize();
M = PBPK.getOdeMat(P);
x0 = zeros(1,P.info.compartmentCnt+2);
x0(end) = 750;
[t,x] = ode45(@(t,x)PBPK.ode(t,x,M),[0 50],x0);
plot(t,x)

% bacteria part
k = [0.1939   -0.0555  116.6546];
y = k(3) * tanh(k(1) * t + k(2));
figure;
plot(t,y);