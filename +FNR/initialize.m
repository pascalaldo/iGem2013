function M = initialize()
% FNR.INITIALIZE creates the network for a stochastic simulation.
% M = STOCHASTICS.INITIALIZE() creates the network data
% The output of this function is struct M, which contains all information
% of the model. M can be used as an input argument for the function
% Stochastics.Simulate(M). The structure of M looks like this:
%
% M
%  .info
%        .volume                 - The volume of E.coli
%        .species                - The number of species in the model
%        .reactions              - The number of reactions in the model
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

% M.count.species = length(model.Species);
% M.count.reactions = length(model.Reactions);
% modified by Yicong
M.info.species = 4;
M.info.reactions = 4;
M.info.volume = 0.6E-15;    % the volume of E.ocli in L
M.info.NA = 6.023E23;       % the Avogadro's constant

%% Parameters
a1      = 0.0871;
a1max   = 0.135;
a21     = 0.484;
a22     = 4.09;
b22     = 2.6;
b1(1)   = 0.838;
b1(2)   = 0.613;
b21(1)  = 0.0821;
b21(2)  = 0.0634;
b31(1)  = 0.0231;
b31(2)  = 0.0148;
g13     = -0.464;
x4      = 0.196;
x5      = 0.455;
%x6      = oxygen;
x3c     = 0.389;

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

M.species.toName(1) = 'Void';
M.species.toId('Void') = 1;
d('- Added species `Void`');

M.species.toName(2) = 'FNR mRNA';
M.species.toId('FNR-mRNA') = 2;
d('- Added species `FNR-mRNA`');

M.species.toName(3) = 'Inactive FNR';
M.species.toId('Inactive FNR') = 3;
d('- Added species `Inactive FNR`');

M.species.toName(4) = 'Active FNR';
M.species.toId('Active FNR') = 4;
d('- Added species `Active FNR`');

% Set up the stoichiometry matrix
M.stoichiometry = sparse(zeros(M.info.species,M.info.reactions));
M.stoichiometry(2,1) = 1;
M.stoichiometry(3,2) = 1;
M.stoichiometry(4,3) = 1;
M.stoichiometry(3,4) = -2;
M.stoichiometry(4,4) = 1;

% Set the initial condition
M.amounts = [1; 58; 1673; 29];

%% Reactions
%
NV = M.info.NA*M.info.volume*10^(-6);

d('------ Reactions ------');
d('Reaction 1:');
M.reactions(1).equation = 'Void <-> FNR mRNA';
M.reactions(1).reactant = 1;
M.reactions(1).product = 2;
    function r = reaction1_mesorate_plus(env,x1,x3,x6)
        if x3<x3c*NV
            r = a1max*NV;
        else
            r = a1*NV*(x3/NV)^g13;
        end
    end
M.reactions(1).mesorate_plus = @reaction1_mesorate_plus;
M.reactions(1).mesorate_min = @(env,x1,x3,x6)( b1(env) );
d(M.reactions(1).equation);

d('Reaction 2:');
M.reactions(2).equation = 'Void <-> Inactive FNR';
M.reactions(2).reactant = 1;
M.reactions(2).product = 3;
M.reactions(2).mesorate_plus = @(env,x1,x3,x6)( a21*x1 );
M.reactions(2).mesorate_min = @(env,x1,x3,x6)( b21(env)*x4 );
d(M.reactions(2).equation);

d('Reaction 3:');
M.reactions(3).equation = 'Void <- Active FNR';
M.reactions(3).reactant = 1;
M.reactions(3).product = 4;
M.reactions(3).mesorate_plus = @(env,x1,x3,x6)( 0 );
M.reactions(3).mesorate_min = @(env,x1,x3,x6)( b31(env) );
d(M.reactions(3).equation);

d('Reaction 4:');
M.reactions(4).equation = '2 Inactive FNR <-> Active FNR';
M.reactions(4).reactant = 3;
M.reactions(4).product = 4;
M.reactions(4).mesorate_plus = @(env,x1,x3,x6)( b22*x5/NV );
M.reactions(4).mesorate_min = @(env,x1,x3,x6)( a22*x6 );
d(M.reactions(4).equation);


end
