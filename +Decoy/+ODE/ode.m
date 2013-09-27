function f = ode(t,x,O)
% f = Decoy.ODE.ode(t,x,O) includes the differential equations extracted
% from model struct O.
% O can be generated by Decoy.ODE.initialize()
% The output of this ode is:

f = zeros(O.info.species,1);

di = x(O.species.TN)*O.values(O.parameters.Knmin) - x(O.species.N)*x(O.species.T)*O.values(O.parameters.Knplus);
f(O.species.T) = f(O.species.T) + di;
f(O.species.N) = f(O.species.N) + di;
f(O.species.TN) = f(O.species.TN) - di;

di = x(O.species.TP)*O.values(O.parameters.Ktpmin) - x(O.species.P)*x(O.species.T)*O.values(O.parameters.Ktpplus);
f(O.species.T) = f(O.species.T) + di;
f(O.species.P) = f(O.species.P) + di;
f(O.species.TP) = f(O.species.TP) - di;

di = x(O.species.PT)*O.values(O.parameters.Kptmin) - x(O.species.P)*x(O.species.T)*O.values(O.parameters.Kptplus);
f(O.species.T) = f(O.species.T) + di;
f(O.species.P) = f(O.species.P) + di;
f(O.species.PT) = f(O.species.PT) - di;

di = x(O.species.TPT)*O.values(O.parameters.Ktp_tptmin) - x(O.species.TP)*x(O.species.T)*O.values(O.parameters.Ktp_tptplus);
f(O.species.T) = f(O.species.T) + di;
f(O.species.TP) = f(O.species.TP) + di;
f(O.species.TPT) = f(O.species.TPT) - di;

di = x(O.species.TPT)*O.values(O.parameters.Kpt_tptmin) - x(O.species.PT)*x(O.species.T)*O.values(O.parameters.Kpt_tptplus);
f(O.species.T) = f(O.species.T) + di;
f(O.species.PT) = f(O.species.PT) + di;
f(O.species.TPT) = f(O.species.TPT) - di;

f = f(:);

end