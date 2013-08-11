function [megaRatePlus,megaRateMin] = meso2mega( M, n)
%TOOLS.MESO2MEGA changes the mesoscopic rate to rate constant
%   [megaRatePlus,megaRateMin] = meso2mega( M,n )
%   M               - the stochastic model struct
%   n               - the index of reaction
%   megaRatePlus    - the rate constant of forward reaction
%   megaRateMin     - the rate constant of backward reaction

%% Calculate megaRatePlus
    order = length(M.reactions(n).reactant) - 1;
    omega = (M.info.NA * M.info.volume / 1000000)^order;
    megaRatePlus = M.reactions(n).mesorate_plus(0) * omega;
    
%% Calculate megaRateMin
    order = length(M.reactions(n).product) - 1;
    omega = (M.info.NA * M.info.volume / 1000000)^order;
    megaRateMin = M.reactions(n).mesorate_min(0) * omega;
end

