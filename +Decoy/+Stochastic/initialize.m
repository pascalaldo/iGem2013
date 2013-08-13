function M = initialize()
% STOCHASTICS.INITIALIZE creates the network for a stochastic simulation.
% M = STOCHASTICS.INITIALIZE()

S.info.model = 'Decoy';
S.info.species = 8;
S.info.reactions = 2;
S.info.rules = 3;
S.info.volume = 0.6E-15;    % the volume of E.ocli in L
S.info.NA = 6.023E23;       % the Avogadro's constant
S.info.copyNumber = 17.5;

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

S.reaction.TpN_TN  = 1;
S.reaction.TpP_TP  = 2;

%% Rules
S.rule.T0 = 1;
S.rule.N0 = 2;
S.rule.P0 = 3;

M = Decoy.Stochastic.setup(S);

end
