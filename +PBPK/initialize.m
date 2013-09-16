function P = initialize()
% initialize the struct for PBPK
% the structure of P looks like this:
% P
%   .info
%       .BV                             - body volume (patient specific)
%       .QC                             - cardiac output (patient specific)
%       .toID                           - map to ID of compartment
%       .compartmentCnt                 - total number of compartments
%   .arterial
%       .Q                              - portion cardiac output
%       .V                              - portion body volume [L]
%   .venous
%       .Q
%       .V
%   .venous
%   .compartments(nr)
%       .name                           - name of the tissue, e.g., 'liver'
%       .V                              - portion of body volume
%       .Q                              - portion of cardiac output
%       .K                              - tissue : plasma distribution
%       .dir                            - 1, from arterial to venous
%                                       - 0, from venous to arterial
%   .elimination

P.info.BV               = 1;        % body volume
P.info.QC               = 1;        % cardiac output
P.info.toID = containers.Map('KeyType','char','ValueType','uint32');

P.arterial.Q            = 1;
P.arterial.V            = 0.0243;
P.venous.Q              = 1;
P.venous.V              = 0.0557;

% P.compartments = struct.empty;

fileID = fopen('+PBPK/compartmentData.txt');

format = '%s %f %f %f';
% scan category: distribution from arterial to venous
data = textscan(fileID,format,'CommentStyle','//','HeaderLines',6);
n1 = length(data{2});
for i = 1:n1
    P.distribution(i).name  = data{1}{i};
    P.distribution(i).V     = data{2}(i);
    P.distribution(i).Q     = data{3}(i);
    P.distribution(i).K     = data{4}(i);
%     P.distribution(i).dir   = 1;
    P.info.toID(data{1}{i}) = i;
end
% % scan category: distribution from venous to arterial
% data = textscan(fileID,format,'CommentStyle','//','HeaderLines',3);
% n2 = length(data{2});
% for i = 1 : n2
%     P.distribution(n1+i).name  = data{1}{i};
%     P.distribution(n1+i).V     = data{2}(i);
%     P.distribution(n1+i).Q     = data{3}(i);
%     P.distribution(n1+i).K     = data{4}(i);
%     P.distribution(n1+i).dir   = 0;
%     P.info.toID(data{1}{i})    = n1 + i;
% end

P.info.compartmentCnt   = length(P.distribution);

% scan category: elimination
data = textscan(fileID,format,'CommentStyle','//','HeaderLines',3);
P.elimination.name              = data{1}{1};
P.elimination.rate              = data{2};
P.elimination.lo                = data{3};
P.elimination.hi                = data{4};

% scan category: absorption
data = textscan(fileID,format,'CommentStyle','//','HeaderLines',3);
P.absorption.name               = data{1}{1};
P.absorption.rate               = data{2};
P.absorption.lo                 = data{3};
P.absorption.hi                 = data{4};

end