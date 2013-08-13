function M = setup(S)

M = S;

M.stoichiometry(M.species.N,M.reaction.VoidpN_TN) = -1;
M.stoichiometry(M.species.TN,M.reaction.VoidpN_TN) = 1;

M.stoichiometry(M.species.P,M.reaction.VoidpP_TP) = -1;
M.stoichiometry(M.species.TP,M.reaction.VoidpP_TP) = 1;

d(sprintf('Reaction %d:', M.reaction.VoidpN_TN));
M.reactions(M.reaction.VoidpN_TN).equation = 'Void + N <- TN';
M.reactions(M.reaction.VoidpN_TN).reactant = [M.species.Void M.species.N];
M.reactions(M.reaction.VoidpN_TN).product = M.species.TN;
M.reactions(M.reaction.VoidpN_TN).mesorate_plus = @(env,x1,x3,x6)( 0 );
M.reactions(M.reaction.VoidpN_TN).mesorate_min = @(env,x1,x3,x6)( M.par.b31(env) );
d(M.reactions(M.reaction.VoidpN_TN).equation);

d(sprintf('Reaction %d:', M.reaction.VoidpP_TP));
M.reactions(M.reaction.VoidpP_TP).equation = 'Void + P <- TP';
M.reactions(M.reaction.VoidpP_TP).reactant = [M.species.Void M.species.P];
M.reactions(M.reaction.VoidpP_TP).product = M.species.TP;
M.reactions(M.reaction.VoidpP_TP).mesorate_plus = @(env,x1,x3,x6)( 0 );
M.reactions(M.reaction.VoidpP_TP).mesorate_min = @(env,x1,x3,x6)( M.par.b31(env) );
d(M.reactions(M.reaction.VoidpP_TP).equation);

end