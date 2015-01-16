(*
	InsertFields.m
		insert fields into topologies
		last change: 1 Dec 97 by TH
*)

BeginPackage["InsertFields`", {"FeynArts`","CreateTopologies`"}]

InsertFields::usage =
"InsertFields[topology, extli, options] constructs all Feynman diagrams
of a Topology or a TopologyList with external fields given in `extli'.
extli must be of the form
{ particle_1, ..., particle_i } -> { particle_i+1, ..., particle_n }" 

Begin["`Private`"] 

(* initialization *)

AppendFieldVar[ pr_[a_,b_,c___], i_Integer ] := pr[a, b, fi[i], c]

PropagatorSort[a_] :=
  If[ Length[a] === 2, Sort[a], Append[ Sort[Take[a,2]],a[[3]] ] ]

ToType[ Incoming ] = inc

ToType[ Outgoing ] = out

InitTopology[mod_][ tt:Topology[_][___], extli_ ] := 
Block[ {to},
  to = Sort[ (PropagatorSort/@ tt) /. ex -> AAA ];
  (Head[to]@@
    Append[ MapIndexed[AppendFieldVar[#1,#2[[1]] ]&, to],
      Insertions[Graph[]] ]) //.
    t_[ pp___,
        Propagator[AAA][a___,e[i_Integer],b___,fi[j_],c___],
        qq___, Insertions[Graph[v___]] ] :>
      t[ pp, Propagator[extli[[i,0]]//ToType][a,e[i],b,fi[j],c], qq,
       Insertions[ Graph[v, fi[j] -> extli[[i]] /.
         {Incoming -> Identity, Outgoing -> AntiParticle[mod]}] ] ]
]

(* Insert compatible particles in 1 propagator for 1 set of rules *)

Ins11[ vert2_, ru_, mod_, i_Integer, proptype_ ] :=
Block[ {int, vx, newvertex, possiblevx1, possiblevx2},
  vx = vert2 /. (List@@ ru) ;
  possiblevx1 = Union@@ (PossibleParticles[#][vx[[1]]]&/@ mod);
  possiblevx2 = Union@@ (PossibleParticles[#][vx[[2]]]&/@ mod);
  int = Intersection[ AntiParticle[mod]/@ possiblevx1, possiblevx2,
    Complement[ Union@@ (ParticleList/@ mod),
      Global`ExcludeParticles[proptype] ]
  ];
  If[ vx[[1]] === vx[[2]],
    int = Select[ int,
      (newvertex = vx[[1]] /. fi[i] -> #;
        !FreeQ[newvertex,fi] || MemberQ[VertexList[mod],newvertex])&
    ] ]; 
  Insertions@@ (Append[ru,fi[i] -> #]&/@ int)
]

FindFields[ ver_, pr_[ver_,_,c_] ] := Vertex[ APa[c] ]

FindFields[ ver_, pr_[_,ver_,c_] ] := Vertex[ c ]

FindFields[ ver_, pr_[ver_,ver_,c_] ] := Vertex[ APa[c], c ]

FindFields[ ver_, pr_[_,_,c_] ] := Vertex[]

(* insert the first i propagators (recursive definition) *)

Ins1[ tt:Topology[_][___], _, i_Integer, i_Integer ] := tt

Ins1[ tt:Topology[_][___], mod_, i_Integer, extlength_Integer ] := 
Block[ {t, rules, props, vert2},
  t = Ins1[tt, mod, i-1, extlength];
  rules = Last[t];
  props = Drop[t,-1];
  vert2 = {
    Flatten[ Vertex@@ (FindFields[props[[i,1]],#]&/@ props) ],
    Flatten[ Vertex@@ (FindFields[props[[i,2]],#]&/@ props) ] 
  } /. APa -> AntiParticle[mod];
  Append[ props,
    Flatten[Union[ Ins11[vert2,#,mod,i,props[[i,0,1]] ]&/@ rules ]] ]
]

InsertFields::badparticle =
"Particle `1` does not live in models `2`."

InsertFields::extnumber =
"You cannot fit `1` external particle(s) onto a `2` leg topology."

Options[InsertFields] = {
  Model -> {SM},
  Generation1 -> True,
  Generation2 -> True,
  Generation3 -> True,
  ElectronHCoupling -> True,
  LightFHCoupling -> True,
  QuarkMixing -> False,
  UnitaryGauge -> False,
  RemoveEmptyTops -> True,
  ScreenMessages -> True,
  ProcessName -> Automatic
}

(* supports equation form of extli *)

InsertFields[ tt_, a_ -> b_, Opt___Rule ] :=
Block[ {insresult},
  insresult = InsertFields[ tt,
    Join[ List@@ (Incoming/@ a), List@@ (Outgoing/@ b) ], Opt ];
  Append[Head[insresult], Process -> (a -> b)]@@ insresult
] /; Head[a] === Head[b]

(* insert fields into 1 topology *)

InsertFields[ t:Topology[_][___], extli_List, modOpt___Rule ] :=
Block[ {modelname, localoptions, partlist, momli,
ttt, tt, to, too, topextlength},
  localoptions = ActualOptions[InsertFields, modOpt];
  topextlength = Count[t, Propagator[ex][___]];
  If[ Length[extli] =!= topextlength,
    Message[InsertFields::extnumber,Length[extli],topextlength];
    Return[$Aborted] ];
  If[ (modelname = CheckModel[localoptions]) === $Aborted,
    Return[$Aborted] ];
  partlist = Union@@ (ParticleList/@ modelname);
  Scan[ If[ !MemberQ[partlist,#[[1]]],
    Message[InsertFields::badparticle, #[[1]], Model /. localoptions];
    Return[$Aborted] ]&, extli];
  ttt = InitTopology[modelname][t, extli];
  If[ Length[ Select[Drop[ttt,-1],FreeQ[#,e]&] ] == 0 &&
    !MemberQ[VertexList[modelname],
      Vertex@@ Array[ ttt[[-1,1,#,2]]&, Length[ ttt[[-1,1]] ] ] ],
    ttt = ttt /. Insertions[__] -> Insertions[]
  ];
  tt = Append[ Take[#,3]&/@ Take[ttt,Length[t]], Last[ttt] ];
  momli = Drop[#,3]&/@ Take[ttt,Length[t]];
  to = Ins1[tt, modelname, Length[t], Length[extli]];
  Print[Length[Last[to]], " insertions before Compare"];
  too = InsertionsCompare[to, modelname];
  Print[Length[too], " insertions after Compare" ];
  Print[];
  too = Topology@@ Append[ 
    Array[(tt[[#,0]]@@ Join[List@@ tt[[#]], List@@ momli[[#]] ])&, 
      Length[tt]-1 ],
    too ];
  localoptions = 
    Select[localoptions, FreeQ[#, ScreenMessages | RemoveEmptyTops]&] /.
    (ProcessName -> Automatic) :> (ProcessName -> AutoProcessName[extli]);
  (TopologyList@@ localoptions)[too]
]

(* insert fields into a list of topologies *)

InsertFields[ topl_TopologyList, extli_List, modOpt___Rule ] :=
Block[ {result, localoptions, modelname, mod, partlist,
topextlength, deltalength},
  localoptions = ActualOptions[InsertFields, modOpt];
  topextlength = Count[topl[[1]], Propagator[ex][___]];
  If[ Length[extli] =!= topextlength,
    Message[InsertFields::extnumber, Length[extli], topextlength];
    Return[$Aborted] ];
  If[ (modelname = CheckModel[localoptions]) === $Aborted,
    Return[$Aborted] ];
  partlist = Union@@ (ParticleList/@ modelname);
  Scan[ If[ !MemberQ[partlist,#[[1]] ],
    Message[InsertFields::badparticle, #[[1]], Model /. localoptions];
    Return[$Aborted] ]&, extli];
  localoptions = Select[localoptions, FreeQ[#,ScreenMessages]&] /.
    (ProcessName -> Automatic) :> (ProcessName -> AutoProcessName[extli]);
  le = Length[topl];
  result = (TopologyList@@ localoptions) @@
    Array[(Print["Topology ",#," (out of ",le,") being inserted"];
      InsertFields[topl[[#]], extli, modOpt][[1]])&, le];
  If[ RemoveEmptyTops /. localoptions,
    deltalength = le - 
      Length[ result = Select[result, Length[ #[[-1]] ] =!= 0 &] ];
    If[ deltalength > 0,
      Print["Out of ", le, If[ le === 1," top. "," tops. "],
        deltalength, " have no ins. and are discarded" ] ]
  ];
  Print["total number of insertions: ",
    Plus@@ (Length[Last[#]]&/@ result)];
  SetOptions[FeynInit, ScreenMessages -> True];
  $Output = {"stdout"};
  result
]

tostr[ h_[n_Integer?Positive] ] := ToString[h]<>ToString[n]

tostr[ h_[n_Integer] ] := "a"<>ToString[h]<>ToString[-n]

tostr[ h_[I] ] := ToString[h]<>"I"

tostr[ h_[-I] ] := "a"<>ToString[h]<>"I"

AutoProcessName[ x_List ] :=
Block[ {name},
  Off[General::spell1];
  name = ToExpression[
    StringJoin[ x /. {Incoming -> List, Outgoing -> List} /.
      h:(_[_?AtomQ]) :> tostr[h] ] ];
  On[General::spell1];
  name
]

(* compare all insertions *)

LongInsertion[mod_][ b___ ] := 
  (#[[1]] -> Sort[ {#[[2]],AntiParticle[mod][#[[2]] ]} ][[1]])&/@ {b}

InsertionsCompare[ Topology[___][___,Insertions[]], mod_ ] :=
  Insertions[]

InsertionsCompare[ t:Topology[1][___], mod_ ] :=  
  Last[t] /. {Topology[1] -> Topology, Graph -> Graph[1]}

InsertionsCompare[ to:Topology[_][__], mod_ ] := 
Block[ {top, ru, inli, lili, all, pos, ar},
  top = Drop[to,-1];
  ru = Last[to] /. Graph -> LongInsertion[mod];
  inli = #[[3]]&/@ Select[top, !FreeQ[#,in]&];
  lili = #[[3]]&/@ Select[top, FreeQ[#,in|inc|out]&];
  all = Join[inli /. #, Sort[lili /. #]]&/@ ru;
  pos = Position[all,#]&/@ Union[all];
  ar = Append[ top, Insertions@@ (to[[-1,#]]&/@ Flatten[#]) ]&/@ pos;
  Join@@ (DisjointInsertionsCompare[#,mod]&/@ ar)
]

(* comparing disjoint subsets using CreateTopologies`Compare *)

DisjointInsertionsCompare[ to:T_[ __ ] , mod_ ] := 
  Insertions@@ (ExtractInsertion /@ 
    Compare[ TopologyList@@
      Array[ Drop[to,{-1}] /. (Last[to][[#]] /. Graph -> List)&,
        Length[Last[to]] ],
      mod ])

ExtractInsertion[ t:Topology[i_][ ___ ] ] :=
  Graph[i]@@ Array[ fi[#] -> t[[#,3]] &, Length[t] ]

(* making insertions for drawing a topology *)

LineSpec[ TopDummy[1] ] = { straight, none, " " }

InsertFields[ tt_TopologyList, ninc_Integer, nout_Integer ] :=
  TopologyList[Model -> {Topology}, Process -> Topology]@@
    (InsertFields[#,ninc,nout]&/@ tt)

InsertFields[ tt:Topology[sym_][__], ninc_, nout_ ] :=
Block[ {rettop},
  rettop = Sort[(PropagatorSort/@ tt) /. ex -> xxt] /. xxt -> ex /.
    IncOutSpecification[ninc,nout];
  rettop = MapIndexed[AppendFieldVar[#1,#2[[1]] ]&, rettop];
  Topology@@ Append[ rettop,
    Insertions[ Graph[sym]@@ Array[fi[#] -> TopDummy[1]&, Length[tt]] ] ]
]

IncOutSpecification[ ninc_, nout_ ] :=
  Join[
    Array[Propagator[ex][e[#],vert__] :> Propagator[inc][e[#],vert]&, 
      ninc],
    Array[Propagator[ex][e[#],vert__] :> Propagator[out][e[#],vert]&,
      nout, ninc+1]
  ]

End[]

EndPackage[]

