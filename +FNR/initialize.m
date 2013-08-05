% initialize.m geneFNRdatas the FNRdata in the workspace.
% oxygen is not included in the struct
% concentrations in [uM]
% FNRdatas in [uM/min]
% a - aerobic
% n - anaerobic

clear i;
FNRdata.toID = containers.Map('KeyType','char','ValueType','uint32');
i = 1;

FNRdata.toID('mRNA') = i;
FNRdata.values(i) = 0.16;

i = i+1;
FNRdata.toID('inactiveFNR') = i;
FNRdata.values(i) = 4.63;

i = i+1;
FNRdata.toID('activeFNR') = i;
FNRdata.values(i) = 0.08;

i = i+1;
FNRdata.toID('a1') = i;
FNRdata.values(i) = 0.0871;

i = i+1;
FNRdata.toID('a1max') = i;
FNRdata.values(i) = 0.135;

i = i+1;
FNRdata.toID('a21') = i;
FNRdata.values(i) = 0.484;

i = i+1;
FNRdata.toID('a22') = i;
FNRdata.values(i) = 4.09;

i = i+1;
FNRdata.toID('b22') = i;
FNRdata.values(i) = 2.6;

i = i+1;
FNRdata.toID('b1a') = i;
FNRdata.values(i) = 0.838;

i = i+1;
FNRdata.toID('b1n') = i;
FNRdata.values(i) = 0.613;

i = i+1;
FNRdata.toID('b21a') = i;
FNRdata.values(i) = 0.0821;

i = i+1;
FNRdata.toID('b21n') = i;
FNRdata.values(i) = 0.0634;

i = i+1;
FNRdata.toID('b31a') = i;
FNRdata.values(i) = 0.0231;

i = i+1;
FNRdata.toID('b31n') = i;
FNRdata.values(i) = 0.0148;

i = i+1;
FNRdata.toID('g13') = i;
FNRdata.values(i) = -0.464;

i = i+1;
FNRdata.toID('x4') = i;
FNRdata.values(i) = 0.196;

i = i+1;
FNRdata.toID('x5') = i;
FNRdata.values(i) = 0.455;

i = i+1;
FNRdata.toID('x3c') = i;
FNRdata.values(i) = 0.389;

clear i