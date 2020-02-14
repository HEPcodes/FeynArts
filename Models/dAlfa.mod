(*
	dAlfa.mod
		add-on model file which modifies the renormalization for
		use with alpha(MZ), rather than alpha(0) as in SM.mod
		by Thomas Hahn
		last modified 06 Feb 17 by cs
*)


RenConst[ dZAA1 ] = dZAA1light + dZAA1heavy


RenConst[ dZAA1light ] :=
  -ReTilde[SelfEnergy[V[1] -> V[1], MZ]]/MZ^2

Options[ dZAA1light ] = {
  InsertionLevel -> {Generic, Classes, Particles},
  ExcludeParticles -> F[3, {3, ___}],
  LastSelections -> F[2|3|4]
}


RenConst[ dZAA1heavy ] :=
Block[ {InsertFieldsHook},
  InsertFieldsHook[args__] := InsertFields[args,
    ExcludeParticles -> {F[2], F[4]}] /.
    F[3, {_, r___}] -> F[3, {3, r}];
  FieldRC[V[1]]
]


Alfa = AlfaMZ;
Conjugate[AlfaMZ] ^:= AlfaMZ

EL = ELMZ;
Conjugate[ELMZ] ^:= ELMZ

