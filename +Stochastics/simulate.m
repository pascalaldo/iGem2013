function [t,a] = simulate(M)
% STOCHASTICS.SIMULATE runs a stochastic simlution.
% [t,a] = STOCHASTICS.SIMULATE(M) runs a stochastic simulation using the 
% network defined in struct M. M can be generated using the function
% Stochastics.initialize(sbmlfile). This function returns the different 
% points in time the simulation was run and the corresponding amounts of
% molecules of each species.

% set the maximum simulation time
tmax = 10;

% Initialization
i = 1;
t(i) = 0;

while t(i) < tmax

    p = zeros(M.count.reactions,1);
    q = zeros(M.count.reactions,1);
    
    for j = 1:M.count.reactions
        p(j) = prod(M.amounts((M.reactions(j).reactant),i))*M.reactions(j).mesorate_plus;
        q(j) = prod(M.amounts((M.reactions(j).product),i))*M.reactions(j).mesorate_min; % Reverse reaction
    end
    lamda = cumsum([p;q]);

    % calculate the time step
    i = i + 1;
    tstep = exprnd(1/lamda(end));
    t(i) = t(i-1) + tstep;

    % decide which reaction
    flag = find( (lamda - rand(1)*lamda(end)) >0, 1);

    if flag <= M.count.reactions
        M.amounts(:,i) = M.amounts(:,i-1) + M.stoichiometry(:,flag);
    else % Reverse reaction
        M.amounts(:,i) = M.amounts(:,i-1) - M.stoichiometry(:,flag-M.count.reactions);
    end
end

a = M.amounts;

end