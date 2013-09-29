% fit the partition coefficient of kidney and lung
% the result of data fit is already written in comaprtmentData.txt
% the initial value in this file is calculated from paper

%% fit partition coefficients and elimination rate at the same time
% result:     0.1150    2.1054    0.7091    1.1682    1.2529    1.2748

clear all
k = [0.1150 2.0100 0.7087 1.6475 1.2180 0.196];
P = PBPK.initialize();
opt = optimset('display','iter');
x = lsqnonlin(@(k)PBPK.glblsq(k,P),k,[],[],opt);

%% fit the bacteria growth in tumor
% result: 0.0207  150.0625    0.9988
% 0.0207 is the bacteria growth rate
% 0.9988 is the offset in time
% 150.0625 is proportional to the amount of bacteria injected (1*10^8)
close all
clear all
k = [0.001 150 1];
opt = optimset('display','iter');
x = lsqcurvefit(@PBPK.bglsq,k,[1.0 24 48 96 168],[8.0 171 41 673 637],[],[],opt);
t = [0:0.1:168];
yfit = x(3) * exp(x(1) * (t + x(2)));
plot(t,yfit)
hold on
plot([1.0 24 48 96 168],[8.0 171 41 673 637],'*')
hold off

%% test the result
pos = find(t>5);
b = zeros(1,9);
for i = 1:9
    result = fit(t(pos),x(pos,i),'exp1');
    b(i) = result.b;
end