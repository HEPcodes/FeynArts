(*

This is FeynArts, Version 1.2
Copyright by Sepp Kueblbeck and Hagen Eck 1991
algorithms by Ansgar Denner
last revision: 1 Dec 97 by Thomas Hahn

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
   somewhere in your documentation that you've used
   our code.

If you're a lawyer, you can find the legal stuff at
http://www.fsf.org/copyleft/lgpl.html.

If you make this software available to others please
also provide them with the manual FA1guide.ps.

If you find any bugs, or want to make suggestions, or
just write fan mail, address it to:
	Thomas Hahn
	Institut fuer theoretische Physik
	Universitaet Karlsruhe
	email: hahn@particle.physik.uni-karlsruhe.de

Technical note:
Before loading FeynArts.m into Mathematica, set $Path to
contain this directory.

Have fun!

*)

Begin["FeynArts`"]

(* Font definitions: *)

$ScreenTextFont = {"Courier",10};             
$SmallScreenTextFont = {"Courier",8};   
$ScreenSymbolFont = None; 
$SmallScreenSymbolFont = None; 

$PrinterTextFont = {"Helvetica",10};
$SmallPrinterTextFont = {"Helvetica",8};
$PrinterSymbolFont = {"Symbol",10};
$SmallPrinterSymbolFont = {"Symbol",8};
$DefaultFont=$PrinterTextFont;

(* Translation rules for devices without the Symbol font *)

NoGreek["c"] = "x";		(* chi *)
NoGreek["g"] = "A";		(* gamma *)
NoGreek["j"] = "fi";		(* phi *)
NoGreek["m"] = "m";		(* mu *)
NoGreek["n"] = "n";		(* nu *)
NoGreek["t"] = "l";		(* tau *)

(* Field and Model variables *)

Models = { SM, QED, QCD, QE, QC, WEYL, YOT, BGF, SMbgf };
  (* the models FeynArts knows of *)
SingleModels = { QE, QC, WEYL, YOT };
  (* models which cannot be combined with any of the other Models *)
Fieldtypes = { F, G, S, V, U };
  (* field types FeynArts knows of *)

Global`ExcludeParticles[___] = PL[];
  (* particles excluded from internal lines *)

(* uncomment the following line if you want M_photon=0 from the outset *)
(* Global`MLA = 0; *)

FeynArtsNullDevice = "FeynArts.log";

End[]

Print[" "];
Print["FeynArts 1.2 for Mathematica"];
Print["by Hagen Eck and Sepp Kueblbeck"];
Print["last revision: 1 Dec 97 by Thomas Hahn"];
Print["[additional packages being loaded]"];

<< General.m;
<< CreateTopologies.m;
<< InsertFields.m;
<< CreateFeynAmp.m;
<< Paint.m;

