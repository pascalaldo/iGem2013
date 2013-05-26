% stochasticSim - main file for stochastic simulation
% for use in iGEM 2013
% created by Yicong Chen on 26 May, 2013

close all
clear all
load('data.mat')

% set the maximum simulation time
tmax = 100;

% get the info of loaded data
reactionSize = length(reactions);

while t(i) < tmax

    p = zeros(reactionSize,1);

    for j = 1:n
        p(j) = prod(species((reactions(j).reactant),i))*reactions(j).mesorate;
    end
    lamda = cumsum(p);

    % calculate the time step
    i = i + 1;
    tstep = exprnd(1/lamda(end));
    t(i) = t(i-1) + tstep;

    % decide which reaction
    flag = find( (lamda - rand(1)*lamda(end)) >0, 1);
    species(:,i) = species(:,i-1) + stoichMat(:,flag);
end