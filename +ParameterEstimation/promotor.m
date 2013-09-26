function par = promotor()
%PROMOTOR Summary of this function goes here
%   Detailed explanation goes here

M = Decoy.ODE.initialize();

%% Changes
% Remove decoy sites
M.amounts(M.species.N,:) = 0;
M.amounts(M.species.TN,:) = 0;
M.amounts(M.species.N0,:) = 0;
M.amounts(M.species.TP,:) = 0;
M.values(M.parameters.Ktpplus) = 0;
M.values(M.parameters.Ktpmin) = 0;
M.amounts(M.species.PT,:) = 0;
M.values(M.parameters.Kptplus) = 0;
M.values(M.parameters.Kptmin) = 0;
M.values(M.parameters.Ktp_tptplus) = 0;
M.values(M.parameters.Ktp_tptmin) = 0;
M.values(M.parameters.Kpt_tptplus) = 0;
M.values(M.parameters.Kpt_tptmin) = 0;
M.amounts(M.species.TPT,:) = 0;
M.amounts(M.species.P,:) = 0.005; % 5 nM 48bp concensus sites
M.amounts(M.species.P0,:) = 0.005; % 5 nM 48bp concensus sites

%M.values(M.)

M.oxygen = 0;
M.info.oxygen = 0;

    function y = modelfunc(par,xdata,S)
        d(sprintf('Plus: %f; Min: %f',par(1),par(2)))
        xs = zeros(length(xdata),S.info.species);
        S.values(S.parameters.Ktpplus) = par(1);
        S.values(S.parameters.Ktpmin) = par(2);
        %S.rates(S.reaction.TpP_TP).megaRatePlus = par(1);
        %S.rates(S.reaction.TpP_TP).megaRateMin = par(2);
        
        for i=1:length(xdata)
            S.amounts(S.species.T,:) = xdata(i);
            S.amounts(S.species.T0,:) = xdata(i);
            
            xs(i,:) = Tools.steadystate(30, S);
        end
        y = (xs(:,S.species.TP)./xs(:,S.species.P0))';
        %figure(1);
        %plot(xdata,y,'r-',xdata,ydata,'b.');
        %disp(par);
    end

xdata = [0 0.12 0.23 0.47 0.94 1.8];
ydata = [0 13.1 46.6 73.8 86.4 90.3]./100;

par0 = [0.0994 0.0099];%[M.rates(M.reaction.TpP_TP).megaRatePlus M.rates(M.reaction.TpP_TP).megaRateMin];
parlb = [0 0];
parub = [10 10];

problem = createOptimProblem('lsqcurvefit','objective', ...
@(par,xdata)(modelfunc(par,xdata,M)),'x0',par0,'lb',parlb,'ub',parub, ...
'xdata',xdata,'ydata',ydata);
ms = MultiStart;%('PlotFcns',@gsplotbestf);
[parms,errormulti] = run(ms,problem,15);

%gs = GlobalSearch;%('PlotFcns',@gsplotbestf);
%[pargs,errorglobal] = run(gs,problem);

par = lsqcurvefit(@(par,xdata)(modelfunc(par,xdata,M)),parms,xdata,ydata,parlb,parub);

res0 = modelfunc(par0,xdata,M);
resms = modelfunc(parms,xdata,M);
res = modelfunc(par,xdata,M);
%resgs = modelfunc(pargs,xdata,M);
figure(1);plot(xdata,resms,'r-',xdata,res,'m-',xdata,res0,'g-',xdata,ydata,'b.'); %

end
