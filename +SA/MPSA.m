function MPSA( varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% varargin: model,repeats,dummyNr,ifOxygen,dataType,dataID,dataType,dataID
%           1     2       3        4       5         6     7        8
celldisp(varargin);

% get the model directory and intialize the model
modelDir = sprintf('%s.ODE.initialize()',varargin{1});
M = eval(modelDir);

n_Real = 0;
par0 = double.empty;                        % initialize par0 for origianl values

repeats = varargin{2};
dummyNr = varargin{3};

if strcmp(varargin{4},'oxygenOn')
    par0 = M.oxygen;
    n_Real = n_Real + 1;
end

if strcmp(varargin{5},'values')||strcmp(varargin{7},'values')
% determine if the values of varargin{5} and varargin{7} are 'rates'
    if strcmp(varargin{5},'values')
        dataID = varargin{6};
    else
        dataID = varargin{8};
    end
    par0 = [par0;M.values(dataID)'];
    n_Real = n_Real + length(dataID);
end

if strcmp(varargin{5},'amounts')||strcmp(varargin{7},'amounts')
% determine if the values of varargin{5} and varargin{7} are 'amounts'
    if strcmp(varargin{5},'amounts')
        dataID = varargin{6};
    else
        dataID = varargin{8};
    end
    par0 = [par0;M.amounts(dataID)'];
    n_Real = n_Real + length(dataID);
end

n_Total = n_Real + dummyNr;
scale = lhsdesign(repeats, n_Total); % random uniform distributed parameter sets (values [0,1])
scale = scale * 2 - 1;          % rescale to bound (-1, 1)
scale = 10.^scale;              % rescale to logarithm

parVar = zeros(repeats, n_Real);        % parameter variations

for i = 1 : n_Real
    parVar(:,i) = scale(:,i) * par0(i);
end
for i = n_Real+1 : n_Total
    parVar(:,i) = scale(:,i);
end

feature0 = SA.getSAfeature(par0,M,varargin{[1 4 5 6 7 8]})
for j = 1 : repeats
    parTemp=parVar(j,1:n_Real); 
    feature = SA.getSAfeature(parTemp,M,varargin{[1 4 5 6 7 8]});
    V(j) = (feature0-feature).^2;
end

% Classification of acceptable vs unacceptable simulations
flag  = zeros(repeats, 1);
Sa    = zeros(repeats, n_Total);
Su    = zeros(repeats, n_Total);
value = zeros(repeats, n_Total);

threshold = mean(V);    % mean as threshold
acc       = find(V <= threshold);
unacc     = find(V  > threshold);
flag(acc) = 1;          % assign 1 to positions under threshold

% Cumulative distributions 
for i = 1 : n_Total
    temp = [parVar(:,i), flag];     %associate 1 to acceptable cases and 0 to unacceptable parameter values
    temp = sortrows(temp,1);        %sorts temp based on column 1
    
    value(:,i) = temp(:,1);
    Sa(:,i) = cumsum(temp(:,end));
    Su(:,i) = cumsum(-1*temp(:,end)+ones(repeats,1));
    Sa(:,i) = Sa(:,i)/max(Sa(:,i));
    Su(:,i) = Su(:,i)/max(Su(:,i)); 
end

% Kolmogorov-Smirnov statistic
K_S = max(abs(Sa-Su))
bar(K_S)

end