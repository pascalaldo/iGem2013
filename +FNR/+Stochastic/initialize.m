function M = initialize()
% FNR.STOCHASTIC.INITIALIZE

S.info.model = 'FNR';
S.info.species = 4;
S.info.reactions = 4;
S.info.rules = 0;
S.info.volume = 0.6E-15;    % the volume of E.ocli in L
S.info.NA = 6.023E23;       % the Avogadro's constant
S.info.oxygen = 0;

%% Parameters
S.par.a1      = 0.0871;
S.par.a1max   = 0.135;
S.par.a21     = 0.484;
S.par.a22     = 4.09;
S.par.b22     = 2.6;
S.par.b1(1)   = 0.838;
S.par.b1(2)   = 0.613;
S.par.b21(1)  = 0.0821;
S.par.b21(2)  = 0.0634;
S.par.b31(1)  = 0.0231;
S.par.b31(2)  = 0.0148;
S.par.g13     = -0.464;
S.par.x4      = 0.196;
S.par.x5      = 0.455;
%S.par.x6      = oxygen;
S.par.x3c     = 0.389;

%% Species
S.species.toName = containers.Map('KeyType','uint32','ValueType','char');
S.species.toID = containers.Map('KeyType','char','ValueType','uint32');

S.species.Void          = 1;
S.species.FNRmRNA       = 2;
S.species.InactiveFNR   = 3;
S.species.ActiveFNR     = 4;

%% Reactions

S.reaction.Void_FNRmRNA         = 1;
S.reaction.Void_InactiveFNR     = 2;
S.reaction.Void_ActiveFNR       = 3;
S.reaction.InactiveFNR_ActiveFNR= 4;

M = FNR.Stochastic.setup(S);

end
