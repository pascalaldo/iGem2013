% FNR.run

clear x0 tspan;

disp('1) Decoy model');
disp('2) FNR model');
disp('3) Merged model');
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
tspan = [0 500]; %(min)
d(sprintf('Simulated time: %d minutes', tspan(2)));
[t,x] = ode45(@(t,x)ode(t,x,M),tspan,x0); %Runge-Kutta

% Plot results:
figure;
plt = plot(t,x);
leg = {};
for i=1:M.info.species
    leg = {leg{:}, M.species.toName(i)};
end
legend(leg);
xlabel('time (min)');
ylabel('concentration (\muM)');
title('Anaerobic FNR model simulation')

beautify(gcf,plt,3);

if model ~= 2
    figure;
    plt = plot(t,Tools.expressionrate(M,x));
    xlabel('time (min)');
    ylabel('concentration (\muM)');
    title('Expression Rate')

    beautify(gcf,plt,1);
end

clear t x

if model == 3
    tic;
    
    kfac=1;
    
    Ktpplus_old = M.values(M.parameters.Ktpplus);
    Ktpmin_old = M.values(M.parameters.Ktpmin);
    M.values(M.parameters.Ktpplus) = Ktpplus_old/kfac;
    M.values(M.parameters.Ktpmin) = Ktpmin_old*kfac;
    M.values(M.parameters.Kptplus) = Ktpplus_old/kfac;
    M.values(M.parameters.Kptmin) = Ktpmin_old*kfac;
    M.values(M.parameters.Ktp_tptplus) = Ktpplus_old/kfac;
    M.values(M.parameters.Ktp_tptmin) = Ktpmin_old*kfac;
    M.values(M.parameters.Kpt_tptplus) = Ktpplus_old/kfac;
    M.values(M.parameters.Kpt_tptmin) = Ktpmin_old*kfac;
    
    O2 = 10.^sort([[-1:0.1:2.0] 0.999999]);
    dec = 0:25:200;
    xss = [];
    leg = {};
    for ndec=dec
        newam = Tools.nr2mol(M,ndec*M.info.copyNumber)
        M.amounts(M.species.N,:) = newam;
        M.amounts(M.species.N0,:) = newam;
        xs = [];
        for i=O2
            d(sprintf('[oxygen] = %f',i));
            M.values(M.parameters.oxygen) = i;
            xs = [xs; Tools.expressionrate(M,Tools.steadystate(50, M))];
        end
        xss = [xss, xs];
        leg = [leg, sprintf('%d Decoy Sites',ndec)];
    end
    toc
    figure(5);
    plt = loglog(O2',xss);
    xlabel('oxygen concentration (\muM)');
    ylabel('expression rate (-)');
    title('Steady State Expression Rates')
    legend(leg);
    
    beautify(gcf,plt,1);
    
    figure(6);
    plt = plot(O2',xss);
    xlabel('oxygen concentration (\muM)');
    ylabel('expression rate (-)');
    title('Steady State Expression Rate')

    beautify(gcf,plt,1);
    
    save('decoydata.mat','xss','02','dec');
    
    clear x0 tspan;
end

if model == 2
    tic;
    O2 = 10.^sort([[-1:0.1:2.5] 0.999999]);
    xs = [];
    for i=O2
        d(sprintf('[oxygen] = %f',i));
        M.values(M.parameters.oxygen) = i;
        xs = [xs; Tools.steadystate(50, M)];
    end
    toc
    
    figure(5);
    plt = loglog(O2',xs);
    xlabel('oxygen concentration (\muM)');
    ylabel('concentration (\muM)');
    title('Steady states of the FNR model');
    legend(leg);
    
    beautify(gcf,plt,3);
    
    figure(6);
    plt = plot(O2',xs);
    xlabel('oxygen concentration (\muM)');
    ylabel('concentration (\muM)');
    title('Steady states of the FNR model');
    legend(leg);

    beautify(gcf,plt,3);
        
    clear x0 tspan;
end

if model == 3
    tic;
    O2 = [50 0];
    dec = 0:25:200;
    xs = {};
    
    kfac=1;
    
    Ktpplus_old = M.values(M.parameters.Ktpplus);
    Ktpmin_old = M.values(M.parameters.Ktpmin);
    M.values(M.parameters.Ktpplus) = Ktpplus_old/kfac;
    M.values(M.parameters.Ktpmin) = Ktpmin_old*kfac;
    M.values(M.parameters.Kptplus) = Ktpplus_old/kfac;
    M.values(M.parameters.Kptmin) = Ktpmin_old*kfac;
    M.values(M.parameters.Ktp_tptplus) = Ktpplus_old/kfac;
    M.values(M.parameters.Ktp_tptmin) = Ktpmin_old*kfac;
    M.values(M.parameters.Kpt_tptplus) = Ktpplus_old/kfac;
    M.values(M.parameters.Kpt_tptmin) = Ktpmin_old*kfac;
    
    leg = {};
    for ndec=dec
        newam = Tools.nr2mol(M,ndec*M.info.copyNumber)
        M.amounts(M.species.N,:) = newam;
        M.amounts(M.species.N0,:) = newam;
        
        tspan = [0 200];
        x0 = M.amounts(:,1);
        M.values(M.parameters.oxygen) = O2(1);
        [t1,x1] = ode45(@(t,x)ode(t,x,M),tspan,x0);
        
        x0 = x1(end,:);
        M.values(M.parameters.oxygen) = O2(2);
        [t2,x2] = ode45(@(t,x)ode(t,x,M),tspan,x0);
        
        xtot = [x1; x2];
        ttot = [t1; (t2+tspan(2))];

        xs = [xs [Tools.expressionrate(M,xtot),ttot]];
        leg = [leg, sprintf('%d Decoy Sites',ndec)];
    end
    toc
    
    figure;
    for i=xs
        it = i{1};
        plt = plot(it(:,2),it(:,1));
        hold on;
    end
    xlabel('oxygen concentration (\muM)');
    ylabel('expression rate (-)');
    title('Response to Change in Oxygen Concentration');
    legend(leg);
    
    beautify(gcf,plt,1);
    
    save('decoydata2.mat','xs','dec');
    
    clear x0 tspan;
end