(*
	Initialize.m
		Functions for the initialization of models
		last modified 2 Sep 19 th
*)

Begin["`Initialize`"]

(* The functions defined for a certain model are:
	F$AllGeneric:		all generic fields
	F$AllClasses:		all classes of the model
	F$AllParticles:		all particles of the model
   These lists are static for the initialized model.  For InsertFields
   the following lists are also used; they might be changed by the
   function RestrictCurrentModel:
	F$Generic:		currently used generic fields
	F$Classes:		currently used classes
	F$Particles:		currently used particles
	F$AllowedFields:	all used fields
   For the construction of the couplings the following lists are defined:
	FieldPointList[0, 1, 2, ...]
	ReferenceOrder[Generic | Classes]
   Furthermore, InitializeModel defines the functions
	PossibleFields	-> fields `fitting' on a half-filled vertex
	CheckFieldPoint	-> is this vertex in the current model?
	AnalyticalCoupling	-> analytical expression for a coupling
	AnalyticalPropagator	-> ditto for propagators
   InitializeModel also sets the functions that return certain
   properties of the fields like
	AntiParticle, Indices, SelfConjugate, TheMass, TheLabel, etc.

   There is one restriction on entering the model file:
   the coupling definitions in the classes model file have to be made
   with classes couplings of the same ordering as in the generic
   coupling definition.
*)


Attributes[FieldPoint] = Attributes[PermutationSymmetry] = {Orderless}


ToModelName[mod_] := str/@ Flatten[{mod}]

str[mod:_[___]] := str/@ mod

str[mod_] := ToString[mod]


indent = ""

Attributes[ReadModelFile] = {HoldFirst}

ReadModelFile[args__][ModelDebug[name_]] :=
  ReadModelFile[args][name, True]

ReadModelFile[args__][name_] :=
  ReadModelFile[args][name, $ModelDebug]

ReadModelFile[newitems_, type_, ext_][name_, deb_] :=
Block[ {$Path = $ModelPath, file},
  file = System`Private`FindFile[name <> ext];
  If[ file === $Failed,
    Message[InitializeModel::noopen, name <> ext];
    Abort[] ];
  FAPrint[2, indent, "loading ", type, " model file ", file];

  (*Off[Syntax::newl, Syntax::com];*)
  Check[ Block[{indent = indent <> "  "}, Get[file]], Abort[] ];
  (*On[Syntax::newl, Syntax::com];*)

  DebugModel[newitems, name, deb];
  olditems = newitems;

  name
]


Attributes[DebugModel] = {HoldFirst}

DebugModel[__, False] = 0

DebugModel[newitems_, name_, True] :=
  MapThread[ ReportChanges[name],
    {Block[newitems, ToString/@ newitems], newitems, olditems} ] /;
  olditems =!= 0

DebugModel[newitems_, name_, other_] :=
  DebugModel[newitems, name, MemberQ[ToString/@ Flatten[{other}], name]]


ReportChanges[_][_, new_, new_] := True

ReportChanges[name_][item_, new_, old_] := (
  {$ModelRemoved, $ModelChanged, $ModelAdded} =
    FindDiff[new, old, {}, {}];

  Print[];

  If[ Length[$ModelAdded] > 0,
    Print[name, " added the following ", Length[$ModelAdded],
      " items to ", item, ":"];
    Print[$ModelAdded //$ModelDebugForm] ];

  If[ Length[$ModelRemoved] > 0,
    Print[name, " removed the following ", Length[$ModelRemoved],
      " items from ", item, ":"];
    Print[$ModelRemoved //$ModelDebugForm] ];

  If[ Length[$ModelChanged] > 0,
    Print[name, " changed the following ", Length[$ModelChanged],
      " items in ", item, ":"];
    Print[$ModelChanged //$ModelDebugForm] ];

  False
)


FindDiff[{c_, d___}, {a___, c_, b___}, diff_, add_] :=
  FindDiff[{d}, {a, b}, diff, add]
 
FindDiff[{c_ == x_, d___}, {a___, k_ == y_, b___}, diff_, add_] :=
  FindDiff[{d}, {a, b}, {diff, c}, add] /; ToClasses[c] === ToClasses[k]

FindDiff[{c_, d___}, old_, diff_, add_] :=
  FindDiff[{d}, old, diff, {add, c}]

FindDiff[{}, r__] := Replace[Flatten/@ {r}, x_ == _ :> x, {2}]


General::undefinedgen =
"No or incomplete generic model loaded."

ResetGenericModel[] := (
  M$GenericPropagators := (
    Message[M$GenericPropagators::undefinedgen];
    Abort[]; );
  M$GenericCouplings := (
    Message[M$GenericCouplings::undefinedgen];
    Abort[]; );
  M$FlippingRules = M$TruncationRules = M$LastGenericRules = {};
)

ResetGenericModel[]

LoadGenericModel[args__] := (
  ResetGenericModel[];
  ReadGenericModel[args]
)

ReadGenericModel[genmod_, ext_String:".gen"] :=
Block[ {olditems = 0},
  ReadModelFile[
    {M$GenericPropagators, M$GenericCouplings,
      M$FlippingRules, M$TruncationRules, M$LastGenericRules},
    "generic", ext ]/@ ToModelName[genmod]
]


General::undefinedmod =
"No or incomplete classes model loaded."

ResetModel[] := (
  M$ClassesDescription := (
    Message[M$ClassesDescription::undefinedmod];
    Abort[]; );
  M$CouplingMatrices := (
    Message[M$CouplingMatrices::undefinedmod];
    Abort[]; );
  M$LastModelRules = {};
)

ResetModel[]

LoadModel[args__] := (
  ResetModel[];
  ReadModel[args]
)

ReadModel[mod_, ext_String:".mod"] :=
Block[ {olditems = 0},
  ReadModelFile[
    {M$ClassesDescription, M$CouplingMatrices, M$LastModelRules},
    "classes", ext ]/@ ToModelName[mod]
]


(* this is a workaround for a Mathematica bug in Put, known
   to Wolfram Support since Version 4 but still not fixed *)

Attributes[WriteDef] = {Listable, HoldRest}

WriteDef[hh_, sym_, foo_] :=
Block[ {list = foo[sym], sym},
  Scan[
    ( foo[sym] = #;
      Put[Definition[sym], hh];
      WriteString[hh, "\n"] )&,
    Partition[list, 16, 16, 1, {}] ]
]

Attributes[WriteDefinitions] = {HoldRest}

WriteDefinitions[file_, syms__] :=
Block[ {hh},
  hh = OpenWrite[file];
  WriteDef[hh, {syms}, DownValues];
  WriteDef[hh, {syms}, OwnValues];
  Close[hh]
]


Attributes[DumpGenericModel] = {HoldRest}

DumpGenericModel[genfile_String, other___] :=
  WriteDefinitions[ genfile,
    M$GenericPropagators, M$GenericCouplings,
    M$FlippingRules, M$TruncationRules, M$LastGenericRules,
    KinematicIndices, other ]


Attributes[DumpModel] = {HoldRest}

DumpModel[modfile_String, other___] :=
Block[ {IndexRange},
  DownValues[IndexRange] = #;
  IndexRange[error_] =.;
  WriteDefinitions[ modfile,
    M$ClassesDescription, M$CouplingMatrices, 
    M$LastModelRules, IndexRange, ViolatesQ,
    RenConst, MassShift, other ]
]& @ DownValues[IndexRange]


Options[InitializeModel] = {
  GenericModel -> "Lorentz",
  Reinitialize -> True,
  TagCouplings -> False,
  GenericModelEdit :> Null,
  ModelEdit :> Null
}

InitializeModel::nonlin =
"Non-linear term `` in ``."

InitializeModel::unknown =
"Unknown field ``."

InitializeModel::badmix =
"Mixing field must be of the form Mix[g1,g2][i], not ``."

InitializeModel::norange =
"Index `` has no IndexRange specification."

InitializeModel::incomp1 =
"Coupling definition in model file for `` is incompatible to generic \
coupling structure.  Coupling is not a vector of length ``."

InitializeModel::incomp2 =
"Incompatible index structure in classes coupling ``.  \
Field `` needs `` indices, not ``."

InitializeModel::kinind =
"Warning: Wrong number of kinematic indices in field ``."

InitializeModel::nogeneric =
"Warning: Classes coupling `` matches no generic coupling."

InitializeModel::rhs1 =
"Generic coupling `` has G-expressions inside the kinematic vector."

InitializeModel::rhs2 =
"Generic coupling `` is not of the form \
AnalyticalCoupling[__] == G[_][__] . {__}."

InitializeModel::rhs3 =
"Classes coupling `` is not of the form C[__] == {{__}..}."

InitializeModel::dup =
"Duplicate components in ``."

InitializeModel::badrestr =
"Warning: `` is not a valid model restriction."

InitializeModel::nosymb =
"Cannot properly analyze the field specification ``.  Either the \
overall format is wrong, or it contains symbols that were already \
assigned values somewhere in your model file (most often \"i\" or \"j\").  \
Please check your generic model file and try again."

InitializeModel[opt:P$Options] := InitializeModel[{}, opt]

InitializeModel[model_, options:P$Options] :=
Block[ {reini, tagcoup, genmod, mod,
opt = ActualOptions[InitializeModel, options]},
  reini = TrueQ[Reinitialize /. opt];
  tagcoup = TrueQ[TagCouplings /. opt];

  genmod = ToModelName[GenericModel /. opt];
  If[ reini || genmod =!= $GenericModel,
    (InitGenericModel[GenericModelEdit] /. opt)[genmod] ];

  mod = ToModelName[model];
  If[ Length[mod] > 0 && (reini || mod =!= $Model),
    (InitModel[ModelEdit] /. opt)[mod] ];

  True
]


$GenericModel = $Model = ""


(* initializing a generic model: *)

Attributes[InitGenericModel] = {HoldAll}

InitGenericModel[edit_][genmod_] :=
Block[ {savecp = $ContextPath},
	(* no Global symbols allowed for these operations *)
  $ContextPath = DeleteCases[$ContextPath, "Global`"];
  $GenericModel = $Model = "";

  Clear[AnalyticalPropagator, AnalyticalCoupling, KinematicVector,
    PermutationSymmetry, PossibleFields, CheckFieldPoint, Combinations,
    Compatibles, MixingPartners, CloseCouplingVector];
  $ExcludedFPs = $ExcludedParticleFPs = {};

  $FermionLines = True;
  $SparseCouplings = False;

  FAPrint[2, ""];
  $GenericModel = LoadGenericModel[genmod];
  edit;

  ReferenceOrder[Generic] =
    Union[ ToGeneric[(List@@ #[[1]])&/@ M$GenericCouplings] ];
  FieldPointList[Generic] = FieldPoint@@@ ReferenceOrder[Generic];
  Scan[BuildCombinations, Union[Length/@ ReferenceOrder[Generic]]];

  MixingPartners[Mix[fi__]] := {fi};
  MixingPartners[Rev[fi__]] := Reverse[{fi}];
  MixingPartners[Rev[fi__][i__]] := Reverse[MixingPartners[Mix[fi][i]]];
  MixingPartners[fi_] := {fi};

  _Compatibles[fi_] := {fi};

  F$Generic = Union[ToGeneric[#[[1,1]]&/@ M$GenericPropagators]];

  SubValues[AnalyticalPropagator] =
    InitGenericPropagator@@@ M$GenericPropagators;
  SubValues[AnalyticalCoupling] =
    InitGenericCoupling@@@ M$GenericCouplings;

  If[ TrueQ[$GenericMixing],
    FAPrint[2, "> $GenericMixing is ON"];
    F$Generic = Flatten[{F$Generic,
      Cases[F$Generic, Mix[L_,R_] :> (
        Attach[Compatibles[0][R], Mix[L,R]];
        Attach[Compatibles[0][L], Rev[L,R]];
        Rev[L,R] )]}];
    AnalyticalPropagator[Internal][s_. Rev[fi__][i__]] :=
      AnalyticalPropagator[Internal][s Mix[fi][i] /. r_Rule :> Reverse[r]];
    AnalyticalPropagator[External][s_. (fi:(_Mix | _Rev)[__])] :=
      AnalyticalPropagator[External][s MixingPartners[fi][[-1]]],
  (* else *)
    FAPrint[2, "> $GenericMixing is OFF"]
  ];
  F$AllGeneric = F$Generic;

  (CheckFieldPoint[FieldPoint[_][##]] = True)&@@@
    FieldPointList[Generic];
	(* CheckFieldPoint must yield True in cases where some part
	   of the vertex is yet unknown, e.g. FieldPoint[0, V, V, V] *)
  CheckFieldPoint[fp_] :=
    MemberQ[fp, 0] || !FreeQ[fp, Field] ||
      Length[Union[AtomQ/@ fp]] =!= 1;

  PossibleFields[_][__] = {};
  SetPossibleFields[_, Table[0, {Length[#]}]&, FieldPointList[Generic]];

  $ContextPath = savecp;
  FAPrint[1, "generic model ", $GenericModel, " initialized"];
]


InitGenericPropagator[lhs_, rhs_] :=
  HoldPattern[Evaluate[PropFieldPattern/@ lhs]] :> PV[rhs]


(* BuildCombinations generates all combinations of valence 
   configurations of a vertex with n legs, e.g.
	Combinations[{f1_, f2_}, {h1_, h2_}] :=
	  { {{h1, FieldPoint[h1, f2]}, f1},
	    {{h2, FieldPoint[f1, h2]}, f2},
	    {{h1, FieldPoint[h1, h2]}, f1},
	    {{h2, FieldPoint[h1, h2]}, f2} }
   The first line is interpreted as: for the vertex FieldPoint[h1, f2] 
   where h1 is a `wildcard' (0 or a Generic field), f1 is a possible 
   field to insert. *)

BuildCombinations[n_] := 
Block[ {f, h, i, v},
  f = Array[ToExpression["f" <> ToString[#]]&, n];
  h = Array[ToExpression["h" <> ToString[#]]&, n];
  SetDelayed@@
    { Combinations[patt/@ f, patt/@ h],
      Flatten[Table[
        (v = f; Scan[(v[[#]] = h[[#]])&, #];
          { {h[[#]], FieldPoint@@ v}, f[[#]] }&/@ #)&/@ TupleList[n, i],
        {i, n} ], 2] }
]


(* TupleList[n, m] returns all possible m-tuples that can be constructed 
   from an n-tuple *)

TupleList[n_, 1] := Array[List, n]

TupleList[n_, m_] := TupleList[n, m] =
  Flatten[
    Function[z, Flatten[{z, #}]&/@ Range[Last[z] + 1, n]]/@
      TupleList[n, m - 1],
    1 ]


(* construct PossibleFields from the vertex lists: *) 

SetPossibleFields[cto_, func_, fp_] :=
Block[ {id = Sequence[], pl = {}},
  Scan[
	(* this is NOT the same as `=!=' since id = Sequence[] at first *)
    ( If[ !(#[[1]] === id),
        (PossibleFields[cto][##] = Union[pl])&@@ id;
        pl = {} ];
      id = #[[1]];
      AppendTo[ pl, #[[2]] ] )&,
    Append[ Union[Flatten[
      Combinations[List@@ #, func[List@@ #]]&/@ fp, 1 ]], {0, 0} ] ]
]


(* Transformation of Equal in the generic couplings to SetDelayed:
   lhs has to be changed to patterns, rhs is changed from
   G . {g1, g2, ...} to {G[g1], G[g2], ...} * {g1, g2, ...}.
   Both lhs and rhs get an additional argument, the counter-term order.
   Also, the function KinematicVector is defined which gives only the
   kinematic part of the coupling *)

InitGenericCoupling[lhs_, s_. g:G[_][__]] :=
  InitGenericCoupling[lhs, g . {s}]

InitGenericCoupling[AnalyticalCoupling[fg__], G[_][__] . kinvec_List] :=
  (Message[InitializeModel::rhs1, ToGeneric[{fg}]]; Seq[]) /;
  !FreeQ[kinvec, G]

InitGenericCoupling[AnalyticalCoupling[fg__], G[sym_][fc__] . kinvec_List] :=
Block[ {lhs, cpl, kin, sic, kv, x, Global`cto},
  lhs = CoupFieldPattern/@ {fg};
  Evaluate[cpl@@ lhs] = kinvec;

  (PermutationSymmetry[##] = sym)&@@ ToGeneric[lhs];

	(* put Mom and KI dummies in the fields on the rhs.  These dummies 
	   will appear as part of the Lorentz term indexing of the G's. *)
  x = (sic = 0; # /. IndexSum :> (#1 /. (SumDummies/@ {##2})&))&/@
    cpl@@ MapIndexed[KinDummies, {fg}];
  kv = KinematicVector@@ ToGeneric[{fg}];
  If[ Length[x] > Length[Union[x]],
    Message[InitializeModel::dup, kv] ];
  (# = x)&[kv];

  (HoldPattern[#1] :> #2)&[
    AnalyticalCoupling[Global`cto_]@@ lhs,
    PV[(G[sym][Global`cto][fc]/@ x) . kinvec] ]
]

InitGenericCoupling[AnalyticalCoupling[f__], _] :=
  (Message[InitializeModel::rhs2, ToGeneric[{f}]]; Seq[])


SumDummies[{i_, __}] := i -> SI[++sic]

SumDummies[i_] := i -> SI[++sic]


KinDummies[s_. (f:P$Generic)[__, ki_List], {n_}] :=
  s f[CI[n], Mom[n], Through[Take[KIs, Length[ki]][n]]]

KinDummies[s_. (f:P$Generic)[__], {n_}] := s f[CI[n], Mom[n]]


Off[RuleDelayed::rhs]


(* Change field representation to patterns.  Coupling patterns include
   ___ so that they match also in mixing cases. *)

PropFieldPattern[fi_[i_Symbol, m_Symbol]] := fi[i__, m_]

PropFieldPattern[fi_[i_Symbol, m_Symbol, ki:{___Symbol}]] := 
  fi[i__, m_, patt/@ ki]

PropFieldPattern[fi_[i_Symbol, m_Symbol, ki:({___Symbol} -> {___Symbol})]] := 
  fi[i__, m_, Map[patt, ki, {2}]]

PropFieldPattern[s_Symbol fi:_[___]] := s_. PropFieldPattern[fi]

PropFieldPattern[fi_] :=
  (Message[InitializeModel::nosymb, FullForm[fi]]; Abort[])


CoupFieldPattern[f:fi_[i_Symbol, m_Symbol]] := (
  If[Length[KinematicIndices[fi]] =!= 0, Message[InitializeModel::kinind, f]];
  fi[i__, m_, ___List] )

CoupFieldPattern[f:fi_[i_Symbol, m_Symbol, ki:{__Symbol}]] :=
  fi[i__, m_, KinIndices[f, ki]]

CoupFieldPattern[f:fi_[i_Symbol, m_Symbol, ki1:{__Symbol} -> ki2:{__Symbol}]] :=
  fi[i__, m_, KinIndices[f, ki1] -> KinIndices[f, ki2]]

CoupFieldPattern[s_Symbol fi:_[___]] := s_. CoupFieldPattern[fi]

CoupFieldPattern[fi_] :=
  (Message[InitializeModel::nosymb, FullForm[fi]]; Abort[])


KinIndices[f_, ki_] := (
  If[ Length[KinematicIndices[Head[f]]] =!= Length[ki],
    Message[InitializeModel::kinind, f] ];
  Append[patt/@ ki, ___] )


ToPatt[c_C] := ToPatt/@ c

ToPatt[c__C] := Map[ToPatt, Alternatives[c], {2}]

ToPatt[p_] := p /; !FreeQ[p, Verbatim[_] | Verbatim[__] | Verbatim[___]]

ToPatt[s_Symbol f_] := s_. ToPatt[f]

ToPatt[s_. f:P$Generic[__]] := s Replace[f, x_Symbol :> x_, {1, Infinity}]

ToPatt[other_] := other


patt = Pattern[#, _]&


(*On[RuleDelayed::rhs]*)


CloseKinematicVector[cpl_AnalyticalCoupling == g_ . kin_List] :=
Block[ {pattcpl, perm, inv, clokin, i},
  pattcpl = PropFieldPattern/@ cpl;
  perm = Sort[MapIndexed[Apply, ToGeneric[cpl]]];
  inv = InversePermutation[Level[perm, {2}]];
  perm = Permutations[Level[#, {2}]]&/@ SplitBy[perm, Head];
  perm = Flatten[Outer[cpl[[ Join[##][[inv]] ]]&, Sequence@@ perm, 1]];
  clokin = Replace[perm, {pattcpl :> kin, _ :> Seq[]}, {1}];
  clokin = Union@@ Replace[clokin, _Integer x_ :> x, {2}];
  With[ {c = C@@ ToClasses[pattcpl],
         v = Replace[clokin, Append[
           Thread[(i_Integer:1) kin -> i Array[Slot, Length[kin]]],
           _ -> NewComp[#1] ], {1}]},
    CloseCouplingVector[(lhs:c) == {rhs___}] := lhs == (v&)[rhs] ];
  cpl == g . clokin
]


NewComp[c_List] := Table[0, {Length[c]}]


SignMap[h_, fi_, r___] := {h[fi, r]} /; SelfConjugate[fi]

SignMap[h_, fi__] := {h[fi], h@@ -{fi}} 


AllFields[Mix[fi__][i_]] := SignMap[List, Mix[fi][i], Rev[fi][i]]

AllFields[fi_] := SignMap[List, fi]


Attributes[ClearDefs] = {HoldAll}

ClearDefs[defs_] := defs = Select[defs, FreeQ[#, P$Generic[__]]&]


(* Assigning the mixing propagators.  There are in general 4 cases:
	-->--~~>~~	 Mix[S,V] = {S, V}
	--<--~~<~~	-Mix[S,V] = {-S, -V} 
	~~>~~-->--	 Mix[V,S] = {V, S}
	~~<~~--<--	-Mix[V,S] = {-V, -S}  *)

SetMixing[Mix[L_,R_][i__], {sL_. (L:P$Generic)[iL__],
                             sR_. (R:P$Generic)[iR__]}] :=
Hold @	(* postpone until after SelfConjugate definitions *)
Block[ {j},
  MixingPartners[Mix[L,R][i, j___]] = {sL L[iL, j], sR R[iR, j]};
  MixingPartners[Rev[L,R][i, j___]] = {sR R[iR, j], sL L[iL, j]};
  Attach[Compatibles[Mix[L,R]][sR R[iR]], Mix[L,R][i]];
  Attach[Compatibles[Mix[L,R]][sL L[iL]], Rev[L,R][i]];
  If[ !SelfConjugate[Mix[L,R][i]],
    MixingPartners[-Mix[L,R][i, j___]] = {-sL L[iL, j], -sR R[iR, j]};
    MixingPartners[-Rev[L,R][i, j___]] = {-sR R[iR, j], -sL L[iL, j]};
    Attach[Compatibles[Mix[L,R]][-sR R[iR]], -Mix[L,R][i]];
    Attach[Compatibles[Mix[L,R]][-sL L[iL]], -Rev[L,R][i]] ]
]

SetMixing[fi_, _]  := (Message[InitializeModel::badmix, fi]; Abort[])


Attributes[Attach] = {HoldFirst}

Attach[c_, new___] := c = Union[Flatten[{c, new}]]


Attributes[Assign] = {Listable}

Assign[fi_, MixingPartners -> mix_] := SetMixing[fi, mix]

Assign[Mix[fi__][i_], a_ -> b_] := (
  SetProp[Mix[fi][i], a -> b];
  SetProp[Rev[fi][i], a -> rev[b]]; )

Assign[fi_, a_ -> b_] := (SetProp[fi, a -> b];)


rev[l_List] := Reverse[l]

rev[other_] := other


	(* e.g. Mass[Loop] -> ... *)
SetProp[fi_, a_[t___] -> b_] := SetProp[fi, t, a -> b]

SetProp[fi__, Mass -> b_] := TheMass[fi] = b

SetProp[fi__, PropagatorLabel -> b_] := TheLabel[fi] = b

SetProp[fi__, a_ -> b_] := a[fi] = b



TagCoupling[x_, {_, 1, __}] := x

TagCoupling[x_, {n__}] := x Coupling[n]


TagCoupling[coup_ == expr_, {n_}] := coup == 
  MapIndexed[#1 Coupling[n, #2[[1]] - 1]&, expr, {2}]


(* Initialization of a classes model: *)

Attributes[InitModel] = {HoldAll}

InitModel[edit_][mod_] :=
Block[ {SVTheC, sv, unsortedFP, unsortedCT, savecp = $ContextPath},
	(* no Global symbols allowed for these operations *)
  $ContextPath = DeleteCases[$ContextPath, "Global`"];
  $Model = "";

  Clear[CouplingDeltas, TheC, RenConst, MassShift];
  ClearDefs[SubValues[PossibleFields]];
  ClearDefs[DownValues[#]]&/@ {CheckFieldPoint,
    SelfConjugate, Indices, Compatibles, MixingPartners,
    TheMass, QuantumNumbers, MatrixTraceFactor,
    InsertOnly, Mixture, TheCoeff, IndexBase,
    TheLabel, PropagatorType, PropagatorArrow};

  FAPrint[2, ""];
  $Model = LoadModel[mod];
  edit;

	(* initialize particles:
	   set properties of classes from their description list: *)
  ReleaseHold[Assign@@@ M$ClassesDescription];
  SetCoeff[#][Mixture[#]]&@@@ M$ClassesDescription;

  F$Classes = First/@ M$ClassesDescription;
	(* set all possible index combinations for a class: *)
  F$AllParticles = Flatten[
    Function[ fi, If[ Indices[fi] === {}, fi,
      Outer[Append[fi, {##}]&, Sequence@@
        (IndexRange/@ Indices[fi] /. {} | _NoUnfold -> {_})] ] ]/@
      F$Classes ];
  F$Particles = F$AllParticles = Flatten[AllFields/@ F$AllParticles];

  FAPrint[2, "> ", Length[F$AllParticles],
    " particles (incl. antiparticles) in ",
    Length[F$Classes], " classes"];

  F$Classes = F$AllClasses = Flatten[AllFields/@ F$Classes];
  F$AllowedFields = Union[F$AllGeneric, F$AllClasses, F$AllParticles];

  _CouplingDeltas = Sequence[];

	(* forming the explicit and half-generic vertex lists: *)
  Off[RuleDelayed::rhs];

  If[ $SparseCouplings,
    SVTheC[fi___][kin_, rhs:{(0)..}] :=
      (svdef = HoldPattern[TheC[_][fi]] :> rhs; {}) ];
  SVTheC[fi___][kin_, rhs_] := HoldPattern[TheC[kin][fi]] :> rhs;

  {sv, unsortedFP} = Flatten/@ Transpose[
    InitCoupling@@@ Block[ {Coup},
      _Coup = 0;
      TheCoeff[fi_] := Throw[Message[InitializeModel::unknown, fi]];
      Scan[SetCoupling, If[ tagcoup, 
        MapIndexed[TagCoupling, M$CouplingMatrices, {4}],
      (* else *)
        M$CouplingMatrices ]];
      TheCoeff[fi_] =.;
      _Coup =.;
      DownValues[Coup]
    ] ];
  SubValues[TheC] = sv;

  On[RuleDelayed::rhs];

  ReferenceOrder[Classes] = Union[List@@@ unsortedFP];
  FieldPointList[Classes] = FieldPoint@@@ ReferenceOrder[Classes];

  L$CTOrders = Union[Cases[unsortedFP, FieldPoint[n_][__] :> n]];
  Scan[
    Function[ cto,
      unsortedCT = Union[Select[unsortedFP, #[[0,1]] === cto &]];
      FieldPointList[cto] = FieldPoint@@@ unsortedCT;
      FAPrint[2, "> ", Length[unsortedCT],
        If[ cto === 0, " vertices",
          " counterterms of order " <> ToString[cto] ]];
      (CheckFieldPoint[FieldPoint[cto][##]] = True)&@@@
        FieldPointList[cto];
      SetPossibleFields[cto, ToGeneric, FieldPointList[cto]] ],
    If[ $CounterTerms,
      FAPrint[2, "> $CounterTerms are ON"]; L$CTOrders,
      FAPrint[2, "> $CounterTerms are OFF"]; {0} ] ];

  FAPrint[1, "classes model ", $Model, " initialized"];
  $ContextPath = savecp;
]


CC[fi__] == coup_ ^:= Sequence[
  C[fi] == coup,
  AntiParticle/@ C[fi] == ConjugateCoupling[fi][coup]
]


ctoCoup[n_][c_] := If[ Length[c] < n, 0, c[[n]] ]

Couplings[cto_, All] :=
  MapAt[ctoCoup[cto + 1], M$CouplingMatrices, {All, 2, All}]

Couplings[cto_:0] := DeleteCases[Couplings[cto, All], _ == {0..}]


GetCouplings[c__C] := Cases[M$CouplingMatrices, ToPatt[c] == _]


Attributes[ReplaceCouplings] = {HoldAll}

ReplaceCouplings[a___, c_C += coup_, b___] :=
  ReplaceCouplings[a, c == c + coup, b]

ReplaceCouplings[a___, c_C -= coup_, b___] :=
  ReplaceCouplings[a, c == c - coup, b]

ReplaceCouplings[a___, c_C *= coup_, b___] :=
  ReplaceCouplings[a, c == c coup, b]

ReplaceCouplings[a___, c_C /= coup_, b___] :=
  ReplaceCouplings[a, c == c/coup, b]

ReplaceCouplings[cs__Equal] :=
Block[ {Cx, Cmod, done = {}},
  Cx[fi__] := CxSet[fi]@@ Cases[M$CouplingMatrices, ToPatt[C[fi]] == _];
  CmodSet[{cs}];
  Cmod[other_] := other;
  M$CouplingMatrices = Cmod/@ M$CouplingMatrices;
  Flatten[done]
]


Attributes[CmodSet] = {HoldAll, Listable}

CmodSet[c_C == coup_] :=
  Csetmod[c, ToPatt[c], Hold[coup] /. C -> Cx]

Csetmod[c_, pc_, Hold[coup_]] :=
  Cmod[pc == _] := (done = {done, #}; #)&[ c == coup ]


CxSet[fi__][c_ == coup_] := ((Cx[##] = coup)&@@ ToPatt[c]; Cx[fi])

CxSet[fi__][___] := C[fi]


ConjugateCoupling[__][ConjugateCoupling[__][coup_]] := coup

ConjugateCoupling[fi__][coup:(_Plus | _List)] :=
  ConjugateCoupling[fi]/@ coup

ConjugateCoupling[__][n:(_Integer | _Rational | _IndexDelta)] := n


(* form linear combinations of couplings *)

SetCoeff[fi_][fi_] := AppendTo[TheCoeff[fi], fi]

SetCoeff[fi_][p_Plus] := Scan[SetCoeff[fi], p]

SetCoeff[fi_][c_. Field[s_. (f:P$Generic)[i_, j___]]] :=
  AppendTo[TheCoeff[s f[i]], fi -> {c, j}]

SetCoeff[fi_][c_. (f:P$Generic)[i_, j___]] :=
  AppendTo[TheCoeff[f[i]], fi -> {c, j}]

SetCoeff[fi_][other_] := Message[InitializeModel::nonlin, other, fi]


SetCoupling[c:vert_ == _] :=
  Catch[SetCoupling[c, Distribute[TheCoeff/@ vert, List]]]

SetCoupling[vert_ == coup_, comb_] :=
  (Coup[vert] += coup) /; FreeQ[comb, Rule]

SetCoupling[vert_ == coup_, comb_] :=
Block[ {sign, vorig, vref, ord, o, new},
  sign = If[ PermutationSymmetry@@ ToGeneric[vert] === -1,
    Signature, 1 & ];
  vorig = vert;
  vref = vert /. s_. (f:P$Generic)[___] :> s f;
  o = ord = Ordering[vref];
  Attributes[new] = {Orderless};
  new[fi__] := (new[fi] = 0 &; SplitCoeff);
  Scan[(new@@ #)[coup, #]&, comb];
]


SplitCoeff[coup_, comb_] :=
Block[ {coeff, v, c, fn = 0},
  o[[ord]] = Ordering[Thread[{vref, comb /. (f_ -> _) :> f}, C]];
  c = coup sign[o];
  _coeff = {};
  v = C@@ DeleteCases[
    StripCoeff@@@ Thread[{vorig, comb}, C][[o]],
    {}, {-2} ];
  _coeff =.;
  Coup[v] += c Times@@
    (Plus@@ Times@@@ PermuteFields@@ Transpose[#2]&)@@@
    DownValues[coeff];
]


StripCoeff[f0_, -(fi_ -> {coeff_, ind___})] :=
  StripCoeff[f0, -fi -> {Conjugate[coeff], ind}]

StripCoeff[s0_. (f0:P$Generic)[i0_, patt___],
    s_. (f:P$Generic)[i_, ___] -> {lc_, ind___}] := (
  c = Subst[c, patt, ind];
  AppendTo[coeff[f[i]], {s0 f0[i0] -> lc, Thread[Indices[f[i]] -> #]}];
  s f[i, #]
)&[ IndexBase[Indices[f[i]], ++fn] ]

StripCoeff[_, s_. (fi:P$Generic)[i_, ___]] :=
  s fi[i, IndexBase[Indices[fi], ++fn]]


PermuteFields[fi_, ind_] :=
  Transpose[MapThread[ ReplaceAll,
    {Transpose[Map[Last, Permutations[fi], {2}]], ind} ]]


Attributes[IndexBase] = {Listable}

IndexBase[i_] := IndexBase[i] =
Block[ {n = "", ib = Cases[DownValues[IndexBase], _[_, s_String] :> s]},
  Scan[ If[ FreeQ[ib, n = n <> #], Return[] ]&,
    Flatten[{Characters[ToLowerCase[ToString@@ i]], "j", "q", "x"}]  ];
  n
]

IndexBase[i_, n_] := ToExpression[IndexBase[i] <> ToString[n]]


FieldPattern[s_. fi_[i_, j_List]] := s fi[i, j, _]

FieldPattern[s_. fi_[i_]] := s fi[i, _]

FieldPattern[other_] := other


(* InitCoupling converts a single classes coupling definition
   (Equal) to a function definition (SetDelayed).  It checks for
   compatibility of the generic and the classes coupling structure and
   sets the CouplingDeltas function for the field point.
   The structure of the classes coupling is
	{ {a[0], a[1], ...}, {b[0], b[1], ...}, ... }
   where a, b, etc. refer to the kinematic vector G = {Ga, Gb, ..} and
   the inner lists stand for increasing order of the vertices. *)

InitCoupling[_[_[vert_]], coup:{__List}] :=
Block[ {lhs, cv, sv, svdef = {}, fps, fp, x,
genref = ToGeneric[List@@ vert]},

	(* find corresponding generic coupling.
	   Note: whereas formerly the classes coupling was allowed to be
	         given in a different order than the generic coupling, a
	         strict match is now required *)
  If[ !MemberQ[ReferenceOrder[Generic], genref],
    Message[InitializeModel::nogeneric, vert]; Return[{}] ];

  cv = KinematicVector@@ genref;
  If[ Length[cv] =!= Length[coup],
    Message[InitializeModel::incomp1, vert, Length[cv]];
    Abort[] ];

	(* check structure of field indices in coupling *)
  If[ Or@@ (If[ SameQ@@ (x = IndexCount[#]), False,
        Message[InitializeModel::incomp2, vert, #, Sequence@@ x];
        True ]&)/@ vert,
    Abort[] ];

	(* change symbols in model file to patterns: *)
  lhs = Replace[vert, j_Symbol :> j_, {-1}];

	(* this assigns TheC for all components of the coupling vector *)
  sv = MapThread[SVTheC@@ FieldPattern/@ lhs,
    {cv /. SI[n_] :> SIs[[n]], coup}];

  lhs = VSort[lhs];
  cv = ToClasses[vert];
  fps = {};
  MapIndexed[
    If[ !VectorQ[#1, # === 0 &],	(* complete ct order is zero *)
      fp = FieldPoint[#2[[1]] - 1];
      fps = {fps, fp@@ cv};
      x = DeltaSelect[#1];
      If[ Length[x] =!= 0,
        (CouplingDeltas[#1] := #2)&[ fp@@ lhs, x ] ] ]&,
    Transpose[coup] ];
	(* transposing coup yields a list of coupling vectors for each
	   ct order: { {a[0], b[0], ...}, {a[1], b[1], ...}, ...} *)
  {{sv, svdef}, fps}
]

InitCoupling[_[_[vert_]], _] := (
  Message[InitializeModel::rhs3, vert];
  Abort[] )


IndexCount[_. fi_[n_, ndx_List:{}]] :=
  {Length[Indices[fi[n]]], Length[ndx]}

IndexCount[_] = {0, 0}


DeltaSelect[pre_ expr_] := DeltaSelect[expr] /; FreeQ[pre, IndexDelta]

DeltaSelect[expr_Times] := Cases[expr, _IndexDelta]

DeltaSelect[expr_List] :=
  Intersection@@ DeltaSelect/@ DeleteCases[expr, 0]

DeltaSelect[expr_Plus] :=
  If[ Head[#] === Plus, {}, DeltaSelect[#] ]& @
    Collect[expr, _IndexDelta] /;
  !FreeQ[expr, IndexDelta]

DeltaSelect[expr_IndexDelta] := {expr}

DeltaSelect[_] = {}


(* some defaults for the classes properties: *)

SelfConjugate[_Integer fi_] := SelfConjugate[fi]

SelfConjugate[fi_[i_, __]] := SelfConjugate[fi[i]]

_SelfConjugate = False


IndexRange[error_] := (
  Message[InitializeModel::norange, error];
  IndexRange[error] = {} )


Indices[_Integer fi_] := Indices[fi]

Indices[fi_[i_, __]] := Indices[fi[i]]

_Indices = {}


IndexSum[0, _] = 0

	(* need this for CloseKinematicVector: *)
IndexSum[n_?NumberQ r_, i___] := n IndexSum[r, i]

IndexSum[IndexDelta[i_, j_] r_., {i_, _}] := r /. (i -> j)


AddHC[h_[type___, i_, j_], weight_:(1&)] :=
  weight[i, j] h[type, i, j]/2 +
  weight[j, i] Conjugate[h[type, j, i]]/2

AddHC[h_, weight_:(1&)] :=
  weight[i, j] h/2 +
  weight[j, i] Conjugate[h]/2


KinematicIndices[Mix[fi__]] := KinematicIndices/@ {fi}

KinematicIndices[Rev[fi__]] := KinematicIndices[Mix[fi]] /. l:{__List} :> Reverse[l]

_KinematicIndices = {}


MatrixTraceFactor[_Integer fi_] := MatrixTraceFactor[fi]

MatrixTraceFactor[fi_[i_, __]] := MatrixTraceFactor[fi[i]]

_MatrixTraceFactor = 1


InsertOnly[_Integer fi_] := InsertOnly[fi]

InsertOnly[fi_[i_, __]] := InsertOnly[fi[i]]

_InsertOnly = {External, Internal, Loop}


QuantumNumbers[-fi_] := -QuantumNumbers[fi]

_QuantumNumbers = {}


Mixture[fi_[i_, j_, ___]] := Subst[Mixture[fi[i]], i, j]

Mixture[fi_, ___] := fi


TheCoeff[s_Integer f_] := s TheCoeff[f]

TheCoeff[fi_[i_, __]] := TheCoeff[fi[i]]

_TheCoeff = {}


(* There are no direct definitions for the masses of the particles since
   we want to keep track of the field contents of a propagator and the
   mass replacement rules (e.g. Mass[particle] = Mass[antiparticle])
   destroy this information.  All those definitions are given for the
   function TheMass. *)

TheMass[_Integer fi_, t___] := TheMass[fi, t]

TheMass[fi_[i_, j___List, t_Symbol, ___]] := TheMass[fi[i, j], t]

TheMass[fi___] := DefaultMass[fi]


DefaultMass[fi_[i_, j_List], t___] :=
Block[ {DefaultMass, m},
  IndexMass[m, j] /; Head[m = TheMass[fi[i], t]] =!= DefaultMass
]

DefaultMass[fi_, t_] :=
Block[ {m = TheMass[fi]}, m /; Head[m] =!= Mass ]

DefaultMass[fi__] = Mass[fi]


IndexMass[n_?NumberQ, _] := n

IndexMass[s_, {j___}] := s[j]


TheLabel::undef = "No label defined for `1`."

TheLabel[i_Integer, ___] := i

TheLabel[Mix[fi__], ___] := {fi}

TheLabel[Rev[fi__], ___] := Reverse[{fi}]

TheLabel[fi:P$Generic, ___] := fi

TheLabel[-fi_, t___] := TheLabel[fi, t]

TheLabel[fi:Mix[__][_]] := TheLabel/@ MixingPartners[fi]

TheLabel[fi:Rev[__][_]] := TheLabel/@ Reverse[MixingPartners[fi]]

TheLabel[fi___] := DefaultLabel[fi]


DefaultLabel[fi_[i_Integer, j_List], t___] :=
Block[ {DefaultLabel, l},
  (Subst[l, Indices[fi[i]], IndexStyle/@ j] /. _Index -> Null) /;
    Head[l = TheLabel[fi[i], t]] =!= DefaultLabel
]

DefaultLabel[fi_, t_] := TheLabel[fi]

DefaultLabel[h_[i___]] :=
  (Message[TheLabel::undef, h[i]]; ComposedChar[h, i])


IndexStyle[Index[_, i_]] := Alph[i]

IndexStyle[other_] := other


(* Note: AntiParticle[...] := AntiParticle[...] = ... is not possible
   because if another model with different SelfConjugate properties is
   loaded, AntiParticle must be rebuilt. *)

AntiParticle[0] = 0

	(* there are no antiparticles at Generic level.
	   It is important to have _Symbol here to prevent
	   AntiParticle[Field[i]] from being evaluated. *)
AntiParticle[fi_Symbol] := fi

AntiParticle[Mix[fi__]] := Rev[fi]

AntiParticle[Rev[fi__]] := Mix[fi]

AntiParticle[AntiParticle[fi_]] := fi

AntiParticle[s_. p:(fi:P$Generic)[i_, ___]] :=
  If[SelfConjugate[fi[i]], 1, -Sign[s]] p /.
    {Mix -> Rev, Rev -> Mix, mom_FourMomentum :> -mom}


PropagatorType[V] = Sine

PropagatorType[S] = ScalarDash

PropagatorType[U] = GhostDash

PropagatorType[-fi_] := PropagatorType[fi]

PropagatorType[Mix[fi__]] := PropagatorType/@ {fi}

PropagatorType[Rev[fi__]] := PropagatorType/@ Reverse[{fi}]

PropagatorType[fi_[i_, __]] := PropagatorType[fi[i]]

PropagatorType[fi:Mix[__][_]] := PropagatorType/@ MixingPartners[fi]

PropagatorType[fi:Rev[__][_]] := PropagatorType/@ Reverse[MixingPartners[fi]]

_PropagatorType = Straight


PropagatorArrow[_?Negative fi_] :=
  PropagatorArrow[fi] /. {Forward -> Backward, Backward -> Forward}

PropagatorArrow[fi_[i_, __]] := PropagatorArrow[fi[i]]

	(* mixing fields with different arrow properties makes not
	   much sense, so we just take left's one - override with
	   an explicit PropagatorArrow for the mixing field *)
PropagatorArrow[fi:(_Mix | _Rev)[_]] := PropagatorArrow[ MixingPartners[fi][[1]] ]

_PropagatorArrow = None


GaugeXi[_Integer fi_] := GaugeXi[fi]

GaugeXi[(fi:P$Generic)[i_, j___List, t_Symbol, ___]] := GaugeXi[fi[i, j]]


(* RestrictCurrentModel accepts any number of ExcludeFieldPoints or
   ExcludeParticles rules and correspondingly sets the CheckFieldPoint
   functions for the vertices to False or deletes the fields from the
   F$xxx lists
   RestrictCurrentModel[] removes all restrictions from the current
   model *)

RestrictCurrentModel::badfp =
"`1` is not a valid coupling specification of the form
FieldPoint[cto][fields]."

$ExcludedFPs = $ExcludedParticleFPs = {}

RestrictCurrentModel[] :=
Block[ {lG, lC, lP},
  lG = Length[F$AllGeneric] - Length[F$Generic];
  lC = Length[F$AllClasses] - Length[F$Classes];
  lP = Length[F$AllParticles] - Length[F$Particles];

  If[ {lG, lC, lP} =!= {0, 0, 0},
    F$Generic = F$AllGeneric;
    F$Classes = F$AllClasses;
    F$Particles = F$AllParticles;
    F$AllowedFields = Union[F$Generic, F$Classes, F$Particles];
    FAPrint[2, ""];
    FAPrint[2, "Restoring ",
      lG, " Generic, ", lC, " Classes, and ", lP, " Particles fields"] ];

  If[ (lP = Length[$ExcludedFPs] + Length[$ExcludedParticleFPs]) > 0,
    Scan[(CheckFieldPoint[#] = True)&, $ExcludedFPs];
    FAPrint[2, ""];
    FAPrint[2, "Restoring ", lP, " field point(s)"];
    $ExcludedFPs = $ExcludedParticleFPs = {} ];
]

RestrictCurrentModel[args__] :=
Block[ {ex, exclFP, exclP, lG, lC, lP, fps},
  ex = Select[ Flatten[{args}],
    If[ MatchQ[#, ExcludeParticles | ExcludeFieldPoints -> _], True,
      Message[InitializeModel::badrestr, #]; False ]& ];

  exclP = Union[Flatten[Cases[ex, (ExcludeParticles -> p_) :> p]]];
  If[ Length[exclP] > 0,
    exclP = Union[Flatten[
      Function[fi, Select[F$AllowedFields, FieldMatchQ[#, fi]&]]/@
        exclP ]];
    {lG, lC, lP} = Length/@ {F$Generic, F$Classes, F$Particles};
    F$Generic = Complement[F$Generic, exclP];
    F$Classes = Complement[F$Classes, exclP];
    F$Particles = Complement[F$Particles, exclP];
    F$AllowedFields = Complement[F$AllowedFields, exclP];
    FAPrint[2, ""];
    FAPrint[2, "Excluding ",
      lG - Length[F$Generic], " Generic, ",
      lC - Length[F$Classes], " Classes, and ",
      lP - Length[F$Particles], " Particles fields"] ];

  exclFP = Union[Flatten[Cases[ex, (ExcludeFieldPoints -> p_) :> p]]];
  If[ Length[exclFP] > 0,
    exclFP = Union[ VSort/@ #,
      VSort/@ Map[AntiParticle, #, {2}] ]&[ ValidFP/@ exclFP ];
    ex = Select[exclFP, !FreeQ[#, P$Generic[_, _]]&];
    $ExcludedParticleFPs = Union[Join[$ExcludedParticleFPs, ex]];
    fps = Cases[DownValues[CheckFieldPoint],
      (_[_[fp_]] :> True) :> fp];
    exclFP = Union[Flatten[
      Function[fi, Select[fps, FieldPointMatchQ[#, fi]&]]/@
        Complement[exclFP, ex] ]];
    Scan[(CheckFieldPoint[#] =.)&, exclFP];
    $ExcludedFPs = Union[Join[$ExcludedFPs, exclFP]];
    FAPrint[2, ""];
    FAPrint[2, "Excluding ", Length[exclFP] + Length[ex],
      " field point(s) (incl. charge-conjugate ones)"] ];

  {ExcludeParticles -> exclP, ExcludeFieldPoints -> exclFP}
]


ValidFP[FieldPoint[f__]] := FieldPoint[_][f]

ValidFP[f:FieldPoint[_][__]] := f

ValidFP[f_] := (Message[RestrictCurrentModel::badfp, f]; Seq[])


GenericMatchQ[(Mix | Rev)[fi__], (Mix | Rev)[fi__]] := True

GenericMatchQ[fi__] := MatchQ[fi]


FieldMatchQ[_. (fi:P$Generic)[___], _. fj:P$Generic] :=
  GenericMatchQ[fi, fj]

FieldMatchQ[_. (fi:P$Generic)[i_, ___], _. (fj:P$Generic)[j_]] :=
  GenericMatchQ[fi, fj] && MatchQ[i, j]

FieldMatchQ[_. (fi:P$Generic)[i__], _. (fj:P$Generic)[j_, {r__}]] :=
  GenericMatchQ[fi, fj] && MatchQ[{i}, {j, {r, ___}}]

FieldMatchQ[_. fi:P$Generic, _. fj:P$Generic] := GenericMatchQ[fi, fj]

FieldMatchQ[fi__] := MatchQ[fi]


FieldMemberQ[li_, fi_] := !VectorQ[List@@ li, !FieldMatchQ[#, fi]&]


FieldPointMatchQ[fp_, FieldPoint[f__]] := FieldPointMatchQ[fp, FieldPoint[_][f]]

FieldPointMatchQ[FieldPoint[cto1_][fi1__], FieldPoint[cto2_][fi2__]] :=
  MatchQ[cto1, cto2] && Length[{fi1}] === Length[{fi2}] &&
    Catch[
      If[ VectorQ[Transpose[{{fi1}, #}], (FieldMatchQ@@ #)&],
        Throw[True] ]&/@ Permutations[{fi2}];
      False ]

_FieldPointMatchQ = False


FieldPointMemberQ[li_, fp_] := !VectorQ[List@@ li, !FieldPointMatchQ[#, fp]&]


ExcludedQ[vertlist_] :=
  Catch[
    Outer[ If[FieldPointMatchQ[##], Throw[True]]&,
      VSort/@ vertlist, $ExcludedParticleFPs ];
    False ]

End[]

