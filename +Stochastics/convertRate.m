<<<<<<< HEAD
function [mesoRate] = convertRate( M,rate,order)
% convertRate convert the reaction rate to mesoscopic rate
% [mesoRate] = convertRate( M,rate,order) calculates the mesoscopic rate
% constant from rate constant using the values of Avogadro's constant and 
% the volume of E.coli in M struct.
omega = (M.info.NA * M.info.volume)^order;  % the denominator
mesoRate = rate/omega;
=======
function kmeso = convertRate( k, volume, reactantscount )
%CONVERTRATE Converts a macroscopic reaction rate to a mesoscopic rate

NA = 6.022141e23; % Define Avogadros Number

kmeso = k*(NA*volume)^(reactantscount-1);

>>>>>>> 86dd5306134f9f8bf3ae1825b8ad5e2c196b4887
end

