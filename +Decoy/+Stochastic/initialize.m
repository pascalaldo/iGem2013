function M = initialize()
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

M.info.model = 'Decoy';
M.info.species = 8;
M.info.reactions = 2;
M.info.volume = 0.6E-15;    % the volume of E.ocli in L
M.info.NA = 6.023E23;       % the Avogadro's constant
M.info.copyNumber = 17.5;

%% Species
% Set up the struct of name-index mapping
% Notes:
% This part is written as 'modelStruct.species.name' instead of
% 'modelStruct.name' because I think this way it can be expanded easily in
% the future, for example if we want to add any compartments or some polynomials for
% calculating the mesoscopic rate.
d('------ Species ------');
M.species.toName = containers.Map('KeyType','uint32','ValueType','char');
M.species.toID = containers.Map('KeyType','char','ValueType','uint32');

M.species.toName(1) = 'T0';
M.species.toID('T0') = 1;
d('- Added species `T0`');

M.species.toName(2) = 'T';
M.species.toID('T') = 2;
d('- Added species `T`');

M.species.toName(3) = 'N';
M.species.toID('N') = 3;
d('- Added species `N`');

M.species.toName(4) = 'TN';
M.species.toID('TN') = 4;
d('- Added species `TN`');

M.species.toName(5) = 'N0';
M.species.toID('N0') = 5;
d('- Added species `N0`');

M.species.toName(6) = 'P';
M.species.toID('P') = 6;
d('- Added species `P`');

M.species.toName(7) = 'TP';
M.species.toID('TP') = 7;
d('- Added species `TP`');

M.species.toName(8) = 'P0';
M.species.toID('P0') = 8;
d('- Added species `P0`');


%% Set up the stoichiometry
M.stoichiometry = sparse(zeros(M.info.species,M.info.reactions));
M.stoichiometry(2,1) = -1;
M.stoichiometry(3,1) = -1;
M.stoichiometry(4,1) = 1;
M.stoichiometry(2,2) = -1;
M.stoichiometry(6,2) = -1;
M.stoichiometry(7,2) = 1;

%% Set the amounts (initial condition)
M.amounts = round([500; 500; 100; 0; 100; 7; 0; 7].*M.info.copyNumber);

%% Reactions

d('------ Reactions ------');
d('Reaction 1:');
M.reactions(1).equation = 'T + N <-> TN';
M.reactions(1).reactant = [2 3];
M.reactions(1).product = 4;
M.reactions(1).mesorate_plus = @(~,~,~,~)(0.0100);
M.reactions(1).mesorate_min = @(~,~,~,~)(0.4200);
d(M.reactions(1).equation);

d('Reaction 2:');
M.reactions(2).equation = 'T + P <-> TP';
M.reactions(2).reactant = [2 6];
M.reactions(2).product = 7;
M.reactions(2).mesorate_plus = @(~,~,~,~)(0.0100);
M.reactions(2).mesorate_min = @(~,~,~,~)(0.4200);
d(M.reactions(2).equation);

end
