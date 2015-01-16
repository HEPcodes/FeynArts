(*
	SMbgf.mod
		Classes model file for the Standard Model in
		the background field formalism
		last modified 27 Mar 00 by Thomas Hahn

Reference:
	A. Denner, S. Dittmaier, and G. Weiglein
	Nucl. Phys. B440 (1995) 95

This file introduces the following symbols in addition to the ones in
SM.mod:

	GaugeXi[Q, bg]:		gauge parameters

V[10, 20, 30] and S[10, 20, 30] are the background fields respectively of
V[1, 2, 3] and S[1, 2, 3].

*)


IndexRange[ Index[Generation] ] = {1, 2, 3}

Appearance[ Index[Generation, i_Integer] ] := Alph[i + 8]

MaxGenerationIndex = 3


ViolatesQ[ q__ ] := Plus[q] =!= 0


(* the leptonic field RCs are diagonal: *)

dZfL1[ type:1 | 2, j1_, j2_ ] :=
  IndexDelta[j1, j2] dZfL1[type, j1, j1] /; j1 =!= j2

dZfR1[ type:1 | 2, j1_, j2_ ] :=
  IndexDelta[j1, j2] dZfR1[type, j1, j1] /; j1 =!= j2



M$ClassesDescription =
{F[1] == {SelfConjugate -> False, Indices -> {Index[Generation]}, Mass -> 0, 
    QuantumNumbers -> LeptonNumber, 
    PropagatorLabel -> ComposedChar["\\nu", Index[Generation]], 
    PropagatorType -> Straight, PropagatorArrow -> Forward}, 
  F[2] == {SelfConjugate -> False, Indices -> {Index[Generation]}, 
    Mass -> MLE, QuantumNumbers -> {-Charge, LeptonNumber}, 
    PropagatorLabel -> ComposedChar["e", Index[Generation]], 
    PropagatorType -> Straight, PropagatorArrow -> Forward}, 
  F[3] == {SelfConjugate -> False, Indices -> {Index[Generation]}, 
    Mass -> MQU, QuantumNumbers -> (2*Charge)/3, MatrixTraceFactor -> 3, 
    PropagatorLabel -> ComposedChar["u", Index[Generation]], 
    PropagatorType -> Straight, PropagatorArrow -> Forward}, 
  F[4] == {SelfConjugate -> False, Indices -> {Index[Generation]}, 
    Mass -> MQD, QuantumNumbers -> -Charge/3, MatrixTraceFactor -> 3, 
    PropagatorLabel -> ComposedChar["d", Index[Generation]], 
    PropagatorType -> Straight, PropagatorArrow -> Forward}, 
  V[1] == {SelfConjugate -> True, Indices -> {}, Mass -> 0, 
    PropagatorLabel -> "\\gamma", PropagatorType -> Sine, 
    PropagatorArrow -> None, InsertOnly -> Loop}, 
  V[10] == {SelfConjugate -> True, Indices -> {}, Mass -> 0, 
    PropagatorLabel -> ComposedChar["\\gamma", Null, Null, "\\hat"], 
    PropagatorType -> Sine, PropagatorArrow -> None, 
    InsertOnly -> {Internal, External}}, 
  V[2] == {SelfConjugate -> True, Indices -> {}, Mass -> MZ, 
    PropagatorLabel -> "Z", PropagatorType -> Sine, PropagatorArrow -> None, 
    InsertOnly -> Loop}, V[20] == 
   {SelfConjugate -> True, Indices -> {}, Mass -> MZ, 
    PropagatorLabel -> ComposedChar["Z", Null, Null, "\\hat"], 
    PropagatorType -> Sine, PropagatorArrow -> None, 
    InsertOnly -> {Internal, External}}, 
  V[3] == {SelfConjugate -> False, Indices -> {}, Mass -> MW, 
    QuantumNumbers -> -Charge, PropagatorLabel -> "W", 
    PropagatorType -> Sine, PropagatorArrow -> Forward, InsertOnly -> Loop}, 
  V[30] == {SelfConjugate -> False, Indices -> {}, Mass -> MW, 
    QuantumNumbers -> -Charge, 
    PropagatorLabel -> ComposedChar["W", Null, Null, "\\hat"], 
    PropagatorType -> Sine, PropagatorArrow -> Forward, 
    InsertOnly -> {Internal, External}}, 
  SV[2] == {SelfConjugate -> True, Indices -> {}, Mass -> MZ, 
    MixingPartners -> {S[2], V[2]}, PropagatorLabel -> {"\\chi", "Z"}, 
    PropagatorType -> {ScalarDash, Sine}, PropagatorArrow -> None, 
    InsertOnly -> Loop}, SV[20] == 
   {SelfConjugate -> True, Indices -> {}, Mass -> MZ, 
    MixingPartners -> {S[2], V[2]}, 
    PropagatorLabel -> 
     {ComposedChar["\\chi", Null, Null, "\\hat"], 
      ComposedChar["Z", Null, Null, "\\hat"]}, 
    PropagatorType -> {ScalarDash, Sine}, PropagatorArrow -> None, 
    InsertOnly -> {Internal, External}}, 
  SV[3] == {SelfConjugate -> False, Indices -> {}, Mass -> MW, 
    QuantumNumbers -> -Charge, MixingPartners -> {S[3], V[3]}, 
    PropagatorLabel -> {"\\phi", "W"}, PropagatorType -> {ScalarDash, Sine}, 
    PropagatorArrow -> Forward, InsertOnly -> Loop}, 
  SV[30] == {SelfConjugate -> False, Indices -> {}, Mass -> MW, 
    QuantumNumbers -> -Charge, MixingPartners -> {S[3], V[3]}, 
    PropagatorLabel -> 
     {ComposedChar["\\phi", Null, Null, "\\hat"], 
      ComposedChar["W", Null, Null, "\\hat"]}, 
    PropagatorType -> {ScalarDash, Sine}, PropagatorArrow -> Forward, 
    InsertOnly -> {Internal, External}}, 
  S[1] == {SelfConjugate -> True, Indices -> {}, Mass -> MH, 
    PropagatorLabel -> "H", PropagatorType -> ScalarDash, 
    PropagatorArrow -> None, InsertOnly -> Loop}, 
  S[10] == {SelfConjugate -> True, Indices -> {}, Mass -> MH, 
    PropagatorLabel -> ComposedChar["H", Null, Null, "\\hat"], 
    PropagatorType -> ScalarDash, PropagatorArrow -> None, 
    InsertOnly -> {Internal, External}}, 
  S[2] == {SelfConjugate -> True, Indices -> {}, Mass -> MZ, 
    PropagatorLabel -> "\\chi", PropagatorType -> ScalarDash, 
    PropagatorArrow -> None, InsertOnly -> Loop}, 
  S[20] == {SelfConjugate -> True, Indices -> {}, Mass -> MZ, 
    PropagatorLabel -> ComposedChar["\\chi", Null, Null, "\\hat"], 
    PropagatorType -> ScalarDash, PropagatorArrow -> None, 
    InsertOnly -> {Internal, External}}, 
  S[3] == {SelfConjugate -> False, Indices -> {}, Mass -> MW, 
    QuantumNumbers -> -Charge, PropagatorLabel -> "\\phi", 
    PropagatorType -> ScalarDash, PropagatorArrow -> Forward, 
    InsertOnly -> Loop}, S[30] == 
   {SelfConjugate -> False, Indices -> {}, Mass -> MW, 
    QuantumNumbers -> -Charge, 
    PropagatorLabel -> ComposedChar["\\phi", Null, Null, "\\hat"], 
    PropagatorType -> ScalarDash, PropagatorArrow -> Forward, 
    InsertOnly -> {Internal, External}}, 
  U[1] == {SelfConjugate -> False, Indices -> {}, Mass -> 0, 
    QuantumNumbers -> GhostNumber, 
    PropagatorLabel -> ComposedChar["u", "\\gamma"], 
    PropagatorType -> GhostDash, PropagatorArrow -> Forward}, 
  U[2] == {SelfConjugate -> False, Indices -> {}, Mass -> MZ, 
    QuantumNumbers -> GhostNumber, 
    PropagatorLabel -> ComposedChar["u", "Z"], PropagatorType -> GhostDash, 
    PropagatorArrow -> Forward}, 
  U[3] == {SelfConjugate -> False, Indices -> {}, Mass -> MW, 
    QuantumNumbers -> {-Charge, GhostNumber}, 
    PropagatorLabel -> ComposedChar["u", "-"], PropagatorType -> GhostDash, 
    PropagatorArrow -> Forward}, 
  U[4] == {SelfConjugate -> False, Indices -> {}, Mass -> MW, 
    QuantumNumbers -> {Charge, GhostNumber}, 
    PropagatorLabel -> ComposedChar["u", "+"], PropagatorType -> GhostDash, 
    PropagatorArrow -> Forward}}

M$CouplingMatrices =
{C[-V[3], -V[3], V[3], V[3]] == 
   {{(2*I*EL^2)/SW^2}, {(-I*EL^2)/SW^2}, {(-I*EL^2)/SW^2}}, 
  C[-V[3], V[3], V[2], V[2]] == 
   {{(-2*I*CW^2*EL^2)/SW^2}, {(I*CW^2*EL^2)/SW^2}, {(I*CW^2*EL^2)/SW^2}}, 
  C[-V[3], V[3], V[1], V[2]] == 
   {{(2*I*CW*EL^2)/SW}, {(-I*CW*EL^2)/SW}, {(-I*CW*EL^2)/SW}}, 
  C[-V[3], V[3], V[1], V[1]] == {{-2*I*EL^2}, {I*EL^2}, {I*EL^2}}, 
  C[V[1], -V[3], V[3]] == {{-I*EL}, {0}, {0}, {0}}, 
  C[V[2], -V[3], V[3]] == {{(I*CW*EL)/SW}, {0}, {0}, {0}}, 
  C[S[1], S[1], S[1], S[1]] == {{((-3*I)/4*EL^2*MH^2)/(MW^2*SW^2)}}, 
  C[S[1], S[1], S[2], S[2]] == {{(-I/4*EL^2*MH^2)/(MW^2*SW^2)}}, 
  C[S[1], S[1], S[3], -S[3]] == {{(-I/4*EL^2*MH^2)/(MW^2*SW^2)}}, 
  C[S[2], S[2], S[2], S[2]] == {{((-3*I)/4*EL^2*MH^2)/(MW^2*SW^2)}}, 
  C[S[2], S[2], S[3], -S[3]] == {{(-I/4*EL^2*MH^2)/(MW^2*SW^2)}}, 
  C[S[3], S[3], -S[3], -S[3]] == {{(-I/2*EL^2*MH^2)/(MW^2*SW^2)}}, 
  C[S[1], S[1], S[1]] == {{((-3*I)/2*EL*MH^2)/(MW*SW)}}, 
  C[S[1], S[2], S[2]] == {{(-I/2*EL*MH^2)/(MW*SW)}}, 
  C[S[3], S[1], -S[3]] == {{(-I/2*EL*MH^2)/(MW*SW)}}, 
  C[S[1], S[1], V[3], -V[3]] == {{(I/2*EL^2)/SW^2}}, 
  C[S[2], S[2], V[3], -V[3]] == {{(I/2*EL^2)/SW^2}}, 
  C[S[3], -S[3], V[3], -V[3]] == {{(I/2*EL^2)/SW^2}}, 
  C[S[3], -S[3], V[2], V[2]] == {{(I/2*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[3], -S[3], V[1], V[2]] == {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW)}}, 
  C[S[3], -S[3], V[1], V[1]] == {{2*I*EL^2}}, 
  C[S[1], S[1], V[2], V[2]] == {{(I/2*EL^2)/(CW^2*SW^2)}}, 
  C[S[2], S[2], V[2], V[2]] == {{(I/2*EL^2)/(CW^2*SW^2)}}, 
  C[S[1], -S[3], V[3], V[2]] == {{(-I/2*EL^2)/CW}}, 
  C[S[1], S[3], -V[3], V[2]] == {{(-I/2*EL^2)/CW}}, 
  C[S[1], S[3], -V[3], V[1]] == {{(-I/2*EL^2)/SW}}, 
  C[S[1], -S[3], V[3], V[1]] == {{(-I/2*EL^2)/SW}}, 
  C[S[3], S[2], V[2], -V[3]] == {{EL^2/(2*CW)}}, 
  C[-S[3], S[2], V[2], V[3]] == {{-EL^2/(2*CW)}}, 
  C[S[3], S[2], V[1], -V[3]] == {{EL^2/(2*SW)}}, 
  C[-S[3], S[2], V[1], V[3]] == {{-EL^2/(2*SW)}}, 
  C[S[2], S[1], V[2]] == {{EL/(2*CW*SW)}, {-EL/(2*CW*SW)}}, 
  C[-S[3], S[3], V[1]] == {{-I*EL}, {I*EL}}, 
  C[-S[3], S[3], V[2]] == {{(-I/2*EL*(-CW^2 + SW^2))/(CW*SW)}, 
    {(I/2*EL*(-CW^2 + SW^2))/(CW*SW)}}, 
  C[S[3], S[1], -V[3]] == {{(-I/2*EL)/SW}, {(I/2*EL)/SW}}, 
  C[-S[3], S[1], V[3]] == {{(I/2*EL)/SW}, {(-I/2*EL)/SW}}, 
  C[S[3], S[2], -V[3]] == {{EL/(2*SW)}, {-EL/(2*SW)}}, 
  C[-S[3], S[2], V[3]] == {{EL/(2*SW)}, {-EL/(2*SW)}}, 
  C[S[1], -V[3], V[3]] == {{(I*EL*MW)/SW}}, 
  C[S[1], V[2], V[2]] == {{(I*EL*MW)/(CW^2*SW)}}, 
  C[-S[3], V[3], V[2]] == {{(-I*EL*MW*SW)/CW}}, 
  C[S[3], -V[3], V[2]] == {{(-I*EL*MW*SW)/CW}}, 
  C[-S[3], V[3], V[1]] == {{-I*EL*MW}}, C[S[3], -V[3], V[1]] == {{-I*EL*MW}}, 
  C[-F[2, {j1}], F[2, {j2}], V[1]] == 
   {{I*EL*IndexDelta[j1, j2]}, {I*EL*IndexDelta[j1, j2]}}, 
  C[-F[3, {j1}], F[3, {j2}], V[1]] == 
   {{(-2*I)/3*EL*IndexDelta[j1, j2]}, {(-2*I)/3*EL*IndexDelta[j1, j2]}}, 
  C[-F[4, {j1}], F[4, {j2}], V[1]] == 
   {{I/3*EL*IndexDelta[j1, j2]}, {I/3*EL*IndexDelta[j1, j2]}}, 
  C[-F[1, {j1}], F[1, {j2}], V[2]] == 
   {{(I/2*EL*IndexDelta[j1, j2])/(CW*SW)}, {0}}, 
  C[-F[2, {j1}], F[2, {j2}], V[2]] == 
   {{(I*EL*(-1/2 + SW^2)*IndexDelta[j1, j2])/(CW*SW)}, 
    {(I*EL*SW*IndexDelta[j1, j2])/CW}}, 
  C[-F[3, {j1}], F[3, {j2}], V[2]] == 
   {{(I*EL*(1/2 - (2*SW^2)/3)*IndexDelta[j1, j2])/(CW*SW)}, 
    {((-2*I)/3*EL*SW*IndexDelta[j1, j2])/CW}}, 
  C[-F[4, {j1}], F[4, {j2}], V[2]] == 
   {{(I*EL*(-1/2 + SW^2/3)*IndexDelta[j1, j2])/(CW*SW)}, 
    {(I/3*EL*SW*IndexDelta[j1, j2])/CW}}, 
  C[-F[1, {j1}], F[2, {j2}], -V[3]] == 
   {{(I*EL*IndexDelta[j1, j2])/(Sqrt[2]*SW)}, {0}}, 
  C[-F[2, {j1}], F[1, {j2}], V[3]] == 
   {{(I*EL*IndexDelta[j1, j2])/(Sqrt[2]*SW)}, {0}}, 
  C[-F[3, {j1}], F[4, {j2}], -V[3]] == 
   {{(I*EL*CKM[j1, j2])/(Sqrt[2]*SW)}, {0}}, 
  C[-F[4, {j2}], F[3, {j1}], V[3]] == 
   {{(I*EL*Conjugate[CKM[j1, j2]])/(Sqrt[2]*SW)}, {0}}, 
  C[-F[2, {j1}], F[2, {j2}], S[1]] == 
   {{(-I/2*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(MW*SW)}, 
    {(-I/2*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(MW*SW)}}, 
  C[-F[3, {j1}], F[3, {j2}], S[1]] == 
   {{(-I/2*EL*IndexDelta[j1, j2]*Mass[F[3, {j1}]])/(MW*SW)}, 
    {(-I/2*EL*IndexDelta[j1, j2]*Mass[F[3, {j1}]])/(MW*SW)}}, 
  C[-F[4, {j1}], F[4, {j2}], S[1]] == 
   {{(-I/2*EL*IndexDelta[j1, j2]*Mass[F[4, {j1}]])/(MW*SW)}, 
    {(-I/2*EL*IndexDelta[j1, j2]*Mass[F[4, {j1}]])/(MW*SW)}}, 
  C[-F[2, {j1}], F[2, {j2}], S[2]] == 
   {{-(EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(2*MW*SW)}, 
    {(EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(2*MW*SW)}}, 
  C[-F[3, {j1}], F[3, {j2}], S[2]] == 
   {{(EL*IndexDelta[j1, j2]*Mass[F[3, {j1}]])/(2*MW*SW)}, 
    {-(EL*IndexDelta[j1, j2]*Mass[F[3, {j1}]])/(2*MW*SW)}}, 
  C[-F[4, {j1}], F[4, {j2}], S[2]] == 
   {{-(EL*IndexDelta[j1, j2]*Mass[F[4, {j1}]])/(2*MW*SW)}, 
    {(EL*IndexDelta[j1, j2]*Mass[F[4, {j1}]])/(2*MW*SW)}}, 
  C[-F[3, {j1}], F[4, {j2}], -S[3]] == 
   {{(I*EL*CKM[j1, j2]*Mass[F[3, {j1}]])/(Sqrt[2]*MW*SW)}, 
    {(-I*EL*CKM[j1, j2]*Mass[F[4, {j2}]])/(Sqrt[2]*MW*SW)}}, 
  C[-F[4, {j2}], F[3, {j1}], S[3]] == 
   {{(-I*EL*Conjugate[CKM[j1, j2]]*Mass[F[4, {j2}]])/(Sqrt[2]*MW*SW)}, 
    {(I*EL*Conjugate[CKM[j1, j2]]*Mass[F[3, {j1}]])/(Sqrt[2]*MW*SW)}}, 
  C[-F[1, {j1}], F[2, {j2}], -S[3]] == 
   {{0}, {(-I*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(Sqrt[2]*MW*SW)}}, 
  C[-F[2, {j1}], F[1, {j2}], S[3]] == 
   {{(-I*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(Sqrt[2]*MW*SW)}, {0}}, 
  C[-U[3], U[3], V[1]] == {{(-I*EL)/Sqrt[GaugeXi[W]]}, {0}}, 
  C[-U[4], U[4], V[1]] == {{(I*EL)/Sqrt[GaugeXi[W]]}, {0}}, 
  C[-U[3], U[3], V[2]] == {{(I*CW*EL)/(SW*Sqrt[GaugeXi[W]])}, {0}}, 
  C[-U[4], U[4], V[2]] == {{(-I*CW*EL)/(SW*Sqrt[GaugeXi[W]])}, {0}}, 
  C[-U[3], U[2], V[3]] == {{(-I*CW*EL)/(SW*Sqrt[GaugeXi[W]])}, {0}}, 
  C[-U[2], U[3], -V[3]] == {{(-I*CW*EL)/(SW*Sqrt[GaugeXi[Z]])}, {0}}, 
  C[-U[4], U[2], -V[3]] == {{(I*CW*EL)/(SW*Sqrt[GaugeXi[W]])}, {0}}, 
  C[-U[2], U[4], V[3]] == {{(I*CW*EL)/(SW*Sqrt[GaugeXi[Z]])}, {0}}, 
  C[-U[3], U[1], V[3]] == {{(I*EL)/Sqrt[GaugeXi[W]]}, {0}}, 
  C[-U[1], U[3], -V[3]] == {{(I*EL)/Sqrt[GaugeXi[A]]}, {0}}, 
  C[-U[4], U[1], -V[3]] == {{(-I*EL)/Sqrt[GaugeXi[W]]}, {0}}, 
  C[-U[1], U[4], V[3]] == {{(-I*EL)/Sqrt[GaugeXi[A]]}, {0}}, 
  C[S[1], -U[2], U[2]] == {{(-I/2*EL*MW*GaugeXi[Z])/(CW^2*SW)}}, 
  C[S[1], -U[3], U[3]] == {{(-I/2*EL*MW*GaugeXi[W])/SW}}, 
  C[S[1], -U[4], U[4]] == {{(-I/2*EL*MW*GaugeXi[W])/SW}}, 
  C[S[2], -U[4], U[4]] == {{(EL*MW*GaugeXi[W])/(2*SW)}}, 
  C[S[2], -U[3], U[3]] == {{-(EL*MW*GaugeXi[W])/(2*SW)}}, 
  C[-S[3], -U[2], U[3]] == {{(I/2*EL*MW*GaugeXi[Z])/(CW*SW)}}, 
  C[S[3], -U[2], U[4]] == {{(I/2*EL*MW*GaugeXi[Z])/(CW*SW)}}, 
  C[-S[3], -U[4], U[2]] == {{(I/2*EL*MW*(-CW^2 + SW^2)*GaugeXi[W])/(CW*SW)}}, 
  C[S[3], -U[3], U[2]] == {{(I/2*EL*MW*(-CW^2 + SW^2)*GaugeXi[W])/(CW*SW)}}, 
  C[-S[3], -U[4], U[1]] == {{I*EL*MW*GaugeXi[W]}}, 
  C[S[3], -U[3], U[1]] == {{I*EL*MW*GaugeXi[W]}}, 
  C[-F[1, {j1}], F[1, {j2}]] == 
   {{0, -I/2*(Conjugate[dZfL1[1, j1, j1]*IndexDelta[j1, j2]] + 
        dZfL1[1, j1, j1]*IndexDelta[j1, j2])}, 
    {0, I/2*(Conjugate[dZfR1[1, j1, j1]*IndexDelta[j1, j2]] + 
        dZfR1[1, j1, j1]*IndexDelta[j1, j2])}, {0, 0}, {0, 0}}, 
  C[-F[2, {j1}], F[2, {j2}]] == 
   {{0, -I/2*(Conjugate[dZfL1[2, j1, j1]*IndexDelta[j1, j2]] + 
        dZfL1[2, j1, j1]*IndexDelta[j1, j2])}, 
    {0, I/2*(Conjugate[dZfR1[2, j1, j1]*IndexDelta[j1, j2]] + 
        dZfR1[2, j1, j1]*IndexDelta[j1, j2])}, 
    {0, -I/2*(2*dMf1[2, j1]*IndexDelta[j1, j2] + 
        dZfL1[2, j1, j1]*IndexDelta[j1, j2]*Mass[F[2, {j1}]] + 
        Conjugate[dZfR1[2, j1, j1]*IndexDelta[j1, j2]]*Mass[F[2, {j2}]])}, 
    {0, -I/2*(2*dMf1[2, j1]*IndexDelta[j1, j2] + 
        dZfR1[2, j1, j1]*IndexDelta[j1, j2]*Mass[F[2, {j1}]] + 
        Conjugate[dZfL1[2, j1, j1]*IndexDelta[j1, j2]]*Mass[F[2, {j2}]])}}, 
  C[-F[3, {j1}], F[3, {j2}]] == 
   {{0, -I/2*(Conjugate[dZfL1[3, j2, j1]] + dZfL1[3, j1, j2])}, 
    {0, I/2*(Conjugate[dZfR1[3, j2, j1]] + dZfR1[3, j1, j2])}, 
    {0, -I/2*(2*dMf1[3, j1]*IndexDelta[j1, j2] + 
        dZfL1[3, j1, j2]*Mass[F[3, {j1}]] + 
        Conjugate[dZfR1[3, j2, j1]]*Mass[F[3, {j2}]])}, 
    {0, -I/2*(2*dMf1[3, j1]*IndexDelta[j1, j2] + 
        dZfR1[3, j1, j2]*Mass[F[3, {j1}]] + 
        Conjugate[dZfL1[3, j2, j1]]*Mass[F[3, {j2}]])}}, 
  C[-F[4, {j1}], F[4, {j2}]] == 
   {{0, -I/2*(Conjugate[dZfL1[4, j2, j1]] + dZfL1[4, j1, j2])}, 
    {0, I/2*(Conjugate[dZfR1[4, j2, j1]] + dZfR1[4, j1, j2])}, 
    {0, -I/2*(2*dMf1[4, j1]*IndexDelta[j1, j2] + 
        dZfL1[4, j1, j2]*Mass[F[4, {j1}]] + 
        Conjugate[dZfR1[4, j2, j1]]*Mass[F[4, {j2}]])}, 
    {0, -I/2*(2*dMf1[4, j1]*IndexDelta[j1, j2] + 
        dZfR1[4, j1, j2]*Mass[F[4, {j1}]] + 
        Conjugate[dZfL1[4, j2, j1]]*Mass[F[4, {j2}]])}}, 
  C[-V[30], -V[30], V[30], V[30]] == 
   {{(2*I*EL^2)/SW^2, (2*I*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(-I*EL^2)/SW^2, (I*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW^2)}, 
    {(-I*EL^2)/SW^2, (I*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[30], -V[30], V[30], V[3]] == 
   {{(2*I*EL^2)/SW^2, (2*I*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(-I*EL^2)/SW^2, (I*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW^2)}, 
    {(-I*EL^2)/SW^2, (I*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[30], -V[3], V[30], V[30]] == 
   {{(2*I*EL^2)/SW^2, (2*I*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(-I*EL^2)/SW^2, (I*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW^2)}, 
    {(-I*EL^2)/SW^2, (I*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[30], -V[3], V[3], V[3]] == 
   {{(2*I*EL^2)/SW^2, (2*I*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(-I*EL^2)/SW^2, (I*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW^2)}, 
    {(-I*EL^2)/SW^2, (I*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[3], -V[3], V[30], V[3]] == 
   {{(2*I*EL^2)/SW^2, (2*I*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(-I*EL^2)/SW^2, (I*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW^2)}, 
    {(-I*EL^2)/SW^2, (I*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[30], V[30], V[20], V[20]] == 
   {{(-2*I*CW^2*EL^2)/SW^2, (2*I*CW^2*EL^2*(dMWsq1 - dZH1*MW^2))/
      (MW^2*SW^2)}, {(I*CW^2*EL^2)/SW^2, 
     (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(I*CW^2*EL^2)/SW^2, (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[30], V[30], V[20], V[2]] == 
   {{(-2*I*CW^2*EL^2)/SW^2, (2*I*CW^2*EL^2*(dMWsq1 - dZH1*MW^2))/
      (MW^2*SW^2)}, {(I*CW^2*EL^2)/SW^2, 
     (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(I*CW^2*EL^2)/SW^2, (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[30], V[3], V[20], V[20]] == 
   {{(-2*I*CW^2*EL^2)/SW^2, (2*I*CW^2*EL^2*(dMWsq1 - dZH1*MW^2))/
      (MW^2*SW^2)}, {(I*CW^2*EL^2)/SW^2, 
     (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(I*CW^2*EL^2)/SW^2, (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[3], V[30], V[20], V[20]] == 
   {{(-2*I*CW^2*EL^2)/SW^2, (2*I*CW^2*EL^2*(dMWsq1 - dZH1*MW^2))/
      (MW^2*SW^2)}, {(I*CW^2*EL^2)/SW^2, 
     (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(I*CW^2*EL^2)/SW^2, (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[30], V[3], V[2], V[2]] == 
   {{(-2*I*CW^2*EL^2)/SW^2, (2*I*CW^2*EL^2*(dMWsq1 - dZH1*MW^2))/
      (MW^2*SW^2)}, {(I*CW^2*EL^2)/SW^2, 
     (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(I*CW^2*EL^2)/SW^2, (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[3], V[30], V[2], V[2]] == 
   {{(-2*I*CW^2*EL^2)/SW^2, (2*I*CW^2*EL^2*(dMWsq1 - dZH1*MW^2))/
      (MW^2*SW^2)}, {(I*CW^2*EL^2)/SW^2, 
     (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(I*CW^2*EL^2)/SW^2, (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[3], V[3], V[20], V[2]] == 
   {{(-2*I*CW^2*EL^2)/SW^2, (2*I*CW^2*EL^2*(dMWsq1 - dZH1*MW^2))/
      (MW^2*SW^2)}, {(I*CW^2*EL^2)/SW^2, 
     (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}, 
    {(I*CW^2*EL^2)/SW^2, (I*CW^2*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW^2)}}, 
  C[-V[30], V[30], V[10], V[20]] == 
   {{(2*I*CW*EL^2)/SW, (2*I*CW*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}}, 
  C[-V[30], V[30], V[10], V[2]] == 
   {{(2*I*CW*EL^2)/SW, (2*I*CW*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}}, 
  C[-V[30], V[30], V[1], V[20]] == 
   {{(2*I*CW*EL^2)/SW, (2*I*CW*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}}, 
  C[-V[30], V[3], V[10], V[20]] == 
   {{(2*I*CW*EL^2)/SW, (2*I*CW*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}}, 
  C[-V[3], V[30], V[10], V[20]] == 
   {{(2*I*CW*EL^2)/SW, (2*I*CW*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}}, 
  C[-V[30], V[3], V[1], V[2]] == 
   {{(2*I*CW*EL^2)/SW, (2*I*CW*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}}, 
  C[-V[3], V[30], V[1], V[2]] == 
   {{(2*I*CW*EL^2)/SW, (2*I*CW*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}}, 
  C[-V[3], V[3], V[10], V[2]] == 
   {{(2*I*CW*EL^2)/SW, (2*I*CW*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}}, 
  C[-V[3], V[3], V[1], V[20]] == 
   {{(2*I*CW*EL^2)/SW, (2*I*CW*EL^2*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}, 
    {(-I*CW*EL^2)/SW, (I*CW*EL^2*(dMWsq1 - dZH1*MW^2))/(MW^2*SW)}}, 
  C[-V[30], V[30], V[10], V[10]] == 
   {{-2*I*EL^2, -2*I*EL^2*(dZH1 - dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}}, 
  C[-V[30], V[30], V[10], V[1]] == 
   {{-2*I*EL^2, -2*I*EL^2*(dZH1 - dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}}, 
  C[-V[30], V[3], V[10], V[10]] == 
   {{-2*I*EL^2, -2*I*EL^2*(dZH1 - dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}}, 
  C[-V[3], V[30], V[10], V[10]] == 
   {{-2*I*EL^2, -2*I*EL^2*(dZH1 - dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}}, 
  C[-V[30], V[3], V[1], V[1]] == 
   {{-2*I*EL^2, -2*I*EL^2*(dZH1 - dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}}, 
  C[-V[3], V[30], V[1], V[1]] == 
   {{-2*I*EL^2, -2*I*EL^2*(dZH1 - dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}}, 
  C[-V[3], V[3], V[10], V[1]] == 
   {{-2*I*EL^2, -2*I*EL^2*(dZH1 - dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}, 
    {I*EL^2, -I*EL^2*(-dZH1 + dMWsq1/MW^2)}}, 
  C[V[10], -V[30], V[30]] == {{-I*EL, -I*EL*(dZH1 - dMWsq1/MW^2)}, {0, 0}, 
    {0, 0}, {0, 0}}, C[V[10], -V[30], V[3]] == 
   {{-I*EL, -I*EL*(dZH1 - dMWsq1/MW^2)}, {0, 0}, {0, 0}, {0, 0}}, 
  C[V[10], -V[3], V[30]] == {{-I*EL, -I*EL*(dZH1 - dMWsq1/MW^2)}, {0, 0}, 
    {0, 0}, {0, 0}}, C[V[1], -V[30], V[30]] == 
   {{-I*EL, -I*EL*(dZH1 - dMWsq1/MW^2)}, {0, 0}, {0, 0}, {0, 0}}, 
  C[V[20], -V[30], V[30]] == {{(I*CW*EL)/SW, 
     (I*CW*EL*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, {0, 0}, {0, 0}, {0, 0}}, 
  C[V[20], -V[30], V[3]] == {{(I*CW*EL)/SW, 
     (I*CW*EL*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, {0, 0}, {0, 0}, {0, 0}}, 
  C[V[20], -V[3], V[30]] == {{(I*CW*EL)/SW, 
     (I*CW*EL*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, {0, 0}, {0, 0}, {0, 0}}, 
  C[V[2], -V[30], V[30]] == {{(I*CW*EL)/SW, 
     (I*CW*EL*(-dMWsq1 + dZH1*MW^2))/(MW^2*SW)}, {0, 0}, {0, 0}, {0, 0}}, 
  C[S[10], S[10], S[10], S[10]] == 
   {{((-3*I)/4*EL^2*MH^2)/(MW^2*SW^2), 
     ((-3*I)/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[10], S[10], S[1]] == 
   {{((-3*I)/4*EL^2*MH^2)/(MW^2*SW^2), 
     ((-3*I)/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[1], S[1], S[1]] == 
   {{((-3*I)/4*EL^2*MH^2)/(MW^2*SW^2), 
     ((-3*I)/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[10], S[20], S[20]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[10], S[20], S[2]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[1], S[20], S[20]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[1], S[2], S[2]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[1], S[1], S[20], S[2]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[10], S[30], -S[30]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[10], S[30], -S[3]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[10], S[3], -S[30]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[1], S[30], -S[30]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[1], S[3], -S[3]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[1], S[1], S[30], -S[3]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[1], S[1], S[3], -S[30]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[20], S[20], S[20], S[20]] == 
   {{((-3*I)/4*EL^2*MH^2)/(MW^2*SW^2), 
     ((-3*I)/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[20], S[20], S[20], S[2]] == 
   {{((-3*I)/4*EL^2*MH^2)/(MW^2*SW^2), 
     ((-3*I)/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[20], S[2], S[2], S[2]] == 
   {{((-3*I)/4*EL^2*MH^2)/(MW^2*SW^2), 
     ((-3*I)/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[20], S[20], S[30], -S[30]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[20], S[20], S[30], -S[3]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[20], S[20], S[3], -S[30]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[20], S[2], S[30], -S[30]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[20], S[2], S[3], -S[3]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[2], S[2], S[30], -S[3]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[2], S[2], S[3], -S[30]] == 
   {{(-I/4*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/8*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[30], S[30], -S[30], -S[30]] == 
   {{(-I/2*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/4*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[30], S[30], -S[30], -S[3]] == 
   {{(-I/2*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/4*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[30], S[3], -S[30], -S[30]] == 
   {{(-I/2*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/4*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[30], S[3], -S[3], -S[3]] == 
   {{(-I/2*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/4*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[3], S[3], -S[30], -S[3]] == 
   {{(-I/2*EL^2*MH^2)/(MW^2*SW^2), 
     (-I/4*EL^2*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^3*SW^3)}}, 
  C[S[10], S[10], S[10]] == {{((-3*I)/2*EL*MH^2)/(MW*SW), 
     ((-3*I)/4*EL*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^2*SW^2)}}, 
  C[S[10], S[10], S[1]] == {{((-3*I)/2*EL*MH^2)/(MW*SW), 
     ((-3*I)/4*EL*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^2*SW^2)}}, 
  C[S[10], S[20], S[20]] == {{(-I/2*EL*MH^2)/(MW*SW), 
     (-I/4*EL*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^2*SW^2)}}, 
  C[S[10], S[20], S[2]] == {{(-I/2*EL*MH^2)/(MW*SW), 
     (-I/4*EL*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^2*SW^2)}}, 
  C[S[1], S[20], S[20]] == {{(-I/2*EL*MH^2)/(MW*SW), 
     (-I/4*EL*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^2*SW^2)}}, 
  C[S[30], S[10], -S[30]] == {{(-I/2*EL*MH^2)/(MW*SW), 
     (-I/4*EL*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^2*SW^2)}}, 
  C[S[30], S[10], -S[3]] == {{(-I/2*EL*MH^2)/(MW*SW), 
     (-I/4*EL*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^2*SW^2)}}, 
  C[S[30], S[1], -S[30]] == {{(-I/2*EL*MH^2)/(MW*SW), 
     (-I/4*EL*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^2*SW^2)}}, 
  C[S[3], S[10], -S[30]] == {{(-I/2*EL*MH^2)/(MW*SW), 
     (-I/4*EL*(dTad1*EL + 2*(dMHsq1 + dZH1*MH^2)*MW*SW))/(MW^2*SW^2)}}, 
  C[S[10], S[10], V[30], -V[30]] == 
   {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[10], S[10], V[30], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[10], S[10], V[3], -V[30]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[10], S[1], V[30], -V[30]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[10], S[1], V[3], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[1], S[1], V[30], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[1], S[1], V[3], -V[30]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[1], S[1], V[30], -V[30]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[10], S[10], V[3], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[20], S[20], V[30], -V[30]] == 
   {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[20], S[20], V[30], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[20], S[20], V[3], -V[30]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[20], S[2], V[30], -V[30]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[20], S[2], V[3], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[2], S[2], V[30], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[2], S[2], V[3], -V[30]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[2], S[2], V[30], -V[30]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[20], S[20], V[3], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[30], -S[30], V[30], -V[30]] == 
   {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[30], -S[30], V[30], -V[3]] == 
   {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[30], -S[30], V[3], -V[30]] == 
   {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[30], -S[3], V[30], -V[30]] == 
   {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[3], -S[30], V[30], -V[30]] == 
   {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[30], -S[3], V[3], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[3], -S[30], V[3], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[3], -S[3], V[30], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[3], -S[3], V[3], -V[30]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[3], -S[3], V[30], -V[30]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[30], -S[30], V[3], -V[3]] == {{(I/2*EL^2)/SW^2, (I/2*dZH1*EL^2)/SW^2}}, 
  C[S[30], -S[30], V[20], V[20]] == 
   {{(I/2*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2), 
     (I/2*dZH1*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[30], -S[30], V[20], V[2]] == 
   {{(I/2*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2), 
     (I/2*dZH1*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[30], -S[3], V[20], V[20]] == 
   {{(I/2*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2), 
     (I/2*dZH1*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[3], -S[30], V[20], V[20]] == 
   {{(I/2*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2), 
     (I/2*dZH1*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[30], -S[3], V[2], V[2]] == 
   {{(I/2*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2), 
     (I/2*dZH1*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[3], -S[30], V[2], V[2]] == 
   {{(I/2*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2), 
     (I/2*dZH1*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[3], -S[3], V[20], V[2]] == 
   {{(I/2*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2), 
     (I/2*dZH1*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[3], -S[3], V[20], V[20]] == 
   {{(I/2*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2), 
     (I/2*dZH1*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[30], -S[30], V[2], V[2]] == 
   {{(I/2*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2), 
     (I/2*dZH1*EL^2*(-CW^2 + SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[30], -S[30], V[10], V[20]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[30], -S[30], V[10], V[2]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[30], -S[30], V[1], V[20]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[30], -S[3], V[10], V[20]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[3], -S[30], V[10], V[20]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[30], -S[3], V[1], V[2]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[3], -S[30], V[1], V[2]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[3], -S[3], V[10], V[2]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[3], -S[3], V[1], V[20]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[3], -S[3], V[10], V[20]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[30], -S[30], V[1], V[2]] == 
   {{(I*EL^2*(-CW^2 + SW^2))/(CW*SW), (-I*dZH1*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[30], -S[30], V[10], V[10]] == {{2*I*EL^2, 2*I*dZH1*EL^2}}, 
  C[S[30], -S[30], V[10], V[1]] == {{2*I*EL^2, 2*I*dZH1*EL^2}}, 
  C[S[30], -S[3], V[10], V[10]] == {{2*I*EL^2, 2*I*dZH1*EL^2}}, 
  C[S[3], -S[30], V[10], V[10]] == {{2*I*EL^2, 2*I*dZH1*EL^2}}, 
  C[S[30], -S[3], V[1], V[1]] == {{2*I*EL^2, 2*I*dZH1*EL^2}}, 
  C[S[3], -S[30], V[1], V[1]] == {{2*I*EL^2, 2*I*dZH1*EL^2}}, 
  C[S[3], -S[3], V[10], V[1]] == {{2*I*EL^2, 2*I*dZH1*EL^2}}, 
  C[S[3], -S[3], V[10], V[10]] == {{2*I*EL^2, 2*I*dZH1*EL^2}}, 
  C[S[30], -S[30], V[1], V[1]] == {{2*I*EL^2, 2*I*dZH1*EL^2}}, 
  C[S[10], S[10], V[20], V[20]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[10], S[10], V[20], V[2]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[10], S[1], V[20], V[20]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[10], S[1], V[2], V[2]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[1], S[1], V[20], V[2]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[1], S[1], V[20], V[20]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[10], S[10], V[2], V[2]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[20], S[20], V[20], V[20]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[20], S[20], V[20], V[2]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[20], S[2], V[20], V[20]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[20], S[2], V[2], V[2]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[2], S[2], V[20], V[2]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[2], S[2], V[20], V[20]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[20], S[20], V[2], V[2]] == 
   {{(I/2*EL^2)/(CW^2*SW^2), (I/2*dZH1*EL^2)/(CW^2*SW^2)}}, 
  C[S[10], -S[30], V[30], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], -S[30], V[30], V[2]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], -S[30], V[3], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], -S[3], V[30], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[1], -S[30], V[30], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], -S[3], V[3], V[2]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[1], -S[30], V[3], V[2]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[1], -S[3], V[30], V[2]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[1], -S[3], V[3], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[1], -S[3], V[30], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], -S[30], V[3], V[2]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], S[30], -V[30], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], S[30], -V[30], V[2]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], S[30], -V[3], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], S[3], -V[30], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[1], S[30], -V[30], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], S[3], -V[3], V[2]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[1], S[30], -V[3], V[2]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[1], S[3], -V[30], V[2]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[1], S[3], -V[3], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[1], S[3], -V[30], V[20]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], S[30], -V[3], V[2]] == {{(-I/2*EL^2)/CW, (-I/2*dZH1*EL^2)/CW}}, 
  C[S[10], S[30], -V[30], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], S[30], -V[30], V[1]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], S[30], -V[3], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], S[3], -V[30], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[1], S[30], -V[30], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], S[3], -V[3], V[1]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[1], S[30], -V[3], V[1]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[1], S[3], -V[30], V[1]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[1], S[3], -V[3], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[1], S[3], -V[30], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], S[30], -V[3], V[1]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], -S[30], V[30], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], -S[30], V[30], V[1]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], -S[30], V[3], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], -S[3], V[30], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[1], -S[30], V[30], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], -S[3], V[3], V[1]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[1], -S[30], V[3], V[1]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[1], -S[3], V[30], V[1]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[1], -S[3], V[3], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[1], -S[3], V[30], V[10]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[10], -S[30], V[3], V[1]] == {{(-I/2*EL^2)/SW, (-I/2*dZH1*EL^2)/SW}}, 
  C[S[30], S[20], V[20], -V[30]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[S[30], S[20], V[20], -V[3]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[S[30], S[20], V[2], -V[30]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[S[30], S[2], V[20], -V[30]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[S[3], S[20], V[20], -V[30]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[S[30], S[2], V[2], -V[3]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[S[3], S[20], V[2], -V[3]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[S[3], S[2], V[20], -V[3]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[S[3], S[2], V[2], -V[30]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[S[3], S[2], V[20], -V[30]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[S[30], S[20], V[2], -V[3]] == {{EL^2/(2*CW), (dZH1*EL^2)/(2*CW)}}, 
  C[-S[30], S[20], V[20], V[30]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[-S[30], S[20], V[20], V[3]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[-S[30], S[20], V[2], V[30]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[-S[30], S[2], V[20], V[30]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[-S[3], S[20], V[20], V[30]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[-S[30], S[2], V[2], V[3]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[-S[3], S[20], V[2], V[3]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[-S[3], S[2], V[20], V[3]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[-S[3], S[2], V[2], V[30]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[-S[3], S[2], V[20], V[30]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[-S[30], S[20], V[2], V[3]] == {{-EL^2/(2*CW), -(dZH1*EL^2)/(2*CW)}}, 
  C[S[30], S[20], V[10], -V[30]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[S[30], S[20], V[10], -V[3]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[S[30], S[20], V[1], -V[30]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[S[30], S[2], V[10], -V[30]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[S[3], S[20], V[10], -V[30]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[S[30], S[2], V[1], -V[3]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[S[3], S[20], V[1], -V[3]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[S[3], S[2], V[10], -V[3]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[S[3], S[2], V[1], -V[30]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[S[3], S[2], V[10], -V[30]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[S[30], S[20], V[1], -V[3]] == {{EL^2/(2*SW), (dZH1*EL^2)/(2*SW)}}, 
  C[-S[30], S[20], V[10], V[30]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[-S[30], S[20], V[10], V[3]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[-S[30], S[20], V[1], V[30]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[-S[30], S[2], V[10], V[30]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[-S[3], S[20], V[10], V[30]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[-S[30], S[2], V[1], V[3]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[-S[3], S[20], V[1], V[3]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[-S[3], S[2], V[10], V[3]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[-S[3], S[2], V[1], V[30]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[-S[3], S[2], V[10], V[30]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[-S[30], S[20], V[1], V[3]] == {{-EL^2/(2*SW), -(dZH1*EL^2)/(2*SW)}}, 
  C[S[20], S[10], V[20]] == {{EL/(2*CW*SW), (dZH1*EL)/(2*CW*SW)}, 
    {-EL/(2*CW*SW), -(dZH1*EL)/(2*CW*SW)}}, 
  C[S[20], S[10], V[2]] == {{EL/(2*CW*SW), (dZH1*EL)/(2*CW*SW)}, 
    {-EL/(2*CW*SW), -(dZH1*EL)/(2*CW*SW)}}, 
  C[S[20], S[1], V[20]] == {{EL/(2*CW*SW), (dZH1*EL)/(2*CW*SW)}, 
    {-EL/(2*CW*SW), -(dZH1*EL)/(2*CW*SW)}}, 
  C[S[2], S[10], V[20]] == {{EL/(2*CW*SW), (dZH1*EL)/(2*CW*SW)}, 
    {-EL/(2*CW*SW), -(dZH1*EL)/(2*CW*SW)}}, 
  C[S[2], S[1], V[20]] == {{EL/(2*CW*SW), (dZH1*EL)/(2*CW*SW)}, 
    {-EL/(2*CW*SW), -(dZH1*EL)/(2*CW*SW)}}, 
  C[-S[30], S[30], V[10]] == {{-I*EL, -I*dZH1*EL}, {I*EL, I*dZH1*EL}}, 
  C[-S[30], S[30], V[1]] == {{-I*EL, -I*dZH1*EL}, {I*EL, I*dZH1*EL}}, 
  C[-S[30], S[3], V[10]] == {{-I*EL, -I*dZH1*EL}, {I*EL, I*dZH1*EL}}, 
  C[-S[3], S[30], V[10]] == {{-I*EL, -I*dZH1*EL}, {I*EL, I*dZH1*EL}}, 
  C[-S[3], S[3], V[10]] == {{-I*EL, -I*dZH1*EL}, {I*EL, I*dZH1*EL}}, 
  C[-S[30], S[30], V[20]] == {{(I/2*EL*(CW^2 - SW^2))/(CW*SW), 
     (I/2*dZH1*EL*(CW^2 - SW^2))/(CW*SW)}, 
    {(-I/2*EL*(CW^2 - SW^2))/(CW*SW), (-I/2*dZH1*EL*(CW^2 - SW^2))/(CW*SW)}}, 
  C[-S[30], S[30], V[2]] == {{(I/2*EL*(CW^2 - SW^2))/(CW*SW), 
     (I/2*dZH1*EL*(CW^2 - SW^2))/(CW*SW)}, 
    {(-I/2*EL*(CW^2 - SW^2))/(CW*SW), (-I/2*dZH1*EL*(CW^2 - SW^2))/(CW*SW)}}, 
  C[-S[30], S[3], V[20]] == {{(I/2*EL*(CW^2 - SW^2))/(CW*SW), 
     (I/2*dZH1*EL*(CW^2 - SW^2))/(CW*SW)}, 
    {(-I/2*EL*(CW^2 - SW^2))/(CW*SW), (-I/2*dZH1*EL*(CW^2 - SW^2))/(CW*SW)}}, 
  C[-S[3], S[30], V[20]] == {{(I/2*EL*(CW^2 - SW^2))/(CW*SW), 
     (I/2*dZH1*EL*(CW^2 - SW^2))/(CW*SW)}, 
    {(-I/2*EL*(CW^2 - SW^2))/(CW*SW), (-I/2*dZH1*EL*(CW^2 - SW^2))/(CW*SW)}}, 
  C[-S[3], S[3], V[20]] == {{(I/2*EL*(CW^2 - SW^2))/(CW*SW), 
     (I/2*dZH1*EL*(CW^2 - SW^2))/(CW*SW)}, 
    {(-I/2*EL*(CW^2 - SW^2))/(CW*SW), (-I/2*dZH1*EL*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[30], S[10], -V[30]] == {{(-I/2*EL)/SW, (-I/2*dZH1*EL)/SW}, 
    {(I/2*EL)/SW, (I/2*dZH1*EL)/SW}}, 
  C[S[30], S[10], -V[3]] == {{(-I/2*EL)/SW, (-I/2*dZH1*EL)/SW}, 
    {(I/2*EL)/SW, (I/2*dZH1*EL)/SW}}, 
  C[S[30], S[1], -V[30]] == {{(-I/2*EL)/SW, (-I/2*dZH1*EL)/SW}, 
    {(I/2*EL)/SW, (I/2*dZH1*EL)/SW}}, 
  C[S[3], S[10], -V[30]] == {{(-I/2*EL)/SW, (-I/2*dZH1*EL)/SW}, 
    {(I/2*EL)/SW, (I/2*dZH1*EL)/SW}}, 
  C[S[3], S[1], -V[30]] == {{(-I/2*EL)/SW, (-I/2*dZH1*EL)/SW}, 
    {(I/2*EL)/SW, (I/2*dZH1*EL)/SW}}, 
  C[-S[30], S[10], V[30]] == {{(I/2*EL)/SW, (I/2*dZH1*EL)/SW}, 
    {(-I/2*EL)/SW, (-I/2*dZH1*EL)/SW}}, 
  C[-S[30], S[10], V[3]] == {{(I/2*EL)/SW, (I/2*dZH1*EL)/SW}, 
    {(-I/2*EL)/SW, (-I/2*dZH1*EL)/SW}}, 
  C[-S[30], S[1], V[30]] == {{(I/2*EL)/SW, (I/2*dZH1*EL)/SW}, 
    {(-I/2*EL)/SW, (-I/2*dZH1*EL)/SW}}, 
  C[-S[3], S[10], V[30]] == {{(I/2*EL)/SW, (I/2*dZH1*EL)/SW}, 
    {(-I/2*EL)/SW, (-I/2*dZH1*EL)/SW}}, 
  C[-S[3], S[1], V[30]] == {{(I/2*EL)/SW, (I/2*dZH1*EL)/SW}, 
    {(-I/2*EL)/SW, (-I/2*dZH1*EL)/SW}}, 
  C[S[30], S[20], -V[30]] == {{EL/(2*SW), (dZH1*EL)/(2*SW)}, 
    {-EL/(2*SW), -(dZH1*EL)/(2*SW)}}, 
  C[S[30], S[20], -V[3]] == {{EL/(2*SW), (dZH1*EL)/(2*SW)}, 
    {-EL/(2*SW), -(dZH1*EL)/(2*SW)}}, 
  C[S[30], S[2], -V[30]] == {{EL/(2*SW), (dZH1*EL)/(2*SW)}, 
    {-EL/(2*SW), -(dZH1*EL)/(2*SW)}}, 
  C[S[3], S[20], -V[30]] == {{EL/(2*SW), (dZH1*EL)/(2*SW)}, 
    {-EL/(2*SW), -(dZH1*EL)/(2*SW)}}, 
  C[S[3], S[2], -V[30]] == {{EL/(2*SW), (dZH1*EL)/(2*SW)}, 
    {-EL/(2*SW), -(dZH1*EL)/(2*SW)}}, 
  C[-S[30], S[20], V[30]] == {{EL/(2*SW), (dZH1*EL)/(2*SW)}, 
    {-EL/(2*SW), -(dZH1*EL)/(2*SW)}}, 
  C[-S[30], S[20], V[3]] == {{EL/(2*SW), (dZH1*EL)/(2*SW)}, 
    {-EL/(2*SW), -(dZH1*EL)/(2*SW)}}, 
  C[-S[30], S[2], V[30]] == {{EL/(2*SW), (dZH1*EL)/(2*SW)}, 
    {-EL/(2*SW), -(dZH1*EL)/(2*SW)}}, 
  C[-S[3], S[20], V[30]] == {{EL/(2*SW), (dZH1*EL)/(2*SW)}, 
    {-EL/(2*SW), -(dZH1*EL)/(2*SW)}}, 
  C[-S[3], S[2], V[30]] == {{EL/(2*SW), (dZH1*EL)/(2*SW)}, 
    {-EL/(2*SW), -(dZH1*EL)/(2*SW)}}, 
  C[S[10], -V[30], V[30]] == {{(I*EL*MW)/SW, (I*dZH1*EL*MW)/SW}}, 
  C[S[10], -V[30], V[3]] == {{(I*EL*MW)/SW, (I*dZH1*EL*MW)/SW}}, 
  C[S[10], -V[3], V[30]] == {{(I*EL*MW)/SW, (I*dZH1*EL*MW)/SW}}, 
  C[S[1], -V[30], V[30]] == {{(I*EL*MW)/SW, (I*dZH1*EL*MW)/SW}}, 
  C[S[10], -V[3], V[3]] == {{(I*EL*MW)/SW, (I*dZH1*EL*MW)/SW}}, 
  C[S[10], V[20], V[20]] == {{(I*EL*MW)/(CW^2*SW), 
     (I*dZH1*EL*MW)/(CW^2*SW)}}, 
  C[S[10], V[20], V[2]] == {{(I*EL*MW)/(CW^2*SW), (I*dZH1*EL*MW)/(CW^2*SW)}}, 
  C[S[1], V[20], V[20]] == {{(I*EL*MW)/(CW^2*SW), (I*dZH1*EL*MW)/(CW^2*SW)}}, 
  C[S[10], V[2], V[2]] == {{(I*EL*MW)/(CW^2*SW), (I*dZH1*EL*MW)/(CW^2*SW)}}, 
  C[-S[30], V[30], V[20]] == {{(-I*EL*MW*SW)/CW, (-I*dZH1*EL*MW*SW)/CW}}, 
  C[-S[30], V[30], V[2]] == {{(-I*EL*MW*SW)/CW, (-I*dZH1*EL*MW*SW)/CW}}, 
  C[-S[30], V[3], V[20]] == {{(-I*EL*MW*SW)/CW, (-I*dZH1*EL*MW*SW)/CW}}, 
  C[-S[3], V[30], V[20]] == {{(-I*EL*MW*SW)/CW, (-I*dZH1*EL*MW*SW)/CW}}, 
  C[-S[30], V[3], V[2]] == {{(-I*EL*MW*SW)/CW, (-I*dZH1*EL*MW*SW)/CW}}, 
  C[S[30], -V[30], V[20]] == {{(-I*EL*MW*SW)/CW, (-I*dZH1*EL*MW*SW)/CW}}, 
  C[S[30], -V[30], V[2]] == {{(-I*EL*MW*SW)/CW, (-I*dZH1*EL*MW*SW)/CW}}, 
  C[S[30], -V[3], V[20]] == {{(-I*EL*MW*SW)/CW, (-I*dZH1*EL*MW*SW)/CW}}, 
  C[S[3], -V[30], V[20]] == {{(-I*EL*MW*SW)/CW, (-I*dZH1*EL*MW*SW)/CW}}, 
  C[S[30], -V[3], V[2]] == {{(-I*EL*MW*SW)/CW, (-I*dZH1*EL*MW*SW)/CW}}, 
  C[-S[30], V[30], V[10]] == {{-I*EL*MW, -I*dZH1*EL*MW}}, 
  C[-S[30], V[30], V[1]] == {{-I*EL*MW, -I*dZH1*EL*MW}}, 
  C[-S[30], V[3], V[10]] == {{-I*EL*MW, -I*dZH1*EL*MW}}, 
  C[-S[3], V[30], V[10]] == {{-I*EL*MW, -I*dZH1*EL*MW}}, 
  C[-S[30], V[3], V[1]] == {{-I*EL*MW, -I*dZH1*EL*MW}}, 
  C[S[30], -V[30], V[10]] == {{-I*EL*MW, -I*dZH1*EL*MW}}, 
  C[S[30], -V[30], V[1]] == {{-I*EL*MW, -I*dZH1*EL*MW}}, 
  C[S[30], -V[3], V[10]] == {{-I*EL*MW, -I*dZH1*EL*MW}}, 
  C[S[3], -V[30], V[10]] == {{-I*EL*MW, -I*dZH1*EL*MW}}, 
  C[S[30], -V[3], V[1]] == {{-I*EL*MW, -I*dZH1*EL*MW}}, 
  C[-F[2, {j1}], F[2, {j2}], V[10]] == 
   {{I*EL*IndexDelta[j1, j2], I/2*EL*
      (Conjugate[dZfL1[2, j1, j1]*IndexDelta[j1, j2]] + 
        dZfL1[2, j1, j1]*IndexDelta[j1, j2])}, 
    {I*EL*IndexDelta[j1, j2], I/2*EL*
      (Conjugate[dZfR1[2, j1, j1]*IndexDelta[j1, j2]] + 
        dZfR1[2, j1, j1]*IndexDelta[j1, j2])}}, 
  C[-F[3, {j1}], F[3, {j2}], V[10]] == 
   {{(-2*I)/3*EL*IndexDelta[j1, j2], 
     -I/3*EL*(Conjugate[dZfL1[3, j2, j1]] + dZfL1[3, j1, j2])}, 
    {(-2*I)/3*EL*IndexDelta[j1, j2], 
     -I/3*EL*(Conjugate[dZfR1[3, j2, j1]] + dZfR1[3, j1, j2])}}, 
  C[-F[4, {j1}], F[4, {j2}], V[10]] == 
   {{I/3*EL*IndexDelta[j1, j2], 
     I/6*EL*(Conjugate[dZfL1[4, j2, j1]] + dZfL1[4, j1, j2])}, 
    {I/3*EL*IndexDelta[j1, j2], 
     I/6*EL*(Conjugate[dZfR1[4, j2, j1]] + dZfR1[4, j1, j2])}}, 
  C[-F[1, {j1}], F[1, {j2}], V[20]] == 
   {{(I/2*EL*IndexDelta[j1, j2])/(CW*SW), 
     (I/4*EL*(Conjugate[dZfL1[1, j1, j1]*IndexDelta[j1, j2]] + 
          dZfL1[1, j1, j1]*IndexDelta[j1, j2]))/(CW*SW)}, {0, 0}}, 
  C[-F[2, {j1}], F[2, {j2}], V[20]] == 
   {{(I*(1/2 - CW^2)*EL*IndexDelta[j1, j2])/(CW*SW), 
     (-I/4*EL*(CW^2*MW^2*(CW^2 - SW^2)*
           Conjugate[dZfL1[2, j1, j1]*IndexDelta[j1, j2]] + 
          CW^2*MW^2*(CW^2 - SW^2)*dZfL1[2, j1, j1]*IndexDelta[j1, j2]))/
      (CW^3*MW^2*SW)}, {(I*EL*SW*IndexDelta[j1, j2])/CW, 
     (I/2*EL*SW*(Conjugate[dZfR1[2, j1, j1]*IndexDelta[j1, j2]] + 
          dZfR1[2, j1, j1]*IndexDelta[j1, j2]))/CW}}, 
  C[-F[3, {j1}], F[3, {j2}], V[20]] == 
   {{(I/6*(-1 + 4*CW^2)*EL*IndexDelta[j1, j2])/(CW*SW), 
     (I/12*EL*(CW^2*(-1 + 4*CW^2)*MW^2*Conjugate[dZfL1[3, j2, j1]] + 
          CW^2*(-1 + 4*CW^2)*MW^2*dZfL1[3, j1, j2]))/(CW^3*MW^2*SW)}, 
    {((-2*I)/3*EL*SW*IndexDelta[j1, j2])/CW, 
     (-I/3*EL*SW*(Conjugate[dZfR1[3, j2, j1]] + dZfR1[3, j1, j2]))/CW}}, 
  C[-F[4, {j1}], F[4, {j2}], V[20]] == 
   {{(-I/6*(1 + 2*CW^2)*EL*IndexDelta[j1, j2])/(CW*SW), 
     (-I/12*EL*(CW^2*(1 + 2*CW^2)*MW^2*Conjugate[dZfL1[4, j2, j1]] + 
          CW^2*(1 + 2*CW^2)*MW^2*dZfL1[4, j1, j2]))/(CW^3*MW^2*SW)}, 
    {(I/3*EL*SW*IndexDelta[j1, j2])/CW, 
     (I/6*EL*SW*(Conjugate[dZfR1[4, j2, j1]] + dZfR1[4, j1, j2]))/CW}}, 
  C[-F[1, {j1}], F[2, {j2}], -V[30]] == 
   {{(I*EL*IndexDelta[j1, j2])/(Sqrt[2]*SW), 
     (I/2*EL*(Conjugate[dZfL1[1, j1, j1]] + dZfL1[2, j1, j1])*
        IndexDelta[j1, j2])/(Sqrt[2]*SW), 
     (-I/8*EL*(8*dSW2*MW^4 + dMWsq1^2*SW + 4*dMWsq1*dZe1*MW^2*SW - 
          2*dMWsq1*dZH1*MW^2*SW - 8*dZe2*MW^4*SW - 4*dZe1*dZH1*MW^4*SW + 
          dZH1^2*MW^4*SW - 4*dZW2*MW^4*SW + 
          MW^4*SW*Conjugate[dZfL1[1, j1, j1]]^2 - 
          4*MW^4*SW*Conjugate[dZfL2[1, j1, j1]] - 
          2*MW^4*SW*Conjugate[dZfL1[1, j1, j1]]*dZfL1[2, j1, j1] + 
          MW^4*SW*dZfL1[2, j1, j1]^2 - 4*MW^4*SW*dZfL2[2, j1, j1])*
        IndexDelta[j1, j2])/(Sqrt[2]*MW^4*SW^2)}, {0, 0, 0}}, 
  C[-F[2, {j1}], F[1, {j2}], V[30]] == 
   {{(I*EL*IndexDelta[j1, j2])/(Sqrt[2]*SW), 
     (I/2*EL*(Conjugate[dZfL1[2, j1, j1]] + dZfL1[1, j1, j1])*
        IndexDelta[j1, j2])/(Sqrt[2]*SW), 
     (-I/8*EL*(8*dSW2*MW^4 + dMWsq1^2*SW + 4*dMWsq1*dZe1*MW^2*SW - 
          2*dMWsq1*dZH1*MW^2*SW - 8*dZe2*MW^4*SW - 4*dZe1*dZH1*MW^4*SW + 
          dZH1^2*MW^4*SW - 4*dZW2*MW^4*SW + 
          MW^4*SW*Conjugate[dZfL1[2, j1, j1]]^2 - 
          4*MW^4*SW*Conjugate[dZfL2[2, j1, j1]] - 
          2*MW^4*SW*Conjugate[dZfL1[2, j1, j1]]*dZfL1[1, j1, j1] + 
          MW^4*SW*dZfL1[1, j1, j1]^2 - 4*MW^4*SW*dZfL2[1, j1, j1])*
        IndexDelta[j1, j2])/(Sqrt[2]*MW^4*SW^2)}, {0, 0, 0}}, 
  C[-F[3, {j1}], F[4, {j2}], -V[30]] == 
   {{(I*EL*CKM[j1, j2])/(Sqrt[2]*SW), 
     (I/2*EL*(CKM[1, j2]*Conjugate[dZfL1[3, 1, j1]] + 
          CKM[2, j2]*Conjugate[dZfL1[3, 2, j1]] + 
          CKM[3, j2]*Conjugate[dZfL1[3, 3, j1]] + 2*dCKM1[j1, j2] + 
          CKM[j1, 1]*dZfL1[4, 1, j2] + CKM[j1, 2]*dZfL1[4, 2, j2] + 
          CKM[j1, 3]*dZfL1[4, 3, j2]))/(Sqrt[2]*SW)}, {0, 0}}, 
  C[-F[4, {j2}], F[3, {j1}], V[30]] == 
   {{(I*EL*Conjugate[CKM[j1, j2]])/(Sqrt[2]*SW), 
     (I/2*EL*(2*Conjugate[dCKM1[j1, j2]] + 
          Conjugate[CKM[j1, 1]]*Conjugate[dZfL1[4, 1, j2]] + 
          Conjugate[CKM[j1, 2]]*Conjugate[dZfL1[4, 2, j2]] + 
          Conjugate[CKM[j1, 3]]*Conjugate[dZfL1[4, 3, j2]] + 
          Conjugate[CKM[1, j2]]*dZfL1[3, 1, j1] + 
          Conjugate[CKM[2, j2]]*dZfL1[3, 2, j1] + 
          Conjugate[CKM[3, j2]]*dZfL1[3, 3, j1]))/(Sqrt[2]*SW)}, {0, 0}}, 
  C[-F[2, {j1}], F[2, {j2}], S[10]] == 
   {{(-I/2*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(MW*SW), 
     (-I/4*EL*(2*dMf1[2, j1]*IndexDelta[j1, j2] + 
          dZfL1[2, j1, j1]*IndexDelta[j1, j2]*Mass[F[2, {j1}]] + 
          Conjugate[dZfR1[2, j1, j1]*IndexDelta[j1, j2]]*Mass[F[2, {j2}]]))/
      (MW*SW)}, {(-I/2*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(MW*SW), 
     (-I/4*EL*(2*dMf1[2, j1]*IndexDelta[j1, j2] + 
          dZfR1[2, j1, j1]*IndexDelta[j1, j2]*Mass[F[2, {j1}]] + 
          Conjugate[dZfL1[2, j1, j1]*IndexDelta[j1, j2]]*Mass[F[2, {j2}]]))/
      (MW*SW)}}, C[-F[3, {j1}], F[3, {j2}], S[10]] == 
   {{(-I/2*EL*IndexDelta[j1, j2]*Mass[F[3, {j1}]])/(MW*SW), 
     (-I/4*EL*(2*dMf1[3, j1]*IndexDelta[j1, j2] + 
          dZfL1[3, j1, j2]*Mass[F[3, {j1}]] + 
          Conjugate[dZfR1[3, j2, j1]]*Mass[F[3, {j2}]]))/(MW*SW)}, 
    {(-I/2*EL*IndexDelta[j1, j2]*Mass[F[3, {j1}]])/(MW*SW), 
     (-I/4*EL*(2*dMf1[3, j1]*IndexDelta[j1, j2] + 
          dZfR1[3, j1, j2]*Mass[F[3, {j1}]] + 
          Conjugate[dZfL1[3, j2, j1]]*Mass[F[3, {j2}]]))/(MW*SW)}}, 
  C[-F[4, {j1}], F[4, {j2}], S[10]] == 
   {{(-I/2*EL*IndexDelta[j1, j2]*Mass[F[4, {j1}]])/(MW*SW), 
     (-I/4*EL*(2*dMf1[4, j1]*IndexDelta[j1, j2] + 
          dZfL1[4, j1, j2]*Mass[F[4, {j1}]] + 
          Conjugate[dZfR1[4, j2, j1]]*Mass[F[4, {j2}]]))/(MW*SW)}, 
    {(-I/2*EL*IndexDelta[j1, j2]*Mass[F[4, {j1}]])/(MW*SW), 
     (-I/4*EL*(2*dMf1[4, j1]*IndexDelta[j1, j2] + 
          dZfR1[4, j1, j2]*Mass[F[4, {j1}]] + 
          Conjugate[dZfL1[4, j2, j1]]*Mass[F[4, {j2}]]))/(MW*SW)}}, 
  C[-F[2, {j1}], F[2, {j2}], S[20]] == 
   {{-(EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(2*MW*SW), 
     -(EL*(2*dMf1[2, j1]*IndexDelta[j1, j2] + 
           dZfL1[2, j1, j1]*IndexDelta[j1, j2]*Mass[F[2, {j1}]] + 
           Conjugate[dZfR1[2, j1, j1]*IndexDelta[j1, j2]]*Mass[F[2, {j2}]])
)/(4*MW*SW)}, {(EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(2*MW*SW), 
     (EL*(2*dMf1[2, j1]*IndexDelta[j1, j2] + 
          dZfR1[2, j1, j1]*IndexDelta[j1, j2]*Mass[F[2, {j1}]] + 
          Conjugate[dZfL1[2, j1, j1]*IndexDelta[j1, j2]]*Mass[F[2, {j2}]]))/
      (4*MW*SW)}}, C[-F[3, {j1}], F[3, {j2}], S[20]] == 
   {{(EL*IndexDelta[j1, j2]*Mass[F[3, {j1}]])/(2*MW*SW), 
     (EL*(2*dMf1[3, j1]*IndexDelta[j1, j2] + 
          dZfL1[3, j1, j2]*Mass[F[3, {j1}]] + 
          Conjugate[dZfR1[3, j2, j1]]*Mass[F[3, {j2}]]))/(4*MW*SW)}, 
    {-(EL*IndexDelta[j1, j2]*Mass[F[3, {j1}]])/(2*MW*SW), 
     -(EL*(2*dMf1[3, j1]*IndexDelta[j1, j2] + 
           dZfR1[3, j1, j2]*Mass[F[3, {j1}]] + 
           Conjugate[dZfL1[3, j2, j1]]*Mass[F[3, {j2}]]))/(4*MW*SW)}}, 
  C[-F[4, {j1}], F[4, {j2}], S[20]] == 
   {{-(EL*IndexDelta[j1, j2]*Mass[F[4, {j1}]])/(2*MW*SW), 
     -(EL*(2*dMf1[4, j1]*IndexDelta[j1, j2] + 
           dZfL1[4, j1, j2]*Mass[F[4, {j1}]] + 
           Conjugate[dZfR1[4, j2, j1]]*Mass[F[4, {j2}]]))/(4*MW*SW)}, 
    {(EL*IndexDelta[j1, j2]*Mass[F[4, {j1}]])/(2*MW*SW), 
     (EL*(2*dMf1[4, j1]*IndexDelta[j1, j2] + 
          dZfR1[4, j1, j2]*Mass[F[4, {j1}]] + 
          Conjugate[dZfL1[4, j2, j1]]*Mass[F[4, {j2}]]))/(4*MW*SW)}}, 
  C[-F[3, {j1}], F[4, {j2}], -S[30]] == 
   {{(I*EL*CKM[j1, j2]*Mass[F[3, {j1}]])/(Sqrt[2]*MW*SW), 
     (I/2*EL*(2*CKM[j1, j2]*dMf1[3, j1] + 
          CKM[1, j2]*Conjugate[dZfR1[3, 1, j1]]*Mass[F[3, {1}]] + 
          CKM[2, j2]*Conjugate[dZfR1[3, 2, j1]]*Mass[F[3, {2}]] + 
          CKM[3, j2]*Conjugate[dZfR1[3, 3, j1]]*Mass[F[3, {3}]] + 
          2*dCKM1[j1, j2]*Mass[F[3, {j1}]] + 
          CKM[j1, 1]*dZfL1[4, 1, j2]*Mass[F[3, {j1}]] + 
          CKM[j1, 2]*dZfL1[4, 2, j2]*Mass[F[3, {j1}]] + 
          CKM[j1, 3]*dZfL1[4, 3, j2]*Mass[F[3, {j1}]]))/(Sqrt[2]*MW*SW)}, 
    {(-I*EL*CKM[j1, j2]*Mass[F[4, {j2}]])/(Sqrt[2]*MW*SW), 
     (-I/2*EL*(2*CKM[j1, j2]*dMf1[4, j2] + 
          CKM[j1, 1]*dZfR1[4, 1, j2]*Mass[F[4, {1}]] + 
          CKM[j1, 2]*dZfR1[4, 2, j2]*Mass[F[4, {2}]] + 
          CKM[j1, 3]*dZfR1[4, 3, j2]*Mass[F[4, {3}]] + 
          CKM[1, j2]*Conjugate[dZfL1[3, 1, j1]]*Mass[F[4, {j2}]] + 
          CKM[2, j2]*Conjugate[dZfL1[3, 2, j1]]*Mass[F[4, {j2}]] + 
          CKM[3, j2]*Conjugate[dZfL1[3, 3, j1]]*Mass[F[4, {j2}]] + 
          2*dCKM1[j1, j2]*Mass[F[4, {j2}]]))/(Sqrt[2]*MW*SW)}}, 
  C[-F[4, {j2}], F[3, {j1}], S[30]] == 
   {{(-I*EL*Conjugate[CKM[j1, j2]]*Mass[F[4, {j2}]])/(Sqrt[2]*MW*SW), 
     (-I/2*EL*(2*Conjugate[CKM[j1, j2]]*dMf1[4, j2] + 
          Conjugate[CKM[j1, 1]]*Conjugate[dZfR1[4, 1, j2]]*
           Mass[F[4, {1}]] + Conjugate[CKM[j1, 2]]*
           Conjugate[dZfR1[4, 2, j2]]*Mass[F[4, {2}]] + 
          Conjugate[CKM[j1, 3]]*Conjugate[dZfR1[4, 3, j2]]*
           Mass[F[4, {3}]] + 2*Conjugate[dCKM1[j1, j2]]*Mass[F[4, {j2}]] + 
          Conjugate[CKM[1, j2]]*dZfL1[3, 1, j1]*Mass[F[4, {j2}]] + 
          Conjugate[CKM[2, j2]]*dZfL1[3, 2, j1]*Mass[F[4, {j2}]] + 
          Conjugate[CKM[3, j2]]*dZfL1[3, 3, j1]*Mass[F[4, {j2}]]))/
      (Sqrt[2]*MW*SW)}, {(I*EL*Conjugate[CKM[j1, j2]]*Mass[F[3, {j1}]])/
      (Sqrt[2]*MW*SW), (I/2*EL*
        (2*Conjugate[CKM[j1, j2]]*dMf1[3, j2]*Mass[F[3, {j1}]] + 
          (Conjugate[CKM[1, j2]]*dZfR1[3, 1, j1]*Mass[F[3, {1}]] + 
             Conjugate[CKM[2, j2]]*dZfR1[3, 2, j1]*Mass[F[3, {2}]] + 
             Conjugate[CKM[3, j2]]*dZfR1[3, 3, j1]*Mass[F[3, {3}]] + 
             2*Conjugate[dCKM1[j1, j2]]*Mass[F[3, {j1}]] + 
             Conjugate[CKM[j1, 1]]*Conjugate[dZfL1[4, 1, j2]]*
              Mass[F[3, {j1}]] + 
             Conjugate[CKM[j1, 2]]*Conjugate[dZfL1[4, 2, j2]]*
              Mass[F[3, {j1}]] + 
             Conjugate[CKM[j1, 3]]*Conjugate[dZfL1[4, 3, j2]]*
              Mass[F[3, {j1}]])*Mass[F[3, {j2}]]))/
      (Sqrt[2]*MW*SW*Mass[F[3, {j2}]])}}, 
  C[-F[1, {j1}], F[2, {j2}], -S[30]] == 
   {{0, 0}, {(-I*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(Sqrt[2]*MW*SW), 
     (-I/2*EL*IndexDelta[j1, j2]*
        (2*dMf1[2, j1] + (Conjugate[dZfL1[1, j1, j1]] + dZfR1[2, j1, j1])*
           Mass[F[2, {j1}]]))/(Sqrt[2]*MW*SW)}}, 
  C[-F[2, {j1}], F[1, {j2}], S[30]] == 
   {{(-I*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(Sqrt[2]*MW*SW), 
     (-I*EL*IndexDelta[j1, j2]*
        (dMf1[2, j1] + (Conjugate[dZfR1[2, j1, j1]] + dZfL1[1, j1, j1])*
           Mass[F[2, {j1}]]))/(Sqrt[2]*MW*SW)}, {0, 0}}, 
  C[-V[30], V[30]] == {{0, I*dZW1}, {0, I*(dMWsq1 + dZW1*MW^2)}, 
    {0, -I*dZW1}}, C[V[20], V[20]] == 
   {{0, I*dZZZ1}, {0, I*(dMZsq1 + dZZZ1*MZ^2)}, {0, -I*dZZZ1}}, 
  C[V[10], V[10]] == {{0, I*dZAA1}, {0, 0}, {0, -I*dZAA1}}, 
  C[V[10], V[20]] == {{0, I/2*dZAZ1}, {0, 0}, {0, -I/2*dZAZ1}}, 
  C[S[30], -V[30]] == {{0, 0}, {0, I*dZH1*MW}}, 
  C[-S[30], V[30]] == {{0, 0}, {0, -I*dZH1*MW}}, 
  C[S[20], V[20]] == {{0, 0}, {0, -(dZH1*MZ)}}, 
  C[S[10], S[10]] == {{0, -I*dZH1}, {0, I*(-dMHsq1 - dZH1*MH^2)}}, 
  C[S[20], S[20]] == {{0, -I*dZH1}, {0, (I/2*dTad1*EL)/(MW*SW)}}, 
  C[S[30], -S[30]] == {{0, -I*dZH1}, {0, (I/2*dTad1*EL)/(MW*SW)}}, 
  C[V[10], -V[3], V[3]] == {{-I*EL}, {(-I*EL)/GaugeXi[Q]}, 
    {(I*EL)/GaugeXi[Q]}, {0}}, C[-V[30], V[3], V[1]] == 
   {{-I*EL}, {(-I*EL)/GaugeXi[Q]}, {(I*EL)/GaugeXi[Q]}, {0}}, 
  C[V[30], V[1], -V[3]] == {{-I*EL}, {(-I*EL)/GaugeXi[Q]}, 
    {(I*EL)/GaugeXi[Q]}, {0}}, C[V[20], -V[3], V[3]] == 
   {{(I*CW*EL)/SW}, {(I*CW*EL)/(SW*GaugeXi[Q])}, 
    {(-I*CW*EL)/(SW*GaugeXi[Q])}, {0}}, 
  C[-V[30], V[3], V[2]] == {{(I*CW*EL)/SW}, {(I*CW*EL)/(SW*GaugeXi[Q])}, 
    {(-I*CW*EL)/(SW*GaugeXi[Q])}, {0}}, 
  C[V[30], V[2], -V[3]] == {{(I*CW*EL)/SW}, {(I*CW*EL)/(SW*GaugeXi[Q])}, 
    {(-I*CW*EL)/(SW*GaugeXi[Q])}, {0}}, 
  C[S[10], S[1], S[1]] == {{((-3*I)/2*EL*MH^2)/(MW*SW)}}, 
  C[S[10], S[2], S[2]] == {{I*EL*
      (-MH^2/(2*MW*SW) - (MW*GaugeXi[Q])/(CW^2*SW))}}, 
  C[S[1], S[20], S[2]] == {{I*EL*
      (-MH^2/(2*MW*SW) + (MW*GaugeXi[Q])/(CW^2*SW))}}, 
  C[S[10], -S[3], S[3]] == {{I*EL*(-MH^2/(2*MW*SW) - (MW*GaugeXi[Q])/SW)}}, 
  C[S[1], -S[30], S[3]] == {{I*EL*
      (-MH^2/(2*MW*SW) + (MW*GaugeXi[Q])/(2*SW))}}, 
  C[S[1], -S[3], S[30]] == {{I*EL*
      (-MH^2/(2*MW*SW) + (MW*GaugeXi[Q])/(2*SW))}}, 
  C[S[2], -S[30], S[3]] == {{(EL*MW*SW*GaugeXi[Q])/(2*CW^2)}}, 
  C[S[2], -S[3], S[30]] == {{-(EL*MW*SW*GaugeXi[Q])/(2*CW^2)}}, 
  C[S[30], S[1], -V[3]] == {{(-I*EL)/SW}, {0}}, 
  C[-S[30], S[1], V[3]] == {{(I*EL)/SW}, {0}}, 
  C[S[10], S[3], -V[3]] == {{(I*EL)/SW}, {0}}, 
  C[S[10], -S[3], V[3]] == {{(-I*EL)/SW}, {0}}, 
  C[S[30], S[2], -V[3]] == {{EL/SW}, {0}}, 
  C[-S[30], S[2], V[3]] == {{EL/SW}, {0}}, 
  C[S[20], S[3], -V[3]] == {{-(EL/SW)}, {0}}, 
  C[S[20], -S[3], V[3]] == {{-(EL/SW)}, {0}}, 
  C[S[30], -S[3], V[2]] == {{(-I*EL*(CW^2 - SW^2))/(CW*SW)}, {0}}, 
  C[-S[30], S[3], V[2]] == {{(I*EL*(CW^2 - SW^2))/(CW*SW)}, {0}}, 
  C[S[30], -S[3], V[1]] == {{2*I*EL}, {0}}, 
  C[-S[30], S[3], V[1]] == {{-2*I*EL}, {0}}, 
  C[S[20], S[1], V[2]] == {{EL/(CW*SW)}, {0}}, 
  C[S[10], S[2], V[2]] == {{-(EL/(CW*SW))}, {0}}, 
  C[S[1], -V[30], V[3]] == {{(I*EL*MW)/SW}}, 
  C[S[1], V[30], -V[3]] == {{(I*EL*MW)/SW}}, 
  C[S[1], V[20], V[2]] == {{(I*EL*MW)/(CW^2*SW)}}, 
  C[-S[3], V[20], V[3]] == {{(-I*EL*MW)/(CW*SW)}}, 
  C[S[3], V[20], -V[3]] == {{(-I*EL*MW)/(CW*SW)}}, 
  C[-S[3], V[30], V[2]] == {{(I*EL*MW*(CW^2 - SW^2))/(CW*SW)}}, 
  C[S[3], -V[30], V[2]] == {{(I*EL*MW*(CW^2 - SW^2))/(CW*SW)}}, 
  C[-S[3], V[30], V[1]] == {{-2*I*EL*MW}}, 
  C[S[3], -V[30], V[1]] == {{-2*I*EL*MW}}, 
  C[S[2], -V[30], V[3]] == {{(EL*MW)/SW}}, 
  C[S[2], V[30], -V[3]] == {{-((EL*MW)/SW)}}, 
  C[-U[4], U[2], -V[30]] == {{(I*CW*EL)/SW}, {(-I*CW*EL)/SW}}, 
  C[-U[3], U[2], V[30]] == {{(-I*CW*EL)/SW}, {(I*CW*EL)/SW}}, 
  C[-U[4], U[1], -V[30]] == {{-I*EL}, {I*EL}}, 
  C[-U[3], U[1], V[30]] == {{I*EL}, {-I*EL}}, 
  C[-U[2], U[3], -V[30]] == {{(-I*CW*EL)/SW}, {(I*CW*EL)/SW}}, 
  C[-U[2], U[4], V[30]] == {{(I*CW*EL)/SW}, {(-I*CW*EL)/SW}}, 
  C[-U[1], U[3], -V[30]] == {{I*EL}, {-I*EL}}, 
  C[-U[1], U[4], V[30]] == {{-I*EL}, {I*EL}}, 
  C[-U[4], U[4], V[10]] == {{I*EL}, {-I*EL}}, 
  C[-U[3], U[3], V[10]] == {{-I*EL}, {I*EL}}, 
  C[-U[4], U[4], V[20]] == {{(-I*CW*EL)/SW}, {(I*CW*EL)/SW}}, 
  C[-U[3], U[3], V[20]] == {{(I*CW*EL)/SW}, {(-I*CW*EL)/SW}}, 
  C[-S[30], -U[4], U[2]] == {{(I*EL*MW*SW*GaugeXi[Q])/CW}}, 
  C[S[30], -U[3], U[2]] == {{(I*EL*MW*SW*GaugeXi[Q])/CW}}, 
  C[-S[30], -U[4], U[1]] == {{I*EL*MW*GaugeXi[Q]}}, 
  C[S[30], -U[3], U[1]] == {{I*EL*MW*GaugeXi[Q]}}, 
  C[-S[30], -U[2], U[3]] == {{(I*EL*MW*SW*GaugeXi[Q])/CW}}, 
  C[S[30], -U[2], U[4]] == {{(I*EL*MW*SW*GaugeXi[Q])/CW}}, 
  C[-S[30], -U[1], U[3]] == {{I*EL*MW*GaugeXi[Q]}}, 
  C[S[30], -U[1], U[4]] == {{I*EL*MW*GaugeXi[Q]}}, 
  C[S[10], -U[4], U[4]] == {{(-I*EL*MW*GaugeXi[Q])/SW}}, 
  C[S[10], -U[3], U[3]] == {{(-I*EL*MW*GaugeXi[Q])/SW}}, 
  C[S[10], -U[2], U[2]] == {{(-I*EL*MW*GaugeXi[Q])/(CW^2*SW)}}, 
  C[V[10], V[10], -V[3], V[3]] == 
   {{-2*I*EL^2}, {-I*EL^2*(-1 + GaugeXi[Q]^(-1))}, 
    {-I*EL^2*(-1 + GaugeXi[Q]^(-1))}}, 
  C[-V[30], V[30], V[1], V[1]] == 
   {{-2*I*EL^2}, {-I*EL^2*(-1 + GaugeXi[Q]^(-1))}, 
    {-I*EL^2*(-1 + GaugeXi[Q]^(-1))}}, 
  C[V[20], V[20], -V[3], V[3]] == 
   {{(-2*I*CW^2*EL^2)/SW^2}, {(-I*CW^2*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW^2}, 
    {(-I*CW^2*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW^2}}, 
  C[-V[30], V[30], V[2], V[2]] == 
   {{(-2*I*CW^2*EL^2)/SW^2}, {(-I*CW^2*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW^2}, 
    {(-I*CW^2*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW^2}}, 
  C[V[10], V[20], -V[3], V[3]] == 
   {{(2*I*CW*EL^2)/SW}, {(I*CW*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW}, 
    {(I*CW*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW}}, 
  C[-V[30], V[30], V[1], V[2]] == 
   {{(2*I*CW*EL^2)/SW}, {(I*CW*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW}, 
    {(I*CW*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW}}, 
  C[V[30], V[30], -V[3], -V[3]] == 
   {{(2*I*EL^2)/SW^2}, {(I*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW^2}, 
    {(I*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW^2}}, 
  C[-V[30], -V[30], V[3], V[3]] == 
   {{(2*I*EL^2)/SW^2}, {(I*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW^2}, 
    {(I*EL^2*(-1 + GaugeXi[Q]^(-1)))/SW^2}}, 
  C[-V[30], V[10], V[3], V[1]] == 
   {{I*EL^2}, {-2*I*EL^2}, {-I*EL^2*(-1 - GaugeXi[Q]^(-1))}}, 
  C[V[30], V[10], -V[3], V[1]] == 
   {{I*EL^2}, {-2*I*EL^2}, {-I*EL^2*(-1 - GaugeXi[Q]^(-1))}}, 
  C[-V[30], V[20], V[3], V[2]] == 
   {{(I*CW^2*EL^2)/SW^2}, {(-2*I*CW^2*EL^2)/SW^2}, 
    {(-I*CW^2*EL^2*(-1 - GaugeXi[Q]^(-1)))/SW^2}}, 
  C[V[30], V[20], -V[3], V[2]] == 
   {{(I*CW^2*EL^2)/SW^2}, {(-2*I*CW^2*EL^2)/SW^2}, 
    {(-I*CW^2*EL^2*(-1 - GaugeXi[Q]^(-1)))/SW^2}}, 
  C[-V[30], V[10], V[3], V[2]] == 
   {{(-I*CW*EL^2)/SW}, {(2*I*CW*EL^2)/SW}, 
    {(I*CW*EL^2*(-1 - GaugeXi[Q]^(-1)))/SW}}, 
  C[V[30], V[10], -V[3], V[2]] == 
   {{(-I*CW*EL^2)/SW}, {(2*I*CW*EL^2)/SW}, 
    {(I*CW*EL^2*(-1 - GaugeXi[Q]^(-1)))/SW}}, 
  C[-V[30], V[20], V[3], V[1]] == 
   {{(-I*CW*EL^2)/SW}, {(2*I*CW*EL^2)/SW}, 
    {(I*CW*EL^2*(-1 - GaugeXi[Q]^(-1)))/SW}}, 
  C[V[30], V[20], -V[3], V[1]] == 
   {{(-I*CW*EL^2)/SW}, {(2*I*CW*EL^2)/SW}, 
    {(I*CW*EL^2*(-1 - GaugeXi[Q]^(-1)))/SW}}, 
  C[-V[30], V[30], -V[3], V[3]] == 
   {{(-I*EL^2)/SW^2}, {(2*I*EL^2)/SW^2}, 
    {(I*EL^2*(-1 - GaugeXi[Q]^(-1)))/SW^2}}, 
  C[S[1], S[1], -S[30], S[30]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) - GaugeXi[Q]/(2*SW^2))}}, 
  C[S[10], S[10], -S[3], S[3]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) - GaugeXi[Q]/(2*SW^2))}}, 
  C[S[2], S[2], -S[30], S[30]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) - GaugeXi[Q]/(2*SW^2))}}, 
  C[S[20], S[20], -S[3], S[3]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) - GaugeXi[Q]/(2*SW^2))}}, 
  C[S[10], S[1], -S[30], S[3]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) + GaugeXi[Q]/(4*SW^2))}}, 
  C[S[10], S[1], -S[3], S[30]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) + GaugeXi[Q]/(4*SW^2))}}, 
  C[S[20], S[2], -S[30], S[3]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) + GaugeXi[Q]/(4*SW^2))}}, 
  C[S[20], S[2], -S[3], S[30]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) + GaugeXi[Q]/(4*SW^2))}}, 
  C[S[10], S[2], -S[30], S[3]] == {{(EL^2*GaugeXi[Q])/(4*CW^2)}}, 
  C[S[1], S[20], -S[30], S[3]] == {{-(EL^2*GaugeXi[Q])/(4*CW^2)}}, 
  C[S[10], S[2], -S[3], S[30]] == {{-(EL^2*GaugeXi[Q])/(4*CW^2)}}, 
  C[S[1], S[20], -S[3], S[30]] == {{(EL^2*GaugeXi[Q])/(4*CW^2)}}, 
  C[S[1], S[1], S[20], S[20]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) - GaugeXi[Q]/(2*CW^2*SW^2))}}, 
  C[S[10], S[10], S[2], S[2]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) - GaugeXi[Q]/(2*CW^2*SW^2))}}, 
  C[S[10], S[1], S[20], S[2]] == 
   {{I*EL^2*(-MH^2/(4*MW^2*SW^2) + GaugeXi[Q]/(4*CW^2*SW^2))}}, 
  C[-S[30], -S[30], S[3], S[3]] == 
   {{I*EL^2*(-MH^2/(2*MW^2*SW^2) + GaugeXi[Q]/(2*CW^2*SW^2))}}, 
  C[S[30], S[30], -S[3], -S[3]] == 
   {{I*EL^2*(-MH^2/(2*MW^2*SW^2) + GaugeXi[Q]/(2*CW^2*SW^2))}}, 
  C[S[30], -S[30], S[3], -S[3]] == 
   {{I*EL^2*(-MH^2/(2*MW^2*SW^2) - GaugeXi[Q]/(4*CW^2*SW^2))}}, 
  C[S[10], S[10], S[1], S[1]] == {{((-3*I)/4*EL^2*MH^2)/(MW^2*SW^2)}}, 
  C[S[20], S[20], S[2], S[2]] == {{((-3*I)/4*EL^2*MH^2)/(MW^2*SW^2)}}, 
  C[-S[30], S[3], V[10], V[1]] == {{2*I*EL^2}}, 
  C[-S[3], S[30], V[10], V[1]] == {{2*I*EL^2}}, 
  C[-S[30], S[3], V[10], V[2]] == {{(-I*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[-S[3], S[30], V[10], V[2]] == {{(-I*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[-S[30], S[3], V[1], V[20]] == {{(-I*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[-S[3], S[30], V[1], V[20]] == {{(-I*EL^2*(CW^2 - SW^2))/(CW*SW)}}, 
  C[-S[30], S[3], V[20], V[2]] == {{(I/2*EL^2*(CW^2 - SW^2)^2)/(CW^2*SW^2)}}, 
  C[-S[3], S[30], V[20], V[2]] == {{(I/2*EL^2*(CW^2 - SW^2)^2)/(CW^2*SW^2)}}, 
  C[S[10], S[1], V[20], V[2]] == {{(I/2*EL^2)/(CW^2*SW^2)}}, 
  C[S[20], S[2], V[20], V[2]] == {{(I/2*EL^2)/(CW^2*SW^2)}}, 
  C[S[10], S[1], -V[30], V[3]] == {{(I/2*EL^2)/SW^2}}, 
  C[S[10], S[1], -V[3], V[30]] == {{(I/2*EL^2)/SW^2}}, 
  C[S[20], S[2], -V[30], V[3]] == {{(I/2*EL^2)/SW^2}}, 
  C[S[20], S[2], -V[3], V[30]] == {{(I/2*EL^2)/SW^2}}, 
  C[S[1], S[30], V[10], -V[3]] == {{(-I*EL^2)/SW}}, 
  C[S[1], -S[30], V[10], V[3]] == {{(-I*EL^2)/SW}}, 
  C[S[10], S[3], V[1], -V[30]] == {{(-I*EL^2)/SW}}, 
  C[S[10], -S[3], V[1], V[30]] == {{(-I*EL^2)/SW}}, 
  C[S[2], S[30], V[10], -V[3]] == {{EL^2/SW}}, 
  C[S[2], -S[30], V[10], V[3]] == {{-(EL^2/SW)}}, 
  C[S[20], S[3], V[1], -V[30]] == {{EL^2/SW}}, 
  C[S[20], -S[3], V[1], V[30]] == {{-(EL^2/SW)}}, 
  C[S[10], S[3], V[20], -V[3]] == {{(-I/2*EL^2)/(CW*SW^2)}}, 
  C[S[10], -S[3], V[20], V[3]] == {{(-I/2*EL^2)/(CW*SW^2)}}, 
  C[S[1], S[30], V[2], -V[30]] == {{(-I/2*EL^2)/(CW*SW^2)}}, 
  C[S[1], -S[30], V[2], V[30]] == {{(-I/2*EL^2)/(CW*SW^2)}}, 
  C[S[1], S[30], V[20], -V[3]] == {{(I/2*EL^2*(CW^2 - SW^2))/(CW*SW^2)}}, 
  C[S[1], -S[30], V[20], V[3]] == {{(I/2*EL^2*(CW^2 - SW^2))/(CW*SW^2)}}, 
  C[S[10], S[3], V[2], -V[30]] == {{(I/2*EL^2*(CW^2 - SW^2))/(CW*SW^2)}}, 
  C[S[10], -S[3], V[2], V[30]] == {{(I/2*EL^2*(CW^2 - SW^2))/(CW*SW^2)}}, 
  C[S[20], S[3], V[20], -V[3]] == {{EL^2/(2*CW*SW^2)}}, 
  C[S[20], -S[3], V[20], V[3]] == {{-EL^2/(2*CW*SW^2)}}, 
  C[S[2], S[30], V[2], -V[30]] == {{EL^2/(2*CW*SW^2)}}, 
  C[S[2], -S[30], V[2], V[30]] == {{-EL^2/(2*CW*SW^2)}}, 
  C[S[2], S[30], V[20], -V[3]] == {{-(EL^2*(CW^2 - SW^2))/(2*CW*SW^2)}}, 
  C[S[2], -S[30], V[20], V[3]] == {{(EL^2*(CW^2 - SW^2))/(2*CW*SW^2)}}, 
  C[S[20], S[3], V[2], -V[30]] == {{-(EL^2*(CW^2 - SW^2))/(2*CW*SW^2)}}, 
  C[S[20], -S[3], V[2], V[30]] == {{(EL^2*(CW^2 - SW^2))/(2*CW*SW^2)}}, 
  C[-S[3], S[30], -V[30], V[3]] == {{(I*EL^2)/SW^2}}, 
  C[-S[30], S[3], -V[3], V[30]] == {{(I*EL^2)/SW^2}}, 
  C[S[10], S[2], -V[30], V[3]] == {{EL^2/(2*SW^2)}}, 
  C[S[10], S[2], -V[3], V[30]] == {{-EL^2/(2*SW^2)}}, 
  C[S[1], S[20], -V[30], V[3]] == {{-EL^2/(2*SW^2)}}, 
  C[S[1], S[20], -V[3], V[30]] == {{EL^2/(2*SW^2)}}, 
  C[-U[4], U[4], V[10], V[1]] == {{I*EL^2}}, 
  C[-U[3], U[3], V[10], V[1]] == {{I*EL^2}}, 
  C[-U[4], U[4], V[10], V[2]] == {{(-I*CW*EL^2)/SW}}, 
  C[-U[3], U[3], V[10], V[2]] == {{(-I*CW*EL^2)/SW}}, 
  C[-U[4], U[4], V[20], V[1]] == {{(-I*CW*EL^2)/SW}}, 
  C[-U[3], U[3], V[20], V[1]] == {{(-I*CW*EL^2)/SW}}, 
  C[-U[4], U[4], V[20], V[2]] == {{(I*CW^2*EL^2)/SW^2}}, 
  C[-U[3], U[3], V[20], V[2]] == {{(I*CW^2*EL^2)/SW^2}}, 
  C[-U[4], U[1], V[10], -V[3]] == {{-I*EL^2}}, 
  C[-U[3], U[1], V[10], V[3]] == {{-I*EL^2}}, 
  C[-U[4], U[1], V[20], -V[3]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[3], U[1], V[20], V[3]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[4], U[2], V[10], -V[3]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[3], U[2], V[10], V[3]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[4], U[2], V[20], -V[3]] == {{(-I*CW^2*EL^2)/SW^2}}, 
  C[-U[3], U[2], V[20], V[3]] == {{(-I*CW^2*EL^2)/SW^2}}, 
  C[-U[1], U[3], -V[30], V[1]] == {{-I*EL^2}}, 
  C[-U[1], U[4], V[30], V[1]] == {{-I*EL^2}}, 
  C[-U[1], U[3], -V[30], V[2]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[1], U[4], V[30], V[2]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[2], U[3], -V[30], V[1]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[2], U[4], V[30], V[1]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[2], U[3], -V[30], V[2]] == {{(-I*CW^2*EL^2)/SW^2}}, 
  C[-U[2], U[4], V[30], V[2]] == {{(-I*CW^2*EL^2)/SW^2}}, 
  C[-U[1], U[1], -V[30], V[3]] == {{I*EL^2}}, 
  C[-U[1], U[1], V[30], -V[3]] == {{I*EL^2}}, 
  C[-U[2], U[1], -V[30], V[3]] == {{(-I*CW*EL^2)/SW}}, 
  C[-U[2], U[1], V[30], -V[3]] == {{(-I*CW*EL^2)/SW}}, 
  C[-U[1], U[2], -V[30], V[3]] == {{(-I*CW*EL^2)/SW}}, 
  C[-U[1], U[2], V[30], -V[3]] == {{(-I*CW*EL^2)/SW}}, 
  C[-U[2], U[2], -V[30], V[3]] == {{(I*CW^2*EL^2)/SW^2}}, 
  C[-U[2], U[2], V[30], -V[3]] == {{(I*CW^2*EL^2)/SW^2}}, 
  C[-U[4], U[4], -V[30], V[3]] == {{(I*EL^2)/SW^2}}, 
  C[-U[3], U[3], V[30], -V[3]] == {{(I*EL^2)/SW^2}}, 
  C[-U[4], U[3], -V[30], -V[3]] == {{(-I*EL^2)/SW^2}}, 
  C[-U[3], U[4], V[30], V[3]] == {{(-I*EL^2)/SW^2}}, 
  C[-U[4], U[4], V[10], V[10]] == {{2*I*EL^2}}, 
  C[-U[3], U[3], V[10], V[10]] == {{2*I*EL^2}}, 
  C[-U[4], U[4], V[10], V[20]] == {{(-2*I*CW*EL^2)/SW}}, 
  C[-U[3], U[3], V[10], V[20]] == {{(-2*I*CW*EL^2)/SW}}, 
  C[-U[4], U[4], V[20], V[10]] == {{(-2*I*CW*EL^2)/SW}}, 
  C[-U[3], U[3], V[20], V[10]] == {{(-2*I*CW*EL^2)/SW}}, 
  C[-U[4], U[4], V[20], V[20]] == {{(2*I*CW^2*EL^2)/SW^2}}, 
  C[-U[3], U[3], V[20], V[20]] == {{(2*I*CW^2*EL^2)/SW^2}}, 
  C[-U[4], U[1], V[10], -V[30]] == {{-I*EL^2}}, 
  C[-U[3], U[1], V[10], V[30]] == {{-I*EL^2}}, 
  C[-U[4], U[1], V[20], -V[30]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[3], U[1], V[20], V[30]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[4], U[2], V[10], -V[30]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[3], U[2], V[10], V[30]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[4], U[2], V[20], -V[30]] == {{(-I*CW^2*EL^2)/SW^2}}, 
  C[-U[3], U[2], V[20], V[30]] == {{(-I*CW^2*EL^2)/SW^2}}, 
  C[-U[1], U[3], -V[30], V[10]] == {{-I*EL^2}}, 
  C[-U[1], U[4], V[30], V[10]] == {{-I*EL^2}}, 
  C[-U[1], U[3], -V[30], V[20]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[1], U[4], V[30], V[20]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[2], U[3], -V[30], V[10]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[2], U[4], V[30], V[10]] == {{(I*CW*EL^2)/SW}}, 
  C[-U[2], U[3], -V[30], V[20]] == {{(-I*CW^2*EL^2)/SW^2}}, 
  C[-U[2], U[4], V[30], V[20]] == {{(-I*CW^2*EL^2)/SW^2}}, 
  C[-U[1], U[1], V[30], -V[30]] == {{2*I*EL^2}}, 
  C[-U[2], U[1], V[30], -V[30]] == {{(-2*I*CW*EL^2)/SW}}, 
  C[-U[1], U[2], V[30], -V[30]] == {{(-2*I*CW*EL^2)/SW}}, 
  C[-U[2], U[2], V[30], -V[30]] == {{(2*I*CW^2*EL^2)/SW^2}}, 
  C[-U[4], U[4], -V[30], V[30]] == {{(I*EL^2)/SW^2}}, 
  C[-U[3], U[3], V[30], -V[30]] == {{(I*EL^2)/SW^2}}, 
  C[-U[4], U[3], -V[30], -V[30]] == {{(-2*I*EL^2)/SW^2}}, 
  C[-U[3], U[4], V[30], V[30]] == {{(-2*I*EL^2)/SW^2}}, 
  C[-S[30], S[3], -U[4], U[4]] == {{(-I/2*EL^2*GaugeXi[Q])/SW^2}}, 
  C[-S[3], S[30], -U[3], U[3]] == {{(-I/2*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[10], S[1], -U[4], U[4]] == {{(-I/4*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[10], S[1], -U[3], U[3]] == {{(-I/4*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[20], S[2], -U[4], U[4]] == {{(-I/4*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[20], S[2], -U[3], U[3]] == {{(-I/4*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[10], S[1], -U[2], U[2]] == {{(-I/4*EL^2*GaugeXi[Q])/(CW^2*SW^2)}}, 
  C[S[20], S[2], -U[2], U[2]] == {{(-I/4*EL^2*GaugeXi[Q])/(CW^2*SW^2)}}, 
  C[S[10], S[2], -U[4], U[4]] == {{(I/4*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[10], S[2], -U[3], U[3]] == {{(-I/4*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[1], S[20], -U[4], U[4]] == {{(-I/4*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[1], S[20], -U[3], U[3]] == {{(I/4*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[30], -S[3], -U[2], U[2]] == 
   {{(I/4*EL^2*(CW^2 - SW^2)^2*GaugeXi[Q])/(CW^2*SW^2)}}, 
  C[S[3], -S[30], -U[2], U[2]] == 
   {{(I/4*EL^2*(CW^2 - SW^2)^2*GaugeXi[Q])/(CW^2*SW^2)}}, 
  C[S[3], -S[30], -U[2], U[1]] == 
   {{(I/2*EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(CW*SW)}}, 
  C[S[30], -S[3], -U[2], U[1]] == 
   {{(I/2*EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(CW*SW)}}, 
  C[S[3], -S[30], -U[1], U[2]] == 
   {{(I/2*EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(CW*SW)}}, 
  C[S[30], -S[3], -U[1], U[2]] == 
   {{(I/2*EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(CW*SW)}}, 
  C[S[3], -S[30], -U[1], U[1]] == {{-I*EL^2*GaugeXi[Q]}}, 
  C[S[30], -S[3], -U[1], U[1]] == {{-I*EL^2*GaugeXi[Q]}}, 
  C[-S[30], S[1], -U[4], U[2]] == {{(I/4*EL^2*GaugeXi[Q])/(CW*SW^2)}}, 
  C[S[30], S[1], -U[3], U[2]] == {{(I/4*EL^2*GaugeXi[Q])/(CW*SW^2)}}, 
  C[-S[3], S[10], -U[2], U[3]] == {{(I/4*EL^2*GaugeXi[Q])/(CW*SW^2)}}, 
  C[S[3], S[10], -U[2], U[4]] == {{(I/4*EL^2*GaugeXi[Q])/(CW*SW^2)}}, 
  C[-S[3], S[10], -U[4], U[2]] == 
   {{(-I/4*EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(CW*SW^2)}}, 
  C[S[3], S[10], -U[3], U[2]] == 
   {{(-I/4*EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(CW*SW^2)}}, 
  C[-S[30], S[1], -U[2], U[3]] == 
   {{(-I/4*EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(CW*SW^2)}}, 
  C[S[30], S[1], -U[2], U[4]] == 
   {{(I/4*EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(CW*SW^2)}}, 
  C[-S[30], S[1], -U[4], U[1]] == {{(I/2*EL^2*GaugeXi[Q])/SW}}, 
  C[S[30], S[1], -U[3], U[1]] == {{(I/2*EL^2*GaugeXi[Q])/SW}}, 
  C[-S[3], S[10], -U[1], U[3]] == {{(I/2*EL^2*GaugeXi[Q])/SW}}, 
  C[S[3], S[10], -U[1], U[4]] == {{(I/2*EL^2*GaugeXi[Q])/SW}}, 
  C[-S[30], S[2], -U[4], U[2]] == {{(EL^2*GaugeXi[Q])/(4*CW*SW^2)}}, 
  C[S[30], S[2], -U[3], U[2]] == {{-(EL^2*GaugeXi[Q])/(4*CW*SW^2)}}, 
  C[-S[3], S[20], -U[2], U[3]] == {{(EL^2*GaugeXi[Q])/(4*CW*SW^2)}}, 
  C[S[3], S[20], -U[2], U[4]] == {{-(EL^2*GaugeXi[Q])/(4*CW*SW^2)}}, 
  C[-S[3], S[20], -U[4], U[2]] == 
   {{-(EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(4*CW*SW^2)}}, 
  C[S[3], S[20], -U[3], U[2]] == 
   {{(EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(4*CW*SW^2)}}, 
  C[-S[30], S[2], -U[2], U[3]] == 
   {{-(EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(4*CW*SW^2)}}, 
  C[S[30], S[2], -U[2], U[4]] == 
   {{(EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(4*CW*SW^2)}}, 
  C[-S[3], S[20], -U[4], U[1]] == {{(EL^2*GaugeXi[Q])/(2*SW)}}, 
  C[S[3], S[20], -U[3], U[1]] == {{-(EL^2*GaugeXi[Q])/(2*SW)}}, 
  C[-S[30], S[2], -U[1], U[3]] == {{(EL^2*GaugeXi[Q])/(2*SW)}}, 
  C[S[30], S[2], -U[1], U[4]] == {{-(EL^2*GaugeXi[Q])/(2*SW)}}, 
  C[-S[30], S[30], -U[4], U[4]] == {{(-I/2*EL^2*GaugeXi[Q])/SW^2}}, 
  C[-S[30], S[30], -U[3], U[3]] == {{(-I/2*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[10], S[10], -U[4], U[4]] == {{(-I/2*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[10], S[10], -U[3], U[3]] == {{(-I/2*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[20], S[20], -U[4], U[4]] == {{(-I/2*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[20], S[20], -U[3], U[3]] == {{(-I/2*EL^2*GaugeXi[Q])/SW^2}}, 
  C[S[10], S[10], -U[2], U[2]] == {{(-I/2*EL^2*GaugeXi[Q])/(CW^2*SW^2)}}, 
  C[S[20], S[20], -U[2], U[2]] == {{(-I/2*EL^2*GaugeXi[Q])/(CW^2*SW^2)}}, 
  C[S[30], -S[30], -U[2], U[2]] == 
   {{(I/2*EL^2*(CW^2 - SW^2)^2*GaugeXi[Q])/(CW^2*SW^2)}}, 
  C[S[30], -S[30], -U[2], U[1]] == 
   {{(I*EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(CW*SW)}}, 
  C[S[30], -S[30], -U[1], U[2]] == 
   {{(I*EL^2*(CW^2 - SW^2)*GaugeXi[Q])/(CW*SW)}}, 
  C[S[30], -S[30], -U[1], U[1]] == {{-2*I*EL^2*GaugeXi[Q]}}, 
  C[-S[30], S[10], -U[4], U[2]] == {{(I/2*EL^2*GaugeXi[Q])/CW}}, 
  C[S[30], S[10], -U[3], U[2]] == {{(I/2*EL^2*GaugeXi[Q])/CW}}, 
  C[-S[30], S[10], -U[2], U[3]] == {{(I/2*EL^2*GaugeXi[Q])/CW}}, 
  C[S[30], S[10], -U[2], U[4]] == {{(I/2*EL^2*GaugeXi[Q])/CW}}, 
  C[-S[30], S[10], -U[4], U[1]] == {{(I/2*EL^2*GaugeXi[Q])/SW}}, 
  C[S[30], S[10], -U[3], U[1]] == {{(I/2*EL^2*GaugeXi[Q])/SW}}, 
  C[-S[30], S[10], -U[1], U[3]] == {{(I/2*EL^2*GaugeXi[Q])/SW}}, 
  C[S[30], S[10], -U[1], U[4]] == {{(I/2*EL^2*GaugeXi[Q])/SW}}, 
  C[-S[30], S[20], -U[4], U[2]] == {{(EL^2*GaugeXi[Q])/(2*CW)}}, 
  C[S[30], S[20], -U[3], U[2]] == {{-(EL^2*GaugeXi[Q])/(2*CW)}}, 
  C[-S[30], S[20], -U[2], U[3]] == {{(EL^2*GaugeXi[Q])/(2*CW)}}, 
  C[S[30], S[20], -U[2], U[4]] == {{-(EL^2*GaugeXi[Q])/(2*CW)}}, 
  C[-S[30], S[20], -U[4], U[1]] == {{(EL^2*GaugeXi[Q])/(2*SW)}}, 
  C[S[30], S[20], -U[3], U[1]] == {{-(EL^2*GaugeXi[Q])/(2*SW)}}, 
  C[-S[30], S[20], -U[1], U[3]] == {{(EL^2*GaugeXi[Q])/(2*SW)}}, 
  C[S[30], S[20], -U[1], U[4]] == {{-(EL^2*GaugeXi[Q])/(2*SW)}}}


GaugeXi[ V[1 | 2 | 3] ] = GaugeXi[Q];
GaugeXi[ V[10 | 30 | 30] ] = GaugeXi[bg];
GaugeXi[ S[1 | 10] ] = 1;
GaugeXi[ S[2 | 3] ] = GaugeXi[Q];   
GaugeXi[ S[20 | 30] ] = GaugeXi[bg];
GaugeXi[ U[1] ] = 1;
GaugeXi[ U[2 | 3 | 4] ] = GaugeXi[Q]


TheMass[ F[2, {1}] ] = MLE[1] = ME;
TheMass[ F[2, {2}] ] = MLE[2] = MM;
TheMass[ F[2, {3}] ] = MLE[3] = ML;
TheMass[ F[3, {1}] ] = MQU[1] = MU;
TheMass[ F[3, {2}] ] = MQU[2] = MC;
TheMass[ F[3, {3}] ] = MQU[3] = MT;
TheMass[ F[4, {1}] ] = MQD[1] = MD;
TheMass[ F[4, {2}] ] = MQD[2] = MS;
TheMass[ F[4, {3}] ] = MQD[3] = MB

TheLabel[ F[1, {1}] ] = ComposedChar["\\nu", "e"];
TheLabel[ F[1, {2}] ] = ComposedChar["\\nu", "\\mu"];
TheLabel[ F[1, {3}] ] = ComposedChar["\\nu", "\\tau"];
TheLabel[ F[2, {1}] ] = "e";
TheLabel[ F[2, {2}] ] = "\\mu";
TheLabel[ F[2, {3}] ] = "\\tau";
TheLabel[ F[3, {1}] ] = "u";
TheLabel[ F[3, {2}] ] = "c";
TheLabel[ F[3, {3}] ] = "t";
TheLabel[ F[4, {1}] ] = "d";
TheLabel[ F[4, {2}] ] = "s";
TheLabel[ F[4, {3}] ] = "b"


M$LastModelRules = {}


(* some short-hands for excluding classes of particles *)

QEDOnly = ExcludeParticles -> {F[1], V[2], V[3], S, SV, U[2], U[3], U[4]}

NoGeneration1 = ExcludeParticles -> F[_, {1}]

NoGeneration2 = ExcludeParticles -> F[_, {2}]

NoGeneration3 = ExcludeParticles -> F[_, {3}]

NoElectronHCoupling =
  ExcludeFieldPoints -> {
    FieldPoint[_][-F[2, {1}], F[2, {1}], S],
    FieldPoint[_][-F[2, {1}], F[1, {1}], S] }

NoLightFHCoupling =
  ExcludeFieldPoints -> {
    FieldPoint[_][-F[2], F[2], S],
    FieldPoint[_][-F[2], F[1], S],
    FieldPoint[_][-F[3, {1}], F[3, {1}], S],
    FieldPoint[_][-F[3, {2}], F[3, {2}], S],
    FieldPoint[_][-F[4], F[4], S],
    FieldPoint[_][-F[4], F[3, {1, ___}], S],
    FieldPoint[_][-F[4], F[3, {2, ___}], S] }

NoQuarkMixing =
  ExcludeFieldPoints -> {
    FieldPoint[_][-F[4, {1}], F[3, {2}], S[3 | 30]],
    FieldPoint[_][-F[4, {1}], F[3, {2}], V[3 | 30]],
    FieldPoint[_][-F[4, {1}], F[3, {3}], S[3 | 30]],
    FieldPoint[_][-F[4, {1}], F[3, {3}], V[3 | 30]],
    FieldPoint[_][-F[4, {2}], F[3, {1}], S[3 | 30]],
    FieldPoint[_][-F[4, {2}], F[3, {1}], V[3 | 30]],
    FieldPoint[_][-F[4, {2}], F[3, {3}], S[3 | 30]],
    FieldPoint[_][-F[4, {2}], F[3, {3}], V[3 | 30]],
    FieldPoint[_][-F[4, {3}], F[3, {1}], S[3 | 30]],
    FieldPoint[_][-F[4, {3}], F[3, {1}], V[3 | 30]],
    FieldPoint[_][-F[4, {3}], F[3, {2}], S[3 | 30]],
    FieldPoint[_][-F[4, {3}], F[3, {2}], V[3 | 30]] }

