(*
	SetUp.m
		FeynArts startup file
		last modified 4 Jun 98 th

Here you can set up your own changes and enhancements to FeynArts,
e.g. some particular options you always want set, or $SVMixing = True.
It is a good idea to do this here since changing the FeynArts code 
directly is inherently unportable.

*)


$Verbose = 2

$ModelDir = $FeynArtsDir <> "Models/"

$TopologyDataDir = $FeynArtsDir <> "GraphInfo/"

$SVMixing = False

$CounterTerms = True

$FermionLines = True

	(* eliminate those `>' in front of continuation lines so
	   one can cut and paste more easily *)
Format[ Continuation[_] ] = "    "

