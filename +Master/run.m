% Master.run
% This part combines the stochastic model (Decoy) and the ODE model (FNR).

close all
clear xstep x tt tstepODE tstep t oxygen i amountPlus M inc;

tt = 10;                       % Assign total simulation time
x = [0.16 4.63 0.08];          % (uM) [mRNA inactiveFNR activeFNR]
oxygen = 0;

M = Decoy.initialize('data/msb20127-s2.xml');

% Initialization
i = 1;
t(i) = 0;
% inc = 0;

while t(i) < tt
    % Update FNR amount from ODE model
    M.amounts(1,i) = Master.mol2nr(M,x(end,3));     % T0 or total FNR
%     if i>1
%         inc = M.amounts(1,i) - M.amounts(1,i-1);
%     end
%     M.amounts(4,i) = round(inc * M.amounts(4,i) / M.amounts(1,i)) + M.amounts(4,i); % TN
%     M.amounts(7,i) = round(inc * M.amounts(7,i) / M.amounts(1,i)) + M.amounts(7,i); % TP
    M.amounts(2,i) = M.amounts(1,i) - M.amounts(4,i) - M.amounts(7,i);  % T
%     M.amounts(3,i) = M.amounts(5,i) - M.amounts(4,i);           % N
%     M.amounts(6,i) = M.amounts(8,i) - M.amounts(7,i);           % P
    
    % run the stochastic simulation
    [tstep,amountPlus] = Decoy.stepSim(M);
    M.amounts = [M.amounts amountPlus];

    % update the stochastic/master time vector
    i = i + 1;
    t(i) = t(i-1) + tstep;
    
    % run the ODE simulation
    x = [x; x(end,:)+FNR.ode(t(i-1),x(end,:),oxygen,FNRdata)'.*tstep];
end

% Plot the stochastic result and ODE result in one figure
% plotyy(tODE,x,t,M.amounts)
figure(1);
plot(t,x);
hold on;
legend('mRNA', 'Inactive FNR','Active FNR');

% Plot the promoter binding ratio
stairs(t,M.amounts(7,:)./M.amounts(8,:));
%stairs(t,M.amounts(1,:));
hold off;