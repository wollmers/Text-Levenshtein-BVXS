#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "levbv.h"
#include "levbv.c"


MODULE = Text::Levenshtein::BVXS  PACKAGE = Text::Levenshtein::BVXS
PROTOTYPES: DISABLED

int
distance(s1, s2)
	    SV *	s1
        SV *	s2
        CODE:
{
        STRLEN m;
        STRLEN n;
        char *a = SvPV (s1, m);
        char *b = SvPV (s2, n);
        
        RETVAL = dist_asci (a, m, b, n);
}
	OUTPUT:
        RETVAL

