function [Sa,Su]=MPSA( varargin )
%SA.MPSA Global Sensitivity Analysis
%parameters
%   SA.MPSA(varargin) runs a global sensitivity analysis over the chosen
%   parameters
% 
% SA.MPSA(modelType,repeats,outputOfInterest,dataType,dataNr,dataType,dataNr,
% dataType,dataNr)
% NOTE:
% At least one dataType(values/amounts) should be specified to run a proper
% sensitivity analysis. Also make sure that the outputOfInterest EXIST in
% the chosen modelType.
% a fully-specified example:
% SA.MPSA('Merged',5,'TP','dummy',1,'values',[1 2 3],'amounts',[1 2])

%% load values from varargin or default
modelType   = varargin{1};
repeats     = varargin{2};
outName       = varargin{3};
i = 5;
while i <= nargin
    switch varargin{i-1}
        case 'dummy'
            dummyNr = varargin{i};
        case 'values'
            valuesID = varargin{i};
        case 'amounts'
            amountsID = varargin{i};
    end
    i = i + 2;
end
if ~exist('dummyNr','var')
    dummyNr = 0;
end
if ~exist('valuesID','var')
    valuesID = 0;
end
if ~exist('amountsID','var')
    amountsID = 0;
end

%% get the model directory and intialize the model
modelDir = sprintf('%s.ODE.initialize()',modelType);
M = eval(modelDir);

n_Real      = 0;
par0        = double.empty;                        % initialize par0 for origianl values
par0        = [par0;M.values(valuesID)];
n_Real      = n_Real + length(valuesID);
par0        = [par0;M.amounts(amountsID)];
n_Real      = n_Real + length(amountsID);
n_Total     = n_Real + dummyNr;
outID       = M.species.toID(outName);

%% perform sensitivity analysis
scale = lhsdesign(repeats, n_Total);                % random uniform distributed parameter sets (values [0,1])
scale = scale * 2 - 1;          % rescale to bound (-1, 1)
scale = 10.^scale;              % rescale to logarithm

parVar = zeros(repeats, n_Real);        % parameter variations

for i = 1 : n_Real
    parVar(:,i) = scale(:,i) * par0(i);
end
for i = n_Real+1 : n_Total
    parVar(:,i) = scale(:,i);
end

feature0 = SA.getSAfeature(par0,M,outID,valuesID,amountsID);
for j = 1 : repeats
    disp(j)
    parTemp=parVar(j,1:n_Real); 
    feature = SA.getSAfeature(parTemp,M,outID,valuesID,amountsID);
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