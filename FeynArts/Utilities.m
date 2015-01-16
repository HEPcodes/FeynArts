(*
	Utilities.m
		diverse utility functions for other parts of FA
		last modified 19 Sep 01 th
*)

Begin["`Utilities`"]

Attributes[ FAPrint ] = {HoldRest}

FAPrint[ l_Integer, s__ ] := Print[s] /; l <= $Verbose


ActualOptions::noopt =
"Warning: `2` is not a valid option of `1`."

Options[ ActualOptions ] = {Warnings -> True}

ActualOptions[ sym_, opts___ ] :=
Block[ {p},
  If[ Warnings /. Options[ActualOptions],
    Message[ActualOptions::noopt, sym, #]&/@
      Complement[First/@ {opts}, First/@ Options[sym]] ];
  If[ Length[ p = Position[{opts}, First[#] -> _, 1, 1] ] === 0, #,
    {opts}[[ Sequence@@ p[[1]] ]] ]&/@ Options[sym]
]


ResolveLevel::invalid =
"Invalid level specification `1`."

ResolveLevel[ lev_List ] :=
  (Union[lev /. Generic -> AAA] /. AAA -> Generic) /;
    VectorQ[lev, MatchQ[#, Generic | Classes | Particles]&]

ResolveLevel[ Generic ] = {Generic}

ResolveLevel[ Classes ] = {Generic, Classes}

ResolveLevel[ Particles ] = {Generic, Classes, Particles}

ResolveLevel[ x_ ] :=
  (Message[ResolveLevel::invalid, x]; $Failed)


ContainsQ[ expr_, {} ] = True

ContainsQ[ expr_, {x_, ___} ] := False /; FreeQ[expr, x]

ContainsQ[ expr_, {_, li___} ] := ContainsQ[expr, {li}]


If[ System`Ordering[{1, 2}] =!= {1, 2},
  System`Ordering[x_] :=
    Last/@ Sort[Transpose[{x, Range[Length[x]]}]]
]


(* generic fields have no signs (attribute SelfConjugate exists
   only at classes level, i.e. there are no generic antiparticles) *)

ToGeneric[ expr_ ] := expr /. _. (f:P$Generic)[__] -> f

ToClasses[ expr_ ] := expr /. s_. (f:P$Generic)[i_, __] :> s f[i]


Seq = Sequence


(* extract vertices: *)

Vertices[ top_ ] :=
  Union[ Cases[top, Vertex[n__][_] /; {n} =!= {1}, {2}] ]


(* get the correct Lorentz index *)

IncParticle[ s_. fi_[ind__, fr_ -> _] ] := AntiParticle[s fi[ind, fr]]

IncParticle[ fi_ ] := AntiParticle[fi]

OutParticle[ s_. fi_[ind__, _ -> to_] ] := s fi[ind, to]

OutParticle[ fi_ ] = fi

(* get particle which is incoming in vertex v from propagator pr *)

TakeInc[ v_, _[v_, v_, part_, ___] ] :=
  Sequence[IncParticle[part], OutParticle[part]]

TakeInc[ v_, _[v_, _, part_, ___] ] := IncParticle[part]

TakeInc[ v_, _[_, v_, part_, ___] ] := OutParticle[part]

TakeInc[ __ ] = Sequence[]


TakeGraph[ gr_ -> _ ] = gr

TakeGraph[ gr_ ] = gr

TakeIns[ _ -> ins_ ] = ins

TakeIns[ _ ] = Sequence[]


(* Canonical ordering *)

PSort[ Propagator[x__] ] := PSort[ Propagator[True][x] ]

PSort[ pr:Propagator[_][_, _] ] := Sort[pr]

PSort[ Propagator[type_][from_, to_, part_] ] :=
  If[ !OrderedQ[{from, to}] ||
        (from === to && !OrderedQ[{part, AntiParticle[part]}]),
    Propagator[type][to, from, AntiParticle[part]],
  (* else *)
    Propagator[type][from, to, part]
  ]


SortCrit[ a:s_. (f:P$Generic)[t_, i___] ] := {s f[t], {i}, a}

SortCrit[ a:s_. f:P$Generic ] := {s f[0], {}, a}

VSort[ vert_ ] := Last/@ Sort[SortCrit/@ vert]


(* Compare: First build a table of all possible permutations of
   the permutable vertices (those with negative indices), unionize it,
   and weed out the superfluous tops + get their symm factor right *)

Renumber[ top_ ] :=
Block[ {s},
  s = Sort[(Propagator@@ PSort[#])&/@ top];
  s /. MapIndexed[ #1 -> Head[#1]@@ #2 &, Vertices[s] ]
]


TopPermute[ Topology[_][props__] ] :=
Block[ {perm},
  perm = Union[ Cases[{props}, Vertex[_][_?Negative], {2}] ];
  If[ Length[perm] === 0, Return[Renumber[{props}]] ];
  Sort[ Renumber[{props} /. Thread[perm -> #]]&/@
    Permutations[perm] ][[1]]
]


Compare[ tops:_[] ] = tops

Compare[ tops_ ] :=
Block[ {perm, p},
  perm = TopPermute/@ tops;
  ( p = Position[perm, #, 1];
    tops[[ p[[1, 1]] ]] /.
      Topology[s_][rest__] -> Topology[s / Length[p]][rest] )&/@
    Union[perm]
]


Pluralize[ n_, what_ ] :=
  ToString/@ n <> what <> If[Plus@@ Cases[n, _Integer] === 1, "", "s"]

Statistics[ expr_, levels_, what_ ] :=
  Pluralize[
    Rest[Flatten[ {
      ", ",
      Plus@@
        Cases[expr, Insertions[#][args__] :> Length[{args}], Infinity],
      " ", # }&/@ levels ]], 
    what ]


Alph::badindex =
"There is no letter with index `1`."

Alph[ n_ ] := FromCharacterCode[n + 96] /; n > 0 && n < 27

Alph[ n_ ] := Message[Alph::badindex, n]

UCAlph[ n_ ] := FromCharacterCode[n + 64] /; n > 0 && n < 27

UCAlph[ n_ ] := Message[Alph::badindex, n]

MapIndexed[ (Greek[#1] = #2)&[#2[[1]], #1]&,
  { "\\alpha", "\\beta", "\\gamma", "\\delta", "\\epsilon", "\\zeta",
    "\\eta", "\\theta", "\\iota", "\\kappa", "\\lambda", "\\mu", "\\nu",
    "\\xi", "o", "\\pi", "\\rho", "\\sigma", "\\tau", "\\upsilon",
    "\\phi", "\\chi", "\\psi", "\\omega" } ]

Greek[ n_ ] := Message[Alph::badindex, n]

MapIndexed[ (UCGreek[#1] = #2)&[#2[[1]], #1]&,
  { "A", "B", "\\Gamma", "\\Delta", "E", "Z", "H", "\\Theta", "I", "K",
    "\\Lambda", "M", "N", "\\Xi", "O", "\\Pi", "P", "\\Sigma", "T",
    "\\Upsilon", "\\Phi", "X", "\\Psi", "\\Omega" } ]

UCGreek[ n_ ] := Message[Alph::badindex, n]

End[]

