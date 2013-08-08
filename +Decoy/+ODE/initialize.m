function O = initialize()
% initialize.m geneFNRdatas the FNRdata in the workspace.
% oxygen is not included in the struct
% concentrations in [uM]
% FNRdatas in [uM/min]
% a - aerobic
% n - anaerobic

M = Decoy.Stochastic.initialize();

for i = 1:M.info.reactions
    [megaRatePlus,megaRateMin] = Tools.meso2mega(M, i);
    O.rates(i).megaRatePlus = megaRatePlus;
    O.rates(i).megaRateMin = megaRateMin;
end

O.info.model = 'Decoy';
O.info.species = M.info.species;
O.info.reactions = M.info.reactions;
O.reactions = M.reactions;
O.amounts = Tools.nr2mol(M,M.amounts);

end