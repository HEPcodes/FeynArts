(*
	TeXLabels.m
		Paint and DrawLine extension for TeX-style labels
		last change: 1 Dec 97 TH
*)

Begin["Paint`Private`"]

MakeGraphHeader[ Topology[ inserted__ ] ] := {}

End[]

Begin["Utilities`DrawLine`Private`"]

GetLineSpec[ li_List ] :=
Block[ {aa = GetLineSpec/@ li},
  { aa[[1,1]], none, SymbList@@ Flatten[{#[[3]], ", " }&/@
   Sort[ aa, OrderedQ[ {#1[[3]],#2[[3]]} ]& ]]}
]

Unprotect[Greek];
Greek["c"] = "\\chi";
Greek["f"] = "\\phi";
Greek["n"] = "\\nu";
Greek["t"] = "\\tau";
Greek["j"] = "\\varphi";
Greek["g"] = "\\gamma";
Greek["m"] = "\\mu";
Protect[Greek];

Unprotect[Sub];
Sub[ a_String, "B" ] := "\\hat "<>a;		(* bg fields *)
Sub[ a_String, b_String ] := a<>"_"<>b;
Protect[Sub];

SymbList[ a___, x_, ", ", c___, x_, b___ ] := SymbList[a,c,x,b]

SymbList[ a___, ", " ] := SymbList[a]

SymbList[ a___, "u_+", ", ", "u_-", b___] := SymbList[a,"u_\\pm",b]

SymbList[ a___, "u_-", ", ", "u_+", b___] := SymbList[a,"u_\\pm",b]

SymbList[ a___, s1_String, s2_String, b___] := SymbList[a,s1<>s2,b]

(*
SymbList[ "d, e, u" ] = "f"

SymbList[ "d, e, \\nu_e, u" ] = "f"
*)

SymbList[a_] := a

SymbList[a__] := {a}

End[]

