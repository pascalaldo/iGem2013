% initialize.m genedatas the data in the workspace.
% oxygen is not included in the struct
% concentrations in [uM]
% datas in [uM/min]

clear i;
data.toID = containers.Map('KeyType','char','ValueType','uint32');
i = 1;

data.toID('mRNA') = i;
data.values(i) = 0.16;

i = i+1;
data.toID('inactiveFNR') = i;
data.values(i) = 4.63;

i = i+1;
data.toID('activeFNR') = i;
data.values(i) = 0.08;

i = i+1;
data.toID('a1') = i;
data.values(i) = 0.0871;

i = i+1;
data.toID('a1max') = i;
data.values(i) = 0.135

i = i+1;
data.toID('a21') = i;
data.values(i) = 0.484

i = i+1;
data.toID('a22') = i;
data.values(i) = 4.09;

i = i+1;
data.toID('b22') = i;
data.values(i) = 2.6;

i = i+1;
data.toID('b1a') = i;
data.values(i) = 0.838;

i = i+1;
data.toID('b1n') = i;
data.values(i) = 0.613;

i = i+1;
data.toID('b21a') = i;
data.values(i) = 0.0821;

i = i+1;
data.toID('b21n') = i;
data.values(i) = 0.0634;

i = i+1;
data.toID('b31a') = i;
data.values(i) = 0.0231;

i = i+1;
data.toID('b31n') = i;
data.values(i) = 0.0148;

i = i+1;
data.toID('g13') = i;
data.values(i) = -0.464;

i = i+1;
data.toID('x4') = i;
data.values(i) = 0.196

i = i+1;
data.toID('x5') = i;
data.values(i) = 0.455;

i = i+1;
data.toID('x3c') = i;
data.values(i) = 0.389;

clear i