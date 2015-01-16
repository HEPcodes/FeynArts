(*
	SMew.mod
		The Standard Model without colour indices
		last modified 15 Jan 07 by Thomas Hahn
*)


ReadModelFile["SM.mod"]

M$ClassesDescription = M$ClassesDescription /.
  (Indices -> {g_, Index[Colour]}) ->
  Sequence[Indices -> {g}, MatrixTraceFactor -> 3]

M$CouplingMatrices = M$CouplingMatrices /.
  o2 -> o1 /. o1 -> Sequence[]

