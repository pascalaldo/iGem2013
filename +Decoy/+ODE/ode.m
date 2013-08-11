function f = ode(t,x,O)
% f = Decoy.ODE.ode(t,x,O) includes the differential equations extracted
% from model struct O.
% O - Decoy.ODE.initialize()

f(1:O.info.species) = 0;
for i = 1:O.info.reactions
    f(O.reactions(i).reactant) = f(O.reactions(i).reactant) - prod(x(O.reactions(i).reactant))*O.rates(i).megaRatePlus + prod(x(O.reactions(i).product))*O.rates(i).megaRateMin;
    f(O.reactions(i).product) = f(O.reactions(i).product) - prod(x(O.reactions(i).product))*O.rates(i).megaRateMin + prod(x(O.reactions(i).reactant))*O.rates(i).megaRatePlus;
end

f = f(:);

end