% FNR.run

clear x0 tspan;

x0 = [5 0 40]; %(uM) [FNR O2-FNR O2]
d('Initial concentrations in uM');
d(sprintf('O2: %d', x0(3)));
d(sprintf('FNR: %d', x0(1)));

% Integrate ODEs:
tspan = [0 5]; %(s)
d(sprintf('Simulated time: %d seconds', tspan(2)));
[t,x] = ode45(@FNR.ode,tspan,x0); %Runge-Kutta

% Plot results:
figure; plot(t,x(:,1),t,x(:,2));
legend('FNR','O2-FNR');

clear x0 tspan;