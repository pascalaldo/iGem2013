function M = setup(S)
% M = FNR.ODE.SETUP() generates the ODE data needed in the FNR model.
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

M = S;

d('------ Species ------');
M.species.toName(M.species.FNRmRNA) = 'FNR mRNA';
M.species.toID('FNR-mRNA') = M.species.FNRmRNA;
M.amounts(M.species.FNRmRNA) = 0.16;
d('- Added species `FNR-mRNA`');

M.species.toName(M.species.InactiveFNR) = 'Inactive FNR';
M.species.toID('Inactive FNR') = M.species.InactiveFNR;
M.amounts(M.species.InactiveFNR) = 4.63;
d('- Added species `Inactive FNR`');

M.species.toName(M.species.ActiveFNR) = 'Active FNR';
M.species.toID('Active FNR') = M.species.ActiveFNR;
M.amounts(M.species.ActiveFNR) = 0.08;
d('- Added species `Active FNR`');

d('------ Parameters ------');
M.parameters.toID('a1') = M.parameters.a1;
M.values(M.parameters.a1) = 0.0871;

M.parameters.toID('a1max') = M.parameters.a1max;
M.values(M.parameters.a1max) = 0.135;

M.parameters.toID('a21') = M.parameters.a21;
M.values(M.parameters.a21) = 0.484;

M.parameters.toID('a22') = M.parameters.a22;
M.values(M.parameters.a22) = 4.09;

M.parameters.toID('b22') = M.parameters.b22;
M.values(M.parameters.b22) = 2.6;

M.parameters.toID('b1a') = M.parameters.b1a;
M.values(M.parameters.b1a) = 0.838;

M.parameters.toID('b1n') = M.parameters.b1n;
M.values(M.parameters.b1n) = 0.613;

M.parameters.toID('b21a') = M.parameters.b21a;
M.values(M.parameters.b21a) = 0.0821;

M.parameters.toID('b21n') = M.parameters.b21n;
M.values(M.parameters.b21n) = 0.0634;

M.parameters.toID('b31a') = M.parameters.b31a;
M.values(M.parameters.b31a) = 0.0231;

M.parameters.toID('b31n') = M.parameters.b31n;
M.values(M.parameters.b31n) = 0.0148;

M.parameters.toID('g13') = M.parameters.g13;
M.values(M.parameters.g13) = -0.464;

M.parameters.toID('x4') = M.parameters.x4;
M.values(M.parameters.x4) = 0.196;

M.parameters.toID('x5') = M.parameters.x5;
M.values(M.parameters.x5) = 0.455;

M.parameters.toID('x3c') = M.parameters.x3c;
M.values(M.parameters.x3c) = 0.389;

M.parameters.toID('oxygen') = M.parameters.oxygen;
M.values(M.parameters.oxygen) = 0.0;

M.amounts = M.amounts(:);
M.values = M.values(:);

end