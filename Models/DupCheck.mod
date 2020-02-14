Attributes[Cset] = {Orderless}

DupCheck[cs_Cset, c_ == rhs_] := cs = c == rhs

DupCheck[c_ == rhs_, c1_ == rhs_] := Print["Duplicate couplings ", {c, c1}];

DupCheck[c_ == rhs_, c1_ == rhs1_] := Print["MISMATCHING duplicate couplings ", {c, c1}];

DupCheck[Cset@@ #[[1]], #]&/@ M$CouplingMatrices;

