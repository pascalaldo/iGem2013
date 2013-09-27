function [ r ] = expressionrate( M, x )
%EXPRESSIONRATE Summary of this function goes here
%   Detailed explanation goes here

factor_tpt = M.values(M.parameters.expression_tpt);
factor_pt = M.values(M.parameters.expression_pt);

r = x(:,M.species.TP)+factor_tpt.*x(:,M.species.TPT)+factor_pt.*x(:,M.species.PT);

end
