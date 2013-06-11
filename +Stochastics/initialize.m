function M = initialize(sbmlfile)
% STOCHASTICS.INITIALIZE creates the network for a stochastic simulation.
% M = STOCHASTICS.INITIALIZE(sbmlfile) creates the network data from the 
% sbml file sbmlfile.
% The output of this function is struct M, which contains all information
% of the model. M can be used as an input argument for the function
% Stochastics.Simulate(M). The structure of M looks like this:
%
% Pascal :)
% M
%  .info
%        .volume                 - The volume of E.coli
%        .species                - The number of species in the model
%        .reactions              - The number of reactions in the model
%  .species
%          .toName(id)           - Convert species ID to a species name
%          .toID(name)           - Convert species name to a species ID
%  .stoichiometry(spec,react)    - Matrix that holds the stoichiometry
%                                  information of the reactions
%  .amounts(id)                  - The amount of molecules of each species
%  .reactions(nr)
%                .reactant       - Vector of species IDs of all reactants
%                .product        - Vector of species IDs of all products
%                .mesorate_plus  - 'Plus' reaction rate
%                .mesorate_min   - 'Min' reaction rate
%
% To enable verbose mode, set the variable DEBUG to true in your workspace.
%
% Created by the Eindhoven University of Technology 2013 iGEM Team
% Yicong Chen <y.chen.3@student.tue.nl>
% Pasal Pieters <p.a.pieters@student.tue.nl>

% Build the species table
model = sbmlimport(sbmlfile);

% M.count.species = length(model.Species);
% M.count.reactions = length(model.Reactions);
% modified by Yicong
M.info.species = length(model.Species);
M.info.reactions = length(model.Reactions);
M.info.volume = 0.6E-15;    % the volume of E.ocli in L
M.info.NA = 6.023E23;       % the Avogadro's constant

%% Species
% Set up the struct of name-index mapping
% Notes:
% This part is written as 'modelStruct.species.name' instead of
% 'modelStruct.name' because I think this way it can be expanded easily in
% the future, for example if we want to add any compartments or some polynomials for
% calculating the mesoscopic rate.
d('------ Species ------');
M.species.toName = containers.Map('KeyType','uint32','ValueType','char');
M.species.toID = containers.Map('KeyType','char','ValueType','uint32');
for i=1:M.info.species;
    r = model.Species(i);
    M.species.toName(i) = r.Name;
    M.species.toID(r.Name) = i;
    d(sprintf('Added species %d:''%s''', i, r.Name));
end

% Set up the stoichiometry matrix
M.stoichiometry = sparse(zeros(M.info.species,M.info.reactions));

% Set the initial condition
M.amounts = zeros(M.info.species,1);
for i=1:M.info.species
    M.amounts(i) = model.Species(i).InitialAmount;
    d(sprintf('Initial amount of %s = %d', M.species.toName(i), M.amounts(i)));
end

%% Reactions
%
d('------ Reactions ------');
M.reactions = repmat(struct(),M.info.reactions,1);
for i=1:M.info.reactions
    r = model.Reactions(i);
    M.reactions(i).equation = r.Reaction;
    % Add the reactants
    for j=1:length(r.Reactants)
        M.reactions(i).reactant(j) = M.species.toID(r.Reactants(j).Name);
        % Update the stoichiometry matrix
        M.stoichiometry(M.species.toID(r.Reactants(j).Name), i) = r.Stoichiometry(j);
    end
    for j=1:length(r.Products)
        M.reactions(i).product(j) = M.species.toID(r.Products(j).Name);
        % Update the stoichiometry matrix. r.Stoichiometry is a vector with
        % first the values for the reactants and after that the values for
        % the products. That's why length(r.Reactants) is added to the
        % index of r.Stoichiometry.
        M.stoichiometry(M.species.toID(r.Products(j).Name), i) = r.Stoichiometry(length(r.Reactants)+j);
    end
    for j=1:length(r.KineticLaw.Parameters)
        % Get the values for the parameters. The parameters are usually
        % named k*+ and k*- (where * is for example s or n). To check which
        % rate the parameter expresses, check the last character of the
        % name (+ or -). This isn't very elegant, but it works.
        if r.KineticLaw.Parameters(j).Name(end) == '+'
            M.reactions(i).mesorate_plus = r.KineticLaw.Parameters(j).Value;
        else
            M.reactions(i).mesorate_min = r.KineticLaw.Parameters(j).Value;
        end
    end
    d(sprintf('Added reaction %d:''%s''\n\t%s', i, r.Name, r.Reaction));
end

end