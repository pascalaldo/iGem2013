% run_PBPK.m

close all
clear M P t x k y
bodyWeight = 75;   % kg
%%
% the result of one time injection
% dose = 6;
doseM = 23.21;        % mg
P = PBPK.initialize();
bodyVolume = bodyWeight / 0.9; % L
venVolume = bodyVolume * P.venous.V;
dose = doseM / venVolume;

M = PBPK.getOdeMat(P);
x0 = zeros(1,P.info.compartmentCnt+2);
% first injection, day 1
x0(end) = dose;
[t,x] = ode45(@(t,x)PBPK.ode(t,x,M),[0 24],x0);
plot(t,x)
title('Drug Distribution in Different Compartments')
xlabel('time(h)')
ylabel('concentration(mg/L)')
leg = {};
for i=1:P.info.compartmentCnt
    leg = {leg{:}, P.distribution(i).name};
end
leg = {leg{:}, 'arterial','venous'};
legend(leg)

%% the result of 3 days injection + time-kill
% drug part
% dose = 9;
doseM = 23.21;     % mg
P = PBPK.initialize();
bodyVolume = bodyWeight / 0.9; % L
venVolume = bodyVolume * P.venous.V;
dose = doseM / venVolume;

M = PBPK.getOdeMat(P);
x0 = zeros(1,P.info.compartmentCnt+2);
% first injection, day 1
x0(end) = dose;
[t1,x1] = ode45(@(t,x)PBPK.ode(t,x,M),[0 24],x0);
figure
plot(t1,x1(:,8))
hold on;
% second injection, day 2
x0 = x1(end,:);
x0(end) = x0(end) + dose;
[t2,x2] = ode45(@(t,x)PBPK.ode(t,x,M),[24 48],x0);
plot(t2,x2(:,8))
% third injection, day 3
x0 = x2(end,:);
x0(end) = x0(end) + dose;
[t3,x3] = ode45(@(t,x)PBPK.ode(t,x,M),[48 72],x0);
plot(t3,x3(:,8))
title('Drug Distribution in Tumor')
% xlabel('time(h)')
ylabel('concentration(mg/L)')
hold off

% figure;
% hold on
% plot(t1,x1)
% plot(t2,x2)
% plot(t3,x3)
% hold off
% leg = {};
% for i=1:P.info.compartmentCnt
%     leg = {leg{:}, P.distribution(i).name};
% end
% leg = {leg{:}, 'arterial','venous'};
% legend(leg)

t = [t1(1:end-1);t2(1:end-1);t3];
xtumor = [x1(1:end-1,8);x2(1:end-1,8);x3(:,8)];

N = PBPK.regoesSim(t,xtumor,10^6);

% bacteria part
% k = [0.1939   -0.0555  116.6546];
% y = k(3) * tanh(k(1) * t + k(2));
% figure;
% plot(t,y);