% FNR.run

clear x0 tspan;

disp('1) Decoy model');
disp('2) FNR model');
model = input('Please choose: ');

if model == 1
    M = Decoy.ODE.initialize();
    ode = @Decoy.ODE.ode;
else
    M = FNR.ODE.initialize();
    ode = @FNR.ODE.ode;
end

x0 = M.amounts;
%d('Initial concentrations in uM');
%d(sprintf('O2: %d', x0(3)));
%d(sprintf('FNR: %d', x0(1)));

% Integrate ODEs:
tspan = [0 900]; %(min)
d(sprintf('Simulated time: %d minutes', tspan(2)));
[t,x] = ode45(@(t,x)ode(t,x,M),tspan,x0); %Runge-Kutta

% Plot results:
figure; plot(t,x);
legend('mRNA', 'Inactive FNR','Active FNR');
xlabel('time (min)');
ylabel('concentration (µM)');

clear t x

if model == 2
    tic;
    O2 = 10.^sort([[-1:0.1:2.5] 0.999999]);
    xs = [];
    for i=O2
        M.oxygen = i;
        xs = [xs; Tools.steadystate(15, M)];
    end
    toc
    figure; loglog(O2',xs);
    legend('mRNA', 'Inactive FNR','Active FNR');
    xlabel('oxygen concentration (µM)');
    ylabel('concentration (µM)');

    clear x0 tspan;
end