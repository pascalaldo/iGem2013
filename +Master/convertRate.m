function [mesoRate] = convertRate( M,rate,order)
% MASTER.CONVERTRATE convert the reaction rate to mesoscopic rate
% [mesoRate] = MASTER.CONVERTRATE( M,rate,order) calculates the mesoscopic rate
% constant from rate constant using the values of Avogadro's constant and 
% the volume of E.coli in M struct.
omega = (M.info.NA * M.info.volume)^order;  % the denominator
mesoRate = rate/omega;
end

