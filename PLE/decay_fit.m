function e = decay_fit(p, texp, ydata)

k = p(1);
y0 = p(2);

[t y] = ode45(@decay_ode, texp, y0, [], k);

e = ydata(:)-y(:);      % error

end

