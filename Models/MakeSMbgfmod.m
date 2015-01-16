(*
	MakeSMbgfmod.m
		make SMbgf.mod from SM.mod
		last modified 1 Mar 00 th
*)


<< SM.mod


Attributes[HatOn] = {Listable};
HatOn[ char_ ] := ComposedChar[char, Null, Null, "\\hat"]

Seq = Sequence

M$ClassesDescription = M$ClassesDescription /.
  (p:(S | V | SV))[n_] == li_ :>
    Seq[ p[n] == Append[li, InsertOnly -> Loop],
         p[10 n] == Append[li /.
           (PropagatorLabel -> ch_) :> (PropagatorLabel -> HatOn[ch]),
           InsertOnly -> {Internal, External}] ]


(*
dZbgfRules = {
  dZAA1 -> -2 dZe1,
  dZAZ1 -> 2 dCWsq1/(SW CW),
  dZZA1 -> 0,
  dZZZ1 -> -2 dZe1 - (CW^2 - SW^2) dCWsq1/(SW^2 CW^2),
  dZW1 -> -2 dZe1 - dCWsq1/SW^2,
  dZH1 -> -2 dZe1 - dCWsq1/SW^2 + dMWsq1/MW^2,
  dZG01 -> -2 dZe1 - dCWsq1/SW^2 + dMWsq1/MW^2,
  dZGp1 -> -2 dZe1 - dCWsq1/SW^2 + dMWsq1/MW^2,
  dSW1 -> -1/2 dCWsq1/SW
}
*)

dZbgfRules = {
  dZAA1 -> -2 dZe1,
  dZAZ1 -> -2 SW/CW (2 dZe1 + dZH1 - dMWsq1/MW^2),
  dZZA1 -> 0,
  dZZZ1 -> -2 dZe1 + (CW^2 - SW^2)/CW^2 (2 dZe1 + dZH1 - dMWsq1/MW^2),
  dZW1 -> dZH1 - dMWsq1/MW^2,
  dZG01 -> dZH1,
  dZGp1 -> dZH1,
  dSW1 -> (2 dZe1 + dZH1 - dMWsq1/MW^2) SW/2,
  dCW1 -> -(2 dZe1 + dZH1 - dMWsq1/MW^2) SW^2/(2 CW)
}


(* exactly two quantum fields *)

TwoQF = {

	(* Vbg-V-V *)

  C[ V[10], -V[3], V[3] ] == -I EL *
    { {1},
      {1/GaugeXi[Q]},
      {-1/GaugeXi[Q]},
      {0} },

  C[ -V[30], V[3], V[1] ] == -I EL *
    { {1},
      {1/GaugeXi[Q]},
      {-1/GaugeXi[Q]},
      {0} },

  C[ V[30], V[1], -V[3] ] == -I EL *
    { {1},
      {1/GaugeXi[Q]},
      {-1/GaugeXi[Q]},
      {0} },

  C[ V[20], -V[3], V[3] ] == I EL CW/SW *
    { {1},
      {1/GaugeXi[Q]},
      {-1/GaugeXi[Q]},
      {0} },

  C[ -V[30], V[3], V[2] ] == I EL CW/SW *
    { {1},
      {1/GaugeXi[Q]},
      {-1/GaugeXi[Q]},
      {0} },

  C[ V[30], V[2], -V[3] ] == I EL CW/SW *
    { {1},
      {1/GaugeXi[Q]},
      {-1/GaugeXi[Q]},
      {0} },


	(* Sbg-S-S *)

  C[ S[10], S[1], S[1] ] == -3/2 I EL MH^2/(MW SW) *
    { {1} },

  C[ S[10], S[2], S[2] ] ==
    I EL (-MH^2/(2 MW SW) - GaugeXi[Q] MW/(CW^2 SW)) *
    { {1} },

  C[ S[1], S[20], S[2] ] ==
    I EL (-MH^2/(2 MW SW) + GaugeXi[Q] MW/(CW^2 SW)) *
    { {1} },

  C[ S[10], -S[3], S[3] ] == I EL (-MH^2/(2 MW SW) - GaugeXi[Q] MW/SW) *
    { {1} },

  C[ S[1], -S[30], S[3] ] == I EL (-MH^2/(2 MW SW) + GaugeXi[Q] MW/(2 SW)) *
    { {1} },

  C[ S[1], -S[3], S[30] ] == I EL (-MH^2/(2 MW SW) + GaugeXi[Q] MW/(2 SW)) *
    { {1} },

  C[ S[2], -S[30], S[3] ] == EL MW SW GaugeXi[Q]/(2 CW^2) *
    { {1} },

  C[ S[2], -S[3], S[30] ] == -EL MW SW GaugeXi[Q]/(2 CW^2) *
    { {1} },


	(* Sbg-S-V *)

  C[ S[30], S[1], -V[3] ] == -I EL/SW *
    { {1},
      {0} },

  C[ -S[30], S[1], V[3] ] == I EL/SW *
    { {1},
      {0} },

  C[ S[10], S[3], -V[3] ] == I EL/SW *
    { {1},
      {0} },

  C[ S[10], -S[3], V[3] ] == -I EL/SW *
    { {1},
      {0} },

  C[ S[30], S[2], -V[3] ] == EL/SW *
    { {1},
      {0} },

  C[ -S[30], S[2], V[3] ] == EL/SW *
    { {1},
      {0} },

  C[ S[20], S[3], -V[3] ] == -EL/SW *
    { {1},
      {0} },

  C[ S[20], -S[3], V[3] ] == -EL/SW *
    { {1},
      {0} },

  C[ S[30], -S[3], V[2] ] == -I EL (CW^2 - SW^2)/(CW SW) *
    { {1},
      {0} },

  C[ -S[30], S[3], V[2] ] == I EL (CW^2 - SW^2)/(CW SW) *
    { {1},
      {0} },

  C[ S[30], -S[3], V[1] ] == 2 I EL *
    { {1},
      {0} },

  C[ -S[30], S[3], V[1] ] == -2 I EL *
    { {1},
      {0} },

  C[ S[20], S[1], V[2] ] == EL/(CW SW) *
    { {1},
      {0} },

  C[ S[10], S[2], V[2] ] == -EL/(CW SW) *
    { {1},
      {0} },


	(* S-Vbg-V *)

  C[ S[1], -V[30], V[3] ] == I EL MW/SW *
    { {1} },

  C[ S[1], V[30], -V[3] ] == I EL MW/SW *
    { {1} },

  C[ S[1], V[20], V[2] ] == I EL MW/(CW^2 SW) *
    { {1} },

  C[ -S[3], V[20], V[3] ] == -I EL MW/(CW SW) *
    { {1} },

  C[ S[3], V[20], -V[3] ] == -I EL MW/(CW SW) *
    { {1} },

  C[ -S[3], V[30], V[2] ] == I EL MW (CW^2 - SW^2)/(CW SW) *
    { {1} },

  C[ S[3], -V[30], V[2] ] == I EL MW (CW^2 - SW^2)/(CW SW) *
    { {1} },

  C[ -S[3], V[30], V[1] ] == -2 I EL MW *
    { {1} },

  C[ S[3], -V[30], V[1] ] == -2 I EL MW *
    { {1} },

  C[ S[2], -V[30], V[3] ] == EL MW/SW *
    { {1} },

  C[ S[2], V[30], -V[3] ] == -EL MW/SW *
    { {1} },


	(* U-U-Vbg *)

  C[ -U[4], U[2], -V[30] ] == I EL CW/SW *
    { {1},
      {-1} },

  C[ -U[3], U[2], V[30] ] == -I EL CW/SW *
    { {1},
      {-1} },

  C[ -U[4], U[1], -V[30] ] == -I EL *
    { {1},
      {-1} },

  C[ -U[3], U[1], V[30] ] == I EL *
    { {1},
      {-1} },

  C[ -U[2], U[3], -V[30] ] == -I EL CW/SW *
    { {1},
      {-1} },

  C[ -U[2], U[4], V[30] ] == I EL CW/SW *
    { {1},
      {-1} },

  C[ -U[1], U[3], -V[30] ] == I EL *
    { {1},
      {-1} },

  C[ -U[1], U[4], V[30] ] == -I EL *
    { {1},
      {-1} },

  C[ -U[4], U[4], V[10] ] == I EL *
    { {1},
      {-1} },

  C[ -U[3], U[3], V[10] ] == -I EL *
    { {1},
      {-1} },

  C[ -U[4], U[4], V[20] ] == -I EL CW/SW *
    { {1},
      {-1} },

  C[ -U[3], U[3], V[20] ] == I EL CW/SW *
    { {1},
      {-1} },


	(* Sbg-U-U *)

  C[ -S[30], -U[4], U[2] ] == I EL MW SW/CW GaugeXi[Q] *
    { {1} },

  C[ S[30], -U[3], U[2] ] == I EL MW SW/CW GaugeXi[Q] *
    { {1} },

  C[ -S[30], -U[4], U[1] ] == I EL MW GaugeXi[Q] *
    { {1} },

  C[ S[30], -U[3], U[1] ] == I EL MW GaugeXi[Q] *
    { {1} },

  C[ -S[30], -U[2], U[3] ] == I EL MW SW/CW GaugeXi[Q] *
    { {1} },

  C[ S[30], -U[2], U[4] ] == I EL MW SW/CW GaugeXi[Q] *
    { {1} },

  C[ -S[30], -U[1], U[3] ] == I EL MW GaugeXi[Q] *
    { {1} },

  C[ S[30], -U[1], U[4] ] == I EL MW GaugeXi[Q] *
    { {1} },

  C[ S[10], -U[4], U[4] ] == -I EL MW/SW GaugeXi[Q] *
    { {1} },

  C[ S[10], -U[3], U[3] ] == -I EL MW/SW GaugeXi[Q] *
    { {1} },

  C[ S[10], -U[2], U[2] ] == -I EL MW/(CW^2 SW) GaugeXi[Q] *
    { {1} },


	(* Vbg-Vbg-V-V *)

  C[ V[10], V[10], -V[3], V[3] ] == -I EL^2 *
    { {2},
      {-(1 - 1/GaugeXi[Q])},
      {-(1 - 1/GaugeXi[Q])} },

  C[ -V[30], V[30], V[1], V[1] ] == -I EL^2 *
    { {2},
      {-(1 - 1/GaugeXi[Q])},
      {-(1 - 1/GaugeXi[Q])} },

  C[ V[20], V[20], -V[3], V[3] ] == -I EL^2 CW^2/SW^2 *
    { {2},
      {-(1 - 1/GaugeXi[Q])},
      {-(1 - 1/GaugeXi[Q])} },

  C[ -V[30], V[30], V[2], V[2] ] == -I EL^2 CW^2/SW^2 *
    { {2},
      {-(1 - 1/GaugeXi[Q])},
      {-(1 - 1/GaugeXi[Q])} },

  C[ V[10], V[20], -V[3], V[3] ] == I EL^2 CW/SW *
    { {2},
      {-(1 - 1/GaugeXi[Q])},
      {-(1 - 1/GaugeXi[Q])} },

  C[ -V[30], V[30], V[1], V[2] ] == I EL^2 CW/SW *
    { {2},
      {-(1 - 1/GaugeXi[Q])},
      {-(1 - 1/GaugeXi[Q])} },

  C[ V[30], V[30], -V[3], -V[3] ] == I EL^2/SW^2 *
    { {2},
      {-(1 - 1/GaugeXi[Q])},
      {-(1 - 1/GaugeXi[Q])} },

  C[ -V[30], -V[30], V[3], V[3] ] == I EL^2/SW^2 *
    { {2},
      {-(1 - 1/GaugeXi[Q])},
      {-(1 - 1/GaugeXi[Q])} },

  C[ -V[30], V[10], V[3], V[1] ] == -I EL^2 *
    { {-1},
      {2},
      {-(1 + 1/GaugeXi[Q])} },

  C[ V[30], V[10], -V[3], V[1] ] == -I EL^2 *
    { {-1},
      {2},
      {-(1 + 1/GaugeXi[Q])} },

  C[ -V[30], V[20], V[3], V[2] ] == -I EL^2 CW^2/SW^2 *
    { {-1},
      {2},
      {-(1 + 1/GaugeXi[Q])} },

  C[ V[30], V[20], -V[3], V[2] ] == -I EL^2 CW^2/SW^2 *
    { {-1},
      {2},
      {-(1 + 1/GaugeXi[Q])} },

  C[ -V[30], V[10], V[3], V[2] ] == I EL^2 CW/SW *
    { {-1},
      {2},
      {-(1 + 1/GaugeXi[Q])} },

  C[ V[30], V[10], -V[3], V[2] ] == I EL^2 CW/SW *
    { {-1},
      {2},
      {-(1 + 1/GaugeXi[Q])} },

  C[ -V[30], V[20], V[3], V[1]] == I EL^2 CW/SW *
    { {-1},
      {2},
      {-(1 + 1/GaugeXi[Q])} },

  C[ V[30], V[20], -V[3], V[1] ] == I EL^2 CW/SW *
    { {-1},
      {2},
      {-(1 + 1/GaugeXi[Q])} },

  C[ -V[30], V[30], -V[3], V[3] ] == I EL^2/SW^2 *
    { {-1},
      {2},
      {-(1 + 1/GaugeXi[Q])} },


	(* Sbg-Sbg-S-S *)

  C[ S[1], S[1], -S[30], S[30] ] ==
    I EL^2 (-MH^2/(4 MW^2 SW^2) - GaugeXi[Q]/(2 SW^2)) *
    { {1} },

  C[ S[10], S[10], -S[3], S[3] ] == 
    I EL^2 (-MH^2/(4 MW^2 SW^2) - GaugeXi[Q]/(2 SW^2)) *
    { {1} },

  C[ S[2], S[2], -S[30], S[30] ] == 
    I EL^2 (-MH^2/(4 MW^2 SW^2) - GaugeXi[Q]/(2 SW^2)) *
    { {1} },

  C[ S[20], S[20], -S[3], S[3] ] == 
    I EL^2 (-MH^2/(4 MW^2 SW^2) - GaugeXi[Q]/(2 SW^2)) *
    { {1} },

  C[ S[10], S[1], -S[30], S[3] ] == 
    I EL^2 (-MH^2/(4 MW^2 SW^2) + GaugeXi[Q]/(4 SW^2)) *
    { {1} },

  C[ S[10], S[1], -S[3], S[30] ] == 
    I EL^2 (-MH^2/(4 MW^2 SW^2) + GaugeXi[Q]/(4 SW^2)) *
    { {1} },

  C[ S[20], S[2], -S[30], S[3] ] == 
    I EL^2 (-MH^2/(4 MW^2 SW^2) + GaugeXi[Q]/(4 SW^2)) *
    { {1} },

  C[ S[20], S[2], -S[3], S[30] ] == 
    I EL^2 (-MH^2/(4 MW^2 SW^2) + GaugeXi[Q]/(4 SW^2)) *
    { {1} },

  C[ S[10], S[2], -S[30], S[3] ] == EL^2 GaugeXi[Q]/(4 CW^2) *
    { {1} },

  C[ S[1], S[20], -S[30], S[3] ] == -EL^2 GaugeXi[Q]/(4 CW^2) *
    { {1} },

  C[ S[10], S[2], -S[3], S[30] ] == -EL^2 GaugeXi[Q]/(4 CW^2) *
    { {1} },

  C[ S[1], S[20], -S[3], S[30] ] == EL^2 GaugeXi[Q]/(4 CW^2) *
    { {1} },

  C[ S[1], S[1], S[20], S[20] ] == 
    I EL^2 (-MH^2/(4 MW^2 SW^2) - GaugeXi[Q]/(2 CW^2 SW^2)) *
    { {1} },

  C[ S[10], S[10], S[2], S[2] ] == 
    I EL^2 (-MH^2/(4 MW^2 SW^2) - GaugeXi[Q]/(2 CW^2 SW^2)) *
    { {1} },

  C[ S[10], S[1], S[20], S[2] ] == 
    I EL^2 (-MH^2/(4 MW^2 SW^2) + GaugeXi[Q]/(4 CW^2 SW^2)) *
    { {1} },

  C[ -S[30], -S[30], S[3], S[3] ] == 
    I EL^2 (-MH^2/(2 MW^2 SW^2) + GaugeXi[Q]/(2 CW^2 SW^2)) *
    { {1} },

  C[ S[30], S[30], -S[3], -S[3] ] == 
    I EL^2 (-MH^2/(2 MW^2 SW^2) + GaugeXi[Q]/(2 CW^2 SW^2)) *
    { {1} },

  C[ S[30], -S[30], S[3], -S[3] ] == 
    I EL^2 (-MH^2/(2 MW^2 SW^2) - GaugeXi[Q]/(4 CW^2 SW^2)) *
    { {1} },

  C[ S[10], S[10], S[1], S[1] ] == -3/4 I EL^2 MH^2/(MW^2 SW^2) *
    { {1} },

  C[ S[20], S[20], S[2], S[2] ] == -3/4 I EL^2 MH^2/(MW^2 SW^2) *
    { {1} },


	(* Sbg-S-Vbg-V *)

  C[ -S[30], S[3], V[10], V[1] ] == 2 I EL^2 *
    { {1} },

  C[ -S[3], S[30], V[10], V[1] ] == 2 I EL^2 *
    { {1} },

  C[ -S[30], S[3], V[10], V[2] ] == -I EL^2 (CW^2 - SW^2)/(CW SW) *
    { {1} },

  C[ -S[3], S[30], V[10], V[2] ] == -I EL^2 (CW^2 - SW^2)/(CW SW) *
    { {1} },

  C[ -S[30], S[3], V[1], V[20] ] == -I EL^2 (CW^2 - SW^2)/(CW SW) *
    { {1} },

  C[ -S[3], S[30], V[1], V[20] ] == -I EL^2 (CW^2 - SW^2)/(CW SW) *
    { {1} },

  C[ -S[30], S[3], V[20], V[2] ] == I/2 EL^2 (CW^2 - SW^2)^2/(CW^2 SW^2) *
    { {1} },

  C[ -S[3], S[30], V[20], V[2] ] == I/2 EL^2 (CW^2 - SW^2)^2/(CW^2 SW^2) *
    { {1} },

  C[ S[10], S[1], V[20], V[2] ] == I/2 EL^2/(CW^2 SW^2) *
    { {1} },

  C[ S[20], S[2], V[20], V[2] ] == I/2 EL^2/(CW^2 SW^2) *
    { {1} },

  C[ S[10], S[1], -V[30], V[3] ] == I/2 EL^2/SW^2 *
    { {1} },

  C[ S[10], S[1], -V[3], V[30] ] == I/2 EL^2/SW^2 *
    { {1} },

  C[ S[20], S[2], -V[30], V[3] ] == I/2 EL^2/SW^2 *
    { {1} },

  C[ S[20], S[2], -V[3], V[30] ] == I/2 EL^2/SW^2 *
    { {1} },

  C[ S[1], S[30], V[10], -V[3] ] == -I EL^2/SW *
    { {1} },

  C[ S[1], -S[30], V[10], V[3] ] == -I EL^2/SW *
    { {1} },

  C[ S[10], S[3], V[1], -V[30] ] == -I EL^2/SW *
    { {1} },

  C[ S[10], -S[3], V[1], V[30] ] == -I EL^2/SW *
    { {1} },

  C[ S[2], S[30], V[10], -V[3] ] == EL^2/SW *
    { {1} },

  C[ S[2], -S[30], V[10], V[3] ] == -EL^2/SW *
    { {1} },

  C[ S[20], S[3], V[1], -V[30] ] == EL^2/SW *
    { {1} },

  C[ S[20], -S[3], V[1], V[30] ] == -EL^2/SW *
    { {1} },

  C[ S[10], S[3], V[20], -V[3] ] == -I/2 EL^2/(CW SW^2) *
    { {1} },

  C[ S[10], -S[3], V[20], V[3] ] == -I/2 EL^2/(CW SW^2) *
    { {1} },

  C[ S[1], S[30], V[2], -V[30] ] == -I/2 EL^2/(CW SW^2) *
    { {1} },

  C[ S[1], -S[30], V[2], V[30] ] == -I/2 EL^2/(CW SW^2) *
    { {1} },

  C[ S[1], S[30], V[20], -V[3] ] == I/2 EL^2 (CW^2 - SW^2)/(CW SW^2) *
    { {1} },

  C[ S[1], -S[30], V[20], V[3] ] == I/2 EL^2 (CW^2 - SW^2)/(CW SW^2) *
    { {1} },

  C[ S[10], S[3], V[2], -V[30] ] == I/2 EL^2 (CW^2 - SW^2)/(CW SW^2) *
    { {1} },

  C[ S[10], -S[3], V[2], V[30] ] == I/2 EL^2 (CW^2 - SW^2)/(CW SW^2) *
    { {1} },

  C[ S[20], S[3], V[20], -V[3] ] == EL^2/(2 CW SW^2) *
    { {1} },

  C[ S[20], -S[3], V[20], V[3] ] == -EL^2/(2 CW SW^2) *
    { {1} },

  C[ S[2], S[30], V[2], -V[30] ] == EL^2/(2 CW SW^2) *
    { {1} },

  C[ S[2], -S[30], V[2], V[30] ] == -EL^2/(2 CW SW^2) *
    { {1} },

  C[ S[2], S[30], V[20], -V[3] ] == -EL^2 (CW^2 - SW^2)/(2 CW SW^2) *
    { {1} },

  C[ S[2], -S[30], V[20], V[3] ] == EL^2 (CW^2 - SW^2)/(2 CW SW^2) *
    { {1} },

  C[ S[20], S[3], V[2], -V[30] ] == -EL^2 (CW^2 - SW^2)/(2 CW SW^2) *
    { {1} },

  C[ S[20], -S[3], V[2], V[30] ] == EL^2 (CW^2 - SW^2)/(2 CW SW^2) *
    { {1} },

  C[ -S[3], S[30], -V[30], V[3] ] == I EL^2/SW^2 *
    { {1} },

  C[ -S[30], S[3], -V[3], V[30] ] == I EL^2/SW^2 *
    { {1} },

  C[ S[10], S[2], -V[30], V[3] ] == EL^2/(2 SW^2) *
    { {1} },

  C[ S[10], S[2], -V[3], V[30] ] == -EL^2/(2 SW^2) *
    { {1} },

  C[ S[1], S[20], -V[30], V[3] ] == -EL^2/(2 SW^2) *
    { {1} },

  C[ S[1], S[20], -V[3], V[30] ] == EL^2/(2 SW^2) *
    { {1} },


	(* U-U-Vbg-V *)

  C[ -U[4], U[4], V[10], V[1] ] == I EL^2 *
    { {1} },

  C[ -U[3], U[3], V[10], V[1] ] == I EL^2 *
    { {1} },

  C[ -U[4], U[4], V[10], V[2] ] == -I EL^2 CW/SW *
    { {1} },

  C[ -U[3], U[3], V[10], V[2] ] == -I EL^2 CW/SW *
    { {1} },

  C[ -U[4], U[4], V[20], V[1] ] == -I EL^2 CW/SW *
    { {1} },

  C[ -U[3], U[3], V[20], V[1] ] == -I EL^2 CW/SW *
    { {1} },

  C[ -U[4], U[4], V[20], V[2] ] == I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[3], U[3], V[20], V[2] ] == I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[4], U[1], V[10], -V[3] ] == -I EL^2 *
    { {1} },

  C[ -U[3], U[1], V[10], V[3] ] == -I EL^2 *
    { {1} },

  C[ -U[4], U[1], V[20], -V[3] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[3], U[1], V[20], V[3] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[4], U[2], V[10], -V[3] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[3], U[2], V[10], V[3] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[4], U[2], V[20], -V[3] ] == -I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[3], U[2], V[20], V[3] ] == -I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[1], U[3], -V[30], V[1] ] == -I EL^2 *
    { {1} },

  C[ -U[1], U[4], V[30], V[1] ] == -I EL^2 *
    { {1} },

  C[ -U[1], U[3], -V[30], V[2] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[1], U[4], V[30], V[2] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[2], U[3], -V[30], V[1] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[2], U[4], V[30], V[1] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[2], U[3], -V[30], V[2] ] == -I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[2], U[4], V[30], V[2] ] == -I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[1], U[1], -V[30], V[3] ] == I EL^2 *
    { {1} },

  C[ -U[1], U[1], V[30], -V[3] ] == I EL^2 *
    { {1} },

  C[ -U[2], U[1], -V[30], V[3] ] == -I EL^2 CW/SW *
    { {1} },

  C[ -U[2], U[1], V[30], -V[3] ] == -I EL^2 CW/SW *
    { {1} },

  C[ -U[1], U[2], -V[30], V[3] ] == -I EL^2 CW/SW *
    { {1} },

  C[ -U[1], U[2], V[30], -V[3] ] == -I EL^2 CW/SW *
    { {1} },

  C[ -U[2], U[2], -V[30], V[3] ] == I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[2], U[2], V[30], -V[3] ] == I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[4], U[4], -V[30], V[3] ] == I EL^2/SW^2 *
    { {1} },

  C[ -U[3], U[3], V[30], -V[3] ] == I EL^2/SW^2 *
    { {1} },

  C[ -U[4], U[3], -V[30], -V[3] ] == -I EL^2/SW^2 *
    { {1} },

  C[ -U[3], U[4], V[30], V[3] ] == -I EL^2/SW^2 *
    { {1} },


	(* U-U-Vbg-Vbg *)

  C[ -U[4], U[4], V[10], V[10] ] == 2 I EL^2 *
    { {1} },

  C[ -U[3], U[3], V[10], V[10] ] == 2 I EL^2 *
    { {1} },

  C[ -U[4], U[4], V[10], V[20] ] == -2 I EL^2 CW/SW *
    { {1} },

  C[ -U[3], U[3], V[10], V[20] ] == -2 I EL^2 CW/SW *
    { {1} },

  C[ -U[4], U[4], V[20], V[10] ] == -2 I EL^2 CW/SW *
    { {1} },

  C[ -U[3], U[3], V[20], V[10] ] == -2 I EL^2 CW/SW *
    { {1} },

  C[ -U[4], U[4], V[20], V[20] ] == 2 I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[3], U[3], V[20], V[20] ] == 2 I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[4], U[1], V[10], -V[30] ] == -I EL^2 *
    { {1} },

  C[ -U[3], U[1], V[10], V[30] ] == -I EL^2 *
    { {1} },

  C[ -U[4], U[1], V[20], -V[30] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[3], U[1], V[20], V[30] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[4], U[2], V[10], -V[30] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[3], U[2], V[10], V[30] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[4], U[2], V[20], -V[30] ] == -I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[3], U[2], V[20], V[30] ] == -I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[1], U[3], -V[30], V[10] ] == -I EL^2 *
    { {1} },

  C[ -U[1], U[4], V[30], V[10] ] == -I EL^2 *
    { {1} },

  C[ -U[1], U[3], -V[30], V[20] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[1], U[4], V[30], V[20] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[2], U[3], -V[30], V[10] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[2], U[4], V[30], V[10] ] == I EL^2 CW/SW *
    { {1} },

  C[ -U[2], U[3], -V[30], V[20] ] == -I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[2], U[4], V[30], V[20] ] == -I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[1], U[1], V[30], -V[30] ] == 2 I EL^2 *
    { {1} },

  C[ -U[2], U[1], V[30], -V[30] ] == -2 I EL^2 CW/SW *
    { {1} },

  C[ -U[1], U[2], V[30], -V[30] ] == -2 I EL^2 CW/SW *
    { {1} },

  C[ -U[2], U[2], V[30], -V[30] ] == 2 I EL^2 CW^2/SW^2 *
    { {1} },

  C[ -U[4], U[4], -V[30], V[30] ] == I EL^2/SW^2 *
    { {1} },

  C[ -U[3], U[3], V[30], -V[30] ] == I EL^2/SW^2 *
    { {1} },

  C[ -U[4], U[3], -V[30], -V[30] ] == -2 I EL^2/SW^2 *
    { {1} },

  C[ -U[3], U[4], V[30], V[30] ] == -2 I EL^2/SW^2 *
    { {1} },


	(* Sbg-S-U-U *)

  C[ -S[30], S[3], -U[4], U[4] ] == -I/2 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ -S[3], S[30], -U[3], U[3] ] == -I/2 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[10], S[1], -U[4], U[4] ] == -I/4 EL^2 GaugeXi[Q]/SW^2 * 
    { {1} },

  C[ S[10], S[1], -U[3], U[3] ] == -I/4 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[20], S[2], -U[4], U[4] ] == -I/4 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[20], S[2], -U[3], U[3] ] == -I/4 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[10], S[1], -U[2], U[2] ] == -I/4 EL^2 GaugeXi[Q]/(CW^2 SW^2) *
    { {1} },

  C[ S[20], S[2], -U[2], U[2] ] == -I/4 EL^2 GaugeXi[Q]/(CW^2 SW^2) *
    { {1} },

  C[ S[10], S[2], -U[4], U[4] ] == I/4 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[10], S[2], -U[3], U[3] ] == -I/4 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[1], S[20], -U[4], U[4] ] == -I/4 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[1], S[20], -U[3], U[3] ] == I/4 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[30], -S[3], -U[2], U[2] ] ==
    I/4 EL^2 (CW^2 - SW^2)^2 GaugeXi[Q]/(CW^2 SW^2) *
    { {1} },

  C[ S[3], -S[30], -U[2], U[2] ] == 
    I/4 EL^2 (CW^2 - SW^2)^2 GaugeXi[Q]/(CW^2 SW^2) *
    { {1} },

  C[ S[3], -S[30], -U[2], U[1] ] == 
    I/2 EL^2 (CW^2 - SW^2) GaugeXi[Q]/(CW SW) *
    { {1} },

  C[ S[30], -S[3], -U[2], U[1] ] == 
    I/2 EL^2 (CW^2 - SW^2) GaugeXi[Q]/(CW SW) *
    { {1} },

  C[ S[3], -S[30], -U[1], U[2] ] == 
    I/2 EL^2 (CW^2 - SW^2) GaugeXi[Q]/(CW SW) *
    { {1} },

  C[ S[30], -S[3], -U[1], U[2] ] == 
    I/2 EL^2 (CW^2 - SW^2) GaugeXi[Q]/(CW SW) *
    { {1} },

  C[ S[3], -S[30], -U[1], U[1] ] == -I EL^2 GaugeXi[Q] *
    { {1} },

  C[ S[30], -S[3], -U[1], U[1] ] == -I EL^2 GaugeXi[Q] *
    { {1} },

  C[ -S[30], S[1], -U[4], U[2] ] == I/4 EL^2 GaugeXi[Q]/(CW SW^2) *
    { {1} },

  C[ S[30], S[1], -U[3], U[2] ] == I/4 EL^2 GaugeXi[Q]/(CW SW^2) *
    { {1} },

  C[ -S[3], S[10], -U[2], U[3] ] == I/4 EL^2 GaugeXi[Q]/(CW SW^2) *
    { {1} },

  C[ S[3], S[10], -U[2], U[4] ] == I/4 EL^2 GaugeXi[Q]/(CW SW^2) *
    { {1} },

  C[ -S[3], S[10], -U[4], U[2] ] == 
    -I/4 EL^2 (CW^2 - SW^2) GaugeXi[Q]/(CW SW^2) *
    { {1} },

  C[ S[3], S[10], -U[3], U[2] ] == 
    -I/4 EL^2 (CW^2 - SW^2) GaugeXi[Q]/(CW SW^2) *
    { {1} },

  C[ -S[30], S[1], -U[2], U[3] ] == 
    -I/4 EL^2 (CW^2 - SW^2) GaugeXi[Q]/(CW SW^2) *
    { {1} },

  C[ S[30], S[1], -U[2], U[4] ] == 
    I/4 EL^2 (CW^2 - SW^2) GaugeXi[Q]/(CW SW^2) *
    { {1} },

  C[ -S[30], S[1], -U[4], U[1] ] == I/2 EL^2 GaugeXi[Q]/SW *
    { {1} },

  C[ S[30], S[1], -U[3], U[1] ] == I/2 EL^2 GaugeXi[Q]/SW *
    { {1} },

  C[ -S[3], S[10], -U[1], U[3] ] == I/2 EL^2 GaugeXi[Q]/SW *
    { {1} },

  C[ S[3], S[10], -U[1], U[4] ] == I/2 EL^2 GaugeXi[Q]/SW *
    { {1} },

  C[ -S[30], S[2], -U[4], U[2] ] == EL^2 GaugeXi[Q]/(4 CW SW^2) *
    { {1} },

  C[ S[30], S[2], -U[3], U[2] ] == -EL^2 GaugeXi[Q]/(4 CW SW^2) *
    { {1} },

  C[ -S[3], S[20], -U[2], U[3] ] == EL^2 GaugeXi[Q]/(4 CW SW^2) *
    { {1} },

  C[ S[3], S[20], -U[2], U[4] ] == -EL^2 GaugeXi[Q]/(4 CW SW^2) *
    { {1} },

  C[ -S[3], S[20], -U[4], U[2] ] == 
    -EL^2 (CW^2 - SW^2) GaugeXi[Q]/(4 CW SW^2) *
    { {1} },

  C[ S[3], S[20], -U[3], U[2] ] == 
    EL^2 (CW^2 - SW^2) GaugeXi[Q]/(4 CW SW^2) *
    { {1} },

  C[ -S[30], S[2], -U[2], U[3] ] == 
    -EL^2 (CW^2 - SW^2) GaugeXi[Q]/(4 CW SW^2) *
    { {1} },

  C[ S[30], S[2], -U[2], U[4] ] == 
    EL^2 (CW^2 - SW^2) GaugeXi[Q]/(4 CW SW^2) *
    { {1} },

  C[ -S[3], S[20], -U[4], U[1] ] == EL^2 GaugeXi[Q]/(2 SW) *
    { {1} },

  C[ S[3], S[20], -U[3], U[1] ] == -EL^2 GaugeXi[Q]/(2 SW) *
    { {1} },

  C[ -S[30], S[2], -U[1], U[3] ] == EL^2 GaugeXi[Q]/(2 SW) *
    { {1} },

  C[ S[30], S[2], -U[1], U[4] ] == -EL^2 GaugeXi[Q]/(2 SW) *
    { {1} },


	(* Sbg-Sbg-U-U *)

  C[ -S[30], S[30], -U[4], U[4] ] == -I/2 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ -S[30], S[30], -U[3], U[3] ] == -I/2 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[10], S[10], -U[4], U[4] ] == -I/2 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[10], S[10], -U[3], U[3] ] == -I/2 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[20], S[20], -U[4], U[4] ] == -I/2 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[20], S[20], -U[3], U[3] ] == -I/2 EL^2 GaugeXi[Q]/SW^2 *
    { {1} },

  C[ S[10], S[10], -U[2], U[2] ] == -I/2 EL^2 GaugeXi[Q]/(CW^2 SW^2) *
    { {1} },

  C[ S[20], S[20], -U[2], U[2] ] == -I/2 EL^2 GaugeXi[Q]/(CW^2 SW^2) *
    { {1} },

  C[ S[30], -S[30], -U[2], U[2] ] == 
    I/2 EL^2 (CW^2 - SW^2)^2 GaugeXi[Q]/(CW^2 SW^2) *
    { {1} },

  C[ S[30], -S[30], -U[2], U[1] ] == 
    I EL^2 (CW^2 - SW^2) GaugeXi[Q]/(CW SW) *
    { {1} },

  C[ S[30], -S[30], -U[1], U[2] ] == 
    I EL^2 (CW^2 - SW^2) GaugeXi[Q]/(CW SW) *
    { {1} },

  C[ S[30], -S[30], -U[1], U[1] ] == -2 I EL^2 GaugeXi[Q] *
    { {1} },

  C[ -S[30], S[10], -U[4], U[2] ] == I/2 EL^2 GaugeXi[Q]/CW *
    { {1} },

  C[ S[30], S[10], -U[3], U[2] ] == I/2 EL^2 GaugeXi[Q]/CW *
    { {1} },

  C[ -S[30], S[10], -U[2], U[3] ] == I/2 EL^2 GaugeXi[Q]/CW *
    { {1} },

  C[ S[30], S[10], -U[2], U[4] ] == I/2 EL^2 GaugeXi[Q]/CW *
    { {1} },

  C[ -S[30], S[10], -U[4], U[1] ] == I/2 EL^2 GaugeXi[Q]/SW *
    { {1} },

  C[ S[30], S[10], -U[3], U[1] ] == I/2 EL^2 GaugeXi[Q]/SW *
    { {1} },

  C[ -S[30], S[10], -U[1], U[3] ] == I/2 EL^2 GaugeXi[Q]/SW *
    { {1} },

  C[ S[30], S[10], -U[1], U[4] ] == I/2 EL^2 GaugeXi[Q]/SW *
    { {1} },

  C[ -S[30], S[20], -U[4], U[2] ] == EL^2 GaugeXi[Q]/(2 CW) *
    { {1} },

  C[ S[30], S[20], -U[3], U[2] ] == -EL^2 GaugeXi[Q]/(2 CW) *
    { {1} },

  C[ -S[30], S[20], -U[2], U[3] ] == EL^2 GaugeXi[Q]/(2 CW) *
    { {1} },

  C[ S[30], S[20], -U[2], U[4] ] == -EL^2 GaugeXi[Q]/(2 CW) *
    { {1} },

  C[ -S[30], S[20], -U[4], U[1] ] == EL^2 GaugeXi[Q]/(2 SW) *
    { {1} },

  C[ S[30], S[20], -U[3], U[1] ] == -EL^2*GaugeXi[Q]/(2 SW) *
    { {1} },

  C[ -S[30], S[20], -U[1], U[3] ] == EL^2 GaugeXi[Q]/(2 SW) *
    { {1} },

  C[ S[30], S[20], -U[1], U[4] ] == -EL^2 GaugeXi[Q]/(2 SW) *
    { {1} }
}


PropCTs = {

	(* Vbg-Vbg *)

  C[ -V[30], V[30] ] == I *
    { {0, dZW1},
      {0, MW^2 dZW1 + dMWsq1},
      {0, -dZW1} },

  C[ V[20], V[20] ] == I *
    { {0, dZZZ1},
      {0, MZ^2 dZZZ1 + dMZsq1},
      {0, -dZZZ1} },

  C[ V[10], V[10] ] == I *
    { {0, dZAA1},
      {0, 0},
      {0, -dZAA1} },

  C[ V[10], V[20] ] == I *
    { {0, dZAZ1/2},
      {0, 0},
      {0, -dZAZ1/2} },


	(* Sbg-Vbg *)

  C[ S[30], -V[30] ] == I *
    { {0, 0},
      {0, MW dZH1} },

  C[ -S[30], V[30] ] == I *
    { {0, 0},
      {0, -MW dZH1} },

  C[ S[20], V[20] ] == I *
    { {0, 0},
      {0, I MZ dZH1} },


	(* Sbg-Sbg *)

  C[ S[10], S[10] ] == I *
    { {0, -dZH1},
      {0, -MH^2 dZH1 - dMHsq1} },

  C[ S[20], S[20] ] == I *
    { {0, -dZH1},
      {0, EL dTad1/(2 SW MW)} },

  C[ S[30], -S[30] ] == I *
    { {0, -dZH1},
      {0, EL dTad1/(2 SW MW)} }
}


FRSimp[ fr_ ] :=
  Simplify[ fr /. SW^2 -> 1 - CW^2 /. SW^4 -> Expand[(1 - CW^2)^2] ] /.
    -1 + 2 CW^2 -> CW^2 - SW^2 /. 1 - 2 CW^2 -> -(CW^2 - SW^2) /.
    -1 + CW^2 -> -SW^2 /. CW^2 + SW^2 -> 1


RemoveSuperfluous[ cpl_ ] :=
Block[ {cmp},
  cmp = Sort/@ cpl;
  Delete[cpl, Union[Flatten[Rest/@ (Position[cmp, #, 1]&)/@ cmp, 1]]]
]


SMcoupl[ (c:C[ s1_. V[i_], s2_. V[j_], s3_. V[k_] ]) == {a_} ] :=
Block[ {zero = Table[0, {Length[a]}]},
  SMcoupl[ c == {a, zero, zero, zero} ]
]

SMcoupl[ (c:C[ s1_. S[i_], s2_. S[j_], s3_. V[k_] ]) == {a_} ] :=
  SMcoupl[ c == {a, -a} ]

SMcoupl[ c_ == {coup__List} ] := c == (Take[#, 1]&)/@ {coup}


BGcoupl[ (c:C[ s1_. V[i_], s2_. V[j_], s3_. V[k_] ]) == {a_} ] :=
Block[ {zero = Table[0, {Length[a]}]},
  BGcoupl[ c == {a, zero, zero, zero} ]
]

BGcoupl[ (c:C[ s1_. S[i_], s2_. S[j_], s3_. V[k_] ]) == {a_} ] :=
  BGcoupl[ c == {a, -a} ]

BGcoupl[ C[ s1_. (fi1:S | V)[i_], s2_. (fi2:S | V)[j_] ] == a_ ] :=
  Sequence[]

BGcoupl[ C[ s1_. (fi1:S | V)[i_],
            s2_. (fi2:S | V)[j_],
            s3_. (fi3:S | V)[k_] ] == a_ ] :=
Block[ {cpl},
  cpl = {
    C[s1 fi1[10 i], s2 fi2[10 j], s3 fi3[10 k]],
    C[s1 fi1[10 i], s2 fi2[10 j], s3 fi3[k]],
    C[s1 fi1[10 i], s2 fi2[j], s3 fi3[10 k]],
    C[s1 fi1[i], s2 fi2[10 j], s3 fi3[10 k]] };
  If[ {fi1, fi2, fi3} === {S, S, V},
    AppendTo[cpl, C[s1 fi1[i], s2 fi2[j], s3 fi3[10 k]]] ];
  If[ {fi1, fi2, fi3} === {S, V, V},
    AppendTo[cpl, C[s1 fi1[10 i], s2 fi2[j], s3 fi3[k]]] ];
  Sequence@@ (BGcoupl[# == a]&)/@ RemoveSuperfluous[cpl]
] /; i < 10 && j < 10 && k < 10

BGcoupl[ C[ s1_. (fi1:S | V)[i_],
            s2_. (fi2:S | V)[j_],
            s3_. (fi3:S | V)[k_],
            s4_. (fi4:S | V)[m_] ] == a_ ] :=
Block[ {cpl},
  cpl = {
    C[s1 fi1[10 i], s2 fi2[10 j], s3 fi3[10 k], s4 fi4[10 m]],
    C[s1 fi1[10 i], s2 fi2[10 j], s3 fi3[10 k], s4 fi4[m]],
    C[s1 fi1[10 i], s2 fi2[10 j], s3 fi3[k], s4 fi4[10 m]],
    C[s1 fi1[10 i], s2 fi2[j], s3 fi3[10 k], s4 fi4[10 m]],
    C[s1 fi1[i], s2 fi2[10 j], s3 fi3[10 k], s4 fi4[10 m]],
    C[s1 fi1[10 i], s2 fi2[j], s3 fi3[k], s4 fi4[m]],
    C[s1 fi1[i], s2 fi2[10 j], s3 fi3[k], s4 fi4[m]],
    C[s1 fi1[i], s2 fi2[j], s3 fi3[10 k], s4 fi4[m]],
    C[s1 fi1[i], s2 fi2[j], s3 fi3[k], s4 fi4[10 m]] };
  If[ {fi1, fi2, fi3, fi4} === {S, S, V, V},
    cpl = Join[cpl,
      { C[s1 fi1[i], s2 fi2[j], s3 fi3[10 k], s4 fi4[10 m]],
        C[s1 fi1[10 i], s2 fi2[10 j], s3 fi3[k], s4 fi4[m]] }] ];
  Sequence@@ (BGcoupl[# == a]&)/@ RemoveSuperfluous[cpl]
] /; i < 10 && j < 10 && k < 10 && m < 10

BGcoupl[ C[ s1_. F[i__], s2_. F[j__], s3_. (fi3:S | V)[k_] ] == a_ ] :=
  BGcoupl[ C[s1 F[i], s2 F[j], s3 fi3[10 k]] == a ] /; k < 10

BGcoupl[ a_ ] := a


M$CouplingMatrices = DeleteCases[
  Join[
    SMcoupl/@ M$CouplingMatrices,
    BGcoupl/@ FRSimp[
      Select[M$CouplingMatrices, FreeQ[#[[1]], U]&] /. dZbgfRules ],
    PropCTs,
    TwoQF ] //. li:{{__, 0}..} :> (Drop[#, -1]&)/@ li,
  _ == {{0}..} ]


Splice["SMbgf.mmod", FormatType -> InputForm]

