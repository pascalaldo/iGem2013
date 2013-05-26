% dataGen - to generate the network data for stochastic simulation
% for use in iGEM 2013
% Created by Yicong Chen on 25 May, 2013

clear all

% Build the species table

% Set up the struct of name-index mapping
% modelStruct.species.dna = 1;
% Notes:
% This part is written as 'modelStruct.species.name' instead of
% 'modelStruct.name' because I think this way it can be expanded easily in
% the future, for example if we want to add any compartments or some polynomials for
% calculating the mesoscopic rate.
modelStruct.species.T   = 1;
modelStruct.species.TN  = 2;
modelStruct.species.TP  = 3;
modelStruct.species.N   = 4;
modelStruct.species.DNA = 4;

% Set up the stoichiometry matrix
% stoichMat = sparse(zeros(#species, #reactions));
stoichMat = sparse(zeros(1));

% Set the initial condition
% species = zeros(#species,1);
% species(modelStruct.species.dna) = 1;
species = zeros(5,1);

% Reactions
%
% Example
% reactions(#reaction_index).reactant = [1 3];  -Specify which species are used to calculate propensity
% reactions(#reaction_index).mesorate = 4;      -Set the mesoscopic constant rate of the reaction
% stoichMat(5,#reaction_index) = 1;             -Add information of stoichiometry
% stoichMat(12,#reaction_index) = -1;
%
% DNA -> T + DNA, 4
reactions(1).reactant = [modelStruct.species.DNA];
reactions(1).mesorate = 4;
stoichMat(modelStruct.species.DNA,1) = 1;

% Save the data for loading
save('data.mat','modelStruct','reactions','species','stoichMat');
clear all
