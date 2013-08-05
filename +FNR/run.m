% FNR.run

FNR.initialize
clear x0 tspan;

x0(1) = FNRdata.values(FNRdata.toID('mRNA')); 
x0(2) = FNRdata.values(FNRdata.toID('inactiveFNR'));
x0(3) = FNRdata.values(FNRdata.toID('activeFNR'));%(uM) [mRNA inactiveFNR activeFNR]
%d('Initial concentrations in uM');
%d(sprintf('O2: %d', x0(3)));
%d(sprintf('FNR: %d', x0(1)));

oxygen = @(t)(0);

% Integrate ODEs:
tspan = [0 900]; %(min)
d(sprintf('Simulated time: %d minutes', tspan(2)));
[t,x] = ode45(@(t,x)FNR.ode(t,x,oxygen(t),FNRdata),tspan,x0); %Runge-Kutta

% Plot results:
figure; plot(t,x);
legend('mRNA', 'Inactive FNR','Active FNR');
xlabel('time (min)');
ylabel('concentration (µM)');

clear oxygen t x;

O2 = 10.^sort([[-1:0.1:2.5] 0.999999]);
xs = [];
for i=O2
    xs = [xs; FNR.steadystate(i, 15, FNRdata)];
end

figure; loglog(O2',xs);
legend('mRNA', 'Inactive FNR','Active FNR');
xlabel('oxygen concentration (µM)');
ylabel('concentration (µM)');

clear x0 tspan;