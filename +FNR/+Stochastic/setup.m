function M = setup(S)
% FNR.STOCHASTIC.SETUP creates the network for a stochastic simulation.
% M = FNR.STOCHASTICS.SETUP(S) creates the network data
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

M = S;

%% Species
% Set up the struct of name-index mapping
% Notes:
% This part is written as 'modelStruct.species.name' instead of
% 'modelStruct.name' because I think this way it can be expanded easily in
% the future, for example if we want to add any compartments or some polynomials for
% calculating the mesoscopic rate.
d('------ Species ------');
M.species.toName(M.species.Void) = 'Void';
M.species.toId('Void') = M.species.Void;
d('- Added species `Void`');

M.species.toName(M.species.FNRmRNA) = 'FNR mRNA';
M.species.toId('FNR-mRNA') = M.species.FNRmRNA;
d('- Added species `FNR-mRNA`');

M.species.toName(M.species.InactiveFNR) = 'Inactive FNR';
M.species.toId('Inactive FNR') = M.species.InactiveFNR;
d('- Added species `Inactive FNR`');

M.species.toName(M.species.ActiveFNR) = 'Active FNR';
M.species.toId('Active FNR') = M.species.ActiveFNR;
d('- Added species `Active FNR`');

% Set up the stoichiometry matrix
M.stoichiometry = sparse(zeros(M.info.species,M.info.reactions));
M.stoichiometry(M.species.FNRmRNA,M.reaction.Void_FNRmRNA) = 1;
M.stoichiometry(M.species.InactiveFNR,M.reaction.Void_InactiveFNR) = 1;
M.stoichiometry(M.species.ActiveFNR,M.reaction.Void_ActiveFNR) = 1;
M.stoichiometry(M.species.InactiveFNR,M.reaction.InactiveFNR_ActiveFNR) = -2;
M.stoichiometry(M.species.ActiveFNR,M.reaction.InactiveFNR_ActiveFNR) = 1;

% Set the initial condition
M.amounts(M.species.Void,:) = 1;
M.amounts(M.species.FNRmRNA,:) = 58;
M.amounts(M.species.InactiveFNR,:) = 1673;
M.amounts(M.species.ActiveFNR,:) = 29;

%% Reactions
%
NV = M.info.NA*M.info.volume*10^(-6); % conversion factor for µM to molecs.

d('------ Reactions ------');
d(sprintf('Reaction %d:',M.reaction.Void_FNRmRNA));
M.reactions(M.reaction.Void_FNRmRNA).equation = 'Void <-> FNR mRNA';
M.reactions(M.reaction.Void_FNRmRNA).reactant = M.species.Void;
M.reactions(M.reaction.Void_FNRmRNA).product = M.species.FNRmRNA;
    function r = reaction1_mesorate_plus(env,x1,x3,x6)
        if x3<M.par.x3c*NV
            r = M.par.a1max*NV;
        else
            r = M.par.a1*NV*(x3/NV)^M.par.g13;
        end
    end
M.reactions(M.reaction.Void_FNRmRNA).mesorate_plus = @reaction1_mesorate_plus;
M.reactions(M.reaction.Void_FNRmRNA).mesorate_min = @(env,x1,x3,x6)( M.par.b1(env) );
d(M.reactions(M.reaction.Void_FNRmRNA).equation);

d(sprintf('Reaction %d:',M.reaction.Void_InactiveFNR));
M.reactions(M.reaction.Void_InactiveFNR).equation = 'Void <-> Inactive FNR';
M.reactions(M.reaction.Void_InactiveFNR).reactant = M.species.Void;
M.reactions(M.reaction.Void_InactiveFNR).product = M.species.InactiveFNR;
M.reactions(M.reaction.Void_InactiveFNR).mesorate_plus = @(env,x1,x3,x6)( M.par.a21*x1 );
M.reactions(M.reaction.Void_InactiveFNR).mesorate_min = @(env,x1,x3,x6)( M.par.b21(env)*M.par.x4 );
d(M.reactions(M.reaction.Void_InactiveFNR).equation);

d(sprintf('Reaction %d:',M.reaction.Void_ActiveFNR));
M.reactions(M.reaction.Void_ActiveFNR).equation = 'Void <- Active FNR';
M.reactions(M.reaction.Void_ActiveFNR).reactant = M.species.Void;
M.reactions(M.reaction.Void_ActiveFNR).product = M.species.ActiveFNR;
M.reactions(M.reaction.Void_ActiveFNR).mesorate_plus = @(env,x1,x3,x6)( 0 );
M.reactions(M.reaction.Void_ActiveFNR).mesorate_min = @(env,x1,x3,x6)( M.par.b31(env) );
d(M.reactions(M.reaction.Void_ActiveFNR).equation);

d(sprintf('Reaction %d:',M.reaction.InactiveFNR_ActiveFNR));
M.reactions(M.reaction.InactiveFNR_ActiveFNR).equation = '2 Inactive FNR <-> Active FNR';
M.reactions(M.reaction.InactiveFNR_ActiveFNR).reactant = M.species.InactiveFNR;
M.reactions(M.reaction.InactiveFNR_ActiveFNR).product = M.species.ActiveFNR;
M.reactions(M.reaction.InactiveFNR_ActiveFNR).mesorate_plus = @(env,x1,x3,x6)( M.par.b22*M.par.x5/NV );
M.reactions(M.reaction.InactiveFNR_ActiveFNR).mesorate_min = @(env,x1,x3,x6)( M.par.a22*x6 );
d(M.reactions(M.reaction.InactiveFNR_ActiveFNR).equation);


end
