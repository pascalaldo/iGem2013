% Stochastics.run

clear i M t a leg;

M = Stochastics.initialize('data/msb20127-s3.xml');

% Create a legend
leg = cell(M.count.species,1);
for i=1:M.count.species
    leg{i} = M.species.toName(i);
end

tmax=10;

<<<<<<< HEAD
<<<<<<< HEAD
[t,a] = Stochastics.simulate(M,tmax);
=======
[t,a] = Stochastics.simulate(M,10);
>>>>>>> 17b484ad3f5d10221150d6500ece1aceac540f1c
=======
[t,a] = Stochastics.simulate(M,10);
>>>>>>> 86dd5306134f9f8bf3ae1825b8ad5e2c196b4887
figure(1);
plot(t,a);
legend(leg);
title('Single Run');
xlabel('Time (s)');
ylabel('Amount (molecules)');
clear t a;

<<<<<<< HEAD
<<<<<<< HEAD
[t,a] = Stochastics.evaluate(M,100,tmax);
=======
[t,a] = Stochastics.evaluate(M,100,10);
>>>>>>> 17b484ad3f5d10221150d6500ece1aceac540f1c
=======
[t,a] = Stochastics.evaluate(M,100,10);
>>>>>>> 86dd5306134f9f8bf3ae1825b8ad5e2c196b4887
figure(2);
plot(t,a,'LineStyle','none','Marker','.','MarkerSize',1);
legend(leg);
title('Multiple Runs');
xlabel('Time (s)');
ylabel('Amount (molecules)');
clear i M t a leg;