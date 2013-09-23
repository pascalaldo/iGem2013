function N = regoesSim(t,alpha,N0)
% M = PBPK.regoesSim(t,alpha,N0) simulates the time-kill curve.
% t, the discreted time vector
% alpha, the drug concentration
% N0, the initial bacteria count
zMIC = 0.03;
kap = 1;
psimax = 0.1939;
psimin = -6;

psi = @(alpha) psimax - (psimax - psimin) * (alpha./zMIC).^kap ./ ((alpha./zMIC).^kap - psimin/psimax);
% 0.1939 is the bacteria growth rate
tstep = t(:)-[0;t(1:end-1)];
dec = psi(alpha);
N(1) = dec(1)*tstep(1)*N0 + N0;
for i = 2:length(t)
    N(i) = dec(i)*tstep(i)*N(i-1) + N(i-1);
end
% psisum = cumsum(psi(alpha).*tstep);
% length(psisum)
% N = N0 + psisum;
% N = [N0;N];

figure;
plot(t,dec);
figure;
semilogy(t,N)
ylim([10^(-4) 10^6])

end