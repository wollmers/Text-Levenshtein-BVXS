#ifdef __cplusplus
extern "C" {
#endif

// https://www.cprogramming.com/tutorial/unicode.html
/*
  Basic UTF-8 manipulation routines
  by Jeff Bezanson
  placed in the public domain Fall 2005

  This code is designed to provide the utilities you need to manipulate
  UTF-8 as an internal string encoding. These functions do not perform the
  error checking normally needed when handling UTF-8 data, so if you happen
  to be from the Unicode Consortium you will want to flay me alive.
  I do this because error checking can be performed at the boundaries (I/O),
  with these routines reserved for higher performance on data known to be
  valid.
*/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#ifdef WIN32
#include <malloc.h>
#else
#include <alloca.h>
#endif

#include "utf8.h"

static const u_int32_t offsetsFromUTF8[6] = {
    0x00000000UL, 0x00003080UL, 0x000E2080UL,
    0x03C82080UL, 0xFA082080UL, 0x82082080UL
};

/*
static const char allBytesForUTF8[256] = {
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
    3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4,5,5,5,5,6,6,6,6
};
*/

static const char trailingBytesForUTF8[256] = {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5
};

/* returns length of next utf-8 sequence */
int u8_seqlen(char *s)
{
    return trailingBytesForUTF8[(unsigned int)(unsigned char)s[0]] + 1;
}

/* conversions without error checking
   only works for valid UTF-8, i.e. no 5- or 6-byte sequences
   srcsz = source size in bytes, or -1 if 0-terminated
   sz = dest size in # of wide characters

   returns # characters converted
   dest will always be L'\0'-terminated, even if there isn't enough room
   for all the characters.
   if sz = srcsz+1 (i.e. 4*srcsz+4 bytes), there will always be enough space.

   Note: modified to not using \0 termination (srcsz -1)
*/
//int u8_toucs(u_int32_t *dest, int sz, unsigned char *src, int srcsz)
int u8_toucs_old(u_int32_t *dest, int sz, unsigned char *src, unsigned int srcsz)
{
    u_int32_t ch;
    unsigned char *src_end = src + srcsz;
    int nb;
    int i=0;

    while (i < sz-1) {
        nb = trailingBytesForUTF8[(unsigned char)*src];
        /*
        if (srcsz == -1) {
            if (*src == 0)
                goto done_toucs;
        }
        else {
        */
            if (src + nb >= src_end)
                goto done_toucs;
        //}
        ch = 0;
        switch (nb) {
            /* these fall through deliberately */
        case 5: ch += (unsigned char)*src++; ch <<= 6;
        case 4: ch += (unsigned char)*src++; ch <<= 6;
        case 3: ch += (unsigned char)*src++; ch <<= 6;
        case 2: ch += (unsigned char)*src++; ch <<= 6;
        case 1: ch += (unsigned char)*src++; ch <<= 6;
        case 0: ch += (unsigned char)*src++;
        }
        ch -= offsetsFromUTF8[nb];
        dest[i++] = ch;
    }
 done_toucs:
    dest[i] = 0;
    return i;
}

int u8_toucs(u_int32_t *dest, int sz, unsigned char *src, unsigned int srcsz)
{
    u_int32_t ch;
    unsigned char *src_end = src + srcsz;
    int nb;
    int i=0;
/*
length byte[0]  byte[1]  byte[2]  byte[3]
1      0xxxxxxx
2      110xxxxx 10xxxxxx
3      1110xxxx 10xxxxxx 10xxxxxx
4      11110xxx 10xxxxxx 10xxxxxx 10xxxxxx


1 0xxx xxxx  00 .. 7F    s[0] < 0x80
2 110x xxxx  C0 .. DF    (s[0] & 0xe0) == 0xc0
3 1110 xxxx  E0 .. EF    (s[0] & 0xf0) == 0xe0
4 1111 0xxx  F0 .. F7    (s[0] & 0xf8) == 0xf0 && (s[0] <= 0xf4)
5 1111 10xx  F8 .. FB
6 1111 110x  FC .. FD

    static const char lengths[] = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 3, 3, 4, 0
    };
*/
    while (i < sz-1) {

        if ((unsigned char)*src < 0x80) {
            if (src >= src_end) { goto done_toucs; }
            ch = (unsigned char)*src++;
            dest[i++] = ch;
        }
        else {
            nb = trailingBytesForUTF8[(unsigned char)*src];
            if (src + nb >= src_end) { goto done_toucs; }
            ch = 0;
            switch (nb) {
                /* these fall through deliberately */
                case 5: ch += (unsigned char)*src++; ch <<= 6;
                case 4: ch += (unsigned char)*src++; ch <<= 6;
                case 3: ch += (unsigned char)*src++; ch <<= 6;
                case 2: ch += (unsigned char)*src++; ch <<= 6;
                case 1: ch += (unsigned char)*src++; ch <<= 6;
                case 0: ch += (unsigned char)*src++;
            }
            ch -= offsetsFromUTF8[nb];
            dest[i++] = ch;
        }
    }
    done_toucs:
        dest[i] = 0;
        return i;
}


#ifdef __cplusplus
}
#endif
