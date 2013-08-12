% FNR.run

clear x0 tspan;

disp('1) Decoy model');
disp('2) FNR model');
disp('3) Master model');
model = input('Please choose: ');

if model == 1
    M = Decoy.ODE.initialize();
    ode = @Decoy.ODE.ode;
elseif model == 2
    M = FNR.ODE.initialize();
    ode = @FNR.ODE.ode;
else
    M = Merged.ODE.initialize();
    ode = @Merged.ODE.ode;
end

x0 = M.amounts;

% Integrate ODEs:
tspan = [0 15]; %(min)
d(sprintf('Simulated time: %d minutes', tspan(2)));
[t,x] = ode45(@(t,x)ode(t,x,M),tspan,x0); %Runge-Kutta

% Plot results:
figure; plot(t,x);
leg = {};
for i=1:M.info.species
    leg = {leg{:}, M.species.toName(i)};
end
legend(leg);
xlabel('time (min)');
ylabel('concentration (µM)');

% clear t x

if model ~= 1
    tic;
    O2 = 10.^sort([[-1:0.1:2.5] 0.999999]);
    xs = [];
    for i=O2
        if model == 2
            M.oxygen = i;
        else
            M.FNR.oxygen = i;
        end
        xs = [xs; Tools.steadystate(15, M)];
    end
    toc
    figure; loglog(O2',xs);
    legend(leg);
    xlabel('oxygen concentration (µM)');
    ylabel('concentration (µM)');

    clear x0 tspan;
end