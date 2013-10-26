function ores = EGFPoxygen(O2,M,ode,k,x0)
% run_EGFP
%close all

% RATE = 0.001; % the expression rate of EGFP at maximum promoter occupancy
% HALFLIFE = 26*24;  % in min
% k = log(0.5)/HALFLIFE;
% 
% M = Merged.ODE.initialize();
% ode = @Merged.ODE.ode;
% 
% x0 = M.amounts;
% 
% tspan = [0 3000]; %(min)
% M.values(M.parameters.oxygen) = 188;
% d(sprintf('Simulated time: %d minutes', tspan(2)));
% [taer,xaer] = ode45(@(t,x)ode(t,x,M),tspan,x0); %Runge-Kutta
% 
% x0 = xaer(end,:);
% M.values(M.parameters.oxygen)

% Integrate ODEs:
tspan = [0 1200]; %(min)
M.values(M.parameters.oxygen) = O2;
d(sprintf('Simulated time: %d minutes', tspan(2)));
[t,x] = ode45(@(t,x)ode(t,x,M),tspan,x0); %Runge-Kutta
rrate = Tools.expressionrate(M,x);
% tstep = t(:) - [0;t(1:end-1)];

rfunc = @(time)(interp1(t,rrate,time,'linear'));
startrate = @(~)(0.1567);

odefunc = @(time,value,exprrate,degrate,ratefunc)([value*degrate*k+exprrate*ratefunc(time)]);

%trs = {};
%xrs = {};
x0r = [0];

for i=1:-1:0
    [rresst xresst] = ode45(@(time,value)(odefunc(time,value,0.0005,i,startrate)),[0 3000],x0r);
    [tr,xr] = ode45(@(time,value)odefunc(time,value,0.0005,i,rfunc),tspan,xresst(end));
end

    function result = fitfunc(par,xdata)
        [rresstart xresstart] = ode45(@(time,value)(odefunc(time,value,par(1),1,startrate)),[0 3000],x0r);
        
        [rres xres] = ode45(@(time,value)(odefunc(time,value,par(1),1,rfunc)),tspan,xresstart(end));
        result = interp1(rres,xres,xdata);
    end

mxdata = [0, 39, 92, 174, 307, 1197];
mydata = [0.312427, 0.278675, 0.339882, 0.487498, 0.744958, 1];

%param = lsqcurvefit(@(par,xdata)fitfunc(par,xdata),[0.0005 1],mxdata,mydata,[0 0],[2 2])

problem = createOptimProblem('lsqcurvefit','objective', ...
@(par,xdata)fitfunc(par,xdata),'x0',[0.5],'lb',[0],'ub',[1], ...
'xdata',mxdata,'ydata',mydata);
ms = MultiStart;%('PlotFcns',@gsplotbestf);
[param,errormulti] = run(ms,problem,5);

ores = errormulti;

end