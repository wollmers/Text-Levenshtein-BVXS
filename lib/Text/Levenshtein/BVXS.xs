#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "src/levbv.h"
#include "src/levbv.c"

// https://docs.mojolicious.org/perlguts#How-do-I-pass-a-Perl-string-to-a-C-library

// https://docs.mojolicious.org/perlapi
// UV utf8n_to_uvchr(const U8 *s, STRLEN curlen, STRLEN *retlen, const U32 flags)
// UV utf8_to_uvchr_buf(const U8 *s, const U8 *send, STRLEN *retlen)

int
dist_any (SV *s1, SV *s2)
{
    int dist;
	if (SvUTF8 (s1) && SvUTF8 (s2) ) {

        STRLEN m;
        STRLEN n;
        // SvPVbyte
        char *a = SvPV (s1, m);
        char *b = SvPV (s2, n);

        dist = dist_utf8_ucs (a, m, b, n);

    }
    else {
        STRLEN m;
        STRLEN n;
        // SvPVbyte
        char *a = SvPV (s1, m);
        char *b = SvPV (s2, n);

        //dist = dist_asci (a, m, b, n);
        dist = dist_utf8_ucs (a, m, b, n);
    }
    return dist;
}

MODULE = Text::Levenshtein::BVXS  PACKAGE = Text::Levenshtein::BVXS

int
simple(s1, s2)
	    SV *	s1
        SV *	s2
        PROTOTYPE: @
        CODE:
{
        STRLEN m;
        STRLEN n;
        // SvPVbyte
        char *a = SvPV (s1, m);
        char *b = SvPV (s2, n);

        RETVAL = dist_simple_utf8 (a, m, b, n);
}
	OUTPUT:
        RETVAL

int
distance(s1, s2)
	    SV *	s1
        SV *	s2
        PROTOTYPE: @
        CODE:
{

        RETVAL = dist_any (s1, s2);
}
	OUTPUT:
        RETVAL


        