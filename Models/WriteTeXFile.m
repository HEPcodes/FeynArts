(*
	WriteTeXFile.m
		writes out the couplings of a
		FeynArts model file in TeX form
		last modified 18 Mar 20 th

	Usage:	WriteTeXFile["model"]
*)


BeginPackage["WriteTeXFile`", "FeynArts`"]

WriteTeXFile::usage =
"WriteTeXFile[\"model.mod\"] writes the Feynman rules in model.mod in
TeX format to model.tex."

TeXFile::usage =
"TeXFile is an option of WriteTeXFile.  It specifies the output filename
to use.  If set to Automatic, the name of the model file with extension
\".tex\" is used."

PreFunction::usage =
"PreFunction is an option of WriteTeXFile.  It specifies a function to be
applied to each component of the coupling vector before formatting."

MaxLeaf::usage =
"MaxLeaf is an option of WriteTeXFile.  It specifies the leaf count
above which an expression is split into more than one line."

AbbLeaf::usage =
"AbbLeaf is an option of WriteTeXFile.  It specifies the leaf count
above which a subexpression is put into an abbreviation."

TeX::usage =
"TeX[s] indicates that s is TeX code that is written unmodified to the
output file."

Sym::usage =
"Sym[s, sub, sup] prints as symbol s with subscript sub and superscript
sup, where sub and sup are optional."

delta::usage =
"delta[sym] outputs \"delta sym\"."

Abb::usage =
"Abb[expr] prints expr inside a yellow box."

SymRules::usage =
"SymRules turns common symbols into their printed form."

ModelSymRules::usage =
"ModelSymRules turns model symbols into their printed form."

WidthRules::usage =
"WidthRules turns common symbols into a form that better approximates their
width.  This is used for computing line breaks."

ModelWidthRules::usage =
"ModelWidthRules turns model symbols into a form that better approximates
their width.  This is used for computing line breaks."

ConjSym::usage =
"ConjSym[f] specifies a conjugation symbol for field f.  Choices are:\n
  ConjSym[f] = \"-\"\n
  -- f prints as f^-, anti-f prints as f^+,\n
  ConjSym[f] = NoDagger\n
  -- f prints as f, anti-f prints as f^\\dagger,\n
  ConjSym[f] = Null\n
  -- f prints as f, anti-f prints as \\bar f."

NoDagger::usage =
"NoDagger is a symbol used with ConjSym to indicate printing of the
conjugate field with a dagger."

Class::usage =
"Class associates each field a class which is used to group the
couplings."

IndexLetter::usage =
"IndexLetter[i] gives the letter with which indices of type i will be
abbreviated."

AAA::usage =
"AAA[x] serves to move x to the front of a product.  The AAA is
not printed."

BracketForm::usage =
"BracketForm[expr] isolates expr from the rest of the expression it
is embedded in and is turned into HoldForm after formatting."

Begin["`Private`"]

Attributes[brk] = {HoldAll};

brk[x___] := (Begin["WriteTeXFile`Private`"]; Print["brk ", HoldForm[x]]; Interrupt[]; End[])

template = ReadList[
  System`Private`FindFile[$Input] <> ".tex",
  Record, RecordSeparators -> {} ][[1]]

System`Convert`TeXFormDump`maketex[RowBox[{"TeX", _, arg_String, _}]] :=
  ToExpression[arg]

Format[TeX[s_], OutputForm] := s

Format[BracketForm[expr_], OutputForm] := HoldForm[expr]

Format[sym[{s___}, {}, {sup___}], OutputForm] :=
  Superscript[SequenceForm[s], SequenceForm[sup] /. NoDagger :> Sequence[]]

Format[sym[{s___}, {sub___}, {sup___}], OutputForm] :=
  Superscript[SequenceForm[s,"(",sub,")"], SequenceForm[sup] /. NoDagger :> Sequence[]]

TeXEnv[name_, vspace_, deb___][args__] := SequenceForm@@ Flatten[{
  TeX["\n\\begin{" <> name <> "}\n" <> deb],
  Riffle[{args}, TeX[vspace]],
  TeX["\n\\end{" <> name <> "}"] }]

(*delta[x_] := SequenceForm["\[Delta]", x]*)
delta[x_] := {"\[Delta]", x}


Sym[s_, sub_:{}, sup_:{}] :=
  sym[Flatten[{s}], MakeList[sub], MakeList[sup]]

MakeList[Null] = {}

MakeList[{}] = {}

MakeList[s_Symbol] = {s}

MakeList[i__] := Riffle[DeleteCases[Flatten[{i}], Null], ","]

texsym[s_, sub_, sup_] := subsup@@ SequenceForm@@@
  Map[ToString, {s, sub, sup /. NoDagger :> Sequence[] /. {a__, ","} -> {a}}, {-1}]

subsup[s_, _[], _[]] := s

subsup[s_, sub_, _[]] := Subscript[s, sub]

subsup[s_, _[], sup_] := Superscript[s, sup]

subsup[s_, sub_, sup_] := Superscript[Subscript[s, sub], sup]


sym/: sym[x__, {sup___}]^n_Integer?Positive := sym[x, {sup, n}];
sym/: sym[x__, {sup___}]^n_Integer := 1/sym[x, {sup, -n}] /; n < -1

sym/: Conjugate[sym[x__, {sup___}]] := sym[x, {sup, "*"}]

sym/: OverBar[sym[x__, {sup___, TeX["-"]}]] := sym[x, {sup, TeX["+"]}];
sym/: OverBar[sym[x__, {sup___, TeX["+"]}]] := sym[x, {sup, TeX["-"]}]

sym/: OverBar[sym[x__, {sup___, TeX["--"]}]] := sym[x, {sup, TeX["++"]}];
sym/: OverBar[sym[x__, {sup___, TeX["++"]}]] := sym[x, {sup, TeX["--"]}]

sym/: OverBar[sym[x__, {sup___, NoDagger}]] := sym[x, {sup, "\[Dagger]"}];
sym/: OverBar[sym[x__, {sup___, "\[Dagger]"}]] := sym[x, {sup, NoDagger}]

sym/: OverBar[sym[x_, subp__]] := sym[OverBar/@ x, subp]


Attributes[MakeFieldRules] = {Listable}

MakeFieldRules[f_ == desc_] :=
Block[ {Index = Identity, i = Indices /. desc, j, Sym},
  If[ Length[i] > 0,
    SetDelayed@@ (Hold@@ {
      IndexRules[_. Append[f, Pattern[#, Blank[]]&/@ i], {n_}],
      MapThread[#1 :> #2 <> ToString[n] &, {i, IndexLetter/@ i}]
    } /. RuleDelayed -> Rule) ];
  RuleDelayed@@ {
    If[Length[i] === 0, f, Append[f, j___]],
    ToSym[PropagatorLabel /. desc /. Thread[i -> Array[iMap[j], Length[i]]],
      AddConj[SelfConjugate /. desc, ConjSym[f]]] }
]

IndexLetter[i_] := ToLowerCase[StringTake[ToString[i], 1]]

iMap[][___] = iMap[{}][___] = {}

iMap[j_List][n_] := j[[n]] /. Null -> {}


TeXStr[s_String] := TeX[s]

TeXStr[other_] := other


Attributes[ToSym] = {Listable}

ToSym[ComposedChar[s_, sub_, sup_, "\\tilde"], h_] :=
  h[OverTilde[TeXStr[s]], TeXStr[sub], TeXStr[sup]]

ToSym[ComposedChar[s_, sub_, sup_, bar_], h_] :=
  h[{TeX[bar <> "{"], TeXStr[s], TeX["}"]}, TeXStr[sub], TeXStr[sup]]

ToSym[ComposedChar[s_, sub_:Null, sup_:Null], h_] :=
  h[TeX[s], TeXStr[sub], TeXStr[sup]]

ToSym[other_, h_] := h[TeX[other], Null, Null]


AddConj[True, _] = AddConj[False, Null] = Sym

AddConj[False, c_][s_, sub_, sup_] := Sym[s, sub, {sup, c}]


ToBar[-f_] := OverBar[f]

ToBar[f_] := f


MakeSum[] = sum

MakeSum[{v1_, r__}, a___, {v2_, r__}, b___] :=
  MakeSum[{{v1, v2}, r}, a, b]

MakeSum[{var_, from_:1, to_}, a___][b___, expr_] := MakeSum[a][b,
  sym[{TeX["\\sum\\limits"]}, {MakeList[var], "=", from} //Flatten, to],
  expr]


sum[s__, expr_] := -sum[s, -expr] /; MinusInFrontQ[expr]

sum[s__, ZPlusB[a_, b__]] := -sum[s, ZPlusB@@ -{a, b}] /; 
  MinusInFrontQ[a]


widthRules := widthRules = Flatten[{ModelWidthRules, WidthRules}]

symRules := symRules = Flatten[{ModelSymRules, SymRules}]


(* splitting up long expressions *)

lcmax[li_] := MaximalBy[li, LeafCount][[1]]

lcseq[x_, y___] := Fold[#1[#2]&, x, {y}]

lcsym[{s___, x_}, r__] := Level[{{Random[], s}, lcmax[{r}]}, {2}, lcseq]

lcmulti[h_][z__] := {h @ lcmax[{z}]}

lcCoupVec[pre_, cv_] := CoupVec[pre, {lcmax[cv]}]

lcList[] := Sequence[]

lcList[a_, b___] := a[b] (* disregard LC of List itself *)


SizeExpr[expr_] := expr /. widthRules /.
  hx -> Identity /.
  SequenceForm|Subscript|Superscript -> lcseq /.
  "\[Delta]" :> "\[Delta]"[1] /.
	(* can't help Delta Z displays as (Delta Z), at least account for it *)
  {TeX[s_] :> s, "," :> Sequence[], s_String :> Characters[s]} /.
  sym -> lcsym /.
  h:_multi|ZPlusB|ZTimesB :> lcmulti[h] /.
  CoupVec -> lcCoupVec /.
  List -> lcList

LC[expr_] := LeafCount[SizeExpr[expr]];


SplitExpr[expr_] :=
Block[ {ex, px, py, abb},
  abb[h_][x__] := If[ (*!FreeQ[{x}, Abb] ||*) LC[h[x]] < abbleaf, h[x],
    abb[h][x] = Abb[++subN] ];
  ex = expr /. Plus :> abb[Plus];
  ex = Flatten[{ex, Reverse @ Sort[Cases[SubValues[abb], _[_[_[h_][x__]], s_Abb] :> s -> h[x]]]}];
(*Print["split1"];*)
  ex = split[Plus(*|Times*)]/@ ex;
(*Print["split2"];*)
  ex = split[Plus(*|Times*)]/@ ex;
(*Print["split3"];*)
  ex = split[Plus(*|Times*)]/@ ex;
(*
Print["split4"];
  ex = split[Plus(*|Times*)]/@ ex;
*)
  ex
]


(*split[h_][cpl_ == val_] := (Print["cpl"]; cpl == split[h][val])*)

(*split[h_][var_ -> val_] := (Print[var]; var -> split[h][val])*)

split[Times][expr_] := expr /; Head[expr] =!= Times

split[h_][expr_] :=
Block[ {ex, exleaf, p, try, ru},
  ex = expr /. t:h :> hx[t];
(*If[ MatchQ[ex, _Rule|_Equal], Print[ex[[1]]] ];*)
  While[ (exleaf = LC[ex]) > maxleaf &&
         (p = Position[{ex}, _hx[__]]) =!= {},
    try = short[ex]@@@ p;
    ru = MinimalBy[try, First][[1,2]];
(*brk[split];*)
    ex = ReplacePart[ex, ru];
  ];
  ex = ex /. hx -> (#1&) /. {multi[Plus] :> ZPlusB, multi[Times] :> ZTimesB};
  ex
]


hx[t_][p__] := t[p] /; LC[t[p]] < maxleaf/2

hx[Times][a___, x_, b___, y_, c___] := hx[Times][x y, a, b, c] /; FreeQ[x y, Plus]


short[expr_][1, p__] :=
Block[ {ex, remleaf, fusemax},
  ex = Extract[expr, {p}] /. hx -> Identity;
  If[ Length[ex] < 2, Return[{1, ex}] ];
  remleaf = LC[ReplacePart[expr, {p} -> FOO]];
  fusemax = Max[maxleaf - remleaf, maxleaf/2] (*- Min[exleaf - maxleaf, maxleaf/2]*);
(*Print["maxleaf=", maxleaf, "  remleaf=", remleaf, "  exleaf=", exleaf, "  fusemax=", fusemax];*)
  {N[LC[#]/LC[ex]], {p} -> #}& @ Flatten[Operate[Fuse, ex]]
]


Fuse[h_][a_, x___, b_, y___] := Fuse[h][h[a, b], x, y] /; LC[h[a, b]] < fusemax

Fuse[h_][a_, y___] := multi[h][a, Fuse[h][y]]

Fuse[h_][] := Sequence[] (*multi[h][]*)

multi[_][p_] := p


(* ordering inside a product *)

MinusInFrontQ[p_Plus] := MinusInFrontQ @ First[p]

MinusInFrontQ[_?Negative _.] = True

MinusInFrontQ[_] = False


TimesS[r__] :=
  If[MinusInFrontQ[#], TimesO[-1, -#], TimesO[1, #]]& @ Times[r]

TimesO[x_, r_. p_Plus] := If[ MinusInFrontQ[p],
  TimesO[-x ZPlusA@@ -p, r],
  TimesO[x ZPlusA@@ p, r] ]

TimesO[x_, r_. p_Plus^n_?Positive] := If[ MinusInFrontQ[p],
  TimesO[x (-1)^n (-p)^n, r],
  TimesO[x p^n, r] ]

TimesO[x_, r_. p_Plus^n_?Negative] :=
  TimesO[x (-1)^n, r (-p)^n] /; MinusInFrontQ[p]

TimesO[x_, r_. ZPlusB[a_, b__]] := If[ MinusInFrontQ[a],
  TimesO[-x ZPlusB@@ -{a, b}, r],
  TimesO[x ZPlusB[a, b], r] ]

TimesO[x_, r_. z_ZTimesB] := TimesO[x z, r]

TimesO[x_, r_. t_sum] := TimesO[x t, r]

TimesO[x_, r_] := If[Denominator[r] =!= 1,
  x HoldForm[r] //. HoldForm[t_. z:(_ZPlusB | _ZTimesB)^_.] :> z HoldForm[t],
  x r
] /. ZPlusA -> Plus


HoldTimes[t_Times] := HoldTimes@@ t


texZPlusB[z_, r___] := TeXEnv["PlusB", "\\\\\n"
  (*, "\\deb{", ToString[LC[ZPlusB[z, r]]], "}\n"*)
]@@ Partition[Flatten @ {z,
  If[MinusInFrontQ[#], {TeX["\,-"], -#}, {TeX["\,+"], #}]&/@ {r},
  ""}, 2]

texZTimesB[t___] := TeXEnv["TimesB", "\\\\\n"
  (*, "\\deb{", ToString[LC[ZTimesB[t]]], "}\n"*)
]@@ Partition[
  Append[Riffle[{TeX["\\left("], #, TeX["\\right)"]}&/@ {t}, TeX["\\,*"]], ""],
  2]


CVcomp[t_Times] := Flatten[Replace[List@@ t (*Cases[t, Except[_Plus]]*), {
  n_?Negative :> {-1, -n},
  Complex[0, n_?Negative] :> {-1, -n, I},
  Complex[0, n_] :> {n, I},
  p_Plus?MinusInFrontQ :> {-1, -p}
}, 1]]

CVcomp[0] := Sequence[]

_CVcomp = {}


ToCoupVec[cv:{_}] := CoupVec[1, cv]

ToCoupVec[cv_List] :=
  CoupVec[#, cv/# /. p_Plus/q_Plus :> -1 /; p + q == 0]&[
    Times@@ Intersection@@ CVcomp/@ cv ]


texCoupVec[1, cv_] := TeXEnv["CoupVec", "\n\\Next\n"
  (*, "\\deb{", ToString[LC[cv]], "}\n"*)
]@@ HoldForm/@ cv

texCoupVec[pre_, cv_] := SequenceForm[HoldForm[pre], texCoupVec[1, cv]]


(* sorting into classes of couplings *)

ToTeX[c_, lhs_, rhs_, n_] :=
Block[ {cl, cr, abb, subN = 0},
  WriteString["stdout", ToString[Global`CN = n], "\r"];
  Global`CV[n] = prefunc/@ rhs;
  cl = TeX["\\Coup{" <> ToString[n] <> "}"]@@ ToBar/@ lhs;
  cr = ToCoupVec[Global`CV[n]];
  Global`CXRAW[n] = cl == cr /. Join@@ MapIndexed[IndexRules, lhs] //.
    symRules /.
    FieldRules /.
    { Conjugate[(t:Times)[a__]] :> Conjugate[Sym[{"(", a, ")"}]],
      Conjugate[x_] :> Conjugate[Sym[x]] } //.
    IndexSum[expr_, i__] :> MakeSum[i][expr] /.
    BracketForm[p_Plus] :> -BracketForm[-p] /; MinusInFrontQ[p];
  Global`CXSKEL[n] = SplitExpr[Global`CXRAW[n]];
  If[ subN > 0, Print[n, "/", subN] ];
  Global`CXPRE[n] = Global`CXSKEL[n] /. symRules //.
    sym -> texsym /.
    Times -> TimesS /.
    {ZPlusB :> texZPlusB, ZTimesB :> texZTimesB} //.
    { sum[a___, p_Plus] :> SequenceForm[a, TeX["\\left("], p, TeX["\\right)"]],
      sum[a__] :> SequenceForm[a] };
  Global`CX[n] = Global`CXPRE[n] /.
    {p_Plus :> p, -x_ :> SequenceForm["-", x],
      i_Integer?Negative x_ :> SequenceForm["-", -i x]} /.
    CoupVec -> texCoupVec /.
    BracketForm -> HoldForm /.
    AAA[x_] :> x //.
    { SequenceForm[s_SequenceForm] :> s,
      SequenceForm[x_] :> x,
      HoldForm[h_HoldForm] :> h };
  If[ MemberQ[Global`$Debug, n], Print[n]; brk["term ", n] ];
  class[c] = {class[c], texExpr[Global`CX[n]], "\\bigskip\n\n"};
]


Attributes[texExpr] = {Listable}

texExpr[abb_ -> def_] := {"\\AbbDef{",
  (*"\\deb{", ToString[LC[def]], "}\n",*)
  "$", ToString[abb == def, TeXForm], "$}\n\n"}

texExpr[expr_] := {"$", ToString[expr, TeXForm], "$\n\n"}


Plural[p_Plus] := Plural/@ List@@ p

Plural[_[s_String]] := {" -- ", s}

Plural[n_ _[s_]] := {" -- ", ToString[n], " ", s} /;
  StringTake[s, -1] === "s"

Plural[n_ _[s_]] := {" -- ", ToString[n], " ", s, "s"}


AddCoup[lhs_ == rhs:{__List}, {n_}] :=
Block[ {cv = Transpose[rhs], name, h1, h2},
  If[ cto >= 0 && cto < Length[cv] && !MatchQ[cv = cv[[cto + 1]], {(0)...}],
    name = Class/@ lhs;
    h1 = ToString[Head[#]]&/@ List@@ name;
    h2 = Rest[Flatten[Plural[Plus@@ name]]];
    ToTeX[{"\\Class{", h1, "}{", h2, "}\n"}, lhs, cv, n] ]
]

AddCoup[c_, _] := (Message[WriteTeXFile::badcoup, c]; {})


WriteTeXFile::badcoup = "Warning: `` is not recognized as a coupling."

Options[WriteTeXFile] = {
  ModelEdit :> Null,
  TeXFile -> Automatic,
  PreFunction -> Identity,
  MaxLeaf -> 90,
  AbbLeaf -> 120,
  CTOrder -> 0 }

WriteTeXFile[model_, opt___?OptionQ] :=
Block[ {texfile, maxleaf, cto,
mod, FieldRules, IndexRules, class, couplings, hh},

  {texfile, prefunc, maxleaf, abbleaf, cto} =
    {TeXFile, PreFunction, MaxLeaf, AbbLeaf, CTOrder} /.
      {opt} //. Options[WriteTeXFile];

  Check[ mod = LoadModel[model], Abort[] ];
  ModelEdit /. {opt} /. Options[WriteTeXFile];

  FieldRules = MakeFieldRules[M$ClassesDescription];
  _IndexRules = {};

  _class = {};
  MapIndexed[AddCoup, M$CouplingMatrices];
  _class =.;

  couplings = StringReplace[
    StringJoin[{#1[[1, 1]], #2}&@@@ DownValues[class]],
    {"\n \n" -> "\n", "{}^" -> "^"} ];

  If[ texfile === Automatic, texfile = mod <> ".tex" ];
  If[ cto > 0,
    mod = mod <> " (" <> ToString[cto] <> "-loop counter terms)"];

  hh = OpenWrite[texfile];
  WriteString[hh, StringReplace[template,
    {"COUPLINGS" -> couplings, "MODEL" -> ToString[mod]}]];
  Close[hh]
]

End[]

EndPackage[]


(* here come the model-dependent things *)

Class[_. S[__]] := S["Scalar"];
Class[_. F[__]] := S["Fermion"];
Class[_. SV[__]] := SV["Scalar--Vector"];
Class[_. V[__]] := V["Gauge Boson"];
Class[_. U[__]] := U["Ghost"]


(* we want i and coupling constants to print in front,
   thus the silly name "AAA" *)

AAA/: AAA[x_]^n_ := AAA[x^n]

ConjSym[_F] = ConjSym[_U] = Null

_ConjSym = TeX["-"]


SinSym = TeX["s"];
CosSym = TeX["c"];
TanSym = TeX["t"];
BosonMassSym = TeX["M"];
FermionMassSym = TeX["m"];
USym = TeX["U"];
VSym = TeX["V"];
WSym = TeX["W"];
XSym = TeX["X"];
ZSym = TeX["Z"];

SymRules = {
  $HKSign -> 1 (* "(-)" *),
  Complex[re_, im_] :> re + im AAA["i"],
  EL :> AAA[Sym[TeX["e"]]],
  GS :> AAA[Sym[TeX["g"], "s"]],
  SW :> Sym[SinSym, "W"],
  CW :> Sym[CosSym, "W"],
  MW :> Sym[BosonMassSym, "W"],
  MZ :> Sym[BosonMassSym, "Z"],
  MH :> Sym[BosonMassSym, "H"],
  MLE[j_] :> Sym[FermionMassSym, F[2, {j}]],
  MQU[j_] :> Sym[FermionMassSym, F[3, {j}]],
  MQD[j_] :> Sym[FermionMassSym, F[4, {j}]],
  Mass[f_] :> Sym[FermionMassSym, f],
  CKM[g__] :> Sym["CKM", {g}],
  SUNTSum[c1_, c2_, c3_, c4_] :> Sym[{SUNT[x, c1, c2], SUNT[x, c3, c4]}],
  SUNT[g_, c1_, c2_] :> Sym[TeX["T"], {c1, c2}, g],
  SUNT[g__, c1_, c2_] :> Sym[{"(", Sym[TeX["T"], Null, #]&/@ {g}, ")"}, {c1, c2}],
  SUNF[g1_, g2_, g3_, g4_] :> Sym[{SUNF[g1, g2, "x"], SUNF["x", g3, g4]}],
  SUNF[g1_, g2_, g3_] :> Sym[TeX["f"], Null, {g1, g2, g3}],
  d_IndexDelta :> 1 /; !FreeQ[d, "c1"|"c2"|"c3"|"c4"],
  IndexDelta[n_Integer, i_] :> Sym["\[Delta]", {i, n}],
  IndexDelta[i__] :> Sym["\[Delta]", {i}],
  GaugeXi[v_] :> Sym["\[Xi]", v],
  dZe1 :> Sym[delta["Z"], "e"],
  dMHsq1 :> Sym[delta[BosonMassSym], "H", "2"],
  dMWsq1 :> Sym[delta[BosonMassSym], "W", "2"],
  dMZsq1 :> Sym[delta[BosonMassSym], "Z", "2"],
  dMf1[t_, j_] :> Sym[delta[FermionMassSym], j, F[t, {g}]],
  dMf1[t_, j_] :> Sym[delta[FermionMassSym], j, F[t, {g}]],
  dSW1 :> Sym[delta[SinSym], "W"],
  dCW1 :> Sym[delta[CosSym], "W"],
  dZH1 :> Sym[delta[ZSym], "H"],
  dZW1 :> Sym[delta[ZSym], "W"],
  dZbarW1 :> Sym[delta[OverBar[ZSym]], "W"],
  dZAA1 :> Sym[delta[ZSym], "\[Gamma]\[Gamma]"],
  dZZA1 :> Sym[delta[ZSym], "Z\[Gamma]"],
  dZAZ1 :> Sym[delta[ZSym], "\[Gamma]Z"],
  dZZZ1 :> Sym[delta[ZSym], "ZZ"],
  dUW1 :> Sym[delta[USym], "W"],
  dUAA1 :> Sym[delta[USym], "\[Gamma]\[Gamma]"],
  dUZA1 :> Sym[delta[USym], "Z\[Gamma]"],
  dUAZ1 :> Sym[delta[USym], "\[Gamma]Z"],
  dUZZ1 :> Sym[delta[USym], "ZZ"],
  dZG01 :> Sym[delta[ZSym], Sym["G", Null, "0"]],
  dZGp1 :> Sym[delta[ZSym], "G"],
  dZfL1[t_, j1_, j2_] :> Sym[delta[ZSym], {j1, j2}, {F[t], "L"}],
  dZbarfL1[t_, j1_, j2_] :> Sym[delta[OverBar[ZSym]], {j1, j2}, {F[t], "L"}],
  dZfR1[t_, j1_, j2_] :> Sym[delta[ZSym], {j1, j2}, {F[t], "R"}],
  dZbarfR1[t_, j1_, j2_] :> Sym[delta[OverBar[ZSym]], {j1, j2}, {F[t], "R"}],
  dCKM1[j1_, j2_] :> Sym[delta["CKM"], {j1, j2}],
  dTH1 :> Sym[delta["T"], "H"],
  Abb[x_] :> Sym[{TeX["\\Abb{"], x, TeX["}"]}],
  TAG[s_String] :> Sym[{TeX["\\TAG{" <> s <> "}"]}]
}

ModelSymRules = {}


WidthRules = {
  OverBar|OverTilde -> Identity,
  -1 -> +1  (* a - b counts same as a + b *)
}

ModelWidthRules = {}

Null

