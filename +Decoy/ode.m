function f = ode(t,x,stoichM)
% f = Decoy.ode(t,x,stoichM) includes the differential equations extracted
% from model struct M. M can be generated using Decoy.initialize(sbmlfile)

f(1:stoichM.info.species) = 0;
for i = 1:stoichM.info.reactions
    [megaRatePlus,megaRateMin] = Decoy.meso2mega(stoichM, i);
    f(stoichM.reactions(i).reactant) = f(stoichM.reactions(i).reactant) - prod(x(stoichM.reactions(i).reactant))*megaRatePlus + prod(x(stoichM.reactions(i).product))*megaRateMin;
    f(stoichM.reactions(i).product) = f(stoichM.reactions(i).product) - prod(x(stoichM.reactions(i).product))*megaRateMin + prod(x(stoichM.reactions(i).reactant))*megaRatePlus;
end

f = f(:);

end