function M = getOdeMat(P)
% The base of M is
% compartments(1:end),arterial,venous

n = P.info.compartmentCnt + 2;
M = zeros(n);

for i = 1:P.info.compartmentCnt
    if P.compartments(i).dir == 1   % from arterial to venous
        M(i,i) = -P.compartments(i).Q / P.compartments(i).K / P.compartments(i).V;  % blood outflow
        M(i,n-1) = P.compartments(i).Q / P.compartments(i).V;                       % blood inflow
        M(n,i) = P.compartments(i).Q / P.compartments(i).K / P.compartments(i).V;   % venous inflow
    else                            % from venous to arterial
        M(i,i) = -P.compartments(i).Q / P.compartments(i).K / P.compartments(i).V;  % blood outflow
        M(i,n) = P.compartments(i).Q / P.compartments(i).V;                         % blood inflow
        M(n-1,i) = P.compartments(i).Q / P.compartments(i).K / P.compartments(i).V; % arterial inflow
    end
end

M(n-1,n-1) = - P.arterial.Q;
M(n,n) = -P.venous.Q;

end