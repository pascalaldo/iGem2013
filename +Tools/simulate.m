function [t,a] = simulate(M,tmax)
% TOOLS.SIMULATE runs a stochastic simlution.
% [t,a] = TOOLS.SIMULATE(M,tmax) runs a stochastic simulation using the 
% network defined in struct M.

% Initialization
i = 1;
t(i) = 0;

for j = 1:M.info.rules
    eval(M.rules(j).expression);
end

oxyc = Tools.mol2nr(M,10);

FNRModel = ~strcmp(M.info.model, 'Decoy');
x1 = 0; x3 = 0; x6 = 0; env = 0;

while t(i) < tmax
    if FNRModel
        x1 = M.amounts(M.species.FNRmRNA,i);
        x3 = M.amounts(M.species.ActiveFNR,i);
        x6 = M.info.oxygen;
        env = (x6<oxyc)+1;
    end

    p = zeros(M.info.reactions,1);
    q = zeros(M.info.reactions,1);
    
    for j = 1:M.info.reactions
        p(j) = prod(M.amounts((M.reactions(j).reactant),i))*M.reactions(j).mesorate_plus(env,x1,x3,x6); % .^(-M.stoichiometry(M.reactions(j).reactant,j))
        q(j) = prod(M.amounts((M.reactions(j).product),i))*M.reactions(j).mesorate_min(env,x1,x3,x6); % Reverse reaction % .^(M.stoichiometry(M.reactions(j).product,j))
    end
    lamda = cumsum([p;q]);

    % calculate the time step
    i = i + 1;
    tstep = exprnd(1/lamda(end));
    t(i) = t(i-1) + tstep;

    % decide which reaction
    flag = find( (lamda - rand(1)*lamda(end)) >0, 1);

    %d(sprintf('Reaction: %d', flag));

    if flag <= M.info.reactions
        M.amounts(:,i) = M.amounts(:,i-1) + M.stoichiometry(:,flag);
        %d(sprintf('Reaction = %s',M.reactions(flag).equation));
    else % Reverse reaction
        M.amounts(:,i) = M.amounts(:,i-1) - M.stoichiometry(:,flag-M.info.reactions);
        %d(sprintf('Reaction = %s (rev)',M.reactions(flag-M.info.reactions).equation));
    end
    
    for j = 1:M.info.rules
        eval(M.rules(j).expression);
    end
    %figure(1);
    %plot(t,M.amounts(2:4,:));
end

a = M.amounts;

end