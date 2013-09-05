function y=elsq(k,P,M)
% the objective function for PBPK parameter optimization
% k - the elimination rate of kidney


i = P.info.toID(P.elimination.name);
M(i,i) = M(i,i) + P.elimination.rate;
M(i,i) = M(i,i) - k;

[t,x] = ode45(@(t,x)PBPK.ode(t,x,M),[0 50],[0 0 0 0 0 0 0 750]);

[~,pos]=findpeaks(x(:,5));
result = fit(t(pos:end),x(pos:end,5),'exp1');
Kehat = -result.b;

y = Kehat-0.049;

end