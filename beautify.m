function beautify(figh,ploth,priority)

addpath('expfig','-end')

figure(figh);
axh = gca;
set(axh,'FontName','Helvetica','FontSize',12,'LineWidth',1);
set(figh, 'Color', [1.0 1.0 1.0]);
set(axh, 'OuterPosition', [0.0 0.01 1.0 0.98]);


col = hsv(length(ploth)+2).*0.8;
col = col(2:(end-1),:);

for i=1:length(ploth)
    set(ploth(i),'Color',col(i,:),'LineWidth',1);
end

for i=1:length(priority)
    set(ploth(priority),'LineWidth',3);
end

xlabh = get(axh,'XLabel');
set(xlabh,'FontName','Helvetica','FontSize',14);

ylabh = get(axh,'YLabel');
set(ylabh,'FontName','Helvetica','FontSize',14);

tith = get(axh,'Title');
set(tith,'FontName','Helvetica','FontSize',16,'FontWeight','bold')

set(figh, 'Position', [50 50 450 350]);

d_now = datestr(now);

eval(sprintf('export_fig -painters -nocrop ''graphs/%s.png''', d_now));
eval(sprintf('export_fig -painters -nocrop ''graphs/%s.eps''', d_now));


end