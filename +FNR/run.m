% FNR.run

clear x0 tspan;

x0 = [0.16 4.63 0.08]; %(uM) [mRNA inactiveFNR activeFNR]
%d('Initial concentrations in uM');
%d(sprintf('O2: %d', x0(3)));
%d(sprintf('FNR: %d', x0(1)));

oxygen = @(t)((t>5)*0.8);

% Integrate ODEs:
tspan = [0 10]; %(s)
d(sprintf('Simulated time: %d seconds', tspan(2)));
[t,x] = ode45(@(t,x)FNR.ode(t,x,oxygen(t)),tspan,x0); %Runge-Kutta

% Plot results:
figure; plot(t,x);
legend('mRNA', 'Inactive FNR','Active FNR');

clear x0 tspan;