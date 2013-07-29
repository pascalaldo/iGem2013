function M = initialize(sbmlfile,x)
%MASTER.INITIALIZE creates the network for master simulation.
%   M = MASTER.INITIALIZE(sbmlfile) creates the network data from the 
%   sbml file. It is mostly based on DECOY.INITIALIZE. The only thing
%   changed is the amount of 'T', which, in the master simulation, comes
%   from the concentration of FNR in the ODE model.
%   The structure of M looks like this:
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

M = Decoy.initialize(sbmlfile);
% M.amounts(M.species.toID('T')) = mol2nr
M.amounts(2) = Master.mol2nr(M,x);
% M.amounts(M.species.toID('T0')) =
% M.amounts(M.species.toID('T')) + M.amounts(M.species.toID('TP'))
% + M.amounts(M.species.toID('TN'))
M.amounts(1) = M.amounts(2)+ M.amounts(7) + M.amounts(4);
end

