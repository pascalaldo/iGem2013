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

% get data from stochastic model
M = Decoy.Stochastic.initialize();

O.info.model = 'Decoy';
O.info.species = M.info.species;
O.info.reactions = M.info.reactions;

for i = 1:M.info.reactions
    [megaRatePlus,megaRateMin] = Tools.meso2mega(M, i);
    O.rates(i).megaRatePlus = megaRatePlus;
    O.rates(i).megaRateMin = megaRateMin;
end

O.reactions = M.reactions;
O.amounts = Tools.nr2mol(M,M.amounts);

end