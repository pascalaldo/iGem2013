function O = setup(S)
% O = DECOY.ODE.SETUP() generates the data needed in the ODE model
% 

O = S;

O.parameters.toID('copyNumber') = O.parameters.copyNumber;
O.parameters.toID('volume') = O.parameters.volume;
O.parameters.toID('Knplus') = O.parameters.Knplus;
O.parameters.toID('Knmin') = O.parameters.Knmin;

O.parameters.toID('Kptplus') = O.parameters.Kptplus;
O.parameters.toID('Kptmin') = O.parameters.Kptmin;

O.parameters.toID('Ktpplus') = O.parameters.Ktpplus;
O.parameters.toID('Ktpmin') = O.parameters.Ktpmin;

O.parameters.toID('Kpt_tptplus') = O.parameters.Kpt_tptplus;
O.parameters.toID('Kpt_tptmin') = O.parameters.Kpt_tptmin;

O.parameters.toID('Ktp_tptplus') = O.parameters.Ktp_tptplus;
O.parameters.toID('Ktp_tptmin') = O.parameters.Ktp_tptmin;

O.values(O.parameters.copyNumber) = 17.5;
O.values(O.parameters.volume) = 0.6E-15;    % the volume of E.ocli in L

O.info.volume = O.values(O.parameters.volume);
O.info.copyNumber = O.values(O.parameters.copyNumber);

O = Decoy.Stochastic.setup(O);

[megaRatePlus,megaRateMin] = Tools.meso2mega(O, O.reaction.TpN_TN);
O.values(O.parameters.Knplus) = megaRatePlus;
O.values(O.parameters.Knmin) = megaRateMin;

[megaRatePlus,megaRateMin] = Tools.meso2mega(O, O.reaction.TpP_TP);
O.values(O.parameters.Kptplus) = megaRatePlus;
O.values(O.parameters.Kptmin) = megaRateMin;

O.values(O.parameters.Ktpplus) = megaRatePlus;
O.values(O.parameters.Ktpmin) = megaRateMin;

O.values(O.parameters.Kpt_tptplus) = megaRatePlus;
O.values(O.parameters.Kpt_tptmin) = megaRateMin;

O.values(O.parameters.Ktp_tptplus) = megaRatePlus;
O.values(O.parameters.Ktp_tptmin) = megaRateMin;

newam = Tools.nr2mol(O,O.amounts);

O.amounts(O.species.T0) = newam(O.species.T0);
O.amounts(O.species.T) = newam(O.species.T);
O.amounts(O.species.N) = newam(O.species.N);
O.amounts(O.species.TN) = newam(O.species.TN);
O.amounts(O.species.N0) = newam(O.species.N0);
O.amounts(O.species.P) = newam(O.species.P);
O.amounts(O.species.TP) = newam(O.species.TP);
O.amounts(O.species.TP) = newam(O.species.PT);
O.amounts(O.species.TP) = newam(O.species.TPT);
O.amounts(O.species.P0) = newam(O.species.P0);

O.values = O.values(:);
O.amounts = O.amounts(:);
end