(* ************************************************************* *)
(*                                                               *)
(*                          model.QC                             *)
(*                                                               *)
(* ************************************************************* *)

PropList[QC]=
{
 Prop[in][ F[-I],F[I],mom_ ] == 
           PV[ NonCommutative[ DiracSlash[ mom ] + MQ ]  
	       I PropagatorDenominator[ mom , MQ ] ],
 Prop[ex][ F[I],mom_ ]  == PV[ NonCommutative[ QuarkSpinor[ mom,MQ] ] ],
 Prop[ex][ F[-I],mom_ ] == PV[ NonCommutative[ QuarkSpinor[ -mom,MQ] ] ],
 Prop[in][ G[1,li1_,gi1_],G[1,li2_,gi2_],mom_] == 
          PV[    I  PropagatorDenominator[ mom , 0 ]
		   SU3Delta[ gi1,gi2 ]
                   ( - MetricTensor[li1, li2]
                   + (1-1/GaugeXi[G]) FourVector[ mom, li1 ]
                     FourVector[ mom, li2 ]
                     PropagatorDenominator[ mom,0 ] ) ],
 Prop[ex][ G[1,li2_,gi2_],mom_] == 
	   PV[  PolarizationVector[ mom, li2 , gi2 ] ],
 Prop[in][ U[-5,gi1_],U[5,gi2_],mom_] == 
          PV[    I  PropagatorDenominator[ mom , 0 ]
		   SU3Delta[ gi1,gi2 ]   ]
}

LineSpec[ F[I] ] = {straight,forward,"q"};
LineSpec[ F[-I] ] = {straight,backward,"q"};
LineSpec[ G[1] ] = {cycloid,none,"g"};
LineSpec[ U[5] ] = {dotted,forward,Sub["u","g"]}
LineSpec[ U[-5] ] = {dotted,backward,Sub["u","g"]}

CoupList[QC]=
{
 Coup[{G[1,li1_,gi1_],mom1_},{F[-I],mom2_},{F[I],mom3_}]  == 
   PV[ NonCommutative[DiracMatrix[li1] GellMannMatrix[gi1]] ( I*GS/2) ], 
 Coup[{G[1,li1_,gi1_],mom1_},{G[1,li2_,gi2_],mom2_},{G[1,li3_,gi3_],mom3_}]  == 
   PV[ GS SU3F[gi1,gi2,gi3](MetricTensor[li1,li2] FourVector[mom1-mom2,li3]
                            +MetricTensor[li2,li3] FourVector[mom2-mom3,li1]
                            +MetricTensor[li3,li1] FourVector[mom3-mom1,li2]) ],
 Coup[{G[1,li1_,gi1_],mom1_},{G[1,li2_,gi2_],mom2_},
      {G[1,li3_,gi3_],mom3_},{G[1,li4_,gi4_],mom4_}]  == 
   PV[ - I GS^2 (SU3F[gi1,gi2,dummy] SU3F[gi3,gi4,dummy]
	      (MetricTensor[li1,li3] MetricTensor[li2,li4]
	      -MetricTensor[li1,li4] MetricTensor[li2,li3])
             +SU3F[gi1,gi3,dummy] SU3F[gi2,gi4,dummy]
	      (MetricTensor[li1,li2] MetricTensor[li4,li3]
	      -MetricTensor[li1,li4] MetricTensor[li2,li3])
             +SU3F[gi1,gi4,dummy] SU3F[gi3,gi2,dummy]
	      (MetricTensor[li1,li3] MetricTensor[li2,li4]
	      -MetricTensor[li1,li2] MetricTensor[li3,li4]) )  ],
 Coup[{G[1,li1_,gi1_],mom1_},{U[-5,gi2_],mom2_},{U[5,gi3_],mom3_}]  == 
   PV[ -GS FourVector[mom2,li1]  SU3F[gi1,gi2,gi3]  ] 
}

(**)

