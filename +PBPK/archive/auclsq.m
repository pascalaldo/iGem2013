function y=auclsq(k,P)
% the objective function for PBPK parameter optimization
% k - the partition coefficient of 
% kidney, lung

art     = 7;
ven     = 8;
M = zeros(ven);

% distribution
for i = 1:4
    M(i,i) = -P.distribution(i).Q / P.distribution(i).K / P.distribution(i).V;  % tissue outflow
    M(i,art) = P.distribution(i).Q / P.distribution(i).V;        % tissue inflow
    M(ven,i) = P.distribution(i).Q / P.distribution(i).K / P.venous.V;          % venous inflow
    M(art,art) = M(art,art) - P.distribution(i).Q / P.arterial.V;% arterial outflow
end

i = 5;
M(i,i) = -P.distribution(i).Q / k(1) / P.distribution(i).V;  % tissue outflow
M(i,art) = P.distribution(i).Q / P.distribution(i).V;        % tissue inflow
M(ven,i) = P.distribution(i).Q / k(1) / P.venous.V;          % venous inflow
M(art,art) = M(art,art) - P.distribution(i).Q / P.arterial.V;% arterial outflow

i = 6;
M(i,i) = -P.distribution(i).Q / k(2) / P.distribution(i).V;  % tissue outflow
M(i,ven) = P.distribution(i).Q / P.distribution(i).V;                       % tissue inflow
M(art,i) = P.distribution(i).Q / k(2) / P.arterial.V;        % arterial inflow
M(ven,ven) = M(ven,ven) - P.distribution(i).Q / P.venous.V;                % venous outflow


i = P.info.toID(P.elimination.name);
M(i,i) = M(i,i) - P.elimination.rate;

[t,x] = ode45(@(t,x)PBPK.ode(t,x,M),[0 50],[0 0 0 0 0 0 0 750]);

% estimate the apparent elimination rate in kidney
% [pks,pos] = findpeaks(x(:,5));
pos = find(t>0.5);
result = fit(t(pos),x(pos,7),'exp1');
Kehat = -result.b;

A = zeros(1,3);
for i=1:3
    A(i) = polyarea(t,x(:,i+4)) + x(end,i+4)/Kehat;
end
R = A./A(3);

Kauc = [2.0100    1.2180];
% y = (R(1:6) - Kauc(1:6))*(R(1:6) - Kauc(1:6))' + (10*Kehat - 10*0.049)^2;
y = R(1:2)-Kauc;
y = y(:);

end