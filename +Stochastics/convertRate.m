function [mesoRate] = convertRate( M,rate,order)
% convertRate convert the reaction rate to mesoscopic rate
% [mesoRate] = convertRate( M,rate,order) calculates the mesoscopic rate
% constant from rate constant using the values of Avogadro's constant and 
% the volume of E.coli in M struct.
omega = (M.info.NA * M.info.volume)^order;  % the denominator
mesoRate = rate/omega;
end

