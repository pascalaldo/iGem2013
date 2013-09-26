function promotor_comp()
%PROMOTOR Summary of this function goes here
%   Detailed explanation goes here

M = Merged.ODE.initialize();

Kon = 0.099345131816798; Koff = 0.009847254228745;

%% Changes for FNR-single
% Remove decoy sites
M.amounts(M.species.N,:) = 0;
M.amounts(M.species.TN,:) = 0;
M.amounts(M.species.N0,:) = 0;
M.amounts(M.species.TP,:) = 0;
M.amounts(M.species.PT,:) = 0;
M.values(M.parameters.Kptplus) = 0;
M.values(M.parameters.Kptmin) = 0;
M.values(M.parameters.Ktp_tptplus) = 0;
M.values(M.parameters.Ktp_tptmin) = 0;
M.values(M.parameters.Kpt_tptplus) = 0;
M.values(M.parameters.Kpt_tptmin) = 0;
M.amounts(M.species.TPT,:) = 0;

M.values(M.parameters.Ktpplus) = Kon;
M.values(M.parameters.Ktpmin) = Koff;

%M.values(M.)

M.oxygen = 0;
M.info.oxygen = 0;

d(sprintf('%f', M.amounts(M.species.P)));

x0 = M.amounts;

tspan = [0 500]; %(min)
d(sprintf('Simulated time: %d minutes', tspan(2)));
[ts,xs] = ode45(@(t,x)Merged.ODE.ode(t,x,M),tspan,x0); %Runge-Kutta


M.values(M.parameters.Kptplus) = Kon;
M.values(M.parameters.Kptmin) = Koff;
M.values(M.parameters.Ktp_tptplus) = Kon;
M.values(M.parameters.Ktp_tptmin) = Koff;
M.values(M.parameters.Kpt_tptplus) = Kon;
M.values(M.parameters.Kpt_tptmin) = Koff;

M.values(M.parameters.expression_pt) = 0;

tspan = [0 500]; %(min)
d(sprintf('Simulated time: %d minutes', tspan(2)));
[tt,xt] = ode45(@(t,x)Merged.ODE.ode(t,x,M),tspan,x0); %Runge-Kutta

figure;
plot(ts, xs);

figure;
plot(ts, xs(:,M.species.TP,:), 'r-', tt, Tools.expressionrate(M,xt), 'g-');
hold on;
plot(ts, interp1(tt,Tools.expressionrate(M,xt),ts)./xs(:,M.species.TP,:), 'b-');

    function y = modelfunc(par,xdata,S,xtf, xsend)
        S.values(S.parameters.expression_tpt) = par(1);
        S.values(S.parameters.expression_pt) = 0;%par(2);
                
        temp = Tools.expressionrate(S,xtf);
        y = temp(end,1)/xsend;
        end

xdata = [0];
ydata = [1.8];

par0 = [1]; %1];%[M.rates(M.reaction.TpP_TP).megaRatePlus M.rates(M.reaction.TpP_TP).megaRateMin];
parlb = [0]; %0];
parub = [10]; %10];

par = lsqcurvefit(@(par,xdata)(modelfunc(par,xdata,M,xt,xs(end,M.species.TP))),par0,xdata,ydata,parlb,parub);

par

M.values(M.parameters.expression_tpt) = par(1);
%M.values(S.parameters.expression_pt) = par(2);

figure;
plot(ts, xs(:,M.species.TP,:), 'r-', tt, Tools.expressionrate(M,xt), 'g-');
hold on;
plot(ts, interp1(tt,Tools.expressionrate(M,xt),ts)./xs(:,M.species.TP), 'b-');

end
