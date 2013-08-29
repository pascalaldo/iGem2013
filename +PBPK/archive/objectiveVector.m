function y=objectiveVector(k,P)
% the objective function for PBPK parameter optimization
% k - the partition coefficient of 
% brain, heart, liver, spleen, kidney, lung and elimination rate in kidney

% Ke = [0.0172 0.0173 0.0247 0.0223 0.0267 0.0059];

% art     = P.info.compartmentCnt + 1;
% ven     = P.info.compartmentCnt + 2;
% dos     = P.info.compartmentCnt + 3;
% M = zeros(dos);
art     = 7;
ven     = 8;
M = zeros(ven);

% distribution
% for i = 1:P.info.compartmentCnt
for i = 1:6
    if P.distribution(i).dir == 1   % from arterial to venous
        M(i,i) = -P.distribution(i).Q / k(i) / P.distribution(i).V;  % tissue outflow
        M(i,art) = P.distribution(i).Q / P.distribution(i).V;        % tissue inflow
        M(ven,i) = P.distribution(i).Q / k(i) / P.venous.V;          % venous inflow
        M(art,art) = M(art,art) - P.distribution(i).Q / P.arterial.V;% arterial outflow
    else                            % from venous to arterial
        M(i,i) = -P.distribution(i).Q / k(i) / P.distribution(i).V;  % tissue outflow
        M(i,ven) = P.distribution(i).Q / P.distribution(i).V;        % tissue inflow
        M(art,i) = P.distribution(i).Q / k(i) / P.arterial.V;        % arterial inflow
        M(ven,ven) = M(ven,ven) - P.distribution(i).Q / P.venous.V ; % venous outflow
    end
end

i = P.info.toID(P.elimination.name);
M(i,i) = M(i,i) - k(7);

[t,x] = ode45(@(t,x)PBPK.ode(t,x,M),[0 50],[0 0 0 0 0 0 0 750]);

% estimate the apparent elimination rate in kidney
% [pks,pos] = findpeaks(x(:,5));
pos = find(t>0.5);
result = fit(t(pos),x(pos,5),'exp1');
Kehat = -result.b;

A = zeros(1,8);
for i=1:8
    A(i) = polyarea(t,x(:,i)) + x(end,i)/Kehat;
end
R = A./A(8);

Kauc = [0.1150    0.9514    0.7087    1.1676    2.0100    1.2180];
% y = (R(1:6) - Kauc(1:6))*(R(1:6) - Kauc(1:6))' + (10*Kehat - 10*0.049)^2;
y = [R(1:6) - Kauc(1:6) 10*(Kehat - 0.049)]';

end