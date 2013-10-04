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

M.amounts(M.species.N,:) = round(100*M.info.copyNumber);
M.amounts(M.species.TN,:) = round(0*M.info.copyNumber);
M.amounts(M.species.N0,:) = round(100*M.info.copyNumber);
M.reactions(M.reaction.PpT_PT).mesorate_plus = @(~,~,~,~)(0.0);
M.reactions(M.reaction.TPpT_TPT).mesorate_plus = @(~,~,~,~)(0.0);
M.reactions(M.reaction.PTpT_TPT).mesorate_plus = @(~,~,~,~)(0.0);
M.reactions(M.reaction.PpT_PT).mesorate_min = @(~,~,~,~)(0.0);
M.reactions(M.reaction.TPpT_TPT).mesorate_min = @(~,~,~,~)(0.0);
M.reactions(M.reaction.PTpT_TPT).mesorate_min = @(~,~,~,~)(0.0);

[t,a] = Tools.simulate(M,tmax);
figure;
plt = stairs(t',[(a(M.species.TP,:)./a(M.species.P0,:))' (a(M.species.TN,:)./a(M.species.N0,:))']);
legend({'Promotor Binding Ratio', 'Decoy Site Binding Ratio'},'Location','SouthEast');
axis([0 10 0.92 1.0]);
title('Single Run');
xlabel('Time (min)');
ylabel('Binding Ratio (-)');

beautify(gcf,plt,[]);

if model == 3
    boundP = a(M.species.TP,:) + a(M.species.PT,:) + a(M.species.TPT,:);
    figure;
    plot(t,boundP./a(M.species.P0,:));
end

clear t a;

 
[t,a] = Tools.evaluate(M,50,tmax);

figure;
plt = plot(t',(a(M.species.TN,:)./a(M.species.N0,:))','LineStyle','none','Marker','.','MarkerSize',2);
legend({'Decoy Site Binding Ratio'},'Location','SouthEast');
title('Multiple Runs');
xlabel('Time (min)');
ylabel('Binding Ratio (-)');

beautify(gcf,plt,[]);

%clear i M t a leg;
