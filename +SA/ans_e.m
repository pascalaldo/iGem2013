% answer code for Assignment 1 question e
% multi-parameter sensitivity analysis
% created by Yicong on 12 March

clear all
close all

load BIOMD0000000151

parIndex = 1:105;               % set the index of parameters for analysis
n_Dummy = 5;                    % set number of dummy variables
n_MPSA = 660;                   % set number of simulations

n_Real = length(parIndex);
par0 = p(parIndex);             % extract data from the parameter matrix

n_Total = length(par0) + n_Dummy; % calculate number of variables
scale = lhsdesign(n_MPSA, n_Total); % random uniform distributed parameter sets (values [0,1])
scale = scale * 2 - 1;          % rescale to bound (-1, 1)
scale = 10.^scale;              % rescale to logarithm

% Adjust parameter sets for MC to reference values par0
% dummy parameters are added to the end of par_MC matrix
par_MC = zeros(n_MPSA, n_Total);
for i = 1 : n_Real
    par_MC(:,i) = scale(:,i) * par0(i);
end
for i = n_Real+1 : n_Total
    par_MC(:,i) = scale(:,i);
end

% Monte Carlo simulations
feature0 = ans_e_simulation(parIndex, par0, modelStruct.s.x20);

for j = 1 : n_MPSA
    parTemp=par_MC(j,1:n_Real); 
    feature = ans_e_simulation(parIndex,parTemp, modelStruct.s.x20);
    V(j) = (feature0-feature).^2;
end

% Classification of acceptable vs unacceptable simulations
flag  = zeros(n_MPSA, 1);
Sa    = zeros(n_MPSA, n_Total);
Su    = zeros(n_MPSA, n_Total);
value = zeros(n_MPSA, n_Total);

threshold = mean(V);    %mean as threshold
acc       = find(V <= threshold);
unacc     = find(V  > threshold);
flag(acc) = 1;          % assign 1 to positions under threshold

% Cumulative distributions 
for i = 1 : n_Total
    temp = [par_MC(:,i), flag];     %associate 1 to acceptable cases and 0 to unacceptable parameter values
    temp = sortrows(temp,1);        %sorts temp based on column 1
    
    value(:,i) = temp(:,1);
    Sa(:,i) = cumsum(temp(:,end));
    Su(:,i) = cumsum(-1*temp(:,end)+ones(n_MPSA,1));
    Sa(:,i) = Sa(:,i)/max(Sa(:,i));
    Su(:,i) = Su(:,i)/max(Su(:,i)); 
end

% Kolmogorov-Smirnov statistic
K_S = max(abs(Sa-Su))
bar(K_S)
title('MPSA')