#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "src/levbv.h"
#include "src/levbv.c"

#define _LEVBV_FOR_PERL

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
    SV *    s1
    SV *    s2
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
    SV *    s1
    SV *    s2
    PROTOTYPE: @
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
    PROTOTYPE: @
    CODE:
{
    int i;
    int distance;

    IV n;
    IV m;
    //m = av_count(s1);
    m = av_top_index(s1) + 1;
    //n = av_count(s2);
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
            //char *key = SvPVbyte(string, keylen);
            char *key = SvPVutf8(string, keylen);

            array1->keys[i] = key;
            array1->lens[i] = keylen;
        }

        Array *array2 = array_new (n);
        array2->elements = n;

        for (i = 0; i < n; ++i) {
            SV *string = *av_fetch(s2, i, 0);
            STRLEN keylen;
            //char *key = SvPVbyte(string, keylen);
            char *key = SvPVutf8(string, keylen);

            array2->keys[i] = key;
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

