(*
	Graphics.m
		Graphics routines for FeynArts
		last modified 3 Aug 20 th
*)

Begin["`Graphics`"]

NPi = N[Pi]

	(* for "PS" format: paper size in bp for finding margins *)
PaperSize = {595, 842}	(* A4, use 72 {8.5, 11} for Letter *)

DefaultImageSize = 72 {6, 7}

	(* Dimensions of a single diagram *)
DiagramBorder = 1

DiagramCanvas = 20

DiagramSize = DiagramCanvas + 2 DiagramBorder

LabelFontSize = 2 (* units of the diagram coordinate system *)

LabelFont = "Helvetica"

	(* for ordinary vertices and counter terms: *)
PropagatorThickness = Thickness[.11/DiagramSize]

VertexThickness = PointSize[8 .11/DiagramSize]

CounterThickness = Thickness[3 .11/DiagramSize]

	(* for counter terms: *)
CrossWidth = 1

ArrowLength = 1.2

	(* height of an arrow's thick end over the baseline *)
ArrowHeight = .4

DampingConst = (.65 ArrowLength)^4

ScalarDashing = Dashing[{.66, .66}/DiagramSize]

GhostDashing = Dashing[{.11, .66}/DiagramSize]

	(* # of points per unit arc length used in drawing Sine and
	   Cycles lines *)
NPoints = 10

	(* # of Sine or Cycles wave crests per unit arc length *)
NCrestsSine = .5

NCrestsCycles = .65

SineAmp = .25

CyclesAmp = .6

	(* the breadth of the "spikes" of the cycloid *)
CyclesBreadth = .16

	(* default radius for label positioning, must be the
	   same as DEFAULT_RADIUS in TopologyEditor.java *)
DefaultRadius = 1.3


Options[Paint] = {
  PaintLevel -> InsertionLevel,
  ColumnsXRows -> 3,
  AutoEdit -> True,
  SheetHeader -> Automatic,
  Numbering -> Full,
  FieldNumbers -> False,
  If[ $VersionNumber >= 6 && $Notebooks,
    DisplayFunction :> (Print/@ Render[##] &),
    DisplayFunction :> $DisplayFunction ]
}

Paint::nolevel =
"Warning: Level `1` is not contained in this insertion."

Paint::colrows =
"ColumnsXRows is not an integer or a pair of integers."

Paint[_[], ___] = Null

Paint[top:P$Topology, opt:P$Options] :=
  Paint[TopologyList[top], opt]

Paint[top:(P$Topology -> _), opt:P$Options] :=
  Paint[TopologyList[][top], opt]

Paint[tops_TopologyList, options:P$Options] :=
Block[ {fnum, ghead, opt = ActualOptions[Paint, Display, options]},
  fnum = If[TrueQ[FieldNumbers /. opt], 1, 0];
  ghead = Switch[ ghead = SheetHeader /. opt,
    None | False,
      FeynArtsGraphics[],
    Automatic | True, 
      ghead = #[[0,1]]&/@ tops[[1]];
      FeynArtsGraphics[
        Count[ghead, Incoming | External] -> Count[ghead, Outgoing] ],
    _,
      FeynArtsGraphics[ghead]
  ];

  PaintSheet[tops, options]
]

Paint[tops:TopologyList[info___][___], options:P$Options] :=
Block[ {plevel, ins, ghead, fnum = 0,
opt = ActualOptions[Paint, Display, options]},
  If[ (plevel = ResolveLevel[PaintLevel /. opt /. {info} /.
        Options[InsertFields]]) === $Failed,
    Return[$Failed] ];
  ins = PickLevel[plevel][tops];
  If[ FreeQ[plevel, Generic],
    ins = Select[ins /. Insertions[Generic][gr__] :> Join@@ TakeIns/@ {gr},
      Length[#] =!= 0 &] ];
  Scan[
    If[FreeQ[ins, Insertions[#]], Message[Paint::nolevel, #]]&,
    plevel ];

  If[ InitializeModel[Model /. {info} /. Options[InsertFields],
        GenericModel -> (GenericModel /. {info} /. Options[InsertFields]),
        Reinitialize -> False] =!= True,
    Return[$Failed] ];

  ghead = Switch[ ghead = SheetHeader /. opt,
    None | False,
      FeynArtsGraphics[],
    Automatic | True, 
      If[ (ghead = Process /. {info}) === Process,
        FeynArtsGraphics[],
      (* else *)
        FeynArtsGraphics[Map[TheLabel[#, External]&, ghead, {2}] /.
          _Index -> Null]
      ],
    _,
      FeynArtsGraphics[ghead]
  ];

  PaintSheet[
    ins //. (x:FeynmanGraph[___][__] -> Insertions[_][gr___]) :> Seq[x, gr],
    options ]
]


PaintSheet[tops_, options___] :=
Block[ {auto, disp, cols, rows, dhead, edit, editor, closeEditor, g,
topnr = 0, runnr = 0},
  Switch[ cols = ColumnsXRows /. opt,
    _Integer,
      rows = cols,
    {_Integer, _Integer},
      {cols, rows} = cols,
    _,
      Message[Paint::colrows]; cols = rows = 3
  ];
  Switch[ Numbering /. opt,
    Full,
      dhead[gr_] := 
      Block[ {specs},
        ++runnr;
        specs = Cases[Head[gr], lev_ == n_ :>
          {" ", StringTake[ToString[lev], 1], ToString[n]}];
        If[ Length[specs] =!= 0,
          specs = {specs, " N", ToString[runnr]} ];
        DiagramGraphics["T" <> ToString[topnr] <> specs]
      ],
    Simple,
      _dhead := DiagramGraphics[ ToString[++runnr] ],
    _,
      _dhead = DiagramGraphics[]
  ];

  edit[_][Automatic] = AutoEdit /. opt;
  g = Flatten[TopologyGraphics/@ List@@ tops] /. _Index -> Null;
  closeEditor[];

  g = Flatten[{g, Table[Null, {Mod[rows cols - Length[g], rows cols]}]}];
  g = Level[{Partition[Partition[g, cols], rows],
    {SelectOptions[Display, options]}}, {2}, ghead];
  (DisplayFunction /. opt)[g];
  g
]


TopologyGraphics[top_ -> g_] :=
Block[ {v, p, s},
  ( v = VGraphics/@ Vertices[top] /. #1;
    p = Transpose[{List@@ top /. Vertex[e_, _] :> Vertex[e] /. #1, #2, #3}];
    s = #4
  )&@@ FindShape[top, ShapeSources,
    ShapeInfo[++topnr, ", ", NumberOf[{Length[gr]}, " diagram"]]];
  Level[{PGraphics@@@ (p /. List@@ # /. Field[_] -> 0), v, {s}},
    {2}, dhead[#]]&/@ List@@ g
]

TopologyGraphics[top_] :=
Block[ {n = 0},
  TopologyGraphics[ Append[Take[#1, 2], n += fnum]&/@ top -> {{}} ]
]


VGraphics[_[e_, c_:0][n_]] := VertexGraphics[c][Vertex[e][n]]

PGraphics[_[from_, to_, 0, ___], height_, labelpos_] :=
  PropagatorGraphics[Straight][from, to, height, labelpos]

PGraphics[_[type_][from_, to_, particle_, ___], height_, labelpos_] :=
  PropagatorGraphics[
    PropagatorType[particle],
    TheLabel[particle, ResolveType[type]],
    PropagatorArrow[particle]
  ][from, to, height, labelpos]


Format[DiagramGraphics[h___][__]] := SequenceForm["[", h, "]"]

Format[(g_FeynArtsGraphics)[l__List, ___Rule]] := MatrixForm/@ g[l]


SetOptions[OpenWrite, CharacterEncoding -> {}]

Unprotect[Show, Display, Export]

Show[g:FeynArtsGraphics[___][___]] := Show/@ Render[g]

Display[chan_, g:FeynArtsGraphics[___][___], format___String, opt:P$Options] :=
Block[ {rg},
  rg = Render[g, InferFormat[chan, format], SelectOptions[Display, opt]];
  MapThread[Display[##, format, opt]&,
    {FilePerSheet[chan, Length[rg]], rg}]
]

Display[chan_, s_String, ___] := (WriteString[#, s]; Close[#])& @
  OpenWrite[chan, CharacterEncoding -> "ISO8859-1"]

	(* we have to play some tricks to get our definitions
	   for Export before Mma's ones *)
DownValues[Export] = Flatten[{
  Block[ {Export},
    Export[ chan_, s_String, ___ ] := (WriteString[#, s]; Close[#])& @
      OpenWrite[chan, CharacterEncoding -> "ISO8859-1"];
    Export[ chan_, g:FeynArtsGraphics[___][___],
      format___String, opt:Evaluate[P$Options] ] :=
    Block[ {rg},
      rg = Render[g, InferFormat[chan, format], SelectOptions[Export, opt]];
      MapThread[Export[##, format, opt]&,
        {FilePerSheet[chan, Length[rg]], rg}]
    ];
    DownValues[Export]
  ],
  DownValues[Export]
}]

Protect[Show, Display, Export]


InferFormat[_, format_] := format

InferFormat[file_String] := "PS" /; StringMatchQ[file, "*.ps"]

InferFormat[file_String] := "EPS" /; StringMatchQ[file, "*.eps"]

InferFormat[file_String] := "TeX" /; StringMatchQ[file, "*.tex"]

InferFormat[_] = Sequence[]


Options[Render] = {ImageSize -> Automatic}

getsize[opt___, def_] := If[NumberQ[#], {#, #}, #]& @
  Round[ImageSize /. ActualOptions[Render, opt] /. Automatic -> def]

prologue := prologue =
  ReadList[ToFileName[$FeynArtsProgramDir, "FeynArts.pro"],
    Record, RecordSeparators -> ""][[1]]

epsf = ""

Render[(g_FeynArtsGraphics)[l__List, o___Rule], format___String, opt___Rule] :=
  DoRender[format][o, opt][g/@ {l} /. {None -> 0, Forward -> 1, Backward -> -1}]

DoRender["EPS"][opt___][g_] :=
Block[ {PaperSize = imgsize, epsf = " EPSF-3.0"},
  Flatten[DoRender["PS"][opt]/@ g]
]

DoRender["PS"][opt___][g_] :=
Block[ {imgsize = getsize[opt, DefaultImageSize], bbox},
  bbox = Round[.5 (PaperSize - imgsize)];
  bbox = {bbox, bbox + imgsize};
  { PSString[ "\
%!PS-Adobe-3.0", epsf, "\n\
%%BoundingBox: 0 0 ", PaperSize, "\n\
%%Pages: ", Length[g], "\n",
    prologue,
    MapIndexed[
      { "\n%%Page: ", #2, #2, "\ngsave\n",
        bbox, #1, "\ngrestore\nshowpage\n" }&,
      PSRender[g] ], "\n\
%%Trailer\n\
end\n\
%%EOF\n" ] }
]

DoRender["TeX"][opt___][g_] :=
Block[ {imgsize = getsize[opt, DefaultImageSize]},
  { "\\unitlength=1bp%\n\n" <> TeXRender[g] }
]

DoRender[___][opt___][g_] :=
Block[ {imgsize = getsize[opt, {288, 288}],
(* magnify the labels a bit for screen viewing: *)
LabelFontSize = 1.26 LabelFontSize},
  MmaRender[g]
]


FilePerSheet[file_, 1] := {file}

FilePerSheet[file:{__}, n_] := Thread[FilePerSheet[#, n]&/@ file]

FilePerSheet[file_String, n_] :=
Block[ {p, pre, post},
  p = StringPosition[file, "."];
  If[ Length[p] === 0, pre = file <> "_"; post = "",
    p = p[[-1,1]] - 1;
    pre = StringTake[file, p] <> "_";
    post = StringDrop[file, p] ];
  Array[pre <> ToString[#] <> post &, n]
] /; file =!= "stdout"

FilePerSheet[file_, n_] := Table[file, {n}]


Attributes[PSNumber] = {Listable}

PSNumber[x_] := {ToString[x], " "}


PSString[s_String] := s

PSString[RGBColor[r_, g_, b_, ___]] :=
  PSNumber[{r, g, b}] <> "setrgbcolor "

PSString[CMYKColor[c_, m_, y_, k_, ___]] :=
  PSNumber[{c, m, y, k}] <> "setcmykcolor "

PSString[Hue[h_, s_:1, b_:1, ___]] :=
  PSNumber[{h, s, b}] <> "sethsbcolor "

PSString[GrayLevel[g_, ___]] := PSNumber[g] <> "setgray "

PSString[Thickness[t_]] := PSNumber[t DiagramSize] <> "setlinewidth "

PSString[s_] := StringJoin[PSNumber[s]] /; Head[s] =!= List

PSString[s__] := StringJoin[PSString/@ Flatten[{s}]]


TeXString[{x_, y_}] := "(" <> ToString[x] <> "," <> ToString[y] <> ")"

TeXString[s_] := ToString[s]

TeXString[s__] := StringJoin[TeXString/@ {s}]


Attributes[PSRender] =
Attributes[TeXRender] =
Attributes[MmaRender] = {Listable}


PSRender[FeynArtsGraphics[h___][sheet_]] :=
Block[ {rows, cols, g},
  {rows, cols} = Dimensions[sheet];
  g = PSRender[{Title[h], sheet}];
  PSString[cols, rows, "Layout\n" <> g]
]

Attributes[TeXJoin] = {Flat, OneIdentity}

TeXJoin[n_Integer] := ToString[n]

TeXJoin[s1_String, s2_String] := s1 <> "\\quad " <> s2

TeXRender[FeynArtsGraphics[in_ -> out_][sheet_]] :=
  TeXRender[FeynArtsGraphics[TeXJoin@@ Flatten[{in, "\\to", out}]][sheet]]

TeXRender[FeynArtsGraphics[h___][sheet_]] :=
Block[ {rows, cols, g},
  {rows, cols} = Dimensions[sheet];
  g = TeXRender[{Title[h], sheet}];
  TeXString["\\begin{feynartspicture}", imgsize, {cols, rows},
    "\n" <> g <> "\\end{feynartspicture}\n\n"]
]

MmaRender[FeynArtsGraphics[h___][sheet_]] :=
Block[ {rows, cols, fsize, g, title},
  {rows, cols} = Dimensions[sheet];
  g = MapIndexed[DiagramBox, sheet, {2}];
  title = MmaRender[Title[h]];
  fsize = LabelFontSize Min[imgsize/{cols, rows}]/DiagramSize;
  Graphics[ Flatten[{g, title}],
    PlotRange -> {{0, cols}, {0, rows}} DiagramSize,
    AspectRatio -> rows/cols,
    ImageSize -> imgsize ]
]


DiagramBox[Null, _] = {}

DiagramBox[g_, {yoff_, xoff_}] := Inset[ MmaRender[g],
  {xoff - 1, rows - yoff} DiagramSize, {0, 0}, {1, 1} DiagramSize ]

If[ $VersionNumber < 6,
  Inset[obj_, pos_, _, size_] := Rectangle[pos, pos + size, obj]
]


Title[] = {}

Title[t_] := (
  rows += .3;
  LabelText[t, {.5 cols, rows - .12} DiagramSize, {0, 0}, 1.2, 0] )


PSRender[DiagramGraphics[h___][pv__, s_]] := "\n\
(" <> h <> ") Diagram\n\
% " <> ToString[s] <> "\n" <> Transpose[PSRender[{pv}]]

PSRender[Null] = "\n() Diagram\n"

TeXRender[DiagramGraphics[h___][pv__, s_]] := "\n\
\\FADiagram{" <> h <> "}\n\
% " <> ToString[s] <> "\n" <> Transpose[TeXRender[{pv}]]

TeXRender[Null] = "\n\\FADiagram{}\n"

MmaRender[DiagramGraphics[h___][pv__, s_]] :=
Block[ {g},
  g = Flatten[{
    PropagatorThickness, #1,
    scope[VertexThickness, #2],
    DiagLabel[h]
  }]&@@ Transpose[MmaRender[{pv}]];
  g = g /. scope[a__] :> scope@@ Flatten[{a}] /. scope -> List;
  If[ NameQ["System`Tooltip"], g = Tooltip[g, s] ];
  Graphics[ g,
    PlotRange -> {{0, DiagramSize}, {0, DiagramSize}} - DiagramBorder,
    AspectRatio -> 1 ]
]

DiagLabel[] = {}

DiagLabel[t_] := MmaRender[LabelText[t, {.5 DiagramCanvas, -.5}, {0, -1}, .8]]


PSRender[VertexGraphics[cto_][xy_]] :=
  {{}, PSString[xy, cto, "Vert\n"]}

TeXRender[VertexGraphics[cto_][xy_]] :=
  {{}, TeXString["\\FAVert", xy, "{", cto, "}\n"]}

MmaRender[VertexGraphics[0][xy_]] := {{}, Point[xy]}

MmaRender[VertexGraphics[c_?Negative][xy_]] := {{},
  { scope[ GrayLevel[Max[0, 1.1 + .3 c]], Disk[xy, CrossWidth] ],
    Circle[xy, CrossWidth] }}

MmaRender[VertexGraphics[c_][xy_]] := {{},
  { scope[ CounterThickness,
      Line[{xy - .5 CrossWidth, xy + .5 CrossWidth}],
      Line[{xy - {.5, -.5} CrossWidth, xy + {.5, -.5} CrossWidth}] ],
    Array[Circle[xy, (.25 # + .8) CrossWidth]&, c - 1] }}


PSRender[PropagatorGraphics[type_, label_:0, arrow_:0][
  from_, to_, height_, labelpos_:0 ]] :=
Block[ {dir, ommc, cs, ctr, rad, mid, dphi, line},
  line = PSString["{ ", type, "} ", arrow, height, from, to, "Prop\n"];
  If[ label =!= 0,
    CalcPropData[from, to, height];
    line = line <> PSRender[PropLabel[label, labelpos, arrow, type]] ];
  {line, {}}
]

TeXRender[PropagatorGraphics[type_, label_:0, arrow_:0][
  from_, to_, height_, labelpos_:0 ]] :=
Block[ {dir, ommc, cs, ctr, rad, mid, dphi, line},
  line = TeXString["\\FAProp", from, to,
    If[ NumberQ[height], {height, ""}, height],
    "{" <> StringDrop[PSString[type], -1] <> "}{", arrow, "}\n"];
  If[ label =!= 0,
    CalcPropData[from, to, height];
    line = line <> TeXRender[PropLabel[label, labelpos, arrow, type]] ];
  {line, {}}
]

MmaRender[PropagatorGraphics[type_, label_:0, arrow_:0][
  from_, to_, height_, labelpos_:0 ]] :=
Block[ {dir, ommc, cs, ctr, rad, mid, dphi, line, phi, damping, t, h, v},
  CalcPropData[from, to, height];
  If[ arrow =!= 0,
    damping[phi_] := (#/(# + DampingConst))&[(rad Abs[phi - ommc])^4],
  (* else *)
    _damping = 1 ];
  phi = ommc - dphi;
  (*phi = Mod[phi, 2 NPi]; 31 Oct 19 *)
  t = Flatten[{type}];
  h = Position[t, Straight | ScalarDash | GhostDash | Sine | Cycles, 1];
  dphi *= 2./Length[h];
  line = scope[MapAt[PropSegment[#, phi += dphi, dphi]&, t, h]];
  If[ arrow =!= 0,
    h = .5 arrow ArrowLength {Cos[dir], Sin[dir]};
    v = ArrowHeight cs;
    line = {line, Polygon[{mid + h, mid - h + v, mid - h - v}]} ];
  If[ label =!= 0,
    line = {line, MmaRender[PropLabel[label, labelpos, arrow, type]]} ];
  {line, {}}
]


(* CalcPropData computes the data necessary for actual drawing:
   dir  -- the direction along the propagator
   ommc -- the direction of the perpendicular bisector
   ctr  -- the center of the circle on which the prop lies,
   rad  -- the radius of the circle
   mid  -- the position on the middle of the prop
           (the blue square in the topology editor)
   dphi -- half the opening angle *)

CalcPropData[from_, _, xy_List] := (
  mid = xy;
  ctr = .5 (from + mid);
  rad = Distance[from, ctr];
  ommc = Orientation[from, ctr];
  dir = ommc + .5 NPi;
  cs = {Cos[ommc], Sin[ommc]};
  dphi = NPi
)

CalcPropData[from_, to_, height_] :=
Block[ {lab, h},
  lab = .5 Distance[from, to];
  dir = Orientation[from, to];
  ommc = dir + If[height < 0, .5, -.5] NPi;
  cs = {Cos[ommc], Sin[ommc]};
  ctr = mid = .5 (from + to);
  If[ height != 0,
    dphi = 2. ArcTan[h = Abs[height]];
    rad = lab/Sin[dphi];
    dphi *= Sign[height];
    mid += h lab cs;
    h = If[h > 1., -1, 1],
  (* else *)
    rad = 20000.;
    dphi = ArcSin[lab/rad];
    h = 1
  ];
  ctr -= h Sqrt[rad^2 - lab^2] cs
]


PropSegment[Sine, phi_, dphi_] :=
Block[ {arc, w, n},
  arc = rad Abs[dphi];
  w = 2. NPi (.5 + Max[1, Round[NCrestsSine arc]]);
  Line @ Table[
    arc = phi - n dphi;
    ctr + (rad - damping[arc] SineAmp Sin[n w]) {Cos[arc], Sin[arc]},
    {n, 0, 1, 1./Floor[NPoints arc]} ]
]

rshift = CyclesAmp - SineAmp

phadj = ArcCos[rshift/CyclesAmp]

sphadj = Sin[phadj]

PropSegment[Cycles, phi_, dphi_] :=
Block[ {arc, w, n, phamp},
  arc = rad Abs[dphi];
  w = 2. (phadj + NPi Max[1, Round[NCrestsCycles arc]]);
  phamp = CyclesBreadth NPi Sign[dphi]/rad;
  Line @ Table[
    arc = n w - phadj;
    ctr + (rad + CyclesAmp Cos[arc] - rshift) *
      Through[{Cos, Sin}[
        phi - n dphi - phamp (Sin[arc] - (2 n - 1) sphadj)]],
    {n, 0, 1, 1./Floor[2 NPoints arc]} ]
]

PropSegment[Straight, phi_, dphi_] :=
  If[ rad < 20000,
    Circle[ctr, rad, Sort[{phi - dphi, phi}]],
    Line[{ ctr + rad {Cos[phi - dphi], Sin[phi - dphi]},
           ctr + rad {Cos[phi], Sin[phi]} }] ]

PropSegment[ScalarDash, phi_, dphi_] :=
  scope[ScalarDashing, PropSegment[Straight, phi, dphi]]

PropSegment[GhostDash, phi_, dphi_] :=
  scope[GhostDashing, PropSegment[Straight, phi, dphi]]


PropLabel[label_, labelpos_, arrow_, type_] :=
Block[ {rad, phi, s},
  {rad, phi} =
    If[ NumberQ[labelpos], {labelpos DefaultRadius, 0.}, labelpos ];
  s = Sign[rad Cos[phi]];
  cs *= s;
  Which[
    arrow =!= 0 || !FreeQ[type, Sine],
      mid += SineAmp cs,
    !FreeQ[type, Cycles],
      mid += If[s < 0, CyclesAmp + rshift, SineAmp] cs ];
  phi += ommc;
  cs = -Round[1.3 cs];
  LabelText[ label,
    mid + rad {Cos[phi], Sin[phi]} + .24 LabelFontSize cs,
    cs, 1, dir ]
]


LabelText[in_ -> out_, pos_, align_, size_, dir_] :=
Block[ {t, l, cs = {Cos[dir], Sin[dir]}},
  t = Flatten[{in, "\\to", out}];
  l = .5 (Length[t] + 1);
  MapIndexed[LabelText[#1, pos + 4.5 (#2[[1]] - l) cs, align, size]&, t]
]

LabelText[t_List, pos_, align_, size_, dir_] :=
Block[ {l = .5 (Length[t] + 1), cs = {Cos[dir], Sin[dir]}},
  MapIndexed[LabelText[#1, pos + 2 (#2[[1]] - l) cs, align, size]&, t]
]

PSRender[LabelText[t_, pos_, align_, size_, ___]] :=
  PSString["{ ", MapIndexed[PSChar, Flatten[{ToPS[t]}]], "} ",
    pos, align, size, "Label\n"]

PSChar[_[], _] = {}

PSChar[_[c_], {n_}] := {"$(", c, psops[[n]]}

PSChar[c_, {n_}] := {"(", c, psops[[n]]}

psops = {")# ", ")_ ", ")^ ", ")~ "}


TeXRender[LabelText[t_, pos_, align_, size_, ___]] :=
Block[ {ComposedChar = TeXComposedChar},
  TeXString[
    "\\FALabel", pos, "[" <> Extract[texalign, align + {2, 2}] <> "]{" <>
    Which[size > 1, "\\large ", size < 1, "\\small ", True, ""] <>
    "$", t, "$}\n" ]
]

texalign = {{"bl", "l", "tl"},
            {"b",  "",  "t"},
            {"br", "r", "tr"}}

TeXComposedChar[t_, sub_:Null, super_:Null, over_:Null] :=
Block[ {tex = t},
  If[ sub =!= Null, tex = tex <> "_" <> ToString[sub] ];
  If[ super =!= Null, tex = tex <> "^" <> ToString[super] ];
  If[ over =!= Null, tex = ToString[over] <> " " <> tex ];
  tex
]

If[ $VersionNumber >= 6 || $Notebooks,

MmaRender[LabelText[t_, pos_, align_, size_, ___]] := Text[
  StyleForm[DisplayForm[MmaChar@@ Flatten[{ToUnicode[t]}]],
    FontFamily -> LabelFont,
    FontSize -> size fsize],
  pos, align ];

MmaChar[t__, Null] := MmaChar[t];

MmaChar[t_, sub_, super_, over_] :=
  MmaChar[OverscriptBox[t, over], sub, super];

MmaChar[t_, Null, super_] := SuperscriptBox[t, super];

MmaChar[t_, sub_, super_] := SubsuperscriptBox[t, sub, super];

MmaChar[t_, sub_] := SubscriptBox[t, sub];

MmaChar[t_] := RowBox[{t}],

(* else $Notebooks *)

MmaRender[LabelText[t_, r__]] :=
  MapIndexed[ KernelChar[##, r]&, Flatten[{ToPS[t]}] ];

KernelChar[_[], __] = {};

KernelChar[t_, {n_}, pos_, align_, size_, ___] :=
Block[ {newpos, newalign, fscale = sizes[[n]] size},
  {newpos, newalign} = If[ size < 1, {pos, align},
    {pos + .24 size LabelFontSize (palign[[n]] - align), talign[[n]]} ];
  Text[MmaChar[t], newpos, newalign]
];

MmaChar[_[c_]] := FontForm[c, {"Symbol", fscale fsize}];

MmaChar[c_] := FontForm[c, {LabelFont, fscale fsize}];

sizes = {1, .667, .667, 1};

palign = {{0, 0}, {1.2, -.9}, {1.2, .7}, {0, 1.2}};

talign = {{0, 0}, {-1, 0}, {-1, 0}, {0, -1}};

] (* endif $Notebooks *)


Attributes[WithinBorders] = {Listable}

WithinBorders[x_, border_:0] :=
  If[NumberQ[x], Min[Max[x, border], 20 - border], x]


vcode = "\
abcdefghijklmnopqrstuvwxyz\
ABCDEFGHIJKLMNOPQRSTUVWXYZ\
0987654321"

pcode[_[Incoming | External][c__]] := {{c}, {}, {}}

pcode[_[Outgoing][c__]] := {{}, {c}, {}}

pcode[_[c__]] := {{}, {}, {c}}

TopologyCode[top:P$Topology] :=
  ToFileName[Drop[#, -1], Last[#] <> ".m"]&[
    StringJoin/@ Transpose[pcode/@
      Apply[StringTake[vcode, {#}]&, Take[#, 2]&/@ List@@ top, {2}]] /.
      "" -> "0" ]

TopologyCode[top_ -> _] := TopologyCode[top]

TopologyCode[tops:TopologyList[___][___] | TopologyList[___]] :=
  TopologyCode/@ List@@ tops


TopologyFile[topcode_] := ToFileName[$ShapeDataDir, topcode]


MkDir[dir_String] := dir /; FileType[dir] === Directory

MkDir[dir_String] := Check[CreateDirectory[dir], Abort[]]

PutShape[shapedata_, topcode_] := (
  MkDir[DirectoryName[#]];
  Put[Take[shapedata, 3], #]
)& @ TopologyFile[topcode]


ShapeSources = { ##,
  VFlip[##],
  HFlip[##, VFlip[##]],
  Automatic
}&[ ShapeData, File ]

ShapeHook[s_, ___] := s

ShapeInfo[n_, info___][{__, s_}] :=
  FAPrint[2, "> Top. ", n, " ", s, info]

FindShape[top_, sources_, msg_] :=
Block[ {gtop, topcode, ret},
  gtop = Take[#, 2]&/@ Topology@@ top /.
    External -> Incoming /. Vertex[e_, _] :> Vertex[e];
  topcode = TopologyCode[gtop];
  ret[shapedata_] := (
    msg[shapedata];
    Throw[ ShapeData[topcode] = Replace[
      EditShape[edit[0] @ shapedata[[4]], gtop, topcode,
        ShapeHook[shapedata, gtop, topcode]] /. r_Real :> Round[r, .001],
      xy:{_?NumberQ, _?NumberQ} :> WithinBorders/@ xy, {3} ] ]
  );
  Catch[GetShape[gtop, #[topcode]]&/@ sources]
]


GetShape[_, {__, _[s_]}] := 0 /; Level[s, {-1}, edit[1]]

GetShape[_, shapedata_List] := ret[shapedata]

GetShape[_, File[topcode_]] :=
  If[ FileType[#] === File, ret[Append[Get[#], topcode]] ]& @
    TopologyFile[topcode]

Global`GetFlip[top_, f_] :=
Block[ {ru, ntop, ftop, map, fshape},
  ru = FlipRules[ f,
    Sort[Cases[top, _[Incoming][v_, _] :> v]],
    Sort[Cases[top, _[Outgoing][v_, _] :> v]] ];
  ntop = top /. ru;
  {ftop, map} = TopologyOrdering[ntop];
  {ru, ntop, ftop, map}
]

GetShape[top_, f_[fsources__][_]] :=
Block[ {ru, ntop, ftop, map, fshape},
  ru = FlipRules[ f,
    Sort[Cases[top, _[Incoming][v_, _] :> v]],
    Sort[Cases[top, _[Outgoing][v_, _] :> v]] ];
  ntop = top /. ru;
  {ftop, map} = TopologyOrdering[ntop];
  fshape = FindShape[ftop, {fsources}, List];
  FlipShape[f, ntop, ftop, map, fshape /. Reverse/@ ru]
]

FlipRules[VFlip, in_, out_] :=
  Thread[Join[out, in] -> Reverse[Join[in, out]]]

FlipRules[HFlip, in_, out_] :=
  Flatten[{Thread[# -> Sort[#]]& @ Join[out, in],
    Incoming -> Outgoing, Outgoing -> Incoming}]

FlipShape[f_, ntop_, ftop_, map_, {v_, p_, l_, s_}] :=
Block[ {ord = Ordering[Abs[map]], vord, vmap},
  vord = Flatten[(4 Abs[#] - 1 + Sign[#] {-1, 1})/2&/@ map];
  vmap = Thread[ Level[ftop, {2}] -> Level[ntop, {2}][[vord]] ];
  ret @ Level[{{Sort[fvert[f]/@ v /. vmap]},
    Transpose[ MapThread[fprop[f], {p, l, map}][[ord]] ],
    {f[s]}}, {2}]
] /; Depth[s] < 3	(* avoid e.g. VFlip[HFlip[VFlip[.]]] *)


fvert[VFlip][v_ -> {x_, y_}] := v -> {x, DiagramCanvas - y}

fvert[HFlip][v_ -> {x_, y_}] := v -> {DiagramCanvas - x, y}


fprop[VFlip][{x_, y_}, {r_, fi_}, _] := {{x, DiagramCanvas - y}, {r, -fi}}

fprop[HFlip][{x_, y_}, {r_, fi_}, _] := {{DiagramCanvas - x, y}, {r, -fi}}

fprop[VFlip][{x_, y_}, l_, _] := {{x, DiagramCanvas - y}, l}

fprop[HFlip][{x_, y_}, l_, _] := {{DiagramCanvas - x, y}, l}

fprop[VFlip][h_, {r_, fi_}, s_] := {-Sign[s] h, {r, -Sign[s] fi}} /; h != 0

fprop[HFlip][h_, {r_, fi_}, s_] := {-Sign[s] h, {r, -fi}} /; h != 0

fprop[_][_, {r_, fi_}, s_] := {0, {r, If[s > 0, Pi - fi, -fi]}}

fprop[_][h_, l_, s_] := {-Sign[s] h, l} /; h != 0

fprop[_][_, l_, s_] := {0, -Sign[s] l}


GetShape[top_, _Automatic] :=
Block[ {shapedata, vert, props, ext, l, tree, mesh, mesh2, vars,
tadbr, tad, min, ok, c, ct, pt, shrink = {}, rev = {}, loops = {}},
  _props = {};
  top /. Propagator -> pr;
  loops = Union[loops];

  Off[FindMinimum::fmmp, FindMinimum::fmcv, FindMinimum::precw,
    FindMinimum::fmgz, FindMinimum::sdprec, FindMinimum::lstol];

	(* a) fix the incoming and outgoing propagators on the left and
	      right side, respectively *)
  shapedata = Join[
    l = Length[props[Incoming]]/20.;
    MapIndexed[
      #1[[1]] -> {0, 20 - Round[(#2[[1]] - .5)/l]}&,
      props[Incoming] ],
    l = Length[props[Outgoing]]/20.;
    MapIndexed[
      #1[[1]] -> {20, 20 - Round[(#2[[1]] - .5)/l]}&,
      props[Outgoing] ] ];

	(* b) shrink loops to 1 point which is the center of an imaginary
	      circle on which the external points of the loop lie *)
  vert = Flatten[props[Tree]];
  tree = Fold[
    ( l = Flatten[props[#2]];
      ext[#2] = l = Select[vert, MemberQ[l, #]&];
      AppendTo[ rev, c = center[Length[l]][#2] -> Union[l] ];
      shrink = {shrink, c = Thread[Reverse[c]]};
      #1 /. c )&,
    props[Tree], loops ];
  shrink = Flatten[shrink];

	(* c) cut tadpole-like parts and minimize the length of the
	      remaining mesh of propagators *)
  mesh2 = Leaves@@ twig@@@ (tree /. shapedata) /. twig -> List;
  _tadbr = {};
  Cases[mesh2, branch[ctr:center[_][_], v_, ___] :>
    (tadbr[ctr] = Flatten[{tadbr[ctr], v /. rev}]), Infinity];
  mesh = mesh2 /. branch[__] :> Seq[];
  vert = Cases[mesh, leaf[a_] :> a];
  mesh = mesh /. _leaf :> Seq[];
  mesh = List@@ Fold[
    Replace[#1, x:{__, #2} :> Reverse[x], {1}] /.
      Leaves[x:{#2, __}, {#2, b__}] :> Leaves[{Sequence@@ Reverse[x], b}]&,
    mesh,
    vert = Union[vert, Cases[mesh, _[2, ___][_], {2}]]
  ] /. twig -> List;
  vert = (# -> CartesianVar[#])&/@
    Complement[Cases[mesh, _[__][_], {2}], vert];
  If[ Length[vert] =!= 0,
    dist = Distance2@@@ (mesh /. vert);
    dist = Expand[Apply[Plus, Outer[(#1 - #2)^2 &, dist, dist], {0, 1}]];
    vars = Flatten[Last/@ vert];
    min := FindMinimum@@ Prepend[{#, 10 + Random[]}&/@ vars, dist];
    Do[
      If[ ok = (Head[c = min] =!= FindMinimum &&
                Min[ l = Last/@ c[[2]] ] >= 0 &&
                Max[l] <= 20), Break[] ],
    {5} ];
    vert = vert /.
      If[ ok, MapAt[Round, #, 2]&/@ c[[2]], (# -> RandInt)&/@ vars ]
  ];
  shapedata = Join[shapedata, vert];
  shapedata = Flatten[ {shapedata,
    (l = (#[[-1]] - (c = #[[1]]))/(Length[#] - 1);
     MapIndexed[#1 -> c + l #2[[1]] &, Take[#, {2, -2}]])&/@
      (Select[mesh, Length[#] > 2 &] /. shapedata)} ];

	(* d) minimizing the straight distance of a tadpole to its
	      nearest vertex v would make the tadpole stick to v.
	      Therefore, the tadpole is given polar coordinates with
	      fixed radius and we try to construct the ideal angle with
	      respect to the lines joining at v by maximizing. *)
  mesh2 = (List@@ mesh2) /.
    leaf[br__] :> Sequence@@ Cases[{br}, branch[__]] /. shapedata;
  While[ Length[ tad = Cases[mesh2, branch[{_, _}, __]] ] =!= 0,
    mesh2 = Fold[FixTad, mesh2, tad] ];

	(* e) for each loop, distribute the external points of the loop
	      at the middle of the line from the center to the external
	      vertex and distribute the remaining points of the loop
	      on the imaginary circle around the center. *)
  ok = shapedata;
  Scan[
    Function[rul,
      If[ Length[ vert = Union[ext[ rul[[1,1]] ]] ] === 1,
        c = SetTadpole[vert[[1]], rul],
        SetMiddle[#, rul]&/@ vert; c = rul[[2]] ];
      SetLoop[props[ rul[[1,1]] ] /. shapedata, c] ],
    Select[shapedata, !FreeQ[#, center]&] ];

	(* f) last resort: randomize any remaining vertex *)
  shapedata = Join[ MapAt[Inside, #, 2]&/@ shapedata,
    (# -> {RandInt, RandInt})&/@
      Union[Cases[top /. shapedata, Vertex[__][_], Infinity]] ];

	(* g) give tadpoles and identical propagators curvature so that
	      they do not fall on top of each other *)
  pt[ _[Loop[n_]][v_, v_], _ ] :=
    center[ Length[ext[n]] ][n] /. shapedata /. center[_][_] :>
      Inside[ (v /. shapedata) + 4 Through[{Cos, Sin}[2. NPi Random[]]] ];
  pt[ _, 0 ] = 0;
  ct[ p_ ] := If[ (c = (Count[top, p] - 1)/2) === 0, 0,
    pt[ p, n_ ] := .8 n/c;
    ct[ p ] = c
  ];

  On[FindMinimum::fmmp, FindMinimum::fmcv, FindMinimum::precw,
    FindMinimum::fmgz, FindMinimum::sdprec, FindMinimum::lstol];

  vert = unsame@@ Select[shapedata, FreeQ[#, center]&];

  ret @ { Sort[List@@ vert],
    pt[#, ct[#]--]&/@ List@@ top,
    Table[1, {Length[top]}],
    Automatic }
]


Attributes[unsame] = {Flat, Orderless}

unsame[v1_ -> p1:{x1_, y1_}, v2_ -> p2:{x2_, y2_}] :=
Block[ {shift},
  shift = If[Abs[x1 - 10] < Abs[y1 - 10], {1, 0}, {0, 1}];
  unsame[v1 -> WithinBorders[p1 + shift, 1],
         v2 -> WithinBorders[p2 - shift, 1]]
] /; (x2 - x1)^2 + (y2 - y1)^2 < .1


pr[Loop[l_]][from_, to_, ___] := (
  AppendTo[loops, l];
  AppendTo[props[l], {from, to}] )

pr[type_][from_, to_, ___] := (
  AppendTo[props[Tree], {from, to}];
  AppendTo[props[type], {from, to}] )


Attributes[twig] = {Orderless}

twig[a:_[1, ___][_], b_] := branch[b, a]

Attributes[Leaves] = {Orderless, Flat}

Leaves[branch[a_, b__], twig[a:_[2, ___][_], c_]] :=
  Leaves[branch[c, a, b]]

Leaves[br:branch[a_, __].., tw:twig[a_, _]..] :=
  Switch[ Length[{tw}],
    1, Leaves[branch[ Sequence@@ DeleteCases[tw, a], a, br ]],
    2, Leaves[leaf[br, a], tw],
    _, Leaves[leaf[br], tw]
  ]

cutbranch[vert__, br___branch] :=
  Sequence[br, Drop[{vert}, {2, -2}]]


Inside[xy_] := Max[Min[#, 20], 0]&/@ N[xy]

RandInt := Plus@@ Table[Random[Integer, 9], {2}] + 1


Distance[p1_, p2_] := Sqrt[# . #]&[p2 - p1]

Distance2[p1_, ___, p2_] := (# . #)&[p2 - p1]

Orientation[p1_, p2_] := N[ArcTan@@ (p2 - p1)] /; p1 != p2

_Orientation = 0


CartesianVar[n_] := CartesianVar[n] = {Unique["X"], Unique["Y"]}


FixTad[mesh_, br_] :=
Block[ {stem, root, c, phi, dphi, vert, min, dist},
  stem = DeleteCases[List@@ br, branch[__]];
  c = (root = stem[[1]]) + (Length[stem] + 1) {Cos[phi], Sin[phi]};
  vert = Cases[mesh, {a___, root, b___} :> Seq[a, b]];
  Switch[ Length[vert],
    0, phi = 0,
    1, phi = Orientation[vert[[1]], root],
    _, dist = -Plus@@ (Distance[c, #]&)/@ vert;
       Do[
         If[ Head[min = FindMinimum[dist, {phi, 1.57 + dphi}]] =!=
               FindMinimum &&
             Min[ min = c /. min[[2]] ] >= 0 &&
             Max[min] <= 20, c = min; Break[] ],
       {dphi, 0, 2. NPi, .5 NPi} ];
       phi = 2. NPi Random[]
  ];
  If[ Min[c] < 0 || Max[c] > 20, c = {RandInt, RandInt} ];
  c = (c - root)/(Length[stem] - 1);
  vert = MapIndexed[#1 -> root + #2[[1]] c &, Rest[stem]];
  shapedata = Join[shapedata, vert];
  mesh /. br -> cutbranch@@ br /. vert
]


SetLoop[loop_, ctr_] :=
Block[ {vert, vars, rad, angle, off, min, c = 0},
  vert = Union[Cases[loop, _[__][_], {2}]];
  If[ Length[vert] =!= 0,
    rad = Union[Cases[loop, _List, {2}]];
    rad = If[ Length[rad] === 0, 5,
      Plus@@ (Distance[#, ctr]&/@ rad)/Length[rad] ];
    angle = 2. NPi/Length[vert];
    vars = (# -> ctr + rad Through[{Cos, Sin}[++c angle + off]])&/@ vert;
    min = FindMinimum@@ {
      -Plus@@ Distance@@@ (loop /. vars),
      {off, 2. NPi Random[]} };
    shapedata = Join[shapedata,
      If[ Head[min] === FindMinimum,
        vars /. off -> 2. NPi Random[],
      (* else *)
        c = vars /. min[[2]];
        If[ Length[Intersection[
          Round[Last/@ c], Round[Last/@ shapedata] ]] === 0,
          c,
          # -> ctr + Random[] rad Through[{Sin, Cos}[2. NPi Random[]]]&/@
            vert ]
      ]]
  ];
]


SetMiddle[vert_, ctr_ -> xy_] :=
Block[ {ex, mid},
  ex = DeleteCases[Flatten[Select[props[Tree], !FreeQ[#, vert]&]], vert];
  If[ Length[ex] =!= 0,
    If[ Length[mid = Complement[ex, tadbr[ctr]]] =!= 0, ex = mid ];
    ex = ex /. shrink /. shapedata;
    While[ Length[ex] =!= 0 && (mid = Plus@@ ex/Length[ex]) == xy,
      ex = Rest[ex] ];
    If[ Length[ex] === 0, mid = {RandInt, RandInt} ];
    AppendTo[shapedata, vert -> .6 xy + .4 mid]
  ]
]


SetTadpole[vert_, ctr_ -> xy_] :=
Block[ {adj, max, new, a1, a2},
  adj = Select[tree, !FreeQ[#, ctr]&] /. ok;
  shapedata = shapedata /. ctr -> vert;
  If[ Length[adj] === 1,
    new = 2.6 xy - .8 Plus@@ adj[[1]],
  (* else *)
    adj = Orientation@@@ (adj /. {a_, xy} :> {xy, a});
    max = -1;
    Outer[
      If[ (new = Abs[#2 - #1]) > max, max = new; a1 = #1; a2 = #2 ]&,
      adj, adj ];
    new = xy + 4 Through[{Cos, Sin}[.5 (a1 + a2)]] ];
  If[ Distance2[xy, max = Inside[new]] < 2.8,
    shapedata = shapedata /. xy -> xy - .7 (new - max) ];
  AppendTo[shapedata, ctr -> max];
  max
]


ToJava[p__, n_?NumberQ] := ToJava[p, {n DefaultRadius, 0.}]

ToJava[_[from_, from_], {xc_, yc_}, {xl_, yl_}] :=
  {-from, xc, yc, xl, yl}

ToJava[_[from_, to_], height_, {xl_, yl_}] :=
  {from, to, height, xl, yl}


(* call the topology editor *)

Shape::wait =
"Starting Java and the topology editor.  This may take a moment."

Shape::notopedit =
"Could not load the topology editor.  Make sure you have J/Link and Java
installed."

Shape::javaerror =
"Could not open a topology-editor window."

Options[ Shape ] = {
  NumberFrom -> 1,
  EditFlips -> False
}

Shape[tops:TopologyList[___][___] | TopologyList[___], options___] :=
Block[ {n, edit, editor, closeEditor, shapes,
opt = ActualOptions[Shape, options]},
  n = NumberFrom /. opt;
  If[ EditFlips /. opt,
    edit[1][_] = False,
  (* else *)
    edit[_][_[_]] = False ];
  edit[_][_] = True;
  shapes = FindShape[#, ShapeSources, ShapeInfo[n++]]&/@ List@@ tops;
  closeEditor[];
  shapes
]

Shape[top:P$Topology -> _, options___] :=
  Shape[TopologyList[top], options]

Shape[top:P$Topology, options___] :=
  Shape[TopologyList[top], options]


EditShape[True, top_, topcode_, raw_] :=
Block[ {v, arg1, arg2, exitcode, shapedata = raw},
  If[ editorclass === False,
    Message[Shape::wait];
    Needs["JLink`"];
    JLink`InstallJava[];
    AppendTo[JLink`$ExtraClassPath,
      ToFileName[$FeynArtsProgramDir, "TopologyEditor.jar"]];
    editorclass = JLink`LoadClass["de.FeynArts.TopologyEditor"];
    If[ Head[editorclass] =!= JLink`JavaClass, Message[Shape::notopedit] ]
  ];
  If[ Head[editorclass] =!= JLink`JavaClass, Return[shapedata] ];

  If[ !JLink`JavaObjectQ[editor],
    editor = JLink`JavaNew[editorclass];
    If[ !JLink`JavaObjectQ[editor],
      Message[Shape::javaerror];
      Return[shapedata] ];
    closeEditor[] := (
      editor@closeWindow[];
      JLink`ReleaseObject[editor];
      editor = False )
  ];

  ( {v, arg1} = Transpose[List@@@ #1];
    arg2 = MapThread[ ToJava,
      {List@@ top /. Thread[v -> Range[Length[v]]], #2, #3} ];
    editor@putShapeData[ N[Flatten[arg1]], N[Flatten[arg2]] ]
  )&@@ shapedata;

  Switch[ JLink`DoModal[],
    0, shapedata = {Thread[v -> #1], ##2, topcode}&@@
         editor@getShapeData[];
       PutShape[shapedata, topcode],
    2, closeEditor[]; Abort[]
  ];

  edit[_][topcode] = False;
  shapedata
]

EditShape[__, shapedata_] := shapedata


editorclass = editor = False

remaining = 0


ToPS["\\alpha"] = SymbolChar["a"];
ToPS["\\beta"] = SymbolChar["b"];
ToPS["\\gamma"] = SymbolChar["g"];
ToPS["\\delta"] = SymbolChar["d"];
ToPS["\\epsilon"] = ToPS["\\varepsilon"] = SymbolChar["e"];
ToPS["\\zeta"] = SymbolChar["z"];
ToPS["\\eta"] = SymbolChar["h"];
ToPS["\\theta"] = SymbolChar["q"];
ToPS["\\vartheta"] = SymbolChar["J"];
ToPS["\\iota"] = SymbolChar["i"];
ToPS["\\kappa"] = SymbolChar["k"];
ToPS["\\lambda"] = SymbolChar["l"];
ToPS["\\mu"] = SymbolChar["m"];
ToPS["\\nu"] = SymbolChar["n"];
ToPS["\\xi"] = SymbolChar["x"];
ToPS["\\pi"] = SymbolChar["p"];
ToPS["\\varpi"] = SymbolChar["v"];
ToPS["\\rho"] = ToPS["\\varrho"] = SymbolChar["r"];
ToPS["\\sigma"] = SymbolChar["s"];
ToPS["\\varsigma"] = SymbolChar["V"];
ToPS["\\tau"] = SymbolChar["t"];
ToPS["\\upsilon"] = SymbolChar["u"];
ToPS["\\phi"] = SymbolChar["f"];
ToPS["\\varphi"] = SymbolChar["j"];
ToPS["\\chi"] = SymbolChar["c"];
ToPS["\\psi"] = SymbolChar["y"];
ToPS["\\omega"] = SymbolChar["w"];
ToPS["\\Gamma"] = SymbolChar["G"];
ToPS["\\Delta"] = SymbolChar["D"];
ToPS["\\Theta"] = SymbolChar["Q"];
ToPS["\\Lambda"] = SymbolChar["L"];
ToPS["\\Xi"] = SymbolChar["X"];
ToPS["\\Pi"] = SymbolChar["P"];
ToPS["\\Sigma"] = SymbolChar["S"];
ToPS["\\Upsilon"] = SymbolChar["\241"];
ToPS["\\Phi"] = SymbolChar["F"];
ToPS["\\Psi"] = SymbolChar["X"];
ToPS["\\Omega"] = SymbolChar["W"];
ToPS["\\infty"] = SymbolChar["\245"];
ToPS["\\pm"] = SymbolChar["\261"];
ToPS["\\partial"] = SymbolChar["\266"];
ToPS["\\leq"] = SymbolChar["\243"];
ToPS["\\geq"] = SymbolChar["\263"];
ToPS["\\times"] = SymbolChar["\264"];
ToPS["\\otimes"] = SymbolChar["\304"];
ToPS["\\oplus"] = SymbolChar["\305"];
ToPS["\\nabla"] = SymbolChar["\321"];
ToPS["\\neq"] = SymbolChar["\271"];
ToPS["\\equiv"] = SymbolChar["\272"];
ToPS["\\approx"] = SymbolChar["\273"];
ToPS["\\ldots"] = SymbolChar["\274"];
ToPS["\\in"] = SymbolChar["\316"];
ToPS["\\notin"] = SymbolChar["\317"];
ToPS["\\sim"] = SymbolChar["\176"];
ToPS["\\sqrt"] = SymbolChar["\326"];
ToPS["\\propto"] = SymbolChar["\265"];
ToPS["\\subset"] = SymbolChar["\314"];
ToPS["\\supset"] = SymbolChar["\311"];
ToPS["\\subseteq"] = SymbolChar["\315"];
ToPS["\\supseteq"] = SymbolChar["\312"];
ToPS["\\bullet"] = SymbolChar["\267"];
ToPS["\\perp"] = SymbolChar["^"];
ToPS["\\simeq"] = SymbolChar["@"];
ToPS["\\vee"] = SymbolChar["\332"];
ToPS["\\wedge"] = SymbolChar["\331"];
ToPS["\\leftrightarrow"] = SymbolChar["\253"];
ToPS["\\leftarrow"] = SymbolChar["\254"];
ToPS["\\rightarrow"] = ToPS["\\to"] = SymbolChar["\256"];
ToPS["\\uparrow"] = SymbolChar["\255"];
ToPS["\\downarrow"] = SymbolChar["\257"];
ToPS["\\Leftarrow"] = SymbolChar["\334"];
ToPS["\\Rightarrow"] = SymbolChar["\336"];
ToPS["\\Uparrow"] = SymbolChar["\335"];
ToPS["\\Downarrow"] = SymbolChar["\337"];
ToPS["\\bar"] = "\305";
ToPS["\\hat"] = "\303";
ToPS["\\tilde"] = "\304";
ToPS["\\dot"] = "\307";
ToPS["\\ddot"] = "\310";
ToPS["\\vec"] = SymbolChar["\256"];
ToPS["\\prime"] = "'";
ToPS["\\#"] = "#";
ToPS["\\&"] = "&";
ToPS["\\$"] = "$";
ToPS["\\%"] = "%";
ToPS["\\_"] = "_";
ToPS["-"] = SymbolChar["-"];
ToPS[Null] = SymbolChar[];
ToPS[ComposedChar[t__]] := ToPS/@ {t};
ToPS[c_] := ToString[c]

ToUnicode["\\alpha"] = "\[Alpha]";
ToUnicode["\\beta"] = "\[Beta]";
ToUnicode["\\gamma"] = "\[Gamma]";
ToUnicode["\\delta"] = "\[Delta]";
ToUnicode["\\epsilon"] = "\[Epsilon]";
ToUnicode["\\varepsilon"] = "\[CurlyEpsilon]";
ToUnicode["\\zeta"] = "\[Zeta]";
ToUnicode["\\eta"] = "\[Eta]";
ToUnicode["\\theta"] = "\[Theta]";
ToUnicode["\\vartheta"] = "\[CurlyTheta]";
ToUnicode["\\iota"] = "\[Iota]";
ToUnicode["\\kappa"] = "\[Kappa]";
ToUnicode["\\lambda"] = "\[Lambda]";
ToUnicode["\\mu"] = "\[Mu]";
ToUnicode["\\nu"] = "\[Nu]";
ToUnicode["\\xi"] = "\[Xi]";
ToUnicode["\\pi"] = "\[Pi]";
ToUnicode["\\varpi"] = "\[CurlyPi]";
ToUnicode["\\rho"] = "\[Rho]";
ToUnicode["\\varrho"] = "\[CurlyRho]";
ToUnicode["\\sigma"] = "\[Sigma]";
ToUnicode["\\varsigma"] = "\[FinalSigma]";
ToUnicode["\\tau"] = "\[Tau]";
ToUnicode["\\upsilon"] = "\[Upsilon]";
ToUnicode["\\phi"] = "\[Phi]";
ToUnicode["\\varphi"] = "\[CurlyPhi]";
ToUnicode["\\chi"] = "\[Chi]";
ToUnicode["\\psi"] = "\[Psi]";
ToUnicode["\\omega"] = "\[Omega]";
ToUnicode["\\Gamma"] = "\[CapitalGamma]";
ToUnicode["\\Delta"] = "\[CapitalDelta]";
ToUnicode["\\Theta"] = "\[CapitalTheta]";
ToUnicode["\\Lambda"] = "\[CapitalLambda]";
ToUnicode["\\Xi"] = "\[CapitalXi]";
ToUnicode["\\Pi"] = "\[CapitalPi]";
ToUnicode["\\Sigma"] = "\[CapitalSigma]";
ToUnicode["\\Upsilon"] = "\[CapitalUpsilon]";
ToUnicode["\\Phi"] = "\[CapitalPhi]";
ToUnicode["\\Psi"] = "\[CapitalPsi]";
ToUnicode["\\Omega"] = "\[CapitalOmega]";
ToUnicode["\\infty"] = "\[Infinity]";
ToUnicode["\\pm"] = "\[PlusMinus]";
ToUnicode["\\partial"] = "\[PartialD]";
ToUnicode["\\leq"] = "\[LessEqual]";
ToUnicode["\\geq"] = "\[GreaterEqual]";
ToUnicode["\\times"] = "\[Times]";
ToUnicode["\\otimes"] = "\[CircleTimes]";
ToUnicode["\\oplus"] = "\[CirclePlus]";
ToUnicode["\\nabla"] = "\[Del]";
ToUnicode["\\neq"] = "\[NotEqual]";
ToUnicode["\\equiv"] = "\[Congruent]";
ToUnicode["\\approx"] = "\[TildeTilde]";
ToUnicode["\\ldots"] = "\[Ellipsis]";
ToUnicode["\\in"] = "\[Element]";
ToUnicode["\\notin"] = "\[NotElement]";
ToUnicode["\\sim"] = "\[Tilde]";
ToUnicode["\\sqrt"] = "\[Sqrt]";
ToUnicode["\\propto"] = "\[Proportional]";
ToUnicode["\\subset"] = "\[Subset]";
ToUnicode["\\supset"] = "\[Superset]";
ToUnicode["\\subseteq"] = "\[SubsetEqual]";
ToUnicode["\\supseteq"] = "\[SupersetEqual]";
ToUnicode["\\bullet"] = "\[FilledSmallCircle]";
ToUnicode["\\perp"] = "\[RightAngle]";
ToUnicode["\\simeq"] = "\[TildeEqual]";
ToUnicode["\\vee"] = "\[Vee]";
ToUnicode["\\wedge"] = "\[Wedge]";
ToUnicode["\\leftrightarrow"] = "\[LeftRightArrow]";
ToUnicode["\\leftarrow"] = "\[LeftArrow]";
ToUnicode["\\rightarrow"] = ToUnicode["\\to"] = "\[RightArrow]";
ToUnicode["\\uparrow"] = "\[UpArrow]";
ToUnicode["\\downarrow"] = "\[DownArrow]";
ToUnicode["\\Leftarrow"] = "\[DoubleLeftArrow]";
ToUnicode["\\Rightarrow"] = "\[DoubleRightArrow]";
ToUnicode["\\Uparrow"] = "\[DoubleUpArrow]";
ToUnicode["\\Downarrow"] = "\[DoubleDownArrow]";
ToUnicode["\\bar"] = "_";
ToUnicode["\\hat"] = "^";
ToUnicode["\\tilde"] = "~";
ToUnicode["\\dot"] = "\[CenterDot]";
ToUnicode["\\ddot"] = "\[CenterDot]\[CenterDot]";
ToUnicode["\\vec"] = "\[RightVector]";
ToUnicode["\\prime"] = "'";
ToUnicode["\\#"] = "#";
ToUnicode["\\&"] = "&";
ToUnicode["\\$"] = "$";
ToUnicode["\\%"] = "%";
ToUnicode["\\_"] = "_";
ToUnicode[Null] = Null;
ToUnicode[ComposedChar[t__]] := ToUnicode/@ {t};
ToUnicode[c_] := ToString[c]

End[]

