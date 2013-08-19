function O = initialize()
% O = DECOY.ODE.INITIALIZE() generates the data needed in the ODE model
% O = Decoy.ODE.initialize() generates a struct type, with:
% oxygen is not included in the struct
% concentrations in [uM]
% FNRdatas in [uM/min]
% a - aerobic
% n - anaerobic
%
% the structure of O looks like this:
% O
%  .info
%       .model                  - Type of model
%       .species                - Number of species in the model
%       .reactions              - Number of reactions in the model
%  .rates(nr)
%       .megaRatePlus           - 'Plus' reaction rate
%       .megaRateMin            - 'Min' reaction rate
%  .reactions(nr)
%       .reactant               - Vector of species IDs of all reactants
%       .product                - Vector of species IDs of all products
%       .mesorate_plus          - 'Plus' reaction rate
%       .mesorate_min           - 'Min' reaction rate
%  .amounts(id)                 - The concentrations[uM] of molecules of each species

S.info.model = 'Decoy';
S.info.species = 8;
S.info.reactions = 2;
S.info.rules = 3;
S.info.NA = 6.023E23;       % the Avogadro's constant

%% Species
S.species.toName = containers.Map('KeyType','uint32','ValueType','char');
S.species.toID = containers.Map('KeyType','char','ValueType','uint32');

S.species.T0    = 1;
S.species.T     = 2;
S.species.N     = 3;
S.species.TN    = 4;
S.species.N0    = 5;
S.species.P     = 6;
S.species.TP    = 7;
S.species.P0    = 8;

%% Reactions
S.stoichiometry = sparse(zeros(S.info.species,S.info.reactions));

S.reaction.TpN_TN  = 1;
S.reaction.TpP_TP  = 2;

%% Rules
S.rule.T0 = 1;
S.rule.N0 = 2;
S.rule.P0 = 3;

%% Paramters
S.parameters.toID = containers.Map('KeyType','char','ValueType','uint32');

S.parameters.Knplus = 1;
S.parameters.Knmin = 2;
S.parameters.Kpplus = 3;
S.parameters.Kpmin = 4;
S.parameters.oxygen = 5;
S.parameters.copyNumber = 6;
S.parameters.volume = 7;

O = Decoy.ODE.setup(S);

end