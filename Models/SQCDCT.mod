(*
	SQCDCT.mod
		model file for SUSY QCD based on MSSMCT.mod
		by Christian Schappacher
		last modified 20 Feb 14 by cs
*)


LoadModel["MSSMCT"]

SetOptions[InsertFields,
  ExcludeParticles -> {F[1|2|11|12], 
    S[1|2|3|4|5|6], S[11|12],
    U[1|2|3|4],
    V[1|2|3]}]

M$CouplingMatrices = M$CouplingMatrices /. {EL -> 0, Alfa -> 0}

RenConst[dMZsq1] := 0;
RenConst[dMWsq1] := 0;

RenConst[dSW1] := 0;
RenConst[dZe1] := 0;

RenConst[dMUE1] := 0;
RenConst[dMUEdr] := 0;
 
RenConst[dTB1] := 0;
RenConst[dSB1] := 0;
RenConst[dCB1] := 0;

RenConst[dZHiggs1[_, _]] := 0;
RenConst[dMHiggs1[_, _]] := 0

