% PL calculation
clear all
close all

proLData

parname = {'k','y0'};
p = [0.074, 0.95];      % Result of MLE, optimum value
resnorm = 0.491;        % Result of MLE, optimum value
% Profile Likelihood
func = @(p)decay_fit(p,texp,ydata); %cost function for model fitting
thresh = chi2inv(0.5,length(p)); %threshold - chi square distribution
lb = [0 0]; %lower bounds for parameter estimation (lsqnonlin)
ub = []; %upper bounds for parameter estimation (lsqnonlin)
optimoptions = []; %options for optimization (lsqnonlin)
minStep = 0.01; %minimal step factor
maxStep = 0.1; %maximal step factor
minChange = 0.01; %minimal change of resnorm
maxChange = 1; %maximal change of resnorm
nr = 10; %no. of samples in profile likelihood

% PL for parameters in the increasing direction
maxPar = [2 2]; %max values parameters
for i=1:length(p)
[plPar,plRes]=proL(func,p,i,maxPar(i),thresh,lb,ub,optimoptions,minStep,maxStep,minChange,maxChange,nr);
parInc{i} = plPar;
resInc{i} = plRes;
end
% PL for parameters in the decreasing direction
maxPar = 0.1*p;
for i=1:length(p)
[plPar,plRes]=proL(func,p,i,maxPar(i),thresh,lb,ub,optimoptions,minStep,maxStep,minChange,maxChange,nr);
parDec{i} = fliplr(plPar);
resDec{i} = fliplr(plRes);
end

figure
for i=1:length(p)
subplot(2,2,i)
plot([parDec{i} parInc{i}], [resDec{i} resInc{i}], 'Linewidth',2);
hold on
plot(p(i),resnorm,'*r')
plot([parDec{i}(1) parInc{i}(end)], [thresh thresh], '--k')
xlabel(parname(i));ylabel('\chi^2_{PL}');
end