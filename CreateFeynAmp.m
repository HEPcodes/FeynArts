(*
	CreateFeynAmp.m
		create Feynman amplitudes
		last change: 1 Dec 97 by TH
*)

BeginPackage["CreateFeynAmp`", {"FeynArts`","InsertFields`"}]

CreateFeynAmp::usage =
"CreateFeynAmp[insertedTopologyList, options] creates a list of Feynman
amplitudes (`FeynAmpList') of all the insertions created by
InsertFields."

FeynmanGauge::usage =
"FeynmanGauge is an option of CreateFeynAmp that only applies to
't Hooft gauge (i.e. UnitaryGauge -> False). If set to True (default) it
sets all GaugeXi[A|Z|W] -> 1."

Truncated::usage =
"Truncated is an option of CreateFeynAmp. If True, no wave functions
for the external fields are generated."

$DDimensions::usage =
"$DDimensions is an option for CreateFeynAmp to determine the prefactor
of a Feynman amplitude."

Begin["`Private`"]

Options[CreateFeynAmp] = {
  FeynmanGauge -> True,
  $DDimensions -> False,
  Truncated -> False,
  ScreenMessages -> True
}

Unprotect[FeynAmp]

Format[ FeynAmp[ GraphName[name___],mom___,ampl_ ] ] := 
  "FeynAmp"[name][ "Integral"[mom] ampl /. ReadRules ]

Protect[FeynAmp]

(* rules for human readable form *)

ReadRule1 = {
  PropagatorDenominator[0,0] :> 0,
  PropagatorDenominator[a_,b_] :> 1/(a^2-b^2),
  DiracTrace[a___] :> "tr"[a],
  GellMannTrace[a___] :> "tr"[a],
  LeptonSpinor[a_,b_] :> If[ Length[a]>1, "v"[-a,b], "u"[a,b] ],
  QuarkSpinor[a_,b_] :> If[ Length[a]>1, "v"[-a,b], "u"[a,b] ],
  DiracSlash[p_] :> "gs"[p],
  ChiralityProjector[a_] :> (1+a*"ga"[5])/2,
  DiracMatrix[p_] :> "ga"[p],
  SU3Delta[a__] :> "d"[a],
  SU3F[a___] :> "f"[a],
  GellMannMatrix[a___] :> "la"[a],
  GaugeXi[a_] :> "xi"[a],
  Conjugate[PolarizationVector[a__]] :> "ep(*)"[a],
  PolarizationVector[a__] :> "ep"[a],
  MetricTensor[a__] :> "g"[a],
  FourVector[a_,b_] :> a[b]
}

ReadRule2 = {
  FeynAmpDenominator -> Times,
  Conjugate[a_] :> "QMM(*)"[ StringTake[ToString[a],-2] ]
}

ReadRules = x_ :> (x //. ReadRule1 /. ReadRule2)

(* omit wave funcions *)

TruncationRules = {
  PolarizationVector[__] -> 1,
  QuarkSpinor[__] -> 1,
  LeptonSpinor[__] -> 1 
}

(* color factor *)

ColorFactorRule =
  sc:SpinorChain[__] :> 3 sc /;
    FreeQ[sc, LeptonSpinor|QuarkSpinor|GellMannMatrix] &&
    !FreeQ[sc, mu|md|mc|ms|mt|mb|
      Global`MU|Global`MD|Global`MC|Global`MS|Global`MT|Global`MB]

(* decide whether external or internal *)

ExternQ[ Propagator[ty_][__] ] := MemberQ[{ex,inc,out}, ty]

IncomingQ[ Propagator[ty_][__] ] := ty === inc

InternQ[ Propagator[ty_][__] ] := FreeQ[{ex,inc,out}, ty]

(* external propagators *)

NrOfInc[ t:Topology[___][__] ] := Length[List@@ Select[t, IncomingQ]]

momput1[ Propagator[ty_][ e[n_], to_[m_], a___ ] ] := 
  Propagator[ty][e[n], to[m], a, p[n]]

momput1[ Propagator[ty_][ to_[m_], e[n_], a___ ] ] := 
  Propagator[ty][to[m], e[n], a, -p[n]]

momput1[ Propagator[inc][ e[n_], to_[m_], a___ ], ninc_ ] := 
  Propagator[inc][e[n], to[m], a, p[n]]

momput1[ Propagator[inc][ to_[m_], e[n_], a___ ], ninc_ ] := 
  Propagator[inc][to[m], e[n], a, -p[n]]

momput1[ Propagator[out][ e[n_], to_[m_], a___ ], ninc_ ] := 
  Propagator[out][e[n], to[m], a, -k[n-ninc]]

momput1[ Propagator[out][ to_[m_], e[n_], a___ ], ninc_ ] := 
  Propagator[out][to[m], e[n], a, k[n-ninc]]

ext[ t:Topology[___][__] ] := 
  If[ NrOfInc[t] === 0,
    momput1/@ (List@@ Select[t, ExternQ]),
    momput1[#, NrOfInc[t]]&/@ (List@@ Select[t, ExternQ]) ]

(* internal propagators *)

momput2[ x_List ] :=
  (Append@@ #)&/@ Transpose[ {x, Array[q,Length[x]]} ]

int[ t:Topology[___][__] ] := momput2[ List@@ Select[t, InternQ] ]

AppendMomenta[ t:Topology[s___][__] ] := Join[ext[t], int[t]]

(* construct the "momentum vertex" *)

mom[ver_, Propagator[_][ver_, _, ___, m_] ] := -m

mom[ver_, Propagator[_][_, ver_, ___, m_] ] := m

mom[ver_, Propagator[_][ver_, ver_, ___, m_] ] := {-m, m}

Vertices[ tt_List ] := Vertices[ Topology[1]@@ tt ]

Vertices[ tt:Topology[elem__] ] := Vertices[ Topology[1][elem] ]

Vertices[ tt:Topology[_][___] ] :=
  Union[ Cases[tt, (v3|v4)[_], Infinity] ]       

MakeVertices[t_List] := 
  Function[z, 
    Expand[ Flatten[ mom[z,#1]& /@ Select[t, MemberQ[#1,z]& ] ] ]
  ]/@  Vertices[t]  

(* vertex handling *)

ppOne[ h_[ no_, one_, _, three_, _ ] ] := h[no,one,three]

ppTwo[ h_[ no_, _, two_, _, four_ ] ] := h[no,two,four]

ppOne[ h_[ no_, one_, _ ] ] := h[no,one]

ppTwo[ h_[ no_, _, two_ ] ] := h[no,two]

ppOne[ x_ ] := x

ppTwo[ x_ ] := x

TakeIn[ vert_, Propagator[_][ vert_, _, part_, mom_ ] ] := 
  {{AntiParticle[WorkingModel][ppOne[part]], Expand[-mom]}}

TakeIn[ vert_, Propagator[_][ _, vert_, part_, mom_ ] ] :=
  {{ppTwo[part],mom}}

TakeIn[ vert_, Propagator[_][ vert_, vert_, part_, mom_] ] :=
  {{AntiParticle[WorkingModel][ppOne[part]],
    Expand[-mom]},{ppTwo[part],mom}}

ConstVert[ vv_, wl_List ] :=
  Vertex[vv, Flatten[TakeIn[vv,#]&/@ Select[wl,!FreeQ[#,vv]&], 1]]

ConstructVertices[ tt:Topology[_][___] ] :=
Block[ {worklist},
  worklist = Flatten[ tt /. {Topology[_] -> List, SpinorChain -> List} ];
  ConstVert[#,worklist]&/@ Vertices[tt]
]

VPositionRules = {
  Topology[s_][ {listofvert__}, otherstuff__ ] :> 
    Topology[s][ listofvert, otherstuff ] ,
  Topology[s_][ a___, Vertex[ thev_, vv_List ], b___,
    SpinorChain[ pa___, p:Propagator[_][_,thev_,__], pb___ ], c___ ] :>
    Topology[s][ a, b, SpinorChain[pa,p,Vertex[thev,vv],pb], c ]
}

VertexHandling[ Topology[s_][ elements__ ] ] :=
  Topology[s][ ConstructVertices[Topology[s][elements]], elements ] //.
    VPositionRules

(* search momentum to solve equation *)

firstq[vert_List] :=
  If[ FreeQ[vert /. List -> Plus,q], {},
    Cases[ vert /. List -> Plus, _.q[j_] -> q[j] ][[1]] ]

(* solve equation for first momentum "q" *)

MomentumReplacement[ topo_List, i_ ] := 
  If[ firstq[ topo[[i]] ]==={},
    { { p[1] -> p[1] } },
    Solve[ (Plus@@ topo[[i]]) == 0, firstq[ topo[[i]] ] ]
  ] 

(* sum of all external momenta (= 0) *)

momsum[ t:Topology[s___][__] ] := 
  Plus@@ (Join[
    Cases[t, Propagator[ex][___,e[n_],___] -> p[n] ],
    Cases[t, Propagator[inc][___,e[n_],___] -> p[n] ],
    Cases[t, Propagator[out][___,e[n_],___] -> -k[n-NrOfInc[t]] ]
  ])

(* insert momentum conservation for every vertex *)

PutMomenta[ topo_List, n_Integer?Positive ] :=
Block[ {newt},
  newt = PutMomenta[topo, n-1];
  newt /. Flatten[ MomentumReplacement[MakeVertices[newt], n] ]
]

PutMomenta[ topo_List, 0 ] := topo

PutMomenta[ t:Topology[s___][__] ] := 
  ExpandAll[
    Topology[s]@@ 
      PutMomenta[ AppendMomenta[t], Length[Vertices[t]] ] /.
    momsum[t] -> 0 ]

PutMomenta[ t:Topology[ pr__, v:Insertions[ ___ ] ]  ] :=
  Append[ Topology@@ PutMomenta[ Topology[1]@@ t ], v ]

(* momentum conservation and renumbering the internal momenta *)

AddMomenta[ thetop_ ] := 
Block[ {tt, theq, newq} ,
  tt = PutMomenta[thetop];
  theq = Cases[ Flatten[List@@ tt /. Propagator[_] -> List], q[_] ];
  newq = Array[q, Length[theq]];
  tt /. Thread[theq -> newq]
]

AddMomenta[ ttt_TopologyList ] := AddMomenta/@ ttt

AddMomenta[ ttt:TopologyList[__][___] ] := AddMomenta/@ ttt

CreateFeynAmp[ Topology[mod___Rule][props__, verslist_Insertions],
  optional___Rule ] := 
Block[ {localoptions, reamp, momtop},
  localoptions = ActualOptions[FeynInit, mod,
    Sequence@@ Select[{optional},!FreeQ[#,ScreenMessages]&]];
  If[ (modelname = CheckModel[localoptions]) === $Aborted,
    Return[$Aborted] ];
  WorkingModel = modelname;
  If[ Length[{props}[[1]] ] < 4,
    momtop = Drop[AddMomenta[ Topology[props,verslist] ], -1],
  (* else *)
    momtop = Topology[props] ];
  localoptions = ActualOptions[CreateFeynAmp, optional];
  reamp = CreateAmplitude[modelname][CrInit[momtop,#,localoptions],
    localoptions]&/@ (verslist /. IndicesRule);
  FeynAmpList@@ reamp
]

ExtendedProcess[ proc_, mtop_] :=
Block[ {mrules, hd},
  mrules = Select[List@@ mtop /. 
    { Propagator[inc][e[i_Integer],_,_,mom_] :> (e[i] -> mom),
      Propagator[out][e[i_Integer],_,_,mom_] :> (e[i] -> -mom) },
    FreeQ[#,fi]& ];
  hd = proc[[1,0]];
  hd@@ Table[ {proc[[1,i]], e[i] /. mrules, Mass[ proc[[1,i]] ]},
    {i,Length[ proc[[1]] ]} ] ->
    hd@@ Table[ {proc[[2,i]], e[i+Length[ proc[[1]] ]] /. mrules,
      Mass[proc[[2,i]]]}, {i,Length[ proc[[2]] ]} ]
]

CreateFeynAmp[ TopologyList[mod__Rule][tops__Topology], options___Rule ] :=
Block[ {moddd, back, temp, len, name, modelname, n = 0,
topoptions, localoptions, result},
  len = Length[{tops}];
  back = TopologyList[];
	(* Add momenta and masses to `Process' *)
  moddd = {mod} /. (Process -> proc_) :>
    (Process -> ExtendedProcess[ proc, AddMomenta[{tops}[[1]] ] ]);
  name = Cases[moddd, (ProcessName -> x_) -> x ][[1]];
  localoptions = ActualOptions[CreateFeynAmp, options];
  topoptions = Select[moddd, FreeQ[#,Process]&];
  modelname = CheckModel[ Append[topoptions, 
    ScreenMessages -> (ScreenMessages /. localoptions)] ];
  If[modelname === $Aborted, Return[$Aborted] ];
  Off[General::spell1];
  Do[ 
    Print[ thestring[i, len, Length[{tops}[[i,-1]] ]] ];
    temp = (Topology@@ topoptions)@@ {tops}[[i]];
    temp = If[ {options} === {},
      CreateFeynAmp[temp],
      CreateFeynAmp[temp, options] ];
    temp = Array[ Prepend[temp[[#]],
      GraphName[name,
        ToExpression[StringJoin["T",ToString[i]]],
        ToExpression[StringJoin["I",ToString[#]]],
        ToExpression[StringJoin["N",ToString[++n]]] ] ]&, Length[temp] ];
    AppendTo[back, temp],
  {i,len}];
  $Output = {"stdout"};
  result = ( (FeynAmpList@@ moddd)@@
    (Join@@ (back /. FeynAmpList -> List)) ) //. LastRules;
  On[General::spell1];
  result
]

(* supply with li and gi (Lorentz and gluon indices) *)

AddIndex[ g_ ] :=
Block[ {ind, nli = 0, ngi = 0},
  ind[f_ -> V[a_]] := (nli+=2; f -> V[a,li[nli-1],li[nli]]);
  ind[f_ -> U[a_]] := (ngi+=2; f -> U[a,gi[ngi-1],gi[ngi]]);
  ind[f_ -> G[a_]] :=
    (ngi+=2; nli+=2; f -> G[a,li[nli-1],li[nli],gi[ngi-1],gi[ngi]]);
  g /. r:(fi[_] -> (V[_]|U[5]|U[-5]|G[_])) :> ind[r]
]

IndicesRule = g:(Graph[_][__]) :> AddIndex[g]

(* optical message *)

thestring[ somuch_, outof_, actlen_ ] := 
  StringJoin[Table[".",{somuch}],Table[" ",{outof-somuch}],
    "|(",ToString[actlen],")"]

(* build SpinorChains of fermions and correct the combinatorial factor *)

(* first step: building chains of Grassmann fields *)

GrassmannStart = {
  Topology[s_][ pa___, Propagator[ty_][x___,U[in_,gi___],m_], pb___] :>
    Topology[s][ pa, pb, gmC[ Propagator[ty][x,U[in,gi],m] ] ],
  Topology[s_][ pa___, Propagator[ty_][x___,F[in_],m_], pb___] :>
    Topology[s][ pa, pb, gmC[ Propagator[ty][x,F[in],m] ] ]
}

GrassmannRules = {
  Topology[s_][ pa___, 
    Propagator[ty_][toz_,toy_,fi_[in_,gi___],m1_],
    pb___,
    gmC[qa___,Propagator[tz_][frz_,toz_,fi_[jn_,gj___],m2_] ] ] :>
    Topology[s][ pa, pb, 
      gmC[qa,Propagator[tz][frz,toz,fi[jn,gj],m2],
        Propagator[ty][toz,toy,fi[in,gi],m1]] ] /; MemberQ[{F,U},fi],
  Topology[s_][ pa___,
    Propagator[ty_][fry_,toz_,fi_[in_,gi___],m1_],
    pb___,
    gmC[ qa___,Propagator[tz_][frz_,toz_,fi_[jn_,gj___],m2_] ] ] :>
    Topology[s][ pa, pb,
      gmC[qa,Propagator[tz][frz,toz,fi[jn,gj],m2],
        Propagator[ty][toz,fry,
          AntiParticle[CreateFeynAmp`Private`WorkingModel][fi[in,gi]],
          -m1] ] ] /; MemberQ[{F,U},fi],
  Topology[s_][ pa___,
    Propagator[ty_][fry_,frz_,fi_[in_,gi___],m1_],
    pb___,
    gmC[Propagator[tz_][frz_,toz_,fi_[jn_,gj___],m2_],qa___] ] :>
    Topology[s][ pa, pb,
      gmC[Propagator[ty][fry,frz,fi[in,gi],m1],
        Propagator[tz][frz,toz,fi[jn,gj],m2],qa] ] /; MemberQ[{F,U},fi],
  Topology[s_][ pa___,
    Propagator[ty_][frz_,toy_,fi_[in_,gi___],m1_],
    pb___,
    gmC[Propagator[tz_][frz_,toz_,fi_[jn_,gj___],m2_],qa___] ] :>
    Topology[s][ pa, pb,
      gmC[Propagator[ty][toy,frz,
        AntiParticle[CreateFeynAmp`Private`WorkingModel][fi[in,gi]],
        -m1],
      Propagator[tz][frz,toz,fi[jn,gj],m2], qa ] ] /; MemberQ[{F,U},fi]
}

Grassmann =
  Topology[s_][p___] :>
    ((Topology[s][p] /. GrassmannStart) //. GrassmannRules)

(* second step: correcting the combinatorial factor (1),
                add -1 for every closed Grassmann chain *)

Scorrect[ tt:Topology[s_][args___] ] := 
  Topology[ (-1)^(Count[tt,gmC[x__] /; FreeQ[{x},e]]) s ][args]

(* third step: building correct fermion chains *)

PropReverse[ Propagator[ty_][ fr_,to_,fi_,mom_ ] ] := 
  Propagator[ty][to, fr, 
    AntiParticle[CreateFeynAmp`Private`WorkingModel][fi], -mom]

ToSpinorChain = {
  Topology[s_][ pa___, 
    gmC[Propagator[ty_][fr_ ,to_ ,U[in_,gi___], mom_ ],pb___ ], 
    pc___ ] :>
    Topology[s][ Propagator[ty][fr,to,U[in,gi],mom], pb, pa, pc],
  Topology[s_][ pa___, 
    gmC[ Propagator[ty_][fr_, to_,F[in_Integer?Negative], mom_], pb___], 
    pc___ ] :>
    Topology[s][pa, pc, SpinorChain[Propagator[ty][fr,to,F[in],mom],pb]] ,
  Topology[s_][ pa___, 
    the:gmC[ Propagator[ty_][fr_ ,to_, F[in_Integer?Positive], mom_ ] ,
      pb___], pc___ ] :>
     Topology[s][ pa, pc, SpinorChain@@ Reverse[PropReverse/@ the] ],
  Topology[s_][ pa___, 
    gmC[ Propagator[ty_][fr_, to_,F[-I], mom_], pb___], 
    pc___ ] :>
    Topology[s][pa, pc, SpinorChain[Propagator[ty][fr,to,F[-I],mom],pb]] ,
  Topology[s_][ pa___, 
    the:gmC[ Propagator[ty_][fr_ ,to_, F[I], mom_ ], pb___], 
    pc___ ] :>
    Topology[s][ pa, pc, SpinorChain@@ Reverse[PropReverse/@ the] ]  
}

(* fourth step: extracting the external fermion numbers *)

ExtractExt[ SpinorChain[
  Propagator[_][e[a_],__], ___, Propagator[_][_,e[b_],__] ] ] :=
  Sequence[a,b]

ExtractExt[ _ ] = Sequence[]

ExternalSign[ tt:Topology[_][__] ] :=
Block[ {ext},
  ext = ExtractExt/@ (List@@ tt);
	(* Since fermion chains are always traversed opposite to the
	   fermion flow, we need the sign of the permutation that gets
	   the list of external fermions into _descending_ order.
	   However, Signature gives the sign for _ascending_ order,
	   so we need another (-1)^(Length[ext]/2).
	   (Actually, the factor is (-1)^(len*(len-1)/2), but since
	   the number of external fermions is always even, (-1)^(len/2)
	   gives the same result.) *)
  Signature[ext]*(-1)^(Length[ext]/2)
]

(* all Grassmann stuff combined into one function *)

TopToGrassmann[ tt:Topology[_][__] ] :=
Block[ {fermfac, topol},
  topol = Scorrect[tt //. Grassmann] //. ToSpinorChain;
  fermfac = ExternalSign[topol];
  topol /. Topology[ss_] -> Topology[ss fermfac]
]

(* construct the analytical expressions from topologies with PV and
   SpinorChain functions as FeynAmp[scalars * spinorchains] *)

SpCrule1 = { 
  SpinorChain[ PV[NonCommutative[gp1__] sc1_.],
      PV[NonCommutative[gp2__] sc2_. ], sth___ ] :>
    SpinorChain[ PV[ NonCommutative[gp1, gp2] sc1 sc2 ], sth ],
  SpinorChain[ PV[sc1_] , PV[NonCommutative[gp2__] sc2_.], sth___ ] :>
    SpinorChain[ PV[NonCommutative[gp2] sc1 sc2], sth ],
  SpinorChain[ PV[NonCommutative[gp1__] sc1_.], PV[sc2_], sth___ ] :>
    SpinorChain[ PV[NonCommutative[gp1] sc1 sc2], sth ]
}

SpCrule2 =	   
  SpinorChain[ PV[ NonCommutative[sth___] scal_. ] ] :> 
    PV[ SpinorChain[sth] scal ]

Multrule =
 Topology[sym_][ pat:PV[_].. ] :>
   FeynAmp[ sym*(Times[pat] /. PV -> Times) ]

FeynMultiplication[ tt:Topology[_][__] ] := 
  tt //. SpCrule1 //. SpCrule2 /. Multrule

(* extract symm fac, insert version, search Grassmann fields *)

CrInit[ acTop:Topology[ps__], actvers:Graph[sym_][ru__], opt_List ] :=
  TopToGrassmann[ Topology[sym][ps] /.
    If[ $DDimensions /. opt /. Options[CreateFeynAmp],
      symruleddim, symrule4dim] /. {ru} ]

(* constructing the global prefactor;
   for truncated amplitudes the -I is eliminated when calling the 
   truncation rules *)

symruleddim =
  Topology[sym_][ props__ ] :>
    Topology[ -I (1/(2 Pi)^$D Mu^(4-$D))^LoopNr[{props}] / sym ][ props ]

symrule4dim = 
  Topology[sym_][ props__ ]:>
    Topology[ -I (1/(2 Pi)^4)^LoopNr[{props}] / sym ][ props ]

(* Loop number using Euler's formula *)

LoopNr[ ps_List ] := 
Block[ {all} ,
  all = Union[ Flatten[ ps /. Propagator[_] -> List ] ];
  (Count[all, v3[_]]-Count[all, e[_]])/2 + Count[all, v4[_]] + 1
]

(* replacing Vertex -> AnalyticalCoupling automatically inserts *)

VertInsert[mod_][ Topology[s_][elem__] ] :=
  Topology[s][elem] /. 
    Vertex[___, vv_List, ___] :> AnalyticalCoupling[mod]@@ Sort[vv]

(* put propagator to nice form;
   replacing Propagator -> AnalyticalPropagator automatically inserts *)

PropOrder[mod_][ Propagator[type_][_,_,part_,mom_] ] :=
Block[ {tt, from, to, x},
  from = ppOne[part];
  to = ppTwo[part];
  If[ type === inc || type === out, 
    tt = type /. {inc -> 1, out -> 1};
	(* if you want the outgoing particles' momenta to be incoming,
	   change out -> 1 to out -> -1 *)
    x = AnalyticalPropagator[mod][ex][to, Expand[tt*mom]];
    If[ Head[x] =!= PV,
      x = AnalyticalPropagator[mod][ex][AntiParticle[mod][from],
        Expand[-tt*mom] ]
    ],
  (* else *)
    x = AnalyticalPropagator[mod][in][ AntiParticle[mod][from], to, mom ];
	(* The direction of the in-propagator is only relevant for the 
	   fermions. As these are formed against the flow of fermion 
	   number, part is always the antifermion. So to apply our Feynman 
	   rules to to and AP[from] we just reverse the propagator and 
	   change the momentum sign. (For us the second rule would be 
	   enough, but someone might enter Feynman rules from fermion to 
	   antifermion (or particle to antiparticle)) *)
    If[ Head[x] =!= PV,
      x = AnalyticalPropagator[mod][in][
        to, AntiParticle[mod][from], Expand[-mom] ]
    ];
  ];
  x
] 

PropInsert[mod_][ tt:Topology[s_][elem__] ] :=
  tt /. Propagator[ty_][ff__] :> PropOrder[mod][Propagator[ty][ff]]

(* resolve powers of PropagatorDenominator, 
   collect PropagatorDenominator factors, expand them,
   order them in FeynAmpDenominators *)

allnonpd[ list_ ] :=
  Select[ list[[1]], (FreeQ[#,PropagatorDenominator] || FreeQ[#,q])& ]

allpd[ list_ ] :=
  Expand[
    Select[list[[1]], (!FreeQ[#,PropagatorDenominator] && !FreeQ[#,q])&],
    PropagatorDenominator ] /. 
  PropagatorDenominator[a___]^(n_Integer?Positive) :>
    FeynAmpDenominator@@ Table[prden[a],{n}] /.
  PropagatorDenominator[a__] :> FeynAmpDenominator[prden[a]] //.
  FeynAmpDenominator[a___] FeynAmpDenominator[b___] :>
    FeynAmpDenominator[a,b];

CollectPD[ list_ ] :=
  FeynAmp[allnonpd[list] *
    (allpd[list] /. prden -> PropagatorDenominator)]

(* expand the arguments of FeynAmpDenominator, PropagatorDenominator
   and FourVector arguments *)

lv[ mom_, args___ ] := FourVector[Expand[mom], args]

df[ 0, mass_ ] := PropagatorDenominator[0, mass]

df[ mom_, mass_ ] :=
  If[ MemberQ[mom, -q[1]] ||
    Head[First[mom]] === Times || MatchQ[mom, -q[_]],
    PropagatorDenominator[Expand[-mom], mass],
    PropagatorDenominator[Expand[mom], mass] 
  ]

dn[ allfactors___ ] := Sort[ FeynAmpDenominator[allfactors] ]

(* construct integration information *)

IntegrationInfo[ faexpr_ ] :=
  MomentumIntegration@@ Union[ Cases[faexpr, q[_], Infinity] ]

(* substituting dummy by appropriate gi[n] *)

DummyTreat[ amp_ ] := amp /; FreeQ[amp,dummy]

DummyTreat[ FeynAmp[amp__] ] := 
Block[ {ngi, repl},
  ngi = Sort[Cases[{amp},gi[_],Infinity]][[-1,1]];
  repl[x_] := repl[x] = x /. dummy -> gi[++ngi];
  FeynAmp[amp] /. x:(SU3F[___,dummy,___]*SU3F[___,dummy,___]) :> repl[x]
]

DummyRule = a:FeynAmp[___] :> DummyTreat[a]

OuterIndexRule = {
  Propagator[inc][fr_, to_, h_[ a_,b_,c_,d_,e_ ], mom_] :>
    Propagator[inc][fr,to,h[a,c,c,e,e],mom],
  Propagator[inc][fr_, to_, h_[ a_,b_,c_], mom_] :>
    Propagator[inc][fr,to,h[a,c,c],mom],
  Propagator[out][fr_, to_, h_[ a_,b_,c_,d_,e_ ], mom_] :>
    Propagator[out][fr,to,h[a,c,c,e,e],mom],
  Propagator[out][fr_, to_, h_[a_,b_,c_], mom_] :>
    Propagator[out][fr,to,h[a,c,c],mom]
}

(* putting everything together *)

CreateAmplitude[mod_][ acTop:Topology[sym_][ ps__ ], opt_ ] :=
Block[ {theamp},
  theamp = 
    PropInsert[mod][
      VertInsert[mod][
        VertexHandling[acTop /. OuterIndexRule]
    ]];
  If[FeynmanGauge /. opt, theamp = theamp /. GaugeXi[_] -> 1];
  theamp = CollectPD[ FeynMultiplication[theamp] ] /.
    { FourVector -> lv,
      PropagatorDenominator -> df,
      FeynAmpDenominator -> dn } /. ColorFactorRule;
  If[ Truncated /. opt,
	(* eliminate factor -I from global prefactor *)
    theamp = theamp /. Last[theamp] :> I Last[theamp] /. TruncationRules
  ];
  theamp = Prepend[theamp, IntegrationInfo@@ theamp] /. DummyRule;
  Off[General::spell1];
  theamp = theamp //. FeynCalcRules /.
    PolarizationVector[ k[a_],r___ ] :>
      Conjugate[PolarizationVector[k[a],r]];
  On[General::spell1];
  theamp
]

FeynCalcRules = {
  FeynAmpDenominator[ a___PropagatorDenominator,
    PropagatorDenominator[q[1],mass_],  
    b___PropagatorDenominator ] :>
    FeynAmpDenominator[ PropagatorDenominator[q[1],mass], a, b ],
  PropagatorDenominator[ Plus[ a___, sign_. q[1], b___ ], mass_ ] :>
    PropagatorDenominator[ Expand[ sign*Plus[sign*q[1],a,b] ], mass ],
  SpinorChain[a_LeptonSpinor, b___, c_LeptonSpinor] :>
    Dot[a,b,c] /; FreeQ[{b},LeptonSpinor],
  SpinorChain[a_QuarkSpinor, b___, c_QuarkSpinor] :>
    Dot[a,b,c] /; FreeQ[{b},QuarkSpinor], 
  SpinorChain[1, b___, 1] :> Dot[b] /; FreeQ[{b},LeptonSpinor],
  SpinorChain[1, b___, 1] :> Dot[b] /; FreeQ[{b},QuarkSpinor],
  SpinorChain[a__] :> GDTrace[Dot[a]] /; FreeQ[{a},LeptonSpinor],
  SpinorChain[a__] :> GDTrace[Dot[a]] /; FreeQ[{a},QuarkSpinor],
  GDTrace[a___] :> TraceRule[a],
  DiracTrace[Dot[]] :> 1,
  GellMannTrace[Dot[]] :> 1,
  FeynAmp[n___, MomentumIntegration[mom__], amp_] :>
    FeynAmp[n, mom, amp]
}

PolarizationVector[ -k_, r___ ] := PolarizationVector[k, r]

TraceRule[a__] :=
Block[ {gpart, dpart, dummydot},
  gpart = If[ !FreeQ[#,GellMannMatrix],
    Select[#, !FreeQ[#,GellMannMatrix]&], 1]&/@
    If[Head[a] === Plus, dummydot[a], a];
  gpart = Select[gpart, (# =!= 1)&] /. dummydot -> Dot;
  dpart = a /. GellMannMatrix[___] :> 1 ;
  DiracTrace[dpart]*GellMannTrace[gpart]
]

(* final touch *)

LastRules = {
  p[i_] :> ToExpression["p"<>ToString[i]],
  q[i_] :> ToExpression["q"<>ToString[i]],
  k[i_] :> ToExpression["k"<>ToString[i]],
  li[i_] :> ToExpression["li"<>ToString[i]],
  gi[i_] :> ToExpression["gi"<>ToString[i]],
  SpinorChain[1, line___, 1] :> SpinorChain[line],
  SpinorChain[1, 1] -> 1,
  FeynAmp[n___, MomentumIntegration[], amp_] :> FeynAmp[n, amp]
}

End[]

EndPackage[]

