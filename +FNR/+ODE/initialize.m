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

S.info.model = 'FNR';
S.info.species = 3;

%% Species
S.species.toName = containers.Map('KeyType','uint32','ValueType','char');
S.species.toID = containers.Map('KeyType','char','ValueType','uint32');

S.species.FNRmRNA       = 1;
S.species.InactiveFNR   = 2;
S.species.ActiveFNR     = 3;

%% Paramters
S.parameters.toID = containers.Map('KeyType','char','ValueType','uint32');

S.parameters.a1 = 1;
S.parameters.a1max = 2;
S.parameters.a21 = 3;
S.parameters.a22 = 4;
S.parameters.b22 = 5;
S.parameters.b1a = 6;
S.parameters.b1n = 7;
S.parameters.b21a = 8;
S.parameters.b21n = 9;
S.parameters.b31a = 10;
S.parameters.b31n = 11;
S.parameters.g13 = 12;
S.parameters.x4 = 13;
S.parameters.x5 = 14;
S.parameters.x3c = 15;
S.parameters.oxygen = 16;

M = FNR.ODE.setup(S);

end