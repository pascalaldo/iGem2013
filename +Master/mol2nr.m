function nr = mol2nr( M,umol)
% MASTER.MOL2NR convert the molar concentration to number of molecuels
% nr = MASTER.MOL2NR( M,umol) calculates the molecular numbers from micro
% molar concentration using the values of Avogadro's constant and 
% the volume of E.coli in M struct.

nr = umol * M.info.volume * M.info.NA / 1000;
nr = round(nr);

end