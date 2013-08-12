function M = initialize()
% M = FNR.ODE.INITIALIZE() generates the ODE data needed in the FNR model.
% concentrations in [uM]
% rates in [uM/min]
% a short for aerobic
% n short for anaerobic
% The output struct M looks like this:
% M
%   .info
%       .model                  - FNR
%   .toID(name)                 - Convert species name to a species ID
%   .values(id)                 - Values used in the ode functions
%   .oxygen                     - The concentrations of oxygen
%   .amounts(nr)                - Initial concentrations

M.info.model = 'FNR';
M.info.species = 3;

d('------ Species ------');
M.species.toName = containers.Map('KeyType','uint32','ValueType','char');
M.species.toID = containers.Map('KeyType','char','ValueType','uint32');

M.species.toName(1) = 'FNR mRNA';
M.species.toId('FNR-mRNA') = 1;
d('- Added species `FNR-mRNA`');

M.species.toName(2) = 'Inactive FNR';
M.species.toId('Inactive FNR') = 2;
d('- Added species `Inactive FNR`');

M.species.toName(3) = 'Active FNR';
M.species.toId('Active FNR') = 3;
d('- Added species `Active FNR`');

M.toID = containers.Map('KeyType','char','ValueType','uint32');
i = 1;

M.toID('mRNA') = i;
M.values(i) = 0.16;

i = i+1;
M.toID('inactiveFNR') = i;
M.values(i) = 4.63;

i = i+1;
M.toID('activeFNR') = i;
M.values(i) = 0.08;

i = i+1;
M.toID('a1') = i;
M.values(i) = 0.0871;

i = i+1;
M.toID('a1max') = i;
M.values(i) = 0.135;

i = i+1;
M.toID('a21') = i;
M.values(i) = 0.484;

i = i+1;
M.toID('a22') = i;
M.values(i) = 4.09;

i = i+1;
M.toID('b22') = i;
M.values(i) = 2.6;

i = i+1;
M.toID('b1a') = i;
M.values(i) = 0.838;

i = i+1;
M.toID('b1n') = i;
M.values(i) = 0.613;

i = i+1;
M.toID('b21a') = i;
M.values(i) = 0.0821;

i = i+1;
M.toID('b21n') = i;
M.values(i) = 0.0634;

i = i+1;
M.toID('b31a') = i;
M.values(i) = 0.0231;

i = i+1;
M.toID('b31n') = i;
M.values(i) = 0.0148;

i = i+1;
M.toID('g13') = i;
M.values(i) = -0.464;

i = i+1;
M.toID('x4') = i;
M.values(i) = 0.196;

i = i+1;
M.toID('x5') = i;
M.values(i) = 0.455;

i = i+1;
M.toID('x3c') = i;
M.values(i) = 0.389;

M.oxygen = 0;

M.amounts(1) = 0.16;
M.amounts(2) = 4.63;
M.amounts(3) = 0.08;

end