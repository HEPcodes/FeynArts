:Begin:
:Function:	topedit
:Pattern:	TopEdit[vert_List, prop_List, pscaling_Integer]
:Arguments:	{ToString[vert], ToString[prop], pscaling}
:ArgumentTypes:	{String, String, Integer}
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
	|D|      (400x400)     |D| | button  | |D|
	|E|                    |E| \---------/ |E|
	|R|         |          |R| BUTTONWIDTH |R|
	| |         |          | |    (120)    | |
	| |         v          | |             | |
	|_|____________________|_|_____________|_|
	__________________________________________  BORDER	*/

#define BORDER 10
#define DRAWAREA 400
#define BUTTONWIDTH 120
#define BUTTONHEIGHT 35
#define BUTTONSEP BORDER
#define NBUTTONS 6
#define SCREENFONT "9x15"

int drawarea = DRAWAREA;
int ybase = BORDER + DRAWAREA;
char *winname = "FeynArts Topology Editor";
char *iconname = "FA TopEdit";

static char copyleft[] =
  "@(#) FeynArts 1.2 Topology Editor, 27 May 98 Thomas Hahn";

typedef struct {
  char name[30];
  double x, y;
  int xs, ys;
} vertexinfo;

typedef struct {
  vertexinfo *from, *to;
  double xc, yc;
  double xm, ym, om1, om2, step, rad;
  int xs, ys, tad;
} propinfo;

typedef unsigned long color;

propinfo propagators[20], *pp;
vertexinfo vertices[50], *vp;
double xscale, yscale;
int paintscaling;
const char *tok;

Display *disp;
Window win;
GC gc;
color black, white, red, blue;
Colormap cmap;
XFontStruct *font;
int buttonc;
char *buttonlabels[NBUTTONS] = {
  "Finished",
  "Abort",
  "Revert",
  "shift Up",
  "shift Down",
  "unSnap grid" };
char allowedkeys[NBUTTONS] = { 'f', 'a', 'r', 'u', 'd', 's' };

void report_error(MLCONST char *);
int Xini(void);
void redrawbuttons(void);
char buttonkey(int);
char *getitem(char *);
void analyse_topology(const char *, const char *);
void return_graphpoints(void);
void calcdrawinfo(propinfo *);
void drawprop(propinfo *, color, color);
void redraw(Bool);
void redrawprop(propinfo *, double, double);
void redrawvertex(vertexinfo *, double, double);
void topedit(MLCONST char *, MLCONST char *, int);

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

  col.flags = DoRed | DoBlue;
  col.red = 0xffff;
  col.blue = col.green = 0;
  XAllocColor(disp, cmap, &col);
  red = col.pixel;

  col.red = col.green = 0;
  col.blue = 0xffff;
  XAllocColor(disp, cmap, &col);
  blue = col.pixel;

  gc = XCreateGC(disp, DefaultRootWindow(disp), 0, 0);
  XSetForeground(disp, gc, black);
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

  sizehints->min_width =
    BORDER + NBUTTONS*(BUTTONHEIGHT + BUTTONSEP) + BORDER +
      BUTTONWIDTH + BORDER;
  sizehints->min_height =
    BORDER + NBUTTONS*(BUTTONHEIGHT + BUTTONSEP) + BORDER;
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
  int l, buttony = BORDER;

  XSetLineAttributes(disp, gc, 0, LineSolid, CapButt, JoinMiter);
  for(s = buttonlabels; s < &buttonlabels[NBUTTONS]; ++s) {
    XDrawRectangle(disp, win, gc,
      drawarea + 2*BORDER, buttony, BUTTONWIDTH, BUTTONHEIGHT);
    XDrawLine(disp, win, gc,
      drawarea + 2*BORDER + 5, buttony + BUTTONHEIGHT - 5,
      drawarea + 2*BORDER + BUTTONWIDTH - 5, buttony + BUTTONHEIGHT - 5);
    XDrawLine(disp, win, gc,
      drawarea + 2*BORDER + BUTTONWIDTH - 5, buttony + BUTTONHEIGHT - 5,
      drawarea + 2*BORDER + BUTTONWIDTH - 5, buttony + 5);
    l = strlen(*s);
    XDrawString(disp, win, gc,
      drawarea + 2*BORDER + BUTTONWIDTH/2 - (XTextWidth(font, *s, l) >> 1),
      buttony + buttonc, *s, l);
    buttony += BUTTONHEIGHT + BUTTONSEP;
  }
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
  XSetForeground(disp, gc, black);
  return allowedkeys[n];
}

char *getitem(char *dest)
{
  int bracket = 0;
  char *d = dest;

  for( ; ; ++tok) {
    switch(*tok) {
    case '(':
    case '[':
    case '{':
      ++bracket;
      break;
    case ')':
    case ']':
    case '}':
      if(bracket == 0) continue;
      --bracket;
      break;
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

  tok = vert + 1;
  for(vp = vertices; *tok; ++vp) {
    getitem(vp->name);
    vp->x = atof(getitem(s));
    vp->y = atof(getitem(s));
  }

  tok = prop + 1;
  for(pp = propagators; *tok; ++pp) {
    pp->from = vertices + atoi(getitem(s)) - 1;
    pp->to = vertices + atoi(getitem(s)) - 1;
    pp->tad = (pp->from == pp->to);
    if(*getitem(s) == '{') {
      pp->xc = atof(s + 1);
      pp->yc = atof(strchr(s + 1, ',') + 1);
      calcdrawinfo(pp);
    }
    else pp->xc = -1.;
  }
}

void return_graphpoints()
{
  propinfo *pp2;
  vertexinfo *vp2;

  MLPutFunction(stdlink, "List", 2);
  MLPutFunction(stdlink, "List", pp - propagators);
  for(pp2 = propagators; pp2 < pp; ++pp2)
    if(pp2->xc < 0.) MLPutInteger(stdlink, 0);
    else {
      MLPutFunction(stdlink, "List", 2);
      MLPutReal(stdlink, pp2->xc);
      MLPutReal(stdlink, pp2->yc);
    }
  MLPutFunction(stdlink, "List", vp - vertices);
  for(vp2 = vertices; vp2 < vp; ++vp2) {
    MLPutFunction(stdlink, "Rule", 2);
    MLPutFunction(stdlink, "ToExpression", 1);
    MLPutString(stdlink, vp2->name);
    MLPutFunction(stdlink, "List", 2);
    MLPutReal(stdlink, vp2->x);
    MLPutReal(stdlink, vp2->y);
  }
  MLEndPacket(stdlink);
}

void calcdrawinfo(propinfo *pr)
{
  double dx, dy, lab, lac, omab, omac, mid, h, a, r;

  if(pr->xc == -1) return;
  dx = pr->xc - pr->from->x;
  dy = pr->yc - pr->from->y;
  lac = hypot(dx, dy);
  if(pr->tad) {
    pr->xm = .5*(pr->from->x + pr->xc);
    pr->ym = .5*(pr->from->y + pr->yc);
    pr->rad = .5*lac;
    pr->om1 = 0.;
    pr->om2 = 2.*M_PI;
    pr->step = 5.*M_PI/180.;
  }
  else {
    omac = atan2(dy, dx);
    dx = pr->to->x - pr->from->x;
    dy = pr->to->y - pr->from->y;
    lab = hypot(dx, dy);
    omab = atan2(dy, dx);
    mid = omab - copysign(M_PI/2.,
      omac > -M_PI/2. && omac < M_PI/2. ?
        omab - omac : (omab - omac)*omac*omab );
    mid = fmod(mid + M_PI, 2.*M_PI) - M_PI;
    h = sqrt(lac*lac - .25*lab*lab);
    a = 2.*atan((h + h)/lab);
    r = .5*lab/sin(a);
    h += r*cos(a);
    pr->xm = pr->xc - h*cos(mid);
    pr->ym = pr->yc - h*sin(mid);
    pr->rad = r;
    pr->om1 = mid - fabs(a);
    pr->om2 = mid + fabs(a);
    h = 2.*fabs(a);
    pr->step = h/ceil(h/(5.*M_PI/180.)) - 1e-10;
  }
}

void drawprop(propinfo *pp2, color linecolor, color boxcolor)
{
  double om;
  int x, y, xold, yold;

  XSetForeground(disp, gc, linecolor);
  if(pp2->xc < 0.) {
    pp2->xs = BORDER - 5 + (int)(xscale*.5*(pp2->from->x + pp2->to->x));
    pp2->ys = ybase - 6 - (int)(yscale*.5*(pp2->from->y + pp2->to->y));
    XDrawLine(disp, win, gc,
      BORDER + (int)(xscale*pp2->from->x),
      ybase - (int)(yscale*pp2->from->y),
      BORDER + (int)(xscale*pp2->to->x),
      ybase - (int)(yscale*pp2->to->y));
  }
  else {
    pp2->xs = BORDER - 5 + (int)(xscale*pp2->xc);
    pp2->ys = ybase - 6 - (int)(yscale*pp2->yc);
    xold = -1;
    for(om = pp2->om1; om <= pp2->om2; om += pp2->step) {
      x = BORDER + (int)(xscale*(pp2->xm + pp2->rad*cos(om)));
      y=ybase - (int)(yscale*(pp2->ym + pp2->rad*sin(om)));
      if(xold != -1) XDrawLine(disp, win, gc, xold, yold, x, y);
      xold = x;
      yold = y;
    }
  }
  XSetForeground(disp, gc, boxcolor);
  XFillRectangle(disp, win, gc, pp2->xs, pp2->ys, 10, 12);
}

void redraw(Bool clearbefore)
{
  double xd, yd;
  int i, j;
  propinfo *pp2;
  vertexinfo *vp2;

  if(clearbefore)
    XClearArea(disp, win,
      0, 0, drawarea + 2*BORDER, ybase + BORDER, False);
  XSetLineAttributes(disp, gc, 3, LineSolid, CapButt, JoinMiter);
  for(xd = BORDER, i = paintscaling; i-- >= 0; xd += xscale)
    for(yd = ybase, j = paintscaling; j-- >= 0; yd -= yscale)
      XDrawPoint(disp, win, gc, (int)xd, (int)yd);
  for(pp2 = propagators; pp2 < pp; ++pp2)
    drawprop(pp2, black, blue);
  XSetForeground(disp, gc, red);
  for(vp2 = vertices; vp2 < vp; ++vp2) {
    vp2->xs = BORDER - 5 + (int)(xscale*vp2->x);
    vp2->ys = ybase - 6 - (int)(yscale*vp2->y);
    XFillRectangle(disp, win, gc, vp2->xs, vp2->ys, 10, 12);
  }
  XSetForeground(disp, gc, black);
}

void redrawprop(propinfo *pp2, double nx, double ny)
{
  double om, xm, ym, dx, dy;
  int i, j, x, y;

  XSetLineAttributes(disp, gc, 3, LineSolid, CapButt, JoinMiter);
  drawprop(pp2, white, white);
  XFlush(disp);
  if(pp2->tad) pp2->xc = nx, pp2->yc = ny;
  else {
    xm = .5*(pp2->to->x + pp2->from->x);
    ym = .5*(pp2->to->y + pp2->from->y);
    if((dx = pp2->to->x - pp2->from->x) == 0.)
      pp2->xc = nx, pp2->yc = ym;
    else if((dy = pp2->to->y - pp2->from->y) == 0.)
      pp2->yc = ny, pp2->xc = xm;
    else {
      om = dy/dx;
      dx = om + dx/dy;
      pp2->xc = (xm/om + ym - ny + om*nx)/dx;
      pp2->yc = (xm + ym*om - nx + ny/om)/dx;
    }
    if(hypot(xm - pp2->xc, ym - pp2->yc) < .3) pp2->xc = -1.;
  }
  calcdrawinfo(pp2);
  drawprop(pp2, black, blue);
}

void redrawvertex(vertexinfo *vp2, double nx, double ny)
{
  propinfo *pp2;
  int i, j, x, y;
  double om, xf, yf, xt, yt, xv, yv, xm, ym, l;

  XSetLineAttributes(disp, gc, 3, LineSolid, CapButt, JoinMiter);
  XSetForeground(disp, gc, white);
  XFillRectangle(disp, win, gc, vp2->xs, vp2->ys, 10, 12);
  for(pp2 = propagators; pp2 < pp; ++pp2)
    if(pp2->from == vp2 || pp2->to == vp2) {
      drawprop(pp2, white, white);
      if(pp2->tad) pp2->xc += nx - vp2->x, pp2->yc += ny - vp2->y;
      else if(pp2->xc >= 0) {
        if(vp2 == pp2->from)
          xf = nx, yf = ny, xt = pp2->to->x, yt = pp2->to->y;
        else xf = pp2->from->x, yf = pp2->from->y, xt = nx, yt = ny;
        xm = pp2->xc - .5*(pp2->from->x + pp2->to->x);
        ym = pp2->yc - .5*(pp2->from->y + pp2->to->y);
        l = copysign(hypot(xm, ym)/hypot(xv = -yt + yf, yv = xt - xf),
          ym*(pp2->to->x - pp2->from->x) -
          xm*(pp2->to->y - pp2->from->y));
        pp2->xc = .5*(xt + xf) + xv*l;
        pp2->yc = .5*(yt + yf) + yv*l;
      }
    }
  vp2->xs = BORDER - 5 + (int)(xscale*(vp2->x = nx));
  vp2->ys = ybase - 6 - (int)(yscale*(vp2->y = ny));
  for(pp2 = propagators; pp2 < pp; ++pp2)
    if(pp2->from == vp2 || pp2->to == vp2) {
      calcdrawinfo(pp2);
      drawprop(pp2, black, blue);
    }
  XSetForeground(disp, gc, red);
  XFillRectangle(disp, win, gc, vp2->xs, vp2->ys, 10, 12);
  XSetForeground(disp, gc, black);
}

void topedit(MLCONST char *vert, MLCONST char *prop, int pscaling)
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
  paintscaling = pscaling;
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
      xscale = (double)drawarea/pscaling;
      yscale = (double)(ev.xconfigure.height - 2*BORDER)/pscaling;
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
        for(pp2 = propagators; pp2 < pp; ++pp2)
          if(pp2->xc >= 0. && pp2->yc + off > paintscaling) goto ignore;
        for(vp2 = vertices; vp2 < vp; ++vp2)
          if(vp2->y + off > paintscaling) goto ignore;
shift:
        for(pp2 = propagators; pp2 < pp; ++pp2)
          if(pp2->xc >= 0.) pp2->yc += off, pp2->ym += off;
        for(vp2 = vertices; vp2 < vp; ++vp2)
          vp2->y += off;
        redraw(True);
        break;
      case 'd':
        off = -.5;
        for(pp2 = propagators; pp2 < pp; ++pp2)
          if(pp2->xc >= 0. && pp2->yc + off < 0.) goto ignore;
        for(vp2 = vertices; vp2 < vp; ++vp2)
          if(vp2->y + off < 0.) goto ignore;
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
        for(pp2 = propagators; pp2 < pp; ++pp2)
          if((unsigned)(ev.xbutton.x - pp2->xs) <= 10 &&
             (unsigned)(ev.xbutton.y - pp2->ys) <= 12) {
            if(ev.xbutton.button == 1) sel = 1;
            else if(!pp2->tad && pp2->xc > 0.) {
              pp2->xc = -1.;
              redraw(True);
            }
            goto selection;
          }
        if(ev.xbutton.button != 1) break;
        for(vp2 = vertices; vp2 < vp; ++vp2)
          if((unsigned)(ev.xbutton.x - vp2->xs) <= 10 &&
             (unsigned)(ev.xbutton.y - vp2->ys) <= 12) {
            sel = 2;
            goto selection;
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
      if(snap) nx = rint(nx), ny = rint(ny);
      if(sel == 1) redrawprop(pp2, nx, ny);
      else redrawvertex(vp2, nx, ny);
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

