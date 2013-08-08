function f = ode(t,x,O)
% f = Decoy.ode(t,x,M) includes the differential equations extracted
% from model struct M. M can be generated using Decoy.initialize(sbmlfile)

f(1:O.info.species) = 0;
for i = 1:O.info.reactions
    f(O.reactions(i).reactant) = f(O.reactions(i).reactant) - prod(x(O.reactions(i).reactant))*O.rates(i).megaRatePlus + prod(x(O.reactions(i).product))*O.rates(i).megaRateMin;
    f(O.reactions(i).product) = f(O.reactions(i).product) - prod(x(O.reactions(i).product))*O.rates(i).megaRateMin + prod(x(O.reactions(i).reactant))*O.rates(i).megaRatePlus;
end

f = f(:);

end