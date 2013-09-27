% Decoy.run

clear i M t a leg;

disp('1) Decoy model');
disp('2) FNR model');
disp('3) Merged model');
model = input('Please choose: ');

if model == 1
    M = Decoy.Stochastic.initialize();
elseif model == 2
    M = FNR.Stochastic.initialize();
else
    M = Merged.Stochastic.initialize();
end

% Create a legend
leg = cell(M.info.species,1);
for i=1:M.info.species
    leg{i} = M.species.toName(i);
end

tmax=10;

[t,a] = Tools.simulate(M,tmax);
figure;
plot(t,a);
legend(leg);
title('Single Run');
xlabel('Time (s)');
ylabel('Amount (molecules)');

if model == 3
    boundP = a(M.species.TP,:) + a(M.species.PT,:) + a(M.species.TPT,:);
    figure;
    plot(t,boundP./a(M.species.P0,:));
end

clear t a;

% 
% [t,a] = Tools.evaluate(M,10,tmax);
% 
% figure;
% plot(t,a,'LineStyle','none','Marker','.','MarkerSize',1);
% legend(leg);
% title('Multiple Runs');
% xlabel('Time (s)');
% ylabel('Amount (molecules)');
% clear i M t a leg;