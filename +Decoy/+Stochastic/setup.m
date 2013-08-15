function M = setup(S)
% STOCHASTICS.INITIALIZE creates the network for a stochastic simulation.
% M = STOCHASTICS.INITIALIZE(sbmlfile) creates the network data from the 
% sbml file sbmlfile.
% The output of this function is struct M, which contains all information
% of the model. M can be used as an input argument for the function
% Stochastics.Simulate(M). The structure of M looks like this:
%
% M
%  .info
%        .model                  - The type of the model
%        .volume                 - The volume of E.coli
%        .species                - The number of species in the model
%        .reactions              - The number of reactions in the model
%        .NA                     - The Avgadro's constant
%        .copyNumber             - The copy number of plasmid
%  .species
%          .toName(id)           - Convert species ID to a species name
%          .toID(name)           - Convert species name to a species ID
%  .stoichiometry(spec,react)    - Matrix that holds the stoichiometry
%                                  information of the reactions
%  .amounts(id)                  - The amount of molecules of each species
%  .reactions(nr)
%                .reactant       - Vector of species IDs of all reactants
%                .product        - Vector of species IDs of all products
%                .mesorate_plus  - 'Plus' reaction rate
%                .mesorate_min   - 'Min' reaction rate
%
% To enable verbose mode, set the variable DEBUG to true in your workspace.
%
% Created by the Eindhoven University of Technology 2013 iGEM Team
% Yicong Chen <y.chen.3@student.tue.nl>
% Pasal Pieters <p.a.pieters@student.tue.nl>

M = S;

%% Species
% Set up the struct of name-index mapping
% Notes:
% This part is written as 'modelStruct.species.name' instead of
% 'modelStruct.name' because I think this way it can be expanded easily in
% the future, for example if we want to add any compartments or some polynomials for
% calculating the mesoscopic rate.
d('------ Species ------');
M.species.toName(M.species.T0) = 'T0';
M.species.toID('T0') = M.species.T0;
d('- Added species `T0`');

M.species.toName(M.species.T) = 'T';
M.species.toID('T') = M.species.T;
d('- Added species `T`');

M.species.toName(M.species.N) = 'N';
M.species.toID('N') = M.species.N;
d('- Added species `N`');

M.species.toName(M.species.TN) = 'TN';
M.species.toID('TN') = M.species.TN;
d('- Added species `TN`');

M.species.toName(M.species.N0) = 'N0';
M.species.toID('N0') = M.species.N0;
d('- Added species `N0`');

M.species.toName(M.species.P) = 'P';
M.species.toID('P') = M.species.P;
d('- Added species `P`');

M.species.toName(M.species.TP) = 'TP';
M.species.toID('TP') = M.species.TP;
d('- Added species `TP`');

M.species.toName(M.species.P0) = 'P0';
M.species.toID('P0') = M.species.P0;
d('- Added species `P0`');


%% Set up the stoichiometry
M.stoichiometry(M.species.T,M.reaction.TpN_TN) = -1;
M.stoichiometry(M.species.N,M.reaction.TpN_TN) = -1;
M.stoichiometry(M.species.TN,M.reaction.TpN_TN) = 1;
M.stoichiometry(M.species.T,M.reaction.TpP_TP) = -1;
M.stoichiometry(M.species.P,M.reaction.TpP_TP) = -1;
M.stoichiometry(M.species.TP,M.reaction.TpP_TP) = 1;

%% Set the amounts (initial condition)
M.amounts(M.species.T0,:) = round(500*M.info.copyNumber);
M.amounts(M.species.T,:) = round(500*M.info.copyNumber);
M.amounts(M.species.N,:) = round(100*M.info.copyNumber);
M.amounts(M.species.TN,:) = round(0*M.info.copyNumber);
M.amounts(M.species.N0,:) = round(100*M.info.copyNumber);
M.amounts(M.species.P,:) = round(7*M.info.copyNumber);
M.amounts(M.species.TP,:) = round(0*M.info.copyNumber);
M.amounts(M.species.P0,:) = round(7*M.info.copyNumber);

%% Reactions
d('------ Reactions ------');
d(sprintf('Reaction %d:',M.reaction.TpN_TN));
M.reactions(M.reaction.TpN_TN).equation = 'T + N <-> TN';
M.reactions(M.reaction.TpN_TN).reactant = [M.species.T M.species.N];
M.reactions(M.reaction.TpN_TN).product = M.species.TN;
M.reactions(M.reaction.TpN_TN).mesorate_plus = @(~,~,~,~)(0.0100);
M.reactions(M.reaction.TpN_TN).mesorate_min = @(~,~,~,~)(0.4200);
d(M.reactions(M.reaction.TpN_TN).equation);

d(sprintf('Reaction %d:',M.reaction.TpP_TP));
M.reactions(M.reaction.TpP_TP).equation = 'T + P <-> TP';
M.reactions(M.reaction.TpP_TP).reactant = [M.species.T M.species.P];
M.reactions(M.reaction.TpP_TP).product = M.species.TP;
M.reactions(M.reaction.TpP_TP).mesorate_plus = @(~,~,~,~)(0.0100);
M.reactions(M.reaction.TpP_TP).mesorate_min = @(~,~,~,~)(0.4200);
d(M.reactions(M.reaction.TpP_TP).equation);

%% Rules

d('------ Rules ------');
M.rules(M.rule.T0).expression = 'M.amounts(M.species.T0,i) = M.amounts(M.species.T,i) + M.amounts(M.species.TN,i) + M.amounts(M.species.TP,i);';
M.rules(M.rule.N0).expression = 'M.amounts(M.species.N0,i) = M.amounts(M.species.N,i) + M.amounts(M.species.TN,i);';
M.rules(M.rule.P0).expression = 'M.amounts(M.species.P0,i) = M.amounts(M.species.P,i) + M.amounts(M.species.TP,i);';

end
