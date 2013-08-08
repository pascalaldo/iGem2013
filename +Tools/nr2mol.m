function [ umol ] = nr2mol( M,nr )
%TOOLS.NR2MOL converts the molecule number to micro molar concentration
%   [ umol ] = Master.nr2mol( M,nr ) is used to get the initial
%   concentrations in the ODE simulation of decoy sites.

umol = nr ./ M.info.volume ./ M.info.NA .* 1000000;

end

