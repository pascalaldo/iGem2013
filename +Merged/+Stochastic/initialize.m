function M = initialize()
% [D,F,M] = MERGED.ODE.INITIALIZE() generates the data for master ode model
% M
%   .info
%       .model                              - 'master'
%   .Decoy                                  - Decoy struct
%   .FNR                                    - FNR struct
%   .amounts(id)                            - initial concentrations
%   .oxygen                                 - oxygen concentrations

D = Decoy.Stochastic.initialize();
F = FNR.Stochastic.initialize();

M.info.model = 'Merged';
M.info.species = 11;
M.info.reactions = 8;
M.info.volume = 0.6E-15;    % the volume of E.ocli in L
M.info.NA = 6.023E23;       % the Avogadro's constant
M.info.oxygen = 0;

b31(1)  = 0.0231;
b31(2)  = 0.0148;

d('------ Species ------');
M.species = F.species;

M.species.toName(F.info.species+1) = D.species.toName(1);
M.species.toID(D.species.toName(1)) = F.info.species+1;
d(sprintf('- Added species `%s`', M.species.toName(F.info.species+1)));
for i=[3:D.info.species]
    M.species.toName(F.info.species+i-1) = D.species.toName(i);
    M.species.toID(D.species.toName(i)) = F.info.species+i-1;
    d(sprintf('- Added species `%s`', M.species.toName(F.info.species+i-1)));
end

M.Decoy = D;
M.FNR = F;

stF = [M.FNR.stoichiometry sparse(zeros(M.FNR.info.species,M.Decoy.info.reactions))];
stD = [sparse(zeros(M.Decoy.info.species,M.FNR.info.reactions)) M.Decoy.stoichiometry];

degrTN = sparse(zeros(M.info.species,1));
degrTN(6) = -1;
degrTN(7) = 1;
degrTP = sparse(zeros(M.info.species,1));
degrTP(9) = -1;
degrTP(10) = 1;

M.stoichiometry = [[stF(1:3,:); (stF(4,:) + stD(2,:)); stD([1 3:D.info.species],:)] degrTN degrTP];
d(full(M.stoichiometry));

M.reactions = F.reactions;
for i=[1:D.info.reactions]
    M.reactions(F.info.reactions+i) = D.reactions(i);
    M.reactions(F.info.reactions+i).reactant = M.reactions(F.info.reactions+i).reactant + F.info.species-1;
    M.reactions(F.info.reactions+i).product = M.reactions(F.info.reactions+i).product + F.info.species-1;
    d(M.reactions(F.info.reactions+i).equation);
end

M.reactions(7).equation = 'Void + N <- TN';
M.reactions(7).reactant = [1 6];
M.reactions(7).product = 7;
M.reactions(7).mesorate_plus = @(env,x1,x3,x6)( 0 );
M.reactions(7).mesorate_min = @(env,x1,x3,x6)( b31(env) );
d(M.reactions(7).equation);

M.reactions(8).equation = 'Void + P <- TP';
M.reactions(8).reactant = [1 9];
M.reactions(8).product = 10;
M.reactions(8).mesorate_plus = @(env,x1,x3,x6)( 0 );
M.reactions(8).mesorate_min = @(env,x1,x3,x6)( b31(env) );
d(M.reactions(8).equation);

M.amounts = F.amounts;
M.amounts(5) = D.amounts(1);
M.amounts(6:11) = D.amounts(3:8);

end