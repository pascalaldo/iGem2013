% fit the partition coefficient of kidney and lung
% the result of data fit is already written in comaprtmentData.txt
% the initial value in this file is calculated from paper

%% fit partition coefficient of kidney and lung
clear all

k = [2.0100    1.2180];
P = PBPK.initialize();
opt = optimset('display','iter');
x = lsqnonlin(@(k)PBPK.auclsq(k,P),k,[],[],opt);

%% fit elimination rate of kidney
clear all

k = 0.049;
P = PBPK.initialize();
M = PBPK.getOdeMat(P);
opt = optimset('display','iter');
x = lsqnonlin(@(k)PBPK.elsq(k,P,M),k,[],[],opt);