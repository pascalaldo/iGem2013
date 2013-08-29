% fit the partition coefficient of kidney and lung

clear all

k = [2.0100    1.2180];
P = PBPK.initialize();
opt = optimset('display','iter');
x = lsqnonlin(@(k)PBPK.auclsq(k,P),k,[],[],opt);