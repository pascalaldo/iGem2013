function feature = getSAfeature( varargin )
%
% varargin: parTemp,modelStruct,model,ifOxygen,dataType,dataID,dataType,dataID

parTemp = varargin{1};
n = 0;                                  % ID counter

M = varargin{2};

if strcmp(varargin{3},'oxygenOn')
    M.oxygen = parTemp(1);
    n = n + 1;
end

if strcmp(varargin{5},'values')||strcmp(varargin{7},'values')
% determine if the values of varargin{5} and varargin{7} are 'rates'
    if strcmp(varargin{5},'values')
        dataID = varargin{6};
    else
        dataID = varargin{8};
    end
    M.values(dataID) = parTemp(dataID + n);
    n = n + length(dataID);
end

if strcmp(varargin{5},'amounts')||strcmp(varargin{7},'amounts')
% determine if the values of varargin{4} and varargin{6} are 'amounts'
    if strcmp(varargin{5},'amounts')
        dataID = varargin{6};
    else
        dataID = varargin{8};
    end
    M.amounts(dataID) = parTemp(dataID + n);
    n = n + length(dataID);
end

x0 = M.amounts;
tspan = [0 15];
odeDir = sprintf('@%s.ODE.ode',varargin{3});
ode = eval(odeDir);
[t,x] = ode45(@(t,x)ode(t,x,M),tspan,x0);

feature = polyarea(t,x(:,2));

end