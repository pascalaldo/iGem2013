% FNR.run

clear x0 tspan;

x0 = [40 5 0 0]; %(uM)
d('Initial concentrations in uM');
d(sprintf('O2: %d', x0(1)));
d(sprintf('FNR: %d', x0(2)));

% Integrate ODEs:
tspan = [0 5]; %(s)
d('Simulated time: %d seconds', tspan(2));
[t,x] = ode15s(@FNR.ode,tspan,x0); %Runge-Kutta

% Plot results:
figure; plot(t,x(:,1),t,x(:,2),t,x(:,3),t,x(:,4));
legend('O2','FNR','O2-FNR','Product');

clear x0 tspan;