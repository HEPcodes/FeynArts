If[ ValueQ[O$CouplingMatrices],
  M$Len = Length[M$CouplingMatrices];
  O$Len = Length[O$CouplingMatrices];

  If[ M$Len > O$Len,
    Print["M$CouplingMatrices enlarged by ", M$Len - O$Len, " couplings"] ];

  If[ M$Len < O$Len,
    Print["M$CouplingMatrices shrunk by ", O$Len - M$Len, " couplings"] ];

  M$Diff = Flatten @ Position[MapThread[SameQ,
    Take[#, Min[M$Len, O$Len]]&/@
      {M$CouplingMatrices, O$CouplingMatrices}], False];

  If[ Length[M$Diff] > 0,
    Print["M$CouplingMatrices differ at ", M$Diff] ]
]

O$CouplingMatrices = M$CouplingMatrices

Null

