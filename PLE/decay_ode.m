function dydt = decay_ode(t, y, k)

dydt(1) = -k*y(1);

dydt = dydt(:);

end

