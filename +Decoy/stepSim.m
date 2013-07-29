function [t,amountPlus] = stepSim(M)
% DECOY.STEPSIM runs a single-step stochastic simlution.
% [t,a] = DECOY.STEPSIM(M) runs a single-step stochastic simulation using 
% the molecule amounts given in 'M'. This function returns step time
% the corresponding amounts of molecules of each species. It is written
% specially for Master.run, so that the stochastic model and the ODE model
% can talk to each other.

p = zeros(M.info.reactions,1);
q = zeros(M.info.reactions,1);

for j = 1:M.info.reactions
    p(j) = prod(M.amounts((M.reactions(j).reactant),end))*M.reactions(j).mesorate_plus;
    q(j) = prod(M.amounts((M.reactions(j).product),end))*M.reactions(j).mesorate_min; % Reverse reaction
end
lamda = cumsum([p;q]);

% calculate the time step
t = exprnd(1/lamda(end));

% decide which reaction
flag = find( (lamda - rand(1)*lamda(end)) >0, 1);

if flag <= M.info.reactions
    amountPlus = M.amounts(:,end) + M.stoichiometry(:,flag);
else % Reverse reaction
    amountPlus = M.amounts(:,end) - M.stoichiometry(:,flag-M.info.reactions);
end

end