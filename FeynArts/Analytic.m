(*
	Analytic.m
		Translation of InsertFields output into
		analytic expressions
		last modified 1 Mar 00 th
*)

Begin["`Analytic`"]

Options[ CreateFeynAmp ] = {
  AmplitudeLevel -> InsertionLevel,	(* i.e. taken from InsertFields *)
  GaugeRules -> GaugeXi[_] -> 1,
  HoldTimes -> False,
  PreFactor -> -I (2 Pi)^(-4 LoopNr),
  Truncated -> False,
  MomentumConservation -> True
}

(* for D dimensions use
   PreFactor -> -I (Global`Mu^(4 - $D) / (2 Pi)^$D)^LoopNr *)

CreateFeynAmp::nolevel =
"Warning: Level `1` is not contained in this insertion."

CreateFeynAmp::mtrace =
"Different MatrixTraceFactors inside one loop. Involved fields are `1`.
Please check the classes model and try again."

CreateFeynAmp::noprop =
"Cannot resolve propagator of field `1`."

CreateFeynAmp::novert =
"Cannot find vertex `1`."

CreateFeynAmp::nocoupl =
"Cannot resolve coupling `1` for kinematical object `2`."

CreateFeynAmp::counter =
"Counter-term order `2` is not defined in coupling of `1`."


(* CreateFeynAmp invokes a hierarchy of functions:
     CreateFeynAmp[TopologyList]	select levels, init model
       CreateAmpTop[Topology]		add momenta, make fermion chains
         CreateAmpGraph[Graph]		add indices, make generic expr
           CreateAmpIns[Graph -> Ins]	add GM replacement rules *)

CreateFeynAmp[ top:(P$Topology -> _), opt___Rule ] :=
  CreateFeynAmp[ TopologyList[][top], opt ]

CreateFeynAmp[ TopologyList[tops__], opt___Rule ] :=
  CreateFeynAmp[ TopologyList[][tops], opt ]

CreateFeynAmp[ TopologyList[info___][], ___ ] :=
  FeynAmpList[info][] /.
    (Process -> iorule_) :>
      (Process -> MapIndexed[{#1, iomom@@ #2, TheMass[#1]}&, iorule, {2}])

CreateFeynAmp[ tops:TopologyList[info___][__], options___Rule ] :=
Block[ {alevel, name, kinobjects, pref, next, gaugeru, truncru, momcons,
vfuncs, Mult, topnr = 1, opt = ActualOptions[CreateFeynAmp, options]},

  If[ (alevel = ResolveLevel[AmplitudeLevel /. opt /. {info} /.
        Options[InsertFields]]) === $Aborted,
    Return[$Aborted] ];

  If[ InitializeModel[ Model /. {info} /. Options[InsertFields],
    GenericModel -> (GenericModel /. {info} /. Options[InsertFields]),
    Reinitialize -> False ] === $Aborted, Return[$Aborted] ];

  FAPrint[2, ""];
  FAPrint[2, "creating amplitudes at level(s) ", alevel];

  kinobjects = Prepend[
    Take[ KIarr,
      Length[ Union[Flatten[Last/@ DownValues[KinematicIndices]]] ] ],
    Mom ];
  name = ProcessName /. {info};
  vfuncs = TrueQ[VertexFunctions /. {info}];
  next = Plus@@ Length/@ (Process /. {info});
  pref = PreFactor /. opt;
  gaugeru = GaugeRules /. opt;
  truncru = If[ TrueQ[Truncated /. opt], M$TruncationRules, {} ];
  If[ !(HoldTimes /. opt), Mult = Times ];
  momcons = TrueQ[MomentumConservation /. opt];

  amps = PickLevel[alevel][tops];
  Scan[ If[FreeQ[amps, #], Message[CreateFeynAmp::nolevel, #]]&, alevel ];

  amps = CreateAmpTop/@ ( amps //.
    (_ -> Insertions[_][]) :> Seq[] /.
    (Field[i_] -> fi_?AtomQ) -> (Field[i] -> fi[Index[Generic, i]]) );
  WriteStatistics[1, "in total: ",
    {Insertions[Generic]@@ amps}, alevel, " amplitudes"];

  amps = (FeynAmpList[info] /.
    (Process -> iorule_) :> (Process ->
      MapIndexed[{#1, iomom@@ #2, TheMass[#1]}&, iorule, {2}]))@@ amps /.
    MTF[__] -> 1 //. M$LastModelRules;

  If[ Length[alevel] === 1, PickLevel[ alevel[[1]] ][amps], amps ]
]


iomom[ 1, n_ ] = FourMomentum[Incoming, n]

iomom[ 2, n_ ] = FourMomentum[Outgoing, n]


CreateAmpTop[ P$Topology ] = Sequence[]

CreateAmpTop[ top:P$Topology -> ins_ ] :=
Block[ {momtop, imom, oldmom, amp, c, toppref, mtf, mc = 0, gennr = 0},

	(* append momenta and enforce momentum conservation for
	   every vertex. For economical reasons, external momentum
	   conservation (i.e. elimination of one momentum) is not
	   carried out. *)
  c[ _ ] = 0;
  momtop = AppendMomentum/@ top;
  If[ momcons,
	(* since we don't touch the external momenta, it's
	   important to go through the vertices last to first
	   because the first are always those that connect the
	   external particles *)
    momtop = Catch[
      Fold[
        MomConservation,
        momtop,
        Reverse[
          Cases[top, Vertex[n__][_] /; {n} =!= {1}, {2}] //.
            {a___, x_, b___, x_, c___} :> {a, x, b, c} ] ] ]
  ];
	(* renumber the internal momenta *)
  oldmom = Union[ Cases[momtop, FourMomentum[_ZZZ, _], Infinity] ];
  imom = Apply[RenumberMom, oldmom, 1];
  momtop = momtop /. Thread[oldmom -> imom];

  toppref = pref /. LoopNr :> Genus[top];

  amp = Sequence@@ (CreateAmpGraph[momtop, #]&)/@ ins;
  WriteStatistics[2, "> Top. ", topnr++, ": ",
    {Insertions[Generic][amp]}, alevel, " amplitudes"];
  amp
]


(* loop number using Euler's relation: *)

Genus[ top_ ] := 
Block[ {c, vn = {}},
  c[ n_ ] := (AppendTo[vn, n]; 0);
  ++c[ #[[0, 1]] ]&/@ Union[Cases[top, Vertex[__][_], {2}]];
  (Plus@@ ((# - 2) * c[#] &)/@ vn) / 2 + 1
]


FourMomentum[ type_, n_Integer mom_ ] :=
  -FourMomentum[type, -n mom] /; n < 0


	(* ZZZ[priority] gives a ranking for eliminating momenta:
	   of the sorted list of momenta at a vertex the last is
	   eliminated, hence ZZZ[4] is eliminated before ZZZ[3] etc.
	   Since momenta on tree propagators (Propagator[Internal])
	   can always be expressed by the external momenta, they
	   have the highest priority. *)

	(* in case a momentum is given from outside: *)
AppendMomentum[ Propagator[type_][from_, to_, fi_, mom_] ] :=
  Propagator[type][ from, to, fi,
    FourMomentum[type /. {Loop[_] -> ZZZ[1], Internal -> ZZZ[3]},
      mom /. FourMomentum[_, t_] -> t] ]

AppendMomentum[ pr:Propagator[Outgoing][from_, __] ] :=
  Append[ pr,
    If[from[[0, 1]] === 1, -1, 1] FourMomentum[Outgoing, ++c[Outgoing]] ]

AppendMomentum[ pr:Propagator[Incoming | External][from_, __] ] :=
  Append[ pr,
    If[from[[0, 1]] === 1, 1, -1] FourMomentum[Incoming, ++c[Incoming]] ]

AppendMomentum[ pr:Propagator[Loop[_]][__] ] :=
  Append[ pr, FourMomentum[ZZZ[2], ++c[Internal]] ]

AppendMomentum[ pr:Propagator[Internal][__] ] :=
  Append[ pr, FourMomentum[ZZZ[4], ++c[Internal]] ]


RenumberMom[ _, _Integer ] := FourMomentum[Internal, ++mc]

RenumberMom[ _, id_ ] = FourMomentum[Internal, id]


MomConservation[ top_, vert_ ] := Throw[top] /; FreeQ[top, ZZZ]

MomConservation[ top_, vert_ ] :=
Block[ {eq},
  eq = Plus@@ (IncomingMomentum[vert, #]&)/@ top;
  If[ eq === 0 || (Head[eq] === Plus && FreeQ[eq, ZZZ]), top,
    top /. If[ Head[eq] =!= Plus, eq -> 0,
      Solve[ eq == 0,
        Sort[Cases[{eq}, _FourMomentum, Infinity]][[-1]] ][[1]] ]
  ]
]

IncomingMomentum[ v_, _[v_, v_, ___] ] = 0

IncomingMomentum[ v_, _[v_, _, ___, m_] ] = -m

IncomingMomentum[ v_, _[_, v_, ___, m_] ] = m

IncomingMomentum[ __ ] = 0


app[ fi_ ] = fi


CreateAmpGraph[ top_, gr:Graph[s_, ___][__] -> ins_ ] :=
Block[ {amp, gm, rawgm, orig, anti},
	(* must save Field[n] information to be able to subsequently
	   apply the insertion rules of deeper levels *)
  amp = CreateAmpGraph[ top,
    gr /. (n_ -> x_. fi_[i__]) :> (n -> x fi[i, orig[x, n]]) ];
  gm = Append[
    Union[ Cases[amp[[3]],
      G[_][_][__][__] | Mass[_] | GaugeXi[_] | VertexFunction[_][__],
      Infinity] ],
    RelativeCF ];
  rawgm = gm /.
    s1_. _[__, orig[s2_, fi_], k___] :>
      app[ If[s1 === s2, fi, anti[fi]], k ];
  Append[amp, gm -> (CreateAmpIns[rawgm, s mtf, #]&)/@ ins] /.
    orig[__] :> Seq[]
]

(* Create the basic amplitude *)

CreateAmpGraph[ top_, Graph[s_, ___][ru__] ] :=
Block[ {c, res, props, vert, faden, prden = {},
scalars = {RelativeCF, toppref, 1 / s}},

  c[ _ ] = 0;
  res = AddKinematicIndices/@ (List@@ top /. {ru});
  mtf = 1;
  If[ $FermionLines, res = MakeFermionChains[res] ];

	(* props contains the propagators not involved in gmcs *)
  props = Cases[res, Propagator[_][__]];
  vert = Vertices[props];

	(* insert the vertices in fermion chains first. Note that
	   VertexInChain modifies vert *)
  res = res /. {
    dot[c__] :> dot[VertexInChain[c]],
    tr[c__] :> tr[VertexAtEnds[VertexInChain[c]]] };

	(* now the remaining vertices *)
  vert = Function[ v,
    ResolveGeneric[
      Append[Head[v], 0][[2]], v, Select[props, !FreeQ[#, v]&] ] ]/@ vert;

	(* TakeNC does the multiplication business. It also updates
	   scalars and prden *)
  res = Join[vert, res /. Propagator -> ResolvePropagator /. gaugeru] /.
    PV -> TakeNC;

  FeynAmp[
    GraphName[name, Topology == topnr, Generic == ++gennr],
    Integral@@ imom,
    Mult@@ DeleteCases[Flatten[scalars], 1] *
      LoopPD[Expand[Times@@ Flatten[prden], PropagatorDenominator]] *
      Times@@ res /.
      {dot -> FermionChain, tr -> MatrixTrace} /.
      truncru //. M$LastGenericRules /. Mass -> TheMass ]
]


AddKinematicIndices[
  Propagator[type_][vert__, s_. fi_[ind___], mom_] ] :=
Block[ {ki = KinematicIndices[fi], kin},
  If[ Length[ki] === 0, kin = Seq[],
    kin = If[ FreeQ[{vert}, Vertex[1]],
      Rule@@ Transpose[{Index[#, ++c[#]], Index[#, ++c[#]]}&/@ ki],
    (* else *)
      Index[#, ++c[#]]&/@ ki
    ] ];
  Propagator[type][vert, s fi[ind, mom, kin]]
]


(* Building fermion chains.
   An unsolved problem lies in the construction of multiple fermion
   chains that touch. This is possible only in non-renormalizable
   theories, for instance the Fermi model. To my knowledge the only 100%
   reliable method of determining how the fermion chains are to be
   concatenated comes from the Lagrangian. This information is, however,
   not available here.
   In such a case $FermionLines = False must be set and the fermion fields
   must carry a Dirac index with which it is possible to find the correct
   fermion chains. *)

ReverseProp[ pr_[from_, to_, part_] ] :=
  pr[to, from, AntiParticle[part]]

Attributes[BuildChain] = {Flat, Orderless}

BuildChain[
  c1:gmc[___, _[_, v_, _. fi_[__]]],
  c2:gmc[_[v_, _, _. fi_[__]], ___] ] := Join[c1, c2]

BuildChain[
  c1:gmc[___, _[_, v_, _. fi_[__]]],
  c2:gmc[___, _[_, v_, _. fi_[__]]] ] :=
  Join[c1, Reverse[ReverseProp/@ c2]]

BuildChain[
  c1:gmc[_[v_, _, _. fi_[__]], ___],
  c2:gmc[_[v_, _, _. fi_[__]], ___] ] :=
  Join[Reverse[ReverseProp/@ c1], c2]


Fixgmc[ c__ ] := tr[c] /; FreeQ[{c}, Vertex[1]]

	(* a Dirac fermion, and it's in the right place *)
Fixgmc[ c:_[__, -_], r___ ] := dot[c, r]

	(* assuming that the front end must be a Majorana fermion, then *)
Fixgmc[ r___, c:_[__, -_] ] := dot[r, c]

	(* in principle there is no convention how to order Majorana
	   lines; this is just an attempt to get some order for
	   calculational convenience ;-) *)
Fixgmc[ c1:_[__, _?SelfConjugate], r___, c2:_[__, f_?SelfConjugate] ] :=
  dot[c1, r, c2] /; FreeQ[f, Outgoing]

	(* could still be two Majorana fermions, but reversing the chain
	   makes no difference in that case *)
Fixgmc[ c__ ] := Reverse[ ReverseProp/@ dot[c] ]


MakeFermionChains[ top_ ] := top /; FreeQ[top, F | U]

MakeFermionChains[ top_ ] :=
Block[ {res, ext},
  res = Select[top, !FreeQ[#[[3]], F | U]&];
  res = Append[ Complement[top, res],
    BuildChain@@ gmc/@ res /. gmc -> Fixgmc ] /.
      BuildChain -> Sequence;

	(* Since fermion chains are always traversed opposite to the
	   fermion flow, we need the sign of the permutation that gets
	   the list of external fermions into _descending_ order.
	   However, Signature gives the sign for _ascending_ order,
	   so we need another (-1)^(Length[ext] / 2).
	   (Actually, the factor is (-1)^(len (len - 1) / 2), but since
	   the number of external fermions is always even, (-1)^(len / 2)
	   gives the same result.) *)
  ext = Cases[res, d_dot :> Seq[ d[[1, 1, 1]], d[[-1, 2, 1]] ] ];
  AppendTo[ scalars,
    Signature[ext] (-1)^(Count[res, tr[__]] + Length[ext] / 2) ];

  mtf = Times@@
    Cases[ res, tr[pr__] :> MTF[ Union[Cases[{pr}, Field[_], {-2}]] ] ];

	(* ghost chains are needed only for the sign *)
  res /. (tr | dot)[args__] :> Seq[args] /; !FreeQ[{args}, U]
]


MTF[ {} ] = 1

MTF[ fi_List ] :=
Block[ {res},
  res = Union[MatrixTraceFactor/@ fi];
  If[ Length[res] === 1, res[[1]],
    Message[CreateFeynAmp::mtrace, fi]; 1 ]
] /; FreeQ[fi, Field]


SignedMixers[ fi_ ] := MixingPartners[fi][[-1]] /; FreeQ[fi, Generic]

SignedMixers[ -fi_[x__] ] := -MixingPartners[AntiParticle[fi]][[-1]][x]

SignedMixers[ fi_[x__] ] := MixingPartners[fi][[-1]][x]


ResolveGeneric[ cto_, vert_, props_ ] :=
Block[ {v, gv, p},
  v = SignedMixers/@ (TakeInc[vert, #]&)/@ props;
  gv = ToGeneric[v];
  p = Position[GenericFieldPoints[], FieldPoint@@ gv, 1, 1];
  If[ Length[p] === 0,
    Message[CreateFeynAmp::novert, vert];
    Return[{}] ];
  v = (p = Position[gv, #1, 1, 1][[1, 1]]; gv[[p]] = 0; v[[p]])&/@
    ReferenceOrder[Generic][[ p[[1, 1]] ]];
  If[ cto =!= 0 && vfuncs,
    I PV[ If[FreeQ[v, F | U], Identity, NonCommutative][
            VertexFunction[cto]@@ v ] ],
  (* else *)
    AnalyticalCoupling[cto]@@ v ]
]


Attributes[ VertexInChain ] = {Flat}

VertexInChain[ p1:Propagator[_][__],
  p2:Propagator[_][v:Vertex[_, cto_:0][_], __] ] := (
  vert = DeleteCases[vert, v];
  Seq[ p1,
    ResolveGeneric[ cto, v,
      Join[{p1, p2}, Select[props, !FreeQ[#, v]&]] ], p2 ]
)

VertexInChain[ args__ ] = args

VertexAtEnds[ p1:Propagator[_][v:Vertex[_, cto_:0][_], __],
  pr___, p2_ ] := (
  vert = DeleteCases[vert, v];
  Seq[ p1, pr, p2,
    ResolveGeneric[ cto, v,
      Join[{p2, p1}, Select[props, !FreeQ[#, v]&]] ] ]
)

	(* the single-propagator version applies to tadpoles: *)
VertexAtEnds[ p1:Propagator[_][v:Vertex[_, cto_:0][_], __] ] := (
  vert = DeleteCases[vert, v];
  Seq[ p1,
    ResolveGeneric[ cto, v,
      Prepend[Select[props, !FreeQ[#, v]&], p1] ] ]
)


	(* if AnalyticalPropagator with the exact type is not defined
	   use a more generic type. The replacement must be limited to
	   the head or else the kinematical information is altered. *)
ResolvePropagator[type_][ _, _, part_ ] :=
Block[ {res},
  If[ Head[ res = MapAt[
        # /. {Loop[_] -> Internal, Incoming | Outgoing -> External} &,
        AnalyticalPropagator[type][part],
        0 ] ] === PV,
    res,
    Message[CreateFeynAmp::noprop, part]; Propagator[part] ]
]


	(* useful for Truncated -> True *)
NonCommutative[ 1 ] = Sequence[]


TakeNC[ f_List ] :=
Block[ {s},
  s = Select[f, FreeQ[#, NonCommutative]&];
  AppendTo[scalars, Select[s, FreeQ[#, PropagatorDenominator]&]];
  AppendTo[prden, Select[s, !FreeQ[#, PropagatorDenominator]&]];
  Sequence@@ Select[f, !FreeQ[#, NonCommutative]&]
]

TakeNC[ f_Times ] := TakeNC[List@@ f]

TakeNC[ f_ ] := TakeNC[{f}]


LoopPD[ p_ ] := p /; FreeQ[p, Internal]

LoopPD[ p_Plus ] := LoopPD/@ p

LoopPD[ p_Times ] :=
  Select[p, FreeQ[#, PropagatorDenominator]&] *
    LoopPD@@ Cases[p, PropagatorDenominator[__]]

LoopPD[ p__PropagatorDenominator ] :=
  Times@@ Select[{p}, FreeQ[#, Internal]&] *
    FeynAmpDenominator@@ SortPD/@ Select[{p}, !FreeQ[#, Internal]&]


SortPD[ PropagatorDenominator[mom_, mass_] ] :=
  PropagatorDenominator[ Expand[-mom], mass ] /;
  !FreeQ[mom, -FourMomentum[Internal, _]]

SortPD[ p_ ] = p


Attributes[ FeynAmpDenominator ] = {Orderless}

FeynAmpDenominator[ ] = 1


SumOver[ i_, {}, ext___ ] := SumOver[i, 0, ext]

SumOver[ i_, NoUnfold[l_], ext___ ] := SumOver[i, l, ext]

SumOver[ i_, r:{___, l_Integer}, ext___ ] :=
  SumOver[i, l, ext] /; r === Range[l]


CreateAmpIns[ gm_, sgen_, gr_ -> ins_ ] :=
  CreateAmpIns[gm, sgen, gr] -> (CreateAmpIns[gm, sgen, #]&)/@ ins

CreateAmpIns[ gm_, sgen_, gr:Graph[s_, ___][ru__] ] :=
Block[ {ext, int, ins, deltas},
  ins = ReplacePart[gm, sgen / s, -1] /. {ru} /.
    anti -> AntiParticle /.
    app[ x_. (fi:P$Generic)[n__], k__ ] :> x fi[n, k];
  deltas = DeleteCases[ Union@@ Diagonal/@
    Union[ Cases[ins, G[_][cto_][fi__][__] :> FieldPoint[cto][fi]] ],
    _Integer ];
  ins = ins /. G -> GtoC /. Mass -> TheMass /. gaugeru /.
    _MTF -> 1 /. Thread[deltas -> 1];
  ext = Union[Cases[Take[{ru}, next], _Index, Infinity]];
  int = Complement[Cases[Drop[{ru}, next], _Index, Infinity], ext];
  ins[[-1]] *=
    Times@@ deltas *
    Times@@ (SumOver[#, IndexRange[Take[#, 1]], External]&)/@ ext *
    Times@@ (SumOver[#, IndexRange[Take[#, 1]]]&)/@ int;
  ins
]


(* about G -> C replacement: 
   GtoC tries to replace the head "G" by "TheC" (the classes permutation
   is first resolved by applying the appropriate mapping of kinematical
   indices to all G-expressions). Failing that, it will try the negative
   kinematical expression (for a G[-]). If neither method resolves TheC,
   it will issue a warning and return C[cto][fields][kinpart]. *) 

GtoC[ sym_ ][ cto_ ][ fi__ ][ kin__ ] :=
Block[ {vert, ref, cv, p, posmap, kinpart},

  vert = MixingPartners[#][[-1]]&/@ {fi};

	(* at classes level there may be several definitions for
	   fermionic vertices, e.g. C[F, -F, ...] and C[-F, F, ...].
	   Thus, an exact match is attempted first and only then the
	   sorted form is used. *)
  cv = ToClasses[vert];
  p = Position[ReferenceOrder[Classes], cv, 1, 1];
  If[ Length[p] === 0,
    p = Position[FieldPoints[], FieldPoint@@ cv, 1, 1] ];
  If[ Length[p] === 0,
    Message[CreateFeynAmp::novert, vert];
    Return[ (C[cto]@@ vert)@@ kin ] ];
  ref = ReferenceOrder[Classes][[ p[[1, 1]] ]];

	(* find a list of position replacement rules describing
	   how the given vertex is permuted into the template vertex,
	   i.e. a list of the form {1 -> 3, 2 -> 1, 3 -> 2} *)
  posmap = MapIndexed[
    (ref[[ p = Position[ref, #1, 1, 1][[1, 1]] ]] = 0; #2[[1]] -> p)&,
    cv ];

	(* apply FermionFlipRules and transpose momenta and kinematical
	   indices according to posmap *)
  kinpart =
    If[ FreeQ[vert, F], {kin}, {kin} /. M$FermionFlipRule@@ posmap ] /.
      Flatten[ Thread/@ Map[Through[kinobjects[#]]&, posmap, {2}] ];

	(* apply posmap and then try to resolve coupling *)
  cv = vert;
  Apply[(cv[[#2]] = vert[[#1]])&, posmap, 1];

  If[ Head[cv = (TheC@@ kinpart)@@ cv] =!= List && sym === -1,
    cv = -MapAt[-#&, cv, {0, 1}] ];

  If[ !FreeQ[cv, TheC],
    Message[CreateFeynAmp::nocoupl, vert, kinpart];
    Return[ (C[cto]@@ vert)@@ kinpart ] ];

	(* check requested counter-term order: *)
  If[ Length[cv] <= cto,
    Message[CreateFeynAmp::counter, vert, cto];
    Return[ (C[cto]@@ vert)@@ kinpart ] ];

  cv[[cto + 1]]
]


Format[ G[sym_][cto_][fi__] ] :=
  SequenceForm[ "G",
    ColumnForm[
      { "(" <> ToString[cto] <> ")",
        "",
        StringJoin@@ ToString/@ ToGeneric[{fi}] },
      Left, Center ] ]

Format[ NonCommutative[nc__] ] := Dot[nc]

Format[ MatrixTrace ] = "tr"

Format[ FermionChain[a__] ] := Dot[a]

Format[ PropagatorDenominator[a_, b_] ] :=
  Block[ {x = a^2 - b^2}, 1 / x /; x =!= 0 ]

Format[ FourMomentum[Incoming, i_Integer] ] := SequenceForm["p", i]

Format[ FourMomentum[Outgoing, i_Integer] ] := SequenceForm["k", i]

Format[ FourMomentum[Internal, i_Integer] ] := SequenceForm["q", i]

Format[ FourMomentum[_, s_Symbol] ] = s

Format[ Index[type_, i_] ] :=
  SequenceForm[StringTake[ToString[type], 3], i]


PickLevel[ _ ][ tops_TopologyList ] = tops

PickLevel[ lev_ ][ tops:TopologyList[___][___] ] :=
Block[ {Rule, levels, res},
  _ -> Insertions[_][ ] = Sequence[];
	(* Generic is always kept *)
  res = Switch[ {FreeQ[lev, Classes], FreeQ[lev, Particles]},
    {True, True},
      tops /. (x_ -> Insertions[Classes | Particles][__]) -> x,
    {False, True},
      tops /. (x_ -> Insertions[Particles][__]) -> x,
    {True, False},
      tops /. gr:Insertions[Classes][__] :>
        Insertions[Particles]@@ Join@@ TakeIns/@ gr,
    _,
      tops ];
  levels = Flatten[{lev} /. Generic -> {}];
  If[ Length[levels] =!= 0,
    res = MapAt[ Select[#, ContainsQ[#, levels]&]&, res,
      Array[{#, 2}&, Length[res]] ] ];
  res
]

PickLevel::nocontain =
"Warning: FeynAmps have already been picked at a different level, `1`
level cannot be extracted."

PickLevel[ lev_ ][ amps:FeynAmpList[___][___] ] :=
Block[ {n = 0, c = 0, warn = True},
  LevelPick[lev]/@ (amps /. Number == _ :> Seq[])
]

PickLevel[ lev_ ][ amp_FeynAmp ] :=
Block[ {n = 0, c = 0, warn = True},
  FeynAmpList[][ LevelPick[lev][amp /. Number == _ :> Seq[]] ]
]


LevelPick[ Generic ][ amp_ ] :=
Block[ {RelativeCF = 1},
  If[ Length[amp] =!= 3 || MatchQ[amp[[1]], GraphName[__, Generic == _]],
    Insert[ Take[amp, 3], Number == ++n, {1, -1} ],
  (* else *)
    If[warn, Message[PickLevel::nocontain, Generic]; warn = False];
      Seq[] ]
]

LevelPick[ lev:Classes | Particles ][ amp_ ] := (
  Sequence@@ (Insert[#, Number == ++n, {1, -1}]&)/@
    If[ Length[amp] === 3,
      If[ MatchQ[amp[[1]], GraphName[__, lev == _]], amp,
        If[warn, Message[PickLevel::nocontain, lev]; warn = False]; {}],
    (* else *)
      ApplyGMRules[Take[amp, 3], amp[[-1]], lev] ]
)


ApplyGMRules[ amp_, gm_ -> Insertions[lev_][ru__], lev_ ] :=
Block[ {n = 0},
  Insert[#, lev == ++n, {1, -1}]&/@
    (amp /. (Thread[gm -> TakeGraph[#]]&)/@ {ru})
]

ApplyGMRules[ amp_, gm_ -> Insertions[Classes][ru__], Particles ] :=
Block[ {partru},
  partru = Flatten[TakeIns/@ Insertions[Particles][ru]];
  If[ Length[partru] === 0, {},
    ApplyGMRules[ Insert[amp, Classes == ++c, {1, -1}],
      gm -> partru, Particles ] ]
]


WeedOut[ g:Graph[_, t_ == _][__] -> _[] ] :=
  If[ MemberQ[lev, t], g, Seq[] ]

WeedOut[ a_ ] := a


Discard[ tops:TopologyList[info__][__], diags__ ] :=
Block[ {p, lev, Rule},
  p = Position[tops, Graph[__][__]];
  lev = ResolveLevel[InsertionLevel /. {info}];
  If[ FreeQ[lev, Generic], p = Select[p, Length[#] =!= 4 &] ];
  p = p[[ Union[ Flatten[
    {diags} /. a_Integer (Repeated | RepeatedNull)[b_] :>
                 Range@@ Sort[Floor[{b, a}]] ] ] ]];
  If[ Head[p] === Part, Return[$Failed] ];
  Rule[_] := Sequence[];
  Delete[tops, p] /. ins:Insertions[_][__] :> WeedOut/@ ins /.
    (Topology[__][__] -> _[]) :> Seq[]
]

Discard[ amp_, diags__ ] :=
  Delete[ amp, List/@ Union[Flatten[ {diags} /.
    a_Integer (Repeated | RepeatedNull)[b_] :>
      Range@@ Sort[Floor[{b, a}]] ]] ]


DiagramSelect[ tops:TopologyList[info__][__], crit_ ] :=
Block[ {lev, iselect, Rule},
  lev = ResolveLevel[InsertionLevel /. {info}];
  Rule[_] := Sequence[];
  iselect[lev_][gr__] :=
    Select[Insertions[lev][gr], crit] /; FreeQ[{gr}, iselect];
  tops /. Insertions -> iselect /.
    ins:Insertions[_][__] :> WeedOut/@ ins /.
    (Topology[__][__] -> _[]) :> Seq[]
]

DiagramSelect[ amp_, crit_ ] := Select[amp, crit]


ToFA1Conventions[ expr_ ] :=
Block[ {lev, FourMomentum, Conjugate, Global`PolarizationVector,
Global`DiracSpinor, Index, Integral = Sequence, FermionChain = Dot,
NonCommutative = Dot, MatrixTrace = Global`DiracTrace},

  FourMomentum[ Incoming | External, n_Integer ] :=
    FourMomentum[ Incoming | External, n ] =
      ToExpression["p" <> ToString[n]];
  FourMomentum[ Outgoing, n_Integer ] :=
    FourMomentum[ Outgoing, n ] =
      ToExpression["k" <> ToString[n]];
  FourMomentum[ Internal, n_Integer ] :=
    FourMomentum[ Internal, n ] =
      ToExpression["q" <> ToString[n]];

  Conjugate[Global`PolarizationVector][ args__ ] :=
    Conjugate[ Global`PolarizationVector[args] ];
  Global`PolarizationVector[ _, mom_, li_ ] =
    Global`PolarizationVector[mom, li];

  Global`DiracSpinor[ mom_, mass_, ___ ] := Global`Spinor[mom, mass];

  Index[ Global`Lorentz, n_ ] := Index[Global`Lorentz, n] =
    ToExpression["li" <> ToString[n]];

  lev = Scan[ If[!FreeQ[expr, #], Return[#]]&,
    {Generic, Classes, Particles} ];
  expr /. {
    (Number == n_) :> ToExpression["N" <> ToString[n]],
    (Topology == n_) :> ToExpression["T" <> ToString[n]],
    (lev == n_) :> ToExpression["I" <> ToString[n]],
    (_ == n_) :> Seq[] }
]

End[]

