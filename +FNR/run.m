% FNR.run

clear x0 tspan;

x0 = [40 5 0 0]; %(uM)

% Integrate ODEs:
tspan = [0 5]; %(s)
[t,x] = ode15s(@FNR.ode,tspan,x0); %Runge-Kutta

% Plot results:
figure; plot(t,x(:,1),t,x(:,2),t,x(:,3),t,x(:,4));
legend('O2','FNR','O2-FNR','Product');

clear x0 tspan;