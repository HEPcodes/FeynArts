:Begin:
:Function:	topedit
:Pattern:	TopEdit[vert_List, prop_List]
:Arguments:	{ToString[CForm[vert]], ToString[CForm[prop]]}
:ArgumentTypes:	{String, String}
:ReturnType:	Manual
:End:

:Evaluate:	TopEdit::nodisplay = "Can't open display."
:Evaluate:	TopEdit::noXini = "Failed to initialize X."

#include "mathlink.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

#ifndef MLCONST
#define MLCONST
#endif

/* initial window geometry:
	__________________________________________
	__________________________________________  BORDER
	| |         ^          | |             | |
	| |         |          | |             | |
	|B|         |          |B|             |B|
	|O|                    |O|             |O|
	|R|<--   DRAWAREA   -->|R| /---------\ |R|
	|D|     (400 x 400)    |D| | button  | |D|
	|E|                    |E| \---------/ |E|
	|R|         |          |R| BUTTONWIDTH |R|
	| |         |          | |    (126)    | |
	| |         v          | |             | |
	|_|____________________|_|_____________|_|
	__________________________________________  BORDER	*/

#define BORDER 10
#define DRAWAREA 400
#define BUTTONWIDTH 126
#define BUTTONHEIGHT 35
#define BUTTONSEP BORDER
#define NBUTTONS 6
#define SCREENFONT "9x15"
#define TEXTHEIGHT 17
#define DEFAULT_DR 1.3

#define XSCALED(x) BORDER + (int)rint(xscale*(x))
#define YSCALED(y) ybase - (int)rint(yscale*(y))

int drawarea = DRAWAREA;
int ybase = BORDER + DRAWAREA;
char *winname = "FeynArts Topology Editor";
char *iconname = "FA TopEdit";

static char copyleft[] =
  "@(#) FeynArts 2.2 Topology Editor, 14 Jun 98 Thomas Hahn";

typedef struct {
  char name[30];
  double x, y;
  int xs, ys;
} vertexinfo;

typedef struct {
  vertexinfo *from, *to;
  double height, xc, yc;
  double dr, dphi;
  double xm, ym, ommc, rad;
  int om1, om2, xs, ys, xl, yl, tad, circ;
} propinfo;

typedef unsigned long color;

propinfo propagators[20], *pp;
vertexinfo vertices[50], *vp;
double xscale, yscale;
const char *tok;

Display *disp;
Window win;
GC gc;
color black, white, red, blue, green;
Colormap cmap;
XFontStruct *font;
int buttonc;
char snapbut[] = "unSnap grid";
char *buttonlabels[NBUTTONS] = {
  "Finished",
  "Abort",
  "Revert",
  "shift Up",
  "shift Down",
  snapbut };
char allowedkeys[NBUTTONS] = { 'f', 'a', 'r', 'u', 'd', 's' };

void report_error(MLCONST char *);
int Xini(void);
void redrawbuttons(void);
char buttonkey(int);
char *getitem(char *);
void analyse_topology(const char *, const char *);
void return_graphpoints(void);
void calcdrawinfo(propinfo *);
void drawprop(propinfo *, color, color, color);
void redraw(Bool);
void redrawprop(propinfo *, double, double);
void redrawvertex(vertexinfo *, double, double);
void redrawlabel(propinfo *, double, double);
void topedit(MLCONST char *, MLCONST char *);

void report_error(MLCONST char *tag)
{
  MLPutFunction(stdlink, "CompoundExpression", 2);
  MLPutFunction(stdlink, "Message", 1);
  MLPutFunction(stdlink, "MessageName", 2);
  MLPutSymbol(stdlink, "TopEdit");
  MLPutString(stdlink, tag);  
  MLPutSymbol(stdlink, "$Failed");
  MLEndPacket(stdlink);
}

int Xini()
{
  XSizeHints *sizehints;
  XWMHints *wmhints;
  XClassHint *classhints;
  XTextProperty winname_, iconname_;
  XColor col;
  char **fontlist;
  int screen, c;

  if((disp = XOpenDisplay("")) == NULL) {
    report_error("nodisplay");
    return 1;
  }

  screen = DefaultScreen(disp);
  cmap = DefaultColormap(disp, screen);
  black = BlackPixel(disp, screen);
  white = WhitePixel(disp, screen);

  col.flags = DoRed | DoBlue | DoGreen;
  col.red = 0xffff;
  col.blue = col.green = 0;
  XAllocColor(disp, cmap, &col);
  red = col.pixel;

  col.red = col.green = 0;
  col.blue = 0xffff;
  XAllocColor(disp, cmap, &col);
  blue = col.pixel;

  col.red = col.blue = 0;
  col.green = 0xffff;
  XAllocColor(disp, cmap, &col);
  green = col.pixel;

  gc = XCreateGC(disp, DefaultRootWindow(disp), 0, 0);
  XSetBackground(disp, gc, white);

  if(!(sizehints = XAllocSizeHints()) ||
     !(wmhints = XAllocWMHints()) ||
     !(classhints = XAllocClassHint()) ||
    XStringListToTextProperty(&winname, 1, &winname_) == 0 ||
    XStringListToTextProperty(&iconname, 1, &iconname_) == 0) {
    report_error("noXini");
    XFreeGC(disp, gc);
    XCloseDisplay(disp);
    return 1;
  }

  win = XCreateSimpleWindow(disp, DefaultRootWindow(disp),
    100, 100, DRAWAREA + BUTTONWIDTH + 3*BORDER, DRAWAREA + 2*BORDER,
    17, black, white);

  XSelectInput(disp, win,
    ButtonPressMask | ButtonMotionMask | ButtonReleaseMask |
    KeyPressMask | ExposureMask | StructureNotifyMask);

  wmhints->initial_state = NormalState;
  wmhints->input = True;
  wmhints->flags = StateHint | InputHint;

  sizehints->min_width = DRAWAREA + BUTTONWIDTH + 3*BORDER;
  sizehints->min_height = DRAWAREA + 2*BORDER;
  sizehints->flags = PMinSize;

  XSetWMProperties(disp, win,
    &winname_, &iconname_, NULL, 0, sizehints, wmhints, classhints);

  font = XLoadQueryFont(disp, SCREENFONT);
  XSetFont(disp, gc, font->fid);
  buttonc = (BUTTONHEIGHT - 1 + font->ascent) >> 1;

  XMapRaised(disp, win);
  return 0;
}

void redrawbuttons()
{
  char **s;
  int l, y = BORDER;

  XSetLineAttributes(disp, gc, 0, LineSolid, CapButt, JoinMiter);
  XSetForeground(disp, gc, black);
  for(s = buttonlabels; s < &buttonlabels[NBUTTONS]; ++s) {
    XDrawRectangle(disp, win, gc,
      drawarea + 2*BORDER, y, BUTTONWIDTH, BUTTONHEIGHT);
    XDrawLine(disp, win, gc,
      drawarea + 2*BORDER + 5, y + BUTTONHEIGHT - 5,
      drawarea + 2*BORDER + BUTTONWIDTH - 5, y + BUTTONHEIGHT - 5);
    XDrawLine(disp, win, gc,
      drawarea + 2*BORDER + BUTTONWIDTH - 5, y + BUTTONHEIGHT - 5,
      drawarea + 2*BORDER + BUTTONWIDTH - 5, y + 5);
    l = strlen(*s);
    XDrawString(disp, win, gc,
      drawarea + 2*BORDER + BUTTONWIDTH/2 - (XTextWidth(font, *s, l) >> 1),
      y + buttonc, *s, l);
    y += BUTTONHEIGHT + BUTTONSEP;
  }

  l = drawarea + 2*BORDER + 5;
  XDrawString(disp, win, gc,
    l, y += BORDER + 1, "left button", 11);
  XDrawString(disp, win, gc,
    l + 46, y += TEXTHEIGHT, "move", 4);
  XDrawString(disp, win, gc,
    l, y += TEXTHEIGHT + 8, "middle button", 13);
  XDrawString(disp, win, gc,
    l + 16, y += TEXTHEIGHT, "straight", 8);
  XDrawString(disp, win, gc,
    l + 16, y += TEXTHEIGHT, "default pos.", 12);
  XDrawString(disp, win, gc,
    l, y += TEXTHEIGHT + 8, "right button", 12);
  XDrawString(disp, win, gc,
    l + 31, y += TEXTHEIGHT, "opposite", 8);
  XSetForeground(disp, gc, red);
  XFillRectangle(disp, win, gc, l, y - 5*TEXTHEIGHT - 27, 10, 12);
  XSetForeground(disp, gc, blue);
  XFillRectangle(disp, win, gc, l + 15, y - 5*TEXTHEIGHT - 27, 10, 12);
  XFillRectangle(disp, win, gc, l, y - 3*TEXTHEIGHT - 19, 10, 12);
  XFillRectangle(disp, win, gc, l, y - 11, 10, 12);
  XSetForeground(disp, gc, green);
  XFillRectangle(disp, win, gc, l + 30, y - 5*TEXTHEIGHT - 27, 10, 12);
  XFillRectangle(disp, win, gc, l, y - 2*TEXTHEIGHT - 19, 10, 12);
  XFillRectangle(disp, win, gc, l + 15, y - 11, 10, 12);
}

char buttonkey(int n)
{
  int y = n*(BUTTONHEIGHT + BUTTONSEP) + BORDER + 5;

  XSetLineAttributes(disp, gc, 0, LineSolid, CapButt, JoinMiter);
  XSetFunction(disp, gc, GXxor);
  XSetForeground(disp, gc, white);
  XDrawRectangle(disp, win, gc,
    drawarea + 2*BORDER + 5, y, BUTTONWIDTH - 10, BUTTONHEIGHT - 10);
  XFlush(disp);
  XDrawRectangle(disp, win, gc,
    drawarea + 2*BORDER + 5, y, BUTTONWIDTH - 10, BUTTONHEIGHT - 10);
  XSetFunction(disp, gc, GXcopy);
  return allowedkeys[n];
}

char *getitem(char *dest)
{
  int bracket = 0;
  char *d = dest;

  for( ; ; ++tok) {
    switch(*tok) {
    case '(':
      ++bracket;
      *d++ = '[';
      continue;
    case ')':
      if(bracket) --bracket, *d++ = ']';
      continue;
    case ',':
      if(bracket) break;
      ++tok;
    case 0:
      *d = 0;
      return dest;
    }
    if(*tok > ' ') *d++ = *tok;
  }
}

void analyse_topology(const char *vert, const char *prop)
{
  char s[100], *p;
  int i;

  tok = vert + 5;
  for(vp = vertices; *tok; ++vp) {
    getitem(vp->name);
    vp->x = atof(getitem(s));
    vp->y = atof(getitem(s));
  }

  tok = prop + 5;
  for(pp = propagators; *tok; ++pp) {
    pp->from = vertices + atoi(getitem(s)) - 1;
    pp->to = vertices + atoi(getitem(s)) - 1;
    if(pp->tad = (pp->from == pp->to)) {
      pp->circ = 1;
      if(*getitem(s) == 'L')
        pp->xc = atof(s + 5),
        pp->yc = atof(strchr(s + 5, ',') + 1);
      else
        pp->xc = pp->from->x,
        pp->yc = pp->from->y + 2.;
    }
    else {
      pp->height = atof(getitem(s));
      pp->circ = (pp->height != 0.);
    }
    if(*getitem(s) == 'L') {
      pp->dr = atof(s + 5);
      pp->dphi = atof(strchr(s + 5, ',') + 1);
    }
    else pp->dr = DEFAULT_DR, pp->dphi = 0.;
    calcdrawinfo(pp);
  }
}

void return_graphpoints()
{
  propinfo *pp2;
  vertexinfo *vp2;

  MLPutFunction(stdlink, "List", 3);
  MLPutFunction(stdlink, "List", vp - vertices);
  for(vp2 = vertices; vp2 < vp; ++vp2) {
    MLPutFunction(stdlink, "Rule", 2);
    MLPutFunction(stdlink, "ToExpression", 1);
    MLPutString(stdlink, vp2->name);
    MLPutFunction(stdlink, "List", 2);
    MLPutReal(stdlink, vp2->x);
    MLPutReal(stdlink, vp2->y);
  }
  MLPutFunction(stdlink, "List", pp - propagators);
  for(pp2 = propagators; pp2 < pp; ++pp2)
    if(pp2->tad) {
      MLPutFunction(stdlink, "List", 2);
      MLPutReal(stdlink, pp2->xc);
      MLPutReal(stdlink, pp2->yc);
    }
    else MLPutReal(stdlink, pp2->height);
  MLPutFunction(stdlink, "List", pp - propagators);
  for(pp2 = propagators; pp2 < pp; ++pp2)
    if(pp2->dr == DEFAULT_DR && pp2->dphi == 0.)
      MLPutInteger(stdlink, 0);
    else {
      MLPutFunction(stdlink, "List", 2);
      MLPutReal(stdlink, pp2->dr);
      MLPutReal(stdlink, pp2->dphi);
    }
  MLEndPacket(stdlink);
}

void calcdrawinfo(propinfo *pr)
{
  double dx, dy, lab, omab, m, a, r;

  if(pr->tad) {
    pr->xm = .5*(pr->from->x + pr->xc);
    pr->ym = .5*(pr->from->y + pr->yc);
    dx = pr->xm - pr->from->x;
    dy = pr->ym - pr->from->y;
    pr->rad = hypot(dx, dy);
    pr->ommc = atan2(dy, dx);
    pr->om1 = 0;
    pr->om2 = 64*360;
    return;
  }
  dx = pr->to->x - pr->from->x;
  dy = pr->to->y - pr->from->y;
  lab = .5*hypot(dx, dy);
  m = atan2(dy, dx) - .5*M_PI;
  pr->xm = pr->xc = .5*(pr->from->x + pr->to->x);
  pr->ym = pr->yc = .5*(pr->from->y + pr->to->y);
  if(pr->circ) {
    if(pr->height < 0.) m += M_PI;
    a = 2.*atan(r = fabs(pr->height));
    pr->xc += r*lab*cos(m);
    pr->yc += r*lab*sin(m);
    pr->rad = r = lab/sin(a);
  }
  else a = asin(lab/(pr->rad = r = 2000.));
  r = sqrt(r*r - lab*lab);
  if(fabs(pr->height) > 1.) r = -r;
  pr->xm -= r*cos(m);
  pr->ym -= r*sin(m);
  pr->ommc = m;
  pr->om1 = (int)((m - a)*64.*180./M_PI);
  pr->om2 = (int)(a*2.*64.*180./M_PI);
}

void drawprop(propinfo *pr, color line, color centerbox, color labelbox)
{
  double r, m;

  XSetLineAttributes(disp, gc, 3, LineSolid, CapButt, JoinMiter);
  XSetForeground(disp, gc, line);
  if(pr->circ)
    XDrawArc(disp, win, gc,
      XSCALED(pr->xm - pr->rad), YSCALED(pr->ym + pr->rad),
      (int)rint(xscale*2.*pr->rad),
      (int)rint(yscale*2.*pr->rad),
      pr->om1, pr->om2);
  else
    XDrawLine(disp, win, gc,
      XSCALED(pr->from->x), YSCALED(pr->from->y),
      XSCALED(pr->to->x), YSCALED(pr->to->y));

  r = pr->rad + pr->dr;
  m = pr->ommc + pr->dphi;
  pr->xl = XSCALED(pr->xm + r*cos(m)) - 5;
  pr->yl = YSCALED(pr->ym + r*sin(m)) - 6;
  pr->xs = XSCALED(pr->xc) - 5;
  pr->ys = YSCALED(pr->yc) - 6;
  XSetLineAttributes(disp, gc, 0, LineSolid, CapButt, JoinMiter);
  XDrawLine(disp, win, gc,
    pr->xs + 5, pr->ys + 6, pr->xl + 5, pr->yl + 6);
  XSetForeground(disp, gc, labelbox);
  XFillRectangle(disp, win, gc, pr->xl, pr->yl, 10, 12);

  XSetForeground(disp, gc, centerbox);
  XFillRectangle(disp, win, gc, pr->xs, pr->ys, 10, 12);
}

void redraw(Bool clearbefore)
{
  double xd, yd;
  int i, j, i5, x, y;
  propinfo *pp2;
  vertexinfo *vp2;

  if(clearbefore)
    XClearArea(disp, win,
      0, 0, drawarea + 2*BORDER, ybase + BORDER, False);

  XSetForeground(disp, gc, black);
  XSetLineAttributes(disp, gc, 0, LineSolid, CapButt, JoinMiter);
  for(xd = BORDER, i = 20; i >= 0; --i, xd += xscale) {
    i5 = i % 5;
    for(yd = ybase, j = 20; j >= 0; --j, yd -= yscale) {
      x = (int)xd;
      y = (int)yd;
      if(i5 || j % 5) XDrawPoint(disp, win, gc, x, y);
      else {
        XDrawLine(disp, win, gc, x - 2, y, x + 2, y);
        XDrawLine(disp, win, gc, x, y - 2, x, y + 2);
      }
    }
  }

  for(pp2 = propagators; pp2 < pp; ++pp2)
    drawprop(pp2, black, blue, green);
  XSetForeground(disp, gc, red);
  for(vp2 = vertices; vp2 < vp; ++vp2) {
    vp2->xs = XSCALED(vp2->x) - 5;
    vp2->ys = YSCALED(vp2->y) - 6;
    XFillRectangle(disp, win, gc, vp2->xs, vp2->ys, 10, 12);
  }
}

void redrawprop(propinfo *pr, double nx, double ny)
{
  double h, xm, ym, dx, dy, d;

  if(pr->xc == nx && pr->yc == ny) return;
  if(pr->tad) {
    drawprop(pr, white, white, white);
    pr->xc = nx;
    pr->yc = ny;
  }
  else {
    xm = .5*(pr->to->x + pr->from->x);
    ym = .5*(pr->to->y + pr->from->y);
    dx = pr->to->x - pr->from->x;
    dy = pr->to->y - pr->from->y;
    if(dx == 0.) ny = ym;
    else if(dy == 0.) nx = xm;
    else {
      h = dy/dx;
      d = h + dx/dy;
      nx = (xm/h + ym - ny + h*nx)/d;
      ny = (xm + ym*h - nx + ny/h)/d;
    }
    h = hypot(xm - nx, ym - ny);
    h = h < .3 ? 0. :
      copysign(2.*h/hypot(dx, dy),
        dy*(nx - pr->from->x) - dx*(ny - pr->from->y));
    if(h == pr->height) return;
    drawprop(pr, white, white, white);
    pr->height = h;
    pr->circ = h != 0.;
  }
  calcdrawinfo(pr);
  drawprop(pr, black, blue, green);
}

void redrawvertex(vertexinfo *vx, double nx, double ny)
{
  propinfo *pp2;

  if(vx->x == nx && vx->y == ny) return;
  XSetForeground(disp, gc, white);
  XFillRectangle(disp, win, gc, vx->xs, vx->ys, 10, 12);
  for(pp2 = propagators; pp2 < pp; ++pp2)
    if(pp2->from == vx || pp2->to == vx) {
      drawprop(pp2, white, white, white);
      if(pp2->tad) pp2->xc += nx - vx->x, pp2->yc += ny - vx->y;
    }
  vx->x = nx;
  vx->y = ny;
  for(pp2 = propagators; pp2 < pp; ++pp2)
    if(pp2->from == vx || pp2->to == vx) {
      calcdrawinfo(pp2);
      drawprop(pp2, black, blue, green);
    }
  XSetForeground(disp, gc, red);
  XFillRectangle(disp, win, gc, 
    vx->xs = XSCALED(nx) - 5, vx->ys = YSCALED(ny) - 6, 10, 12);
}

void redrawlabel(propinfo *pr, double nx, double ny)
{
  double dx, dy, dr, dphi;

  dx = nx - pr->xm;
  dy = ny - pr->ym;
  dr = hypot(dx, dy) - pr->rad;
  dphi = atan2(dy, dx) - pr->ommc;
  if(fabs(dphi) < 1e-10) dphi = 0.;
  if(dr == pr->dr && dphi == pr->dphi) return;
  XSetLineAttributes(disp, gc, 0, LineSolid, CapButt, JoinMiter);
  XSetForeground(disp, gc, white);
  XDrawLine(disp, win, gc,
    pr->xs + 5, pr->ys + 6, pr->xl + 5, pr->yl + 6);
  XFillRectangle(disp, win, gc, pr->xl, pr->yl, 10, 12);
  pr->dr = dr;
  pr->dphi = dphi;
  pr->xl = XSCALED(nx) - 5;
  pr->yl = YSCALED(ny) - 6;
  XSetForeground(disp, gc, black);
  XDrawLine(disp, win, gc,
    pr->xs + 5, pr->ys + 6, pr->xl + 5, pr->yl + 6);
  XSetForeground(disp, gc, green);
  XFillRectangle(disp, win, gc, pr->xl, pr->yl, 10, 12);
}

void topedit(MLCONST char *vert, MLCONST char *prop)
{
  XEvent ev;
  Region region;
  XRectangle rect;
  int havetoredraw, havetoredrawbuttons;
  char key[2];
  int x, y, sel = 0, snap = 4;
  vertexinfo *vp2;
  propinfo *pp2;
  double off, nx, ny;

  if(Xini()) return;
  analyse_topology(vert, prop);

  for( ; ; ) {
ignore:
    XNextEvent(disp, &ev);
    switch(ev.type) {
    case Expose:
      region = XCreateRegion();
      havetoredraw = havetoredrawbuttons = 0;
      do {
        havetoredraw |= (ev.xexpose.x < drawarea + BORDER);
        havetoredrawbuttons |=
          (ev.xexpose.x + ev.xexpose.width > drawarea + BORDER);
        rect.x = ev.xexpose.x;
        rect.y = ev.xexpose.y;
        rect.width = ev.xexpose.width;
        rect.height = ev.xexpose.height;
        XUnionRectWithRegion(&rect, region, region);
      } while(XCheckTypedEvent(disp, Expose, &ev));
      XSetRegion(disp, gc, region);
      if(havetoredraw) redraw(False);
      if(havetoredrawbuttons) redrawbuttons();
      XDestroyRegion(region);
      XSetClipMask(disp, gc, None);
      break;
    case ConfigureNotify:
      drawarea = ev.xconfigure.width - 3*BORDER - BUTTONWIDTH;
      ybase = ev.xconfigure.height - BORDER;
      xscale = (double)drawarea/20.;
      yscale = (double)(ev.xconfigure.height - 2*BORDER)/20.;
      break;
    case MappingNotify: 
      if(ev.xmapping.request == MappingKeyboard)
        XRefreshKeyboardMapping(&ev.xmapping);
      break;
    case KeyPress:
      if(XLookupString(&ev.xkey, key, 2, 0, 0) != 1) break;
dispatch:
      switch(key[0]) {
      case 'f':
        return_graphpoints();
quit:
        buttonlabels[5] = snapbut;
        XFreeFont(disp, font);
        XDestroyWindow(disp, win);
        XFreeGC(disp, gc);
        XCloseDisplay(disp);
        return;
      case 'a':
        MLPutSymbol(stdlink, "$Aborted");
        goto quit;
      case 'r':
        analyse_topology(vert, prop);
        redraw(True);
        break;
      case 'u':
        off = .5;
        for(vp2 = vertices; vp2 < vp; ++vp2)
          if(vp2->y + off > 20.) goto ignore;
        for(pp2 = propagators; pp2 < pp; ++pp2)
          if(pp2->circ && pp2->yc + off > 20.) goto ignore;
shift:
        for(pp2 = propagators; pp2 < pp; ++pp2)
          pp2->yc += off, pp2->ym += off;
        for(vp2 = vertices; vp2 < vp; ++vp2)
          vp2->y += off;
        redraw(True);
        break;
      case 'd':
        off = -.5;
        for(vp2 = vertices; vp2 < vp; ++vp2)
          if(vp2->y + off < 0.) goto ignore;
        for(pp2 = propagators; pp2 < pp; ++pp2)
          if(pp2->circ && pp2->yc + off < 0.) goto ignore;
        goto shift;
      case 's':
        buttonlabels[5] -= (snap ^= 4) - 2;
        XClearArea(disp, win,
          drawarea + 2*BORDER + 6,
          BORDER + 5*(BUTTONHEIGHT + BUTTONSEP) + 6,
          BUTTONWIDTH - 12, BUTTONHEIGHT - 12, False);
        redrawbuttons();
        break;
      default:
        break;
      }
      break;
    case ButtonPress:
      if(ev.xbutton.x >= BORDER && ev.xbutton.x <= drawarea + BORDER) {
        if(ev.xbutton.button == 1)
          for(vp2 = vertices; vp2 < vp; ++vp2)
            if((unsigned)(ev.xbutton.x - vp2->xs) <= 10 &&
               (unsigned)(ev.xbutton.y - vp2->ys) <= 12) {
              sel = 2;
              goto selection;
            }
        for(pp2 = propagators; pp2 < pp; ++pp2) {
          if((unsigned)(ev.xbutton.x - pp2->xs) <= 10 &&
             (unsigned)(ev.xbutton.y - pp2->ys) <= 12) {
            if(ev.xbutton.button == 1) sel = 1;
            else if(!pp2->tad && pp2->circ) {
              if(ev.xbutton.button == 3) pp2->height = -pp2->height;
              else pp2->circ = 0, pp2->height = 0.;
              calcdrawinfo(pp2);
              redraw(True);
            }
            goto selection;
          }
          if((unsigned)(ev.xbutton.x - pp2->xl) <= 10 &&
             (unsigned)(ev.xbutton.y - pp2->yl) <= 12) {
            switch(ev.xbutton.button) {
            case 1:
              sel = 3;
              break;
            case 2:
              pp2->dr = DEFAULT_DR;
              pp2->dphi = 0.;
              redraw(True);
              break;
            case 3:
              pp2->dr = -pp2->dr;
              redraw(True);
              break;
            }
            goto selection;
          }
        }
      }
      else if(ev.xbutton.button == 1 &&
          ev.xbutton.x >= drawarea + 2*BORDER &&
          ev.xbutton.x <= drawarea + 2*BORDER + BUTTONWIDTH &&
          ev.xbutton.y >= BORDER &&
          ev.xbutton.y <= BORDER + NBUTTONS*(BUTTONHEIGHT + BUTTONSEP)) {
        y = ev.xbutton.y - BORDER;
        if(y % (BUTTONHEIGHT + BUTTONSEP) > BUTTONHEIGHT) break;
        key[0] = buttonkey(y/(BUTTONHEIGHT + BUTTONSEP));
        goto dispatch;
      }
selection:
      break;
    case MotionNotify:
      if(!sel) break;
      if((x = ev.xbutton.x - BORDER) < 0) x = 0;
      if(x > drawarea) x = drawarea;
      if((y = ybase - ev.xbutton.y) < 0) y = 0;
      if(y > ybase - BORDER) y = ybase - BORDER;
      nx = (double)x/xscale;
      ny = (double)y/yscale;
      if(snap) nx = .5*rint(2.*nx), ny = .5*rint(2.*ny);
      switch(sel) {
      case 1:
        redrawprop(pp2, nx, ny);
        break;
      case 2:
        redrawvertex(vp2, nx, ny);
        break;
      default:
        redrawlabel(pp2, nx, ny);
        break;
      }
      break;
    case ButtonRelease:
      if(ev.xbutton.button == 1 && sel) {
        redraw(True);
        sel = 0;
      }
      break;
    default:
      break;
    }
  }
}

main(int argc, char **argv)
{
  return MLMain(argc, argv);
}

