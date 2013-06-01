% dataGen - to generate the network data for stochastic simulation
% for use in iGEM 2013
% Created by Yicong Chen on 25 May, 2013

clear all

DEBUG=true;

% Build the species table

sbmlfile = 'data/msb20127-s3.xml';

model = sbmlimport(sbmlfile);

% Set up the struct of name-index mapping
% modelStruct.species.dna = 1;
% Notes:
% This part is written as 'modelStruct.species.name' instead of
% 'modelStruct.name' because I think this way it can be expanded easily in
% the future, for example if we want to add any compartments or some polynomials for
% calculating the mesoscopic rate.

% There are probably more suitable ways to store this information than
% structs... ;)
d('------ Species ------');
modelStruct.species = containers.Map('KeyType','uint32','ValueType','char');
modelStruct.speciesID = containers.Map('KeyType','char','ValueType','uint32');
for i=1:length(model.Species)
    modelStruct.species(i) = model.Species(i).Name;
    modelStruct.speciesID(model.Species(i).Name) = i;
    d(sprintf('Added species %d:''%s''', i, model.Species(i).Name));
end

% Set up the stoichiometry matrix
% stoichMat = sparse(zeros(#species, #reactions));
stoichMat = sparse(zeros(1));

% Set the initial condition
% species = zeros(#species,1);
% species(modelStruct.species.dna) = 1;
species = zeros(length(model.Species),1);
for i=1:length(species)
    species(i) = model.Species(i).InitialAmount;
    d(sprintf('Initial amount of species %d (%s) = %d', i, modelStruct.species(i), species(i)));
end

% Reactions
%
% Example
% reactions(#reaction_index).reactant = [1 3];  -Specify which species are used to calculate propensity
% reactions(#reaction_index).mesorate = 4;      -Set the mesoscopic constant rate of the reaction
% stoichMat(5,#reaction_index) = 1;             -Add information of stoichiometry
% stoichMat(12,#reaction_index) = -1;
%
% DNA -> T + DNA, 4
d('------ Reactions ------');
reactions(1).reactant = [modelStruct.species.DNA];
reactions(1).mesorate = 4;
stoichMat(modelStruct.species.DNA,1) = 1;

% Save the data for loading
save('data.mat','modelStruct','reactions','species','stoichMat');
clear all
