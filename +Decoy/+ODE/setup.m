function O = setup(S)
% O = DECOY.ODE.SETUP() generates the data needed in the ODE model
% 

O = S;

O.parameters.toID('copyNumber') = O.parameters.copyNumber;
O.parameters.toID('volume') = O.parameters.volume;
O.parameters.toID('Knplus') = O.parameters.Knplus;
O.parameters.toID('Knmin') = O.parameters.Knmin;
O.parameters.toID('Kpplus') = O.parameters.Kpplus;
O.parameters.toID('Kpmin') = O.parameters.Kpmin;

O.values(O.parameters.copyNumber) = 17.5;
O.values(O.parameters.volume) = 0.6E-15;    % the volume of E.ocli in L

O.info.volume = O.values(O.parameters.volume);
O.info.copyNumber = O.values(O.parameters.copyNumber);

O = Decoy.Stochastic.setup(O);

[megaRatePlus,megaRateMin] = Tools.meso2mega(O, O.reaction.TpN_TN);
O.values(O.parameters.Knplus) = megaRatePlus;
O.values(O.parameters.Knmin) = megaRateMin;

[megaRatePlus,megaRateMin] = Tools.meso2mega(O, O.reaction.TpP_TP);
O.values(O.parameters.Kpplus) = megaRatePlus;
O.values(O.parameters.Kpmin) = megaRateMin;

newam = Tools.nr2mol(O,O.amounts);

O.amounts(O.species.T0) = newam(O.species.T0);
O.amounts(O.species.T) = newam(O.species.T);
O.amounts(O.species.N) = newam(O.species.N);
O.amounts(O.species.TN) = newam(O.species.TN);
O.amounts(O.species.N0) = newam(O.species.N0);
O.amounts(O.species.P) = newam(O.species.P);
O.amounts(O.species.TP) = newam(O.species.TP);
O.amounts(O.species.P0) = newam(O.species.P0);

end