function [t,a] = evaluate(M, n, tmax)
% DECOY.EVALUATE runs multiple stochastic simlutions.
% [t,a] = DECOY.EVALUATE(M, n) runs n stochastic simulation using the 
% network defined in struct M. M can be generated using the function
% Decoy.initialize(sbmlfile).

t = [];
a = [];

for i=1:n
    [times,amounts] = Decoy.simulate(M,tmax);
    t = [t times];
    a = [a amounts];
end

end

