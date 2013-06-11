function kmeso = convertRate( k, volume, reactantscount )
%CONVERTRATE Converts a macroscopic reaction rate to a mesoscopic rate

NA = 6.022141e23; % Define Avogadros Number

kmeso = k*(NA*volume)^(reactantscount-1);

end

