<<<<<<< HEAD
function [t,a] = evaluate(M, n, tmax)
=======
function [t,a] = evaluate(M, n,tmax)
>>>>>>> 17b484ad3f5d10221150d6500ece1aceac540f1c
% STOCHASTICS.EVALUATE runs multiple stochastic simlutions.
% [t,a] = STOCHASTICS.EVALUATE(M, n) runs n stochastic simulation using the 
% network defined in struct M. M can be generated using the function
% Stochastics.initialize(sbmlfile).

t = [];
a = [];

for i=1:n
    [times,amounts] = Stochastics.simulate(M,tmax);
    t = [t times];
    a = [a amounts];
end

end

