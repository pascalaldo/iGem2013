function y=glblsq(k,P)
% the objective function for PBPK parameter optimization
% k - the partition coefficient of 
% kidney, lung

tempa = max(k);
tempb = min(k);
k = [k(1:5),tempa,tempb,k(end)];

art     = P.info.compartmentCnt + 1;
ven     = P.info.compartmentCnt + 2;
li      = P.info.toID('liver');
sp      = P.info.toID('spleen');
% dos     = P.info.compartmentCnt + 3;
% M = zeros(dos);
M = zeros(ven);

% distribution
for i = 1:P.info.compartmentCnt
    if i ~= li && i ~= sp
        if strcmp(P.distribution(i).name,'lung')   % from venous to arterial
            M(i,i) = M(i,i)-P.distribution(i).Q / k(i) / P.distribution(i).V;  % tissue outflow
            M(i,ven) = P.distribution(i).Q / P.distribution(i).V;                       % tissue inflow
            M(art,i) = P.distribution(i).Q / k(i) / P.arterial.V;        % arterial inflow
            M(ven,ven) = M(ven,ven) - P.distribution(i).Q / P.venous.V ;                % venous outflow
        else
            M(i,i) = M(i,i)-P.distribution(i).Q / k(i) / P.distribution(i).V;  % tissue outflow
            M(i,art) = P.distribution(i).Q / P.distribution(i).V;                       % tissue inflow
            M(ven,i) = P.distribution(i).Q / k(i) / P.venous.V;          % venous inflow
            M(art,art) = M(art,art) - P.distribution(i).Q / P.arterial.V;               % arterial outflow
        end
    else
        if i == li
            M(i,i) = M(i,i) -P.distribution(i).Q / k(i) / P.distribution(i).V;  % liver outflow
            M(i,art) = (P.distribution(i).Q - P.distribution(sp).Q) / P.distribution(i).V;     % liver inflow
            M(i,sp)  = P.distribution(sp).Q / k(sp) / P.distribution(i).V;      % liver inflow
            M(ven,i) = P.distribution(i).Q / k(i) / P.venous.V;                 % venous inflow
%             M(art,art) = M(art,art) - (P.distribution(i).Q - P.distribution(sp).Q) / P.arterial.V ; % arterial outflow
            M(art,art) = M(art,art) - P.distribution(i).Q  / P.arterial.V;                      % arterial outflow including spleen
        else % P.distribution.name = 'spleen'
            M(i,i) = M(i,i) -P.distribution(i).Q / k(i) / P.distribution(i).V;  % spleen outflow
            M(i,art)  = P.distribution(i).Q / P.distribution(i).V;                             % spleen inflow
%             M(art,art) = M(art,art) - P.distribution(i).Q / P.venous.V ;                       % arterial outflow
        end
    end
end

% elimination
i = P.info.toID(P.elimination.name);
M(i,i) = M(i,i) - k(end);

[t,x] = ode45(@(t,x)PBPK.ode(t,x,M),[0 50],[0 0 0 0 0 0 0 0 750]);

% estimate the apparent elimination rate in kidney
ki = P.info.toID('kidney');
pos = find(t>5);
result = fit(t(pos),x(pos,ki),'exp1');
Kehat = -result.b;

A = zeros(1,9);
for i=1:9
    A(i) = polyarea(t,x(:,i)) + x(end,i)/Kehat;
%     A(i) = polyarea(t,x(:,i));
end
R = A./A(9);
Kauc = [0.1150 2.0100 0.7087 1.1676 1.2180];
y = R(1:5) - Kauc;
y(6) = (Kehat - 0.049)*10;
y = y(:);

end