(*
	General.m
		general definitions
		last change: 1 Dec 97 by TH
*)

BeginPackage["FeynArts`"]

(* symbols without special tasks *)

Gaugetypes = { FeynmanGauge, UnitaryGauge }

Fieldpoints = { e, v3, v4 }

Momenta = { p, q, k }

ExternProptypes = { ex, inc, out }

InternProptypes =
  { in, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12 }

Indices = { fi, li, gi }

Results = { FeynAmpList, FeynAmp, SpinorChain, DiracTrace,
  GellMannTrace, GraphName, MomentumIntegration, Insertions,
  Graph, Process }

FeynArtsSymbols = { Greek, Sub, dummy, SU3F, GellMannMatrix,
  SU3Delta, FeynAmpDenominator, PropagatorDenominator,
  MetricTensor, DiracSlash, DiracMatrix, ChiralityProjector,
  QMM, FourVector, LeptonSpinor, QuarkSpinor, NonCommutative,
  $D, PV, Mu, GaugeXi, A, Z, W, Incoming, Outgoing }

TopologyList::usage =
"TopologyList is the head of a list of topologies."

Topology::usage =
"Topology[s][...] is the head of one topology with combinatorial
factor s."

Propagator::usage =
"Propagator[type][from, to] is the representation of one single
propagator. `type' is one of:\n
  `ex',`inc',`out' for external lines\n
  `in' for internal lines\n
  `li' for internal lines on loop i"

Vertex::usage =
"Vertex[fi[1], fi[2], ...] is the representation of a fieldpoint with
incoming fields fi[i]."

AntiParticle::usage =
"AntiParticle[mod][field] gives the antiparticle of a field in model
`mod'."

VertexList::usage =
"VertexList[mod] gives a list of all couplings in model `mod'.
VertexList[i_Integer][mod] gives only i-Vertices."

ParticleList::usage =
"ParticleList[mod] gives a list of all particles in model `mod'."

PossibleParticles::usage =
"PossibleParticles[mod][vertex] returns a list of particles that
can be inserted into the valences of vertex according to model `mod'."

AnalyticalCoupling::usage =
"AnalyticalCoupling[mod][vertex] gives the analytical expression
for a given vertex in model `mod'."

AnalyticalPropagator::usage =
"AnalyticalPropagator[mod][from, to, field, momentum] gives the
analytical expression for a propagator in model `mod'."
							   
Mass::usage =
"Mass[mod][field] yields the mass of the field."

PropList::usage =
"PropList[MOD] is the list of propagators of model MOD. It is
defined in the file ./Models/model.MOD."

CoupList::usage =
"CoupList[MOD] is the list of couplings of model MOD. It is defined
in the file ./Models/model.MOD."

InitializedModels::usage =
"InitializedModels is an internal variable of FeynArts that lists the
initialized models (for InsertFields and CreateFeynAmp)."

QuarkMixingMatrix::usage =
"QuarkMixingMatrix is a 3x3 Matrix with elements QMM_ij (i,j = 1...3)."

$ModelFiles::usage =
"$ModelFiles is the list of files whose names match `*model.*` when
FeynArts is loaded."

(* Options *)

Model::usage =
"Model is an option of InsertFields."

ProcessName::usage =
"ProcessName is an option of InsertFields which allows to choose a
cryptic process name that can be used as a file name."

UnitaryGauge::usage =
"UnitaryGauge is an option of FeynInit which turns the unitary gauge on
(useful only for tree topologies because of renormalizability)."

Generation1::usage =
"Generation1 is an option of FeynInit which switches the first fermion
generation on and off (electron, neutrino, up, down)."

Generation2::usage =
"Generation2 is an option of FeynInit which switches the second fermion
generation on and off (muon, muon neutrino, charm, strange)."

Generation3::usage =
"Generation3 is an option of FeynInit which switches the third fermion
generation on and off (tau, tau neutrino, top, bottom)."

QuarkMixing::usage =
"QuarkMixing is an option of FeynInit which, if set to True uses a
3x3 matrix QMM instead of the IdentityMatrix for quark flavour mixing."

LightFHCoupling::usage =
"LightFHCoupling is an option of FeynInit which switches the coupling
of light fermions (= all except the top quark) to the Higgs particles
on and off."

ElectronHCoupling::usage =
"ElectronHCoupling is an option of FeynInit that deletes the coupling
of the electron to the Higgs particle."

RemoveEmptyTops::usage =
"RemoveEmptyTops is an Option for InsertFields that allows to omit
Topologies which do not contain any realisations after the insertion
routine."

ScreenMessages::usage =
"ScreenMessages is an Option InsertFields, Paint and CreateFeynAmp
to supress run time messages."

CheckModel::usage =
"CheckModel checks for not initialized models. If all models in option
Model of FeynInit are compatible and if the model files of the not
initialized ones exist FeynInit is called to initialize them."

FeynInit::usage =
"FeynInit[Model -> MOD, modeloptions] reads the file ./Model/model.MOD
and creates the functions PossibleParticles, AntiParticle, ParticleList,
VertexList, AnalyticalCoupling and AnalyticalPropagator."

ModelNameSymbol::usage =
"ModelNameSymbol[Model -> MOD, modeloptions] returns a list of
expressions that describes the specified model."

SymbolToModel::usage =
"SymbolToModel extracts the model from the descriptional expression."

PolarizationVector::usage =
"PolarizationVector is the Head for the Green function of a vector
particle. Its two indices are momentum and Lorentzindex. A negative
argument denotes the complex conjugate."

ActualOptions::usage =
"ActualOptions[symbol, newopts] returns a list of the current options of 
symbol, including those set in newopts."

(* information for the Paint-(DrawLine)-Package *)

LineSpec::usage =
"LineSpec[particle] specifies the appearance of a propagator."

LineTypes = { straight, wavy, cycloid, dashed, dotted }

LineDirections = { forward, backward, none }

Begin["`Private`"]

(* extract model from descriptional expression *)

SymbolToModel[ modelname_ ]:=
Block[ {mstr},
  mstr = ToString[modelname];
  ToExpression[
    StringTake[ mstr,
      Min[ StringPosition[mstr,"1"][[1,1]], 
           StringPosition[mstr,"0"][[1,1]] ]
      -1 ] ]
]

ModelNameSymbol[ opta___Rule, Model -> mo_, optb___Rule ] :=
Block[ {symbollist},
  Off[General::spell1];
  symbollist = (ToExpression[
    StringJoin@@
      ToString/@ Join[{#},
        Select[ {opta,optb}, (#[[1]]=!=ScreenMessages &&
          #[[1]]=!=ProcessName && #[[1]]=!=Process &&
          #[[1]]=!=RemoveEmptyTops)& ] /.
        {Rule[_,True] -> 1, Rule[_,False] -> 0} ] ])&/@ mo;
  On[General::spell1];
  symbollist
]

CheckModel::singlemodels =
"Model `1` cannot be combined with the other models."

CheckModel[ options_List ] :=
Block[ {inter, newmodels, modelname},
  inter = Intersection[ Model /. options, SingleModels ];
  If[ inter =!= {} && Length[Model /. options] =!= 1,
    Message[CheckModel::singlemodels, First[inter]];
    Return[$Aborted] ];
  $Output = {If[ ScreenMessages /. options,
    "stdout", FeynArtsNullDevice ]};
  modelname = ModelNameSymbol@@ options;
  newmodels = Select[modelname, !MemberQ[InitializedModels,#]&];
  If[ MemberQ[(
    Print[" ... initializing model \"",#,"\""];
    (FeynInit@@ Append[options,#]))&/@ newmodels,
    $Aborted],
    Return[$Aborted] ];
	(* FeynInit sets $Output to stdout *)
  If[ !(ScreenMessages /. options), $Output = {FeynArtsNullDevice} ];
  modelname
]

VertexList[ i___Integer, mod_List ] :=
  VL@@ (Union@@ Join[ VertexList[i,#]&/@ mod ])

AntiParticle[ mod_List ][ f_[a_,b___] ] := 
  Join[ 
    Select[ AntiParticle[#][f[a]]&/@ mod,
      FreeQ[#,AntiParticle]& ]//First,
    f[b]  
  ] /; f=!=fi

AnalyticalCoupling[ mod_List ][ c__List ]:=
  Select[ AnalyticalCoupling[#][c]&/@ mod,
    FreeQ[#,AnalyticalCoupling]& ]//First

FirstExtended[ {} ] = {}

FirstExtended[ x_ ] := First[x]

AnalyticalPropagator[mod_List][ type_ ][ c___ ]:=
  Select[ AnalyticalPropagator[#][type][c]&/@ mod,
    FreeQ[#,AnalyticalPropagator]& ]//FirstExtended

FeynInit::initialized =
"The model `1` is already initialized!"

FeynInit[ options___Rule ] :=
  FeynInit[ options, ModelNameSymbol@@ localoptions ]

Options[FeynInit] := Options[InsertFields`InsertFields]

FeynInit[ options___Rule, modelname_ ] :=
Block[ {localoptions, model, mess},
  localoptions = ActualOptions[FeynInit, options];
  model = SymbolToModel[modelname];
  If[ MemberQ[InitializedModels, modelname],
    Message[FeynInit::initialized, modelname];
    Return[] ];
  $Output = {If[ScreenMessages /. localoptions,
    "stdout", FeynArtsNullDevice]};
  mess = Init[model, modelname, localoptions];
  $Output = {"stdout"};
  If[ mess === $Aborted, mess,
    AppendTo[InitializedModels, modelname] ]
] 

Init::filenotfound =
"Could not find file \"model.`1`\" (no initialization). Allowed models
are `2`."

Init[ mod_, name_, opt_ ]:=
Block[ {modelfile},
  Unprotect[QMM];
  QMM = If[ QuarkMixing /. opt, QuarkMixingMatrix, IdentityMatrix[3] ];
  Protect[QMM];
  modelfile = Select[ $ModelFiles, 
    StringMatchQ[#, "*."<>ToString[mod]]& ];
  If[ modelfile === {},
    Message[Init::filenotfound, mod, Models];
    Return[$Aborted],
  (* else *)
    Off[Syntax::newl];
    Scan[Get, modelfile];
    On[Syntax::newl]
  ];
  PropList[name] = PropList[mod];
  CoupList[name] = Select[CoupList[mod], (#[[2]] =!= PV[0])&];
  If[ UnitaryGauge /. opt ,
    PropList[name] = DelForUnitGauge[PropList[name]] /. 
      {(1-1/GaugeXi[A])*PropagatorDenominator[_, 0] -> 0,
       (1-1/GaugeXi[_])*
         PropagatorDenominator[_,m_/Sqrt[GaugeXi[_]] ] -> 1/m^2 } ;
    CoupList[name] = DelForUnitGauge[CoupList[name]];
    Print[" ... Unitary Gauge: tree graphs only!"]
  ];
  If[ !(LightFHCoupling /. opt),
    CoupList[name] = DeleteLFHC[CoupList[name]];
    Print[" ... LightFermionHiggsCouplings deleted"]
  ];
  If[ !(ElectronHCoupling /. opt),
    CoupList[name] = DeleteEHC[CoupList[name]];
    Print[" ... ElectronHiggsCouplings deleted"]
  ];
  If[ !(Generation1 /. opt),
    PropList[name] = DeleteG1[PropList[name]];
    CoupList[name] = DeleteG1[CoupList[name]];
    Print[" ... Generation1 deleted"]
  ];
  If[ !(Generation2 /. opt),
    PropList[name] = DeleteG2[PropList[name]];
    CoupList[name] = DeleteG2[CoupList[name]];
    Print[" ... Generation2 deleted"]
  ];
  If[ !(Generation3 /. opt),
    PropList[name] = DeleteG3[PropList[name]];
    CoupList[name] = DeleteG3[CoupList[name]];
    Print[" ... Generation3 deleted"]
  ];
  CreateAntiParticles[name];
  CreateVertexList[name];
  CreateParticleList[name];
  CreateMasses[name];
  CreatePossibleParticles[name];
  Unprotect[PV];
  CreateAnalyticalCoupling[name];
  CreateAnalyticalPropagator[name];
  Protect[PV];
]

(* deleting parts of the model *)

MemberList[ x_, l_List ] := Select[ x, !FreeQ[#, Alternatives@@ l]& ]

FreeList[ x_, l_List ] := Select[ x, FreeQ[#, Alternatives@@ l]& ]

DeleteLFHC[ x_ ] :=
Block[ {del, hold},
  hold = FreeList[ x, {S[1],S[2],S[3],S[-1],S[-2],S[-3]} ];
  del = MemberList[ x, {S[1],S[2],S[3],S[-1],S[-2],S[-3]} ];
  del = Union[
    FreeList[ del, {F[1],F[2],F[3],F[4],F[5],F[6],
      F[7],F[8],F[9],F[10],F[12],
      F[-1],F[-2],F[-3],F[-4],F[-5],F[-6],F[-7],
      F[-8],F[-9],F[-10],F[-12]} ],
    MemberList[ del, {F[11],F[-11]}]];
  Union[hold, del] /.
    ChiralityProjector[_]*(Global`MB|Global`MS|Global`MD) :> 0
]

DeleteElecPosi[ x_ ] := FreeList[ x, {F[-1],F[1]} ]

DeleteEHC[ x_ ] :=
Block[ {del, hold},
  hold = FreeList[ x, {S[1],S[2],S[3],S[-1],S[-2],S[-3]} ];
  del = DeleteElecPosi[
    MemberList[ x, {S[1],S[2],S[3],S[-1],S[-2],S[-3]} ] ];
  Union[hold,del]
]

LeaveQEDonly[ x_ ] := 
  FreeList[ x,
    {F[-12],F[-11],F[-10],F[-8],F[-7],F[-6],F[-4],F[-3],F[-2],
     F[2],F[3],F[4],F[6],F[7],F[8],F[10].F[11],F[12],
     S[-3],S[1],S[2],S[3],
     V[-3,_],V[2,_],V[3,_], 
     U[-4],U[-3],U[-2],U[-1],U[1],U[2],U[3],U[4]} ] 

DelForUnitGauge[ x_ ] := 
  FreeList[ x ,
    {U[-4],U[-3],U[-2],U[-1],U[1],U[2],U[3],U[4],
     S[-3],S[2],S[3]} ]

DeleteG1[ x_ ] :=
  FreeList[ x, {F[-4],F[-3],F[-2],F[-1],F[1],F[2],F[3],F[4]} ]

DeleteG2[ x_ ] := 
  FreeList[ x, {F[-8],F[-7],F[-6],F[-6],F[5],F[6],F[7],F[8]} ]

DeleteG3[ x_ ] := 
  FreeList[ x, {F[-12],F[-11],F[-10],F[-9],F[9],F[10],F[11],F[12]} ]

(* creating AntiParticle-function *)

MakeAP[mod_][ Global`Prop[_][ fa_, fb_, ___ ] ] := Null 

MakeAP[mod_][ Global`Prop[in][ fa_, fb_, ___ ] ] := 
  { AntiParticle[mod][Take[fa,1]] = Take[fb,1],
    AntiParticle[mod][Take[fb,1]] = Take[fa,1] }

CreateAntiParticles[ mod_ ] :=
  MakeAP[mod][ #[[1]] ]&/@ PropList[mod]

(* creating VertexList *)

MakeVertexList[ Global`Coup[{fi1_,mom1_}, {fi2_,mom2_}, {fi3_,mom3_}] ] :=
  Vertex[ Take[fi1,1],Take[fi2,1],Take[fi3,1] ]

MakeVertexList[ Global`Coup[{fi1_,mom1_}, {fi2_,mom2_},
  {fi3_,mom3_}, {fi4_,mom4_}] ] :=
  Vertex[ Take[fi1,1], Take[fi2,1], Take[fi3,1], Take[fi4,1] ]

CreateVertexList[ mod_ ] := (
  VertexList[i_Integer][mod] :=
    VertexList[i,mod] = Select[ VertexList[mod], Length[#]===i& ];
  VertexList[mod] = 
    FeynArts`VL@@ (MakeVertexList[ #[[1]] ]&/@ CoupList[mod])
)

(* creating ParticleList *)

ExtractParticle[ Global`Prop[_][ fa_,fb_, ___ ] ] := {}

ExtractParticle[ Global`Prop[in][ fa_,fb_, ___ ] ] := 
  {Take[fa,1], Take[fb,1]}

CreateParticleList[ mod_ ] := 
  ParticleList[mod] =
    FeynArts`PL@@ 
      Union[Flatten[ ExtractParticle[ #[[1]] ]&/@ PropList[mod] ]]

(* auxiliary functions for CreatePossibleParticles *)

c31[ part_,mod_ ] :=
  Ok[mod][ Vertex[part,zzz[1],zzz[1]] ] = True

c41[ part_,mod_ ] :=
  Ok[mod][ Vertex[part,zzz[1],zzz[1],zzz[1]] ] = True

c32[ v_[part1_,part2_],mod_ ] :=
  Ok[mod][ Vertex[part1,part2,zzz[1]] ] = True

c42[ v_[part1_,part2_],mod_ ] := 
  Ok[mod][ Vertex[part1,part2,zzz[1],zzz[1]] ] = True

c33[ v_[part1_,part2_,part3_],mod_ ] := 
  Ok[mod][ Vertex[part1,part2,part3] ] = True

c43[ v_[part1_,part2_,part3_],mod_ ] := 
  Ok[mod][ Vertex[part1,part2,part3,zzz[1]] ] = True

c44[ v_[part1_,part2_,part3_,part4_],mod_ ] := 
  Ok[mod][ Vertex[part1,part2,part3,part4] ] = True

pselect[mod_][vv_] :=
  Select[ ParticleList[mod], Ok[mod][Append[vv,#]]& ]

o31[ part_,mod_ ] := 
  OkP[mod][ Vertex[ part, zzz[1], zzz[1] ]  ] =
    pselect[mod][Vertex[part,zzz[1]]]

o41[ part_,mod_ ] := 
  OkP[mod][ Vertex[part,zzz[1],zzz[1],zzz[1]] ] =
    pselect[mod][Vertex[part,zzz[1],zzz[1]]]

o32[ v_[part1_,part2_],mod_ ] := 
  OkP[mod][ Vertex[part1,part2,zzz[1]] ] =
    pselect[mod][Vertex[part1,part2]]

o42[ v_[part1_,part2_],mod_ ] := 
  OkP[mod][ Vertex[part1,part2,zzz[1],zzz[1]] ] =
    pselect[mod][Vertex[part1,part2,zzz[1]]]

o43[ v_[part1_,part2_,part3_],mod_ ] := 
  OkP[mod][ Vertex[part1,part2,part3,zzz[1]] ] =
    pselect[mod][Vertex[part1,part2,part3]]

h32[vx_]:=FeynArts`VL[ Take[vx,2],Take[vx,-2],Drop[vx,{2}] ]

h42[vx_]:=FeynArts`VL[ Take[vx,2],Take[vx,-2],Take[vx,{2,3}],
  {vx[[1]],vx[[4]]},{vx[[1]],vx[[3]]},{vx[[2]],vx[[4]]} ]

h43[vx_]:=
  FeynArts`VL[ Drop[vx,{1}],Drop[vx,{2}],Drop[vx,{3}],Drop[vx,{4}] ]

(* creating PossibleParticles *)

CreatePossibleParticles[mod_] :=
Block[ {modvert3, modvert4, part31, part41, part32, part42, part43},
  FeynArts`Ok[FeynArts`Vertex[__],mod] := False;
  modvert3 = VertexList[3][mod];
  modvert4 = VertexList[4][mod];
  c33[#,mod]&/@ modvert3;
  c44[#,mod]&/@ modvert4;
  part31 = Union[ Flatten[ Vertex@@ modvert3 ] ];
  part41 = Union[ Flatten[ Vertex@@ modvert4 ] ];
  c31[#,mod]&/@ part31;
  c41[#,mod]&/@ part41;
  part32 = Union[ Flatten[ h32/@ modvert3 ] ];
  part42 = Union[ Flatten[ h42/@ modvert4 ] ];
  part43 = Union[ Flatten[ h43/@ modvert4 ] ];
  c32[#,mod]&/@ part32;
  c42[#,mod]&/@ part42;
  c43[#,mod]&/@ part43;
  OkP[mod][_] := FeynArts`PL[];
  OkP[mod][ Vertex[zzz[1],zzz[1],zzz[1]] ] =
    FeynArts`PL@@ (Union@@ VertexList[3][mod]);
  OkP[mod][ Vertex[zzz[1],zzz[1],zzz[1],zzz[1]] ] =
    FeynArts`PL@@ (Union@@ VertexList[4][mod]);
  WriteString[ "stdout", " |.    |"  ];
  o31[#,mod]&/@ part31;
  WriteString[ "stdout", "\r |..   |"  ];
  o41[#,mod]&/@ part41;
  WriteString[ "stdout", "\r |...  |"  ];
  o32[#,mod]&/@ part32;
  WriteString[ "stdout", "\r |.... |"  ];
  o42[#,mod]&/@ part42;
  WriteString[ "stdout", "\r |.....|"  ];
  o43[#,mod]&/@ part43;
  Print["\r ... (done)"];
]

PossibleParticles[ mod_ ][ vx_ ] :=
  OkP[mod][ (Vertex@@ vx) /. {v_[fi[i_]] -> zzz[1], fi[i_] -> zzz[1]} ];

(* create AnalyticalCoupling functions *)

CreateAnalyticalCoupling[ mod_ ] := 
  CoupList[mod] /.
    Global`Coup[ sth__ ] :> Global`Coup@@ Sort[{sth}] /.
    Global`Coup -> AnalyticalCoupling[mod] /.
    Equal -> SetDelayed

(* create AnalyticalPropagator functions *)

CreateAnalyticalPropagator[ mod_ ] :=
  PropList[mod] /. Global`Prop->AnalyticalPropagator[mod] /.
    Equal -> SetDelayed

CreateMasses[ mod_ ] :=
Block[ {pl},
  pl = Select[ PropList[mod], !FreeQ[#,in]& ] /.
    PV[___ * PropagatorDenominator[mom_,mas_]] :> mas;
  Join[
    pl /. Global`Prop[in][f1_[a_,___],f2_[_,___],___] -> Mass[f1[a]],
    pl /. Global`Prop[in][f1_[_,___],f2_[a_,___],___] -> Mass[f2[a]]  
  ] /. Equal -> SetDelayed;
]

$ModelFiles = FileNames["model.*", $Path, 2]

If[!ValueQ[InitializedModels], InitializedModels = {}]

SetAttributes[Vertex, Orderless]

SetAttributes[TopologyList, Flat]

(* default for the QuarkMixingMatrix *)

Attributes[ QMM ] = {}

QMM = { { FeynArts`QMM11,FeynArts`QMM12,FeynArts`QMM13 },
	{ FeynArts`QMM21,FeynArts`QMM22,FeynArts`QMM23 },
	{ FeynArts`QMM31,FeynArts`QMM32,FeynArts`QMM33 } }

QuarkMixingMatrix = QMM

(* default for the line specifications *)

LineSpec[x_[y_]] := 
  {straight, none, StringJoin[ToString[x],ToString[Abs[y]]]}

(* protect FeynArts`-symbols *)

Protect/@ Flatten[{ Models, Gaugetypes, Fieldtypes,
  Fieldpoints, Momenta, ExternProptypes, InternProptypes,
  Indices, Results, FeynArtsSymbols }]

ActualOptions[ sym_, opts___ ] :=
Block[ {p},
  If[ (p = Position[{opts}, First[#] -> _]) === {}, #,
    ({opts}[[##]]&)@@ Last[p] ]&/@ Options[sym]
]

End[]

EndPackage[]

