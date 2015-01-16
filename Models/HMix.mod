(*
	HMix.mod
		model file which adds two new particles:
		S[0,  {h}] = Sum[UHiggs[h,i] S[i], {i, 3}]
		S[10, {h}] = Sum[ZHiggs[h,i] S[i], {i, 3}]
		this file is part of FeynArts
		last modified 15 Jan 07 th
*)


ReadModelFile["MSSMQCD.mod"]

IndexRange[ Index[Higgs] ] = Range[3]

M$ClassesDescription = Flatten[{
  DeleteCases[M$ClassesDescription, S[1|2|3] == _],
  S[0] == {
	SelfConjugate -> True,
	Indices -> {Index[Higgs]},
	Mass -> MHiggs,
	PropagatorLabel -> ComposedChar["H", Index[Higgs]],
	PropagatorType -> ScalarDash,
	PropagatorArrow -> None },
  S[10] == {
	SelfConjugate -> True,
	Indices -> {Index[Higgs]},
	InsertOnly -> {External},
	Mass -> MHiggs,
	PropagatorLabel -> ComposedChar["H", Index[Higgs], Null, "\\hat"],
	PropagatorType -> ScalarDash,
	PropagatorArrow -> None }
}]


Block[ {NewCoup, UZPerm, coup, oldcoup, newcoup},

NewCoup[c_ == rhs_] :=
Block[ {p = Position[c, S[1|2|3]]},
  Block[ {newi, u},
    newi = Take[{h1, h2, h3, h4}, Length[p]];
    u = Plus@@ (Times@@ MapThread[UHiggs, {newi, #}]&)/@
      Permutations[Apply[c[[#, 1]]&, p, 1]];
    (coup[#] += u rhs)& @
      ReplacePart[c, S[0, {#}]&/@ newi, p, Array[List, Length[p]]];
    {}
  ] /; Length[p] > 0
];

NewCoup[other_] = other;


UZPerm[_[_[_[c_]], rhs_]] :=
Block[ {hi = Cases[c, S[0, {h_}] -> h]},
  (c == (Simplify[rhs] /. CB TB -> SB)) /.
    Array[
      Flatten[{UHiggs[#, i_] -> ZHiggs[#, i],
               S[0, {#}] -> S[10, {#}]}&/@ Take[hi, #]]&,
      Length[hi] + 1, 0 ]
];


_coup = 0;
oldcoup = NewCoup/@ M$CouplingMatrices;
_coup =.;
newcoup = UZPerm/@ DownValues[coup];


If[ TrueQ[$JustNewCouplings], oldcoup = {} ];

M$CouplingMatrices = Flatten[{oldcoup, newcoup}];

]

