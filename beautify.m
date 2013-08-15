function beautify(figh,ploth,priority)

figure(figh);
axh = gca;
set(axh,'FontName','Helvetica-Narrow','FontSize',10);

col = hsv(length(ploth)+2).*0.8;
col = col(2:(end-1),:);

for i=1:length(ploth)
    set(ploth(i),'Color',col(i,:));
end

for i=1:length(priority)
    set(ploth(priority),'LineWidth',2);
end

xlabh = get(axh,'XLabel');
set(xlabh,'FontName','Helvetica','FontSize',12);

ylabh = get(axh,'YLabel');
set(ylabh,'FontName','Helvetica','FontSize',12);

tith = get(axh,'Title');
set(tith,'FontName','Helvetica','FontSize',14,'FontWeight','bold')

end