function P = initialize()
% initialize the struct for PBPK
% the structure of P looks like this:
% P
%   .info
%   .compartments(nr)
%           .name
%           .in
%           .out

P.info.compartmentCnt   = 0;
P.info.BV               = 1;        % body volume
P.info.QC               = 1;        % cardiac output

P.arterial.Q            = 1;
P.arterial.V            = 0.0243;
P.venous.Q              = 1;
P.venous.V              = 0.0557

P.compartments = struct.empty;

end