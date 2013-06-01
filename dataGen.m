% dataGen - to generate the network data for stochastic simulation
% for use in iGEM 2013
% Created by Yicong Chen on 25 May, 2013

clear all

DEBUG=true;

% Build the species table

sbmlfile = 'data/msb20127-s3.xml';

model = sbmlimport(sbmlfile);

%% Species
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
    r = model.Species(i);
    modelStruct.species(i) = r.Name;
    modelStruct.speciesID(r.Name) = i;
    d(sprintf('Added species %d:''%s''', i, r.Name));
end

% Set up the stoichiometry matrix
% stoichMat = sparse(zeros(#species, #reactions));
stoichMat = sparse(zeros(length(model.Species),length(model.Reactions)));

% Set the initial condition
% species = zeros(#species,1);
% species(modelStruct.species.dna) = 1;
species = zeros(length(model.Species),1);
for i=1:length(species)
    species(i) = model.Species(i).InitialAmount;
    d(sprintf('Initial amount of species %d (%s) = %d', i, modelStruct.species(i), species(i)));
end

%% Reactions
%
% Example
% reactions(#reaction_index).reactant = [1 3];  -Specify which species are used to calculate propensity
% reactions(#reaction_index).mesorate = 4;      -Set the mesoscopic constant rate of the reaction
% stoichMat(5,#reaction_index) = 1;             -Add information of stoichiometry
% stoichMat(12,#reaction_index) = -1;
%
% DNA -> T + DNA, 4
d('------ Reactions ------');
reactions = repmat(struct(),length(model.Reactions),1);
for i=1:length(model.Reactions)
    r = model.Reactions(i);
    % Add the reactants
    for j=1:length(r.Reactants)
        reactions(i).reactant(j) = modelStruct.speciesID(r.Reactants(j).Name);
        % Update the stoichiometry matrix
        stoichMat(modelStruct.speciesID(r.Reactants(j).Name), i) = r.Stoichiometry(j);
    end
    for j=1:length(r.Products)
        reactions(i).product(j) = modelStruct.speciesID(r.Products(j).Name);
        % Update the stoichiometry matrix. r.Stoichiometry is a vector with
        % first the values for the reactants and after that the values for
        % the products. That's why length(r.Reactants) is added to the
        % index of r.Stoichiometry.
        stoichMat(modelStruct.speciesID(r.Products(j).Name), i) = r.Stoichiometry(length(r.Reactants)+j);
    end
    for j=1:length(r.KineticLaw.Parameters)
        % Get the values for the parameters. The parameters are usually
        % named k*+ and k*- (where * is for example s or n). To check which
        % rate the parameter expresses, check the last character of the
        % name (+ or -). This isn't very elegant, but it works.
        if r.KineticLaw.Parameters(j).Name(end) == '+'
            reactions(i).mesorate_plus = r.KineticLaw.Parameters(j).Value;
        else
            reactions(i).mesorate_min = r.KineticLaw.Parameters(j).Value;
        end
    end
    d(sprintf('Added reaction %d:''%s''\n\t%s', i, r.Name, r.Reaction));
end

% Save the data for loading
save('data.mat','modelStruct','reactions','species','stoichMat');
clear all
