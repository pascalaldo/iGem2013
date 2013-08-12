function res = bc(ya,yb)
% RES = MERGED.ODE.BS(YA,YB) includes the boundary conditions
% N0 = TN + N;
% P0 = TP + P;

res = [ya(5) - ya(3) - ya(4);
    yb(8) - yb(7) - yb(6)]
end