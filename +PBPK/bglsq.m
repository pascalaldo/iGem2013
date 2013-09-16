function y=bglsq(k,t)
% the objective function of bacteria growth

y = k(3) * tanh(k(1) * t + k(2));

end