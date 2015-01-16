(*
	Graphics.m
		Graphics routines for FeynArts
		last modified 30 May 00 th
*)

Begin["`Graphics`"]

NPi = N[Pi]

	(* The font size used for the propagator labels in a 3x3 sheet.
	   For other ColumnsXRows settings the font will be scaled
	   accordingly; the graph numbering is displayed in .9 of this
	   size. The font size for the header is 1.2 LabelFontSize
	   independent of the number of diagrams on the sheet. *)
LabelFontSize = 10.

TextFont = "Helvetica"

	(* PlotRange for a single diagram *)
GraphArea = {{-1, 21}, {-1, 21}}

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

ArrowLength = 1.2

ArrowAngle = .1 NPi

	(* height of an arrow's thick end over the baseline, should
	   really be ArrowLength Sin[ArrowAngle], but this looks ugly
	   because arrows seem to be overly bent then *)
ArrowHeight = .5 ArrowLength Sin[ArrowAngle]

	(* for counter terms: *)
CrossDiameter = 1.

	(* for ordinary vertices and counter terms: *)
VertexThickness = {PointSize[.04], Thickness[.015]}

PropThickness = Thickness[.005]

ScalarDash = Dashing[{.03, .03}]

GhostDash = Dashing[{.005, .03}]

	(* default delta_r for label positioning,
	   must be the same as DEFAULT_DR in TopEdit.tm *)
DefaultDR = 1.3

$TeXPictureSize = {4}

Centimeters = 1 / 2.54


Options[ Paint ] = {
  PaintLevel -> InsertionLevel,
  FileBaseName -> ProcessName,
  ColumnsXRows -> 3,
  AutoEdit -> True,
  TeXLabels -> False,
  SheetHeader -> Automatic,
  Numbering -> True,
  FieldNumbers -> False,
  Destination -> Screen
}

Paint::nolevel =
"Warning: Level `1` is not contained in this insertion."

Paint::colrows =
"ColumnsXRows is not an integer or a pair of integers."

Paint[ top:P$Topology, opt___Rule ] :=
  Paint[ TopologyList[top], opt ]

Paint[ top:(P$Topology -> _), opt___Rule ] :=
  Paint[ TopologyList[][top], opt ]

Paint[ tops_TopologyList, options___Rule ] :=
Block[ {screen, file, ghead, glabel, fnum, vfuncs = False,
opt = ActualOptions[Paint, options]},
  screen = Destination /. opt /. All -> {File, Screen};
  file = If[ FreeQ[screen, File], False,
    ToString[FileBaseName /. opt /. ProcessName -> "Topology"] ];

  ghead = Switch[ ghead = SheetHeader /. opt,
    False,
      {},
    Automatic | True, 
      ghead = #[[0, 1]]&/@ tops[[1]];
      { Count[ghead, Incoming | External],
        Null, Null, "\\to", Null, Null,
        Count[ghead, Outgoing] },
    _,
      ToString[ghead]
  ];
  glabel[ _ ] = "";
  fnum = FieldNumbers /. opt;

  PaintSheet[ tops, ColumnsXRows /. opt ]
]

Paint[ tops:TopologyList[info___][__], options___Rule ] :=
Block[ {plevel, ins, screen, file, ghead, glabel, vfuncs,
fnum = False, opt = ActualOptions[Paint, options]},

  If[ (plevel = ResolveLevel[PaintLevel /. opt /. {info} /.
        Options[InsertFields]]) === $Aborted,
    Return[$Aborted] ]; 

  ins = PickLevel[plevel][tops];
  If[ FreeQ[plevel, Generic],
    ins = Select[
      ins /. Insertions[Generic][ gr__ ] :> Join@@ TakeIns/@ {gr},
      Length[#] =!= 0 & ] ];
  Scan[ If[FreeQ[ins, #], Message[Paint::nolevel, #]]&, plevel ];

  If[ InitializeModel[ Model /. {info} /. Options[InsertFields],
    GenericModel -> (GenericModel /. {info} /. Options[InsertFields]),
    Reinitialize -> False ] === $Aborted, Return[$Aborted] ];

  screen = Destination /. opt /. All -> {File, Screen};
  file = If[ FreeQ[screen, File], False,
    ToString[FileBaseName /. opt /. {info}] ];
  vfuncs = VertexFunctions /. {info};

  ghead = Switch[ ghead = SheetHeader /. opt,
    False,
      {},
    Automatic | True, 
      If[ (ghead = Process /. {info}) === Process, {},
        ghead = Join[ TheLabel/@ ghead[[1]], {"\\to"},
          TheLabel/@ ghead[[2]] ];
        Flatten[
          Insert[ghead, Null, Array[List, Length[ghead] - 1, 2]] ] ],
    _,
      ToString[ghead]
  ];
  glabel[ gr_ ] := StringJoin[
    Cases[ Head[gr], lev_ == n_ :>
      "  " <> StringTake[ToString[lev], 1] <> ToString[n] ],
    "  N", ToString[++runnr] ];

  PaintSheet[
    ins //. (x:Graph[___][__] -> Insertions[_][gr___]) :> Seq[x, gr],
    ColumnsXRows /. opt ]
]


PaintSheet[ tops_, cr_ ] :=
Block[ {auto, texlabels, cols, rows, psfile, xoff, yoff,
gscale, margin, aspect, fsize, thelabel,
dir = 0, page = 0, sheet = MDictAdd, res = {}, topnr = 0, runnr = 0},

  auto = AutoEdit /. opt /. {False -> 2, _ -> 1};
  texlabels = TrueQ[TeXLabels /. opt];

  Which[
    IntegerQ[cr], cols = rows = cr,
    MatchQ[cr, {_Integer, _Integer}], {cols, rows} = cr,
    True, Message[Paint::colrows]; cols = rows = 3 ];

  screen = !FreeQ[screen, Screen];
  If[ file =!= False && !texlabels,
    file = file <> ".mps";
    psfile = OpenWrite[file] ];

  margin = 0;
  gscale = cols;
  If[ ghead =!= {},
    ghead = {FontText[ghead, 1.2 LabelFontSize, {.5 cols, rows + .15}]} ];
  If[ (Numbering /. opt) === True,
    If[ texlabels,
      thelabel[ _ ] :=
        FontText["\\#" <> ToString[++runnr], .9 fsize, {10., .5}],
      thelabel[ gr_ ] :=
        FontText[tn <> glabel[gr], .9 fsize, {10., .5}] ],
    thelabel[ _ ] = Sequence[] ];

  margin = -GraphArea[[1, 1]];
  gscale = GraphArea[[1, 2]] + margin;
  aspect = (rows + .3) / cols;
  fsize = Max[ 4, 3 / If[aspect > 11. / 8.5, rows, cols] LabelFontSize ];
  xoff = 0;
  yoff = rows;
  Scan[TopologyGraphics, tops];
  If[ Length[sheet] =!= 0, FinishPage ];
  If[ file =!= False && !texlabels,
    WriteString[psfile, "%%Trailer\n"];
    Close[psfile];
    FAPrint[1, " (", file, ")"],
  (* else *)
    FAPrint[1, ""];
  ];
  res
]

Off[FrontEndObject::notavail]

	(* the Notebook cannot render direct PostScript primitives,
	   that's why we have to have NBRender; it's also used
	   by Arrow *)
NBRender[ ___ ] = Sequence[]


FinishPage :=
Block[ {nb = $Notebooks, $Notebooks = False},
  sheet = Graphics[ Join[sheet, ghead],
    PlotRange -> {{0, cols}, {0, rows + .3}},
    AspectRatio -> aspect ];
  AppendTo[res, sheet];
  If[ screen, Show[sheet /. p_PostScript :> NBRender[p] /; nb] ];
  If[ file =!= False,
    ++page;
    If[ texlabels,
      psfile = file <> "_" <> ToString[page] <> ".tex";
      If[ $Verbose >= 1, WriteString["stdout", " (", psfile, ") "] ];
      $TeXPictureSize = Flatten[{$TeXPictureSize}];
      Display[
        ToString[ StringForm["!`1`mpslatex_`2` `3` `4` > `5`",
          $FeynArtsDir, $Platform,
          $TeXPictureSize[[1]]//N, $TeXPictureSize[[-1]]//N, psfile] ],
        sheet],
    (* else *)
      WriteString[psfile, "%%Page: ", page, " ", page, "\n"];
      Display[psfile, sheet];
      WriteString[psfile, "showpage\n",
        "/Mwidth 8.5 72 mul def\n",
        "/Mheight 11 72 mul def\n"] ]
  ];
  xoff = 0;
  yoff = rows;
  sheet = {}
]


TopologyGraphics[ top_ -> gr_ ] :=
Block[ {ginfo, gtop, vertexplot, h, tn = "T" <> ToString[++topnr]},
  ginfo = Shape[top, auto];
  gtop = Transpose[{
    List@@ top /. ginfo[[1]],
    ginfo[[2]],
    ginfo[[3]] }] /. Propagator[_] -> Sequence;
  vertexplot = Flatten[ {VertexThickness,
    Vertices[top] /. Vertex -> VertexGraphics /. ginfo[[1]]} ] /.
    h -> List;
  If[ $Verbose >= 2, WriteString["stdout", "\n> Top. ", topnr, " "] ];
  Scan[
    ( If[ $Verbose >= 2, WriteString["stdout", "+"] ];
      AppendTo[ sheet,
        Rectangle[ {xoff, yoff - 1}, {xoff + 1, yoff},
          Graphics[ 
            { Prepend[
                Apply[ PropagatorGraphics,
                  gtop /. List@@ # /. Field[_] -> 0, {1} ],
                PropThickness ],
              vertexplot,
              thelabel[#] },
            PlotRange -> GraphArea,
            AspectRatio -> 1 ] ] ];
      If[ ++xoff >= cols,
        xoff = 0;
        If[ --yoff === 0, FinishPage ] ] )&,
    gr ];
]

TopologyGraphics[ top_ ] :=
  TopologyGraphics[
    MapIndexed[Append[ Take[#1, 2], #2[[1]] ]&, top] -> {{}} ] /; fnum

TopologyGraphics[ top_ ] :=
  TopologyGraphics[ Append[Take[#, 2], 0]&/@ top -> {{}} ]


VertexGraphics[ e_ ][ n_ ] := Point[Vertex[e][n]]

VertexGraphics[ e_, c_ ][ n_ ] := {
  h[ GrayLevel[Max[0, 1.1 - .3 c]], Disk[Vertex[e, c][n], CrossDiameter] ],
  h[ PropThickness, Circle[Vertex[e, c][n], CrossDiameter] ] } /; vfuncs

VertexGraphics[ e_, c_ ][ n_ ] := {
  CrossMark[ Vertex[e, c][n] ],
  Array[ Circle[Vertex[e, c][n], .5 # - .3 + CrossDiameter]&, c - 1 ] }


crad = .5 CrossDiameter

CrossMark[ xy_ ] := Disk[xy, crad] /; vfuncs

CrossMark[ {x_, y_} ] := {
  Line[ {{x - crad, y - crad}, {x + crad, y + crad}} ],
  Line[ {{x - crad, y + crad}, {x + crad, y - crad}} ] }


PropagatorGraphics[ from_, to_, particle_, ___, height_, label_ ] :=
Block[ {ctr, mid, lab, h, rad, dir, ommc, alpha, cs, dr, line,
damping, circ, tad, Forward = 0, Backward = NPi},
  cs := cs = {Cos[ommc], Sin[ommc]};
  If[ tad = to === from,
    circ = True;
    ctr = If[Head[height] === List, height, from + {0., 2.}];
    mid = .5 (from + ctr);
    rad = Distance[from, mid];
    ommc = Orientation[from, mid];
    dir = ommc + .5 NPi;
    alpha = NPi,
  (* else *)
    lab = .5 Distance[from, to];
    dir = Orientation[from, to];
    ommc = dir - .5 NPi;
    mid = ctr = .5 (from + to);
    If[ circ = TrueQ[height != 0],
      If[ height < 0, ommc += NPi ];
      alpha = 2. ArcTan[h = Abs[height]];
      rad = lab / Sin[alpha];
      ctr += h lab cs;
      h = If[h > 1., -1, 1],
    (* else *)
      rad = 2000.;
      alpha = ArcSin[lab / rad];
      h = 1
    ];
    mid -= h Sqrt[rad^2 - lab^2] cs;
  ];

  h = Flatten[{PropagatorType[particle]}];
  damping[ phi_ ] =
    If[ NumberQ[PropagatorArrow[particle]],
      Min[Max[rad Abs[phi - ommc] - .5 ArrowLength, 0], 1],
      1 ];
  dr = ommc - alpha;
  alpha *= 2. / Length[h];
  line = { Sequence@@ ((HalfLine[#, dr += alpha, alpha])&)/@ h,
    Arrow[PropagatorArrow[particle]] };
  If[ particle === 0, line,
    If[ label === 0, dr = DefaultDR,
      dr = label[[1]]; ommc += label[[2]] ];
    If[ !FreeQ[h, Sine | Cycles] || NumberQ[PropagatorArrow[particle]],
      mid += Sign[dr] SineAmp cs ];
    Seq[line, FontText[ TheLabel[particle],
      fsize,
      mid + (rad + dr) {Cos[ommc], Sin[ommc]} ]]
  ]
]


HalfLine[ Sine, phi_, dphi_ ] :=
Block[ {arc, w, n},
  arc = rad Abs[dphi];
  w = 2. NPi (.5 + Max[1, Round[NCrestsSine arc]]);
  Line[
    Table[ arc = phi - n dphi;
      mid + (rad - damping[arc] SineAmp Sin[n w]) Through[{Cos, Sin}[arc]],
      {n, 0, 1, 1. / Floor[NPoints arc]} ] ]
]

rshift = CyclesAmp - SineAmp

phadj = ArcCos[rshift / CyclesAmp]

sphadj = Sin[phadj]

HalfLine[ Cycles, phi_, dphi_ ] :=
Block[ {arc, w, n, phamp},
  arc = rad Abs[dphi];
  w = 2. (phadj + NPi Max[1, Round[NCrestsCycles arc]]);
  phamp = CyclesBreadth NPi Sign[dphi] / rad;
  Line[
    Table[ arc = n w - phadj;
      mid + (rad + CyclesAmp Cos[arc] - rshift) *
        Through[{Cos, Sin}[
          phi - n dphi - phamp (Sin[arc] - (2 n - 1) sphadj)]],
      {n, 0, 1, 1. / Floor[2 NPoints arc]} ] ]
]

HalfLine[ prim_, phi_, dphi_ ] :=
Block[ {l},
  l = If[ circ,
    Circle[mid, rad, Sort[{phi - dphi, phi}]],
    Line[{ mid + rad {Cos[phi - dphi], Sin[phi - dphi]},
           mid + rad {Cos[phi], Sin[phi]} }] ];
  If[ prim === Straight, l, {prim, l} ]
]


degperrad = N[1 / Degree]

Arrow[ o_?NumberQ ] :=
Block[ {a = dir + o, l, tip, p, straight, curved},
  tip = ctr + .5 ArrowLength {Cos[a], Sin[a]};
  straight = Polygon[ {
    tip - ArrowLength Through[{Cos, Sin}[a - ArrowAngle]],
    tip,
    tip - ArrowLength Through[{Cos, Sin}[a + ArrowAngle]] } ];
  If[ circ,
    a = Sign[Sin[ommc - a]];
    l = a .5 ArrowLength / rad;
    a *= ArrowAngle;
    tip = ommc - l;
    p = mid + rad {Cos[tip], Sin[tip]};
    curved = PostScript[
      ToString[StringForm[
        "newpath `1` `2` `3` `4` `5` `6`",
        PSScale[ p - rad Through[{Cos, Sin}[tip + a]] ],
        rad / gscale,
        degperrad (tip + a),
        degperrad (ommc + l (rad - ArrowHeight) / rad + a),
        If[a < 0, "arcn", "arc"] ]],
      ToString[StringForm[
        "`1` `2` `3` `4` `5` `6` closepath fill",
        PSScale[ p - rad Through[{Cos, Sin}[tip - a]] ],
        rad / gscale,
        degperrad (ommc + l (rad + ArrowHeight) / rad - a),
        degperrad (tip - a),
        If[a < 0, "arc", "arcn"] ]] ];
    NBRender[curved] = straight;
    curved,
  (* else *)
    straight
  ]
]

Arrow[ ___ ] = Sequence[]


PSScale[ {x_, y_} ] :=
  Sequence[(x + margin) / gscale, (y + margin) / gscale]


Unprotect[Offset]

Offset[ ofs1_, Offset[ ofs2_, pos_ ] ] := Offset[ofs1 + ofs2, pos]

Protect[Offset]

If[ $VersionNumber < 3,

  Unprotect[Text];

  Text[ FontForm[t_, {font_, size_}], Offset[{ox_, oy_}, p_] ] :=
    PostScript[
      ToString[StringForm[
        "/`1` findfont `2` scalefont setfont", font, size ]],
      ToString[StringForm[
        "[(`1`)] `2` `3` `4` `5` Mabsadd 0 0 Mshowa",
        t, PSScale[p], ox, oy ]] ];

  Protect[Text];

  MDictAdd = {
    PostScript[
      "/Mabsadd { Mgmatrix idtransform Mtmatrix dtransform",
      "3 -1 roll add 3 1 roll add exch } bind def" ] },

(* else *)

  MDictAdd = {}

]


FontText[ t_List, size_, pos_ ] :=
  Text[
    StringDrop[
      StringJoin[{#[[1]], " "}&/@ (FontText[#, size, pos]&)/@ t], -1 ],
    pos ] /; texlabels

FontText[ t_List, size_, pos_ ] :=
Block[ {l = .5 (Length[t] + 1)},
  Sequence@@ MapIndexed[
    FontText[#1, size,
      Offset[size (#2[[1]] - l) {Cos[dir], Sin[dir]}, pos]]&,
    t ]
]

FontText[ ComposedChar[t_, indices___], size_, pos_ ] :=
Block[ {i, ind, l, tex = t},
  ind = {indices} /. _Index -> Null;
  l = Length[ind];
  If[ l > 0 && (i = ind[[1]]) =!= Null,
    tex = tex <> "_{" <> FontText[i, size, pos][[1]] <> "}" ];
  If[ l > 1 && (i = ind[[2]]) =!= Null,
    tex = tex <> "^{" <> FontText[i, size, pos][[1]] <> "}" ];
  If[ l > 2 && (i = ind[[3]]) =!= Null,
    tex = FontText[i, size, pos][[1]] <> " " <> tex ];
  Text[tex, pos]
] /; texlabels

FontText[ ComposedChar[t_, indices___], size_, pos_ ] :=
  Sequence@@ Prepend[
    MapIndexed[
      If[ #1 === Null, Seq[],
        FontText[#1, .7 size, Offset[size IndexOffset@@ #2, pos]] ]&,
      {indices} /. _Index -> Null ],
    FontText[t, size, pos] ]

FontText[ Null, _, _ ] = Sequence[]

FontText[ t_, size_, pos_ ] := Text[ToString[t], pos] /; texlabels

FontText[ t_, size_, pos_ ] := Text[TeXToPS[t][size], pos]


IndexOffset[ 1 ] := {.6, -.3}			(* subscript *)

IndexOffset[ 2 ] := {.6, .3}			(* superscript *)

IndexOffset[ 3 ] := {0, .57}			(* bar *)

IndexOffset[ _ ] = 0


pr[ Loop[l_] ][ from_, to_, ___ ] := (
  AppendTo[loops, l];
  AppendTo[props[l], {from, to}] )

pr[ type_ ][ from_, to_, ___ ] := (
  AppendTo[props[Tree], {from, to}];
  AppendTo[props[type], {from, to}] )

AutoShape[ top_ ] :=
Block[ {ginfo, props, ext, l, tree, mesh, mesh2, tadbr, vars, vert,
tad, min, ok, c, ct, pt, shrink = {}, rev = {}, loops = {}},

  props[ _ ] = {};
  top /. Propagator -> pr;
  loops = Union[loops];

  Off[FindMinimum::fmmp, FindMinimum::fmcv, FindMinimum::precw,
    FindMinimum::fmgz];

	(* a) fix the incoming and outgoing propagators on the left and
	      right side, respectively *)
  ginfo = Join[
    l = Length[props[Incoming]] / 20.;
    MapIndexed[
      #1[[1]] -> {0, 20 - Round[(#2[[1]] - .5) / l]}&,
      props[Incoming] ],
    l = Length[props[Outgoing]] / 20.;
    MapIndexed[
      #1[[1]] -> {20, 20 - Round[(#2[[1]] - .5) / l]}&,
      props[Outgoing] ] ];

	(* b) shrink loops to 1 point which is the center of an imaginary
	      circle on which the external points of the loop lie *)
  vert = Flatten[props[Tree]];
  tree = Fold[
    ( l = Flatten[props[#2]];
      ext[#2] = l = Select[vert, MemberQ[l, #]&];
      AppendTo[ rev, c = center[Length[l]][#2] -> Union[l] ];
      shrink = Join[ shrink, c = Thread[Reverse[c]] ];
      #1 /. c )&,
    props[Tree], loops ];

	(* c) cut tadpole-like parts and minimize the length of the
	      remaining mesh of propagators *)
  mesh2 = Leaves@@ Apply[twig, tree /. ginfo, 1] /. twig -> List;
  tadbr[ _ ] = {};
  Cases[mesh2, branch[ctr:center[_][_], v_, ___] :>
    (tadbr[ctr] = Flatten[{tadbr[ctr], v /. rev}]), Infinity];
  mesh = mesh2 /. branch[__] :> Seq[];
  vert = Cases[mesh, leaf[a_] -> a];
  mesh = mesh /. leaf[___] :> Seq[];
  mesh = List@@ Fold[
    #1 /. {
      Leaves[{a___, #2, b___}, {#2, c_}] :> Leaves[{a, b, #2, c}],
      Leaves[{a___, #2, b___}, {c_, #2}] :> Leaves[{a, b, #2, c}] } &,
    mesh,
    vert = Union[Join[ vert, Cases[mesh, _[2, ___][_], {2}] ]] ] /.
    twig -> List;
  vert = (# -> CartesianVar[#])&/@
    Complement[Cases[mesh, _[__][_], {2}], vert];
  If[ Length[vert] =!= 0,
    dist = Apply[Distance2, mesh /. vert, {1}];
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
  ginfo = Join[ginfo, vert];
  ginfo = Flatten[ {ginfo,
    (l = (#[[-1]] - (c = #[[1]])) / (Length[#] - 1);
     MapIndexed[#1 -> c + l #2[[1]] &, Take[#, {2, -2}]])&/@
      (Select[mesh, Length[#] > 2 &] /. ginfo)} ];

	(* d) minimizing the straight distance of a tadpole to its
	      nearest vertex v would make the tadpole stick to v.
	      Therefore, the tadpole is given polar coordinates with
	      fixed radius and we try to construct the ideal angle with
	      respect to the lines joining at v by maximizing. *)
  mesh2 = (List@@ mesh2) /.
    leaf[br__] :> Sequence@@ Cases[{br}, branch[__]] /. ginfo;
  While[ Length[ tad = Cases[mesh2, branch[{_, _}, __]] ] =!= 0,
    mesh2 = Fold[FixTad, mesh2, tad] ];

	(* e) for each loop, distribute the external points of the loop
	      at the middle of the line from the center to the external
	      vertex and distribute the remaining points of the loop
	      on the imaginary circle around the center. *)
  ok = ginfo;
  Scan[
    Function[rul,
      If[ Length[ vert = Union[ext[ rul[[1, 1]] ]] ] === 1,
        c = SetTadpole[vert[[1]], rul],
        SetMiddle[#, rul]&/@ vert; c = rul[[2]] ];
      SetLoop[props[ rul[[1, 1]] ] /. ginfo, c] ],
    Select[ginfo, !FreeQ[#, center]&] ];

	(* f) last resort: randomize any remaining vertex *)
  ginfo = Join[ MapAt[Clip, #, 2]&/@ ginfo,
    (# -> {RandInt, RandInt})&/@
      Union[Cases[top /. ginfo, Vertex[__][_], Infinity]] ];

	(* g) give tadpoles and identical propagators curvature so that
	      they do not fall on top of each other *)
  pt[ _[Loop[n_]][v_, v_], _ ] :=
    center[ Length[ext[n]] ][n] /. ginfo /. center[_][_] :>
      Clip[ (v /. ginfo) + 4 Through[{Cos, Sin}[2. NPi Random[]]] ];
  pt[ _, 0 ] = 0;
  ct[ p_ ] := If[ (c = (Count[top, p] - 1) / 2) === 0, 0,
    pt[ p, n_ ] = .8 n / c;
    ct[ p ] = c
  ];

  On[FindMinimum::fmmp, FindMinimum::fmcv, FindMinimum::precw,
    FindMinimum::fmgz];

  { Select[ginfo, FreeQ[#, center]&],
    pt[#, ct[#]--]&/@ List@@ top,
    Table[0, {Length[top]}] }
]


Attributes[twig] = {Orderless}

twig[ a:_[1, ___][_], b_ ] := branch[b, a]

Attributes[Leaves] = {Orderless, Flat}

Leaves[ branch[a_, b__], twig[a:_[2, ___][_], c_] ] :=
  Leaves[branch[c, a, b]]

Leaves[ br:branch[a_, __].., tw:twig[a_, _].. ] :=
  Switch[ Length[{tw}],
    1, Leaves[branch[ Sequence@@ DeleteCases[tw, a], a, br ]],
    2, Leaves[leaf[br, a], tw],
    _, Leaves[leaf[br], tw]
  ]

cutbranch[ vert__, br___branch ] :=
  Sequence[ br, Drop[{vert}, {2, -2}] ]


Clip[ xy_ ] := Max[Min[#, 20], 0]&/@ N[xy]

RandInt := Plus@@ Table[Random[Integer, 9], {2}] + 1


Distance[ p1_, p2_ ] := Block[ {d = p2 - p1}, Sqrt[d . d] ]

Distance2[ p1_, ___, p2_ ] := Block[ {d = p2 - p1}, d . d ]

Orientation[ p1_, p2_ ] := N[ArcTan@@ (p2 - p1)]


CartesianVar[ n_ ] := CartesianVar[n] = {Unique["X"], Unique["Y"]}


FixTad[ mesh_, br_ ] :=
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
  ginfo = Join[ginfo, vert];
  mesh /. br -> cutbranch@@ br /. vert
]


SetLoop[ loop_, ctr_ ] :=
Block[ {vert, vars, rad, angle, off, min, c = 0},
  vert = Union[ Cases[loop, _[__][_], {2}] ];
  If[ Length[vert] =!= 0,
    rad = Union[ Cases[loop, _List, {2}] ];
    rad = If[ Length[rad] === 0, 5,
      Plus@@ (Distance[#, ctr]&/@ rad) / Length[rad] ];
    angle = 2. NPi / Length[vert];
    vars = (# ->
      ctr + rad Through[{Cos, Sin}[++c angle + off]])&/@ vert;
    min = FindMinimum@@ {
      -Plus@@ Apply[Distance, loop /. vars, {1}],
      {off, 2. NPi Random[]} };
    ginfo = Join[ ginfo,
      If[ Head[min] === FindMinimum, vars /. off -> 2. NPi Random[],
        c = vars /. min[[2]];
        If[ Length[Intersection[
          Round[Last/@ c], Round[Last/@ ginfo] ]] === 0,
          c,
          # -> ctr + Random[] rad Through[{Sin, Cos}[2. NPi Random[]]]&/@
            vert ] ]
    ]
  ];
]


SetMiddle[ vert_, ctr_ -> xy_ ] :=
Block[ {ex, mid},
  ex = DeleteCases[
    Flatten[Select[props[Tree], !FreeQ[#, vert]&]], vert ];
  If[ Length[ex] =!= 0,
    If[ Length[ mid = Complement[ex, tadbr[ctr]] ] =!= 0, ex = mid ];
    ex = ex /. shrink /. ginfo;
    While[ Length[ex] =!= 0 && (mid = Plus@@ ex / Length[ex]) == xy,
      ex = Rest[ex] ];
    If[ Length[ex] === 0, mid = {RandInt, RandInt} ];
    AppendTo[ginfo, vert -> .6 xy + .4 mid]
  ]
]


SetTadpole[ vert_, ctr_ -> xy_ ] :=
Block[ {adj, max, new, a1, a2},
  adj = Select[tree, !FreeQ[#, ctr]&] /. ok;
  ginfo = ginfo /. ctr -> vert;
  If[ Length[adj] === 1,
    new = 2.6 xy - .8 Plus@@ adj[[1]],
  (* else *)
    adj = Apply[Orientation, adj /. {a_, xy} -> {xy, a}, {1}];
    max = -1;
    Outer[
      If[ (new = Abs[#2 - #1]) > max, max = new; a1 = #1; a2 = #2 ]&,
      adj, adj ];
    new = xy + 4 Through[{Cos, Sin}[.5 (a1 + a2)]] ];
  If[ Distance2[xy, max = Clip[new]] < 2.8,
    ginfo = ginfo /. xy -> xy - .7 (new - max) ];
  AppendTo[ginfo, ctr -> max];
  max
]


(* call the topology editor *)

Shape::notopedit =
"Topology editor not found. You have to compile TopEdit.tm first."

Shape[ tops:TopologyList[___][___] | TopologyList[___] ] :=
  MapIndexed[ (FAPrint[ 2, "> Top. ", #2[[1]] ]; Shape[#1])&,
    List@@ tops ]

Shape[ top:P$Topology -> _ ] := Shape[top]

Shape[ top:P$Topology, auto_:0 ] :=
Block[ {edittop, gname, ghead, ginfo, arg1, arg2, res},
  edittop = Take[#, 2]&/@ Topology@@ top /. External -> Incoming;
  ghead = ShortHand[ #[[0, 1]] ]&/@ edittop;
  gname = StringJoin[
    # <> ToString[Count[ghead, #]] &/@ {"Inc", "Out", "Int", "Loop"} ];
  ghead = ToExpression[gname];
  res = auto;
  If[ Head[ginfo = ghead[edittop]] =!= List,
	(* attempt to load GraphInfo *)
    If[ !MemberQ[$LoadedGraphInfos, gname],
      Off[Get::noopen];
      Get[$TopologyDataDir <> gname <> ".m"];
      On[Get::noopen];
      AppendTo[$LoadedGraphInfos, gname];
    ];
    If[ Head[ginfo] =!= List,
      --res; Set@@ {ginfo, AutoShape[edittop]} ];
  ];
  If[ res > 0, Return[ginfo] ];
  If[ htopedit === False,
    arg1 = $FeynArtsDir <> "TopEdit_" <> $Platform;
    htopedit = If[ FileType[arg1] =!= None,
      Install[arg1],
      Message[Shape::notopedit]; True ] ];
  arg1 = Apply[List, ginfo[[1]], {1}];
  arg2 = Transpose[ {
    List@@ Map[Position[arg1, #, {2}, 1][[1, 1]]&, edittop, {2}],
    ginfo[[2]],
    ginfo[[3]] } ] /. Propagator[_] -> Sequence;
  res = TopEdit[ Flatten[arg1], Flatten[arg2, 1] ];
  If[ res === $Failed, Uninstall[htopedit],
    If[ res =!= $Aborted,
      (#1[#2] = #3)&[ghead, edittop, ginfo = res];
      $LoadedGraphInfos = Union[Append[$LoadedGraphInfos, gname]];
      $ModifiedGraphInfos = Union[Append[$ModifiedGraphInfos, gname]];
      System`$Epilog := SaveGraphInfos[] ]
  ];
  ginfo
]


htopedit = False

TopEdit[ __ ] = $Aborted


$LoadedGraphInfos = $ModifiedGraphInfos = {}


SaveGraphInfos[ ] := (
  Put[ Definition[#], $TopologyDataDir <> # <> ".m" ]&/@
    $ModifiedGraphInfos;
  $ModifiedGraphInfos = {} )


ShortHand[ Loop[_] ] = "Loop"

ShortHand[ type_ ] := StringTake[ ToString[type], 3 ]


SymbolChar[ c_ ] := FontForm[c, {"Symbol", #}]&

TextChar[ c_ ] := FontForm[c, {TextFont, #}]&

TeXToPS[ "\\alpha" ] := SymbolChar["a"];
TeXToPS[ "\\beta" ] := SymbolChar["b"];
TeXToPS[ "\\gamma" ] := SymbolChar["g"];
TeXToPS[ "\\delta" ] := SymbolChar["d"];
TeXToPS[ "\\epsilon" ] := SymbolChar["e"];
TeXToPS[ "\\varepsilon" ] := SymbolChar["e"];
TeXToPS[ "\\zeta" ] := SymbolChar["z"];
TeXToPS[ "\\eta" ] := SymbolChar["h"];
TeXToPS[ "\\theta" ] := SymbolChar["q"];
TeXToPS[ "\\vartheta" ] := SymbolChar["J"];
TeXToPS[ "\\iota" ] := SymbolChar["i"];
TeXToPS[ "\\kappa" ] := SymbolChar["k"];
TeXToPS[ "\\lambda" ] := SymbolChar["l"];
TeXToPS[ "\\mu" ] := SymbolChar["m"];
TeXToPS[ "\\nu" ] := SymbolChar["n"];
TeXToPS[ "\\xi" ] := SymbolChar["x"];
TeXToPS[ "\\pi" ] := SymbolChar["p"];
TeXToPS[ "\\varpi" ] := SymbolChar["v"];
TeXToPS[ "\\rho" ] := SymbolChar["r"];
TeXToPS[ "\\varrho" ] := SymbolChar["r"];
TeXToPS[ "\\sigma" ] := SymbolChar["s"];
TeXToPS[ "\\varsigma" ] := SymbolChar["V"];
TeXToPS[ "\\tau" ] := SymbolChar["t"];
TeXToPS[ "\\upsilon" ] := SymbolChar["u"];
TeXToPS[ "\\phi" ] := SymbolChar["f"];
TeXToPS[ "\\varphi" ] := SymbolChar["j"];
TeXToPS[ "\\chi" ] := SymbolChar["c"];
TeXToPS[ "\\psi" ] := SymbolChar["y"];
TeXToPS[ "\\omega" ] := SymbolChar["w"];
TeXToPS[ "\\Gamma" ] := SymbolChar["G"];
TeXToPS[ "\\Delta" ] := SymbolChar["D"];
TeXToPS[ "\\Theta" ] := SymbolChar["Q"];
TeXToPS[ "\\Lambda" ] := SymbolChar["L"];
TeXToPS[ "\\Xi" ] := SymbolChar["X"];
TeXToPS[ "\\Pi" ] := SymbolChar["P"];
TeXToPS[ "\\Sigma" ] := SymbolChar["S"];
TeXToPS[ "\\Upsilon" ] := SymbolChar["\241"];
TeXToPS[ "\\Phi" ] := SymbolChar["F"];
TeXToPS[ "\\Psi" ] := SymbolChar["X"];
TeXToPS[ "\\Omega" ] := SymbolChar["W"];
TeXToPS[ "\\infty" ] := SymbolChar["\245"];
TeXToPS[ "\\pm" ] := SymbolChar["\261"];
TeXToPS[ "\\partial" ] := SymbolChar["\266"];
TeXToPS[ "\\leq" ] := SymbolChar["\243"];
TeXToPS[ "\\geq" ] := SymbolChar["\263"];
TeXToPS[ "\\times" ] := SymbolChar["\264"];
TeXToPS[ "\\otimes" ] := SymbolChar["\304"];
TeXToPS[ "\\oplus" ] := SymbolChar["\305"];
TeXToPS[ "\\nabla" ] := SymbolChar["\321"];
TeXToPS[ "\\neq" ] := SymbolChar["\271"];
TeXToPS[ "\\equiv" ] := SymbolChar["\272"];
TeXToPS[ "\\approx" ] := SymbolChar["\273"];
TeXToPS[ "\\ldots" ] := SymbolChar["\274"];
TeXToPS[ "\\in" ] := SymbolChar["\316"];
TeXToPS[ "\\notin" ] := SymbolChar["\317"];
TeXToPS[ "\\sim" ] := SymbolChar["\176"];
TeXToPS[ "\\forall" ] := SymbolChar["\""];
TeXToPS[ "\\exists" ] := SymbolChar["$"];
TeXToPS[ "\\sqrt" ] := SymbolChar["\326"];
TeXToPS[ "\\propto" ] := SymbolChar["\265"];
TeXToPS[ "\\subset" ] := SymbolChar["\314"];
TeXToPS[ "\\supset" ] := SymbolChar["\311"];
TeXToPS[ "\\subseteq" ] := SymbolChar["\315"];
TeXToPS[ "\\supseteq" ] := SymbolChar["\312"];
TeXToPS[ "\\bullet" ] := SymbolChar["\267"];
TeXToPS[ "\\perp" ] := SymbolChar["^"];
TeXToPS[ "\\simeq" ] := SymbolChar["@"];
TeXToPS[ "\\vee" ] := SymbolChar["\332"];
TeXToPS[ "\\wedge" ] := SymbolChar["\331"];
TeXToPS[ "\\leftrightarrow" ] := SymbolChar["\253"];
TeXToPS[ "\\leftarrow" ] := SymbolChar["\254"];
TeXToPS[ "\\rightarrow" ] := SymbolChar["\256"];
TeXToPS[ "\\to" ] := SymbolChar["\256"];
TeXToPS[ "\\uparrow" ] := SymbolChar["\255"];
TeXToPS[ "\\downarrow" ] := SymbolChar["\257"];
TeXToPS[ "\\Leftarrow" ] := SymbolChar["\334"];
TeXToPS[ "\\Rightarrow" ] := SymbolChar["\336"];
TeXToPS[ "\\Uparrow" ] := SymbolChar["\335"];
TeXToPS[ "\\Downarrow" ] := SymbolChar["\337"];
TeXToPS[ "\\bar" ] := SymbolChar["-"];
TeXToPS[ "-" ] := SymbolChar["-"];
TeXToPS[ "\\hat" ] := TextChar["^"];
TeXToPS[ "\\tilde" ] := TextChar["~"];
TeXToPS[ "\\dot" ] := SymbolChar["\327"];
TeXToPS[ "\\ddot" ] := SymbolChar["\327\327"];
TeXToPS[ "\\vec" ] := SymbolChar["\256"];
TeXToPS[ "\\prime" ] := TextChar["'"];
TeXToPS[ "\\ast" ] := TextChar["*"];
TeXToPS[ "\\#" ] := TextChar["#"];
TeXToPS[ "\\&" ] := TextChar["&"];
TeXToPS[ "\\$" ] := TextChar["$"];
TeXToPS[ "\\%" ] := TextChar["%"];
TeXToPS[ "\\_" ] := TextChar["_"];
TeXToPS[ c_ ] := TextChar[ToString[c]]

End[]

