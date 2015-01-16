(*
	SMQCD.mod
		Addendum classes model file for SMc.mod
		to include the strong interactions.
		last modified 3 May 00 by Christian Schappacher

ATTENTION: The quark-quark-gluon counter term is in ON-SHELL 
~~~~~~~~~~ renormalization!

Note: this file uses colour indices for the quarks, as does SMc.mod.

This file introduces the following symbols in addition to the ones in
SMc.mod:

	GS, the strong coupling constant

	SUNT[a, i, j], the generators of SU(N)
		(half the Gell-Mann matrices)

	SUNF[a, b, c], the structure constants of SU(N)

	SUNF[a, b, c, d], a short-hand for the sum
		\sum_i SUNF[a, b, i] SUNF[i, c, d]
*)


Get[$ModelDir <> "SMc.mod"]

IndexRange[ Index[Gluon] ] = NoUnfold[Range[8]]


M$ClassesDescription = Join[ M$ClassesDescription, {

  V[5] == {
	SelfConjugate -> True,
	Indices -> {Index[Gluon]},
	Mass -> 0,
	PropagatorLabel -> "g",
	PropagatorType -> Cycles,
	PropagatorArrow -> None },

  U[5] == {
	SelfConjugate -> False,
	Indices -> {Index[Gluon]},
	Mass -> 0,
	QuantumNumbers -> GhostNumber,
	PropagatorLabel -> ComposedChar["u", "g"],
	PropagatorType -> GhostDash,
	PropagatorArrow -> Forward }
} ]


M$CouplingMatrices = Join[ M$CouplingMatrices, {


(*--- gluon-gluon-gluon-gluon ------------------------------------------*)

  C[ V[5, {g1}], V[5, {g2}], V[5, {g3}], V[5, {g4}] ] == -I GS^2 *
    { { SUNF[g1, g3, g2, g4] - SUNF[g1, g4, g3, g2]},
      { SUNF[g1, g2, g3, g4] + SUNF[g1, g4, g3, g2]},
      {-SUNF[g1, g2, g3, g4] - SUNF[g1, g3, g2, g4]} },


(*--- gluon-gluon-gluon ------------------------------------------------*)

  C[ V[5, {g1}], V[5, {g2}], V[5, {g3}] ] == GS *
    { {SUNF[g1, g2, g3]} },


(*--- ghost-ghost-gluon ------------------------------------------------*)

  C[ -U[5, {g1}], U[5, {g2}], V[5, {g3}] ] == GS *
    { {SUNF[g1, g2, g3]}, {0} },


(*--- quark-quark-gluon ------------------------------------------------*)

  C[ -F[3, {j1, o1}], F[3, {j2, o2}], V[5, {g1}] ] == -I GS *
    IndexDelta[j1, j2] SUNT[g1, o1, o2] *
    { {1, dZfL1cc[3, j1, j2]}, 
      {1, dZfR1cc[3, j1, j2]} },

  C[ -F[4, {j1, o1}], F[4, {j2, o2}], V[5, {g1}] ] == -I GS *
    IndexDelta[j1, j2] SUNT[g1, o1, o2] *
    { {1, dZfL1cc[4, j1, j2]}, 
      {1, dZfR1cc[4, j1, j2]} }

} ]

(***********************************************************************)
