(*
	ModelMaker.m
		derives the Feynman rules from the Lagrangian
		and splices them into a template model file
		last modified 5 Oct 01 th
*)


BeginPackage["ModelMaker`", "FeynArts`"]

FeynmanRules::usage =
"FeynmanRules[lag] returns the list of Feynman rules derived from the
Lagrangian lag. FeynmanRules[lag, simp] in addition applies the function
simp to each derived Feynman rule for simplification. These rules still
contain the kinematic parts, i.e. the couplings have not yet been
decomposed into a kinematic and a coupling vector."

Kin::usage =
"Kin is an inert function wrapped around the kinematic parts of a
coupling by FeynmanRules."

CouplingVector::usage =
"CouplingVector[rul] extracts the coupling vector of each Feynman rule in
rul according to the corresponding kinematic vector in the currently
initialized generic model file. The output is in a form suitable for the
classes model file."

WriteModelFile::usage =
"WriteModelFile[rul, \"MODEL.mmod\"] writes the Feynman rules rul to the
model file MODEL.mod using the template model file MODEL.mmod. The
location in MODEL.mmod where the Feynman rules are to be inserted must be
marked by \"<* M$CouplingMatrices *>\"."


Begin["`Private`"]

fermobjs = NonCommutative |
  Global`DiracMatrix | Global`DiracSlash | Global`ChiralityProjector

bosobjs = Global`MetricTensor | Global`FourVector | Global`ScalarProduct

kinobjs = Flatten[bosobjs | fermobjs | Mom]


FunctionalD[p_Plus, f_] := FunctionalD[#, f]&/@ p

FunctionalD[c_. f_Field, Field[fd__]] :=
  If[Length[f] =!= Length[{fd}], 0, c FieldD[f, fd]]

FieldD[_[]] = 1

FieldD[f_, fd_, fr___] :=
Block[ {sig, s},
  If[ FreeQ[fd, F | U], sig = 1, s = -1; sig := s = -s ];
  Plus@@ MapIndexed[sig IndexD[#1, fd, FieldD[Drop[f, #2], fr]]&, f]
]

Attributes[IndexD] = {HoldAll}

IndexD[{f_, i1_}, {f_, i2_}, todo_] :=
  Inner[IndexDelta, elim/@ i1, i2, Times] todo

IndexD[__] = 0


EliminateDeltas[x_] := x /; FreeQ[x, elim]

EliminateDeltas[p_Plus] := EliminateDeltas/@ p

EliminateDeltas[IndexDelta[elim[i_], j_] r_.] :=
  EliminateDeltas[r /. elim[i] -> j /. i -> j]


FeynmanRules::nocontrib = "Warning: The term `` does not contain any
fields and thus does not contribute to the Feynman rules."

FeynmanRules::nogeneric = "No field point corresponding to the vertex
`1` was found in the generic model file."

FeynmanRules[lagr_, simp_:Identity] :=
Block[ {lag, cpl},
  If[ $GenericModel === "", InitializeModel[] ];
  lag = IsolateFields[Expand[lagr, Field]];
  cpl = Union[Cases[lag,
    f_Field :> Block[{char = 96}, Apply[IndexRename, f, 1]],
    Infinity]];
  cpl = ( Print[C@@ First/@ #];
    C@@ Apply[FieldJoin, #, 1] ==
      Collect[I EliminateDeltas[FunctionalD[lag, #]//Expand],
        {_Kin, _IndexDelta}, HoldForm@@ {simp[#]}&]
  )&/@ cpl;
  DeleteCases[cpl, _ == 0]
]


IsolateFields[p_Plus] := IsolateFields/@ p

IsolateFields[t:(_Times | _Dot)] :=
Block[ {vert, ind, rulz, coeff, h, perm, n = 0},
  {vert, ind, rulz, coeff} = Flatten/@
    Transpose[Apply[List, FieldCat[t] /. prod -> Dot, {0, 1}]];
  If[ Length[vert] === 0,
    Message[FeynmanRules::nocontrib, t];
    Return[0] ];
  perm = FindVertex[ToGeneric[vert], Generic];
  If[ perm === $Failed,
    Message[FeynmanRules::nogeneric, t];
    Return[0] ];
  rulz = Flatten[Apply[KinRule[##, ++n]&, rulz[[perm]], 1]];
  Kinalyze[Expand[Times@@ coeff /. rulz, kinobjs]] *
    Field@@ Transpose[{vert, Level[ind, {2}]}][[perm]]
]

IsolateFields[other_] := (Message[FeynmanRules::nocontrib, other]; 0)


Attributes[prod] = {Flat, Orderless}

FieldCat[t_Times] := FieldCat/@ prod@@ t

FieldCat[d_Dot] := FieldCat/@ d

FieldCat[Field[s_. (f:P$Generic)[t_, i_], r___]] :=
  h[s f[t], h[i], h[r], {}]

FieldCat[Field[f_, r___]] := h[f, h[{}], h[r], {}]

FieldCat[other_] := h[{}, {}, {}, other]


KinRule[_] = {}

KinRule[mom_, ki_List, n_] := {KinRule[mom, n], KinRule[ki, n]}

KinRule[mom_, n_] := mom -> Mom[n]

KinRule[ki_List, n_] := Thread[ki -> Through[Take[KIs, Length[ki]][n]]]


Kinalyze[expr_] := expr Kin[1] /; FreeQ[expr, kinobjs]

Kinalyze[p_Plus] := Kinalyze/@ p

Kinalyze[t_Times] :=
Block[ {nc, kin, coeff},
  {nc, kin, coeff} = Flatten/@ Transpose[KinCat/@ List@@ t];
  Kin[If[Length[nc] === 0, 1, Flatten[NonCommutative@@ nc]] Times@@ kin] *
    Times@@ coeff
]


KinCat[x:fermobjs[__]] := {x, {}, {}}

KinCat[x:bosobjs[__]] := {{}, x, {}}

KinCat[Mom[n_][mu_]] := {{}, Global`FourVector[Mom[n], mu], {}}

KinCat[other_] := {{}, {}, other}


Kin[_[ga_Global`DiracMatrix]] :=
  Kin[NonCommutative[ga, Global`ChiralityProjector[+1]]] +
  Kin[NonCommutative[ga, Global`ChiralityProjector[-1]]]


FieldJoin[f_, {}] = f

FieldJoin[s_. (f:P$Generic)[t_], i_] := s f[t, i]


IndexRename[f_, i_] :=
Block[ {letter = FromCharacterCode[++char]},
  {f, Array[ToExpression[letter <> ToString[#]]&, Length[i]]}
]


Attributes[CouplingVector] = {Listable}

CouplingVector[rul:_ == _List] = rul

CouplingVector[fi_ == cpl_] :=
  fi == ReleaseHold[
    {CouplingConst[cpl, #]}&/@ KinematicVector@@ ToGeneric[fi] ]

CouplingVector[other_] := CouplingVector[FeynmanRules[other]]


CouplingConst[coup_, kcomp_] := Coefficient[coup, Kin[kcomp]]

CouplingConst[coup_, ksum_Plus] :=
Block[ {xcoup, Kin, Global`FourVector},
  Kin[n_Integer x_] := n Kin[x];
  Global`FourVector[p_Plus, mu_] := Global`FourVector[#, mu]&/@ p;
  Global`FourVector[n_Integer mom_, mu_] := n Global`FourVector[mom, mu];
  xcoup = coup /. Kin[k_] :> Distribute[Kin[Expand[k]]];
  xcoup = ReleaseHold[nCoeff/@ List@@ Expand[ksum]];
  If[ SameQ@@ Expand[xcoup], xcoup[[1]], 0 ]
]

nCoeff[(n_Integer:1) k_] := Coefficient[xcoup, Kin[k]]/n


WriteModelFile[rulz_, template_] :=
Block[ {M$CouplingMatrices = rulz},
  Splice[template]
]


End[]

EndPackage[]

