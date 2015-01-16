(*
	Insert.m
		Insertion of fields into topologies created by 
		CreateTopologies.
		last modified 18 Jan 07 th

The insertion is done in 3 levels: insertion of generic fields (Generic),
of classes of a certain model (Classes) or of the members of the classes
(Particles).

Models are described in model files which are supposed to exist somewhere
on the $ModelPath.  At the beginning of an insertion InsertFields calls
Initialize`InitializeModel that checks whether the model is initialized or
not and performs the initialization if needed.

*)

Begin["`Insert`"]

Options[ InsertFields ] = {
  Model	-> "SM",
  GenericModel -> "Lorentz",
  InsertionLevel -> Classes,
  ExcludeParticles -> {}, 
  LastSelections -> {},
  ExcludeFieldPoints -> {},
  Restrictions -> {}
} 

InsertFields::syntax =
"The syntax of InsertFields is InsertFields[tops, in -> out, options]."

InsertFields::extnumber = 
"You cannot fit `1` -> `2` external particles onto a `3` -> `4` leg
topology."
			  
InsertFields::badparticle = 
"Particle `1` does not live in model `2`."

InsertFields::badsel =
"Element `1` of LastSelections is not a proper field specification."


InsertFields[ top:P$Topology, args__ ] :=
  InsertFields[TopologyList[top], args]

InsertFields[ tops:TopologyList[__] | TopologyList[__][__],
  initial_ -> final_, options___Rule ] :=
Block[ {mod, iorule, pp, ninc, nout, pinc, pout, iotops, fields,
ilevel, level, exclP, res, omit, need, topnr = 0,
opt = ActualOptions[InsertFields, options]},

  If[ (ilevel = ResolveLevel[InsertionLevel /. opt]) === $Failed,
    Return[$Failed] ];

  iorule = Flatten[{initial}] -> Flatten[{final}] /.
    _Integer p_Symbol -> p;
  ninc = Length[ iorule[[1]] ];
  nout = Length[ iorule[[2]] ];
  If[ !FreeQ[First[iotops = tops], External],
    iotops = tops /.
      Propagator[External][Vertex[1][j_], v2__] :>
        Propagator[ If[j > ninc, Outgoing, Incoming] ][Vertex[1][j], v2]
  ];
  pinc = Count[iotops[[1]], Incoming, Infinity, Heads -> True];
  pout = Count[iotops[[1]], Outgoing, Infinity, Heads -> True];
  If[ ninc =!= pinc || nout =!= pout,
    Message[InsertFields::extnumber, ninc, nout, pinc, pout];
    Return[$Failed]
  ];

  If[ InitializeModel[ mod = Model /. opt,
    GenericModel -> (GenericModel /. opt),
    Reinitialize -> False ] === $Failed, Return[$Failed] ];

  If[ Or@@ (If[ InModelQ[#], False,
    Message[InsertFields::badparticle, #, mod]; True ]&)/@
      Join@@ iorule,
    Return[$Failed] ];

  exclP = RestrictCurrentModel[ Restrictions /. opt,
    Cases[opt, _[ExcludeFieldPoints | ExcludeParticles, _]]
  ][[1, 2]];

  pp = Union[Flatten[{LastSelections /. opt}, 1]];
  omit = CheckProperField/@
    Join[ Cases[pp, !x_ -> x], Cases[exclP, _. P$Generic[_, _]] ];
  omit = Union[ Join[omit, AntiParticle/@ omit] ] /.
    (f:P$Generic)[i_, {j__}] -> f[i, {j, ___}];
  need = CheckProperField/@ Complement[
    pp /. !x_ -> x /. (f:P$Generic)[i_, {j__}] -> f[i, {j, ___}],
    omit ];

  AppendTo[opt, Process -> iorule];

  FAPrint[2, ""];
  FAPrint[2, "inserting at level(s) ", ilevel];

  fields = MapIndexed[ Field@@ #2 -> #1 &,
    Join[ iorule[[1]], AntiParticle/@ iorule[[2]] ] ];
  ninc = Length[fields];
  level = Last[ilevel];
  res = PickLevel[ilevel][
    (TopologyList@@ opt)@@ TopologyInsert/@ iotops ];

  FAPrint[1, "in total: ", Statistics[res, ilevel, " insertion"]];

  RestrictCurrentModel[];
  res /. Insertions -> NumberInsertions
]

InsertFields[ ___ ] := (Message[InsertFields::syntax]; $Failed)


CheckProperField[ fi_Alternatives ] := CheckProperField/@ fi

CheckProperField[ fi:P$Generic | _. P$Generic[__] ] = fi

CheckProperField[ fi_ ] := (Message[InsertFields::badsel, fi]; Seq[])


InModelQ[ s_. fi_[i_Integer, j_List] ] :=
Block[ {r, NoUnfold = Identity},
  InModelQ[s fi[i]] && Length[j] <= Length[Indices[fi[i]]] &&
    Catch[
      Apply[
        If[ IntegerQ[#2] &&
            Length[r = IndexRange[#1]] =!= 0 && !MemberQ[r, #2],
          Throw[False] ]&,
        Transpose[{Take[Indices[fi[i]], Length[j]], j}], 1 ];
      True ]
]

InModelQ[ p_ ] := MemberQ[F$AllowedFields, p]


FieldToString[ fi_[n_, ___] ] := ToString[fi] <> ToString[n]

FieldToString[ -fi_[n_, ___] ] := ToLowerCase[ToString[fi]] <> ToString[n]

FieldToString[ _ ] = "_"


(* add numbers to the Heads of each Graph, i.e.
   Graph[sym] -> Graph[sym, lev == num] *)

AddNumbering[ Graph[s_, ___][args__] -> ins_, n_ ] :=
  Graph[s, n][args] -> ins

AddNumbering[ Graph[s_, ___][args__], n_ ] := Graph[s, n][args]

NumberInsertions[ lev_ ][ gr___ ] :=
  Insertions[lev]@@
    MapIndexed[AddNumbering[ #1, lev == #2[[1]] ]&, {gr}]


(* TopologyInsert: insert fields into one topology *)

TopologyInsert[ Topology[pr__] -> ins_ ] :=
  TopologyInsert[Topology[1][pr] -> ins]

TopologyInsert[ Topology[pr__] ] :=
  TopologyInsert[Topology[1][pr]]

(* start from scratch if someone wants to re-insert Generic level *)

TopologyInsert[ top_ -> Insertions[_][__] ] :=
  TopologyInsert[top] /; level === Generic

(* allow insertion on top of old insertions only if external particles
   are the same: *)

TopologyInsert[ top_ -> Insertions[_][ins_, ___] ] :=
  TopologyInsert[top] /; fields =!= List@@ Take[ins, ninc]

(* add Field[n] to propagator and append Insertions template: *)

AddFieldNo[ p_[from_, to_, ___], fn_ ] := p[from, to, Field@@ fn]

TopologyInsert[ top:Topology[_][__] ] :=
  TopologyInsert[ MapIndexed[AddFieldNo, top] ->
    { Graph@@ Join[fields,
      Array[Field[#] -> 0 &, Length[top] - ninc, ninc + 1]] } ]

TopologyInsert[ top:Topology[_][__] -> ins_ ] :=
Block[ {vertli, fpoints, res, topol = top},
  fpoints = Map[
    Function[ v, FieldPoint[ CTO[v] ]@@ (TakeInc[v, #]&)/@ top ],
    DeleteCases[Take[#, 2], Vertex[1][_]]&/@ top,
    {2} ];
  vertli = Union[Flatten[ Apply[List, fpoints, {0, 1}] ]];

	(* if the field points exist with the external particles
	   inserted, start insertion process *)
  res =
    If[ VectorQ[vertli /. ToClasses[fields], CheckFP],
      Catch[ DoInsert[level][ins] ],
      Insertions[Generic][] ];
  FAPrint[2, "> Top. ", ++topnr, ": ",
    Statistics[top -> res, ilevel, " insertion"]];
  top -> res
]

TopologyInsert[ other_ ] = other


CTO[ Vertex[_, c_][__] ] = c

CTO[ _ ] = 0


RightPartner[ fi_ ] := MixingPartners[fi][[-1]] /; FreeQ[fi, Field]


ParticleLookup[ fp_, SV ] :=
  Flatten[ SVCompatibles/@
    Lookup[ fp[[0, 1]] ][V, FieldPoint@@ (fp /. _Field -> V)] ]

ParticleLookup[ fp_, VS ] :=
  Flatten[ SVCompatibles/@
    Lookup[ fp[[0, 1]] ][S, FieldPoint@@ (fp /. _Field -> S)] ]

ParticleLookup[ fp_, p_ ] :=
  Flatten[ Compatibles/@
    Lookup[ fp[[0, 1]] ][p, FieldPoint@@ (fp /. _Field -> p)] ]


Lookup[ cto_?NonNegative ] = PossibleFields[cto]

Lookup[ cto_ ][ 0, fp_ ] := PossibleFields[-cto][0, fp]

Lookup[ _ ][ p_, fp_ ] :=
Block[ {n = Position[fp, p, {1}, 1]},
  Select[
    Select[F$Classes, !FreeQ[#, p]&],
    VFAllowed[ReplacePart[fp, #, n]]& ]
]


CheckFP[ fp:FieldPoint[_?NonNegative][__] ] :=
  CheckFieldPoint[ Sort[fp] ]

CheckFP[ fp_ ] :=
  !FreeQ[fp, Field] ||
  ( MemberQ[FieldPoints[Generic], FieldPoint@@ ToGeneric[fp] /. 0 -> _] &&
    VFAllowed[fp] )


VFAllowed[ fp_ ] := True /; MemberQ[fp, 0 | P$Generic]

VFAllowed[ fp_ ] :=
  ViolatesQ@@ Flatten[QuantumNumbers/@ List@@ fp] =!= True


(* Insert compatible particles in 1 propagator for 1 set of rules: *)

Ins11[ vert12_, ru_, i_ ] := 
Block[ {vx, p = ru[[i, 2]], leftallowed, rightallowed, allowed, ckfp},

  vx = Map[ RightPartner,
    If[ SameQ@@ vert12,		(* tadpole *)
      Take[vert12, 1],
      vert12 ] /. Delete[List@@ ru, i],
    {2} ];

  leftallowed = ParticleLookup[vx[[1]], AntiParticle[p]];

  ckfp[ n_, fi_ ] := CheckFP[ vx[[n]] /. Field[i] -> fi ];

  allowed = If[ Length[vx] === 1,	(* tadpole *)
    Select[ Intersection[leftallowed, F$AllowedFields], ckfp[1, #]& ],
  (* else *)
    leftallowed = AntiParticle/@ leftallowed;
    rightallowed = ParticleLookup[vx[[2]], p];
    Select[
      Intersection[leftallowed, rightallowed, F$AllowedFields],
      ckfp[1, #] && ckfp[2, #] & ]
  ];

  If[ TrueQ[Global`$FADebug],
    Print["Ins11: inserting field ", p];
    Print["Ins11: L-vertex  = ", vert12[[1]]];
    Print["Ins11: R-vertex  = ", vert12[[2]]];
    Print["Ins11: L-allowed = ", leftallowed];
    Print["Ins11: R-allowed = ", rightallowed];
    Print["Ins11: allowed   = ", allowed];
  ];

  p = vert12[[0, 1]];
  (ru /. (Field[i] -> _) -> (Field[i] -> #))&/@
    Select[allowed, InsertOK[#, p]&]
]


(* check whether field is allowed on type of propagator *)

InsertOK[ _Integer fi_, p_ ] := InsertOK[fi, p]

InsertOK[ fi_, _ ] := True /; Head[InsertOnly[fi]] === InsertOnly

InsertOK[ fi_, Loop[_] ] := !FreeQ[InsertOnly[fi], Loop]

InsertOK[ fi_, Internal ] := !FreeQ[InsertOnly[fi], Internal]

InsertOK[ fi_, io:Incoming | Outgoing | External ] :=
  !FreeQ[InsertOnly[fi], io | External]


(* insert the ith propagator: *)

Ins1[ ru_, i_ ] :=
Block[ {ins},
  ins = Flatten[ Ins11[fpoints[[i]], #, i]&/@ ru ];
  If[ Length[ins] === 0, Throw[ins] ];
  ins
]


Need[ ] = Sequence[]

Need[ fi__ ] := Select[#, ContainsQ[Drop[#, ninc], {fi}]&]&

Omit[ ] = Sequence[]

Omit[ fi__ ] := Select[#, FreeQ[Drop[#, ninc], Alternatives[fi]]&]&


(* insertion at generic level: *)

DoInsert[Generic][ ins_ ] :=
Block[ {freesites, theins, filter},
  freesites = Flatten[ Position[ins[[1]], _ -> 0, 1] ];

  filter = Composition[
    Need@@ (Cases[need, P$Generic | _[P$Generic..]] /. SV :> Seq[SV, VS]),
    Omit@@ (Cases[omit, P$Generic | _[P$Generic..]] /. SV :> Seq[SV, VS]) ];

  theins = Insertions[Generic]@@
    InsertionsCompare[ topol,
      filter[ Catch[Fold[Ins1,
        ToGeneric[ins /. (2 | -2) SV[__] -> VS], freesites]] ] ] /.
		(* restore unstripped rules *)
    Cases[ ins[[1]], ru:(fi_ -> p_ /; p =!= 0) -> ((fi -> _) -> ru) ];

  If[ Length[theins] === 0, Throw[theins] ];
  theins
]


(* insertion at classes level: *)

DoInsert[Classes][ ins_ ] :=
Block[ {theins, rul, freesites, filter, pfilter},
  theins = ToClasses[ rul = ins /.
    (x_ -> Insertions[Classes | Particles][___]) -> x ];

	(* Generic fields count as free sites at classes level *)
  freesites = Flatten[ Position[theins[[1]], _ -> _?AtomQ, 1] ];

  If[ Head[theins] =!= Insertions[Generic],
    theins = DoInsert[Generic][theins] ];

  filter = Composition[
    Need@@ Cases[need, _. P$Generic[_] | _[(_. P$Generic[_])..]],
    Omit@@ Cases[omit, _. P$Generic[_] | _[(_. P$Generic[_])..]] ];
  pfilter =
    If[ Length[$ExcludedParticleFPs] === 0,
      Identity,
      Select[#, !ExcludedQ[vertli /. List@@ #]&]& ];

  theins =
    (# -> Insertions[Classes]@@ InsertionsCompare[
            Topology[ #[[0, 1]] ]@@ topol,
            filter[ Catch[Fold[Ins1, {Graph@@ #}, freesites]] ] ]
    )&/@ theins /.
		(* restore unstripped rules *)
    Cases[ rul[[1]], ru:(fi_ -> _?(!AtomQ[#]&)) -> ((fi -> _) -> ru) ] /.
    cins:Insertions[Classes][__] :> pfilter[ProvideIndices/@ cins];

  theins = Select[theins, Length[ #[[2]] ] =!= 0 &];
  If[ Length[theins] === 0, Throw[theins] ];
  theins
]


Attributes[IndexDelta] = {Orderless}

IndexDelta[ n_, n_ ] = 1

	(* Caveat: do not discard the n on n_Integer, or else
	   the IndexDelta[n_, n_] rule will apply! *)
IndexDelta[ n_Integer, _Integer ] = 0

Conjugate[ IndexDelta[ind__] ] ^:= IndexDelta[ind]

IndexDelta[ ind__ ]^_?Positive ^:= IndexDelta[ind]

ext/: IndexDelta[ ext[_], ext[_] ] = 1


AppendIndex[ Field[ind_] -> s_. fi:_[_] ] :=
  (Field[ind] -> s Append[ fi, Append[#, ind]&/@ Indices[fi] ]) /;
  Indices[fi] =!= {}

AppendIndex[ Field[ind_] -> s_. fi_[i_, j_List] ] :=
  (Field[ind] -> s fi[i, Join[ j,
    Append[#, ind]&/@ Drop[Indices[fi[i]], Length[j]] ]]) /;
  Length[j] < Length[Indices[fi[i]]]

AppendIndex[ ru_ ] = ru


ProvideIndices[ ru_ ] :=
Block[ {indexru, extind, deltas},
  indexru = AppendIndex/@ ru;
  extind = Alternatives@@ DeleteCases[
    Union@@ Cases[Take[indexru, ninc], _List, Infinity],
    _Integer ];
  deltas = Union[ Flatten[
    Diagonal[VSort[#]]&/@ Flatten[vertli /.
      Distribute[
        Thread[MapAt[MixingPartners, #, 2]]&/@ List@@ indexru,
        List ]] ] ];
  EvaluateDelta[ indexru, deltas /. e:extind :> ext[e] ]
]


EvaluateDelta[ expr_, {} ] :=
Block[ {c},
  c[ _ ] = 0;
  c[ t_, n_ ] := c[t, n] = ++c[t];
  expr /. Index[t_, n_] :> Index[t, c[t, n]]
]

	(* For unequal integers: *)
EvaluateDelta[ _, {0, ___} ] = Sequence[]

EvaluateDelta[ expr_, {IndexDelta[_ext, _Integer], rest___} ] :=
  EvaluateDelta[expr, {rest}]

EvaluateDelta[ expr_, {IndexDelta[ind1_ext, ind2_], rest___} ] :=
  EvaluateDelta[expr /. ind2 -> ind1[[1]], {rest} /. ind2 -> ind1]

EvaluateDelta[ expr_, {IndexDelta[ind1_Integer, ind2_], rest___} ] :=
  EvaluateDelta[expr /. ind2 -> ind1, {rest} /. ind2 -> ind1]

EvaluateDelta[ expr_, {IndexDelta[ind1_, ind2_Index], rest___} ] :=
  EvaluateDelta[expr /. ind2 -> ind1, {rest} /. ind2 -> ind1]

EvaluateDelta[ expr_, {IndexDelta[ind1_, ind2_], rest___} ] :=
  EvaluateDelta[expr /. ind2 -> ind1, {rest} /. ind2 -> ind1]

EvaluateDelta[ expr_, {_, rest___} ] := 
  EvaluateDelta[expr, {rest}]


(* insertion at particles level: *)

DoInsert[Particles][ ins_ ] :=
Block[ {theins, filter},
  theins = ins /. (x_ -> Insertions[Particles][__]) -> x;
  If[ FreeQ[theins, Insertions[Classes]],
    theins = DoInsert[Classes][theins] ];

  filter = Composition[
    If[ Length[$ExcludedParticleFPs] === 0,
      Identity,
      Select[#, !ExcludedQ[vertli /. List@@ #]&]& ],
    Need@@ Cases[need, _. P$Generic[_, _] | _[(_. P$Generic[_, _])..]],
    Omit@@ Cases[omit, _. P$Generic[_, _] | _[(_. P$Generic[_, _])..]] ];

  theins /. cins:Insertions[Classes][__] :> IndexVariations/@ cins
]


IndexVariations[ gr:Graph[s_, ___][ru__] ] :=
Block[ {ins, li, NoUnfold},
  NoUnfold[__] = {};
  ins = DeleteCases[
    Thread[ # -> IndexRange[Take[#, 1]] ]&/@ 
      Union[Cases[{ru}, Index[__], Infinity]], {} ];
  If[ Length[ins] =!= 0,
    ins = Flatten[ Outer[li, Sequence@@ ins] ] /. li -> List ];
  If[ Length[ins] === 0,
    Return[gr -> filter[Insertions[Particles][gr]]] ];
  ins = InsertionsCompare[ Topology[s]@@ topol, filter[{ru} /. ins] ];
  gr -> Insertions[Particles]@@ ins
]


InsertionsCompare[ _, {} ] = {}

InsertionsCompare[ top_, ins_ ] :=
Block[ {intp, loo, all, disj, fno},
	(* only attempt to compare disjoint insertions *)
  intp = Cases[top, Propagator[Internal][_, _, fi_] -> fi];
  loo[ _ ] = 0;
  Cases[top, Propagator[Loop[n_]][_, _, fi_] :> (loo[n] += fi)];
  all = {intp, Times@@ Cases[DownValues[loo], (_ :> p_Plus) -> p]} /.
    (Apply[List, ins, 1] /. s_?Negative -> -s);
  disj = Apply[List, ins[[ Flatten[Position[all, #, 1]] ]], {0, 1}]&/@ 
    Union[all];
  all = TopologyList@@ (Compare[TopologyList@@ (top /. #)]&)/@ disj;
  fno = List@@ Last/@ top;
  (Graph[ #[[0, 1]] ]@@ Thread[fno -> Last/@ List@@ #]&)/@ all
]

End[]

