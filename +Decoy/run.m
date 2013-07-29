% Stochastics.run

clear i M t a leg;

M = Stochastics.initialize('data/msb20127-s3.xml');

% Create a legend
leg = cell(M.info.species,1);
for i=1:M.info.species
    leg{i} = M.species.toName(i);
end

tmax=10;

[t,a] = Stochastics.simulate(M,tmax);
figure(1);
plot(t,a);
legend(leg);
title('Single Run');
xlabel('Time (s)');
ylabel('Amount (molecules)');
clear t a;

[t,a] = Stochastics.evaluate(M,100,tmax);

figure(2);
plot(t,a,'LineStyle','none','Marker','.','MarkerSize',1);
legend(leg);
title('Multiple Runs');
xlabel('Time (s)');
ylabel('Amount (molecules)');
clear i M t a leg;