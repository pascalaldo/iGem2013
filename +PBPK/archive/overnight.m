[x,f] = run(ms,problemlsq,50)

optfine = optimset('display','iter'); % options for finer iteration
xfinal = lsqnonlin(@(k)PBPK.objectiveVector(k,P),k,[],[],optfine)