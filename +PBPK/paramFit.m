% fit the partition coefficient of kidney and lung
% the result of data fit is already written in comaprtmentData.txt
% the initial value in this file is calculated from paper

%% fit partition coefficients and elimination rate at the same time
% result:     2.0933    0.8749    0.7784

clear all
k = [0.1150 2.0100 0.7087 1.1676 1.2180 0.196];
P = PBPK.initialize();
opt = optimset('display','iter');
x = lsqnonlin(@(k)PBPK.glblsq(k,P),k,[],[],opt);

%% fit the bacteria growth in tumor
% result: 0.1939   -0.0555  116.6546
% 0.1939 is the bacteria growth rate
% -0.0555 is the offset in time
% 116.6546 is proportional to the amount of bacteria injected (1*10^8)

clear all
k = [1 0 0.01];
opt = optimset('display','iter');
x = lsqcurvefit(@PBPK.bglsq,k,[1.0 24 48 96 168],[8.0 171 41 673 637],[],[],opt);

%% test the result
pos = find(t>5);
b = zeros(1,9);
for i = 1:9
    result = fit(t(pos),x(pos,i),'exp1');
    b(i) = result.b;
end