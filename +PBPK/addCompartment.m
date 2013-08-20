function P = addCompartment(M,name,V,Q,K,dir)
% P = PBPK.addCompartment(P,name,Q,P,dir) adds compartment to struct P
% the structure of P.compartments looks like this:
% P.compartments
%       .name                           - name of the tissue, e.g., 'liver'
%       .V                              - portion of body volume
%       .Q                              - portion of cardiac output
%       .K                              - tissue : plasma distribution
%       .dir                            - 1, from arterial to venous
%                                       - 0, from venous to arterial
P = M;
i = length(P.compartments) + 1;

P.compartments(i).name  = name;
P.compartments(i).V     = V;
P.compartments(i).Q     = Q;
P.compartments(i).K     = K;
P.compartments(i).dir   = dir;

P.info.compartmentCnt = length(P.compartments);

end