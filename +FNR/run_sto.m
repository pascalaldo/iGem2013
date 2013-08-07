% Decoy.run

clear i M t a leg;

M = FNR.initialize();

% Create a legend
leg = cell(M.info.species-1,1);
for i=1:M.info.species-1
    leg{i} = M.species.toName(i+1);
end

tmax=10;

[t,a] = FNR.simulate(M,0,tmax);
figure(1);
plot(t,a(2:4,:));
legend(leg);
title('Single Run');
xlabel('Time (min)');
ylabel('Amount (molecules)');
clear t a;

[t,a] = FNR.evaluate(M,0,10,tmax);

figure(2);
plot(t,a(2:4,:),'LineStyle','none','Marker','.','MarkerSize',1);
legend(leg);
title('Multiple Runs');
xlabel('Time (min)');
ylabel('Amount (molecules)');
clear i M t a leg;