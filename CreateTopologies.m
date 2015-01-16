(*
	CreateTopologies.m
		create topologies (0...3 loops)
		last change: 1 Dec 97 by TH
*)

BeginPackage["CreateTopologies`", {"FeynArts`"}]

CreateTopologies::usage =
"CreateTopologies[l, e, options] returns a TopologyList of Topologies 
with e external points and l loops (l = 0...3)."

Tadpoles::usage =
"Tadpoles is an Option of CreateTopologies. Tadpoles -> False omits 
tadpoles."

SelfEnergies::usage = "SelfEnergies is an Option of CreateTopologies.
SelfEnergies -> False omits selfenergies."

WFCorrections::usage =
"WFCorrections is an Option of CreateTopologies. External self-energies 
and tadpoles (wave function corrections) are omitted if this option is set 
to False."

Triangles::usage =
"Triangles is an Option of CreateTopologies. Triangles -> False omits 
three point functions."

Boxes::usage =
"Boxes is an Option of CreateTopologies. Boxes -> False omits four and 
more point functions."

Theta::usage =
"Theta is an Option of CreateTopologies. It determines whether the
starttopology `theta' should be included or not."

Eight::usage =
"Eight is an Option of CreateTopologies. It determines whether the 
starttopology `eight' should be included or not."

Bicycle::usage =
"Bicycle is an Option of CreateTopologies. Bicycle -> True includes the 
starttopology formed like a dump-bell."

Compare::usage =
"Compare[t, mod] is the `pure' compare function to eliminate
equivalent topologies of a TopologyList t. The argument mod is
optional and denotes the model for comparing inserted topologies."

Begin["`Private`"]

(* starting topologies *)

tt = Topology[1][
  Propagator[ex][ e[1], v3[1] ],
  Propagator[ex][ e[2], v3[1] ],
  Propagator[ex][ e[3], v3[1] ]
]

o1 = Topology[2][
  Propagator[l1][ v3[1], v3[1] ],
  Propagator[ex][ e[1], v3[1] ]
]

d1 = Topology[12][
  Propagator[l1][ v3[-2], v3[-1] ],
  Propagator[l2][ v3[-2], v3[-1] ],
  Propagator[l3][ v3[-2], v3[-1] ]
]

d2 = Topology[8][
  Propagator[l1][ v4[-1], v4[-1] ],
  Propagator[l2][ v4[-1], v4[-1] ]
]
   
d3 = Topology[8][
  Propagator[l1][ v3[-1], v3[-1] ],
  Propagator[l2][ v3[-2], v3[-2] ],
  Propagator[l3][ v3[-2], v3[-1] ]
]

(* 3-loop starting topologies:
   t1-t6: Mertig/Eck, m1-m6: Muenz/Misiak *)

(* Mercedes star: 4x3v *)

t1 = Topology[ 24][ 
  Propagator[l1][ v3[-1], v3[-2] ],
  Propagator[l2][ v3[-2], v3[-3] ],
  Propagator[l3][ v3[-3], v3[-1] ],
  Propagator[l6][ v3[-1], v3[-4] ],
  Propagator[l5][ v3[-2], v3[-4] ],
  Propagator[l4][ v3[-3], v3[-4] ]
]

m1 = Topology[24][
  Propagator[l1][ v3[-2], v3[-1] ],
  Propagator[l2][ v3[-3], v3[-1] ],
  Propagator[l3][ v3[-4], v3[-1] ],
  Propagator[l4][ v3[-3], v3[-2] ],
  Propagator[l5][ v3[-4], v3[-2] ],
  Propagator[l6][ v3[-4], v3[-3] ]
]
 
(* 2 circles: 4x3v *)

t2 = Topology[16][ 
  Propagator[l1][ v3[-1], v3[-2] ],
  Propagator[l2][ v3[-2], v3[-3] ],
  Propagator[l3][ v3[-3], v3[-4] ],
  Propagator[l4][ v3[-4], v3[-1] ],
  Propagator[l5][ v3[-1], v3[-4] ],
  Propagator[l6][ v3[-2], v3[-3] ]
]

m2 = Topology[16][
  Propagator[l1][ v3[-2], v3[-1] ],
  Propagator[l2][ v3[-2], v3[-1] ],
  Propagator[l3][ v3[-3], v3[-1] ],
  Propagator[l4][ v3[-4], v3[-2] ],
  Propagator[l5][ v3[-4], v3[-3] ],
  Propagator[l6][ v3[-4], v3[-3] ]
]

(* 2 circles in touch: 2x3v + 1x4v *)

t3 = Topology[8][ 
  Propagator[l1][ v3[-1], v3[-2] ],
  Propagator[l2][ v3[-2], v4[-3] ],
  Propagator[l3][ v4[-3], v3[-1] ],
  Propagator[l4][ v3[-1], v4[-3] ],
  Propagator[l5][ v3[-2], v4[-3] ]
]

m3 = Topology[8][
  Propagator[l1][ v3[-2], v4[-1] ],
  Propagator[l2][ v3[-2], v4[-1] ],
  Propagator[l3][ v3[-3], v4[-1] ],
  Propagator[l4][ v3[-3], v4[-1] ],
  Propagator[l5][ v3[-3], v3[-2] ]
]

(* extended theta (1): 2x3v + 1x4v *)

t4 = Topology[8][
  Propagator[l1][ v3[-1], v3[-2] ],
  Propagator[l2][ v3[-1], v3[-2] ],
  Propagator[l3][ v3[-1], v4[-3] ],
  Propagator[l4][ v3[-2], v4[-3] ],
  Propagator[l5][ v4[-3], v4[-3] ]
]

m4 = Topology[8][
  Propagator[l1][ v3[-2], v4[-1] ],
  Propagator[l2][ v3[-3], v4[-1] ],
  Propagator[l3][ v3[-3], v3[-2] ],
  Propagator[l4][ v3[-3], v3[-2] ],
  Propagator[l5][ v4[-1], v4[-1] ]
]

(* eye of the tiger: 2x4v *)

t5 = Topology[48][ 
  Propagator[l1][ v4[-1], v4[-2] ],
  Propagator[l2][ v4[-1], v4[-2] ],
  Propagator[l3][ v4[-1], v4[-2] ],
  Propagator[l4][ v4[-1], v4[-2] ]
]

m5 = Topology[48][
  Propagator[l1][ v4[-2], v4[-1] ],
  Propagator[l2][ v4[-2], v4[-1] ],
  Propagator[l3][ v4[-2], v4[-1] ],
  Propagator[l4][ v4[-2], v4[-1] ]
]

(* 3 circles: 2x4v *)

t6 = Topology[16][
  Propagator[l1][ v4[-1], v4[-1] ],
  Propagator[l2][ v4[-1], v4[-2] ],
  Propagator[l3][ v4[-1], v4[-2] ],
  Propagator[l4][ v4[-2], v4[-2] ]
]

m6 = Topology[16][
  Propagator[l1][ v4[-1], v4[-1] ],
  Propagator[l2][ v4[-2], v4[-1] ],
  Propagator[l3][ v4[-2], v4[-1] ],
  Propagator[l4][ v4[-2], v4[-2] ]
]

(* recursive creation of topologies *)

(* starting topologies for 2-loop depend on options *)

ConstructTopologies[0,3] = TopologyList[tt]

ConstructTopologies[1,1] = TopologyList[o1]

ConstructTopologies[3,0] = TopologyList[t1, t2, t3, t4, t5, t6]

ConstructTopologies[ loops_, ext_Integer ] :=
  TopologyList[ AddOne[#,ext]&/@ ConstructTopologies[loops,ext-1] ]

Options[CreateTopologies] = {
  Tadpoles -> True,
  SelfEnergies -> True,
  Triangles -> True,
  Boxes -> True,
  WFCorrections -> True,
  Theta -> True,
  Eight -> True,
  Bicycle -> False
}

CreateTopologies[ l_, n_Integer, options___ ] := 
  CreateTopologies[ l, n, options ] = 
Block[ {localoptions, topos},
  localoptions = ActualOptions[CreateTopologies, options];
  ConstructTopologies[2,0] = TopologyList[];
  If[ Theta /. localoptions,
    AppendTo[ConstructTopologies[2,0], d1] ];
  If[ Eight /. localoptions,
    AppendTo[ConstructTopologies[2,0], d2] ];
  If[ Bicycle /. localoptions,
    AppendTo[ConstructTopologies[2,0], d3] ];
  topos = ConstructTopologies[l,n];
  If[ !(Tadpoles /. localoptions),
    topos = NoTadpoles[topos] ];
  If[ !(WFCorrections /. localoptions),
    topos = NoWFCorrections[topos] ];
  If[ !(SelfEnergies /. localoptions),
    topos = NoSelfEnergies[topos] ];
  If[ !(Triangles /. localoptions),
    topos = NoTriangles[topos] ];
  If[ !(Boxes /. localoptions),
    topos = Fold[NoBoxes, topos, Range[4,n]] ];
  topos
]

OnLoopTest[ tt:Topology[_][___], i_Integer ] := 
  Length[ Select[AtLoopPropagators[tt], !FreeQ[#,ex|in]&] ] === i

ExternalSelfEnergy[ tt:Topology[_][___] ] := 
Block[ {inexprops},
  inexprops = Select[AtLoopPropagators[tt], !FreeQ[#,ex|in]&];
  Length[inexprops] === 2 &&
    Length[ Select[inexprops, !FreeQ[#,ex]&] ] > 0 
]

ExternalTadpole[ tt:Topology[_][___] ] :=
Block[ {inprop},
  inprop = Identity@@ Select[AtLoopPropagators[tt], !FreeQ[#,in]&];
  If[ inprop === {},
    True, 	(* only non-loop propagator is external *)
    !FreeQ[Select[tt, !FreeQ[#, inprop[[1]]|inprop[[2]] ]&], ex]
  ]
]

AtLoopPropagators[ tt:Topology[_][___] ] :=
Block[ {lvertices},
  lvertices = Union[Join@@ 
    (Select[tt, FreeQ[#,in|ex]&] /. Propagator[_] -> List)];
  Union@@ (Function[ z, Select[tt, !FreeQ[#,z]&] ]/@ lvertices)
]

NoTadpoles[ tt:TopologyList[___] ] :=
  Select[tt, !OnLoopTest[#,1]&]

NoSelfEnergies[ tt:TopologyList[___] ] :=
  Select[tt, !OnLoopTest[#,2]&]

NoTriangles[ tt:TopologyList[___] ] :=
  Select[tt, !OnLoopTest[#,3]&]

NoBoxes[ tt:TopologyList[___], i_Integer ] :=
  Select[tt, !OnLoopTest[#,i]&]

NoWFCorrections[ tt:TopologyList[___]  ] := 
  Union[ tt//NoSelfEnergies//NoTadpoles,
    Select[tt, (OnLoopTest[#,2] && !ExternalSelfEnergy[#])&],
    Select[tt, (OnLoopTest[#,1] && !ExternalTadpole[#])&] ];

(* construct the vertices *)

Vs[3][t_]:= Union[ Flatten[ List@@ (Cases[#, v3[n_] -> n]&/@ t) ]]

Vs[4][t_]:= Union[ Flatten[ List@@ (Cases[#, v4[n_] -> n]&/@ t) ]]

Vsn[type_Integer?Positive][t_] := Select[ Vs[type][t], #<0& ]

(* for permutations *)

SwapV[ x_, old_List, new_List ] :=
  x /. Thread[v3/@ old -> v3/@ new] /. Thread[v4/@ old -> v4/@ new]

(* adding to one propagator *)

PropPlus[ Propagator[h_][f_,t_], n_Integer ] :=
  Topology[h][ Propagator[h][f,v3[n]],
    Propagator[ If[h === ex,in,h] ][v3[n],t],
    Propagator[ex][e[n],v3[n]] ]

(* conserve and destroy information about addition *)

ConstructAdditionalInfor =
  Topology[s_][ p1___,Topology[sp_][arg__],p2___ ] :> 
    Topology[ s sp ][p1,arg,p2]

DeleteAdditionalInfor =
  Topology[ (s_Integer:1) (v_Symbol:v3) ][p__] :> Topology[s][p]

(* adding propagator #n to propagator and vertex #m *)

AddPropagator[ Topology[s_][ x:Propagator[___][__].. ],
  n_Integer, m_Integer ] :=
  Topology[s][x] /.
    Topology[s][x][[m]] -> PropPlus[Topology[s][x][[m]],n] /.
    ConstructAdditionalInfor
   
AddV3[ Topology[s_][ x:Propagator[___][__].. ],n_Integer,m_Integer ] :=
Block[ {return},
  return=Topology[s v3][x,
    Propagator[ex][ e[n],v4[n] ]] /. v3[m] -> v4[n];
  If[ m<0, return = Topology[s vc]@@ return ];
  return = return /. ConstructAdditionalInfor;
  If[ Length[Vsn[3][ Topology[x] ]]>1,
    return = SwapV[ return, Vsn[3][return],
      Table[ -i, {i,Length[Vsn[3][return]]} ] ]
  ];
  return
]

(* adding propagator #n to all other propagators *)

AddPropagator[ Topology[s_][ x:Propagator[___][__].. ], n_Integer ] :=
  TopologyList@@
    Array[ AddPropagator[Topology[s][ x ],n,#]&, Length[{x}] ]

(* adding propagator #n to all 3-vertices *)

AddV3[ Topology[s_][ x:Propagator[___][__].. ], n_Integer ] :=
  TopologyList@@
    (AddV3[ Topology[s][ x ],n,#]&/@ Vs[3][ Topology[x] ])

(* putting it all together *)

AddOne[ t:Topology[s_][__], n_Integer ] := 
  TopologyList[
    TopologiesCompare[ AddPropagator[t,n] ],
    TopologiesCompare[ AddV3[t,n] ] ]

(* TopologiesCompare routine *)

TopologiesCompare[ TopologyList[], ___ ] := TopologyList[]

TopologiesCompare[ tt:TopologyList[__] ] :=  
Block[ {check, notequal, posequal},
  check = (AtomQ[#[[0,1]] ] || MemberQ[#[[0,1]], in|ex|v3])&;
  notequal = Select[tt, check];
  posequal = Select[tt, !check[#]&];
  posequal = Compare[posequal] //. DeleteAdditionalInfor;
  notequal = notequal //. DeleteAdditionalInfor;
  Append[notequal,posequal]
]

(* basic topology-compare routine *)

(* construct the vertices *)

Vs[3][ t_ ] := Union[Flatten[ List@@ (Cases[#, v3[n_] -> n]&/@ t) ]]

Vs[4][ t_ ] := Union[Flatten[ List@@ (Cases[#, v4[n_] -> n]&/@ t) ]]

Vsn[type_Integer?Positive][ t_ ] := Select[ Vs[type][t], #<0& ]

(* for permutations *)

SwapV[ x_ , old_List , new_List ] :=           
  x /. Thread[v3/@ old -> v3/@ new] /. Thread[v4/@ old -> v4/@ new] 

(* comparable form *)

PrSort[ pr_[f_,t_] ] := Sort[ pr[f,t] ]

PrSort[ pr_[f_,t_, p_], mod_List ] :=
  If[ !OrderedQ[{f,t}],
    Propagator[t, f, AntiParticle[mod][p]],
  (* else *)
    If[ f === t,
      Propagator[f, f, Sort[{p,AntiParticle[mod][p]}][[1]] ],
      Propagator[f, t, p]
    ]
  ]

CompForm[ t:Topology[___][__], mod___List ] := 
  Topology@@ Sort[ PrSort[Propagator@@ #,mod]&/@ t]  

(* compare Topology with TopologyList *)

Complist[ t:Topology[___][__], tt_TopologyList, mod___ ] :=
Block[ {ctm = CompForm[t,mod]},
  (ctm === #)&/@ List@@ (CompForm[#,mod]&/@ tt)
]

(* compare `permutable' Topology with TopologyList *)

DoPerComplist[ t:Topology[___][__],
  tt_TopologyList, per_List, mod___List ] :=
  Function[z, (z === #)&/@ (List@@ (CompForm[#,mod]&/@ tt))]/@
    (CompForm[SwapV[t,per,#],mod]&/@ Permutations[per])

(* two groups of permutables *)

PerComplist[ t:Topology[___][__], tt_TopologyList, a_List, {}, 
  mod___List ] :=
  DoPerComplist[t, tt, a, mod]

PerComplist[ t:Topology[___][__], tt_TopologyList, a_List, {_},
  mod___List] :=
  DoPerComplist[t, tt, a, mod] 

PerComplist[ t:Topology[___][__], tt_TopologyList, a_List, {pp__}, 
  mod___List ] :=
  Flatten[ List@@ (DoPerComplist[#,tt,a,mod]&/@
    (SwapV[t,{pp},#]&/@ Permutations[{pp}]) ) ]

(* putting these things together *)

compare[ t:Topology[___][__], tt_TopologyList, mod___ ] :=
Block[ {long, short},
  If[ Length[Vsn[3][t]] >= Length[Vsn[4][t]],
    long = Vsn[3][t]; short = Vsn[4][t],
    long = Vsn[4][t]; short = Vsn[3][t]
  ]; 
  If[ Length[long] < 2 && Length[short] < 2,
    Complist[t,tt,mod],
    MemberQ[#,True]&/@
      Transpose[ PerComplist[t,tt,long,short,mod] ]
  ]
]

(* for extracting the information *)

comp[ True, t:Topology[s_][x__] ] := trash

comp[ False, t:Topology[s_][x__] ] := t  

comp[ n_Integer, t:Topology[s_][x__] ] :=
Block[ {new = Head[t][[1]]},
  new = If[ Length[new] > 1,
    Select[new, (Head[#] === Integer)& ],
    new ];
  new /= n;
  Topology[new]@@ t
]

truesum[ { a___, True, b___ } ]:=
  {a, Length[Cases[{a,True,b},True]], b}

(* apply the comp function *)

compmap[ t:Topology[___][__], tt_TopologyList, m_Integer, mod___ ] :=
  (comp@@ #)&/@ 
    Transpose[ { Join[ Table[False,{m-1}] ,
      truesum[compare[t,Drop[tt,m-1],mod]]] , 
      List@@ tt } ] 

(* main compare routine *)

Compare[ TopologyList[], mod___ ] := TopologyList[]

Compare[ tt:TopologyList[__], mod___ ] := 
Block[ {nn = 1, topol},
  topol = tt;
  While[ nn < Length[ topol ] ,
    topol=Select[ TopologyList@@ compmap[topol[[nn]],topol,nn,mod],  
      (# =!= trash)&];
    nn++
  ];
  topol
]

End[]

EndPackage[]
