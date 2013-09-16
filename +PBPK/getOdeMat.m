function M = getOdeMat(P)
% The base of M is
% compartments(1:end),arterial,venous,dose

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
            M(i,i) = M(i,i)-P.distribution(i).Q / P.distribution(i).K / P.distribution(i).V;  % tissue outflow
            M(i,ven) = P.distribution(i).Q / P.distribution(i).V;                       % tissue inflow
            M(art,i) = P.distribution(i).Q / P.distribution(i).K / P.arterial.V;        % arterial inflow
            M(ven,ven) = M(ven,ven) - P.distribution(i).Q / P.venous.V ;                % venous outflow
        else
            M(i,i) = M(i,i)-P.distribution(i).Q / P.distribution(i).K / P.distribution(i).V;  % tissue outflow
            M(i,art) = P.distribution(i).Q / P.distribution(i).V;                       % tissue inflow
            M(ven,i) = P.distribution(i).Q / P.distribution(i).K / P.venous.V;          % venous inflow
            M(art,art) = M(art,art) - P.distribution(i).Q / P.arterial.V;               % arterial outflow
        end
    else
        if i == li
            M(i,i) = M(i,i) -P.distribution(i).Q / P.distribution(i).K / P.distribution(i).V;  % liver outflow
            M(i,art) = (P.distribution(i).Q - P.distribution(sp).Q) / P.distribution(i).V;     % liver inflow
            M(i,sp)  = P.distribution(sp).Q / P.distribution(sp).K / P.distribution(i).V;      % liver inflow
            M(ven,i) = P.distribution(i).Q / P.distribution(i).K / P.venous.V;                 % venous inflow
%             M(art,art) = M(art,art) - (P.distribution(i).Q - P.distribution(sp).Q) / P.arterial.V ; % arterial outflow
            M(art,art) = M(art,art) - P.distribution(i).Q  / P.arterial.V;                      % arterial outflow including spleen
        else % P.distribution.name = 'spleen'
            M(i,i) = M(i,i) -P.distribution(i).Q / P.distribution(i).K / P.distribution(i).V;  % spleen outflow
            M(i,art)  = P.distribution(i).Q / P.distribution(i).V;                             % spleen inflow
%             M(art,art) = M(art,art) - P.distribution(i).Q / P.venous.V ;                       % arterial outflow
        end
    end
end

% M(art,art)      = - P.arterial.Q;
% M(ven,ven)      = -P.venous.Q;

% elimination
i = P.info.toID(P.elimination.name);
M(i,i) = M(i,i) - P.elimination.rate;

% absorption
% i = P.info.toID(P.absorption.name);
% if strcmp(P.absorption.name,'venous')
%     M(ven,dos) = P.absorption.rate;
%     M(dos,dos) = -P.absorption.rate;
% end

end