(*
	MSSMCT.mod
		Classes model file for the renormalized MSSM
                by Thomas Fritzsche, Thomas Hahn, Sven Heinemeyer, 
                Heidi Rzehak and Christian Schappacher		
		based on the Feynman rules of the MSSM by Arnd Kraft
		last modified 15 Apr 2016 by cs

History:
May 2001: MSSM.mod created by Thomas Hahn.
May 2001: MSSMQCD.mod created by Christian Schappacher.
Oct 2001: ModelMaker: SM-counterterms included by Thomas Fritzsche.
Oct 2002: ModelMaker: MSSMQCD-couplings included by Thomas Fritzsche.
Mar 2005: ModelMaker: additional renormalization constants included 
          by Thomas Fritzsche.
Apr 2005: ModelMaker: additional MSSM-counterterms included 
          by Thomas Fritzsche.
Feb 2008: bugfix for some complex RenConst by Christian Schappacher.
Apr 2008: squark sector renormalization rewritten by Christian Schappacher.
Jul 2008: Higgs sector renormalization (follows now hep-ph/0611326) 
          rewritten by Sven Heinemeyer and Christian Schappacher.
Dec 2009: additional sbottom sector renormalization schemes included
          by Sven Heinemeyer, Heidi Rzehak and Christian Schappacher.
Feb 2011: fermion and slepton sector renormalization rewritten 
          by Christian Schappacher.
Mar 2011: ModelMaker: CBn, SBn, CBc, SBc introduced (see: hep-ph/0611326) 
          by Sven Heinemeyer and Christian Schappacher.
Nov 2011: additional/modified RenConst for absorptive contributions included
          (following mainly arXiv:0909.5165)          
          by Heidi Rzehak and Christian Schappacher.
Sep 2012: missing SM-counterterms included by Christian Schappacher.
          Sneutrino-Sneutrino-Photon counterterm included, 
          thanks to Peter Drechsel.
Dec 2012: ModelMaker: missing CBn, SBn, CBc, SBc added
          (now consistent with the Higgs sector of hep-ph/0611326) 
	  by Sven Heinemeyer and Christian Schappacher. 
          Thanks to Sebastian Passehr.
Feb 2013: bugfix for Sfermion-Sfermion-Sfermion-Sfermion couplings.
          Thanks to Sebastian Passehr.
Mar 2013: still missing counterterms included by Sven Heinemeyer and
          Christian Schappacher.
Apr 2013: QuantumNumbers added by Christian Schappacher.
Jul 2013: RenConst completely rewritten by Thomas Hahn.
Jul 2013: slepton sector bugfix by Heidi Rzehak.
Sep 2013: on-shell scheme for down-type squarks added by Christian Schappacher.
Oct 2013: CCN and CNN schemes added by Federico von der Pahlen.
Dec 2013: variable renormalization schemes added by Thomas Hahn.
Jan 2015: bugfix for H-gamma/Z-W counterterm vertices by
          Christian Schappacher. Thanks to Sebastian Passehr.
Mar 2016: bugfix for H-G-gamma/Z counterterm vertices and missing 
          A0/G0-H/G-gamma/Z-W, H0/G0-h0/A0-W/Z-W/Z, G-H-gamma/W/Z-gamma/W/Z, 
          H-G0-W-gamma/Z and G-A0-W-gamma/Z counterterm vertices added
          by Sebastian Passehr and Christian Schappacher.


This file contains the definition of the minimal supersymmetric standard
model for FeynArts.  It needs the Generic model file Lorentz.gen.

When you change things, remember:

-- All particles are arranged in classes.  For single particle
   model definitions each particle lives in its own class.

-- For each class the common SelfConjugate behaviour and the
   IndexRange MUST be present in the definitions.

-- IMPORTANT: The coupling matrices MUST be declared in the
   SAME order as the Generic coupling.

This file introduces the following symbols:

	coupling constants and masses:
	------------------------------
	EL:		    electron charge (Thomson limit)
	CW, SW:		    cosine and sine of weak mixing angle

	MW, MZ:		    W, and Z masses
	Mh0, MHH, MA0, MHp: the Higgs masses

	MLE:		    lepton class mass
	ME, MM, ML:	    lepton masses (e, mu, tau)

	MQU:		    u-type quark class mass
	MU, MC, MT:	    u-type quark masses (up, charm, top)

	MQD:		    d-type quark class mass
	MD, MS, MB:	    d-type quark masses (down, strange, bottom)

	MSf:		    sfermion mass

	CKM:		    quark mixing matrix
			    (set $CKM = True for quark-mixing)

	GaugeXi[A, W, Z]:   photon, W, Z gauge parameters

	CA, SA:		    {Cos, Sin}[alpha]
	CB, SB, TB:	    {Cos, Sin, Tan}[beta]
	C2A, S2A:	    {Cos, Sin}[2 alpha]
	CAB, SAB:	    {Cos, Sin}[alpha + beta]
	CBA, SBA:	    {Cos, Sin}[beta - alpha]
		            where alpha is the (h0, H0) mixing angle 
                            and tan[beta] is the ratio of the VEVs of
			    the two Higgs doublets

	ZNeu:		    neutralino mixing matrix (4x4)
	UCha, VCha:	    chargino mixing matrices (2x2)
	USf[t]:		    t-type sfermion 1-2 mixing matrices (2x2)

	Af[t, i, i]:	    soft breaking parameters
	MUE:		    the H1-H2 mixing parameter

	GS:                 the strong coupling constant

	MGl:                the gluino mass
	SqrtEGl:            sqrt of the gluino phase (phase of M_3)

	SUNT[a, i, j]:      the generators of SU(N)
		            (half the Gell-Mann matrices)

	SUNTSum[i, j, k, l] = \sum_g SUNT[g, i, j] SUNT[g, k, l]

	SUNF[a, b, c]:      the structure constants of SU(N)

	SUNF[a, b, c, d]:   a short-hand for the sum
		            \sum_i SUNF[a, b, i] SUNF[i, c, d]

	GaugeXi[G]:         gluon gauge parameter


	MSSM one-loop renormalization constants (RCs):
	--------------------------------------------
	dZe1:               electromagnetic charge RC
	dSW1:               Weinberg angle sine RC

	dZW1, dMWsq1:	    W field and mass RC
	dMZsq1:		    Z mass RC
	dZZZ1, dZZA1,
	dZAZ1, dZAA1:       Z and photon field RCs

	dMf1:		    fermion mass RCs
	dZfL1:              left handed fermion field RCs 
        dZfR1:		    right handed fermion field RCs

	dCKM1:		    quark mixing matrix RCs

	dZG01, dZGp1:	    field RC for unphysical scalars
	dUZZ1, dUZA1,
	dUAZ1, dUAA1:       field RCs for photon and Z ghosts
	dUW1:	            field RC for +/- ghosts

	dZGG1:              gluon field RC
        dZgs1:              strong coupling-constant RC

	dTB1:               vev ratio RC
	dSB1:               auxiliary RC
	dCB1:               auxiliary RC

	dZHiggs1:           Higgs field RCs
	dMHiggs1:           Higgs mass RCs

	dMCha1:             chargino mass RCs
	dMNeu1:             neutralino mass RCs
	dMino11:            bino mass parameter RC
	dMino21:            wino mass parameter RC
	dMUE1:              higgsino mass parameter RC

	dZSf1:              sfermion field RCs
	dMSfsq1:            sfermion mass RCs
	dAf1:               A-parameter RCs

	dMGl1:              gluino mass RC
	dZGlL1:             left handed gluino field RC
	dZGlR1:             right handed gluino field RC

	Note, that the barred field RCs ("dZbar..." for outgoing particles, 
	see below) are, in general, different from the unbarred field RCs 
	(for incoming particles) if absorptive contributions are taken 
	into account and complex input parameters are used. 
	Otherwise the barred and unbarred field RCs are the same,
	see Phys. Rev. D 86, 035014 (2012) [arXiv:1111.7289] for further 
	informations.
	
        The sign in the SU(2) covariant derivative,
        D_\mu = \partial_\mu + Sign I g A^a_\mu \tau^a,
        is in Haber-Kane conventions, i.e. Sign = +1
*)

Clear[DR, OS]

If[ !ValueQ[$SfScheme[4, j1]], $SfScheme[4, _] = DR[2] ];
If[ !ValueQ[$SfScheme[2, j1]], $SfScheme[2, _] = OS[2] ];
If[ !ValueQ[$InoScheme], $InoScheme = CCN[1] ];
$MHpInput = $MHpInput =!= False;
$CKM = $CKM === True

FAPrint[1, ""];
FAPrint[1, Definition[$SfScheme, $InoScheme, $MHpInput, $CKM]];
FAPrint[1, ""]

If[ !$CKM, CKM = IndexDelta; _dCKM1 = 0 ]

IndexRange[ Index[Gluon] ] = NoUnfold[Range[8]];
IndexRange[ Index[Generation] ] = Range[3];
IndexRange[ Index[Colour] ] = NoUnfold[Range[3]];
IndexRange[ Index[Sfermion] ] = Range[2];
IndexRange[ Index[Chargino] ] = Range[2];
IndexRange[ Index[Neutralino] ] = Range[4]

IndexStyle[ Index[Generation | Chargino | Neutralino, i_Integer] ] :=
  Alph[i + 8] 

IndexStyle[ Index[Sfermion, i_Integer] ] := Alph[i + 18]

M$ClassesDescription = {
	(* Neutrinos: I_3 = +1/2, Q = 0 *)
   F[1] == {
         SelfConjugate -> False, 
      	 Indices -> {Index[Generation]}, 
	 Mass -> 0, 
	 QuantumNumbers -> {0 Charge, LeptonNumber}, 
       	 PropagatorLabel -> ComposedChar["\\nu", Index[Generation]], 
	 PropagatorType -> Straight, 
      	 PropagatorArrow -> Forward }, 

	(* massive Leptons: I_3 = -1/2, Q = -1 *)
   F[2] == {
         SelfConjugate -> False, 
      	 Indices -> {Index[Generation]}, 
	 Mass -> MLE, 
	 QuantumNumbers -> {-1 Charge, LeptonNumber}, 
       	 PropagatorLabel -> ComposedChar["e", Index[Generation]], 
	 PropagatorType -> Straight, 
      	 PropagatorArrow -> Forward }, 

	(* Quarks (u): I_3 = +1/2, Q = +2/3 *)
   F[3] == {
         SelfConjugate -> False, 
      	 Indices -> {Index[Generation], Index[Colour]}, 
	 Mass -> MQU, 
      	 QuantumNumbers -> {2/3 Charge, Sqrt[4/3] ColorCharge}, 
      	 PropagatorLabel -> ComposedChar["u", Index[Generation]], 
      	 PropagatorType -> Straight, 
	 PropagatorArrow -> Forward },

	(* Quarks (d): I_3 = -1/2, Q = -1/3 *) 
   F[4] == {
         SelfConjugate -> False, 
	 Indices -> {Index[Generation], Index[Colour]}, 
	 Mass -> MQD, 
	 QuantumNumbers -> {-1/3 Charge, Sqrt[4/3] ColorCharge}, 
	 PropagatorLabel -> ComposedChar["d", Index[Generation]], 
	 PropagatorType -> Straight, 
      	 PropagatorArrow -> Forward }, 

	(* Neutralinos *)
  F[11] == {
         SelfConjugate -> True, 
      	 Indices -> {Index[Neutralino]}, 
	 Mass -> MNeu, 
      	 PropagatorLabel -> 
           ComposedChar["\\chi", Index[Neutralino], "0", "\\tilde"], 
	 PropagatorType -> Straight, 		  
	 PropagatorArrow -> None }, 

	(* Charginos *)
  F[12] == {
         SelfConjugate -> False, 
	 Indices -> {Index[Chargino]}, 
      	 Mass -> MCha, 
	 QuantumNumbers -> {-1 Charge},
	 PropagatorLabel -> 
       	   ComposedChar["\\chi", Index[Chargino], Null, "\\tilde"], 
      	 PropagatorType -> Straight, 
	 PropagatorArrow -> Forward }, 

	(* Gauge bosons: Q = 0 *)
   V[1] == {
         SelfConjugate -> True, 
	 Indices -> {}, 
	 Mass -> 0, 
	 PropagatorLabel -> "\\gamma", 
	 PropagatorType -> Sine, 
	 PropagatorArrow -> None }, 

   V[2] == {
         SelfConjugate -> True, 
      	 Indices -> {}, 
	 Mass -> MZ, 
	 PropagatorLabel -> "Z", 
      	 PropagatorType -> Sine, 
	 PropagatorArrow -> None }, 

	(* Gauge bosons: Q = -1 *)
   V[3] == {
         SelfConjugate -> False, 
	 Indices -> {}, 
	 Mass -> MW, 
      	 QuantumNumbers -> {-1 Charge}, 
	 PropagatorLabel -> "W", 
      	 PropagatorType -> Sine, 
	 PropagatorArrow -> Forward }, 

	(* CP-even Higgs doublet: Q = 0 *)
   S[1] == {
         SelfConjugate -> True, 
	 Indices -> {}, 
	 Mass -> Mh0, 
      	 Mass[Loop] -> Mh0tree,
	 PropagatorLabel -> ComposedChar["h", Null, "0"], 
      	 PropagatorType -> ScalarDash, 
	 PropagatorArrow -> None }, 

   S[2] == {
         SelfConjugate -> True, 
	 Indices -> {}, 
	 Mass -> MHH, 
      	 Mass[Loop] -> MHHtree,
	 PropagatorLabel -> ComposedChar["H", Null, "0"], 
      	 PropagatorType -> ScalarDash, 
	 PropagatorArrow -> None }, 

	(* CP-odd Higgs doublet: Q = 0 *)
   S[3] == {
         SelfConjugate -> True, 
	 Indices -> {}, 
	 Mass -> MA0, 
      	 Mass[Loop] -> MA0tree,
	 PropagatorLabel -> ComposedChar["A", Null, "0"], 
      	 PropagatorType -> ScalarDash, 
	 PropagatorArrow -> None }, 

   S[4] == {
         SelfConjugate -> True, 
	 Indices -> {}, 
	 Mass -> MZ, 
      	 PropagatorLabel -> ComposedChar["G", Null, "0"], 
      	 PropagatorType -> ScalarDash, 
	 PropagatorArrow -> None }, 

	(* charged Higgs doublet: Q = -1 *)
   S[5] == {
         SelfConjugate -> False, 
	 Indices -> {}, 
	 Mass -> MHp, 
	 Mass[Loop] -> MHptree,
      	 QuantumNumbers -> {-1 Charge}, 
      	 PropagatorLabel -> "H", PropagatorType -> ScalarDash, 
      	 PropagatorArrow -> Forward }, 

   S[6] == {
         SelfConjugate -> False, 
      	 Indices -> {}, 
	 Mass -> MW, 
	 QuantumNumbers -> {-1 Charge}, 
      	 PropagatorLabel -> "G", 
	 PropagatorType -> ScalarDash, 
      	 PropagatorArrow -> Forward }, 

	(* Sneutrinos: Q = 0 *)
  S[11] == {
  	 SelfConjugate -> False, 
      	 Indices -> {Index[Generation]}, 
	 Mass -> MSneu, 
      	 QuantumNumbers -> {0 Charge, LeptonNumber},	 
      	 PropagatorLabel -> 
	   ComposedChar["\\nu", Index[Generation], Null, "\\tilde"], 
	 PropagatorType -> ScalarDash, 
	 PropagatorArrow -> Forward }, 

	(* Sleptons: Q = -1 *)
  S[12] == {
         SelfConjugate -> False, 
      	 Indices -> {Index[Sfermion], Index[Generation]}, 
	 Mass -> MSel, 
      	 QuantumNumbers -> {-1 Charge, LeptonNumber},
	 PropagatorLabel -> 
           ComposedChar["e", Index[Generation], Index[Sfermion], "\\tilde"], 
      	 PropagatorType -> ScalarDash, 
	 PropagatorArrow -> Forward }, 

	(* Squarks (u): Q = +2/3 *)
  S[13] == {
         SelfConjugate -> False, 
	 Indices -> {Index[Sfermion], Index[Generation], Index[Colour]}, 
	 Mass -> MSup, 
      	 QuantumNumbers -> {2/3 Charge, Sqrt[4/3] ColorCharge}, 
      	 PropagatorLabel -> 
           ComposedChar["u", Index[Generation], Index[Sfermion], "\\tilde"], 
	 PropagatorType -> ScalarDash, 
      	 PropagatorArrow -> Forward }, 

	(* Squarks (d): Q = -1/3 *)
  S[14] == {
         SelfConjugate -> False, 
      	 Indices -> {Index[Sfermion], Index[Generation], Index[Colour]}, 
      	 Mass -> MSdown, 
	 QuantumNumbers -> {-1/3 Charge, Sqrt[4/3] ColorCharge}, 
      	 PropagatorLabel -> 
           ComposedChar["d", Index[Generation], Index[Sfermion], "\\tilde"], 
	 PropagatorType -> ScalarDash, 
      	 PropagatorArrow -> Forward }, 

	(* Ghosts: Q = 0 *)
   U[1] == {
   	 SelfConjugate -> False, 
      	 Indices -> {}, 
	 Mass -> 0, 
	 QuantumNumbers -> GhostNumber, 
      	 PropagatorLabel -> ComposedChar["u", "\\gamma"], 
      	 PropagatorType -> GhostDash, 
	 PropagatorArrow -> Forward }, 

   U[2] == {
         SelfConjugate -> False, 
	 Indices -> {}, 
	 Mass -> MZ, 
      	 QuantumNumbers -> GhostNumber, 
	 PropagatorLabel -> ComposedChar["u", "Z"], 
	 PropagatorType -> GhostDash, 
      	 PropagatorArrow -> Forward }, 

	(* Ghosts: Q = -1 *)
   U[3] == {
   	 SelfConjugate -> False, 
      	 Indices -> {}, 
	 Mass -> MW, 
	 QuantumNumbers -> {-1 Charge, GhostNumber}, 
      	 PropagatorLabel -> ComposedChar["u", "-"], 
      	 PropagatorType -> GhostDash, 
      	 PropagatorArrow -> Forward }, 

   U[4] == {
   	 SelfConjugate -> False, 
      	 Indices -> {}, 
	 Mass -> MW, 
	 QuantumNumbers -> {1 Charge, GhostNumber}, 
      	 PropagatorLabel -> ComposedChar["u", "+"], 
	 PropagatorType -> GhostDash, 
      	 PropagatorArrow -> Forward }, 

	(* Gluons: Q = 0 *)
   V[5] == {
   	 SelfConjugate -> True, 
      	 Indices -> {Index[Gluon]}, 
	 Mass -> 0, 
	 QuantumNumbers -> {Sqrt[3] ColorCharge}, 
       	 PropagatorLabel -> "g", 
	 PropagatorType -> Cycles, 
	 PropagatorArrow -> None }, 

	(* Gluon ghosts: Q = 0 *)
   U[5] == {
   	 SelfConjugate -> False, 
      	 Indices -> {Index[Gluon]}, 
	 Mass -> 0, 
	 QuantumNumbers -> {Sqrt[3] ColorCharge, GhostNumber}, 
	 PropagatorLabel -> ComposedChar["u", "g"], 
	 PropagatorType -> GhostDash, 
      	 PropagatorArrow -> Forward }, 

	(* Gluinos: Q = 0 *)
  F[15] == {
  	 SelfConjugate -> True, 
      	 Indices -> {Index[Gluon]}, 
	 Mass -> MGl, 
	 QuantumNumbers -> {Sqrt[3] ColorCharge}, 
       	 PropagatorLabel -> ComposedChar["g", Null, Null, "\\tilde"], 
	 PropagatorType -> Straight, 
	 PropagatorArrow -> None }
}

MLE[1] = ME;
MLE[2] = MM;
MLE[3] = ML;
MQU[1] = MU;
MQU[2] = MC;
MQU[3] = MT;
MQD[1] = MD;
MQD[2] = MS;
MQD[3] = MB;
MQU[gen_, _] = MQU[gen];
MQD[gen_, _] = MQD[gen];
MGl[_] = MGl

TheLabel[ F[1, {1}] ] = ComposedChar["\\nu", "e"]; 
TheLabel[ F[1, {2}] ] = ComposedChar["\\nu", "\\mu"]; 
TheLabel[ F[1, {3}] ] = ComposedChar["\\nu", "\\tau"]; 
TheLabel[ F[2, {1}] ] = "e"; 
TheLabel[ F[2, {2}] ] = "\\mu"; 
TheLabel[ F[2, {3}] ] = "\\tau";
TheLabel[ F[3, {1, ___}] ] = "u"; 
TheLabel[ F[3, {2, ___}] ] = "c";
TheLabel[ F[3, {3, ___}] ] = "t";
TheLabel[ F[4, {1, ___}] ] = "d"; 
TheLabel[ F[4, {2, ___}] ] = "s";
TheLabel[ F[4, {3, ___}] ] = "b"

MSneu[gen_] := MSf[1, 1, gen];
MSel[sf_, gen_] := MSf[sf, 2, gen];
MSup[sf_, gen_, ___] := MSf[sf, 3, gen];
MSdown[sf_, gen_, ___] := MSf[sf, 4, gen];

TheLabel[ S[11, {1}] ] = ComposedChar["\\nu", "e", Null, "\\tilde"];
TheLabel[ S[11, {2}] ] = ComposedChar["\\nu", "\\mu", Null, "\\tilde"];
TheLabel[ S[11, {3}] ] = ComposedChar["\\nu", "\\tau", Null, "\\tilde"];
TheLabel[ S[12, {sf_, 1}] ] :=
  ComposedChar["e", Null, IndexStyle[sf], "\\tilde"];
TheLabel[ S[12, {sf_, 2}] ] :=
  ComposedChar["\\mu", Null, IndexStyle[sf], "\\tilde"];
TheLabel[ S[12, {sf_, 3}] ] :=
  ComposedChar["\\tau", Null, IndexStyle[sf], "\\tilde"];
TheLabel[ S[13, {sf_, 1, ___}] ] :=
  ComposedChar["u", Null, IndexStyle[sf], "\\tilde"];
TheLabel[ S[13, {sf_, 2, ___}] ] :=
  ComposedChar["c", Null, IndexStyle[sf], "\\tilde"];
TheLabel[ S[13, {sf_, 3, ___}] ] :=
  ComposedChar["t", Null, IndexStyle[sf], "\\tilde"];
TheLabel[ S[14, {sf_, 1, ___}] ] :=
  ComposedChar["d", Null, IndexStyle[sf], "\\tilde"];
TheLabel[ S[14, {sf_, 2, ___}] ] :=
  ComposedChar["s", Null, IndexStyle[sf], "\\tilde"];
TheLabel[ S[14, {sf_, 3, ___}] ] :=
  ComposedChar["b", Null, IndexStyle[sf], "\\tilde"]

GaugeXi[ V[1] ] = GaugeXi[A];
GaugeXi[ V[2] ] = GaugeXi[Z];
GaugeXi[ V[3] ] = GaugeXi[W];
GaugeXi[ V[5] ] = GaugeXi[G];
GaugeXi[ U[1] ] = GaugeXi[A];
GaugeXi[ U[2] ] = GaugeXi[Z];
GaugeXi[ U[3] ] = GaugeXi[W];
GaugeXi[ U[4] ] = GaugeXi[W];
GaugeXi[ U[5] ] = GaugeXi[G];
GaugeXi[ S[4] ] = GaugeXi[Z];
GaugeXi[ S[6] ] = GaugeXi[W];
GaugeXi[ S[_Integer, ___] ] = 1

M$LastModelRules = {}


(* some short-hands for excluding classes of particles *)

NoGeneration1 = ExcludeParticles ->
  {F[1|2|3|4, {1, ___}], S[11, {1, ___}], S[12|13|14, {_, 1, ___}]}

NoGeneration2 = ExcludeParticles ->
  {F[1|2|3|4, {2, ___}], S[11, {2, ___}], S[12|13|14, {_, 2, ___}]}

NoGeneration3 = ExcludeParticles ->
  {F[1|2|3|4, {3, ___}], S[11, {3, ___}], S[12|13|14, {_, 3, ___}]}

NoSUSYParticles = ExcludeParticles ->
  {S[11], S[12], S[13], S[14], S[2], S[3], S[5], F[11], F[12]}

THDMParticles = ExcludeParticles ->
  {S[11], S[12], S[13], S[14], F[11], F[12]}

NoElectronHCoupling =
  ExcludeFieldPoints -> {
    FieldPoint[_][-F[2, {1}], F[2, {1}], S[1|2|3|4]],
    FieldPoint[_][-F[2, {1}], F[1, {1}], S[5|6]]}

NoLightFHCoupling =
  ExcludeFieldPoints -> {
    FieldPoint[_][-F[2], F[2], S[1|2|3|4]],
    FieldPoint[_][-F[2], F[1], S[5|6]],
    FieldPoint[_][-F[3, {1, ___}], F[3, {1, ___}], S[1|2|3|4]],
    FieldPoint[_][-F[3, {2, ___}], F[3, {2, ___}], S[1|2|3|4]],
    FieldPoint[_][-F[4], F[4], S[1|2|3|4]],
    FieldPoint[_][-F[4], F[3, {1, ___}], S[5|6]],
    FieldPoint[_][-F[4], F[3, {2, ___}], S[5|6]] }

M$CouplingMatrices = {
 C[S[6], -S[6], V[1]] == 
  {{I*EL, (I/4)*EL*(2*dZAA1 + 4*dZe1 + dZZA1*(CW/SW - SW/CW) + 
      4*dZHiggs1[6, 6])}}, C[S[6], -S[6], V[2]] == 
  {{((-I/2)*(1 - 2*CW^2)*EL)/(CW*SW), 
    ((-I/4)*EL*(2*dSW1*SW^4 + CW^4*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + 
           2*dZHiggs1[6, 6])) - SW^2*(2*CW^3*dZAZ1 - 
         CW^2*(4*dSW1 + SW*(2*dZe1 + dZZZ1 + 2*dZHiggs1[6, 6])))))/
     (CW^3*SW^2)}}, C[S[4], S[6], -V[3]] == 
  {{EL/(2*SW), -(EL*(2*dSW1 - SW*(dZbarW1 + 2*dZe1 + dZHiggs1[4, 4] + 
          dZHiggs1[6, 6])))/(4*SW^2)}}, C[S[4], -S[6], V[3]] == 
  {{EL/(2*SW), -(EL*(2*dSW1 - SW*(2*dZe1 + dZW1 + dZHiggs1[4, 4] + 
          dZHiggs1[6, 6])))/(4*SW^2)}}, C[S[6], V[1], -V[3]] == 
  {{I*EL*MW, ((-I/2)*EL*(dZZA1*MW^2*SW - 
       CW*(dMWsq1 + MW^2*(dZAA1 + dZbarW1 + 2*dZe1 + dZHiggs1[6, 6]))))/
     (CW*MW)}}, C[-S[6], V[1], V[3]] == 
  {{I*EL*MW, ((-I/2)*EL*(dZZA1*MW^2*SW - 
       CW*(dMWsq1 + MW^2*(dZAA1 + 2*dZe1 + dZW1 + dZHiggs1[6, 6]))))/
     (CW*MW)}}, C[S[6], V[2], -V[3]] == 
  {{((-I)*EL*MW*SW)/CW, ((I/2)*EL*(MW^2*(CW^3*dZAZ1 - 2*dSW1*SW^2) - 
       CW^2*(dMWsq1*SW + MW^2*(2*dSW1 + SW*(dZbarW1 + 2*dZe1 + dZZZ1 + 
             dZHiggs1[6, 6])))))/(CW^3*MW)}}, 
 C[-S[6], V[2], V[3]] == {{((-I)*EL*MW*SW)/CW, 
    ((I/2)*EL*(MW^2*(CW^3*dZAZ1 - 2*dSW1*SW^2) - 
       CW^2*(dMWsq1*SW + MW^2*(2*dSW1 + SW*(2*dZe1 + dZW1 + dZZZ1 + 
             dZHiggs1[6, 6])))))/(CW^3*MW)}}, 
 C[V[1], -V[3], V[3]] == 
  {{(-I)*EL, (-I/2)*EL*(dZAA1 + 2*(dZe1 + dZW1) + (CW*dZZA1)/SW)}}, 
 C[V[2], -V[3], V[3]] == 
  {{((-I)*CW*EL)/SW, 
    ((I/2)*EL*(2*dSW1 - CW*SW*(CW*(2*(dZe1 + dZW1) + dZZZ1) + dZAZ1*SW)))/
     (CW*SW^2)}}, C[S[4], U[3], -U[3]] == {{-(EL*MW*GaugeXi[W])/(2*SW)}}, 
 C[S[4], U[4], -U[4]] == {{(EL*MW*GaugeXi[W])/(2*SW)}}, 
 C[S[6], U[1], -U[3]] == {{(-I)*EL*MW*GaugeXi[W]}}, 
 C[-S[6], U[1], -U[4]] == {{(-I)*EL*MW*GaugeXi[W]}}, 
 C[S[6], U[2], -U[3]] == {{((I/2)*(1 - 2*CW^2)*EL*MW*GaugeXi[W])/(CW*SW)}}, 
 C[-S[6], U[2], -U[4]] == {{((I/2)*(1 - 2*CW^2)*EL*MW*GaugeXi[W])/(CW*SW)}}, 
 C[S[6], U[4], -U[2]] == {{((I/2)*EL*MW*GaugeXi[Z])/(CW*SW)}}, 
 C[-S[6], U[3], -U[2]] == {{((I/2)*EL*MW*GaugeXi[Z])/(CW*SW)}}, 
 C[-U[3], U[3], V[1]] == 
  {{(-I)*EL, (-I/2)*EL*(2*dUW1 + dZAA1 + 2*dZe1 - dZW1 + (CW*dZZA1)/SW)}, 
   {0, 0}}, C[-U[4], U[4], V[1]] == 
  {{I*EL, (I/2)*EL*(2*dUW1 + dZAA1 + 2*dZe1 - dZW1 + (CW*dZZA1)/SW)}, 
   {0, 0}}, C[-U[3], U[3], V[2]] == 
  {{((-I)*CW*EL)/SW, 
    ((I/2)*EL*(2*dSW1 - CW*SW*(CW*(2*(dUW1 + dZe1) - dZW1 + dZZZ1) + 
         dZAZ1*SW)))/(CW*SW^2)}, {0, 0}}, C[-U[4], U[4], V[2]] == 
  {{(I*CW*EL)/SW, ((-I/2)*EL*(2*dSW1 - 
       CW*SW*(CW*(2*(dUW1 + dZe1) - dZW1 + dZZZ1) + dZAZ1*SW)))/(CW*SW^2)}, 
   {0, 0}}, C[-U[3], U[1], V[3]] == 
  {{I*EL, I*EL*(dUAA1 + dZe1 + (CW*dUZA1)/SW)}, {0, 0}}, 
 C[-U[4], U[1], -V[3]] == {{(-I)*EL, (-I)*EL*(dUAA1 + dZe1 + (CW*dUZA1)/SW)}, 
   {0, 0}}, C[-U[1], U[4], V[3]] == 
  {{(-I)*EL, (-I/2)*EL*(2*dUW1 - dZAA1 + 2*dZe1 + dZW1 - (CW*dZAZ1)/SW)}, 
   {0, 0}}, C[-U[1], U[3], -V[3]] == 
  {{I*EL, I*EL*(dUW1 + (-dZAA1 + 2*dZe1 + dZW1 - (CW*dZAZ1)/SW)/2)}, {0, 0}}, 
 C[-U[3], U[2], V[3]] == 
  {{(I*CW*EL)/SW, ((-I)*EL*(dSW1 - CW*SW*(CW*(dUZZ1 + dZe1) + dUAZ1*SW)))/
     (CW*SW^2)}, {0, 0}}, C[-U[4], U[2], -V[3]] == 
  {{((-I)*CW*EL)/SW, (I*EL*(dSW1 - CW*SW*(CW*(dUZZ1 + dZe1) + dUAZ1*SW)))/
     (CW*SW^2)}, {0, 0}}, C[-U[2], U[4], V[3]] == 
  {{((-I)*CW*EL)/SW, 
    ((I/2)*EL*(2*dSW1 - CW*SW*(CW*(2*(dUW1 + dZe1) + dZW1 - dZZZ1) - 
         dZZA1*SW)))/(CW*SW^2)}, {0, 0}}, C[-U[2], U[3], -V[3]] == 
  {{(I*CW*EL)/SW, ((-I/2)*EL*(2*dSW1 - 
       CW*SW*(CW*(2*(dUW1 + dZe1) + dZW1 - dZZZ1) - dZZA1*SW)))/(CW*SW^2)}, 
   {0, 0}}, C[S[1], S[1], V[2], V[2]] == 
  {{((I/2)*EL^2)/(CW^2*SW^2), 
    ((I/2)*EL^2*(2*dSW1*SW^2 - CW^2*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + 
           dZHiggs1[1, 1]))))/(CW^4*SW^3)}}, C[S[1], S[1], V[3], -V[3]] == 
  {{((I/2)*EL^2)/SW^2, 
    ((-I/4)*EL^2*(4*dSW1 - SW*(dZbarW1 + 4*dZe1 + dZW1 + 2*dZHiggs1[1, 1])))/
     SW^3}}, C[S[4], S[4], V[2], V[2]] == 
  {{((I/2)*EL^2)/(CW^2*SW^2), 
    ((I/2)*EL^2*(2*dSW1*SW^2 - CW^2*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + 
           dZHiggs1[4, 4]))))/(CW^4*SW^3)}}, C[S[4], S[4], V[3], -V[3]] == 
  {{((I/2)*EL^2)/SW^2, 
    ((-I/4)*EL^2*(4*dSW1 - SW*(dZbarW1 + 4*dZe1 + dZW1 + 2*dZHiggs1[4, 4])))/
     SW^3}}, C[S[6], -S[6], V[1], V[1]] == 
  {{(2*I)*EL^2, (I*EL^2*(dZZA1*(CW^2 - SW^2) + 
       2*CW*SW*(dZAA1 + 2*dZe1 + dZHiggs1[6, 6])))/(CW*SW)}}, 
 C[S[6], -S[6], V[1], V[2]] == {{((-I)*(1 - 2*CW^2)*EL^2)/(CW*SW), 
    ((-I/4)*EL^2*(4*dSW1*SW^4 - dZZA1*(CW^5 + CW*SW^4) + 
       2*CW^4*(2*dSW1 - SW*(dZAA1 + 4*dZe1 + dZZZ1 + 2*dZHiggs1[6, 6])) - 
       SW^2*(2*CW^3*(2*dZAZ1 - dZZA1) - 2*CW^2*(4*dSW1 + 
           SW*(dZAA1 + 4*dZe1 + dZZZ1 + 2*dZHiggs1[6, 6])))))/(CW^3*SW^2)}}, 
 C[S[6], -S[6], V[2], V[2]] == {{((I/2)*(EL - 2*CW^2*EL)^2)/(CW^2*SW^2), 
    ((I/2)*(1 - 2*CW^2)*EL^2*(2*dSW1*SW^4 + 
       CW^4*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + dZHiggs1[6, 6])) - 
       SW^2*(2*CW^3*dZAZ1 - CW^2*(4*dSW1 + SW*(2*dZe1 + dZZZ1 + 
             dZHiggs1[6, 6])))))/(CW^4*SW^3)}}, 
 C[S[6], -S[6], V[3], -V[3]] == 
  {{((I/2)*EL^2)/SW^2, 
    ((-I/4)*EL^2*(4*dSW1 - SW*(dZbarW1 + 4*dZe1 + dZW1 + 2*dZHiggs1[6, 6])))/
     SW^3}}, C[V[1], V[1], V[3], -V[3]] == 
  {{(-2*I)*EL^2, ((-2*I)*EL^2*(CW*dZZA1 + (dZAA1 + 2*dZe1 + dZW1)*SW))/SW}, 
   {I*EL^2, (I*EL^2*(CW*dZZA1 + (dZAA1 + 2*dZe1 + dZW1)*SW))/SW}, 
   {I*EL^2, (I*EL^2*(CW*dZZA1 + (dZAA1 + 2*dZe1 + dZW1)*SW))/SW}}, 
 C[V[1], V[2], V[3], -V[3]] == 
  {{((-2*I)*CW*EL^2)/SW, 
    (I*EL^2*(2*dSW1 - CW*(CW^2*dZZA1 + CW*(dZAA1 + 4*dZe1 + 2*dZW1 + dZZZ1)*
          SW + dZAZ1*SW^2)))/(CW*SW^2)}, {(I*CW*EL^2)/SW, 
    ((-I/2)*EL^2*(2*dSW1 - CW*(CW^2*dZZA1 + CW*(dZAA1 + 4*dZe1 + 2*dZW1 + 
           dZZZ1)*SW + dZAZ1*SW^2)))/(CW*SW^2)}, 
   {(I*CW*EL^2)/SW, ((-I/2)*EL^2*(2*dSW1 - 
       CW*(CW^2*dZZA1 + CW*(dZAA1 + 4*dZe1 + 2*dZW1 + dZZZ1)*SW + 
         dZAZ1*SW^2)))/(CW*SW^2)}}, C[V[2], V[2], V[3], -V[3]] == 
  {{((-2*I)*CW^2*EL^2)/SW^2, 
    ((2*I)*EL^2*(2*dSW1 - CW*SW*(CW*(2*dZe1 + dZW1 + dZZZ1) + dZAZ1*SW)))/
     SW^3}, {(I*CW^2*EL^2)/SW^2, 
    ((-I)*EL^2*(2*dSW1 - CW*SW*(CW*(2*dZe1 + dZW1 + dZZZ1) + dZAZ1*SW)))/
     SW^3}, {(I*CW^2*EL^2)/SW^2, 
    ((-I)*EL^2*(2*dSW1 - CW*SW*(CW*(2*dZe1 + dZW1 + dZZZ1) + dZAZ1*SW)))/
     SW^3}}, C[V[3], V[3], -V[3], -V[3]] == 
  {{((2*I)*EL^2)/SW^2, ((-4*I)*EL^2*(dSW1 - (dZe1 + dZW1)*SW))/SW^3}, 
   {((-I)*EL^2)/SW^2, ((2*I)*EL^2*(dSW1 - (dZe1 + dZW1)*SW))/SW^3}, 
   {((-I)*EL^2)/SW^2, ((2*I)*EL^2*(dSW1 - (dZe1 + dZW1)*SW))/SW^3}}, 
 C[S[1], S[1], S[1]] == {{(((-3*I)/2)*C2A*EL*MW*SAB)/(CW^2*SW), 
    (((-3*I)/4)*EL*(C2A*(4*dSW1*MW^2*SAB*SW^2 - 
         CW^2*(2*dSW1*MW^2*SAB - SW*(dMWsq1*SAB + MW^2*(2*CAB*CB^2*dTB1 + SAB*
                (2*dZe1 + 3*dZHiggs1[1, 1]))))) - 
       CW^2*MW^2*(C2A*CAB - 2*S2A*SAB)*SW*dZHiggs1[1, 2]))/(CW^4*MW*SW^2)}}, 
 C[S[1], S[1], S[2]] == {{((I/2)*EL*MW*(C2A*CAB - 2*S2A*SAB))/(CW^2*SW), 
    ((-I/4)*EL*(C2A*(CW^2*MW^2*SAB*SW*(2*CB^2*dTB1 + dZHiggs1[1, 2]) - 
         CAB*(4*dSW1*MW^2*SW^2 - CW^2*(2*dSW1*MW^2 - 
             SW*(dMWsq1 + MW^2*(2*(dZe1 + dZHiggs1[1, 1]) + dZHiggs1[2, 
                  2]))))) + 2*S2A*(4*dSW1*MW^2*SAB*SW^2 - 
         CW^2*(2*dSW1*MW^2*SAB - SW*(dMWsq1*SAB + MW^2*(2*CAB*(CB^2*dTB1 - 
                 dZHiggs1[1, 2]) + SAB*(2*(dZe1 + dZHiggs1[1, 1]) + 
                 dZHiggs1[2, 2])))))))/(CW^4*MW*SW^2)}}, 
 C[S[1], S[2], S[2]] == {{((I/2)*EL*MW*(2*CAB*S2A + C2A*SAB))/(CW^2*SW), 
    ((-I/4)*EL*(SAB*(4*CW^2*MW^2*S2A*SW*(CB^2*dTB1 + dZHiggs1[1, 2]) - 
         C2A*(4*dSW1*MW^2*SW^2 + CW^2*(dMWsq1*SW - MW^2*(2*dSW1 - SW*
                (2*dZe1 + dZHiggs1[1, 1] + 2*dZHiggs1[2, 2]))))) - 
       CAB*(8*dSW1*MW^2*S2A*SW^2 - CW^2*(4*dSW1*MW^2*S2A - 
           SW*(2*dMWsq1*S2A + MW^2*(C2A*(2*CB^2*dTB1 - dZHiggs1[1, 2]) + S2A*
                (4*dZe1 + 2*dZHiggs1[1, 1] + 4*dZHiggs1[2, 2])))))))/
     (CW^4*MW*SW^2)}}, C[S[2], S[2], S[2]] == 
  {{(((-3*I)/2)*C2A*CAB*EL*MW)/(CW^2*SW), 
    (((3*I)/4)*EL*(2*CAB*CW^2*MW^2*S2A*SW*dZHiggs1[1, 2] + 
       C2A*(CW^2*MW^2*SAB*SW*(2*CB^2*dTB1 + dZHiggs1[1, 2]) - 
         CAB*(4*dSW1*MW^2*SW^2 + CW^2*(dMWsq1*SW - MW^2*(2*dSW1 - SW*
                (2*dZe1 + 3*dZHiggs1[2, 2])))))))/(CW^4*MW*SW^2)}}, 
 C[S[1], S[3], S[3]] == {{((-I/2)*C2B*EL*MW*SAB)/(CW^2*SW), 
    ((-I/4)*EL*(C2B*(4*dSW1*MW^2*SAB*SW^2 - CW^2*(2*dSW1*MW^2*SAB - 
           SW*(dMWsq1*SAB + MW^2*(CAB*(2*CB^2*dTB1 - dZHiggs1[1, 2]) + SAB*
                (2*dZe1 + dZHiggs1[1, 1] + 2*dZHiggs1[3, 3]))))) + 
       2*CW^2*MW^2*S2B*SAB*SW*dZHiggs1[3, 4]))/(CW^4*MW*SW^2)}}, 
 C[S[1], S[4], S[4]] == {{((I/2)*C2B*EL*MW*SAB)/(CW^2*SW), 
    ((-I/4)*EL*(2*CW^2*MW^2*S2B*SAB*SW*dZHiggs1[3, 4] - 
       C2B*(4*dSW1*MW^2*SAB*SW^2 - CW^2*(2*dSW1*MW^2*SAB - 
           SW*(dMWsq1*SAB + MW^2*(CAB*(2*CB^2*dTB1 - dZHiggs1[1, 2]) + SAB*
                (2*dZe1 + dZHiggs1[1, 1] + 2*dZHiggs1[4, 4])))))))/
     (CW^4*MW*SW^2)}}, C[S[1], S[3], S[4]] == 
  {{((-I/2)*EL*MW*S2B*SAB)/(CW^2*SW), 
    ((-I/4)*EL*S2B*(4*dSW1*MW^2*SAB*SW^2 - CW^2*(2*dSW1*MW^2*SAB - 
         SW*(dMWsq1*SAB + MW^2*(CAB*(2*CB^2*dTB1 - dZHiggs1[1, 2]) + 
             SAB*(2*dZe1 + dZHiggs1[1, 1] + dZHiggs1[3, 3] + dZHiggs1[4, 
                4]))))))/(CW^4*MW*SW^2)}}, C[S[2], S[3], S[3]] == 
  {{((I/2)*C2B*CAB*EL*MW)/(CW^2*SW), 
    ((-I/4)*EL*(C2B*(CW^2*MW^2*SAB*SW*(2*CB^2*dTB1 + dZHiggs1[1, 2]) - 
         CAB*(4*dSW1*MW^2*SW^2 - CW^2*(2*dSW1*MW^2 - 
             SW*(dMWsq1 + MW^2*(2*dZe1 + dZHiggs1[2, 2] + 2*dZHiggs1[3, 
                   3]))))) - 2*CAB*CW^2*MW^2*S2B*SW*dZHiggs1[3, 4]))/
     (CW^4*MW*SW^2)}}, C[S[2], S[4], S[4]] == 
  {{((-I/2)*C2B*CAB*EL*MW)/(CW^2*SW), 
    ((I/4)*EL*(2*CAB*CW^2*MW^2*S2B*SW*dZHiggs1[3, 4] + 
       C2B*(CW^2*MW^2*SAB*SW*(2*CB^2*dTB1 + dZHiggs1[1, 2]) - 
         CAB*(4*dSW1*MW^2*SW^2 - CW^2*(2*dSW1*MW^2 - 
             SW*(dMWsq1 + MW^2*(2*dZe1 + dZHiggs1[2, 2] + 2*dZHiggs1[4, 
                   4])))))))/(CW^4*MW*SW^2)}}, 
 C[S[2], S[3], S[4]] == {{((I/2)*CAB*EL*MW*S2B)/(CW^2*SW), 
    ((-I/4)*EL*S2B*(CW^2*MW^2*SAB*SW*(2*CB^2*dTB1 + dZHiggs1[1, 2]) - 
       CAB*(4*dSW1*MW^2*SW^2 - CW^2*(2*dSW1*MW^2 - 
           SW*(dMWsq1 + MW^2*(2*dZe1 + dZHiggs1[2, 2] + dZHiggs1[3, 3] + 
               dZHiggs1[4, 4]))))))/(CW^4*MW*SW^2)}}, 
 C[S[1], S[5], -S[5]] == 
  {{((-I/2)*EL*MW*(CA*(C2B + 2*CW^2)*SB - SA*(CB + CW^2*S2B*SB - 
         2*CB^3*SW^2)))/(CW^2*SW), 
    ((I/4)*EL*(C2B*(CA*CW^2*SB*(2*dSW1*MW^2 - 
           SW*(dMWsq1 + MW^2*(2*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[1, 1] + 
               dZHiggs1[5, 5]))) - MW^2*SW*(4*dSW1*SAB*SW + 
           CW^2*SA*SB*dZHiggs1[1, 2] - CAB*CW^4*(dZHiggs1[5, 6] + 
             dZHiggs1[6, 5]))) - CW^2*(CB*(1 + 2*CW^2*SB^2 - 2*CB^2*SW^2)*
          (2*dSW1*MW^2*SA - SW*(dMWsq1*SA - MW^2*(CA*dZHiggs1[1, 2] - SA*
                (2*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[1, 1] + dZHiggs1[5, 
                  5])))) + 2*CA*(dSB1*MW^2*SW*(1 - 2*SB^2*SW^2) - 
           CW^2*(2*dSW1*MW^2*SB - SW*(dMWsq1*SB + MW^2*(dCB1*S2B + 
                 SB*(2*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[1, 1] + 
                   dZHiggs1[5, 5]))))) - MW^2*SW*
          (SA*(dCB1*(2 - 4*CB^2*SW^2) + 2*CW^2*(dSB1*S2B - SB*dZHiggs1[1, 
                 2])) - S2B*SAB*SW^2*(dZHiggs1[5, 6] + dZHiggs1[6, 5])))))/
     (CW^4*MW*SW^2)}}, C[S[1], S[6], -S[6]] == 
  {{((I/2)*C2B*EL*MW*SAB)/(CW^2*SW), 
    ((-I/4)*EL*(CW^2*MW^2*SW*(CA*dSB1*(2 - 4*CB^2*SW^2) - 
         dCB1*SA*(2 - 4*SB^2*SW^2) - S2B*(2*CW^2*(CA*dCB1 - dSB1*SA) - 
           SAB*SW^2*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))) - 
       C2B*(MW^2*(4*dSW1*SAB*SW^2 + CAB*CW^4*SW*(dZHiggs1[5, 6] + 
             dZHiggs1[6, 5])) - CW^2*(2*dSW1*MW^2*SAB - 
           SW*(dMWsq1*SAB - MW^2*(CAB*dZHiggs1[1, 2] - SAB*(2*dZe1 + 
                 dZHiggs1[1, 1] + 2*dZHiggs1[6, 6])))))))/(CW^4*MW*SW^2)}}, 
 C[S[1], S[5], -S[6]] == {{(I/2)*EL*MW*((C2B*CAB)/SW - (S2B*SAB*SW)/CW^2), 
    ((-I/4)*EL*(C2B*CW^4*(MW^2*SAB*SW*(2*CB^2*dTB1 - dZHiggs1[1, 2]) + 
         CAB*(2*dSW1*MW^2 - SW*(dMWsq1 + MW^2*(2*dZe1 + dZHiggs1[1, 1] + 
               dZHiggs1[5, 5] + dZHiggs1[6, 6])))) + 
       SW*(2*MW^2*(2*dSW1*S2B*SAB*SW^3 + CW^4*SBA*dZHiggs1[6, 5]) + 
         CW^2*S2B*SW*(2*dSW1*MW^2*SAB + SW*(dMWsq1*SAB + 
             MW^2*(CAB*(2*CB^2*dTB1 - dZHiggs1[1, 2]) + SAB*(2*dZe1 + 
                 dZHiggs1[1, 1] + dZHiggs1[5, 5] + dZHiggs1[6, 6])))))))/
     (CW^4*MW*SW^2)}}, C[S[1], S[6], -S[5]] == 
  {{(I/2)*EL*MW*((C2B*CAB)/SW - (S2B*SAB*SW)/CW^2), 
    ((-I/4)*EL*(C2B*CW^4*(MW^2*SAB*SW*(2*CB^2*dTB1 - dZHiggs1[1, 2]) + 
         CAB*(2*dSW1*MW^2 - SW*(dMWsq1 + MW^2*(2*dZe1 + dZbarHiggs1[5, 5] + 
               dZHiggs1[1, 1] + dZHiggs1[6, 6])))) + 
       SW*(MW^2*(4*dSW1*S2B*SAB*SW^3 + CW^4*(CAB*S2B - 2*CB^3*SA + 2*CA*SB^3)*
            dZHiggs1[5, 6]) + CW^2*S2B*SW*(2*dSW1*MW^2*SAB + 
           SW*(dMWsq1*SAB + MW^2*(CAB*(2*CB^2*dTB1 - dZHiggs1[1, 2]) + SAB*
                (2*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[1, 1] + dZHiggs1[6, 
                  6])))))))/(CW^4*MW*SW^2)}}, 
 C[S[2], S[5], -S[5]] == 
  {{((-I/2)*EL*MW*((C2B + 2*CW^2)*SA*SB + CA*(CB + CW^2*S2B*SB - 
         2*CB^3*SW^2)))/(CW^2*SW), 
    ((I/4)*EL*(C2B*(CW^2*SA*SB*(2*dSW1*MW^2 - 
           SW*(dMWsq1 + MW^2*(2*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[2, 2] + 
               dZHiggs1[5, 5]))) + MW^2*(4*CAB*dSW1*SW^2 + 
           CW^4*SAB*SW*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))) - 
       CW^2*(CA*(MW^2*SW*(2*CW^2*dSB1*S2B + dCB1*(2 - 4*CB^2*SW^2) + 
             (C2B + 2*CW^2)*SB*dZHiggs1[1, 2]) - CB*(1 + 2*CW^2*SB^2 - 
             2*CB^2*SW^2)*(2*dSW1*MW^2 - SW*(dMWsq1 + MW^2*(2*dZe1 + 
                 dZbarHiggs1[5, 5] + dZHiggs1[2, 2] + dZHiggs1[5, 5])))) - 
         2*CW^2*SA*(2*dSW1*MW^2*SB - SW*(dCB1*MW^2*S2B + 
             SB*(dMWsq1 + MW^2*(2*dZe1 + dZbarHiggs1[5, 5] - 
                 (S2B*dZHiggs1[1, 2])/2 + dZHiggs1[2, 2] + dZHiggs1[5, 
                  5])))) + MW^2*SW*(SA*(dSB1*(2 - 4*SB^2*SW^2) - 
             (CB - 2*CB^3*SW^2)*dZHiggs1[1, 2]) - CAB*S2B*SW^2*
            (dZHiggs1[5, 6] + dZHiggs1[6, 5])))))/(CW^4*MW*SW^2)}}, 
 C[S[2], S[6], -S[6]] == {{((-I/2)*C2B*CAB*EL*MW)/(CW^2*SW), 
    ((-I/4)*EL*(CW^2*MW^2*SW*(dSB1*SA*(2 - 4*CB^2*SW^2) + 
         CA*dCB1*(2 - 4*SB^2*SW^2) - S2B*(2*CW^2*(CA*dSB1 + dCB1*SA) + 
           CAB*SW^2*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))) + 
       C2B*(MW^2*(4*CAB*dSW1*SW^2 - CW^4*SAB*SW*(dZHiggs1[5, 6] + 
             dZHiggs1[6, 5])) - CW^2*(MW^2*SAB*SW*dZHiggs1[1, 2] + 
           CA*CB*(2*dSW1*MW^2 - SW*(dMWsq1 + MW^2*(2*dZe1 + dZHiggs1[2, 2] + 
                 2*dZHiggs1[6, 6]))) + SA*SB*(dMWsq1*SW - 
             MW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[2, 2] + 2*dZHiggs1[6, 
                   6])))))))/(CW^4*MW*SW^2)}}, 
 C[S[2], S[5], -S[6]] == {{(I/2)*EL*MW*((C2B*SAB)/SW + (CAB*S2B*SW)/CW^2), 
    ((-I/4)*EL*(C2B*CW^4*(2*dSW1*MW^2*SAB - 
         SW*(dMWsq1*SAB + MW^2*(CAB*(2*CB^2*dTB1 + dZHiggs1[1, 2]) + 
             SAB*(2*dZe1 + dZHiggs1[2, 2] + dZHiggs1[5, 5] + dZHiggs1[6, 
                6])))) + 
       SW*(CW^2*MW^2*(S2B*SAB*SW^2*(2*CB^2*dTB1 + dZHiggs1[1, 2]) + 
           CW^2*(S2B*(2*CB*SA - SAB) + 2*(SA*SB^3 + CA*(CB^3 + S2B*SB)))*
            dZHiggs1[6, 5]) - CAB*S2B*SW*(4*dSW1*MW^2*SW^2 + 
           CW^2*(dMWsq1*SW + MW^2*(2*dSW1 + SW*(2*dZe1 + dZHiggs1[2, 2] + 
                 dZHiggs1[5, 5] + dZHiggs1[6, 6])))))))/(CW^4*MW*SW^2)}}, 
 C[S[2], S[6], -S[5]] == {{(I/2)*EL*MW*((C2B*SAB)/SW + (CAB*S2B*SW)/CW^2), 
    ((-I/4)*EL*(C2B*CW^4*(2*dSW1*MW^2*SAB - 
         SW*(dMWsq1*SAB + MW^2*(CAB*(2*CB^2*dTB1 + dZHiggs1[1, 2]) + 
             SAB*(2*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[2, 2] + dZHiggs1[6, 
                6])))) + 
       SW*(CW^2*MW^2*(S2B*SAB*SW^2*(2*CB^2*dTB1 + dZHiggs1[1, 2]) + 
           CW^2*(2*CA*CB^3 + S2B*SAB + 2*SA*SB^3)*dZHiggs1[5, 6]) - 
         CAB*S2B*SW*(4*dSW1*MW^2*SW^2 + CW^2*(dMWsq1*SW + 
             MW^2*(2*dSW1 + SW*(2*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[2, 2] + 
                 dZHiggs1[6, 6])))))))/(CW^4*MW*SW^2)}}, 
 C[S[3], S[5], -S[6]] == 
  {{-(EL*MW)/(2*SW), 
    (EL*(MW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[3, 3] + dZHiggs1[5, 5])) - 
       SW*(dMWsq1 + MW^2*(2*(CB*dCB1 + dSB1*SB) + dZHiggs1[6, 6]))))/
     (4*MW*SW^2)}}, C[S[3], S[6], -S[5]] == 
  {{(EL*MW)/(2*SW), 
    (EL*(SW*(dMWsq1 + MW^2*(2*(CB*dCB1 + dSB1*SB) + dZbarHiggs1[5, 5])) - 
       MW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[3, 3] + dZHiggs1[6, 6]))))/
     (4*MW*SW^2)}}, C[S[4], S[5], -S[6]] == 
  {{0, (EL*MW*(2*CB*dSB1 - 2*dCB1*SB - dZHiggs1[3, 4]))/(4*SW)}}, 
 C[S[4], S[6], -S[5]] == 
  {{0, -(EL*MW*(2*CB*dSB1 - 2*dCB1*SB - dZHiggs1[3, 4]))/(4*SW)}}, 
 C[S[1], S[3], V[2]] == {{(CBA*EL)/(2*CW*SW), 
    (EL*(CBA*(2*dSW1*SW^2 - CW^2*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + 
             dZHiggs1[1, 1] + dZHiggs1[3, 3]))) - 
       CW^2*SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[3, 4])))/(4*CW^3*SW^2)}}, 
 C[S[1], S[4], V[2]] == {{(EL*SBA)/(2*CW*SW), 
    (EL*(2*dSW1*SBA*SW^2 - CW^2*(2*dSW1*SBA - 
         SW*(CBA*(dZHiggs1[1, 2] + dZHiggs1[3, 4]) + 
           SBA*(2*dZe1 + dZZZ1 + dZHiggs1[1, 1] + dZHiggs1[4, 4])))))/
     (4*CW^3*SW^2)}}, C[S[2], S[3], V[2]] == 
  {{-(EL*SBA)/(2*CW*SW), 
    -(EL*(2*dSW1*SBA*SW^2 - CW^2*(2*dSW1*SBA - 
          SW*(SBA*(2*dZe1 + dZZZ1 + dZHiggs1[2, 2] + dZHiggs1[3, 3]) - 
            CBA*(dZHiggs1[1, 2] + dZHiggs1[3, 4])))))/(4*CW^3*SW^2)}}, 
 C[S[2], S[4], V[2]] == {{(CBA*EL)/(2*CW*SW), 
    (EL*(CW^2*SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[3, 4]) + 
       CBA*(2*dSW1*SW^2 - CW^2*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + 
             dZHiggs1[2, 2] + dZHiggs1[4, 4])))))/(4*CW^3*SW^2)}}, 
 C[S[5], -S[5], V[1]] == 
  {{I*EL, (I/4)*EL*(2*dZAA1 + 4*dZe1 + dZZA1*(CW/SW - SW/CW) + 
      2*(dZbarHiggs1[5, 5] + dZHiggs1[5, 5]))}}, 
 C[S[5], -S[5], V[2]] == {{((-I/2)*(1 - 2*CW^2)*EL)/(CW*SW), 
    ((-I/4)*EL*(2*dSW1*SW^4 + CW^4*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + 
           dZbarHiggs1[5, 5] + dZHiggs1[5, 5])) - 
       SW^2*(2*CW^3*dZAZ1 - CW^2*(4*dSW1 + SW*(2*dZe1 + dZZZ1 + 
             dZbarHiggs1[5, 5] + dZHiggs1[5, 5])))))/(CW^3*SW^2)}}, 
 C[S[1], S[5], -V[3]] == {{((-I/2)*CBA*EL)/SW, 
    ((I/4)*EL*(CBA*(2*dSW1 - SW*(dZbarW1 + 2*dZe1 + dZHiggs1[1, 1] + 
           dZHiggs1[5, 5])) + SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[6, 5])))/
     SW^2}}, C[S[1], S[6], -V[3]] == 
  {{((-I/2)*EL*SBA)/SW, 
    ((I/4)*EL*(2*dSW1*SBA - SW*(CBA*(dZHiggs1[1, 2] + dZHiggs1[5, 6]) + 
         SBA*(dZbarW1 + 2*dZe1 + dZHiggs1[1, 1] + dZHiggs1[6, 6]))))/SW^2}}, 
 C[S[2], S[5], -V[3]] == {{((I/2)*EL*SBA)/SW, 
    ((-I/4)*EL*(2*dSW1*SBA - SW*(SBA*(dZbarW1 + 2*dZe1 + dZHiggs1[2, 2] + 
           dZHiggs1[5, 5]) - CBA*(dZHiggs1[1, 2] + dZHiggs1[6, 5]))))/SW^2}}, 
 C[S[2], S[6], -V[3]] == {{((-I/2)*CBA*EL)/SW, 
    ((-I/4)*EL*(SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[5, 6]) - 
       CBA*(2*dSW1 - SW*(dZbarW1 + 2*dZe1 + dZHiggs1[2, 2] + 
           dZHiggs1[6, 6]))))/SW^2}}, C[S[1], -S[5], V[3]] == 
  {{((I/2)*CBA*EL)/SW, 
    ((-I/4)*EL*(CBA*(2*dSW1 - SW*(2*dZe1 + dZW1 + dZbarHiggs1[5, 5] + 
           dZHiggs1[1, 1])) + SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[5, 6])))/
     SW^2}}, C[S[1], -S[6], V[3]] == 
  {{((I/2)*EL*SBA)/SW, ((-I/4)*EL*(2*dSW1*SBA - 
       SW*(CBA*(dZHiggs1[1, 2] + dZHiggs1[6, 5]) + 
         SBA*(2*dZe1 + dZW1 + dZHiggs1[1, 1] + dZHiggs1[6, 6]))))/SW^2}}, 
 C[S[2], -S[5], V[3]] == {{((-I/2)*EL*SBA)/SW, 
    ((I/4)*EL*(2*dSW1*SBA - SW*(SBA*(2*dZe1 + dZW1 + dZbarHiggs1[5, 5] + 
           dZHiggs1[2, 2]) - CBA*(dZHiggs1[1, 2] + dZHiggs1[5, 6]))))/SW^2}}, 
 C[S[2], -S[6], V[3]] == {{((I/2)*CBA*EL)/SW, 
    ((I/4)*EL*(SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[6, 5]) - 
       CBA*(2*dSW1 - SW*(2*dZe1 + dZW1 + dZHiggs1[2, 2] + dZHiggs1[6, 6]))))/
     SW^2}}, C[S[3], S[5], -V[3]] == 
  {{EL/(2*SW), -(EL*(2*dSW1 - SW*(dZbarW1 + 2*dZe1 + dZHiggs1[3, 3] + 
          dZHiggs1[5, 5])))/(4*SW^2)}}, C[S[3], -S[5], V[3]] == 
  {{EL/(2*SW), -(EL*(2*dSW1 - SW*(2*dZe1 + dZW1 + dZbarHiggs1[5, 5] + 
          dZHiggs1[3, 3])))/(4*SW^2)}}, C[S[1], V[2], V[2]] == 
  {{(I*EL*MW*SBA)/(CW^2*SW), ((I/2)*EL*(4*dSW1*MW^2*SBA*SW^2 - 
       CW^2*(2*dSW1*MW^2*SBA - SW*(dMWsq1*SBA + 
           MW^2*(SBA*(2*(dZe1 + dZZZ1) + dZHiggs1[1, 1]) + 
             CBA*(2*CB^2*dTB1 + dZHiggs1[1, 2]))))))/(CW^4*MW*SW^2)}}, 
 C[S[2], V[2], V[2]] == {{(I*CBA*EL*MW)/(CW^2*SW), 
    ((-I/2)*EL*(CW^2*MW^2*SBA*SW*(2*CB^2*dTB1 - dZHiggs1[1, 2]) - 
       CBA*(4*dSW1*MW^2*SW^2 - CW^2*(2*dSW1*MW^2 - 
           SW*(dMWsq1 + MW^2*(2*(dZe1 + dZZZ1) + dZHiggs1[2, 2]))))))/
     (CW^4*MW*SW^2)}}, C[S[1], V[3], -V[3]] == 
  {{(I*EL*MW*SBA)/SW, ((-I/2)*EL*(2*dSW1*MW^2*SBA - 
       SW*(dMWsq1*SBA + MW^2*(SBA*(dZbarW1 + 2*dZe1 + dZW1 + 
             dZHiggs1[1, 1]) + CBA*(2*CB^2*dTB1 + dZHiggs1[1, 2])))))/
     (MW*SW^2)}}, C[S[2], V[3], -V[3]] == 
  {{(I*CBA*EL*MW)/SW, 
    ((-I/2)*EL*(MW^2*SBA*SW*(2*CB^2*dTB1 - dZHiggs1[1, 2]) + 
       CBA*(2*dSW1*MW^2 - SW*(dMWsq1 + MW^2*(dZbarW1 + 2*dZe1 + dZW1 + 
             dZHiggs1[2, 2])))))/(MW*SW^2)}}, 
 C[S[1], U[2], -U[2]] == {{((-I/2)*EL*MW*SBA*GaugeXi[Z])/(CW^2*SW)}}, 
 C[S[2], U[2], -U[2]] == {{((-I/2)*CBA*EL*MW*GaugeXi[Z])/(CW^2*SW)}}, 
 C[S[1], U[3], -U[3]] == {{((-I/2)*EL*MW*SBA*GaugeXi[W])/SW}}, 
 C[S[2], U[3], -U[3]] == {{((-I/2)*CBA*EL*MW*GaugeXi[W])/SW}}, 
 C[S[1], U[4], -U[4]] == {{((-I/2)*EL*MW*SBA*GaugeXi[W])/SW}}, 
 C[S[2], U[4], -U[4]] == {{((-I/2)*CBA*EL*MW*GaugeXi[W])/SW}}, 
 C[S[1], S[1], S[1], S[1]] == {{(((-3*I)/4)*C2A^2*EL^2)/(CW^2*SW^2), 
    (((-3*I)/2)*C2A*EL^2*
      (C2A*(dSW1*SW^2 - CW^2*(dSW1 - SW*(dZe1 + dZHiggs1[1, 1]))) + 
       CW^2*S2A*SW*dZHiggs1[1, 2]))/(CW^4*SW^3)}}, 
 C[S[1], S[1], S[1], S[2]] == {{(((-3*I)/4)*C2A*EL^2*S2A)/(CW^2*SW^2), 
    (((-3*I)/8)*EL^2*S2A*(2*CW^2*S2A*SW*dZHiggs1[1, 2] + 
       C2A*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(4*dZe1 + 3*dZHiggs1[1, 1] + 
             dZHiggs1[2, 2])))))/(CW^4*SW^3)}}, 
 C[S[1], S[1], S[2], S[2]] == {{((I/4)*EL^2*(1 - 3*S2A^2))/(CW^2*SW^2), 
    ((I/4)*EL^2*(1 - 3*S2A^2)*(2*dSW1*SW^2 - 
       CW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[1, 1] + dZHiggs1[2, 2]))))/
     (CW^4*SW^3)}}, C[S[1], S[2], S[2], S[2]] == 
  {{(((3*I)/4)*C2A*EL^2*S2A)/(CW^2*SW^2), 
    (((-3*I)/8)*EL^2*S2A*(2*CW^2*S2A*SW*dZHiggs1[1, 2] - 
       C2A*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + 
             3*dZHiggs1[2, 2])))))/(CW^4*SW^3)}}, 
 C[S[2], S[2], S[2], S[2]] == {{(((-3*I)/4)*C2A^2*EL^2)/(CW^2*SW^2), 
    (((3*I)/2)*C2A*EL^2*(CW^2*S2A*SW*dZHiggs1[1, 2] - 
       C2A*(dSW1*SW^2 - CW^2*(dSW1 - SW*(dZe1 + dZHiggs1[2, 2])))))/
     (CW^4*SW^3)}}, C[S[1], S[1], S[3], S[3]] == 
  {{((-I/4)*C2A*C2B*EL^2)/(CW^2*SW^2), 
    ((-I/4)*EL^2*(C2B*CW^2*S2A*SW*dZHiggs1[1, 2] + 
       C2A*(C2B*(2*dSW1*SW^2 - CW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[1, 1] + 
               dZHiggs1[3, 3]))) + CW^2*S2B*SW*dZHiggs1[3, 4])))/
     (CW^4*SW^3)}}, C[S[1], S[1], S[4], S[4]] == 
  {{((I/4)*C2A*C2B*EL^2)/(CW^2*SW^2), 
    ((I/4)*EL^2*(C2B*CW^2*S2A*SW*dZHiggs1[1, 2] - 
       C2A*(CW^2*S2B*SW*dZHiggs1[3, 4] - C2B*(2*dSW1*SW^2 - 
           CW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[1, 1] + dZHiggs1[4, 4]))))))/
     (CW^4*SW^3)}}, C[S[1], S[1], S[3], S[4]] == 
  {{((-I/4)*C2A*EL^2*S2B)/(CW^2*SW^2), 
    ((-I/8)*EL^2*S2B*(2*CW^2*S2A*SW*dZHiggs1[1, 2] + 
       C2A*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(4*dZe1 + 2*dZHiggs1[1, 1] + 
             dZHiggs1[3, 3] + dZHiggs1[4, 4])))))/(CW^4*SW^3)}}, 
 C[S[1], S[2], S[3], S[3]] == {{((-I/4)*C2B*EL^2*S2A)/(CW^2*SW^2), 
    ((-I/8)*EL^2*S2A*(C2B*(4*dSW1*SW^2 - 
         CW^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[2, 2] + 
             2*dZHiggs1[3, 3]))) + 2*CW^2*S2B*SW*dZHiggs1[3, 4]))/
     (CW^4*SW^3)}}, C[S[1], S[2], S[4], S[4]] == 
  {{((I/4)*C2B*EL^2*S2A)/(CW^2*SW^2), 
    ((-I/8)*EL^2*S2A*(2*CW^2*S2B*SW*dZHiggs1[3, 4] - 
       C2B*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + 
             dZHiggs1[2, 2] + 2*dZHiggs1[4, 4])))))/(CW^4*SW^3)}}, 
 C[S[1], S[2], S[3], S[4]] == {{((-I/4)*EL^2*S2A*S2B)/(CW^2*SW^2), 
    ((-I/8)*EL^2*S2A*S2B*(4*dSW1*SW^2 - 
       CW^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[2, 2] + 
           dZHiggs1[3, 3] + dZHiggs1[4, 4]))))/(CW^4*SW^3)}}, 
 C[S[2], S[2], S[3], S[3]] == {{((I/4)*C2A*C2B*EL^2)/(CW^2*SW^2), 
    ((-I/4)*EL^2*(C2B*(CW^2*S2A*SW*dZHiggs1[1, 2] - 
         C2A*(2*dSW1*SW^2 - CW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[2, 2] + 
               dZHiggs1[3, 3])))) - C2A*CW^2*S2B*SW*dZHiggs1[3, 4]))/
     (CW^4*SW^3)}}, C[S[2], S[2], S[4], S[4]] == 
  {{((-I/4)*C2A*C2B*EL^2)/(CW^2*SW^2), 
    ((I/4)*EL^2*(C2B*CW^2*S2A*SW*dZHiggs1[1, 2] + 
       C2A*(CW^2*S2B*SW*dZHiggs1[3, 4] - C2B*(2*dSW1*SW^2 - 
           CW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[2, 2] + dZHiggs1[4, 4]))))))/
     (CW^4*SW^3)}}, C[S[2], S[2], S[3], S[4]] == 
  {{((I/4)*C2A*EL^2*S2B)/(CW^2*SW^2), 
    ((-I/8)*EL^2*S2B*(2*CW^2*S2A*SW*dZHiggs1[1, 2] - 
       C2A*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(4*dZe1 + 2*dZHiggs1[2, 2] + 
             dZHiggs1[3, 3] + dZHiggs1[4, 4])))))/(CW^4*SW^3)}}, 
 C[S[1], S[1], S[5], -S[5]] == 
  {{(-I/4)*EL^2*((C2A*C2B)/CW^2 + (1 - S2A*S2B)/SW^2), 
    ((-I/8)*EL^2*(4*C2A*C2B*dSW1*SW^4 - CW^4*(4*dSW1*(1 - S2A*S2B) - 
         SW*(4*dZe1 + dZbarHiggs1[5, 5] + 2*dZHiggs1[1, 1] + dZHiggs1[5, 5] + 
           S2B*(2*C2A*dZHiggs1[1, 2] - S2A*(4*dZe1 + dZbarHiggs1[5, 5] + 2*
                dZHiggs1[1, 1] + dZHiggs1[5, 5])) + 
           C2B*S2A*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))) + 
       CW^2*SW^3*(2*C2B*S2A*dZHiggs1[1, 2] + 
         C2A*(C2B*(4*dZe1 + dZbarHiggs1[5, 5] + 2*dZHiggs1[1, 1] + 
             dZHiggs1[5, 5]) + S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5])))))/
     (CW^4*SW^3)}}, C[S[1], S[1], S[6], -S[6]] == 
  {{(I/4)*EL^2*((C2A*C2B)/CW^2 - (1 + S2A*S2B)/SW^2), 
    ((I/8)*EL^2*(4*C2A*C2B*dSW1*SW^4 + CW^2*SW^3*(2*C2B*S2A*dZHiggs1[1, 2] - 
         C2A*(S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - 
           2*C2B*(2*dZe1 + dZHiggs1[1, 1] + dZHiggs1[6, 6]))) + 
       CW^4*(4*dSW1*(1 + S2A*S2B) - SW*(4*dZe1*(1 + S2A*S2B) + 
           C2B*S2A*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) + 
           2*(dZHiggs1[1, 1] + dZHiggs1[6, 6] - S2B*(C2A*dZHiggs1[1, 2] - S2A*
                (dZHiggs1[1, 1] + dZHiggs1[6, 6])))))))/(CW^4*SW^3)}}, 
 C[S[1], S[1], S[5], -S[6]] == 
  {{(-I/4)*EL^2*((C2A*S2B)/CW^2 + (C2B*S2A)/SW^2), 
    ((I/8)*EL^2*(C2B*CW^4*(4*dSW1*S2A + SW*(2*C2A*dZHiggs1[1, 2] - 
           S2A*(4*dZe1 + 2*dZHiggs1[1, 1] + dZHiggs1[5, 5] + 
             dZHiggs1[6, 6]))) - SW*(2*CW^4*dZHiggs1[6, 5] + 
         S2B*SW^2*(2*CW^2*S2A*dZHiggs1[1, 2] + C2A*(4*dSW1*SW + 
             CW^2*(4*dZe1 + 2*dZHiggs1[1, 1] + dZHiggs1[5, 5] + dZHiggs1[6, 
                6]))))))/(CW^4*SW^3)}}, C[S[1], S[1], S[6], -S[5]] == 
  {{(-I/4)*EL^2*((C2A*S2B)/CW^2 + (C2B*S2A)/SW^2), 
    ((I/8)*EL^2*(C2B*CW^4*(4*dSW1*S2A + SW*(2*C2A*dZHiggs1[1, 2] - 
           S2A*(4*dZe1 + dZbarHiggs1[5, 5] + 2*dZHiggs1[1, 1] + 
             dZHiggs1[6, 6]))) - SW*(2*CW^4*dZHiggs1[5, 6] + 
         S2B*SW^2*(2*CW^2*S2A*dZHiggs1[1, 2] + C2A*(4*dSW1*SW + 
             CW^2*(4*dZe1 + dZbarHiggs1[5, 5] + 2*dZHiggs1[1, 1] + dZHiggs1[
                6, 6]))))))/(CW^4*SW^3)}}, C[S[1], S[2], S[5], -S[5]] == 
  {{(-I/4)*EL^2*((C2B*S2A)/CW^2 + (C2A*S2B)/SW^2), 
    ((-I/8)*EL^2*(C2B*S2A*SW^3*(4*dSW1*SW + 
         CW^2*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[1, 1] + dZHiggs1[2, 2] + 
           dZHiggs1[5, 5])) + CW^2*SW*(2*CW^2*dZHiggs1[1, 2] + 
         S2A*S2B*SW^2*(dZHiggs1[5, 6] + dZHiggs1[6, 5])) - 
       C2A*CW^4*(4*dSW1*S2B - SW*(S2B*(4*dZe1 + dZbarHiggs1[5, 5] + 
             dZHiggs1[1, 1] + dZHiggs1[2, 2] + dZHiggs1[5, 5]) - 
           C2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5])))))/(CW^4*SW^3)}}, 
 C[S[1], S[2], S[6], -S[6]] == 
  {{(I/4)*EL^2*((C2B*S2A)/CW^2 + (C2A*S2B)/SW^2), 
    ((-I/8)*EL^2*(CW^2*SW*(2*CW^2*dZHiggs1[1, 2] + S2A*S2B*SW^2*
          (dZHiggs1[5, 6] + dZHiggs1[6, 5])) - C2B*S2A*SW^3*
        (4*dSW1*SW + CW^2*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[2, 2] + 
           2*dZHiggs1[6, 6])) + C2A*CW^4*(4*dSW1*S2B - 
         SW*(C2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) + 
           S2B*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[2, 2] + 
             2*dZHiggs1[6, 6])))))/(CW^4*SW^3)}}, 
 C[S[1], S[2], S[5], -S[6]] == 
  {{(-I/4)*EL^2*((S2A*S2B)/CW^2 - (C2A*C2B)/SW^2), 
    ((-I/8)*EL^2*(S2A*S2B*SW^3*(4*dSW1*SW + CW^2*(4*dZe1 + dZHiggs1[1, 1] + 
           dZHiggs1[2, 2] + dZHiggs1[5, 5] + dZHiggs1[6, 6])) + 
       C2A*C2B*CW^4*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[2, 2] + 
           dZHiggs1[5, 5] + dZHiggs1[6, 6]))))/(CW^4*SW^3)}}, 
 C[S[1], S[2], S[6], -S[5]] == 
  {{(-I/4)*EL^2*((S2A*S2B)/CW^2 - (C2A*C2B)/SW^2), 
    ((-I/8)*EL^2*(S2A*S2B*SW^3*(4*dSW1*SW + 
         CW^2*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[1, 1] + dZHiggs1[2, 2] + 
           dZHiggs1[6, 6])) + C2A*C2B*CW^4*(4*dSW1 - 
         SW*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[1, 1] + dZHiggs1[2, 2] + 
           dZHiggs1[6, 6]))))/(CW^4*SW^3)}}, C[S[2], S[2], S[5], -S[5]] == 
  {{(I/4)*EL^2*((C2A*C2B)/CW^2 - (1 + S2A*S2B)/SW^2), 
    ((I/8)*EL^2*(4*C2A*C2B*dSW1*SW^4 - CW^2*SW^3*(2*C2B*S2A*dZHiggs1[1, 2] - 
         C2A*(C2B*(4*dZe1 + dZbarHiggs1[5, 5] + 2*dZHiggs1[2, 2] + 
             dZHiggs1[5, 5]) + S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))) + 
       CW^4*(4*dSW1*(1 + S2A*S2B) - SW*(4*dZe1*(1 + S2A*S2B) + 
           dZbarHiggs1[5, 5] + 2*(C2A*S2B*dZHiggs1[1, 2] + dZHiggs1[2, 2]) + 
           dZHiggs1[5, 5] + S2A*(S2B*(dZbarHiggs1[5, 5] + 2*dZHiggs1[2, 2] + 
               dZHiggs1[5, 5]) - C2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))))))/
     (CW^4*SW^3)}}, C[S[2], S[2], S[6], -S[6]] == 
  {{(-I/4)*EL^2*((C2A*C2B)/CW^2 + (1 - S2A*S2B)/SW^2), 
    ((-I/8)*EL^2*(4*C2A*C2B*dSW1*SW^4 - CW^2*SW^3*(2*C2B*S2A*dZHiggs1[1, 2] + 
         C2A*(S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - 
           2*C2B*(2*dZe1 + dZHiggs1[2, 2] + dZHiggs1[6, 6]))) - 
       CW^4*(dSW1*(4 - 4*S2A*S2B) - SW*(4*dZe1 - C2B*S2A*(dZHiggs1[5, 6] + 
             dZHiggs1[6, 5]) + 2*(dZHiggs1[2, 2] + dZHiggs1[6, 6]) - 
           2*S2B*(C2A*dZHiggs1[1, 2] + S2A*(2*dZe1 + dZHiggs1[2, 2] + 
               dZHiggs1[6, 6]))))))/(CW^4*SW^3)}}, 
 C[S[2], S[2], S[5], -S[6]] == 
  {{(I/4)*EL^2*((C2A*S2B)/CW^2 + (C2B*S2A)/SW^2), 
    ((-I/8)*EL^2*(S2B*SW^3*(2*CW^2*S2A*dZHiggs1[1, 2] - 
         C2A*(4*dSW1*SW + CW^2*(4*dZe1 + 2*dZHiggs1[2, 2] + dZHiggs1[5, 5] + 
             dZHiggs1[6, 6]))) + CW^4*(2*SW*dZHiggs1[6, 5] + 
         C2B*(4*dSW1*S2A - SW*(2*C2A*dZHiggs1[1, 2] + 
             S2A*(4*dZe1 + 2*dZHiggs1[2, 2] + dZHiggs1[5, 5] + dZHiggs1[6, 
                6]))))))/(CW^4*SW^3)}}, C[S[2], S[2], S[6], -S[5]] == 
  {{(I/4)*EL^2*((C2A*S2B)/CW^2 + (C2B*S2A)/SW^2), 
    ((-I/8)*EL^2*(S2B*SW^3*(2*CW^2*S2A*dZHiggs1[1, 2] - 
         C2A*(4*dSW1*SW + CW^2*(4*dZe1 + dZbarHiggs1[5, 5] + 
             2*dZHiggs1[2, 2] + dZHiggs1[6, 6]))) + 
       CW^4*(2*SW*dZHiggs1[5, 6] + C2B*(4*dSW1*S2A - 
           SW*(2*C2A*dZHiggs1[1, 2] + S2A*(4*dZe1 + dZbarHiggs1[5, 5] + 2*
                dZHiggs1[2, 2] + dZHiggs1[6, 6]))))))/(CW^4*SW^3)}}, 
 C[S[1], S[3], S[5], -S[6]] == 
  {{-(EL^2*SBA)/(4*SW^2), 
    -(EL^2*(CB*(4*dSW1*SA + SW*(CA*(dZHiggs1[1, 2] - dZHiggs1[3, 4]) - 
            SA*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[3, 3] + dZHiggs1[5, 
               5]))) + SB*(SA*SW*(dZHiggs1[1, 2] - dZHiggs1[3, 4]) - 
          CA*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[3, 3] + 
              dZHiggs1[5, 5]))) + SBA*SW*dZHiggs1[6, 6]))/(8*SW^3)}}, 
 C[S[1], S[3], S[6], -S[5]] == 
  {{(EL^2*SBA)/(4*SW^2), 
    (EL^2*(SW*(SBA*dZbarHiggs1[5, 5] + SA*SB*(dZHiggs1[1, 2] - 
           dZHiggs1[3, 4])) - CA*SB*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + 
           dZHiggs1[3, 3] + dZHiggs1[6, 6])) + 
       CB*(4*dSW1*SA + SW*(CA*(dZHiggs1[1, 2] - dZHiggs1[3, 4]) - 
           SA*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[3, 3] + dZHiggs1[6, 6])))))/
     (8*SW^3)}}, C[S[1], S[4], S[5], -S[6]] == 
  {{(CBA*EL^2)/(4*SW^2), 
    -(EL^2*(SB*(4*dSW1*SA + CA*SW*(dZHiggs1[1, 2] + dZHiggs1[3, 4])) + 
        CA*CB*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[4, 4] + 
            dZHiggs1[5, 5])) - SW*(SA*(CB*(dZHiggs1[1, 2] + dZHiggs1[3, 4]) + 
            SB*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[4, 4] + dZHiggs1[5, 5])) + 
          CBA*dZHiggs1[6, 6])))/(8*SW^3)}}, C[S[1], S[4], S[6], -S[5]] == 
  {{-(CBA*EL^2)/(4*SW^2), 
    (EL^2*(SB*(4*dSW1*SA + CA*SW*(dZHiggs1[1, 2] + dZHiggs1[3, 4])) + 
       CA*CB*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[4, 4] + 
           dZHiggs1[6, 6])) - SW*(CBA*dZbarHiggs1[5, 5] + 
         SA*(CB*(dZHiggs1[1, 2] + dZHiggs1[3, 4]) + 
           SB*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[4, 4] + dZHiggs1[6, 6])))))/
     (8*SW^3)}}, C[S[2], S[3], S[5], -S[6]] == 
  {{-(CBA*EL^2)/(4*SW^2), 
    (EL^2*(4*dSW1*SA*SB - CA*(SB*SW*(dZHiggs1[1, 2] + dZHiggs1[3, 4]) - 
         CB*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[3, 3] + 
             dZHiggs1[5, 5]))) + 
       SW*(SA*(CB*(dZHiggs1[1, 2] + dZHiggs1[3, 4]) - 
           SB*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[3, 3] + dZHiggs1[5, 5])) - 
         CBA*dZHiggs1[6, 6])))/(8*SW^3)}}, C[S[2], S[3], S[6], -S[5]] == 
  {{(CBA*EL^2)/(4*SW^2), 
    -(EL^2*(4*dSW1*SA*SB - SW*(CBA*dZbarHiggs1[5, 5] - 
          SA*(CB*(dZHiggs1[1, 2] + dZHiggs1[3, 4]) - 
            SB*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[3, 3] + dZHiggs1[6, 
               6]))) - CA*(SB*SW*(dZHiggs1[1, 2] + dZHiggs1[3, 4]) - 
          CB*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[3, 3] + 
              dZHiggs1[6, 6])))))/(8*SW^3)}}, C[S[2], S[4], S[5], -S[6]] == 
  {{-(EL^2*SBA)/(4*SW^2), 
    (EL^2*(CA*SB*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[4, 4] + 
           dZHiggs1[5, 5])) - CB*(4*dSW1*SA - 
         SW*(CA*(dZHiggs1[1, 2] - dZHiggs1[3, 4]) + 
           SA*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[4, 4] + dZHiggs1[5, 5]))) + 
       SW*(SA*SB*(dZHiggs1[1, 2] - dZHiggs1[3, 4]) - SBA*dZHiggs1[6, 6])))/
     (8*SW^3)}}, C[S[2], S[4], S[6], -S[5]] == 
  {{(EL^2*SBA)/(4*SW^2), 
    (EL^2*(SW*(SBA*dZbarHiggs1[5, 5] - SA*SB*(dZHiggs1[1, 2] - 
           dZHiggs1[3, 4])) - CA*SB*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[2, 2] + 
           dZHiggs1[4, 4] + dZHiggs1[6, 6])) + 
       CB*(4*dSW1*SA - SW*(CA*(dZHiggs1[1, 2] - dZHiggs1[3, 4]) + 
           SA*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[4, 4] + dZHiggs1[6, 6])))))/
     (8*SW^3)}}, C[S[3], S[3], S[3], S[3]] == 
  {{(((-3*I)/4)*EL^2*(1 + 10*CB^4 - CB^2*(4 + 3*S2B^2) - 
       6*(C2B^2*CB^8 + CB^6*S2B^2) + (3*S2B^4*(5 - 8*SB^2 + 4*SB^4))/8))/
     (CW^2*SW^2), (((3*I)/64)*EL^2*
      (dSW1*(9*S2B^6 - 32*SB^12 + 16*S2B^2*SB^4*(2 - 3*SB^4) - 
         2*S2B^4*(8 - 4*C2B - SB^4))*SW^2 - 
       32*CB^12*(dSW1*SW^2 - CW^2*(dSW1 - SW*(dZe1 + dZHiggs1[3, 3]))) - 
       2*CB^2*S2B^2*(4*C2B*(4 - S2B^2)*(dSW1*SW^2 - 
           CW^2*(dSW1 - SW*(dZe1 + dZHiggs1[3, 3]))) + 
         CW^2*S2B*(14 - 3*S2B^2)*SW*dZHiggs1[3, 4]) - 
       CW^2*((128*CB^11*dCB1 - 32*C2B*CB^7*dSB1*S2B + 2*CB*S2B^2*
            (dSB1*S2B*(16 - 15*S2B^2) + 2*C2B*dCB1*(12 - 5*S2B^2)) + 
           S2B*(8*CB^3*(18*C2B^2*dCB1*S2B + C2B*dSB1*(4 - 3*S2B^2) - 6*dCB1*
                S2B*(1 - S2B^2)) - 16*CB^5*(7*C2B*dCB1*S2B - dSB1*
                (4 - S2B^2))) + (-48*C2B*dSB1*S2B^2 + 8*(4 - C2B)*dCB1*
              S2B^3 + 20*C2B*dSB1*S2B^4 - 42*dCB1*S2B^5)*SB + 
           (-48*dSB1*S2B^2 + 16*C2B*dCB1*S2B^3 - 24*dSB1*S2B^4)*SB^3 + 
           (-32*dCB1*S2B + 112*C2B*dSB1*S2B^2 + 32*dCB1*S2B^3)*SB^5 + 
           144*dSB1*S2B^2*SB^7 + 96*dCB1*S2B*SB^9 + 128*dSB1*SB^11)*SW + 
         (-8*(2 - C2B)*S2B^4 + 9*S2B^6 + (32*S2B^2 + 2*S2B^4)*SB^4 - 
           48*S2B^2*SB^8 - 32*SB^12)*(dSW1 - SW*(dZe1 + dZHiggs1[3, 3])) + 
         S2B*(16*(C2B*CB^8 + CB^10) + 2*(S2B^2*SB^2*(3*S2B^2 - 2*
                (7 - SB^2 - 6*SB^4)) + C2B*(11*S2B^4 - 12*S2B^2*
                (1 - 2*SB^4) + 8*(SB^4 + SB^8))))*SW*dZHiggs1[3, 4]) + 
       S2B*(2*CB^4*(S2B*(16 - 24*C2B^2 - 11*S2B^2)*(dSW1*SW^2 - 
             CW^2*(dSW1 - SW*(dZe1 + dZHiggs1[3, 3]))) - 
           8*C2B*CW^2*(1 + 3*S2B^2)*SW*dZHiggs1[3, 4]) + 
         4*CB^6*(8*C2B*S2B*(dSW1*SW^2 - CW^2*(dSW1 - SW*(dZe1 + dZHiggs1[3, 
                  3]))) + CW^2*(4 + 5*S2B^2)*SW*dZHiggs1[3, 4]))))/
     (CW^4*SW^3)}}, C[S[3], S[3], S[3], S[4]] == 
  {{(((-3*I)/4)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    (((-3*I)/16)*EL^2*
      (C2B*S2B*(CW^2*SW*(2*dCB1*(8*CB^7 + 2*CB^3*(2 + 9*S2B^2) - 
             S2B*SB*(6 - 11*S2B^2 - 12*SB^4)) - (1 + CB^2)*S2B*
            (4*CB^2 - 4*CB^4 - S2B^2)*dZHiggs1[3, 4]) + 
         CB^8*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(4*dZe1 + 3*dZHiggs1[3, 3] + 
               dZHiggs1[4, 4]))) + CB^4*(4*dSW1*(1 + 22*SB^4)*SW^2 - 
           CW^2*(dSW1*(4 + 88*SB^4) - SW*(176*dSB1*SB^3 + dZe1*
                (4 + 88*SB^4) + (1 + 22*SB^4)*(3*dZHiggs1[3, 3] + 
                 dZHiggs1[4, 4])))) - SB*((24*CB^2 - 48*CB^6)*CW^2*dSB1*SW + 
           (3*CB - 6*CB^5)*S2B*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(4*dZe1 + 
                 3*dZHiggs1[3, 3] + dZHiggs1[4, 4]))) - 
           SB^2*(4*dSW1*SB*(1 + 3*S2B^2 + SB^4)*SW^2 - 
             CW^2*(4*dSW1*(SB + 3*S2B^2*SB + SB^5) - SW*
                (4*dSB1*(2 + 9*S2B^2 + 4*SB^4) + SB*(1 + 3*S2B^2 + SB^4)*
                  (4*dZe1 + 3*dZHiggs1[3, 3] + dZHiggs1[4, 4])))))) + 
       2*((CW^2*SW*(4*dCB1*S2B*(56*CB^9 + CB*S2B^2*(38 - 13*S2B^2) - 
              2*CB^5*(12 + 37*S2B^2) + 2*S2B*SB^3*(11*S2B^2 - 
                2*(9 - SB^2 - 4*SB^4))) - (32*CB^8 - 32*CB^12 - 39*S2B^6 + 
              S2B^4*(44 - 94*SB^4) + 32*SB^8*(1 - SB^4) - 
              S2B^2*(2*CB^4*(16 + 24*C2B^2 + 59*S2B^2) + 16*SB^4*
                 (2 + 3*SB^4)))*dZHiggs1[3, 4]))/32 + 
         CB^11*(4*dSW1*SB*SW^2 - CW^2*(4*dSW1*SB - SW*(2*dSB1 + SB*
                (4*dZe1 + 3*dZHiggs1[3, 3] + dZHiggs1[4, 4])))) - 
         (S2B^3*SB*(4*dSW1*SB*(7 - 5*SB^4)*SW^2 - 
            CW^2*(4*dSW1*SB*(7 - 5*SB^4) - SW*(dSB1*(38 - 74*SB^4) + 
                SB*(7 - 5*SB^4)*(4*dZe1 + 3*dZHiggs1[3, 3] + dZHiggs1[4, 
                   4])))))/8 - CB^7*(4*dSW1*SB*(1 + 6*SB^4)*SW^2 - 
           CW^2*(4*dSW1*(SB + 6*SB^5) - SW*(dSB1*(2 + 44*SB^4) + SB*
                (1 + 6*SB^4)*(4*dZe1 + 3*dZHiggs1[3, 3] + dZHiggs1[4, 
                  4])))) + (S2B*SB^5*(2*CW^2*dSB1*(3 - 7*SB^4)*SW + 
            CB^2*SB*(1 + SB^2)*(4*dSW1*SW^2 - CW^2*(4*dSW1 - 
                SW*(4*dZe1 + 3*dZHiggs1[3, 3] + dZHiggs1[4, 4])))))/2 + 
         SB^2*(CB^5*(4*dSW1*SB*(7 + 6*SB^4)*SW^2 - CW^2*(4*dSW1*SB*
                (7 + 6*SB^4) - SW*(2*dSB1*(9 + 26*SB^4) + SB*(7 + 6*SB^4)*
                  (4*dZe1 + 3*dZHiggs1[3, 3] + dZHiggs1[4, 4])))) - 
           CB^9*(20*dSW1*SB*SW^2 + CW^2*(6*dSB1*SW - 5*SB*(4*dSW1 - 
                 SW*(4*dZe1 + 3*dZHiggs1[3, 3] + dZHiggs1[4, 4]))))))))/
     (CW^4*SW^3)}}, C[S[3], S[3], S[4], S[4]] == 
  {{((I/4)*EL^2*(1 - 3*S2B^2))/(CW^2*SW^2), 
    ((-I/32)*EL^2*(2*dSW1*(12*S2B^6 + 16*S2B^2*SB^4 - 8*SB^8 - 
         3*S2B^4*(5 - 2*C2B - 8*SB^4))*SW^2 + 
       CW^2*(2*dSW1*(3*S2B^4*(5 - 2*C2B - 4*S2B^2) - 8*S2B^2*(2 + 3*S2B^2)*
            SB^4 + 8*SB^8) + SW*(-48*CB^9*dSB1*S2B - 6*CB*S2B^2*
            (2*dSB1*S2B*(5 - 8*S2B^2) + C2B*dCB1*(12 - 5*S2B^2)) - 
           12*CB^3*S2B*(C2B*dSB1*(4 - 3*S2B^2) - dCB1*S2B*(4 + 13*S2B^2)) + 
           8*(CB^7*(6*C2B*dSB1*S2B - dCB1*(4 - 3*S2B^2)) + 
             CB^5*S2B*(21*C2B*dCB1*S2B + dSB1*(4 + 9*S2B^2))) + 
           (72*C2B*dSB1*S2B^2 - 12*(5 - C2B)*dCB1*S2B^3 - 30*C2B*dSB1*S2B^4 + 
             96*dCB1*S2B^5)*SB + (48*dSB1*S2B^2 - 24*C2B*dCB1*S2B^3 + 
             156*dSB1*S2B^4)*SB^3 + (32*dCB1*S2B - 168*C2B*dSB1*S2B^2 + 
             72*dCB1*S2B^3)*SB^5 + dSB1*(-32 + 24*S2B^2)*SB^7 - 
           48*dCB1*S2B*SB^9 + (-3*(5 - 2*C2B)*S2B^4 + 12*S2B^6 + 
             (16*S2B^2 + 24*S2B^4)*SB^4 - 8*SB^8)*(2*dZe1 + dZHiggs1[3, 3] + 
             dZHiggs1[4, 4]))) + (-8*CB^8 + S2B^2*(8*CB^4*(2 + 3*S2B^2) + 
           C2B*(24*CB^6 - 6*CB^2*(4 - S2B^2))))*(2*dSW1*SW^2 - 
         CW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[3, 3] + dZHiggs1[4, 4])))))/
     (CW^4*SW^3)}}, C[S[3], S[4], S[4], S[4]] == 
  {{(((3*I)/4)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    (((3*I)/16)*EL^2*
      (C2B*S2B*(CW^2*SW*(2*dCB1*(8*CB^7 + 2*CB^3*(2 + 9*S2B^2) - 
             S2B*SB*(6 - 11*S2B^2 - 12*SB^4)) + (1 + CB^2)*S2B*
            (4*CB^2 - 4*CB^4 - S2B^2)*dZHiggs1[3, 4]) + 
         CB^8*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[3, 3] + 3*
                dZHiggs1[4, 4]))) + CB^4*(4*dSW1*(1 + 22*SB^4)*SW^2 - 
           CW^2*(dSW1*(4 + 88*SB^4) - SW*(176*dSB1*SB^3 + dZe1*
                (4 + 88*SB^4) + (1 + 22*SB^4)*(dZHiggs1[3, 3] + 
                 3*dZHiggs1[4, 4])))) - SB*((24*CB^2 - 48*CB^6)*CW^2*dSB1*
            SW + (3*CB - 6*CB^5)*S2B*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*
                (4*dZe1 + dZHiggs1[3, 3] + 3*dZHiggs1[4, 4]))) - 
           SB^2*(4*dSW1*SB*(1 + 3*S2B^2 + SB^4)*SW^2 - 
             CW^2*(4*dSW1*(SB + 3*S2B^2*SB + SB^5) - SW*
                (4*dSB1*(2 + 9*S2B^2 + 4*SB^4) + SB*(1 + 3*S2B^2 + SB^4)*
                  (4*dZe1 + dZHiggs1[3, 3] + 3*dZHiggs1[4, 4])))))) + 
       2*((CW^2*SW*(4*dCB1*S2B*(56*CB^9 + CB*S2B^2*(38 - 13*S2B^2) - 
              2*CB^5*(12 + 37*S2B^2) + 2*S2B*SB^3*(11*S2B^2 - 
                2*(9 - SB^2 - 4*SB^4))) + (32*CB^8 - 32*CB^12 - 39*S2B^6 + 
              S2B^4*(44 - 94*SB^4) + 32*SB^8*(1 - SB^4) - 
              S2B^2*(2*CB^4*(16 + 24*C2B^2 + 59*S2B^2) + 16*SB^4*
                 (2 + 3*SB^4)))*dZHiggs1[3, 4]))/32 + 
         CB^11*(4*dSW1*SB*SW^2 - CW^2*(4*dSW1*SB - SW*(2*dSB1 + SB*
                (4*dZe1 + dZHiggs1[3, 3] + 3*dZHiggs1[4, 4])))) - 
         (S2B^3*SB*(4*dSW1*SB*(7 - 5*SB^4)*SW^2 - 
            CW^2*(4*dSW1*SB*(7 - 5*SB^4) - SW*(dSB1*(38 - 74*SB^4) + 
                SB*(7 - 5*SB^4)*(4*dZe1 + dZHiggs1[3, 3] + 3*dZHiggs1[4, 
                    4])))))/8 - CB^7*(4*dSW1*SB*(1 + 6*SB^4)*SW^2 - 
           CW^2*(4*dSW1*(SB + 6*SB^5) - SW*(dSB1*(2 + 44*SB^4) + SB*
                (1 + 6*SB^4)*(4*dZe1 + dZHiggs1[3, 3] + 3*dZHiggs1[4, 
                   4])))) + (S2B*SB^5*(2*CW^2*dSB1*(3 - 7*SB^4)*SW + 
            CB^2*SB*(1 + SB^2)*(4*dSW1*SW^2 - CW^2*(4*dSW1 - 
                SW*(4*dZe1 + dZHiggs1[3, 3] + 3*dZHiggs1[4, 4])))))/2 + 
         SB^2*(CB^5*(4*dSW1*SB*(7 + 6*SB^4)*SW^2 - CW^2*(4*dSW1*SB*
                (7 + 6*SB^4) - SW*(2*dSB1*(9 + 26*SB^4) + SB*(7 + 6*SB^4)*
                  (4*dZe1 + dZHiggs1[3, 3] + 3*dZHiggs1[4, 4])))) - 
           CB^9*(20*dSW1*SB*SW^2 + CW^2*(6*dSB1*SW - 5*SB*(4*dSW1 - 
                 SW*(4*dZe1 + dZHiggs1[3, 3] + 3*dZHiggs1[4, 4]))))))))/
     (CW^4*SW^3)}}, C[S[4], S[4], S[4], S[4]] == 
  {{(((-3*I)/4)*EL^2*(1 + 10*CB^4 - CB^2*(4 + 3*S2B^2) - 
       6*(C2B^2*CB^8 + CB^6*S2B^2) + (3*S2B^4*(5 - 8*SB^2 + 4*SB^4))/8))/
     (CW^2*SW^2), (((3*I)/64)*EL^2*
      (dSW1*(9*S2B^6 - 32*SB^12 + 16*S2B^2*SB^4*(2 - 3*SB^4) - 
         2*S2B^4*(8 - 4*C2B - SB^4))*SW^2 - 
       32*CB^12*(dSW1*SW^2 - CW^2*(dSW1 - SW*(dZe1 + dZHiggs1[4, 4]))) - 
       CW^2*(dSW1*(9*S2B^6 - 32*SB^12 + 16*S2B^2*SB^4*(2 - 3*SB^4) - 
           2*S2B^4*(8 - 4*C2B - SB^4)) + SW*(128*CB^11*dCB1 + 
           2*CB*S2B^2*(dSB1*S2B*(16 - 15*S2B^2) + 2*C2B*dCB1*
              (12 - 5*S2B^2)) + S2B*(-32*C2B*CB^7*dSB1 + 
             8*CB^3*(18*C2B^2*dCB1*S2B + C2B*dSB1*(4 - 3*S2B^2) - 6*dCB1*S2B*
                (1 - S2B^2)) - 16*CB^5*(7*C2B*dCB1*S2B - dSB1*(4 - S2B^2))) - 
           dZe1*(9*S2B^6 - 32*SB^12 + 16*S2B^2*SB^4*(2 - 3*SB^4) - 
             2*S2B^4*(8 - 4*C2B - SB^4)) - 16*(C2B*CB^8 + CB^10)*S2B*
            dZHiggs1[3, 4] - 2*SB*(dCB1*S2B*(21*S2B^4 + 16*SB^4 - 48*SB^8 - 
               16*S2B^2*(1 + SB^4)) + SB*(4*dSB1*SB*(3*S2B^4 - 16*SB^8 + 
                 S2B^2*(6 - 18*SB^4)) + S2B^3*(3*S2B^2 - 2*(7 - SB^2 - 
                   6*SB^4))*dZHiggs1[3, 4])) - (9*S2B^6 - 32*SB^12 + 
             16*S2B^2*SB^4*(2 - 3*SB^4) - 2*S2B^4*(8 - SB^4))*
            dZHiggs1[4, 4] - 2*C2B*S2B*(SB*(4*dCB1*S2B^2*(1 - 2*SB^2) + 2*
                dSB1*S2B*(12 - 5*S2B^2 - 28*SB^4)) + (11*S2B^4 - 12*S2B^2*
                (1 - 2*SB^4) + 8*(SB^4 + SB^8))*dZHiggs1[3, 4] + 
             4*S2B^3*dZHiggs1[4, 4]))) + CB^2*S2B^2*
        (2*CW^2*S2B*(14 - 3*S2B^2)*SW*dZHiggs1[3, 4] - 8*C2B*(4 - S2B^2)*
          (dSW1*SW^2 - CW^2*(dSW1 - SW*(dZe1 + dZHiggs1[4, 4])))) - 
       S2B*(4*CB^6*(CW^2*(4 + 5*S2B^2)*SW*dZHiggs1[3, 4] - 
           8*C2B*S2B*(dSW1*SW^2 - CW^2*(dSW1 - SW*(dZe1 + dZHiggs1[4, 
                  4])))) - 2*CB^4*(dSW1*S2B*(16 - 24*C2B^2 - 11*S2B^2)*SW^2 + 
           CW^2*(C2B*(8 + 24*S2B^2)*SW*dZHiggs1[3, 4] + 
             (-8*(2 - 3*C2B^2)*S2B + 11*S2B^3)*(dSW1 - SW*(dZe1 + 
                 dZHiggs1[4, 4])))))))/(CW^4*SW^3)}}, 
 C[S[3], S[3], S[5], -S[5]] == {{((-I/4)*C2B^2*EL^2)/(CW^2*SW^2), 
    ((-I/8)*C2B*EL^2*(C2B*(4*dSW1*SW^2 - 
         CW^2*(4*dSW1 - SW*(16*CB*dCB1 + 4*dZe1 + 16*dSB1*SB + 
             dZbarHiggs1[5, 5] + 2*dZHiggs1[3, 3] + dZHiggs1[5, 5]))) + 
       CW^2*S2B*SW*(2*dZHiggs1[3, 4] + dZHiggs1[5, 6] + dZHiggs1[6, 5])))/
     (CW^4*SW^3)}}, C[S[3], S[3], S[5], -S[6]] == 
  {{((-I/4)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    ((-I/8)*EL^2*(2*CW^2*SW*(S2B^2*dZHiggs1[3, 4] - 
         CW^2*(dZHiggs1[3, 4] - dZHiggs1[6, 5])) + 
       C2B*S2B*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(16*CB*dCB1 + 4*dZe1 + 
             16*dSB1*SB + 2*dZHiggs1[3, 3] + dZHiggs1[5, 5] + 
             dZHiggs1[6, 6])))))/(CW^4*SW^3)}}, 
 C[S[3], S[3], S[6], -S[5]] == {{((-I/4)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    ((-I/8)*EL^2*(2*CW^2*SW*(S2B^2*dZHiggs1[3, 4] - 
         CW^2*(dZHiggs1[3, 4] - dZHiggs1[5, 6])) + 
       C2B*S2B*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(16*CB*dCB1 + 4*dZe1 + 
             16*dSB1*SB + dZbarHiggs1[5, 5] + 2*dZHiggs1[3, 3] + 
             dZHiggs1[6, 6])))))/(CW^4*SW^3)}}, 
 C[S[3], S[3], S[6], -S[6]] == {{((I/4)*(C2B^2 - 2*CW^2)*EL^2)/(CW^2*SW^2), 
    ((I/8)*EL^2*(C2B*CW^2*SW*(S2B*(2*dZHiggs1[3, 4] - dZHiggs1[5, 6] - 
           dZHiggs1[6, 5]) + 2*C2B*(8*CB*dCB1 + 2*dZe1 + 8*dSB1*SB + 
           dZHiggs1[3, 3] + dZHiggs1[6, 6])) + 
       4*(C2B^2*dSW1*SW^4 + CW^4*(dSW1*(1 + S2B^2) - 
           SW*(6*CB*dCB1 + 2*dZe1 + 6*dSB1*SB + dZHiggs1[3, 3] + 
             dZHiggs1[6, 6])))))/(CW^4*SW^3)}}, 
 C[S[3], S[4], S[5], -S[5]] == {{((-I/4)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    ((-I/8)*EL^2*(C2B*S2B*(4*dSW1*SW^2 - 
         CW^2*(4*dSW1 - SW*(16*CB*dCB1 + 4*dZe1 + 16*dSB1*SB + 
             dZbarHiggs1[5, 5] + dZHiggs1[3, 3] + dZHiggs1[4, 4] + 
             dZHiggs1[5, 5]))) + CW^2*SW*
        (CW^2*(2*dZHiggs1[3, 4] - dZHiggs1[5, 6] - dZHiggs1[6, 5]) + 
         S2B^2*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))))/(CW^4*SW^3)}}, 
 C[S[3], S[4], S[5], -S[6]] == 
  {{((I/4)*EL^2*(CW - S2B)*(CW + S2B))/(CW^2*SW^2), 
    ((-I/32)*EL^2*(CW^4*(dSW1*(16 + S2B^6 - 8*(S2B^2 + S2B^4)) - 
         4*SW*(16*CB*dCB1 + 4*dZe1 + 16*C2B^2*dSB1*SB + dZHiggs1[3, 3] + 
           dZHiggs1[4, 4] + dZHiggs1[5, 5] + dZHiggs1[6, 6])) - 
       S2B^2*(dSW1*SW^2*(8*(CB^8 + SB^8) - (24 - 8*S2B^2 + S2B^4)*SW^2) + 
         4*CW^2*(dSW1*(CB^8 + SB^8)*(2 - 4*SW^2) - 
           SW*(16*CB*dCB1 + 4*dZe1 + 16*dSB1*SB*SW^2 + dZHiggs1[3, 3] + 
             dZHiggs1[4, 4] + dZHiggs1[5, 5] + dZHiggs1[6, 6])))))/
     (CW^4*SW^3)}}, C[S[3], S[4], S[6], -S[5]] == 
  {{((I/4)*EL^2*(CW - S2B)*(CW + S2B))/(CW^2*SW^2), 
    ((-I/32)*EL^2*(CW^4*(dSW1*(16 + S2B^6 - 8*(S2B^2 + S2B^4)) - 
         4*SW*(16*CB*dCB1 + 4*dZe1 + 16*C2B^2*dSB1*SB + dZbarHiggs1[5, 5] + 
           dZHiggs1[3, 3] + dZHiggs1[4, 4] + dZHiggs1[6, 6])) - 
       S2B^2*(dSW1*SW^2*(8*(CB^8 + SB^8) - (24 - 8*S2B^2 + S2B^4)*SW^2) + 
         4*CW^2*(dSW1*(CB^8 + SB^8)*(2 - 4*SW^2) - 
           SW*(16*CB*dCB1 + 4*dZe1 + 16*dSB1*SB*SW^2 + dZbarHiggs1[5, 5] + 
             dZHiggs1[3, 3] + dZHiggs1[4, 4] + dZHiggs1[6, 6])))))/
     (CW^4*SW^3)}}, C[S[3], S[4], S[6], -S[6]] == 
  {{((I/4)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    ((-I/8)*EL^2*(CW^2*SW*(CW^2*(2*dZHiggs1[3, 4] - dZHiggs1[5, 6] - 
           dZHiggs1[6, 5]) + S2B^2*(dZHiggs1[5, 6] + dZHiggs1[6, 5])) - 
       C2B*S2B*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(16*CB*dCB1 + 4*dZe1 + 
             16*dSB1*SB + dZHiggs1[3, 3] + dZHiggs1[4, 4] + 
             2*dZHiggs1[6, 6])))))/(CW^4*SW^3)}}, 
 C[S[4], S[4], S[5], -S[5]] == {{((I/4)*(C2B^2 - 2*CW^2)*EL^2)/(CW^2*SW^2), 
    ((I/8)*EL^2*(4*C2B^2*dSW1*SW^4 + CW^4*(4*dSW1*(1 + S2B^2) - 
         2*SW*(12*CB*dCB1 + 4*dZe1 + 12*dSB1*SB + dZbarHiggs1[5, 5] + 
           2*dZHiggs1[4, 4] + dZHiggs1[5, 5])) + 
       C2B*CW^2*SW*(C2B*(16*CB*dCB1 + 4*dZe1 + 16*dSB1*SB + 
           dZbarHiggs1[5, 5] + 2*dZHiggs1[4, 4] + dZHiggs1[5, 5]) - 
         S2B*(2*dZHiggs1[3, 4] - dZHiggs1[5, 6] - dZHiggs1[6, 5]))))/
     (CW^4*SW^3)}}, C[S[4], S[4], S[5], -S[6]] == 
  {{((I/4)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    ((I/8)*EL^2*(SW*(2*CW^2*(CW - S2B)*(CW + S2B)*dZHiggs1[3, 4] - 
         2*CW^4*dZHiggs1[6, 5]) + C2B*S2B*(4*dSW1*SW^2 - 
         CW^2*(4*dSW1 - SW*(16*CB*dCB1 + 4*dZe1 + 16*dSB1*SB + 
             2*dZHiggs1[4, 4] + dZHiggs1[5, 5] + dZHiggs1[6, 6])))))/
     (CW^4*SW^3)}}, C[S[4], S[4], S[6], -S[5]] == 
  {{((I/4)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    ((I/8)*EL^2*(SW*(2*CW^2*(CW - S2B)*(CW + S2B)*dZHiggs1[3, 4] - 
         2*CW^4*dZHiggs1[5, 6]) + C2B*S2B*(4*dSW1*SW^2 - 
         CW^2*(4*dSW1 - SW*(16*CB*dCB1 + 4*dZe1 + 16*dSB1*SB + 
             dZbarHiggs1[5, 5] + 2*dZHiggs1[4, 4] + dZHiggs1[6, 6])))))/
     (CW^4*SW^3)}}, C[S[4], S[4], S[6], -S[6]] == 
  {{((-I/4)*C2B^2*EL^2)/(CW^2*SW^2), 
    ((I/8)*C2B*EL^2*(CW^2*S2B*SW*(2*dZHiggs1[3, 4] + dZHiggs1[5, 6] + 
         dZHiggs1[6, 5]) - 2*C2B*(2*dSW1*SW^2 - 
         CW^2*(2*dSW1 - SW*(8*CB*dCB1 + 2*dZe1 + 8*dSB1*SB + dZHiggs1[4, 4] + 
             dZHiggs1[6, 6])))))/(CW^4*SW^3)}}, 
 C[S[5], S[5], -S[5], -S[5]] == 
  {{((-I/2)*EL^2*(CB - SB)^2*(CB + SB)^2)/(CW^2*SW^2), 
    ((I/2)*C2B*EL^2*(2*dSW1*SB^2*SW^2 - CB^2*(2*dSW1*SW^2 - 
         CW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[5, 5]))) - 
       CW^2*(SB^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[5, 5])) + 
         SW*(C2B*dZbarHiggs1[5, 5] + S2B*(dZHiggs1[5, 6] + 
             dZHiggs1[6, 5])))))/(CW^4*SW^3)}}, 
 C[S[5], S[5], -S[5], -S[6]] == {{((-I/2)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    ((-I/4)*EL^2*((CW^2*SW*(2*S2B*(C2B*dZbarHiggs1[5, 5] + 
            S2B*dZHiggs1[5, 6]) + (2*C2B^2 - 2*CB^4 + 3*S2B^2 - 2*SB^4)*
           dZHiggs1[6, 5]))/2 + C2B*S2B*(4*dSW1*SW^2 - 
         CW^2*(4*dSW1 - SW*(4*dZe1 + 2*dZHiggs1[5, 5] + dZHiggs1[6, 6])))))/
     (CW^4*SW^3)}}, C[S[5], S[5], -S[6], -S[6]] == 
  {{((-I/2)*EL^2*S2B^2)/(CW^2*SW^2), 
    ((-I/2)*EL^2*S2B^2*(2*dSW1*SW^2 - 
       CW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[5, 5] + dZHiggs1[6, 6]))))/
     (CW^4*SW^3)}}, C[S[5], S[6], -S[5], -S[5]] == 
  {{((-I/2)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    ((I/4)*EL^2*S2B*(4*dSW1*SB^2*SW^2 - CB^2*(4*dSW1*SW^2 - 
         CW^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[5, 5] + dZHiggs1[6, 6]))) - 
       CW^2*(SW*(2*C2B*dZbarHiggs1[5, 5] + S2B*(dZHiggs1[5, 6] + 
             dZHiggs1[6, 5])) + SB^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[5, 5] + 
             dZHiggs1[6, 6])))))/(CW^4*SW^3)}}, 
 C[S[5], S[6], -S[5], -S[6]] == {{((I/4)*EL^2*(1 - 2*S2B^2))/(CW^2*SW^2), 
    ((I/8)*EL^2*(1 - 2*S2B^2)*(4*dSW1*SW^2 - 
       CW^2*(4*dSW1 - SW*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[5, 5] + 
           2*dZHiggs1[6, 6]))))/(CW^4*SW^3)}}, 
 C[S[5], S[6], -S[6], -S[6]] == {{((I/2)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    ((-I/4)*EL^2*S2B*(4*dSW1*SB^2*SW^2 - 
       CB^2*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[5, 5] + 
             dZHiggs1[6, 6]))) + 
       CW^2*(SW*(S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - 
           2*C2B*dZHiggs1[6, 6]) - SB^2*(4*dSW1 - 
           SW*(4*dZe1 + dZHiggs1[5, 5] + dZHiggs1[6, 6])))))/(CW^4*SW^3)}}, 
 C[S[6], S[6], -S[5], -S[5]] == {{((-I/2)*EL^2*S2B^2)/(CW^2*SW^2), 
    ((-I/2)*EL^2*S2B^2*(2*dSW1*SW^2 - 
       CW^2*(2*dSW1 - SW*(2*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[6, 6]))))/
     (CW^4*SW^3)}}, C[S[6], S[6], -S[5], -S[6]] == 
  {{((I/2)*C2B*EL^2*S2B)/(CW^2*SW^2), 
    ((I/4)*EL^2*S2B*(CW^2*SW*(C2B*dZbarHiggs1[5, 5] - 
         S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5])) + 
       C2B*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(4*dZe1 + 3*dZHiggs1[6, 6])))))/
     (CW^4*SW^3)}}, C[S[6], S[6], -S[6], -S[6]] == 
  {{((-I/2)*EL^2*(CB - SB)^2*(CB + SB)^2)/(CW^2*SW^2), 
    ((I/2)*C2B*EL^2*(2*dSW1*SB^2*SW^2 - CB^2*(2*dSW1*SW^2 - 
         CW^2*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[6, 6]))) + 
       CW^2*(SW*(S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - dZHiggs1[6, 6]) - 
         SB^2*(2*dSW1 - SW*(2*dZe1 + 3*dZHiggs1[6, 6])))))/(CW^4*SW^3)}}, 
 C[S[1], S[5], V[1], -V[3]] == 
  {{((I/2)*CBA*EL^2)/SW, 
    ((-I/4)*EL^2*(CBA*(dZZA1*SW^2 + CW*(2*dSW1 - SW*(dZAA1 + dZbarW1 + 
             4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[5, 5]))) + 
       CW*SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[6, 5])))/(CW*SW^2)}}, 
 C[S[1], S[6], V[1], -V[3]] == 
  {{((I/2)*EL^2*SBA)/SW, ((-I/4)*EL^2*(dZZA1*SBA*SW^2 + 
       CW*(2*dSW1*SBA - SW*(CBA*(dZHiggs1[1, 2] + dZHiggs1[5, 6]) + 
           SBA*(dZAA1 + dZbarW1 + 4*dZe1 + dZHiggs1[1, 1] + 
             dZHiggs1[6, 6])))))/(CW*SW^2)}}, C[S[1], S[5], V[2], -V[3]] == 
  {{((-I/2)*CBA*EL^2)/CW, 
    ((I/4)*EL^2*(CBA*(CW^3*dZAZ1 - 2*dSW1*SW^2 - 
         CW^2*SW*(dZbarW1 + 4*dZe1 + dZZZ1 + dZHiggs1[1, 1] + 
           dZHiggs1[5, 5])) + CW^2*SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[6, 5])))/
     (CW^3*SW)}}, C[S[1], S[6], V[2], -V[3]] == 
  {{((-I/2)*EL^2*SBA)/CW, ((I/4)*EL^2*(SBA*(CW^3*dZAZ1 - 2*dSW1*SW^2) - 
       CW^2*SW*(CBA*(dZHiggs1[1, 2] + dZHiggs1[5, 6]) + 
         SBA*(dZbarW1 + 4*dZe1 + dZZZ1 + dZHiggs1[1, 1] + dZHiggs1[6, 6]))))/
     (CW^3*SW)}}, C[S[1], -S[5], V[1], V[3]] == 
  {{((I/2)*CBA*EL^2)/SW, 
    ((-I/4)*EL^2*(CBA*(dZZA1*SW^2 + CW*(2*dSW1 - SW*(dZAA1 + 4*dZe1 + dZW1 + 
             dZbarHiggs1[5, 5] + dZHiggs1[1, 1]))) + 
       CW*SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[5, 6])))/(CW*SW^2)}}, 
 C[S[1], -S[6], V[1], V[3]] == 
  {{((I/2)*EL^2*SBA)/SW, ((-I/4)*EL^2*(dZZA1*SBA*SW^2 + 
       CW*(2*dSW1*SBA - SW*(CBA*(dZHiggs1[1, 2] + dZHiggs1[6, 5]) + 
           SBA*(dZAA1 + 4*dZe1 + dZW1 + dZHiggs1[1, 1] + dZHiggs1[6, 6])))))/
     (CW*SW^2)}}, C[S[1], -S[5], V[2], V[3]] == 
  {{((-I/2)*CBA*EL^2)/CW, 
    ((I/4)*EL^2*(CBA*(CW^3*dZAZ1 - 2*dSW1*SW^2 - 
         CW^2*SW*(4*dZe1 + dZW1 + dZZZ1 + dZbarHiggs1[5, 5] + 
           dZHiggs1[1, 1])) + CW^2*SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[5, 6])))/
     (CW^3*SW)}}, C[S[1], -S[6], V[2], V[3]] == 
  {{((-I/2)*EL^2*SBA)/CW, ((I/4)*EL^2*(SBA*(CW^3*dZAZ1 - 2*dSW1*SW^2) - 
       CW^2*SW*(CBA*(dZHiggs1[1, 2] + dZHiggs1[6, 5]) + 
         SBA*(4*dZe1 + dZW1 + dZZZ1 + dZHiggs1[1, 1] + dZHiggs1[6, 6]))))/
     (CW^3*SW)}}, C[S[2], S[2], V[2], V[2]] == 
  {{((I/2)*EL^2)/(CW^2*SW^2), 
    ((I/2)*EL^2*(2*dSW1*SW^2 - CW^2*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + 
           dZHiggs1[2, 2]))))/(CW^4*SW^3)}}, C[S[2], S[2], V[3], -V[3]] == 
  {{((I/2)*EL^2)/SW^2, 
    ((-I/4)*EL^2*(4*dSW1 - SW*(dZbarW1 + 4*dZe1 + dZW1 + 2*dZHiggs1[2, 2])))/
     SW^3}}, C[S[2], S[5], V[1], -V[3]] == 
  {{((-I/2)*EL^2*SBA)/SW, ((I/4)*EL^2*(dZZA1*SBA*SW^2 + 
       CW*(2*dSW1*SBA - SW*(SBA*(dZAA1 + dZbarW1 + 4*dZe1 + dZHiggs1[2, 2] + 
             dZHiggs1[5, 5]) - CBA*(dZHiggs1[1, 2] + dZHiggs1[6, 5])))))/
     (CW*SW^2)}}, C[S[2], S[6], V[1], -V[3]] == 
  {{((I/2)*CBA*EL^2)/SW, 
    ((I/4)*EL^2*(CW*SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[5, 6]) - 
       CBA*(dZZA1*SW^2 + CW*(2*dSW1 - SW*(dZAA1 + dZbarW1 + 4*dZe1 + 
             dZHiggs1[2, 2] + dZHiggs1[6, 6])))))/(CW*SW^2)}}, 
 C[S[2], S[5], V[2], -V[3]] == 
  {{((I/2)*EL^2*SBA)/CW, ((-I/4)*EL^2*(SBA*(CW^3*dZAZ1 - 2*dSW1*SW^2) - 
       CW^2*SW*(SBA*(dZbarW1 + 4*dZe1 + dZZZ1 + dZHiggs1[2, 2] + 
           dZHiggs1[5, 5]) - CBA*(dZHiggs1[1, 2] + dZHiggs1[6, 5]))))/
     (CW^3*SW)}}, C[S[2], S[6], V[2], -V[3]] == 
  {{((-I/2)*CBA*EL^2)/CW, 
    ((-I/4)*EL^2*(CW^2*SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[5, 6]) - 
       CBA*(CW^3*dZAZ1 - 2*dSW1*SW^2 - CW^2*SW*(dZbarW1 + 4*dZe1 + dZZZ1 + 
           dZHiggs1[2, 2] + dZHiggs1[6, 6]))))/(CW^3*SW)}}, 
 C[S[2], -S[5], V[1], V[3]] == 
  {{((-I/2)*EL^2*SBA)/SW, ((I/4)*EL^2*(dZZA1*SBA*SW^2 + 
       CW*(2*dSW1*SBA - SW*(SBA*(dZAA1 + 4*dZe1 + dZW1 + dZbarHiggs1[5, 5] + 
             dZHiggs1[2, 2]) - CBA*(dZHiggs1[1, 2] + dZHiggs1[5, 6])))))/
     (CW*SW^2)}}, C[S[2], -S[6], V[1], V[3]] == 
  {{((I/2)*CBA*EL^2)/SW, 
    ((I/4)*EL^2*(CW*SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[6, 5]) - 
       CBA*(dZZA1*SW^2 + CW*(2*dSW1 - SW*(dZAA1 + 4*dZe1 + dZW1 + 
             dZHiggs1[2, 2] + dZHiggs1[6, 6])))))/(CW*SW^2)}}, 
 C[S[2], -S[5], V[2], V[3]] == 
  {{((I/2)*EL^2*SBA)/CW, ((-I/4)*EL^2*(SBA*(CW^3*dZAZ1 - 2*dSW1*SW^2) - 
       CW^2*SW*(SBA*(4*dZe1 + dZW1 + dZZZ1 + dZbarHiggs1[5, 5] + 
           dZHiggs1[2, 2]) - CBA*(dZHiggs1[1, 2] + dZHiggs1[5, 6]))))/
     (CW^3*SW)}}, C[S[2], -S[6], V[2], V[3]] == 
  {{((-I/2)*CBA*EL^2)/CW, 
    ((-I/4)*EL^2*(CW^2*SBA*SW*(dZHiggs1[1, 2] - dZHiggs1[6, 5]) - 
       CBA*(CW^3*dZAZ1 - 2*dSW1*SW^2 - CW^2*SW*(4*dZe1 + dZW1 + dZZZ1 + 
           dZHiggs1[2, 2] + dZHiggs1[6, 6]))))/(CW^3*SW)}}, 
 C[S[3], S[3], V[2], V[2]] == {{((I/2)*EL^2)/(CW^2*SW^2), 
    ((I/2)*EL^2*(2*dSW1*SW^2 - CW^2*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + 
           dZHiggs1[3, 3]))))/(CW^4*SW^3)}}, C[S[3], S[3], V[3], -V[3]] == 
  {{((I/2)*EL^2)/SW^2, 
    ((-I/4)*EL^2*(4*dSW1 - SW*(dZbarW1 + 4*dZe1 + dZW1 + 2*dZHiggs1[3, 3])))/
     SW^3}}, C[S[3], S[5], V[1], -V[3]] == 
  {{-EL^2/(2*SW), 
    (EL^2*(dZZA1*SW^2 + CW*(2*dSW1 - SW*(dZAA1 + dZbarW1 + 4*dZe1 + 
           dZHiggs1[3, 3] + dZHiggs1[5, 5]))))/(4*CW*SW^2)}}, 
 C[S[3], S[5], V[2], -V[3]] == 
  {{EL^2/(2*CW), -(EL^2*(CW^3*dZAZ1 - 2*dSW1*SW^2 - 
        CW^2*SW*(dZbarW1 + 4*dZe1 + dZZZ1 + dZHiggs1[3, 3] + 
          dZHiggs1[5, 5])))/(4*CW^3*SW)}}, C[S[3], -S[5], V[1], V[3]] == 
  {{EL^2/(2*SW), 
    -(EL^2*(dZZA1*SW^2 + CW*(2*dSW1 - SW*(dZAA1 + 4*dZe1 + dZW1 + 
            dZbarHiggs1[5, 5] + dZHiggs1[3, 3]))))/(4*CW*SW^2)}}, 
 C[S[3], -S[5], V[2], V[3]] == 
  {{-EL^2/(2*CW), (EL^2*(CW^3*dZAZ1 - 2*dSW1*SW^2 - 
       CW^2*SW*(4*dZe1 + dZW1 + dZZZ1 + dZbarHiggs1[5, 5] + dZHiggs1[3, 3])))/
     (4*CW^3*SW)}}, C[S[4], S[6], V[1], -V[3]] == 
  {{-EL^2/(2*SW), 
    (EL^2*(dZZA1*SW^2 + CW*(2*dSW1 - SW*(dZAA1 + dZbarW1 + 4*dZe1 + 
           dZHiggs1[4, 4] + dZHiggs1[6, 6]))))/(4*CW*SW^2)}}, 
 C[S[4], S[6], V[2], -V[3]] == 
  {{EL^2/(2*CW), -(EL^2*(CW^3*dZAZ1 - 2*dSW1*SW^2 - 
        CW^2*SW*(dZbarW1 + 4*dZe1 + dZZZ1 + dZHiggs1[4, 4] + 
          dZHiggs1[6, 6])))/(4*CW^3*SW)}}, C[S[4], -S[6], V[1], V[3]] == 
  {{EL^2/(2*SW), 
    -(EL^2*(dZZA1*SW^2 + CW*(2*dSW1 - SW*(dZAA1 + 4*dZe1 + dZW1 + 
            dZHiggs1[4, 4] + dZHiggs1[6, 6]))))/(4*CW*SW^2)}}, 
 C[S[4], -S[6], V[2], V[3]] == 
  {{-EL^2/(2*CW), (EL^2*(CW^3*dZAZ1 - 2*dSW1*SW^2 - 
       CW^2*SW*(4*dZe1 + dZW1 + dZZZ1 + dZHiggs1[4, 4] + dZHiggs1[6, 6])))/
     (4*CW^3*SW)}}, C[S[5], -S[5], V[1], V[1]] == 
  {{(2*I)*EL^2, (I*EL^2*(dZZA1*(CW^2 - SW^2) + 
       CW*SW*(2*dZAA1 + 4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[5, 5])))/
     (CW*SW)}}, C[S[5], -S[5], V[1], V[2]] == 
  {{((-I)*(1 - 2*CW^2)*EL^2)/(CW*SW), 
    ((-I/4)*EL^2*(4*dSW1*SW^4 - dZZA1*(CW^5 + CW*SW^4) + 
       2*CW^4*(2*dSW1 - SW*(dZAA1 + 4*dZe1 + dZZZ1 + dZbarHiggs1[5, 5] + 
           dZHiggs1[5, 5])) - SW^2*(2*CW^3*(2*dZAZ1 - dZZA1) - 
         2*CW^2*(4*dSW1 + SW*(dZAA1 + 4*dZe1 + dZZZ1 + dZbarHiggs1[5, 5] + 
             dZHiggs1[5, 5])))))/(CW^3*SW^2)}}, 
 C[S[5], -S[5], V[2], V[2]] == {{((I/2)*(EL - 2*CW^2*EL)^2)/(CW^2*SW^2), 
    ((I/4)*(1 - 2*CW^2)*EL^2*(4*dSW1*SW^4 + 
       CW^4*(4*dSW1 - SW*(4*dZe1 + 2*dZZZ1 + dZbarHiggs1[5, 5] + 
           dZHiggs1[5, 5])) - SW^2*(4*CW^3*dZAZ1 - 
         CW^2*(8*dSW1 + SW*(4*dZe1 + 2*dZZZ1 + dZbarHiggs1[5, 5] + 
             dZHiggs1[5, 5])))))/(CW^4*SW^3)}}, 
 C[S[5], -S[5], V[3], -V[3]] == 
  {{((I/2)*EL^2)/SW^2, 
    ((-I/4)*EL^2*(4*dSW1 - SW*(dZbarW1 + 4*dZe1 + dZW1 + dZbarHiggs1[5, 5] + 
         dZHiggs1[5, 5])))/SW^3}}, C[F[2, {j1}], -F[2, {j2}], S[1]] == 
  {{((I/2)*EL*SA*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(CB*MW*SW), 
    ((I/4)*EL*IndexDelta[j1, j2]*(2*CB*MW^2*SA*SW*dMf1[2, j1] - 
       (SA*(2*dCB1*MW^2*SW + CB*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW))) - 
         CB*MW^2*SW*(SA*(dZbarfR1[2, j2, j2] + dZfL1[2, j1, j1] + 
             dZHiggs1[1, 1]) - CA*dZHiggs1[1, 2]))*Mass[F[2, {j1}]]))/
     (CB^2*MW^3*SW^2)}, {((I/2)*EL*SA*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/
     (CB*MW*SW), ((I/4)*EL*IndexDelta[j1, j2]*(2*CB*MW^2*SA*SW*dMf1[2, j1] - 
       (SA*(2*dCB1*MW^2*SW + CB*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW))) - 
         CB*MW^2*SW*(SA*(dZbarfL1[2, j2, j2] + dZfR1[2, j1, j1] + 
             dZHiggs1[1, 1]) - CA*dZHiggs1[1, 2]))*Mass[F[2, {j1}]]))/
     (CB^2*MW^3*SW^2)}}, C[F[3, {j1, o1}], -F[3, {j2, o2}], S[1]] == 
  {{((-I/2)*CA*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[3, {j1, o1}]])/
     (MW*SB*SW), ((-I/4)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CA*MW^2*SB*SW*dMf1[3, j1] - 
       (CA*(2*MW^2*(dSW1*SB + dSB1*SW) + SB*SW*(dMWsq1 - 
             MW^2*(2*dZe1 + dZbarfR1[3, j2, j2] + dZfL1[3, j1, j1] + dZHiggs1[
                1, 1]))) - MW^2*SA*SB*SW*dZHiggs1[1, 2])*
        Mass[F[3, {j1, o1}]]))/(MW^3*SB^2*SW^2)}, 
   {((-I/2)*CA*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[3, {j1, o1}]])/
     (MW*SB*SW), ((-I/4)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CA*MW^2*SB*SW*dMf1[3, j1] - 
       (CA*(2*MW^2*(dSW1*SB + dSB1*SW) + SB*SW*(dMWsq1 - 
             MW^2*(2*dZe1 + dZbarfL1[3, j2, j2] + dZfR1[3, j1, j1] + dZHiggs1[
                1, 1]))) - MW^2*SA*SB*SW*dZHiggs1[1, 2])*
        Mass[F[3, {j1, o1}]]))/(MW^3*SB^2*SW^2)}}, 
 C[F[4, {j1, o1}], -F[4, {j2, o2}], S[1]] == 
  {{((I/2)*EL*SA*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[4, {j1, o1}]])/
     (CB*MW*SW), ((I/4)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CB*MW^2*SA*SW*dMf1[4, j1] - 
       (SA*(2*dCB1*MW^2*SW + CB*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW))) - 
         CB*MW^2*SW*(SA*(dZbarfR1[4, j2, j2] + dZfL1[4, j1, j1] + 
             dZHiggs1[1, 1]) - CA*dZHiggs1[1, 2]))*Mass[F[4, {j1, o1}]]))/
     (CB^2*MW^3*SW^2)}, {((I/2)*EL*SA*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      Mass[F[4, {j1, o1}]])/(CB*MW*SW), 
    ((I/4)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CB*MW^2*SA*SW*dMf1[4, j1] - 
       (SA*(2*dCB1*MW^2*SW + CB*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW))) - 
         CB*MW^2*SW*(SA*(dZbarfL1[4, j2, j2] + dZfR1[4, j1, j1] + 
             dZHiggs1[1, 1]) - CA*dZHiggs1[1, 2]))*Mass[F[4, {j1, o1}]]))/
     (CB^2*MW^3*SW^2)}}, C[F[2, {j1}], -F[2, {j2}], S[3]] == 
  {{(EL*SB^2*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(MW*S2B*SW), 
    (EL*IndexDelta[j1, j2]*(MW^2*S2B*SW*dMf1[2, j1] - 
       (MW^2*S2B*(dSW1 - dZe1*SW) + SW*((CB*dMWsq1 + 2*dCB1*MW^2)*SB - 
           CB*MW^2*(SB*(dZbarfR1[2, j2, j2] + dZfL1[2, j1, j1] + dZHiggs1[3, 
                3]) - CB*dZHiggs1[3, 4])))*Mass[F[2, {j1}]]))/
     (4*CB^2*MW^3*SW^2)}, {-((EL*SB^2*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/
      (MW*S2B*SW)), -(EL*IndexDelta[j1, j2]*(MW^2*S2B*SW*dMf1[2, j1] - 
        (MW^2*S2B*(dSW1 - dZe1*SW) + SW*((CB*dMWsq1 + 2*dCB1*MW^2)*SB - 
            CB*MW^2*(SB*(dZbarfL1[2, j2, j2] + dZfR1[2, j1, j1] + 
                dZHiggs1[3, 3]) - CB*dZHiggs1[3, 4])))*Mass[F[2, {j1}]]))/
     (4*CB^2*MW^3*SW^2)}}, C[F[2, {j1}], -F[2, {j2}], S[4]] == 
  {{-(EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(2*MW*SW), 
    -(EL*IndexDelta[j1, j2]*(2*CB*MW^2*SW*dMf1[2, j1] - 
        (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 + SB*dZHiggs1[3, 4] - 
            CB*(2*dZe1 + dZbarfR1[2, j2, j2] + dZfL1[2, j1, j1] + 
              dZHiggs1[4, 4])))*Mass[F[2, {j1}]]))/(4*CB*MW^3*SW^2)}, 
   {(EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(2*MW*SW), 
    (EL*IndexDelta[j1, j2]*(2*CB*MW^2*SW*dMf1[2, j1] - 
       (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 + SB*dZHiggs1[3, 4] - 
           CB*(2*dZe1 + dZbarfL1[2, j2, j2] + dZfR1[2, j1, j1] + 
             dZHiggs1[4, 4])))*Mass[F[2, {j1}]]))/(4*CB*MW^3*SW^2)}}, 
 C[F[1, {j1}], -F[2, {j2}], S[5]] == 
  {{(I*Sqrt[2]*EL*SB^2*IndexDelta[j1, j2]*Mass[F[2, {j2}]])/(MW*S2B*SW), 
    ((I/2)*EL*IndexDelta[j1, j2]*(MW^2*S2B*SW*dMf1[2, j2] - 
       (MW^2*S2B*(dSW1 - dZe1*SW) + SW*((CB*dMWsq1 + 2*dCB1*MW^2)*SB - 
           CB*MW^2*(SB*(dZbarfR1[2, j2, j2] + dZfL1[1, j1, j1] + dZHiggs1[5, 
                5]) - CB*dZHiggs1[6, 5])))*Mass[F[2, {j2}]]))/
     (Sqrt[2]*CB^2*MW^3*SW^2)}, {0, 0}}, C[F[1, {j1}], -F[2, {j2}], S[6]] == 
  {{((-I)*EL*IndexDelta[j1, j2]*Mass[F[2, {j2}]])/(Sqrt[2]*MW*SW), 
    ((-I/2)*EL*IndexDelta[j1, j2]*(2*CB*MW^2*SW*dMf1[2, j2] - 
       (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 + SB*dZHiggs1[5, 6] - 
           CB*(2*dZe1 + dZbarfR1[2, j2, j2] + dZfL1[1, j1, j1] + 
             dZHiggs1[6, 6])))*Mass[F[2, {j2}]]))/(Sqrt[2]*CB*MW^3*SW^2)}, 
   {0, 0}}, C[F[2, {j1}], -F[1, {j2}], -S[5]] == 
  {{0, 0}, {(I*Sqrt[2]*EL*SB^2*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/
     (MW*S2B*SW), ((I/4)*EL*IndexDelta[j1, j2]*(2*MW^2*S2B*SW*dMf1[2, j1] - 
       (S2B*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW)) + 
         MW^2*SW*(4*dCB1*SB - S2B*(dZbarfL1[1, j2, j2] + dZbarHiggs1[5, 5] + 
             dZfR1[2, j1, j1]) + 2*CB^2*dZHiggs1[5, 6]))*Mass[F[2, {j1}]]))/
     (Sqrt[2]*CB^2*MW^3*SW^2)}}, C[F[2, {j1}], -F[1, {j2}], -S[6]] == 
  {{0, 0}, {((-I)*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(Sqrt[2]*MW*SW), 
    ((-I/2)*EL*IndexDelta[j1, j2]*(2*CB*MW^2*SW*dMf1[2, j1] - 
       (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 + SB*dZHiggs1[6, 5] - 
           CB*(2*dZe1 + dZbarfL1[1, j2, j2] + dZfR1[2, j1, j1] + 
             dZHiggs1[6, 6])))*Mass[F[2, {j1}]]))/(Sqrt[2]*CB*MW^3*SW^2)}}, 
 C[F[3, {j1, o1}], -F[3, {j2, o2}], S[3]] == 
  {{(CB^2*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[3, {j1, o1}]])/
     (MW*S2B*SW), (EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*MW^2*S2B*SW*dMf1[3, j1] - 
       (S2B*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW)) + 
         MW^2*SW*(4*CB*dSB1 - S2B*(dZbarfR1[3, j2, j2] + dZfL1[3, j1, j1] + 
             dZHiggs1[3, 3]) - 2*SB^2*dZHiggs1[3, 4]))*Mass[F[3, {j1, o1}]]))/
     (8*MW^3*SB^2*SW^2)}, 
   {-((CB^2*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[3, {j1, o1}]])/
      (MW*S2B*SW)), -(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
       (2*MW^2*S2B*SW*dMf1[3, j1] - 
        (S2B*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW)) + 
          MW^2*SW*(4*CB*dSB1 - S2B*(dZbarfL1[3, j2, j2] + dZfR1[3, j1, j1] + 
              dZHiggs1[3, 3]) - 2*SB^2*dZHiggs1[3, 4]))*
         Mass[F[3, {j1, o1}]]))/(8*MW^3*SB^2*SW^2)}}, 
 C[F[3, {j1, o1}], -F[3, {j2, o2}], S[4]] == 
  {{(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[3, {j1, o1}]])/
     (2*MW*SW), (EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*MW^2*SB*SW*dMf1[3, j1] - ((dMWsq1*SB + 2*MW^2*(dSB1 - dZe1*SB))*SW + 
         MW^2*(2*dSW1*SB - SW*(CB*dZHiggs1[3, 4] + SB*(dZbarfR1[3, j2, j2] + 
               dZfL1[3, j1, j1] + dZHiggs1[4, 4]))))*Mass[F[3, {j1, o1}]]))/
     (4*MW^3*SB*SW^2)}, 
   {-(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[3, {j1, o1}]])/
     (2*MW*SW), -(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
       (2*MW^2*SB*SW*dMf1[3, j1] - ((dMWsq1*SB + 2*MW^2*(dSB1 - dZe1*SB))*
           SW + MW^2*(2*dSW1*SB - SW*(CB*dZHiggs1[3, 4] + 
              SB*(dZbarfL1[3, j2, j2] + dZfR1[3, j1, j1] + dZHiggs1[4, 4]))))*
         Mass[F[3, {j1, o1}]]))/(4*MW^3*SB*SW^2)}}, 
 C[F[4, {j1, o1}], -F[4, {j2, o2}], S[3]] == 
  {{(EL*SB^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[4, {j1, o1}]])/
     (MW*S2B*SW), (EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (MW^2*S2B*SW*dMf1[4, j1] - (MW^2*S2B*(dSW1 - dZe1*SW) + 
         SW*((CB*dMWsq1 + 2*dCB1*MW^2)*SB - CB*MW^2*
            (SB*(dZbarfR1[4, j2, j2] + dZfL1[4, j1, j1] + dZHiggs1[3, 3]) - 
             CB*dZHiggs1[3, 4])))*Mass[F[4, {j1, o1}]]))/(4*CB^2*MW^3*SW^2)}, 
   {-((EL*SB^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[4, {j1, o1}]])/
      (MW*S2B*SW)), -(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
       (MW^2*S2B*SW*dMf1[4, j1] - (MW^2*S2B*(dSW1 - dZe1*SW) + 
          SW*((CB*dMWsq1 + 2*dCB1*MW^2)*SB - CB*MW^2*
             (SB*(dZbarfL1[4, j2, j2] + dZfR1[4, j1, j1] + dZHiggs1[3, 3]) - 
              CB*dZHiggs1[3, 4])))*Mass[F[4, {j1, o1}]]))/
     (4*CB^2*MW^3*SW^2)}}, C[F[4, {j1, o1}], -F[4, {j2, o2}], S[4]] == 
  {{-(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[4, {j1, o1}]])/
     (2*MW*SW), -(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
       (2*CB*MW^2*SW*dMf1[4, j1] - (CB*(2*dSW1*MW^2 + dMWsq1*SW) + 
          MW^2*SW*(2*dCB1 + SB*dZHiggs1[3, 4] - 
            CB*(2*dZe1 + dZbarfR1[4, j2, j2] + dZfL1[4, j1, j1] + 
              dZHiggs1[4, 4])))*Mass[F[4, {j1, o1}]]))/(4*CB*MW^3*SW^2)}, 
   {(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[4, {j1, o1}]])/
     (2*MW*SW), (EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CB*MW^2*SW*dMf1[4, j1] - (CB*(2*dSW1*MW^2 + dMWsq1*SW) + 
         MW^2*SW*(2*dCB1 + SB*dZHiggs1[3, 4] - 
           CB*(2*dZe1 + dZbarfL1[4, j2, j2] + dZfR1[4, j1, j1] + 
             dZHiggs1[4, 4])))*Mass[F[4, {j1, o1}]]))/(4*CB*MW^3*SW^2)}}, 
 C[-F[2, {j2}], F[2, {j1}], V[1]] == 
  {{I*EL*IndexDelta[j1, j2], (I/4)*EL*(2*dZAA1 + 4*dZe1 + 
      (dZZA1 - 2*dZZA1*SW^2)/(CW*SW) + 2*(dZbarfL1[2, j2, j2] + 
        dZfL1[2, j2, j2]))*IndexDelta[j1, j2]}, {I*EL*IndexDelta[j1, j2], 
    ((-I/2)*EL*(dZZA1*SW - CW*(dZAA1 + 2*dZe1 + dZbarfR1[2, j2, j2] + 
         dZfR1[2, j2, j2]))*IndexDelta[j1, j2])/CW}}, 
 C[-F[3, {j2, o1}], F[3, {j1, o2}], V[1]] == 
  {{((-2*I)/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2], 
    ((-I/12)*EL*(4*CW*SW*(dZbarfL1[3, j1, j2] + dZfL1[3, j2, j1]) - 
       ((1 - 4*CW^2)*dZZA1 - 4*CW*(dZAA1 + 2*dZe1)*SW)*IndexDelta[j1, j2])*
      IndexDelta[o1, o2])/(CW*SW)}, {((-2*I)/3)*EL*IndexDelta[j1, j2]*
     IndexDelta[o1, o2], 
    ((-I/3)*EL*(CW*(dZbarfR1[3, j1, j2] + dZfR1[3, j2, j1]) + 
       (CW*(dZAA1 + 2*dZe1) - dZZA1*SW)*IndexDelta[j1, j2])*
      IndexDelta[o1, o2])/CW}}, C[-F[4, {j2, o1}], F[4, {j1, o2}], V[1]] == 
  {{(I/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2], 
    ((I/12)*EL*(2*CW*SW*(dZbarfL1[4, j1, j2] + dZfL1[4, j2, j1]) + 
       (dZZA1 + 2*(CW^2*dZZA1 + CW*(dZAA1 + 2*dZe1)*SW))*IndexDelta[j1, j2])*
      IndexDelta[o1, o2])/(CW*SW)}, {(I/3)*EL*IndexDelta[j1, j2]*
     IndexDelta[o1, o2], 
    ((I/6)*EL*(CW*(dZbarfR1[4, j1, j2] + dZfR1[4, j2, j1]) + 
       (CW*(dZAA1 + 2*dZe1) - dZZA1*SW)*IndexDelta[j1, j2])*
      IndexDelta[o1, o2])/CW}}, C[-F[1, {j2}], F[1, {j1}], V[2]] == 
  {{((-I/2)*EL*IndexDelta[j1, j2])/(CW*SW), 
    ((-I/4)*EL*(2*dSW1*SW^2 - CW^2*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + 
           dZbarfL1[1, j2, j2] + dZfL1[1, j2, j2])))*IndexDelta[j1, j2])/
     (CW^3*SW^2)}, {0, 0}}, C[-F[2, {j2}], F[2, {j1}], V[2]] == 
  {{((-I/2)*(1 - 2*CW^2)*EL*IndexDelta[j1, j2])/(CW*SW), 
    ((-I/4)*EL*(2*(dSW1 - CW^3*dZAZ1)*SW^2 + 
       CW^2*(2*dSW1 + (1 - 2*CW^2)*SW*(2*dZe1 + dZZZ1 + dZbarfL1[2, j2, j2] + 
           dZfL1[2, j2, j2])))*IndexDelta[j1, j2])/(CW^3*SW^2)}, 
   {((-I)*EL*SW*IndexDelta[j1, j2])/CW, 
    ((-I/2)*EL*(2*dSW1 - CW^2*(CW*dZAZ1 - SW*(2*dZe1 + dZZZ1 + 
           dZbarfR1[2, j2, j2] + dZfR1[2, j2, j2])))*IndexDelta[j1, j2])/
     CW^3}}, C[-F[3, {j2, o1}], F[3, {j1, o2}], V[2]] == 
  {{((I/6)*(1 - 4*CW^2)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2])/(CW*SW), 
    ((I/12)*EL*(CW^2*(1 - 4*CW^2)*SW*(dZbarfL1[3, j1, j2] + 
         dZfL1[3, j2, j1]) + (2*(dSW1 - 2*CW^3*dZAZ1)*SW^2 + 
         CW^2*(6*dSW1 + (1 - 4*CW^2)*(2*dZe1 + dZZZ1)*SW))*
        IndexDelta[j1, j2])*IndexDelta[o1, o2])/(CW^3*SW^2)}, 
   {(((2*I)/3)*EL*SW*IndexDelta[j1, j2]*IndexDelta[o1, o2])/CW, 
    ((I/3)*EL*(CW^2*SW*(dZbarfR1[3, j1, j2] + dZfR1[3, j2, j1]) + 
       (2*dSW1 - CW^2*(CW*dZAZ1 - (2*dZe1 + dZZZ1)*SW))*IndexDelta[j1, j2])*
      IndexDelta[o1, o2])/CW^3}}, C[-F[4, {j2, o1}], F[4, {j1, o2}], V[2]] == 
  {{((I/6)*(1 + 2*CW^2)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2])/(CW*SW), 
    ((I/12)*EL*(CW^2*(1 + 2*CW^2)*SW*(dZbarfL1[4, j1, j2] + 
         dZfL1[4, j2, j1]) + (2*(dSW1 + CW^3*dZAZ1)*SW^2 - 
         CW^2*(6*dSW1 - (1 + 2*CW^2)*(2*dZe1 + dZZZ1)*SW))*
        IndexDelta[j1, j2])*IndexDelta[o1, o2])/(CW^3*SW^2)}, 
   {((-I/3)*EL*SW*IndexDelta[j1, j2]*IndexDelta[o1, o2])/CW, 
    ((-I/6)*EL*(CW^2*SW*(dZbarfR1[4, j1, j2] + dZfR1[4, j2, j1]) + 
       (2*dSW1 - CW^2*(CW*dZAZ1 - (2*dZe1 + dZZZ1)*SW))*IndexDelta[j1, j2])*
      IndexDelta[o1, o2])/CW^3}}, C[F[2, {j1}], -F[2, {j2}], S[2]] == 
  {{((-I/2)*CA*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/(CB*MW*SW), 
    ((-I/4)*EL*IndexDelta[j1, j2]*(2*CA*CB*MW^2*SW*dMf1[2, j1] - 
       (2*CA*dCB1*MW^2*SW + CB*(CA*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW)) + 
           MW^2*SW*(SA*dZHiggs1[1, 2] - CA*(dZbarfR1[2, j2, j2] + dZfL1[2, 
                j1, j1] + dZHiggs1[2, 2]))))*Mass[F[2, {j1}]]))/
     (CB^2*MW^3*SW^2)}, {((-I/2)*CA*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/
     (CB*MW*SW), ((-I/4)*EL*IndexDelta[j1, j2]*(2*CA*CB*MW^2*SW*dMf1[2, j1] - 
       (2*CA*dCB1*MW^2*SW + CB*(CA*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW)) + 
           MW^2*SW*(SA*dZHiggs1[1, 2] - CA*(dZbarfL1[2, j2, j2] + dZfR1[2, 
                j1, j1] + dZHiggs1[2, 2]))))*Mass[F[2, {j1}]]))/
     (CB^2*MW^3*SW^2)}}, C[F[3, {j1, o1}], -F[3, {j2, o2}], S[2]] == 
  {{((-I/2)*EL*SA*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[3, {j1, o1}]])/
     (MW*SB*SW), ((-I/4)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*MW^2*SA*SB*SW*dMf1[3, j1] - 
       (SA*(2*dSW1*MW^2*SB + (dMWsq1*SB + 2*MW^2*(dSB1 - dZe1*SB))*SW) - 
         MW^2*SB*SW*(CA*dZHiggs1[1, 2] + SA*(dZbarfR1[3, j2, j2] + 
             dZfL1[3, j1, j1] + dZHiggs1[2, 2])))*Mass[F[3, {j1, o1}]]))/
     (MW^3*SB^2*SW^2)}, {((-I/2)*EL*SA*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      Mass[F[3, {j1, o1}]])/(MW*SB*SW), 
    ((-I/4)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*MW^2*SA*SB*SW*dMf1[3, j1] - 
       (SA*(2*dSW1*MW^2*SB + (dMWsq1*SB + 2*MW^2*(dSB1 - dZe1*SB))*SW) - 
         MW^2*SB*SW*(CA*dZHiggs1[1, 2] + SA*(dZbarfL1[3, j2, j2] + 
             dZfR1[3, j1, j1] + dZHiggs1[2, 2])))*Mass[F[3, {j1, o1}]]))/
     (MW^3*SB^2*SW^2)}}, C[F[4, {j1, o1}], -F[4, {j2, o2}], S[2]] == 
  {{((-I/2)*CA*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[4, {j1, o1}]])/
     (CB*MW*SW), ((-I/4)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CA*CB*MW^2*SW*dMf1[4, j1] - (2*CA*dCB1*MW^2*SW + 
         CB*(CA*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW)) + 
           MW^2*SW*(SA*dZHiggs1[1, 2] - CA*(dZbarfR1[4, j2, j2] + dZfL1[4, 
                j1, j1] + dZHiggs1[2, 2]))))*Mass[F[4, {j1, o1}]]))/
     (CB^2*MW^3*SW^2)}, {((-I/2)*CA*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      Mass[F[4, {j1, o1}]])/(CB*MW*SW), 
    ((-I/4)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CA*CB*MW^2*SW*dMf1[4, j1] - (2*CA*dCB1*MW^2*SW + 
         CB*(CA*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW)) + 
           MW^2*SW*(SA*dZHiggs1[1, 2] - CA*(dZbarfL1[4, j2, j2] + dZfR1[4, 
                j1, j1] + dZHiggs1[2, 2]))))*Mass[F[4, {j1, o1}]]))/
     (CB^2*MW^3*SW^2)}}, C[-F[2, {j2}], F[1, {j1}], V[3]] == 
  {{((-I)*EL*IndexDelta[j1, j2])/(Sqrt[2]*SW), 
    ((I/2)*EL*(2*dSW1 - SW*(2*dZe1 + dZW1 + dZbarfL1[2, j2, j2] + 
         dZfL1[1, j2, j2]))*IndexDelta[j1, j2])/(Sqrt[2]*SW^2)}, {0, 0}}, 
 C[-F[1, {j2}], F[2, {j1}], -V[3]] == 
  {{((-I)*EL*IndexDelta[j1, j2])/(Sqrt[2]*SW), 
    ((I/2)*EL*(2*dSW1 - SW*(2*dZe1 + dZW1 + dZbarfL1[1, j2, j2] + 
         dZfL1[2, j2, j2]))*IndexDelta[j1, j2])/(Sqrt[2]*SW^2)}, {0, 0}}, 
 C[F[3, {j1, o1}], -F[4, {j2, o2}], S[5]] == 
  {{(I*Sqrt[2]*EL*SB^2*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      Mass[F[4, {j2, o1}]])/(MW*S2B*SW), 
    ((I/2)*EL*IndexDelta[o1, o2]*(MW^2*S2B*SW*Conjugate[dCKM1[j1, j2]]*
        Mass[F[4, {j2, o1}]] + Conjugate[CKM[j1, j2]]*
        (MW^2*S2B*SW*dMf1[4, j2] - (MW^2*S2B*(dSW1 - dZe1*SW) + 
           SW*((CB*dMWsq1 + 2*dCB1*MW^2)*SB - CB*MW^2*
              (SB*(dZbarfR1[4, j2, j2] + dZfL1[3, j1, j1] + dZHiggs1[5, 5]) - 
               CB*dZHiggs1[6, 5])))*Mass[F[4, {j2, o1}]])))/
     (Sqrt[2]*CB^2*MW^3*SW^2)}, 
   {(I*Sqrt[2]*CB^2*EL*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      Mass[F[3, {j1, o1}]])/(MW*S2B*SW), 
    ((I/4)*EL*IndexDelta[o1, o2]*(2*MW^2*S2B*SW*Conjugate[dCKM1[j1, j2]]*
        Mass[F[3, {j1, o1}]] + Conjugate[CKM[j1, j2]]*
        (2*MW^2*S2B*SW*dMf1[3, j1] - 
         (S2B*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW)) + 
           MW^2*SW*(4*CB*dSB1 - S2B*(dZbarfL1[4, j2, j2] + dZfR1[3, j1, j1] + 
               dZHiggs1[5, 5]) - 2*SB^2*dZHiggs1[6, 5]))*
          Mass[F[3, {j1, o1}]])))/(Sqrt[2]*MW^3*SB^2*SW^2)}}, 
 C[F[3, {j1, o1}], -F[4, {j2, o2}], S[6]] == 
  {{((-I)*EL*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*Mass[F[4, {j2, o1}]])/
     (Sqrt[2]*MW*SW), ((-I/2)*EL*IndexDelta[o1, o2]*
      (2*CB*MW^2*SW*Conjugate[dCKM1[j1, j2]]*Mass[F[4, {j2, o1}]] + 
       Conjugate[CKM[j1, j2]]*(2*CB*MW^2*SW*dMf1[4, j2] - 
         (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 + 
             SB*dZHiggs1[5, 6] - CB*(2*dZe1 + dZbarfR1[4, j2, j2] + dZfL1[3, 
                j1, j1] + dZHiggs1[6, 6])))*Mass[F[4, {j2, o1}]])))/
     (Sqrt[2]*CB*MW^3*SW^2)}, 
   {(I*EL*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*Mass[F[3, {j1, o1}]])/
     (Sqrt[2]*MW*SW), ((I/2)*EL*IndexDelta[o1, o2]*
      (2*MW^2*SB*SW*Conjugate[dCKM1[j1, j2]]*Mass[F[3, {j1, o1}]] + 
       Conjugate[CKM[j1, j2]]*(2*MW^2*SB*SW*dMf1[3, j1] - 
         ((dMWsq1*SB + 2*MW^2*(dSB1 - dZe1*SB))*SW + 
           MW^2*(2*dSW1*SB - SW*(CB*dZHiggs1[5, 6] + SB*(dZbarfL1[4, j2, 
                  j2] + dZfR1[3, j1, j1] + dZHiggs1[6, 6]))))*
          Mass[F[3, {j1, o1}]])))/(Sqrt[2]*MW^3*SB*SW^2)}}, 
 C[F[4, {j1, o1}], -F[3, {j2, o2}], -S[5]] == 
  {{(I*Sqrt[2]*CB^2*EL*CKM[j2, j1]*IndexDelta[o1, o2]*Mass[F[3, {j2, o1}]])/
     (MW*S2B*SW), ((I/4)*EL*IndexDelta[o1, o2]*
      (2*MW^2*S2B*SW*CKM[j2, j1]*dMf1[3, j2] + 
       (2*MW^2*S2B*SW*dCKM1[j2, j1] - CKM[j2, j1]*
          (S2B*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW)) + 
           MW^2*SW*(4*CB*dSB1 - S2B*(dZbarfR1[3, j2, j2] + dZbarHiggs1[5, 
                5] + dZfL1[4, j1, j1]) - 2*SB^2*dZHiggs1[5, 6])))*
        Mass[F[3, {j2, o1}]]))/(Sqrt[2]*MW^3*SB^2*SW^2)}, 
   {(I*Sqrt[2]*EL*SB^2*CKM[j2, j1]*IndexDelta[o1, o2]*Mass[F[4, {j1, o1}]])/
     (MW*S2B*SW), ((I/4)*EL*IndexDelta[o1, o2]*
      (2*MW^2*S2B*SW*CKM[j2, j1]*dMf1[4, j1] + 
       (2*MW^2*S2B*SW*dCKM1[j2, j1] - CKM[j2, j1]*
          (S2B*(dMWsq1*SW + 2*MW^2*(dSW1 - dZe1*SW)) + 
           MW^2*SW*(4*dCB1*SB - S2B*(dZbarfL1[3, j2, j2] + dZbarHiggs1[5, 
                5] + dZfR1[4, j1, j1]) + 2*CB^2*dZHiggs1[5, 6])))*
        Mass[F[4, {j1, o1}]]))/(Sqrt[2]*CB^2*MW^3*SW^2)}}, 
 C[F[4, {j1, o1}], -F[3, {j2, o2}], -S[6]] == 
  {{(I*EL*CKM[j2, j1]*IndexDelta[o1, o2]*Mass[F[3, {j2, o1}]])/
     (Sqrt[2]*MW*SW), ((I/2)*EL*IndexDelta[o1, o2]*
      (2*MW^2*SB*SW*CKM[j2, j1]*dMf1[3, j2] + 
       (2*MW^2*SB*SW*dCKM1[j2, j1] - CKM[j2, j1]*
          ((dMWsq1*SB + 2*MW^2*(dSB1 - dZe1*SB))*SW + 
           MW^2*(2*dSW1*SB - SW*(CB*dZHiggs1[6, 5] + SB*(dZbarfR1[3, j2, 
                  j2] + dZfL1[4, j1, j1] + dZHiggs1[6, 6])))))*
        Mass[F[3, {j2, o1}]]))/(Sqrt[2]*MW^3*SB*SW^2)}, 
   {((-I)*EL*CKM[j2, j1]*IndexDelta[o1, o2]*Mass[F[4, {j1, o1}]])/
     (Sqrt[2]*MW*SW), ((-I/2)*EL*IndexDelta[o1, o2]*
      (2*CB*MW^2*SW*dCKM1[j2, j1]*Mass[F[4, {j1, o1}]] + 
       CKM[j2, j1]*(2*CB*MW^2*SW*dMf1[4, j1] - 
         (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 + 
             SB*dZHiggs1[6, 5] - CB*(2*dZe1 + dZbarfL1[3, j2, j2] + dZfR1[4, 
                j1, j1] + dZHiggs1[6, 6])))*Mass[F[4, {j1, o1}]])))/
     (Sqrt[2]*CB*MW^3*SW^2)}}, C[-F[4, {j2, o1}], F[3, {j1, o2}], V[3]] == 
  {{((-I)*EL*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2])/(Sqrt[2]*SW), 
    ((I/2)*EL*((2*dSW1 - (2*dZe1 + dZW1)*SW)*Conjugate[CKM[j1, j2]] - 
       SW*(2*Conjugate[dCKM1[j1, j2]] + Conjugate[CKM[j1, 1]]*
          dZbarfL1[4, j2, 1] + Conjugate[CKM[j1, 2]]*dZbarfL1[4, j2, 2] + 
         Conjugate[CKM[j1, 3]]*dZbarfL1[4, j2, 3] + Conjugate[CKM[1, j2]]*
          dZfL1[3, 1, j1] + Conjugate[CKM[2, j2]]*dZfL1[3, 2, j1] + 
         Conjugate[CKM[3, j2]]*dZfL1[3, 3, j1]))*IndexDelta[o1, o2])/
     (Sqrt[2]*SW^2)}, {0, 0}}, C[-F[3, {j2, o1}], F[4, {j1, o2}], -V[3]] == 
  {{((-I)*EL*CKM[j2, j1]*IndexDelta[o1, o2])/(Sqrt[2]*SW), 
    ((I/2)*EL*((2*dSW1 - (2*dZe1 + dZW1)*SW)*CKM[j2, j1] - 
       SW*(2*dCKM1[j2, j1] + CKM[1, j1]*dZbarfL1[3, j2, 1] + 
         CKM[2, j1]*dZbarfL1[3, j2, 2] + CKM[3, j1]*dZbarfL1[3, j2, 3] + 
         CKM[j2, 1]*dZfL1[4, 1, j1] + CKM[j2, 2]*dZfL1[4, 2, j1] + 
         CKM[j2, 3]*dZfL1[4, 3, j1]))*IndexDelta[o1, o2])/(Sqrt[2]*SW^2)}, 
   {0, 0}}, C[S[3], S[12, {s1, j1}], -S[12, {s2, j2}]] == 
  {{-(EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]]*
       ((CB*MUE + SB*Conjugate[Af[2, j1, j1]])*Conjugate[USf[2, j1][s1, 2]]*
         USf[2, j1][s2, 1] - (SB*Af[2, j1, j1] + CB*Conjugate[MUE])*
         Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][s2, 2]))/(2*CB*MW*SW), 
    (EL*IndexDelta[j1, j2]*(SW*Mass[F[2, {j1}]]*
        ((CB*dMWsq1 + MW^2*(2*dCB1 - CB*(2*dZe1 + dZHiggs1[3, 3])))*
          ((CB*MUE + SB*Conjugate[Af[2, j1, j1]])*Conjugate[
             USf[2, j1][s1, 2]]*USf[2, j1][s2, 1] - 
           (SB*Af[2, j1, j1] + CB*Conjugate[MUE])*Conjugate[
             USf[2, j1][s1, 1]]*USf[2, j1][s2, 2]) - CB*MW^2*dZHiggs1[3, 4]*
          ((MUE*SB - CB*Conjugate[Af[2, j1, j1]])*Conjugate[
             USf[2, j1][s1, 2]]*USf[2, j1][s2, 1] + 
           (CB*Af[2, j1, j1] - SB*Conjugate[MUE])*Conjugate[
             USf[2, j1][s1, 1]]*USf[2, j1][s2, 2])) + 
       MW^2*(2*CB*dSW1*Mass[F[2, {j1}]]*
          ((CB*MUE + SB*Conjugate[Af[2, j1, j1]])*Conjugate[
             USf[2, j1][s1, 2]]*USf[2, j1][s2, 1] - 
           (SB*Af[2, j1, j1] + CB*Conjugate[MUE])*Conjugate[
             USf[2, j1][s1, 1]]*USf[2, j1][s2, 2]) - 
         SW*(Mass[F[2, {j1}]]*(CB*((CB*MUE + SB*Conjugate[Af[2, j1, j1]])*
                Conjugate[USf[2, j1][s1, 2]]*(dZbarSf1[1, s2, 2, j2]*
                  USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 
                   1]) - (SB*Af[2, j1, j1] + CB*Conjugate[MUE])*Conjugate[
                 USf[2, j1][s1, 1]]*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 
                   2] + dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 2])) + 
             (2*CB^2*dMUE1 + S2B*Conjugate[dAf1[2, j1, j1]])*
              Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 1] - 
             Conjugate[USf[2, j1][s1, 1]]*(2*CB^2*Conjugate[dMUE1] + S2B*
                dAf1[2, j1, j1])*USf[2, j1][s2, 2]) + 
           CB*(2*dMf1[2, j1]*((CB*MUE + SB*Conjugate[Af[2, j1, j1]])*
                Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 1] - 
               (SB*Af[2, j1, j1] + CB*Conjugate[MUE])*Conjugate[USf[2, j1][
                  s1, 1]]*USf[2, j1][s2, 2]) + Mass[F[2, {j1}]]*
              ((CB*MUE + SB*Conjugate[Af[2, j1, j1]])*
                (Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s1, 2, j1] + 
                 Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s1, 2, j1])*
                USf[2, j1][s2, 1] - (SB*Af[2, j1, j1] + CB*Conjugate[MUE])*
                (Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s1, 2, j1] + 
                 Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*
                USf[2, j1][s2, 2]))))))/(4*CB^2*MW^3*SW^2)}}, 
 C[S[4], S[12, {s1, j1}], -S[12, {s2, j2}]] == 
  {{-(EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]]*
       ((MUE*SB - CB*Conjugate[Af[2, j1, j1]])*Conjugate[USf[2, j1][s1, 2]]*
         USf[2, j1][s2, 1] + (CB*Af[2, j1, j1] - SB*Conjugate[MUE])*
         Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][s2, 2]))/(2*CB*MW*SW), 
    (EL*IndexDelta[j1, j2]*
      (SW*(CB*dMWsq1 + MW^2*(2*dCB1 - CB*(2*dZe1 + dZHiggs1[4, 4])))*
        Mass[F[2, {j1}]]*((MUE*SB - CB*Conjugate[Af[2, j1, j1]])*
          Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 1] + 
         (CB*Af[2, j1, j1] - SB*Conjugate[MUE])*Conjugate[USf[2, j1][s1, 1]]*
          USf[2, j1][s2, 2]) + MW^2*(2*CB*dSW1*Mass[F[2, {j1}]]*
          ((MUE*SB - CB*Conjugate[Af[2, j1, j1]])*Conjugate[
             USf[2, j1][s1, 2]]*USf[2, j1][s2, 1] + 
           (CB*Af[2, j1, j1] - SB*Conjugate[MUE])*Conjugate[
             USf[2, j1][s1, 1]]*USf[2, j1][s2, 2]) - 
         SW*(2*CB*dMf1[2, j1]*((MUE*SB - CB*Conjugate[Af[2, j1, j1]])*
              Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 1] + 
             (CB*Af[2, j1, j1] - SB*Conjugate[MUE])*Conjugate[USf[2, j1][s1, 
                1]]*USf[2, j1][s2, 2]) - Mass[F[2, {j1}]]*
            (2*CB^2*Conjugate[dAf1[2, j1, j1]]*Conjugate[USf[2, j1][s1, 2]]*
              USf[2, j1][s2, 1] + Conjugate[USf[2, j1][s1, 1]]*
              (S2B*Conjugate[dMUE1] - 2*CB^2*dAf1[2, j1, j1])*
              USf[2, j1][s2, 2] - CB*((CB*Af[2, j1, j1] - SB*Conjugate[MUE])*
                Conjugate[USf[2, j1][s1, 1]]*(dZbarSf1[1, s2, 2, j2]*
                  USf[2, j1][1, 2] + dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 
                   2]) + Conjugate[USf[2, j1][s1, 2]]*
                ((MUE*SB - CB*Conjugate[Af[2, j1, j1]])*(dZbarSf1[1, s2, 2, 
                     j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*USf[2, j1][
                     2, 1]) + 2*dMUE1*SB*USf[2, j1][s2, 1]) + dZSf1[1, s1, 2, 
                 j1]*((MUE*SB - CB*Conjugate[Af[2, j1, j1]])*Conjugate[
                   USf[2, j1][1, 2]]*USf[2, j1][s2, 1] + (CB*Af[2, j1, j1] - 
                   SB*Conjugate[MUE])*Conjugate[USf[2, j1][1, 1]]*USf[2, j1][
                   s2, 2]) + dZSf1[2, s1, 2, j1]*((MUE*SB - CB*Conjugate[
                     Af[2, j1, j1]])*Conjugate[USf[2, j1][2, 2]]*USf[2, j1][
                   s2, 1] + (CB*Af[2, j1, j1] - SB*Conjugate[MUE])*
                  Conjugate[USf[2, j1][2, 1]]*USf[2, j1][s2, 2]) + 
               dZHiggs1[3, 4]*((CB*MUE + SB*Conjugate[Af[2, j1, j1]])*
                  Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 1] - 
                 (SB*Af[2, j1, j1] + CB*Conjugate[MUE])*Conjugate[USf[2, j1][
                    s1, 1]]*USf[2, j1][s2, 2])))))))/(4*CB^2*MW^3*SW^2)}}, 
 C[S[3], S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}]] == 
  {{-(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[3, {j1}]]*
       ((MUE*SB + CB*Conjugate[Af[3, j1, j1]])*Conjugate[USf[3, j1][s1, 2]]*
         USf[3, j1][s2, 1] - (CB*Af[3, j1, j1] + SB*Conjugate[MUE])*
         Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 2]))/(2*MW*SB*SW), 
    (EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (SB*SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[3, 3]))*Mass[F[3, {j1}]]*
        ((MUE*SB + CB*Conjugate[Af[3, j1, j1]])*Conjugate[USf[3, j1][s1, 2]]*
          USf[3, j1][s2, 1] - (CB*Af[3, j1, j1] + SB*Conjugate[MUE])*
          Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 2]) + 
       MW^2*(2*(dSW1*SB + dSB1*SW)*Mass[F[3, {j1}]]*
          ((MUE*SB + CB*Conjugate[Af[3, j1, j1]])*Conjugate[
             USf[3, j1][s1, 2]]*USf[3, j1][s2, 1] - 
           (CB*Af[3, j1, j1] + SB*Conjugate[MUE])*Conjugate[
             USf[3, j1][s1, 1]]*USf[3, j1][s2, 2]) - 
         SW*(Mass[F[3, {j1}]]*(SB*((MUE*SB + CB*Conjugate[Af[3, j1, j1]])*
                Conjugate[USf[3, j1][s1, 2]]*(dZbarSf1[1, s2, 3, j2]*
                  USf[3, j1][1, 1] + dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 
                   1]) - (CB*Af[3, j1, j1] + SB*Conjugate[MUE])*Conjugate[
                 USf[3, j1][s1, 1]]*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 
                   2] + dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 2])) + 
             (2*dMUE1*SB^2 + S2B*Conjugate[dAf1[3, j1, j1]])*
              Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 1] - 
             Conjugate[USf[3, j1][s1, 1]]*(2*SB^2*Conjugate[dMUE1] + S2B*
                dAf1[3, j1, j1])*USf[3, j1][s2, 2]) + 
           SB*(2*dMf1[3, j1]*((MUE*SB + CB*Conjugate[Af[3, j1, j1]])*
                Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 1] - 
               (CB*Af[3, j1, j1] + SB*Conjugate[MUE])*Conjugate[USf[3, j1][
                  s1, 1]]*USf[3, j1][s2, 2]) + Mass[F[3, {j1}]]*
              (dZSf1[1, s1, 3, j1]*((MUE*SB + CB*Conjugate[Af[3, j1, j1]])*
                  Conjugate[USf[3, j1][1, 2]]*USf[3, j1][s2, 1] - 
                 (CB*Af[3, j1, j1] + SB*Conjugate[MUE])*Conjugate[USf[3, j1][
                    1, 1]]*USf[3, j1][s2, 2]) + dZSf1[2, s1, 3, j1]*
                ((MUE*SB + CB*Conjugate[Af[3, j1, j1]])*Conjugate[USf[3, j1][
                    2, 2]]*USf[3, j1][s2, 1] - (CB*Af[3, j1, j1] + 
                   SB*Conjugate[MUE])*Conjugate[USf[3, j1][2, 1]]*USf[3, j1][
                   s2, 2]) - dZHiggs1[3, 4]*((CB*MUE - SB*Conjugate[
                     Af[3, j1, j1]])*Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][
                   s2, 1] + (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*
                  Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 2])))))))/
     (4*MW^3*SB^2*SW^2)}}, C[S[4], S[13, {s1, j1, o1}], 
   -S[13, {s2, j2, o2}]] == 
  {{(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[3, {j1}]]*
      ((CB*MUE - SB*Conjugate[Af[3, j1, j1]])*Conjugate[USf[3, j1][s1, 2]]*
        USf[3, j1][s2, 1] + (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*
        Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 2]))/(2*MW*SB*SW), 
    -(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
       (SB*SW*Mass[F[3, {j1}]]*((dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[4, 4]))*
           ((CB*MUE - SB*Conjugate[Af[3, j1, j1]])*Conjugate[
              USf[3, j1][s1, 2]]*USf[3, j1][s2, 1] + 
            (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*Conjugate[
              USf[3, j1][s1, 1]]*USf[3, j1][s2, 2]) + MW^2*dZHiggs1[3, 4]*
           ((MUE*SB + CB*Conjugate[Af[3, j1, j1]])*Conjugate[
              USf[3, j1][s1, 2]]*USf[3, j1][s2, 1] - 
            (CB*Af[3, j1, j1] + SB*Conjugate[MUE])*Conjugate[
              USf[3, j1][s1, 1]]*USf[3, j1][s2, 2])) + 
        MW^2*(2*(dSW1*SB + dSB1*SW)*Mass[F[3, {j1}]]*
           ((CB*MUE - SB*Conjugate[Af[3, j1, j1]])*Conjugate[
              USf[3, j1][s1, 2]]*USf[3, j1][s2, 1] + 
            (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*Conjugate[
              USf[3, j1][s1, 1]]*USf[3, j1][s2, 2]) - 
          SW*(Mass[F[3, {j1}]]*(SB*((CB*MUE - SB*Conjugate[Af[3, j1, j1]])*
                 Conjugate[USf[3, j1][s1, 2]]*(dZbarSf1[1, s2, 3, j2]*
                   USf[3, j1][1, 1] + dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 
                    1]) + (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*Conjugate[
                  USf[3, j1][s1, 1]]*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 
                    2] + dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 2])) + 
              (dMUE1*S2B - 2*SB^2*Conjugate[dAf1[3, j1, j1]])*Conjugate[
                USf[3, j1][s1, 2]]*USf[3, j1][s2, 1] - Conjugate[
                USf[3, j1][s1, 1]]*(S2B*Conjugate[dMUE1] - 2*SB^2*
                 dAf1[3, j1, j1])*USf[3, j1][s2, 2]) + 
            SB*(2*dMf1[3, j1]*((CB*MUE - SB*Conjugate[Af[3, j1, j1]])*
                 Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 1] + 
                (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*Conjugate[USf[3, j1][
                   s1, 1]]*USf[3, j1][s2, 2]) + Mass[F[3, {j1}]]*(
                (CB*MUE - SB*Conjugate[Af[3, j1, j1]])*(Conjugate[USf[3, j1][
                     1, 2]]*dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 2]]*
                   dZSf1[2, s1, 3, j1])*USf[3, j1][s2, 1] + 
                (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*(Conjugate[USf[3, j1][
                     1, 1]]*dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 1]]*
                   dZSf1[2, s1, 3, j1])*USf[3, j1][s2, 2]))))))/
     (4*MW^3*SB^2*SW^2)}}, C[S[3], S[14, {s1, j1, o1}], 
   -S[14, {s2, j2, o2}]] == 
  {{-(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[4, {j1}]]*
       ((CB*MUE + SB*Conjugate[Af[4, j1, j1]])*Conjugate[USf[4, j1][s1, 2]]*
         USf[4, j1][s2, 1] - (SB*Af[4, j1, j1] + CB*Conjugate[MUE])*
         Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 2]))/(2*CB*MW*SW), 
    (EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (SW*Mass[F[4, {j1}]]*
        ((CB*dMWsq1 + MW^2*(2*dCB1 - CB*(2*dZe1 + dZHiggs1[3, 3])))*
          ((CB*MUE + SB*Conjugate[Af[4, j1, j1]])*Conjugate[
             USf[4, j1][s1, 2]]*USf[4, j1][s2, 1] - 
           (SB*Af[4, j1, j1] + CB*Conjugate[MUE])*Conjugate[
             USf[4, j1][s1, 1]]*USf[4, j1][s2, 2]) - CB*MW^2*dZHiggs1[3, 4]*
          ((MUE*SB - CB*Conjugate[Af[4, j1, j1]])*Conjugate[
             USf[4, j1][s1, 2]]*USf[4, j1][s2, 1] + 
           (CB*Af[4, j1, j1] - SB*Conjugate[MUE])*Conjugate[
             USf[4, j1][s1, 1]]*USf[4, j1][s2, 2])) + 
       MW^2*(2*CB*dSW1*Mass[F[4, {j1}]]*
          ((CB*MUE + SB*Conjugate[Af[4, j1, j1]])*Conjugate[
             USf[4, j1][s1, 2]]*USf[4, j1][s2, 1] - 
           (SB*Af[4, j1, j1] + CB*Conjugate[MUE])*Conjugate[
             USf[4, j1][s1, 1]]*USf[4, j1][s2, 2]) - 
         SW*(Mass[F[4, {j1}]]*(CB*((CB*MUE + SB*Conjugate[Af[4, j1, j1]])*
                Conjugate[USf[4, j1][s1, 2]]*(dZbarSf1[1, s2, 4, j2]*
                  USf[4, j1][1, 1] + dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 
                   1]) - (SB*Af[4, j1, j1] + CB*Conjugate[MUE])*Conjugate[
                 USf[4, j1][s1, 1]]*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 
                   2] + dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 2])) + 
             (2*CB^2*dMUE1 + S2B*Conjugate[dAf1[4, j1, j1]])*
              Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 1] - 
             Conjugate[USf[4, j1][s1, 1]]*(2*CB^2*Conjugate[dMUE1] + S2B*
                dAf1[4, j1, j1])*USf[4, j1][s2, 2]) + 
           CB*(2*dMf1[4, j1]*((CB*MUE + SB*Conjugate[Af[4, j1, j1]])*
                Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 1] - 
               (SB*Af[4, j1, j1] + CB*Conjugate[MUE])*Conjugate[USf[4, j1][
                  s1, 1]]*USf[4, j1][s2, 2]) + Mass[F[4, {j1}]]*
              ((CB*MUE + SB*Conjugate[Af[4, j1, j1]])*
                (Conjugate[USf[4, j1][1, 2]]*dZSf1[1, s1, 4, j1] + 
                 Conjugate[USf[4, j1][2, 2]]*dZSf1[2, s1, 4, j1])*
                USf[4, j1][s2, 1] - (SB*Af[4, j1, j1] + CB*Conjugate[MUE])*
                (Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s1, 4, j1] + 
                 Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s1, 4, j1])*
                USf[4, j1][s2, 2]))))))/(4*CB^2*MW^3*SW^2)}}, 
 C[S[4], S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{-(EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*Mass[F[4, {j1}]]*
       ((MUE*SB - CB*Conjugate[Af[4, j1, j1]])*Conjugate[USf[4, j1][s1, 2]]*
         USf[4, j1][s2, 1] + (CB*Af[4, j1, j1] - SB*Conjugate[MUE])*
         Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 2]))/(2*CB*MW*SW), 
    (EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (SW*(CB*dMWsq1 + MW^2*(2*dCB1 - CB*(2*dZe1 + dZHiggs1[4, 4])))*
        Mass[F[4, {j1}]]*((MUE*SB - CB*Conjugate[Af[4, j1, j1]])*
          Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 1] + 
         (CB*Af[4, j1, j1] - SB*Conjugate[MUE])*Conjugate[USf[4, j1][s1, 1]]*
          USf[4, j1][s2, 2]) + MW^2*(2*CB*dSW1*Mass[F[4, {j1}]]*
          ((MUE*SB - CB*Conjugate[Af[4, j1, j1]])*Conjugate[
             USf[4, j1][s1, 2]]*USf[4, j1][s2, 1] + 
           (CB*Af[4, j1, j1] - SB*Conjugate[MUE])*Conjugate[
             USf[4, j1][s1, 1]]*USf[4, j1][s2, 2]) - 
         SW*(2*CB*dMf1[4, j1]*((MUE*SB - CB*Conjugate[Af[4, j1, j1]])*
              Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 1] + 
             (CB*Af[4, j1, j1] - SB*Conjugate[MUE])*Conjugate[USf[4, j1][s1, 
                1]]*USf[4, j1][s2, 2]) - Mass[F[4, {j1}]]*
            (2*CB^2*Conjugate[dAf1[4, j1, j1]]*Conjugate[USf[4, j1][s1, 2]]*
              USf[4, j1][s2, 1] + Conjugate[USf[4, j1][s1, 1]]*
              (S2B*Conjugate[dMUE1] - 2*CB^2*dAf1[4, j1, j1])*
              USf[4, j1][s2, 2] - CB*((CB*Af[4, j1, j1] - SB*Conjugate[MUE])*
                Conjugate[USf[4, j1][s1, 1]]*(dZbarSf1[1, s2, 4, j2]*
                  USf[4, j1][1, 2] + dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 
                   2]) + Conjugate[USf[4, j1][s1, 2]]*
                ((MUE*SB - CB*Conjugate[Af[4, j1, j1]])*(dZbarSf1[1, s2, 4, 
                     j2]*USf[4, j1][1, 1] + dZbarSf1[2, s2, 4, j2]*USf[4, j1][
                     2, 1]) + 2*dMUE1*SB*USf[4, j1][s2, 1]) + dZSf1[1, s1, 4, 
                 j1]*((MUE*SB - CB*Conjugate[Af[4, j1, j1]])*Conjugate[
                   USf[4, j1][1, 2]]*USf[4, j1][s2, 1] + (CB*Af[4, j1, j1] - 
                   SB*Conjugate[MUE])*Conjugate[USf[4, j1][1, 1]]*USf[4, j1][
                   s2, 2]) + dZSf1[2, s1, 4, j1]*((MUE*SB - CB*Conjugate[
                     Af[4, j1, j1]])*Conjugate[USf[4, j1][2, 2]]*USf[4, j1][
                   s2, 1] + (CB*Af[4, j1, j1] - SB*Conjugate[MUE])*
                  Conjugate[USf[4, j1][2, 1]]*USf[4, j1][s2, 2]) + 
               dZHiggs1[3, 4]*((CB*MUE + SB*Conjugate[Af[4, j1, j1]])*
                  Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 1] - 
                 (SB*Af[4, j1, j1] + CB*Conjugate[MUE])*Conjugate[USf[4, j1][
                    s1, 1]]*USf[4, j1][s2, 2])))))))/(4*CB^2*MW^3*SW^2)}}, 
 C[S[1], S[11, {j1}], -S[11, {j2}]] == 
  {{((I/2)*EL*MZ*SAB*IndexDelta[j1, j2])/(CW*SW), 
    ((-I/4)*EL*(CW^2*(2*dSW1*MZ^2*SAB - 
         (dMZsq1*SAB + 2*MZ^2*(CAB*CB^2*dTB1 + dZe1*SAB))*SW) - 
       MZ^2*(2*dSW1*SAB*SW^2 - CW^2*SW*(CAB*dZHiggs1[1, 2] - 
           SAB*(dZbarSf1[1, 1, 1, j2] + dZHiggs1[1, 1] + dZSf1[1, 1, 1, 
              j1]))))*IndexDelta[j1, j2])/(CW^3*MZ*SW^2)}}, 
 C[S[2], S[11, {j1}], -S[11, {j2}]] == 
  {{((-I/2)*CAB*EL*MZ*IndexDelta[j1, j2])/(CW*SW), 
    ((-I/4)*EL*(CAB*CW^2*(dMZsq1*SW - 2*MZ^2*(dSW1 - dZe1*SW)) + 
       MZ^2*SW*(2*CAB*dSW1*SW - CW^2*(SAB*(2*CB^2*dTB1 + dZHiggs1[1, 2]) - 
           CAB*(dZbarSf1[1, 1, 1, j2] + dZHiggs1[2, 2] + dZSf1[1, 1, 1, 
              j1]))))*IndexDelta[j1, j2])/(CW^3*MZ*SW^2)}}, 
 C[S[1], S[12, {s1, j1}], -S[12, {s2, j2}]] == 
  {{((I/2)*EL*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s1, 1]]*
        ((CB*(1 - 2*CW^2)*MW*MZ*SAB + 2*CW*SA*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s2, 1] + CW*(SA*Af[2, j1, j1] + CA*Conjugate[MUE])*
          Mass[F[2, {j1}]]*USf[2, j1][s2, 2]) + Conjugate[USf[2, j1][s1, 2]]*
        (CW*(CA*MUE + SA*Conjugate[Af[2, j1, j1]])*Mass[F[2, {j1}]]*
          USf[2, j1][s2, 1] - (2*CB*MW*MZ*SAB*SW^2 - 
           2*CW*SA*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2])))/(CB*CW*MW*SW), 
    (I/4)*EL*IndexDelta[j1, j2]*
     (2*MZ*((dSW1*SAB)/CW^3 + (CAB*CB^2*dTB1)/(CW*SW))*
       ((1 - 2*CW^2)*Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][s2, 1] - 
        2*SW^2*Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 2]) + 
      (((dZbarSf1[1, s2, 2, j2]*(Conjugate[USf[2, j1][s1, 1]]*(
                (CB*(1 - 2*CW^2)*MW*MZ*SAB + 2*CW*SA*Mass[F[2, {j1}]]^2)*
                 USf[2, j1][1, 1] + CW*(SA*Af[2, j1, j1] + CA*Conjugate[MUE])*
                 Mass[F[2, {j1}]]*USf[2, j1][1, 2]) + Conjugate[USf[2, j1][
                 s1, 2]]*(CW*(CA*MUE + SA*Conjugate[Af[2, j1, j1]])*
                 Mass[F[2, {j1}]]*USf[2, j1][1, 1] - (2*CB*MW*MZ*SAB*SW^2 - 
                  2*CW*SA*Mass[F[2, {j1}]]^2)*USf[2, j1][1, 2])) + 
            dZbarSf1[2, s2, 2, j2]*(Conjugate[USf[2, j1][s1, 1]]*(
                (CB*(1 - 2*CW^2)*MW*MZ*SAB + 2*CW*SA*Mass[F[2, {j1}]]^2)*
                 USf[2, j1][2, 1] + CW*(SA*Af[2, j1, j1] + CA*Conjugate[MUE])*
                 Mass[F[2, {j1}]]*USf[2, j1][2, 2]) + Conjugate[USf[2, j1][
                 s1, 2]]*(CW*(CA*MUE + SA*Conjugate[Af[2, j1, j1]])*
                 Mass[F[2, {j1}]]*USf[2, j1][2, 1] - (2*CB*MW*MZ*SAB*SW^2 - 
                  2*CW*SA*Mass[F[2, {j1}]]^2)*USf[2, j1][2, 2])))/CW + 
          2*Mass[F[2, {j1}]]*((CA*dMUE1 + SA*Conjugate[dAf1[2, j1, j1]])*
             Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 1] + 
            Conjugate[USf[2, j1][s1, 1]]*(CA*Conjugate[dMUE1] + 
              SA*dAf1[2, j1, j1])*USf[2, j1][s2, 2]))/SW + 
        (2*dSW1*(Conjugate[USf[2, j1][s1, 1]]*((CB*(3 - 2*CW^2)*MW*MZ*SAB - 2*
                CW*SA*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 1] - 
             CW*(SA*Af[2, j1, j1] + CA*Conjugate[MUE])*Mass[F[2, {j1}]]*
              USf[2, j1][s2, 2]) - Conjugate[USf[2, j1][s1, 2]]*
            (CW*(CA*MUE + SA*Conjugate[Af[2, j1, j1]])*Mass[F[2, {j1}]]*
              USf[2, j1][s2, 1] + 2*(CB*MW*MZ*SAB*SW^2 + CW*SA*
                Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2])))/(CW*SW^2))/(CB*MW) + 
      ((dMZsq1*SAB*((1 - 2*CW^2)*Conjugate[USf[2, j1][s1, 1]]*
            USf[2, j1][s2, 1] - 2*SW^2*Conjugate[USf[2, j1][s1, 2]]*
            USf[2, j1][s2, 2]))/(CW*MZ) - ((CB*dMWsq1 + 2*dCB1*MW^2)*
          Mass[F[2, {j1}]]*(Conjugate[USf[2, j1][s1, 1]]*
            (2*SA*Mass[F[2, {j1}]]*USf[2, j1][s2, 1] + 
             (SA*Af[2, j1, j1] + CA*Conjugate[MUE])*USf[2, j1][s2, 2]) + 
           Conjugate[USf[2, j1][s1, 2]]*((CA*MUE + SA*Conjugate[Af[2, j1, 
                  j1]])*USf[2, j1][s2, 1] + 2*SA*Mass[F[2, {j1}]]*
              USf[2, j1][s2, 2])))/(CB^2*MW^3) + 
        (2*dMf1[2, j1]*(Conjugate[USf[2, j1][s1, 1]]*(4*SA*Mass[F[2, {j1}]]*
               USf[2, j1][s2, 1] + (SA*Af[2, j1, j1] + CA*Conjugate[MUE])*
               USf[2, j1][s2, 2]) + Conjugate[USf[2, j1][s1, 2]]*
             ((CA*MUE + SA*Conjugate[Af[2, j1, j1]])*USf[2, j1][s2, 1] + 
              4*SA*Mass[F[2, {j1}]]*USf[2, j1][s2, 2])) - 
          (dZHiggs1[1, 2]*(Conjugate[USf[2, j1][s1, 1]]*(
                (CAB*CB*(1 - 2*CW^2)*MW*MZ + 2*CA*CW*Mass[F[2, {j1}]]^2)*
                 USf[2, j1][s2, 1] + CW*(CA*Af[2, j1, j1] - SA*Conjugate[
                    MUE])*Mass[F[2, {j1}]]*USf[2, j1][s2, 2]) - 
              Conjugate[USf[2, j1][s1, 2]]*(CW*(MUE*SA - CA*Conjugate[
                    Af[2, j1, j1]])*Mass[F[2, {j1}]]*USf[2, j1][s2, 1] + 
                2*(CAB*CB*MW*MZ*SW^2 - CA*CW*Mass[F[2, {j1}]]^2)*USf[2, j1][
                  s2, 2])) - dZSf1[1, s1, 2, j1]*(Conjugate[USf[2, j1][1, 1]]*
               ((CB*(1 - 2*CW^2)*MW*MZ*SAB + 2*CW*SA*Mass[F[2, {j1}]]^2)*
                 USf[2, j1][s2, 1] + CW*(SA*Af[2, j1, j1] + CA*Conjugate[
                    MUE])*Mass[F[2, {j1}]]*USf[2, j1][s2, 2]) + 
              Conjugate[USf[2, j1][1, 2]]*(CW*(CA*MUE + SA*Conjugate[
                    Af[2, j1, j1]])*Mass[F[2, {j1}]]*USf[2, j1][s2, 1] - 
                (2*CB*MW*MZ*SAB*SW^2 - 2*CW*SA*Mass[F[2, {j1}]]^2)*
                 USf[2, j1][s2, 2])) - dZSf1[2, s1, 2, j1]*
             (Conjugate[USf[2, j1][2, 1]]*((CB*(1 - 2*CW^2)*MW*MZ*SAB + 
                  2*CW*SA*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 1] + 
                CW*(SA*Af[2, j1, j1] + CA*Conjugate[MUE])*Mass[F[2, {j1}]]*
                 USf[2, j1][s2, 2]) + Conjugate[USf[2, j1][2, 2]]*(
                CW*(CA*MUE + SA*Conjugate[Af[2, j1, j1]])*Mass[F[2, {j1}]]*
                 USf[2, j1][s2, 1] - (2*CB*MW*MZ*SAB*SW^2 - 2*CW*SA*
                   Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2])) - 
            (2*dZe1 + dZHiggs1[1, 1])*(Conjugate[USf[2, j1][s1, 1]]*(
                (CB*(1 - 2*CW^2)*MW*MZ*SAB + 2*CW*SA*Mass[F[2, {j1}]]^2)*
                 USf[2, j1][s2, 1] + CW*(SA*Af[2, j1, j1] + CA*Conjugate[
                    MUE])*Mass[F[2, {j1}]]*USf[2, j1][s2, 2]) + 
              Conjugate[USf[2, j1][s1, 2]]*(CW*(CA*MUE + SA*Conjugate[
                    Af[2, j1, j1]])*Mass[F[2, {j1}]]*USf[2, j1][s2, 1] - 
                (2*CB*MW*MZ*SAB*SW^2 - 2*CW*SA*Mass[F[2, {j1}]]^2)*
                 USf[2, j1][s2, 2])))/CW)/(CB*MW))/SW)}}, 
 C[S[2], S[12, {s1, j1}], -S[12, {s2, j2}]] == 
  {{((-I/2)*EL*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s1, 1]]*
        ((CAB*CB*(1 - 2*CW^2)*MW*MZ + 2*CA*CW*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s2, 1] + CW*(CA*Af[2, j1, j1] - SA*Conjugate[MUE])*
          Mass[F[2, {j1}]]*USf[2, j1][s2, 2]) - Conjugate[USf[2, j1][s1, 2]]*
        (CW*(MUE*SA - CA*Conjugate[Af[2, j1, j1]])*Mass[F[2, {j1}]]*
          USf[2, j1][s2, 1] + 2*(CAB*CB*MW*MZ*SW^2 - 
           CA*CW*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2])))/(CB*CW*MW*SW), 
    ((-I/4)*EL*IndexDelta[j1, j2]*
      ((Conjugate[USf[2, j1][s1, 1]]*
          ((CB*MW*MZ*(2*CAB*(3 - 2*CW^2)*dSW1 - (1 - 2*CW^2)*SAB*SW*
                dZHiggs1[1, 2]) - 2*CW*(2*CA*dSW1 + SA*SW*dZHiggs1[1, 2])*
              Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 1] + 
           CW*(Conjugate[MUE]*(2*dSW1*SA - CA*SW*dZHiggs1[1, 2]) - 
             Af[2, j1, j1]*(2*CA*dSW1 + SA*SW*dZHiggs1[1, 2]))*
            Mass[F[2, {j1}]]*USf[2, j1][s2, 2]) - 
         Conjugate[USf[2, j1][s1, 2]]*(2*CB*MW*MZ*SW^2*(2*CAB*dSW1 - 
             SAB*SW*dZHiggs1[1, 2])*USf[2, j1][s2, 2] - 
           CW*((MUE*(2*dSW1*SA - CA*SW*dZHiggs1[1, 2]) - Conjugate[
                 Af[2, j1, j1]]*(2*CA*dSW1 + SA*SW*dZHiggs1[1, 2]))*
              Mass[F[2, {j1}]]*USf[2, j1][s2, 1] - 2*(2*CA*dSW1 + SA*SW*
                dZHiggs1[1, 2])*Mass[F[2, {j1}]]^2*USf[2, j1][s2, 2])))/
        (CB*CW*MW) - SW*((2*MZ*(CB^2*CW^2*dTB1*SAB - CAB*dSW1*SW)*
           ((1 - 2*CW^2)*Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][s2, 1] - 
            2*SW^2*Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 2]))/CW^3 + 
         ((CB*dMWsq1 + 2*dCB1*MW^2)*Mass[F[2, {j1}]]*
           (Conjugate[USf[2, j1][s1, 1]]*(2*CA*Mass[F[2, {j1}]]*USf[2, j1][
                s2, 1] + (CA*Af[2, j1, j1] - SA*Conjugate[MUE])*USf[2, j1][
                s2, 2]) - Conjugate[USf[2, j1][s1, 2]]*
             ((MUE*SA - CA*Conjugate[Af[2, j1, j1]])*USf[2, j1][s2, 1] - 
              2*CA*Mass[F[2, {j1}]]*USf[2, j1][s2, 2])))/(CB^2*MW^3) - 
         ((CAB*dMZsq1*((1 - 2*CW^2)*Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][
                s2, 1] - 2*SW^2*Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 
                2]))/MZ - (Conjugate[USf[2, j1][s1, 2]]*(dZbarSf1[1, s2, 2, 
                 j2]*(2*CAB*CB*MW*MZ*SW^2*USf[2, j1][1, 2] + 
                 CW*((MUE*SA - CA*Conjugate[Af[2, j1, j1]])*Mass[F[2, {j1}]]*
                    USf[2, j1][1, 1] - 2*CA*Mass[F[2, {j1}]]^2*USf[2, j1][1, 
                     2])) + dZbarSf1[2, s2, 2, j2]*(2*CAB*CB*MW*MZ*SW^2*
                  USf[2, j1][2, 2] + CW*((MUE*SA - CA*Conjugate[Af[2, j1, 
                        j1]])*Mass[F[2, {j1}]]*USf[2, j1][2, 1] - 
                   2*CA*Mass[F[2, {j1}]]^2*USf[2, j1][2, 2])) + 2*CW*
                (dMUE1*SA - CA*Conjugate[dAf1[2, j1, j1]])*Mass[F[2, {j1}]]*
                USf[2, j1][s2, 1]) - Conjugate[USf[2, j1][s1, 1]]*
              (dZbarSf1[1, s2, 2, j2]*((CAB*CB*(1 - 2*CW^2)*MW*MZ + 
                   2*CA*CW*Mass[F[2, {j1}]]^2)*USf[2, j1][1, 1] + 
                 CW*(CA*Af[2, j1, j1] - SA*Conjugate[MUE])*Mass[F[2, {j1}]]*
                  USf[2, j1][1, 2]) + dZbarSf1[2, s2, 2, j2]*
                ((CAB*CB*(1 - 2*CW^2)*MW*MZ + 2*CA*CW*Mass[F[2, {j1}]]^2)*
                  USf[2, j1][2, 1] + CW*(CA*Af[2, j1, j1] - SA*Conjugate[
                     MUE])*Mass[F[2, {j1}]]*USf[2, j1][2, 2]) - 2*CW*
                (SA*Conjugate[dMUE1] - CA*dAf1[2, j1, j1])*Mass[F[2, {j1}]]*
                USf[2, j1][s2, 2]))/(CB*MW))/CW - 
         (2*dMf1[2, j1]*(Conjugate[USf[2, j1][s1, 1]]*(4*CA*Mass[F[2, {j1}]]*
                USf[2, j1][s2, 1] + (CA*Af[2, j1, j1] - SA*Conjugate[MUE])*
                USf[2, j1][s2, 2]) - Conjugate[USf[2, j1][s1, 2]]*
              ((MUE*SA - CA*Conjugate[Af[2, j1, j1]])*USf[2, j1][s2, 1] - 4*
                CA*Mass[F[2, {j1}]]*USf[2, j1][s2, 2])) + 
           (dZSf1[1, s1, 2, j1]*(Conjugate[USf[2, j1][1, 1]]*
                ((CAB*CB*(1 - 2*CW^2)*MW*MZ + 2*CA*CW*Mass[F[2, {j1}]]^2)*
                  USf[2, j1][s2, 1] + CW*(CA*Af[2, j1, j1] - SA*Conjugate[
                     MUE])*Mass[F[2, {j1}]]*USf[2, j1][s2, 2]) - Conjugate[
                 USf[2, j1][1, 2]]*(CW*(MUE*SA - CA*Conjugate[Af[2, j1, j1]])*
                  Mass[F[2, {j1}]]*USf[2, j1][s2, 1] + 2*(CAB*CB*MW*MZ*SW^2 - 
                   CA*CW*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2])) + 
             dZSf1[2, s1, 2, j1]*(Conjugate[USf[2, j1][2, 1]]*
                ((CAB*CB*(1 - 2*CW^2)*MW*MZ + 2*CA*CW*Mass[F[2, {j1}]]^2)*
                  USf[2, j1][s2, 1] + CW*(CA*Af[2, j1, j1] - SA*Conjugate[
                     MUE])*Mass[F[2, {j1}]]*USf[2, j1][s2, 2]) - Conjugate[
                 USf[2, j1][2, 2]]*(CW*(MUE*SA - CA*Conjugate[Af[2, j1, j1]])*
                  Mass[F[2, {j1}]]*USf[2, j1][s2, 1] + 2*(CAB*CB*MW*MZ*SW^2 - 
                   CA*CW*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2])) + 
             (2*dZe1 + dZHiggs1[2, 2])*(Conjugate[USf[2, j1][s1, 1]]*
                ((CAB*CB*(1 - 2*CW^2)*MW*MZ + 2*CA*CW*Mass[F[2, {j1}]]^2)*
                  USf[2, j1][s2, 1] + CW*(CA*Af[2, j1, j1] - SA*Conjugate[
                     MUE])*Mass[F[2, {j1}]]*USf[2, j1][s2, 2]) - Conjugate[
                 USf[2, j1][s1, 2]]*(CW*(MUE*SA - CA*Conjugate[Af[2, j1, 
                      j1]])*Mass[F[2, {j1}]]*USf[2, j1][s2, 1] + 
                 2*(CAB*CB*MW*MZ*SW^2 - CA*CW*Mass[F[2, {j1}]]^2)*USf[2, j1][
                   s2, 2])))/CW)/(CB*MW))))/SW^2}}, 
 C[S[1], S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}]] == 
  {{((-I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s1, 1]]*(((1 - 4*CW^2)*MW*MZ*SAB*SB + 
           6*CA*CW*Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 1] + 
         3*CW*(CA*Af[3, j1, j1] + SA*Conjugate[MUE])*Mass[F[3, {j1}]]*
          USf[3, j1][s2, 2]) + Conjugate[USf[3, j1][s1, 2]]*
        (3*CW*(MUE*SA + CA*Conjugate[Af[3, j1, j1]])*Mass[F[3, {j1}]]*
          USf[3, j1][s2, 1] - (4*MW*MZ*SAB*SB*SW^2 - 
           6*CA*CW*Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 2])))/(CW*MW*SB*SW), 
    (-I/12)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
     (2*MZ*((dSW1*SAB)/CW^3 + (CAB*CB^2*dTB1)/(CW*SW))*
       ((1 - 4*CW^2)*Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 1] - 
        4*SW^2*Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 2]) + 
      (((dZbarSf1[1, s2, 3, j2]*(Conjugate[USf[3, j1][s1, 1]]*(
                ((1 - 4*CW^2)*MW*MZ*SAB*SB + 6*CA*CW*Mass[F[3, {j1}]]^2)*
                 USf[3, j1][1, 1] + 3*CW*(CA*Af[3, j1, j1] + SA*Conjugate[
                    MUE])*Mass[F[3, {j1}]]*USf[3, j1][1, 2]) + 
              Conjugate[USf[3, j1][s1, 2]]*(3*CW*(MUE*SA + CA*Conjugate[
                    Af[3, j1, j1]])*Mass[F[3, {j1}]]*USf[3, j1][1, 1] - 
                (4*MW*MZ*SAB*SB*SW^2 - 6*CA*CW*Mass[F[3, {j1}]]^2)*
                 USf[3, j1][1, 2])) + dZbarSf1[2, s2, 3, j2]*
             (Conjugate[USf[3, j1][s1, 1]]*(((1 - 4*CW^2)*MW*MZ*SAB*SB + 
                  6*CA*CW*Mass[F[3, {j1}]]^2)*USf[3, j1][2, 1] + 
                3*CW*(CA*Af[3, j1, j1] + SA*Conjugate[MUE])*Mass[F[3, {j1}]]*
                 USf[3, j1][2, 2]) + Conjugate[USf[3, j1][s1, 2]]*(
                3*CW*(MUE*SA + CA*Conjugate[Af[3, j1, j1]])*Mass[F[3, {j1}]]*
                 USf[3, j1][2, 1] - (4*MW*MZ*SAB*SB*SW^2 - 6*CA*CW*
                   Mass[F[3, {j1}]]^2)*USf[3, j1][2, 2])))/CW + 
          6*Mass[F[3, {j1}]]*((dMUE1*SA + CA*Conjugate[dAf1[3, j1, j1]])*
             Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 1] + 
            Conjugate[USf[3, j1][s1, 1]]*(SA*Conjugate[dMUE1] + 
              CA*dAf1[3, j1, j1])*USf[3, j1][s2, 2]))/SW + 
        (Conjugate[USf[3, j1][s1, 1]]*((MW*MZ*SB*(2*(7 - 4*CW^2)*dSW1*SAB - 
                CAB*(1 - 4*CW^2)*SW*dZHiggs1[1, 2]) - 6*CW*(2*CA*dSW1 - 
                SA*SW*dZHiggs1[1, 2])*Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 1] - 
            3*CW*(Conjugate[MUE]*(2*dSW1*SA + CA*SW*dZHiggs1[1, 2]) + 
              Af[3, j1, j1]*(2*CA*dSW1 - SA*SW*dZHiggs1[1, 2]))*
             Mass[F[3, {j1}]]*USf[3, j1][s2, 2]) - 
          Conjugate[USf[3, j1][s1, 2]]*(4*MW*MZ*SB*SW^2*(2*dSW1*SAB - 
              CAB*SW*dZHiggs1[1, 2])*USf[3, j1][s2, 2] + 
            CW*(3*(MUE*(2*dSW1*SA + CA*SW*dZHiggs1[1, 2]) + 
                Conjugate[Af[3, j1, j1]]*(2*CA*dSW1 - SA*SW*dZHiggs1[1, 2]))*
               Mass[F[3, {j1}]]*USf[3, j1][s2, 1] + 6*(2*CA*dSW1 - 
                SA*SW*dZHiggs1[1, 2])*Mass[F[3, {j1}]]^2*USf[3, j1][s2, 2])))/
         (CW*SW^2))/(MW*SB) + 
      ((dMZsq1*SAB*((1 - 4*CW^2)*Conjugate[USf[3, j1][s1, 1]]*
            USf[3, j1][s2, 1] - 4*SW^2*Conjugate[USf[3, j1][s1, 2]]*
            USf[3, j1][s2, 2]))/(CW*MZ) - (3*(2*dSB1*MW^2 + dMWsq1*SB)*
          Mass[F[3, {j1}]]*(Conjugate[USf[3, j1][s1, 1]]*
            (2*CA*Mass[F[3, {j1}]]*USf[3, j1][s2, 1] + 
             (CA*Af[3, j1, j1] + SA*Conjugate[MUE])*USf[3, j1][s2, 2]) + 
           Conjugate[USf[3, j1][s1, 2]]*((MUE*SA + CA*Conjugate[Af[3, j1, 
                  j1]])*USf[3, j1][s2, 1] + 2*CA*Mass[F[3, {j1}]]*
              USf[3, j1][s2, 2])))/(MW^3*SB^2) + 
        (6*dMf1[3, j1]*(Conjugate[USf[3, j1][s1, 1]]*(4*CA*Mass[F[3, {j1}]]*
               USf[3, j1][s2, 1] + (CA*Af[3, j1, j1] + SA*Conjugate[MUE])*
               USf[3, j1][s2, 2]) + Conjugate[USf[3, j1][s1, 2]]*
             ((MUE*SA + CA*Conjugate[Af[3, j1, j1]])*USf[3, j1][s2, 1] + 
              4*CA*Mass[F[3, {j1}]]*USf[3, j1][s2, 2])) + 
          (dZSf1[1, s1, 3, j1]*(Conjugate[USf[3, j1][1, 1]]*(
                ((1 - 4*CW^2)*MW*MZ*SAB*SB + 6*CA*CW*Mass[F[3, {j1}]]^2)*
                 USf[3, j1][s2, 1] + 3*CW*(CA*Af[3, j1, j1] + 
                  SA*Conjugate[MUE])*Mass[F[3, {j1}]]*USf[3, j1][s2, 2]) + 
              Conjugate[USf[3, j1][1, 2]]*(3*CW*(MUE*SA + CA*Conjugate[
                    Af[3, j1, j1]])*Mass[F[3, {j1}]]*USf[3, j1][s2, 1] - 
                (4*MW*MZ*SAB*SB*SW^2 - 6*CA*CW*Mass[F[3, {j1}]]^2)*
                 USf[3, j1][s2, 2])) + dZSf1[2, s1, 3, j1]*
             (Conjugate[USf[3, j1][2, 1]]*(((1 - 4*CW^2)*MW*MZ*SAB*SB + 
                  6*CA*CW*Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 1] + 
                3*CW*(CA*Af[3, j1, j1] + SA*Conjugate[MUE])*Mass[F[3, {j1}]]*
                 USf[3, j1][s2, 2]) + Conjugate[USf[3, j1][2, 2]]*(
                3*CW*(MUE*SA + CA*Conjugate[Af[3, j1, j1]])*Mass[F[3, {j1}]]*
                 USf[3, j1][s2, 1] - (4*MW*MZ*SAB*SB*SW^2 - 6*CA*CW*
                   Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 2])) + 
            (2*dZe1 + dZHiggs1[1, 1])*(Conjugate[USf[3, j1][s1, 1]]*(
                ((1 - 4*CW^2)*MW*MZ*SAB*SB + 6*CA*CW*Mass[F[3, {j1}]]^2)*
                 USf[3, j1][s2, 1] + 3*CW*(CA*Af[3, j1, j1] + 
                  SA*Conjugate[MUE])*Mass[F[3, {j1}]]*USf[3, j1][s2, 2]) + 
              Conjugate[USf[3, j1][s1, 2]]*(3*CW*(MUE*SA + CA*Conjugate[
                    Af[3, j1, j1]])*Mass[F[3, {j1}]]*USf[3, j1][s2, 1] - 
                (4*MW*MZ*SAB*SB*SW^2 - 6*CA*CW*Mass[F[3, {j1}]]^2)*
                 USf[3, j1][s2, 2])))/CW)/(MW*SB))/SW)}}, 
 C[S[2], S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}]] == 
  {{((I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s1, 1]]*((CAB*(1 - 4*CW^2)*MW*MZ*SB - 
           6*CW*SA*Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 1] - 
         3*CW*(SA*Af[3, j1, j1] - CA*Conjugate[MUE])*Mass[F[3, {j1}]]*
          USf[3, j1][s2, 2]) + Conjugate[USf[3, j1][s1, 2]]*
        (3*CW*(CA*MUE - SA*Conjugate[Af[3, j1, j1]])*Mass[F[3, {j1}]]*
          USf[3, j1][s2, 1] - 2*(2*CAB*MW*MZ*SB*SW^2 + 
           3*CW*SA*Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 2])))/(CW*MW*SB*SW), 
    ((-I/12)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (SW*((2*MZ*(CB^2*CW^2*dTB1*SAB - CAB*dSW1*SW)*
           ((1 - 4*CW^2)*Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 1] - 
            4*SW^2*Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 2]))/CW^3 - 
         (3*(2*dSB1*MW^2 + dMWsq1*SB)*Mass[F[3, {j1}]]*
           (Conjugate[USf[3, j1][s1, 1]]*(2*SA*Mass[F[3, {j1}]]*USf[3, j1][
                s2, 1] + (SA*Af[3, j1, j1] - CA*Conjugate[MUE])*USf[3, j1][
                s2, 2]) - Conjugate[USf[3, j1][s1, 2]]*
             ((CA*MUE - SA*Conjugate[Af[3, j1, j1]])*USf[3, j1][s2, 1] - 
              2*SA*Mass[F[3, {j1}]]*USf[3, j1][s2, 2])))/(MW^3*SB^2) - 
         ((CAB*dMZsq1*((1 - 4*CW^2)*Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][
                s2, 1] - 4*SW^2*Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 
                2]))/MZ - (Conjugate[USf[3, j1][s1, 2]]*(dZbarSf1[1, s2, 3, 
                 j2]*(4*CAB*MW*MZ*SB*SW^2*USf[3, j1][1, 2] - 
                 CW*(3*(CA*MUE - SA*Conjugate[Af[3, j1, j1]])*Mass[
                     F[3, {j1}]]*USf[3, j1][1, 1] - 6*SA*Mass[F[3, {j1}]]^2*
                    USf[3, j1][1, 2])) + dZbarSf1[2, s2, 3, j2]*
                (4*CAB*MW*MZ*SB*SW^2*USf[3, j1][2, 2] - 
                 CW*(3*(CA*MUE - SA*Conjugate[Af[3, j1, j1]])*Mass[
                     F[3, {j1}]]*USf[3, j1][2, 1] - 6*SA*Mass[F[3, {j1}]]^2*
                    USf[3, j1][2, 2])) - 6*CW*(CA*dMUE1 - SA*Conjugate[
                   dAf1[3, j1, j1]])*Mass[F[3, {j1}]]*USf[3, j1][s2, 1]) - 
             Conjugate[USf[3, j1][s1, 1]]*(dZbarSf1[1, s2, 3, j2]*
                ((CAB*(1 - 4*CW^2)*MW*MZ*SB - 6*CW*SA*Mass[F[3, {j1}]]^2)*
                  USf[3, j1][1, 1] - 3*CW*(SA*Af[3, j1, j1] - CA*Conjugate[
                     MUE])*Mass[F[3, {j1}]]*USf[3, j1][1, 2]) + dZbarSf1[2, 
                 s2, 3, j2]*((CAB*(1 - 4*CW^2)*MW*MZ*SB - 6*CW*SA*
                    Mass[F[3, {j1}]]^2)*USf[3, j1][2, 1] - 3*CW*
                  (SA*Af[3, j1, j1] - CA*Conjugate[MUE])*Mass[F[3, {j1}]]*
                  USf[3, j1][2, 2]) + 6*CW*(CA*Conjugate[dMUE1] - 
                 SA*dAf1[3, j1, j1])*Mass[F[3, {j1}]]*USf[3, j1][s2, 2]))/
            (MW*SB))/CW + (6*dMf1[3, j1]*(Conjugate[USf[3, j1][s1, 1]]*
              (4*SA*Mass[F[3, {j1}]]*USf[3, j1][s2, 1] + (SA*Af[3, j1, j1] - 
                 CA*Conjugate[MUE])*USf[3, j1][s2, 2]) - 
             Conjugate[USf[3, j1][s1, 2]]*((CA*MUE - SA*Conjugate[Af[3, j1, 
                    j1]])*USf[3, j1][s2, 1] - 4*SA*Mass[F[3, {j1}]]*
                USf[3, j1][s2, 2])) + (dZHiggs1[1, 2]*
             (Conjugate[USf[3, j1][s1, 1]]*(((1 - 4*CW^2)*MW*MZ*SAB*SB + 
                  6*CA*CW*Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 1] + 
                3*CW*(CA*Af[3, j1, j1] + SA*Conjugate[MUE])*Mass[F[3, {j1}]]*
                 USf[3, j1][s2, 2]) + Conjugate[USf[3, j1][s1, 2]]*(
                3*CW*(MUE*SA + CA*Conjugate[Af[3, j1, j1]])*Mass[F[3, {j1}]]*
                 USf[3, j1][s2, 1] - (4*MW*MZ*SAB*SB*SW^2 - 6*CA*CW*
                   Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 2])))/CW)/(MW*SB)) - 
       (2*dSW1*(Conjugate[USf[3, j1][s1, 1]]*((CAB*(7 - 4*CW^2)*MW*MZ*SB + 6*
                CW*SA*Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 1] + 
             3*CW*(SA*Af[3, j1, j1] - CA*Conjugate[MUE])*Mass[F[3, {j1}]]*
              USf[3, j1][s2, 2]) - Conjugate[USf[3, j1][s1, 2]]*
            (3*CW*(CA*MUE - SA*Conjugate[Af[3, j1, j1]])*Mass[F[3, {j1}]]*
              USf[3, j1][s2, 1] + (4*CAB*MW*MZ*SB*SW^2 - 6*CW*SA*
                Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 2])) + 
         SW*(dZSf1[1, s1, 3, j1]*(Conjugate[USf[3, j1][1, 1]]*
              ((CAB*(1 - 4*CW^2)*MW*MZ*SB - 6*CW*SA*Mass[F[3, {j1}]]^2)*
                USf[3, j1][s2, 1] - 3*CW*(SA*Af[3, j1, j1] - 
                 CA*Conjugate[MUE])*Mass[F[3, {j1}]]*USf[3, j1][s2, 2]) + 
             Conjugate[USf[3, j1][1, 2]]*(3*CW*(CA*MUE - SA*Conjugate[
                   Af[3, j1, j1]])*Mass[F[3, {j1}]]*USf[3, j1][s2, 1] - 2*
                (2*CAB*MW*MZ*SB*SW^2 + 3*CW*SA*Mass[F[3, {j1}]]^2)*
                USf[3, j1][s2, 2])) + dZSf1[2, s1, 3, j1]*
            (Conjugate[USf[3, j1][2, 1]]*((CAB*(1 - 4*CW^2)*MW*MZ*SB - 
                 6*CW*SA*Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 1] - 3*CW*
                (SA*Af[3, j1, j1] - CA*Conjugate[MUE])*Mass[F[3, {j1}]]*
                USf[3, j1][s2, 2]) + Conjugate[USf[3, j1][2, 2]]*
              (3*CW*(CA*MUE - SA*Conjugate[Af[3, j1, j1]])*Mass[F[3, {j1}]]*
                USf[3, j1][s2, 1] - 2*(2*CAB*MW*MZ*SB*SW^2 + 3*CW*SA*
                  Mass[F[3, {j1}]]^2)*USf[3, j1][s2, 2])) + 
           (2*dZe1 + dZHiggs1[2, 2])*(Conjugate[USf[3, j1][s1, 1]]*
              ((CAB*(1 - 4*CW^2)*MW*MZ*SB - 6*CW*SA*Mass[F[3, {j1}]]^2)*
                USf[3, j1][s2, 1] - 3*CW*(SA*Af[3, j1, j1] - 
                 CA*Conjugate[MUE])*Mass[F[3, {j1}]]*USf[3, j1][s2, 2]) + 
             Conjugate[USf[3, j1][s1, 2]]*(3*CW*(CA*MUE - SA*Conjugate[
                   Af[3, j1, j1]])*Mass[F[3, {j1}]]*USf[3, j1][s2, 1] - 2*
                (2*CAB*MW*MZ*SB*SW^2 + 3*CW*SA*Mass[F[3, {j1}]]^2)*
                USf[3, j1][s2, 2]))))/(CW*MW*SB)))/SW^2}}, 
 C[S[1], S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{((-I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s1, 1]]*((CB*(1 + 2*CW^2)*MW*MZ*SAB - 
           6*CW*SA*Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 1] - 
         3*CW*(SA*Af[4, j1, j1] + CA*Conjugate[MUE])*Mass[F[4, {j1}]]*
          USf[4, j1][s2, 2]) - Conjugate[USf[4, j1][s1, 2]]*
        (3*CW*(CA*MUE + SA*Conjugate[Af[4, j1, j1]])*Mass[F[4, {j1}]]*
          USf[4, j1][s2, 1] - (2*CB*MW*MZ*SAB*SW^2 - 
           6*CW*SA*Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 2])))/(CB*CW*MW*SW), 
    (-I/12)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
     (2*MZ*((dSW1*SAB)/CW^3 + (CAB*CB^2*dTB1)/(CW*SW))*
       ((1 + 2*CW^2)*Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 
        2*SW^2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]) + 
      (((dZbarSf1[1, s2, 4, j2]*(Conjugate[USf[4, j1][s1, 1]]*(
                (CB*(1 + 2*CW^2)*MW*MZ*SAB - 6*CW*SA*Mass[F[4, {j1}]]^2)*
                 USf[4, j1][1, 1] - 3*CW*(SA*Af[4, j1, j1] + CA*Conjugate[
                    MUE])*Mass[F[4, {j1}]]*USf[4, j1][1, 2]) - 
              Conjugate[USf[4, j1][s1, 2]]*(3*CW*(CA*MUE + SA*Conjugate[
                    Af[4, j1, j1]])*Mass[F[4, {j1}]]*USf[4, j1][1, 1] - 
                (2*CB*MW*MZ*SAB*SW^2 - 6*CW*SA*Mass[F[4, {j1}]]^2)*
                 USf[4, j1][1, 2])) + dZbarSf1[2, s2, 4, j2]*
             (Conjugate[USf[4, j1][s1, 1]]*((CB*(1 + 2*CW^2)*MW*MZ*SAB - 
                  6*CW*SA*Mass[F[4, {j1}]]^2)*USf[4, j1][2, 1] - 
                3*CW*(SA*Af[4, j1, j1] + CA*Conjugate[MUE])*Mass[F[4, {j1}]]*
                 USf[4, j1][2, 2]) - Conjugate[USf[4, j1][s1, 2]]*(
                3*CW*(CA*MUE + SA*Conjugate[Af[4, j1, j1]])*Mass[F[4, {j1}]]*
                 USf[4, j1][2, 1] - (2*CB*MW*MZ*SAB*SW^2 - 6*CW*SA*
                   Mass[F[4, {j1}]]^2)*USf[4, j1][2, 2])))/CW - 
          6*Mass[F[4, {j1}]]*((CA*dMUE1 + SA*Conjugate[dAf1[4, j1, j1]])*
             Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 1] + 
            Conjugate[USf[4, j1][s1, 1]]*(CA*Conjugate[dMUE1] + 
              SA*dAf1[4, j1, j1])*USf[4, j1][s2, 2]))/SW - 
        (2*dSW1*(Conjugate[USf[4, j1][s1, 1]]*((CB*(5 - 2*CW^2)*MW*MZ*SAB - 6*
                CW*SA*Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 1] - 
             3*CW*(SA*Af[4, j1, j1] + CA*Conjugate[MUE])*Mass[F[4, {j1}]]*
              USf[4, j1][s2, 2]) - Conjugate[USf[4, j1][s1, 2]]*
            (2*CB*MW*MZ*SAB*SW^2*USf[4, j1][s2, 2] + 
             CW*(3*(CA*MUE + SA*Conjugate[Af[4, j1, j1]])*Mass[F[4, {j1}]]*
                USf[4, j1][s2, 1] + 6*SA*Mass[F[4, {j1}]]^2*USf[4, j1][s2, 
                 2]))))/(CW*SW^2))/(CB*MW) + 
      ((dMZsq1*SAB*((1 + 2*CW^2)*Conjugate[USf[4, j1][s1, 1]]*
            USf[4, j1][s2, 1] + 2*SW^2*Conjugate[USf[4, j1][s1, 2]]*
            USf[4, j1][s2, 2]))/(CW*MZ) + (3*(CB*dMWsq1 + 2*dCB1*MW^2)*
          Mass[F[4, {j1}]]*(Conjugate[USf[4, j1][s1, 1]]*
            (2*SA*Mass[F[4, {j1}]]*USf[4, j1][s2, 1] + 
             (SA*Af[4, j1, j1] + CA*Conjugate[MUE])*USf[4, j1][s2, 2]) + 
           Conjugate[USf[4, j1][s1, 2]]*((CA*MUE + SA*Conjugate[Af[4, j1, 
                  j1]])*USf[4, j1][s2, 1] + 2*SA*Mass[F[4, {j1}]]*
              USf[4, j1][s2, 2])))/(CB^2*MW^3) - 
        (6*dMf1[4, j1]*(Conjugate[USf[4, j1][s1, 1]]*(4*SA*Mass[F[4, {j1}]]*
               USf[4, j1][s2, 1] + (SA*Af[4, j1, j1] + CA*Conjugate[MUE])*
               USf[4, j1][s2, 2]) + Conjugate[USf[4, j1][s1, 2]]*
             ((CA*MUE + SA*Conjugate[Af[4, j1, j1]])*USf[4, j1][s2, 1] + 
              4*SA*Mass[F[4, {j1}]]*USf[4, j1][s2, 2])) + 
          (dZHiggs1[1, 2]*(Conjugate[USf[4, j1][s1, 1]]*(
                (CAB*CB*(1 + 2*CW^2)*MW*MZ - 6*CA*CW*Mass[F[4, {j1}]]^2)*
                 USf[4, j1][s2, 1] - 3*CW*(CA*Af[4, j1, j1] - 
                  SA*Conjugate[MUE])*Mass[F[4, {j1}]]*USf[4, j1][s2, 2]) + 
              Conjugate[USf[4, j1][s1, 2]]*(3*CW*(MUE*SA - CA*Conjugate[
                    Af[4, j1, j1]])*Mass[F[4, {j1}]]*USf[4, j1][s2, 1] + 
                2*(CAB*CB*MW*MZ*SW^2 - 3*CA*CW*Mass[F[4, {j1}]]^2)*
                 USf[4, j1][s2, 2])) - dZSf1[1, s1, 4, j1]*
             (Conjugate[USf[4, j1][1, 1]]*((CB*(1 + 2*CW^2)*MW*MZ*SAB - 
                  6*CW*SA*Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 1] - 
                3*CW*(SA*Af[4, j1, j1] + CA*Conjugate[MUE])*Mass[F[4, {j1}]]*
                 USf[4, j1][s2, 2]) - Conjugate[USf[4, j1][1, 2]]*(
                3*CW*(CA*MUE + SA*Conjugate[Af[4, j1, j1]])*Mass[F[4, {j1}]]*
                 USf[4, j1][s2, 1] - (2*CB*MW*MZ*SAB*SW^2 - 6*CW*SA*
                   Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 2])) - 
            dZSf1[2, s1, 4, j1]*(Conjugate[USf[4, j1][2, 1]]*(
                (CB*(1 + 2*CW^2)*MW*MZ*SAB - 6*CW*SA*Mass[F[4, {j1}]]^2)*
                 USf[4, j1][s2, 1] - 3*CW*(SA*Af[4, j1, j1] + 
                  CA*Conjugate[MUE])*Mass[F[4, {j1}]]*USf[4, j1][s2, 2]) - 
              Conjugate[USf[4, j1][2, 2]]*(3*CW*(CA*MUE + SA*Conjugate[
                    Af[4, j1, j1]])*Mass[F[4, {j1}]]*USf[4, j1][s2, 1] - 
                (2*CB*MW*MZ*SAB*SW^2 - 6*CW*SA*Mass[F[4, {j1}]]^2)*
                 USf[4, j1][s2, 2])) - (2*dZe1 + dZHiggs1[1, 1])*
             (Conjugate[USf[4, j1][s1, 1]]*((CB*(1 + 2*CW^2)*MW*MZ*SAB - 
                  6*CW*SA*Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 1] - 
                3*CW*(SA*Af[4, j1, j1] + CA*Conjugate[MUE])*Mass[F[4, {j1}]]*
                 USf[4, j1][s2, 2]) - Conjugate[USf[4, j1][s1, 2]]*(
                3*CW*(CA*MUE + SA*Conjugate[Af[4, j1, j1]])*Mass[F[4, {j1}]]*
                 USf[4, j1][s2, 1] - (2*CB*MW*MZ*SAB*SW^2 - 6*CW*SA*
                   Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 2])))/CW)/(CB*MW))/
       SW)}}, C[S[2], S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{((I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s1, 1]]*((CAB*CB*(1 + 2*CW^2)*MW*MZ - 
           6*CA*CW*Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 1] - 
         3*CW*(CA*Af[4, j1, j1] - SA*Conjugate[MUE])*Mass[F[4, {j1}]]*
          USf[4, j1][s2, 2]) + Conjugate[USf[4, j1][s1, 2]]*
        (3*CW*(MUE*SA - CA*Conjugate[Af[4, j1, j1]])*Mass[F[4, {j1}]]*
          USf[4, j1][s2, 1] + 2*(CAB*CB*MW*MZ*SW^2 - 
           3*CA*CW*Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 2])))/(CB*CW*MW*SW), 
    (I/12)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
     (CAB*((2*dSW1*MZ)/CW^3 + dMZsq1/(CW*MZ*SW))*
       ((1 + 2*CW^2)*Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 
        2*SW^2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]) + 
      ((Conjugate[USf[4, j1][s1, 2]]*(dZbarSf1[1, s2, 4, j2]*
             (2*CAB*CB*MW*MZ*SW^2*USf[4, j1][1, 2] + 
              CW*(3*(MUE*SA - CA*Conjugate[Af[4, j1, j1]])*Mass[F[4, {j1}]]*
                 USf[4, j1][1, 1] - 6*CA*Mass[F[4, {j1}]]^2*USf[4, j1][1, 
                  2])) + dZbarSf1[2, s2, 4, j2]*(2*CAB*CB*MW*MZ*SW^2*
               USf[4, j1][2, 2] + CW*(3*(MUE*SA - CA*Conjugate[Af[4, j1, 
                     j1]])*Mass[F[4, {j1}]]*USf[4, j1][2, 1] - 
                6*CA*Mass[F[4, {j1}]]^2*USf[4, j1][2, 2])) + 
            6*CW*(dMUE1*SA - CA*Conjugate[dAf1[4, j1, j1]])*Mass[F[4, {j1}]]*
             USf[4, j1][s2, 1]) + Conjugate[USf[4, j1][s1, 1]]*
           (dZbarSf1[1, s2, 4, j2]*((CAB*CB*(1 + 2*CW^2)*MW*MZ - 
                6*CA*CW*Mass[F[4, {j1}]]^2)*USf[4, j1][1, 1] - 
              3*CW*(CA*Af[4, j1, j1] - SA*Conjugate[MUE])*Mass[F[4, {j1}]]*
               USf[4, j1][1, 2]) + dZbarSf1[2, s2, 4, j2]*
             ((CAB*CB*(1 + 2*CW^2)*MW*MZ - 6*CA*CW*Mass[F[4, {j1}]]^2)*
               USf[4, j1][2, 1] - 3*CW*(CA*Af[4, j1, j1] - SA*Conjugate[MUE])*
               Mass[F[4, {j1}]]*USf[4, j1][2, 2]) + 
            6*CW*(SA*Conjugate[dMUE1] - CA*dAf1[4, j1, j1])*Mass[F[4, {j1}]]*
             USf[4, j1][s2, 2]))/SW - (Conjugate[USf[4, j1][s1, 1]]*
           ((CB*MW*MZ*(2*CAB*(5 - 2*CW^2)*dSW1 + (1 + 2*CW^2)*SAB*SW*
                 dZHiggs1[1, 2]) - 6*CW*(2*CA*dSW1 + SA*SW*dZHiggs1[1, 2])*
               Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 1] + 
            3*CW*(Conjugate[MUE]*(2*dSW1*SA - CA*SW*dZHiggs1[1, 2]) - 
              Af[4, j1, j1]*(2*CA*dSW1 + SA*SW*dZHiggs1[1, 2]))*
             Mass[F[4, {j1}]]*USf[4, j1][s2, 2]) - 
          Conjugate[USf[4, j1][s1, 2]]*(2*CB*MW*MZ*SW^2*(2*CAB*dSW1 - 
              SAB*SW*dZHiggs1[1, 2])*USf[4, j1][s2, 2] - 
            CW*(3*(MUE*(2*dSW1*SA - CA*SW*dZHiggs1[1, 2]) - 
                Conjugate[Af[4, j1, j1]]*(2*CA*dSW1 + SA*SW*dZHiggs1[1, 2]))*
               Mass[F[4, {j1}]]*USf[4, j1][s2, 1] - 6*(2*CA*dSW1 + 
                SA*SW*dZHiggs1[1, 2])*Mass[F[4, {j1}]]^2*USf[4, j1][s2, 2])))/
         SW^2)/(CB*CW*MW) - 
      ((2*CB^4*dTB1*MZ*SAB*((1 + 2*CW^2)*Conjugate[USf[4, j1][s1, 1]]*
            USf[4, j1][s2, 1] + 2*SW^2*Conjugate[USf[4, j1][s1, 2]]*
            USf[4, j1][s2, 2]))/CW - (3*(CB*dMWsq1 + 2*dCB1*MW^2)*
          Mass[F[4, {j1}]]*(Conjugate[USf[4, j1][s1, 1]]*
            (2*CA*Mass[F[4, {j1}]]*USf[4, j1][s2, 1] + 
             (CA*Af[4, j1, j1] - SA*Conjugate[MUE])*USf[4, j1][s2, 2]) - 
           Conjugate[USf[4, j1][s1, 2]]*((MUE*SA - CA*Conjugate[Af[4, j1, 
                  j1]])*USf[4, j1][s2, 1] - 2*CA*Mass[F[4, {j1}]]*
              USf[4, j1][s2, 2])))/MW^3 + 
        (CB*(6*dMf1[4, j1]*(Conjugate[USf[4, j1][s1, 1]]*
              (4*CA*Mass[F[4, {j1}]]*USf[4, j1][s2, 1] + (CA*Af[4, j1, j1] - 
                 SA*Conjugate[MUE])*USf[4, j1][s2, 2]) - 
             Conjugate[USf[4, j1][s1, 2]]*((MUE*SA - CA*Conjugate[Af[4, j1, 
                    j1]])*USf[4, j1][s2, 1] - 4*CA*Mass[F[4, {j1}]]*
                USf[4, j1][s2, 2])) - (dZSf1[1, s1, 4, j1]*
              (Conjugate[USf[4, j1][1, 1]]*((CAB*CB*(1 + 2*CW^2)*MW*MZ - 
                   6*CA*CW*Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 1] - 
                 3*CW*(CA*Af[4, j1, j1] - SA*Conjugate[MUE])*Mass[F[4, {j1}]]*
                  USf[4, j1][s2, 2]) + Conjugate[USf[4, j1][1, 2]]*
                (3*CW*(MUE*SA - CA*Conjugate[Af[4, j1, j1]])*Mass[F[4, {j1}]]*
                  USf[4, j1][s2, 1] + 2*(CAB*CB*MW*MZ*SW^2 - 3*CA*CW*
                    Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 2])) + 
             dZSf1[2, s1, 4, j1]*(Conjugate[USf[4, j1][2, 1]]*
                ((CAB*CB*(1 + 2*CW^2)*MW*MZ - 6*CA*CW*Mass[F[4, {j1}]]^2)*
                  USf[4, j1][s2, 1] - 3*CW*(CA*Af[4, j1, j1] - 
                   SA*Conjugate[MUE])*Mass[F[4, {j1}]]*USf[4, j1][s2, 2]) + 
               Conjugate[USf[4, j1][2, 2]]*(3*CW*(MUE*SA - CA*Conjugate[
                     Af[4, j1, j1]])*Mass[F[4, {j1}]]*USf[4, j1][s2, 1] + 
                 2*(CAB*CB*MW*MZ*SW^2 - 3*CA*CW*Mass[F[4, {j1}]]^2)*
                  USf[4, j1][s2, 2])) + (2*dZe1 + dZHiggs1[2, 2])*
              (Conjugate[USf[4, j1][s1, 1]]*((CAB*CB*(1 + 2*CW^2)*MW*MZ - 
                   6*CA*CW*Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 1] - 
                 3*CW*(CA*Af[4, j1, j1] - SA*Conjugate[MUE])*Mass[F[4, {j1}]]*
                  USf[4, j1][s2, 2]) + Conjugate[USf[4, j1][s1, 2]]*
                (3*CW*(MUE*SA - CA*Conjugate[Af[4, j1, j1]])*Mass[F[4, {j1}]]*
                  USf[4, j1][s2, 1] + 2*(CAB*CB*MW*MZ*SW^2 - 3*CA*CW*
                    Mass[F[4, {j1}]]^2)*USf[4, j1][s2, 2])))/CW))/MW)/
       (CB^2*SW))}}, C[-S[5], S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}]] == 
  {{(I*EL*CKM[j1, j2]*IndexDelta[o1, o2]*(Conjugate[USf[4, j2][s2, 2]]*
        Mass[F[4, {j2}]]*((MUE*S2B + 2*SB^2*Conjugate[Af[4, j2, j2]])*
          USf[3, j1][s1, 1] + 2*Mass[F[3, {j1}]]*USf[3, j1][s1, 2]) - 
       Conjugate[USf[4, j2][s2, 1]]*
        ((MW^2*S2B^2 - 2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2))*
          USf[3, j1][s1, 1] - (2*CB^2*Af[3, j1, j1] + S2B*Conjugate[MUE])*
          Mass[F[3, {j1}]]*USf[3, j1][s1, 2])))/(Sqrt[2]*MW*S2B*SW), 
    ((-I/2)*EL*IndexDelta[o1, o2]*
      ((2*((2*dSW1 - 2*dZe1*SW)*CKM[j1, j2]*(Conjugate[USf[4, j2][s2, 2]]*
             Mass[F[4, {j2}]]*(SB*(CB*MUE + SB*Conjugate[Af[4, j2, j2]])*
               USf[3, j1][s1, 1] + Mass[F[3, {j1}]]*USf[3, j1][s1, 2]) - 
            Conjugate[USf[4, j2][s2, 1]]*(((MW^2*S2B^2)/2 - 
                CB^2*Mass[F[3, {j1}]]^2 - SB^2*Mass[F[4, {j2}]]^2)*USf[3, j1][
                s1, 1] - ((2*CB^2*Af[3, j1, j1] + S2B*Conjugate[MUE])*
                Mass[F[3, {j1}]]*USf[3, j1][s1, 2])/2)) - 
          SW*((2*dCKM1[j1, j2] + CKM[j1, j2]*dZbarHiggs1[5, 5])*
             (Conjugate[USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*(
                SB*(CB*MUE + SB*Conjugate[Af[4, j2, j2]])*USf[3, j1][s1, 1] + 
                Mass[F[3, {j1}]]*USf[3, j1][s1, 2]) - Conjugate[USf[4, j2][
                 s2, 1]]*(((MW^2*S2B^2)/2 - CB^2*Mass[F[3, {j1}]]^2 - 
                  SB^2*Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] - 
                ((2*CB^2*Af[3, j1, j1] + S2B*Conjugate[MUE])*Mass[F[3, {j1}]]*
                  USf[3, j1][s1, 2])/2)) - (dMWsq1*CKM[j1, j2]*
              (Conjugate[USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*
                (SB*(CB*MUE + SB*Conjugate[Af[4, j2, j2]])*USf[3, j1][s1, 
                   1] + Mass[F[3, {j1}]]*USf[3, j1][s1, 2]) + Conjugate[
                 USf[4, j2][s2, 1]]*((CB^2*Mass[F[3, {j1}]]^2 + 
                   SB^2*(2*CB^2*MW^2 + Mass[F[4, {j2}]]^2))*USf[3, j1][s1, 
                   1] + CB*(CB*Af[3, j1, j1] + SB*Conjugate[MUE])*
                  Mass[F[3, {j1}]]*USf[3, j1][s1, 2])))/MW^2)))/S2B + 
       SW*CKM[j1, j2]*(2*((dCB1*(SB*Conjugate[USf[4, j2][s2, 1]]*(CB^2*MW^2 + 
                Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] + Conjugate[
                USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*((CB*MUE + 
                  SB*Conjugate[Af[4, j2, j2]])*USf[3, j1][s1, 1] + 
                SB*Mass[F[3, {j1}]]*USf[3, j1][s1, 2])))/CB^2 + 
           (dSB1*(CB*Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*Mass[
                F[4, {j2}]]*USf[3, j1][s1, 2] + Conjugate[USf[4, j2][s2, 1]]*(
                CB*(MW^2*SB^2 + Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 1] + 
                (CB*Af[3, j1, j1] + SB*Conjugate[MUE])*Mass[F[3, {j1}]]*
                 USf[3, j1][s1, 2])))/SB^2) - 
         ((Conjugate[USf[4, j2][1, 2]]*dZSf1[1, s2, 4, j2] + 
             Conjugate[USf[4, j2][2, 2]]*dZSf1[2, s2, 4, j2])*
            Mass[F[4, {j2}]]*((MUE*S2B + 2*SB^2*Conjugate[Af[4, j2, j2]])*
              USf[3, j1][s1, 1] + 2*Mass[F[3, {j1}]]*USf[3, j1][s1, 2]) - 
           (Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
             Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
            ((MW^2*S2B^2 - 2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^
                   2))*USf[3, j1][s1, 1] - (2*CB^2*Af[3, j1, j1] + S2B*
                Conjugate[MUE])*Mass[F[3, {j1}]]*USf[3, j1][s1, 2]) + 
           2*(dZbarSf1[1, s1, 3, j1]*(Conjugate[USf[4, j2][s2, 2]]*
                Mass[F[4, {j2}]]*(SB*(CB*MUE + SB*Conjugate[Af[4, j2, j2]])*
                  USf[3, j1][1, 1] + Mass[F[3, {j1}]]*USf[3, j1][1, 2]) - 
               Conjugate[USf[4, j2][s2, 1]]*(((MW^2*S2B^2)/2 - CB^2*
                    Mass[F[3, {j1}]]^2 - SB^2*Mass[F[4, {j2}]]^2)*USf[3, j1][
                   1, 1] - CB*(CB*Af[3, j1, j1] + SB*Conjugate[MUE])*
                  Mass[F[3, {j1}]]*USf[3, j1][1, 2])) + 
             dZbarSf1[2, s1, 3, j1]*(Conjugate[USf[4, j2][s2, 2]]*
                Mass[F[4, {j2}]]*(SB*(CB*MUE + SB*Conjugate[Af[4, j2, j2]])*
                  USf[3, j1][2, 1] + Mass[F[3, {j1}]]*USf[3, j1][2, 2]) - 
               Conjugate[USf[4, j2][s2, 1]]*(((MW^2*S2B^2)/2 - CB^2*
                    Mass[F[3, {j1}]]^2 - SB^2*Mass[F[4, {j2}]]^2)*USf[3, j1][
                   2, 1] - CB*(CB*Af[3, j1, j1] + SB*Conjugate[MUE])*
                  Mass[F[3, {j1}]]*USf[3, j1][2, 2])) + 
             Conjugate[USf[4, j2][s2, 1]]*(4*SB^2*dMf1[4, j2]*
                Mass[F[4, {j2}]]*USf[3, j1][s1, 1] + (S2B*Conjugate[dMUE1] + 
                 2*CB^2*dAf1[3, j1, j1])*Mass[F[3, {j1}]]*USf[3, j1][s1, 2] + 
               dMf1[3, j1]*(4*CB^2*Mass[F[3, {j1}]]*USf[3, j1][s1, 1] + 
                 (2*CB^2*Af[3, j1, j1] + S2B*Conjugate[MUE])*USf[3, j1][s1, 
                   2])) + Conjugate[USf[4, j2][s2, 2]]*(Mass[F[4, {j2}]]*
                ((dMUE1*S2B + 2*SB^2*Conjugate[dAf1[4, j2, j2]])*USf[3, j1][
                   s1, 1] + 2*dMf1[3, j1]*USf[3, j1][s1, 2]) + dMf1[4, j2]*
                ((MUE*S2B + 2*SB^2*Conjugate[Af[4, j2, j2]])*USf[3, j1][s1, 
                   1] + 2*Mass[F[3, {j1}]]*USf[3, j1][s1, 2])) + 
             dZHiggs1[5, 6]*(SB*(MUE*SB - CB*Conjugate[Af[4, j2, j2]])*
                Conjugate[USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 
                 1] + CB*Conjugate[USf[4, j2][s2, 1]]*(SB*(C2B*MW^2 + 
                   Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 
                   1] + (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*
                  Mass[F[3, {j1}]]*USf[3, j1][s1, 2]))))/S2B)))/
     (Sqrt[2]*MW*SW^2)}}, C[S[5], S[13, {s1, j1, o1}], 
   -S[14, {s2, j2, o2}]] == 
  {{(I*EL*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
        ((MUE*S2B + 2*CB^2*Conjugate[Af[3, j1, j1]])*USf[4, j2][s2, 1] + 
         2*Mass[F[4, {j2}]]*USf[4, j2][s2, 2]) - Conjugate[USf[3, j1][s1, 1]]*
        ((MW^2*S2B^2 - 2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2))*
          USf[4, j2][s2, 1] - (2*SB^2*Af[4, j2, j2] + S2B*Conjugate[MUE])*
          Mass[F[4, {j2}]]*USf[4, j2][s2, 2])))/(Sqrt[2]*MW*S2B*SW), 
    ((-I/2)*EL*IndexDelta[o1, o2]*(SW*Conjugate[CKM[j1, j2]]*
        ((2*(2*Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
             (CB*dSB1*(MUE*S2B + 2*CB^2*Conjugate[Af[3, j1, j1]])*USf[4, j2][
                s2, 1] + 2*(CB^3*dSB1 + dCB1*SB^3)*Mass[F[4, {j2}]]*
               USf[4, j2][s2, 2]) + Conjugate[USf[3, j1][s1, 1]]*
             ((MW^2*S2B^2*(CB*dSB1 + dCB1*SB) + 4*(CB^3*dSB1*Mass[F[3, {j1}]]^
                    2 + dCB1*SB^3*Mass[F[4, {j2}]]^2))*USf[4, j2][s2, 1] + 
              2*dCB1*SB*(2*SB^2*Af[4, j2, j2] + S2B*Conjugate[MUE])*Mass[
                F[4, {j2}]]*USf[4, j2][s2, 2])))/S2B^2 - 
         (2*(dZbarSf1[1, s2, 4, j2]*(Conjugate[USf[3, j1][s1, 2]]*Mass[
                F[3, {j1}]]*(CB*(MUE*SB + CB*Conjugate[Af[3, j1, j1]])*
                 USf[4, j2][1, 1] + Mass[F[4, {j2}]]*USf[4, j2][1, 2]) + 
              Conjugate[USf[3, j1][s1, 1]]*(CB^2*Mass[F[3, {j1}]]^2*
                 USf[4, j2][1, 1] - SB*((CB*MW^2*S2B - SB*Mass[F[4, {j2}]]^2)*
                   USf[4, j2][1, 1] - (SB*Af[4, j2, j2] + CB*Conjugate[MUE])*
                   Mass[F[4, {j2}]]*USf[4, j2][1, 2]))) + 
            dZbarSf1[2, s2, 4, j2]*(Conjugate[USf[3, j1][s1, 2]]*Mass[
                F[3, {j1}]]*(CB*(MUE*SB + CB*Conjugate[Af[3, j1, j1]])*
                 USf[4, j2][2, 1] + Mass[F[4, {j2}]]*USf[4, j2][2, 2]) + 
              Conjugate[USf[3, j1][s1, 1]]*(CB^2*Mass[F[3, {j1}]]^2*
                 USf[4, j2][2, 1] - SB*((CB*MW^2*S2B - SB*Mass[F[4, {j2}]]^2)*
                   USf[4, j2][2, 1] - (SB*Af[4, j2, j2] + CB*Conjugate[MUE])*
                   Mass[F[4, {j2}]]*USf[4, j2][2, 2]))) + 
            Conjugate[USf[3, j1][s1, 1]]*(4*CB^2*dMf1[3, j1]*Mass[F[3, {j1}]]*
               USf[4, j2][s2, 1] + (S2B*Conjugate[dMUE1] + 2*SB^2*
                 dAf1[4, j2, j2])*Mass[F[4, {j2}]]*USf[4, j2][s2, 2] + 
              dMf1[4, j2]*(4*SB^2*Mass[F[4, {j2}]]*USf[4, j2][s2, 1] + 
                (2*SB^2*Af[4, j2, j2] + S2B*Conjugate[MUE])*USf[4, j2][s2, 
                  2])) + Conjugate[USf[3, j1][s1, 2]]*
             (Mass[F[3, {j1}]]*((dMUE1*S2B + 2*CB^2*Conjugate[dAf1[3, j1, 
                     j1]])*USf[4, j2][s2, 1] + 2*dMf1[4, j2]*USf[4, j2][s2, 
                  2]) + dMf1[3, j1]*((MUE*S2B + 2*CB^2*Conjugate[Af[3, j1, 
                     j1]])*USf[4, j2][s2, 1] + 2*Mass[F[4, {j2}]]*
                 USf[4, j2][s2, 2]))))/S2B) - 
       (2*(Conjugate[CKM[j1, j2]]*((SW*((Conjugate[USf[3, j1][1, 2]]*
                  dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 2]]*
                  dZSf1[2, s1, 3, j1])*Mass[F[3, {j1}]]*
                ((MUE*S2B + 2*CB^2*Conjugate[Af[3, j1, j1]])*USf[4, j2][s2, 
                   1] + 2*Mass[F[4, {j2}]]*USf[4, j2][s2, 2]) - 
               (Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
                 Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
                ((MW^2*S2B^2 - 2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*
                      Mass[F[4, {j2}]]^2))*USf[4, j2][s2, 1] - 
                 (2*SB^2*Af[4, j2, j2] + S2B*Conjugate[MUE])*Mass[F[4, {j2}]]*
                  USf[4, j2][s2, 2])))/2 - (2*dSW1 - 2*dZe1*SW)*
             (Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*(
                CB*(MUE*SB + CB*Conjugate[Af[3, j1, j1]])*USf[4, j2][s2, 1] + 
                Mass[F[4, {j2}]]*USf[4, j2][s2, 2]) - Conjugate[USf[3, j1][
                 s1, 1]]*(((MW^2*S2B^2)/2 - CB^2*Mass[F[3, {j1}]]^2 - 
                  SB^2*Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1] - 
                ((2*SB^2*Af[4, j2, j2] + S2B*Conjugate[MUE])*Mass[F[4, {j2}]]*
                  USf[4, j2][s2, 2])/2))) + 
          SW*((2*Conjugate[dCKM1[j1, j2]] + Conjugate[CKM[j1, j2]]*dZHiggs1[
                5, 5])*(Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*(
                CB*(MUE*SB + CB*Conjugate[Af[3, j1, j1]])*USf[4, j2][s2, 1] + 
                Mass[F[4, {j2}]]*USf[4, j2][s2, 2]) - Conjugate[USf[3, j1][
                 s1, 1]]*(((MW^2*S2B^2)/2 - CB^2*Mass[F[3, {j1}]]^2 - 
                  SB^2*Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1] - 
                ((2*SB^2*Af[4, j2, j2] + S2B*Conjugate[MUE])*Mass[F[4, {j2}]]*
                  USf[4, j2][s2, 2])/2)) - (Conjugate[CKM[j1, j2]]*
              (Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
                ((MUE*(dMWsq1*S2B + 2*CB^2*MW^2*dZHiggs1[6, 5]) + 
                   Conjugate[Af[3, j1, j1]]*(2*CB^2*dMWsq1 - MW^2*S2B*
                      dZHiggs1[6, 5]))*USf[4, j2][s2, 1] + 2*dMWsq1*
                  Mass[F[4, {j2}]]*USf[4, j2][s2, 2]) - Conjugate[
                 USf[3, j1][s1, 1]]*((MW^2*S2B*dZHiggs1[6, 5]*(C2B*MW^2 + 
                     Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2) - dMWsq1*
                    (MW^2*S2B^2 + 2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*
                        Mass[F[4, {j2}]]^2)))*USf[4, j2][s2, 1] - 
                 (Af[4, j2, j2]*(2*dMWsq1*SB^2 + MW^2*S2B*dZHiggs1[6, 5]) + 
                   Conjugate[MUE]*(dMWsq1*S2B - 2*MW^2*SB^2*dZHiggs1[6, 5]))*
                  Mass[F[4, {j2}]]*USf[4, j2][s2, 2])))/(2*MW^2))))/S2B))/
     (Sqrt[2]*MW*SW^2)}}, C[-S[5], S[12, {s2, j2}], -S[11, {j1}]] == 
  {{(I*EL*IndexDelta[j1, j2]*((CB*MUE + SB*Conjugate[Af[2, j1, j1]])*
        Conjugate[USf[2, j1][s2, 2]]*Mass[F[2, {j1}]] - 
       Conjugate[USf[2, j1][s2, 1]]*(CB*MW^2*S2B - SB*Mass[F[2, {j1}]]^2)))/
     (Sqrt[2]*CB*MW*SW), ((I/2)*EL*IndexDelta[j1, j2]*
      (Conjugate[USf[2, j1][s2, 2]]*(2*CB*MW^2*SW*(CB*MUE + 
           SB*Conjugate[Af[2, j1, j1]])*dMf1[2, j1] - 
         (Conjugate[Af[2, j1, j1]]*((S2B*(2*dSW1*MW^2 + SW*(dMWsq1 - 
                  MW^2*(2*dZe1 + dZbarHiggs1[5, 5] + dZbarSf1[1, 1, 1, 
                     j1]))))/2 + MW^2*SW*(2*dCB1*SB + CB^2*dZHiggs1[5, 6])) - 
           CB*(CB*(2*dMUE1*MW^2*SW - MUE*(2*dSW1*MW^2 + dMWsq1*SW)) + 
             MW^2*SW*(2*SB*Conjugate[dAf1[2, j1, j1]] - MUE*(2*dCB1 - 
                 CB*(2*dZe1 + dZbarHiggs1[5, 5] + dZbarSf1[1, 1, 1, j1]) - 
                 SB*dZHiggs1[5, 6]))))*Mass[F[2, {j1}]]) + 
       CB*MW^2*SW*((CB*MUE + SB*Conjugate[Af[2, j1, j1]])*
          (Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s2, 2, j2])*
          Mass[F[2, {j1}]] - (Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, 
             j2] + Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
          (CB*MW^2*S2B - SB*Mass[F[2, {j1}]]^2)) - 
       Conjugate[USf[2, j1][s2, 1]]*(2*CB^3*(dMWsq1*MW^2*SB*SW - 
           MW^4*(2*dSW1*SB - dSB1*SW)) - MW^2*S2B*Mass[F[2, {j1}]]*
          (2*SW*dMf1[2, j1] - dSW1*Mass[F[2, {j1}]]) + 
         SW*(CB*MW^4*(S2B*(dCB1 + CB*(2*dZe1 + dZbarHiggs1[5, 5])) - 
             C2B*CB*dZHiggs1[5, 6]) + ((dMWsq1*S2B + MW^2*(4*dCB1*SB - 
                 S2B*(2*dZe1 + dZbarHiggs1[5, 5]) + 2*CB^2*dZHiggs1[5, 6]))*
              Mass[F[2, {j1}]]^2 + MW^2*S2B*dZbarSf1[1, 1, 1, j1]*
              (2*CB^2*MW^2 - Mass[F[2, {j1}]]^2))/2))))/
     (Sqrt[2]*CB^2*MW^3*SW^2)}}, C[S[5], S[11, {j1}], -S[12, {s2, j2}]] == 
  {{((-I)*EL*IndexDelta[j1, j2]*((CB*MW^2*S2B - SB*Mass[F[2, {j1}]]^2)*
        USf[2, j1][s2, 1] - (SB*Af[2, j1, j1] + CB*Conjugate[MUE])*
        Mass[F[2, {j1}]]*USf[2, j1][s2, 2]))/(Sqrt[2]*CB*MW*SW), 
    ((-I/2)*EL*IndexDelta[j1, j2]*
      ((2*CB^3*(dMWsq1*MW^2*SB*SW - MW^4*(2*dSW1*SB - dSB1*SW)) - 
         (MW^4*SW*((4*CB^4 - S2B^2)*dZHiggs1[6, 5] - 
            4*S2B*(CB*dCB1 + CB^2*(2*dZe1 + dZHiggs1[5, 5] + dZSf1[1, 1, 1, 
                 j1]))))/4 - MW^2*S2B*Mass[F[2, {j1}]]*(2*SW*dMf1[2, j1] - 
           dSW1*Mass[F[2, {j1}]]))*USf[2, j1][s2, 1] + 
       (((CB*dMWsq1 + 2*dCB1*MW^2)*SB*SW + MW^2*S2B*(dSW1 - dZe1*SW))*
          Af[2, j1, j1] + CB^2*(dMWsq1*SW*Conjugate[MUE] - 
           MW^2*(2*SW*Conjugate[dMUE1] - 2*dSW1*Conjugate[MUE])) - 
         (MW^2*SW*(2*S2B*dAf1[2, j1, j1] - Af[2, j1, j1]*
             (2*CB^2*dZHiggs1[6, 5] - S2B*(dZHiggs1[5, 5] + dZSf1[1, 1, 1, 
                 j1])) - Conjugate[MUE]*(4*CB*dCB1 - S2B*dZHiggs1[6, 5] - 
              2*CB^2*(2*dZe1 + dZHiggs1[5, 5] + dZSf1[1, 1, 1, j1]))))/2)*
        Mass[F[2, {j1}]]*USf[2, j1][s2, 2] + 
       SW*(((MW^2*(4*dCB1*SB - S2B*(2*dZe1 + dZHiggs1[5, 5]) + 
              2*CB^2*dZHiggs1[6, 5]) + S2B*(dMWsq1 - MW^2*dZSf1[1, 1, 1, 
                j1]))*Mass[F[2, {j1}]]^2*USf[2, j1][s2, 1])/2 + 
         MW^2*(CB*(dZbarSf1[1, s2, 2, j2]*((CB*MW^2*S2B - SB*Mass[F[2, {j1}]]^
                   2)*USf[2, j1][1, 1] - (SB*Af[2, j1, j1] + 
                 CB*Conjugate[MUE])*Mass[F[2, {j1}]]*USf[2, j1][1, 2]) + 
             dZbarSf1[2, s2, 2, j2]*((CB*MW^2*S2B - SB*Mass[F[2, {j1}]]^2)*
                USf[2, j1][2, 1] - (SB*Af[2, j1, j1] + CB*Conjugate[MUE])*
                Mass[F[2, {j1}]]*USf[2, j1][2, 2])) - 
           (S2B*Af[2, j1, j1] + 2*CB^2*Conjugate[MUE])*dMf1[2, j1]*
            USf[2, j1][s2, 2]))))/(Sqrt[2]*CB^2*MW^3*SW^2)}}, 
 C[-S[6], S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}]] == 
  {{(I*EL*CKM[j1, j2]*IndexDelta[o1, o2]*
      ((2*MUE*SB^2 - S2B*Conjugate[Af[4, j2, j2]])*
        Conjugate[USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 1] + 
       Conjugate[USf[4, j2][s2, 1]]*(S2B*(C2B*MW^2 + Mass[F[3, {j1}]]^2 - 
           Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] + 
         (S2B*Af[3, j1, j1] - 2*CB^2*Conjugate[MUE])*Mass[F[3, {j1}]]*
          USf[3, j1][s1, 2])))/(Sqrt[2]*MW*S2B*SW), 
    ((I/2)*EL*IndexDelta[o1, o2]*
      (SW*CKM[j1, j2]*(dZbarSf1[1, s1, 3, j1]*
          (((MUE*SB - CB*Conjugate[Af[4, j2, j2]])*Conjugate[
              USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*USf[3, j1][1, 1])/CB + 
           Conjugate[USf[4, j2][s2, 1]]*((C2B*MW^2 + Mass[F[3, {j1}]]^2 - 
               Mass[F[4, {j2}]]^2)*USf[3, j1][1, 1] + 
             ((SB*Af[3, j1, j1] - CB*Conjugate[MUE])*Mass[F[3, {j1}]]*
               USf[3, j1][1, 2])/SB)) + dZbarSf1[2, s1, 3, j1]*
          (((MUE*SB - CB*Conjugate[Af[4, j2, j2]])*Conjugate[
              USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*USf[3, j1][2, 1])/CB + 
           Conjugate[USf[4, j2][s2, 1]]*((C2B*MW^2 + Mass[F[3, {j1}]]^2 - 
               Mass[F[4, {j2}]]^2)*USf[3, j1][2, 1] + 
             ((SB*Af[3, j1, j1] - CB*Conjugate[MUE])*Mass[F[3, {j1}]]*
               USf[3, j1][2, 2])/SB)) + 
         (2*dCB1*(CB*Conjugate[USf[4, j2][s2, 1]]*(CB^2*MW^2 + 
              Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] - 
            Conjugate[USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*
             ((MUE*SB - CB*Conjugate[Af[4, j2, j2]])*USf[3, j1][s1, 1] - 
              CB*Mass[F[3, {j1}]]*USf[3, j1][s1, 2])))/CB^2 - 
         (2*dSB1*(SB*Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*
             Mass[F[4, {j2}]]*USf[3, j1][s1, 2] + 
            Conjugate[USf[4, j2][s2, 1]]*(SB*(MW^2*SB^2 + Mass[F[3, {j1}]]^2)*
               USf[3, j1][s1, 1] + (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*
               Mass[F[3, {j1}]]*USf[3, j1][s1, 2])))/SB^2 + 
         ((2*MUE*SB^2 - S2B*Conjugate[Af[4, j2, j2]])*
            (Conjugate[USf[4, j2][1, 2]]*dZSf1[1, s2, 4, j2] + 
             Conjugate[USf[4, j2][2, 2]]*dZSf1[2, s2, 4, j2])*
            Mass[F[4, {j2}]]*USf[3, j1][s1, 1] + 
           (Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
             Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
            (S2B*(C2B*MW^2 + Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*
              USf[3, j1][s1, 1] + (S2B*Af[3, j1, j1] - 2*CB^2*Conjugate[MUE])*
              Mass[F[3, {j1}]]*USf[3, j1][s1, 2]))/S2B - 
         2*(((2*CB*Conjugate[USf[4, j2][s2, 1]]*dMf1[4, j2]*Mass[
                F[4, {j2}]] - Conjugate[USf[4, j2][s2, 2]]*(
                (MUE*SB - CB*Conjugate[Af[4, j2, j2]])*dMf1[4, j2] + 
                (dMUE1*SB - CB*Conjugate[dAf1[4, j2, j2]])*Mass[F[4, {j2}]]))*
             USf[3, j1][s1, 1])/CB + (Conjugate[USf[4, j2][s2, 1]]*
             ((CB*Conjugate[dMUE1] - SB*dAf1[3, j1, j1])*Mass[F[3, {j1}]]*
               USf[3, j1][s1, 2] - dMf1[3, j1]*(2*SB*Mass[F[3, {j1}]]*
                 USf[3, j1][s1, 1] + (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*
                 USf[3, j1][s1, 2])))/SB)) - 
       (2*((2*dSW1 - 2*dZe1*SW)*CKM[j1, j2]*
           (SB*(MUE*SB - CB*Conjugate[Af[4, j2, j2]])*Conjugate[
              USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 1] + 
            CB*Conjugate[USf[4, j2][s2, 1]]*(SB*(C2B*MW^2 + Mass[F[3, {j1}]]^
                 2 - Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] + 
              (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*Mass[F[3, {j1}]]*
               USf[3, j1][s1, 2])) - 
          SW*((2*dCKM1[j1, j2] + CKM[j1, j2]*dZHiggs1[6, 6])*
             (SB*(MUE*SB - CB*Conjugate[Af[4, j2, j2]])*Conjugate[
                USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 1] + 
              CB*Conjugate[USf[4, j2][s2, 1]]*(SB*(C2B*MW^2 + 
                  Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 
                  1] + (SB*Af[3, j1, j1] - CB*Conjugate[MUE])*
                 Mass[F[3, {j1}]]*USf[3, j1][s1, 2])) - 
            (CKM[j1, j2]*(Conjugate[USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*
                ((MUE*(2*dMWsq1*SB^2 - MW^2*S2B*dZHiggs1[6, 5]) - 
                   Conjugate[Af[4, j2, j2]]*(dMWsq1*S2B + 2*MW^2*SB^2*
                      dZHiggs1[6, 5]))*USf[3, j1][s1, 1] - 2*MW^2*dZHiggs1[6, 
                   5]*Mass[F[3, {j1}]]*USf[3, j1][s1, 2]) - Conjugate[
                 USf[4, j2][s2, 1]]*((MW^2*S2B*(C2B*dMWsq1 - MW^2*S2B*
                      dZHiggs1[6, 5]) - (dMWsq1*S2B - 2*CB^2*MW^2*dZHiggs1[6, 
                       5])*Mass[F[3, {j1}]]^2 + (dMWsq1*S2B + 2*MW^2*SB^2*
                      dZHiggs1[6, 5])*Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] - 
                 (Af[3, j1, j1]*(dMWsq1*S2B - 2*CB^2*MW^2*dZHiggs1[6, 5]) - 
                   Conjugate[MUE]*(2*CB^2*dMWsq1 + MW^2*S2B*dZHiggs1[6, 5]))*
                  Mass[F[3, {j1}]]*USf[3, j1][s1, 2])))/(2*MW^2))))/S2B))/
     (Sqrt[2]*MW*SW^2)}}, C[S[6], S[13, {s1, j1, o1}], 
   -S[14, {s2, j2, o2}]] == 
  {{((-I)*EL*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      ((2*CB^2*MUE - S2B*Conjugate[Af[3, j1, j1]])*
        Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*USf[4, j2][s2, 1] - 
       Conjugate[USf[3, j1][s1, 1]]*(S2B*(C2B*MW^2 + Mass[F[3, {j1}]]^2 - 
           Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1] - 
         (S2B*Af[4, j2, j2] - 2*SB^2*Conjugate[MUE])*Mass[F[4, {j2}]]*
          USf[4, j2][s2, 2])))/(Sqrt[2]*MW*S2B*SW), 
    ((-I/2)*EL*IndexDelta[o1, o2]*
      (((2*SW*Conjugate[dCKM1[j1, j2]] - Conjugate[CKM[j1, j2]]*
           (2*dSW1 - SW*(2*dZe1 + dZHiggs1[6, 6])))*
         ((2*CB^2*MUE - S2B*Conjugate[Af[3, j1, j1]])*
           Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*USf[4, j2][s2, 1] - 
          Conjugate[USf[3, j1][s1, 1]]*(S2B*(C2B*MW^2 + Mass[F[3, {j1}]]^2 - 
              Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1] - 
            (S2B*Af[4, j2, j2] - 2*SB^2*Conjugate[MUE])*Mass[F[4, {j2}]]*
             USf[4, j2][s2, 2])))/S2B + SW*Conjugate[CKM[j1, j2]]*
        (dZbarSf1[1, s2, 4, j2]*(((CB*MUE - SB*Conjugate[Af[3, j1, j1]])*
             Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*USf[4, j2][1, 1])/
            SB - Conjugate[USf[3, j1][s1, 1]]*((C2B*MW^2 + Mass[F[3, {j1}]]^
                2 - Mass[F[4, {j2}]]^2)*USf[4, j2][1, 1] - 
             ((CB*Af[4, j2, j2] - SB*Conjugate[MUE])*Mass[F[4, {j2}]]*
               USf[4, j2][1, 2])/CB)) + dZbarSf1[2, s2, 4, j2]*
          (((CB*MUE - SB*Conjugate[Af[3, j1, j1]])*Conjugate[
              USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*USf[4, j2][2, 1])/SB - 
           Conjugate[USf[3, j1][s1, 1]]*((C2B*MW^2 + Mass[F[3, {j1}]]^2 - 
               Mass[F[4, {j2}]]^2)*USf[4, j2][2, 1] - 
             ((CB*Af[4, j2, j2] - SB*Conjugate[MUE])*Mass[F[4, {j2}]]*
               USf[4, j2][2, 2])/CB)) - (2*Conjugate[USf[3, j1][s1, 1]]*
           ((SB*Conjugate[dMUE1] - CB*dAf1[4, j2, j2])*Mass[F[4, {j2}]]*
             USf[4, j2][s2, 2] - dMf1[4, j2]*(2*CB*Mass[F[4, {j2}]]*
               USf[4, j2][s2, 1] + (CB*Af[4, j2, j2] - SB*Conjugate[MUE])*
               USf[4, j2][s2, 2])))/CB + 
         (2*dSB1*(SB*Conjugate[USf[3, j1][s1, 1]]*(MW^2*SB^2 + 
              Mass[F[3, {j1}]]^2)*USf[4, j2][s2, 1] - 
            Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
             ((CB*MUE - SB*Conjugate[Af[3, j1, j1]])*USf[4, j2][s2, 1] - 
              SB*Mass[F[4, {j2}]]*USf[4, j2][s2, 2])))/SB^2 - 
         (dZHiggs1[5, 6]*(Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
             ((MUE*S2B + 2*CB^2*Conjugate[Af[3, j1, j1]])*USf[4, j2][s2, 1] + 
              2*Mass[F[4, {j2}]]*USf[4, j2][s2, 2]) - 
            Conjugate[USf[3, j1][s1, 1]]*((MW^2*S2B^2 - 
                2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2))*
               USf[4, j2][s2, 1] - (2*SB^2*Af[4, j2, j2] + S2B*Conjugate[
                  MUE])*Mass[F[4, {j2}]]*USf[4, j2][s2, 2])))/S2B - 
         (2*dCB1*(CB*Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
             Mass[F[4, {j2}]]*USf[4, j2][s2, 2] + 
            Conjugate[USf[3, j1][s1, 1]]*(CB*(CB^2*MW^2 + Mass[F[4, {j2}]]^2)*
               USf[4, j2][s2, 1] + (CB*Af[4, j2, j2] - SB*Conjugate[MUE])*
               Mass[F[4, {j2}]]*USf[4, j2][s2, 2])))/CB^2 - 
         (2*(2*SB*Conjugate[USf[3, j1][s1, 1]]*dMf1[3, j1]*Mass[F[3, {j1}]] - 
             Conjugate[USf[3, j1][s1, 2]]*((CB*MUE - SB*Conjugate[Af[3, j1, 
                    j1]])*dMf1[3, j1] + (CB*dMUE1 - SB*Conjugate[dAf1[3, j1, 
                    j1]])*Mass[F[3, {j1}]]))*USf[4, j2][s2, 1] + 
           (-(dZSf1[1, s1, 3, j1]*(CB*(CB*MUE - SB*Conjugate[Af[3, j1, j1]])*
                 Conjugate[USf[3, j1][1, 2]]*Mass[F[3, {j1}]]*USf[4, j2][s2, 
                  1] - SB*Conjugate[USf[3, j1][1, 1]]*(CB*(C2B*MW^2 + 
                    Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 
                    1] - (CB*Af[4, j2, j2] - SB*Conjugate[MUE])*
                   Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))) - 
             dZSf1[2, s1, 3, j1]*(CB*(CB*MUE - SB*Conjugate[Af[3, j1, j1]])*
                Conjugate[USf[3, j1][2, 2]]*Mass[F[3, {j1}]]*USf[4, j2][s2, 
                 1] - SB*Conjugate[USf[3, j1][2, 1]]*(CB*(C2B*MW^2 + 
                   Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 
                   1] - (CB*Af[4, j2, j2] - SB*Conjugate[MUE])*
                  Mass[F[4, {j2}]]*USf[4, j2][s2, 2])) + 
             (dMWsq1*(CB*(CB*MUE - SB*Conjugate[Af[3, j1, j1]])*Conjugate[
                  USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*USf[4, j2][s2, 1] + 
                SB*Conjugate[USf[3, j1][s1, 1]]*(CB*(C2B*MW^2 - 
                    Mass[F[3, {j1}]]^2 + Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 
                    1] + (CB*Af[4, j2, j2] - SB*Conjugate[MUE])*
                   Mass[F[4, {j2}]]*USf[4, j2][s2, 2])))/MW^2)/CB)/SB)))/
     (Sqrt[2]*MW*SW^2)}}, C[-S[6], S[12, {s2, j2}], -S[11, {j1}]] == 
  {{(I*EL*IndexDelta[j1, j2]*((MUE*SB - CB*Conjugate[Af[2, j1, j1]])*
        Conjugate[USf[2, j1][s2, 2]]*Mass[F[2, {j1}]] + 
       CB*Conjugate[USf[2, j1][s2, 1]]*(C2B*MW^2 - Mass[F[2, {j1}]]^2)))/
     (Sqrt[2]*CB*MW*SW), ((I/2)*EL*IndexDelta[j1, j2]*
      (Conjugate[USf[2, j1][s2, 2]]*
        (MW^2*SW*(MUE*S2B - 2*CB^2*Conjugate[Af[2, j1, j1]])*dMf1[2, j1] - 
         (MW^2*S2B*(dSW1*MUE - (dMUE1 + dZe1*MUE)*SW) + 
           SW*(MUE*(CB*dMWsq1 + 2*dCB1*MW^2)*SB + 
             (MW^2*(CB^2*(4*Conjugate[dAf1[2, j1, j1]] - 2*MUE*dZHiggs1[6, 
                    5]) - MUE*S2B*(dZbarSf1[1, 1, 1, j1] + dZHiggs1[6, 6])))/
              2) - CB*Conjugate[Af[2, j1, j1]]*
            (MW^2*SW*(2*dCB1 - CB*dZbarSf1[1, 1, 1, j1] + SB*dZHiggs1[6, 
                 5]) + CB*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + 
                   dZHiggs1[6, 6])))))*Mass[F[2, {j1}]]) + 
       CB*(MW^2*SW*((MUE*SB - CB*Conjugate[Af[2, j1, j1]])*
            (Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s2, 2, j2] + 
             Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s2, 2, j2])*
            Mass[F[2, {j1}]] + CB*(Conjugate[USf[2, j1][1, 1]]*
              dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 1]]*
              dZSf1[2, s2, 2, j2])*(C2B*MW^2 - Mass[F[2, {j1}]]^2)) - 
         Conjugate[USf[2, j1][s2, 1]]*(dSW1*MW^4*(2*CB^3 - S2B*SB) - 
           CB*(2*dSW1*MW^2 + dMWsq1*SW)*Mass[F[2, {j1}]]^2 - 
           MW^2*SW*((2*dCB1 + SB*dZHiggs1[6, 5] - CB*(2*dZe1 + dZHiggs1[6, 
                  6]))*Mass[F[2, {j1}]]^2 + ((dMWsq1 + 2*dZe1*MW^2)*
                (2*CB^3 - S2B*SB) + MW^2*(4*CB^2*dCB1 - 2*(dSB1*S2B + 
                   CB*(S2B*dZHiggs1[6, 5] - C2B*dZHiggs1[6, 6]))) - 8*CB*
                dMf1[2, j1]*Mass[F[2, {j1}]])/2 + CB*dZbarSf1[1, 1, 1, j1]*
              (C2B*MW^2 - Mass[F[2, {j1}]]^2))))))/
     (Sqrt[2]*CB^2*MW^3*SW^2)}}, C[S[6], S[11, {j1}], -S[12, {s2, j2}]] == 
  {{(I*EL*IndexDelta[j1, j2]*(CB*(C2B*MW^2 - Mass[F[2, {j1}]]^2)*
        USf[2, j1][s2, 1] - (CB*Af[2, j1, j1] - SB*Conjugate[MUE])*
        Mass[F[2, {j1}]]*USf[2, j1][s2, 2]))/(Sqrt[2]*CB*MW*SW), 
    ((-I/2)*EL*IndexDelta[j1, j2]*(((dSW1*MW^4*(4*CB^4 - S2B^2))/2 - 
         CB^2*(2*dSW1*MW^2 + dMWsq1*SW)*Mass[F[2, {j1}]]^2 - 
         (MW^2*SW*(MW^2*(8*CB^3*dCB1 - 4*S2B*(CB*dSB1 + CB^2*dZHiggs1[5, 
                  6])) + (4*CB^4 - S2B^2)*(dMWsq1 + MW^2*(2*dZe1 + 
                dZHiggs1[6, 6] + dZSf1[1, 1, 1, j1])) - 16*CB^2*dMf1[2, j1]*
             Mass[F[2, {j1}]]))/4)*USf[2, j1][s2, 1] + 
       (((CB*dMWsq1 + 2*dCB1*MW^2)*SB*SW + MW^2*S2B*(dSW1 - dZe1*SW))*
          Conjugate[MUE] - SW*(MW^2*S2B*Conjugate[dMUE1] + 
           CB*((2*dCB1*MW^2 + CB*(dMWsq1 - 2*dZe1*MW^2))*Af[2, j1, j1] - 
             MW^2*(2*CB*dAf1[2, j1, j1] - (SB*Af[2, j1, j1] + 
                 CB*Conjugate[MUE])*dZHiggs1[5, 6] + (CB*Af[2, j1, j1] - 
                 SB*Conjugate[MUE])*(dZHiggs1[6, 6] + dZSf1[1, 1, 1, j1])))))*
        Mass[F[2, {j1}]]*USf[2, j1][s2, 2] - 
       MW^2*(2*CB^2*dSW1*Af[2, j1, j1]*Mass[F[2, {j1}]]*USf[2, j1][s2, 2] + 
         SW*(CB*(dZbarSf1[1, s2, 2, j2]*(CB*(C2B*MW^2 - Mass[F[2, {j1}]]^2)*
                USf[2, j1][1, 1] - (CB*Af[2, j1, j1] - SB*Conjugate[MUE])*
                Mass[F[2, {j1}]]*USf[2, j1][1, 2]) + dZbarSf1[2, s2, 2, j2]*
              (CB*(C2B*MW^2 - Mass[F[2, {j1}]]^2)*USf[2, j1][2, 1] - 
               (CB*Af[2, j1, j1] - SB*Conjugate[MUE])*Mass[F[2, {j1}]]*
                USf[2, j1][2, 2]) + (2*dCB1 + SB*dZHiggs1[5, 6] - CB*
                (2*dZe1 + dZHiggs1[6, 6] + dZSf1[1, 1, 1, j1]))*
              Mass[F[2, {j1}]]^2*USf[2, j1][s2, 1]) - 
           (2*CB^2*Af[2, j1, j1] - S2B*Conjugate[MUE])*dMf1[2, j1]*
            USf[2, j1][s2, 2]))))/(Sqrt[2]*CB^2*MW^3*SW^2)}}, 
 C[S[11, {j1}], -S[11, {j2}], V[2]] == 
  {{((-I/2)*EL*IndexDelta[j1, j2])/(CW*SW), 
    ((-I/4)*EL*(2*dSW1*SW^2 - CW^2*(2*dSW1 - SW*(2*dZe1 + dZZZ1 + 
           dZbarSf1[1, 1, 1, j2] + dZSf1[1, 1, 1, j1])))*IndexDelta[j1, j2])/
     (CW^3*SW^2)}}, C[S[12, {s1, j1}], -S[12, {s2, j2}], V[1]] == 
  {{I*EL*IndexDelta[j1, j2]*IndexDelta[s1, s2], 
    ((I/4)*EL*IndexDelta[j1, j2]*
      (2*CW*SW*(dZbarSf1[1, s2, 2, j2]*IndexDelta[1, s1] + 
         dZSf1[1, s1, 2, j1]*IndexDelta[1, s2] + dZbarSf1[2, s2, 2, j2]*
          IndexDelta[2, s1] + dZSf1[2, s1, 2, j1]*IndexDelta[2, s2] + 
         (dZAA1 + 2*dZe1)*IndexDelta[s1, s2]) + 
       dZZA1*((1 - 2*SW^2)*Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][s2, 1] - 
         2*SW^2*Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 2])))/(CW*SW)}}, 
 C[S[12, {s1, j1}], -S[12, {s2, j2}], V[2]] == 
  {{((-I/2)*EL*IndexDelta[j1, j2]*((1 - 2*CW^2)*Conjugate[USf[2, j1][s1, 1]]*
        USf[2, j1][s2, 1] + 2*SW^2*Conjugate[USf[2, j1][s1, 2]]*
        USf[2, j1][s2, 2]))/(CW*SW), ((I/4)*EL*IndexDelta[j1, j2]*
      (2*CW^3*dZAZ1*SW^2*IndexDelta[s1, s2] - Conjugate[USf[2, j1][s1, 1]]*
        (CW^2*(1 - 2*CW^2)*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
           dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) + 
         (CW^2*((6 - 4*CW^2)*dSW1 + (1 - 2*CW^2)*(2*dZe1 + dZZZ1)*SW) - 
           dSW1*(2*SW^2 - 4*SW^4))*USf[2, j1][s2, 1]) - 
       SW*(2*SW*Conjugate[USf[2, j1][s1, 2]]*
          (CW^2*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 2] + 
             dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 2]) + 
           (2*dSW1*SW^2 + CW^2*(2*dSW1 + (2*dZe1 + dZZZ1)*SW))*
            USf[2, j1][s2, 2]) + CW^2*((1 - 2*CW^2)*
            (Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s1, 2, j1] + 
             Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*
            USf[2, j1][s2, 1] + 2*SW^2*(Conjugate[USf[2, j1][1, 2]]*
              dZSf1[1, s1, 2, j1] + Conjugate[USf[2, j1][2, 2]]*
              dZSf1[2, s1, 2, j1])*USf[2, j1][s2, 2]))))/(CW^3*SW^2)}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], V[1]] == 
  {{((-2*I)/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*IndexDelta[s1, s2], 
    ((-I/12)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (4*CW*SW*(dZbarSf1[1, s2, 3, j2]*IndexDelta[1, s1] + 
         dZSf1[1, s1, 3, j1]*IndexDelta[1, s2] + dZbarSf1[2, s2, 3, j2]*
          IndexDelta[2, s1] + dZSf1[2, s1, 3, j1]*IndexDelta[2, s2] + 
         (dZAA1 + 2*dZe1)*IndexDelta[s1, s2]) + 
       dZZA1*((3 - 4*SW^2)*Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 1] - 
         4*SW^2*Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 2])))/(CW*SW)}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], V[2]] == 
  {{((I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      ((1 - 4*CW^2)*Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 1] + 
       4*SW^2*Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 2]))/(CW*SW), 
    ((-I/12)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (4*CW^3*dZAZ1*SW^2*IndexDelta[s1, s2] - Conjugate[USf[3, j1][s1, 1]]*
        (CW^2*(1 - 4*CW^2)*SW*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 1] + 
           dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 1]) + 
         (2*(1 - 4*CW^2)*dSW1*SW^2 + CW^2*((14 - 8*CW^2)*dSW1 + 
             (1 - 4*CW^2)*(2*dZe1 + dZZZ1)*SW))*USf[3, j1][s2, 1]) - 
       SW*(4*SW*Conjugate[USf[3, j1][s1, 2]]*
          (CW^2*SW*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 2] + 
             dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 2]) + 
           (2*dSW1*SW^2 + CW^2*(2*dSW1 + (2*dZe1 + dZZZ1)*SW))*
            USf[3, j1][s2, 2]) + CW^2*((1 - 4*CW^2)*
            (Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
             Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
            USf[3, j1][s2, 1] + 4*SW^2*(Conjugate[USf[3, j1][1, 2]]*
              dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 2]]*
              dZSf1[2, s1, 3, j1])*USf[3, j1][s2, 2]))))/(CW^3*SW^2)}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[1]] == 
  {{(I/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*IndexDelta[s1, s2], 
    ((I/12)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CW*SW*(dZbarSf1[1, s2, 4, j2]*IndexDelta[1, s1] + 
         dZSf1[1, s1, 4, j1]*IndexDelta[1, s2] + dZbarSf1[2, s2, 4, j2]*
          IndexDelta[2, s1] + dZSf1[2, s1, 4, j1]*IndexDelta[2, s2] + 
         (dZAA1 + 2*dZe1)*IndexDelta[s1, s2]) + 
       dZZA1*((3 - 2*SW^2)*Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] - 
         2*SW^2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])))/(CW*SW)}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[2]] == 
  {{((I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      ((1 + 2*CW^2)*Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] - 
       2*SW^2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]))/(CW*SW), 
    ((I/12)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CW^3*dZAZ1*SW^2*IndexDelta[s1, s2] + Conjugate[USf[4, j1][s1, 1]]*
        (CW^2*(1 + 2*CW^2)*SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 1] + 
           dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 1]) + 
         (2*(dSW1*SW^2 + CW^4*(2*dSW1 + (2*dZe1 + dZZZ1)*SW)) + 
           CW^2*((2*dZe1 + dZZZ1)*SW - 2*dSW1*(5 - 2*SW^2)))*
          USf[4, j1][s2, 1]) - SW*(2*SW*Conjugate[USf[4, j1][s1, 2]]*
          (CW^2*SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 2] + 
             dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 2]) + 
           (2*dSW1*SW^2 + CW^2*(2*dSW1 + (2*dZe1 + dZZZ1)*SW))*
            USf[4, j1][s2, 2]) - CW^2*((1 + 2*CW^2)*
            (Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s1, 4, j1] + 
             Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s1, 4, j1])*
            USf[4, j1][s2, 1] - 2*SW^2*(Conjugate[USf[4, j1][1, 2]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 2]]*
              dZSf1[2, s1, 4, j1])*USf[4, j1][s2, 2]))))/(CW^3*SW^2)}}, 
 C[S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[3]] == 
  {{((-I)*EL*Conjugate[CKM[j1, j2]]*Conjugate[USf[3, j1][s1, 1]]*
      IndexDelta[o1, o2]*USf[4, j2][s2, 1])/(Sqrt[2]*SW), 
    ((-I/2)*EL*IndexDelta[o1, o2]*(2*SW*Conjugate[dCKM1[j1, j2]]*
        Conjugate[USf[3, j1][s1, 1]]*USf[4, j2][s2, 1] + 
       Conjugate[CKM[j1, j2]]*(SW*(Conjugate[USf[3, j1][1, 1]]*
            dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 1]]*
            dZSf1[2, s1, 3, j1])*USf[4, j2][s2, 1] + 
         Conjugate[USf[3, j1][s1, 1]]*
          (SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + 
             dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 1]) - 
           (2*dSW1 - (2*dZe1 + dZW1)*SW)*USf[4, j2][s2, 1]))))/
     (Sqrt[2]*SW^2)}}, C[S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}], -V[3]] == 
  {{((-I)*EL*CKM[j1, j2]*Conjugate[USf[4, j2][s2, 1]]*IndexDelta[o1, o2]*
      USf[3, j1][s1, 1])/(Sqrt[2]*SW), 
    ((-I/2)*EL*IndexDelta[o1, o2]*(2*SW*Conjugate[USf[4, j2][s2, 1]]*
        dCKM1[j1, j2]*USf[3, j1][s1, 1] + CKM[j1, j2]*
        (SW*(Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
          USf[3, j1][s1, 1] + Conjugate[USf[4, j2][s2, 1]]*
          (SW*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + 
             dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) - 
           (2*dSW1 - (dZbarW1 + 2*dZe1)*SW)*USf[3, j1][s1, 1]))))/
     (Sqrt[2]*SW^2)}}, C[S[11, {j1}], -S[12, {s2, j2}], V[3]] == 
  {{((-I)*EL*IndexDelta[j1, j2]*USf[2, j1][s2, 1])/(Sqrt[2]*SW), 
    ((-I/2)*EL*IndexDelta[j1, j2]*
      (SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*
          USf[2, j1][2, 1]) - (2*dSW1 - SW*(2*dZe1 + dZW1 + 
           dZSf1[1, 1, 1, j1]))*USf[2, j1][s2, 1]))/(Sqrt[2]*SW^2)}}, 
 C[S[12, {s2, j2}], -S[11, {j1}], -V[3]] == 
  {{((-I)*EL*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2])/(Sqrt[2]*SW), 
    ((I/2)*EL*(Conjugate[USf[2, j1][s2, 1]]*(2*dSW1 - 
         SW*(dZbarW1 + 2*dZe1 + dZbarSf1[1, 1, 1, j1])) - 
       SW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
         Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2]))*
      IndexDelta[j1, j2])/(Sqrt[2]*SW^2)}}, 
 C[F[11, {n2}], F[11, {n1}], S[1]] == 
  {{((-I/2)*EL*((SA*Conjugate[ZNeu[n1, 3]] + CA*Conjugate[ZNeu[n1, 4]])*
        (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
       (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]])*
        (SA*Conjugate[ZNeu[n2, 3]] + CA*Conjugate[ZNeu[n2, 4]])))/(CW*SW), 
    ((-I/4)*EL*((2*((SA*Conjugate[ZNeu[n1, 3]] + CA*Conjugate[ZNeu[n1, 4]])*
           (SW^2*(CW^2*dZe1 + dSW1*SW)*Conjugate[ZNeu[n2, 1]] + 
            CW^3*(dSW1 - dZe1*SW)*Conjugate[ZNeu[n2, 2]]) + 
          (SW^2*(CW^2*dZe1 + dSW1*SW)*Conjugate[ZNeu[n1, 1]] + 
            CW^3*(dSW1 - dZe1*SW)*Conjugate[ZNeu[n1, 2]])*
           (SA*Conjugate[ZNeu[n2, 3]] + CA*Conjugate[ZNeu[n2, 4]])))/CW^3 + 
       (SW*(((SA*Conjugate[ZNeu[1, 3]] + CA*Conjugate[ZNeu[1, 4]])*
             (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]]) + 
            (SW*Conjugate[ZNeu[1, 1]] - CW*Conjugate[ZNeu[1, 2]])*
             (SA*Conjugate[ZNeu[n1, 3]] + CA*Conjugate[ZNeu[n1, 4]]))*
           dZbarfR1[11, n2, 1] + ((SA*Conjugate[ZNeu[2, 3]] + 
              CA*Conjugate[ZNeu[2, 4]])*(SW*Conjugate[ZNeu[n1, 1]] - 
              CW*Conjugate[ZNeu[n1, 2]]) + (SW*Conjugate[ZNeu[2, 1]] - 
              CW*Conjugate[ZNeu[2, 2]])*(SA*Conjugate[ZNeu[n1, 3]] + 
              CA*Conjugate[ZNeu[n1, 4]]))*dZbarfR1[11, n2, 2] + 
          ((SA*Conjugate[ZNeu[3, 3]] + CA*Conjugate[ZNeu[3, 4]])*
             (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]]) + 
            (SW*Conjugate[ZNeu[3, 1]] - CW*Conjugate[ZNeu[3, 2]])*
             (SA*Conjugate[ZNeu[n1, 3]] + CA*Conjugate[ZNeu[n1, 4]]))*
           dZbarfR1[11, n2, 3] + ((SA*Conjugate[ZNeu[4, 3]] + 
              CA*Conjugate[ZNeu[4, 4]])*(SW*Conjugate[ZNeu[n1, 1]] - 
              CW*Conjugate[ZNeu[n1, 2]]) + (SW*Conjugate[ZNeu[4, 1]] - 
              CW*Conjugate[ZNeu[4, 2]])*(SA*Conjugate[ZNeu[n1, 3]] + 
              CA*Conjugate[ZNeu[n1, 4]]))*dZbarfR1[11, n2, 4] + 
          ((SA*Conjugate[ZNeu[1, 3]] + CA*Conjugate[ZNeu[1, 4]])*
             (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
            (SW*Conjugate[ZNeu[1, 1]] - CW*Conjugate[ZNeu[1, 2]])*
             (SA*Conjugate[ZNeu[n2, 3]] + CA*Conjugate[ZNeu[n2, 4]]))*
           dZfL1[11, 1, n1] + ((SA*Conjugate[ZNeu[2, 3]] + CA*Conjugate[
                ZNeu[2, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[
                ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[2, 1]] - CW*Conjugate[
                ZNeu[2, 2]])*(SA*Conjugate[ZNeu[n2, 3]] + CA*Conjugate[
                ZNeu[n2, 4]]))*dZfL1[11, 2, n1] + 
          ((SA*Conjugate[ZNeu[3, 3]] + CA*Conjugate[ZNeu[3, 4]])*
             (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
            (SW*Conjugate[ZNeu[3, 1]] - CW*Conjugate[ZNeu[3, 2]])*
             (SA*Conjugate[ZNeu[n2, 3]] + CA*Conjugate[ZNeu[n2, 4]]))*
           dZfL1[11, 3, n1] + ((SA*Conjugate[ZNeu[4, 3]] + CA*Conjugate[
                ZNeu[4, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[
                ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[4, 1]] - CW*Conjugate[
                ZNeu[4, 2]])*(SA*Conjugate[ZNeu[n2, 3]] + CA*Conjugate[
                ZNeu[n2, 4]]))*dZfL1[11, 4, n1] + 
          ((SA*Conjugate[ZNeu[n1, 3]] + CA*Conjugate[ZNeu[n1, 4]])*
             (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
            (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]])*
             (SA*Conjugate[ZNeu[n2, 3]] + CA*Conjugate[ZNeu[n2, 4]]))*
           dZHiggs1[1, 1] - ((CA*Conjugate[ZNeu[n1, 3]] - SA*Conjugate[
                ZNeu[n1, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[
                ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[
                ZNeu[n1, 2]])*(CA*Conjugate[ZNeu[n2, 3]] - SA*Conjugate[
                ZNeu[n2, 4]]))*dZHiggs1[1, 2]))/CW))/SW^2}, 
   {((-I/2)*EL*((SA*ZNeu[n1, 3] + CA*ZNeu[n1, 4])*(SW*ZNeu[n2, 1] - 
         CW*ZNeu[n2, 2]) + (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2])*
        (SA*ZNeu[n2, 3] + CA*ZNeu[n2, 4])))/(CW*SW), 
    ((-I/4)*EL*(2*((SA*ZNeu[n1, 3] + CA*ZNeu[n1, 4])*
          (SW^2*(CW^2*dZe1 + dSW1*SW)*ZNeu[n2, 1] + CW^3*(dSW1 - dZe1*SW)*
            ZNeu[n2, 2]) + (SW^2*(CW^2*dZe1 + dSW1*SW)*ZNeu[n1, 1] + 
           CW^3*(dSW1 - dZe1*SW)*ZNeu[n1, 2])*(SA*ZNeu[n2, 3] + 
           CA*ZNeu[n2, 4])) + CW^2*SW*(dZbarfL1[11, n2, 1]*
          ((SA*ZNeu[1, 3] + CA*ZNeu[1, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[1, 1] - CW*ZNeu[1, 2])*
            (SA*ZNeu[n1, 3] + CA*ZNeu[n1, 4])) + dZbarfL1[11, n2, 2]*
          ((SA*ZNeu[2, 3] + CA*ZNeu[2, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[2, 1] - CW*ZNeu[2, 2])*
            (SA*ZNeu[n1, 3] + CA*ZNeu[n1, 4])) + dZbarfL1[11, n2, 3]*
          ((SA*ZNeu[3, 3] + CA*ZNeu[3, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[3, 1] - CW*ZNeu[3, 2])*
            (SA*ZNeu[n1, 3] + CA*ZNeu[n1, 4])) + dZbarfL1[11, n2, 4]*
          ((SA*ZNeu[4, 3] + CA*ZNeu[4, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[4, 1] - CW*ZNeu[4, 2])*
            (SA*ZNeu[n1, 3] + CA*ZNeu[n1, 4])) + 
         ((SA*dZHiggs1[1, 1] - CA*dZHiggs1[1, 2])*ZNeu[n1, 3] + 
           (CA*dZHiggs1[1, 1] + SA*dZHiggs1[1, 2])*ZNeu[n1, 4])*
          (SW*ZNeu[n2, 1] - CW*ZNeu[n2, 2]) + 
         (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2])*
          ((SA*dZHiggs1[1, 1] - CA*dZHiggs1[1, 2])*ZNeu[n2, 3] + 
           (CA*dZHiggs1[1, 1] + SA*dZHiggs1[1, 2])*ZNeu[n2, 4]) + 
         dZfR1[11, 1, n1]*((SA*ZNeu[1, 3] + CA*ZNeu[1, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[1, 1] - CW*ZNeu[1, 2])*
            (SA*ZNeu[n2, 3] + CA*ZNeu[n2, 4])) + dZfR1[11, 2, n1]*
          ((SA*ZNeu[2, 3] + CA*ZNeu[2, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[2, 1] - CW*ZNeu[2, 2])*
            (SA*ZNeu[n2, 3] + CA*ZNeu[n2, 4])) + dZfR1[11, 3, n1]*
          ((SA*ZNeu[3, 3] + CA*ZNeu[3, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[3, 1] - CW*ZNeu[3, 2])*
            (SA*ZNeu[n2, 3] + CA*ZNeu[n2, 4])) + dZfR1[11, 4, n1]*
          ((SA*ZNeu[4, 3] + CA*ZNeu[4, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[4, 1] - CW*ZNeu[4, 2])*
            (SA*ZNeu[n2, 3] + CA*ZNeu[n2, 4])))))/(CW^3*SW^2)}}, 
 C[F[11, {n2}], F[11, {n1}], S[2]] == 
  {{((I/2)*EL*((CA*Conjugate[ZNeu[n1, 3]] - SA*Conjugate[ZNeu[n1, 4]])*
        (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
       (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]])*
        (CA*Conjugate[ZNeu[n2, 3]] - SA*Conjugate[ZNeu[n2, 4]])))/(CW*SW), 
    ((I/4)*EL*((2*((CA*Conjugate[ZNeu[n1, 3]] - SA*Conjugate[ZNeu[n1, 4]])*
           (SW^2*(CW^2*dZe1 + dSW1*SW)*Conjugate[ZNeu[n2, 1]] + 
            CW^3*(dSW1 - dZe1*SW)*Conjugate[ZNeu[n2, 2]]) + 
          (SW^2*(CW^2*dZe1 + dSW1*SW)*Conjugate[ZNeu[n1, 1]] + 
            CW^3*(dSW1 - dZe1*SW)*Conjugate[ZNeu[n1, 2]])*
           (CA*Conjugate[ZNeu[n2, 3]] - SA*Conjugate[ZNeu[n2, 4]])))/CW^3 + 
       (SW*(((CA*Conjugate[ZNeu[1, 3]] - SA*Conjugate[ZNeu[1, 4]])*
             (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]]) + 
            (SW*Conjugate[ZNeu[1, 1]] - CW*Conjugate[ZNeu[1, 2]])*
             (CA*Conjugate[ZNeu[n1, 3]] - SA*Conjugate[ZNeu[n1, 4]]))*
           dZbarfR1[11, n2, 1] + ((CA*Conjugate[ZNeu[2, 3]] - 
              SA*Conjugate[ZNeu[2, 4]])*(SW*Conjugate[ZNeu[n1, 1]] - 
              CW*Conjugate[ZNeu[n1, 2]]) + (SW*Conjugate[ZNeu[2, 1]] - 
              CW*Conjugate[ZNeu[2, 2]])*(CA*Conjugate[ZNeu[n1, 3]] - 
              SA*Conjugate[ZNeu[n1, 4]]))*dZbarfR1[11, n2, 2] + 
          ((CA*Conjugate[ZNeu[3, 3]] - SA*Conjugate[ZNeu[3, 4]])*
             (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]]) + 
            (SW*Conjugate[ZNeu[3, 1]] - CW*Conjugate[ZNeu[3, 2]])*
             (CA*Conjugate[ZNeu[n1, 3]] - SA*Conjugate[ZNeu[n1, 4]]))*
           dZbarfR1[11, n2, 3] + ((CA*Conjugate[ZNeu[4, 3]] - 
              SA*Conjugate[ZNeu[4, 4]])*(SW*Conjugate[ZNeu[n1, 1]] - 
              CW*Conjugate[ZNeu[n1, 2]]) + (SW*Conjugate[ZNeu[4, 1]] - 
              CW*Conjugate[ZNeu[4, 2]])*(CA*Conjugate[ZNeu[n1, 3]] - 
              SA*Conjugate[ZNeu[n1, 4]]))*dZbarfR1[11, n2, 4] + 
          ((CA*Conjugate[ZNeu[1, 3]] - SA*Conjugate[ZNeu[1, 4]])*
             (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
            (SW*Conjugate[ZNeu[1, 1]] - CW*Conjugate[ZNeu[1, 2]])*
             (CA*Conjugate[ZNeu[n2, 3]] - SA*Conjugate[ZNeu[n2, 4]]))*
           dZfL1[11, 1, n1] + ((CA*Conjugate[ZNeu[2, 3]] - SA*Conjugate[
                ZNeu[2, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[
                ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[2, 1]] - CW*Conjugate[
                ZNeu[2, 2]])*(CA*Conjugate[ZNeu[n2, 3]] - SA*Conjugate[
                ZNeu[n2, 4]]))*dZfL1[11, 2, n1] + 
          ((CA*Conjugate[ZNeu[3, 3]] - SA*Conjugate[ZNeu[3, 4]])*
             (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
            (SW*Conjugate[ZNeu[3, 1]] - CW*Conjugate[ZNeu[3, 2]])*
             (CA*Conjugate[ZNeu[n2, 3]] - SA*Conjugate[ZNeu[n2, 4]]))*
           dZfL1[11, 3, n1] + ((CA*Conjugate[ZNeu[4, 3]] - SA*Conjugate[
                ZNeu[4, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[
                ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[4, 1]] - CW*Conjugate[
                ZNeu[4, 2]])*(CA*Conjugate[ZNeu[n2, 3]] - SA*Conjugate[
                ZNeu[n2, 4]]))*dZfL1[11, 4, n1] - 
          ((SA*Conjugate[ZNeu[n1, 3]] + CA*Conjugate[ZNeu[n1, 4]])*
             (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
            (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]])*
             (SA*Conjugate[ZNeu[n2, 3]] + CA*Conjugate[ZNeu[n2, 4]]))*
           dZHiggs1[1, 2] + ((CA*Conjugate[ZNeu[n1, 3]] - SA*Conjugate[
                ZNeu[n1, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[
                ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[
                ZNeu[n1, 2]])*(CA*Conjugate[ZNeu[n2, 3]] - SA*Conjugate[
                ZNeu[n2, 4]]))*dZHiggs1[2, 2]))/CW))/SW^2}, 
   {((I/2)*EL*((CA*ZNeu[n1, 3] - SA*ZNeu[n1, 4])*(SW*ZNeu[n2, 1] - 
         CW*ZNeu[n2, 2]) + (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2])*
        (CA*ZNeu[n2, 3] - SA*ZNeu[n2, 4])))/(CW*SW), 
    ((I/4)*EL*(2*((CA*ZNeu[n1, 3] - SA*ZNeu[n1, 4])*
          (SW^2*(CW^2*dZe1 + dSW1*SW)*ZNeu[n2, 1] + CW^3*(dSW1 - dZe1*SW)*
            ZNeu[n2, 2]) + (SW^2*(CW^2*dZe1 + dSW1*SW)*ZNeu[n1, 1] + 
           CW^3*(dSW1 - dZe1*SW)*ZNeu[n1, 2])*(CA*ZNeu[n2, 3] - 
           SA*ZNeu[n2, 4])) + CW^2*SW*(dZbarfL1[11, n2, 1]*
          ((CA*ZNeu[1, 3] - SA*ZNeu[1, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[1, 1] - CW*ZNeu[1, 2])*
            (CA*ZNeu[n1, 3] - SA*ZNeu[n1, 4])) + dZbarfL1[11, n2, 2]*
          ((CA*ZNeu[2, 3] - SA*ZNeu[2, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[2, 1] - CW*ZNeu[2, 2])*
            (CA*ZNeu[n1, 3] - SA*ZNeu[n1, 4])) + dZbarfL1[11, n2, 3]*
          ((CA*ZNeu[3, 3] - SA*ZNeu[3, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[3, 1] - CW*ZNeu[3, 2])*
            (CA*ZNeu[n1, 3] - SA*ZNeu[n1, 4])) + dZbarfL1[11, n2, 4]*
          ((CA*ZNeu[4, 3] - SA*ZNeu[4, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[4, 1] - CW*ZNeu[4, 2])*
            (CA*ZNeu[n1, 3] - SA*ZNeu[n1, 4])) - dZHiggs1[1, 2]*
          ((SA*ZNeu[n1, 3] + CA*ZNeu[n1, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2])*
            (SA*ZNeu[n2, 3] + CA*ZNeu[n2, 4])) + dZfR1[11, 1, n1]*
          ((CA*ZNeu[1, 3] - SA*ZNeu[1, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[1, 1] - CW*ZNeu[1, 2])*
            (CA*ZNeu[n2, 3] - SA*ZNeu[n2, 4])) + dZfR1[11, 2, n1]*
          ((CA*ZNeu[2, 3] - SA*ZNeu[2, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[2, 1] - CW*ZNeu[2, 2])*
            (CA*ZNeu[n2, 3] - SA*ZNeu[n2, 4])) + dZfR1[11, 3, n1]*
          ((CA*ZNeu[3, 3] - SA*ZNeu[3, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[3, 1] - CW*ZNeu[3, 2])*
            (CA*ZNeu[n2, 3] - SA*ZNeu[n2, 4])) + dZfR1[11, 4, n1]*
          ((CA*ZNeu[4, 3] - SA*ZNeu[4, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[4, 1] - CW*ZNeu[4, 2])*
            (CA*ZNeu[n2, 3] - SA*ZNeu[n2, 4])) + dZHiggs1[2, 2]*
          ((CA*ZNeu[n1, 3] - SA*ZNeu[n1, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2])*
            (CA*ZNeu[n2, 3] - SA*ZNeu[n2, 4])))))/(CW^3*SW^2)}}, 
 C[F[11, {n2}], F[11, {n1}], S[3]] == 
  {{(EL*((SB*Conjugate[ZNeu[n1, 3]] - CB*Conjugate[ZNeu[n1, 4]])*
        (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
       (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]])*
        (SB*Conjugate[ZNeu[n2, 3]] - CB*Conjugate[ZNeu[n2, 4]])))/(2*CW*SW), 
    (EL*((2*SB*Conjugate[ZNeu[n1, 3]] - 2*CB*Conjugate[ZNeu[n1, 4]])*
        (SW^2*(CW^2*dZe1 + dSW1*SW)*Conjugate[ZNeu[n2, 1]] + 
         CW^3*(dSW1 - dZe1*SW)*Conjugate[ZNeu[n2, 2]]) + 
       2*(SW^2*(CW^2*dZe1 + dSW1*SW)*Conjugate[ZNeu[n1, 1]] + 
         CW^3*(dSW1 - dZe1*SW)*Conjugate[ZNeu[n1, 2]])*
        (SB*Conjugate[ZNeu[n2, 3]] - CB*Conjugate[ZNeu[n2, 4]]) + 
       CW^2*SW*(((SB*Conjugate[ZNeu[1, 3]] - CB*Conjugate[ZNeu[1, 4]])*
            (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]]) + 
           (SW*Conjugate[ZNeu[1, 1]] - CW*Conjugate[ZNeu[1, 2]])*
            (SB*Conjugate[ZNeu[n1, 3]] - CB*Conjugate[ZNeu[n1, 4]]))*
          dZbarfR1[11, n2, 1] + ((SB*Conjugate[ZNeu[2, 3]] - 
             CB*Conjugate[ZNeu[2, 4]])*(SW*Conjugate[ZNeu[n1, 1]] - 
             CW*Conjugate[ZNeu[n1, 2]]) + (SW*Conjugate[ZNeu[2, 1]] - 
             CW*Conjugate[ZNeu[2, 2]])*(SB*Conjugate[ZNeu[n1, 3]] - 
             CB*Conjugate[ZNeu[n1, 4]]))*dZbarfR1[11, n2, 2] + 
         ((SB*Conjugate[ZNeu[3, 3]] - CB*Conjugate[ZNeu[3, 4]])*
            (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]]) + 
           (SW*Conjugate[ZNeu[3, 1]] - CW*Conjugate[ZNeu[3, 2]])*
            (SB*Conjugate[ZNeu[n1, 3]] - CB*Conjugate[ZNeu[n1, 4]]))*
          dZbarfR1[11, n2, 3] + ((SB*Conjugate[ZNeu[4, 3]] - 
             CB*Conjugate[ZNeu[4, 4]])*(SW*Conjugate[ZNeu[n1, 1]] - 
             CW*Conjugate[ZNeu[n1, 2]]) + (SW*Conjugate[ZNeu[4, 1]] - 
             CW*Conjugate[ZNeu[4, 2]])*(SB*Conjugate[ZNeu[n1, 3]] - 
             CB*Conjugate[ZNeu[n1, 4]]))*dZbarfR1[11, n2, 4] + 
         ((SB*Conjugate[ZNeu[1, 3]] - CB*Conjugate[ZNeu[1, 4]])*
            (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
           (SW*Conjugate[ZNeu[1, 1]] - CW*Conjugate[ZNeu[1, 2]])*
            (SB*Conjugate[ZNeu[n2, 3]] - CB*Conjugate[ZNeu[n2, 4]]))*
          dZfL1[11, 1, n1] + ((SB*Conjugate[ZNeu[2, 3]] - 
             CB*Conjugate[ZNeu[2, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - 
             CW*Conjugate[ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[2, 1]] - 
             CW*Conjugate[ZNeu[2, 2]])*(SB*Conjugate[ZNeu[n2, 3]] - 
             CB*Conjugate[ZNeu[n2, 4]]))*dZfL1[11, 2, n1] + 
         ((SB*Conjugate[ZNeu[3, 3]] - CB*Conjugate[ZNeu[3, 4]])*
            (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
           (SW*Conjugate[ZNeu[3, 1]] - CW*Conjugate[ZNeu[3, 2]])*
            (SB*Conjugate[ZNeu[n2, 3]] - CB*Conjugate[ZNeu[n2, 4]]))*
          dZfL1[11, 3, n1] + ((SB*Conjugate[ZNeu[4, 3]] - 
             CB*Conjugate[ZNeu[4, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - 
             CW*Conjugate[ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[4, 1]] - 
             CW*Conjugate[ZNeu[4, 2]])*(SB*Conjugate[ZNeu[n2, 3]] - 
             CB*Conjugate[ZNeu[n2, 4]]))*dZfL1[11, 4, n1] + 
         ((SB*Conjugate[ZNeu[n1, 3]] - CB*Conjugate[ZNeu[n1, 4]])*
            (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
           (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]])*
            (SB*Conjugate[ZNeu[n2, 3]] - CB*Conjugate[ZNeu[n2, 4]]))*
          dZHiggs1[3, 3] - ((CB*Conjugate[ZNeu[n1, 3]] + 
             SB*Conjugate[ZNeu[n1, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - 
             CW*Conjugate[ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[n1, 1]] - 
             CW*Conjugate[ZNeu[n1, 2]])*(CB*Conjugate[ZNeu[n2, 3]] + 
             SB*Conjugate[ZNeu[n2, 4]]))*dZHiggs1[3, 4])))/(4*CW^3*SW^2)}, 
   {-(EL*((SB*ZNeu[n1, 3] - CB*ZNeu[n1, 4])*(SW*ZNeu[n2, 1] - 
          CW*ZNeu[n2, 2]) + (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2])*
         (SB*ZNeu[n2, 3] - CB*ZNeu[n2, 4])))/(2*CW*SW), 
    -(EL*((2*SB*ZNeu[n1, 3] - 2*CB*ZNeu[n1, 4])*(SW^2*(CW^2*dZe1 + dSW1*SW)*
           ZNeu[n2, 1] + CW^3*(dSW1 - dZe1*SW)*ZNeu[n2, 2]) + 
        2*(SW^2*(CW^2*dZe1 + dSW1*SW)*ZNeu[n1, 1] + CW^3*(dSW1 - dZe1*SW)*
           ZNeu[n1, 2])*(SB*ZNeu[n2, 3] - CB*ZNeu[n2, 4]) + 
        CW^2*SW*(dZbarfL1[11, n2, 1]*((SB*ZNeu[1, 3] - CB*ZNeu[1, 4])*
             (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2]) + (SW*ZNeu[1, 1] - 
              CW*ZNeu[1, 2])*(SB*ZNeu[n1, 3] - CB*ZNeu[n1, 4])) + 
          dZbarfL1[11, n2, 2]*((SB*ZNeu[2, 3] - CB*ZNeu[2, 4])*
             (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2]) + (SW*ZNeu[2, 1] - 
              CW*ZNeu[2, 2])*(SB*ZNeu[n1, 3] - CB*ZNeu[n1, 4])) + 
          dZbarfL1[11, n2, 3]*((SB*ZNeu[3, 3] - CB*ZNeu[3, 4])*
             (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2]) + (SW*ZNeu[3, 1] - 
              CW*ZNeu[3, 2])*(SB*ZNeu[n1, 3] - CB*ZNeu[n1, 4])) + 
          dZbarfL1[11, n2, 4]*((SB*ZNeu[4, 3] - CB*ZNeu[4, 4])*
             (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2]) + (SW*ZNeu[4, 1] - 
              CW*ZNeu[4, 2])*(SB*ZNeu[n1, 3] - CB*ZNeu[n1, 4])) + 
          ((SB*dZHiggs1[3, 3] - CB*dZHiggs1[3, 4])*ZNeu[n1, 3] - 
            (CB*dZHiggs1[3, 3] + SB*dZHiggs1[3, 4])*ZNeu[n1, 4])*
           (SW*ZNeu[n2, 1] - CW*ZNeu[n2, 2]) + 
          (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2])*
           ((SB*dZHiggs1[3, 3] - CB*dZHiggs1[3, 4])*ZNeu[n2, 3] - 
            (CB*dZHiggs1[3, 3] + SB*dZHiggs1[3, 4])*ZNeu[n2, 4]) + 
          dZfR1[11, 1, n1]*((SB*ZNeu[1, 3] - CB*ZNeu[1, 4])*(SW*ZNeu[n2, 1] - 
              CW*ZNeu[n2, 2]) + (SW*ZNeu[1, 1] - CW*ZNeu[1, 2])*
             (SB*ZNeu[n2, 3] - CB*ZNeu[n2, 4])) + dZfR1[11, 2, n1]*
           ((SB*ZNeu[2, 3] - CB*ZNeu[2, 4])*(SW*ZNeu[n2, 1] - 
              CW*ZNeu[n2, 2]) + (SW*ZNeu[2, 1] - CW*ZNeu[2, 2])*
             (SB*ZNeu[n2, 3] - CB*ZNeu[n2, 4])) + dZfR1[11, 3, n1]*
           ((SB*ZNeu[3, 3] - CB*ZNeu[3, 4])*(SW*ZNeu[n2, 1] - 
              CW*ZNeu[n2, 2]) + (SW*ZNeu[3, 1] - CW*ZNeu[3, 2])*
             (SB*ZNeu[n2, 3] - CB*ZNeu[n2, 4])) + dZfR1[11, 4, n1]*
           ((SB*ZNeu[4, 3] - CB*ZNeu[4, 4])*(SW*ZNeu[n2, 1] - 
              CW*ZNeu[n2, 2]) + (SW*ZNeu[4, 1] - CW*ZNeu[4, 2])*
             (SB*ZNeu[n2, 3] - CB*ZNeu[n2, 4])))))/(4*CW^3*SW^2)}}, 
 C[F[11, {n2}], F[11, {n1}], S[4]] == 
  {{-(EL*((CB*Conjugate[ZNeu[n1, 3]] + SB*Conjugate[ZNeu[n1, 4]])*
         (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
        (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]])*
         (CB*Conjugate[ZNeu[n2, 3]] + SB*Conjugate[ZNeu[n2, 4]])))/(2*CW*SW), 
    -(EL*(2*((CB*Conjugate[ZNeu[n1, 3]] + SB*Conjugate[ZNeu[n1, 4]])*
           (SW^2*(CW^2*dZe1 + dSW1*SW)*Conjugate[ZNeu[n2, 1]] + 
            CW^3*(dSW1 - dZe1*SW)*Conjugate[ZNeu[n2, 2]]) + 
          (SW^2*(CW^2*dZe1 + dSW1*SW)*Conjugate[ZNeu[n1, 1]] + 
            CW^3*(dSW1 - dZe1*SW)*Conjugate[ZNeu[n1, 2]])*
           (CB*Conjugate[ZNeu[n2, 3]] + SB*Conjugate[ZNeu[n2, 4]])) + 
        CW^2*SW*(((CB*Conjugate[ZNeu[1, 3]] + SB*Conjugate[ZNeu[1, 4]])*
             (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]]) + 
            (SW*Conjugate[ZNeu[1, 1]] - CW*Conjugate[ZNeu[1, 2]])*
             (CB*Conjugate[ZNeu[n1, 3]] + SB*Conjugate[ZNeu[n1, 4]]))*
           dZbarfR1[11, n2, 1] + ((CB*Conjugate[ZNeu[2, 3]] + 
              SB*Conjugate[ZNeu[2, 4]])*(SW*Conjugate[ZNeu[n1, 1]] - 
              CW*Conjugate[ZNeu[n1, 2]]) + (SW*Conjugate[ZNeu[2, 1]] - 
              CW*Conjugate[ZNeu[2, 2]])*(CB*Conjugate[ZNeu[n1, 3]] + 
              SB*Conjugate[ZNeu[n1, 4]]))*dZbarfR1[11, n2, 2] + 
          ((CB*Conjugate[ZNeu[3, 3]] + SB*Conjugate[ZNeu[3, 4]])*
             (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]]) + 
            (SW*Conjugate[ZNeu[3, 1]] - CW*Conjugate[ZNeu[3, 2]])*
             (CB*Conjugate[ZNeu[n1, 3]] + SB*Conjugate[ZNeu[n1, 4]]))*
           dZbarfR1[11, n2, 3] + ((CB*Conjugate[ZNeu[4, 3]] + 
              SB*Conjugate[ZNeu[4, 4]])*(SW*Conjugate[ZNeu[n1, 1]] - 
              CW*Conjugate[ZNeu[n1, 2]]) + (SW*Conjugate[ZNeu[4, 1]] - 
              CW*Conjugate[ZNeu[4, 2]])*(CB*Conjugate[ZNeu[n1, 3]] + 
              SB*Conjugate[ZNeu[n1, 4]]))*dZbarfR1[11, n2, 4] + 
          ((CB*Conjugate[ZNeu[1, 3]] + SB*Conjugate[ZNeu[1, 4]])*
             (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
            (SW*Conjugate[ZNeu[1, 1]] - CW*Conjugate[ZNeu[1, 2]])*
             (CB*Conjugate[ZNeu[n2, 3]] + SB*Conjugate[ZNeu[n2, 4]]))*
           dZfL1[11, 1, n1] + ((CB*Conjugate[ZNeu[2, 3]] + SB*Conjugate[
                ZNeu[2, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[
                ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[2, 1]] - CW*Conjugate[
                ZNeu[2, 2]])*(CB*Conjugate[ZNeu[n2, 3]] + SB*Conjugate[
                ZNeu[n2, 4]]))*dZfL1[11, 2, n1] + 
          ((CB*Conjugate[ZNeu[3, 3]] + SB*Conjugate[ZNeu[3, 4]])*
             (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
            (SW*Conjugate[ZNeu[3, 1]] - CW*Conjugate[ZNeu[3, 2]])*
             (CB*Conjugate[ZNeu[n2, 3]] + SB*Conjugate[ZNeu[n2, 4]]))*
           dZfL1[11, 3, n1] + ((CB*Conjugate[ZNeu[4, 3]] + SB*Conjugate[
                ZNeu[4, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[
                ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[4, 1]] - CW*Conjugate[
                ZNeu[4, 2]])*(CB*Conjugate[ZNeu[n2, 3]] + SB*Conjugate[
                ZNeu[n2, 4]]))*dZfL1[11, 4, n1] - 
          ((SB*Conjugate[ZNeu[n1, 3]] - CB*Conjugate[ZNeu[n1, 4]])*
             (SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[ZNeu[n2, 2]]) + 
            (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]])*
             (SB*Conjugate[ZNeu[n2, 3]] - CB*Conjugate[ZNeu[n2, 4]]))*
           dZHiggs1[3, 4] + ((CB*Conjugate[ZNeu[n1, 3]] + SB*Conjugate[
                ZNeu[n1, 4]])*(SW*Conjugate[ZNeu[n2, 1]] - CW*Conjugate[
                ZNeu[n2, 2]]) + (SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[
                ZNeu[n1, 2]])*(CB*Conjugate[ZNeu[n2, 3]] + SB*Conjugate[
                ZNeu[n2, 4]]))*dZHiggs1[4, 4])))/(4*CW^3*SW^2)}, 
   {(EL*((CB*ZNeu[n1, 3] + SB*ZNeu[n1, 4])*(SW*ZNeu[n2, 1] - 
         CW*ZNeu[n2, 2]) + (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2])*
        (CB*ZNeu[n2, 3] + SB*ZNeu[n2, 4])))/(2*CW*SW), 
    (EL*(2*((CB*ZNeu[n1, 3] + SB*ZNeu[n1, 4])*(SW^2*(CW^2*dZe1 + dSW1*SW)*
            ZNeu[n2, 1] + CW^3*(dSW1 - dZe1*SW)*ZNeu[n2, 2]) + 
         (SW^2*(CW^2*dZe1 + dSW1*SW)*ZNeu[n1, 1] + CW^3*(dSW1 - dZe1*SW)*
            ZNeu[n1, 2])*(CB*ZNeu[n2, 3] + SB*ZNeu[n2, 4])) + 
       CW^2*SW*(dZbarfL1[11, n2, 1]*((CB*ZNeu[1, 3] + SB*ZNeu[1, 4])*
            (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2]) + 
           (SW*ZNeu[1, 1] - CW*ZNeu[1, 2])*(CB*ZNeu[n1, 3] + 
             SB*ZNeu[n1, 4])) + dZbarfL1[11, n2, 2]*
          ((CB*ZNeu[2, 3] + SB*ZNeu[2, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[2, 1] - CW*ZNeu[2, 2])*
            (CB*ZNeu[n1, 3] + SB*ZNeu[n1, 4])) + dZbarfL1[11, n2, 3]*
          ((CB*ZNeu[3, 3] + SB*ZNeu[3, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[3, 1] - CW*ZNeu[3, 2])*
            (CB*ZNeu[n1, 3] + SB*ZNeu[n1, 4])) + dZbarfL1[11, n2, 4]*
          ((CB*ZNeu[4, 3] + SB*ZNeu[4, 4])*(SW*ZNeu[n1, 1] - 
             CW*ZNeu[n1, 2]) + (SW*ZNeu[4, 1] - CW*ZNeu[4, 2])*
            (CB*ZNeu[n1, 3] + SB*ZNeu[n1, 4])) - dZHiggs1[3, 4]*
          ((SB*ZNeu[n1, 3] - CB*ZNeu[n1, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2])*
            (SB*ZNeu[n2, 3] - CB*ZNeu[n2, 4])) + dZfR1[11, 1, n1]*
          ((CB*ZNeu[1, 3] + SB*ZNeu[1, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[1, 1] - CW*ZNeu[1, 2])*
            (CB*ZNeu[n2, 3] + SB*ZNeu[n2, 4])) + dZfR1[11, 2, n1]*
          ((CB*ZNeu[2, 3] + SB*ZNeu[2, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[2, 1] - CW*ZNeu[2, 2])*
            (CB*ZNeu[n2, 3] + SB*ZNeu[n2, 4])) + dZfR1[11, 3, n1]*
          ((CB*ZNeu[3, 3] + SB*ZNeu[3, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[3, 1] - CW*ZNeu[3, 2])*
            (CB*ZNeu[n2, 3] + SB*ZNeu[n2, 4])) + dZfR1[11, 4, n1]*
          ((CB*ZNeu[4, 3] + SB*ZNeu[4, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[4, 1] - CW*ZNeu[4, 2])*
            (CB*ZNeu[n2, 3] + SB*ZNeu[n2, 4])) + dZHiggs1[4, 4]*
          ((CB*ZNeu[n1, 3] + SB*ZNeu[n1, 4])*(SW*ZNeu[n2, 1] - 
             CW*ZNeu[n2, 2]) + (SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2])*
            (CB*ZNeu[n2, 3] + SB*ZNeu[n2, 4])))))/(4*CW^3*SW^2)}}, 
 C[F[12, {c1}], -F[12, {c2}], S[1]] == 
  {{(I*EL*(SA*Conjugate[UCha[c1, 2]]*Conjugate[VCha[c2, 1]] - 
       CA*Conjugate[UCha[c1, 1]]*Conjugate[VCha[c2, 2]]))/(Sqrt[2]*SW), 
    ((I/2)*EL*(SW*((SA*Conjugate[UCha[1, 2]]*Conjugate[VCha[c2, 1]] - 
           CA*Conjugate[UCha[1, 1]]*Conjugate[VCha[c2, 2]])*
          dZfL1[12, 1, c1] + (SA*Conjugate[UCha[2, 2]]*Conjugate[
             VCha[c2, 1]] - CA*Conjugate[UCha[2, 1]]*Conjugate[VCha[c2, 2]])*
          dZfL1[12, 2, c1]) + Conjugate[UCha[c1, 2]]*
        (SA*SW*(Conjugate[VCha[1, 1]]*dZbarfR1[12, c2, 1] + 
           Conjugate[VCha[2, 1]]*dZbarfR1[12, c2, 2]) - 
         Conjugate[VCha[c2, 1]]*(SA*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[1, 1])) + 
           CA*SW*dZHiggs1[1, 2])) - Conjugate[UCha[c1, 1]]*
        (CA*SW*(Conjugate[VCha[1, 2]]*dZbarfR1[12, c2, 1] + 
           Conjugate[VCha[2, 2]]*dZbarfR1[12, c2, 2]) - 
         Conjugate[VCha[c2, 2]]*(CA*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[1, 1])) - 
           SA*SW*dZHiggs1[1, 2]))))/(Sqrt[2]*SW^2)}, 
   {(I*EL*(SA*UCha[c2, 2]*VCha[c1, 1] - CA*UCha[c2, 1]*VCha[c1, 2]))/
     (Sqrt[2]*SW), 
    ((I/2)*EL*(SW*(dZfR1[12, 1, c1]*(SA*UCha[c2, 2]*VCha[1, 1] - 
           CA*UCha[c2, 1]*VCha[1, 2]) + dZfR1[12, 2, c1]*
          (SA*UCha[c2, 2]*VCha[2, 1] - CA*UCha[c2, 1]*VCha[2, 2])) + 
       (SA*SW*(dZbarfL1[12, c2, 1]*UCha[1, 2] + dZbarfL1[12, c2, 2]*
            UCha[2, 2]) - (SA*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[1, 1])) + 
           CA*SW*dZHiggs1[1, 2])*UCha[c2, 2])*VCha[c1, 1] - 
       (CA*SW*(dZbarfL1[12, c2, 1]*UCha[1, 1] + dZbarfL1[12, c2, 2]*
            UCha[2, 1]) - (CA*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[1, 1])) - 
           SA*SW*dZHiggs1[1, 2])*UCha[c2, 1])*VCha[c1, 2]))/(Sqrt[2]*SW^2)}}, 
 C[F[12, {c1}], -F[12, {c2}], S[2]] == 
  {{((-I)*EL*(CA*Conjugate[UCha[c1, 2]]*Conjugate[VCha[c2, 1]] + 
       SA*Conjugate[UCha[c1, 1]]*Conjugate[VCha[c2, 2]]))/(Sqrt[2]*SW), 
    ((-I/2)*EL*(SW*((CA*Conjugate[UCha[1, 2]]*Conjugate[VCha[c2, 1]] + 
           SA*Conjugate[UCha[1, 1]]*Conjugate[VCha[c2, 2]])*
          dZfL1[12, 1, c1] + (CA*Conjugate[UCha[2, 2]]*Conjugate[
             VCha[c2, 1]] + SA*Conjugate[UCha[2, 1]]*Conjugate[VCha[c2, 2]])*
          dZfL1[12, 2, c1]) + Conjugate[UCha[c1, 2]]*
        (CA*SW*(Conjugate[VCha[1, 1]]*dZbarfR1[12, c2, 1] + 
           Conjugate[VCha[2, 1]]*dZbarfR1[12, c2, 2]) - 
         Conjugate[VCha[c2, 1]]*(SA*SW*dZHiggs1[1, 2] + 
           CA*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[2, 2])))) + 
       Conjugate[UCha[c1, 1]]*(SA*SW*(Conjugate[VCha[1, 2]]*
            dZbarfR1[12, c2, 1] + Conjugate[VCha[2, 2]]*dZbarfR1[12, c2, 
             2]) + Conjugate[VCha[c2, 2]]*(CA*SW*dZHiggs1[1, 2] - 
           SA*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[2, 2]))))))/(Sqrt[2]*SW^2)}, 
   {((-I)*EL*(CA*UCha[c2, 2]*VCha[c1, 1] + SA*UCha[c2, 1]*VCha[c1, 2]))/
     (Sqrt[2]*SW), 
    ((-I/2)*EL*(SW*(dZfR1[12, 1, c1]*(CA*UCha[c2, 2]*VCha[1, 1] + 
           SA*UCha[c2, 1]*VCha[1, 2]) + dZfR1[12, 2, c1]*
          (CA*UCha[c2, 2]*VCha[2, 1] + SA*UCha[c2, 1]*VCha[2, 2])) + 
       (CA*SW*(dZbarfL1[12, c2, 1]*UCha[1, 2] + dZbarfL1[12, c2, 2]*
            UCha[2, 2]) - (SA*SW*dZHiggs1[1, 2] + 
           CA*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[2, 2])))*UCha[c2, 2])*
        VCha[c1, 1] + (SA*SW*(dZbarfL1[12, c2, 1]*UCha[1, 1] + 
           dZbarfL1[12, c2, 2]*UCha[2, 1]) + (CA*SW*dZHiggs1[1, 2] - 
           SA*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[2, 2])))*UCha[c2, 1])*
        VCha[c1, 2]))/(Sqrt[2]*SW^2)}}, C[F[12, {c1}], -F[12, {c2}], S[3]] == 
  {{-((EL*(SB*Conjugate[UCha[c1, 2]]*Conjugate[VCha[c2, 1]] + 
        CB*Conjugate[UCha[c1, 1]]*Conjugate[VCha[c2, 2]]))/(Sqrt[2]*SW)), 
    -(EL*(SW*((SB*Conjugate[UCha[1, 2]]*Conjugate[VCha[c2, 1]] + 
            CB*Conjugate[UCha[1, 1]]*Conjugate[VCha[c2, 2]])*
           dZfL1[12, 1, c1] + (SB*Conjugate[UCha[2, 2]]*Conjugate[
              VCha[c2, 1]] + CB*Conjugate[UCha[2, 1]]*Conjugate[VCha[c2, 2]])*
           dZfL1[12, 2, c1]) + Conjugate[UCha[c1, 2]]*
         (SB*SW*(Conjugate[VCha[1, 1]]*dZbarfR1[12, c2, 1] + 
            Conjugate[VCha[2, 1]]*dZbarfR1[12, c2, 2]) - 
          Conjugate[VCha[c2, 1]]*(SB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[3, 
                 3])) + CB*SW*dZHiggs1[3, 4])) + Conjugate[UCha[c1, 1]]*
         (CB*SW*(Conjugate[VCha[1, 2]]*dZbarfR1[12, c2, 1] + 
            Conjugate[VCha[2, 2]]*dZbarfR1[12, c2, 2]) - 
          Conjugate[VCha[c2, 2]]*(CB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[3, 
                 3])) - SB*SW*dZHiggs1[3, 4]))))/(2*Sqrt[2]*SW^2)}, 
   {(EL*(SB*UCha[c2, 2]*VCha[c1, 1] + CB*UCha[c2, 1]*VCha[c1, 2]))/
     (Sqrt[2]*SW), 
    (EL*(SW*(dZfR1[12, 1, c1]*(SB*UCha[c2, 2]*VCha[1, 1] + 
           CB*UCha[c2, 1]*VCha[1, 2]) + dZfR1[12, 2, c1]*
          (SB*UCha[c2, 2]*VCha[2, 1] + CB*UCha[c2, 1]*VCha[2, 2])) + 
       (SB*SW*(dZbarfL1[12, c2, 1]*UCha[1, 2] + dZbarfL1[12, c2, 2]*
            UCha[2, 2]) - (SB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[3, 3])) + 
           CB*SW*dZHiggs1[3, 4])*UCha[c2, 2])*VCha[c1, 1] + 
       (CB*SW*(dZbarfL1[12, c2, 1]*UCha[1, 1] + dZbarfL1[12, c2, 2]*
            UCha[2, 1]) - (CB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[3, 3])) - 
           SB*SW*dZHiggs1[3, 4])*UCha[c2, 1])*VCha[c1, 2]))/
     (2*Sqrt[2]*SW^2)}}, C[F[12, {c1}], -F[12, {c2}], S[4]] == 
  {{(EL*(CB*Conjugate[UCha[c1, 2]]*Conjugate[VCha[c2, 1]] - 
       SB*Conjugate[UCha[c1, 1]]*Conjugate[VCha[c2, 2]]))/(Sqrt[2]*SW), 
    (EL*(SW*((CB*Conjugate[UCha[1, 2]]*Conjugate[VCha[c2, 1]] - 
           SB*Conjugate[UCha[1, 1]]*Conjugate[VCha[c2, 2]])*
          dZfL1[12, 1, c1] + (CB*Conjugate[UCha[2, 2]]*Conjugate[
             VCha[c2, 1]] - SB*Conjugate[UCha[2, 1]]*Conjugate[VCha[c2, 2]])*
          dZfL1[12, 2, c1]) - Conjugate[UCha[c1, 1]]*
        (SB*SW*(Conjugate[VCha[1, 2]]*dZbarfR1[12, c2, 1] + 
           Conjugate[VCha[2, 2]]*dZbarfR1[12, c2, 2]) - 
         Conjugate[VCha[c2, 2]]*(2*dSW1*SB - SW*(CB*dZHiggs1[3, 4] + 
             SB*(2*dZe1 + dZHiggs1[4, 4])))) + Conjugate[UCha[c1, 2]]*
        (CB*SW*(Conjugate[VCha[1, 1]]*dZbarfR1[12, c2, 1] + 
           Conjugate[VCha[2, 1]]*dZbarfR1[12, c2, 2]) - 
         Conjugate[VCha[c2, 1]]*(SB*SW*dZHiggs1[3, 4] + 
           CB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[4, 4]))))))/(2*Sqrt[2]*SW^2)}, 
   {-((EL*(CB*UCha[c2, 2]*VCha[c1, 1] - SB*UCha[c2, 1]*VCha[c1, 2]))/
      (Sqrt[2]*SW)), 
    -(EL*(SW*(dZfR1[12, 1, c1]*(CB*UCha[c2, 2]*VCha[1, 1] - 
            SB*UCha[c2, 1]*VCha[1, 2]) + dZfR1[12, 2, c1]*
           (CB*UCha[c2, 2]*VCha[2, 1] - SB*UCha[c2, 1]*VCha[2, 2])) + 
        (CB*SW*(dZbarfL1[12, c2, 1]*UCha[1, 2] + dZbarfL1[12, c2, 2]*
             UCha[2, 2]) - (SB*SW*dZHiggs1[3, 4] + 
            CB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[4, 4])))*UCha[c2, 2])*
         VCha[c1, 1] - (SB*SW*(dZbarfL1[12, c2, 1]*UCha[1, 1] + 
            dZbarfL1[12, c2, 2]*UCha[2, 1]) + (CB*SW*dZHiggs1[3, 4] - 
            SB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[4, 4])))*UCha[c2, 1])*
         VCha[c1, 2]))/(2*Sqrt[2]*SW^2)}}, 
 C[F[11, {n1}], -F[12, {c2}], S[5]] == 
  {{((-I)*CB*EL*((Conjugate[VCha[c2, 2]]*((SW*Conjugate[ZNeu[n1, 1]])/CW + 
          Conjugate[ZNeu[n1, 2]]))/Sqrt[2] + Conjugate[VCha[c2, 1]]*
        Conjugate[ZNeu[n1, 4]]))/SW, 
    ((-I/4)*EL*(Sqrt[2]*Conjugate[VCha[c2, 2]]*
        (SW^2*Conjugate[ZNeu[n1, 1]]*
          (CB*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[5, 5])) + 
           CW^2*SB*dZHiggs1[6, 5]) + 
         CW^2*(CB*SW*((SW*Conjugate[ZNeu[1, 1]] + CW*Conjugate[ZNeu[1, 2]])*
              dZfL1[11, 1, n1] + (SW*Conjugate[ZNeu[2, 1]] + CW*Conjugate[
                 ZNeu[2, 2]])*dZfL1[11, 2, n1] + (SW*Conjugate[ZNeu[3, 1]] + 
               CW*Conjugate[ZNeu[3, 2]])*dZfL1[11, 3, n1] + 
             (SW*Conjugate[ZNeu[4, 1]] + CW*Conjugate[ZNeu[4, 2]])*
              dZfL1[11, 4, n1]) - CW*Conjugate[ZNeu[n1, 2]]*
            (CB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[5, 5])) - 
             SB*SW*dZHiggs1[6, 5]))) + 
       CW^2*(CB*SW*((Sqrt[2]*Conjugate[VCha[1, 2]]*(SW*Conjugate[
                 ZNeu[n1, 1]] + CW*Conjugate[ZNeu[n1, 2]]) + 
             2*CW*Conjugate[VCha[1, 1]]*Conjugate[ZNeu[n1, 4]])*
            dZbarfR1[12, c2, 1] + (Sqrt[2]*Conjugate[VCha[2, 2]]*
              (SW*Conjugate[ZNeu[n1, 1]] + CW*Conjugate[ZNeu[n1, 2]]) + 
             2*CW*Conjugate[VCha[2, 1]]*Conjugate[ZNeu[n1, 4]])*
            dZbarfR1[12, c2, 2]) + 2*CW*Conjugate[VCha[c2, 1]]*
          (CB*SW*(Conjugate[ZNeu[1, 4]]*dZfL1[11, 1, n1] + 
             Conjugate[ZNeu[2, 4]]*dZfL1[11, 2, n1] + Conjugate[ZNeu[3, 4]]*
              dZfL1[11, 3, n1] + Conjugate[ZNeu[4, 4]]*dZfL1[11, 4, n1]) - 
           Conjugate[ZNeu[n1, 4]]*(CB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[5, 
                  5])) - SB*SW*dZHiggs1[6, 5])))))/(CW^3*SW^2)}, 
   {(I*EL*SB*((UCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] - 
       UCha[c2, 1]*ZNeu[n1, 3]))/SW, 
    ((-I/2)*EL*(CB*SW*dZHiggs1[6, 5]*
        ((UCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] - 
         UCha[c2, 1]*ZNeu[n1, 3]) - 
       SB*(dSW1*(Sqrt[2]*UCha[c2, 2]*((SW^3*ZNeu[n1, 1])/CW^3 - 
             ZNeu[n1, 2]) + 2*UCha[c2, 1]*ZNeu[n1, 3]) + 
         SW*(dZfR1[11, 1, n1]*((UCha[c2, 2]*((SW*ZNeu[1, 1])/CW + 
                ZNeu[1, 2]))/Sqrt[2] - UCha[c2, 1]*ZNeu[1, 3]) + 
           dZfR1[11, 2, n1]*((UCha[c2, 2]*((SW*ZNeu[2, 1])/CW + ZNeu[2, 2]))/
              Sqrt[2] - UCha[c2, 1]*ZNeu[2, 3]) + dZfR1[11, 3, n1]*
            ((UCha[c2, 2]*((SW*ZNeu[3, 1])/CW + ZNeu[3, 2]))/Sqrt[2] - 
             UCha[c2, 1]*ZNeu[3, 3]) + dZfR1[11, 4, n1]*
            ((UCha[c2, 2]*((SW*ZNeu[4, 1])/CW + ZNeu[4, 2]))/Sqrt[2] - 
             UCha[c2, 1]*ZNeu[4, 3]) + dZbarfL1[12, c2, 1]*
            ((UCha[1, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] - 
             UCha[1, 1]*ZNeu[n1, 3]) + dZbarfL1[12, c2, 2]*
            ((UCha[2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] - 
             UCha[2, 1]*ZNeu[n1, 3]) + (2*dZe1 + dZHiggs1[5, 5])*
            ((UCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] - 
             UCha[c2, 1]*ZNeu[n1, 3])))))/SW^2}}, 
 C[F[11, {n1}], -F[12, {c2}], S[6]] == 
  {{((-I)*EL*SB*((Conjugate[VCha[c2, 2]]*((SW*Conjugate[ZNeu[n1, 1]])/CW + 
          Conjugate[ZNeu[n1, 2]]))/Sqrt[2] + Conjugate[VCha[c2, 1]]*
        Conjugate[ZNeu[n1, 4]]))/SW, 
    ((-I/4)*EL*(Sqrt[2]*Conjugate[VCha[c2, 2]]*
        (SW^2*Conjugate[ZNeu[n1, 1]]*(2*dSW1*SB*SW + 
           CW^2*(CB*dZHiggs1[5, 6] + SB*(2*dZe1 + dZHiggs1[6, 6]))) + 
         CW^2*(SB*SW*((SW*Conjugate[ZNeu[1, 1]] + CW*Conjugate[ZNeu[1, 2]])*
              dZfL1[11, 1, n1] + (SW*Conjugate[ZNeu[2, 1]] + CW*Conjugate[
                 ZNeu[2, 2]])*dZfL1[11, 2, n1] + (SW*Conjugate[ZNeu[3, 1]] + 
               CW*Conjugate[ZNeu[3, 2]])*dZfL1[11, 3, n1] + 
             (SW*Conjugate[ZNeu[4, 1]] + CW*Conjugate[ZNeu[4, 2]])*
              dZfL1[11, 4, n1]) - CW*Conjugate[ZNeu[n1, 2]]*
            (2*dSW1*SB - SW*(CB*dZHiggs1[5, 6] + SB*(2*dZe1 + dZHiggs1[6, 
                  6]))))) + 
       CW^2*(SB*SW*((Sqrt[2]*Conjugate[VCha[1, 2]]*(SW*Conjugate[
                 ZNeu[n1, 1]] + CW*Conjugate[ZNeu[n1, 2]]) + 
             2*CW*Conjugate[VCha[1, 1]]*Conjugate[ZNeu[n1, 4]])*
            dZbarfR1[12, c2, 1] + (Sqrt[2]*Conjugate[VCha[2, 2]]*
              (SW*Conjugate[ZNeu[n1, 1]] + CW*Conjugate[ZNeu[n1, 2]]) + 
             2*CW*Conjugate[VCha[2, 1]]*Conjugate[ZNeu[n1, 4]])*
            dZbarfR1[12, c2, 2]) + 2*CW*Conjugate[VCha[c2, 1]]*
          (SB*SW*(Conjugate[ZNeu[1, 4]]*dZfL1[11, 1, n1] + 
             Conjugate[ZNeu[2, 4]]*dZfL1[11, 2, n1] + Conjugate[ZNeu[3, 4]]*
              dZfL1[11, 3, n1] + Conjugate[ZNeu[4, 4]]*dZfL1[11, 4, n1]) - 
           Conjugate[ZNeu[n1, 4]]*(2*dSW1*SB - SW*(CB*dZHiggs1[5, 6] + SB*
                (2*dZe1 + dZHiggs1[6, 6])))))))/(CW^3*SW^2)}, 
   {((-I)*CB*EL*((UCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] - 
       UCha[c2, 1]*ZNeu[n1, 3]))/SW, 
    ((I/2)*EL*(SW*(SB*dZHiggs1[5, 6] - CB*dZHiggs1[6, 6])*
        ((UCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] - 
         UCha[c2, 1]*ZNeu[n1, 3]) - 
       CB*(dSW1*(Sqrt[2]*UCha[c2, 2]*((SW^3*ZNeu[n1, 1])/CW^3 - 
             ZNeu[n1, 2]) + 2*UCha[c2, 1]*ZNeu[n1, 3]) + 
         SW*(dZfR1[11, 1, n1]*((UCha[c2, 2]*((SW*ZNeu[1, 1])/CW + 
                ZNeu[1, 2]))/Sqrt[2] - UCha[c2, 1]*ZNeu[1, 3]) + 
           dZfR1[11, 2, n1]*((UCha[c2, 2]*((SW*ZNeu[2, 1])/CW + ZNeu[2, 2]))/
              Sqrt[2] - UCha[c2, 1]*ZNeu[2, 3]) + dZfR1[11, 3, n1]*
            ((UCha[c2, 2]*((SW*ZNeu[3, 1])/CW + ZNeu[3, 2]))/Sqrt[2] - 
             UCha[c2, 1]*ZNeu[3, 3]) + dZfR1[11, 4, n1]*
            ((UCha[c2, 2]*((SW*ZNeu[4, 1])/CW + ZNeu[4, 2]))/Sqrt[2] - 
             UCha[c2, 1]*ZNeu[4, 3]) + dZbarfL1[12, c2, 1]*
            ((UCha[1, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] - 
             UCha[1, 1]*ZNeu[n1, 3]) + dZbarfL1[12, c2, 2]*
            ((UCha[2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] - 
             UCha[2, 1]*ZNeu[n1, 3]) + 2*dZe1*
            ((UCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] - 
             UCha[c2, 1]*ZNeu[n1, 3])))))/SW^2}}, 
 C[F[12, {c2}], F[11, {n1}], -S[5]] == 
  {{(I*EL*SB*((Conjugate[UCha[c2, 2]]*((SW*Conjugate[ZNeu[n1, 1]])/CW + 
          Conjugate[ZNeu[n1, 2]]))/Sqrt[2] - Conjugate[UCha[c2, 1]]*
        Conjugate[ZNeu[n1, 3]]))/SW, 
    ((I/4)*EL*(Sqrt[2]*Conjugate[UCha[c2, 2]]*(SW^2*Conjugate[ZNeu[n1, 1]]*
          (2*dSW1*SB*SW + CW^2*(SB*(2*dZe1 + dZbarHiggs1[5, 5]) - 
             CB*dZHiggs1[5, 6])) + 
         CW^2*(SB*SW*((SW*Conjugate[ZNeu[1, 1]] + CW*Conjugate[ZNeu[1, 2]])*
              dZfL1[11, 1, n1] + (SW*Conjugate[ZNeu[2, 1]] + CW*Conjugate[
                 ZNeu[2, 2]])*dZfL1[11, 2, n1] + (SW*Conjugate[ZNeu[3, 1]] + 
               CW*Conjugate[ZNeu[3, 2]])*dZfL1[11, 3, n1] + 
             (SW*Conjugate[ZNeu[4, 1]] + CW*Conjugate[ZNeu[4, 2]])*
              dZfL1[11, 4, n1]) - CW*Conjugate[ZNeu[n1, 2]]*
            (2*dSW1*SB - SW*(SB*(2*dZe1 + dZbarHiggs1[5, 5]) - CB*
                dZHiggs1[5, 6])))) + 
       CW^2*(SB*SW*((Sqrt[2]*Conjugate[UCha[1, 2]]*(SW*Conjugate[
                 ZNeu[n1, 1]] + CW*Conjugate[ZNeu[n1, 2]]) - 
             2*CW*Conjugate[UCha[1, 1]]*Conjugate[ZNeu[n1, 3]])*
            dZfL1[12, 1, c2] + (Sqrt[2]*Conjugate[UCha[2, 2]]*
              (SW*Conjugate[ZNeu[n1, 1]] + CW*Conjugate[ZNeu[n1, 2]]) - 
             2*CW*Conjugate[UCha[2, 1]]*Conjugate[ZNeu[n1, 3]])*
            dZfL1[12, 2, c2]) - 2*CW*Conjugate[UCha[c2, 1]]*
          (SB*SW*(Conjugate[ZNeu[1, 3]]*dZfL1[11, 1, n1] + 
             Conjugate[ZNeu[2, 3]]*dZfL1[11, 2, n1] + Conjugate[ZNeu[3, 3]]*
              dZfL1[11, 3, n1] + Conjugate[ZNeu[4, 3]]*dZfL1[11, 4, n1]) - 
           Conjugate[ZNeu[n1, 3]]*(2*dSW1*SB - SW*(SB*(2*dZe1 + dZbarHiggs1[
                  5, 5]) - CB*dZHiggs1[5, 6]))))))/(CW^3*SW^2)}, 
   {((-I)*CB*EL*((VCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] + 
       VCha[c2, 1]*ZNeu[n1, 4]))/SW, 
    ((I/2)*EL*(CB*dSW1*(Sqrt[2]*VCha[c2, 2]*ZNeu[n1, 2] + 
         2*VCha[c2, 1]*ZNeu[n1, 4]) - 
       SW*(SB*dZHiggs1[5, 6]*((VCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + 
              ZNeu[n1, 2]))/Sqrt[2] + VCha[c2, 1]*ZNeu[n1, 4]) + 
         CB*(dZfR1[11, 1, n1]*((VCha[c2, 2]*((SW*ZNeu[1, 1])/CW + 
                ZNeu[1, 2]))/Sqrt[2] + VCha[c2, 1]*ZNeu[1, 4]) + 
           dZfR1[11, 2, n1]*((VCha[c2, 2]*((SW*ZNeu[2, 1])/CW + ZNeu[2, 2]))/
              Sqrt[2] + VCha[c2, 1]*ZNeu[2, 4]) + dZfR1[11, 3, n1]*
            ((VCha[c2, 2]*((SW*ZNeu[3, 1])/CW + ZNeu[3, 2]))/Sqrt[2] + 
             VCha[c2, 1]*ZNeu[3, 4]) + dZfR1[11, 4, n1]*
            ((VCha[c2, 2]*((SW*ZNeu[4, 1])/CW + ZNeu[4, 2]))/Sqrt[2] + 
             VCha[c2, 1]*ZNeu[4, 4]) + (Sqrt[2]*dSW1*SW^2*VCha[c2, 2]*
             ZNeu[n1, 1])/CW^3 + dZfR1[12, 1, c2]*
            ((VCha[1, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] + 
             VCha[1, 1]*ZNeu[n1, 4]) + dZfR1[12, 2, c2]*
            ((VCha[2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] + 
             VCha[2, 1]*ZNeu[n1, 4]) + (2*dZe1 + dZbarHiggs1[5, 5])*
            ((VCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] + 
             VCha[c2, 1]*ZNeu[n1, 4])))))/SW^2}}, 
 C[F[12, {c2}], F[11, {n1}], -S[6]] == 
  {{((-I)*CB*EL*((Conjugate[UCha[c2, 2]]*((SW*Conjugate[ZNeu[n1, 1]])/CW + 
          Conjugate[ZNeu[n1, 2]]))/Sqrt[2] - Conjugate[UCha[c2, 1]]*
        Conjugate[ZNeu[n1, 3]]))/SW, 
    ((-I/4)*EL*(-(Sqrt[2]*Conjugate[UCha[c2, 2]]*
         (SW^2*Conjugate[ZNeu[n1, 1]]*(CW^2*SB*dZHiggs1[6, 5] - 
            CB*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[6, 6]))) - 
          CW^2*(CB*SW*((SW*Conjugate[ZNeu[1, 1]] + CW*Conjugate[ZNeu[1, 2]])*
               dZfL1[11, 1, n1] + (SW*Conjugate[ZNeu[2, 1]] + 
                CW*Conjugate[ZNeu[2, 2]])*dZfL1[11, 2, n1] + 
              (SW*Conjugate[ZNeu[3, 1]] + CW*Conjugate[ZNeu[3, 2]])*dZfL1[11, 
                3, n1] + (SW*Conjugate[ZNeu[4, 1]] + CW*Conjugate[
                  ZNeu[4, 2]])*dZfL1[11, 4, n1]) - CW*Conjugate[ZNeu[n1, 2]]*
             (SB*SW*dZHiggs1[6, 5] + CB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[6, 
                   6])))))) + 
       CW^2*(CB*SW*((Sqrt[2]*Conjugate[UCha[1, 2]]*(SW*Conjugate[
                 ZNeu[n1, 1]] + CW*Conjugate[ZNeu[n1, 2]]) - 
             2*CW*Conjugate[UCha[1, 1]]*Conjugate[ZNeu[n1, 3]])*
            dZfL1[12, 1, c2] + (Sqrt[2]*Conjugate[UCha[2, 2]]*
              (SW*Conjugate[ZNeu[n1, 1]] + CW*Conjugate[ZNeu[n1, 2]]) - 
             2*CW*Conjugate[UCha[2, 1]]*Conjugate[ZNeu[n1, 3]])*
            dZfL1[12, 2, c2]) - 2*CW*Conjugate[UCha[c2, 1]]*
          (CB*SW*(Conjugate[ZNeu[1, 3]]*dZfL1[11, 1, n1] + 
             Conjugate[ZNeu[2, 3]]*dZfL1[11, 2, n1] + Conjugate[ZNeu[3, 3]]*
              dZfL1[11, 3, n1] + Conjugate[ZNeu[4, 3]]*dZfL1[11, 4, n1]) - 
           Conjugate[ZNeu[n1, 3]]*(SB*SW*dZHiggs1[6, 5] + 
             CB*(2*dSW1 - SW*(2*dZe1 + dZHiggs1[6, 6])))))))/(CW^3*SW^2)}, 
   {((-I)*EL*SB*((VCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] + 
       VCha[c2, 1]*ZNeu[n1, 4]))/SW, 
    ((I/2)*EL*(dSW1*SB*(Sqrt[2]*VCha[c2, 2]*ZNeu[n1, 2] + 
         2*VCha[c2, 1]*ZNeu[n1, 4]) - 
       SW*((CB*dZHiggs1[6, 5] + SB*dZHiggs1[6, 6])*
          ((VCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] + 
           VCha[c2, 1]*ZNeu[n1, 4]) + 
         SB*(dZfR1[11, 1, n1]*((VCha[c2, 2]*((SW*ZNeu[1, 1])/CW + 
                ZNeu[1, 2]))/Sqrt[2] + VCha[c2, 1]*ZNeu[1, 4]) + 
           dZfR1[11, 2, n1]*((VCha[c2, 2]*((SW*ZNeu[2, 1])/CW + ZNeu[2, 2]))/
              Sqrt[2] + VCha[c2, 1]*ZNeu[2, 4]) + dZfR1[11, 3, n1]*
            ((VCha[c2, 2]*((SW*ZNeu[3, 1])/CW + ZNeu[3, 2]))/Sqrt[2] + 
             VCha[c2, 1]*ZNeu[3, 4]) + dZfR1[11, 4, n1]*
            ((VCha[c2, 2]*((SW*ZNeu[4, 1])/CW + ZNeu[4, 2]))/Sqrt[2] + 
             VCha[c2, 1]*ZNeu[4, 4]) + (Sqrt[2]*dSW1*SW^2*VCha[c2, 2]*
             ZNeu[n1, 1])/CW^3 + dZfR1[12, 1, c2]*
            ((VCha[1, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] + 
             VCha[1, 1]*ZNeu[n1, 4]) + dZfR1[12, 2, c2]*
            ((VCha[2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] + 
             VCha[2, 1]*ZNeu[n1, 4]) + 2*dZe1*
            ((VCha[c2, 2]*((SW*ZNeu[n1, 1])/CW + ZNeu[n1, 2]))/Sqrt[2] + 
             VCha[c2, 1]*ZNeu[n1, 4])))))/SW^2}}, 
 C[F[11, {n1}], -F[1, {j1}], S[11, {j2}]] == 
  {{0, 0}, {(I*EL*IndexDelta[j1, j2]*(SW*ZNeu[n1, 1] - CW*ZNeu[n1, 2]))/
     (Sqrt[2]*CW*SW), ((I/2)*EL*IndexDelta[j1, j2]*
      (SW*(CW^2*(dZfR1[11, 1, n1]*(SW*ZNeu[1, 1] - CW*ZNeu[1, 2]) + 
           dZfR1[11, 2, n1]*(SW*ZNeu[2, 1] - CW*ZNeu[2, 2]) + 
           dZfR1[11, 3, n1]*(SW*ZNeu[3, 1] - CW*ZNeu[3, 2]) + 
           dZfR1[11, 4, n1]*(SW*ZNeu[4, 1] - CW*ZNeu[4, 2])) + 
         SW*(2*(CW^2*dZe1 + dSW1*SW) + CW^2*(dZbarfL1[1, j1, j1] + 
             dZSf1[1, 1, 1, j2]))*ZNeu[n1, 1]) + 
       CW^3*(2*dSW1 - SW*(2*dZe1 + dZbarfL1[1, j1, j1] + dZSf1[1, 1, 1, j2]))*
        ZNeu[n1, 2]))/(Sqrt[2]*CW^3*SW^2)}}, 
 C[F[11, {n1}], -F[2, {j1}], S[12, {s2, j2}]] == 
  {{((-I)*EL*IndexDelta[j1, j2]*(2*CB*MW*SW*Conjugate[ZNeu[n1, 1]]*
        Conjugate[USf[2, j1][s2, 2]] + CW*Conjugate[ZNeu[n1, 3]]*
        Conjugate[USf[2, j1][s2, 1]]*Mass[F[2, {j1}]]))/
     (Sqrt[2]*CB*CW*MW*SW), ((-I/2)*EL*IndexDelta[j1, j2]*
      (2*CB^2*MW^3*SW^2*Conjugate[ZNeu[n1, 1]]*
        (Conjugate[USf[2, j1][s2, 2]]*(2*dSW1*SW + 
           CW^2*(2*dZe1 + dZbarfR1[2, j1, j1])) + 
         CW^2*(Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s2, 2, j2])) + 
       CW^2*(CB*MW^2*SW*(2*CB*MW*SW*Conjugate[USf[2, j1][s2, 2]]*
            (Conjugate[ZNeu[1, 1]]*dZfL1[11, 1, n1] + Conjugate[ZNeu[2, 1]]*
              dZfL1[11, 2, n1] + Conjugate[ZNeu[3, 1]]*dZfL1[11, 3, n1] + 
             Conjugate[ZNeu[4, 1]]*dZfL1[11, 4, n1]) + 
           CW*Conjugate[USf[2, j1][s2, 1]]*(Conjugate[ZNeu[1, 3]]*
              dZfL1[11, 1, n1] + Conjugate[ZNeu[2, 3]]*dZfL1[11, 2, n1] + 
             Conjugate[ZNeu[3, 3]]*dZfL1[11, 3, n1] + Conjugate[ZNeu[4, 3]]*
              dZfL1[11, 4, n1])*Mass[F[2, {j1}]]) + CW*Conjugate[ZNeu[n1, 3]]*
          (CB*MW^2*SW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
             Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
            Mass[F[2, {j1}]] + Conjugate[USf[2, j1][s2, 1]]*
            (2*CB*MW^2*SW*dMf1[2, j1] - (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*
                SW*(2*dCB1 - CB*(2*dZe1 + dZbarfR1[2, j1, j1])))*
              Mass[F[2, {j1}]])))))/(Sqrt[2]*CB^2*CW^3*MW^3*SW^2)}, 
   {(I*EL*IndexDelta[j1, j2]*(CB*MW*Conjugate[USf[2, j1][s2, 1]]*
        (SW*ZNeu[n1, 1] + CW*ZNeu[n1, 2]) - CW*Conjugate[USf[2, j1][s2, 2]]*
        Mass[F[2, {j1}]]*ZNeu[n1, 3]))/(Sqrt[2]*CB*CW*MW*SW), 
    ((I/2)*EL*IndexDelta[j1, j2]*(CB^2*MW^3*Conjugate[USf[2, j1][s2, 1]]*
        (SW*(CW^3*dZfR1[11, 3, n1]*ZNeu[3, 2] + 
           CW^2*(dZfR1[11, 1, n1]*(SW*ZNeu[1, 1] + CW*ZNeu[1, 2]) + 
             dZfR1[11, 2, n1]*(SW*ZNeu[2, 1] + CW*ZNeu[2, 2]) + 
             SW*dZfR1[11, 3, n1]*ZNeu[3, 1] + dZfR1[11, 4, n1]*
              (SW*ZNeu[4, 1] + CW*ZNeu[4, 2]))) + 
         SW^2*(2*dSW1*SW + CW^2*(2*dZe1 + dZbarfL1[2, j1, j1]))*ZNeu[n1, 1] - 
         CW^3*(2*dSW1 - SW*(2*dZe1 + dZbarfL1[2, j1, j1]))*ZNeu[n1, 2]) + 
       CW^2*(CB*MW^2*SW*(CB*MW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, 
               j2] + Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
            (SW*ZNeu[n1, 1] + CW*ZNeu[n1, 2]) - 
           CW*(Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s2, 2, j2] + 
             Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s2, 2, j2])*
            Mass[F[2, {j1}]]*ZNeu[n1, 3]) + CW*Conjugate[USf[2, j1][s2, 2]]*
          (MW^2*SW*(2*dCB1 - CB*(2*dZe1 + dZbarfL1[2, j1, j1]))*
            Mass[F[2, {j1}]]*ZNeu[n1, 3] + CB*(dMWsq1*SW*Mass[F[2, {j1}]]*
              ZNeu[n1, 3] + MW^2*(2*dSW1*Mass[F[2, {j1}]]*ZNeu[n1, 3] - SW*
                (Mass[F[2, {j1}]]*(dZfR1[11, 1, n1]*ZNeu[1, 3] + 
                   dZfR1[11, 2, n1]*ZNeu[2, 3] + dZfR1[11, 3, n1]*ZNeu[3, 
                     3] + dZfR1[11, 4, n1]*ZNeu[4, 3]) + 2*dMf1[2, j1]*
                  ZNeu[n1, 3])))))))/(Sqrt[2]*CB^2*CW^3*MW^3*SW^2)}}, 
 C[F[11, {n1}], -F[3, {j1, o1}], S[13, {s2, j2, o2}]] == 
  {{((I/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (4*MW*SB*SW*Conjugate[ZNeu[n1, 1]]*Conjugate[USf[3, j1][s2, 2]] - 
       3*CW*Conjugate[ZNeu[n1, 4]]*Conjugate[USf[3, j1][s2, 1]]*
        Mass[F[3, {j1, o1}]]))/(Sqrt[2]*CW*MW*SB*SW), 
    ((I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (4*MW^3*SB^2*SW^2*Conjugate[ZNeu[n1, 1]]*
        (Conjugate[USf[3, j1][s2, 2]]*(2*dSW1*SW + 
           CW^2*(2*dZe1 + dZbarfR1[3, j1, j1])) + 
         CW^2*(Conjugate[USf[3, j1][1, 2]]*dZSf1[1, s2, 3, j2] + 
           Conjugate[USf[3, j1][2, 2]]*dZSf1[2, s2, 3, j2])) + 
       CW^2*(MW^2*SB*SW*(4*MW*SB*SW*Conjugate[USf[3, j1][s2, 2]]*
            (Conjugate[ZNeu[1, 1]]*dZfL1[11, 1, n1] + Conjugate[ZNeu[2, 1]]*
              dZfL1[11, 2, n1] + Conjugate[ZNeu[3, 1]]*dZfL1[11, 3, n1] + 
             Conjugate[ZNeu[4, 1]]*dZfL1[11, 4, n1]) - 
           3*CW*Conjugate[USf[3, j1][s2, 1]]*(Conjugate[ZNeu[1, 4]]*
              dZfL1[11, 1, n1] + Conjugate[ZNeu[2, 4]]*dZfL1[11, 2, n1] + 
             Conjugate[ZNeu[3, 4]]*dZfL1[11, 3, n1] + Conjugate[ZNeu[4, 4]]*
              dZfL1[11, 4, n1])*Mass[F[3, {j1, o1}]]) - 
         3*CW*Conjugate[ZNeu[n1, 4]]*(MW^2*SB*SW*(Conjugate[USf[3, j1][1, 1]]*
              dZSf1[1, s2, 3, j2] + Conjugate[USf[3, j1][2, 1]]*
              dZSf1[2, s2, 3, j2])*Mass[F[3, {j1, o1}]] + 
           Conjugate[USf[3, j1][s2, 1]]*(2*MW^2*SB*SW*dMf1[3, j1] - 
             (2*MW^2*(dSW1*SB + dSB1*SW) + SB*SW*(dMWsq1 - MW^2*(2*dZe1 + 
                   dZbarfR1[3, j1, j1])))*Mass[F[3, {j1, o1}]])))))/
     (Sqrt[2]*CW^3*MW^3*SB^2*SW^2)}, 
   {((-I/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (MW*SB*Conjugate[USf[3, j1][s2, 1]]*(SW*ZNeu[n1, 1] + 
         3*CW*ZNeu[n1, 2]) + 3*CW*Conjugate[USf[3, j1][s2, 2]]*
        Mass[F[3, {j1, o1}]]*ZNeu[n1, 4]))/(Sqrt[2]*CW*MW*SB*SW), 
    ((-I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (MW^3*SB^2*Conjugate[USf[3, j1][s2, 1]]*
        (SW*(3*CW^3*dZfR1[11, 3, n1]*ZNeu[3, 2] + 
           CW^2*(dZfR1[11, 1, n1]*(SW*ZNeu[1, 1] + 3*CW*ZNeu[1, 2]) + 
             dZfR1[11, 2, n1]*(SW*ZNeu[2, 1] + 3*CW*ZNeu[2, 2]) + 
             SW*dZfR1[11, 3, n1]*ZNeu[3, 1] + dZfR1[11, 4, n1]*
              (SW*ZNeu[4, 1] + 3*CW*ZNeu[4, 2]))) + 
         SW^2*(2*dSW1*SW + CW^2*(2*dZe1 + dZbarfL1[3, j1, j1]))*ZNeu[n1, 1] - 
         CW^3*(6*dSW1 - SW*(6*dZe1 + 3*dZbarfL1[3, j1, j1]))*ZNeu[n1, 2]) + 
       CW^2*(MW^2*SB*SW*(MW*SB*(Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s2, 3, 
               j2] + Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s2, 3, j2])*
            (SW*ZNeu[n1, 1] + 3*CW*ZNeu[n1, 2]) + 
           3*CW*(Conjugate[USf[3, j1][1, 2]]*dZSf1[1, s2, 3, j2] + 
             Conjugate[USf[3, j1][2, 2]]*dZSf1[2, s2, 3, j2])*
            Mass[F[3, {j1, o1}]]*ZNeu[n1, 4]) - 
         3*CW*Conjugate[USf[3, j1][s2, 2]]*
          (SB*SW*(dMWsq1 - MW^2*(2*dZe1 + dZbarfL1[3, j1, j1]))*
            Mass[F[3, {j1, o1}]]*ZNeu[n1, 4] + 
           MW^2*(2*dSB1*SW*Mass[F[3, {j1, o1}]]*ZNeu[n1, 4] + 
             SB*(2*dSW1*Mass[F[3, {j1, o1}]]*ZNeu[n1, 4] - SW*
                (Mass[F[3, {j1, o1}]]*(dZfR1[11, 1, n1]*ZNeu[1, 4] + 
                   dZfR1[11, 2, n1]*ZNeu[2, 4] + dZfR1[11, 3, n1]*ZNeu[3, 
                     4] + dZfR1[11, 4, n1]*ZNeu[4, 4]) + 2*dMf1[3, j1]*
                  ZNeu[n1, 4])))))))/(Sqrt[2]*CW^3*MW^3*SB^2*SW^2)}}, 
 C[F[11, {n1}], -F[4, {j1, o1}], S[14, {s2, j2, o2}]] == 
  {{((-I/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CB*MW*SW*Conjugate[ZNeu[n1, 1]]*Conjugate[USf[4, j1][s2, 2]] + 
       3*CW*Conjugate[ZNeu[n1, 3]]*Conjugate[USf[4, j1][s2, 1]]*
        Mass[F[4, {j1, o1}]]))/(Sqrt[2]*CB*CW*MW*SW), 
    ((-I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CB^2*MW^3*SW^2*Conjugate[ZNeu[n1, 1]]*
        (Conjugate[USf[4, j1][s2, 2]]*(2*dSW1*SW + 
           CW^2*(2*dZe1 + dZbarfR1[4, j1, j1])) + 
         CW^2*(Conjugate[USf[4, j1][1, 2]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j1][2, 2]]*dZSf1[2, s2, 4, j2])) + 
       CW^2*(CB*MW^2*SW*(2*CB*MW*SW*Conjugate[USf[4, j1][s2, 2]]*
            (Conjugate[ZNeu[1, 1]]*dZfL1[11, 1, n1] + Conjugate[ZNeu[2, 1]]*
              dZfL1[11, 2, n1] + Conjugate[ZNeu[3, 1]]*dZfL1[11, 3, n1] + 
             Conjugate[ZNeu[4, 1]]*dZfL1[11, 4, n1]) + 
           3*CW*Conjugate[USf[4, j1][s2, 1]]*(Conjugate[ZNeu[1, 3]]*
              dZfL1[11, 1, n1] + Conjugate[ZNeu[2, 3]]*dZfL1[11, 2, n1] + 
             Conjugate[ZNeu[3, 3]]*dZfL1[11, 3, n1] + Conjugate[ZNeu[4, 3]]*
              dZfL1[11, 4, n1])*Mass[F[4, {j1, o1}]]) + 
         3*CW*Conjugate[ZNeu[n1, 3]]*(CB*MW^2*SW*(Conjugate[USf[4, j1][1, 1]]*
              dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j1][2, 1]]*
              dZSf1[2, s2, 4, j2])*Mass[F[4, {j1, o1}]] + 
           Conjugate[USf[4, j1][s2, 1]]*(2*CB*MW^2*SW*dMf1[4, j1] - 
             (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 - 
                 CB*(2*dZe1 + dZbarfR1[4, j1, j1])))*Mass[F[4, 
                {j1, o1}]])))))/(Sqrt[2]*CB^2*CW^3*MW^3*SW^2)}, 
   {((-I/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (CB*MW*Conjugate[USf[4, j1][s2, 1]]*(SW*ZNeu[n1, 1] - 
         3*CW*ZNeu[n1, 2]) + 3*CW*Conjugate[USf[4, j1][s2, 2]]*
        Mass[F[4, {j1, o1}]]*ZNeu[n1, 3]))/(Sqrt[2]*CB*CW*MW*SW), 
    ((I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (CB^2*MW^3*Conjugate[USf[4, j1][s2, 1]]*
        (SW*(3*CW^3*dZfR1[11, 3, n1]*ZNeu[3, 2] - 
           CW^2*(dZfR1[11, 1, n1]*(SW*ZNeu[1, 1] - 3*CW*ZNeu[1, 2]) + 
             dZfR1[11, 2, n1]*(SW*ZNeu[2, 1] - 3*CW*ZNeu[2, 2]) + 
             SW*dZfR1[11, 3, n1]*ZNeu[3, 1] + dZfR1[11, 4, n1]*
              (SW*ZNeu[4, 1] - 3*CW*ZNeu[4, 2]))) - 
         SW^2*(2*dSW1*SW + CW^2*(2*dZe1 + dZbarfL1[4, j1, j1]))*ZNeu[n1, 1] - 
         3*CW^3*(2*dSW1 - SW*(2*dZe1 + dZbarfL1[4, j1, j1]))*ZNeu[n1, 2]) - 
       CW^2*(CB*MW^2*SW*(CB*MW*(Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s2, 4, 
               j2] + Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s2, 4, j2])*
            (SW*ZNeu[n1, 1] - 3*CW*ZNeu[n1, 2]) + 
           3*CW*(Conjugate[USf[4, j1][1, 2]]*dZSf1[1, s2, 4, j2] + 
             Conjugate[USf[4, j1][2, 2]]*dZSf1[2, s2, 4, j2])*
            Mass[F[4, {j1, o1}]]*ZNeu[n1, 3]) - 
         3*CW*Conjugate[USf[4, j1][s2, 2]]*
          (MW^2*SW*(2*dCB1 - CB*(2*dZe1 + dZbarfL1[4, j1, j1]))*
            Mass[F[4, {j1, o1}]]*ZNeu[n1, 3] + 
           CB*(dMWsq1*SW*Mass[F[4, {j1, o1}]]*ZNeu[n1, 3] + 
             MW^2*(2*dSW1*Mass[F[4, {j1, o1}]]*ZNeu[n1, 3] - SW*
                (Mass[F[4, {j1, o1}]]*(dZfR1[11, 1, n1]*ZNeu[1, 3] + 
                   dZfR1[11, 2, n1]*ZNeu[2, 3] + dZfR1[11, 3, n1]*ZNeu[3, 
                     3] + dZfR1[11, 4, n1]*ZNeu[4, 3]) + 2*dMf1[4, j1]*
                  ZNeu[n1, 3])))))))/(Sqrt[2]*CB^2*CW^3*MW^3*SW^2)}}, 
 C[F[1, {j1}], F[11, {n1}], -S[11, {j2}]] == 
  {{(I*EL*(SW*Conjugate[ZNeu[n1, 1]] - CW*Conjugate[ZNeu[n1, 2]])*
      IndexDelta[j1, j2])/(Sqrt[2]*CW*SW), 
    ((I/2)*EL*(SW^2*Conjugate[ZNeu[n1, 1]]*(2*(CW^2*dZe1 + dSW1*SW) + 
         CW^2*(dZbarSf1[1, 1, 1, j2] + dZfL1[1, j1, j1])) + 
       CW^2*(CW*Conjugate[ZNeu[n1, 2]]*(2*(dSW1 - dZe1*SW) - 
           SW*(dZbarSf1[1, 1, 1, j2] + dZfL1[1, j1, j1])) + 
         SW*((SW*Conjugate[ZNeu[1, 1]] - CW*Conjugate[ZNeu[1, 2]])*
            dZfL1[11, 1, n1] + (SW*Conjugate[ZNeu[2, 1]] - 
             CW*Conjugate[ZNeu[2, 2]])*dZfL1[11, 2, n1] + 
           (SW*Conjugate[ZNeu[3, 1]] - CW*Conjugate[ZNeu[3, 2]])*
            dZfL1[11, 3, n1] + (SW*Conjugate[ZNeu[4, 1]] - 
             CW*Conjugate[ZNeu[4, 2]])*dZfL1[11, 4, n1])))*
      IndexDelta[j1, j2])/(Sqrt[2]*CW^3*SW^2)}, {0, 0}}, 
 C[F[2, {j1}], F[11, {n1}], -S[12, {s2, j2}]] == 
  {{(I*EL*IndexDelta[j1, j2]*(CB*MW*(SW*Conjugate[ZNeu[n1, 1]] + 
         CW*Conjugate[ZNeu[n1, 2]])*USf[2, j1][s2, 1] - 
       CW*Conjugate[ZNeu[n1, 3]]*Mass[F[2, {j1}]]*USf[2, j1][s2, 2]))/
     (Sqrt[2]*CB*CW*MW*SW), ((I/2)*EL*IndexDelta[j1, j2]*
      (CB^2*MW^3*SW^2*Conjugate[ZNeu[n1, 1]]*
        (CW^2*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
           dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) + 
         (2*dSW1*SW + CW^2*(2*dZe1 + dZfL1[2, j1, j1]))*USf[2, j1][s2, 1]) + 
       CW^2*(CB*MW^2*SW*(CB*MW*((SW*Conjugate[ZNeu[1, 1]] + CW*Conjugate[
                 ZNeu[1, 2]])*dZfL1[11, 1, n1] + (SW*Conjugate[ZNeu[2, 1]] + 
               CW*Conjugate[ZNeu[2, 2]])*dZfL1[11, 2, n1] + 
             (SW*Conjugate[ZNeu[3, 1]] + CW*Conjugate[ZNeu[3, 2]])*
              dZfL1[11, 3, n1] + (SW*Conjugate[ZNeu[4, 1]] + CW*Conjugate[
                 ZNeu[4, 2]])*dZfL1[11, 4, n1])*USf[2, j1][s2, 1] - 
           CW*(Conjugate[ZNeu[1, 3]]*dZfL1[11, 1, n1] + Conjugate[ZNeu[2, 3]]*
              dZfL1[11, 2, n1] + Conjugate[ZNeu[3, 3]]*dZfL1[11, 3, n1] + 
             Conjugate[ZNeu[4, 3]]*dZfL1[11, 4, n1])*Mass[F[2, {j1}]]*
            USf[2, j1][s2, 2]) + CW*(CB^2*MW^3*Conjugate[ZNeu[n1, 2]]*
            (SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, 
                 j2]*USf[2, j1][2, 1]) - (2*dSW1 - SW*(2*dZe1 + dZfL1[2, j1, 
                  j1]))*USf[2, j1][s2, 1]) - Conjugate[ZNeu[n1, 3]]*
            (CB*MW^2*SW*Mass[F[2, {j1}]]*(dZbarSf1[1, s2, 2, j2]*
                USf[2, j1][1, 2] + dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 2]) + 
             (2*CB*MW^2*SW*dMf1[2, j1] - (CB*(2*dSW1*MW^2 + dMWsq1*SW) + 
                 MW^2*SW*(2*dCB1 - CB*(2*dZe1 + dZfL1[2, j1, j1])))*
                Mass[F[2, {j1}]])*USf[2, j1][s2, 2])))))/
     (Sqrt[2]*CB^2*CW^3*MW^3*SW^2)}, 
   {((-I)*EL*IndexDelta[j1, j2]*(CW*Mass[F[2, {j1}]]*ZNeu[n1, 3]*
        USf[2, j1][s2, 1] + 2*CB*MW*SW*ZNeu[n1, 1]*USf[2, j1][s2, 2]))/
     (Sqrt[2]*CB*CW*MW*SW), ((I/2)*EL*IndexDelta[j1, j2]*
      (CW^3*MW^2*SW*(2*dCB1 - CB*(2*dZe1 + dZfR1[2, j1, j1]))*
        Mass[F[2, {j1}]]*ZNeu[n1, 3]*USf[2, j1][s2, 1] - 
       CB*CW^2*(MW^2*SW*(dZbarSf1[1, s2, 2, j2]*(CW*Mass[F[2, {j1}]]*
              ZNeu[n1, 3]*USf[2, j1][1, 1] + 2*CB*MW*SW*ZNeu[n1, 1]*
              USf[2, j1][1, 2]) + dZbarSf1[2, s2, 2, j2]*
            (CW*Mass[F[2, {j1}]]*ZNeu[n1, 3]*USf[2, j1][2, 1] + 
             2*CB*MW*SW*ZNeu[n1, 1]*USf[2, j1][2, 2])) - 
         CW*(dMWsq1*SW*Mass[F[2, {j1}]]*ZNeu[n1, 3] + 
           MW^2*(2*dSW1*Mass[F[2, {j1}]]*ZNeu[n1, 3] - 
             SW*(Mass[F[2, {j1}]]*(dZfR1[11, 1, n1]*ZNeu[1, 3] + 
                 dZfR1[11, 2, n1]*ZNeu[2, 3] + dZfR1[11, 3, n1]*ZNeu[3, 3] + 
                 dZfR1[11, 4, n1]*ZNeu[4, 3]) + 2*dMf1[2, j1]*ZNeu[n1, 3])))*
          USf[2, j1][s2, 1]) - 2*CB^2*MW^3*SW^2*
        (CW^2*(dZfR1[11, 1, n1]*ZNeu[1, 1] + dZfR1[11, 2, n1]*ZNeu[2, 1] + 
           dZfR1[11, 3, n1]*ZNeu[3, 1] + dZfR1[11, 4, n1]*ZNeu[4, 1]) + 
         (2*dSW1*SW + CW^2*(2*dZe1 + dZfR1[2, j1, j1]))*ZNeu[n1, 1])*
        USf[2, j1][s2, 2]))/(Sqrt[2]*CB^2*CW^3*MW^3*SW^2)}}, 
 C[F[3, {j1, o1}], F[11, {n1}], -S[13, {s2, j2, o2}]] == 
  {{((-I/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (MW*SB*SW*Conjugate[ZNeu[n1, 1]]*USf[3, j1][s2, 1] + 
       3*CW*(MW*SB*Conjugate[ZNeu[n1, 2]]*USf[3, j1][s2, 1] + 
         Conjugate[ZNeu[n1, 4]]*Mass[F[3, {j1, o1}]]*USf[3, j1][s2, 2])))/
     (Sqrt[2]*CW*MW*SB*SW), ((-I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (MW^3*SB^2*SW^2*Conjugate[ZNeu[n1, 1]]*
        (CW^2*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 1] + 
           dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 1]) + 
         (2*dSW1*SW + CW^2*(2*dZe1 + dZfL1[3, j1, j1]))*USf[3, j1][s2, 1]) + 
       CW^2*(MW^2*SB*SW*(MW*SB*((SW*Conjugate[ZNeu[1, 1]] + 3*CW*
                Conjugate[ZNeu[1, 2]])*dZfL1[11, 1, n1] + 
             (SW*Conjugate[ZNeu[2, 1]] + 3*CW*Conjugate[ZNeu[2, 2]])*
              dZfL1[11, 2, n1] + (SW*Conjugate[ZNeu[3, 1]] + 3*CW*
                Conjugate[ZNeu[3, 2]])*dZfL1[11, 3, n1] + 
             (SW*Conjugate[ZNeu[4, 1]] + 3*CW*Conjugate[ZNeu[4, 2]])*
              dZfL1[11, 4, n1])*USf[3, j1][s2, 1] + 
           3*CW*(Conjugate[ZNeu[1, 4]]*dZfL1[11, 1, n1] + 
             Conjugate[ZNeu[2, 4]]*dZfL1[11, 2, n1] + Conjugate[ZNeu[3, 4]]*
              dZfL1[11, 3, n1] + Conjugate[ZNeu[4, 4]]*dZfL1[11, 4, n1])*
            Mass[F[3, {j1, o1}]]*USf[3, j1][s2, 2]) + 
         3*CW*(MW^3*SB^2*Conjugate[ZNeu[n1, 2]]*
            (SW*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 1] + dZbarSf1[2, s2, 3, 
                 j2]*USf[3, j1][2, 1]) - (2*dSW1 - SW*(2*dZe1 + dZfL1[3, j1, 
                  j1]))*USf[3, j1][s2, 1]) + Conjugate[ZNeu[n1, 4]]*
            (MW^2*SB*SW*Mass[F[3, {j1, o1}]]*(dZbarSf1[1, s2, 3, j2]*
                USf[3, j1][1, 2] + dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 2]) + 
             (2*MW^2*SB*SW*dMf1[3, j1] - (2*MW^2*(dSW1*SB + dSB1*SW) + 
                 SB*SW*(dMWsq1 - MW^2*(2*dZe1 + dZfL1[3, j1, j1])))*
                Mass[F[3, {j1, o1}]])*USf[3, j1][s2, 2])))))/
     (Sqrt[2]*CW^3*MW^3*SB^2*SW^2)}, 
   {((-I/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (3*CW*Mass[F[3, {j1, o1}]]*ZNeu[n1, 4]*USf[3, j1][s2, 1] - 
       4*MW*SB*SW*ZNeu[n1, 1]*USf[3, j1][s2, 2]))/(Sqrt[2]*CW*MW*SB*SW), 
    ((-I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (CW^2*MW^2*SB*SW*(dZbarSf1[1, s2, 3, j2]*(3*CW*Mass[F[3, {j1, o1}]]*
            ZNeu[n1, 4]*USf[3, j1][1, 1] - 4*MW*SB*SW*ZNeu[n1, 1]*
            USf[3, j1][1, 2]) + dZbarSf1[2, s2, 3, j2]*
          (3*CW*Mass[F[3, {j1, o1}]]*ZNeu[n1, 4]*USf[3, j1][2, 1] - 
           4*MW*SB*SW*ZNeu[n1, 1]*USf[3, j1][2, 2])) - 
       CW^3*(SB*SW*(3*dMWsq1 - 3*MW^2*(2*dZe1 + dZfR1[3, j1, j1]))*
          Mass[F[3, {j1, o1}]]*ZNeu[n1, 4] - 
         MW^2*(3*SB*SW*Mass[F[3, {j1, o1}]]*(dZfR1[11, 1, n1]*ZNeu[1, 4] + 
             dZfR1[11, 2, n1]*ZNeu[2, 4] + dZfR1[11, 3, n1]*ZNeu[3, 4] + 
             dZfR1[11, 4, n1]*ZNeu[4, 4]) + 6*(SB*SW*dMf1[3, j1] - 
             (dSW1*SB + dSB1*SW)*Mass[F[3, {j1, o1}]])*ZNeu[n1, 4]))*
        USf[3, j1][s2, 1] - 4*MW^3*SB^2*SW^2*
        ((2*dSW1*SW + CW^2*dZfR1[3, j1, j1])*ZNeu[n1, 1] + 
         CW^2*(dZfR1[11, 1, n1]*ZNeu[1, 1] + dZfR1[11, 2, n1]*ZNeu[2, 1] + 
           dZfR1[11, 3, n1]*ZNeu[3, 1] + dZfR1[11, 4, n1]*ZNeu[4, 1] + 
           2*dZe1*ZNeu[n1, 1]))*USf[3, j1][s2, 2]))/
     (Sqrt[2]*CW^3*MW^3*SB^2*SW^2)}}, 
 C[F[4, {j1, o1}], F[11, {n1}], -S[14, {s2, j2, o2}]] == 
  {{((-I/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (CB*MW*(SW*Conjugate[ZNeu[n1, 1]] - 3*CW*Conjugate[ZNeu[n1, 2]])*
        USf[4, j1][s2, 1] + 3*CW*Conjugate[ZNeu[n1, 3]]*Mass[F[4, {j1, o1}]]*
        USf[4, j1][s2, 2]))/(Sqrt[2]*CB*CW*MW*SW), 
    ((-I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (CB^2*MW^3*SW^2*Conjugate[ZNeu[n1, 1]]*
        (CW^2*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 1] + 
           dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 1]) + 
         (2*dSW1*SW + CW^2*(2*dZe1 + dZfL1[4, j1, j1]))*USf[4, j1][s2, 1]) + 
       CW^2*(CB*MW^2*SW*(CB*MW*((SW*Conjugate[ZNeu[1, 1]] - 3*CW*
                Conjugate[ZNeu[1, 2]])*dZfL1[11, 1, n1] + 
             (SW*Conjugate[ZNeu[2, 1]] - 3*CW*Conjugate[ZNeu[2, 2]])*
              dZfL1[11, 2, n1] + (SW*Conjugate[ZNeu[3, 1]] - 3*CW*
                Conjugate[ZNeu[3, 2]])*dZfL1[11, 3, n1] + 
             (SW*Conjugate[ZNeu[4, 1]] - 3*CW*Conjugate[ZNeu[4, 2]])*
              dZfL1[11, 4, n1])*USf[4, j1][s2, 1] + 
           3*CW*(Conjugate[ZNeu[1, 3]]*dZfL1[11, 1, n1] + 
             Conjugate[ZNeu[2, 3]]*dZfL1[11, 2, n1] + Conjugate[ZNeu[3, 3]]*
              dZfL1[11, 3, n1] + Conjugate[ZNeu[4, 3]]*dZfL1[11, 4, n1])*
            Mass[F[4, {j1, o1}]]*USf[4, j1][s2, 2]) - 
         CW*(3*CB^2*MW^3*Conjugate[ZNeu[n1, 2]]*
            (SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 1] + dZbarSf1[2, s2, 4, 
                 j2]*USf[4, j1][2, 1]) - (2*dSW1 - SW*(2*dZe1 + dZfL1[4, j1, 
                  j1]))*USf[4, j1][s2, 1]) - 3*Conjugate[ZNeu[n1, 3]]*
            (CB*MW^2*SW*Mass[F[4, {j1, o1}]]*(dZbarSf1[1, s2, 4, j2]*
                USf[4, j1][1, 2] + dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 2]) + 
             (2*CB*MW^2*SW*dMf1[4, j1] - (CB*(2*dSW1*MW^2 + dMWsq1*SW) + 
                 MW^2*SW*(2*dCB1 - CB*(2*dZe1 + dZfL1[4, j1, j1])))*
                Mass[F[4, {j1, o1}]])*USf[4, j1][s2, 2])))))/
     (Sqrt[2]*CB^2*CW^3*MW^3*SW^2)}, 
   {((-I/3)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (3*CW*Mass[F[4, {j1, o1}]]*ZNeu[n1, 3]*USf[4, j1][s2, 1] + 
       2*CB*MW*SW*ZNeu[n1, 1]*USf[4, j1][s2, 2]))/(Sqrt[2]*CB*CW*MW*SW), 
    ((I/6)*EL*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (3*CW^3*MW^2*SW*(2*dCB1 - CB*(2*dZe1 + dZfR1[4, j1, j1]))*
        Mass[F[4, {j1, o1}]]*ZNeu[n1, 3]*USf[4, j1][s2, 1] - 
       CB*CW^2*(MW^2*SW*(dZbarSf1[1, s2, 4, j2]*(3*CW*Mass[F[4, {j1, o1}]]*
              ZNeu[n1, 3]*USf[4, j1][1, 1] + 2*CB*MW*SW*ZNeu[n1, 1]*
              USf[4, j1][1, 2]) + dZbarSf1[2, s2, 4, j2]*
            (3*CW*Mass[F[4, {j1, o1}]]*ZNeu[n1, 3]*USf[4, j1][2, 1] + 
             2*CB*MW*SW*ZNeu[n1, 1]*USf[4, j1][2, 2])) + 
         CW*(3*MW^2*SW*Mass[F[4, {j1, o1}]]*(dZfR1[11, 1, n1]*ZNeu[1, 3] + 
             dZfR1[11, 2, n1]*ZNeu[2, 3] + dZfR1[11, 3, n1]*ZNeu[3, 3] + 
             dZfR1[11, 4, n1]*ZNeu[4, 3]) + (6*MW^2*SW*dMf1[4, j1] - 
             3*(2*dSW1*MW^2 + dMWsq1*SW)*Mass[F[4, {j1, o1}]])*ZNeu[n1, 3])*
          USf[4, j1][s2, 1]) - 2*CB^2*MW^3*SW^2*
        (CW^2*(dZfR1[11, 1, n1]*ZNeu[1, 1] + dZfR1[11, 2, n1]*ZNeu[2, 1] + 
           dZfR1[11, 3, n1]*ZNeu[3, 1] + dZfR1[11, 4, n1]*ZNeu[4, 1]) + 
         (2*dSW1*SW + CW^2*(2*dZe1 + dZfR1[4, j1, j1]))*ZNeu[n1, 1])*
        USf[4, j1][s2, 2]))/(Sqrt[2]*CB^2*CW^3*MW^3*SW^2)}}, 
 C[F[12, {c1}], -F[4, {j2, o1}], S[13, {s1, j1, o2}]] == 
  {{(I*EL*Conjugate[CKM[j1, j2]]*Conjugate[UCha[c1, 2]]*
      Conjugate[USf[3, j1][s1, 1]]*IndexDelta[o1, o2]*Mass[F[4, {j2, o1}]])/
     (Sqrt[2]*CB*MW*SW), ((I/2)*EL*IndexDelta[o1, o2]*
      (2*CB*MW^2*SW*Conjugate[dCKM1[j1, j2]]*Conjugate[UCha[c1, 2]]*
        Conjugate[USf[3, j1][s1, 1]]*Mass[F[4, {j2, o1}]] + 
       Conjugate[CKM[j1, j2]]*(CB*MW^2*SW*Conjugate[USf[3, j1][s1, 1]]*
          (Conjugate[UCha[1, 2]]*dZfL1[12, 1, c1] + Conjugate[UCha[2, 2]]*
            dZfL1[12, 2, c1])*Mass[F[4, {j2, o1}]] + Conjugate[UCha[c1, 2]]*
          (CB*MW^2*SW*(Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
             Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
            Mass[F[4, {j2, o1}]] + Conjugate[USf[3, j1][s1, 1]]*
            (2*CB*MW^2*SW*dMf1[4, j2] - (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*
                SW*(2*dCB1 - CB*(2*dZe1 + dZbarfR1[4, j2, j2])))*
              Mass[F[4, {j2, o1}]])))))/(Sqrt[2]*CB^2*MW^3*SW^2)}, 
   {((-I/2)*EL*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      (2*MW*SB*Conjugate[USf[3, j1][s1, 1]]*VCha[c1, 1] - 
       Sqrt[2]*Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*VCha[c1, 2]))/
     (MW*SB*SW), ((-I/4)*EL*IndexDelta[o1, o2]*
      (2*MW^2*SB*SW*Conjugate[dCKM1[j1, j2]]*
        (2*MW*SB*Conjugate[USf[3, j1][s1, 1]]*VCha[c1, 1] - 
         Sqrt[2]*Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*VCha[c1, 2]) + 
       Conjugate[CKM[j1, j2]]*(2*MW^3*SB^2*Conjugate[USf[3, j1][s1, 1]]*
          (SW*(dZfR1[12, 1, c1]*VCha[1, 1] + dZfR1[12, 2, c1]*VCha[2, 1]) - 
           (2*dSW1 - SW*(2*dZe1 + dZbarfL1[4, j2, j2]))*VCha[c1, 1]) + 
         MW^2*SB*SW*(2*MW*SB*(Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, 
               j1] + Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
            VCha[c1, 1] - Sqrt[2]*(Conjugate[USf[3, j1][1, 2]]*
              dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 2]]*
              dZSf1[2, s1, 3, j1])*Mass[F[3, {j1}]]*VCha[c1, 2]) - 
         Sqrt[2]*Conjugate[USf[3, j1][s1, 2]]*(MW^2*SB*SW*Mass[F[3, {j1}]]*
            (dZfR1[12, 1, c1]*VCha[1, 2] + dZfR1[12, 2, c1]*VCha[2, 2]) + 
           (2*MW^2*SB*SW*dMf1[3, j1] - (2*MW^2*(dSW1*SB + dSB1*SW) + SB*SW*
                (dMWsq1 - MW^2*(2*dZe1 + dZbarfL1[4, j2, j2])))*
              Mass[F[3, {j1}]])*VCha[c1, 2]))))/(MW^3*SB^2*SW^2)}}, 
 C[-F[12, {c1}], -F[3, {j1, o1}], S[14, {s2, j2, o2}]] == 
  {{(I*EL*CKM[j1, j2]*Conjugate[VCha[c1, 2]]*Conjugate[USf[4, j2][s2, 1]]*
      IndexDelta[o1, o2]*Mass[F[3, {j1, o1}]])/(Sqrt[2]*MW*SB*SW), 
    ((I/2)*EL*IndexDelta[o1, o2]*(2*MW^2*SB*SW*Conjugate[VCha[c1, 2]]*
        Conjugate[USf[4, j2][s2, 1]]*dCKM1[j1, j2]*Mass[F[3, {j1, o1}]] + 
       CKM[j1, j2]*(MW^2*SB*SW*Conjugate[USf[4, j2][s2, 1]]*
          (Conjugate[VCha[1, 2]]*dZbarfR1[12, c1, 1] + Conjugate[VCha[2, 2]]*
            dZbarfR1[12, c1, 2])*Mass[F[3, {j1, o1}]] + 
         Conjugate[VCha[c1, 2]]*(MW^2*SB*SW*(Conjugate[USf[4, j2][1, 1]]*
              dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j2][2, 1]]*
              dZSf1[2, s2, 4, j2])*Mass[F[3, {j1, o1}]] + 
           Conjugate[USf[4, j2][s2, 1]]*(2*MW^2*SB*SW*dMf1[3, j1] - 
             (2*MW^2*(dSW1*SB + dSB1*SW) + SB*SW*(dMWsq1 - MW^2*(2*dZe1 + 
                   dZbarfR1[3, j1, j1])))*Mass[F[3, {j1, o1}]])))))/
     (Sqrt[2]*MW^3*SB^2*SW^2)}, 
   {((-I/2)*EL*CKM[j1, j2]*IndexDelta[o1, o2]*
      (2*CB*MW*Conjugate[USf[4, j2][s2, 1]]*UCha[c1, 1] - 
       Sqrt[2]*Conjugate[USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*UCha[c1, 2]))/
     (CB*MW*SW), ((-I/4)*EL*IndexDelta[o1, o2]*
      (2*CB*MW^2*SW*dCKM1[j1, j2]*(2*CB*MW*Conjugate[USf[4, j2][s2, 1]]*
          UCha[c1, 1] - Sqrt[2]*Conjugate[USf[4, j2][s2, 2]]*Mass[F[4, {j2}]]*
          UCha[c1, 2]) + CKM[j1, j2]*
        (2*CB^2*MW^3*Conjugate[USf[4, j2][s2, 1]]*
          (SW*(dZbarfL1[12, c1, 1]*UCha[1, 1] + dZbarfL1[12, c1, 2]*
              UCha[2, 1]) - (2*dSW1 - SW*(2*dZe1 + dZbarfL1[3, j1, j1]))*
            UCha[c1, 1]) + CB*MW^2*SW*(2*CB*MW*(Conjugate[USf[4, j2][1, 1]]*
              dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j2][2, 1]]*
              dZSf1[2, s2, 4, j2])*UCha[c1, 1] - Sqrt[2]*
            (Conjugate[USf[4, j2][1, 2]]*dZSf1[1, s2, 4, j2] + 
             Conjugate[USf[4, j2][2, 2]]*dZSf1[2, s2, 4, j2])*
            Mass[F[4, {j2}]]*UCha[c1, 2]) - Sqrt[2]*
          Conjugate[USf[4, j2][s2, 2]]*(CB*MW^2*SW*Mass[F[4, {j2}]]*
            (dZbarfL1[12, c1, 1]*UCha[1, 2] + dZbarfL1[12, c1, 2]*
              UCha[2, 2]) + (2*CB*MW^2*SW*dMf1[4, j2] - 
             (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 - 
                 CB*(2*dZe1 + dZbarfL1[3, j1, j1])))*Mass[F[4, {j2}]])*
            UCha[c1, 2]))))/(CB^2*MW^3*SW^2)}}, 
 C[F[12, {c1}], -F[2, {j2}], S[11, {j1}]] == 
  {{(I*EL*Conjugate[UCha[c1, 2]]*IndexDelta[j1, j2]*Mass[F[2, {j1}]])/
     (Sqrt[2]*CB*MW*SW), ((I/2)*EL*IndexDelta[j1, j2]*
      (CB*MW^2*SW*(Conjugate[UCha[1, 2]]*dZfL1[12, 1, c1] + 
         Conjugate[UCha[2, 2]]*dZfL1[12, 2, c1])*Mass[F[2, {j1}]] + 
       Conjugate[UCha[c1, 2]]*(2*CB*MW^2*SW*dMf1[2, j1] - 
         (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 - 
             CB*(2*dZe1 + dZbarfR1[2, j2, j2] + dZSf1[1, 1, 1, j1])))*
          Mass[F[2, {j1}]])))/(Sqrt[2]*CB^2*MW^3*SW^2)}, 
   {((-I)*EL*IndexDelta[j1, j2]*VCha[c1, 1])/SW, 
    ((-I/2)*EL*IndexDelta[j1, j2]*(SW*(dZfR1[12, 1, c1]*VCha[1, 1] + 
         dZfR1[12, 2, c1]*VCha[2, 1]) - 
       (2*dSW1 - SW*(2*dZe1 + dZbarfL1[2, j2, j2] + dZSf1[1, 1, 1, j1]))*
        VCha[c1, 1]))/SW^2}}, C[-F[12, {c1}], -F[1, {j1}], 
   S[12, {s2, j2}]] == 
  {{0, 0}, {((-I/2)*EL*IndexDelta[j1, j2]*(2*Conjugate[USf[2, j1][s2, 1]]*
        UCha[c1, 1] - (Sqrt[2]*Conjugate[USf[2, j1][s2, 2]]*Mass[F[2, {j1}]]*
         UCha[c1, 2])/(CB*MW)))/SW, ((-I/4)*EL*IndexDelta[j1, j2]*
      (2*CB^2*MW^3*Conjugate[USf[2, j1][s2, 1]]*
        (SW*(dZbarfL1[12, c1, 1]*UCha[1, 1] + dZbarfL1[12, c1, 2]*
            UCha[2, 1]) - (2*dSW1 - SW*(2*dZe1 + dZbarfL1[1, j1, j1]))*
          UCha[c1, 1]) + CB*MW^2*SW*
        (2*CB*MW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*UCha[c1, 1] - 
         Sqrt[2]*(Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s2, 2, j2])*Mass[F[2, {j1}]]*
          UCha[c1, 2]) - Sqrt[2]*Conjugate[USf[2, j1][s2, 2]]*
        (CB*MW^2*SW*Mass[F[2, {j1}]]*(dZbarfL1[12, c1, 1]*UCha[1, 2] + 
           dZbarfL1[12, c1, 2]*UCha[2, 2]) + (2*CB*MW^2*SW*dMf1[2, j1] - 
           (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 - CB*(2*dZe1 + 
                 dZbarfL1[1, j1, j1])))*Mass[F[2, {j1}]])*UCha[c1, 2])))/
     (CB^2*MW^3*SW^2)}}, C[F[4, {j2, o1}], -F[12, {c1}], 
   -S[13, {s1, j1, o2}]] == 
  {{((-I/2)*EL*CKM[j1, j2]*IndexDelta[o1, o2]*
      (2*MW*SB*Conjugate[VCha[c1, 1]]*USf[3, j1][s1, 1] - 
       Sqrt[2]*Conjugate[VCha[c1, 2]]*Mass[F[3, {j1}]]*USf[3, j1][s1, 2]))/
     (MW*SB*SW), ((-I/4)*EL*IndexDelta[o1, o2]*
      (2*MW^2*SB*SW*dCKM1[j1, j2]*(2*MW*SB*Conjugate[VCha[c1, 1]]*
          USf[3, j1][s1, 1] - Sqrt[2]*Conjugate[VCha[c1, 2]]*Mass[F[3, {j1}]]*
          USf[3, j1][s1, 2]) + CKM[j1, j2]*
        (2*MW^3*SB^2*Conjugate[VCha[c1, 1]]*
          (SW*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + 
             dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) - 
           (2*dSW1 - SW*(2*dZe1 + dZfL1[4, j2, j2]))*USf[3, j1][s1, 1]) + 
         MW^2*SB*SW*(2*MW*SB*(Conjugate[VCha[1, 1]]*dZbarfR1[12, c1, 1] + 
             Conjugate[VCha[2, 1]]*dZbarfR1[12, c1, 2])*USf[3, j1][s1, 1] - 
           Sqrt[2]*(Conjugate[VCha[1, 2]]*dZbarfR1[12, c1, 1] + 
             Conjugate[VCha[2, 2]]*dZbarfR1[12, c1, 2])*Mass[F[3, {j1}]]*
            USf[3, j1][s1, 2]) - Sqrt[2]*Conjugate[VCha[c1, 2]]*
          (MW^2*SB*SW*Mass[F[3, {j1}]]*(dZbarSf1[1, s1, 3, j1]*
              USf[3, j1][1, 2] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 2]) + 
           (2*MW^2*SB*SW*dMf1[3, j1] - (2*MW^2*(dSW1*SB + dSB1*SW) + SB*SW*
                (dMWsq1 - MW^2*(2*dZe1 + dZfL1[4, j2, j2])))*
              Mass[F[3, {j1}]])*USf[3, j1][s1, 2]))))/(MW^3*SB^2*SW^2)}, 
   {(I*EL*CKM[j1, j2]*IndexDelta[o1, o2]*Mass[F[4, {j2, o1}]]*UCha[c1, 2]*
      USf[3, j1][s1, 1])/(Sqrt[2]*CB*MW*SW), 
    ((I/2)*EL*IndexDelta[o1, o2]*(2*CB*MW^2*SW*dCKM1[j1, j2]*
        Mass[F[4, {j2, o1}]]*UCha[c1, 2]*USf[3, j1][s1, 1] + 
       CKM[j1, j2]*(CB*MW^2*SW*Mass[F[4, {j2, o1}]]*UCha[c1, 2]*
          (dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, j1]*
            USf[3, j1][2, 1]) + (CB*MW^2*SW*Mass[F[4, {j2, o1}]]*
            (dZbarfL1[12, c1, 1]*UCha[1, 2] + dZbarfL1[12, c1, 2]*
              UCha[2, 2]) + (2*CB*MW^2*SW*dMf1[4, j2] - 
             (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 - 
                 CB*(2*dZe1 + dZfR1[4, j2, j2])))*Mass[F[4, {j2, o1}]])*
            UCha[c1, 2])*USf[3, j1][s1, 1])))/(Sqrt[2]*CB^2*MW^3*SW^2)}}, 
 C[F[3, {j1, o1}], F[12, {c1}], -S[14, {s2, j2, o2}]] == 
  {{((-I/2)*EL*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      (2*CB*MW*Conjugate[UCha[c1, 1]]*USf[4, j2][s2, 1] - 
       Sqrt[2]*Conjugate[UCha[c1, 2]]*Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))/
     (CB*MW*SW), ((-I/4)*EL*IndexDelta[o1, o2]*
      (2*CB*MW^2*SW*Conjugate[dCKM1[j1, j2]]*(2*CB*MW*Conjugate[UCha[c1, 1]]*
          USf[4, j2][s2, 1] - Sqrt[2]*Conjugate[UCha[c1, 2]]*Mass[F[4, {j2}]]*
          USf[4, j2][s2, 2]) + Conjugate[CKM[j1, j2]]*
        (2*CB^2*MW^3*Conjugate[UCha[c1, 1]]*
          (SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + 
             dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 1]) - 
           (2*dSW1 - SW*(2*dZe1 + dZfL1[3, j1, j1]))*USf[4, j2][s2, 1]) + 
         CB*MW^2*SW*(2*CB*MW*(Conjugate[UCha[1, 1]]*dZfL1[12, 1, c1] + 
             Conjugate[UCha[2, 1]]*dZfL1[12, 2, c1])*USf[4, j2][s2, 1] - 
           Sqrt[2]*(Conjugate[UCha[1, 2]]*dZfL1[12, 1, c1] + 
             Conjugate[UCha[2, 2]]*dZfL1[12, 2, c1])*Mass[F[4, {j2}]]*
            USf[4, j2][s2, 2]) - Sqrt[2]*Conjugate[UCha[c1, 2]]*
          (CB*MW^2*SW*Mass[F[4, {j2}]]*(dZbarSf1[1, s2, 4, j2]*
              USf[4, j2][1, 2] + dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 2]) + 
           (2*CB*MW^2*SW*dMf1[4, j2] - (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*
                SW*(2*dCB1 - CB*(2*dZe1 + dZfL1[3, j1, j1])))*
              Mass[F[4, {j2}]])*USf[4, j2][s2, 2]))))/(CB^2*MW^3*SW^2)}, 
   {(I*EL*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*Mass[F[3, {j1, o1}]]*
      VCha[c1, 2]*USf[4, j2][s2, 1])/(Sqrt[2]*MW*SB*SW), 
    ((I/2)*EL*IndexDelta[o1, o2]*(2*MW^2*SB*SW*Conjugate[dCKM1[j1, j2]]*
        Mass[F[3, {j1, o1}]]*VCha[c1, 2]*USf[4, j2][s2, 1] + 
       Conjugate[CKM[j1, j2]]*(MW^2*SB*SW*Mass[F[3, {j1, o1}]]*VCha[c1, 2]*
          (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, j2]*
            USf[4, j2][2, 1]) + (MW^2*SB*SW*Mass[F[3, {j1, o1}]]*
            (dZfR1[12, 1, c1]*VCha[1, 2] + dZfR1[12, 2, c1]*VCha[2, 2]) + 
           (2*MW^2*SB*SW*dMf1[3, j1] - (2*MW^2*(dSW1*SB + dSB1*SW) + SB*SW*
                (dMWsq1 - MW^2*(2*dZe1 + dZfR1[3, j1, j1])))*
              Mass[F[3, {j1, o1}]])*VCha[c1, 2])*USf[4, j2][s2, 1])))/
     (Sqrt[2]*MW^3*SB^2*SW^2)}}, C[F[2, {j2}], -F[12, {c1}], -S[11, {j1}]] == 
  {{((-I)*EL*Conjugate[VCha[c1, 1]]*IndexDelta[j1, j2])/SW, 
    ((-I/2)*EL*(SW*(Conjugate[VCha[1, 1]]*dZbarfR1[12, c1, 1] + 
         Conjugate[VCha[2, 1]]*dZbarfR1[12, c1, 2]) - Conjugate[VCha[c1, 1]]*
        (2*dSW1 - SW*(2*dZe1 + dZbarSf1[1, 1, 1, j1] + dZfL1[2, j2, j2])))*
      IndexDelta[j1, j2])/SW^2}, 
   {(I*EL*IndexDelta[j1, j2]*Mass[F[2, {j1}]]*UCha[c1, 2])/
     (Sqrt[2]*CB*MW*SW), ((I/2)*EL*IndexDelta[j1, j2]*
      (CB*MW^2*SW*Mass[F[2, {j1}]]*(dZbarfL1[12, c1, 1]*UCha[1, 2] + 
         dZbarfL1[12, c1, 2]*UCha[2, 2]) + (2*CB*MW^2*SW*dMf1[2, j1] - 
         (CB*(2*dSW1*MW^2 + dMWsq1*SW) + MW^2*SW*(2*dCB1 - 
             CB*(2*dZe1 + dZbarSf1[1, 1, 1, j1] + dZfR1[2, j2, j2])))*
          Mass[F[2, {j1}]])*UCha[c1, 2]))/(Sqrt[2]*CB^2*MW^3*SW^2)}}, 
 C[F[1, {j1}], F[12, {c1}], -S[12, {s2, j2}]] == 
  {{((-I/2)*EL*IndexDelta[j1, j2]*(2*Conjugate[UCha[c1, 1]]*
        USf[2, j1][s2, 1] - (Sqrt[2]*Conjugate[UCha[c1, 2]]*Mass[F[2, {j1}]]*
         USf[2, j1][s2, 2])/(CB*MW)))/SW, 
    ((-I/4)*EL*IndexDelta[j1, j2]*(2*CB^2*MW^3*Conjugate[UCha[c1, 1]]*
        (SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*
            USf[2, j1][2, 1]) - (2*dSW1 - SW*(2*dZe1 + dZfL1[1, j1, j1]))*
          USf[2, j1][s2, 1]) + CB*MW^2*SW*
        (2*CB*MW*(Conjugate[UCha[1, 1]]*dZfL1[12, 1, c1] + 
           Conjugate[UCha[2, 1]]*dZfL1[12, 2, c1])*USf[2, j1][s2, 1] - 
         Sqrt[2]*(Conjugate[UCha[1, 2]]*dZfL1[12, 1, c1] + 
           Conjugate[UCha[2, 2]]*dZfL1[12, 2, c1])*Mass[F[2, {j1}]]*
          USf[2, j1][s2, 2]) - Sqrt[2]*Conjugate[UCha[c1, 2]]*
        (CB*MW^2*SW*Mass[F[2, {j1}]]*(dZbarSf1[1, s2, 2, j2]*
            USf[2, j1][1, 2] + dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 2]) + 
         (2*CB*MW^2*SW*dMf1[2, j1] - (CB*(2*dSW1*MW^2 + dMWsq1*SW) + 
             MW^2*SW*(2*dCB1 - CB*(2*dZe1 + dZfL1[1, j1, j1])))*
            Mass[F[2, {j1}]])*USf[2, j1][s2, 2])))/(CB^2*MW^3*SW^2)}, 
   {0, 0}}, C[F[11, {n1}], F[11, {n2}], V[2]] == 
  {{((-I/2)*EL*(Conjugate[ZNeu[n2, 3]]*ZNeu[n1, 3] - Conjugate[ZNeu[n2, 4]]*
        ZNeu[n1, 4]))/(CW*SW), 
    ((-I/4)*EL*(Conjugate[ZNeu[n2, 3]]*(2*dSW1*SW^2*ZNeu[n1, 3] + 
         CW^2*(SW*(dZbarfL1[11, n1, 1]*ZNeu[1, 3] + dZbarfL1[11, n1, 2]*
              ZNeu[2, 3] + dZbarfL1[11, n1, 3]*ZNeu[3, 3] + 
             dZbarfL1[11, n1, 4]*ZNeu[4, 3]) - (2*dSW1 - (2*dZe1 + dZZZ1)*SW)*
            ZNeu[n1, 3])) + CW^2*SW*
        ((Conjugate[ZNeu[1, 3]]*dZfL1[11, 1, n2] + Conjugate[ZNeu[2, 3]]*
            dZfL1[11, 2, n2] + Conjugate[ZNeu[3, 3]]*dZfL1[11, 3, n2] + 
           Conjugate[ZNeu[4, 3]]*dZfL1[11, 4, n2])*ZNeu[n1, 3] - 
         (Conjugate[ZNeu[1, 4]]*dZfL1[11, 1, n2] + Conjugate[ZNeu[2, 4]]*
            dZfL1[11, 2, n2] + Conjugate[ZNeu[3, 4]]*dZfL1[11, 3, n2] + 
           Conjugate[ZNeu[4, 4]]*dZfL1[11, 4, n2])*ZNeu[n1, 4]) - 
       Conjugate[ZNeu[n2, 4]]*(2*dSW1*SW^2*ZNeu[n1, 4] + 
         CW^2*(SW*(dZbarfL1[11, n1, 1]*ZNeu[1, 4] + dZbarfL1[11, n1, 2]*
              ZNeu[2, 4] + dZbarfL1[11, n1, 3]*ZNeu[3, 4] + 
             dZbarfL1[11, n1, 4]*ZNeu[4, 4]) - (2*dSW1 - (2*dZe1 + dZZZ1)*SW)*
            ZNeu[n1, 4]))))/(CW^3*SW^2)}, 
   {((I/2)*EL*(Conjugate[ZNeu[n1, 3]]*ZNeu[n2, 3] - Conjugate[ZNeu[n1, 4]]*
        ZNeu[n2, 4]))/(CW*SW), 
    ((I/4)*EL*(Conjugate[ZNeu[n1, 3]]*(CW^2*SW*(dZfR1[11, 1, n2]*ZNeu[1, 3] + 
           dZfR1[11, 2, n2]*ZNeu[2, 3] + dZfR1[11, 3, n2]*ZNeu[3, 3] + 
           dZfR1[11, 4, n2]*ZNeu[4, 3]) + 
         (2*dSW1*SW^2 - CW^2*(2*dSW1 - (2*dZe1 + dZZZ1)*SW))*ZNeu[n2, 3]) - 
       Conjugate[ZNeu[n1, 4]]*(CW^2*SW*(dZfR1[11, 1, n2]*ZNeu[1, 4] + 
           dZfR1[11, 2, n2]*ZNeu[2, 4] + dZfR1[11, 3, n2]*ZNeu[3, 4] + 
           dZfR1[11, 4, n2]*ZNeu[4, 4]) + 
         (2*dSW1*SW^2 - CW^2*(2*dSW1 - (2*dZe1 + dZZZ1)*SW))*ZNeu[n2, 4]) + 
       CW^2*SW*((Conjugate[ZNeu[1, 3]]*dZbarfR1[11, n1, 1] + 
           Conjugate[ZNeu[2, 3]]*dZbarfR1[11, n1, 2] + Conjugate[ZNeu[3, 3]]*
            dZbarfR1[11, n1, 3] + Conjugate[ZNeu[4, 3]]*dZbarfR1[11, n1, 4])*
          ZNeu[n2, 3] - (Conjugate[ZNeu[1, 4]]*dZbarfR1[11, n1, 1] + 
           Conjugate[ZNeu[2, 4]]*dZbarfR1[11, n1, 2] + Conjugate[ZNeu[3, 4]]*
            dZbarfR1[11, n1, 3] + Conjugate[ZNeu[4, 4]]*dZbarfR1[11, n1, 4])*
          ZNeu[n2, 4])))/(CW^3*SW^2)}}, C[F[11, {n2}], -F[12, {c1}], V[3]] == 
  {{(I*EL*(Conjugate[VCha[c1, 1]]*ZNeu[n2, 2] - 
       (Conjugate[VCha[c1, 2]]*ZNeu[n2, 4])/Sqrt[2]))/SW, 
    ((I/4)*EL*(2*Conjugate[VCha[c1, 1]]*(SW*(dZbarfL1[11, n2, 1]*ZNeu[1, 2] + 
           dZbarfL1[11, n2, 2]*ZNeu[2, 2] + dZbarfL1[11, n2, 3]*ZNeu[3, 2] + 
           dZbarfL1[11, n2, 4]*ZNeu[4, 2]) - (2*dSW1 - (2*dZe1 + dZW1)*SW)*
          ZNeu[n2, 2]) - Sqrt[2]*Conjugate[VCha[c1, 2]]*
        (SW*(dZbarfL1[11, n2, 1]*ZNeu[1, 4] + dZbarfL1[11, n2, 2]*
            ZNeu[2, 4] + dZbarfL1[11, n2, 3]*ZNeu[3, 4] + dZbarfL1[11, n2, 4]*
            ZNeu[4, 4]) - (2*dSW1 - (2*dZe1 + dZW1)*SW)*ZNeu[n2, 4]) + 
       SW*(2*(Conjugate[VCha[1, 1]]*dZbarfR1[12, c1, 1] + 
           Conjugate[VCha[2, 1]]*dZbarfR1[12, c1, 2])*ZNeu[n2, 2] - 
         Sqrt[2]*(Conjugate[VCha[1, 2]]*dZbarfR1[12, c1, 1] + 
           Conjugate[VCha[2, 2]]*dZbarfR1[12, c1, 2])*ZNeu[n2, 4])))/SW^2}, 
   {(I*EL*(Conjugate[ZNeu[n2, 2]]*UCha[c1, 1] + 
       (Conjugate[ZNeu[n2, 3]]*UCha[c1, 2])/Sqrt[2]))/SW, 
    ((I/4)*EL*(2*Conjugate[ZNeu[n2, 2]]*(SW*(dZbarfL1[12, c1, 1]*UCha[1, 1] + 
           dZbarfL1[12, c1, 2]*UCha[2, 1]) - (2*dSW1 - (2*dZe1 + dZW1)*SW)*
          UCha[c1, 1]) + Sqrt[2]*Conjugate[ZNeu[n2, 3]]*
        (SW*(dZbarfL1[12, c1, 1]*UCha[1, 2] + dZbarfL1[12, c1, 2]*
            UCha[2, 2]) - (2*dSW1 - (2*dZe1 + dZW1)*SW)*UCha[c1, 2]) + 
       SW*(2*(Conjugate[ZNeu[1, 2]]*dZbarfR1[11, n2, 1] + 
           Conjugate[ZNeu[2, 2]]*dZbarfR1[11, n2, 2] + Conjugate[ZNeu[3, 2]]*
            dZbarfR1[11, n2, 3] + Conjugate[ZNeu[4, 2]]*dZbarfR1[11, n2, 4])*
          UCha[c1, 1] + Sqrt[2]*(Conjugate[ZNeu[1, 3]]*dZbarfR1[11, n2, 1] + 
           Conjugate[ZNeu[2, 3]]*dZbarfR1[11, n2, 2] + Conjugate[ZNeu[3, 3]]*
            dZbarfR1[11, n2, 3] + Conjugate[ZNeu[4, 3]]*dZbarfR1[11, n2, 4])*
          UCha[c1, 2])))/SW^2}}, C[F[12, {c1}], F[11, {n2}], -V[3]] == 
  {{(I*EL*(Conjugate[ZNeu[n2, 2]]*VCha[c1, 1] - 
       (Conjugate[ZNeu[n2, 4]]*VCha[c1, 2])/Sqrt[2]))/SW, 
    ((I/4)*EL*(2*Conjugate[ZNeu[n2, 2]]*(SW*(dZfR1[12, 1, c1]*VCha[1, 1] + 
           dZfR1[12, 2, c1]*VCha[2, 1]) - (2*dSW1 - (dZbarW1 + 2*dZe1)*SW)*
          VCha[c1, 1]) - Sqrt[2]*Conjugate[ZNeu[n2, 4]]*
        (SW*(dZfR1[12, 1, c1]*VCha[1, 2] + dZfR1[12, 2, c1]*VCha[2, 2]) - 
         (2*dSW1 - (dZbarW1 + 2*dZe1)*SW)*VCha[c1, 2]) + 
       SW*(2*(Conjugate[ZNeu[1, 2]]*dZfL1[11, 1, n2] + Conjugate[ZNeu[2, 2]]*
            dZfL1[11, 2, n2] + Conjugate[ZNeu[3, 2]]*dZfL1[11, 3, n2] + 
           Conjugate[ZNeu[4, 2]]*dZfL1[11, 4, n2])*VCha[c1, 1] - 
         Sqrt[2]*(Conjugate[ZNeu[1, 4]]*dZfL1[11, 1, n2] + 
           Conjugate[ZNeu[2, 4]]*dZfL1[11, 2, n2] + Conjugate[ZNeu[3, 4]]*
            dZfL1[11, 3, n2] + Conjugate[ZNeu[4, 4]]*dZfL1[11, 4, n2])*
          VCha[c1, 2])))/SW^2}, 
   {(I*EL*(Conjugate[UCha[c1, 1]]*ZNeu[n2, 2] + 
       (Conjugate[UCha[c1, 2]]*ZNeu[n2, 3])/Sqrt[2]))/SW, 
    ((I/4)*EL*(2*Conjugate[UCha[c1, 1]]*(SW*(dZfR1[11, 1, n2]*ZNeu[1, 2] + 
           dZfR1[11, 2, n2]*ZNeu[2, 2] + dZfR1[11, 3, n2]*ZNeu[3, 2] + 
           dZfR1[11, 4, n2]*ZNeu[4, 2]) - (2*dSW1 - (dZbarW1 + 2*dZe1)*SW)*
          ZNeu[n2, 2]) + Sqrt[2]*Conjugate[UCha[c1, 2]]*
        (SW*(dZfR1[11, 1, n2]*ZNeu[1, 3] + dZfR1[11, 2, n2]*ZNeu[2, 3] + 
           dZfR1[11, 3, n2]*ZNeu[3, 3] + dZfR1[11, 4, n2]*ZNeu[4, 3]) - 
         (2*dSW1 - (dZbarW1 + 2*dZe1)*SW)*ZNeu[n2, 3]) + 
       SW*(2*(Conjugate[UCha[1, 1]]*dZfL1[12, 1, c1] + Conjugate[UCha[2, 1]]*
            dZfL1[12, 2, c1])*ZNeu[n2, 2] + Sqrt[2]*
          (Conjugate[UCha[1, 2]]*dZfL1[12, 1, c1] + Conjugate[UCha[2, 2]]*
            dZfL1[12, 2, c1])*ZNeu[n2, 3])))/SW^2}}, 
 C[-F[12, {c2}], F[12, {c1}], V[1]] == 
  {{I*EL*IndexDelta[c1, c2], 
    ((I/4)*EL*(2*SW*(CW*(dZbarfL1[12, c2, 1]*IndexDelta[1, c1] + 
           dZfL1[12, 1, c1]*IndexDelta[1, c2] + dZbarfL1[12, c2, 2]*
            IndexDelta[2, c1] + dZfL1[12, 2, c1]*IndexDelta[2, c2]) + 
         (CW*(dZAA1 + 2*dZe1) - dZZA1*SW)*IndexDelta[c1, c2]) + 
       dZZA1*(2*Conjugate[UCha[c1, 1]]*UCha[c2, 1] + Conjugate[UCha[c1, 2]]*
          UCha[c2, 2])))/(CW*SW)}, {I*EL*IndexDelta[c1, c2], 
    ((I/4)*EL*(2*SW*(CW*(dZbarfR1[12, c2, 1]*IndexDelta[1, c1] + 
           dZfR1[12, 1, c1]*IndexDelta[1, c2] + dZbarfR1[12, c2, 2]*
            IndexDelta[2, c1] + dZfR1[12, 2, c1]*IndexDelta[2, c2]) + 
         (CW*(dZAA1 + 2*dZe1) - dZZA1*SW)*IndexDelta[c1, c2]) + 
       dZZA1*(2*Conjugate[VCha[c2, 1]]*VCha[c1, 1] + Conjugate[VCha[c2, 2]]*
          VCha[c1, 2])))/(CW*SW)}}, C[-F[12, {c2}], F[12, {c1}], V[2]] == 
  {{((-I/2)*EL*(2*SW^2*IndexDelta[c1, c2] - 2*Conjugate[UCha[c1, 1]]*
        UCha[c2, 1] - Conjugate[UCha[c1, 2]]*UCha[c2, 2]))/(CW*SW), 
    ((I/4)*EL*(SW^2*((2*CW^3*dZAZ1 - 4*dSW1*SW^2 - 
           2*CW^2*(2*dSW1 + (2*dZe1 + dZZZ1)*SW))*IndexDelta[c1, c2] + 
         4*dSW1*Conjugate[UCha[c1, 1]]*UCha[c2, 1]) - 
       CW^2*(2*SW^3*(dZbarfL1[12, c2, 1]*IndexDelta[1, c1] + 
           dZbarfL1[12, c2, 2]*IndexDelta[2, c1]) - 2*Conjugate[UCha[c1, 1]]*
          (SW*(dZbarfL1[12, c2, 1]*UCha[1, 1] + dZbarfL1[12, c2, 2]*
              UCha[2, 1]) - (2*dSW1 - (2*dZe1 + dZZZ1)*SW)*UCha[c2, 1]) - 
         Conjugate[UCha[c1, 2]]*(SW*(dZbarfL1[12, c2, 1]*UCha[1, 2] + 
             dZbarfL1[12, c2, 2]*UCha[2, 2]) - 2*dSW1*UCha[c2, 2])) + 
       SW*((CW^2*(2*dZe1 + dZZZ1) + 2*dSW1*SW)*Conjugate[UCha[c1, 2]]*
          UCha[c2, 2] - CW^2*(dZfL1[12, 1, c1]*(2*SW^2*IndexDelta[1, c2] - 
             2*Conjugate[UCha[1, 1]]*UCha[c2, 1] - Conjugate[UCha[1, 2]]*
              UCha[c2, 2]) + dZfL1[12, 2, c1]*(2*SW^2*IndexDelta[2, c2] - 
             2*Conjugate[UCha[2, 1]]*UCha[c2, 1] - Conjugate[UCha[2, 2]]*
              UCha[c2, 2])))))/(CW^3*SW^2)}, 
   {((-I/2)*EL*(2*SW^2*IndexDelta[c1, c2] - 2*Conjugate[VCha[c2, 1]]*
        VCha[c1, 1] - Conjugate[VCha[c2, 2]]*VCha[c1, 2]))/(CW*SW), 
    ((I/4)*EL*(SW^2*(2*CW^3*dZAZ1 - 4*dSW1*SW^2 - 
         2*CW^2*(2*dSW1 + (2*dZe1 + dZZZ1)*SW))*IndexDelta[c1, c2] + 
       2*SW*(2*dSW1*SW*Conjugate[VCha[c2, 1]] + 
         CW^2*(Conjugate[VCha[1, 1]]*dZbarfR1[12, c2, 1] + 
           Conjugate[VCha[2, 1]]*dZbarfR1[12, c2, 2]))*VCha[c1, 1] - 
       CW^2*(2*SW^3*(dZbarfR1[12, c2, 1]*IndexDelta[1, c1] + 
           dZbarfR1[12, c2, 2]*IndexDelta[2, c1]) + 
         SW*(dZfR1[12, 1, c1]*(2*SW^2*IndexDelta[1, c2] - 
             2*Conjugate[VCha[c2, 1]]*VCha[1, 1] - Conjugate[VCha[c2, 2]]*
              VCha[1, 2]) + dZfR1[12, 2, c1]*(2*SW^2*IndexDelta[2, c2] - 
             2*Conjugate[VCha[c2, 1]]*VCha[2, 1] - Conjugate[VCha[c2, 2]]*
              VCha[2, 2])) + 2*(2*dSW1 - (2*dZe1 + dZZZ1)*SW)*
          Conjugate[VCha[c2, 1]]*VCha[c1, 1]) + 
       ((2*dSW1*SW^2 - CW^2*(2*dSW1 - (2*dZe1 + dZZZ1)*SW))*
          Conjugate[VCha[c2, 2]] + CW^2*SW*(Conjugate[VCha[1, 2]]*
            dZbarfR1[12, c2, 1] + Conjugate[VCha[2, 2]]*dZbarfR1[12, c2, 2]))*
        VCha[c1, 2]))/(CW^3*SW^2)}}, 
 C[S[1], S[1], S[11, {j2}], -S[11, {j1}]] == 
  {{((I/4)*C2A*EL^2*IndexDelta[j1, j2])/(CW^2*SW^2), 
    ((I/8)*EL^2*(4*C2A*(dSW1*SW^2 - CW^2*(dSW1 - dZe1*SW)) + 
       CW^2*SW*(2*S2A*dZHiggs1[1, 2] + C2A*(dZbarSf1[1, 1, 1, j1] + 
           2*dZHiggs1[1, 1] + dZSf1[1, 1, 1, j2])))*IndexDelta[j1, j2])/
     (CW^4*SW^3)}}, C[S[1], S[1], S[12, {s2, j2}], -S[12, {s1, j1}]] == 
  {{((I/4)*EL^2*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s2, 1]]*
        (C2A*CB^2*(1 - 2*CW^2)*MW^2 - 2*CW^2*SA^2*Mass[F[2, {j1}]]^2)*
        USf[2, j1][s1, 1] - 2*Conjugate[USf[2, j1][s2, 2]]*
        (C2A*CB^2*MW^2*SW^2 + CW^2*SA^2*Mass[F[2, {j1}]]^2)*
        USf[2, j1][s1, 2]))/(CB^2*CW^2*MW^2*SW^2), 
    ((I/8)*EL^2*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s2, 1]]*
        (CB*CW^2*MW^2*SW*(C2A*CB^2*(1 - 2*CW^2)*MW^2 - 2*CW^2*SA^2*
            Mass[F[2, {j1}]]^2)*(dZbarSf1[1, s1, 2, j1]*USf[2, j1][1, 1] + 
           dZbarSf1[2, s1, 2, j1]*USf[2, j1][2, 1]) + 
         2*(CB^3*MW^4*(C2A*(2*(1 - 2*CW^2)*dSW1*SW^2 + CW^2*(2*dSW1 + 
                 (1 - 2*CW^2)*SW*(2*dZe1 + dZHiggs1[1, 1]))) + 
             CW^2*(1 - 2*CW^2)*S2A*SW*dZHiggs1[1, 2]) - CW^4*Mass[F[2, {j1}]]*
            (4*CB*MW^2*SA^2*SW*dMf1[2, j1] - (4*dCB1*MW^2*SA^2*SW + CB*
                (4*dSW1*MW^2*SA^2 + SW*(2*SA^2*(dMWsq1 - MW^2*(2*dZe1 + 
                       dZHiggs1[1, 1])) + MW^2*S2A*dZHiggs1[1, 2])))*
              Mass[F[2, {j1}]]))*USf[2, j1][s1, 1]) + 
       CB*CW^2*MW^2*SW*((Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
          (C2A*CB^2*(1 - 2*CW^2)*MW^2 - 2*CW^2*SA^2*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s1, 1] - 2*(Conjugate[USf[2, j1][1, 2]]*
            dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 2]]*
            dZSf1[2, s2, 2, j2])*(C2A*CB^2*MW^2*SW^2 + 
           CW^2*SA^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s1, 2]) - 
       2*Conjugate[USf[2, j1][s2, 2]]*(CB*CW^2*MW^2*SW*(C2A*CB^2*MW^2*SW^2 + 
           CW^2*SA^2*Mass[F[2, {j1}]]^2)*(dZbarSf1[1, s1, 2, j1]*
            USf[2, j1][1, 2] + dZbarSf1[2, s1, 2, j1]*USf[2, j1][2, 2]) + 
         (2*CB^3*MW^4*SW^3*(C2A*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[1, 
                  1])) + CW^2*S2A*dZHiggs1[1, 2]) + CW^4*Mass[F[2, {j1}]]*
            (4*CB*MW^2*SA^2*SW*dMf1[2, j1] - (4*dCB1*MW^2*SA^2*SW + CB*
                (4*dSW1*MW^2*SA^2 + SW*(2*SA^2*(dMWsq1 - MW^2*(2*dZe1 + 
                       dZHiggs1[1, 1])) + MW^2*S2A*dZHiggs1[1, 2])))*
              Mass[F[2, {j1}]]))*USf[2, j1][s1, 2])))/
     (CB^3*CW^4*MW^4*SW^3)}}, C[S[1], S[1], S[13, {s2, j2, o1}], 
   -S[13, {s1, j1, o2}]] == 
  {{((-I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s2, 1]]*(C2A*(1 - 4*CW^2)*MW^2*SB^2 + 
         6*CA^2*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 1] - 
       2*Conjugate[USf[3, j1][s2, 2]]*(2*C2A*MW^2*SB^2*SW^2 - 
         3*CA^2*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]))/
     (CW^2*MW^2*SB^2*SW^2), ((-I/24)*EL^2*IndexDelta[j1, j2]*
      IndexDelta[o1, o2]*(Conjugate[USf[3, j1][s2, 1]]*
        (CW^2*MW^2*SB*SW*(C2A*(1 - 4*CW^2)*MW^2*SB^2 + 6*CA^2*CW^2*
            Mass[F[3, {j1}]]^2)*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + 
           dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) + 
         2*(MW^4*SB^3*(C2A*(2*(1 - 4*CW^2)*dSW1*SW^2 + CW^2*(6*dSW1 + 
                 (1 - 4*CW^2)*SW*(2*dZe1 + dZHiggs1[1, 1]))) + 
             CW^2*(1 - 4*CW^2)*S2A*SW*dZHiggs1[1, 2]) + 
           3*CW^4*Mass[F[3, {j1}]]*(4*CA^2*MW^2*SB*SW*dMf1[3, j1] - 
             (2*CA^2*(2*dSB1*MW^2*SW + SB*(2*dSW1*MW^2 + SW*(dMWsq1 - 
                     MW^2*(2*dZe1 + dZHiggs1[1, 1])))) - MW^2*S2A*SB*SW*
                dZHiggs1[1, 2])*Mass[F[3, {j1}]]))*USf[3, j1][s1, 1]) + 
       CW^2*MW^2*SB*SW*((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s2, 3, j2] + 
           Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s2, 3, j2])*
          (C2A*(1 - 4*CW^2)*MW^2*SB^2 + 6*CA^2*CW^2*Mass[F[3, {j1}]]^2)*
          USf[3, j1][s1, 1] - 2*(Conjugate[USf[3, j1][1, 2]]*
            dZSf1[1, s2, 3, j2] + Conjugate[USf[3, j1][2, 2]]*
            dZSf1[2, s2, 3, j2])*(2*C2A*MW^2*SB^2*SW^2 - 
           3*CA^2*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]) - 
       2*Conjugate[USf[3, j1][s2, 2]]*(CW^2*MW^2*SB*SW*
          (2*C2A*MW^2*SB^2*SW^2 - 3*CA^2*CW^2*Mass[F[3, {j1}]]^2)*
          (dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 2] + dZbarSf1[2, s1, 3, j1]*
            USf[3, j1][2, 2]) + (4*MW^4*SB^3*SW^3*
            (C2A*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[1, 1])) + 
             CW^2*S2A*dZHiggs1[1, 2]) - 3*CW^4*Mass[F[3, {j1}]]*
            (4*CA^2*MW^2*SB*SW*dMf1[3, j1] - (2*CA^2*(2*dSB1*MW^2*SW + 
                 SB*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[1, 
                        1])))) - MW^2*S2A*SB*SW*dZHiggs1[1, 2])*
              Mass[F[3, {j1}]]))*USf[3, j1][s1, 2])))/
     (CW^4*MW^4*SB^3*SW^3)}}, C[S[1], S[1], S[14, {s2, j2, o1}], 
   -S[14, {s1, j1, o2}]] == 
  {{((-I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s2, 1]]*(C2A*CB^2*(1 + 2*CW^2)*MW^2 + 
         6*CW^2*SA^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 1] + 
       2*Conjugate[USf[4, j1][s2, 2]]*(C2A*CB^2*MW^2*SW^2 + 
         3*CW^2*SA^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]))/
     (CB^2*CW^2*MW^2*SW^2), ((-I/24)*EL^2*IndexDelta[j1, j2]*
      IndexDelta[o1, o2]*(Conjugate[USf[4, j1][s2, 1]]*
        (CB*CW^2*MW^2*SW*(C2A*CB^2*(1 + 2*CW^2)*MW^2 + 6*CW^2*SA^2*
            Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s1, 4, j1]*USf[4, j1][1, 1] + 
           dZbarSf1[2, s1, 4, j1]*USf[4, j1][2, 1]) + 
         2*(CB^3*MW^4*(C2A*(2*(1 + 2*CW^2)*dSW1*SW^2 - CW^2*(6*dSW1 - 
                 (1 + 2*CW^2)*SW*(2*dZe1 + dZHiggs1[1, 1]))) + 
             CW^2*(1 + 2*CW^2)*S2A*SW*dZHiggs1[1, 2]) + 
           3*CW^4*Mass[F[4, {j1}]]*(4*CB*MW^2*SA^2*SW*dMf1[4, j1] - 
             (4*dCB1*MW^2*SA^2*SW + CB*(4*dSW1*MW^2*SA^2 + 
                 SW*(2*SA^2*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[1, 1])) + 
                   MW^2*S2A*dZHiggs1[1, 2])))*Mass[F[4, {j1}]]))*
          USf[4, j1][s1, 1]) + CB*CW^2*MW^2*SW*
        ((Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s2, 4, j2])*
          (C2A*CB^2*(1 + 2*CW^2)*MW^2 + 6*CW^2*SA^2*Mass[F[4, {j1}]]^2)*
          USf[4, j1][s1, 1] + 2*(Conjugate[USf[4, j1][1, 2]]*
            dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j1][2, 2]]*
            dZSf1[2, s2, 4, j2])*(C2A*CB^2*MW^2*SW^2 + 3*CW^2*SA^2*
            Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]) + 
       2*Conjugate[USf[4, j1][s2, 2]]*(CB*CW^2*MW^2*SW*(C2A*CB^2*MW^2*SW^2 + 
           3*CW^2*SA^2*Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s1, 4, j1]*
            USf[4, j1][1, 2] + dZbarSf1[2, s1, 4, j1]*USf[4, j1][2, 2]) + 
         (2*CB^3*MW^4*SW^3*(C2A*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[1, 
                  1])) + CW^2*S2A*dZHiggs1[1, 2]) + 3*CW^4*Mass[F[4, {j1}]]*
            (4*CB*MW^2*SA^2*SW*dMf1[4, j1] - (4*dCB1*MW^2*SA^2*SW + CB*
                (4*dSW1*MW^2*SA^2 + SW*(2*SA^2*(dMWsq1 - MW^2*(2*dZe1 + 
                       dZHiggs1[1, 1])) + MW^2*S2A*dZHiggs1[1, 2])))*
              Mass[F[4, {j1}]]))*USf[4, j1][s1, 2])))/
     (CB^3*CW^4*MW^4*SW^3)}}, C[S[2], S[2], S[11, {j2}], -S[11, {j1}]] == 
  {{((-I/4)*C2A*EL^2*IndexDelta[j1, j2])/(CW^2*SW^2), 
    ((-I/8)*EL^2*(4*C2A*(dSW1*SW^2 - CW^2*(dSW1 - dZe1*SW)) - 
       CW^2*SW*(2*S2A*dZHiggs1[1, 2] - C2A*(dZbarSf1[1, 1, 1, j1] + 
           2*dZHiggs1[2, 2] + dZSf1[1, 1, 1, j2])))*IndexDelta[j1, j2])/
     (CW^4*SW^3)}}, C[S[2], S[2], S[12, {s2, j2}], -S[12, {s1, j1}]] == 
  {{((-I/4)*EL^2*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s2, 1]]*
        (C2A*CB^2*(1 - 2*CW^2)*MW^2 + 2*CA^2*CW^2*Mass[F[2, {j1}]]^2)*
        USf[2, j1][s1, 1] - 2*Conjugate[USf[2, j1][s2, 2]]*
        (C2A*CB^2*MW^2*SW^2 - CA^2*CW^2*Mass[F[2, {j1}]]^2)*
        USf[2, j1][s1, 2]))/(CB^2*CW^2*MW^2*SW^2), 
    ((-I/8)*EL^2*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s2, 1]]*
        (CB*CW^2*MW^2*SW*(C2A*CB^2*(1 - 2*CW^2)*MW^2 + 2*CA^2*CW^2*
            Mass[F[2, {j1}]]^2)*(dZbarSf1[1, s1, 2, j1]*USf[2, j1][1, 1] + 
           dZbarSf1[2, s1, 2, j1]*USf[2, j1][2, 1]) - 
         2*(CB^3*MW^4*(CW^2*(1 - 2*CW^2)*S2A*SW*dZHiggs1[1, 2] - 
             C2A*(2*(1 - 2*CW^2)*dSW1*SW^2 + CW^2*(2*dSW1 + (1 - 2*CW^2)*SW*
                  (2*dZe1 + dZHiggs1[2, 2])))) - CW^4*Mass[F[2, {j1}]]*
            (4*CA^2*CB*MW^2*SW*dMf1[2, j1] - (CB*MW^2*S2A*SW*dZHiggs1[1, 2] + 
               2*CA^2*(2*dCB1*MW^2*SW + CB*(2*dSW1*MW^2 + SW*(dMWsq1 - 
                     MW^2*(2*dZe1 + dZHiggs1[2, 2])))))*Mass[F[2, {j1}]]))*
          USf[2, j1][s1, 1]) + CB*CW^2*MW^2*SW*
        ((Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
          (C2A*CB^2*(1 - 2*CW^2)*MW^2 + 2*CA^2*CW^2*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s1, 1] - 2*(Conjugate[USf[2, j1][1, 2]]*
            dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 2]]*
            dZSf1[2, s2, 2, j2])*(C2A*CB^2*MW^2*SW^2 - 
           CA^2*CW^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s1, 2]) - 
       2*Conjugate[USf[2, j1][s2, 2]]*(CB*CW^2*MW^2*SW*(C2A*CB^2*MW^2*SW^2 - 
           CA^2*CW^2*Mass[F[2, {j1}]]^2)*(dZbarSf1[1, s1, 2, j1]*
            USf[2, j1][1, 2] + dZbarSf1[2, s1, 2, j1]*USf[2, j1][2, 2]) - 
         (2*CB^3*MW^4*SW^3*(CW^2*S2A*dZHiggs1[1, 2] - 
             C2A*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[2, 2]))) + 
           CW^4*Mass[F[2, {j1}]]*(4*CA^2*CB*MW^2*SW*dMf1[2, j1] - 
             (CB*MW^2*S2A*SW*dZHiggs1[1, 2] + 2*CA^2*(2*dCB1*MW^2*SW + 
                 CB*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[2, 
                        2])))))*Mass[F[2, {j1}]]))*USf[2, j1][s1, 2])))/
     (CB^3*CW^4*MW^4*SW^3)}}, C[S[2], S[2], S[13, {s2, j2, o1}], 
   -S[13, {s1, j1, o2}]] == 
  {{((I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s2, 1]]*(C2A*(1 - 4*CW^2)*MW^2*SB^2 - 
         6*CW^2*SA^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 1] - 
       2*Conjugate[USf[3, j1][s2, 2]]*(2*C2A*MW^2*SB^2*SW^2 + 
         3*CW^2*SA^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]))/
     (CW^2*MW^2*SB^2*SW^2), ((I/24)*EL^2*IndexDelta[j1, j2]*
      IndexDelta[o1, o2]*(Conjugate[USf[3, j1][s2, 1]]*
        (CW^2*MW^2*SB*SW*(C2A*(1 - 4*CW^2)*MW^2*SB^2 - 6*CW^2*SA^2*
            Mass[F[3, {j1}]]^2)*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + 
           dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) - 
         2*(MW^4*SB^3*(CW^2*(1 - 4*CW^2)*S2A*SW*dZHiggs1[1, 2] - 
             C2A*(2*(1 - 4*CW^2)*dSW1*SW^2 + CW^2*(6*dSW1 + (1 - 4*CW^2)*SW*
                  (2*dZe1 + dZHiggs1[2, 2])))) + 3*CW^4*Mass[F[3, {j1}]]*
            (4*MW^2*SA^2*SB*SW*dMf1[3, j1] - (4*MW^2*SA^2*(dSW1*SB + 
                 dSB1*SW) + SB*SW*(2*dMWsq1*SA^2 - MW^2*(S2A*dZHiggs1[1, 2] + 
                   SA^2*(4*dZe1 + 2*dZHiggs1[2, 2]))))*Mass[F[3, {j1}]]))*
          USf[3, j1][s1, 1]) + CW^2*MW^2*SB*SW*
        ((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s2, 3, j2] + 
           Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s2, 3, j2])*
          (C2A*(1 - 4*CW^2)*MW^2*SB^2 - 6*CW^2*SA^2*Mass[F[3, {j1}]]^2)*
          USf[3, j1][s1, 1] - 2*(Conjugate[USf[3, j1][1, 2]]*
            dZSf1[1, s2, 3, j2] + Conjugate[USf[3, j1][2, 2]]*
            dZSf1[2, s2, 3, j2])*(2*C2A*MW^2*SB^2*SW^2 + 
           3*CW^2*SA^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]) - 
       2*Conjugate[USf[3, j1][s2, 2]]*(CW^2*MW^2*SB*SW*
          (2*C2A*MW^2*SB^2*SW^2 + 3*CW^2*SA^2*Mass[F[3, {j1}]]^2)*
          (dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 2] + dZbarSf1[2, s1, 3, j1]*
            USf[3, j1][2, 2]) - (4*MW^4*SB^3*SW^3*(CW^2*S2A*dZHiggs1[1, 2] - 
             C2A*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[2, 2]))) - 
           3*CW^4*Mass[F[3, {j1}]]*(4*MW^2*SA^2*SB*SW*dMf1[3, j1] - 
             (4*dSB1*MW^2*SA^2*SW + SB*(4*dSW1*MW^2*SA^2 + 
                 SW*(2*dMWsq1*SA^2 - MW^2*(S2A*dZHiggs1[1, 2] + SA^2*
                      (4*dZe1 + 2*dZHiggs1[2, 2])))))*Mass[F[3, {j1}]]))*
          USf[3, j1][s1, 2])))/(CW^4*MW^4*SB^3*SW^3)}}, 
 C[S[2], S[2], S[14, {s2, j2, o1}], -S[14, {s1, j1, o2}]] == 
  {{((I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s2, 1]]*(C2A*CB^2*(1 + 2*CW^2)*MW^2 - 
         6*CA^2*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 1] + 
       2*Conjugate[USf[4, j1][s2, 2]]*(C2A*CB^2*MW^2*SW^2 - 
         3*CA^2*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]))/
     (CB^2*CW^2*MW^2*SW^2), ((I/24)*EL^2*IndexDelta[j1, j2]*
      IndexDelta[o1, o2]*(Conjugate[USf[4, j1][s2, 1]]*
        (CB*CW^2*MW^2*SW*(C2A*CB^2*(1 + 2*CW^2)*MW^2 - 6*CA^2*CW^2*
            Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s1, 4, j1]*USf[4, j1][1, 1] + 
           dZbarSf1[2, s1, 4, j1]*USf[4, j1][2, 1]) - 
         2*(CB^3*MW^4*(CW^2*(1 + 2*CW^2)*S2A*SW*dZHiggs1[1, 2] - 
             C2A*(2*(1 + 2*CW^2)*dSW1*SW^2 - CW^2*(6*dSW1 - (1 + 2*CW^2)*SW*
                  (2*dZe1 + dZHiggs1[2, 2])))) + 3*CW^4*Mass[F[4, {j1}]]*
            (4*CA^2*CB*MW^2*SW*dMf1[4, j1] - (CB*MW^2*S2A*SW*dZHiggs1[1, 2] + 
               2*CA^2*(2*dCB1*MW^2*SW + CB*(2*dSW1*MW^2 + SW*(dMWsq1 - 
                     MW^2*(2*dZe1 + dZHiggs1[2, 2])))))*Mass[F[4, {j1}]]))*
          USf[4, j1][s1, 1]) + CB*CW^2*MW^2*SW*
        ((Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s2, 4, j2])*
          (C2A*CB^2*(1 + 2*CW^2)*MW^2 - 6*CA^2*CW^2*Mass[F[4, {j1}]]^2)*
          USf[4, j1][s1, 1] + 2*(Conjugate[USf[4, j1][1, 2]]*
            dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j1][2, 2]]*
            dZSf1[2, s2, 4, j2])*(C2A*CB^2*MW^2*SW^2 - 3*CA^2*CW^2*
            Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]) + 
       2*Conjugate[USf[4, j1][s2, 2]]*(CB*CW^2*MW^2*SW*(C2A*CB^2*MW^2*SW^2 - 
           3*CA^2*CW^2*Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s1, 4, j1]*
            USf[4, j1][1, 2] + dZbarSf1[2, s1, 4, j1]*USf[4, j1][2, 2]) - 
         (2*CB^3*MW^4*SW^3*(CW^2*S2A*dZHiggs1[1, 2] - 
             C2A*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[2, 2]))) + 
           3*CW^4*Mass[F[4, {j1}]]*(4*CA^2*CB*MW^2*SW*dMf1[4, j1] - 
             (CB*MW^2*S2A*SW*dZHiggs1[1, 2] + 2*CA^2*(2*dCB1*MW^2*SW + 
                 CB*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[2, 
                        2])))))*Mass[F[4, {j1}]]))*USf[4, j1][s1, 2])))/
     (CB^3*CW^4*MW^4*SW^3)}}, C[S[3], S[3], S[11, {j2}], -S[11, {j1}]] == 
  {{((I/4)*C2B*EL^2*IndexDelta[j1, j2])/(CW^2*SW^2), 
    ((I/8)*EL^2*(4*C2B*(dSW1*SW^2 - CW^2*(dSW1 - dZe1*SW)) + 
       CW^2*SW*(2*S2B*dZHiggs1[3, 4] + C2B*(dZbarSf1[1, 1, 1, j1] + 
           2*dZHiggs1[3, 3] + dZSf1[1, 1, 1, j2])))*IndexDelta[j1, j2])/
     (CW^4*SW^3)}}, C[S[4], S[4], S[11, {j2}], -S[11, {j1}]] == 
  {{((-I/4)*C2B*EL^2*IndexDelta[j1, j2])/(CW^2*SW^2), 
    ((-I/8)*EL^2*(4*C2B*(dSW1*SW^2 - CW^2*(dSW1 - dZe1*SW)) - 
       CW^2*SW*(2*S2B*dZHiggs1[3, 4] - C2B*(dZbarSf1[1, 1, 1, j1] + 
           2*dZHiggs1[4, 4] + dZSf1[1, 1, 1, j2])))*IndexDelta[j1, j2])/
     (CW^4*SW^3)}}, C[S[3], S[4], S[11, {j2}], -S[11, {j1}]] == 
  {{((I/4)*EL^2*S2B*IndexDelta[j1, j2])/(CW^2*SW^2), 
    ((I/8)*EL^2*S2B*(4*dSW1*SW^2 - CW^2*(4*(dSW1 - dZe1*SW) - 
         SW*(dZbarSf1[1, 1, 1, j1] + dZHiggs1[3, 3] + dZHiggs1[4, 4] + 
           dZSf1[1, 1, 1, j2])))*IndexDelta[j1, j2])/(CW^4*SW^3)}}, 
 C[S[3], S[3], S[12, {s2, j2}], -S[12, {s1, j1}]] == 
  {{((I/4)*EL^2*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s2, 1]]*
        (C2B*CB^2*(1 - 2*CW^2)*MW^2 - 2*CW^2*SB^2*Mass[F[2, {j1}]]^2)*
        USf[2, j1][s1, 1] - 2*Conjugate[USf[2, j1][s2, 2]]*
        (C2B*CB^2*MW^2*SW^2 + CW^2*SB^2*Mass[F[2, {j1}]]^2)*
        USf[2, j1][s1, 2]))/(CB^2*CW^2*MW^2*SW^2), 
    ((I/8)*EL^2*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s2, 1]]*
        (CW^2*MW^2*SW*(C2B*CB^3*(1 - 2*CW^2)*MW^2 - CW^2*S2B*SB*
            Mass[F[2, {j1}]]^2)*(dZbarSf1[1, s1, 2, j1]*USf[2, j1][1, 1] + 
           dZbarSf1[2, s1, 2, j1]*USf[2, j1][2, 1]) + 
         2*(CB^3*MW^4*(C2B*(2*(1 - 2*CW^2)*dSW1*SW^2 + CW^2*(2*dSW1 + 
                 (1 - 2*CW^2)*SW*(2*dZe1 + dZHiggs1[3, 3]))) + 
             CW^2*(1 - 2*CW^2)*S2B*SW*dZHiggs1[3, 4]) - 
           2*CW^4*SB*Mass[F[2, {j1}]]*(MW^2*S2B*SW*dMf1[2, j1] - 
             ((S2B*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[3, 
                       3]))))/2 + MW^2*SW*(2*dCB1*SB + CB^2*dZHiggs1[3, 4]))*
              Mass[F[2, {j1}]]))*USf[2, j1][s1, 1]) + 
       CB*CW^2*MW^2*SW*((Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
          (C2B*CB^2*(1 - 2*CW^2)*MW^2 - 2*CW^2*SB^2*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s1, 1] - 2*(Conjugate[USf[2, j1][1, 2]]*
            dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 2]]*
            dZSf1[2, s2, 2, j2])*(C2B*CB^2*MW^2*SW^2 + 
           CW^2*SB^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s1, 2]) - 
       2*Conjugate[USf[2, j1][s2, 2]]*(CB*CW^2*MW^2*SW*(C2B*CB^2*MW^2*SW^2 + 
           CW^2*SB^2*Mass[F[2, {j1}]]^2)*(dZbarSf1[1, s1, 2, j1]*
            USf[2, j1][1, 2] + dZbarSf1[2, s1, 2, j1]*USf[2, j1][2, 2]) + 
         2*(CB^3*MW^4*SW^3*(C2B*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[3, 
                  3])) + CW^2*S2B*dZHiggs1[3, 4]) + CW^4*SB*Mass[F[2, {j1}]]*
            (MW^2*S2B*SW*dMf1[2, j1] - ((S2B*(2*dSW1*MW^2 + SW*(dMWsq1 - 
                    MW^2*(2*dZe1 + dZHiggs1[3, 3]))))/2 + MW^2*SW*
                (2*dCB1*SB + CB^2*dZHiggs1[3, 4]))*Mass[F[2, {j1}]]))*
          USf[2, j1][s1, 2])))/(CB^3*CW^4*MW^4*SW^3)}}, 
 C[S[4], S[4], S[12, {s2, j2}], -S[12, {s1, j1}]] == 
  {{((-I/4)*EL^2*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s2, 1]]*
        (C2B*(1 - 2*CW^2)*MW^2 + 2*CW^2*Mass[F[2, {j1}]]^2)*
        USf[2, j1][s1, 1] - 2*Conjugate[USf[2, j1][s2, 2]]*
        (C2B*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s1, 2]))/
     (CW^2*MW^2*SW^2), ((-I/8)*EL^2*IndexDelta[j1, j2]*
      (Conjugate[USf[2, j1][s2, 1]]*(CB*CW^2*MW^2*SW*(C2B*(1 - 2*CW^2)*MW^2 + 
           2*CW^2*Mass[F[2, {j1}]]^2)*(dZbarSf1[1, s1, 2, j1]*
            USf[2, j1][1, 1] + dZbarSf1[2, s1, 2, j1]*USf[2, j1][2, 1]) - 
         2*(2*CW^4*(MW^2*SW*(2*dCB1 + SB*dZHiggs1[3, 4]) + 
             CB*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[4, 4]))))*
            Mass[F[2, {j1}]]^2 + CB*(MW^4*(CW^2*(1 - 2*CW^2)*S2B*SW*
                dZHiggs1[3, 4] - C2B*(2*(1 - 2*CW^2)*dSW1*SW^2 + 
                 CW^2*(2*dSW1 + (1 - 2*CW^2)*SW*(2*dZe1 + dZHiggs1[4, 
                      4])))) - 4*CW^4*MW^2*SW*dMf1[2, j1]*Mass[F[2, {j1}]]))*
          USf[2, j1][s1, 1]) + CB*CW^2*MW^2*SW*
        ((Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
          (C2B*(1 - 2*CW^2)*MW^2 + 2*CW^2*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s1, 1] - 2*(Conjugate[USf[2, j1][1, 2]]*
            dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 2]]*
            dZSf1[2, s2, 2, j2])*(C2B*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s1, 2]) - 2*Conjugate[USf[2, j1][s2, 2]]*
        (CB*CW^2*MW^2*SW*(C2B*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*
          (dZbarSf1[1, s1, 2, j1]*USf[2, j1][1, 2] + dZbarSf1[2, s1, 2, j1]*
            USf[2, j1][2, 2]) + 
         2*(CW^4*(MW^2*SW*(2*dCB1 + SB*dZHiggs1[3, 4]) + 
             CB*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[4, 4]))))*
            Mass[F[2, {j1}]]^2 - CB*(MW^4*SW^3*(CW^2*S2B*dZHiggs1[3, 4] - C2B*
                (2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[4, 4]))) + 
             2*CW^4*MW^2*SW*dMf1[2, j1]*Mass[F[2, {j1}]]))*
          USf[2, j1][s1, 2])))/(CB*CW^4*MW^4*SW^3)}}, 
 C[S[3], S[4], S[12, {s2, j2}], -S[12, {s1, j1}]] == 
  {{(I*EL^2*SB^2*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s2, 1]]*
        (CB^2*(1 - 2*CW^2)*MW^2 + CW^2*Mass[F[2, {j1}]]^2)*
        USf[2, j1][s1, 1] - Conjugate[USf[2, j1][s2, 2]]*
        (2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s1, 2]))/
     (CW^2*MW^2*S2B*SW^2), ((I/8)*EL^2*IndexDelta[j1, j2]*
      (Conjugate[USf[2, j1][s2, 1]]*(CW^2*MW^2*S2B*SW*
          (CB^2*(1 - 2*CW^2)*MW^2 + CW^2*Mass[F[2, {j1}]]^2)*
          (dZbarSf1[1, s1, 2, j1]*USf[2, j1][1, 1] + dZbarSf1[2, s1, 2, j1]*
            USf[2, j1][2, 1]) + 
         (CB^2*MW^4*S2B*(4*(dSW1*SW^2 + CW^2*(dSW1 - dZe1*SW)*(1 - 2*SW^2)) + 
             CW^2*(1 - 2*CW^2)*SW*(dZHiggs1[3, 3] + dZHiggs1[4, 4])) + 
           CW^4*Mass[F[2, {j1}]]*(4*MW^2*S2B*SW*dMf1[2, j1] - 
             (4*dSW1*MW^2*S2B + SW*(2*dMWsq1*S2B + MW^2*(8*dCB1*SB + 
                   2*dZHiggs1[3, 4] - S2B*(4*dZe1 + dZHiggs1[3, 3] + 
                     dZHiggs1[4, 4]))))*Mass[F[2, {j1}]]))*
          USf[2, j1][s1, 1]) + CW^2*MW^2*S2B*SW*
        ((Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
          (CB^2*(1 - 2*CW^2)*MW^2 + CW^2*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s1, 1] - (Conjugate[USf[2, j1][1, 2]]*
            dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 2]]*
            dZSf1[2, s2, 2, j2])*(2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s1, 2]) - Conjugate[USf[2, j1][s2, 2]]*
        (CW^2*MW^2*S2B*SW*(2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*
          (dZbarSf1[1, s1, 2, j1]*USf[2, j1][1, 2] + dZbarSf1[2, s1, 2, j1]*
            USf[2, j1][2, 2]) + (2*CB^2*MW^4*S2B*SW^3*(4*dSW1*SW + 
             CW^2*(4*dZe1 + dZHiggs1[3, 3] + dZHiggs1[4, 4])) - 
           CW^4*Mass[F[2, {j1}]]*(4*MW^2*S2B*SW*dMf1[2, j1] - 
             (S2B*(4*dSW1*MW^2 + 2*(dMWsq1 - 2*dZe1*MW^2)*SW) + MW^2*SW*
                (8*dCB1*SB + 2*dZHiggs1[3, 4] - S2B*(dZHiggs1[3, 3] + 
                   dZHiggs1[4, 4])))*Mass[F[2, {j1}]]))*USf[2, j1][s1, 2])))/
     (CB^2*CW^4*MW^4*SW^3)}}, C[S[3], S[3], S[13, {s2, j2, o1}], 
   -S[13, {s1, j1, o2}]] == 
  {{((-I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (6*CB^2*CW^2*Mass[F[3, {j1}]]^2*(Conjugate[USf[3, j1][s2, 1]]*
          USf[3, j1][s1, 1] + Conjugate[USf[3, j1][s2, 2]]*
          USf[3, j1][s1, 2]) + C2B*MW^2*SB^2*
        ((1 - 4*CW^2)*Conjugate[USf[3, j1][s2, 1]]*USf[3, j1][s1, 1] - 
         4*SW^2*Conjugate[USf[3, j1][s2, 2]]*USf[3, j1][s1, 2])))/
     (CW^2*MW^2*SB^2*SW^2), ((-I/24)*EL^2*IndexDelta[j1, j2]*
      IndexDelta[o1, o2]*(Conjugate[USf[3, j1][s2, 1]]*
        (CW^2*MW^2*SB*SW*(C2B*(1 - 4*CW^2)*MW^2*SB^2 + 6*CB^2*CW^2*
            Mass[F[3, {j1}]]^2)*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + 
           dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) - 
         2*(MW^4*SB^3*(CB^2*(dSW1*(6*SW^2 - 8*SW^4) - CW^2*(6*dSW1 + 
                 (1 - 4*CW^2)*SW*(2*dZe1 + dZHiggs1[3, 3]))) + 
             SB^2*(2*(1 - 4*CW^2)*dSW1*SW^2 + CW^2*(6*dSW1 + (1 - 4*CW^2)*SW*
                  (2*dZe1 + dZHiggs1[3, 3]))) - CW^2*(1 - 4*CW^2)*S2B*SW*
              dZHiggs1[3, 4]) - 6*CB*CW^4*Mass[F[3, {j1}]]*
            (MW^2*S2B*SW*dMf1[3, j1] - (CB*(2*dSB1*MW^2*SW + 
                 SB*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[3, 
                        3])))) - MW^2*SB^2*SW*dZHiggs1[3, 4])*
              Mass[F[3, {j1}]]))*USf[3, j1][s1, 1]) + 
       CW^2*MW^2*SB*SW*((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s2, 3, j2] + 
           Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s2, 3, j2])*
          (C2B*(1 - 4*CW^2)*MW^2*SB^2 + 6*CB^2*CW^2*Mass[F[3, {j1}]]^2)*
          USf[3, j1][s1, 1] - 2*(Conjugate[USf[3, j1][1, 2]]*
            dZSf1[1, s2, 3, j2] + Conjugate[USf[3, j1][2, 2]]*
            dZSf1[2, s2, 3, j2])*(2*C2B*MW^2*SB^2*SW^2 - 
           3*CB^2*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]) - 
       2*Conjugate[USf[3, j1][s2, 2]]*(CW^2*MW^2*SB*SW*
          (2*C2B*MW^2*SB^2*SW^2 - 3*CB^2*CW^2*Mass[F[3, {j1}]]^2)*
          (dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 2] + dZbarSf1[2, s1, 3, j1]*
            USf[3, j1][2, 2]) - 2*(2*MW^4*SB^3*SW^3*(2*dSW1*SB^2*SW - 
             CB^2*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[3, 3])) + 
             CW^2*(SB^2*(2*dZe1 + dZHiggs1[3, 3]) - S2B*dZHiggs1[3, 4])) + 
           3*CB*CW^4*Mass[F[3, {j1}]]*(MW^2*S2B*SW*dMf1[3, j1] - 
             ((2*dSW1*MW^2*S2B + SW*(dMWsq1*S2B + MW^2*(4*CB*dSB1 - 
                    S2B*(2*dZe1 + dZHiggs1[3, 3]) - 2*SB^2*dZHiggs1[3, 4])))*
               Mass[F[3, {j1}]])/2))*USf[3, j1][s1, 2])))/
     (CW^4*MW^4*SB^3*SW^3)}}, C[S[4], S[4], S[13, {s2, j2, o1}], 
   -S[13, {s1, j1, o2}]] == 
  {{((I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s2, 1]]*(C2B*(1 - 4*CW^2)*MW^2 - 
         6*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 1] - 
       2*Conjugate[USf[3, j1][s2, 2]]*(2*C2B*MW^2*SW^2 + 
         3*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]))/(CW^2*MW^2*SW^2), 
    ((I/24)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s2, 1]]*(CW^2*MW^2*SB*SW*(C2B*(1 - 4*CW^2)*MW^2 - 
           6*CW^2*Mass[F[3, {j1}]]^2)*(dZbarSf1[1, s1, 3, j1]*
            USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) + 
         2*(6*CW^4*(2*dSW1*MW^2*SB + SW*(dMWsq1*SB + MW^2*(2*dSB1 - 
                 CB*dZHiggs1[3, 4] - SB*(2*dZe1 + dZHiggs1[4, 4]))))*
            Mass[F[3, {j1}]]^2 - SB*(MW^4*(CW^2*(1 - 4*CW^2)*S2B*SW*
                dZHiggs1[3, 4] - SB^2*(dSW1*(6*SW^2 - 8*SW^4) - 
                 CW^2*(6*dSW1 + (1 - 4*CW^2)*SW*(2*dZe1 + dZHiggs1[4, 4]))) - 
               CB^2*(2*(1 - 4*CW^2)*dSW1*SW^2 + CW^2*(6*dSW1 + (1 - 4*CW^2)*
                    SW*(2*dZe1 + dZHiggs1[4, 4])))) + 12*CW^4*MW^2*SW*
              dMf1[3, j1]*Mass[F[3, {j1}]]))*USf[3, j1][s1, 1]) + 
       CW^2*MW^2*SB*SW*((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s2, 3, j2] + 
           Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s2, 3, j2])*
          (C2B*(1 - 4*CW^2)*MW^2 - 6*CW^2*Mass[F[3, {j1}]]^2)*
          USf[3, j1][s1, 1] - 2*(Conjugate[USf[3, j1][1, 2]]*
            dZSf1[1, s2, 3, j2] + Conjugate[USf[3, j1][2, 2]]*
            dZSf1[2, s2, 3, j2])*(2*C2B*MW^2*SW^2 + 
           3*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]) - 
       2*Conjugate[USf[3, j1][s2, 2]]*(CW^2*MW^2*SB*SW*(2*C2B*MW^2*SW^2 + 
           3*CW^2*Mass[F[3, {j1}]]^2)*(dZbarSf1[1, s1, 3, j1]*
            USf[3, j1][1, 2] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 2]) - 
         2*(3*CW^4*(2*dSW1*MW^2*SB + SW*(dMWsq1*SB + MW^2*(2*dSB1 - 
                 CB*dZHiggs1[3, 4] - SB*(2*dZe1 + dZHiggs1[4, 4]))))*
            Mass[F[3, {j1}]]^2 + SB*(2*MW^4*SW^3*(CW^2*S2B*dZHiggs1[3, 4] - 
               C2B*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[4, 4]))) - 
             6*CW^4*MW^2*SW*dMf1[3, j1]*Mass[F[3, {j1}]]))*
          USf[3, j1][s1, 2])))/(CW^4*MW^4*SB*SW^3)}}, 
 C[S[3], S[4], S[13, {s2, j2, o1}], -S[13, {s1, j1, o2}]] == 
  {{((-I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s2, 1]]*((1 - 4*CW^2)*MW^2*S2B*SB + 
         6*CB*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 1] - 
       2*Conjugate[USf[3, j1][s2, 2]]*(2*MW^2*S2B*SB*SW^2 - 
         3*CB*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]))/
     (CW^2*MW^2*SB*SW^2), ((-I/24)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s2, 1]]*(CW^2*MW^2*S2B*SW*
          ((1 - 4*CW^2)*MW^2*SB^2 + 3*CW^2*Mass[F[3, {j1}]]^2)*
          (dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, j1]*
            USf[3, j1][2, 1]) - (6*CW^4*(2*dSW1*MW^2*S2B + 
             (SW*(2*dMWsq1*S2B + MW^2*(8*CB*dSB1 - 2*dZHiggs1[3, 4] - 
                  S2B*(4*dZe1 + dZHiggs1[3, 3] + dZHiggs1[4, 4]))))/2)*
            Mass[F[3, {j1}]]^2 - CB*(2*MW^4*SB^3*(4*dSW1*SW^2 - 4*CW^4*SW*
                (4*dZe1 + dZHiggs1[3, 3] + dZHiggs1[4, 4]) + CW^2*
                (4*dSW1*(3 - 4*SW^2) + SW*(4*dZe1 + dZHiggs1[3, 3] + 
                   dZHiggs1[4, 4]))) + 24*CW^4*MW^2*SB*SW*dMf1[3, j1]*
              Mass[F[3, {j1}]]))*USf[3, j1][s1, 1]) + 
       CW^2*MW^2*S2B*SW*((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s2, 3, j2] + 
           Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s2, 3, j2])*
          ((1 - 4*CW^2)*MW^2*SB^2 + 3*CW^2*Mass[F[3, {j1}]]^2)*
          USf[3, j1][s1, 1] - (Conjugate[USf[3, j1][1, 2]]*
            dZSf1[1, s2, 3, j2] + Conjugate[USf[3, j1][2, 2]]*
            dZSf1[2, s2, 3, j2])*(4*MW^2*SB^2*SW^2 - 
           3*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]) - 
       Conjugate[USf[3, j1][s2, 2]]*(CW^2*MW^2*S2B*SW*(4*MW^2*SB^2*SW^2 - 
           3*CW^2*Mass[F[3, {j1}]]^2)*(dZbarSf1[1, s1, 3, j1]*
            USf[3, j1][1, 2] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 2]) + 
         2*((3*CW^4*(4*dSW1*MW^2*S2B + SW*(2*dMWsq1*S2B + MW^2*(8*CB*dSB1 - 
                  2*dZHiggs1[3, 4] - S2B*(4*dZe1 + dZHiggs1[3, 3] + 
                    dZHiggs1[4, 4]))))*Mass[F[3, {j1}]]^2)/2 + 
           CB*(4*MW^4*SB^3*SW^3*(4*dSW1*SW + CW^2*(4*dZe1 + dZHiggs1[3, 3] + 
                 dZHiggs1[4, 4])) - 12*CW^4*MW^2*SB*SW*dMf1[3, j1]*
              Mass[F[3, {j1}]]))*USf[3, j1][s1, 2])))/
     (CW^4*MW^4*SB^2*SW^3)}}, C[S[3], S[3], S[14, {s2, j2, o1}], 
   -S[14, {s1, j1, o2}]] == 
  {{((-I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s2, 1]]*(C2B*CB^2*(1 + 2*CW^2)*MW^2 + 
         6*CW^2*SB^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 1] + 
       2*Conjugate[USf[4, j1][s2, 2]]*(C2B*CB^2*MW^2*SW^2 + 
         3*CW^2*SB^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]))/
     (CB^2*CW^2*MW^2*SW^2), ((-I/24)*EL^2*IndexDelta[j1, j2]*
      IndexDelta[o1, o2]*(Conjugate[USf[4, j1][s2, 1]]*
        (CW^2*MW^2*SW*(C2B*CB^3*(1 + 2*CW^2)*MW^2 + 3*CW^2*S2B*SB*
            Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s1, 4, j1]*USf[4, j1][1, 1] + 
           dZbarSf1[2, s1, 4, j1]*USf[4, j1][2, 1]) + 
         2*(CB^3*MW^4*(CB^2*(2*(1 + 2*CW^2)*dSW1*SW^2 - CW^2*(6*dSW1 - 
                 (1 + 2*CW^2)*SW*(2*dZe1 + dZHiggs1[3, 3]))) - 
             SB^2*(dSW1*(6*SW^2 - 4*SW^4) - CW^2*(6*dSW1 - (1 + 2*CW^2)*SW*
                  (2*dZe1 + dZHiggs1[3, 3]))) + CW^2*(1 + 2*CW^2)*S2B*SW*
              dZHiggs1[3, 4]) + 6*CW^4*SB*Mass[F[4, {j1}]]*
            (MW^2*S2B*SW*dMf1[4, j1] - ((S2B*(2*dSW1*MW^2 + SW*(dMWsq1 - 
                    MW^2*(2*dZe1 + dZHiggs1[3, 3]))))/2 + MW^2*SW*
                (2*dCB1*SB + CB^2*dZHiggs1[3, 4]))*Mass[F[4, {j1}]]))*
          USf[4, j1][s1, 1]) + CB*CW^2*MW^2*SW*
        ((Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s2, 4, j2])*
          (C2B*CB^2*(1 + 2*CW^2)*MW^2 + 6*CW^2*SB^2*Mass[F[4, {j1}]]^2)*
          USf[4, j1][s1, 1] + 2*(Conjugate[USf[4, j1][1, 2]]*
            dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j1][2, 2]]*
            dZSf1[2, s2, 4, j2])*(C2B*CB^2*MW^2*SW^2 + 3*CW^2*SB^2*
            Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]) + 
       2*Conjugate[USf[4, j1][s2, 2]]*(CB*CW^2*MW^2*SW*(C2B*CB^2*MW^2*SW^2 + 
           3*CW^2*SB^2*Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s1, 4, j1]*
            USf[4, j1][1, 2] + dZbarSf1[2, s1, 4, j1]*USf[4, j1][2, 2]) + 
         2*(CB^3*MW^4*SW^3*(C2B*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[3, 
                  3])) + CW^2*S2B*dZHiggs1[3, 4]) + 3*CW^4*SB*
            Mass[F[4, {j1}]]*(MW^2*S2B*SW*dMf1[4, j1] - 
             ((S2B*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[3, 
                       3]))))/2 + MW^2*SW*(2*dCB1*SB + CB^2*dZHiggs1[3, 4]))*
              Mass[F[4, {j1}]]))*USf[4, j1][s1, 2])))/
     (CB^3*CW^4*MW^4*SW^3)}}, C[S[4], S[4], S[14, {s2, j2, o1}], 
   -S[14, {s1, j1, o2}]] == 
  {{((I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s2, 1]]*(C2B*(1 + 2*CW^2)*MW^2 - 
         6*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 1] + 
       2*Conjugate[USf[4, j1][s2, 2]]*(C2B*MW^2*SW^2 - 
         3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]))/(CW^2*MW^2*SW^2), 
    ((I/24)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s2, 1]]*(CB*CW^2*MW^2*SW*(C2B*(1 + 2*CW^2)*MW^2 - 
           6*CW^2*Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s1, 4, j1]*
            USf[4, j1][1, 1] + dZbarSf1[2, s1, 4, j1]*USf[4, j1][2, 1]) + 
         2*(6*CW^4*(MW^2*SW*(2*dCB1 + SB*dZHiggs1[3, 4]) + 
             CB*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[4, 4]))))*
            Mass[F[4, {j1}]]^2 - CB*(MW^4*(CW^2*(1 + 2*CW^2)*S2B*SW*
                dZHiggs1[3, 4] - CB^2*(2*(1 + 2*CW^2)*dSW1*SW^2 - 
                 CW^2*(6*dSW1 - (1 + 2*CW^2)*SW*(2*dZe1 + dZHiggs1[4, 4]))) + 
               SB^2*(dSW1*(6*SW^2 - 4*SW^4) - CW^2*(6*dSW1 - (1 + 2*CW^2)*SW*
                    (2*dZe1 + dZHiggs1[4, 4])))) + 12*CW^4*MW^2*SW*
              dMf1[4, j1]*Mass[F[4, {j1}]]))*USf[4, j1][s1, 1]) + 
       CB*CW^2*MW^2*SW*((Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s2, 4, j2])*
          (C2B*(1 + 2*CW^2)*MW^2 - 6*CW^2*Mass[F[4, {j1}]]^2)*
          USf[4, j1][s1, 1] + 2*(Conjugate[USf[4, j1][1, 2]]*
            dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j1][2, 2]]*
            dZSf1[2, s2, 4, j2])*(C2B*MW^2*SW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*
          USf[4, j1][s1, 2]) + 2*Conjugate[USf[4, j1][s2, 2]]*
        (CB*CW^2*MW^2*SW*(C2B*MW^2*SW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*
          (dZbarSf1[1, s1, 4, j1]*USf[4, j1][1, 2] + dZbarSf1[2, s1, 4, j1]*
            USf[4, j1][2, 2]) + 
         2*(3*CW^4*(MW^2*SW*(2*dCB1 + SB*dZHiggs1[3, 4]) + 
             CB*(2*dSW1*MW^2 + SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[4, 4]))))*
            Mass[F[4, {j1}]]^2 - CB*(MW^4*SW^3*(CW^2*S2B*dZHiggs1[3, 4] - C2B*
                (2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[4, 4]))) + 
             6*CW^4*MW^2*SW*dMf1[4, j1]*Mass[F[4, {j1}]]))*
          USf[4, j1][s1, 2])))/(CB*CW^4*MW^4*SW^3)}}, 
 C[S[3], S[4], S[14, {s2, j2, o1}], -S[14, {s1, j1, o2}]] == 
  {{((-I/3)*EL^2*SB^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s2, 1]]*(CB^2*(1 + 2*CW^2)*MW^2 - 
         3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 1] + 
       Conjugate[USf[4, j1][s2, 2]]*(2*CB^2*MW^2*SW^2 - 
         3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]))/(CW^2*MW^2*S2B*SW^2), 
    ((-I/24)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s2, 1]]*(CW^2*MW^2*S2B*SW*
          (CB^2*(1 + 2*CW^2)*MW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*
          (dZbarSf1[1, s1, 4, j1]*USf[4, j1][1, 1] + dZbarSf1[2, s1, 4, j1]*
            USf[4, j1][2, 1]) + 
         (6*CW^4*(MW^2*SW*(4*dCB1*SB + dZHiggs1[3, 4]) + 
             (S2B*(4*dSW1*MW^2 + SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZHiggs1[3, 
                     3] + dZHiggs1[4, 4]))))/2)*Mass[F[4, {j1}]]^2 + 
           SB*(2*CB^3*MW^4*(4*dSW1*SW^2 + 2*CW^4*SW*(4*dZe1 + dZHiggs1[3, 
                  3] + dZHiggs1[4, 4]) - CW^2*(4*dSW1*(3 - 2*SW^2) - 
                 SW*(4*dZe1 + dZHiggs1[3, 3] + dZHiggs1[4, 4]))) - 
             24*CB*CW^4*MW^2*SW*dMf1[4, j1]*Mass[F[4, {j1}]]))*
          USf[4, j1][s1, 1]) + CW^2*MW^2*S2B*SW*
        ((Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s2, 4, j2])*
          (CB^2*(1 + 2*CW^2)*MW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*
          USf[4, j1][s1, 1] + (Conjugate[USf[4, j1][1, 2]]*
            dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j1][2, 2]]*
            dZSf1[2, s2, 4, j2])*(2*CB^2*MW^2*SW^2 - 
           3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]) + 
       Conjugate[USf[4, j1][s2, 2]]*(CW^2*MW^2*S2B*SW*(2*CB^2*MW^2*SW^2 - 
           3*CW^2*Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s1, 4, j1]*
            USf[4, j1][1, 2] + dZbarSf1[2, s1, 4, j1]*USf[4, j1][2, 2]) + 
         2*(3*CW^4*(MW^2*SW*(4*dCB1*SB + dZHiggs1[3, 4]) + 
             (S2B*(4*dSW1*MW^2 + SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZHiggs1[3, 
                     3] + dZHiggs1[4, 4]))))/2)*Mass[F[4, {j1}]]^2 + 
           SB*(2*CB^3*MW^4*SW^3*(4*dSW1*SW + CW^2*(4*dZe1 + dZHiggs1[3, 3] + 
                 dZHiggs1[4, 4])) - 12*CB*CW^4*MW^2*SW*dMf1[4, j1]*
              Mass[F[4, {j1}]]))*USf[4, j1][s1, 2])))/
     (CB^2*CW^4*MW^4*SW^3)}}, C[S[1], S[2], S[11, {j2}], -S[11, {j1}]] == 
  {{((I/4)*EL^2*S2A*IndexDelta[j1, j2])/(CW^2*SW^2), 
    ((I/8)*EL^2*S2A*(4*dSW1*SW^2 - CW^2*(4*(dSW1 - dZe1*SW) - 
         SW*(dZbarSf1[1, 1, 1, j1] + dZHiggs1[1, 1] + dZHiggs1[2, 2] + 
           dZSf1[1, 1, 1, j2])))*IndexDelta[j1, j2])/(CW^4*SW^3)}}, 
 C[S[1], S[2], S[12, {s2, j2}], -S[12, {s1, j1}]] == 
  {{((I/4)*EL^2*S2A*IndexDelta[j1, j2]*(Conjugate[USf[2, j1][s2, 1]]*
        (CB^2*(1 - 2*CW^2)*MW^2 + CW^2*Mass[F[2, {j1}]]^2)*
        USf[2, j1][s1, 1] - Conjugate[USf[2, j1][s2, 2]]*
        (2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s1, 2]))/
     (CB^2*CW^2*MW^2*SW^2), ((I/8)*EL^2*IndexDelta[j1, j2]*
      (Conjugate[USf[2, j1][s2, 1]]*(CB*CW^2*MW^2*S2A*SW*
          (CB^2*(1 - 2*CW^2)*MW^2 + CW^2*Mass[F[2, {j1}]]^2)*
          (dZbarSf1[1, s1, 2, j1]*USf[2, j1][1, 1] + dZbarSf1[2, s1, 2, j1]*
            USf[2, j1][2, 1]) + (CB^3*MW^4*S2A*(4*(1 - 2*CW^2)*dSW1*SW^2 + 
             CW^2*(4*dSW1 + (1 - 2*CW^2)*SW*(4*dZe1 + dZHiggs1[1, 1] + 
                 dZHiggs1[2, 2]))) + CW^4*Mass[F[2, {j1}]]*
            (4*CB*MW^2*S2A*SW*dMf1[2, j1] - (4*dCB1*MW^2*S2A*SW + CB*
                (4*dSW1*MW^2*S2A + SW*(2*dMWsq1*S2A + MW^2*(2*(CA^2 + SA^2)*
                      dZHiggs1[1, 2] - S2A*(4*dZe1 + dZHiggs1[1, 1] + 
                       dZHiggs1[2, 2])))))*Mass[F[2, {j1}]]))*
          USf[2, j1][s1, 1]) + CB*CW^2*MW^2*S2A*SW*
        ((Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
          (CB^2*(1 - 2*CW^2)*MW^2 + CW^2*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s1, 1] - (Conjugate[USf[2, j1][1, 2]]*
            dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 2]]*
            dZSf1[2, s2, 2, j2])*(2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*
          USf[2, j1][s1, 2]) - Conjugate[USf[2, j1][s2, 2]]*
        (CB*CW^2*MW^2*S2A*SW*(2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*
          (dZbarSf1[1, s1, 2, j1]*USf[2, j1][1, 2] + dZbarSf1[2, s1, 2, j1]*
            USf[2, j1][2, 2]) + (2*CB^3*MW^4*S2A*SW^3*(4*dSW1*SW + 
             CW^2*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[2, 2])) - 
           CW^4*Mass[F[2, {j1}]]*(4*CB*MW^2*S2A*SW*dMf1[2, j1] - 
             (4*dCB1*MW^2*S2A*SW + CB*(4*dSW1*MW^2*S2A + SW*(2*dMWsq1*S2A + 
                   MW^2*(2*(CA^2 + SA^2)*dZHiggs1[1, 2] - S2A*(4*dZe1 + 
                       dZHiggs1[1, 1] + dZHiggs1[2, 2])))))*
              Mass[F[2, {j1}]]))*USf[2, j1][s1, 2])))/
     (CB^3*CW^4*MW^4*SW^3)}}, C[S[1], S[2], S[13, {s2, j2, o1}], 
   -S[13, {s1, j1, o2}]] == 
  {{((-I/12)*EL^2*S2A*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s2, 1]]*((1 - 4*CW^2)*MW^2*SB^2 + 
         3*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 1] - 
       Conjugate[USf[3, j1][s2, 2]]*(4*MW^2*SB^2*SW^2 - 
         3*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]))/
     (CW^2*MW^2*SB^2*SW^2), ((-I/24)*EL^2*IndexDelta[j1, j2]*
      IndexDelta[o1, o2]*(Conjugate[USf[3, j1][s2, 1]]*
        (CW^2*MW^2*S2A*SB*SW*((1 - 4*CW^2)*MW^2*SB^2 + 
           3*CW^2*Mass[F[3, {j1}]]^2)*(dZbarSf1[1, s1, 3, j1]*
            USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) + 
         (MW^4*S2A*SB^3*(4*(1 - 4*CW^2)*dSW1*SW^2 + 
             CW^2*(12*dSW1 + (1 - 4*CW^2)*SW*(4*dZe1 + dZHiggs1[1, 1] + 
                 dZHiggs1[2, 2]))) + 3*CW^4*Mass[F[3, {j1}]]*
            (4*MW^2*S2A*SB*SW*dMf1[3, j1] - (4*dSW1*MW^2*S2A*SB + SW*
                (4*dSB1*MW^2*S2A + SB*(2*dMWsq1*S2A - MW^2*(2*(CA^2 + SA^2)*
                      dZHiggs1[1, 2] + S2A*(4*dZe1 + dZHiggs1[1, 1] + 
                       dZHiggs1[2, 2])))))*Mass[F[3, {j1}]]))*
          USf[3, j1][s1, 1]) + CW^2*MW^2*S2A*SB*SW*
        ((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s2, 3, j2] + 
           Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s2, 3, j2])*
          ((1 - 4*CW^2)*MW^2*SB^2 + 3*CW^2*Mass[F[3, {j1}]]^2)*
          USf[3, j1][s1, 1] - (Conjugate[USf[3, j1][1, 2]]*
            dZSf1[1, s2, 3, j2] + Conjugate[USf[3, j1][2, 2]]*
            dZSf1[2, s2, 3, j2])*(4*MW^2*SB^2*SW^2 - 
           3*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j1][s1, 2]) - 
       Conjugate[USf[3, j1][s2, 2]]*(CW^2*MW^2*S2A*SB*SW*(4*MW^2*SB^2*SW^2 - 
           3*CW^2*Mass[F[3, {j1}]]^2)*(dZbarSf1[1, s1, 3, j1]*
            USf[3, j1][1, 2] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 2]) + 
         (4*MW^4*S2A*SB^3*SW^3*(4*dSW1*SW + CW^2*(4*dZe1 + dZHiggs1[1, 1] + 
               dZHiggs1[2, 2])) - 3*CW^4*Mass[F[3, {j1}]]*
            (4*MW^2*S2A*SB*SW*dMf1[3, j1] - (4*dSW1*MW^2*S2A*SB + SW*
                (4*dSB1*MW^2*S2A + SB*(2*dMWsq1*S2A - MW^2*(2*(CA^2 + SA^2)*
                      dZHiggs1[1, 2] + S2A*(4*dZe1 + dZHiggs1[1, 1] + 
                       dZHiggs1[2, 2])))))*Mass[F[3, {j1}]]))*
          USf[3, j1][s1, 2])))/(CW^4*MW^4*SB^3*SW^3)}}, 
 C[S[1], S[2], S[14, {s2, j2, o1}], -S[14, {s1, j1, o2}]] == 
  {{((-I/12)*EL^2*S2A*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s2, 1]]*(CB^2*(1 + 2*CW^2)*MW^2 - 
         3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 1] + 
       Conjugate[USf[4, j1][s2, 2]]*(2*CB^2*MW^2*SW^2 - 
         3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]))/
     (CB^2*CW^2*MW^2*SW^2), ((-I/24)*EL^2*IndexDelta[j1, j2]*
      IndexDelta[o1, o2]*(Conjugate[USf[4, j1][s2, 1]]*
        (CB*CW^2*MW^2*S2A*SW*(CB^2*(1 + 2*CW^2)*MW^2 - 
           3*CW^2*Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s1, 4, j1]*
            USf[4, j1][1, 1] + dZbarSf1[2, s1, 4, j1]*USf[4, j1][2, 1]) + 
         (CB^3*MW^4*S2A*(4*(1 + 2*CW^2)*dSW1*SW^2 - 
             CW^2*(12*dSW1 - (1 + 2*CW^2)*SW*(4*dZe1 + dZHiggs1[1, 1] + 
                 dZHiggs1[2, 2]))) - 3*CW^4*Mass[F[4, {j1}]]*
            (4*CB*MW^2*S2A*SW*dMf1[4, j1] - (4*dCB1*MW^2*S2A*SW + CB*
                (4*dSW1*MW^2*S2A + SW*(2*dMWsq1*S2A + MW^2*(2*(CA^2 + SA^2)*
                      dZHiggs1[1, 2] - S2A*(4*dZe1 + dZHiggs1[1, 1] + 
                       dZHiggs1[2, 2])))))*Mass[F[4, {j1}]]))*
          USf[4, j1][s1, 1]) + CB*CW^2*MW^2*S2A*SW*
        ((Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s2, 4, j2])*
          (CB^2*(1 + 2*CW^2)*MW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*
          USf[4, j1][s1, 1] + (Conjugate[USf[4, j1][1, 2]]*
            dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j1][2, 2]]*
            dZSf1[2, s2, 4, j2])*(2*CB^2*MW^2*SW^2 - 
           3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j1][s1, 2]) + 
       Conjugate[USf[4, j1][s2, 2]]*(CB*CW^2*MW^2*S2A*SW*(2*CB^2*MW^2*SW^2 - 
           3*CW^2*Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s1, 4, j1]*
            USf[4, j1][1, 2] + dZbarSf1[2, s1, 4, j1]*USf[4, j1][2, 2]) + 
         (2*CB^3*MW^4*S2A*SW^3*(4*dSW1*SW + CW^2*(4*dZe1 + dZHiggs1[1, 1] + 
               dZHiggs1[2, 2])) - 3*CW^4*Mass[F[4, {j1}]]*
            (4*CB*MW^2*S2A*SW*dMf1[4, j1] - (4*dCB1*MW^2*S2A*SW + CB*
                (4*dSW1*MW^2*S2A + SW*(2*dMWsq1*S2A + MW^2*(2*(CA^2 + SA^2)*
                      dZHiggs1[1, 2] - S2A*(4*dZe1 + dZHiggs1[1, 1] + 
                       dZHiggs1[2, 2])))))*Mass[F[4, {j1}]]))*
          USf[4, j1][s1, 2])))/(CB^3*CW^4*MW^4*SW^3)}}, 
 C[S[1], S[5], S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{((-I/2)*EL^2*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s1, 1]]*(CAB*MW^2*S2B^2 - 
         4*CA*CB^3*Mass[F[3, {j1}]]^2 + 4*SA*SB^3*Mass[F[4, {j2}]]^2)*
        USf[4, j2][s2, 1] - 2*S2B*SBA*Conjugate[USf[3, j1][s1, 2]]*
        Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))/
     (Sqrt[2]*MW^2*S2B^2*SW^2), (I*Sqrt[2]*EL^2*IndexDelta[o1, o2]*
      (MW^2*S2B*SW*Conjugate[dCKM1[j1, j2]]*(Conjugate[USf[3, j1][s1, 1]]*
          (CA*CB^3*Mass[F[3, {j1}]]^2 - SB^2*(CAB*CB^2*MW^2 + 
             SA*SB*Mass[F[4, {j2}]]^2))*USf[4, j2][s2, 1] + 
         (S2B*SBA*Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
           Mass[F[4, {j2}]]*USf[4, j2][s2, 2])/2) - Conjugate[CKM[j1, j2]]*
        (Conjugate[USf[3, j1][s1, 1]]*((MW^2*S2B*SW*(CAB*MW^2*S2B^2 - 
              4*CA*CB^3*Mass[F[3, {j1}]]^2 + 4*SA*SB^3*Mass[F[4, {j2}]]^2)*
             (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, 
                j2]*USf[4, j2][2, 1]))/8 - 
           (CB^3*(2*CA*MW^2*S2B*SW*dMf1[3, j1]*Mass[F[3, {j1}]] + 
               ((MW^2*S2B*SA*SW*dZHiggs1[1, 2] - CA*(4*dSW1*MW^2*S2B + 
                    SW*(2*dMWsq1*S2B + MW^2*(8*CB*dSB1 - S2B*(4*dZe1 + 
                          dZHiggs1[1, 1] + dZHiggs1[5, 5]) - 2*SB^2*dZHiggs1[
                          6, 5]))))*Mass[F[3, {j1}]]^2)/2) + 
             SB^3*(CB^3*MW^4*(CAB*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + 
                     dZHiggs1[5, 5])) - SAB*SW*(dZHiggs1[1, 2] + dZHiggs1[6, 
                    5])) - 2*MW^2*S2B*SA*SW*dMf1[4, j2]*Mass[F[4, {j2}]] + 
               ((S2B*(4*dSW1*MW^2*SA + SW*(2*dMWsq1*SA + MW^2*(CA*dZHiggs1[1, 
                          2] - SA*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[5, 
                          5])))))/2 + MW^2*SA*SW*(4*dCB1*SB + CB^2*dZHiggs1[
                     6, 5]))*Mass[F[4, {j2}]]^2))*USf[4, j2][s2, 1]) - 
         (S2B*(MW^2*SW*((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
                Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*(
                CA*CB^3*Mass[F[3, {j1}]]^2 - SB^2*(CAB*CB^2*MW^2 + 
                  SA*SB*Mass[F[4, {j2}]]^2))*USf[4, j2][s2, 1] + 
              (S2B*SBA*(Conjugate[USf[3, j1][1, 2]]*dZSf1[1, s1, 3, j1] + 
                 Conjugate[USf[3, j1][2, 2]]*dZSf1[2, s1, 3, j1])*
                Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[4, j2][s2, 2])/2) + 
            Conjugate[USf[3, j1][s1, 2]]*((MW^2*S2B*SBA*SW*Mass[F[3, {j1}]]*
                Mass[F[4, {j2}]]*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 2] + 
                 dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 2]))/2 + 
              (MW^2*S2B*SBA*SW*dMf1[4, j2]*Mass[F[3, {j1}]] + 
                (MW^2*S2B*SBA*SW*dMf1[3, j1] - (2*dCB1*MW^2*SB*SBA*SW + 
                    CB*(4*dSW1*MW^2*SB*SBA + SW*(2*dSB1*MW^2*SBA + 
                        SB*(2*dMWsq1*SBA - MW^2*(SBA*(4*dZe1 + dZHiggs1[1, 
                          1] + dZHiggs1[5, 5]) + CBA*(dZHiggs1[1, 2] - 
                          dZHiggs1[6, 5]))))))*Mass[F[3, {j1}]])*
                 Mass[F[4, {j2}]])*USf[4, j2][s2, 2])))/2)))/
     (MW^4*S2B^3*SW^3)}}, C[S[1], S[6], S[13, {s1, j1, o1}], 
   -S[14, {s2, j2, o2}]] == 
  {{((-I)*EL^2*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      ((Conjugate[USf[3, j1][s1, 1]]*(MW^2*S2B*SAB - 
          2*(CA*CB*Mass[F[3, {j1}]]^2 + SA*SB*Mass[F[4, {j2}]]^2))*
         USf[4, j2][s2, 1])/2 + CBA*Conjugate[USf[3, j1][s1, 2]]*
        Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))/
     (Sqrt[2]*MW^2*S2B*SW^2), ((-I)*Sqrt[2]*CB*EL^2*IndexDelta[o1, o2]*
      (2*CB*MW^2*SB^2*SW*Conjugate[dCKM1[j1, j2]]*
        (Conjugate[USf[3, j1][s1, 1]]*
          (CB*(MW^2*SAB*SB - CA*Mass[F[3, {j1}]]^2) - 
           SA*SB*Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1] + 
         CBA*Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*
          USf[4, j2][s2, 2]) + Conjugate[CKM[j1, j2]]*
        (Conjugate[USf[3, j1][s1, 1]]*(CB*MW^2*SB^2*SW*
            (CB*(MW^2*SAB*SB - CA*Mass[F[3, {j1}]]^2) - 
             SA*SB*Mass[F[4, {j2}]]^2)*(dZbarSf1[1, s2, 4, j2]*
              USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 1]) - 
           ((CB*S2B*Mass[F[3, {j1}]]*(4*CA*MW^2*SB*SW*dMf1[3, j1] + 
                (MW^2*SA*SB*SW*dZHiggs1[1, 2] - CA*(4*dSW1*MW^2*SB + 
                    SW*(2*dMWsq1*SB + MW^2*(4*dSB1 - CB*dZHiggs1[5, 6] - 
                        SB*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[6, 6])))))*
                 Mass[F[3, {j1}]]))/2 + SB^3*(CB^2*MW^4*(4*dSW1*SAB + 
                 SW*(CAB*(dZHiggs1[1, 2] - dZHiggs1[5, 6]) - SAB*(4*dZe1 + 
                     dZHiggs1[1, 1] + dZHiggs1[6, 6]))) + 4*CB*MW^2*SA*SW*
                dMf1[4, j2]*Mass[F[4, {j2}]] - (MW^2*SA*SW*(4*dCB1 + 
                   SB*dZHiggs1[5, 6]) + CB*(4*dSW1*MW^2*SA + 
                   SW*(2*dMWsq1*SA + MW^2*(CA*dZHiggs1[1, 2] - SA*(4*dZe1 + 
                         dZHiggs1[1, 1] + dZHiggs1[6, 6])))))*
                Mass[F[4, {j2}]]^2))*USf[4, j2][s2, 1]) + 
         SB*((MW^2*S2B*SW*((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
                Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*(
                CB*(MW^2*SAB*SB - CA*Mass[F[3, {j1}]]^2) - SA*SB*
                 Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1] + 
              CBA*(Conjugate[USf[3, j1][1, 2]]*dZSf1[1, s1, 3, j1] + 
                Conjugate[USf[3, j1][2, 2]]*dZSf1[2, s1, 3, j1])*Mass[
                F[3, {j1}]]*Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))/2 + 
           Conjugate[USf[3, j1][s1, 2]]*((CBA*MW^2*S2B*SW*Mass[F[3, {j1}]]*
               Mass[F[4, {j2}]]*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 2] + 
                dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 2]))/2 + 
             (CBA*MW^2*S2B*SW*dMf1[4, j2]*Mass[F[3, {j1}]] + 
               (CBA*MW^2*S2B*SW*dMf1[3, j1] - ((MW^2*S2B*SBA*SW*(dZHiggs1[1, 
                       2] + dZHiggs1[5, 6]) + CBA*(4*dSW1*MW^2*S2B + 
                      SW*(2*dMWsq1*S2B + MW^2*(4*(CB*dSB1 + dCB1*SB) - 
                          S2B*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[6, 6])))))*
                   Mass[F[3, {j1}]])/2)*Mass[F[4, {j2}]])*USf[4, j2][s2, 
               2])))))/(MW^4*S2B^3*SW^3)}}, 
 C[S[1], -S[5], S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}]] == 
  {{((-I/2)*EL^2*CKM[j1, j2]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j2][s2, 1]]*(CAB*MW^2*S2B^2 - 
         4*CA*CB^3*Mass[F[3, {j1}]]^2 + 4*SA*SB^3*Mass[F[4, {j2}]]^2)*
        USf[3, j1][s1, 1] - 2*S2B*SBA*Conjugate[USf[4, j2][s2, 2]]*
        Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 2]))/
     (Sqrt[2]*MW^2*S2B^2*SW^2), (I*Sqrt[2]*EL^2*IndexDelta[o1, o2]*
      (MW^2*S2B*SW*dCKM1[j1, j2]*(Conjugate[USf[4, j2][s2, 1]]*
          (CA*CB^3*Mass[F[3, {j1}]]^2 - SB^2*(CAB*CB^2*MW^2 + 
             SA*SB*Mass[F[4, {j2}]]^2))*USf[3, j1][s1, 1] + 
         (S2B*SBA*Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*
           Mass[F[4, {j2}]]*USf[3, j1][s1, 2])/2) - 
       CKM[j1, j2]*(Conjugate[USf[4, j2][s2, 1]]*
          ((MW^2*S2B*SW*(CAB*MW^2*S2B^2 - 4*CA*CB^3*Mass[F[3, {j1}]]^2 + 
              4*SA*SB^3*Mass[F[4, {j2}]]^2)*(dZbarSf1[1, s1, 3, j1]*
               USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]))/
            8 - (CB^3*(2*CA*MW^2*S2B*SW*dMf1[3, j1]*Mass[F[3, {j1}]] + 
               ((MW^2*S2B*SA*SW*dZHiggs1[1, 2] - CA*(4*dSW1*MW^2*S2B + 
                    SW*(2*dMWsq1*S2B + MW^2*(8*CB*dSB1 - S2B*(4*dZe1 + 
                          dZbarHiggs1[5, 5] + dZHiggs1[1, 1]) - 2*SB^2*
                         dZHiggs1[5, 6]))))*Mass[F[3, {j1}]]^2)/2) + 
             SB^3*(CB^3*MW^4*(CAB*(4*dSW1 - SW*(4*dZe1 + dZbarHiggs1[5, 5] + 
                     dZHiggs1[1, 1])) - SAB*SW*(dZHiggs1[1, 2] + dZHiggs1[5, 
                    6])) - 2*MW^2*S2B*SA*SW*dMf1[4, j2]*Mass[F[4, {j2}]] + 
               ((S2B*(4*dSW1*MW^2*SA + SW*(2*dMWsq1*SA - MW^2*(SA*(4*dZe1 + 
                          dZbarHiggs1[5, 5] + dZHiggs1[1, 1]) - CA*dZHiggs1[
                          1, 2]))))/2 + MW^2*SA*SW*(4*dCB1*SB + 
                   CB^2*dZHiggs1[5, 6]))*Mass[F[4, {j2}]]^2))*
            USf[3, j1][s1, 1]) - 
         (S2B*(MW^2*SW*((Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
                Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*(
                CA*CB^3*Mass[F[3, {j1}]]^2 - SB^2*(CAB*CB^2*MW^2 + 
                  SA*SB*Mass[F[4, {j2}]]^2))*USf[3, j1][s1, 1] + 
              (S2B*SBA*(Conjugate[USf[4, j2][1, 2]]*dZSf1[1, s2, 4, j2] + 
                 Conjugate[USf[4, j2][2, 2]]*dZSf1[2, s2, 4, j2])*
                Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 2])/2) + 
            Conjugate[USf[4, j2][s2, 2]]*((MW^2*S2B*SBA*SW*Mass[F[3, {j1}]]*
                Mass[F[4, {j2}]]*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 2] + 
                 dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 2]))/2 + 
              (MW^2*S2B*SBA*SW*dMf1[4, j2]*Mass[F[3, {j1}]] + 
                (MW^2*S2B*SBA*SW*dMf1[3, j1] - (2*dCB1*MW^2*SB*SBA*SW + 
                    CB*(4*dSW1*MW^2*SB*SBA + SW*(2*dSB1*MW^2*SBA + 
                        SB*(2*dMWsq1*SBA - MW^2*(SBA*(4*dZe1 + dZbarHiggs1[5, 
                          5] + dZHiggs1[1, 1]) + CBA*(dZHiggs1[1, 2] - 
                          dZHiggs1[5, 6]))))))*Mass[F[3, {j1}]])*
                 Mass[F[4, {j2}]])*USf[3, j1][s1, 2])))/2)))/
     (MW^4*S2B^3*SW^3)}}, C[S[1], -S[6], S[14, {s2, j2, o1}], 
   -S[13, {s1, j1, o2}]] == 
  {{((-I)*EL^2*CKM[j1, j2]*IndexDelta[o1, o2]*
      ((Conjugate[USf[4, j2][s2, 1]]*(MW^2*S2B*SAB - 
          2*(CA*CB*Mass[F[3, {j1}]]^2 + SA*SB*Mass[F[4, {j2}]]^2))*
         USf[3, j1][s1, 1])/2 + CBA*Conjugate[USf[4, j2][s2, 2]]*
        Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 2]))/
     (Sqrt[2]*MW^2*S2B*SW^2), ((-I)*Sqrt[2]*CB*EL^2*IndexDelta[o1, o2]*
      (2*CB*MW^2*SB^2*SW*dCKM1[j1, j2]*(Conjugate[USf[4, j2][s2, 1]]*
          (CB*(MW^2*SAB*SB - CA*Mass[F[3, {j1}]]^2) - 
           SA*SB*Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] + 
         CBA*Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*
          USf[3, j1][s1, 2]) + CKM[j1, j2]*(Conjugate[USf[4, j2][s2, 1]]*
          (CB*MW^2*SB^2*SW*(CB*(MW^2*SAB*SB - CA*Mass[F[3, {j1}]]^2) - 
             SA*SB*Mass[F[4, {j2}]]^2)*(dZbarSf1[1, s1, 3, j1]*
              USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) - 
           ((CB*S2B*Mass[F[3, {j1}]]*(4*CA*MW^2*SB*SW*dMf1[3, j1] + 
                (MW^2*SA*SB*SW*dZHiggs1[1, 2] - CA*(4*dSW1*MW^2*SB + 
                    SW*(2*dMWsq1*SB + MW^2*(4*dSB1 - CB*dZHiggs1[6, 5] - 
                        SB*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[6, 6])))))*
                 Mass[F[3, {j1}]]))/2 + SB^3*(CB^2*MW^4*(4*dSW1*SAB + 
                 SW*(CAB*(dZHiggs1[1, 2] - dZHiggs1[6, 5]) - SAB*(4*dZe1 + 
                     dZHiggs1[1, 1] + dZHiggs1[6, 6]))) + 4*CB*MW^2*SA*SW*
                dMf1[4, j2]*Mass[F[4, {j2}]] - (MW^2*SA*SW*(4*dCB1 + 
                   SB*dZHiggs1[6, 5]) + CB*(4*dSW1*MW^2*SA + 
                   SW*(2*dMWsq1*SA + MW^2*(CA*dZHiggs1[1, 2] - SA*(4*dZe1 + 
                         dZHiggs1[1, 1] + dZHiggs1[6, 6])))))*
                Mass[F[4, {j2}]]^2))*USf[3, j1][s1, 1]) + 
         SB*((MW^2*S2B*SW*((Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
                Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*(
                CB*(MW^2*SAB*SB - CA*Mass[F[3, {j1}]]^2) - SA*SB*
                 Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] + 
              CBA*(Conjugate[USf[4, j2][1, 2]]*dZSf1[1, s2, 4, j2] + 
                Conjugate[USf[4, j2][2, 2]]*dZSf1[2, s2, 4, j2])*Mass[
                F[3, {j1}]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 2]))/2 + 
           Conjugate[USf[4, j2][s2, 2]]*((CBA*MW^2*S2B*SW*Mass[F[3, {j1}]]*
               Mass[F[4, {j2}]]*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 2] + 
                dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 2]))/2 + 
             (CBA*MW^2*S2B*SW*dMf1[4, j2]*Mass[F[3, {j1}]] + 
               (CBA*MW^2*S2B*SW*dMf1[3, j1] - ((MW^2*S2B*SBA*SW*(dZHiggs1[1, 
                       2] + dZHiggs1[6, 5]) + CBA*(4*dSW1*MW^2*S2B + 
                      SW*(2*dMWsq1*S2B + MW^2*(4*(CB*dSB1 + dCB1*SB) - 
                          S2B*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[6, 6])))))*
                   Mass[F[3, {j1}]])/2)*Mass[F[4, {j2}]])*USf[3, j1][s1, 
               2])))))/(MW^4*S2B^3*SW^3)}}, 
 C[S[3], S[5], S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{(Sqrt[2]*EL^2*Conjugate[CKM[j1, j2]]*Conjugate[USf[3, j1][s1, 1]]*
      IndexDelta[o1, o2]*((C2B*MW^2*S2B^2)/4 - CB^4*Mass[F[3, {j1}]]^2 + 
       SB^4*Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1])/(MW^2*S2B^2*SW^2), 
    (Sqrt[2]*EL^2*IndexDelta[o1, o2]*(MW^2*S2B*SW*Conjugate[dCKM1[j1, j2]]*
        Conjugate[USf[3, j1][s1, 1]]*((C2B*MW^2*S2B^2)/4 - 
         CB^4*Mass[F[3, {j1}]]^2 + SB^4*Mass[F[4, {j2}]]^2)*
        USf[4, j2][s2, 1] + Conjugate[CKM[j1, j2]]*
        (Conjugate[USf[3, j1][s1, 1]]*((MW^2*S2B*SW*(C2B*MW^2*S2B^2 - 
              4*CB^4*Mass[F[3, {j1}]]^2 + 4*SB^4*Mass[F[4, {j2}]]^2)*
             (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, 
                j2]*USf[4, j2][2, 1]))/8 - 
           (CB^4*(2*MW^2*S2B*SW*dMf1[3, j1]*Mass[F[3, {j1}]] - 
               (CB*(4*dSW1*MW^2*SB + SW*(4*dSB1*MW^2 + SB*(2*dMWsq1 - 
                       MW^2*(4*dZe1 + dZHiggs1[3, 3] + dZHiggs1[5, 5])))) - 
                 MW^2*SB^2*SW*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))*
                Mass[F[3, {j1}]]^2) + SB^3*(CB^3*MW^4*(C2B*(4*dSW1 - 
                   SW*(4*dZe1 + dZHiggs1[3, 3] + dZHiggs1[5, 5])) - 
                 S2B*SW*(dZHiggs1[3, 4] + dZHiggs1[6, 5])) - SB*
                (2*MW^2*S2B*SW*dMf1[4, j2]*Mass[F[4, {j2}]] - 
                 ((S2B*(4*dSW1*MW^2 + SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZHiggs1[
                          3, 3] + dZHiggs1[5, 5]))))/2 + MW^2*SW*(4*dCB1*SB + 
                     CB^2*(dZHiggs1[3, 4] + dZHiggs1[6, 5])))*
                  Mass[F[4, {j2}]]^2)))*USf[4, j2][s2, 1]) + 
         (MW^2*S2B*SW*((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
              Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
             ((C2B*MW^2*S2B^2)/4 - CB^4*Mass[F[3, {j1}]]^2 + 
              SB^4*Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1] + 
            (S2B*Conjugate[USf[3, j1][s1, 2]]*(dZHiggs1[3, 4] - dZHiggs1[6, 
                5])*Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[4, j2][s2, 2])/2))/
          2)))/(MW^4*S2B^3*SW^3)}}, 
 C[S[4], S[6], S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{-(EL^2*Conjugate[CKM[j1, j2]]*Conjugate[USf[3, j1][s1, 1]]*
       IndexDelta[o1, o2]*(C2B*MW^2 + Mass[F[3, {j1}]]^2 - 
        Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1])/(2*Sqrt[2]*MW^2*SW^2), 
    -(EL^2*IndexDelta[o1, o2]*(MW^2*S2B*SW*Conjugate[dCKM1[j1, j2]]*
         Conjugate[USf[3, j1][s1, 1]]*(C2B*MW^2 + Mass[F[3, {j1}]]^2 - 
          Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1] + Conjugate[CKM[j1, j2]]*
         (Conjugate[USf[3, j1][s1, 1]]*((MW^2*S2B*SW*(C2B*MW^2 + 
               Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*(dZbarSf1[1, s2, 4, 
                 j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 
                 1]))/2 - ((MW^4*S2B*(S2B*SW*(dZHiggs1[3, 4] + dZHiggs1[5, 
                    6]) + (CB^2 - SB^2)*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[4, 
                      4] + dZHiggs1[6, 6]))))/2 - SW*(dMWsq1*S2B + 
                (MW^2*(8*dCB1*SB + 2*SB^2*(dZHiggs1[3, 4] + dZHiggs1[5, 6]) - 
                   S2B*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[6, 6])))/2)*
               Mass[F[4, {j2}]]^2 + CB*((4*dSW1*MW^2*SB + SW*(2*dMWsq1*SB + 
                    MW^2*(4*dSB1 - CB*(dZHiggs1[3, 4] + dZHiggs1[5, 6]) - 
                      SB*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[6, 6]))))*
                 Mass[F[3, {j1}]]^2 - MW^2*SB*(4*SW*dMf1[3, j1]*
                   Mass[F[3, {j1}]] - 4*Mass[F[4, {j2}]]*(SW*dMf1[4, j2] - 
                    dSW1*Mass[F[4, {j2}]]))))*USf[4, j2][s2, 1]) + 
          MW^2*SW*((S2B*(Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
               Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
              (C2B*MW^2 + Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*
              USf[4, j2][s2, 1])/2 + Conjugate[USf[3, j1][s1, 2]]*
             (dZHiggs1[3, 4] - dZHiggs1[5, 6])*Mass[F[3, {j1}]]*
             Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))))/
     (2*Sqrt[2]*MW^4*S2B*SW^3)}}, 
 C[S[3], S[6], S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{(EL^2*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s1, 1]]*(MW^2*S2B^2 - 
         2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2))*
        USf[4, j2][s2, 1] - 2*Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
        Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))/(2*Sqrt[2]*MW^2*S2B*SW^2), 
    (EL^2*IndexDelta[o1, o2]*(MW^2*S2B*SW*Conjugate[dCKM1[j1, j2]]*
        (Conjugate[USf[3, j1][s1, 1]]*((MW^2*S2B^2)/2 - 
           CB^2*Mass[F[3, {j1}]]^2 - SB^2*Mass[F[4, {j2}]]^2)*
          USf[4, j2][s2, 1] - Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
          Mass[F[4, {j2}]]*USf[4, j2][s2, 2]) - Conjugate[CKM[j1, j2]]*
        (MW^2*S2B*SW*((Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
             Mass[F[4, {j2}]]*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 2] + 
              dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 2]))/2 - 
           ((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
              Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
             (MW^2*S2B^2 - 2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^
                  2))*USf[4, j2][s2, 1])/4) - Conjugate[USf[3, j1][s1, 1]]*
          ((MW^2*S2B*SW*(MW^2*S2B^2 - 2*(CB^2*Mass[F[3, {j1}]]^2 + 
                SB^2*Mass[F[4, {j2}]]^2))*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][
                1, 1] + dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 1]))/4 - 
           (CB^2*(2*MW^2*S2B*SW*dMf1[3, j1]*Mass[F[3, {j1}]] + 
               (MW^2*SW*(SB^2*dZHiggs1[3, 4] + CB^2*dZHiggs1[5, 6]) - 
                 CB*(4*dSW1*MW^2*SB + SW*(4*dSB1*MW^2 + SB*(2*dMWsq1 - 
                       MW^2*(4*dZe1 + dZHiggs1[3, 3] + dZHiggs1[6, 6])))))*
                Mass[F[3, {j1}]]^2) + SB^2*(CB^2*MW^4*(4*dSW1*S2B + 
                 SW*(C2B*(dZHiggs1[3, 4] - dZHiggs1[5, 6]) - S2B*(4*dZe1 + 
                     dZHiggs1[3, 3] + dZHiggs1[6, 6]))) + 2*MW^2*S2B*SW*
                dMf1[4, j2]*Mass[F[4, {j2}]] - (MW^2*SW*(4*dCB1*SB + 
                   CB^2*dZHiggs1[3, 4] + SB^2*dZHiggs1[5, 6]) + 
                 (S2B*(4*dSW1*MW^2 + SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZHiggs1[
                         3, 3] + dZHiggs1[6, 6]))))/2)*Mass[F[4, {j2}]]^2))*
            USf[4, j2][s2, 1]) - 
         (SW*(Conjugate[USf[3, j1][s1, 2]]*(dMWsq1*S2B + MW^2*SB*
                (2*dCB1 - CB*(4*dZe1 + dZHiggs1[3, 3] + dZHiggs1[6, 6]))) - 
             (MW^2*S2B*(Conjugate[USf[3, j1][1, 2]]*dZSf1[1, s1, 3, j1] + 
                Conjugate[USf[3, j1][2, 2]]*dZSf1[2, s1, 3, j1]))/2)*
            Mass[F[3, {j1}]]*Mass[F[4, {j2}]] - 2*CB*MW^2*
            Conjugate[USf[3, j1][s1, 2]]*(SB*SW*dMf1[4, j2]*
              Mass[F[3, {j1}]] + (SB*SW*dMf1[3, j1] - (2*dSW1*SB + dSB1*SW)*
                Mass[F[3, {j1}]])*Mass[F[4, {j2}]]))*USf[4, j2][s2, 2])))/
     (Sqrt[2]*MW^4*S2B^2*SW^3)}}, 
 C[S[4], S[5], S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{(EL^2*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      (Conjugate[USf[3, j1][s1, 1]]*(MW^2*S2B^2 - 
         2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2))*
        USf[4, j2][s2, 1] + 2*Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
        Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))/(2*Sqrt[2]*MW^2*S2B*SW^2), 
    (EL^2*IndexDelta[o1, o2]*(MW^2*S2B*SW*Conjugate[dCKM1[j1, j2]]*
        (Conjugate[USf[3, j1][s1, 1]]*((MW^2*S2B^2)/2 - 
           CB^2*Mass[F[3, {j1}]]^2 - SB^2*Mass[F[4, {j2}]]^2)*
          USf[4, j2][s2, 1] + Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
          Mass[F[4, {j2}]]*USf[4, j2][s2, 2]) + Conjugate[CKM[j1, j2]]*
        (Conjugate[USf[3, j1][s1, 1]]*
          ((MW^2*S2B*SW*(MW^2*S2B^2 - 2*(CB^2*Mass[F[3, {j1}]]^2 + 
                SB^2*Mass[F[4, {j2}]]^2))*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][
                1, 1] + dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 1]))/4 - 
           (CB^2*(2*MW^2*S2B*SW*dMf1[3, j1]*Mass[F[3, {j1}]] - 
               (CB*(4*dSW1*MW^2*SB + SW*(4*dSB1*MW^2 + SB*(2*dMWsq1 - 
                       MW^2*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[5, 5])))) - 
                 MW^2*SW*(CB^2*dZHiggs1[3, 4] + SB^2*dZHiggs1[6, 5]))*
                Mass[F[3, {j1}]]^2) + SB^2*(CB^2*MW^4*(4*dSW1*S2B - 
                 SW*(S2B*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[5, 5]) + 
                   C2B*(dZHiggs1[3, 4] - dZHiggs1[6, 5]))) + 2*MW^2*S2B*SW*
                dMf1[4, j2]*Mass[F[4, {j2}]] - ((S2B*(4*dSW1*MW^2 + 
                    SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[
                         5, 5]))))/2 + MW^2*SW*(4*dCB1*SB + SB^2*dZHiggs1[3, 
                     4] + CB^2*dZHiggs1[6, 5]))*Mass[F[4, {j2}]]^2))*
            USf[4, j2][s2, 1]) + 
         SW*((MW^4*S2B^3*(Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
              Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
             USf[4, j2][s2, 1])/4 + MW^2*S2B*((Conjugate[USf[3, j1][s1, 2]]*
               Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*(dZbarSf1[1, s2, 4, j2]*
                 USf[4, j2][1, 2] + dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 2]))/
              2 - ((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
                Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*(
                CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2)*USf[4, j2][
                s2, 1])/2)) - (SW*(Conjugate[USf[3, j1][s1, 2]]*
              (dMWsq1*S2B + MW^2*SB*(2*dCB1 - CB*(4*dZe1 + dZHiggs1[4, 4] + 
                   dZHiggs1[5, 5]))) - (MW^2*S2B*(Conjugate[USf[3, j1][1, 2]]*
                 dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 2]]*
                 dZSf1[2, s1, 3, j1]))/2)*Mass[F[3, {j1}]]*Mass[F[4, {j2}]] - 
           2*CB*MW^2*Conjugate[USf[3, j1][s1, 2]]*(SB*SW*dMf1[4, j2]*
              Mass[F[3, {j1}]] + (SB*SW*dMf1[3, j1] - (2*dSW1*SB + dSB1*SW)*
                Mass[F[3, {j1}]])*Mass[F[4, {j2}]]))*USf[4, j2][s2, 2])))/
     (Sqrt[2]*MW^4*S2B^2*SW^3)}}, 
 C[S[3], -S[5], S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}]] == 
  {{-(EL^2*CKM[j1, j2]*Conjugate[USf[4, j2][s2, 1]]*IndexDelta[o1, o2]*
       (C2B*MW^2*S2B^2 - 4*CB^4*Mass[F[3, {j1}]]^2 + 
        4*SB^4*Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1])/
     (2*Sqrt[2]*MW^2*S2B^2*SW^2), 
    -((Sqrt[2]*EL^2*IndexDelta[o1, o2]*
       (MW^2*S2B*SW*Conjugate[USf[4, j2][s2, 1]]*dCKM1[j1, j2]*
         ((C2B*MW^2*S2B^2)/4 - CB^4*Mass[F[3, {j1}]]^2 + 
          SB^4*Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] + 
        CKM[j1, j2]*(Conjugate[USf[4, j2][s2, 1]]*
           ((MW^2*S2B*SW*(C2B*MW^2*S2B^2 - 4*CB^4*Mass[F[3, {j1}]]^2 + 4*SB^4*
                Mass[F[4, {j2}]]^2)*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 
                 1] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]))/8 - 
            (CB^4*(2*MW^2*S2B*SW*dMf1[3, j1]*Mass[F[3, {j1}]] - 
                (CB*(4*dSW1*MW^2*SB + SW*(4*dSB1*MW^2 + SB*(2*dMWsq1 - 
                        MW^2*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[3, 
                          3])))) - MW^2*SB^2*SW*(dZHiggs1[3, 4] + dZHiggs1[5, 
                     6]))*Mass[F[3, {j1}]]^2) + SB^3*(CB^3*MW^4*
                 (C2B*(4*dSW1 - SW*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[3, 
                       3])) - S2B*SW*(dZHiggs1[3, 4] + dZHiggs1[5, 6])) - 
                SB*(2*MW^2*S2B*SW*dMf1[4, j2]*Mass[F[4, {j2}]] - 
                  ((S2B*(4*dSW1*MW^2 + SW*(2*dMWsq1 - MW^2*(4*dZe1 + 
                          dZbarHiggs1[5, 5] + dZHiggs1[3, 3]))))/2 + 
                    MW^2*SW*(4*dCB1*SB + CB^2*(dZHiggs1[3, 4] + dZHiggs1[5, 
                         6])))*Mass[F[4, {j2}]]^2)))*USf[3, j1][s1, 1]) + 
          (MW^2*S2B*SW*((Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
               Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
              ((C2B*MW^2*S2B^2)/4 - CB^4*Mass[F[3, {j1}]]^2 + SB^4*
                Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] + 
             (S2B*Conjugate[USf[4, j2][s2, 2]]*(dZHiggs1[3, 4] - 
                dZHiggs1[5, 6])*Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[3, j1][
                s1, 2])/2))/2)))/(MW^4*S2B^3*SW^3))}}, 
 C[S[4], -S[6], S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}]] == 
  {{(EL^2*CKM[j1, j2]*Conjugate[USf[4, j2][s2, 1]]*IndexDelta[o1, o2]*
      (C2B*MW^2 + Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1])/
     (2*Sqrt[2]*MW^2*SW^2), (EL^2*IndexDelta[o1, o2]*
      (MW^2*S2B*SW*Conjugate[USf[4, j2][s2, 1]]*dCKM1[j1, j2]*
        (C2B*MW^2 + Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*
        USf[3, j1][s1, 1] + CKM[j1, j2]*(Conjugate[USf[4, j2][s2, 1]]*
          ((MW^2*S2B*SW*(C2B*MW^2 + Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*
             (dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, 
                j1]*USf[3, j1][2, 1]))/2 - 
           ((MW^4*S2B*(S2B*SW*(dZHiggs1[3, 4] + dZHiggs1[6, 5]) + 
                (CB^2 - SB^2)*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[4, 4] + 
                    dZHiggs1[6, 6]))))/2 - SW*(dMWsq1*S2B + (MW^2*
                 (8*dCB1*SB + 2*SB^2*(dZHiggs1[3, 4] + dZHiggs1[6, 5]) - 
                  S2B*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[6, 6])))/2)*
              Mass[F[4, {j2}]]^2 + CB*((4*dSW1*MW^2*SB + SW*(2*dMWsq1*SB + 
                   MW^2*(4*dSB1 - CB*(dZHiggs1[3, 4] + dZHiggs1[6, 5]) - 
                     SB*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[6, 6]))))*
                Mass[F[3, {j1}]]^2 - MW^2*SB*(4*SW*dMf1[3, j1]*
                  Mass[F[3, {j1}]] - 4*Mass[F[4, {j2}]]*(SW*dMf1[4, j2] - 
                   dSW1*Mass[F[4, {j2}]]))))*USf[3, j1][s1, 1]) + 
         MW^2*SW*((S2B*(Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
              Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
             (C2B*MW^2 + Mass[F[3, {j1}]]^2 - Mass[F[4, {j2}]]^2)*
             USf[3, j1][s1, 1])/2 + Conjugate[USf[4, j2][s2, 2]]*
            (dZHiggs1[3, 4] - dZHiggs1[6, 5])*Mass[F[3, {j1}]]*
            Mass[F[4, {j2}]]*USf[3, j1][s1, 2]))))/
     (2*Sqrt[2]*MW^4*S2B*SW^3)}}, 
 C[S[3], -S[6], S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}]] == 
  {{-(EL^2*CKM[j1, j2]*IndexDelta[o1, o2]*(Conjugate[USf[4, j2][s2, 1]]*
         (MW^2*S2B^2 - 2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2))*
         USf[3, j1][s1, 1] - 2*Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*
         Mass[F[4, {j2}]]*USf[3, j1][s1, 2]))/(2*Sqrt[2]*MW^2*S2B*SW^2), 
    -((EL^2*IndexDelta[o1, o2]*(MW^2*S2B*SW*dCKM1[j1, j2]*
         (Conjugate[USf[4, j2][s2, 1]]*((MW^2*S2B^2)/2 - 
            CB^2*Mass[F[3, {j1}]]^2 - SB^2*Mass[F[4, {j2}]]^2)*
           USf[3, j1][s1, 1] - Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*
           Mass[F[4, {j2}]]*USf[3, j1][s1, 2]) - CKM[j1, j2]*
         (MW^2*S2B*SW*((Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*
              Mass[F[4, {j2}]]*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 2] + 
               dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 2]))/2 - 
            ((Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + Conjugate[
                 USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*(MW^2*S2B^2 - 2*
                (CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2))*
              USf[3, j1][s1, 1])/4) - Conjugate[USf[4, j2][s2, 1]]*
           ((MW^2*S2B*SW*(MW^2*S2B^2 - 2*(CB^2*Mass[F[3, {j1}]]^2 + 
                 SB^2*Mass[F[4, {j2}]]^2))*(dZbarSf1[1, s1, 3, j1]*
                USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]))/
             4 - (CB^2*(2*MW^2*S2B*SW*dMf1[3, j1]*Mass[F[3, {j1}]] + 
                (MW^2*SW*(SB^2*dZHiggs1[3, 4] + CB^2*dZHiggs1[6, 5]) - 
                  CB*(4*dSW1*MW^2*SB + SW*(4*dSB1*MW^2 + SB*(2*dMWsq1 - 
                        MW^2*(4*dZe1 + dZHiggs1[3, 3] + dZHiggs1[6, 6])))))*
                 Mass[F[3, {j1}]]^2) + SB^2*(CB^2*MW^4*(4*dSW1*S2B + 
                  SW*(C2B*(dZHiggs1[3, 4] - dZHiggs1[6, 5]) - S2B*(4*dZe1 + 
                      dZHiggs1[3, 3] + dZHiggs1[6, 6]))) + 2*MW^2*S2B*SW*
                 dMf1[4, j2]*Mass[F[4, {j2}]] - (MW^2*SW*(4*dCB1*SB + 
                    CB^2*dZHiggs1[3, 4] + SB^2*dZHiggs1[6, 5]) + 
                  (S2B*(4*dSW1*MW^2 + SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZHiggs1[
                          3, 3] + dZHiggs1[6, 6]))))/2)*Mass[F[4, {j2}]]^2))*
             USf[3, j1][s1, 1]) - (SW*(Conjugate[USf[4, j2][s2, 2]]*(
                dMWsq1*S2B + MW^2*SB*(2*dCB1 - CB*(4*dZe1 + dZHiggs1[3, 3] + 
                    dZHiggs1[6, 6]))) - (MW^2*S2B*(Conjugate[USf[4, j2][1, 
                    2]]*dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j2][2, 2]]*
                  dZSf1[2, s2, 4, j2]))/2)*Mass[F[3, {j1}]]*
             Mass[F[4, {j2}]] - 2*CB*MW^2*Conjugate[USf[4, j2][s2, 2]]*
             (SB*SW*dMf1[4, j2]*Mass[F[3, {j1}]] + (SB*SW*dMf1[3, j1] - 
                (2*dSW1*SB + dSB1*SW)*Mass[F[3, {j1}]])*Mass[F[4, {j2}]]))*
           USf[3, j1][s1, 2])))/(Sqrt[2]*MW^4*S2B^2*SW^3))}}, 
 C[S[4], -S[5], S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}]] == 
  {{-(EL^2*CKM[j1, j2]*IndexDelta[o1, o2]*(Conjugate[USf[4, j2][s2, 1]]*
         (MW^2*S2B^2 - 2*(CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2))*
         USf[3, j1][s1, 1] + 2*Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*
         Mass[F[4, {j2}]]*USf[3, j1][s1, 2]))/(2*Sqrt[2]*MW^2*S2B*SW^2), 
    -((EL^2*IndexDelta[o1, o2]*(MW^2*S2B*SW*dCKM1[j1, j2]*
         (Conjugate[USf[4, j2][s2, 1]]*((MW^2*S2B^2)/2 - 
            CB^2*Mass[F[3, {j1}]]^2 - SB^2*Mass[F[4, {j2}]]^2)*
           USf[3, j1][s1, 1] + Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*
           Mass[F[4, {j2}]]*USf[3, j1][s1, 2]) + CKM[j1, j2]*
         (Conjugate[USf[4, j2][s2, 1]]*((MW^2*S2B*SW*(MW^2*S2B^2 - 2*
                (CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2))*
              (dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, 
                 j1]*USf[3, j1][2, 1]))/4 - (CB^2*(2*MW^2*S2B*SW*dMf1[3, j1]*
                 Mass[F[3, {j1}]] - (CB*(4*dSW1*MW^2*SB + SW*(4*dSB1*MW^2 + 
                      SB*(2*dMWsq1 - MW^2*(4*dZe1 + dZbarHiggs1[5, 5] + 
                          dZHiggs1[4, 4])))) - MW^2*SW*(CB^2*dZHiggs1[3, 4] + 
                    SB^2*dZHiggs1[5, 6]))*Mass[F[3, {j1}]]^2) + 
              SB^2*(CB^2*MW^4*(4*dSW1*S2B - SW*(S2B*(4*dZe1 + dZbarHiggs1[5, 
                       5] + dZHiggs1[4, 4]) + C2B*(dZHiggs1[3, 4] - dZHiggs1[
                       5, 6]))) + 2*MW^2*S2B*SW*dMf1[4, j2]*Mass[
                  F[4, {j2}]] - ((S2B*(4*dSW1*MW^2 + SW*(2*dMWsq1 - 
                       MW^2*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[4, 4]))))/
                   2 + MW^2*SW*(4*dCB1*SB + SB^2*dZHiggs1[3, 4] + 
                    CB^2*dZHiggs1[5, 6]))*Mass[F[4, {j2}]]^2))*
             USf[3, j1][s1, 1]) + 
          SW*((MW^4*S2B^3*(Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
               Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
              USf[3, j1][s1, 1])/4 + MW^2*S2B*((Conjugate[USf[4, j2][s2, 2]]*
                Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*(dZbarSf1[1, s1, 3, j1]*
                  USf[3, j1][1, 2] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 
                   2]))/2 - ((Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, 
                   j2] + Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
                (CB^2*Mass[F[3, {j1}]]^2 + SB^2*Mass[F[4, {j2}]]^2)*
                USf[3, j1][s1, 1])/2)) - 
          (SW*(Conjugate[USf[4, j2][s2, 2]]*(dMWsq1*S2B + MW^2*SB*
                 (2*dCB1 - CB*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[4, 
                     4]))) - (MW^2*S2B*(Conjugate[USf[4, j2][1, 2]]*
                  dZSf1[1, s2, 4, j2] + Conjugate[USf[4, j2][2, 2]]*
                  dZSf1[2, s2, 4, j2]))/2)*Mass[F[3, {j1}]]*
             Mass[F[4, {j2}]] - 2*CB*MW^2*Conjugate[USf[4, j2][s2, 2]]*
             (SB*SW*dMf1[4, j2]*Mass[F[3, {j1}]] + (SB*SW*dMf1[3, j1] - 
                (2*dSW1*SB + dSB1*SW)*Mass[F[3, {j1}]])*Mass[F[4, {j2}]]))*
           USf[3, j1][s1, 2])))/(Sqrt[2]*MW^4*S2B^2*SW^3))}}, 
 C[S[1], S[5], S[11, {j1}], -S[12, {s2, j2}]] == 
  {{((-I/2)*EL^2*IndexDelta[j1, j2]*(CAB*CB^2*MW^2 + 
       SA*SB*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 1])/(Sqrt[2]*CB^2*MW^2*SW^2), 
    ((-I/4)*EL^2*IndexDelta[j1, j2]*
      (CB*MW^2*SW*(CAB*CB^2*MW^2 + SA*SB*Mass[F[2, {j1}]]^2)*
        (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*
          USf[2, j1][2, 1]) - 
       ((CB^2*MW^4*(2*CA*CB^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + 
                dZHiggs1[5, 5])) + SA*SW*(S2B*(4*dZe1 + dZHiggs1[1, 1] + 
                dZHiggs1[5, 5]) - 2*CB^2*(dZHiggs1[1, 2] + dZHiggs1[6, 5])) - 
            S2B*(4*dSW1*SA + CA*SW*(dZHiggs1[1, 2] + dZHiggs1[6, 5]))))/2 - 
         S2B*SA*Mass[F[2, {j1}]]*(2*MW^2*SW*dMf1[2, j1] - 
           (2*dSW1*MW^2 + dMWsq1*SW)*Mass[F[2, {j1}]]) + 
         (MW^2*SW*((S2B*(CA*dZHiggs1[1, 2] - SA*(4*dZe1 + dZHiggs1[1, 1] + 
                  dZHiggs1[5, 5])) + SA*(8*dCB1*SB + 2*CB^2*dZHiggs1[6, 5]))*
             Mass[F[2, {j1}]]^2 - dZSf1[1, 1, 1, j1]*(2*CAB*CB^3*MW^2 + 
              S2B*SA*Mass[F[2, {j1}]]^2)))/2)*USf[2, j1][s2, 1]))/
     (Sqrt[2]*CB^3*MW^4*SW^3)}}, 
 C[S[1], S[6], S[11, {j1}], -S[12, {s2, j2}]] == 
  {{((-I/2)*EL^2*IndexDelta[j1, j2]*(CB*MW^2*SAB - SA*Mass[F[2, {j1}]]^2)*
      USf[2, j1][s2, 1])/(Sqrt[2]*CB*MW^2*SW^2), 
    ((-I/4)*EL^2*IndexDelta[j1, j2]*
      (CB*MW^2*SW*(CB*MW^2*SAB - SA*Mass[F[2, {j1}]]^2)*
        (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*
          USf[2, j1][2, 1]) - 
       (CB*((MW^4*(CB^2*(8*dSW1*SA + 2*SW*(CA*(dZHiggs1[1, 2] - dZHiggs1[5, 
                     6]) - SA*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[6, 6]))) - 
              S2B*(SA*SW*(dZHiggs1[1, 2] - dZHiggs1[5, 6]) - 
                CA*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[6, 
                     6])))))/2 + 2*SA*Mass[F[2, {j1}]]*
            (2*MW^2*SW*dMf1[2, j1] - (2*dSW1*MW^2 + dMWsq1*SW)*
              Mass[F[2, {j1}]])) - MW^2*SW*
          ((SA*(4*dCB1 + SB*dZHiggs1[5, 6]) + CB*(CA*dZHiggs1[1, 2] - SA*
                (4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[6, 6])))*
            Mass[F[2, {j1}]]^2 + CB*dZSf1[1, 1, 1, j1]*(CB*MW^2*SAB - 
             SA*Mass[F[2, {j1}]]^2)))*USf[2, j1][s2, 1]))/
     (Sqrt[2]*CB^2*MW^4*SW^3)}}, 
 C[S[1], -S[5], S[12, {s2, j2}], -S[11, {j1}]] == 
  {{((-I/2)*EL^2*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2]*
      (CAB*CB^2*MW^2 + SA*SB*Mass[F[2, {j1}]]^2))/(Sqrt[2]*CB^2*MW^2*SW^2), 
    ((-I/8)*EL^2*IndexDelta[j1, j2]*
      (MW^2*SW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
         Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
        (2*CAB*CB^3*MW^2 + S2B*SA*Mass[F[2, {j1}]]^2) - 
       Conjugate[USf[2, j1][s2, 1]]*
        (MW^4*(2*CB^4*(CA*(4*dSW1 - SW*(4*dZe1 + dZbarSf1[1, 1, 1, j1] + 
                 dZHiggs1[1, 1])) - SA*SW*dZHiggs1[1, 2]) - 
           CB^2*S2B*(SA*(4*dSW1 - SW*dZbarSf1[1, 1, 1, j1]) - 
             SW*(SA*(4*dZe1 + dZHiggs1[1, 1]) - CA*dZHiggs1[1, 2])) - 
           2*CB^3*SW*(CAB*dZbarHiggs1[5, 5] + SAB*dZHiggs1[5, 6])) + 
         MW^2*SA*SW*(8*dCB1*SB + 2*CB^2*dZHiggs1[5, 6])*Mass[F[2, {j1}]]^2 - 
         S2B*Mass[F[2, {j1}]]*(4*MW^2*SA*SW*dMf1[2, j1] - 
           (MW^2*SA*(4*dSW1 - SW*dZbarSf1[1, 1, 1, j1]) + 
             SW*(2*dMWsq1*SA - MW^2*(SA*(4*dZe1 + dZbarHiggs1[5, 5] + 
                   dZHiggs1[1, 1]) - CA*dZHiggs1[1, 2])))*
            Mass[F[2, {j1}]]))))/(Sqrt[2]*CB^3*MW^4*SW^3)}}, 
 C[S[1], -S[6], S[12, {s2, j2}], -S[11, {j1}]] == 
  {{((-I/2)*EL^2*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2]*
      (CB*MW^2*SAB - SA*Mass[F[2, {j1}]]^2))/(Sqrt[2]*CB*MW^2*SW^2), 
    ((-I/8)*EL^2*IndexDelta[j1, j2]*
      (2*CB*MW^2*SW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
         Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
        (CB*MW^2*SAB - SA*Mass[F[2, {j1}]]^2) - Conjugate[USf[2, j1][s2, 1]]*
        (MW^4*(CB*S2B*(CA*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[1, 1])) - 
             SA*SW*dZHiggs1[1, 2]) + 2*CB^3*(4*dSW1*SA - 
             SW*(SA*(4*dZe1 + dZHiggs1[1, 1]) - CA*dZHiggs1[1, 2])) - 
           2*CB^2*SW*(CAB*dZHiggs1[6, 5] + SAB*(dZbarSf1[1, 1, 1, j1] + 
               dZHiggs1[6, 6]))) - MW^2*SA*SW*(8*dCB1 + 2*SB*dZHiggs1[6, 5])*
          Mass[F[2, {j1}]]^2 + 2*CB*Mass[F[2, {j1}]]*
          (4*MW^2*SA*SW*dMf1[2, j1] - (MW^2*SA*(4*dSW1 - SW*dZbarSf1[1, 1, 1, 
                 j1]) + SW*(2*dMWsq1*SA + MW^2*(CA*dZHiggs1[1, 2] - 
                 SA*(4*dZe1 + dZHiggs1[1, 1] + dZHiggs1[6, 6]))))*
            Mass[F[2, {j1}]]))))/(Sqrt[2]*CB^2*MW^4*SW^3)}}, 
 C[S[3], S[5], S[11, {j1}], -S[12, {s2, j2}]] == 
  {{(EL^2*IndexDelta[j1, j2]*(C2B*CB^2*MW^2 + SB^2*Mass[F[2, {j1}]]^2)*
      USf[2, j1][s2, 1])/(2*Sqrt[2]*CB^2*MW^2*SW^2), 
    (EL^2*IndexDelta[j1, j2]*(CB*MW^2*SW*(C2B*CB^2*MW^2 + 
         SB^2*Mass[F[2, {j1}]]^2)*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
         dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) + 
       ((MW^4*((-4*CB^5 + CB*S2B^2)*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[3, 3] + 
                dZHiggs1[5, 5])) + 4*CB^3*SW*(S2B*(dZHiggs1[3, 4] + 
                dZHiggs1[6, 5]) + C2B*dZSf1[1, 1, 1, j1])) - 
          MW^2*SW*(16*dCB1*SB^2 + 2*CB*S2B*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))*
           Mass[F[2, {j1}]]^2 + 2*S2B*SB*Mass[F[2, {j1}]]*
           (4*MW^2*SW*dMf1[2, j1] - (SW*(2*dMWsq1 - MW^2*(4*dZe1 + 
                  dZHiggs1[3, 3] + dZHiggs1[5, 5])) + MW^2*(4*dSW1 - 
                SW*dZSf1[1, 1, 1, j1]))*Mass[F[2, {j1}]]))*USf[2, j1][s2, 1])/
        4))/(4*Sqrt[2]*CB^3*MW^4*SW^3)}}, 
 C[S[4], S[6], S[11, {j1}], -S[12, {s2, j2}]] == 
  {{-(EL^2*IndexDelta[j1, j2]*(C2B*MW^2 - Mass[F[2, {j1}]]^2)*
       USf[2, j1][s2, 1])/(2*Sqrt[2]*MW^2*SW^2), 
    -(EL^2*IndexDelta[j1, j2]*(CB*MW^2*SW*(C2B*MW^2 - Mass[F[2, {j1}]]^2)*
         (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*
           USf[2, j1][2, 1]) - 
        ((MW^4*(CB^3*(8*dSW1 - 2*SW*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[6, 
                  6])) + S2B*(2*CB*SW*(dZHiggs1[3, 4] + dZHiggs1[5, 6]) - SB*
                (4*dSW1 - SW*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[6, 6])))))/
           2 + 2*CB*Mass[F[2, {j1}]]*(2*MW^2*SW*dMf1[2, j1] - 
            (2*dSW1*MW^2 + dMWsq1*SW)*Mass[F[2, {j1}]]) - 
          MW^2*SW*((4*dCB1 + SB*(dZHiggs1[3, 4] + dZHiggs1[5, 6]) - 
              CB*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[6, 6]))*
             Mass[F[2, {j1}]]^2 + CB*dZSf1[1, 1, 1, j1]*(C2B*MW^2 - 
              Mass[F[2, {j1}]]^2)))*USf[2, j1][s2, 1]))/
     (4*Sqrt[2]*CB*MW^4*SW^3)}}, 
 C[S[3], S[6], S[11, {j1}], -S[12, {s2, j2}]] == 
  {{(EL^2*IndexDelta[j1, j2]*(CB*MW^2*S2B - SB*Mass[F[2, {j1}]]^2)*
      USf[2, j1][s2, 1])/(2*Sqrt[2]*CB*MW^2*SW^2), 
    (EL^2*IndexDelta[j1, j2]*((MW^2*S2B*SW*(2*CB^2*MW^2 - Mass[F[2, {j1}]]^2)*
         (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*
           USf[2, j1][2, 1]))/2 - 
       ((MW^4*((4*CB^4 - S2B^2)*SW*(dZHiggs1[3, 4] - dZHiggs1[5, 6]) + 
            4*CB^2*S2B*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[3, 3] + dZHiggs1[6, 
                 6]))))/4 + 2*MW^2*S2B*Mass[F[2, {j1}]]*(SW*dMf1[2, j1] - 
           dSW1*Mass[F[2, {j1}]]) - 
         SW*((dMWsq1*S2B + (MW^2*(8*dCB1*SB + 2*(CB^2*dZHiggs1[3, 4] + 
                  SB^2*dZHiggs1[5, 6]) - S2B*(4*dZe1 + dZHiggs1[3, 3] + 
                  dZHiggs1[6, 6])))/2)*Mass[F[2, {j1}]]^2 + 
           (MW^2*S2B*dZSf1[1, 1, 1, j1]*(2*CB^2*MW^2 - Mass[F[2, {j1}]]^2))/
            2))*USf[2, j1][s2, 1]))/(4*Sqrt[2]*CB^2*MW^4*SW^3)}}, 
 C[S[4], S[5], S[11, {j1}], -S[12, {s2, j2}]] == 
  {{(EL^2*IndexDelta[j1, j2]*(CB*MW^2*S2B - SB*Mass[F[2, {j1}]]^2)*
      USf[2, j1][s2, 1])/(2*Sqrt[2]*CB*MW^2*SW^2), 
    (EL^2*IndexDelta[j1, j2]*((MW^2*S2B*SW*(2*CB^2*MW^2 - Mass[F[2, {j1}]]^2)*
         (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*
           USf[2, j1][2, 1]))/2 - 
       ((MW^4*(4*CB^2*S2B*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[4, 4] + 
                dZHiggs1[5, 5])) - (4*CB^4 - S2B^2)*SW*(dZHiggs1[3, 4] - 
              dZHiggs1[6, 5])))/4 + S2B*Mass[F[2, {j1}]]*
          (2*MW^2*SW*dMf1[2, j1] - (2*dSW1*MW^2 + dMWsq1*SW)*
            Mass[F[2, {j1}]]) - 
         (MW^2*SW*((8*dCB1*SB + 2*SB^2*dZHiggs1[3, 4] - S2B*(4*dZe1 + 
                dZHiggs1[4, 4] + dZHiggs1[5, 5]) + 2*CB^2*dZHiggs1[6, 5])*
             Mass[F[2, {j1}]]^2 + S2B*dZSf1[1, 1, 1, j1]*(2*CB^2*MW^2 - 
              Mass[F[2, {j1}]]^2)))/2)*USf[2, j1][s2, 1]))/
     (4*Sqrt[2]*CB^2*MW^4*SW^3)}}, 
 C[S[3], -S[5], S[12, {s2, j2}], -S[11, {j1}]] == 
  {{-(EL^2*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2]*
       (C2B*CB^2*MW^2 + SB^2*Mass[F[2, {j1}]]^2))/(2*Sqrt[2]*CB^2*MW^2*SW^2), 
    -(EL^2*IndexDelta[j1, j2]*(2*MW^2*SW*(Conjugate[USf[2, j1][1, 1]]*
           dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 1]]*
           dZSf1[2, s2, 2, j2])*(2*C2B*CB^3*MW^2 + 
          S2B*SB*Mass[F[2, {j1}]]^2) + Conjugate[USf[2, j1][s2, 1]]*
         (MW^4*((-4*CB^5 + CB*S2B^2)*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[3, 
                 3])) + 4*CB^3*SW*(C2B*(dZbarHiggs1[5, 5] + dZbarSf1[1, 1, 1, 
                 j1]) + S2B*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))) - 
          MW^2*SW*(16*dCB1*SB^2 + 2*CB*S2B*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))*
           Mass[F[2, {j1}]]^2 + 2*S2B*SB*Mass[F[2, {j1}]]*
           (4*MW^2*SW*dMf1[2, j1] - (MW^2*(4*dSW1 - SW*dZbarSf1[1, 1, 1, 
                  j1]) + SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZbarHiggs1[5, 5] + 
                  dZHiggs1[3, 3])))*Mass[F[2, {j1}]]))))/
     (16*Sqrt[2]*CB^3*MW^4*SW^3)}}, 
 C[S[4], -S[6], S[12, {s2, j2}], -S[11, {j1}]] == 
  {{(EL^2*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2]*
      (C2B*MW^2 - Mass[F[2, {j1}]]^2))/(2*Sqrt[2]*MW^2*SW^2), 
    (EL^2*IndexDelta[j1, j2]*(CB*MW^2*SW*(Conjugate[USf[2, j1][1, 1]]*
          dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 1]]*
          dZSf1[2, s2, 2, j2])*(C2B*MW^2 - Mass[F[2, {j1}]]^2) - 
       Conjugate[USf[2, j1][s2, 1]]*
        ((MW^4*(CB^3*(8*dSW1 - 2*SW*(4*dZe1 + dZHiggs1[4, 4])) - 
            S2B*SB*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[4, 4])) + 
            2*CB*SW*(S2B*(dZHiggs1[3, 4] + dZHiggs1[6, 5]) - C2B*dZHiggs1[6, 
                6])))/2 + 2*CB*Mass[F[2, {j1}]]*(2*MW^2*SW*dMf1[2, j1] - 
           (2*dSW1*MW^2 + dMWsq1*SW)*Mass[F[2, {j1}]]) - 
         MW^2*SW*((4*dCB1 + SB*(dZHiggs1[3, 4] + dZHiggs1[6, 5]) - 
             CB*(4*dZe1 + dZHiggs1[4, 4] + dZHiggs1[6, 6]))*
            Mass[F[2, {j1}]]^2 + CB*dZbarSf1[1, 1, 1, j1]*
            (C2B*MW^2 - Mass[F[2, {j1}]]^2)))))/(4*Sqrt[2]*CB*MW^4*SW^3)}}, 
 C[S[3], -S[6], S[12, {s2, j2}], -S[11, {j1}]] == 
  {{-(EL^2*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2]*
       (CB*MW^2*S2B - SB*Mass[F[2, {j1}]]^2))/(2*Sqrt[2]*CB*MW^2*SW^2), 
    -(EL^2*IndexDelta[j1, j2]*
       ((MW^2*S2B*SW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
           Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
          (2*CB^2*MW^2 - Mass[F[2, {j1}]]^2))/2 - 
        Conjugate[USf[2, j1][s2, 1]]*
         ((MW^4*((4*CB^4 - S2B^2)*SW*dZHiggs1[3, 4] + 
             4*CB^2*(4*dSW1*S2B - SW*(C2B*dZHiggs1[6, 5] + S2B*(4*dZe1 + 
                   dZHiggs1[3, 3] + dZHiggs1[6, 6])))))/4 + 
          2*MW^2*S2B*Mass[F[2, {j1}]]*(SW*dMf1[2, j1] - 
            dSW1*Mass[F[2, {j1}]]) - 
          SW*((dMWsq1*S2B + (MW^2*(8*dCB1*SB + 2*(CB^2*dZHiggs1[3, 4] + 
                   SB^2*dZHiggs1[6, 5]) - S2B*(4*dZe1 + dZHiggs1[3, 3] + 
                   dZHiggs1[6, 6])))/2)*Mass[F[2, {j1}]]^2 + 
            (MW^2*S2B*dZbarSf1[1, 1, 1, j1]*(2*CB^2*MW^2 - Mass[F[2, {j1}]]^
                2))/2))))/(4*Sqrt[2]*CB^2*MW^4*SW^3)}}, 
 C[S[4], -S[5], S[12, {s2, j2}], -S[11, {j1}]] == 
  {{-(EL^2*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2]*
       (CB*MW^2*S2B - SB*Mass[F[2, {j1}]]^2))/(2*Sqrt[2]*CB*MW^2*SW^2), 
    -(EL^2*IndexDelta[j1, j2]*(2*MW^2*S2B*SW*(Conjugate[USf[2, j1][1, 1]]*
           dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 1]]*
           dZSf1[2, s2, 2, j2])*(2*CB^2*MW^2 - Mass[F[2, {j1}]]^2) + 
        Conjugate[USf[2, j1][s2, 1]]*
         (MW^4*((4*CB^4 - S2B^2)*SW*dZHiggs1[3, 4] - 4*CB^2*S2B*
             (4*dSW1 - SW*(4*dZe1 + dZbarHiggs1[5, 5] + dZbarSf1[1, 1, 1, 
                 j1] + dZHiggs1[4, 4]))) - 2*S2B*Mass[F[2, {j1}]]*
           (4*MW^2*SW*dMf1[2, j1] - (MW^2*(4*dSW1 - SW*dZbarSf1[1, 1, 1, 
                  j1]) + SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZbarHiggs1[5, 5] + 
                  dZHiggs1[4, 4])))*Mass[F[2, {j1}]]) + 
          MW^2*SW*((16*dCB1*SB + 4*SB^2*dZHiggs1[3, 4])*Mass[F[2, {j1}]]^2 - 
            4*CB^2*dZHiggs1[5, 6]*(C2B*MW^2 - Mass[F[2, {j1}]]^2)))))/
     (16*Sqrt[2]*CB^2*MW^4*SW^3)}}, 
 C[S[2], S[5], S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{((-I)*Sqrt[2]*EL^2*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      ((Conjugate[USf[3, j1][s1, 1]]*(MW^2*S2B^2*SAB - 
          4*(CB^3*SA*Mass[F[3, {j1}]]^2 + CA*SB^3*Mass[F[4, {j2}]]^2))*
         USf[4, j2][s2, 1])/4 - (CBA*S2B*Conjugate[USf[3, j1][s1, 2]]*
         Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[4, j2][s2, 2])/2))/
     (MW^2*S2B^2*SW^2), ((-I)*Sqrt[2]*EL^2*IndexDelta[o1, o2]*
      ((MW^2*S2B*SW*Conjugate[dCKM1[j1, j2]]*(Conjugate[USf[3, j1][s1, 1]]*
           (MW^2*S2B^2*SAB - 4*(CB^3*SA*Mass[F[3, {j1}]]^2 + 
              CA*SB^3*Mass[F[4, {j2}]]^2))*USf[4, j2][s2, 1] - 
          2*CBA*S2B*Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*
           Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))/4 + Conjugate[CKM[j1, j2]]*
        (Conjugate[USf[3, j1][s1, 1]]*((MW^2*S2B*SW*(MW^2*S2B^2*SAB - 
              4*(CB^3*SA*Mass[F[3, {j1}]]^2 + CA*SB^3*Mass[F[4, {j2}]]^2))*
             (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, 
                j2]*USf[4, j2][2, 1]))/8 - 
           (CB^3*(2*MW^2*S2B*SA*SW*dMf1[3, j1]*Mass[F[3, {j1}]] - 
               (CB*(4*dSW1*MW^2*SA*SB + SW*(4*dSB1*MW^2*SA + 
                     SB*(2*dMWsq1*SA - MW^2*(CA*dZHiggs1[1, 2] + SA*(4*dZe1 + 
                          dZHiggs1[2, 2] + dZHiggs1[5, 5]))))) - MW^2*SA*SB^2*
                  SW*dZHiggs1[6, 5])*Mass[F[3, {j1}]]^2) + 
             SB^3*(CB^3*MW^4*(4*dSW1*SAB - SW*(SAB*(4*dZe1 + dZHiggs1[2, 2] + 
                     dZHiggs1[5, 5]) + CAB*(dZHiggs1[1, 2] - dZHiggs1[6, 
                      5]))) + 2*CA*MW^2*S2B*SW*dMf1[4, j2]*Mass[F[4, {j2}]] - 
               ((MW^2*S2B*SA*SW*dZHiggs1[1, 2])/2 + CA*((S2B*(4*dSW1*MW^2 + 
                      SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[
                          5, 5]))))/2 + MW^2*SW*(4*dCB1*SB + CB^2*dZHiggs1[6, 
                       5])))*Mass[F[4, {j2}]]^2))*USf[4, j2][s2, 1]) + 
         (S2B*(MW^2*SW*(((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
                 Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
                (MW^2*S2B^2*SAB - 4*(CB^3*SA*Mass[F[3, {j1}]]^2 + CA*SB^3*
                    Mass[F[4, {j2}]]^2))*USf[4, j2][s2, 1])/4 - 
              (CBA*S2B*(Conjugate[USf[3, j1][1, 2]]*dZSf1[1, s1, 3, j1] + 
                 Conjugate[USf[3, j1][2, 2]]*dZSf1[2, s1, 3, j1])*
                Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[4, j2][s2, 2])/2) - 
            Conjugate[USf[3, j1][s1, 2]]*((CBA*MW^2*S2B*SW*Mass[F[3, {j1}]]*
                Mass[F[4, {j2}]]*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 2] + 
                 dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 2]))/2 + 
              (CBA*MW^2*S2B*SW*dMf1[4, j2]*Mass[F[3, {j1}]] + 
                ((2*CBA*MW^2*S2B*SW*dMf1[3, j1] - (CBA*(4*dSW1*MW^2*S2B + 
                       SW*(2*dMWsq1*S2B + MW^2*(4*(CB*dSB1 + dCB1*SB) - 
                          S2B*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[5, 5])))) - 
                     MW^2*S2B*SBA*SW*(dZHiggs1[1, 2] + dZHiggs1[6, 5]))*
                    Mass[F[3, {j1}]])*Mass[F[4, {j2}]])/2)*USf[4, j2][s2, 
                2])))/2)))/(MW^4*S2B^3*SW^3)}}, 
 C[S[2], S[6], S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{(I*EL^2*Conjugate[CKM[j1, j2]]*IndexDelta[o1, o2]*
      ((Conjugate[USf[3, j1][s1, 1]]*(CAB*MW^2*S2B + 
          2*CB*SA*Mass[F[3, {j1}]]^2 - 2*CA*SB*Mass[F[4, {j2}]]^2)*
         USf[4, j2][s2, 1])/2 + SBA*Conjugate[USf[3, j1][s1, 2]]*
        Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))/
     (Sqrt[2]*MW^2*S2B*SW^2), (I*Sqrt[2]*EL^2*IndexDelta[o1, o2]*
      ((MW^2*S2B^2*SW*Conjugate[dCKM1[j1, j2]]*(Conjugate[USf[3, j1][s1, 1]]*
           (CB*(CAB*MW^2*SB + SA*Mass[F[3, {j1}]]^2) - 
            CA*SB*Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1] + 
          SBA*Conjugate[USf[3, j1][s1, 2]]*Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*
           USf[4, j2][s2, 2]))/2 + Conjugate[CKM[j1, j2]]*
        (Conjugate[USf[3, j1][s1, 1]]*((MW^2*S2B^2*SW*(CAB*MW^2*S2B + 
              2*CB*SA*Mass[F[3, {j1}]]^2 - 2*CA*SB*Mass[F[4, {j2}]]^2)*
             (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, 
                j2]*USf[4, j2][2, 1]))/8 + 
           S2B*((CB^2*Mass[F[3, {j1}]]*(4*MW^2*SA*SB*SW*dMf1[3, j1] - 
                (4*dSW1*MW^2*SA*SB + SW*(SA*(4*dSB1*MW^2 + 2*dMWsq1*SB) - 
                    MW^2*(CB*SA*dZHiggs1[5, 6] + SB*(CA*dZHiggs1[1, 2] + 
                        SA*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[6, 6])))))*
                 Mass[F[3, {j1}]]))/2 - SB^2*((CB^2*MW^4*
                 (SAB*SW*(dZHiggs1[1, 2] + dZHiggs1[5, 6]) + CAB*(4*dSW1 - 
                    SW*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[6, 6]))))/2 + 2*CA*
                CB*MW^2*SW*dMf1[4, j2]*Mass[F[4, {j2}]] - 
               ((CB*MW^2*SA*SW*dZHiggs1[1, 2] + CA*(MW^2*SW*(4*dCB1 + 
                      SB*dZHiggs1[5, 6]) + CB*(4*dSW1*MW^2 + SW*(2*dMWsq1 - 
                        MW^2*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[6, 6])))))*
                 Mass[F[4, {j2}]]^2)/2))*USf[4, j2][s2, 1]) + 
         (S2B*((MW^2*S2B*SW*((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, 
                   j1] + Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
                (CB*(CAB*MW^2*SB + SA*Mass[F[3, {j1}]]^2) - CA*SB*
                  Mass[F[4, {j2}]]^2)*USf[4, j2][s2, 1] + SBA*
                (Conjugate[USf[3, j1][1, 2]]*dZSf1[1, s1, 3, j1] + 
                 Conjugate[USf[3, j1][2, 2]]*dZSf1[2, s1, 3, j1])*
                Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[4, j2][s2, 2]))/2 + 
            Conjugate[USf[3, j1][s1, 2]]*((MW^2*S2B*SBA*SW*Mass[F[3, {j1}]]*
                Mass[F[4, {j2}]]*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 2] + 
                 dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 2]))/2 + 
              (MW^2*S2B*SBA*SW*dMf1[4, j2]*Mass[F[3, {j1}]] + 
                (MW^2*S2B*SBA*SW*dMf1[3, j1] - (2*dCB1*MW^2*SB*SBA*SW + 
                    CB*(4*dSW1*MW^2*SB*SBA + SW*(2*dSB1*MW^2*SBA + 
                        SB*(2*dMWsq1*SBA + MW^2*(CBA*(dZHiggs1[1, 2] - 
                          dZHiggs1[5, 6]) - SBA*(4*dZe1 + dZHiggs1[2, 2] + 
                          dZHiggs1[6, 6]))))))*Mass[F[3, {j1}]])*
                 Mass[F[4, {j2}]])*USf[4, j2][s2, 2])))/2)))/
     (MW^4*S2B^3*SW^3)}}, C[S[2], -S[5], S[14, {s2, j2, o1}], 
   -S[13, {s1, j1, o2}]] == 
  {{((-I)*Sqrt[2]*EL^2*CKM[j1, j2]*IndexDelta[o1, o2]*
      ((Conjugate[USf[4, j2][s2, 1]]*(MW^2*S2B^2*SAB - 
          4*(CB^3*SA*Mass[F[3, {j1}]]^2 + CA*SB^3*Mass[F[4, {j2}]]^2))*
         USf[3, j1][s1, 1])/4 - (CBA*S2B*Conjugate[USf[4, j2][s2, 2]]*
         Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 2])/2))/
     (MW^2*S2B^2*SW^2), ((-I)*Sqrt[2]*EL^2*IndexDelta[o1, o2]*
      ((MW^2*S2B*SW*dCKM1[j1, j2]*(Conjugate[USf[4, j2][s2, 1]]*
           (MW^2*S2B^2*SAB - 4*(CB^3*SA*Mass[F[3, {j1}]]^2 + 
              CA*SB^3*Mass[F[4, {j2}]]^2))*USf[3, j1][s1, 1] - 
          2*CBA*S2B*Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*
           Mass[F[4, {j2}]]*USf[3, j1][s1, 2]))/4 + 
       CKM[j1, j2]*(Conjugate[USf[4, j2][s2, 1]]*
          ((MW^2*S2B*SW*(MW^2*S2B^2*SAB - 4*(CB^3*SA*Mass[F[3, {j1}]]^2 + 
                CA*SB^3*Mass[F[4, {j2}]]^2))*(dZbarSf1[1, s1, 3, j1]*
               USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]))/
            8 - (CB^3*(2*MW^2*S2B*SA*SW*dMf1[3, j1]*Mass[F[3, {j1}]] - 
               (CB*(4*dSW1*MW^2*SA*SB + SW*(4*dSB1*MW^2*SA + 
                     SB*(2*dMWsq1*SA - MW^2*(CA*dZHiggs1[1, 2] + SA*(4*dZe1 + 
                          dZbarHiggs1[5, 5] + dZHiggs1[2, 2]))))) - 
                 MW^2*SA*SB^2*SW*dZHiggs1[5, 6])*Mass[F[3, {j1}]]^2) + 
             SB^3*(CB^3*MW^4*(4*dSW1*SAB - SW*(SAB*(4*dZe1 + dZbarHiggs1[5, 
                      5] + dZHiggs1[2, 2]) + CAB*(dZHiggs1[1, 2] - dZHiggs1[
                      5, 6]))) + 2*CA*MW^2*S2B*SW*dMf1[4, j2]*
                Mass[F[4, {j2}]] - ((MW^2*S2B*SA*SW*dZHiggs1[1, 2])/2 + 
                 CA*((S2B*(4*dSW1*MW^2 + SW*(2*dMWsq1 - MW^2*(4*dZe1 + 
                          dZbarHiggs1[5, 5] + dZHiggs1[2, 2]))))/2 + 
                   MW^2*SW*(4*dCB1*SB + CB^2*dZHiggs1[5, 6])))*
                Mass[F[4, {j2}]]^2))*USf[3, j1][s1, 1]) + 
         (S2B*(MW^2*SW*(((Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
                 Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
                (MW^2*S2B^2*SAB - 4*(CB^3*SA*Mass[F[3, {j1}]]^2 + CA*SB^3*
                    Mass[F[4, {j2}]]^2))*USf[3, j1][s1, 1])/4 - 
              (CBA*S2B*(Conjugate[USf[4, j2][1, 2]]*dZSf1[1, s2, 4, j2] + 
                 Conjugate[USf[4, j2][2, 2]]*dZSf1[2, s2, 4, j2])*
                Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 2])/2) - 
            Conjugate[USf[4, j2][s2, 2]]*((CBA*MW^2*S2B*SW*Mass[F[3, {j1}]]*
                Mass[F[4, {j2}]]*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 2] + 
                 dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 2]))/2 + 
              (CBA*MW^2*S2B*SW*dMf1[4, j2]*Mass[F[3, {j1}]] + 
                ((2*CBA*MW^2*S2B*SW*dMf1[3, j1] - (CBA*(4*dSW1*MW^2*S2B + 
                       SW*(2*dMWsq1*S2B + MW^2*(4*(CB*dSB1 + dCB1*SB) - 
                          S2B*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[2, 
                          2])))) - MW^2*S2B*SBA*SW*(dZHiggs1[1, 2] + 
                       dZHiggs1[5, 6]))*Mass[F[3, {j1}]])*Mass[F[4, {j2}]])/
                 2)*USf[3, j1][s1, 2])))/2)))/(MW^4*S2B^3*SW^3)}}, 
 C[S[2], -S[6], S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}]] == 
  {{(I*EL^2*CKM[j1, j2]*IndexDelta[o1, o2]*
      ((Conjugate[USf[4, j2][s2, 1]]*(CAB*MW^2*S2B + 
          2*CB*SA*Mass[F[3, {j1}]]^2 - 2*CA*SB*Mass[F[4, {j2}]]^2)*
         USf[3, j1][s1, 1])/2 + SBA*Conjugate[USf[4, j2][s2, 2]]*
        Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 2]))/
     (Sqrt[2]*MW^2*S2B*SW^2), (I*Sqrt[2]*EL^2*IndexDelta[o1, o2]*
      ((MW^2*S2B^2*SW*dCKM1[j1, j2]*(Conjugate[USf[4, j2][s2, 1]]*
           (CB*(CAB*MW^2*SB + SA*Mass[F[3, {j1}]]^2) - 
            CA*SB*Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] + 
          SBA*Conjugate[USf[4, j2][s2, 2]]*Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*
           USf[3, j1][s1, 2]))/2 + CKM[j1, j2]*
        (Conjugate[USf[4, j2][s2, 1]]*((MW^2*S2B^2*SW*(CAB*MW^2*S2B + 
              2*CB*SA*Mass[F[3, {j1}]]^2 - 2*CA*SB*Mass[F[4, {j2}]]^2)*
             (dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + dZbarSf1[2, s1, 3, 
                j1]*USf[3, j1][2, 1]))/8 + 
           S2B*((CB^2*Mass[F[3, {j1}]]*(4*MW^2*SA*SB*SW*dMf1[3, j1] - 
                (4*dSW1*MW^2*SA*SB + SW*(SA*(4*dSB1*MW^2 + 2*dMWsq1*SB) - 
                    MW^2*(CB*SA*dZHiggs1[6, 5] + SB*(CA*dZHiggs1[1, 2] + 
                        SA*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[6, 6])))))*
                 Mass[F[3, {j1}]]))/2 - SB^2*((CB^2*MW^4*
                 (SAB*SW*(dZHiggs1[1, 2] + dZHiggs1[6, 5]) + CAB*(4*dSW1 - 
                    SW*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[6, 6]))))/2 + 2*CA*
                CB*MW^2*SW*dMf1[4, j2]*Mass[F[4, {j2}]] - 
               ((CB*MW^2*SA*SW*dZHiggs1[1, 2] + CA*(MW^2*SW*(4*dCB1 + 
                      SB*dZHiggs1[6, 5]) + CB*(4*dSW1*MW^2 + SW*(2*dMWsq1 - 
                        MW^2*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[6, 6])))))*
                 Mass[F[4, {j2}]]^2)/2))*USf[3, j1][s1, 1]) + 
         (S2B*((MW^2*S2B*SW*((Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, 
                   j2] + Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
                (CB*(CAB*MW^2*SB + SA*Mass[F[3, {j1}]]^2) - CA*SB*
                  Mass[F[4, {j2}]]^2)*USf[3, j1][s1, 1] + SBA*
                (Conjugate[USf[4, j2][1, 2]]*dZSf1[1, s2, 4, j2] + 
                 Conjugate[USf[4, j2][2, 2]]*dZSf1[2, s2, 4, j2])*
                Mass[F[3, {j1}]]*Mass[F[4, {j2}]]*USf[3, j1][s1, 2]))/2 + 
            Conjugate[USf[4, j2][s2, 2]]*((MW^2*S2B*SBA*SW*Mass[F[3, {j1}]]*
                Mass[F[4, {j2}]]*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 2] + 
                 dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 2]))/2 + 
              (MW^2*S2B*SBA*SW*dMf1[4, j2]*Mass[F[3, {j1}]] + 
                (MW^2*S2B*SBA*SW*dMf1[3, j1] - (2*dCB1*MW^2*SB*SBA*SW + 
                    CB*(4*dSW1*MW^2*SB*SBA + SW*(2*dSB1*MW^2*SBA + 
                        SB*(2*dMWsq1*SBA + MW^2*(CBA*(dZHiggs1[1, 2] - 
                          dZHiggs1[6, 5]) - SBA*(4*dZe1 + dZHiggs1[2, 2] + 
                          dZHiggs1[6, 6]))))))*Mass[F[3, {j1}]])*
                 Mass[F[4, {j2}]])*USf[3, j1][s1, 2])))/2)))/
     (MW^4*S2B^3*SW^3)}}, C[S[2], S[5], S[11, {j1}], -S[12, {s2, j2}]] == 
  {{((-I/2)*EL^2*IndexDelta[j1, j2]*(CB^2*MW^2*SAB - 
       CA*SB*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 1])/(Sqrt[2]*CB^2*MW^2*SW^2), 
    ((-I/4)*EL^2*IndexDelta[j1, j2]*
      (CB*MW^2*SW*(CB^2*MW^2*SAB - CA*SB*Mass[F[2, {j1}]]^2)*
        (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*
          USf[2, j1][2, 1]) - (CB^3*MW^4*(4*SAB*(dSW1 - dZe1*SW) - 
           SW*(CA*(SB*(dZHiggs1[2, 2] + dZHiggs1[5, 5]) + CB*
                (dZHiggs1[1, 2] - dZHiggs1[6, 5])) + 
             SA*(CB*(dZHiggs1[2, 2] + dZHiggs1[5, 5]) - SB*(dZHiggs1[1, 2] - 
                 dZHiggs1[6, 5])))) + CA*Mass[F[2, {j1}]]*
          (2*MW^2*S2B*SW*dMf1[2, j1] - (2*dSW1*MW^2*S2B + 
             ((dMWsq1 - 2*dZe1*MW^2)*S2B + 4*dCB1*MW^2*SB)*SW)*
            Mass[F[2, {j1}]]) - 
         (MW^2*SW*((S2B*(SA*dZHiggs1[1, 2] - CA*(dZHiggs1[2, 2] + dZHiggs1[5, 
                   5])) + 2*CA*CB^2*dZHiggs1[6, 5])*Mass[F[2, {j1}]]^2 + 
            dZSf1[1, 1, 1, j1]*(2*CB^3*MW^2*SAB - CA*S2B*Mass[F[2, {j1}]]^
                2)))/2)*USf[2, j1][s2, 1]))/(Sqrt[2]*CB^3*MW^4*SW^3)}}, 
 C[S[2], S[6], S[11, {j1}], -S[12, {s2, j2}]] == 
  {{((I/2)*EL^2*IndexDelta[j1, j2]*(CAB*CB*MW^2 - CA*Mass[F[2, {j1}]]^2)*
      USf[2, j1][s2, 1])/(Sqrt[2]*CB*MW^2*SW^2), 
    ((I/4)*EL^2*IndexDelta[j1, j2]*
      (CB*MW^2*SW*(CAB*CB*MW^2 - CA*Mass[F[2, {j1}]]^2)*
        (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*
          USf[2, j1][2, 1]) + 
       ((CB*MW^4*(S2B*(4*dSW1*SA - SW*(CA*(dZHiggs1[1, 2] + dZHiggs1[5, 6]) + 
                SA*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[6, 6]))) - 
            2*CB^2*(SA*SW*(dZHiggs1[1, 2] + dZHiggs1[5, 6]) + 
              CA*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[6, 6])))))/
          2 - CA*(4*CB*MW^2*SW*dMf1[2, j1]*Mass[F[2, {j1}]] - 
           2*(2*dCB1*MW^2*SW + CB*(dMWsq1*SW + MW^2*(2*dSW1 - 2*dZe1*SW)))*
            Mass[F[2, {j1}]]^2) + MW^2*SW*((CA*SB*dZHiggs1[5, 6] + 
             CB*(SA*dZHiggs1[1, 2] - CA*(dZHiggs1[2, 2] + dZHiggs1[6, 6])))*
            Mass[F[2, {j1}]]^2 + CB*dZSf1[1, 1, 1, j1]*(CAB*CB*MW^2 - 
             CA*Mass[F[2, {j1}]]^2)))*USf[2, j1][s2, 1]))/
     (Sqrt[2]*CB^2*MW^4*SW^3)}}, 
 C[S[2], -S[5], S[12, {s2, j2}], -S[11, {j1}]] == 
  {{((-I/2)*EL^2*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2]*
      (CB^2*MW^2*SAB - CA*SB*Mass[F[2, {j1}]]^2))/(Sqrt[2]*CB^2*MW^2*SW^2), 
    ((-I/8)*EL^2*IndexDelta[j1, j2]*
      (MW^2*SW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
         Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
        (2*CB^3*MW^2*SAB - CA*S2B*Mass[F[2, {j1}]]^2) - 
       Conjugate[USf[2, j1][s2, 1]]*
        (MW^4*(2*CB^4*(4*dSW1*SA - SW*(CA*dZHiggs1[1, 2] + SA*(4*dZe1 + 
                 dZHiggs1[2, 2]))) + CB^2*S2B*(SA*SW*dZHiggs1[1, 2] + 
             CA*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[2, 2]))) - 
           2*CB^3*SW*(SAB*(dZbarHiggs1[5, 5] + dZbarSf1[1, 1, 1, j1]) - 
             CAB*dZHiggs1[5, 6])) - CA*MW^2*SW*(8*dCB1*SB + 
           2*CB^2*dZHiggs1[5, 6])*Mass[F[2, {j1}]]^2 + S2B*Mass[F[2, {j1}]]*
          (4*CA*MW^2*SW*dMf1[2, j1] + (MW^2*SW*(CA*dZbarSf1[1, 1, 1, j1] - SA*
                dZHiggs1[1, 2]) - CA*(4*dSW1*MW^2 + SW*(2*dMWsq1 - 
                 MW^2*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[2, 2]))))*
            Mass[F[2, {j1}]]))))/(Sqrt[2]*CB^3*MW^4*SW^3)}}, 
 C[S[2], -S[6], S[12, {s2, j2}], -S[11, {j1}]] == 
  {{((I/2)*EL^2*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2]*
      (CAB*CB*MW^2 - CA*Mass[F[2, {j1}]]^2))/(Sqrt[2]*CB*MW^2*SW^2), 
    ((I/8)*EL^2*IndexDelta[j1, j2]*
      (2*CB*MW^2*SW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
         Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2])*
        (CAB*CB*MW^2 - CA*Mass[F[2, {j1}]]^2) + Conjugate[USf[2, j1][s2, 1]]*
        (MW^4*(CB*S2B*(4*dSW1*SA - SW*(CA*dZHiggs1[1, 2] + SA*(4*dZe1 + 
                 dZHiggs1[2, 2]))) - 2*(CB^3*(SA*SW*dZHiggs1[1, 2] + CA*
                (4*dSW1 - SW*(4*dZe1 + dZHiggs1[2, 2]))) + 
             CB^2*SW*(SAB*dZHiggs1[6, 5] - CAB*(dZbarSf1[1, 1, 1, j1] + 
                 dZHiggs1[6, 6])))) + CA*MW^2*SW*(8*dCB1 + 
           2*SB*dZHiggs1[6, 5])*Mass[F[2, {j1}]]^2 - 2*CB*Mass[F[2, {j1}]]*
          (4*CA*MW^2*SW*dMf1[2, j1] + (MW^2*SW*(CA*dZbarSf1[1, 1, 1, j1] - SA*
                dZHiggs1[1, 2]) - CA*(4*dSW1*MW^2 + SW*(2*dMWsq1 - 
                 MW^2*(4*dZe1 + dZHiggs1[2, 2] + dZHiggs1[6, 6]))))*
            Mass[F[2, {j1}]]))))/(Sqrt[2]*CB^2*MW^4*SW^3)}}, 
 C[S[5], -S[5], S[11, {j1}], -S[11, {j2}]] == 
  {{((I/4)*EL^2*IndexDelta[j1, j2]*(C2B*CB^2*(1 - 2*CW^2)*MW^2 - 
       2*CW^2*SB^2*Mass[F[2, {j1}]]^2))/(CB^2*CW^2*MW^2*SW^2), 
    ((I/32)*EL^2*IndexDelta[j1, j2]*
      (CB*MW^4*(4*((4*CB^4 - S2B^2)*(dSW1*SW^2 + (-CW^2 + 2*CW^4)*
              (dSW1 - dZe1*SW)) + C2B*CB^2*CW^2*(1 - 2*CW^2)*SW*
            dZbarHiggs1[5, 5]) + CW^2*(1 - 2*CW^2)*SW*
          ((4*CB^4 - S2B^2)*dZHiggs1[5, 5] + 4*CB^2*
            (S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) + C2B*(dZbarSf1[1, 1, 1, 
                j2] + dZSf1[1, 1, 1, j1])))) - 
       CW^4*(16*MW^2*S2B*SB*SW*dMf1[2, j1]*Mass[F[2, {j1}]] - 
         4*(MW^2*SW*(8*dCB1*SB^2 + CB*S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 
                5])) + S2B*SB*(MW^2*(4*dSW1 - SW*(4*dZe1 + dZbarHiggs1[5, 
                  5])) + SW*(2*dMWsq1 - MW^2*(dZbarSf1[1, 1, 1, j2] + 
                 dZHiggs1[5, 5] + dZSf1[1, 1, 1, j1]))))*
          Mass[F[2, {j1}]]^2)))/(CB^3*CW^4*MW^4*SW^3)}}, 
 C[S[6], -S[6], S[11, {j1}], -S[11, {j2}]] == 
  {{((-I/4)*EL^2*IndexDelta[j1, j2]*(C2B*(1 - 2*CW^2)*MW^2 + 
       2*CW^2*Mass[F[2, {j1}]]^2))/(CW^2*MW^2*SW^2), 
    ((-I/16)*EL^2*IndexDelta[j1, j2]*(4*MW^4*(2*CB^3 - S2B*SB)*
        (dSW1*SW^2 + (-CW^2 + 2*CW^4)*(dSW1 - dZe1*SW)) - 
       CW^2*(4*CW^2*(CB*(2*dMWsq1*SW + 4*MW^2*(dSW1 - dZe1*SW)) + 
           MW^2*SW*(4*dCB1 + SB*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - 
             CB*(dZbarSf1[1, 1, 1, j2] + 2*dZHiggs1[6, 6] + dZSf1[1, 1, 1, 
                j1])))*Mass[F[2, {j1}]]^2 - 
         SW*((1 - 2*CW^2)*MW^4*(2*CB^3*dZHiggs1[6, 6] - 
             S2B*(2*CB*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) + SB*dZHiggs1[6, 
                 6]) + 2*C2B*CB*(dZbarSf1[1, 1, 1, j2] + dZHiggs1[6, 6] + 
               dZSf1[1, 1, 1, j1])) + 16*CB*CW^2*MW^2*dMf1[2, j1]*
            Mass[F[2, {j1}]]))))/(CB*CW^4*MW^4*SW^3)}}, 
 C[S[5], -S[6], S[11, {j1}], -S[11, {j2}]] == 
  {{((-I/4)*EL^2*S2B*IndexDelta[j1, j2]*(2 - CW^(-2) - 
       Mass[F[2, {j1}]]^2/(CB^2*MW^2)))/SW^2, 
    ((-I/8)*EL^2*IndexDelta[j1, j2]*
      (CW^4*(S2B*(2*dMWsq1*SW + 4*MW^2*(dSW1 - dZe1*SW)) + 
         MW^2*SW*(8*dCB1*SB + 2*dZHiggs1[6, 5] - S2B*(dZbarSf1[1, 1, 1, j2] + 
             dZHiggs1[5, 5] + dZHiggs1[6, 6] + dZSf1[1, 1, 1, j1])))*
        Mass[F[2, {j1}]]^2 - 
       S2B*(CB^2*MW^4*(4*(dSW1*SW^2 + (-CW^2 + 2*CW^4)*(dSW1 - dZe1*SW)) + 
           CW^2*(1 - 2*CW^2)*SW*(dZbarSf1[1, 1, 1, j2] + dZHiggs1[5, 5] + 
             dZHiggs1[6, 6] + dZSf1[1, 1, 1, j1])) + 4*CW^4*MW^2*SW*
          dMf1[2, j1]*Mass[F[2, {j1}]])))/(CB^2*CW^4*MW^4*SW^3)}}, 
 C[S[6], -S[5], S[11, {j1}], -S[11, {j2}]] == 
  {{((-I/4)*EL^2*S2B*IndexDelta[j1, j2]*(2 - CW^(-2) - 
       Mass[F[2, {j1}]]^2/(CB^2*MW^2)))/SW^2, 
    ((-I/8)*EL^2*IndexDelta[j1, j2]*(CW^4*(S2B*(4*dSW1*MW^2 + 2*dMWsq1*SW) + 
         MW^2*SW*(8*dCB1*SB + 2*dZHiggs1[5, 6] - 
           S2B*(4*dZe1 + dZbarHiggs1[5, 5] + dZbarSf1[1, 1, 1, j2] + 
             dZHiggs1[6, 6] + dZSf1[1, 1, 1, j1])))*Mass[F[2, {j1}]]^2 - 
       S2B*(CB^2*MW^4*(4*dSW1*SW^2 + CW^4*(8*dSW1 - 
             2*SW*(4*dZe1 + dZbarHiggs1[5, 5])) - 
           CW^2*(4*dSW1 - SW*(4*dZe1 + dZbarHiggs1[5, 5] + (1 - 2*CW^2)*
                (dZbarSf1[1, 1, 1, j2] + dZHiggs1[6, 6] + dZSf1[1, 1, 1, 
                  j1])))) + 4*CW^4*MW^2*SW*dMf1[2, j1]*Mass[F[2, {j1}]])))/
     (CB^2*CW^4*MW^4*SW^3)}}, C[S[5], -S[5], S[12, {s1, j1}], 
   -S[12, {s2, j2}]] == 
  {{((I/4)*EL^2*IndexDelta[j1, j2]*(C2B*Conjugate[USf[2, j1][s1, 1]]*
        USf[2, j1][s2, 1] - (2*Conjugate[USf[2, j1][s1, 2]]*
         (C2B*CB^2*MW^2*SW^2 + CW^2*SB^2*Mass[F[2, {j1}]]^2)*
         USf[2, j1][s2, 2])/(CB^2*MW^2)))/(CW^2*SW^2), 
    ((-I/8)*EL^2*IndexDelta[j1, j2]*(2*Conjugate[USf[2, j1][s1, 2]]*
        (CB*CW^2*MW^2*SW*(C2B*CB^2*MW^2*SW^2 + CW^2*SB^2*Mass[F[2, {j1}]]^2)*
          (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 2] + dZbarSf1[2, s2, 2, j2]*
            USf[2, j1][2, 2]) - 
         (CW^4*SB*(SB*(4*dCB1*MW^2*SW + CB*(2*dMWsq1*SW + MW^2*(4*dSW1 - 
                   SW*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[5, 5])))) + 
             CB^2*MW^2*SW*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))*
            Mass[F[2, {j1}]]^2 - CB*MW^2*SW*(CB^2*MW^2*SW^2*
              (C2B*(4*dSW1*SW + CW^2*(4*dZe1 + dZbarHiggs1[5, 5] + 
                   dZHiggs1[5, 5])) + CW^2*S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 
                  5])) + 4*CW^4*SB^2*dMf1[2, j1]*Mass[F[2, {j1}]]))*
          USf[2, j1][s2, 2]) - CB*MW^2*(MW^2*Conjugate[USf[2, j1][s1, 1]]*
          (C2B*CB^2*CW^2*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
             dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) + 
           (dSW1*(4*CB^8*SW^2 - 4*CB^2*CW^2*(1 - 2*CW^2*SB^2 + 2*C2B*SB^4*
                  SW^2)) - CB^2*SW*(4*dSW1*SB^6*SW - C2B*(dSW1*S2B^2*SW + 
                 CW^2*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[5, 5])) - CW^2*
                (8*CB*dCB1 + dSB1*(8*SB - 16*SB^3) - S2B*(8*dCB1*SB - 
                   2*dSW1*S2B*(1 + 2*SB^2)*SW - dZHiggs1[5, 6] - dZHiggs1[6, 
                    5]))))*USf[2, j1][s2, 1]) + 
         CW^2*SW*(C2B*CB^2*MW^2*(Conjugate[USf[2, j1][1, 1]]*
              dZSf1[1, s1, 2, j1] + Conjugate[USf[2, j1][2, 1]]*
              dZSf1[2, s1, 2, j1])*USf[2, j1][s2, 1] - 
           2*(Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s1, 2, j1] + 
             Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s1, 2, j1])*
            (C2B*CB^2*MW^2*SW^2 + CW^2*SB^2*Mass[F[2, {j1}]]^2)*
            USf[2, j1][s2, 2]))))/(CB^3*CW^4*MW^4*SW^3)}}, 
 C[S[6], -S[6], S[12, {s1, j1}], -S[12, {s2, j2}]] == 
  {{((-I/4)*EL^2*IndexDelta[j1, j2]*(C2B*MW^2*Conjugate[USf[2, j1][s1, 1]]*
        USf[2, j1][s2, 1] - 2*Conjugate[USf[2, j1][s1, 2]]*
        (C2B*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2]))/
     (CW^2*MW^2*SW^2), ((I/8)*EL^2*IndexDelta[j1, j2]*
      (2*Conjugate[USf[2, j1][s1, 2]]*(CB*CW^2*MW^2*SW*(C2B*MW^2*SW^2 - 
           CW^2*Mass[F[2, {j1}]]^2)*(dZbarSf1[1, s2, 2, j2]*
            USf[2, j1][1, 2] + dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 2]) + 
         (CW^4*(MW^2*SW*(4*dCB1 + SB*(dZHiggs1[5, 6] + dZHiggs1[6, 5])) + 
             CB*(4*dSW1*MW^2 + 2*SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[6, 
                    6]))))*Mass[F[2, {j1}]]^2 - 
           CB*(MW^4*SW^3*(CW^2*S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - 2*C2B*
                (2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[6, 6]))) + 
             4*CW^4*MW^2*SW*dMf1[2, j1]*Mass[F[2, {j1}]]))*
          USf[2, j1][s2, 2]) - MW^2*(MW^2*Conjugate[USf[2, j1][s1, 1]]*
          (C2B*CB*CW^2*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
             dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) + 
           (4*C2B*CB^2*CW^2*dCB1*SW - 2*S2B*(2*dSW1*SB*SW^2 - CW^2*
                (2*dSW1*SB + C2B*dSB1*SW)) + CB*(4*dSW1*SW^2 - CW^2*
                (4*dSW1 + SW*(S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - 
                   2*C2B*(2*dZe1 + dZHiggs1[6, 6])))))*USf[2, j1][s2, 1]) + 
         CB*CW^2*SW*(C2B*MW^2*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s1, 2, 
               j1] + Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*
            USf[2, j1][s2, 1] - 2*(Conjugate[USf[2, j1][1, 2]]*
              dZSf1[1, s1, 2, j1] + Conjugate[USf[2, j1][2, 2]]*
              dZSf1[2, s1, 2, j1])*(C2B*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*
            USf[2, j1][s2, 2]))))/(CB*CW^4*MW^4*SW^3)}}, 
 C[S[5], -S[6], S[12, {s1, j1}], -S[12, {s2, j2}]] == 
  {{((I/4)*EL^2*SB*IndexDelta[j1, j2]*(2*CB*Conjugate[USf[2, j1][s1, 1]]*
        USf[2, j1][s2, 1] - (2*Conjugate[USf[2, j1][s1, 2]]*
         (2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2])/
        (CB*MW^2)))/(CW^2*SW^2), ((I/8)*EL^2*IndexDelta[j1, j2]*
      (CB^3*MW^4*Conjugate[USf[2, j1][s1, 1]]*
        (2*CW^2*SB*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
           dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) + 
         ((SB*(16*dSW1*SW^2 - 16*CW^4*(dSW1 - 3*dSB1*SB^3*SW)) + 
            CW^2*SW*(4*dCB1*S2B*(3 + SB^2) + dSB1*(5*S2B^2 + 4*SB^2 - 
                4*SB^4*(5 - 12*SW^2)) + 4*SB*(4*dZe1 - 4*dSW1*SW + 
                dZHiggs1[5, 5] + dZHiggs1[6, 6])))*USf[2, j1][s2, 1])/2) + 
       2*((CW^2*MW^2*S2B*SW*(CB^2*MW^2*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, 
                s1, 2, j1] + Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*
             USf[2, j1][s2, 1] - (Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s1, 2, 
                j1] + Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s1, 2, j1])*
             (2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2]))/
          2 - Conjugate[USf[2, j1][s1, 2]]*
          ((CW^2*MW^2*S2B*SW*(2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*
             (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 2] + dZbarSf1[2, s2, 2, 
                j2]*USf[2, j1][2, 2]))/2 + 
           (CW^4*(MW^2*SW*(4*dCB1*SB + dZHiggs1[6, 5]) + (S2B*(2*dMWsq1*SW + 
                  MW^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[5, 5] + dZHiggs1[6, 
                       6]))))/2)*Mass[F[2, {j1}]]^2 + 
             (MW^2*S2B*SW*(2*CB^2*MW^2*SW^2*(4*dSW1*SW + CW^2*(4*dZe1 + 
                    dZHiggs1[5, 5] + dZHiggs1[6, 6])) - 4*CW^4*dMf1[2, j1]*
                 Mass[F[2, {j1}]]))/2)*USf[2, j1][s2, 2]))))/
     (CB^2*CW^4*MW^4*SW^3)}}, C[S[6], -S[5], S[12, {s1, j1}], 
   -S[12, {s2, j2}]] == 
  {{((I/4)*EL^2*SB*IndexDelta[j1, j2]*(2*CB*Conjugate[USf[2, j1][s1, 1]]*
        USf[2, j1][s2, 1] - (2*Conjugate[USf[2, j1][s1, 2]]*
         (2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2])/
        (CB*MW^2)))/(CW^2*SW^2), ((I/8)*EL^2*IndexDelta[j1, j2]*
      (CB^3*MW^4*Conjugate[USf[2, j1][s1, 1]]*
        (2*CW^2*SB*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
           dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) + 
         ((SB*(16*dSW1*SW^2 - 16*CW^4*(dSW1 - 3*dSB1*SB^3*SW)) + 
            CW^2*SW*(4*dCB1*S2B*(3 + SB^2) + dSB1*(5*S2B^2 + 4*SB^2 - 
                4*SB^4*(5 - 12*SW^2)) + 4*SB*(4*dZe1 - 4*dSW1*SW + 
                dZbarHiggs1[5, 5] + dZHiggs1[6, 6])))*USf[2, j1][s2, 1])/2) + 
       2*((CW^2*MW^2*S2B*SW*(CB^2*MW^2*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, 
                s1, 2, j1] + Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*
             USf[2, j1][s2, 1] - (Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s1, 2, 
                j1] + Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s1, 2, j1])*
             (2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*USf[2, j1][s2, 2]))/
          2 - Conjugate[USf[2, j1][s1, 2]]*
          ((CW^2*MW^2*S2B*SW*(2*CB^2*MW^2*SW^2 - CW^2*Mass[F[2, {j1}]]^2)*
             (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 2] + dZbarSf1[2, s2, 2, 
                j2]*USf[2, j1][2, 2]))/2 + 
           (CW^4*(MW^2*SW*(4*dCB1*SB + dZHiggs1[5, 6]) + (S2B*(2*dMWsq1*SW + 
                  MW^2*(4*dSW1 - SW*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[6, 
                       6]))))/2)*Mass[F[2, {j1}]]^2 + 
             (MW^2*S2B*SW*(2*CB^2*MW^2*SW^2*(4*dSW1*SW + CW^2*(4*dZe1 + 
                    dZbarHiggs1[5, 5] + dZHiggs1[6, 6])) - 4*CW^4*dMf1[2, j1]*
                 Mass[F[2, {j1}]]))/2)*USf[2, j1][s2, 2]))))/
     (CB^2*CW^4*MW^4*SW^3)}}, C[S[5], -S[5], S[13, {s1, j1, o1}], 
   -S[13, {s2, j2, o2}]] == 
  {{((-I/12)*EL^2*IndexDelta[o1, o2]*(Conjugate[USf[3, j1][s1, 1]]*
        (C2B*(1 + 2*CW^2)*MW^2*S2B^2*IndexDelta[j1, j2] + 
         24*CW^2*SB^4*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^2 + 
           CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
           CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
        USf[3, j2][s2, 1] - 4*Conjugate[USf[3, j1][s1, 2]]*IndexDelta[j1, j2]*
        (C2B*MW^2*S2B^2*SW^2 - 6*CB^4*CW^2*Mass[F[3, {j1}]]^2)*
        USf[3, j2][s2, 2]))/(CW^2*MW^2*S2B^2*SW^2), 
    ((-I/3)*EL^2*IndexDelta[o1, o2]*(SB^3*Conjugate[USf[3, j1][s1, 1]]*
        (CW^2*MW^2*SW*(C2B*CB^3*(1 + 2*CW^2)*MW^2*IndexDelta[j1, j2] + 
           3*CW^2*S2B*SB*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^
               2 + CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
             CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
          (dZbarSf1[1, s2, 3, j2]*USf[3, j2][1, 1] + dZbarSf1[2, s2, 3, j2]*
            USf[3, j2][2, 1]) + 
         (CB^3*MW^4*(C2B*(4*dSW1*SW^2 - CW^4*(8*dSW1 - 2*SW*(4*dZe1 + 
                   dZbarHiggs1[5, 5] + dZHiggs1[5, 5])) - CW^2*(4*dSW1 - 
                 SW*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[5, 5]))) + 
             CW^2*(1 + 2*CW^2)*S2B*SW*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))*
            IndexDelta[j1, j2] + 6*CW^4*SB*(CKM[j2, 1]*Mass[F[4, {1}]]*
              (MW^2*S2B*SW*Conjugate[dCKM1[j1, 1]]*Mass[F[4, {1}]] + 
               Conjugate[CKM[j1, 1]]*(2*MW^2*S2B*SW*dMf1[4, 1] - 
                 ((S2B*(4*dSW1*MW^2 + SW*(2*dMWsq1 - MW^2*(4*dZe1 + 
                          dZbarHiggs1[5, 5] + dZHiggs1[5, 5]))))/2 + 
                   MW^2*SW*(4*dCB1*SB + CB^2*(dZHiggs1[5, 6] + dZHiggs1[6, 
                        5])))*Mass[F[4, {1}]])) + 
             S2B*(MW^2*SW*Conjugate[CKM[j1, 1]]*dCKM1[j2, 1]*Mass[F[4, {1}]]^
                 2 + CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]*
                (2*MW^2*SW*dMf1[4, 2] - (2*dSW1*MW^2 + dMWsq1*SW)*
                  Mass[F[4, {2}]])) + SW*(SB*(2*CB*MW^2*Conjugate[CKM[j1, 3]]*
                  dCKM1[j2, 3] + CKM[j2, 3]*(2*CB*MW^2*Conjugate[dCKM1[j1, 
                      3]] - Conjugate[CKM[j1, 3]]*(4*dCB1*MW^2 + 
                     CB*(2*dMWsq1 - MW^2*(4*dZe1 + dZbarHiggs1[5, 5] + 
                         dZHiggs1[5, 5]))))) - CB^2*MW^2*CKM[j2, 3]*
                Conjugate[CKM[j1, 3]]*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))*
              Mass[F[4, {3}]]^2 + MW^2*(SW*(S2B*Conjugate[CKM[j1, 2]]*
                  dCKM1[j2, 2] + (CKM[j2, 2]*(2*S2B*Conjugate[dCKM1[j1, 2]] - 
                    Conjugate[CKM[j1, 2]]*(8*dCB1*SB - S2B*(4*dZe1 + 
                        dZbarHiggs1[5, 5] + dZHiggs1[5, 5]) + 2*CB^2*
                       (dZHiggs1[5, 6] + dZHiggs1[6, 5]))))/2)*
                Mass[F[4, {2}]]^2 + 2*S2B*CKM[j2, 3]*Conjugate[CKM[j1, 3]]*
                Mass[F[4, {3}]]*(SW*dMf1[4, 3] - dSW1*Mass[F[4, {3}]]))))*
          USf[3, j2][s2, 1]) + 
       CB*(CW^2*MW^2*SB*SW*(SB^2*(Conjugate[USf[3, j1][1, 1]]*
              dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 1]]*
              dZSf1[2, s1, 3, j1])*(C2B*CB^2*(1 + 2*CW^2)*MW^2*
              IndexDelta[j1, j2] + 6*CW^2*SB^2*(CKM[j2, 1]*Conjugate[
                 CKM[j1, 1]]*Mass[F[4, {1}]]^2 + CKM[j2, 2]*Conjugate[
                 CKM[j1, 2]]*Mass[F[4, {2}]]^2 + CKM[j2, 3]*Conjugate[
                 CKM[j1, 3]]*Mass[F[4, {3}]]^2))*USf[3, j2][s2, 1] - 
           (Conjugate[USf[3, j1][1, 2]]*dZSf1[1, s1, 3, j1] + 
             Conjugate[USf[3, j1][2, 2]]*dZSf1[2, s1, 3, j1])*
            IndexDelta[j1, j2]*(C2B*MW^2*S2B^2*SW^2 - 6*CB^4*CW^2*
              Mass[F[3, {j1}]]^2)*USf[3, j2][s2, 2]) - 
         2*CB^2*Conjugate[USf[3, j1][s1, 2]]*IndexDelta[j1, j2]*
          (CW^2*MW^2*SB*SW*(2*C2B*MW^2*SB^2*SW^2 - 3*CB^2*CW^2*
              Mass[F[3, {j1}]]^2)*(dZbarSf1[1, s2, 3, j2]*USf[3, j2][1, 2] + 
             dZbarSf1[2, s2, 3, j2]*USf[3, j2][2, 2]) + 
           (2*MW^4*SB^3*SW^3*(C2B*(4*dSW1*SW + CW^2*(4*dZe1 + dZbarHiggs1[5, 
                    5] + dZHiggs1[5, 5])) + CW^2*S2B*(dZHiggs1[5, 6] + 
                 dZHiggs1[6, 5])) - 3*CB*CW^4*Mass[F[3, {j1}]]*
              (2*MW^2*S2B*SW*dMf1[3, j1] - (CB*(4*dSW1*MW^2*SB + 
                   SW*(4*dSB1*MW^2 + SB*(2*dMWsq1 - MW^2*(4*dZe1 + 
                         dZbarHiggs1[5, 5] + dZHiggs1[5, 5])))) - 
                 MW^2*SB^2*SW*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))*
                Mass[F[3, {j1}]]))*USf[3, j2][s2, 2]))))/
     (CW^4*MW^4*S2B^3*SW^3)}}, C[S[6], -S[6], S[13, {s1, j1, o1}], 
   -S[13, {s2, j2, o2}]] == 
  {{((I/12)*EL^2*IndexDelta[o1, o2]*(Conjugate[USf[3, j1][s1, 1]]*
        (C2B*(1 + 2*CW^2)*MW^2*IndexDelta[j1, j2] - 
         6*CW^2*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^2 + 
           CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
           CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
        USf[3, j2][s2, 1] - 2*Conjugate[USf[3, j1][s1, 2]]*IndexDelta[j1, j2]*
        (2*C2B*MW^2*SW^2 + 3*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j2][s2, 2]))/
     (CW^2*MW^2*SW^2), ((I/12)*EL^2*IndexDelta[o1, o2]*
      (SB*Conjugate[USf[3, j1][s1, 1]]*(CB*CW^2*MW^2*SW*
          (C2B*(1 + 2*CW^2)*MW^2*IndexDelta[j1, j2] - 
           6*CW^2*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^2 + 
             CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
             CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
          (dZbarSf1[1, s2, 3, j2]*USf[3, j2][1, 1] + dZbarSf1[2, s2, 3, j2]*
            USf[3, j2][2, 1]) - 
         2*(CB*MW^4*((CW^2*(1 + 2*CW^2)*S2B*SW*(dZHiggs1[5, 6] + 
                dZHiggs1[6, 5]))/2 - C2B*(2*dSW1*SW^2 - CW^4*(4*dSW1 - 
                 2*SW*(2*dZe1 + dZHiggs1[6, 6])) - CW^2*(2*dSW1 - 
                 SW*(2*dZe1 + dZHiggs1[6, 6]))))*IndexDelta[j1, j2] + 
           3*CW^4*(CKM[j2, 1]*Mass[F[4, {1}]]*(2*CB*MW^2*SW*Conjugate[
                 dCKM1[j1, 1]]*Mass[F[4, {1}]] + Conjugate[CKM[j1, 1]]*
                (4*CB*MW^2*SW*dMf1[4, 1] - (MW^2*SW*(4*dCB1 + 
                     SB*(dZHiggs1[5, 6] + dZHiggs1[6, 5])) + 
                   CB*(4*dSW1*MW^2 + 2*SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[
                          6, 6]))))*Mass[F[4, {1}]])) + 
             2*CB*(MW^2*SW*Conjugate[CKM[j1, 1]]*dCKM1[j2, 1]*Mass[F[4, {1}]]^
                 2 + CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]*
                (2*MW^2*SW*dMf1[4, 2] - (2*dSW1*MW^2 + dMWsq1*SW)*
                  Mass[F[4, {2}]])) - SW*(CKM[j2, 3]*((2*CB*dMWsq1 + 
                   4*(dCB1 - CB*dZe1)*MW^2)*Conjugate[CKM[j1, 3]] - 
                 2*CB*MW^2*Conjugate[dCKM1[j1, 3]]) - MW^2*Conjugate[
                 CKM[j1, 3]]*(2*CB*dCKM1[j2, 3] - CKM[j2, 3]*
                  (SB*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - 2*CB*dZHiggs1[6, 
                     6])))*Mass[F[4, {3}]]^2 + MW^2*(SW*CKM[j2, 2]*
                (2*CB*Conjugate[dCKM1[j1, 2]] - Conjugate[CKM[j1, 2]]*
                  (4*dCB1 + SB*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - 
                   2*CB*(2*dZe1 + dZHiggs1[6, 6])))*Mass[F[4, {2}]]^2 + CB*
                (2*SW*Conjugate[CKM[j1, 2]]*dCKM1[j2, 2]*Mass[F[4, {2}]]^2 + 
                 4*CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]*
                  (SW*dMf1[4, 3] - dSW1*Mass[F[4, {3}]])))))*
          USf[3, j2][s2, 1]) + 
       CB*(CW^2*MW^2*SB*SW*((Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, 
               j1] + Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
            (C2B*(1 + 2*CW^2)*MW^2*IndexDelta[j1, j2] - 
             6*CW^2*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^2 + 
               CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
               CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
            USf[3, j2][s2, 1] - 2*(Conjugate[USf[3, j1][1, 2]]*
              dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 2]]*
              dZSf1[2, s1, 3, j1])*IndexDelta[j1, j2]*(2*C2B*MW^2*SW^2 + 
             3*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j2][s2, 2]) - 
         2*Conjugate[USf[3, j1][s1, 2]]*IndexDelta[j1, j2]*
          (CW^2*MW^2*SB*SW*(2*C2B*MW^2*SW^2 + 3*CW^2*Mass[F[3, {j1}]]^2)*
            (dZbarSf1[1, s2, 3, j2]*USf[3, j2][1, 2] + dZbarSf1[2, s2, 3, j2]*
              USf[3, j2][2, 2]) - (3*CW^4*(4*dSW1*MW^2*SB + SW*(2*dMWsq1*SB + 
                 MW^2*(4*dSB1 - CB*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - 
                   2*SB*(2*dZe1 + dZHiggs1[6, 6]))))*Mass[F[3, {j1}]]^2 + 
             SB*(2*MW^4*SW^3*(CW^2*S2B*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) - 
                 2*C2B*(2*dSW1*SW + CW^2*(2*dZe1 + dZHiggs1[6, 6]))) - 12*
                CW^4*MW^2*SW*dMf1[3, j1]*Mass[F[3, {j1}]]))*
            USf[3, j2][s2, 2]))))/(CW^4*MW^4*S2B*SW^3)}}, 
 C[S[5], -S[6], S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}]] == 
  {{((-I/12)*EL^2*IndexDelta[o1, o2]*(Conjugate[USf[3, j1][s1, 1]]*
        ((1 + 2*CW^2)*MW^2*S2B^2*IndexDelta[j1, j2] - 
         12*CW^2*SB^2*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^2 + 
           CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
           CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
        USf[3, j2][s2, 1] - 4*Conjugate[USf[3, j1][s1, 2]]*IndexDelta[j1, j2]*
        (MW^2*S2B^2*SW^2 - 3*CB^2*CW^2*Mass[F[3, {j1}]]^2)*
        USf[3, j2][s2, 2]))/(CW^2*MW^2*S2B*SW^2), 
    ((-I/3)*EL^2*IndexDelta[o1, o2]*(SB^2*Conjugate[USf[3, j1][s1, 1]]*
        ((CW^2*MW^2*S2B*SW*(CB^2*(1 + 2*CW^2)*MW^2*IndexDelta[j1, j2] - 
            3*CW^2*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^2 + 
              CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
              CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
           (dZbarSf1[1, s2, 3, j2]*USf[3, j2][1, 1] + dZbarSf1[2, s2, 3, j2]*
             USf[3, j2][2, 1]))/2 + 
         ((CB^2*MW^4*S2B*(4*dSW1*SW^2 - CW^4*(8*dSW1 - 2*SW*(4*dZe1 + 
                  dZHiggs1[5, 5] + dZHiggs1[6, 6])) - CW^2*(4*dSW1 - 
                SW*(4*dZe1 + dZHiggs1[5, 5] + dZHiggs1[6, 6])))*
             IndexDelta[j1, j2])/2 - 3*CW^4*(CKM[j2, 1]*Mass[F[4, {1}]]*
              (MW^2*S2B*SW*Conjugate[dCKM1[j1, 1]]*Mass[F[4, {1}]] + 
               Conjugate[CKM[j1, 1]]*(2*MW^2*S2B*SW*dMf1[4, 1] - 
                 (MW^2*SW*(4*dCB1*SB + dZHiggs1[6, 5]) + (S2B*(4*dSW1*MW^2 + 
                      SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZHiggs1[5, 5] + dZHiggs1[
                          6, 6]))))/2)*Mass[F[4, {1}]])) + 
             S2B*(MW^2*SW*Conjugate[CKM[j1, 1]]*dCKM1[j2, 1]*Mass[F[4, {1}]]^
                 2 + CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]*
                (2*MW^2*SW*dMf1[4, 2] - (2*dSW1*MW^2 + dMWsq1*SW)*
                  Mass[F[4, {2}]])) + SW*(MW^2*S2B*Conjugate[CKM[j1, 3]]*
                dCKM1[j2, 3] + (CKM[j2, 3]*(2*MW^2*S2B*Conjugate[dCKM1[j1, 
                     3]] - Conjugate[CKM[j1, 3]]*(2*dMWsq1*S2B + 
                    MW^2*(8*dCB1*SB + 2*dZHiggs1[6, 5] - S2B*(4*dZe1 + 
                        dZHiggs1[5, 5] + dZHiggs1[6, 6])))))/2)*
              Mass[F[4, {3}]]^2 + MW^2*((SW*CKM[j2, 2]*(2*S2B*Conjugate[
                    dCKM1[j1, 2]] - Conjugate[CKM[j1, 2]]*(8*dCB1*SB + 
                    2*dZHiggs1[6, 5] - S2B*(4*dZe1 + dZHiggs1[5, 5] + 
                      dZHiggs1[6, 6])))*Mass[F[4, {2}]]^2)/2 + S2B*
                (SW*Conjugate[CKM[j1, 2]]*dCKM1[j2, 2]*Mass[F[4, {2}]]^2 + 
                 2*CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]*
                  (SW*dMf1[4, 3] - dSW1*Mass[F[4, {3}]])))))*
          USf[3, j2][s2, 1]) + 
       CB*(CW^2*MW^2*SB*SW*(SB^2*(Conjugate[USf[3, j1][1, 1]]*
              dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 1]]*
              dZSf1[2, s1, 3, j1])*(CB^2*(1 + 2*CW^2)*MW^2*IndexDelta[j1, 
               j2] - 3*CW^2*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^
                 2 + CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
               CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
            USf[3, j2][s2, 1] - (Conjugate[USf[3, j1][1, 2]]*
              dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 2]]*
              dZSf1[2, s1, 3, j1])*IndexDelta[j1, j2]*(MW^2*S2B^2*SW^2 - 
             3*CB^2*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j2][s2, 2]) - 
         (CB*Conjugate[USf[3, j1][s1, 2]]*IndexDelta[j1, j2]*
           (CW^2*MW^2*S2B*SW*(4*MW^2*SB^2*SW^2 - 3*CW^2*Mass[F[3, {j1}]]^2)*
             (dZbarSf1[1, s2, 3, j2]*USf[3, j2][1, 2] + dZbarSf1[2, s2, 3, 
                j2]*USf[3, j2][2, 2]) + (3*CW^4*(4*dSW1*MW^2*S2B + 
                SW*(2*dMWsq1*S2B + MW^2*(8*CB*dSB1 - 2*dZHiggs1[6, 5] - 
                    S2B*(4*dZe1 + dZHiggs1[5, 5] + dZHiggs1[6, 6]))))*
               Mass[F[3, {j1}]]^2 + S2B*(4*MW^4*SB^2*SW^3*(4*dSW1*SW + 
                  CW^2*(4*dZe1 + dZHiggs1[5, 5] + dZHiggs1[6, 6])) - 
                12*CW^4*MW^2*SW*dMf1[3, j1]*Mass[F[3, {j1}]]))*
             USf[3, j2][s2, 2]))/2)))/(CW^4*MW^4*S2B^2*SW^3)}}, 
 C[S[6], -S[5], S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}]] == 
  {{((-I/12)*EL^2*IndexDelta[o1, o2]*(Conjugate[USf[3, j1][s1, 1]]*
        ((1 + 2*CW^2)*MW^2*S2B^2*IndexDelta[j1, j2] - 
         12*CW^2*SB^2*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^2 + 
           CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
           CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
        USf[3, j2][s2, 1] - 4*Conjugate[USf[3, j1][s1, 2]]*IndexDelta[j1, j2]*
        (MW^2*S2B^2*SW^2 - 3*CB^2*CW^2*Mass[F[3, {j1}]]^2)*
        USf[3, j2][s2, 2]))/(CW^2*MW^2*S2B*SW^2), 
    ((-I/3)*EL^2*IndexDelta[o1, o2]*(SB^2*Conjugate[USf[3, j1][s1, 1]]*
        ((CW^2*MW^2*S2B*SW*(CB^2*(1 + 2*CW^2)*MW^2*IndexDelta[j1, j2] - 
            3*CW^2*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^2 + 
              CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
              CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
           (dZbarSf1[1, s2, 3, j2]*USf[3, j2][1, 1] + dZbarSf1[2, s2, 3, j2]*
             USf[3, j2][2, 1]))/2 + 
         ((CB^2*MW^4*S2B*(4*dSW1*SW^2 - CW^4*(8*dSW1 - 2*SW*(4*dZe1 + 
                  dZbarHiggs1[5, 5] + dZHiggs1[6, 6])) - CW^2*(4*dSW1 - 
                SW*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[6, 6])))*
             IndexDelta[j1, j2])/2 - 3*CW^4*(CKM[j2, 1]*Mass[F[4, {1}]]*
              (MW^2*S2B*SW*Conjugate[dCKM1[j1, 1]]*Mass[F[4, {1}]] + 
               Conjugate[CKM[j1, 1]]*(2*MW^2*S2B*SW*dMf1[4, 1] - 
                 (MW^2*SW*(4*dCB1*SB + dZHiggs1[5, 6]) + (S2B*(4*dSW1*MW^2 + 
                      SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZbarHiggs1[5, 5] + 
                          dZHiggs1[6, 6]))))/2)*Mass[F[4, {1}]])) + 
             S2B*(MW^2*SW*Conjugate[CKM[j1, 1]]*dCKM1[j2, 1]*Mass[F[4, {1}]]^
                 2 + CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]*
                (2*MW^2*SW*dMf1[4, 2] - (2*dSW1*MW^2 + dMWsq1*SW)*
                  Mass[F[4, {2}]])) + SW*(MW^2*S2B*Conjugate[CKM[j1, 3]]*
                dCKM1[j2, 3] + (CKM[j2, 3]*(2*MW^2*S2B*Conjugate[dCKM1[j1, 
                     3]] - Conjugate[CKM[j1, 3]]*(2*dMWsq1*S2B + 
                    MW^2*(8*dCB1*SB + 2*dZHiggs1[5, 6] - S2B*(4*dZe1 + 
                        dZbarHiggs1[5, 5] + dZHiggs1[6, 6])))))/2)*
              Mass[F[4, {3}]]^2 + MW^2*((SW*CKM[j2, 2]*(2*S2B*Conjugate[
                    dCKM1[j1, 2]] - Conjugate[CKM[j1, 2]]*(8*dCB1*SB + 
                    2*dZHiggs1[5, 6] - S2B*(4*dZe1 + dZbarHiggs1[5, 5] + 
                      dZHiggs1[6, 6])))*Mass[F[4, {2}]]^2)/2 + S2B*
                (SW*Conjugate[CKM[j1, 2]]*dCKM1[j2, 2]*Mass[F[4, {2}]]^2 + 
                 2*CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]*
                  (SW*dMf1[4, 3] - dSW1*Mass[F[4, {3}]])))))*
          USf[3, j2][s2, 1]) + 
       CB*(CW^2*MW^2*SB*SW*(SB^2*(Conjugate[USf[3, j1][1, 1]]*
              dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 1]]*
              dZSf1[2, s1, 3, j1])*(CB^2*(1 + 2*CW^2)*MW^2*IndexDelta[j1, 
               j2] - 3*CW^2*(CKM[j2, 1]*Conjugate[CKM[j1, 1]]*Mass[F[4, {1}]]^
                 2 + CKM[j2, 2]*Conjugate[CKM[j1, 2]]*Mass[F[4, {2}]]^2 + 
               CKM[j2, 3]*Conjugate[CKM[j1, 3]]*Mass[F[4, {3}]]^2))*
            USf[3, j2][s2, 1] - (Conjugate[USf[3, j1][1, 2]]*
              dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 2]]*
              dZSf1[2, s1, 3, j1])*IndexDelta[j1, j2]*(MW^2*S2B^2*SW^2 - 
             3*CB^2*CW^2*Mass[F[3, {j1}]]^2)*USf[3, j2][s2, 2]) - 
         (CB*Conjugate[USf[3, j1][s1, 2]]*IndexDelta[j1, j2]*
           (CW^2*MW^2*S2B*SW*(4*MW^2*SB^2*SW^2 - 3*CW^2*Mass[F[3, {j1}]]^2)*
             (dZbarSf1[1, s2, 3, j2]*USf[3, j2][1, 2] + dZbarSf1[2, s2, 3, 
                j2]*USf[3, j2][2, 2]) + (3*CW^4*(4*dSW1*MW^2*S2B + 
                SW*(2*dMWsq1*S2B + MW^2*(8*CB*dSB1 - 2*dZHiggs1[5, 6] - 
                    S2B*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[6, 6]))))*
               Mass[F[3, {j1}]]^2 + S2B*(4*MW^4*SB^2*SW^3*(4*dSW1*SW + 
                  CW^2*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[6, 6])) - 
                12*CW^4*MW^2*SW*dMf1[3, j1]*Mass[F[3, {j1}]]))*
             USf[3, j2][s2, 2]))/2)))/(CW^4*MW^4*S2B^2*SW^3)}}, 
 C[S[5], -S[5], S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{((-I/12)*EL^2*IndexDelta[o1, o2]*
      ((Conjugate[USf[4, j1][s1, 1]]*(C2B*(1 - 4*CW^2)*MW^2*SB^2*
           IndexDelta[j1, j2] + 6*CB^2*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*
             Mass[F[3, {1}]]^2 + CKM[2, j1]*Conjugate[CKM[2, j2]]*
             Mass[F[3, {2}]]^2 + CKM[3, j1]*Conjugate[CKM[3, j2]]*
             Mass[F[3, {3}]]^2))*USf[4, j2][s2, 1])/SB^2 + 
       (2*Conjugate[USf[4, j1][s1, 2]]*IndexDelta[j1, j2]*
         (C2B*CB^2*MW^2*SW^2 + 3*CW^2*SB^2*Mass[F[4, {j1}]]^2)*
         USf[4, j2][s2, 2])/CB^2))/(CW^2*MW^2*SW^2), 
    ((-I/3)*EL^2*IndexDelta[o1, o2]*(CB^3*Conjugate[USf[4, j1][s1, 1]]*
        (CW^2*MW^2*SB*SW*(C2B*(1 - 4*CW^2)*MW^2*SB^2*IndexDelta[j1, j2] + 
           6*CB^2*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*Mass[F[3, {1}]]^2 + 
             CKM[2, j1]*Conjugate[CKM[2, j2]]*Mass[F[3, {2}]]^2 + 
             CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]^2))*
          (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, j2]*
            USf[4, j2][2, 1]) + 
         (MW^4*SB^3*(C2B*(-(CW^2*(4*dSW1 - SW*(4*dZe1 + dZbarHiggs1[5, 5] + 
                    dZHiggs1[5, 5]))) + 4*(dSW1*SW^2 + CW^4*(4*dSW1 - 
                   SW*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[5, 5])))) + 
             CW^2*(1 - 4*CW^2)*S2B*SW*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))*
            IndexDelta[j1, j2] + 6*CB*CW^4*(CKM[1, j1]*Mass[F[3, {1}]]*
              (MW^2*S2B*SW*Conjugate[dCKM1[1, j2]]*Mass[F[3, {1}]] + 
               Conjugate[CKM[1, j2]]*(2*MW^2*S2B*SW*dMf1[3, 1] - 
                 ((4*dSW1*MW^2*S2B + SW*(2*dMWsq1*S2B + MW^2*(8*CB*dSB1 - 
                        S2B*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[5, 5]) - 
                        2*SB^2*(dZHiggs1[5, 6] + dZHiggs1[6, 5]))))*
                   Mass[F[3, {1}]])/2)) + CB*Mass[F[3, {2}]]*
              (SB*SW*(2*MW^2*Conjugate[CKM[2, j2]]*dCKM1[2, j1] + 
                 CKM[2, j1]*(2*MW^2*Conjugate[dCKM1[2, j2]] - 
                   Conjugate[CKM[2, j2]]*(2*dMWsq1 - MW^2*(4*dZe1 + 
                       dZbarHiggs1[5, 5] + dZHiggs1[5, 5]))))*
                Mass[F[3, {2}]] + 4*MW^2*CKM[2, j1]*Conjugate[CKM[2, j2]]*
                (SB*SW*dMf1[3, 2] - (dSW1*SB + dSB1*SW)*Mass[F[3, {2}]])) + 
             SW*(MW^2*S2B*Conjugate[CKM[1, j2]]*dCKM1[1, j1]*Mass[F[3, {1}]]^
                 2 + SB*(CB*(2*MW^2*Conjugate[CKM[3, j2]]*dCKM1[3, j1] + 
                   CKM[3, j1]*(2*MW^2*Conjugate[dCKM1[3, j2]] - 
                     Conjugate[CKM[3, j2]]*(2*dMWsq1 - MW^2*(4*dZe1 + 
                         dZbarHiggs1[5, 5] + dZHiggs1[5, 5])))) + 
                 MW^2*SB*CKM[3, j1]*Conjugate[CKM[3, j2]]*(dZHiggs1[5, 6] + 
                   dZHiggs1[6, 5]))*Mass[F[3, {3}]]^2) + 
             MW^2*(SB^2*SW*CKM[2, j1]*Conjugate[CKM[2, j2]]*(dZHiggs1[5, 6] + 
                 dZHiggs1[6, 5])*Mass[F[3, {2}]]^2 + 2*CKM[3, j1]*
                Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]*(S2B*SW*dMf1[3, 3] - 
                 (dSW1*S2B + 2*CB*dSB1*SW)*Mass[F[3, {3}]]))))*
          USf[4, j2][s2, 1]) + 
       SB*(CB*CW^2*MW^2*SW*(CB^2*(Conjugate[USf[4, j1][1, 1]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 1]]*
              dZSf1[2, s1, 4, j1])*(C2B*(1 - 4*CW^2)*MW^2*SB^2*
              IndexDelta[j1, j2] + 6*CB^2*CW^2*(CKM[1, j1]*Conjugate[
                 CKM[1, j2]]*Mass[F[3, {1}]]^2 + CKM[2, j1]*Conjugate[
                 CKM[2, j2]]*Mass[F[3, {2}]]^2 + CKM[3, j1]*Conjugate[
                 CKM[3, j2]]*Mass[F[3, {3}]]^2))*USf[4, j2][s2, 1] + 
           ((Conjugate[USf[4, j1][1, 2]]*dZSf1[1, s1, 4, j1] + 
              Conjugate[USf[4, j1][2, 2]]*dZSf1[2, s1, 4, j1])*
             IndexDelta[j1, j2]*(C2B*MW^2*S2B^2*SW^2 + 12*CW^2*SB^4*
               Mass[F[4, {j1}]]^2)*USf[4, j2][s2, 2])/2) + 
         2*SB^2*Conjugate[USf[4, j1][s1, 2]]*IndexDelta[j1, j2]*
          (CB*CW^2*MW^2*SW*(C2B*CB^2*MW^2*SW^2 + 3*CW^2*SB^2*
              Mass[F[4, {j1}]]^2)*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 2] + 
             dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 2]) + 
           (CB^3*MW^4*SW^3*(C2B*(4*dSW1*SW + CW^2*(4*dZe1 + dZbarHiggs1[5, 
                    5] + dZHiggs1[5, 5])) + CW^2*S2B*(dZHiggs1[5, 6] + 
                 dZHiggs1[6, 5])) + 3*CW^4*SB*Mass[F[4, {j1}]]*
              (2*MW^2*S2B*SW*dMf1[4, j1] - ((S2B*(4*dSW1*MW^2 + 
                    SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZbarHiggs1[5, 5] + 
                        dZHiggs1[5, 5]))))/2 + MW^2*SW*(4*dCB1*SB + 
                   CB^2*(dZHiggs1[5, 6] + dZHiggs1[6, 5])))*
                Mass[F[4, {j1}]]))*USf[4, j2][s2, 2]))))/
     (CW^4*MW^4*S2B^3*SW^3)}}, C[S[6], -S[6], S[14, {s1, j1, o1}], 
   -S[14, {s2, j2, o2}]] == 
  {{((I/12)*EL^2*IndexDelta[o1, o2]*(Conjugate[USf[4, j1][s1, 1]]*
        (C2B*(1 - 4*CW^2)*MW^2*IndexDelta[j1, j2] - 
         6*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*Mass[F[3, {1}]]^2 + 
           CKM[2, j1]*Conjugate[CKM[2, j2]]*Mass[F[3, {2}]]^2 + 
           CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]^2))*
        USf[4, j2][s2, 1] + 2*Conjugate[USf[4, j1][s1, 2]]*IndexDelta[j1, j2]*
        (C2B*MW^2*SW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j2][s2, 2]))/
     (CW^2*MW^2*SW^2), ((I/12)*EL^2*IndexDelta[o1, o2]*
      (CB*Conjugate[USf[4, j1][s1, 1]]*(CW^2*MW^2*SB*SW*
          (C2B*(1 - 4*CW^2)*MW^2*IndexDelta[j1, j2] - 
           6*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*Mass[F[3, {1}]]^2 + 
             CKM[2, j1]*Conjugate[CKM[2, j2]]*Mass[F[3, {2}]]^2 + 
             CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]^2))*
          (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, j2]*
            USf[4, j2][2, 1]) - 
         2*(MW^4*SB*((CW^2*(1 - 4*CW^2)*S2B*SW*(dZHiggs1[5, 6] + 
                dZHiggs1[6, 5]))/2 - C2B*(2*dSW1*SW^2 + CW^4*(8*dSW1 - 
                 4*SW*(2*dZe1 + dZHiggs1[6, 6])) - CW^2*(2*dSW1 - 
                 SW*(2*dZe1 + dZHiggs1[6, 6]))))*IndexDelta[j1, j2] + 
           3*CW^4*(CKM[1, j1]*Mass[F[3, {1}]]*(2*MW^2*SB*SW*Conjugate[
                 dCKM1[1, j2]]*Mass[F[3, {1}]] + Conjugate[CKM[1, j2]]*
                (4*MW^2*SB*SW*dMf1[3, 1] - (4*dSW1*MW^2*SB + 
                   SW*(2*dMWsq1*SB + MW^2*(4*dSB1 - CB*(dZHiggs1[5, 6] + 
                         dZHiggs1[6, 5]) - 2*SB*(2*dZe1 + dZHiggs1[6, 6]))))*
                  Mass[F[3, {1}]])) + SW*(SB*(2*MW^2*Conjugate[CKM[1, j2]]*
                  dCKM1[1, j1]*Mass[F[3, {1}]]^2 - (CKM[2, j1]*
                    (2*(dMWsq1 - 2*dZe1*MW^2)*Conjugate[CKM[2, j2]] - 
                     2*MW^2*Conjugate[dCKM1[2, j2]]) - 2*MW^2*Conjugate[
                     CKM[2, j2]]*dCKM1[2, j1])*Mass[F[3, {2}]]^2) + 
               (2*MW^2*SB*Conjugate[CKM[3, j2]]*dCKM1[3, j1] + CKM[3, j1]*
                  (2*MW^2*SB*Conjugate[dCKM1[3, j2]] - Conjugate[CKM[3, j2]]*
                    (2*dMWsq1*SB - MW^2*(CB*(dZHiggs1[5, 6] + dZHiggs1[6, 
                          5]) + 2*SB*(2*dZe1 + dZHiggs1[6, 6])))))*
                Mass[F[3, {3}]]^2) + MW^2*(CKM[2, j1]*Conjugate[CKM[2, j2]]*
                (SW*(CB*(dZHiggs1[5, 6] + dZHiggs1[6, 5]) + 2*SB*dZHiggs1[6, 
                     6])*Mass[F[3, {2}]]^2 + 4*Mass[F[3, {2}]]*
                  (SB*SW*dMf1[3, 2] - (dSW1*SB + dSB1*SW)*Mass[F[3, {2}]])) + 
               4*CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]*
                (SB*SW*dMf1[3, 3] - (dSW1*SB + dSB1*SW)*Mass[F[3, {3}]]))))*
          USf[4, j2][s2, 1]) + 
       SB*(CB*CW^2*MW^2*SW*((Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s1, 4, 
               j1] + Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s1, 4, j1])*
            (C2B*(1 - 4*CW^2)*MW^2*IndexDelta[j1, j2] - 
             6*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*Mass[F[3, {1}]]^2 + 
               CKM[2, j1]*Conjugate[CKM[2, j2]]*Mass[F[3, {2}]]^2 + 
               CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]^2))*
            USf[4, j2][s2, 1] + 2*(Conjugate[USf[4, j1][1, 2]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 2]]*
              dZSf1[2, s1, 4, j1])*IndexDelta[j1, j2]*(C2B*MW^2*SW^2 - 
             3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j2][s2, 2]) + 
         2*Conjugate[USf[4, j1][s1, 2]]*IndexDelta[j1, j2]*
          (CB*CW^2*MW^2*SW*(C2B*MW^2*SW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*
            (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 2] + dZbarSf1[2, s2, 4, j2]*
              USf[4, j2][2, 2]) + (3*CW^4*(MW^2*SW*(4*dCB1 + 
                 SB*(dZHiggs1[5, 6] + dZHiggs1[6, 5])) + CB*(4*dSW1*MW^2 + 
                 2*SW*(dMWsq1 - MW^2*(2*dZe1 + dZHiggs1[6, 6]))))*
              Mass[F[4, {j1}]]^2 - CB*(MW^4*SW^3*(CW^2*S2B*(dZHiggs1[5, 6] + 
                   dZHiggs1[6, 5]) - 2*C2B*(2*dSW1*SW + CW^2*(2*dZe1 + 
                     dZHiggs1[6, 6]))) + 12*CW^4*MW^2*SW*dMf1[4, j1]*
                Mass[F[4, {j1}]]))*USf[4, j2][s2, 2]))))/
     (CW^4*MW^4*S2B*SW^3)}}, C[S[5], -S[6], S[14, {s1, j1, o1}], 
   -S[14, {s2, j2, o2}]] == 
  {{((-I/3)*EL^2*IndexDelta[o1, o2]*(CB^2*Conjugate[USf[4, j1][s1, 1]]*
        ((1 - 4*CW^2)*MW^2*SB^2*IndexDelta[j1, j2] + 
         3*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*Mass[F[3, {1}]]^2 + 
           CKM[2, j1]*Conjugate[CKM[2, j2]]*Mass[F[3, {2}]]^2 + 
           CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]^2))*
        USf[4, j2][s2, 1] + SB^2*Conjugate[USf[4, j1][s1, 2]]*
        IndexDelta[j1, j2]*(2*CB^2*MW^2*SW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*
        USf[4, j2][s2, 2]))/(CW^2*MW^2*S2B*SW^2), 
    ((-I/3)*EL^2*IndexDelta[o1, o2]*(CB^2*Conjugate[USf[4, j1][s1, 1]]*
        ((CW^2*MW^2*S2B*SW*((1 - 4*CW^2)*MW^2*SB^2*IndexDelta[j1, j2] + 
            3*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*Mass[F[3, {1}]]^2 + 
              CKM[2, j1]*Conjugate[CKM[2, j2]]*Mass[F[3, {2}]]^2 + 
              CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]^2))*
           (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, j2]*
             USf[4, j2][2, 1]))/2 + 
         ((MW^4*S2B*SB^2*(-(CW^2*(4*dSW1 - SW*(4*dZe1 + dZHiggs1[5, 5] + 
                   dZHiggs1[6, 6]))) + 4*(dSW1*SW^2 + CW^4*(4*dSW1 - 
                  SW*(4*dZe1 + dZHiggs1[5, 5] + dZHiggs1[6, 6]))))*
             IndexDelta[j1, j2])/2 + 3*CW^4*(CKM[1, j1]*Mass[F[3, {1}]]*
              (MW^2*S2B*SW*Conjugate[dCKM1[1, j2]]*Mass[F[3, {1}]] + 
               Conjugate[CKM[1, j2]]*(2*MW^2*S2B*SW*dMf1[3, 1] - 
                 (2*dSW1*MW^2*S2B + (SW*(2*dMWsq1*S2B + MW^2*(8*CB*dSB1 - 
                        2*dZHiggs1[6, 5] - S2B*(4*dZe1 + dZHiggs1[5, 5] + 
                          dZHiggs1[6, 6]))))/2)*Mass[F[3, {1}]])) + 
             CB*Mass[F[3, {2}]]*(SB*SW*(2*MW^2*Conjugate[CKM[2, j2]]*
                  dCKM1[2, j1] + CKM[2, j1]*(2*MW^2*Conjugate[dCKM1[2, j2]] - 
                   Conjugate[CKM[2, j2]]*(2*dMWsq1 - MW^2*(4*dZe1 + dZHiggs1[
                        5, 5]))))*Mass[F[3, {2}]] + 4*MW^2*CKM[2, j1]*
                Conjugate[CKM[2, j2]]*(SB*SW*dMf1[3, 2] - (dSW1*SB + dSB1*SW)*
                  Mass[F[3, {2}]])) + SW*(MW^2*S2B*Conjugate[CKM[1, j2]]*
                dCKM1[1, j1]*Mass[F[3, {1}]]^2 + (MW^2*S2B*Conjugate[
                   CKM[3, j2]]*dCKM1[3, j1] + (CKM[3, j1]*(2*MW^2*S2B*
                     Conjugate[dCKM1[3, j2]] - Conjugate[CKM[3, j2]]*
                     (2*dMWsq1*S2B - MW^2*(2*dZHiggs1[6, 5] + S2B*(4*dZe1 + 
                          dZHiggs1[5, 5] + dZHiggs1[6, 6])))))/2)*
                Mass[F[3, {3}]]^2) + MW^2*((SW*CKM[2, j1]*Conjugate[
                  CKM[2, j2]]*(2*dZHiggs1[6, 5] + S2B*dZHiggs1[6, 6])*
                 Mass[F[3, {2}]]^2)/2 + 2*CKM[3, j1]*Conjugate[CKM[3, j2]]*
                Mass[F[3, {3}]]*(S2B*SW*dMf1[3, 3] - (dSW1*S2B + 2*CB*dSB1*
                    SW)*Mass[F[3, {3}]]))))*USf[4, j2][s2, 1]) + 
       SB*(CB*CW^2*MW^2*SW*(CB^2*(Conjugate[USf[4, j1][1, 1]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 1]]*
              dZSf1[2, s1, 4, j1])*((1 - 4*CW^2)*MW^2*SB^2*IndexDelta[j1, 
               j2] + 3*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*Mass[F[3, {1}]]^
                 2 + CKM[2, j1]*Conjugate[CKM[2, j2]]*Mass[F[3, {2}]]^2 + 
               CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]^2))*
            USf[4, j2][s2, 1] + SB^2*(Conjugate[USf[4, j1][1, 2]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 2]]*
              dZSf1[2, s1, 4, j1])*IndexDelta[j1, j2]*(2*CB^2*MW^2*SW^2 - 
             3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j2][s2, 2]) + 
         SB*Conjugate[USf[4, j1][s1, 2]]*IndexDelta[j1, j2]*
          ((CW^2*MW^2*S2B*SW*(2*CB^2*MW^2*SW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*
             (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 2] + dZbarSf1[2, s2, 4, 
                j2]*USf[4, j2][2, 2]))/2 + 
           (3*CW^4*(MW^2*SW*(4*dCB1*SB + dZHiggs1[6, 5]) + (S2B*
                 (4*dSW1*MW^2 + SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZHiggs1[5, 
                       5] + dZHiggs1[6, 6]))))/2)*Mass[F[4, {j1}]]^2 + 
             SB*(2*CB^3*MW^4*SW^3*(4*dSW1*SW + CW^2*(4*dZe1 + dZHiggs1[5, 
                    5] + dZHiggs1[6, 6])) - 12*CB*CW^4*MW^2*SW*dMf1[4, j1]*
                Mass[F[4, {j1}]]))*USf[4, j2][s2, 2]))))/
     (CW^4*MW^4*S2B^2*SW^3)}}, C[S[6], -S[5], S[14, {s1, j1, o1}], 
   -S[14, {s2, j2, o2}]] == 
  {{((-I/3)*EL^2*IndexDelta[o1, o2]*(CB^2*Conjugate[USf[4, j1][s1, 1]]*
        ((1 - 4*CW^2)*MW^2*SB^2*IndexDelta[j1, j2] + 
         3*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*Mass[F[3, {1}]]^2 + 
           CKM[2, j1]*Conjugate[CKM[2, j2]]*Mass[F[3, {2}]]^2 + 
           CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]^2))*
        USf[4, j2][s2, 1] + SB^2*Conjugate[USf[4, j1][s1, 2]]*
        IndexDelta[j1, j2]*(2*CB^2*MW^2*SW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*
        USf[4, j2][s2, 2]))/(CW^2*MW^2*S2B*SW^2), 
    ((-I/3)*EL^2*IndexDelta[o1, o2]*(CB^2*Conjugate[USf[4, j1][s1, 1]]*
        ((CW^2*MW^2*S2B*SW*((1 - 4*CW^2)*MW^2*SB^2*IndexDelta[j1, j2] + 
            3*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*Mass[F[3, {1}]]^2 + 
              CKM[2, j1]*Conjugate[CKM[2, j2]]*Mass[F[3, {2}]]^2 + 
              CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]^2))*
           (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, j2]*
             USf[4, j2][2, 1]))/2 + 
         ((MW^4*S2B*SB^2*(-(CW^2*(4*dSW1 - SW*(4*dZe1 + dZbarHiggs1[5, 5] + 
                   dZHiggs1[6, 6]))) + 4*(dSW1*SW^2 + CW^4*(4*dSW1 - 
                  SW*(4*dZe1 + dZbarHiggs1[5, 5] + dZHiggs1[6, 6]))))*
             IndexDelta[j1, j2])/2 + 3*CW^4*(CKM[1, j1]*Mass[F[3, {1}]]*
              (MW^2*S2B*SW*Conjugate[dCKM1[1, j2]]*Mass[F[3, {1}]] + 
               Conjugate[CKM[1, j2]]*(2*MW^2*S2B*SW*dMf1[3, 1] - 
                 (2*dSW1*MW^2*S2B + (SW*(2*dMWsq1*S2B + MW^2*(8*CB*dSB1 - 
                        2*dZHiggs1[5, 6] - S2B*(4*dZe1 + dZbarHiggs1[5, 5] + 
                          dZHiggs1[6, 6]))))/2)*Mass[F[3, {1}]])) + 
             CB*Mass[F[3, {2}]]*(SB*SW*(2*MW^2*Conjugate[CKM[2, j2]]*
                  dCKM1[2, j1] + CKM[2, j1]*(2*MW^2*Conjugate[dCKM1[2, j2]] - 
                   Conjugate[CKM[2, j2]]*(2*dMWsq1 - MW^2*(4*dZe1 + 
                       dZbarHiggs1[5, 5]))))*Mass[F[3, {2}]] + 4*MW^2*
                CKM[2, j1]*Conjugate[CKM[2, j2]]*(SB*SW*dMf1[3, 2] - 
                 (dSW1*SB + dSB1*SW)*Mass[F[3, {2}]])) + 
             SW*(MW^2*S2B*Conjugate[CKM[1, j2]]*dCKM1[1, j1]*Mass[F[3, {1}]]^
                 2 + (MW^2*S2B*Conjugate[CKM[3, j2]]*dCKM1[3, j1] + 
                 (CKM[3, j1]*(2*MW^2*S2B*Conjugate[dCKM1[3, j2]] - 
                    Conjugate[CKM[3, j2]]*(2*dMWsq1*S2B - MW^2*
                       (2*dZHiggs1[5, 6] + S2B*(4*dZe1 + dZbarHiggs1[5, 5] + 
                          dZHiggs1[6, 6])))))/2)*Mass[F[3, {3}]]^2) + 
             MW^2*((SW*CKM[2, j1]*Conjugate[CKM[2, j2]]*(2*dZHiggs1[5, 6] + 
                  S2B*dZHiggs1[6, 6])*Mass[F[3, {2}]]^2)/2 + 2*CKM[3, j1]*
                Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]*(S2B*SW*dMf1[3, 3] - 
                 (dSW1*S2B + 2*CB*dSB1*SW)*Mass[F[3, {3}]]))))*
          USf[4, j2][s2, 1]) + 
       SB*(CB*CW^2*MW^2*SW*(CB^2*(Conjugate[USf[4, j1][1, 1]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 1]]*
              dZSf1[2, s1, 4, j1])*((1 - 4*CW^2)*MW^2*SB^2*IndexDelta[j1, 
               j2] + 3*CW^2*(CKM[1, j1]*Conjugate[CKM[1, j2]]*Mass[F[3, {1}]]^
                 2 + CKM[2, j1]*Conjugate[CKM[2, j2]]*Mass[F[3, {2}]]^2 + 
               CKM[3, j1]*Conjugate[CKM[3, j2]]*Mass[F[3, {3}]]^2))*
            USf[4, j2][s2, 1] + SB^2*(Conjugate[USf[4, j1][1, 2]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 2]]*
              dZSf1[2, s1, 4, j1])*IndexDelta[j1, j2]*(2*CB^2*MW^2*SW^2 - 
             3*CW^2*Mass[F[4, {j1}]]^2)*USf[4, j2][s2, 2]) + 
         SB*Conjugate[USf[4, j1][s1, 2]]*IndexDelta[j1, j2]*
          ((CW^2*MW^2*S2B*SW*(2*CB^2*MW^2*SW^2 - 3*CW^2*Mass[F[4, {j1}]]^2)*
             (dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 2] + dZbarSf1[2, s2, 4, 
                j2]*USf[4, j2][2, 2]))/2 + 
           (3*CW^4*(MW^2*SW*(4*dCB1*SB + dZHiggs1[5, 6]) + (S2B*
                 (4*dSW1*MW^2 + SW*(2*dMWsq1 - MW^2*(4*dZe1 + dZbarHiggs1[5, 
                       5] + dZHiggs1[6, 6]))))/2)*Mass[F[4, {j1}]]^2 + 
             SB*(2*CB^3*MW^4*SW^3*(4*dSW1*SW + CW^2*(4*dZe1 + dZbarHiggs1[5, 
                    5] + dZHiggs1[6, 6])) - 12*CB*CW^4*MW^2*SW*dMf1[4, j1]*
                Mass[F[4, {j1}]]))*USf[4, j2][s2, 2]))))/
     (CW^4*MW^4*S2B^2*SW^3)}}, C[S[11, {j1}], -S[11, {j2}], V[2], V[2]] == 
  {{((I/2)*EL^2*IndexDelta[j1, j2])/(CW^2*SW^2), 
    ((I/4)*EL^2*(4*dSW1*SW^2 - CW^2*(4*dSW1 - SW*(2*(2*dZe1 + dZZZ1) + 
           dZbarSf1[1, 1, 1, j2] + dZSf1[1, 1, 1, j1])))*IndexDelta[j1, j2])/
     (CW^4*SW^3)}}, C[S[12, {s1, j1}], -S[12, {s2, j2}], V[1], V[1]] == 
  {{(2*I)*EL^2*IndexDelta[j1, j2]*IndexDelta[s1, s2], 
    (I*EL^2*IndexDelta[j1, j2]*
      (CW*SW*(dZbarSf1[1, s2, 2, j2]*IndexDelta[1, s1] + 
         dZSf1[1, s1, 2, j1]*IndexDelta[1, s2] + dZbarSf1[2, s2, 2, j2]*
          IndexDelta[2, s1] + dZSf1[2, s1, 2, j1]*IndexDelta[2, s2] + 
         2*(dZAA1 + 2*dZe1)*IndexDelta[s1, s2]) + 
       dZZA1*((1 - 2*SW^2)*Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][s2, 1] - 
         2*SW^2*Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 2])))/(CW*SW)}}, 
 C[S[12, {s1, j1}], -S[12, {s2, j2}], V[1], V[2]] == 
  {{((-I)*EL^2*IndexDelta[j1, j2]*((1 - 2*CW^2)*Conjugate[USf[2, j1][s1, 1]]*
        USf[2, j1][s2, 1] + 2*SW^2*Conjugate[USf[2, j1][s1, 2]]*
        USf[2, j1][s2, 2]))/(CW*SW), ((I/4)*EL^2*IndexDelta[j1, j2]*
      (4*CW^3*dZAZ1*SW^2*IndexDelta[s1, s2] - Conjugate[USf[2, j1][s1, 1]]*
        (2*CW^2*(1 - 2*CW^2)*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
           dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) - 
         (CW*(1 - 2*CW^2)^2*dZZA1 - 2*CW^2*((6 - 4*CW^2)*dSW1 + 
             (1 - 2*CW^2)*(dZAA1 + 4*dZe1 + dZZZ1)*SW) + 
           dSW1*(4*SW^2 - 8*SW^4))*USf[2, j1][s2, 1]) - 
       2*SW*(2*SW*Conjugate[USf[2, j1][s1, 2]]*
          (CW^2*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 2] + 
             dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 2]) + 
           ((2*dSW1 - CW*dZZA1)*SW^2 + CW^2*(2*dSW1 + (dZAA1 + 4*dZe1 + 
                 dZZZ1)*SW))*USf[2, j1][s2, 2]) + 
         CW^2*((1 - 2*CW^2)*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s1, 2, 
               j1] + Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*
            USf[2, j1][s2, 1] + 2*SW^2*(Conjugate[USf[2, j1][1, 2]]*
              dZSf1[1, s1, 2, j1] + Conjugate[USf[2, j1][2, 2]]*
              dZSf1[2, s1, 2, j1])*USf[2, j1][s2, 2]))))/(CW^3*SW^2)}}, 
 C[S[12, {s1, j1}], -S[12, {s2, j2}], V[2], V[2]] == 
  {{((I/2)*EL^2*IndexDelta[j1, j2]*
      ((1 - 2*CW^2)^2*Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][s2, 1] + 
       4*SW^4*Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 2]))/(CW^2*SW^2), 
    ((I/4)*EL^2*IndexDelta[j1, j2]*((1 - 2*CW^2)*Conjugate[USf[2, j1][s1, 1]]*
        (CW^2*(1 - 2*CW^2)*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
           dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) - 
         2*(2*(dSW1 + CW^3*dZAZ1)*SW^2 - 4*dSW1*SW^4 - 
           CW^2*((6 - 4*CW^2)*dSW1 + (1 - 2*CW^2)*(2*dZe1 + dZZZ1)*SW))*
          USf[2, j1][s2, 1]) + SW*(4*SW^3*Conjugate[USf[2, j1][s1, 2]]*
          (CW^2*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 2] + 
             dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 2]) - 
           2*(CW^3*dZAZ1 - 2*dSW1*SW^2 - CW^2*(2*dSW1 + (2*dZe1 + dZZZ1)*SW))*
            USf[2, j1][s2, 2]) + CW^2*((1 - 2*CW^2)^2*
            (Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s1, 2, j1] + 
             Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*
            USf[2, j1][s2, 1] + 4*SW^4*(Conjugate[USf[2, j1][1, 2]]*
              dZSf1[1, s1, 2, j1] + Conjugate[USf[2, j1][2, 2]]*
              dZSf1[2, s1, 2, j1])*USf[2, j1][s2, 2]))))/(CW^4*SW^3)}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], V[1], V[1]] == 
  {{((8*I)/9)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*IndexDelta[s1, s2], 
    (((2*I)/9)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (2*CW*SW*(dZbarSf1[1, s2, 3, j2]*IndexDelta[1, s1] + 
         dZSf1[1, s1, 3, j1]*IndexDelta[1, s2] + dZbarSf1[2, s2, 3, j2]*
          IndexDelta[2, s1] + dZSf1[2, s1, 3, j1]*IndexDelta[2, s2] + 
         (2*dZAA1 + 4*dZe1)*IndexDelta[s1, s2]) + 
       dZZA1*((3 - 4*SW^2)*Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 1] - 
         4*SW^2*Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 2])))/(CW*SW)}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], V[1], V[2]] == 
  {{(((-2*I)/9)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      ((1 - 4*CW^2)*Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 1] + 
       4*SW^2*Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 2]))/(CW*SW), 
    ((I/36)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (16*CW^3*dZAZ1*SW^2*IndexDelta[s1, s2] - Conjugate[USf[3, j1][s1, 1]]*
        (4*CW^2*(1 - 4*CW^2)*SW*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 1] + 
           dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 1]) - 
         (CW*(1 - 4*CW^2)^2*dZZA1 - 8*(1 - 4*CW^2)*dSW1*SW^2 - 
           4*CW^2*((14 - 8*CW^2)*dSW1 + (1 - 4*CW^2)*(dZAA1 + 4*dZe1 + dZZZ1)*
              SW))*USf[3, j1][s2, 1]) - 
       4*SW*(4*SW*Conjugate[USf[3, j1][s1, 2]]*
          (CW^2*SW*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 2] + 
             dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 2]) + 
           ((2*dSW1 - CW*dZZA1)*SW^2 + CW^2*(2*dSW1 + (dZAA1 + 4*dZe1 + 
                 dZZZ1)*SW))*USf[3, j1][s2, 2]) + 
         CW^2*((1 - 4*CW^2)*(Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, 
               j1] + Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
            USf[3, j1][s2, 1] + 4*SW^2*(Conjugate[USf[3, j1][1, 2]]*
              dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 2]]*
              dZSf1[2, s1, 3, j1])*USf[3, j1][s2, 2]))))/(CW^3*SW^2)}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], V[2], V[2]] == 
  {{((I/18)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      ((1 - 4*CW^2)^2*Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 1] + 
       16*SW^4*Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 2]))/(CW^2*SW^2), 
    ((I/36)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      ((1 - 4*CW^2)*Conjugate[USf[3, j1][s1, 1]]*
        (CW^2*(1 - 4*CW^2)*SW*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 1] + 
           dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 1]) - 
         2*((6*dSW1 + 4*CW^3*dZAZ1)*SW^2 - 8*dSW1*SW^4 - 
           CW^2*((14 - 8*CW^2)*dSW1 + (1 - 4*CW^2)*(2*dZe1 + dZZZ1)*SW))*
          USf[3, j1][s2, 1]) + SW*(16*SW^3*Conjugate[USf[3, j1][s1, 2]]*
          (CW^2*SW*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 2] + 
             dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 2]) - 
           2*(CW^3*dZAZ1 - 2*dSW1*SW^2 - CW^2*(2*dSW1 + (2*dZe1 + dZZZ1)*SW))*
            USf[3, j1][s2, 2]) + CW^2*((1 - 4*CW^2)^2*
            (Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
             Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*
            USf[3, j1][s2, 1] + 16*SW^4*(Conjugate[USf[3, j1][1, 2]]*
              dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 2]]*
              dZSf1[2, s1, 3, j1])*USf[3, j1][s2, 2]))))/(CW^4*SW^3)}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[1], V[1]] == 
  {{((2*I)/9)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*IndexDelta[s1, s2], 
    ((I/9)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (CW*SW*(dZbarSf1[1, s2, 4, j2]*IndexDelta[1, s1] + 
         dZSf1[1, s1, 4, j1]*IndexDelta[1, s2] + dZbarSf1[2, s2, 4, j2]*
          IndexDelta[2, s1] + dZSf1[2, s1, 4, j1]*IndexDelta[2, s2] + 
         2*(dZAA1 + 2*dZe1)*IndexDelta[s1, s2]) + 
       dZZA1*((3 - 2*SW^2)*Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] - 
         2*SW^2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])))/(CW*SW)}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[1], V[2]] == 
  {{((I/9)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      ((1 + 2*CW^2)*Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] - 
       2*SW^2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]))/(CW*SW), 
    ((I/36)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (4*CW^3*dZAZ1*SW^2*IndexDelta[s1, s2] + Conjugate[USf[4, j1][s1, 1]]*
        (2*CW^2*(1 + 2*CW^2)*SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 1] + 
           dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 1]) + 
         (CW*(1 + 2*CW^2)^2*dZZA1 + 4*(1 + 2*CW^2)*dSW1*SW^2 - 
           2*CW^2*((10 - 4*CW^2)*dSW1 - (1 + 2*CW^2)*(dZAA1 + 4*dZe1 + dZZZ1)*
              SW))*USf[4, j1][s2, 1]) - 
       2*SW*(2*SW*Conjugate[USf[4, j1][s1, 2]]*
          (CW^2*SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 2] + 
             dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 2]) + 
           ((2*dSW1 - CW*dZZA1)*SW^2 + CW^2*(2*dSW1 + (dZAA1 + 4*dZe1 + 
                 dZZZ1)*SW))*USf[4, j1][s2, 2]) - 
         CW^2*((1 + 2*CW^2)*(Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s1, 4, 
               j1] + Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s1, 4, j1])*
            USf[4, j1][s2, 1] - 2*SW^2*(Conjugate[USf[4, j1][1, 2]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 2]]*
              dZSf1[2, s1, 4, j1])*USf[4, j1][s2, 2]))))/(CW^3*SW^2)}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[2], V[2]] == 
  {{((I/18)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      ((1 + 2*CW^2)^2*Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 
       4*SW^4*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]))/(CW^2*SW^2), 
    ((I/36)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      ((1 + 2*CW^2)*Conjugate[USf[4, j1][s1, 1]]*
        (CW^2*(1 + 2*CW^2)*SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 1] + 
           dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 1]) + 
         2*(2*(3*dSW1 + CW^3*dZAZ1)*SW^2 - 4*dSW1*SW^4 - 
           CW^2*((10 - 4*CW^2)*dSW1 - (1 + 2*CW^2)*(2*dZe1 + dZZZ1)*SW))*
          USf[4, j1][s2, 1]) + SW*(4*SW^3*Conjugate[USf[4, j1][s1, 2]]*
          (CW^2*SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 2] + 
             dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 2]) - 
           2*(CW^3*dZAZ1 - 2*dSW1*SW^2 - CW^2*(2*dSW1 + (2*dZe1 + dZZZ1)*SW))*
            USf[4, j1][s2, 2]) + CW^2*((1 + 2*CW^2)^2*
            (Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s1, 4, j1] + 
             Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s1, 4, j1])*
            USf[4, j1][s2, 1] + 4*SW^4*(Conjugate[USf[4, j1][1, 2]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 2]]*
              dZSf1[2, s1, 4, j1])*USf[4, j1][s2, 2]))))/(CW^4*SW^3)}}, 
 C[S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[1], V[3]] == 
  {{((I/3)*EL^2*Conjugate[CKM[j1, j2]]*Conjugate[USf[3, j1][s1, 1]]*
      IndexDelta[o1, o2]*USf[4, j2][s2, 1])/(Sqrt[2]*SW), 
    ((I/6)*EL^2*IndexDelta[o1, o2]*(2*CW*SW*Conjugate[dCKM1[j1, j2]]*
        Conjugate[USf[3, j1][s1, 1]]*USf[4, j2][s2, 1] + 
       Conjugate[CKM[j1, j2]]*(CW*SW*(Conjugate[USf[3, j1][1, 1]]*
            dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 1]]*
            dZSf1[2, s1, 3, j1])*USf[4, j2][s2, 1] + 
         Conjugate[USf[3, j1][s1, 1]]*(CW*SW*(dZbarSf1[1, s2, 4, j2]*
              USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 1]) - 
           (dZZA1*SW^2 + CW*(2*dSW1 - (dZAA1 + 4*dZe1 + dZW1)*SW))*
            USf[4, j2][s2, 1]))))/(Sqrt[2]*CW*SW^2)}}, 
 C[S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}], V[1], -V[3]] == 
  {{((I/3)*EL^2*CKM[j1, j2]*Conjugate[USf[4, j2][s2, 1]]*IndexDelta[o1, o2]*
      USf[3, j1][s1, 1])/(Sqrt[2]*SW), ((I/6)*EL^2*IndexDelta[o1, o2]*
      (2*CW*SW*Conjugate[USf[4, j2][s2, 1]]*dCKM1[j1, j2]*USf[3, j1][s1, 1] + 
       CKM[j1, j2]*(CW*SW*(Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
          USf[3, j1][s1, 1] + Conjugate[USf[4, j2][s2, 1]]*
          (CW*SW*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + 
             dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) - 
           (dZZA1*SW^2 + CW*(2*dSW1 - (dZAA1 + dZbarW1 + 4*dZe1)*SW))*
            USf[3, j1][s1, 1]))))/(Sqrt[2]*CW*SW^2)}}, 
 C[S[11, {j1}], -S[12, {s2, j2}], V[1], V[3]] == 
  {{((-I)*EL^2*IndexDelta[j1, j2]*USf[2, j1][s2, 1])/(Sqrt[2]*SW), 
    ((-I/2)*EL^2*IndexDelta[j1, j2]*
      (CW*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
         dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) - 
       (dZZA1*SW^2 + CW*(2*dSW1 - SW*(dZAA1 + 4*dZe1 + dZW1 + 
             dZSf1[1, 1, 1, j1])))*USf[2, j1][s2, 1]))/(Sqrt[2]*CW*SW^2)}}, 
 C[S[12, {s2, j2}], -S[11, {j1}], V[1], -V[3]] == 
  {{((-I)*EL^2*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2])/(Sqrt[2]*SW), 
    ((I/2)*EL^2*(Conjugate[USf[2, j1][s2, 1]]*(dZZA1*SW^2 + 
         CW*(2*dSW1 - SW*(dZAA1 + dZbarW1 + 4*dZe1 + dZbarSf1[1, 1, 1, 
              j1]))) - CW*SW*(Conjugate[USf[2, j1][1, 1]]*
          dZSf1[1, s2, 2, j2] + Conjugate[USf[2, j1][2, 1]]*
          dZSf1[2, s2, 2, j2]))*IndexDelta[j1, j2])/(Sqrt[2]*CW*SW^2)}}, 
 C[S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[2], V[3]] == 
  {{((-I/3)*EL^2*Conjugate[CKM[j1, j2]]*Conjugate[USf[3, j1][s1, 1]]*
      IndexDelta[o1, o2]*USf[4, j2][s2, 1])/(Sqrt[2]*CW), 
    ((-I/6)*EL^2*IndexDelta[o1, o2]*(2*CW^2*SW*Conjugate[dCKM1[j1, j2]]*
        Conjugate[USf[3, j1][s1, 1]]*USf[4, j2][s2, 1] + 
       Conjugate[CKM[j1, j2]]*(CW^2*SW*(Conjugate[USf[3, j1][1, 1]]*
            dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 1]]*
            dZSf1[2, s1, 3, j1])*USf[4, j2][s2, 1] + 
         Conjugate[USf[3, j1][s1, 1]]*(CW^2*SW*(dZbarSf1[1, s2, 4, j2]*
              USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 1]) - 
           (CW^3*dZAZ1 - CW^2*(4*dZe1 + dZW1 + dZZZ1)*SW - 2*dSW1*SW^2)*
            USf[4, j2][s2, 1]))))/(Sqrt[2]*CW^3*SW)}}, 
 C[S[14, {s2, j2, o1}], -S[13, {s1, j1, o2}], V[2], -V[3]] == 
  {{((-I/3)*EL^2*CKM[j1, j2]*Conjugate[USf[4, j2][s2, 1]]*IndexDelta[o1, o2]*
      USf[3, j1][s1, 1])/(Sqrt[2]*CW), ((-I/6)*EL^2*IndexDelta[o1, o2]*
      (2*CW^2*SW*Conjugate[USf[4, j2][s2, 1]]*dCKM1[j1, j2]*
        USf[3, j1][s1, 1] + CKM[j1, j2]*
        (CW^2*SW*(Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
          USf[3, j1][s1, 1] + Conjugate[USf[4, j2][s2, 1]]*
          (CW^2*SW*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + 
             dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) - 
           (CW^3*dZAZ1 - CW^2*(dZbarW1 + 4*dZe1 + dZZZ1)*SW - 2*dSW1*SW^2)*
            USf[3, j1][s1, 1]))))/(Sqrt[2]*CW^3*SW)}}, 
 C[S[11, {j1}], -S[12, {s2, j2}], V[2], V[3]] == 
  {{(I*EL^2*IndexDelta[j1, j2]*USf[2, j1][s2, 1])/(Sqrt[2]*CW), 
    ((I/2)*EL^2*IndexDelta[j1, j2]*
      (CW^2*SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
         dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) - 
       (CW^3*dZAZ1 - 2*dSW1*SW^2 - CW^2*SW*(4*dZe1 + dZW1 + dZZZ1 + 
           dZSf1[1, 1, 1, j1]))*USf[2, j1][s2, 1]))/(Sqrt[2]*CW^3*SW)}}, 
 C[S[12, {s2, j2}], -S[11, {j1}], V[2], -V[3]] == 
  {{(I*EL^2*Conjugate[USf[2, j1][s2, 1]]*IndexDelta[j1, j2])/(Sqrt[2]*CW), 
    ((-I/2)*EL^2*(Conjugate[USf[2, j1][s2, 1]]*(CW^3*dZAZ1 - 2*dSW1*SW^2 - 
         CW^2*SW*(dZbarW1 + 4*dZe1 + dZZZ1 + dZbarSf1[1, 1, 1, j1])) - 
       CW^2*SW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s2, 2, j2] + 
         Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s2, 2, j2]))*
      IndexDelta[j1, j2])/(Sqrt[2]*CW^3*SW)}}, 
 C[S[11, {j1}], -S[11, {j2}], V[3], -V[3]] == 
  {{((I/2)*EL^2*IndexDelta[j1, j2])/SW^2, 
    ((-I/4)*EL^2*(4*dSW1 - SW*(dZbarW1 + 4*dZe1 + dZW1 + 
         dZbarSf1[1, 1, 1, j2] + dZSf1[1, 1, 1, j1]))*IndexDelta[j1, j2])/
     SW^3}}, C[S[12, {s1, j1}], -S[12, {s2, j2}], V[3], -V[3]] == 
  {{((I/2)*EL^2*Conjugate[USf[2, j1][s1, 1]]*IndexDelta[j1, j2]*
      USf[2, j1][s2, 1])/SW^2, ((I/4)*EL^2*IndexDelta[j1, j2]*
      (SW*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s1, 2, j1] + 
         Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*USf[2, j1][s2, 1] + 
       Conjugate[USf[2, j1][s1, 1]]*
        (SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*
            USf[2, j1][2, 1]) - (4*dSW1 - (dZbarW1 + 4*dZe1 + dZW1)*SW)*
          USf[2, j1][s2, 1])))/SW^3}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], V[3], -V[3]] == 
  {{((I/2)*EL^2*Conjugate[USf[3, j1][s1, 1]]*IndexDelta[j1, j2]*
      IndexDelta[o1, o2]*USf[3, j1][s2, 1])/SW^2, 
    ((I/4)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (SW*(Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s1, 3, j1] + 
         Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s1, 3, j1])*USf[3, j1][s2, 1] + 
       Conjugate[USf[3, j1][s1, 1]]*
        (SW*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 1] + dZbarSf1[2, s2, 3, j2]*
            USf[3, j1][2, 1]) - (4*dSW1 - (dZbarW1 + 4*dZe1 + dZW1)*SW)*
          USf[3, j1][s2, 1])))/SW^3}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[3], -V[3]] == 
  {{((I/2)*EL^2*Conjugate[USf[4, j1][s1, 1]]*IndexDelta[j1, j2]*
      IndexDelta[o1, o2]*USf[4, j1][s2, 1])/SW^2, 
    ((I/4)*EL^2*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
      (SW*(Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s1, 4, j1] + 
         Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s1, 4, j1])*USf[4, j1][s2, 1] + 
       Conjugate[USf[4, j1][s1, 1]]*
        (SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 1] + dZbarSf1[2, s2, 4, j2]*
            USf[4, j1][2, 1]) - (4*dSW1 - (dZbarW1 + 4*dZe1 + dZW1)*SW)*
          USf[4, j1][s2, 1])))/SW^3}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], S[14, {s3, j3, o3}], 
   -S[14, {s4, j4, o4}]] == 
  {{(-I/36)*(IndexDelta[j1, j4]*IndexDelta[j2, j3]*
       (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[4, j1][s1, 1]]*
           USf[4, j1][s4, 1] - Conjugate[USf[4, j1][s1, 2]]*
           USf[4, j1][s4, 2])*(Conjugate[USf[4, j2][s3, 1]]*
           USf[4, j2][s2, 1] - Conjugate[USf[4, j2][s3, 2]]*
           USf[4, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
          (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j2][s3, 
                1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*
              USf[4, j1][s4, 1]*USf[4, j2][s2, 2] + CB^2*MW^2*SW^2*
              USf[4, j1][s4, 2]*(Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 
                 1] + 2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 2])) + 
           Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j2][s3, 2]]*
              Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][s4, 2]*
              USf[4, j2][s2, 1] + CB^2*MW^2*USf[4, j1][s4, 1]*
              ((1 + 8*CW^2)*Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 1] + 
               2*SW^2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 2]))))/
         (CB^2*CW^2*MW^2*SW^2)) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
       (36*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[4, j1][s1, 1]]*
           USf[4, j1][s2, 1] - Conjugate[USf[4, j1][s1, 2]]*
           USf[4, j1][s2, 2])*(Conjugate[USf[4, j3][s3, 1]]*
           USf[4, j3][s4, 1] - Conjugate[USf[4, j3][s3, 2]]*
           USf[4, j3][s4, 2]) + (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
          (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j3][s3, 
                1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*
              USf[4, j1][s2, 1]*USf[4, j3][s4, 2] + CB^2*MW^2*SW^2*
              USf[4, j1][s2, 2]*(Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 
                 1] + 2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2])) + 
           Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j3][s3, 2]]*
              Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][s2, 2]*
              USf[4, j3][s4, 1] + CB^2*MW^2*USf[4, j1][s2, 1]*
              ((1 + 8*CW^2)*Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 1] + 
               2*SW^2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2]))))/
         (CB^2*CW^2*MW^2*SW^2))), 
    (-I/72)*(dZbarSf1[1, s4, 4, j4]*(IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][1, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][1, 2])*(Conjugate[USf[4, j2][s3, 1]]*
             USf[4, j2][s2, 1] - Conjugate[USf[4, j2][s3, 2]]*
             USf[4, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j2][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][1, 
                 1]*USf[4, j2][s2, 2] + CB^2*MW^2*SW^2*USf[4, j1][1, 2]*
                (Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 1] + 
                 2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j2][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][1, 
                 2]*USf[4, j2][s2, 1] + CB^2*MW^2*USf[4, j1][1, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 
                   1] + 2*SW^2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 
                   2]))))/(CB^2*CW^2*MW^2*SW^2)) + IndexDelta[j1, j2]*
         IndexDelta[j3, j4]*(36*GS^2*SUNTSum[o2, o1, o4, o3]*
           (Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] - 
            Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])*
           (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][1, 1] - 
            Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][1, 2]) + 
          (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j3][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 1]*USf[4, j3][1, 2] + CB^2*MW^2*SW^2*USf[4, j1][s2, 2]*
                (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][1, 1] + 
                 2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][1, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j3][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 2]*USf[4, j3][1, 1] + CB^2*MW^2*USf[4, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][1, 1] + 
                 2*SW^2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][1, 2]))))/
           (CB^2*CW^2*MW^2*SW^2))) + dZbarSf1[2, s4, 4, j4]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][2, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][2, 2])*(Conjugate[USf[4, j2][s3, 1]]*
             USf[4, j2][s2, 1] - Conjugate[USf[4, j2][s3, 2]]*
             USf[4, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j2][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][2, 
                 1]*USf[4, j2][s2, 2] + CB^2*MW^2*SW^2*USf[4, j1][2, 2]*
                (Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 1] + 
                 2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j2][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][2, 
                 2]*USf[4, j2][s2, 1] + CB^2*MW^2*USf[4, j1][2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 
                   1] + 2*SW^2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 
                   2]))))/(CB^2*CW^2*MW^2*SW^2)) + IndexDelta[j1, j2]*
         IndexDelta[j3, j4]*(36*GS^2*SUNTSum[o2, o1, o4, o3]*
           (Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] - 
            Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])*
           (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][2, 1] - 
            Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][2, 2]) + 
          (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j3][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 1]*USf[4, j3][2, 2] + CB^2*MW^2*SW^2*USf[4, j1][s2, 2]*
                (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][2, 1] + 
                 2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][2, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j3][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 2]*USf[4, j3][2, 1] + CB^2*MW^2*USf[4, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][2, 1] + 
                 2*SW^2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][2, 2]))))/
           (CB^2*CW^2*MW^2*SW^2))) + 144*dZgs1*GS^2*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*SUNTSum[o2, o3, o4, o1]*
         (Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s4, 1] - 
          Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s4, 2])*
         (Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 1] - 
          Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 2]) + 
        IndexDelta[j1, j2]*IndexDelta[j3, j4]*SUNTSum[o2, o1, o4, o3]*
         (Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] - 
          Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])*
         (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 1] - 
          Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2])) + 
      dZSf1[1, s3, 4, j3]*(IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][s4, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][s4, 2])*(Conjugate[USf[4, j2][1, 1]]*
             USf[4, j2][s2, 1] - Conjugate[USf[4, j2][1, 2]]*
             USf[4, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j2][1, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 1]*USf[4, j2][s2, 2] + CB^2*MW^2*SW^2*USf[4, j1][s4, 2]*
                (Conjugate[USf[4, j2][1, 1]]*USf[4, j2][s2, 1] + 
                 2*Conjugate[USf[4, j2][1, 2]]*USf[4, j2][s2, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j2][1, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 2]*USf[4, j2][s2, 1] + CB^2*MW^2*USf[4, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j2][1, 1]]*USf[4, j2][s2, 1] + 
                 2*SW^2*Conjugate[USf[4, j2][1, 2]]*USf[4, j2][s2, 2]))))/
           (CB^2*CW^2*MW^2*SW^2)) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         (36*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][s2, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][s2, 2])*(Conjugate[USf[4, j3][1, 1]]*
             USf[4, j3][s4, 1] - Conjugate[USf[4, j3][1, 2]]*
             USf[4, j3][s4, 2]) + (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j3][1, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 1]*USf[4, j3][s4, 2] + CB^2*MW^2*SW^2*USf[4, j1][s2, 2]*
                (Conjugate[USf[4, j3][1, 1]]*USf[4, j3][s4, 1] + 
                 2*Conjugate[USf[4, j3][1, 2]]*USf[4, j3][s4, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j3][1, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 2]*USf[4, j3][s4, 1] + CB^2*MW^2*USf[4, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j3][1, 1]]*USf[4, j3][s4, 1] + 
                 2*SW^2*Conjugate[USf[4, j3][1, 2]]*USf[4, j3][s4, 2]))))/
           (CB^2*CW^2*MW^2*SW^2))) + dZSf1[2, s3, 4, j3]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][s4, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][s4, 2])*(Conjugate[USf[4, j2][2, 1]]*
             USf[4, j2][s2, 1] - Conjugate[USf[4, j2][2, 2]]*
             USf[4, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j2][2, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 1]*USf[4, j2][s2, 2] + CB^2*MW^2*SW^2*USf[4, j1][s4, 2]*
                (Conjugate[USf[4, j2][2, 1]]*USf[4, j2][s2, 1] + 
                 2*Conjugate[USf[4, j2][2, 2]]*USf[4, j2][s2, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j2][2, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 2]*USf[4, j2][s2, 1] + CB^2*MW^2*USf[4, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j2][2, 1]]*USf[4, j2][s2, 1] + 
                 2*SW^2*Conjugate[USf[4, j2][2, 2]]*USf[4, j2][s2, 2]))))/
           (CB^2*CW^2*MW^2*SW^2)) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         (36*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][s2, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][s2, 2])*(Conjugate[USf[4, j3][2, 1]]*
             USf[4, j3][s4, 1] - Conjugate[USf[4, j3][2, 2]]*
             USf[4, j3][s4, 2]) + (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j3][2, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 1]*USf[4, j3][s4, 2] + CB^2*MW^2*SW^2*USf[4, j1][s2, 2]*
                (Conjugate[USf[4, j3][2, 1]]*USf[4, j3][s4, 1] + 
                 2*Conjugate[USf[4, j3][2, 2]]*USf[4, j3][s4, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j3][2, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 2]*USf[4, j3][s4, 1] + CB^2*MW^2*USf[4, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j3][2, 1]]*USf[4, j3][s4, 1] + 
                 2*SW^2*Conjugate[USf[4, j3][2, 2]]*USf[4, j3][s4, 2]))))/
           (CB^2*CW^2*MW^2*SW^2))) + dZbarSf1[1, s2, 4, j2]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][s4, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][s4, 2])*(Conjugate[USf[4, j2][s3, 1]]*
             USf[4, j2][1, 1] - Conjugate[USf[4, j2][s3, 2]]*
             USf[4, j2][1, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j2][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 1]*USf[4, j2][1, 2] + CB^2*MW^2*SW^2*USf[4, j1][s4, 2]*
                (Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][1, 1] + 
                 2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][1, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j2][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 2]*USf[4, j2][1, 1] + CB^2*MW^2*USf[4, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][1, 1] + 
                 2*SW^2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][1, 2]))))/
           (CB^2*CW^2*MW^2*SW^2)) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         (36*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][1, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][1, 2])*(Conjugate[USf[4, j3][s3, 1]]*
             USf[4, j3][s4, 1] - Conjugate[USf[4, j3][s3, 2]]*
             USf[4, j3][s4, 2]) + (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j3][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][1, 
                 1]*USf[4, j3][s4, 2] + CB^2*MW^2*SW^2*USf[4, j1][1, 2]*
                (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 1] + 
                 2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j3][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][1, 
                 2]*USf[4, j3][s4, 1] + CB^2*MW^2*USf[4, j1][1, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 
                   1] + 2*SW^2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 
                   2]))))/(CB^2*CW^2*MW^2*SW^2))) + dZbarSf1[2, s2, 4, j2]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][s4, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][s4, 2])*(Conjugate[USf[4, j2][s3, 1]]*
             USf[4, j2][2, 1] - Conjugate[USf[4, j2][s3, 2]]*
             USf[4, j2][2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j2][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 1]*USf[4, j2][2, 2] + CB^2*MW^2*SW^2*USf[4, j1][s4, 2]*
                (Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][2, 1] + 
                 2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][2, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j2][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 2]*USf[4, j2][2, 1] + CB^2*MW^2*USf[4, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][2, 1] + 
                 2*SW^2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][2, 2]))))/
           (CB^2*CW^2*MW^2*SW^2)) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         (36*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][2, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][2, 2])*(Conjugate[USf[4, j3][s3, 1]]*
             USf[4, j3][s4, 1] - Conjugate[USf[4, j3][s3, 2]]*
             USf[4, j3][s4, 2]) + (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[4, j1][s1, 2]]*(9*CW^2*Conjugate[USf[4, j3][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][2, 
                 1]*USf[4, j3][s4, 2] + CB^2*MW^2*SW^2*USf[4, j1][2, 2]*
                (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 1] + 
                 2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(18*CW^2*Conjugate[USf[4, j3][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][2, 
                 2]*USf[4, j3][s4, 1] + CB^2*MW^2*USf[4, j1][2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 
                   1] + 2*SW^2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 
                   2]))))/(CB^2*CW^2*MW^2*SW^2))) + dZSf1[1, s1, 4, j1]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[4, j1][1, 1]]*
             USf[4, j1][s4, 1] - Conjugate[USf[4, j1][1, 2]]*
             USf[4, j1][s4, 2])*(Conjugate[USf[4, j2][s3, 1]]*
             USf[4, j2][s2, 1] - Conjugate[USf[4, j2][s3, 2]]*
             USf[4, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[4, j1][1, 2]]*(9*CW^2*Conjugate[USf[4, j2][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 1]*USf[4, j2][s2, 2] + CB^2*MW^2*SW^2*USf[4, j1][s4, 2]*
                (Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 1] + 
                 2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 2])) + 
             Conjugate[USf[4, j1][1, 1]]*(18*CW^2*Conjugate[USf[4, j2][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 2]*USf[4, j2][s2, 1] + CB^2*MW^2*USf[4, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 
                   1] + 2*SW^2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 
                   2]))))/(CB^2*CW^2*MW^2*SW^2)) + IndexDelta[j1, j2]*
         IndexDelta[j3, j4]*(36*GS^2*SUNTSum[o2, o1, o4, o3]*
           (Conjugate[USf[4, j1][1, 1]]*USf[4, j1][s2, 1] - 
            Conjugate[USf[4, j1][1, 2]]*USf[4, j1][s2, 2])*
           (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 1] - 
            Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2]) + 
          (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[4, j1][1, 2]]*(9*CW^2*Conjugate[USf[4, j3][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 1]*USf[4, j3][s4, 2] + CB^2*MW^2*SW^2*USf[4, j1][s2, 2]*
                (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 1] + 
                 2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2])) + 
             Conjugate[USf[4, j1][1, 1]]*(18*CW^2*Conjugate[USf[4, j3][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 2]*USf[4, j3][s4, 1] + CB^2*MW^2*USf[4, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 
                   1] + 2*SW^2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 
                   2]))))/(CB^2*CW^2*MW^2*SW^2))) + dZSf1[2, s1, 4, j1]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[4, j1][2, 1]]*
             USf[4, j1][s4, 1] - Conjugate[USf[4, j1][2, 2]]*
             USf[4, j1][s4, 2])*(Conjugate[USf[4, j2][s3, 1]]*
             USf[4, j2][s2, 1] - Conjugate[USf[4, j2][s3, 2]]*
             USf[4, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[4, j1][2, 2]]*(9*CW^2*Conjugate[USf[4, j2][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 1]*USf[4, j2][s2, 2] + CB^2*MW^2*SW^2*USf[4, j1][s4, 2]*
                (Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 1] + 
                 2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 2])) + 
             Conjugate[USf[4, j1][2, 1]]*(18*CW^2*Conjugate[USf[4, j2][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j1][
                 s4, 2]*USf[4, j2][s2, 1] + CB^2*MW^2*USf[4, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j2][s3, 1]]*USf[4, j2][s2, 
                   1] + 2*SW^2*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 
                   2]))))/(CB^2*CW^2*MW^2*SW^2)) + IndexDelta[j1, j2]*
         IndexDelta[j3, j4]*(36*GS^2*SUNTSum[o2, o1, o4, o3]*
           (Conjugate[USf[4, j1][2, 1]]*USf[4, j1][s2, 1] - 
            Conjugate[USf[4, j1][2, 2]]*USf[4, j1][s2, 2])*
           (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 1] - 
            Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2]) + 
          (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[4, j1][2, 2]]*(9*CW^2*Conjugate[USf[4, j3][s3, 
                  1]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 1]*USf[4, j3][s4, 2] + CB^2*MW^2*SW^2*USf[4, j1][s2, 2]*
                (Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 1] + 
                 2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2])) + 
             Conjugate[USf[4, j1][2, 1]]*(18*CW^2*Conjugate[USf[4, j3][s3, 
                  2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j3, o3}]]*USf[4, j1][
                 s2, 2]*USf[4, j3][s4, 1] + CB^2*MW^2*USf[4, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 
                   1] + 2*SW^2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 
                   2]))))/(CB^2*CW^2*MW^2*SW^2))) + 
      EL^2*((36*Mass[F[4, {j1, o1}]]*(dMf1[4, j2]*IndexDelta[j1, j4]*
            IndexDelta[j2, j3]*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (Conjugate[USf[4, j1][s1, 1]]*Conjugate[USf[4, j2][s3, 2]]*
              USf[4, j1][s4, 2]*USf[4, j2][s2, 1] + Conjugate[USf[4, j1][s1, 
                2]]*Conjugate[USf[4, j2][s3, 1]]*USf[4, j1][s4, 1]*
              USf[4, j2][s2, 2]) + dMf1[4, j3]*IndexDelta[j1, j2]*
            IndexDelta[j3, j4]*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (Conjugate[USf[4, j1][s1, 1]]*Conjugate[USf[4, j3][s3, 2]]*
              USf[4, j1][s2, 2]*USf[4, j3][s4, 1] + Conjugate[USf[4, j1][s1, 
                2]]*Conjugate[USf[4, j3][s3, 1]]*USf[4, j1][s2, 1]*
              USf[4, j3][s4, 2])))/(CB^2*MW^2*SW^2) + 
        (4*(CB^3*MW^4*(2*SW^3*(CW^2*dZe1 + dSW1*SW)*Conjugate[USf[4, j1][s1, 
                2]]*(IndexDelta[j1, j4]*IndexDelta[j2, j3]*IndexDelta[o1, o4]*
                IndexDelta[o2, o3]*USf[4, j1][s4, 2]*(Conjugate[USf[4, j2][
                    s3, 1]]*USf[4, j2][s2, 1] + 2*Conjugate[USf[4, j2][s3, 
                    2]]*USf[4, j2][s2, 2]) + IndexDelta[j1, j2]*IndexDelta[
                 j3, j4]*IndexDelta[o1, o2]*IndexDelta[o3, o4]*USf[4, j1][s2, 
                 2]*(Conjugate[USf[4, j3][s3, 1]]*USf[4, j3][s4, 1] + 
                 2*Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2])) + 
             Conjugate[USf[4, j1][s1, 1]]*(IndexDelta[j1, j4]*IndexDelta[j2, 
                 j3]*IndexDelta[o1, o4]*IndexDelta[o2, o3]*USf[4, j1][s4, 1]*
                ((dSW1*SW^2 + (-CW^2 - 8*CW^4)*(dSW1 - dZe1*SW))*Conjugate[
                   USf[4, j2][s3, 1]]*USf[4, j2][s2, 1] + 2*SW^3*(CW^2*dZe1 + 
                   dSW1*SW)*Conjugate[USf[4, j2][s3, 2]]*USf[4, j2][s2, 2]) + 
               IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o1, o2]*
                IndexDelta[o3, o4]*USf[4, j1][s2, 1]*((dSW1*SW^2 - 
                   (CW^2 + 8*CW^4)*(dSW1 - dZe1*SW))*Conjugate[USf[4, j3][s3, 
                    1]]*USf[4, j3][s4, 1] + 2*SW^3*(CW^2*dZe1 + dSW1*SW)*
                  Conjugate[USf[4, j3][s3, 2]]*USf[4, j3][s4, 2]))) - 
           CW^4*(18*dCB1*MW^2*SW*Mass[F[4, {j1, o1}]]*(IndexDelta[j1, j4]*
                IndexDelta[j2, j3]*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
                Mass[F[4, {j2, o2}]]*(Conjugate[USf[4, j1][s1, 1]]*
                  Conjugate[USf[4, j2][s3, 2]]*USf[4, j1][s4, 2]*USf[4, j2][
                   s2, 1] + Conjugate[USf[4, j1][s1, 2]]*Conjugate[
                   USf[4, j2][s3, 1]]*USf[4, j1][s4, 1]*USf[4, j2][s2, 2]) + 
               IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o1, o2]*
                IndexDelta[o3, o4]*Mass[F[4, {j3, o3}]]*
                (Conjugate[USf[4, j1][s1, 1]]*Conjugate[USf[4, j3][s3, 2]]*
                  USf[4, j1][s2, 2]*USf[4, j3][s4, 1] + Conjugate[USf[4, j1][
                    s1, 2]]*Conjugate[USf[4, j3][s3, 1]]*USf[4, j1][s2, 1]*
                  USf[4, j3][s4, 2])) - 9*CB*(MW^2*SW*dMf1[4, j1] - 
               (2*dSW1*MW^2 + (dMWsq1 - 2*dZe1*MW^2)*SW)*Mass[
                 F[4, {j1, o1}]])*(Conjugate[USf[4, j1][s1, 1]]*
                (Conjugate[USf[4, j2][s3, 2]]*IndexDelta[j1, j4]*IndexDelta[
                   j2, j3]*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
                  Mass[F[4, {j2, o2}]]*USf[4, j1][s4, 2]*USf[4, j2][s2, 1] + 
                 Conjugate[USf[4, j3][s3, 2]]*IndexDelta[j1, j2]*IndexDelta[
                   j3, j4]*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
                  Mass[F[4, {j3, o3}]]*USf[4, j1][s2, 2]*USf[4, j3][s4, 1]) + 
               Conjugate[USf[4, j1][s1, 2]]*(Conjugate[USf[4, j2][s3, 1]]*
                  IndexDelta[j1, j4]*IndexDelta[j2, j3]*IndexDelta[o1, o4]*
                  IndexDelta[o2, o3]*Mass[F[4, {j2, o2}]]*USf[4, j1][s4, 1]*
                  USf[4, j2][s2, 2] + Conjugate[USf[4, j3][s3, 1]]*
                  IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o1, o2]*
                  IndexDelta[o3, o4]*Mass[F[4, {j3, o3}]]*USf[4, j1][s2, 1]*
                  USf[4, j3][s4, 2])))))/(CB^3*CW^4*MW^4*SW^3)))}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], S[12, {s3, j3}], 
   -S[12, {s4, j4}]] == 
  {{((-I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o1, o2]*
      (2*Conjugate[USf[2, j3][s3, 2]]*(3*CW^2*Conjugate[USf[4, j1][s1, 1]]*
          Mass[F[2, {j3}]]*Mass[F[4, {j1, o1}]]*USf[2, j3][s4, 1]*
          USf[4, j1][s2, 2] + CB^2*MW^2*SW^2*USf[2, j3][s4, 2]*
          (Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 
           2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])) + 
       Conjugate[USf[2, j3][s3, 1]]*(6*CW^2*Conjugate[USf[4, j1][s1, 2]]*
          Mass[F[2, {j3}]]*Mass[F[4, {j1, o1}]]*USf[2, j3][s4, 2]*
          USf[4, j1][s2, 1] - CB^2*MW^2*USf[2, j3][s4, 1]*
          ((1 - 4*CW^2)*Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 
           2*SW^2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]))))/
     (CB^2*CW^2*MW^2*SW^2), ((I/24)*EL^2*IndexDelta[j1, j2]*
      IndexDelta[j3, j4]*IndexDelta[o1, o2]*
      (-(CB*CW^2*MW^2*SW*(2*(Conjugate[USf[2, j3][1, 2]]*dZSf1[1, s3, 2, 
              j3] + Conjugate[USf[2, j3][2, 2]]*dZSf1[2, s3, 2, j3])*
           (3*CW^2*Conjugate[USf[4, j1][s1, 1]]*Mass[F[2, {j3}]]*
             Mass[F[4, {j1, o1}]]*USf[2, j3][s4, 1]*USf[4, j1][s2, 2] + 
            CB^2*MW^2*SW^2*USf[2, j3][s4, 2]*(Conjugate[USf[4, j1][s1, 1]]*
               USf[4, j1][s2, 1] + 2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][
                s2, 2])) - (Conjugate[USf[2, j3][1, 1]]*dZSf1[1, s3, 2, j3] + 
            Conjugate[USf[2, j3][2, 1]]*dZSf1[2, s3, 2, j3])*
           (CB^2*(1 - 4*CW^2)*MW^2*Conjugate[USf[4, j1][s1, 1]]*
             USf[2, j3][s4, 1]*USf[4, j1][s2, 1] - 
            2*Conjugate[USf[4, j1][s1, 2]]*(3*CW^2*Mass[F[2, {j3}]]*Mass[
                F[4, {j1, o1}]]*USf[2, j3][s4, 2]*USf[4, j1][s2, 1] - 
              CB^2*MW^2*SW^2*USf[2, j3][s4, 1]*USf[4, j1][s2, 2])))) + 
       Conjugate[USf[2, j3][s3, 1]]*(CB^3*MW^4*Conjugate[USf[4, j1][s1, 1]]*
          (CW^2*(1 - 4*CW^2)*SW*USf[2, j3][s4, 1]*(dZbarSf1[1, s2, 4, j2]*
              USf[4, j1][1, 1] + dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 1]) + 
           (CW^2*(1 - 4*CW^2)*SW*(dZbarSf1[1, s4, 2, j4]*USf[2, j3][1, 1] + 
               dZbarSf1[2, s4, 2, j4]*USf[2, j3][2, 1]) + 
             4*(CW^2*dZe1*SW^3 + dSW1*SW^4 + 3*CW^4*(dSW1 - dZe1*SW))*
              USf[2, j3][s4, 1])*USf[4, j1][s2, 1]) - 
         2*Conjugate[USf[4, j1][s1, 2]]*(dZbarSf1[1, s2, 4, j2]*
            (3*CB*CW^4*MW^2*SW*Mass[F[2, {j3}]]*Mass[F[4, {j1, o1}]]*
              USf[2, j3][s4, 2]*USf[4, j1][1, 1] - CB^3*CW^2*MW^4*SW^3*
              USf[2, j3][s4, 1]*USf[4, j1][1, 2]) + dZbarSf1[2, s2, 4, j2]*
            (3*CB*CW^4*MW^2*SW*Mass[F[2, {j3}]]*Mass[F[4, {j1, o1}]]*
              USf[2, j3][s4, 2]*USf[4, j1][2, 1] - CB^3*CW^2*MW^4*SW^3*
              USf[2, j3][s4, 1]*USf[4, j1][2, 2]) - 
           CW^4*(12*(dCB1 - CB*dZe1)*MW^2*SW*Mass[F[2, {j3}]]*
              Mass[F[4, {j1, o1}]]*USf[2, j3][s4, 2] + 
             CB*(6*(2*dSW1*MW^2 + dMWsq1*SW)*Mass[F[2, {j3}]]*
                Mass[F[4, {j1, o1}]]*USf[2, j3][s4, 2] - MW^2*SW*
                (3*Mass[F[2, {j3}]]*Mass[F[4, {j1, o1}]]*(dZbarSf1[1, s4, 2, 
                     j4]*USf[2, j3][1, 2] + dZbarSf1[2, s4, 2, j4]*USf[2, j3][
                     2, 2]) + 6*(dMf1[4, j1]*Mass[F[2, {j3}]] + dMf1[2, j3]*
                    Mass[F[4, {j1, o1}]])*USf[2, j3][s4, 2])))*
            USf[4, j1][s2, 1] - CB^3*MW^4*SW^3*(CW^2*(dZbarSf1[1, s4, 2, j4]*
                USf[2, j3][1, 1] + dZbarSf1[2, s4, 2, j4]*USf[2, j3][2, 1]) + 
             4*(CW^2*dZe1 + dSW1*SW)*USf[2, j3][s4, 1])*USf[4, j1][s2, 2]) + 
         CB*CW^2*MW^2*SW*(CB^2*(1 - 4*CW^2)*MW^2*(Conjugate[USf[4, j1][1, 1]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 1]]*
              dZSf1[2, s1, 4, j1])*USf[2, j3][s4, 1]*USf[4, j1][s2, 1] - 
           2*(Conjugate[USf[4, j1][1, 2]]*dZSf1[1, s1, 4, j1] + 
             Conjugate[USf[4, j1][2, 2]]*dZSf1[2, s1, 4, j1])*
            (3*CW^2*Mass[F[2, {j3}]]*Mass[F[4, {j1, o1}]]*USf[2, j3][s4, 2]*
              USf[4, j1][s2, 1] - CB^2*MW^2*SW^2*USf[2, j3][s4, 1]*
              USf[4, j1][s2, 2]))) - 2*Conjugate[USf[2, j3][s3, 2]]*
        (Conjugate[USf[4, j1][s1, 1]]*(dZbarSf1[1, s2, 4, j2]*
            (CB^3*CW^2*MW^4*SW^3*USf[2, j3][s4, 2]*USf[4, j1][1, 1] + 
             3*CB*CW^4*MW^2*SW*Mass[F[2, {j3}]]*Mass[F[4, {j1, o1}]]*
              USf[2, j3][s4, 1]*USf[4, j1][1, 2]) + dZbarSf1[2, s2, 4, j2]*
            (CB^3*CW^2*MW^4*SW^3*USf[2, j3][s4, 2]*USf[4, j1][2, 1] + 
             3*CB*CW^4*MW^2*SW*Mass[F[2, {j3}]]*Mass[F[4, {j1, o1}]]*
              USf[2, j3][s4, 1]*USf[4, j1][2, 2]) + CB^3*MW^4*SW^3*
            (CW^2*(dZbarSf1[1, s4, 2, j4]*USf[2, j3][1, 2] + dZbarSf1[2, s4, 
                 2, j4]*USf[2, j3][2, 2]) + 4*(CW^2*dZe1 + dSW1*SW)*
              USf[2, j3][s4, 2])*USf[4, j1][s2, 1] - 
           CW^4*(12*(dCB1 - CB*dZe1)*MW^2*SW*Mass[F[2, {j3}]]*
              Mass[F[4, {j1, o1}]]*USf[2, j3][s4, 1] + 
             CB*(6*(2*dSW1*MW^2 + dMWsq1*SW)*Mass[F[2, {j3}]]*
                Mass[F[4, {j1, o1}]]*USf[2, j3][s4, 1] - MW^2*SW*
                (3*Mass[F[2, {j3}]]*Mass[F[4, {j1, o1}]]*(dZbarSf1[1, s4, 2, 
                     j4]*USf[2, j3][1, 1] + dZbarSf1[2, s4, 2, j4]*USf[2, j3][
                     2, 1]) + 6*(dMf1[4, j1]*Mass[F[2, {j3}]] + dMf1[2, j3]*
                    Mass[F[4, {j1, o1}]])*USf[2, j3][s4, 1])))*
            USf[4, j1][s2, 2]) + CB*MW^2*SW*(2*CB^2*MW^2*SW^2*
            Conjugate[USf[4, j1][s1, 2]]*(CW^2*USf[2, j3][s4, 2]*
              (dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 2] + dZbarSf1[2, s2, 4, 
                 j2]*USf[4, j1][2, 2]) + (CW^2*(dZbarSf1[1, s4, 2, j4]*
                  USf[2, j3][1, 2] + dZbarSf1[2, s4, 2, j4]*USf[2, j3][2, 
                   2]) + 4*(CW^2*dZe1 + dSW1*SW)*USf[2, j3][s4, 2])*
              USf[4, j1][s2, 2]) + CW^2*(2*CB^2*MW^2*SW^2*
              (Conjugate[USf[4, j1][1, 2]]*dZSf1[1, s1, 4, j1] + Conjugate[
                 USf[4, j1][2, 2]]*dZSf1[2, s1, 4, j1])*USf[2, j3][s4, 2]*
              USf[4, j1][s2, 2] + (Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s1, 
                 4, j1] + Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s1, 4, j1])*
              (CB^2*MW^2*SW^2*USf[2, j3][s4, 2]*USf[4, j1][s2, 1] + 3*CW^2*
                Mass[F[2, {j3}]]*Mass[F[4, {j1, o1}]]*USf[2, j3][s4, 1]*
                USf[4, j1][s2, 2]))))))/(CB^3*CW^4*MW^4*SW^3)}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], S[11, {j3}], -S[11, {j4}]] == 
  {{((I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o1, o2]*
      ((1 + 2*CW^2)*Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 
       2*SW^2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]))/(CW^2*SW^2), 
    ((I/24)*EL^2*IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o1, o2]*
      (Conjugate[USf[4, j1][s1, 1]]*(CW^2*(1 + 2*CW^2)*SW*
          (dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 1] + dZbarSf1[2, s2, 4, j2]*
            USf[4, j1][2, 1]) + (4*dSW1*SW^2 - (CW^2 + 2*CW^4)*
            (4*dSW1 - 4*dZe1*SW) + CW^2*(1 + 2*CW^2)*SW*
            (dZbarSf1[1, 1, 1, j4] + dZSf1[1, 1, 1, j3]))*
          USf[4, j1][s2, 1]) + SW*(2*SW^2*Conjugate[USf[4, j1][s1, 2]]*
          (CW^2*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 2] + 
             dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 2]) + 
           (4*(CW^2*dZe1 + dSW1*SW) + CW^2*(dZbarSf1[1, 1, 1, j4] + dZSf1[1, 
                1, 1, j3]))*USf[4, j1][s2, 2]) + 
         CW^2*((1 + 2*CW^2)*(Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s1, 4, 
               j1] + Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s1, 4, j1])*
            USf[4, j1][s2, 1] + 2*SW^2*(Conjugate[USf[4, j1][1, 2]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 2]]*
              dZSf1[2, s1, 4, j1])*USf[4, j1][s2, 2]))))/(CW^4*SW^3)}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], S[13, {s3, j3, o3}], 
   -S[13, {s4, j4, o4}]] == 
  {{IndexDelta[j1, j2]*IndexDelta[j3, j4]*((-I)*GS^2*SUNTSum[o2, o1, o4, o3]*
        (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
         Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2])*
        (Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] - 
         Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]) + 
       ((I/36)*EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
         (4*SW^2*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2]*
           (Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 
            2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]) - 
          Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1]*
           ((1 - 10*CW^2)*Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 
            2*SW^2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])))/
        (CW^2*SW^2)) - ((2*I)*EL^2*CKM[j4, j1]*Conjugate[CKM[j3, j2]]*
       IndexDelta[o1, o4]*IndexDelta[o2, o3]*
       (CB^2*Conjugate[USf[3, j3][s3, 2]]*Conjugate[USf[4, j1][s1, 1]]*
         Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]]*USf[3, j4][s4, 2]*
         USf[4, j2][s2, 1] + (Conjugate[USf[3, j3][s3, 1]]*USf[3, j4][s4, 1]*
          (MW^2*S2B^2*Conjugate[USf[4, j1][s1, 1]]*USf[4, j2][s2, 1] + 
           4*SB^2*Conjugate[USf[4, j1][s1, 2]]*Mass[F[4, {j1, o1}]]*
            Mass[F[4, {j2, o2}]]*USf[4, j2][s2, 2]))/4))/(MW^2*S2B^2*SW^2), 
    ((-I/9)*IndexDelta[j1, j2]*IndexDelta[j3, j4]*
       (36*dZgs1*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j3][s3, 1]]*
           USf[3, j3][s4, 1] - Conjugate[USf[3, j3][s3, 2]]*
           USf[3, j3][s4, 2])*(Conjugate[USf[4, j1][s1, 1]]*
           USf[4, j1][s2, 1] - Conjugate[USf[4, j1][s1, 2]]*
           USf[4, j1][s2, 2]) + (dSW1*EL^2*SW*IndexDelta[o1, o2]*
          IndexDelta[o3, o4]*(Conjugate[USf[3, j3][s3, 1]]*
            USf[3, j3][s4, 1] - 4*Conjugate[USf[3, j3][s3, 2]]*
            USf[3, j3][s4, 2])*(Conjugate[USf[4, j1][s1, 1]]*
            USf[4, j1][s2, 1] + 2*Conjugate[USf[4, j1][s1, 2]]*
            USf[4, j1][s2, 2]))/CW^4) + dZbarSf1[1, s2, 4, j2]*
       (IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         ((-I)*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j3][s4, 1] - Conjugate[USf[3, j3][s3, 2]]*
             USf[3, j3][s4, 2])*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][1, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][1, 2]) + ((I/36)*EL^2*IndexDelta[o1, o2]*
            IndexDelta[o3, o4]*(4*SW^2*Conjugate[USf[3, j3][s3, 2]]*
              USf[3, j3][s4, 2]*(Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][1, 
                 1] + 2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][1, 2]) - 
             Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1]*((1 - 10*CW^2)*
                Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][1, 1] + 2*SW^2*
                Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][1, 2])))/
           (CW^2*SW^2)) - ((2*I)*EL^2*CKM[j4, j1]*Conjugate[CKM[j3, j2]]*
          IndexDelta[o1, o4]*IndexDelta[o2, o3]*
          (CB^2*Conjugate[USf[3, j3][s3, 2]]*Conjugate[USf[4, j1][s1, 1]]*
            Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]]*USf[3, j4][s4, 2]*
            USf[4, j2][1, 1] + (Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j4][s4, 1]*(MW^2*S2B^2*Conjugate[USf[4, j1][s1, 1]]*
               USf[4, j2][1, 1] + 4*SB^2*Conjugate[USf[4, j1][s1, 2]]*Mass[
                F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j2][1, 2]))/4))/
         (MW^2*S2B^2*SW^2)) + dZbarSf1[2, s2, 4, j2]*
       (IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         ((-I)*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j3][s4, 1] - Conjugate[USf[3, j3][s3, 2]]*
             USf[3, j3][s4, 2])*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][2, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][2, 2]) + ((I/36)*EL^2*IndexDelta[o1, o2]*
            IndexDelta[o3, o4]*(4*SW^2*Conjugate[USf[3, j3][s3, 2]]*
              USf[3, j3][s4, 2]*(Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][2, 
                 1] + 2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][2, 2]) - 
             Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1]*((1 - 10*CW^2)*
                Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][2, 1] + 2*SW^2*
                Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][2, 2])))/
           (CW^2*SW^2)) - ((2*I)*EL^2*CKM[j4, j1]*Conjugate[CKM[j3, j2]]*
          IndexDelta[o1, o4]*IndexDelta[o2, o3]*
          (CB^2*Conjugate[USf[3, j3][s3, 2]]*Conjugate[USf[4, j1][s1, 1]]*
            Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]]*USf[3, j4][s4, 2]*
            USf[4, j2][2, 1] + (Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j4][s4, 1]*(MW^2*S2B^2*Conjugate[USf[4, j1][s1, 1]]*
               USf[4, j2][2, 1] + 4*SB^2*Conjugate[USf[4, j1][s1, 2]]*Mass[
                F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j2][2, 2]))/4))/
         (MW^2*S2B^2*SW^2)) + dZSf1[1, s1, 4, j1]*
       (IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         ((-I)*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j3][s4, 1] - Conjugate[USf[3, j3][s3, 2]]*
             USf[3, j3][s4, 2])*(Conjugate[USf[4, j1][1, 1]]*
             USf[4, j1][s2, 1] - Conjugate[USf[4, j1][1, 2]]*
             USf[4, j1][s2, 2]) + ((I/36)*EL^2*IndexDelta[o1, o2]*
            IndexDelta[o3, o4]*(4*SW^2*Conjugate[USf[3, j3][s3, 2]]*
              USf[3, j3][s4, 2]*(Conjugate[USf[4, j1][1, 1]]*USf[4, j1][s2, 
                 1] + 2*Conjugate[USf[4, j1][1, 2]]*USf[4, j1][s2, 2]) - 
             Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1]*((1 - 10*CW^2)*
                Conjugate[USf[4, j1][1, 1]]*USf[4, j1][s2, 1] + 2*SW^2*
                Conjugate[USf[4, j1][1, 2]]*USf[4, j1][s2, 2])))/
           (CW^2*SW^2)) - ((2*I)*EL^2*CKM[j4, j1]*Conjugate[CKM[j3, j2]]*
          IndexDelta[o1, o4]*IndexDelta[o2, o3]*
          (CB^2*Conjugate[USf[3, j3][s3, 2]]*Conjugate[USf[4, j1][1, 1]]*
            Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]]*USf[3, j4][s4, 2]*
            USf[4, j2][s2, 1] + (Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j4][s4, 1]*(MW^2*S2B^2*Conjugate[USf[4, j1][1, 1]]*
               USf[4, j2][s2, 1] + 4*SB^2*Conjugate[USf[4, j1][1, 2]]*Mass[
                F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j2][s2, 2]))/4))/
         (MW^2*S2B^2*SW^2)) + dZSf1[2, s1, 4, j1]*
       (IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         ((-I)*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j3][s4, 1] - Conjugate[USf[3, j3][s3, 2]]*
             USf[3, j3][s4, 2])*(Conjugate[USf[4, j1][2, 1]]*
             USf[4, j1][s2, 1] - Conjugate[USf[4, j1][2, 2]]*
             USf[4, j1][s2, 2]) + ((I/36)*EL^2*IndexDelta[o1, o2]*
            IndexDelta[o3, o4]*(4*SW^2*Conjugate[USf[3, j3][s3, 2]]*
              USf[3, j3][s4, 2]*(Conjugate[USf[4, j1][2, 1]]*USf[4, j1][s2, 
                 1] + 2*Conjugate[USf[4, j1][2, 2]]*USf[4, j1][s2, 2]) - 
             Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1]*((1 - 10*CW^2)*
                Conjugate[USf[4, j1][2, 1]]*USf[4, j1][s2, 1] + 2*SW^2*
                Conjugate[USf[4, j1][2, 2]]*USf[4, j1][s2, 2])))/
           (CW^2*SW^2)) - ((2*I)*EL^2*CKM[j4, j1]*Conjugate[CKM[j3, j2]]*
          IndexDelta[o1, o4]*IndexDelta[o2, o3]*
          (CB^2*Conjugate[USf[3, j3][s3, 2]]*Conjugate[USf[4, j1][2, 1]]*
            Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]]*USf[3, j4][s4, 2]*
            USf[4, j2][s2, 1] + (Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j4][s4, 1]*(MW^2*S2B^2*Conjugate[USf[4, j1][2, 1]]*
               USf[4, j2][s2, 1] + 4*SB^2*Conjugate[USf[4, j1][2, 2]]*Mass[
                F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j2][s2, 2]))/4))/
         (MW^2*S2B^2*SW^2)) + dZbarSf1[1, s4, 3, j4]*
       (IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         ((-I)*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j3][1, 1] - Conjugate[USf[3, j3][s3, 2]]*
             USf[3, j3][1, 2])*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][s2, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][s2, 2]) + ((I/36)*EL^2*IndexDelta[o1, o2]*
            IndexDelta[o3, o4]*(4*SW^2*Conjugate[USf[3, j3][s3, 2]]*
              USf[3, j3][1, 2]*(Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 
                 1] + 2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]) - 
             Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][1, 1]*((1 - 10*CW^2)*
                Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 2*SW^2*
                Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])))/
           (CW^2*SW^2)) - ((2*I)*EL^2*CKM[j4, j1]*Conjugate[CKM[j3, j2]]*
          IndexDelta[o1, o4]*IndexDelta[o2, o3]*
          (CB^2*Conjugate[USf[3, j3][s3, 2]]*Conjugate[USf[4, j1][s1, 1]]*
            Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]]*USf[3, j4][1, 2]*
            USf[4, j2][s2, 1] + (Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j4][1, 1]*(MW^2*S2B^2*Conjugate[USf[4, j1][s1, 1]]*
               USf[4, j2][s2, 1] + 4*SB^2*Conjugate[USf[4, j1][s1, 2]]*Mass[
                F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j2][s2, 2]))/4))/
         (MW^2*S2B^2*SW^2)) + dZbarSf1[2, s4, 3, j4]*
       (IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         ((-I)*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j3][2, 1] - Conjugate[USf[3, j3][s3, 2]]*
             USf[3, j3][2, 2])*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][s2, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][s2, 2]) + ((I/36)*EL^2*IndexDelta[o1, o2]*
            IndexDelta[o3, o4]*(4*SW^2*Conjugate[USf[3, j3][s3, 2]]*
              USf[3, j3][2, 2]*(Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 
                 1] + 2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]) - 
             Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][2, 1]*((1 - 10*CW^2)*
                Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 2*SW^2*
                Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])))/
           (CW^2*SW^2)) - ((2*I)*EL^2*CKM[j4, j1]*Conjugate[CKM[j3, j2]]*
          IndexDelta[o1, o4]*IndexDelta[o2, o3]*
          (CB^2*Conjugate[USf[3, j3][s3, 2]]*Conjugate[USf[4, j1][s1, 1]]*
            Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]]*USf[3, j4][2, 2]*
            USf[4, j2][s2, 1] + (Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j4][2, 1]*(MW^2*S2B^2*Conjugate[USf[4, j1][s1, 1]]*
               USf[4, j2][s2, 1] + 4*SB^2*Conjugate[USf[4, j1][s1, 2]]*Mass[
                F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j2][s2, 2]))/4))/
         (MW^2*S2B^2*SW^2)) + dZSf1[1, s3, 3, j3]*
       (IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         ((-I)*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j3][1, 1]]*
             USf[3, j3][s4, 1] - Conjugate[USf[3, j3][1, 2]]*
             USf[3, j3][s4, 2])*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][s2, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][s2, 2]) + ((I/36)*EL^2*IndexDelta[o1, o2]*
            IndexDelta[o3, o4]*(4*SW^2*Conjugate[USf[3, j3][1, 2]]*
              USf[3, j3][s4, 2]*(Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 
                 1] + 2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]) - 
             Conjugate[USf[3, j3][1, 1]]*USf[3, j3][s4, 1]*((1 - 10*CW^2)*
                Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 2*SW^2*
                Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])))/
           (CW^2*SW^2)) - ((2*I)*EL^2*CKM[j4, j1]*Conjugate[CKM[j3, j2]]*
          IndexDelta[o1, o4]*IndexDelta[o2, o3]*
          (CB^2*Conjugate[USf[3, j3][1, 2]]*Conjugate[USf[4, j1][s1, 1]]*
            Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]]*USf[3, j4][s4, 2]*
            USf[4, j2][s2, 1] + (Conjugate[USf[3, j3][1, 1]]*
             USf[3, j4][s4, 1]*(MW^2*S2B^2*Conjugate[USf[4, j1][s1, 1]]*
               USf[4, j2][s2, 1] + 4*SB^2*Conjugate[USf[4, j1][s1, 2]]*Mass[
                F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j2][s2, 2]))/4))/
         (MW^2*S2B^2*SW^2)) + dZSf1[2, s3, 3, j3]*
       (IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         ((-I)*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j3][2, 1]]*
             USf[3, j3][s4, 1] - Conjugate[USf[3, j3][2, 2]]*
             USf[3, j3][s4, 2])*(Conjugate[USf[4, j1][s1, 1]]*
             USf[4, j1][s2, 1] - Conjugate[USf[4, j1][s1, 2]]*
             USf[4, j1][s2, 2]) + ((I/36)*EL^2*IndexDelta[o1, o2]*
            IndexDelta[o3, o4]*(4*SW^2*Conjugate[USf[3, j3][2, 2]]*
              USf[3, j3][s4, 2]*(Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 
                 1] + 2*Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2]) - 
             Conjugate[USf[3, j3][2, 1]]*USf[3, j3][s4, 1]*((1 - 10*CW^2)*
                Conjugate[USf[4, j1][s1, 1]]*USf[4, j1][s2, 1] + 2*SW^2*
                Conjugate[USf[4, j1][s1, 2]]*USf[4, j1][s2, 2])))/
           (CW^2*SW^2)) - ((2*I)*EL^2*CKM[j4, j1]*Conjugate[CKM[j3, j2]]*
          IndexDelta[o1, o4]*IndexDelta[o2, o3]*
          (CB^2*Conjugate[USf[3, j3][2, 2]]*Conjugate[USf[4, j1][s1, 1]]*
            Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]]*USf[3, j4][s4, 2]*
            USf[4, j2][s2, 1] + (Conjugate[USf[3, j3][2, 1]]*
             USf[3, j4][s4, 1]*(MW^2*S2B^2*Conjugate[USf[4, j1][s1, 1]]*
               USf[4, j2][s2, 1] + 4*SB^2*Conjugate[USf[4, j1][s1, 2]]*Mass[
                F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j2][s2, 2]))/4))/
         (MW^2*S2B^2*SW^2)) + 
      EL^2*(((-I)*(4*CB^2*Conjugate[USf[3, j3][s3, 2]]*Conjugate[
             USf[4, j1][s1, 1]]*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (MW^2*S2B*SW*Conjugate[CKM[j3, j2]]*dCKM1[j4, j1]*
              Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]] + CKM[j4, j1]*
              (MW^2*S2B*SW*Conjugate[dCKM1[j3, j2]]*Mass[F[3, {j3, o3}]]*
                Mass[F[3, {j4, o4}]] + Conjugate[CKM[j3, j2]]*
                (MW^2*S2B*SW*dMf1[3, j4]*Mass[F[3, {j3, o3}]] + 
                 (MW^2*S2B*SW*dMf1[3, j3] - (dMWsq1*S2B*SW + MW^2*
                      (2*dSW1*S2B + 4*CB*dSB1*SW))*Mass[F[3, {j3, o3}]])*
                  Mass[F[3, {j4, o4}]])))*USf[3, j4][s4, 2]*
            USf[4, j2][s2, 1] + Conjugate[USf[3, j3][s3, 1]]*
            (MW^4*S2B^3*Conjugate[USf[4, j1][s1, 1]]*(dSW1*IndexDelta[j1, j2]*
                IndexDelta[j3, j4]*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
                USf[3, j3][s4, 1]*USf[4, j1][s2, 1] - (CKM[j4, j1]*
                  (2*dSW1*Conjugate[CKM[j3, j2]] - SW*Conjugate[dCKM1[j3, 
                      j2]]) - SW*Conjugate[CKM[j3, j2]]*dCKM1[j4, j1])*
                IndexDelta[o1, o4]*IndexDelta[o2, o3]*USf[3, j4][s4, 1]*
                USf[4, j2][s2, 1]) + 4*SB^2*Conjugate[USf[4, j1][s1, 2]]*
              IndexDelta[o1, o4]*IndexDelta[o2, o3]*(MW^2*S2B*SW*
                Conjugate[CKM[j3, j2]]*dCKM1[j4, j1]*Mass[F[4, {j1, o1}]]*
                Mass[F[4, {j2, o2}]] + CKM[j4, j1]*(MW^2*S2B*SW*Conjugate[
                   dCKM1[j3, j2]]*Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]] + 
                 Conjugate[CKM[j3, j2]]*(MW^2*S2B*SW*dMf1[4, j2]*
                    Mass[F[4, {j1, o1}]] + (MW^2*S2B*SW*dMf1[4, j1] - 
                     (4*dCB1*MW^2*SB*SW + S2B*(2*dSW1*MW^2 + dMWsq1*SW))*
                      Mass[F[4, {j1, o1}]])*Mass[F[4, {j2, o2}]])))*
              USf[3, j4][s4, 1]*USf[4, j2][s2, 2])))/(MW^4*S2B^3*SW^3) + 
        ((I/9)*dZe1*((IndexDelta[j1, j2]*IndexDelta[j3, j4]*
             IndexDelta[o1, o2]*IndexDelta[o3, o4]*(4*SW^2*Conjugate[
                USf[3, j3][s3, 2]]*USf[3, j3][s4, 2]*(Conjugate[USf[4, j1][
                   s1, 1]]*USf[4, j1][s2, 1] + 2*Conjugate[USf[4, j1][s1, 2]]*
                 USf[4, j1][s2, 2]) - Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][
                s4, 1]*((1 - 10*CW^2)*Conjugate[USf[4, j1][s1, 1]]*
                 USf[4, j1][s2, 1] + 2*SW^2*Conjugate[USf[4, j1][s1, 2]]*
                 USf[4, j1][s2, 2])))/CW^2 - (18*CKM[j4, j1]*
             Conjugate[CKM[j3, j2]]*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
             (4*CB^2*Conjugate[USf[3, j3][s3, 2]]*Conjugate[USf[4, j1][s1, 
                 1]]*Mass[F[3, {j3, o3}]]*Mass[F[3, {j4, o4}]]*USf[3, j4][s4, 
                2]*USf[4, j2][s2, 1] + Conjugate[USf[3, j3][s3, 1]]*
               USf[3, j4][s4, 1]*(MW^2*S2B^2*Conjugate[USf[4, j1][s1, 1]]*
                 USf[4, j2][s2, 1] + 4*SB^2*Conjugate[USf[4, j1][s1, 2]]*
                 Mass[F[4, {j1, o1}]]*Mass[F[4, {j2, o2}]]*USf[4, j2][s2, 
                  2])))/(MW^2*S2B^2)))/SW^2))/2}}, 
 C[S[14, {s1, j1, o1}], -S[12, {s2, j2}], S[11, {j3}], 
   -S[13, {s4, j4, o4}]] == 
  {{((-I/2)*EL^2*CKM[j4, j1]*IndexDelta[j2, j3]*IndexDelta[o1, o4]*
      (CB^2*MW^2*Conjugate[USf[4, j1][s1, 1]]*USf[2, j2][s2, 1] + 
       Conjugate[USf[4, j1][s1, 2]]*Mass[F[2, {j2}]]*Mass[F[4, {j1, o1}]]*
        USf[2, j2][s2, 2])*USf[3, j4][s4, 1])/(CB^2*MW^2*SW^2), 
    ((-I/4)*EL^2*IndexDelta[j2, j3]*IndexDelta[o1, o4]*
      (2*CB*MW^2*SW*dCKM1[j4, j1]*(CB^2*MW^2*Conjugate[USf[4, j1][s1, 1]]*
          USf[2, j2][s2, 1] + Conjugate[USf[4, j1][s1, 2]]*Mass[F[2, {j2}]]*
          Mass[F[4, {j1, o1}]]*USf[2, j2][s2, 2])*USf[3, j4][s4, 1] + 
       CKM[j4, j1]*(CB*MW^2*SW*(CB^2*MW^2*(Conjugate[USf[4, j1][1, 1]]*
              dZSf1[1, s1, 4, j1] + Conjugate[USf[4, j1][2, 1]]*
              dZSf1[2, s1, 4, j1])*USf[2, j2][s2, 1] + 
           (Conjugate[USf[4, j1][1, 2]]*dZSf1[1, s1, 4, j1] + 
             Conjugate[USf[4, j1][2, 2]]*dZSf1[2, s1, 4, j1])*
            Mass[F[2, {j2}]]*Mass[F[4, {j1, o1}]]*USf[2, j2][s2, 2])*
          USf[3, j4][s4, 1] + CB^3*MW^4*Conjugate[USf[4, j1][s1, 1]]*
          (SW*USf[2, j2][s2, 1]*(dZbarSf1[1, s4, 3, j4]*USf[3, j4][1, 1] + 
             dZbarSf1[2, s4, 3, j4]*USf[3, j4][2, 1]) + 
           (SW*(dZbarSf1[1, s2, 2, j2]*USf[2, j2][1, 1] + dZbarSf1[2, s2, 2, 
                 j2]*USf[2, j2][2, 1]) - (4*dSW1 - SW*(4*dZe1 + dZSf1[1, 1, 
                  1, j3]))*USf[2, j2][s2, 1])*USf[3, j4][s4, 1]) + 
         Conjugate[USf[4, j1][s1, 2]]*(CB*MW^2*SW*Mass[F[2, {j2}]]*
            Mass[F[4, {j1, o1}]]*USf[2, j2][s2, 2]*(dZbarSf1[1, s4, 3, j4]*
              USf[3, j4][1, 1] + dZbarSf1[2, s4, 3, j4]*USf[3, j4][2, 1]) + 
           (CB*MW^2*SW*Mass[F[2, {j2}]]*Mass[F[4, {j1, o1}]]*
              (dZbarSf1[1, s2, 2, j2]*USf[2, j2][1, 2] + dZbarSf1[2, s2, 2, 
                 j2]*USf[2, j2][2, 2]) + (2*CB*MW^2*SW*dMf1[4, j1]*
                Mass[F[2, {j2}]] + (2*CB*MW^2*SW*dMf1[2, j2] - 
                 (CB*(4*dSW1*MW^2 + 2*dMWsq1*SW) + MW^2*SW*(4*dCB1 - 
                     CB*(4*dZe1 + dZSf1[1, 1, 1, j3])))*Mass[F[2, {j2}]])*
                Mass[F[4, {j1, o1}]])*USf[2, j2][s2, 2])*USf[3, j4][s4, 
             1]))))/(CB^3*MW^4*SW^3)}}, 
 C[S[12, {s1, j1}], -S[14, {s2, j2, o2}], S[13, {s3, j3, o3}], 
   -S[11, {j4}]] == 
  {{((-I/2)*EL^2*Conjugate[CKM[j3, j2]]*Conjugate[USf[3, j3][s3, 1]]*
      IndexDelta[j1, j4]*IndexDelta[o2, o3]*
      (CB^2*MW^2*Conjugate[USf[2, j1][s1, 1]]*USf[4, j2][s2, 1] + 
       Conjugate[USf[2, j1][s1, 2]]*Mass[F[2, {j1}]]*Mass[F[4, {j2, o2}]]*
        USf[4, j2][s2, 2]))/(CB^2*MW^2*SW^2), 
    ((-I/4)*EL^2*IndexDelta[j1, j4]*IndexDelta[o2, o3]*
      (2*CB*MW^2*SW*Conjugate[dCKM1[j3, j2]]*Conjugate[USf[3, j3][s3, 1]]*
        (CB^2*MW^2*Conjugate[USf[2, j1][s1, 1]]*USf[4, j2][s2, 1] + 
         Conjugate[USf[2, j1][s1, 2]]*Mass[F[2, {j1}]]*Mass[F[4, {j2, o2}]]*
          USf[4, j2][s2, 2]) + Conjugate[CKM[j3, j2]]*
        (CB^3*MW^4*Conjugate[USf[2, j1][s1, 1]]*
          (SW*(Conjugate[USf[3, j3][1, 1]]*dZSf1[1, s3, 3, j3] + 
             Conjugate[USf[3, j3][2, 1]]*dZSf1[2, s3, 3, j3])*
            USf[4, j2][s2, 1] + Conjugate[USf[3, j3][s3, 1]]*
            (SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + dZbarSf1[2, s2, 4, 
                 j2]*USf[4, j2][2, 1]) - (4*dSW1 - SW*(4*dZe1 + dZbarSf1[1, 
                  1, 1, j4]))*USf[4, j2][s2, 1])) + 
         CB*MW^2*SW*Conjugate[USf[3, j3][s3, 1]]*
          (CB^2*MW^2*(Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s1, 2, j1] + 
             Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*
            USf[4, j2][s2, 1] + (Conjugate[USf[2, j1][1, 2]]*
              dZSf1[1, s1, 2, j1] + Conjugate[USf[2, j1][2, 2]]*
              dZSf1[2, s1, 2, j1])*Mass[F[2, {j1}]]*Mass[F[4, {j2, o2}]]*
            USf[4, j2][s2, 2]) + Conjugate[USf[2, j1][s1, 2]]*
          (CB*MW^2*SW*(Conjugate[USf[3, j3][1, 1]]*dZSf1[1, s3, 3, j3] + 
             Conjugate[USf[3, j3][2, 1]]*dZSf1[2, s3, 3, j3])*
            Mass[F[2, {j1}]]*Mass[F[4, {j2, o2}]]*USf[4, j2][s2, 2] + 
           Conjugate[USf[3, j3][s3, 1]]*(CB*MW^2*SW*Mass[F[2, {j1}]]*
              Mass[F[4, {j2, o2}]]*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 2] + 
               dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 2]) + 
             (2*CB*MW^2*SW*dMf1[4, j2]*Mass[F[2, {j1}]] + (2*CB*MW^2*SW*
                  dMf1[2, j1] - (CB*(4*dSW1*MW^2 + 2*dMWsq1*SW) + MW^2*SW*
                    (4*dCB1 - CB*(4*dZe1 + dZbarSf1[1, 1, 1, j4])))*
                  Mass[F[2, {j1}]])*Mass[F[4, {j2, o2}]])*USf[4, j2][s2, 
               2])))))/(CB^3*MW^4*SW^3)}}, 
 C[S[12, {s1, j1}], -S[12, {s2, j2}], S[12, {s3, j3}], -S[12, {s4, j4}]] == 
  {{((I/4)*EL^2*(2*Conjugate[USf[2, j1][s1, 2]]*
        (Conjugate[USf[2, j2][s3, 1]]*IndexDelta[j1, j4]*IndexDelta[j2, j3]*
          (CB^2*MW^2*SW^2*USf[2, j1][s4, 2]*USf[2, j2][s2, 1] - 
           CW^2*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*USf[2, j1][s4, 1]*
            USf[2, j2][s2, 2]) - CW^2*Conjugate[USf[2, j3][s3, 1]]*
          IndexDelta[j1, j2]*IndexDelta[j3, j4]*Mass[F[2, {j1}]]*
          Mass[F[2, {j3}]]*USf[2, j1][s2, 1]*USf[2, j3][s4, 2] - 
         CB^2*MW^2*SW^2*(2*Conjugate[USf[2, j2][s3, 2]]*IndexDelta[j1, j4]*
            IndexDelta[j2, j3]*USf[2, j1][s4, 2]*USf[2, j2][s2, 2] - 
           IndexDelta[j1, j2]*IndexDelta[j3, j4]*USf[2, j1][s2, 2]*
            (Conjugate[USf[2, j3][s3, 1]]*USf[2, j3][s4, 1] - 
             2*Conjugate[USf[2, j3][s3, 2]]*USf[2, j3][s4, 2]))) - 
       Conjugate[USf[2, j1][s1, 1]]*(IndexDelta[j1, j4]*IndexDelta[j2, j3]*
          (CB^2*MW^2*Conjugate[USf[2, j2][s3, 1]]*USf[2, j1][s4, 1]*
            USf[2, j2][s2, 1] + 2*Conjugate[USf[2, j2][s3, 2]]*
            (CW^2*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*USf[2, j1][s4, 2]*
              USf[2, j2][s2, 1] - CB^2*MW^2*SW^2*USf[2, j1][s4, 1]*
              USf[2, j2][s2, 2])) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
          (2*CW^2*Conjugate[USf[2, j3][s3, 2]]*Mass[F[2, {j1}]]*
            Mass[F[2, {j3}]]*USf[2, j1][s2, 2]*USf[2, j3][s4, 1] + 
           CB^2*MW^2*USf[2, j1][s2, 1]*(Conjugate[USf[2, j3][s3, 1]]*
              USf[2, j3][s4, 1] - 2*SW^2*Conjugate[USf[2, j3][s3, 2]]*
              USf[2, j3][s4, 2])))))/(CB^2*CW^2*MW^2*SW^2), 
    ((-I/8)*EL^2*(Conjugate[USf[2, j1][s1, 1]]*
        (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
          (SW*(CB^3*CW^2*MW^4*(Conjugate[USf[2, j2][1, 1]]*dZSf1[1, s3, 2, 
                 j3] + Conjugate[USf[2, j2][2, 1]]*dZSf1[2, s3, 2, j3])*
              USf[2, j1][s4, 1] + 2*CB*CW^4*MW^2*(Conjugate[USf[2, j2][1, 2]]*
                dZSf1[1, s3, 2, j3] + Conjugate[USf[2, j2][2, 2]]*
                dZSf1[2, s3, 2, j3])*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*
              USf[2, j1][s4, 2])*USf[2, j2][s2, 1] + CB^3*MW^4*
            (Conjugate[USf[2, j2][s3, 1]]*(CW^2*SW*USf[2, j1][s4, 1]*
                (dZbarSf1[1, s2, 2, j2]*USf[2, j2][1, 1] + dZbarSf1[2, s2, 2, 
                   j2]*USf[2, j2][2, 1]) + (CW^2*SW*(dZbarSf1[1, s4, 2, j4]*
                    USf[2, j1][1, 1] + dZbarSf1[2, s4, 2, j4]*USf[2, j1][2, 
                     1]) + 4*(dSW1*SW^2 - CW^2*(dSW1 - dZe1*SW))*USf[2, j1][
                   s4, 1])*USf[2, j2][s2, 1]) - 2*CW^2*SW^3*
              (Conjugate[USf[2, j2][1, 2]]*dZSf1[1, s3, 2, j3] + Conjugate[
                 USf[2, j2][2, 2]]*dZSf1[2, s3, 2, j3])*USf[2, j1][s4, 1]*
              USf[2, j2][s2, 2]) + 2*Conjugate[USf[2, j2][s3, 2]]*
            (dZbarSf1[1, s2, 2, j2]*(CB*CW^4*MW^2*SW*Mass[F[2, {j1}]]*
                Mass[F[2, {j2}]]*USf[2, j1][s4, 2]*USf[2, j2][1, 1] - CB^3*
                CW^2*MW^4*SW^3*USf[2, j1][s4, 1]*USf[2, j2][1, 2]) + 
             dZbarSf1[2, s2, 2, j2]*(CB*CW^4*MW^2*SW*Mass[F[2, {j1}]]*
                Mass[F[2, {j2}]]*USf[2, j1][s4, 2]*USf[2, j2][2, 1] - CB^3*
                CW^2*MW^4*SW^3*USf[2, j1][s4, 1]*USf[2, j2][2, 2]) - 
             CW^4*(4*(dCB1 - CB*dZe1)*MW^2*SW*Mass[F[2, {j1}]]*
                Mass[F[2, {j2}]]*USf[2, j1][s4, 2] - CB*
                (MW^2*SW*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*
                  (dZbarSf1[1, s4, 2, j4]*USf[2, j1][1, 2] + dZbarSf1[2, s4, 
                     2, j4]*USf[2, j1][2, 2]) + 2*(MW^2*SW*dMf1[2, j2]*
                    Mass[F[2, {j1}]] + (MW^2*SW*dMf1[2, j1] - (2*dSW1*MW^2 + 
                       dMWsq1*SW)*Mass[F[2, {j1}]])*Mass[F[2, {j2}]])*
                  USf[2, j1][s4, 2]))*USf[2, j2][s2, 1] - CB^3*MW^4*SW^3*
              (CW^2*(dZbarSf1[1, s4, 2, j4]*USf[2, j1][1, 1] + 
                 dZbarSf1[2, s4, 2, j4]*USf[2, j1][2, 1]) + 4*(CW^2*dZe1 + 
                 dSW1*SW)*USf[2, j1][s4, 1])*USf[2, j2][s2, 2])) + 
         IndexDelta[j1, j2]*IndexDelta[j3, j4]*
          (SW*(dZbarSf1[1, s4, 2, j4]*(CB^3*CW^2*MW^4*Conjugate[USf[2, j3][
                  s3, 1]]*USf[2, j1][s2, 1] + 2*CB*CW^4*MW^2*Conjugate[
                 USf[2, j3][s3, 2]]*Mass[F[2, {j1}]]*Mass[F[2, {j3}]]*
                USf[2, j1][s2, 2])*USf[2, j3][1, 1] - CB^3*CW^2*MW^4*
              USf[2, j1][s2, 1]*(2*SW^2*Conjugate[USf[2, j3][s3, 2]]*
                dZbarSf1[1, s4, 2, j4]*USf[2, j3][1, 2] - Conjugate[
                 USf[2, j3][s3, 1]]*dZbarSf1[2, s4, 2, j4]*USf[2, j3][2, 
                 1])) + Conjugate[USf[2, j3][s3, 2]]*dZbarSf1[2, s4, 2, j4]*
            (2*CB*CW^4*MW^2*SW*Mass[F[2, {j1}]]*Mass[F[2, {j3}]]*
              USf[2, j1][s2, 2]*USf[2, j3][2, 1] - 2*CB^3*CW^2*MW^4*SW^3*
              USf[2, j1][s2, 1]*USf[2, j3][2, 2]) + 
           (CB*CW^2*MW^2*SW*(CB^2*MW^2*Conjugate[USf[2, j3][s3, 1]]*
                (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, 
                   j2]*USf[2, j1][2, 1]) + 2*CW^2*Conjugate[USf[2, j3][s3, 
                  2]]*Mass[F[2, {j1}]]*Mass[F[2, {j3}]]*(dZbarSf1[1, s2, 2, 
                   j2]*USf[2, j1][1, 2] + dZbarSf1[2, s2, 2, j2]*USf[2, j1][
                   2, 2])) + CB^3*MW^4*(4*(dSW1*SW^2 - CW^2*(dSW1 - dZe1*SW))*
                Conjugate[USf[2, j3][s3, 1]] + CW^2*SW*
                (Conjugate[USf[2, j3][1, 1]]*dZSf1[1, s3, 2, j3] + 
                 Conjugate[USf[2, j3][2, 1]]*dZSf1[2, s3, 2, j3]))*
              USf[2, j1][s2, 1] - CW^4*(MW^2*SW*(8*(dCB1 - CB*dZe1)*
                  Conjugate[USf[2, j3][s3, 2]] - 2*CB*(Conjugate[USf[2, j3][
                      1, 2]]*dZSf1[1, s3, 2, j3] + Conjugate[USf[2, j3][2, 
                      2]]*dZSf1[2, s3, 2, j3]))*Mass[F[2, {j1}]]*
                Mass[F[2, {j3}]] - 4*CB*Conjugate[USf[2, j3][s3, 2]]*
                (MW^2*SW*dMf1[2, j3]*Mass[F[2, {j1}]] + 
                 (MW^2*SW*dMf1[2, j1] - (2*dSW1*MW^2 + dMWsq1*SW)*
                    Mass[F[2, {j1}]])*Mass[F[2, {j3}]]))*USf[2, j1][s2, 2])*
            USf[2, j3][s4, 1] - 2*CB^3*MW^4*SW^3*
            (CW^2*(Conjugate[USf[2, j3][1, 2]]*dZSf1[1, s3, 2, j3] + 
               Conjugate[USf[2, j3][2, 2]]*dZSf1[2, s3, 2, j3])*
              USf[2, j1][s2, 1] + Conjugate[USf[2, j3][s3, 2]]*
              (CW^2*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
                 dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) + 4*(CW^2*dZe1 + 
                 dSW1*SW)*USf[2, j1][s2, 1]))*USf[2, j3][s4, 2])) - 
       2*Conjugate[USf[2, j1][s1, 2]]*(IndexDelta[j1, j4]*IndexDelta[j2, j3]*
          (Conjugate[USf[2, j2][s3, 1]]*(dZbarSf1[1, s2, 2, j2]*
              (CB^3*CW^2*MW^4*SW^3*USf[2, j1][s4, 2]*USf[2, j2][1, 1] - CB*
                CW^4*MW^2*SW*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*USf[2, j1][s4, 
                 1]*USf[2, j2][1, 2]) + dZbarSf1[2, s2, 2, j2]*
              (CB^3*CW^2*MW^4*SW^3*USf[2, j1][s4, 2]*USf[2, j2][2, 1] - CB*
                CW^4*MW^2*SW*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*USf[2, j1][s4, 
                 1]*USf[2, j2][2, 2]) + CB^3*MW^4*SW^3*
              (CW^2*(dZbarSf1[1, s4, 2, j4]*USf[2, j1][1, 2] + 
                 dZbarSf1[2, s4, 2, j4]*USf[2, j1][2, 2]) + 4*(CW^2*dZe1 + 
                 dSW1*SW)*USf[2, j1][s4, 2])*USf[2, j2][s2, 1] + 
             CW^4*(4*(dCB1 - CB*dZe1)*MW^2*SW*Mass[F[2, {j1}]]*
                Mass[F[2, {j2}]]*USf[2, j1][s4, 1] + CB*(2*(2*dSW1*MW^2 + 
                   dMWsq1*SW)*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*USf[2, j1][
                   s4, 1] - MW^2*SW*(Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*
                    (dZbarSf1[1, s4, 2, j4]*USf[2, j1][1, 1] + dZbarSf1[2, 
                       s4, 2, j4]*USf[2, j1][2, 1]) + 2*(dMf1[2, j2]*
                      Mass[F[2, {j1}]] + dMf1[2, j1]*Mass[F[2, {j2}]])*
                    USf[2, j1][s4, 1])))*USf[2, j2][s2, 2]) - 
           2*CB^3*MW^4*SW^3*Conjugate[USf[2, j2][s3, 2]]*
            (CW^2*USf[2, j1][s4, 2]*(dZbarSf1[1, s2, 2, j2]*USf[2, j2][1, 
                 2] + dZbarSf1[2, s2, 2, j2]*USf[2, j2][2, 2]) + 
             (CW^2*(dZbarSf1[1, s4, 2, j4]*USf[2, j1][1, 2] + 
                 dZbarSf1[2, s4, 2, j4]*USf[2, j1][2, 2]) + 4*(CW^2*dZe1 + 
                 dSW1*SW)*USf[2, j1][s4, 2])*USf[2, j2][s2, 2]) - 
           CW^2*(2*CB^3*MW^4*SW^3*(Conjugate[USf[2, j2][1, 2]]*dZSf1[1, s3, 
                 2, j3] + Conjugate[USf[2, j2][2, 2]]*dZSf1[2, s3, 2, j3])*
              USf[2, j1][s4, 2]*USf[2, j2][s2, 2] - CB*MW^2*SW*
              (Conjugate[USf[2, j2][1, 1]]*dZSf1[1, s3, 2, j3] + Conjugate[
                 USf[2, j2][2, 1]]*dZSf1[2, s3, 2, j3])*(CB^2*MW^2*SW^2*
                USf[2, j1][s4, 2]*USf[2, j2][s2, 1] - CW^2*Mass[F[2, {j1}]]*
                Mass[F[2, {j2}]]*USf[2, j1][s4, 1]*USf[2, j2][s2, 2]))) + 
         IndexDelta[j1, j2]*IndexDelta[j3, j4]*(Conjugate[USf[2, j3][s3, 1]]*
            dZbarSf1[1, s4, 2, j4]*(CB^3*CW^2*MW^4*SW^3*USf[2, j1][s2, 2]*
              USf[2, j3][1, 1] - CB*CW^4*MW^2*SW*Mass[F[2, {j1}]]*
              Mass[F[2, {j3}]]*USf[2, j1][s2, 1]*USf[2, j3][1, 2]) - 
           dZbarSf1[2, s4, 2, j4]*(CB*CW^4*MW^2*SW*Conjugate[USf[2, j3][s3, 
                1]]*Mass[F[2, {j1}]]*Mass[F[2, {j3}]]*USf[2, j1][s2, 1] + 
             2*CB^3*CW^2*MW^4*SW^3*Conjugate[USf[2, j3][s3, 2]]*
              USf[2, j1][s2, 2])*USf[2, j3][2, 2] - CB^3*MW^4*SW^3*
            (CW^2*USf[2, j1][s2, 2]*(2*Conjugate[USf[2, j3][s3, 2]]*
                dZbarSf1[1, s4, 2, j4]*USf[2, j3][1, 2] - Conjugate[
                 USf[2, j3][s3, 1]]*dZbarSf1[2, s4, 2, j4]*USf[2, j3][2, 
                 1]) - ((4*dSW1*SW*Conjugate[USf[2, j3][s3, 1]] + 
                 CW^2*(Conjugate[USf[2, j3][1, 1]]*dZSf1[1, s3, 2, j3] + 
                   Conjugate[USf[2, j3][2, 1]]*dZSf1[2, s3, 2, j3]))*
                USf[2, j1][s2, 2] + CW^2*Conjugate[USf[2, j3][s3, 1]]*
                (dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 2] + dZbarSf1[2, s2, 2, 
                   j2]*USf[2, j1][2, 2] + 4*dZe1*USf[2, j1][s2, 2]))*
              USf[2, j3][s4, 1]) - (dZbarSf1[1, s2, 2, j2]*(CB*CW^4*MW^2*SW*
                Conjugate[USf[2, j3][s3, 1]]*Mass[F[2, {j1}]]*
                Mass[F[2, {j3}]]*USf[2, j1][1, 1] + 2*CB^3*CW^2*MW^4*SW^3*
                Conjugate[USf[2, j3][s3, 2]]*USf[2, j1][1, 2]) + 
             dZbarSf1[2, s2, 2, j2]*(CB*CW^4*MW^2*SW*Conjugate[USf[2, j3][s3, 
                  1]]*Mass[F[2, {j1}]]*Mass[F[2, {j3}]]*USf[2, j1][2, 1] + 2*
                CB^3*CW^2*MW^4*SW^3*Conjugate[USf[2, j3][s3, 2]]*
                USf[2, j1][2, 2]) - CW^4*(MW^2*SW*(4*(dCB1 - CB*dZe1)*
                  Conjugate[USf[2, j3][s3, 1]] - CB*(Conjugate[USf[2, j3][1, 
                      1]]*dZSf1[1, s3, 2, j3] + Conjugate[USf[2, j3][2, 1]]*
                    dZSf1[2, s3, 2, j3]))*Mass[F[2, {j1}]]*Mass[F[2, {j3}]] + 
               CB*Conjugate[USf[2, j3][s3, 1]]*(2*(2*dSW1*MW^2 + dMWsq1*SW)*
                  Mass[F[2, {j1}]]*Mass[F[2, {j3}]] - 2*MW^2*SW*
                  (dMf1[2, j3]*Mass[F[2, {j1}]] + dMf1[2, j1]*Mass[
                     F[2, {j3}]])))*USf[2, j1][s2, 1] + 2*CB^3*MW^4*SW^3*
              (4*(CW^2*dZe1 + dSW1*SW)*Conjugate[USf[2, j3][s3, 2]] + CW^2*
                (Conjugate[USf[2, j3][1, 2]]*dZSf1[1, s3, 2, j3] + 
                 Conjugate[USf[2, j3][2, 2]]*dZSf1[2, s3, 2, j3]))*
              USf[2, j1][s2, 2])*USf[2, j3][s4, 2])) - 
       CB*CW^2*MW^2*SW*(2*(Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s1, 2, j1] + 
           Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s1, 2, j1])*
          (Conjugate[USf[2, j2][s3, 1]]*IndexDelta[j1, j4]*IndexDelta[j2, j3]*
            (CB^2*MW^2*SW^2*USf[2, j1][s4, 2]*USf[2, j2][s2, 1] - 
             CW^2*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*USf[2, j1][s4, 1]*
              USf[2, j2][s2, 2]) - CW^2*Conjugate[USf[2, j3][s3, 1]]*
            IndexDelta[j1, j2]*IndexDelta[j3, j4]*Mass[F[2, {j1}]]*
            Mass[F[2, {j3}]]*USf[2, j1][s2, 1]*USf[2, j3][s4, 2] - 
           CB^2*MW^2*SW^2*(2*Conjugate[USf[2, j2][s3, 2]]*IndexDelta[j1, j4]*
              IndexDelta[j2, j3]*USf[2, j1][s4, 2]*USf[2, j2][s2, 2] - 
             IndexDelta[j1, j2]*IndexDelta[j3, j4]*USf[2, j1][s2, 2]*
              (Conjugate[USf[2, j3][s3, 1]]*USf[2, j3][s4, 1] - 2*
                Conjugate[USf[2, j3][s3, 2]]*USf[2, j3][s4, 2]))) - 
         (Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s1, 2, j1] + 
           Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*
          (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
            (2*CW^2*Conjugate[USf[2, j2][s3, 2]]*Mass[F[2, {j1}]]*
              Mass[F[2, {j2}]]*USf[2, j1][s4, 2]*USf[2, j2][s2, 1] + 
             CB^2*MW^2*USf[2, j1][s4, 1]*(Conjugate[USf[2, j2][s3, 1]]*
                USf[2, j2][s2, 1] - 2*SW^2*Conjugate[USf[2, j2][s3, 2]]*
                USf[2, j2][s2, 2])) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
            (2*CW^2*Conjugate[USf[2, j3][s3, 2]]*Mass[F[2, {j1}]]*
              Mass[F[2, {j3}]]*USf[2, j1][s2, 2]*USf[2, j3][s4, 1] + 
             CB^2*MW^2*USf[2, j1][s2, 1]*(Conjugate[USf[2, j3][s3, 1]]*
                USf[2, j3][s4, 1] - 2*SW^2*Conjugate[USf[2, j3][s3, 2]]*
                USf[2, j3][s4, 2]))))))/(CB^3*CW^4*MW^4*SW^3)}}, 
 C[S[12, {s1, j1}], -S[12, {s2, j2}], S[11, {j3}], -S[11, {j4}]] == 
  {{((-I/4)*EL^2*((IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         ((1 - 2*CW^2)*Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][s2, 1] - 
          2*SW^2*Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 2]))/CW^2 + 
       2*IndexDelta[j1, j4]*IndexDelta[j2, j3]*
        (Conjugate[USf[2, j1][s1, 1]]*USf[2, j2][s2, 1] + 
         (Conjugate[USf[2, j1][s1, 2]]*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*
           USf[2, j2][s2, 2])/(CB^2*MW^2))))/SW^2, 
    ((-I/8)*EL^2*(4*dSW1*((SW^4*IndexDelta[j1, j2]*IndexDelta[j3, j4]*
           (Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][s2, 1] - 
            2*Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 2]))/CW^4 + 
         Conjugate[USf[2, j1][s1, 1]]*(IndexDelta[j1, j2]*IndexDelta[j3, j4]*
            USf[2, j1][s2, 1] - 2*IndexDelta[j1, j4]*IndexDelta[j2, j3]*
            USf[2, j2][s2, 1]) - (2*Conjugate[USf[2, j1][s1, 2]]*
           IndexDelta[j1, j4]*IndexDelta[j2, j3]*Mass[F[2, {j1}]]*
           Mass[F[2, {j2}]]*USf[2, j2][s2, 2])/(CB^2*MW^2)) + 
       SW*(dZSf1[1, s1, 2, j1]*((IndexDelta[j1, j2]*IndexDelta[j3, j4]*
             ((1 - 2*CW^2)*Conjugate[USf[2, j1][1, 1]]*USf[2, j1][s2, 1] - 
              2*SW^2*Conjugate[USf[2, j1][1, 2]]*USf[2, j1][s2, 2]))/CW^2 + 
           2*IndexDelta[j1, j4]*IndexDelta[j2, j3]*
            (Conjugate[USf[2, j1][1, 1]]*USf[2, j2][s2, 1] + 
             (Conjugate[USf[2, j1][1, 2]]*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*
               USf[2, j2][s2, 2])/(CB^2*MW^2))) + dZSf1[2, s1, 2, j1]*
          ((IndexDelta[j1, j2]*IndexDelta[j3, j4]*((1 - 2*CW^2)*Conjugate[
                USf[2, j1][2, 1]]*USf[2, j1][s2, 1] - 2*SW^2*Conjugate[
                USf[2, j1][2, 2]]*USf[2, j1][s2, 2]))/CW^2 + 
           2*IndexDelta[j1, j4]*IndexDelta[j2, j3]*
            (Conjugate[USf[2, j1][2, 1]]*USf[2, j2][s2, 1] + 
             (Conjugate[USf[2, j1][2, 2]]*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*
               USf[2, j2][s2, 2])/(CB^2*MW^2))) + 
         (4*dZe1 + dZbarSf1[1, 1, 1, j4] + dZSf1[1, 1, 1, j3])*
          ((IndexDelta[j1, j2]*IndexDelta[j3, j4]*((1 - 2*CW^2)*Conjugate[
                USf[2, j1][s1, 1]]*USf[2, j1][s2, 1] - 2*SW^2*Conjugate[
                USf[2, j1][s1, 2]]*USf[2, j1][s2, 2]))/CW^2 + 
           2*IndexDelta[j1, j4]*IndexDelta[j2, j3]*
            (Conjugate[USf[2, j1][s1, 1]]*USf[2, j2][s2, 1] + 
             (Conjugate[USf[2, j1][s1, 2]]*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*
               USf[2, j2][s2, 2])/(CB^2*MW^2))) - 
         (CB^3*MW^4*(2*SW^2*Conjugate[USf[2, j1][s1, 2]]*IndexDelta[j1, j2]*
              IndexDelta[j3, j4]*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 2] + 
               dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 2]) - 
             Conjugate[USf[2, j1][s1, 1]]*(dZbarSf1[1, s2, 2, j2]*
                ((1 - 2*CW^2)*IndexDelta[j1, j2]*IndexDelta[j3, j4]*
                  USf[2, j1][1, 1] + 2*CW^2*IndexDelta[j1, j4]*IndexDelta[j2, 
                   j3]*USf[2, j2][1, 1]) + dZbarSf1[2, s2, 2, j2]*
                ((1 - 2*CW^2)*IndexDelta[j1, j2]*IndexDelta[j3, j4]*
                  USf[2, j1][2, 1] + 2*CW^2*IndexDelta[j1, j4]*IndexDelta[j2, 
                   j3]*USf[2, j2][2, 1]))) + CW^2*Conjugate[
             USf[2, j1][s1, 2]]*IndexDelta[j1, j4]*IndexDelta[j2, j3]*
            (8*dCB1*MW^2*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*USf[2, j2][s2, 
               2] - 2*CB*(MW^2*Mass[F[2, {j1}]]*Mass[F[2, {j2}]]*
                (dZbarSf1[1, s2, 2, j2]*USf[2, j2][1, 2] + dZbarSf1[2, s2, 2, 
                   j2]*USf[2, j2][2, 2]) + 2*(MW^2*dMf1[2, j2]*
                  Mass[F[2, {j1}]] + (MW^2*dMf1[2, j1] - dMWsq1*Mass[
                     F[2, {j1}]])*Mass[F[2, {j2}]])*USf[2, j2][s2, 2])))/
          (CB^3*CW^2*MW^4))))/SW^3}}, 
 C[S[12, {s1, j1}], -S[12, {s2, j2}], S[13, {s3, j3, o3}], 
   -S[13, {s4, j4, o4}]] == 
  {{((-I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o3, o4]*
      (2*SW^2*Conjugate[USf[2, j1][s1, 2]]*USf[2, j1][s2, 2]*
        (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
         4*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2]) - 
       Conjugate[USf[2, j1][s1, 1]]*USf[2, j1][s2, 1]*
        ((1 + 2*CW^2)*Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
         4*SW^2*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2])))/
     (CW^2*SW^2), ((I/24)*EL^2*IndexDelta[j1, j2]*IndexDelta[j3, j4]*
      IndexDelta[o3, o4]*(Conjugate[USf[2, j1][s1, 1]]*
        (Conjugate[USf[3, j3][s3, 1]]*(CW^2*(1 + 2*CW^2)*SW*USf[2, j1][s2, 1]*
            (dZbarSf1[1, s4, 3, j4]*USf[3, j3][1, 1] + dZbarSf1[2, s4, 3, j4]*
              USf[3, j3][2, 1]) + (CW^2*(1 + 2*CW^2)*SW*(dZbarSf1[1, s2, 2, 
                 j2]*USf[2, j1][1, 1] + dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 
                 1]) + 4*(dSW1*SW^2 - (CW^2 + 2*CW^4)*(dSW1 - dZe1*SW))*
              USf[2, j1][s2, 1])*USf[3, j3][s4, 1]) + 
         SW*(CW^2*USf[2, j1][s2, 1]*((1 + 2*CW^2)*(Conjugate[USf[3, j3][1, 
                  1]]*dZSf1[1, s3, 3, j3] + Conjugate[USf[3, j3][2, 1]]*
                dZSf1[2, s3, 3, j3])*USf[3, j3][s4, 1] - 
             4*SW^2*(Conjugate[USf[3, j3][1, 2]]*dZSf1[1, s3, 3, j3] + 
               Conjugate[USf[3, j3][2, 2]]*dZSf1[2, s3, 3, j3])*
              USf[3, j3][s4, 2]) - 4*SW^2*Conjugate[USf[3, j3][s3, 2]]*
            (CW^2*USf[2, j1][s2, 1]*(dZbarSf1[1, s4, 3, j4]*USf[3, j3][1, 
                 2] + dZbarSf1[2, s4, 3, j4]*USf[3, j3][2, 2]) + 
             (CW^2*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 1] + 
                 dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 1]) + 4*(CW^2*dZe1 + 
                 dSW1*SW)*USf[2, j1][s2, 1])*USf[3, j3][s4, 2]))) - 
       SW*(CW^2*(2*SW^2*(Conjugate[USf[2, j1][1, 2]]*dZSf1[1, s1, 2, j1] + 
             Conjugate[USf[2, j1][2, 2]]*dZSf1[2, s1, 2, j1])*
            USf[2, j1][s2, 2]*(Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 
               1] - 4*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2]) - 
           (Conjugate[USf[2, j1][1, 1]]*dZSf1[1, s1, 2, j1] + 
             Conjugate[USf[2, j1][2, 1]]*dZSf1[2, s1, 2, j1])*
            USf[2, j1][s2, 1]*((1 + 2*CW^2)*Conjugate[USf[3, j3][s3, 1]]*
              USf[3, j3][s4, 1] - 4*SW^2*Conjugate[USf[3, j3][s3, 2]]*
              USf[3, j3][s4, 2])) + 2*SW^2*Conjugate[USf[2, j1][s1, 2]]*
          (Conjugate[USf[3, j3][s3, 1]]*(CW^2*USf[2, j1][s2, 2]*
              (dZbarSf1[1, s4, 3, j4]*USf[3, j3][1, 1] + dZbarSf1[2, s4, 3, 
                 j4]*USf[3, j3][2, 1]) + (CW^2*(dZbarSf1[1, s2, 2, j2]*
                  USf[2, j1][1, 2] + dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 
                   2]) + 4*(CW^2*dZe1 + dSW1*SW)*USf[2, j1][s2, 2])*
              USf[3, j3][s4, 1]) + CW^2*USf[2, j1][s2, 2]*
            ((Conjugate[USf[3, j3][1, 1]]*dZSf1[1, s3, 3, j3] + Conjugate[
                 USf[3, j3][2, 1]]*dZSf1[2, s3, 3, j3])*USf[3, j3][s4, 1] - 
             4*(Conjugate[USf[3, j3][1, 2]]*dZSf1[1, s3, 3, j3] + 
               Conjugate[USf[3, j3][2, 2]]*dZSf1[2, s3, 3, j3])*
              USf[3, j3][s4, 2]) - 4*Conjugate[USf[3, j3][s3, 2]]*
            (CW^2*USf[2, j1][s2, 2]*(dZbarSf1[1, s4, 3, j4]*USf[3, j3][1, 
                 2] + dZbarSf1[2, s4, 3, j4]*USf[3, j3][2, 2]) + 
             (CW^2*(dZbarSf1[1, s2, 2, j2]*USf[2, j1][1, 2] + 
                 dZbarSf1[2, s2, 2, j2]*USf[2, j1][2, 2]) + 4*(CW^2*dZe1 + 
                 dSW1*SW)*USf[2, j1][s2, 2])*USf[3, j3][s4, 2])))))/
     (CW^4*SW^3)}}, C[S[11, {j1}], -S[11, {j2}], S[11, {j3}], 
   -S[11, {j4}]] == 
  {{((-I/4)*EL^2*(IndexDelta[j1, j4]*IndexDelta[j2, j3] + 
       IndexDelta[j1, j2]*IndexDelta[j3, j4]))/(CW^2*SW^2), 
    ((-I/8)*EL^2*(4*dSW1*SW^2 - CW^2*(4*(dSW1 - dZe1*SW) - 
         SW*(dZbarSf1[1, 1, 1, j2] + dZbarSf1[1, 1, 1, j4] + 
           dZSf1[1, 1, 1, j1] + dZSf1[1, 1, 1, j3])))*
      (IndexDelta[j1, j4]*IndexDelta[j2, j3] + IndexDelta[j1, j2]*
        IndexDelta[j3, j4]))/(CW^4*SW^3)}}, 
 C[S[11, {j1}], -S[11, {j2}], S[13, {s3, j3, o3}], -S[13, {s4, j4, o4}]] == 
  {{((I/12)*EL^2*IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o3, o4]*
      ((1 - 4*CW^2)*Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
       4*SW^2*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2]))/(CW^2*SW^2), 
    ((I/24)*EL^2*IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o3, o4]*
      (Conjugate[USf[3, j3][s3, 1]]*(CW^2*(1 - 4*CW^2)*SW*
          (dZbarSf1[1, s4, 3, j4]*USf[3, j3][1, 1] + dZbarSf1[2, s4, 3, j4]*
            USf[3, j3][2, 1]) + (4*(CW^2*dZe1*SW^3 + dSW1*SW^4 + 
             3*CW^4*(dSW1 - dZe1*SW)) - (3*CW^4*SW - CW^2*SW^3)*
            (dZbarSf1[1, 1, 1, j2] + dZSf1[1, 1, 1, j1]))*
          USf[3, j3][s4, 1]) - SW*(4*SW^2*Conjugate[USf[3, j3][s3, 2]]*
          (CW^2*(dZbarSf1[1, s4, 3, j4]*USf[3, j3][1, 2] + 
             dZbarSf1[2, s4, 3, j4]*USf[3, j3][2, 2]) + 
           (4*(CW^2*dZe1 + dSW1*SW) + CW^2*(dZbarSf1[1, 1, 1, j2] + dZSf1[1, 
                1, 1, j1]))*USf[3, j3][s4, 2]) - 
         CW^2*((1 - 4*CW^2)*(Conjugate[USf[3, j3][1, 1]]*dZSf1[1, s3, 3, 
               j3] + Conjugate[USf[3, j3][2, 1]]*dZSf1[2, s3, 3, j3])*
            USf[3, j3][s4, 1] - 4*SW^2*(Conjugate[USf[3, j3][1, 2]]*
              dZSf1[1, s3, 3, j3] + Conjugate[USf[3, j3][2, 2]]*
              dZSf1[2, s3, 3, j3])*USf[3, j3][s4, 2]))))/(CW^4*SW^3)}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], S[13, {s3, j3, o3}], 
   -S[13, {s4, j4, o4}]] == 
  {{(-I/36)*(IndexDelta[j1, j4]*IndexDelta[j2, j3]*
       (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[3, j1][s1, 1]]*
           USf[3, j1][s4, 1] - Conjugate[USf[3, j1][s1, 2]]*
           USf[3, j1][s4, 2])*(Conjugate[USf[3, j2][s3, 1]]*
           USf[3, j2][s2, 1] - Conjugate[USf[3, j2][s3, 2]]*
           USf[3, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
          (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j2][s3, 
                1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*
              USf[3, j1][s4, 1]*USf[3, j2][s2, 2] - 2*MW^2*SB^2*SW^2*
              USf[3, j1][s4, 2]*(Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 
                 1] - 4*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 2])) + 
           Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j2][s3, 2]]*
              Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][s4, 2]*
              USf[3, j2][s2, 1] + MW^2*SB^2*USf[3, j1][s4, 1]*
              ((1 + 8*CW^2)*Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 1] - 
               4*SW^2*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 2]))))/
         (CW^2*MW^2*SB^2*SW^2)) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
       (36*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j1][s1, 1]]*
           USf[3, j1][s2, 1] - Conjugate[USf[3, j1][s1, 2]]*
           USf[3, j1][s2, 2])*(Conjugate[USf[3, j3][s3, 1]]*
           USf[3, j3][s4, 1] - Conjugate[USf[3, j3][s3, 2]]*
           USf[3, j3][s4, 2]) + (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
          (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j3][s3, 
                1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*
              USf[3, j1][s2, 1]*USf[3, j3][s4, 2] - 2*MW^2*SB^2*SW^2*
              USf[3, j1][s2, 2]*(Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 
                 1] - 4*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2])) + 
           Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j3][s3, 2]]*
              Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][s2, 2]*
              USf[3, j3][s4, 1] + MW^2*SB^2*USf[3, j1][s2, 1]*
              ((1 + 8*CW^2)*Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
               4*SW^2*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2]))))/
         (CW^2*MW^2*SB^2*SW^2))), 
    (-I/72)*(dZbarSf1[1, s4, 3, j4]*(IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[3, j1][s1, 1]]*
             USf[3, j1][1, 1] - Conjugate[USf[3, j1][s1, 2]]*
             USf[3, j1][1, 2])*(Conjugate[USf[3, j2][s3, 1]]*
             USf[3, j2][s2, 1] - Conjugate[USf[3, j2][s3, 2]]*
             USf[3, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j2][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][1, 
                 1]*USf[3, j2][s2, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][1, 2]*
                (Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 1] - 
                 4*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j2][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][1, 
                 2]*USf[3, j2][s2, 1] + MW^2*SB^2*USf[3, j1][1, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 
                   1] - 4*SW^2*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 
                   2]))))/(CW^2*MW^2*SB^2*SW^2)) + IndexDelta[j1, j2]*
         IndexDelta[j3, j4]*(36*GS^2*SUNTSum[o2, o1, o4, o3]*
           (Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 1] - 
            Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 2])*
           (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][1, 1] - 
            Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][1, 2]) + 
          (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j3][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 1]*USf[3, j3][1, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s2, 2]*
                (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][1, 1] - 
                 4*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][1, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j3][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 2]*USf[3, j3][1, 1] + MW^2*SB^2*USf[3, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][1, 1] - 
                 4*SW^2*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][1, 2]))))/
           (CW^2*MW^2*SB^2*SW^2))) + dZbarSf1[2, s4, 3, j4]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[3, j1][s1, 1]]*
             USf[3, j1][2, 1] - Conjugate[USf[3, j1][s1, 2]]*
             USf[3, j1][2, 2])*(Conjugate[USf[3, j2][s3, 1]]*
             USf[3, j2][s2, 1] - Conjugate[USf[3, j2][s3, 2]]*
             USf[3, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j2][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][2, 
                 1]*USf[3, j2][s2, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][2, 2]*
                (Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 1] - 
                 4*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j2][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][2, 
                 2]*USf[3, j2][s2, 1] + MW^2*SB^2*USf[3, j1][2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 
                   1] - 4*SW^2*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 
                   2]))))/(CW^2*MW^2*SB^2*SW^2)) + IndexDelta[j1, j2]*
         IndexDelta[j3, j4]*(36*GS^2*SUNTSum[o2, o1, o4, o3]*
           (Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 1] - 
            Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 2])*
           (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][2, 1] - 
            Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][2, 2]) + 
          (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j3][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 1]*USf[3, j3][2, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s2, 2]*
                (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][2, 1] - 
                 4*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][2, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j3][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 2]*USf[3, j3][2, 1] + MW^2*SB^2*USf[3, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][2, 1] - 
                 4*SW^2*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][2, 2]))))/
           (CW^2*MW^2*SB^2*SW^2))) + 144*dZgs1*GS^2*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*SUNTSum[o2, o3, o4, o1]*
         (Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s4, 1] - 
          Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s4, 2])*
         (Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 1] - 
          Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 2]) + 
        IndexDelta[j1, j2]*IndexDelta[j3, j4]*SUNTSum[o2, o1, o4, o3]*
         (Conjugate[USf[3, j1][s1, 1]]*USf[3, j1][s2, 1] - 
          Conjugate[USf[3, j1][s1, 2]]*USf[3, j1][s2, 2])*
         (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
          Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2])) + 
      dZSf1[1, s3, 3, j3]*(IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[3, j1][s1, 1]]*
             USf[3, j1][s4, 1] - Conjugate[USf[3, j1][s1, 2]]*
             USf[3, j1][s4, 2])*(Conjugate[USf[3, j2][1, 1]]*
             USf[3, j2][s2, 1] - Conjugate[USf[3, j2][1, 2]]*
             USf[3, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j2][1, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 1]*USf[3, j2][s2, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s4, 
                 2]*(Conjugate[USf[3, j2][1, 1]]*USf[3, j2][s2, 1] - 
                 4*Conjugate[USf[3, j2][1, 2]]*USf[3, j2][s2, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j2][1, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 2]*USf[3, j2][s2, 1] + MW^2*SB^2*USf[3, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j2][1, 1]]*USf[3, j2][s2, 1] - 
                 4*SW^2*Conjugate[USf[3, j2][1, 2]]*USf[3, j2][s2, 2]))))/
           (CW^2*MW^2*SB^2*SW^2)) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         (36*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j1][s1, 1]]*
             USf[3, j1][s2, 1] - Conjugate[USf[3, j1][s1, 2]]*
             USf[3, j1][s2, 2])*(Conjugate[USf[3, j3][1, 1]]*
             USf[3, j3][s4, 1] - Conjugate[USf[3, j3][1, 2]]*
             USf[3, j3][s4, 2]) + (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j3][1, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 1]*USf[3, j3][s4, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s2, 
                 2]*(Conjugate[USf[3, j3][1, 1]]*USf[3, j3][s4, 1] - 
                 4*Conjugate[USf[3, j3][1, 2]]*USf[3, j3][s4, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j3][1, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 2]*USf[3, j3][s4, 1] + MW^2*SB^2*USf[3, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j3][1, 1]]*USf[3, j3][s4, 1] - 
                 4*SW^2*Conjugate[USf[3, j3][1, 2]]*USf[3, j3][s4, 2]))))/
           (CW^2*MW^2*SB^2*SW^2))) + dZSf1[2, s3, 3, j3]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[3, j1][s1, 1]]*
             USf[3, j1][s4, 1] - Conjugate[USf[3, j1][s1, 2]]*
             USf[3, j1][s4, 2])*(Conjugate[USf[3, j2][2, 1]]*
             USf[3, j2][s2, 1] - Conjugate[USf[3, j2][2, 2]]*
             USf[3, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j2][2, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 1]*USf[3, j2][s2, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s4, 
                 2]*(Conjugate[USf[3, j2][2, 1]]*USf[3, j2][s2, 1] - 
                 4*Conjugate[USf[3, j2][2, 2]]*USf[3, j2][s2, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j2][2, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 2]*USf[3, j2][s2, 1] + MW^2*SB^2*USf[3, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j2][2, 1]]*USf[3, j2][s2, 1] - 
                 4*SW^2*Conjugate[USf[3, j2][2, 2]]*USf[3, j2][s2, 2]))))/
           (CW^2*MW^2*SB^2*SW^2)) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         (36*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j1][s1, 1]]*
             USf[3, j1][s2, 1] - Conjugate[USf[3, j1][s1, 2]]*
             USf[3, j1][s2, 2])*(Conjugate[USf[3, j3][2, 1]]*
             USf[3, j3][s4, 1] - Conjugate[USf[3, j3][2, 2]]*
             USf[3, j3][s4, 2]) + (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j3][2, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 1]*USf[3, j3][s4, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s2, 
                 2]*(Conjugate[USf[3, j3][2, 1]]*USf[3, j3][s4, 1] - 
                 4*Conjugate[USf[3, j3][2, 2]]*USf[3, j3][s4, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j3][2, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 2]*USf[3, j3][s4, 1] + MW^2*SB^2*USf[3, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j3][2, 1]]*USf[3, j3][s4, 1] - 
                 4*SW^2*Conjugate[USf[3, j3][2, 2]]*USf[3, j3][s4, 2]))))/
           (CW^2*MW^2*SB^2*SW^2))) + dZbarSf1[1, s2, 3, j2]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[3, j1][s1, 1]]*
             USf[3, j1][s4, 1] - Conjugate[USf[3, j1][s1, 2]]*
             USf[3, j1][s4, 2])*(Conjugate[USf[3, j2][s3, 1]]*
             USf[3, j2][1, 1] - Conjugate[USf[3, j2][s3, 2]]*
             USf[3, j2][1, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j2][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 1]*USf[3, j2][1, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s4, 2]*
                (Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][1, 1] - 
                 4*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][1, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j2][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 2]*USf[3, j2][1, 1] + MW^2*SB^2*USf[3, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][1, 1] - 
                 4*SW^2*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][1, 2]))))/
           (CW^2*MW^2*SB^2*SW^2)) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         (36*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j1][s1, 1]]*
             USf[3, j1][1, 1] - Conjugate[USf[3, j1][s1, 2]]*
             USf[3, j1][1, 2])*(Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j3][s4, 1] - Conjugate[USf[3, j3][s3, 2]]*
             USf[3, j3][s4, 2]) + (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j3][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][1, 
                 1]*USf[3, j3][s4, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][1, 2]*
                (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
                 4*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j3][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][1, 
                 2]*USf[3, j3][s4, 1] + MW^2*SB^2*USf[3, j1][1, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 
                   1] - 4*SW^2*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 
                   2]))))/(CW^2*MW^2*SB^2*SW^2))) + dZbarSf1[2, s2, 3, j2]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[3, j1][s1, 1]]*
             USf[3, j1][s4, 1] - Conjugate[USf[3, j1][s1, 2]]*
             USf[3, j1][s4, 2])*(Conjugate[USf[3, j2][s3, 1]]*
             USf[3, j2][2, 1] - Conjugate[USf[3, j2][s3, 2]]*
             USf[3, j2][2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j2][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 1]*USf[3, j2][2, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s4, 2]*
                (Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][2, 1] - 
                 4*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][2, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j2][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 2]*USf[3, j2][2, 1] + MW^2*SB^2*USf[3, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][2, 1] - 
                 4*SW^2*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][2, 2]))))/
           (CW^2*MW^2*SB^2*SW^2)) + IndexDelta[j1, j2]*IndexDelta[j3, j4]*
         (36*GS^2*SUNTSum[o2, o1, o4, o3]*(Conjugate[USf[3, j1][s1, 1]]*
             USf[3, j1][2, 1] - Conjugate[USf[3, j1][s1, 2]]*
             USf[3, j1][2, 2])*(Conjugate[USf[3, j3][s3, 1]]*
             USf[3, j3][s4, 1] - Conjugate[USf[3, j3][s3, 2]]*
             USf[3, j3][s4, 2]) + (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[3, j1][s1, 2]]*(9*CW^2*Conjugate[USf[3, j3][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][2, 
                 1]*USf[3, j3][s4, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][2, 2]*
                (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
                 4*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2])) + 
             Conjugate[USf[3, j1][s1, 1]]*(18*CW^2*Conjugate[USf[3, j3][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][2, 
                 2]*USf[3, j3][s4, 1] + MW^2*SB^2*USf[3, j1][2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 
                   1] - 4*SW^2*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 
                   2]))))/(CW^2*MW^2*SB^2*SW^2))) + dZSf1[1, s1, 3, j1]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[3, j1][1, 1]]*
             USf[3, j1][s4, 1] - Conjugate[USf[3, j1][1, 2]]*
             USf[3, j1][s4, 2])*(Conjugate[USf[3, j2][s3, 1]]*
             USf[3, j2][s2, 1] - Conjugate[USf[3, j2][s3, 2]]*
             USf[3, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[3, j1][1, 2]]*(9*CW^2*Conjugate[USf[3, j2][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 1]*USf[3, j2][s2, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s4, 
                 2]*(Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 1] - 
                 4*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 2])) + 
             Conjugate[USf[3, j1][1, 1]]*(18*CW^2*Conjugate[USf[3, j2][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 2]*USf[3, j2][s2, 1] + MW^2*SB^2*USf[3, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 
                   1] - 4*SW^2*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 
                   2]))))/(CW^2*MW^2*SB^2*SW^2)) + IndexDelta[j1, j2]*
         IndexDelta[j3, j4]*(36*GS^2*SUNTSum[o2, o1, o4, o3]*
           (Conjugate[USf[3, j1][1, 1]]*USf[3, j1][s2, 1] - 
            Conjugate[USf[3, j1][1, 2]]*USf[3, j1][s2, 2])*
           (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
            Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2]) + 
          (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[3, j1][1, 2]]*(9*CW^2*Conjugate[USf[3, j3][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 1]*USf[3, j3][s4, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s2, 
                 2]*(Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
                 4*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2])) + 
             Conjugate[USf[3, j1][1, 1]]*(18*CW^2*Conjugate[USf[3, j3][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 2]*USf[3, j3][s4, 1] + MW^2*SB^2*USf[3, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 
                   1] - 4*SW^2*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 
                   2]))))/(CW^2*MW^2*SB^2*SW^2))) + dZSf1[2, s1, 3, j1]*
       (IndexDelta[j1, j4]*IndexDelta[j2, j3]*
         (36*GS^2*SUNTSum[o2, o3, o4, o1]*(Conjugate[USf[3, j1][2, 1]]*
             USf[3, j1][s4, 1] - Conjugate[USf[3, j1][2, 2]]*
             USf[3, j1][s4, 2])*(Conjugate[USf[3, j2][s3, 1]]*
             USf[3, j2][s2, 1] - Conjugate[USf[3, j2][s3, 2]]*
             USf[3, j2][s2, 2]) + (EL^2*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (2*Conjugate[USf[3, j1][2, 2]]*(9*CW^2*Conjugate[USf[3, j2][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 1]*USf[3, j2][s2, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s4, 
                 2]*(Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 1] - 
                 4*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 2])) + 
             Conjugate[USf[3, j1][2, 1]]*(18*CW^2*Conjugate[USf[3, j2][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j2, o2}]]*USf[3, j1][
                 s4, 2]*USf[3, j2][s2, 1] + MW^2*SB^2*USf[3, j1][s4, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j2][s3, 1]]*USf[3, j2][s2, 
                   1] - 4*SW^2*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 
                   2]))))/(CW^2*MW^2*SB^2*SW^2)) + IndexDelta[j1, j2]*
         IndexDelta[j3, j4]*(36*GS^2*SUNTSum[o2, o1, o4, o3]*
           (Conjugate[USf[3, j1][2, 1]]*USf[3, j1][s2, 1] - 
            Conjugate[USf[3, j1][2, 2]]*USf[3, j1][s2, 2])*
           (Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
            Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2]) + 
          (EL^2*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (2*Conjugate[USf[3, j1][2, 2]]*(9*CW^2*Conjugate[USf[3, j3][s3, 
                  1]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 1]*USf[3, j3][s4, 2] - 2*MW^2*SB^2*SW^2*USf[3, j1][s2, 
                 2]*(Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
                 4*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2])) + 
             Conjugate[USf[3, j1][2, 1]]*(18*CW^2*Conjugate[USf[3, j3][s3, 
                  2]]*Mass[F[3, {j1, o1}]]*Mass[F[3, {j3, o3}]]*USf[3, j1][
                 s2, 2]*USf[3, j3][s4, 1] + MW^2*SB^2*USf[3, j1][s2, 1]*
                ((1 + 8*CW^2)*Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 
                   1] - 4*SW^2*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 
                   2]))))/(CW^2*MW^2*SB^2*SW^2))) + 
      EL^2*((36*Mass[F[3, {j1, o1}]]*(dMf1[3, j2]*IndexDelta[j1, j4]*
            IndexDelta[j2, j3]*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
            (Conjugate[USf[3, j1][s1, 1]]*Conjugate[USf[3, j2][s3, 2]]*
              USf[3, j1][s4, 2]*USf[3, j2][s2, 1] + Conjugate[USf[3, j1][s1, 
                2]]*Conjugate[USf[3, j2][s3, 1]]*USf[3, j1][s4, 1]*
              USf[3, j2][s2, 2]) + dMf1[3, j3]*IndexDelta[j1, j2]*
            IndexDelta[j3, j4]*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
            (Conjugate[USf[3, j1][s1, 1]]*Conjugate[USf[3, j3][s3, 2]]*
              USf[3, j1][s2, 2]*USf[3, j3][s4, 1] + Conjugate[USf[3, j1][s1, 
                2]]*Conjugate[USf[3, j3][s3, 1]]*USf[3, j1][s2, 1]*
              USf[3, j3][s4, 2])))/(MW^2*SB^2*SW^2) - 
        (4*(MW^4*SB^3*(4*SW^3*(CW^2*dZe1 + dSW1*SW)*Conjugate[USf[3, j1][s1, 
                2]]*(IndexDelta[j1, j4]*IndexDelta[j2, j3]*IndexDelta[o1, o4]*
                IndexDelta[o2, o3]*USf[3, j1][s4, 2]*(Conjugate[USf[3, j2][
                    s3, 1]]*USf[3, j2][s2, 1] - 4*Conjugate[USf[3, j2][s3, 
                    2]]*USf[3, j2][s2, 2]) + IndexDelta[j1, j2]*IndexDelta[
                 j3, j4]*IndexDelta[o1, o2]*IndexDelta[o3, o4]*USf[3, j1][s2, 
                 2]*(Conjugate[USf[3, j3][s3, 1]]*USf[3, j3][s4, 1] - 
                 4*Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2])) - 
             Conjugate[USf[3, j1][s1, 1]]*(IndexDelta[j1, j4]*IndexDelta[j2, 
                 j3]*IndexDelta[o1, o4]*IndexDelta[o2, o3]*USf[3, j1][s4, 1]*
                ((dSW1*SW^2 + (-CW^2 - 8*CW^4)*(dSW1 - dZe1*SW))*Conjugate[
                   USf[3, j2][s3, 1]]*USf[3, j2][s2, 1] - 4*SW^3*(CW^2*dZe1 + 
                   dSW1*SW)*Conjugate[USf[3, j2][s3, 2]]*USf[3, j2][s2, 2]) + 
               IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o1, o2]*
                IndexDelta[o3, o4]*USf[3, j1][s2, 1]*((dSW1*SW^2 + 
                   (-CW^2 - 8*CW^4)*(dSW1 - dZe1*SW))*Conjugate[USf[3, j3][
                    s3, 1]]*USf[3, j3][s4, 1] - 4*SW^3*(CW^2*dZe1 + dSW1*SW)*
                  Conjugate[USf[3, j3][s3, 2]]*USf[3, j3][s4, 2]))) + 
           CW^4*(18*dSB1*MW^2*SW*Mass[F[3, {j1, o1}]]*(IndexDelta[j1, j4]*
                IndexDelta[j2, j3]*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
                Mass[F[3, {j2, o2}]]*(Conjugate[USf[3, j1][s1, 1]]*
                  Conjugate[USf[3, j2][s3, 2]]*USf[3, j1][s4, 2]*USf[3, j2][
                   s2, 1] + Conjugate[USf[3, j1][s1, 2]]*Conjugate[
                   USf[3, j2][s3, 1]]*USf[3, j1][s4, 1]*USf[3, j2][s2, 2]) + 
               IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o1, o2]*
                IndexDelta[o3, o4]*Mass[F[3, {j3, o3}]]*
                (Conjugate[USf[3, j1][s1, 1]]*Conjugate[USf[3, j3][s3, 2]]*
                  USf[3, j1][s2, 2]*USf[3, j3][s4, 1] + Conjugate[USf[3, j1][
                    s1, 2]]*Conjugate[USf[3, j3][s3, 1]]*USf[3, j1][s2, 1]*
                  USf[3, j3][s4, 2])) - 9*SB*(MW^2*SW*dMf1[3, j1] - 
               (2*dSW1*MW^2 + (dMWsq1 - 2*dZe1*MW^2)*SW)*Mass[
                 F[3, {j1, o1}]])*(Conjugate[USf[3, j1][s1, 1]]*
                (Conjugate[USf[3, j2][s3, 2]]*IndexDelta[j1, j4]*IndexDelta[
                   j2, j3]*IndexDelta[o1, o4]*IndexDelta[o2, o3]*
                  Mass[F[3, {j2, o2}]]*USf[3, j1][s4, 2]*USf[3, j2][s2, 1] + 
                 Conjugate[USf[3, j3][s3, 2]]*IndexDelta[j1, j2]*IndexDelta[
                   j3, j4]*IndexDelta[o1, o2]*IndexDelta[o3, o4]*
                  Mass[F[3, {j3, o3}]]*USf[3, j1][s2, 2]*USf[3, j3][s4, 1]) + 
               Conjugate[USf[3, j1][s1, 2]]*(Conjugate[USf[3, j2][s3, 1]]*
                  IndexDelta[j1, j4]*IndexDelta[j2, j3]*IndexDelta[o1, o4]*
                  IndexDelta[o2, o3]*Mass[F[3, {j2, o2}]]*USf[3, j1][s4, 1]*
                  USf[3, j2][s2, 2] + Conjugate[USf[3, j3][s3, 1]]*
                  IndexDelta[j1, j2]*IndexDelta[j3, j4]*IndexDelta[o1, o2]*
                  IndexDelta[o3, o4]*Mass[F[3, {j3, o3}]]*USf[3, j1][s2, 1]*
                  USf[3, j3][s4, 2])))))/(CW^4*MW^4*SB^3*SW^3)))}}, 
 C[S[4], S[5], V[1], -V[3]] == 
  {{0, -(EL^2*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))/(4*SW)}}, 
 C[S[4], -S[5], V[1], V[3]] == 
  {{0, (EL^2*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))/(4*SW)}}, 
 C[S[4], S[5], V[2], -V[3]] == 
  {{0, (EL^2*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))/(4*CW)}}, 
 C[S[4], -S[5], V[2], V[3]] == 
  {{0, -(EL^2*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))/(4*CW)}}, 
 C[S[3], S[6], V[1], -V[3]] == 
  {{0, -(EL^2*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))/(4*SW)}}, 
 C[S[3], -S[6], V[1], V[3]] == 
  {{0, (EL^2*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))/(4*SW)}}, 
 C[S[3], S[6], V[2], -V[3]] == 
  {{0, (EL^2*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))/(4*CW)}}, 
 C[S[3], -S[6], V[2], V[3]] == 
  {{0, -(EL^2*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))/(4*CW)}}, 
 C[S[2], S[1], V[2], V[2]] == {{0, ((I/2)*EL^2*dZHiggs1[1, 2])/(CW^2*SW^2)}}, 
 C[S[4], S[3], V[2], V[2]] == {{0, ((I/2)*EL^2*dZHiggs1[3, 4])/(CW^2*SW^2)}}, 
 C[S[2], S[1], V[3], -V[3]] == {{0, ((I/2)*EL^2*dZHiggs1[1, 2])/SW^2}}, 
 C[S[4], S[3], V[3], -V[3]] == {{0, ((I/2)*EL^2*dZHiggs1[3, 4])/SW^2}}, 
 C[S[5], S[4], -V[3], V[1]] == 
  {{0, -(EL^2*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))/(4*SW)}}, 
 C[-S[5], S[4], V[3], V[1]] == 
  {{0, (EL^2*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))/(4*SW)}}, 
 C[S[5], S[4], -V[3], V[2]] == 
  {{0, (EL^2*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))/(4*CW)}}, 
 C[-S[5], S[4], V[3], V[2]] == 
  {{0, -(EL^2*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))/(4*CW)}}, 
 C[S[6], S[3], -V[3], V[1]] == 
  {{0, -(EL^2*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))/(4*SW)}}, 
 C[-S[6], S[3], V[3], V[1]] == 
  {{0, (EL^2*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))/(4*SW)}}, 
 C[S[6], S[3], -V[3], V[2]] == 
  {{0, (EL^2*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))/(4*CW)}}, 
 C[-S[6], S[3], V[3], V[2]] == 
  {{0, -(EL^2*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))/(4*CW)}}, 
 C[S[6], -S[5], V[1], V[1]] == {{0, (2*I)*EL^2*dZHiggs1[5, 6]}}, 
 C[S[5], -S[6], V[1], V[1]] == {{0, (2*I)*EL^2*dZHiggs1[6, 5]}}, 
 C[S[6], -S[5], V[2], V[1]] == 
  {{0, ((-I)*(1 - 2*CW^2)*EL^2*dZHiggs1[5, 6])/(CW*SW)}}, 
 C[S[5], -S[6], V[2], V[1]] == 
  {{0, ((-I)*(1 - 2*CW^2)*EL^2*dZHiggs1[6, 5])/(CW*SW)}}, 
 C[S[6], -S[5], V[2], V[2]] == 
  {{0, ((I/2)*(EL - 2*CW^2*EL)^2*dZHiggs1[5, 6])/(CW^2*SW^2)}}, 
 C[S[5], -S[6], V[2], V[2]] == 
  {{0, ((I/2)*(EL - 2*CW^2*EL)^2*dZHiggs1[6, 5])/(CW^2*SW^2)}}, 
 C[S[6], -S[5], V[3], -V[3]] == {{0, ((I/2)*EL^2*dZHiggs1[5, 6])/SW^2}}, 
 C[S[5], -S[6], -V[3], V[3]] == {{0, ((I/2)*EL^2*dZHiggs1[6, 5])/SW^2}}, 
 C[F[11, {n1}], F[11, {n2}], V[1]] == 
  {{0, ((-I/4)*dZZA1*EL*(Conjugate[ZNeu[n2, 3]]*ZNeu[n1, 3] - 
       Conjugate[ZNeu[n2, 4]]*ZNeu[n1, 4]))/(CW*SW)}, 
   {0, ((I/4)*dZZA1*EL*(Conjugate[ZNeu[n1, 3]]*ZNeu[n2, 3] - 
       Conjugate[ZNeu[n1, 4]]*ZNeu[n2, 4]))/(CW*SW)}}, 
 C[S[1], V[2], V[1]] == {{0, ((I/2)*dZZA1*EL*MW*SBA)/(CW^2*SW)}}, 
 C[S[2], V[2], V[1]] == {{0, ((I/2)*CBA*dZZA1*EL*MW)/(CW^2*SW)}}, 
 C[S[5], V[1], -V[3]] == 
  {{0, (I/2)*EL*MW*(2*CB*dSB1 - 2*dCB1*SB + dZHiggs1[6, 5])}}, 
 C[-S[5], V[1], V[3]] == 
  {{0, (I/2)*EL*MW*(2*CB*dSB1 - 2*dCB1*SB + dZHiggs1[5, 6])}}, 
 C[S[5], V[2], -V[3]] == 
  {{0, ((-I/2)*EL*MW*SW*(2*CB*dSB1 - 2*dCB1*SB + dZHiggs1[6, 5]))/CW}}, 
 C[-S[5], V[2], V[3]] == 
  {{0, ((-I/2)*EL*MW*SW*(2*CB*dSB1 - 2*dCB1*SB + dZHiggs1[5, 6]))/CW}}, 
 C[S[1], S[3], V[1]] == {{0, (CBA*dZZA1*EL)/(4*CW*SW)}}, 
 C[S[1], S[4], V[1]] == {{0, (dZZA1*EL*SBA)/(4*CW*SW)}}, 
 C[S[2], S[3], V[1]] == {{0, -(dZZA1*EL*SBA)/(4*CW*SW)}}, 
 C[S[2], S[4], V[1]] == {{0, (CBA*dZZA1*EL)/(4*CW*SW)}}, 
 C[S[5], -S[6], V[1]] == {{0, I*EL*dZHiggs1[6, 5]}}, 
 C[S[6], -S[5], V[1]] == {{0, I*EL*dZHiggs1[5, 6]}}, 
 C[S[5], -S[6], V[2]] == {{0, ((-I/2)*(1 - 2*CW^2)*EL*dZHiggs1[6, 5])/
     (CW*SW)}}, C[S[6], -S[5], V[2]] == 
  {{0, ((-I/2)*(1 - 2*CW^2)*EL*dZHiggs1[5, 6])/(CW*SW)}}, 
 C[S[3], S[6], -V[3]] == {{0, (EL*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))/
     (4*SW)}}, C[S[3], -S[6], V[3]] == 
  {{0, (EL*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))/(4*SW)}}, 
 C[S[4], S[5], -V[3]] == {{0, (EL*(dZHiggs1[3, 4] + dZHiggs1[6, 5]))/
     (4*SW)}}, C[S[4], -S[5], V[3]] == 
  {{0, (EL*(dZHiggs1[3, 4] + dZHiggs1[5, 6]))/(4*SW)}}, 
 C[S[11, {j1}], -S[11, {j2}], V[1]] == 
  {{0, ((-I/4)*dZZA1*EL*IndexDelta[j1, j2])/(CW*SW)}}, 
 C[S[3], V[2]] == {{0, -(MZ*dZHiggs1[3, 4])}, {0, 0}}, 
 C[S[4], V[2]] == {{0, -(MZ*(dZZZ1 + dMZsq1/MZ^2 + dZHiggs1[4, 4]))/2}, 
   {0, 0}}, C[S[4], V[1]] == {{0, -(dZZA1*MZ)/2}, {0, 0}}, 
 C[S[5], -V[3]] == {{0, I*MW*dZHiggs1[6, 5]}, {0, 0}}, 
 C[-S[5], V[3]] == {{0, (-I)*MW*dZHiggs1[5, 6]}, {0, 0}}, 
 C[S[6], -V[3]] == {{0, (I/2)*MW*(dZW1 + dMWsq1/MW^2 + dZHiggs1[6, 6])}, 
   {0, 0}}, C[-S[6], V[3]] == 
  {{0, (-I/2)*MW*(dZW1 + dMWsq1/MW^2 + dZHiggs1[6, 6])}, {0, 0}}, 
 C[-V[3], V[3]] == {{0, I*dZW1, I*dZW2}, {0, I*(dMWsq1 + dZW1*MW^2), 
    I*(dMWsq2 + dMWsq1*dZW1 + dZW2*MW^2)}, {0, (-I)*dZW1, (-I)*dZW2}}, 
 C[V[2], V[2]] == {{0, I*dZZZ1, (I/4)*(dZAZ1^2 + 4*dZZZ2)}, 
   {0, I*(dMZsq1 + dZZZ1*MZ^2), I*(dMZsq2 + dMZsq1*dZZZ1 + dZZZ2*MZ^2)}, 
   {0, (-I)*dZZZ1, (-I/4)*(dZAZ1^2 + 4*dZZZ2)}}, 
 C[V[1], V[1]] == {{0, I*dZAA1, (I/4)*(4*dZAA2 + dZZA1^2)}, 
   {0, 0, (I/4)*dZZA1^2*MZ^2}, {0, (-I)*dZAA1, (-I/4)*(4*dZAA2 + dZZA1^2)}}, 
 C[V[1], V[2]] == {{0, (I/2)*(dZAZ1 + dZZA1), 
    (I/4)*(dZAA1*dZAZ1 + 2*(dZAZ2 + dZZA2) + dZZA1*dZZZ1)}, 
   {0, (I/2)*dZZA1*MZ^2, (I/4)*(2*dMZsq1*dZZA1 + (2*dZZA2 + dZZA1*dZZZ1)*
       MZ^2)}, {0, (-I/2)*(dZAZ1 + dZZA1), 
    (-I/4)*(dZAA1*dZAZ1 + 2*(dZAZ2 + dZZA2) + dZZA1*dZZZ1)}}, 
 C[U[1], -U[1]] == {{0, (-I)*(dUAA1 - dZAA1/2)}, {0, 0}}, 
 C[U[2], -U[2]] == {{0, (-I)*(dUZZ1 - dZZZ1/2)}, 
   {0, (-I/2)*(dMZsq1 + (2*dUZZ1 - dZG01)*MZ^2)*GaugeXi[Z]}}, 
 C[U[2], -U[1]] == {{0, (-I)*(dUAZ1 - dZAZ1/2)}, {0, 0}}, 
 C[U[1], -U[2]] == {{0, (-I)*(dUZA1 - dZZA1/2)}, 
   {0, (-I)*dUZA1*MZ^2*GaugeXi[Z]}}, C[U[3], -U[3]] == 
  {{0, (-I)*(dUW1 - dZW1/2)}, {0, (-I/2)*(dMWsq1 + (2*dUW1 - dZGp1)*MW^2)*
     GaugeXi[W]}}, C[U[4], -U[4]] == {{0, (-I)*(dUW1 - dZW1/2)}, 
   {0, (-I/2)*(dMWsq1 + (2*dUW1 - dZGp1)*MW^2)*GaugeXi[W]}}, 
 C[-F[1, {j1}], F[1, {j2}]] == 
  {{0, (-I/2)*(dZbarfL1[1, j1, j1] + dZfL1[1, j1, j1])*IndexDelta[j1, j2]}, 
   {0, (I/2)*(dZbarfR1[1, j1, j1] + dZfR1[1, j1, j1])*IndexDelta[j1, j2]}, 
   {0, 0}, {0, 0}}, C[-F[2, {j1}], F[2, {j2}]] == 
  {{0, (-I/2)*(dZbarfL1[2, j1, j1] + dZfL1[2, j1, j1])*IndexDelta[j1, j2]}, 
   {0, (I/2)*(dZbarfR1[2, j1, j1] + dZfR1[2, j1, j1])*IndexDelta[j1, j2]}, 
   {0, (-I/2)*IndexDelta[j1, j2]*(2*dMf1[2, j1] + 
      (dZbarfR1[2, j1, j1] + dZfL1[2, j1, j1])*Mass[F[2, {j1}]])}, 
   {0, (-I/2)*IndexDelta[j1, j2]*(2*dMf1[2, j1] + 
      (dZbarfL1[2, j1, j1] + dZfR1[2, j1, j1])*Mass[F[2, {j1}]])}}, 
 C[-F[3, {j1, o1}], F[3, {j2, o2}]] == 
  {{0, (-I/2)*(dZbarfL1[3, j2, j1] + dZfL1[3, j1, j2])*IndexDelta[o1, o2]}, 
   {0, (I/2)*(dZbarfR1[3, j2, j1] + dZfR1[3, j1, j2])*IndexDelta[o1, o2]}, 
   {0, (-I/2)*IndexDelta[o1, o2]*(2*dMf1[3, j1]*IndexDelta[j1, j2] + 
      dZfL1[3, j1, j2]*Mass[F[3, {j1}]] + dZbarfR1[3, j1, j2]*
       Mass[F[3, {j2}]])}, {0, (-I/2)*IndexDelta[o1, o2]*
     (2*dMf1[3, j1]*IndexDelta[j1, j2] + dZfR1[3, j1, j2]*Mass[F[3, {j1}]] + 
      dZbarfL1[3, j1, j2]*Mass[F[3, {j2}]])}}, 
 C[-F[4, {j1, o1}], F[4, {j2, o2}]] == 
  {{0, (-I/2)*(dZbarfL1[4, j2, j1] + dZfL1[4, j1, j2])*IndexDelta[o1, o2]}, 
   {0, (I/2)*(dZbarfR1[4, j2, j1] + dZfR1[4, j1, j2])*IndexDelta[o1, o2]}, 
   {0, (-I/2)*IndexDelta[o1, o2]*(2*dMf1[4, j1]*IndexDelta[j1, j2] + 
      dZfL1[4, j1, j2]*Mass[F[4, {j1}]] + dZbarfR1[4, j1, j2]*
       Mass[F[4, {j2}]])}, {0, (-I/2)*IndexDelta[o1, o2]*
     (2*dMf1[4, j1]*IndexDelta[j1, j2] + dZfR1[4, j1, j2]*Mass[F[4, {j1}]] + 
      dZbarfL1[4, j1, j2]*Mass[F[4, {j2}]])}}, 
 C[-F[1, {j1}], F[1, {j2}], V[1]] == 
  {{0, ((-I/4)*dZZA1*EL*IndexDelta[j1, j2])/(CW*SW)}, {0, 0}}, 
 C[V[5, {g1}], V[5, {g2}], V[5, {g3}], V[5, {g4}]] == 
  {{(-I)*GS^2*(SUNF[g1, g3, g2, g4] - SUNF[g1, g4, g3, g2]), 
    (-2*I)*(dZGG1 + dZgs1)*GS^2*(SUNF[g1, g3, g2, g4] - 
      SUNF[g1, g4, g3, g2])}, 
   {(-I)*GS^2*(SUNF[g1, g2, g3, g4] + SUNF[g1, g4, g3, g2]), 
    (-2*I)*(dZGG1 + dZgs1)*GS^2*(SUNF[g1, g2, g3, g4] + 
      SUNF[g1, g4, g3, g2])}, 
   {I*GS^2*(SUNF[g1, g2, g3, g4] + SUNF[g1, g3, g2, g4]), 
    (2*I)*(dZGG1 + dZgs1)*GS^2*(SUNF[g1, g2, g3, g4] + 
      SUNF[g1, g3, g2, g4])}}, C[V[5, {g1}], V[5, {g2}], V[5, {g3}]] == 
  {{GS*SUNF[g1, g2, g3], ((3*dZGG1 + 2*dZgs1)*GS*SUNF[g1, g2, g3])/2}}, 
 C[-U[5, {g1}], U[5, {g2}], V[5, {g3}]] == {{GS*SUNF[g1, g2, g3]}, {0}}, 
 C[-F[3, {j1, o1}], F[3, {j2, o2}], V[5, {g1}]] == 
  {{(-I)*GS*IndexDelta[j1, j2]*SUNT[g1, o1, o2], 
    (-I/2)*GS*(dZGG1 + 2*dZgs1 + dZbarfL1[3, j1, j1] + dZfL1[3, j2, j2])*
     IndexDelta[j1, j2]*SUNT[g1, o1, o2]}, 
   {(-I)*GS*IndexDelta[j1, j2]*SUNT[g1, o1, o2], 
    (-I/2)*GS*(dZGG1 + 2*dZgs1 + dZbarfR1[3, j1, j1] + dZfR1[3, j2, j2])*
     IndexDelta[j1, j2]*SUNT[g1, o1, o2]}}, 
 C[-F[4, {j1, o1}], F[4, {j2, o2}], V[5, {g1}]] == 
  {{(-I)*GS*IndexDelta[j1, j2]*SUNT[g1, o1, o2], 
    (-I/2)*GS*(dZGG1 + 2*dZgs1 + dZbarfL1[4, j1, j1] + dZfL1[4, j2, j2])*
     IndexDelta[j1, j2]*SUNT[g1, o1, o2]}, 
   {(-I)*GS*IndexDelta[j1, j2]*SUNT[g1, o1, o2], 
    (-I/2)*GS*(dZGG1 + 2*dZgs1 + dZbarfR1[4, j1, j1] + dZfR1[4, j2, j2])*
     IndexDelta[j1, j2]*SUNT[g1, o1, o2]}}, 
 C[F[15, {g1}], F[15, {g2}], V[5, {g3}]] == 
  {{-(GS*SUNF[g1, g2, g3]), -((dZGG1 + 2*(dZGlL1 + dZgs1))*GS*
       SUNF[g1, g2, g3])/2}, {-(GS*SUNF[g1, g2, g3]), 
    -((dZGG1 + 2*(dZGlR1 + dZgs1))*GS*SUNF[g1, g2, g3])/2}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], V[5, {g1}]] == 
  {{(-I)*GS*IndexDelta[j1, j2]*IndexDelta[s1, s2]*SUNT[g1, o2, o1], 
    (-I/2)*GS*IndexDelta[j1, j2]*(dZbarSf1[1, s2, 3, j2]*IndexDelta[1, s1] + 
      dZSf1[1, s1, 3, j1]*IndexDelta[1, s2] + dZbarSf1[2, s2, 3, j2]*
       IndexDelta[2, s1] + dZSf1[2, s1, 3, j1]*IndexDelta[2, s2] + 
      (dZGG1 + 2*dZgs1)*IndexDelta[s1, s2])*SUNT[g1, o2, o1]}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[5, {g1}]] == 
  {{(-I)*GS*IndexDelta[j1, j2]*IndexDelta[s1, s2]*SUNT[g1, o2, o1], 
    (-I/2)*GS*IndexDelta[j1, j2]*(dZbarSf1[1, s2, 4, j2]*IndexDelta[1, s1] + 
      dZSf1[1, s1, 4, j1]*IndexDelta[1, s2] + dZbarSf1[2, s2, 4, j2]*
       IndexDelta[2, s1] + dZSf1[2, s1, 4, j1]*IndexDelta[2, s2] + 
      (dZGG1 + 2*dZgs1)*IndexDelta[s1, s2])*SUNT[g1, o2, o1]}}, 
 C[F[15, {g1}], -F[3, {j1, o1}], S[13, {s2, j2, o2}]] == 
  {{I*Sqrt[2]*GS*Conjugate[SqrtEGl]*Conjugate[USf[3, j1][s2, 2]]*
     IndexDelta[j1, j2]*SUNT[g1, o1, o2], 
    (I*GS*Conjugate[SqrtEGl]*(Conjugate[USf[3, j1][s2, 2]]*
        (dZGlL1 + 2*dZgs1 + dZbarfR1[3, j1, j1]) + 
       Conjugate[USf[3, j1][1, 2]]*dZSf1[1, s2, 3, j2] + 
       Conjugate[USf[3, j1][2, 2]]*dZSf1[2, s2, 3, j2])*IndexDelta[j1, j2]*
      SUNT[g1, o1, o2])/Sqrt[2]}, 
   {(-I)*Sqrt[2]*GS*SqrtEGl*Conjugate[USf[3, j1][s2, 1]]*IndexDelta[j1, j2]*
     SUNT[g1, o1, o2], ((-I)*GS*SqrtEGl*(Conjugate[USf[3, j1][s2, 1]]*
        (dZGlR1 + 2*dZgs1 + dZbarfL1[3, j1, j1]) + 
       Conjugate[USf[3, j1][1, 1]]*dZSf1[1, s2, 3, j2] + 
       Conjugate[USf[3, j1][2, 1]]*dZSf1[2, s2, 3, j2])*IndexDelta[j1, j2]*
      SUNT[g1, o1, o2])/Sqrt[2]}}, 
 C[F[15, {g1}], -F[4, {j1, o1}], S[14, {s2, j2, o2}]] == 
  {{I*Sqrt[2]*GS*Conjugate[SqrtEGl]*Conjugate[USf[4, j1][s2, 2]]*
     IndexDelta[j1, j2]*SUNT[g1, o1, o2], 
    (I*GS*Conjugate[SqrtEGl]*(Conjugate[USf[4, j1][s2, 2]]*
        (dZGlL1 + 2*dZgs1 + dZbarfR1[4, j1, j1]) + 
       Conjugate[USf[4, j1][1, 2]]*dZSf1[1, s2, 4, j2] + 
       Conjugate[USf[4, j1][2, 2]]*dZSf1[2, s2, 4, j2])*IndexDelta[j1, j2]*
      SUNT[g1, o1, o2])/Sqrt[2]}, 
   {(-I)*Sqrt[2]*GS*SqrtEGl*Conjugate[USf[4, j1][s2, 1]]*IndexDelta[j1, j2]*
     SUNT[g1, o1, o2], ((-I)*GS*SqrtEGl*(Conjugate[USf[4, j1][s2, 1]]*
        (dZGlR1 + 2*dZgs1 + dZbarfL1[4, j1, j1]) + 
       Conjugate[USf[4, j1][1, 1]]*dZSf1[1, s2, 4, j2] + 
       Conjugate[USf[4, j1][2, 1]]*dZSf1[2, s2, 4, j2])*IndexDelta[j1, j2]*
      SUNT[g1, o1, o2])/Sqrt[2]}}, 
 C[F[15, {g1}], F[3, {j1, o1}], -S[13, {s2, j2, o2}]] == 
  {{(-I)*Sqrt[2]*GS*Conjugate[SqrtEGl]*IndexDelta[j1, j2]*SUNT[g1, o2, o1]*
     USf[3, j1][s2, 1], ((-I)*GS*Conjugate[SqrtEGl]*IndexDelta[j1, j2]*
      SUNT[g1, o2, o1]*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 1] + 
       dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 1] + 
       (dZGlL1 + 2*dZgs1 + dZfL1[3, j1, j1])*USf[3, j1][s2, 1]))/Sqrt[2]}, 
   {I*Sqrt[2]*GS*SqrtEGl*IndexDelta[j1, j2]*SUNT[g1, o2, o1]*
     USf[3, j1][s2, 2], (I*GS*SqrtEGl*IndexDelta[j1, j2]*SUNT[g1, o2, o1]*
      (dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 2] + dZbarSf1[2, s2, 3, j2]*
        USf[3, j1][2, 2] + (dZGlR1 + 2*dZgs1 + dZfR1[3, j1, j1])*
        USf[3, j1][s2, 2]))/Sqrt[2]}}, 
 C[F[15, {g1}], F[4, {j1, o1}], -S[14, {s2, j2, o2}]] == 
  {{(-I)*Sqrt[2]*GS*Conjugate[SqrtEGl]*IndexDelta[j1, j2]*SUNT[g1, o2, o1]*
     USf[4, j1][s2, 1], ((-I)*GS*Conjugate[SqrtEGl]*IndexDelta[j1, j2]*
      SUNT[g1, o2, o1]*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 1] + 
       dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 1] + 
       (dZGlL1 + 2*dZgs1 + dZfL1[4, j1, j1])*USf[4, j1][s2, 1]))/Sqrt[2]}, 
   {I*Sqrt[2]*GS*SqrtEGl*IndexDelta[j1, j2]*SUNT[g1, o2, o1]*
     USf[4, j1][s2, 2], (I*GS*SqrtEGl*IndexDelta[j1, j2]*SUNT[g1, o2, o1]*
      (dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 2] + dZbarSf1[2, s2, 4, j2]*
        USf[4, j1][2, 2] + (dZGlR1 + 2*dZgs1 + dZfR1[4, j1, j1])*
        USf[4, j1][s2, 2]))/Sqrt[2]}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], V[5, {g1}], V[5, {g2}]] == 
  {{I*GS^2*IndexDelta[j1, j2]*IndexDelta[s1, s2]*(SUNT[g1, g2, o2, o1] + 
      SUNT[g2, g1, o2, o1]), (I/2)*GS^2*IndexDelta[j1, j2]*
     (dZbarSf1[1, s2, 3, j2]*IndexDelta[1, s1] + dZSf1[1, s1, 3, j1]*
       IndexDelta[1, s2] + dZbarSf1[2, s2, 3, j2]*IndexDelta[2, s1] + 
      dZSf1[2, s1, 3, j1]*IndexDelta[2, s2] + 2*(dZGG1 + 2*dZgs1)*
       IndexDelta[s1, s2])*(SUNT[g1, g2, o2, o1] + SUNT[g2, g1, o2, o1])}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[5, {g1}], V[5, {g2}]] == 
  {{I*GS^2*IndexDelta[j1, j2]*IndexDelta[s1, s2]*(SUNT[g1, g2, o2, o1] + 
      SUNT[g2, g1, o2, o1]), (I/2)*GS^2*IndexDelta[j1, j2]*
     (dZbarSf1[1, s2, 4, j2]*IndexDelta[1, s1] + dZSf1[1, s1, 4, j1]*
       IndexDelta[1, s2] + dZbarSf1[2, s2, 4, j2]*IndexDelta[2, s1] + 
      dZSf1[2, s1, 4, j1]*IndexDelta[2, s2] + 2*(dZGG1 + 2*dZgs1)*
       IndexDelta[s1, s2])*(SUNT[g1, g2, o2, o1] + SUNT[g2, g1, o2, o1])}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], V[5, {g1}], V[1]] == 
  {{((4*I)/3)*EL*GS*IndexDelta[j1, j2]*IndexDelta[s1, s2]*SUNT[g1, o2, o1], 
    ((I/6)*EL*GS*IndexDelta[j1, j2]*SUNT[g1, o2, o1]*
      (4*CW*SW*(dZbarSf1[1, s2, 3, j2]*IndexDelta[1, s1] + 
         dZSf1[1, s1, 3, j1]*IndexDelta[1, s2] + dZbarSf1[2, s2, 3, j2]*
          IndexDelta[2, s1] + dZSf1[2, s1, 3, j1]*IndexDelta[2, s2] + 
         (dZAA1 + 2*dZe1 + dZGG1 + 2*dZgs1)*IndexDelta[s1, s2]) - 
       dZZA1*(4*SW^2*IndexDelta[s1, s2] - 3*Conjugate[USf[3, j1][s1, 1]]*
          USf[3, j1][s2, 1])))/(CW*SW)}}, 
 C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[5, {g1}], V[1]] == 
  {{((-2*I)/3)*EL*GS*IndexDelta[j1, j2]*IndexDelta[s1, s2]*SUNT[g1, o2, o1], 
    ((-I/6)*EL*GS*IndexDelta[j1, j2]*SUNT[g1, o2, o1]*
      (2*CW*SW*(dZbarSf1[1, s2, 4, j2]*IndexDelta[1, s1] + 
         dZSf1[1, s1, 4, j1]*IndexDelta[1, s2] + dZbarSf1[2, s2, 4, j2]*
          IndexDelta[2, s1] + dZSf1[2, s1, 4, j1]*IndexDelta[2, s2] + 
         (dZAA1 + 2*dZe1 + dZGG1 + 2*dZgs1)*IndexDelta[s1, s2]) - 
       dZZA1*(2*SW^2*IndexDelta[s1, s2] - 3*Conjugate[USf[4, j1][s1, 1]]*
          USf[4, j1][s2, 1])))/(CW*SW)}}, 
 C[S[13, {s1, j1, o1}], -S[13, {s2, j2, o2}], V[5, {g1}], V[2]] == 
  {{((-I/3)*EL*GS*IndexDelta[j1, j2]*SUNT[g1, o2, o1]*
      (4*SW^2*IndexDelta[s1, s2] - 3*Conjugate[USf[3, j1][s1, 1]]*
        USf[3, j1][s2, 1]))/(CW*SW), ((I/6)*EL*GS*IndexDelta[j1, j2]*
      SUNT[g1, o2, o1]*(SW^2*(4*CW^3*dZAZ1 - 8*dSW1*SW^2 - 
         4*CW^2*(2*dSW1 + (2*dZe1 + dZGG1 + 2*dZgs1 + dZZZ1)*SW))*
        IndexDelta[s1, s2] + Conjugate[USf[3, j1][s1, 1]]*
        (6*dSW1*SW^2*USf[3, j1][s2, 1] + 
         CW^2*(3*SW*(dZbarSf1[1, s2, 3, j2]*USf[3, j1][1, 1] + 
             dZbarSf1[2, s2, 3, j2]*USf[3, j1][2, 1]) - 
           (6*dSW1 - 3*(2*dZe1 + dZGG1 + 2*dZgs1 + dZZZ1)*SW)*
            USf[3, j1][s2, 1])) - 
       CW^2*(4*SW^3*(dZbarSf1[1, s2, 3, j2]*IndexDelta[1, s1] + 
           dZbarSf1[2, s2, 3, j2]*IndexDelta[2, s1]) + 
         SW*(dZSf1[1, s1, 3, j1]*(4*SW^2*IndexDelta[1, s2] - 
             3*Conjugate[USf[3, j1][1, 1]]*USf[3, j1][s2, 1]) + 
           dZSf1[2, s1, 3, j1]*(4*SW^2*IndexDelta[2, s2] - 
             3*Conjugate[USf[3, j1][2, 1]]*USf[3, j1][s2, 1])))))/
     (CW^3*SW^2)}}, C[S[14, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[5, {g1}], 
   V[2]] == {{((I/3)*EL*GS*IndexDelta[j1, j2]*SUNT[g1, o2, o1]*
      (2*SW^2*IndexDelta[s1, s2] - 3*Conjugate[USf[4, j1][s1, 1]]*
        USf[4, j1][s2, 1]))/(CW*SW), ((-I/6)*EL*GS*IndexDelta[j1, j2]*
      SUNT[g1, o2, o1]*(SW^2*(2*CW^3*dZAZ1 - 4*dSW1*SW^2 - 
         2*CW^2*(2*dSW1 + (2*dZe1 + dZGG1 + 2*dZgs1 + dZZZ1)*SW))*
        IndexDelta[s1, s2] + Conjugate[USf[4, j1][s1, 1]]*
        (6*dSW1*SW^2*USf[4, j1][s2, 1] + 
         CW^2*(3*SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j1][1, 1] + 
             dZbarSf1[2, s2, 4, j2]*USf[4, j1][2, 1]) - 
           (6*dSW1 - 3*(2*dZe1 + dZGG1 + 2*dZgs1 + dZZZ1)*SW)*
            USf[4, j1][s2, 1])) - 
       CW^2*(2*SW^3*(dZbarSf1[1, s2, 4, j2]*IndexDelta[1, s1] + 
           dZbarSf1[2, s2, 4, j2]*IndexDelta[2, s1]) + 
         SW*(dZSf1[1, s1, 4, j1]*(2*SW^2*IndexDelta[1, s2] - 
             3*Conjugate[USf[4, j1][1, 1]]*USf[4, j1][s2, 1]) + 
           dZSf1[2, s1, 4, j1]*(2*SW^2*IndexDelta[2, s2] - 
             3*Conjugate[USf[4, j1][2, 1]]*USf[4, j1][s2, 1])))))/
     (CW^3*SW^2)}}, C[S[13, {s1, j1, o1}], -S[14, {s2, j2, o2}], V[5, {g1}], 
   V[3]] == {{(I*Sqrt[2]*EL*GS*Conjugate[CKM[j1, j2]]*
      Conjugate[USf[3, j1][s1, 1]]*SUNT[g1, o2, o1]*USf[4, j2][s2, 1])/SW, 
    (I*EL*GS*SUNT[g1, o2, o1]*(2*SW*Conjugate[dCKM1[j1, j2]]*
        Conjugate[USf[3, j1][s1, 1]]*USf[4, j2][s2, 1] + 
       Conjugate[CKM[j1, j2]]*(SW*(Conjugate[USf[3, j1][1, 1]]*
            dZSf1[1, s1, 3, j1] + Conjugate[USf[3, j1][2, 1]]*
            dZSf1[2, s1, 3, j1])*USf[4, j2][s2, 1] + 
         Conjugate[USf[3, j1][s1, 1]]*
          (SW*(dZbarSf1[1, s2, 4, j2]*USf[4, j2][1, 1] + 
             dZbarSf1[2, s2, 4, j2]*USf[4, j2][2, 1]) - 
           (2*dSW1 - (2*dZe1 + dZGG1 + 2*dZgs1 + dZW1)*SW)*
            USf[4, j2][s2, 1]))))/(Sqrt[2]*SW^2)}}, 
 C[S[14, {s2, j2, o2}], -S[13, {s1, j1, o1}], V[5, {g1}], -V[3]] == 
  {{(I*Sqrt[2]*EL*GS*CKM[j1, j2]*Conjugate[USf[4, j2][s2, 1]]*
      SUNT[g1, o1, o2]*USf[3, j1][s1, 1])/SW, 
    (I*EL*GS*SUNT[g1, o1, o2]*(2*SW*Conjugate[USf[4, j2][s2, 1]]*
        dCKM1[j1, j2]*USf[3, j1][s1, 1] + CKM[j1, j2]*
        (SW*(Conjugate[USf[4, j2][1, 1]]*dZSf1[1, s2, 4, j2] + 
           Conjugate[USf[4, j2][2, 1]]*dZSf1[2, s2, 4, j2])*
          USf[3, j1][s1, 1] + Conjugate[USf[4, j2][s2, 1]]*
          (SW*(dZbarSf1[1, s1, 3, j1]*USf[3, j1][1, 1] + 
             dZbarSf1[2, s1, 3, j1]*USf[3, j1][2, 1]) - 
           (2*dSW1 - (dZbarW1 + 2*dZe1 + dZGG1 + 2*dZgs1)*SW)*
            USf[3, j1][s1, 1]))))/(Sqrt[2]*SW^2)}}, 
 C[-F[12, {c1}], F[12, {c2}]] == 
  {{0, (-I/2)*(dZbarfL1[12, c1, c2] + dZfL1[12, c1, c2])}, 
   {0, (I/2)*(dZbarfR1[12, c1, c2] + dZfR1[12, c1, c2])}, 
   {0, (-I/2)*(2*dMCha1[c1, c2] + dZfL1[12, c1, c2]*TheMass[F[12, {c1}]] + 
      dZbarfR1[12, c1, c2]*TheMass[F[12, {c2}]])}, 
   {0, (-I/2)*(2*Conjugate[dMCha1[c2, c1]] + dZfR1[12, c1, c2]*
       TheMass[F[12, {c1}]] + dZbarfL1[12, c1, c2]*TheMass[F[12, {c2}]])}}, 
 C[F[11, {n1}], F[11, {n2}]] == 
  {{0, (-I/2)*(dZbarfL1[11, n1, n2] + dZfL1[11, n1, n2])}, 
   {0, (I/2)*(dZbarfR1[11, n1, n2] + dZfR1[11, n1, n2])}, 
   {0, (-I/2)*(2*dMNeu1[n1, n2] + dZfL1[11, n1, n2]*TheMass[F[11, {n1}]] + 
      dZbarfR1[11, n1, n2]*TheMass[F[11, {n2}]])}, 
   {0, (-I/2)*(2*Conjugate[dMNeu1[n2, n1]] + dZfR1[11, n1, n2]*
       TheMass[F[11, {n1}]] + dZbarfL1[11, n1, n2]*TheMass[F[11, {n2}]])}}, 
 C[-S[11, {j1}], S[11, {j2}]] == 
  {{0, (-I/2)*(dZbarSf1[1, 1, 1, j2] + dZSf1[1, 1, 1, j1])*
     IndexDelta[j1, j2]}, {0, (-I/2)*IndexDelta[j1, j2]*
     (2*dMSfsq1[1, 1, 1, j1] + (dZbarSf1[1, 1, 1, j2] + dZSf1[1, 1, 1, j1])*
       TheMass[S[11, {j1}]]^2)}}, C[-S[12, {s1, j1}], S[12, {s2, j2}]] == 
  {{0, (-I/2)*(dZbarSf1[s2, s1, 2, j2] + dZSf1[s1, s2, 2, j1])*
     IndexDelta[j1, j2]}, {0, (-I/2)*IndexDelta[j1, j2]*
     (2*dMSfsq1[s1, s2, 2, j1] + dZSf1[s1, s2, 2, j1]*
       TheMass[S[12, {s1, j1}]]^2 + dZbarSf1[s2, s1, 2, j2]*
       TheMass[S[12, {s2, j2}]]^2)}}, C[S[1], S[1]] == 
  {{0, (-I)*dZHiggs1[1, 1]}, 
   {0, (-I)*(dMHiggs1[1, 1] + Mh0tree^2*dZHiggs1[1, 1])}}, 
 C[S[1], S[2]] == {{0, (-I)*dZHiggs1[1, 2]}, 
   {0, (-I/2)*(2*dMHiggs1[1, 2] + (Mh0tree^2 + MHHtree^2)*dZHiggs1[1, 2])}}, 
 C[S[1], S[3]] == {{0, (-I)*dZHiggs1[1, 3]}, 
   {0, (-I/2)*(2*dMHiggs1[1, 3] + (MA0tree^2 + Mh0tree^2)*dZHiggs1[1, 3])}}, 
 C[S[1], S[4]] == {{0, (-I)*dZHiggs1[1, 4]}, 
   {0, (-I/2)*(2*dMHiggs1[1, 4] + Mh0tree^2*dZHiggs1[1, 4])}}, 
 C[S[2], S[1]] == {{0, (-I)*dZHiggs1[1, 2]}, 
   {0, (-I/2)*(2*dMHiggs1[1, 2] + (Mh0tree^2 + MHHtree^2)*dZHiggs1[1, 2])}}, 
 C[S[2], S[2]] == {{0, (-I)*dZHiggs1[2, 2]}, 
   {0, (-I)*(dMHiggs1[2, 2] + MHHtree^2*dZHiggs1[2, 2])}}, 
 C[S[2], S[3]] == {{0, (-I)*dZHiggs1[2, 3]}, 
   {0, (-I/2)*(2*dMHiggs1[2, 3] + (MA0tree^2 + MHHtree^2)*dZHiggs1[2, 3])}}, 
 C[S[2], S[4]] == {{0, (-I)*dZHiggs1[2, 4]}, 
   {0, (-I/2)*(2*dMHiggs1[2, 4] + MHHtree^2*dZHiggs1[2, 4])}}, 
 C[S[3], S[1]] == {{0, (-I)*dZHiggs1[1, 3]}, 
   {0, (-I/2)*(2*dMHiggs1[1, 3] + (MA0tree^2 + Mh0tree^2)*dZHiggs1[1, 3])}}, 
 C[S[3], S[2]] == {{0, (-I)*dZHiggs1[2, 3]}, 
   {0, (-I/2)*(2*dMHiggs1[2, 3] + (MA0tree^2 + MHHtree^2)*dZHiggs1[2, 3])}}, 
 C[S[3], S[3]] == {{0, (-I)*dZHiggs1[3, 3]}, 
   {0, (-I)*(dMHiggs1[3, 3] + MA0tree^2*dZHiggs1[3, 3])}}, 
 C[S[3], S[4]] == {{0, (-I)*dZHiggs1[3, 4]}, 
   {0, (-I/2)*(2*dMHiggs1[3, 4] + MA0tree^2*dZHiggs1[3, 4])}}, 
 C[S[4], S[1]] == {{0, (-I)*dZHiggs1[1, 4]}, 
   {0, (-I/2)*(2*dMHiggs1[1, 4] + Mh0tree^2*dZHiggs1[1, 4])}}, 
 C[S[4], S[2]] == {{0, (-I)*dZHiggs1[2, 4]}, 
   {0, (-I/2)*(2*dMHiggs1[2, 4] + MHHtree^2*dZHiggs1[2, 4])}}, 
 C[S[4], S[3]] == {{0, (-I)*dZHiggs1[3, 4]}, 
   {0, (-I/2)*(2*dMHiggs1[3, 4] + MA0tree^2*dZHiggs1[3, 4])}}, 
 C[S[4], S[4]] == {{0, (-I)*dZHiggs1[4, 4]}, {0, (-I)*dMHiggs1[4, 4]}}, 
 C[S[5], -S[5]] == {{0, (-I/2)*(dZbarHiggs1[5, 5] + dZHiggs1[5, 5])}, 
   {0, (-I/2)*(2*dMHiggs1[5, 5] + MHptree^2*(dZbarHiggs1[5, 5] + 
        dZHiggs1[5, 5]))}}, C[S[5], -S[6]] == {{0, (-I)*dZHiggs1[6, 5]}, 
   {0, (-I/2)*(2*dMHiggs1[6, 5] + MHptree^2*dZHiggs1[5, 6])}}, 
 C[S[6], -S[5]] == {{0, (-I)*dZHiggs1[5, 6]}, 
   {0, (-I/2)*(2*dMHiggs1[5, 6] + MHptree^2*dZHiggs1[6, 5])}}, 
 C[S[6], -S[6]] == {{0, (-I)*dZHiggs1[6, 6]}, {0, (-I)*dMHiggs1[6, 6]}}, 
 C[-S[13, {s1, j1, o1}], S[13, {s2, j2, o2}]] == 
  {{0, (-I/2)*(dZbarSf1[s2, s1, 3, j2] + dZSf1[s1, s2, 3, j1])*
     IndexDelta[j1, j2]*IndexDelta[o1, o2]}, 
   {0, (-I/2)*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
     (2*dMSfsq1[s1, s2, 3, j1] + dZSf1[s1, s2, 3, j1]*
       TheMass[S[13, {s1, j1}]]^2 + dZbarSf1[s2, s1, 3, j2]*
       TheMass[S[13, {s2, j2}]]^2)}}, 
 C[-S[14, {s1, j1, o1}], S[14, {s2, j2, o2}]] == 
  {{0, (-I/2)*(dZbarSf1[s2, s1, 4, j2] + dZSf1[s1, s2, 4, j1])*
     IndexDelta[j1, j2]*IndexDelta[o1, o2]}, 
   {0, (-I/2)*IndexDelta[j1, j2]*IndexDelta[o1, o2]*
     (2*dMSfsq1[s1, s2, 4, j1] + dZSf1[s1, s2, 4, j1]*
       TheMass[S[14, {s1, j1}]]^2 + dZbarSf1[s2, s1, 4, j2]*
       TheMass[S[14, {s2, j2}]]^2)}}, C[V[5, {g1}], V[5, {g2}]] == 
  {{0, I*dZGG1*IndexDelta[g1, g2]}, {0, 0}, 
   {0, (-I)*dZGG1*IndexDelta[g1, g2]}}, C[F[15, {g1}], F[15, {g2}]] == 
  {{0, (-I/2)*(dZbarGlL1 + dZGlL1)*IndexDelta[g1, g2]}, 
   {0, (I/2)*(dZbarGlR1 + dZGlR1)*IndexDelta[g1, g2]}, 
   {0, (-I/2)*IndexDelta[g1, g2]*(2*dMGl1 + (dZbarGlR1 + dZGlL1)*
       TheMass[F[15, {g1}]])}, {0, (-I/2)*IndexDelta[g1, g2]*
     (2*Conjugate[dMGl1] + (dZbarGlL1 + dZGlR1)*TheMass[F[15, {g1}]])}}
}


(* ------------------------ Renormalization constants ---------------------- *)

(* The following SM definitions of renormalization constants are
   for the on-shell renormalization of the MSSM in a scheme
   similar to A. Denner, Fortschr. d. Physik, 41 (1993) 4.

   The MSSM definitions of the renormalization constants 
   (except of the d-type squark sector) can be found in
   Phys. Rev. D 86, 035014 (2012) [arXiv:1111.7289].

   The renormalization constants are not directly used by
   FeynArts, and hence do not restrict the generation of diagrams
   and amplitudes in any way. *)

Clear[RenConst, xHC, xZf1, xZfL1, xZfR1, xZbarfL1, xZbarfR1, xZSf1]

ReDiag = Identity

ReOffDiag = Identity


xHC[Conjugate[mat_[j_, i_]]] := mat[i, j]

xHC[mat_[i_, j_]] := Conjugate[mat[j, i]]

xHC[x_] := Conjugate[x]


xZf1[f_, X_, dm_, s_] :=
Block[ {m = TheMass[f],
        se = ReDiag[SelfEnergy[f]],
        dse = ReDiag[DSelfEnergy[f]]},
  -X[se] - m^2 (LVectorCoeff[dse] + RVectorCoeff[dse]) -
             m (LScalarCoeff[dse] + RScalarCoeff[dse]) +
  s ((LScalarCoeff[se] - dm) - (RScalarCoeff[se] - xHC[dm]))/(2 m)
]

xZfL1[f_, dm_] := xZf1[f, LVectorCoeff, dm, +1]

xZfR1[f_, dm_] := xZf1[f, RVectorCoeff, dm, -1]

xZbarfL1[f_, dm_] := xZf1[f, LVectorCoeff, dm, -1]

xZbarfR1[f_, dm_] := xZf1[f, RVectorCoeff, dm, +1]


xZf1[proc_, m1_, m2_, X_, Y_, SX_, SY_, dm_] :=
Block[ {se = ReOffDiag[SelfEnergy[proc, m2]]},
  2/(m1^2 - m2^2) (m2 (m2 X[se] + m1 Y[se]) +
      m2 (SX[se] - xHC[dm]) + m1 (SY[se] - dm))
]

xZfL1[f1_, f2_, dm_] := xZf1[f2 -> f1, TheMass[f1], TheMass[f2],
  LVectorCoeff, RVectorCoeff, RScalarCoeff, LScalarCoeff, dm]

xZfR1[f1_, f2_, dm_] := xZf1[f2 -> f1, TheMass[f1], TheMass[f2],
  RVectorCoeff, LVectorCoeff, LScalarCoeff, RScalarCoeff, xHC[dm]]

xZbarfL1[f1_, f2_, dm_] := xZf1[f2 -> f1, TheMass[f2], TheMass[f1],
  LVectorCoeff, RVectorCoeff, LScalarCoeff, RScalarCoeff, xHC[dm]]

xZbarfR1[f1_, f2_, dm_] := xZf1[f2 -> f1, TheMass[f2], TheMass[f1],
  RVectorCoeff, LVectorCoeff, RScalarCoeff, LScalarCoeff, dm]


(* ---------------------- SM renormalization constants --------------------- *)

_UVMf1 = Identity

UVMf1[4, 3] = UVDivergentPart

RenConst[dMf1[t_, j1_]] := UVMf1[t, j1][MassRC[F[t, {j1}]]]


RenConst[dZfL1[t_, j1_, j1_]] := xZfL1[F[t, {j1}], 0]

RenConst[dZfR1[t_, j1_, j1_]] := xZfR1[F[t, {j1}], 0]

RenConst[dZbarfL1[t_, j1_, j1_]] := xZbarfL1[F[t, {j1}], 0]

RenConst[dZbarfR1[t_, j1_, j1_]] := xZbarfR1[F[t, {j1}], 0]


RenConst[dZfL1[t_, j1_, j2_]] := xZfL1[F[t, {j1}], F[t, {j2}], 0]

RenConst[dZfR1[t_, j1_, j2_]] := xZfR1[F[t, {j1}], F[t, {j2}], 0]

RenConst[dZbarfL1[t_, j1_, j2_]] := xZbarfL1[F[t, {j1}], F[t, {j2}], 0]

RenConst[dZbarfR1[t_, j1_, j2_]] := xZbarfR1[F[t, {j1}], F[t, {j2}], 0]


(* ------------------------------ Neutrinos -------------------------------- *)

RenConst[dZfL1[1, j1_, j1_]] := FieldRC[F[1, {j1}]][[1]]

RenConst[dZfR1[1, j1_, j1_]] := FieldRC[F[1, {j1}]][[2]]

RenConst[dZbarfL1[1, j1_, j1_]] := dZfL1[1, j1, j1]

RenConst[dZbarfR1[1, j1_, j1_]] := dZfR1[1, j1, j1]


(* ----------------------------- Vector bosons ----------------------------- *)

RenConst[dMZsq1] := MassRC[V[2]]

RenConst[dMWsq1] := MassRC[V[3]]

RenConst[dZAA1] := FieldRC[V[1]]

RenConst[dZAZ1] := FieldRC[V[1], V[2]]

RenConst[dZZA1] := FieldRC[V[2], V[1]]

RenConst[dZZZ1] := -ReDiag[DSelfEnergy[V[2]]]

RenConst[dZW1] := -ReDiag[DSelfEnergy[V[3]]]

RenConst[dZbarW1] := dZW1


(* --------------------------- Goldstone bosons ---------------------------- *)

RenConst[dZG01] := FieldRC[S[4]]

RenConst[dZGp1] := FieldRC[S[6]]


(* -------------------------- Dependent RenConst --------------------------- *)
(* ATTENTION: originally the counterterms have been generated with           *)
(*            SW -> SW - dSW1 instead of SW -> SW + dSW1                     *)
(*            therefore one has now to multiply dSW1 with -1 leading to:     *)
RenConst[dSW1] := CW^2 (dMZsq1/MZ^2 - dMWsq1/MW^2)/(2 SW)

RenConst[dZe1] := (SW/CW dZZA1 - dZAA1)/2


(* ----------------------------- CKM matrix -------------------------------- *)

If[ dCKM1[] =!= 0,
RenConst[dCKM1[j1_, j2_]] := 1/4 Sum[
  (dZfL1[3, j1, gn] - Conjugate[dZfL1[3, gn, j1]]) CKM[gn, j2] -
  CKM[j1, gn] (dZfL1[4, gn, j2] - Conjugate[dZfL1[4, j2, gn]]), {gn, 3} ]
]


(* --------------------- MSSM renormalization constants -------------------- *)


(* ------------------------------- tan(beta) ------------------------------- *)
(* The Higgs sector renormalization follows hep-ph/0611326:                  *)

ABRules = {CA -> 1, SA -> 0, CA2 -> 1, SA2 -> 0, C2A -> 1, S2A -> 0, 
	   CAB -> CB, SAB -> SB, CBA -> CB, SBA -> SB, 
	   SBA2 -> SB^2, CBA2 -> CB^2}

RenConst[dZH1] := -UVDivergentPart[Re[DSelfEnergy[S[2] -> S[2], 0]]] //. ABRules

RenConst[dZH2] := -UVDivergentPart[Re[DSelfEnergy[S[1] -> S[1], 0]]] //. ABRules

(* TB -> TB + dTB1 instead of                                                *)
(* TB -> TB (1 + dTB1) (= Eq. 50 in hep-ph/0611326):                         *)

RenConst[dTB1] := TB (dZH2 - dZH1)/2

RenConst[dSB1] := CB^3 dTB1

RenConst[dCB1] := -SB CB^2 dTB1


(* --------------------- Chargino/Neutralino sector ------------------------ *)

RenConst[dMNeuOS1[n_]] :=
  (MNeu[n] LVectorCoeff[#] + LScalarCoeff[#])& @
    ReTilde[SelfEnergy[F[11, {n}]]]

RenConst[dMChaOS1[c_]] :=
  (MCha[c]/2 (LVectorCoeff[#] + RVectorCoeff[#]) + LScalarCoeff[#])& @
    ReTilde[SelfEnergy[F[12, {c}]]]

RenConst[dZNeu1[n_]] :=
  2 CB^2 dTB1 (SB Conjugate[ZNeu[n, 3]] + CB Conjugate[ZNeu[n, 4]]) *
    (MW Conjugate[ZNeu[n, 2]] - MZ SW Conjugate[ZNeu[n, 1]]) +
  (CB Conjugate[ZNeu[n, 3]] - SB Conjugate[ZNeu[n, 4]]) *  
    (Conjugate[ZNeu[n, 1]] (dMZsq1/MZ SW + 2 MZ dSW1) - 
     Conjugate[ZNeu[n, 2]] dMWsq1/MW)

(* ----------------------------- CCN schemes ------------------------------- *)

CCN[n_][dMino11] :=
  ( dMNeuOS1[n] + dZNeu1[n] - Conjugate[ZNeu[n, 2]]^2 dMino21 +
    2 Conjugate[ZNeu[n, 3]] Conjugate[ZNeu[n, 4]] dMUE1 
  )/Conjugate[ZNeu[n, 1]]^2

CCN[n_][dMino21] :=
Block[ {ud, uo, vd, vo, uv, vu}, 
  ud = Conjugate[UCha[1, 1]] Conjugate[UCha[2, 2]];
  uo = Conjugate[UCha[1, 2]] Conjugate[UCha[2, 1]];
  vd = Conjugate[VCha[1, 1]] Conjugate[VCha[2, 2]];
  vo = Conjugate[VCha[1, 2]] Conjugate[VCha[2, 1]];
  uv = (ud - uo) Conjugate[VCha[1, 2]] Conjugate[VCha[2, 2]];
  vu = (vo - vd) Conjugate[UCha[1, 2]] Conjugate[UCha[2, 2]];
  ( Conjugate[UCha[1, 2]] Conjugate[VCha[1, 2]] dMChaOS1[2] -
    Conjugate[UCha[2, 2]] Conjugate[VCha[2, 2]] dMChaOS1[1] +
    Sqrt[2] CB^2 dTB1 MW (CB uv + SB vu) +
    dMWsq1/(Sqrt[2] MW) (SB uv - CB vu)
  )/(uo vo - ud vd)
]

CCN[n_][dMUE1] :=
Block[ {ud, uo, vd, vo, vu, uv},
  ud = Conjugate[UCha[1, 1]] Conjugate[UCha[2, 2]];
  uo = Conjugate[UCha[1, 2]] Conjugate[UCha[2, 1]];
  vd = Conjugate[VCha[1, 1]] Conjugate[VCha[2, 2]];
  vo = Conjugate[VCha[1, 2]] Conjugate[VCha[2, 1]];
  vu = Conjugate[VCha[1, 1]] Conjugate[VCha[2, 1]] (ud - uo);
  uv = Conjugate[UCha[1, 1]] Conjugate[UCha[2, 1]] (vo - vd);
  ( Conjugate[UCha[2, 1]] Conjugate[VCha[2, 1]] dMChaOS1[1] -
    Conjugate[UCha[1, 1]] Conjugate[VCha[1, 1]] dMChaOS1[2] -
    Sqrt[2] CB^2 dTB1 MW (SB vu + CB uv) +
    dMWsq1/(Sqrt[2] MW) (CB vu - SB uv)
  )/(uo vo - ud vd)
]

(* ------------------------------- CNN schemes ----------------------------- *)

ZNeuAx[i_][j_, k_] :=
  Conjugate[ZNeu[k, i]]^2 (dMNeuOS1[j] + dZNeu1[j]) -
  Conjugate[ZNeu[j, i]]^2 (dMNeuOS1[k] + dZNeu1[k])

ZNeuBx[i_][j_, k_] :=
  Conjugate[ZNeu[k, i]]^2 Conjugate[ZNeu[j, 3]] Conjugate[ZNeu[j, 4]] -
  Conjugate[ZNeu[j, i]]^2 Conjugate[ZNeu[k, 3]] Conjugate[ZNeu[k, 4]]

ZNeuCx[j_, k_] :=
  Conjugate[ZNeu[k, 2]]^2 Conjugate[ZNeu[j, 1]]^2 -
  Conjugate[ZNeu[j, 2]]^2 Conjugate[ZNeu[k, 1]]^2

CNN[c_, n__][dMino11] :=
  (ZNeuAx[2][n] + 2 ZNeuBx[2][n] dMUE1)/ZNeuCx[n]

CNN[c_, n__][dMino21] :=
  -(ZNeuAx[1][n] + 2 ZNeuBx[1][n] dMUE1)/ZNeuCx[n]

CNN[c_, n__][dMUE1] :=
Block[ {u1v1, u1v2, u2v1, u2v2},
   u1v1 = Conjugate[UCha[c, 1]] Conjugate[VCha[c, 1]];
   u1v2 = Conjugate[UCha[c, 1]] Conjugate[VCha[c, 2]];
   u2v1 = Conjugate[UCha[c, 2]] Conjugate[VCha[c, 1]];
   u2v2 = Conjugate[UCha[c, 2]] Conjugate[VCha[c, 2]];
   ( u1v1 ZNeuAx[1][n] +
     ZNeuCx[n] (dMChaOS1[c] -
       Sqrt[2] CB^2 dTB1 MW (CB u1v2 - SB u2v1) -
       dMWsq1/(Sqrt[2] MW) (SB u1v2 + CB u2v1))
   )/(ZNeuCx[n] u2v2 - 2 ZNeuBx[1][n] u1v1)
]


RenConst[dMino11] = $InoScheme /. s:_CCN | _CNN -> s[dMino11]

RenConst[dMino21] = $InoScheme /. s:_CCN | _CNN -> s[dMino21]

RenConst[dMUE1] = $InoScheme /. s:_CCN | _CNN -> s[dMUE1]


(* V^* dX^T U^+ *)
RenConst[dMCha1[i_, j_]] :=
  Array[Conjugate[VCha[i, #]]&, 2] .
  {{dMino21, Sqrt[2] (CB dMWsq1/(2 MW) - CB^2 SB MW dTB1)}, 
   {Sqrt[2] (SB dMWsq1/(2 MW) + CB^3 MW dTB1), dMUE1}} .
  Array[Conjugate[UCha[j, #]]&, 2]


RenConst[dMNeu1[i_, j_]] := dMNeu1[j, i] /; i > j

RenConst[dMNeu1[i_, j_]] :=
Block[ {m13, m14, m23, m24},
  m13 = -MZ CB dSW1 - SW CB dMZsq1/(2 MZ) + MZ SW CB^2 SB dTB1; 
  m14 =  MZ SB dSW1 + SW SB dMZsq1/(2 MZ) + MZ SW CB^2 CB dTB1; 
  m23 =  CB dMWsq1/(2 MW) - MW CB^2 SB dTB1; 
  m24 = -SB dMWsq1/(2 MW) - MW CB^2 CB dTB1; 
  Array[Conjugate[ZNeu[i, #]]&, 4] .
  {{dMino11, 0, m13, m14},
   {0, dMino21, m23, m24},
   {m13, m23, 0, -dMUE1},
   {m14, m24, -dMUE1, 0}} .
  Array[Conjugate[ZNeu[j, #]]&, 4]
]


RenConst[dZfL1[12, c1_, c1_]] := xZfL1[F[12, {c1}], dMCha1[c1, c1]]

RenConst[dZfR1[12, c1_, c1_]] := xZfR1[F[12, {c1}], dMCha1[c1, c1]]

RenConst[dZbarfL1[12, c1_, c1_]] := xZbarfL1[F[12, {c1}], dMCha1[c1, c1]]

RenConst[dZbarfR1[12, c1_, c1_]] := xZbarfR1[F[12, {c1}], dMCha1[c1, c1]]


RenConst[dZfL1[12, c1_, c2_]] :=
  xZfL1[F[12, {c1}], F[12, {c2}], dMCha1[c1, c2]]

RenConst[dZfR1[12, c1_, c2_]] :=
  xZfR1[F[12, {c1}], F[12, {c2}], dMCha1[c1, c2]]

RenConst[dZbarfL1[12, c1_, c2_]] :=
  xZbarfL1[F[12, {c1}], F[12, {c2}], dMCha1[c1, c2]]

RenConst[dZbarfR1[12, c1_, c2_]] :=
  xZbarfR1[F[12, {c1}], F[12, {c2}], dMCha1[c1, c2]]


RenConst[dZfL1[11, n1_, n1_]] := xZfL1[F[11, {n1}], dMNeu1[n1, n1]]

RenConst[dZfR1[11, n1_, n1_]] := xZfR1[F[11, {n1}], dMNeu1[n1, n1]]

RenConst[dZbarfL1[11, n1_, n1_]] := dZfR1[11, n1, n1]

RenConst[dZbarfR1[11, n1_, n1_]] := dZfL1[11, n1, n1]

RenConst[dZfL1[11, n1_, n2_]] :=
  xZfL1[F[11, {n1}], F[11, {n2}], dMNeu1[n1, n2]]

RenConst[dZfR1[11, n1_, n2_]] :=
  xZfR1[F[11, {n1}], F[11, {n2}], dMNeu1[n1, n2]]

RenConst[dZbarfL1[11, n1_, n2_]] := dZfR1[11, n2, n1]

RenConst[dZbarfR1[11, n1_, n2_]] := dZfL1[11, n2, n1]


(* --------------------------- Sfermion sector ----------------------------- *)

USf2[t_, g_][i__][j__] := USf[t, g][i] Conjugate[USf[t, g][j]]

RenConst[dMsq11Sf1[2, j1_]] :=
  dMSfsq1[1, 1, 1, j1] +
  2 TheMass[F[2, {j1}]] dMf1[2, j1] -
  C2B dMWsq1 + 4 MW^2 CB^3 SB dTB1

RenConst[dMsq11Sf1[4, j1_]] :=
  Abs[USf[3, j1][1, 1]]^2 dMSfsq1[1, 1, 3, j1] +
  Abs[USf[3, j1][1, 2]]^2 dMSfsq1[2, 2, 3, j1] -
  2 Re[USf2[3, j1][2, 2][1, 2] dMSfsq1[1, 2, 3, j1]] -
  2 TheMass[F[3, {j1}]] dMf1[3, j1] +
  2 TheMass[F[4, {j1}]] dMf1[4, j1] -
  C2B dMWsq1 + 4 MW^2 CB^3 SB dTB1

RenConst[dMsq12Sf1[4, j1_]] :=
  (Conjugate[Af[4, j1, j1]] - MUE TB) dMf1[4, j1] +
  (Conjugate[dAf1[4, j1, j1]] - dMUE1 TB - MUE dTB1) TheMass[F[4, {j1}]]


DR[_][dMSfsq1[1, 2, 4, j1_]] :=
  ( USf2[4, j1][1, 1][2, 1] (dMSfsq1[1, 1, 4, j1] - dMSfsq1[2, 2, 4, j1]) +
    USf2[4, j1][1, 1][2, 2] dMsq12Sf1[4, j1] -
    USf2[4, j1][1, 2][2, 1] Conjugate[dMsq12Sf1[4, j1]]
  )/(Abs[USf[4, j1][1, 1]]^2 - Abs[USf[4, j1][1, 2]]^2)

DR[_][dMSfsq1[2, 1, 4, j1_]] := Conjugate[dMSfsq1[1, 2, 4, j1]]

DR[s2_][dMSfsq1[s1_, s1_, 4, j1_]] :=
  ( Abs[USf[4, j1][1, s2]]^2 dMSfsq1[s2, s2, 4, j1] +
    (s2 - s1) (2 Re[USf2[4, j1][1, 1][1, 2] dMsq12Sf1[4, j1]] +
      (Abs[USf[4, j1][1, 1]]^2 - Abs[USf[4, j1][1, 2]]^2) dMsq11Sf1[4, j1])
  )/Abs[USf[4, j1][1, s1]]^2 /; s1 =!= s2

DR[_][dMSfsq1[s2_, s2_, t_, j1_]] :=
  MassRC[S[t + 10, {s2, j1}], S[t + 10, {s2, j1}]]


OS[s2_][dMSfsq1[s1_, s1_, t_, j1_]] :=
  ( -Abs[USf[t, j1][1, s2]]^2 dMSfsq1[s2, s2, t, j1] +
    2 Re[USf2[t, j1][2, 2][1, 2] dMSfsq1[1, 2, t, j1]] +
    dMsq11Sf1[t, j1]
  )/Abs[USf[t, j1][1, s1]]^2 /; s1 =!= s2

OS[_][dMSfsq1[s1_, s2_, t_, j1_]] :=
  MassRC[S[t + 10, {s1, j1}], S[t + 10, {s2, j1}]]


RenConst[dMSfsq1[1, 1, 1, j1_]] := MassRC[S[11, {j1}]]

RenConst[dMSfsq1[s1_, s2_, 3, j1_]] :=
  MassRC[S[13, {s1, j1}], S[13, {s2, j1}]]

RenConst[dMSfsq1[s1_, s2_, t:2|4, j1_]] :=
  $SfScheme[t, j1] /. s:_OS | _DR :> s[dMSfsq1[s1, s2, t, j1]]


RenConst[dZSf1[1, 1, 1, j1_]] := -ReDiag[DSelfEnergy[S[11, {j1}]]]

RenConst[dZSf1[s1_, s1_, t_, j1_]] := -ReDiag[DSelfEnergy[S[t + 10, {s1, j1}]]]

RenConst[dZbarSf1[s1_, s1_, t_, j1_]] := dZSf1[s1, s1, t, j1]


xZSf1[s1_, s2_, t_, j1_][os_] :=
Block[ {sf1 = S[t + 10, {s1, j1}], sf2 = S[t + 10, {s2, j1}]},
  2/(TheMass[sf1]^2 - TheMass[sf2]^2) (
    ReOffDiag[SelfEnergy[sf2 -> sf1, TheMass[S[t + 10, {os, j1}]]]] -
    dMSfsq1[s1, s2, t, j1] )
]

RenConst[dZSf1[1, 2, t_, j1_]] := xZSf1[1, 2, t, j1][2]

RenConst[dZSf1[2, 1, t_, j1_]] := xZSf1[2, 1, t, j1][1]

RenConst[dZbarSf1[1, 2, t_, j1_]] := -xZSf1[2, 1, t, j1][2]

RenConst[dZbarSf1[2, 1, t_, j1_]] := -xZSf1[1, 2, t, j1][1]


DR[_][dAf1[4, j1_, j1_]] :=
Block[ {dMSd1sq, dMSd2sq, dYd, dMUEdr},
  dMSd1sq = MassRC[S[14, {1, j1}]];
  dMSd2sq = MassRC[S[14, {2, j1}]];
  dYd = MassRC[S[14, {1, j1}], S[14, {2, j1}]];
  dMUEdr = RenConst[dMUE1] //. {
    d:_dMChaOS1 | _dMNeuOS1 | dMWsq1 | dMZsq1 :> UVDivergentPart[RenConst[d]],
    d:dSW1 | _dZNeu1 :> RenConst[d] };
  UVDivergentPart[
    ( USf2[4, j1][1, 1][1, 2] (dMSd1sq - dMSd2sq) +
      USf2[4, j1][1, 1][2, 2] Conjugate[dYd] +
      USf2[4, j1][2, 1][1, 2] dYd -
      (Af[4, j1, j1] - Conjugate[MUE] TB) RenConst[dMf1[4, j1]]
    )/TheMass[F[4, {j1}]]
  ] + Conjugate[dMUEdr] TB + Conjugate[MUE] dTB1
]

OS[_][dAf1[t:2|4, j1_, j1_]] :=
  ( USf2[t, j1][1, 1][1, 2] (dMSfsq1[1, 1, t, j1] - dMSfsq1[2, 2, t, j1]) +
    USf2[t, j1][1, 1][2, 2] Conjugate[dMSfsq1[1, 2, t, j1]] +
    USf2[t, j1][2, 1][1, 2] dMSfsq1[1, 2, t, j1] -
    (Af[t, j1, j1] - Conjugate[MUE] TB) dMf1[t, j1]
  )/TheMass[F[t, {j1}]] +
  Conjugate[dMUE1] TB + Conjugate[MUE] dTB1


RenConst[dAf1[3, j1_, j1_]] :=
  ( USf2[3, j1][1, 1][1, 2] (dMSfsq1[1, 1, 3, j1] - dMSfsq1[2, 2, 3, j1]) +
    USf2[3, j1][1, 1][2, 2] Conjugate[dMSfsq1[1, 2, 3, j1]] +
    USf2[3, j1][2, 1][1, 2] dMSfsq1[1, 2, 3, j1] -
    (Af[3, j1, j1] - Conjugate[MUE]/TB) dMf1[3, j1]
  )/TheMass[F[3, {j1}]] +
  Conjugate[dMUE1]/TB - Conjugate[MUE] dTB1/TB^2

RenConst[dAf1[4, j1_, j1_]] := $SfScheme[4, j1] /.
  s:_OS | _DR :> s[dAf1[4, j1, j1]]

RenConst[dAf1[t_, j1_, j1_]] = OS[-1][dAf1[t, j1, j1]]


(* --------------------------------- SQCD ---------------------------------- *)

RenConst[dMGl1] := MassRC[F[15]] SqrtEGl^2

RenConst[dZGlL1] := xZfL1[F[15], 0]

RenConst[dZGlR1] := xZfR1[F[15], 0]

RenConst[dZbarGlL1] := dZGlR1

RenConst[dZbarGlR1] := dZGlL1

RenConst[dZGG1] := UVDivergentPart[FieldRC[V[5]]]

RenConst[dZgs1] := dZGG1/2


(* ---------------------------- Higgs sector ------------------------------- *)
(* The dMHiggs1 follow hep-ph/0611326.                                       *)
(* TB -> TB (1 + dTB1) (= Eq. 50 in hep-ph/0611326) instead of               *)
(* TB -> TB + dTB1 makes it necessary to replace dTB1 -> dTB1/TB:            *)

RenConst[dTh01] := TadpoleRC[S[1]]

RenConst[dTHH1] := TadpoleRC[S[2]]

RenConst[dTA01] := TadpoleRC[S[3]]


dMHconst = EL/(2 MZ SW CW)

If[ TrueQ[$MHpInput],
RenConst[dMHiggs1[5, 5]] := ReTilde[SelfEnergy[S[5] -> S[5], MHptree]];
RenConst[dMHiggs1[3, 3]] := dMHiggs1[5, 5] - dMWsq1;
RenConst[dMHiggs1[3, 4]] :=
  dMHconst (dTHH1 SBA - dTh01 CBA) - dTB1 CB^2 (MHptree^2 - MW^2),
(* else *)
RenConst[dMHiggs1[3, 3]] := ReTilde[SelfEnergy[S[3] -> S[3], MA0tree]];
RenConst[dMHiggs1[5, 5]] := dMHiggs1[3, 3] + dMWsq1;
RenConst[dMHiggs1[3, 4]] :=
  dMHconst (dTHH1 SBA - dTh01 CBA) - dTB1 CB^2 MA0tree^2
]

RenConst[dMHiggs1[1, 1]] := (dMHiggs1[3, 3] CBA^2 + dMZsq1 SAB^2 + 
   dMHconst (dTHH1 CBA SBA^2 - dTh01 SBA (1 + CBA^2)) +
   2 dTB1 CB^2 (MZ^2 SAB CAB - MA0tree^2 SBA CBA))

RenConst[dMHiggs1[2, 2]] := (dMHiggs1[3, 3] SBA^2 + dMZsq1 CAB^2 -
   dMHconst (dTHH1 CBA (1 + SBA^2) - dTh01 SBA CBA^2) -
   2 dTB1 CB^2 (MZ^2 SAB CAB - MA0tree^2 SBA CBA))

RenConst[dMHiggs1[4, 4]] := -dMHconst (dTHH1 CBA + dTh01 SBA)

RenConst[dMHiggs1[1, 2]] := -dMHiggs1[3, 3] SBA CBA - dMZsq1 SAB CAB -
   dMHconst (dTHH1 SBA^3 + dTh01 CBA^3) -
   dTB1 CB^2 (MA0tree^2 (CBA^2 - SBA^2) + MZ^2 (CAB^2 - SAB^2))

RenConst[dMHiggs1[1, 3]] := -dMHconst SBA dTA01

RenConst[dMHiggs1[1, 4]] := +dMHconst CBA dTA01

RenConst[dMHiggs1[2, 3]] := -dMHconst CBA dTA01

RenConst[dMHiggs1[2, 4]] := -dMHconst SBA dTA01

RenConst[dMHiggs1[6, 6]] := dMHiggs1[4, 4]

(* To be consistent with the FA/FC convention: Sigma_ij <--> j -> i,         *)
(* we changed the sign of I dTA01:                                           *)
RenConst[dMHiggs1[5, 6]] :=
  dMHconst (dTHH1 SBA - dTh01 CBA + I dTA01) - dTB1 CB^2 MHptree^2

RenConst[dMHiggs1[6, 5]] := Conjugate[dMHiggs1[5, 6]]


RenConst[dZHiggs1[1, 1]] := (SA^2 dZH1 + CA^2 dZH2)
RenConst[dZHiggs1[2, 2]] := (CA^2 dZH1 + SA^2 dZH2)
RenConst[dZHiggs1[3, 3]] := (SB^2 dZH1 + CB^2 dZH2)
RenConst[dZHiggs1[4, 4]] := (CB^2 dZH1 + SB^2 dZH2)
RenConst[dZHiggs1[1, 2]] := (SA CA (dZH2 - dZH1))
RenConst[dZHiggs1[1, 3]] := 0
RenConst[dZHiggs1[1, 4]] := 0
RenConst[dZHiggs1[2, 3]] := 0
RenConst[dZHiggs1[2, 4]] := 0
RenConst[dZHiggs1[3, 4]] := (SB CB (dZH2 - dZH1))

(* RenConst[dZHiggs1[5, 5]] := dZHiggs1[3, 3] leads to IR divergent results. *)
(* For proper on-shell conditions: add dZ^hat, see arXiv:1111.7289.          *)
(* This cancels dZHiggs1[3, 3], leading to an IR finite result.              *)
RenConst[dZHiggs1[5, 5]] := -ReDiag[DSelfEnergy[S[5] -> S[5], MHptree]]

RenConst[dZbarHiggs1[5, 5]] := dZHiggs1[5, 5]

RenConst[dZHiggs1[6, 6]] := dZHiggs1[4, 4]

RenConst[dZHiggs1[5, 6]] := dZHiggs1[3, 4]

RenConst[dZHiggs1[6, 5]] := dZHiggs1[3, 4]


General::badscheme = "Illegal scheme choice ``."

s_DR[___] := (Message[DR::badscheme, s]; Abort[])

s_OS[___] := (Message[OS::badscheme, s]; Abort[])

s_CCN[___] := (Message[CCN::badscheme, s]; Abort[])

s_CNN[___] := (Message[CNN::badscheme, s]; Abort[])

