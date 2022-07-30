#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "src/levbv.h"
#include "src/levbv.c"

#define _LEVBV_FOR_PERL

/*
int
dist_any (SV *s1, SV *s2)
{
    int dist;
    if (SvUTF8 (s1) || SvUTF8 (s2) ) {

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

        dist = dist_bytes (a, m, b, n);
    }
    return dist;
}
*/

int
dist_any (SV *s1, SV *s2)
{
    int dist;

	STRLEN m;
	STRLEN n;
	/* NOTE:
		SvPVbyte would downgrade (undocumented and destructive)
		SvPVutf8 would upgrade (also destructive)
    */
    unsigned char *a = (unsigned char*)SvPV (s1, m);
    unsigned char *b = (unsigned char*)SvPV (s2, n);

    if (SvUTF8 (s1) || SvUTF8 (s2) ) {
        dist = dist_utf8_ucs (a, m, b, n);
    }
    else {
        dist = dist_bytes (a, m, b, n);
    }
    return dist;
}

MODULE = Text::Levenshtein::BVXS  PACKAGE = Text::Levenshtein::BVXS

PROTOTYPES: DISABLE

int
simple(s1, s2)
    SV *    s1
    SV *    s2
    CODE:
{
    STRLEN m;
    STRLEN n;
    // SvPVbyte
    unsigned char *a = (unsigned char*)SvPV (s1, m);
    unsigned char *b = (unsigned char*)SvPV (s2, n);

    RETVAL = dist_simple_utf8 (a, m, b, n);
}
    OUTPUT:
        RETVAL

int
distance(s1, s2)
    SV *    s1
    SV *    s2
    CODE:
{

    RETVAL = dist_any (s1, s2);
}
    OUTPUT:
        RETVAL

int
distance_arr(s1, s2)
    AV * s1
    AV * s2
    CODE:
{
    int i;
    int distance;

    IV n;
    IV m;

    m = av_top_index(s1) + 1;
    n = av_top_index(s2) + 1;

    if ( 1 && ((m < 1) || (n < 1))) {
        distance = labs(m - n);
    }

    else {

        Array *array1 = array_new (m);
        array1->elements = m;

        for (i = 0; i < m; ++i) {
            SV *string = *av_fetch(s1, i, 0);
            STRLEN keylen;

			array1->keys[i] = SvPV(string, keylen);
            array1->lens[i] = keylen;
        }

        Array *array2 = array_new (n);
        array2->elements = n;

        for (i = 0; i < n; ++i) {
            SV *string = *av_fetch(s2, i, 0);
            STRLEN keylen;

			array2->keys[i] = SvPV(string, keylen);
            array2->lens[i] = keylen;
        }

        distance = dist_array ( array1, array2 );
        //distance = dist_simple_arr ( array1, array2 );

        array_free (array1);
        array_free (array2);
    }
    RETVAL = distance;
}
    OUTPUT:
        RETVAL

int
toucs(s1)
    SV *    s1
    CODE:
{
    STRLEN m;
    // SvPVbyte
    unsigned char *a = (unsigned char*)SvPV (s1, m);
	uint32_t a_ucs[(m+1)*4];

    RETVAL = u8_toucs(a_ucs, (m+1)*4, a, m);
}
    OUTPUT:
        RETVAL
