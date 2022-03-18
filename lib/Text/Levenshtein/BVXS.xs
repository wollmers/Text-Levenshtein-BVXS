#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "src/levbv.h"
#include "src/levbv.c"

// https://docs.mojolicious.org/perlguts#How-do-I-pass-a-Perl-string-to-a-C-library

// https://docs.mojolicious.org/perlapi
// UV utf8n_to_uvchr(const U8 *s, STRLEN curlen, STRLEN *retlen, const U32 flags)
// UV utf8_to_uvchr_buf(const U8 *s, const U8 *send, STRLEN *retlen)

UV *
text2UV (SV *sv, STRLEN *lenp)
{
  STRLEN len;
  // char *str = SvPV(foo_sv, strlen);
  // char *s = SvPV (sv, len);
  U8 *s = (U8 *)SvPV (sv, len);
  UV *r = (UV *)SvPVX (sv_2mortal (NEWSV (0, (len + 1) * sizeof (UV))));
  UV *p = r;

  if (SvUTF8 (sv))
    {
       STRLEN clen;
       while (len)
         {
           *p++ = utf8n_to_uvchr (s, len, &clen, 0);

           if (clen < 0)
             croak ("illegal unicode character in string");

           s += clen;
           len -= clen;
         }
    }
  else
    while (len--)
      *p++ = *(unsigned char *)s++;

  *lenp = p - r;
  return r;
}

int
dist_any (SV *s1, SV *s2)
{
    int dist;
	if (SvUTF8 (s1) || SvUTF8 (s2) ) {
	/*
        STRLEN l1, l2;
        // char*  sv_2pvutf8(SV *sv, STRLEN *const lp)
        uint64_t *c1 = (uint64_t *)text2UV (s1, &l1);
        //UV *c1 = text2UV (s1, &l1);
        uint64_t *c2 = (uint64_t *)text2UV (s2, &l2);
        //UV *c2 = text2UV (s2, &l2);

        dist = dist_uni (c1, l1, c2, l2);
    */
        STRLEN m;
        STRLEN n;
        // SvPVbyte
        char *a = SvPV (s1, m);
        char *b = SvPV (s2, n);

        dist = dist_utf8_ucs (a, m, b, n);

        /*
        STRLEN m;
        STRLEN n;
        char *a = SvPV (s1, m);
        char *b = SvPV (s2, n);

        dist = dist_utf8_i (a, m, b, n);
        */
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

int
noop(s1, s2)
	    SV *	s1
        SV *	s2
        PROTOTYPE: @
        CODE:
{
        STRLEN l1, l2;
        UV *c1 = text2UV (s1, &l1);
        UV *c2 = text2UV (s2, &l2);

        RETVAL = levnoop (c1, l1, c2, l2);
}
	OUTPUT:
        RETVAL

int
noutf (s1, s2)
	    SV *	s1
        SV *	s2
        PROTOTYPE: @
CODE:
	RETVAL = noutf (s1, s2);
OUTPUT:
	RETVAL
        