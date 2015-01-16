/*
	mpslatex.c
		makes a LaTeX file from a Mathematica-produced PostScript
		file (.mps), separating the labels from the rest which
		is included via \special
		last modified 30 May 00 th

	invoked as: mpslatex width height < infile > outfile

	Note that to run the resulting file through LaTeX, the MPS
	prologue has to be included (\special{header=mathdict.pro}).
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  double xoff, yoff, xsca, ysca;
} SCALE;

typedef struct {
  double x, y;
  char la[256];
} LABEL;

main(int argc, char **argv)
{
  SCALE sca[3], *sp = sca;
  LABEL lbl[500], *lp = lbl, *lp2;
  char *p, *src, *dest, s[256];
  double gxlow, gylow, gxhigh, gyhigh, w, h, aspect;
  SCALE frame = {0., 0., 288., 288.};

  if(argc >= 2) frame.xsca = 72.*atof(argv[1]);
  if(argc >= 3) frame.ysca = 72.*atof(argv[2]);

  printf("\\unitlength=1bp%%\n"
    "\\begin{picture}(%lg,%lg)\n"
    "\\special{\"\n"
    "Mathdict begin\n"
    "/Mwidth %lg def\n"
    "/Mheight %lg def\n",
    frame.xsca, frame.ysca, frame.xsca, frame.ysca);

  while(1) {
    fgets(s, sizeof(s), stdin);
    if(feof(stdin)) break;
    if(strstr(s, "Mshowa")) {
      p = strstr(s + 2, ")]");
      *lp->la = lp->x = lp->y = 0;
      if(p = strstr(s + 2, ")]")) {
        for(src = s + 2, dest = lp->la; src < p; ++src) {
          if(*src == '\\') ++src;
          *dest++ = *src;
        }
        sscanf(p + 3, "%lg %lg", &gxlow, &gylow);
        lp->x = sp->xsca*gxlow + sp->xoff;
        lp->y = sp->ysca*gylow + sp->yoff;
      }
      ++lp;
      continue;
    }
    fputs(s, stdout);

    if(strstr(s, "Scaling calc")) {
      fgets(s, sizeof(s), stdin);
      fputs(s, stdout);
      while(1) {
        fgets(s, sizeof(s), stdin);
        fputs(s, stdout);
        if(strstr(s, "MathScale")) break;
        gxlow = gxhigh;
        gylow = gyhigh;
        sscanf(s + 2, "%lg %lg", &gxhigh, &gyhigh);
      }
      aspect = (gyhigh - gylow)/(gxhigh - gxlow);
      if(frame.ysca/frame.xsca > aspect)
        w = frame.xsca, h = w*aspect;
      else h = frame.ysca, w = h/aspect;
      sp->xsca = w/(gxhigh - gxlow);
      sp->ysca = h/(gyhigh - gylow);
      sp->xoff = frame.xoff + .5*(frame.xsca - w) + gxlow*sp->xsca;
      sp->yoff = frame.yoff + .5*(frame.ysca - h) + gylow*sp->ysca;
      continue;
    }

    if(strstr(s, "MathSubStart")) {
      sscanf(s, "%lg %lg %lg %lg", &gxlow, &gylow, &gxhigh, &gyhigh);
      frame.xoff = sp->xsca*gxlow + sp->xoff;
      frame.yoff = sp->ysca*gylow + sp->yoff;
      frame.xsca = sp->xsca*(gxhigh - gxlow);
      frame.ysca = sp->ysca*(gyhigh - gylow);
      ++sp;
    }
    else if(strstr(s, "MathSubEnd")) --sp;
  }
  fputs("end }\n", stdout);		/* close mathdict */
  for(lp2 = lbl; lp2 < lp; ++lp2)
    printf("\\put(%lg,%lg){\\makebox(0,0){$%s$}}\n",
      lp2->x, lp2->y, lp2->la);
  fputs("\\end{picture}\n", stdout);
}

