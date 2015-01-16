(*

This is FeynArts, Version 2.2
Copyright by Sepp Kueblbeck, Hagen Eck, and Thomas Hahn 1995-2000
last modified 30 May 00 by Thomas Hahn

Release notes:

FeynArts is free software, but is not in the public domain.
Instead it is covered by the GNU library general public license.
In plain English this means:

1. We don't promise that this software works.
   (But if you find any bugs, please let us know!)

2. You can use this software for whatever you want.
   You don't have to pay us.

3. You may not pretend that you wrote this software.
   If you use it in a program, you must acknowledge
   somewhere in your publication that you've used
   our code.

If you're a lawyer, you can find the legal stuff at
http://www.fsf.org/copyleft/lgpl.html.

The user guide for this program can be found at
http://www.feynarts.de.

If you find any bugs, or want to make suggestions, or
just write fan mail, address it to:
	Thomas Hahn
	Institut fuer Theoretische Physik
	Universitaet Karlsruhe
	e-mail: hahn@feynarts.de

To join the FeynArts mailing list, send a mail (any text) to
	hahn-feynarts-subscribe@particle.uni-karlsruhe.de

Have fun!

*)


Print[""];
Print["FeynArts 2.2"];
Print["by Hagen Eck, Sepp Kueblbeck, and Thomas Hahn"];
Print["last revision: 30 May 00 by Thomas Hahn"]


BeginPackage["FeynArts`"]

(* definitions for Utilities.m *)

FAPrint::usage =
"FAPrint[l, s] prints the string s if l <= $Verbose."

ActualOptions::usage =
"ActualOptions[sym, options] returns a list of options of sym
with the valid options of sym replaced by their actual values."

ResolveLevel::usage =
"ResolveLevel[lev] returns a full set of levels selected by lev. For
example, ResolveLevel[Particles] gives {Generic, Classes, Particles}."

ContainsQ::usage =
"ContainsQ[expr, items] gives True if expr contains every element in
items."

ToGeneric::usage =
"ToGeneric[expr] returns expr with all classes and particle fields
replaced by their generic fields. Mind that this procedure removes the
signs of the fields."

ToClasses::usage =
"ToClasses[expr] returns expr with all particle fields replaced by their
classes fields."

Seq::usage =
"Seq is almost identical to Sequence except that it is not expanded
automatically."

Vertices::usage =
"Vertices[top] returns a list of all vertices of topology top."

TakeInc::usage =
"TakeInc[v, pr] returns the incoming particle from vertex v in propagator
pr."

PSort::usage =
"PSort[p] sorts the first two elements of a Propagator p."

VSort::usage =
"VSort[v] sorts vertex v into canonical order."

Compare::usage =
"Compare[t] is the `pure' compare function to eliminate equivalent
topologies of a TopologyList t."

WriteStatistics::usage =
"WriteStatistics is an internal function."

Alph::usage =
"Alph[n] gives the nth lowercase letter."

UCAlph::usage =
"UCAlph[n] gives the nth uppercase letter."

Greek::usage =
"Greek[n] gives the nth lowercase greek letter."

UCGreek::usage =
"UCGreek[n] gives the nth uppercase greek letter."


(* definitions for Topology.m *)

Topology::usage =
"Topology is the head of a topology data structure. Topology[s] is the
head of a topology with combinatorial factor 1/s."

TopologyList::usage =
"TopologyList is the head of a list of topologies."

Propagator::usage =
"Propagator[v1, v2] is a (undirected) propagator joining the two vertices
v1 and v2.\n
Propagator[v1, v2, f] is a (directed) propagator transporting field f from
vertex v1 to v2.\n
Propagator[t][...] is the representation of a propagator of type t.
Possible types are: Incoming, Outgoing, External, Internal and Loop[n]."

Incoming::usage =
"Propagator[Incoming][...] denotes an incoming propagator."

Outgoing::usage =
"Propagator[Outgoing][...] denotes an outgoing propagator."

External::usage =
"Propagator[External][...] denotes an external propagator.\n
External is also used in SumOver[index, range, External] to indicate that
the index to be summed belongs to an external particle."

Internal::usage =
"Propagator[Internal][...] denotes an internal propagator.\n
ExcludeTopologies -> Internal excludes topologies that contain
Propagator[Internal], i.e. the one-particle reducible ones."

Loop::usage =
"Propagator[Loop[n]][...] denotes a propagator on loop n."

Vertex::usage =
"Vertex[e][n] is the representation of a vertex with e propagators in a
topology.\n
Vertex[e, cto][n] is the representation of a vertex of counter-term order
cto in a topology."

CreateTopologies::usage =
"CreateTopologies[l, i -> o] returns a TopologyList of topologies with i
incoming and o outgoing legs and l loops (at the moment l = 0...3)."

ExcludeTopologies::usage =
"ExcludeTopologies -> {excl} is an option of CreateTopologies. excl can
contain one or more of: Tadpoles, TadpoleCTs, SelfEnergies,
SelfEnergyCTs, WFCorrections, WFCorrectionCTs, Triangles, TriangleCTs,
Boxes[n], BoxCTs[n], AllBoxes, AllBoxCTs."

$ExcludeTopologies::usage =
"$ExcludeTopologies[filt] is the function corresponding to filt in
ExcludeTopologies -> {filt, ...}. It must be defined as a pure function
(i.e. func[#]&). Given a topology, this function must return True if the
topology shall not be discarded."

Tadpoles::usage =
"Tadpoles is a possible value for ExcludeTopologies. It excludes
topologies containing loops that are connected to the rest of the
graph with one propagator."

TadpoleCTs::usage =
"TadpoleCTs is a possible value for ExcludeTopologies. It excludes
counter-term topologies corresponding to Tadpoles."

SelfEnergies::usage =
"SelfEnergies is a possible value for ExcludeTopologies. It excludes
topologies containing loops that are connected to the rest of the
graph with two propagators."

SelfEnergyCTs::usage =
"SelfEnergyCTs is a possible value for ExcludeTopologies. It excludes
counter-term topologies corresponding to SelfEnergies."

WFCorrections::usage =
"WFCorrections is a possible value for ExcludeTopologies. It excludes
topologies with self-energy insertions and tadpoles on external legs."

WFCorrectionCTs::usage =
"WFCorrectionCTs is a possible value for ExcludeTopologies. It excludes
counter-term topologies corresponding to WFCorrections."

Triangles::usage =
"Triangles is a possible value for ExcludeTopologies. It excludes
topologies containing loops that are connected to the rest of the
graph with three propagators."

TriangleCTs::usage =
"TriangleCTs is a possible value for ExcludeTopologies. It excludes
counter-term topologies corresponding to Triangles."

Boxes::usage =
"Boxes[n] is a possible value for ExcludeTopologies. It excludes
topologies containing loops that are connected to the rest of the
graph with n propagators."

BoxCTs::usage =
"BoxCTs[n] is a possible value for ExcludeTopologies. It excludes
counter-term topologies corresponding to Boxes[n]."

AllBoxes::usage =
"AllBoxes is a possible value for ExcludeTopologies. It excludes
topologies containing loops that are connected to the rest of the
graph with four or more propagators."

AllBoxCTs::usage =
"AllBoxCTs is a possible value for ExcludeTopologies. It excludes
counter-term topologies corresponding to AllBoxes."

ToTree::usage =
"ToTree[top] returns top with the loops shrunk to points named
Centre[adj][n] where adj is the adjacency of loop n."

Centre::usage =
"Centre[adj][n] represents the remains of loop n with adjacency adj after
being shrunk to a point by ToTree."

FreeWFQ::usage =
"FreeWFQ[top, patt1, patt2] determines if the topology top is free of
one-point vertices specified by patt1 and two-point vertices specified by
patt2 on external legs. For example, the WFCorrections filter uses
FreeWFQ[ToTree[top], Centre[1], Centre[2]]&."

StartingTopologies::usage =
"StartingTopologies -> {patt..} is an option of CreateTopologies. It
selects the starting topologies matching patt. These are defined in
Topology.m. E.g. at two-loop level there are three starting topologies:
Theta, Eight, and Bicycle."

StartTop::usage =
"StartTop[l, cto] is the list of starting topologies for topologies with
l loops and counterterm order cto. The starting topologies are defined in
Topology.m."

Theta::usage =
"Theta is a possible value for StartingTopologies. It specifies the
two-loop starting topology that looks like the greek letter theta."

Eight::usage =
"Eight is a possible value for StartingTopologies. It specifies the
two-loop starting topology that looks like the number 8."

Bicycle::usage =
"Bicycle is a possible value for StartingTopologies. It specifies the
two-loop starting topology looks like a bicycle."

Three::usage =
"Three[n] is a possible value for StartingTopologies. It specifies the
irreducible three-loop starting topologies where n = 1...8."

ThreeRed::usage =
"ThreeRed[n] is a possible value for StartingTopologies. It specifies the
reducible three-loop starting topologies where n = 1...7."

Adjacencies::usage =
"Adjacencies is an option of CreateTopologies. Its setting is a list
{e1, e2, ...} of integers (ei > 2) of allowed adjacencies of vertices.
The adjacency of a vertex is the number of propagators ending at that
vertex. The two special cases ei = 1 and 2 are for external particles and
counter terms, respectively, and are taken care of by CreateTopologies."

CountertermOrder::usage =
"CountertermOrder is an option of CreateTopologies that specifies for
which counter-term order diagrams shall be generated."

CreateCTTopologies::usage =
"CreateCTTopologies[l, i -> o] generates all counter-term topologies
needed for the l-loop diagrams generated by CreateTopologies[l, i -> o]."

SymmetryFactor::usage =
"SymmetryFactor[top] returns the symmetry factor for the topology top.
This value is needed if you want to enter new starting topologies."


(* definitions for Insert.m *)

Insertions::usage =
"Insertions is the head of an insertion list. Insertions[lev]
specifies insertions at level lev. Insertion lists are returned by
InsertFields as a rule of the form \"topology -> insertionlist\"."

Graph::usage =
"Graph is the head of a list of field replacement rules. The elements
of an insertion list are Graphs."

Field::usage =
"Field[n] denotes the nth field in a topology."

InsertFields::usage =
"InsertFields[top, {inc1, inc2, ...} -> {out1, out2, ...}] constructs all
Feynman diagrams for the Topology or TopologyList top with incoming fields
inc1, inc2, ... and outgoing fields out1, out2, ..."

Restrictions::usage =
"Restrictions is an option of InsertFields. It contains shorthands to
exclude vertices or particles defined in the corresponding model file."

VertexFunctions::usage =
"VertexFunctions is an option of InsertFields. It is useful on
counter-term topologies only, where it instructs InsertFields to create
diagrams with 1PI vertex functions instead of the actual counter terms."

LastSelections::usage =
"LastSelections is an option of InsertFields. It is given as a list of
symbols which must (or must not, if preceded by Not) appear in the
Insertions."

InsertionLevel::usage =
"InsertionLevel is an option of InsertFields and CreateFeynAmp. Possible
values are Generic, Classes (default), or Particles. Just as with the
usual Mathematica level specification, e.g. {Particles} means \"only
Particles level\" whereas Particles means \"down to Particles level\".
By default, CreateFeynAmp uses the same level as InsertFields."

Generic::usage =
"Generic denotes the generic (general field types) level of insertion."

Classes::usage =
"Classes denotes the classes (multiplets) level of insertion."

Particles::usage =
"Particles denotes the particles (members of classes) level of insertion."

Model::usage =
"Model -> \"MOD\" is an option of InsertFields to select the classes
model MOD. FeynArts reads the model information from the file
Models/MOD.mod."

GenericModel::usage =
"GenericModel -> \"GEN\" is an option of InsertFields and
InitializeModel. FeynArts reads the model information from the file
Models/GEN.gen. Default for generic models is \"Lorentz\"."

ProcessName::usage =
"ProcessName is an option of InsertFields and may be set to specify
a particular process name. By default, the process name is generated
automatically from the external particle specifications."

Process::usage =
"Process is returned by InsertFields as an option of TopologyList. It
specifies the process as a rule \"inparticles -> outparticles\"."

IndexDelta::usage =
"IndexDelta[i1, i2] is a symbol in the definition of a classes coupling
that indicates that the coupling is diagonal in the indices i1 and i2."


(* definitions for Initialize.m *)

InitializeModel::usage =
"InitializeModel[MOD] initializes the classes model for the model MOD.
The model information is read from the file Models/MOD.mod."

Reinitialize::usage =
"Reinitialize is an option of InitializeModel. InitializeModel will
reinitialize the current model only if Reinitialize is set to True."

RestrictCurrentModel::usage =
"RestrictCurrentModel[args] applies a number of ExcludeFieldPoints and
ExcludeParticles restrictions to the current model.\n
RestrictCurrentModel[] removes all currently active restrictions."

ExcludeParticles::usage =
"ExcludeParticles is an option of RestrictCurrentModel. It specifies a
list of fields to exclude from the current model. Excluding a field at a
particular level automatically excludes all derived fields at lower
levels. For example, excluding F[3] also excludes F[3, {1}], F[3, {2}],
F[3, {3}]. Further, the exclusion of a particle always implies exclusion
of its antiparticle."

ExcludeFieldPoints::usage =
"ExcludeFieldPoints is an option of RestrictCurrentModel. It specified a
list of field points to exclude from the current model. Excluding a field
point at a particular level automatically excludes derived field points on
lower levels. For example, excluding FieldPoint[F[3], -F[3], V[1]] also
excludes FieldPoint[F[3, {1}], -F[3, {1}], V[1]] etc. Further, the
exclusion of a field point always implies exclusion of its charge
conjugate field point."

ExcludedQ::usage =
"ExcludedQ[vertlist] gives True if vertlist contains any vertices
currently excluded at Particles level."

PossibleFields::usage =
"PossibleFields[cto][t, fp] returns all possible fields of type t that
fit fp at counter-term order cto. t may be 0 (allowing all fields) or
a generic field."

CheckFieldPoint::usage =
"CheckFieldPoint[fp] yields True if fp is a valid field point in the
current model and False otherwise."

AntiParticle::usage =
"AntiParticle[f] returns the antiparticle of f."

TheMass::usage =
"TheMass[p] gives the value of the mass of particle p (if specified in
the model file)."

Indices::usage =
"Indices[c] gives a list of index names of class c."

IndexRange::usage =
"IndexRange[i] gives a list of possible values of index i."

NoUnfold::usage =
"NoUnfold, when wrapped around the right hand side of an IndexRange
assignment, prevents InsertFields from \"unfolding\" that index at
particles level, i.e. InsertFields then does not generate an extra
diagram for every value the index can take on."

ReferenceOrder::usage =
"ReferenceOrder[x] gives a list of all field points of the current model
in (unsorted) list form. x can be Generic or Classes."

FieldPoint::usage =
"FieldPoint[cto][f1, f2, ...] is the representation of a field point
of counter-term order cto with incoming fields f1, f2, ..."

GenericFieldPoints::usage =
"GenericFieldPoints[] returns a list of all generic field points in the
current model."

FieldPoints::usage =
"FieldPoints[cto] returns a list of field points of counter-term order
cto in the current model. FieldPoints[] returns a list of field points
of all orders in the current model."

CouplingVector::usage =
"CouplingVector[f1, f2, ...] returns the coupling vector of the generic
fields f1, f2, ... in an unevaluated form."

Diagonal::usage =
"Diagonal[v] returns a list of IndexDeltas for a vertex v."

F$Generic::usage =
"F$Generic gives the list of generic fields of the current model.
Its content may change with every call to RestrictCurrentModel."

F$Classes::usage =
"F$Classes gives the list of classes fields of the current model.
Its content may change with every call to RestrictCurrentModel."

F$Particles::usage =
"F$Particles gives the list of particles fields of the current model.
Its content may change with every call to RestrictCurrentModel."

F$AllGeneric::usage =
"F$AllGeneric gives the list of generic fields of the current model."

F$AllClasses::usage =
"F$AllClasses gives the list of classes fields of the current model."

F$AllParticles::usage =
"F$AllParticles gives the list of particles fields of the current model."

F$AllowedFields::usage =
"F$AllowedFields is the list of all fields at all three levels that are
in the current model. This list is affected by calls to
RestrictCurrentModel."

L$CTOrders::usage =
"L$CTOrders is the list of counter-term orders of the current model."

Mom::usage =
"Mom[n] is a momentum variable."

KI::usage =
"KI[n] is a kinematic index variable."

KIarr::usage =
"KIarr is an internal symbol."

PV::usage =
"PV is the head of a general analytical expression in FeynArts. The
letters stand for Propagator/Vertex."

F::usage =
"F is a fermion field."

S::usage =
"S is a scalar field."

SV::usage =
"SV is a scalar-vector mixing field."

VS::usage =
"VS is a vector-scalar mixing field. This field is for internal purposes
only. Do not use it in a model file."

U::usage =
"U is a ghost field (Grassmann-valued scalar field)."

V::usage =
"V is a vector boson field."

$SVMixing::usage =
"$SVMixing determines whether mixing of scalar and vector fields is
allowed or not."

$CounterTerms::usage =
"$CounterTerms determines whether or not counter-term couplings are
initialized during InitializeModel. Note that once a model is initialized,
if you change the value of $CounterTerms you have to re-initialize the
model for this to take effect."

$ModelDir::usage =
"$ModelDir is the name of the models directory."

$Model::usage =
"$Model is the currently initialized classes model."

$GenericModel::usage =
"$GenericModel is the currently initialized generic model."

$ExcludedFPs::usage =
"$ExcludedFPs is the list of currently excluded Generic- and Classes-level
field points."

$ExcludedParticleFPs::usage =
"$ExcludedParticleFPs is the list of currently excluded Particles-level
field points."


(* definitions for the model files *)

M$GenericPropagators::usage =
"M$GenericPropagators is the list of propagators and their analytical
expressions in the generic model file."

M$GenericCouplings::usage =
"M$GenericCouplings is the list of couplings and their analytical
expressions in the generic model file."

M$ClassesDescription::usage =
"M$ClassesDescription is the list of classes properties in the classes
model file."

M$CouplingMatrices::usage =
"M$CouplingMatrices is the list of explicit coupling matrices of the
current model."

M$TruncationRules::usage =
"M$TruncationRules is a set of rules that is applied by CreateFeynAmp if
Truncated -> True. It is defined in the generic model file. Typically, it
removes external wavefunctions."

M$FermionFlipRule::usage =
"M$FermionFlipRule[map] is a function defined in the generic model file
that specifies rules to be applied to a fermionic coupling when fermions
change place. The argument map is a list of position replacement rules
describing how the current vertex is permuted into the model file's
template vertex, e.g. 1 -> 2, 2 -> 1, ... if the first two fields are
reversed in the current coupling with respect to the model-file coupling."

M$LastModelRules::usage =
"M$LastModelRules is a set of rules that is applied by CreateFeynAmp
at the very end. It is defined in the model file and can e.g. contain
mappings of symbols to certain Contexts or to special symbols of other
packages."

M$LastGenericRules::usage =
"M$LastGenericRules is a set of rules that is applied by CreateFeynAmp
after creation of the generic amplitudes. It is defined in the generic
model file and can contain e.g. mappings of symbols to certain Contexts or
to special symbols of other packages."

AnalyticalCoupling::usage =
"AnalyticalCoupling[vertex] == G[_][__] . {__} is the form a vertex is
specified in a generic model file."

AnalyticalPropagator::usage =
"AnalyticalPropagator[type][field] == expr is the form a propagator is
specified in a generic model file."

KinematicIndices::usage =
"KinematicIndices[fi] is a list of the kinematic indices the generic field
fi carries. For example, KinematicIndices[V] = {Lorentz} in Lorentz.gen."

MatrixTraceFactor::usage =
"MatrixTraceFactor -> n is an optional entry for fermions in the
M$ClassesDescription list. A MatrixTrace (a closed loop of fermions) is
multiplied by the MatrixTraceFactor of its consituents. Typical usage
is MatrixTraceFactor -> 3 for quarks."

SelfConjugate::usage =
"SelfConjugate -> True | False is an entry in the M$ClassesDescription
list.\n
SelfConjugate[p] is True if field p is self-conjugate and False
otherwise."

InsertOnly::usage =
"InsertOnly is an entry in the M$ClassesDescription list. It specifies
the types of progators the particle may be inserted into. If not
explicitly specified, the particle may be inserted into all types of
propagators.\n
InsertOnly[p] returns the types of propagators in which field p may be
inserted into."

Mass::usage =
"Mass[p] denotes the mass of particle p. It is just a symbol carrying
no further information. FeynArts defines the function TheMass that
returns the explicit symbol of the mass (if specified by the model file)."

MixingPartners::usage =
"MixingPartners -> {...} is an entry in the M$ClassesDescription list for
mixing fields and specifies their mixing partners.\n
MixingPartners[p] returns the partners of mixing field p."

QuantumNumbers::usage =
"QuantumNumbers -> {...} is an entry in the M$ClassesDescription list. It
lists the quantum numbers a particle possesses. Identifiers for the
quantum numbers can be chosen freely, e.g. Charge. The quantum numbers are
needed only when VertexFunctions -> True is chosen in InsertFields to weed
out 1PI vertex functions that violate the conservation of a quantum
number, as determined by ViolatesQ."

ViolatesQ::usage =
"ViolatesQ is a function defined in the model file that specifies how
quantum numbers are conserved. When InsertFields is used with the option
VertexFunctions -> True, it calls ViolatesQ for every possible 1PI vertex
function. ViolatesQ receives as arguments the quantum numbers of the
involved fields (times -1 for antiparticles) and must return True if the
vertex violates the conservation of those quantum numbers."

Compatibles::usage =
"Compatibles[p] is a list of particles that are compatible with p."

SVCompatibles::usage =
"SVCompatibles[p] is a list of SV particles that are compatible with p."

Index::usage =
"Index is the head of an index name (i.e. Index[Generation])."

PropagatorType::usage =
"PropagatorType is an option used in the M$ClassesDescription list of a
model file and specifies the type of propagator for a particle. Possible
values are Straight, Sine, Cycles, ScalarDash, GhostDash, or any valid
Graphics primitive of Mathematica. For a mixing propagtor, a list with
two propagator types may be specified."

Straight::usage =
"Straight selects a straight line in the PropagtorType option."

Sine::usage =
"Sine selects a wavy line in the PropagatorType option."

Cycles::usage =
"Cycles selects a cycloid in the PropagatorType option."

ScalarDash::usage =
"ScalarDash selects a dashed line in the PropagatorType option."

GhostDash::usage =
"GhostDash selects a dotted line in the PropagatorType option."

PropagatorArrow::usage =
"PropagatorArrow -> Forward, Backward, None is an option used in the
M$ClassesDescription list in the model file."

Forward::usage =
"Forward selects a forward arrow in the PropagatorArrow option."

Backward::usage =
"Backward selects a backward arrow in the PropagatorArrow option."

PropagatorLabel::usage =
"PropagatorLabel is an option used in the M$ClassesDescription list in
the model file. It is translated into TheLabel statements during model
initialization."

TheLabel::usage =
"TheLabel[p] returns the PropagatorLabel of particle p."

Appearance::usage =
"Appearance[i] gives the rendering information for the index i. For
example, Appearance[Index[Lorentz, i_]] := Greek[i + 11] makes Lorentz
indices appear as \"\\mu\", \"\\nu\", etc."

TheC::usage =
"TheC is an internal symbol for storing the coupling matrices."

C::usage =
"C[cto][fields][kinpart] is the symbolic form of a coupling that is
returned when CreateFeynAmp fails to resolve a classes coupling.\n
C[fi] == coupl used as an entry in the M$CouplingMatrices list in the
classes model file defines the coupling of the fields fi."

CC::usage =
"CC[fields] == coupl may be used in the M$CouplingMatrices list in the
classes model file to define the coupling of the fields fi, together with
the conjugate coupling in one line. The conjugation is performed with the
function ConjugateCoupling which must be defined accordingly. If
no definition is made, the final amplitudes will simply contain the symbol
ConjugateCoupling."

KinematicVector::usage =
"KinematicVector[fi] returns the kinematic vector of the coupling of the
fields fi."

ConjugateCoupling::usage =
"ConjugateCoupling[coupl] defines how the charge-conjugated coupling is
derived from coupl. Typically, one I multiplying the coupling constant
must not be conjugated because it derives from the exponent of the path
integral, e.g. I \int d^4x {\cal L}. If no definition is made for
ConjugateCoupling, the final amplitudes will contain this symbol."

G::usage =
"G[sym][cto][fields][kinpart] is a generic coupling matrix of counter-term
order cto for fields corresponding to the kinematical object kinpart. G is
symmetric for sym = 1 and antisymmetric for sym = -1."


(* definitions for Analytic.m *)

CreateFeynAmp::usage =
"CreateFeynAmp[tops] creates a list of Feynman amplitudes (Head:
FeynAmpList) of all insertions of Topology or TopologyList tops."

AmplitudeLevel::usage =
"AmplitudeLevel is an option of CreateFeynAmp and specifies for which
levels amplitudes are to be created."

GaugeRules::usage =
"GaugeRules is an option of CreateFeynAmp. It is given as a list of rules
to select a particular gauge. For example, Feynman gauge is obtained by
GaugeRules -> {GaugeXi[_] -> 1} (the default)."

PreFactor::usage =
"PreFactor is an option of CreateFeynAmp and specifies the prefactor for
each diagram. In the expression for the prefactor the symbol LoopNr can
be used which will subsequently be replaced by the actual loop number."

LoopNr::usage =
"LoopNr is used with the option PreFactor of CreateFeynAmp and is replaced
by the loop number of the topology."

Truncated::usage =
"Truncated is an option of CreateFeynAmp that determines whether to
apply the M$TruncationRules of the current generic model (default:
False)."

MomentumConservation::usage =
"MomentumConservation is an option of CreateFeynAmp. It specifies whether
momentum conservation at each vertex is enforced. If set to False, every
propagator will carry its own momentum."

HoldTimes::usage =
"HoldTimes is an option of CreateFeynAmp which if set to true keeps the
factors arising from the propagators and vertices wrapped in Mult so that
they are not evaluated and can be traced more easily."

VertexFunction::usage =
"VertexFunction[f1, f2, ...] represents the 1PI vertex function joining
the fields f1, f2, ..."

TakeGraph::usage =
"TakeGraph[ins -> graph] returns graph."

TakeIns::usage =
"TakeIns[ins -> graph] returns ins."

PickLevel::usage =
"PickLevel[lev][amp] constructs the concrete amplitudes at level lev from
the CreateFeynAmp result amp. PickLevel[lev][tops] picks out the diagrams
at level lev from TopologyList tops. Note that in topology lists you can
never delete the Generic level."

Discard::usage =
"Discard[expr, d] discards the diagrams d from the topology or amplitude
list expr. d may be of the form {3, 8, 17...28} which selects diagrams 3,
8, and 17 through 28."

DiagramSelect::usage =
"DiagramSelect[diags, crit] selects the diagrams from diags for which crit
is true. For example, for selecting diagrams where field #5 is not a
S[1], one could use DiagramSelect[diags, FreeQ[#, Field[5] -> S[1]]&]."

GraphName::usage =
"GraphName is the head of a data structure identifying a single
FeynAmp in a FeynAmpList."

ToFA1Conventions::usage =
"ToFA1Conventions[expr] converts expr back to FeynArts 1 conventions.
Note that this conversion only renames some symbols. The output may thus
not be 100% FeynArts 1 compatible since certain kinds of expressions (e.g.
Generic insertions) could not be generated with FeynArts 1 at all."

	(* for compatibility: *)
FA2toFA1 = ToFA1Conventions

$FermionLines::usage =
"$FermionLines is a FeynArts system constant that can be True or False
indicating whether CreateFeynAmp should collect fermion fields F in lines
or not. Fermion line construction has to be turned off for generic models
that contain couplings involving more than two fermions (it is for example
impossible to reliably determine how two fermion lines run through a
4-fermion vertex). In such a case the fermions should carry a kinematical
(e.g. Dirac) index. Note that if $FermionLines = False the classes option
MatrixTraceFactor has no effect on fermionic classes and also no
additional minus signs are inserted for odd permutations of external
fermions."

FeynAmp::usage =
"FeynAmp is the head of a data structure that represents the analytical
expression of a single Feynman graph. Its members are: graph name, list of
integration momenta, analytical expression of the amplitude."

FeynAmpList::usage =
"FeynAmpList is the head of a list of FeynAmps."

Integral::usage =
"Integral[q] is a member of a FeynAmp data structure and contains the
integration momenta of the amplitude (empty for tree graphs)."

RelativeCF::usage =
"RelativeCF is the relative combinatorial factor of a graph with respect
to the generic graph it was created from. This symbol appears in generic
amplitudes and its value is defined for every Classes or Particles
insertion."

SumOver::usage =
"SumOver[i, r] indicates that the amplitude it is multiplied with is to
be summed in the index i over the range r. If r is an integer, it
represents the range {1, 2, ..., r}. For an index belonging to an
external particle there is a third argument, External."

PropagatorDenominator::usage =
"PropagatorDenominator[p, m] stands for the expression 1/(p^2 - m^2)
that is contained in internal propagators of a Feynman graph."

FeynAmpDenominator::usage =
"FeynAmpDenominator[d1, d2, ...] contains the PropagatorDenominators
d1, d2, ... that belong to a loop."

GaugeXi::usage =
"GaugeXi[s] is a gauge parameter with index s."

FourMomentum::usage =
"FourMomentum[s, n] is the nth momentum of type s. Allowed types are
Incoming, Outgoing, External and Internal."

Mult::usage =
"Mult is an inert head of a product, i.e. similar to Hold[Times[...]].
With HoldTimes -> True CreateFeynAmp keeps scalar factors from the
Feynman rules wrapped in Mult, thus making it possible to trace these
factors while debugging a model."

NonCommutative::usage =
"NonCommutative is the head of noncommuting objects in a Feynman rule."

MatrixTrace::usage =
"MatrixTrace is the head of a trace of noncommuting objects (i.e. of
symbols with head NonCommutative in the Feynman rules) in closed fermion
loops."

FermionChain::usage =
"FermionChain is the head of a trace of noncommuting objects (i.e. of
symbols with head NonCommutative in the Feynman rules) in open fermion
chains."


(* definitions for Graphics.m *)

Paint::usage =
"Paint[tops] draws a list of inserted or bare topologies."

AutoEdit::usage =
"AutoEdit is an option of Paint. If True (default), the topology editor
is called when an unshaped topology is found."

Destination::usage =
"Destination is an option of Paint. Possible values are Screen
(default), File, or All."

ColumnsXRows::usage =
"ColumnsXRows is an option of Paint. It specifies how many diagrams are
arranged on a page. For example, ColumnsXRows -> 3 draws 3 rows of 3
diagrams each, or ColumnsXRows -> {5, 8} draws 8 rows of 5 diagrams each."

FileBaseName::usage =
"FileBaseName is an option of Paint. It specifies which base name to take
when producing PostScript output. By default, the process name is used for
inserted and \"Topology\" for bare topologies."

Screen::usage =
"Screen is a possible value for the option Destination."

PaintLevel::usage =
"PaintLevel is an option of Paint and specifies for which levels
diagrams are drawn."

SheetHeader::usage =
"SheetHeader is an option of Paint. Automatic or True selects the default
header (the process for inserted or #in -> #out for bare topologies),
False disables headers, everything else is taken literally as a header
(e.g. SheetHeader -> \"Self-energy diagrams\")."

Numbering::usage =
"Numbering is an option of Paint. Setting it to False omits the number of
the diagrams. The numbering is of the form T1 C8 N15 (= topology 1,
classes insertion 8, running number 15), or, if TeXLabels -> True is set,
just #15."

FieldNumbers::usage =
"FieldNumbers is an option of Paint. It it meaningful only for bare
topologies where it specifies whether the field numbers (the n in
Field[n]) are used for labelling the propagators. This can be helpful for
selecting diagrams."

TeXLabels::usage =
"TeXLabels is an option of Paint and specifies whether labels are rendered
in TeX or in PostScript. Although the output of Paint is in both cases a
PostScript file, TeXLabels -> True makes further processing for use in TeX
straightforward."

$TeXPictureSize::usage =
"$TeXPictureSize is a variable that determines the picture size for LaTeX
output. It is given in inches either by a single number, e.g. 5 for
5 x 5 inch figures, or by a list of two numbers, e.g. {8, 10} for 8 x 10
inch figures. The constant Centimeters can be used to specify the size in
centimeters, e.g. $TeXPictureSize = {5, 6} Centimeters."

Centimeters::usage =
"Centimeters gives the number of centimeters per inch. It is normally used
as a conversion factor with $TeXPictureSize."

ComposedChar::usage =
"ComposedChar[t, sub, sup, bar] represents a label t with subscript sub,
superscript sup, and accent bar. Typically, bar is something like
\"\\\\bar\", \"\\\\tilde\", etc. The arguments sub, sup, and bar are
optional but their position is significant. For example,
ComposedChar[t, , sup] is a label with a superscript only."

Shape::usage =
"Shape[tops] edits the shapes of the topologies tops."

TopEdit::usage =
"TopEdit[arg1, arg2] is the actual topology editor. It is called
internally by Shape."

SaveGraphInfos::usage =
"SaveGraphInfos[] saves the graph infos currently in $ModifiedGraphInfos."

$LoadedGraphInfos::usage =
"$LoadedGraphInfos returns a list of currently loaded graph infos."

$ModifiedGraphInfos::usage =
"$ModifiedGraphInfos returns a list of modified graph infos which will be
saved at the end of the Mathematica session."


(* FeynArts system constants *)

$FeynArts::usage =
"$FeynArts returns the version of FeynArts."

$Verbose::usage =
"$Verbose is an integer that determines the extent of run-time
messages in FeynArts. It ranges from 0 (no messages) to 2 (normal)."

$FeynArtsDir::usage =
"$FeynArtsDir points to the directory where FeynArts lives."

$Platform::usage =
"$Platform is a string that identifies the platform FeynArts is running
on. It is the value of the environment variable HOSTTYPE in the Bourne
shell (sh) and is used to distinguish the binaries of TopEdit and mpslatex
for different platforms."

$TopologyDataDir::usage =
"$TopologyDataDir is a symbol that denotes the directory containing
information about topology coordinates."

P$Topology::usage =
"P$Topology is the pattern for a topology."

P$Generic::usage =
"P$Generic is the pattern for generic fields."


P$Topology = Topology[__] | Topology[_][__]

P$Generic = F | S | V | U | SV


$FeynArts = 2.2

$FeynArtsDir =
  If[ FileType[$Input] === File, $Input,
	(* if FeynArts was loaded from a directory in $Path: *)
    Block[ {full},
      Scan[
        If[ FileType[full = # <> "/" <> $Input] === File, Return[full] ]&,
        $Path ] ]
  ]

Block[ {pos = StringPosition[$FeynArtsDir, "/"]},
  If[ Length[pos] === 0, $FeynArtsDir = "",
    $FeynArtsDir =
      SetDirectory[StringTake[ $FeynArtsDir, pos[[-1, -1]] ]] <> "/";
    ResetDirectory[] ]
]


$Platform = Environment["HOSTTYPE"]

If[ Head[$Platform] =!= String, $Platform = "" ]


Get[ $FeynArtsDir <> "FeynArts/Utilities.m" ]

Get[ $FeynArtsDir <> "FeynArts/Topology.m" ]

Get[ $FeynArtsDir <> "FeynArts/Initialize.m" ]

Get[ $FeynArtsDir <> "FeynArts/Insert.m" ]

Get[ $FeynArtsDir <> "FeynArts/Analytic.m" ]

Get[ $FeynArtsDir <> "FeynArts/Graphics.m" ]

EndPackage[]


Get[ $FeynArtsDir <> "SetUp.m" ]

Null

