(*
	Paint.m
		graphics routines
		last change: 1 Dec 97 by TH
*)

BeginPackage["Paint`", {"FeynArts`","InsertFields`"}]

Paint::usage =
"Paint[t, v, h, options] returns a Graphic object of graph t.
v and h are vertical and horizontal offset respectively."

SaveGraphInfo::usage =
"SaveGraphInfo[] saves the graphpoint information used for drawing
topologies to disk."

FeynEdit::usage =
"FeynEdit[topology] is an interactive topology editor. It works for
inserted as well as for bare topologies. For bare topologies the usage is:
FeynEdit[topology, NrOfInc, NrOfOut], for inserted ones just
FeynEdit[topology]. FeynEdit is invoked automatically when Paint is called
with the option AutoEdit -> True."

PaintScaling::usage =
"PaintScaling gives the number of gridpoints when drawing a Feynman
graph."

GrayBackground::usage =
"GrayBackground is an option of Paint."

ShowGrid::usage =
"ShowGrid is an option of Paint that shows the grid (with dimensions
PaintScaling * PaintScaling) on which the vertices are located."

ShowPointNames::usage =
"ShowPointNames is an option of Paint that displays the names of the
vertices in a Feynman graph."

GraphsPerRow::usage =
"GraphsPerRow is an option of Paint (default: 3)."

RowsPerSheet::usage =
"RowsPerSheet is an option of Paint (default: 3)."

AutoEdit::usage =
"AutoEdit is an option of Paint that determines whether FeynEdit
should be called automatically for an undefined topology."

ScreenOutput::usage =
"ScreenOutput is an option of Paint that determines whether screen
output is desired or not. If ScreenOutput is set to False, Paint
will return a Graphics object."

PSFileOutput::usage =
"PSFileOutput is an option of Paint that determines whether the
graphics will be written to a PostScript file."

PropagatorThickness::usage =
"PropagatorThickness is an option of Paint that determines the
thickness of the propagators."

VertexSize::usage = 
"VertexSize is an option of Paint that determines the size of the
internal fieldpoints of a Feynman graph."

FullNumbering::usage =
"FullNumbering is an option of Paint that determines whether the
graph number is appended to the name of the Feynman graphs."

FeynArtsGraphics::usage =
"FeynArtsGraphics is an graphics object returned by the FeynArts Paint
routine."

DrawLine::usage =
"DrawLine[from, to, center, particle, scale] draws a propagator line of
particle. The line is straight for center = 0 and part of a circle for
center = {xcoord,ycoord}. scale is the total width of the graph."
    
Orientation::usage =
"Orientation[{x1,y1}, {x2,y2}] gives the angle of this line against the
x axis."

GraphPoints::usage =
"GraphPoints[bare topology, ninc, nout] returns a list of coordinates
for the field points."

Begin["`Private`"]

Options[Paint] = {
  GraphsPerRow -> 3,
  RowsPerSheet -> 3,
  ScreenOutput -> True,
  PSFileOutput -> True,
  ScreenMessages -> True,
  AutoEdit -> True,
  FullNumbering -> True,
  GrayBackground -> False,
  ShowGrid -> False,
  ShowPointNames -> False,
  PropagatorThickness -> Automatic,
  VertexSize -> Automatic
}

PaintScaling = 20

NPi = N[Pi]

FeynArtsGraphics/: Show[ FeynArtsGraphics[ fag___ ] ] :=
  (Show[fag]; FeynArtsGraphics[fag])

Unprotect[Show]

Show[ h:{(_FeynArtsGraphics)[__], ___} ] := Show/@ h

Protect[Show]

Format[ FeynArtsGraphics[___] ] = "-FeynArtsGraphics-"

(* rules to set outputfont *)

ScreenFontRule = {
  FontForm[Greek[a_], OutFont] :> FontForm[a, $ScreenSymbolFont],
  FontForm[Greek[a_], SmallOutFont] :> FontForm[a, $SmallScreenSymbolFont],
  FontForm[a_, OutFont] :> FontForm[a, $ScreenTextFont],
  FontForm[a_, SmallOutFont] :> FontForm[a, $SmallScreenTextFont],
  FontForm[a_, None] :> FontForm[NoGreek[a], $ScreenTextFont]
}

PrinterFontRule = {
  FontForm[Greek[a_], OutFont] :> FontForm[a, $PrinterSymbolFont],
  FontForm[Greek[a_], SmallOutFont] :> FontForm[a, $SmallPrinterSymbolFont],
  FontForm["-", SmallOutFont] :> FontForm["-", $SmallPrinterSymbolFont],
  FontForm[a_, OutFont] :> FontForm[a, $PrinterTextFont],
  FontForm[a_, SmallOutFont] :> FontForm[a, $SmallPrinterTextFont],
  FontForm[a_, None] :> FontForm[NoGreek[a], $PrinterTextFont]
}

FontText[ Sub[a_,b_], pos_ ] :=
  Sequence[ FontText[a, pos],
    Text[ FontForm[b,SmallOutFont],
      {totalwidth/2.+PaintScaling*pos/10., 1.05*totalheight}, {-2.5,1} ] ]

FontText[ a_, pos_ ] :=
  Text[ FontForm[a,OutFont],
    {totalwidth/2.+PaintScaling*pos/10., 1.05*totalheight} ]

FinishPage := (
  onesheet = Graphics[ Join[onesheet, graphheader], 
    AspectRatio -> 1, PlotRange -> {plotrange,plotrange} ];
  If[ ScreenOutput /. localoptions,
    Show[onesheet //. ScreenFontRule] ];
  AppendTo[returngraphics, onesheet];
  If[ psfileoutput,
    ++page;
    WriteString[outfile,
      "%%Page: ",ToString[page]," ",ToString[page],"\n"];
    Display[outfile, onesheet //. PrinterFontRule];
    WriteString[outfile, "showpage\n",
      "/Mwidth 8.5 72 mul def\n",
      "/Mheight 11 72 mul def\n"];
  ];
  onesheet = {} );

(* main draw routine *)

Paint[ TopologyList[descr__][ insertedtopologies__ ], opt___Rule ] :=
Block[ {localoptions, graphsperrow, rowspersheet,
totalheight, totalwidth, plotrange, currenttopology, currentgraph, 
graphoptions, graphname, graphheader, screenmessages, t, len, x,
psfileoutput, outfile, sheetposition, ct, cg, lt, lg, xoffset, yoffset,
onesheet = {}, graphnr = 0, returngraphics = {}, page = 0,
xscale = 1.2*PaintScaling, yscale = PaintScaling},

  localoptions = ActualOptions[Paint, opt];
  If[ (Model /. {descr}) === {Topology},
    graphname := GraphName[ct,0,0,0];
    outfile = "Topologies.mps",
  (* else *)
    If[ FullNumbering /. localoptions,
      graphname := GraphName[ct,cg,graphnr],
      graphname := GraphName[ct,cg] ];
    outfile = ToString[ProcessName /. {descr}]<>".mps";
    If[ CheckModel[ Join[{descr},
      Select[localoptions,!FreeQ[#,ScreenMessages]&]] ] === $Aborted, 
      Return[$Aborted] ];
  ];

  graphsperrow = GraphsPerRow /. localoptions;
  rowspersheet = RowsPerSheet /. localoptions;
  totalwidth = graphsperrow*xscale;
  totalheight = rowspersheet*yscale;
  plotrange = {-1.,Max[totalheight,totalwidth]};
  If[ !(screenmessages = ScreenMessages /. localoptions),
    $Output = {FeynArtsNullDevice} ];
  If[ psfileoutput = PSFileOutput /. localoptions,
    If[ FileType[outfile] === None,
      Print["write to file ",outfile],
      Print["overwrite file ",outfile] ];
    outfile = OpenWrite[outfile]
  ];
  graphoptions = Sequence[ opt,
    ScreenOutput -> False,
    PropagatorThickness -> (PropagatorThickness /. localoptions /.
      Automatic -> 25./graphsperrow/rowspersheet),
    VertexSize -> (VertexSize /. localoptions /.
      Automatic -> N[9./Sqrt[graphsperrow*rowspersheet]]) ];

  lt = Length[{insertedtopologies}];
  Do[
    currenttopology = {insertedtopologies}[[ct]];
    WriteString[$Output,"top. ",ToString[ct]];
    lg = Length[Last[currenttopology]];
    Do[
      currentgraph = Append[ Drop[currenttopology, -1],
        Insertions[ currenttopology[[-1,cg]] ] ];
      sheetposition = Mod[graphnr, graphsperrow*rowspersheet];
      If[sheetposition === 0 && onesheet =!= {}, FinishPage];
      If[ ++graphnr === 1,
        graphheader = MakeGraphHeader[Drop[currentgraph,-1] /.
          (List@@ currentgraph[[-1,1]])];
        len = StringLength[StringJoin[# /.
          {Sub -> List, Greek -> List}]]&/@ graphheader;
        t = -0.5*(Plus@@ len);
        graphheader = 
          Array[FontText[graphheader[[#]], (t+=len[[#]])-len[[#]]/2.]&, 
            Length[graphheader]];
      ];
      If[screenmessages, Print["\tins. ",cg," (#",graphnr,")"]];
      xoffset = Mod[sheetposition, graphsperrow]*xscale;
      yoffset = (rowspersheet-1-
        Quotient[sheetposition, graphsperrow])*yscale;
      t = PaintSingle[currentgraph, yoffset, xoffset,
        graphname, graphoptions];
      AppendTo[ onesheet,
        If[ t === $Aborted,
          {Text["? ? ?",{xoffset+10.,yoffset+10.}]},
          List@@ t ] ],
    {cg, lg}],
  {ct, lt}];
  If[onesheet =!= {}, FinishPage];
  If[ psfileoutput,
    WriteString[outfile, "%%Trailer\n"];
    Close[outfile] ];
  $Output = {"stdout"};
  FeynArtsGraphics/@ (returngraphics //. ScreenFontRule)
]

(* special cases *)

Paint[ tt:Topology[_][___, _Insertions], opt___Rule ] :=
  Paint[ TopologyList[Model -> {Topology}][tt], opt ]

Paint[ tt:Topology[_][Propagator[_][__]..],
  ninc_Integer, nout_Integer, options___Rule ] :=
  Paint[ TopologyList[tt], ninc, nout,
    GraphsPerRow -> 2, RowsPerSheet -> 2, options ]

Paint[ TopologyList[baretopologies__],
  ninc_Integer, nout_Integer, options___Rule ] :=
  Paint[ InsertFields[TopologyList[baretopologies],ninc,nout], options ]

(* draw one single graph (construct the graphics primitives) *)

PaintSingle[ tt:Topology[__,_Insertions],
  yoff_, xoff_, GraphName[t___], opt___Rule ] :=
Block[ {graphprim, labelprim},
  labelprim = { Text[ FontForm[
    Switch[ Length[{t}],
      1, "Ins. "<>ToString[{t}[[1]] ],
      2, "Top. "<>ToString[{t}[[1]] ]<>" Ins. "<>ToString[{t}[[2]] ],
      3, "Top. "<>ToString[{t}[[1]] ]<>" Ins. "<>ToString[{t}[[2]] ]<>
           "-"<>ToString[{t}[[3]] ],
      _, "Top. "<>ToString[{t}[[1]] ] ], OutFont],
    {0.2+xoff,0.2+yoff}, {-1,-1} ] };
  graphprim = PaintSingle[tt, yoff, xoff, opt, ScreenOutput -> False];
  If[ graphprim === $Aborted, Return[$Aborted] ];
  graphprim = Graphics[Join[List@@ graphprim, labelprim]];
  If[ ScreenOutput /. {opt} /. Options[Paint],
    Join[ graphprim, Graphics[AspectRatio -> 1,
       PlotRange -> {{-0.5,0.5+PaintScaling+xoff},
                     {-0.5,0.5+PaintScaling+yoff}}] ];
    Show[graphprim];
  ];
  graphprim
]

PaintSingle[ Topology[ props__, Insertions[vers:Graph[_][__]] ], 
  voff_, hoff_, opt___Rule ] :=
Block[ {localoptions, ninc, nout, baretop, thefields,
propagatorthickness, vertexsize, thelines, graphinfo,
feynartsgraphic = {} },

  localoptions = ActualOptions[Paint, opt];

(* separate topological and field information *)

  baretop = Sort[ Sort/@ (Take[#,2]&/@ Topology[props]) /.
    {inc -> zzx, out -> zzy}] /. {zzx -> inc, zzy -> out};
  thefields = #[[3]]&/@ Sort[Topology[props] /. 
    {inc -> zzx, out -> zzy}] /. {zzx -> inc, zzy -> out};

(* get point locations or call FeynEdit or abort *)

  ninc = NumberOfInc[baretop];
  nout = NumberOfOut[baretop];
  graphinfo = GraphPoints[baretop, ninc, nout];
  If[ Head[graphinfo] =!= List,
    If[ AutoEdit /. localoptions,
      FeynEdit[baretop, ninc, nout];
      graphinfo = GraphPoints[baretop, ninc, nout],
    (* else *)
      Print["No point specifications for this topology!"];
      Print["(use FeynEdit first)"];
      Return[$Aborted] 
    ]
  ];
  graphinfo = graphinfo /.
    {a_?NumberQ,b_?NumberQ} :> N[{a+hoff,b+voff}];

  propagatorthickness =
    PropagatorThickness /. localoptions /. Automatic -> 4;
  vertexsize = VertexSize /. localoptions /. Automatic -> 4;

  thelines = (Append@@ #)&/@
    Transpose[ {List@@ baretop,graphinfo[[1]]} ];
  thelines = (Append@@ #)&/@
    Transpose[ {thelines, List@@ thefields} ];
  thelines = thelines /. List@@ vers /. graphinfo[[2]] //.
    (li:{a___, pr:Propagator[type_][v___, DummyField[1]], b___} :>
       {a, Propagator[type][v,Position[li,pr][[1,1]] ], b});
  thelines = thelines /. Propagator[_][ins__] :>
    DrawLine[ins, PaintScaling, propagatorthickness];

  If[ GrayBackground /. localoptions,
    AppendTo[feynartsgraphic, FeynRaster[PaintScaling]] ];
  If[ ShowGrid /. localoptions,
    feynartsgraphic = Join[ feynartsgraphic,
      Prepend[FeynGrid[PaintScaling], PointSize[.01]] ] ];
  feynartsgraphic = Join[
    feynartsgraphic /. {a_?NumberQ,b_?NumberQ} :> N[{a+hoff,b+voff}],
    VertexPlot[graphinfo, vertexsize, ShowPointNames /. localoptions],
    {PointSize[.00001], Point[{0.,0.}]},
    thelines ];
  If[ ScreenOutput /. localoptions,
    Show[ Graphics[feynartsgraphic //. ScreenFontRule,
      AspectRatio -> 1,
      PlotRange -> {{-0.5+hoff,0.5+PaintScaling+hoff},
                    {-0.5+voff,0.5+PaintScaling+voff}}] ] ];
  Graphics[feynartsgraphic]
]

MakeGraphHeader[ Topology[ inserted__ ] ] := 
Block[{incoming,outgoing},
  incoming = #[[3]]&/@ Select[{inserted}, MatchQ[#,Propagator[inc][__]]&];
  outgoing = #[[3]]&/@ Select[{inserted}, MatchQ[#,Propagator[out][__]]&];
  If[ incoming[[1,0]] === InsertFields`Private`TopDummy,
    Return[{"Top.", ToString[Length[incoming]], " --> ",
      ToString[Length[outgoing]]}]
  ];
  incoming = {#," + "}&/@ (LineSpec[#][[3]]&/@ incoming);
  outgoing = {#," + "}&/@ (LineSpec[#][[3]]&/@ outgoing);
  Flatten[{Drop[Flatten[incoming],-1], " --> ",
    Drop[Flatten[outgoing],-1]}]
]

NumberOfInc[ top_ ] := Count[top, Propagator[inc][_,_]]

NumberOfOut[ top_ ] := Count[top, Propagator[out][_,_]]

(* make a list of bigger points *)

VertexPlot[ {_List, vertices_List}, size_, shownames_ ] :=
Block[ {primitive, vplot},
  primitive = Select[vertices, !MatchQ[#, e[_] -> _]&];
  vplot = Prepend[ primitive /. (_ -> coord_) :> Point[N[coord]],
    PointSize[0.005*size] ];
  If[ shownames,
    vplot = Append[ vplot, primitive /. (point_ -> coord_) :>
      Text[ToString[point], N[0.5+coord], {-1,-1}] ] ];
  vplot
]

(* orientation of baseline *)

Orientation[ p1_, p2_ ]:= N[ArcTan@@ (p2-p1)]

(* constructing an arrow *)

Arrow[ xy_, linedirection_, orientation_, arrowlength_ ] :=
Block[ {a1, a2, xym, len = 2.5*arrowlength,
forward = NPi, backward = 0, thedir},
  thedir = linedirection + orientation;
  xym = xy - len/2.*{Cos[thedir],Sin[thedir]};
  {a1,a2} = thedir - {NPi/10.,-NPi/10.};
  {Polygon[ {xym+len*{Cos[a1],Sin[a1]}, xym, xym+len*{Cos[a2],Sin[a2]}} ]}
]

(* info about line form *)

LineFlags[wavy]    = Sequence[1,0,False,False];
LineFlags[cycloid] = Sequence[1,1,False,False];
LineFlags[dashed]  = Sequence[0,0,True, False];
LineFlags[dotted]  = Sequence[0,0,False,True ];
LineFlags[_]       = Sequence[0,0,False,False];

GetLineFlags[ i_Integer ] :=
  { LineFlags[straight], none, ToString[Global`c[i]] }

GetLineFlags[ part:_[__] ] :=
Block[ {lineinfo},
  lineinfo[ part ] = lineinfo[];
  lineinfo[ ltyp_:straight, ldir_:none, lsym_:ToString[part] ] :=
    { LineFlags[ltyp], ldir, lsym };
  lineinfo@@ LineSpec[part]
]

DrawLine[ from_, to_, center_, particle_, scaling_, thick_ ] :=
Block[ {ctr, mid, lengthab, lengthac, height, radius,
omegaab, omegaac, omegamc, alpha, drawpoints, phaseamp, wavenumber,
frac, angle, XY1, XY2, symb,
graphprim1, graphprim2, labelprim, thickprim,
flAmpl, flPhas, flDash, flDots, flArro, flTad},

  {flAmpl,flPhas,flDash,flDots,flArro,symb} = GetLineFlags[particle];
  lengthab = Sqrt[#.#& @ (to-from)]//N;
  omegaab = If[ flTad = (to === from), 0., Orientation[from,to] ];
  ctr = If[ center === 0,
    If[flTad, from+{0.,2.}, 0.5*(from+to)],
    center ]//N;
  lengthac = Sqrt[#.#& @ (ctr-from)]//N;
  omegaac = Orientation[from, ctr];
  perp = NPi/2.*
    If[ center === 0, 1,
      If[# == 0, 1, #]& @
      (Sign[omegaab-omegaac]*
        If[omegaac>-NPi/2. && omegaac<NPi/2.,
          1, Sign[omegaac]*Sign[omegaab] ])
    ];
  omegamc = If[flTad, omegaac, Mod[omegaab-perp+NPi,2.*NPi]-NPi];
  If[ flTad,
    mid = 0.5*(from+ctr);
    radius = lengthac/2.;
    alpha = 2.*NPi,
  (* else *)
    If[ center === 0,
      radius  = 100.*scaling;
      alpha   = 2.*ArcSin[lengthab/2/radius]//N;
      height  = Abs[lengthab/2/Tan[alpha/2]]//N,
    (* else *)
      height  = Sqrt[lengthac^2-(lengthab/2.)^2]//N;
      alpha   = 4.*ArcTan[2.*height/lengthab]//N;
      radius  = lengthab/2./Sin[alpha/2.]//N;
      height += radius*Cos[alpha/2.]//N
    ];
    mid = ctr-height*{Cos[omegamc],Sin[omegamc]}
  ];
  drawpoints =
    If[{flAmpl,flPhas,center} === {0,0,0}, 1,
      Floor[ radius/scaling*Abs[alpha]*
        If[flAmpl === 0, 60, 100*(1+flPhas)] ]
    ];
  wavenumber = If[ flPhas === 1,
    2.*NPi*( 0.1+Max[1,Floor[7.*Abs[alpha]*radius/scaling]] ),
    NPi*( 0.5+Max[1,Floor[10.*Abs[alpha]*radius/scaling]] )];
  phaseamp = 0.8*flPhas * NPi/90./radius*scaling * Sign[alpha];

(* now computing the points *)

  frac = Array[((#-1)/drawpoints)&, drawpoints+1];
  angle = (#*(alpha-phaseamp)/2.+phaseamp*Sin[#*wavenumber])&/@ frac;
  radius = radius-flAmpl*0.25*
    (1.5*flPhas-(1.+0.5*flPhas)*(Cos[#*wavenumber]&/@ frac));
  XY1 = Array[ (mid+radius[[#]]*
    {Cos[omegamc-angle[[#]] ],
     Sin[omegamc-angle[[#]] ]})&, drawpoints+1 ];
  XY2 = Array[ (mid+radius[[#]]*
    {Cos[omegamc+angle[[#]] ],
     Sin[omegamc+angle[[#]] ]})&, drawpoints+1 ];

(* now creating the output *)

  thickprim = Thickness[0.01*thick/scaling];
  graphprim1 = {thickprim, Line[XY1]};
  graphprim2 = {thickprim, Line[XY2]};
  Which[
    flDash,
      graphprim1 = Prepend[graphprim1, Dashing[{.005,.005}]];
      graphprim2 = Prepend[graphprim2, Dashing[{.005,.005}]],
    flDots,
      graphprim1 = Prepend[graphprim1, Dashing[{.001,.005}]];
      graphprim2 = Prepend[graphprim2, Dashing[{.001,.005}]]
  ];
  height = XY1[[1]] + 24./scaling*{Cos[omegamc],Sin[omegamc]};
  labelprim =
    If[ Head[symb] === Sub,
      {Text[FontForm[symb[[1]], Paint`Private`OutFont], height],
       Text[FontForm[symb[[2]], Paint`Private`SmallOutFont],
         height, {-2.5,1}]},
    (* else *)
      {Text[FontForm[symb, Paint`Private`OutFont], height]} ];
  If[ flArro === none,
    {graphprim1, graphprim2, labelprim},
    {graphprim1, graphprim2, labelprim,
      {thickprim, Arrow[ctr, omegamc+perp, flArro, 12./scaling]} }
  ]
]

(* defining the grids *)

FeynGrid[n_] := Flatten[ Array[Point[{##}//N]&, {n+1,n+1}, 0] ]

EmptyFeynGrid[n_] := {First[FeynGrid[n]], Last[FeynGrid[n]]}

FeynRaster[n_] := Raster[{{0.8}}, {{-.5,-.5}, N[n]+{0.5,0.5}}]

FeynEdit[ Topology[props__, Insertions[__]] ]:=
  FeynEdit[ Topology@@ (Take[#,2]&/@ {props}) ] 

FeynEdit[ tt:Topology[Propagator[_][_,_]..] ] :=
  FeynEdit[tt, NumberOfInc[tt], NumberOfOut[tt]]

FeynEdit[ Topology[_][props:Propagator[_][_,_]..], ninc_, nout_ ] :=
  FeynEdit[Topology[props] /. IncOutSpecification[ninc, nout], ninc, nout]

IncOutSpecification[ ninc_, nout_ ] := Join[
  Array[Propagator[ex][e[#],vert_] :>
    Propagator[inc][e[#],vert]&, ninc],
  Array[Propagator[ex][e[#],vert_] :>
    Propagator[out][e[#],vert]&, nout, ninc+1]
]

Block[ {fullname = FileNames["TopEdit",$Path]},
  If[ Global`UseTopEdit =
    (Length[fullname] > 0 &&
      Environment["DISPLAY"] =!= $Failed &&
      $LinkSupported),
    Install["TopEdit"]
  ]
]

Get[ ContextToFilename["GraphInfo`GraphInfo`"] ]

SaveGraphInfo[ query_:False ] :=
Block[ {graphfile},
  If[query &&
    ToLowerCase[InputString[
      "GraphPoint information not saved yet. Save now? (y/n) "]] === "n",
    Return[] ];
  graphfile = ContextToFilename["GraphInfo`GraphInfo`"];
  Print["write to file ", graphfile];
  Put[ Definition[GraphPoints], graphfile ];
];

FeynEdit[ Topology[ props:Propagator[_][_,_].. ], ninc_, nout_ ] :=
Block[ {workingtop, edittop, command, arg1, arg2, seq},
  edittop = Sort[ Sort/@ (Take[#,2]&/@ Topology[props]) /.
    {inc -> zzx, out -> zzy }] /. {zzx -> inc, zzy -> out};
  If[ Head[ GraphPoints[edittop,ninc,nout] ] =!= List,
    SetRandomPoints[edittop,ninc,nout] ];
  If[Global`UseTopEdit,
    arg1 = GraphPoints[edittop,ninc,nout][[2]] /. Rule -> List;
    arg2 = Flatten[Transpose[
      {List@@ edittop,GraphPoints[edittop,ninc,nout][[1]]}] /.
        Propagator[_][a_,b_] :>
          seq[ Position[arg1,a][[1,1]], Position[arg1,b][[1,1]] ] /.
        seq -> Sequence, 1];
    workingtop = Global`TopEdit[ Flatten[arg1], arg2, PaintScaling ];
    If[workingtop =!= $Aborted,
      SetGraphPoints[edittop, ninc, nout, workingtop];
      System`$Epilog := SaveGraphInfo[True] ],
  (* else *)
    workingtop = Topology@@ Join[AppendIndex[Sort/@ {props}],
      DummyFieldInsertions[Length[{props}]]];
    Print["for help type `h'"];
    command = "s";
    While[ command != "x",
      Switch[ command,
        "h", Print["the following commands are available:"];
             Print["  c (center)   choose coordinates of center of line"];
             Print["  d (displace) choose curvature of line"];
             Print["  f (file)     save the GraphPoints-functions"];
             Print["  h (help)     this message"];
             Print["  p (print)    print the coordinates of the topology"];
             Print["  r (random)   randomize internal points"];
             Print["  s (show)     display the current topology with grid"];
             Print["  u (up)       shift the complete graph in y-direction"];
             Print["  v (vertex)   shift a vertex"];
             Print["  x (exit)     leave FeynEdit"],
        "s", PaintSingle[workingtop, 0., 0., 
               ShowGrid -> True, ShowPointNames -> True,
               PropagatorThickness -> 12, VertexSize -> 8],
        "f", SaveGraphInfo[False],
        "r", SetRandomPoints[edittop, ninc, nout],
        "p", PrintPoints[edittop, ninc, nout],
        "v", VertexShift[edittop, ninc, nout],
        "c", CenterChoice[edittop, ninc, nout],
        "u", GraphShift[edittop, ninc, nout],
        "d", DisplacementChoice[edittop, ninc, nout]
      ];
      command = InputString["FeynEdit> "]
    ];
  ];
]

PrintPoints[ edittop_, ninc_, nout_ ] := (
  PrintProp/@ Transpose[{List@@ edittop,
    GraphPoints[edittop, ninc, nout][[1]],
    Range[Length[edittop]]} ];
  PrintCoord/@ GraphPoints[edittop, ninc, nout][[2]]
)

PrintProp[ {Propagator[_][from_,to_], center_, numb_} ] :=
  Print["   ",from," --> ",to,"   c[",numb,"] = ",
    If[ from === to && center === 0, Automatic, center] ]

PrintCoord[ point_ -> coord_ ] := Print["   ", point," = ", coord ]

AppendIndex[ pr_List ] :=
  If[ Length[ pr[[1]] ] == 3, pr,
    Array[ Append[pr[[#]],fi[#]]&, Length[pr] ] ]

DummyFieldInsertions[ nr_Integer ] :=
  { Insertions[ Graph[1]@@ Array[(fi[#] -> DummyField[1])&, nr] ] }

SetGraphPoints[ top_, ninc_, nout_, newval_ ] :=
  GraphPoints[top, ninc, nout] = newval;

SetRandomPoints[ tt_Topology, ninc_, nout_ ] :=
Block[ {randpoints, vert, holdvert, baretop, linemulti,
se = 2, te = 2, r, r2},
  randpoints = Join[
    Array[ e[#] -> 
      {0, PaintScaling-Round[(#-1/2)*PaintScaling/ninc]}&,
      ninc ],
    Array[ e[#] ->
      {PaintScaling,
       PaintScaling-Round[(#-ninc-1/2)*PaintScaling/nout]}& ,
      nout, ninc+1 ]
  ];
  baretop = List@@ tt /. Propagator[_] -> List;
  vert = Union[ Select[Flatten[baretop], (Head[#] =!= e)&] ];
  While[
    holdvert = (# -> {
      Random[Integer,{3,PaintScaling-3}],
      Random[Integer,{3,PaintScaling-3}] })&/@ vert;
    Length[Union[holdvert]] =!= Length[vert], Null];
  randpoints = {
    If[ MatchQ[#, Propagator[_][a_,a_]],
      r = r2 = #[[1]] /. holdvert;
      While[ r === (r2 =
        Random[ Integer, {Max[3,#-4],Min[PaintScaling-3,#+4]} ]&/@ r),
        Null ];
      r2,
    (* else *)
      0
    ]&/@ (List@@ tt),
    Join[randpoints, holdvert] };
  SetGraphPoints[tt, ninc, nout, randpoints];
  Do[ 
    Switch[ Length[ Cases[baretop,baretop[[i]] ] ],
      2, DisplacementChoice[tt, ninc, nout, i, se];
         se = -se,
      3, DisplacementChoice[tt, ninc, nout, i, te];
         If[te === -2, te = 2, te -= 2]
    ],
  {i,Length[tt]}];
]

(* change position of a vertex (redefine GraphPoints-function) *)

VertexShift[ baretop_, ninc_, nout_ ] :=
Block[ {vertexnr, xsh, ysh, props, cent, verts, point,
lab, lac, oac, oab, disp = {}, dispsign},
  verts = Flatten[baretop /. Propagator[_][a___] :> Topology[a]];
  While[!MemberQ[ verts, vertexnr = Input["Vertex: "] ], Null];
  While[!NumberQ[ xsh = Input[" +x: "] ], Null];
  While[!NumberQ[ ysh = Input[" +y: "] ], Null];
  props = Union[ First/@ Position[baretop,vertexnr] ];
  Do[
    cent = GraphPoints[baretop,ninc,nout][[1, props[[i]] ]];
    If[cent =!= 0,
      point = List@@ (baretop[[ props[[i]] ]] /.
        GraphPoints[baretop, ninc, nout][[2]]);
      lac = Sqrt[#.#& @ (point[[1]]-cent)];
      lab = Sqrt[#.#& @ (point[[1]]-point[[2]])];
      oac = Orientation[point[[1]], cent];
      oab = Orientation[point[[1]], point[[2]] ];
      dispsign = Sign[oac-oab]*
        If[oac > -NPi/2 && oac < NPi/2, 1, Sign[oab]*Sign[oac] ];
      disp = Append[ disp,
        {props[[i]], dispsign*lac*Sin[ArcCos[lab/2/lac]]}]
    ],
  {i,Length[props]}];
  PointShift[baretop, ninc, nout, vertexnr, xsh, ysh];
  If[ disp =!= {} ,
    DisplacementChoice[baretop, ninc, nout, #[[1]], #[[2]] ]&/@ disp ]
]

GraphShift[ baretop_, ninc_, nout_ ] :=
Block[ {ysh},
  While[!NumberQ[ ysh = Input["(all) +y: "] ], Null];
  SetGraphPoints[baretop, ninc, nout,
    GraphPoints[baretop, ninc, nout] /.
      {xval_?NumberQ, yval_?NumberQ} :> {xval, yval+ysh} ]
]

PointShift[ t_Topology, ninc_, nout_, vertex_, xshift_, yshift_:0 ] :=
  If[ Head[vertex] === Global`c,
    If[ GraphPoints[t,ninc,nout][[1,vertex[[1]] ]] === 0,
      Print["-straight line- (use 'd')"],
    (* else *)
      SetGraphPoints[t, ninc, nout,
        ReplacePart[ GraphPoints[t,ninc,nout],
          {GraphPoints[t,ninc,nout][[1,vertex[[1]],1]]+xshift,
           GraphPoints[t,ninc,nout][[1,vertex[[1]],2]]+yshift},
          {1,vertex[[1]]} ] ]
    ],
  (* else *)
    SetGraphPoints[t, ninc, nout,
      GraphPoints[t,ninc,nout] /. (vertex -> {xval_,yval_}) :>
        (vertex -> N[{xval+xshift,yval+yshift}]) ]
  ]

(* choose curvature of line *)

DisplacementChoice[ baretop_, ninc_, nout_ ] :=
Block[ {centernr, displ, ctrs},
  ctrs = Array[Global`c[#]&, Length[baretop]];
  While[!MemberQ[ ctrs, centernr = Input["Center: "] ], Null];
  If[ baretop[[centernr[[1]],1]] === baretop[[centernr[[1]],2]] ,
    Print["d cannot be used for closed propagators!"];
    Return[] ];
  While[!NumberQ[ displ = Input[" displacement: " ] ], Null];
  If[ displ =!= 0,
    displ = CalculateCenter[
      Flatten[baretop[[centernr[[1]],1]] /.
        GraphPoints[baretop,ninc,nout][[2]] ],
      Flatten[baretop[[centernr[[1]],2]] /.
        GraphPoints[baretop,ninc,nout][[2]] ],
      displ ] 
  ];
  SetCenter[baretop, ninc, nout, centernr[[1]], displ]
]

DisplacementChoice[ baretop_, ninc_, nout_, centernr_, howmuch_ ] :=
Block[ {displ},
  If[ howmuch === 0,
    displ = 0,
  (* else *)
    displ = CalculateCenter[
      Flatten[baretop[[centernr,1]] /.
        GraphPoints[baretop,ninc,nout][[2]] ],
      Flatten[baretop[[centernr,2]] /.
        GraphPoints[baretop,ninc,nout][[2]] ],
      howmuch ] 
  ];
  SetCenter[baretop, ninc, nout, centernr, displ]
]

CalculateCenter[ a_, b_, length_ ] :=
Block[ {angle},
  angle = Orientation[a,b]+NPi/2;
  0.5*(a+b) + length*{Cos[angle],Sin[angle]}
]

(* choose center of line by hand (tadpoles) *)

CenterChoice[ baretop_, ninc_, nout_ ] :=
Block[ {centernr, ctrs, xval, yval},
  ctrs = Array[Global`c, Length[baretop]];
  While[!MemberQ[ ctrs, centernr = Input["Center: "] ], Null];
  While[!NumberQ[ xval = Input[" choose x: "] ], Null];
  While[!NumberQ[ yval = Input[" choose y: "] ], Null];
  SetCenter[baretop, ninc, nout, centernr[[1]], {xval,yval}]
]

SetCenter[ t_Topology, ninc_, nout_, cnr_, point_ ] :=
  SetGraphPoints[t, ninc, nout,
    ReplacePart[GraphPoints[t,ninc,nout], point, {1,cnr}] ]

End[]

EndPackage[]

