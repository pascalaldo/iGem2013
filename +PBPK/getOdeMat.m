function M = getOdeMat(P)
% The base of M is
% compartments(1:end),arterial,venous,dose

art     = P.info.compartmentCnt + 1;
ven     = P.info.compartmentCnt + 2;
dos     = P.info.compartmentCnt + 3;
M = zeros(dos);

% distribution
for i = 1:P.info.compartmentCnt
    if P.distribution(i).dir == 1   % from arterial to venous
        M(i,i) = -P.distribution(i).Q / P.distribution(i).K / P.distribution(i).V;  % blood outflow
        M(i,art) = P.distribution(i).Q / P.distribution(i).V;                       % blood inflow
        M(ven,i) = P.distribution(i).Q / P.distribution(i).K / P.distribution(i).V; % venous inflow
    else                            % from venous to arterial
        M(i,i) = -P.distribution(i).Q / P.distribution(i).K / P.distribution(i).V;  % blood outflow
        M(i,ven) = P.distribution(i).Q / P.distribution(i).V;                       % blood inflow
        M(art,i) = P.distribution(i).Q / P.distribution(i).K / P.distribution(i).V; % arterial inflow
    end
end
M(art,art)      = - P.arterial.Q;
M(ven,ven)      = -P.venous.Q;

% elimination
i = P.info.toID(P.elimination.name);
M(i,i) = M(i,i) - P.elimination.rate;

% absorption
% i = P.info.toID(P.absorption.name);
if strcmp(P.absorption.name,'venous')
    M(ven,dos) = P.absorption.rate;
    M(dos,dos) = -P.absorption.rate;
end

end