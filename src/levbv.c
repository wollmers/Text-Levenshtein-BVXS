/* levbv.c
 *
 * Copyright (C) 2020-2022, Helmut Wollmersdorfer, all rights reserved.
 *
*/

#include <stdio.h>
#include <limits.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

#include "levbv.h"

#include "utf8.h"
#include "utf8.c"

// width of type bv_bits in bits, mostly 64 bits 
static const uint64_t width = _LEVBV_WIDTH;

/***** Hashi *****/

typedef struct {
    uint32_t *ikeys;
    uint64_t *bits;
} Hashi;

inline int hashi_index (Hashi *hashi, uint32_t key) {
    int index = 0;
    while ( hashi->ikeys[index]
           && ((uint32_t)hashi->ikeys[index] != key) ) {
        index++;
    }
    return index;
}

inline void hashi_setpos (Hashi *hashi, uint32_t key, uint32_t pos) {
    int index = 0;
    while ( hashi->ikeys[index]
           && ((uint32_t)hashi->ikeys[index] != key) ) {
        index++;
    }
    if (hashi->ikeys[index] == 0) {
        hashi->ikeys[index] = key;
    }
    hashi->bits[index] |= 0x1ull << (pos % _LEVBV_WIDTH);
}

inline uint64_t hashi_getpos (Hashi *hashi, uint32_t key) {
    int index = 0;
    while ( hashi->ikeys[index]
           && ((uint32_t)hashi->ikeys[index] != key) ) {
        index++;
    }
    return hashi->bits[index];
}

/************************/

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


/* number of characters */
/*
int utf8_strlen(char *s)
{
    int count = 0;
    int i = 0;

    while (u8_nextchar(s, &i) != 0)
        count++;

    return count;
}
*/

/************************/



/***********************/

static const uint64_t masks[64] = {
  //0x0000000000000000,
  0x0000000000000001ull,0x0000000000000003ull,0x0000000000000007ull,0x000000000000000full,
  0x000000000000001full,0x000000000000003full,0x000000000000007full,0x00000000000000ffull,
  0x00000000000001ffull,0x00000000000003ffull,0x00000000000007ffull,0x0000000000000fffull,
  0x0000000000001fffull,0x0000000000003fffull,0x0000000000007fffull,0x000000000000ffffull,
  0x000000000001ffffull,0x000000000003ffffull,0x000000000007ffffull,0x00000000000fffffull,
  0x00000000001fffffull,0x00000000003fffffull,0x00000000007fffffull,0x0000000000ffffffull,
  0x0000000001ffffffull,0x0000000003ffffffull,0x0000000007ffffffull,0x000000000fffffffull,
  0x000000001fffffffull,0x000000003fffffffull,0x000000007fffffffull,0x00000000ffffffffull,
  0x00000001ffffffffull,0x00000003ffffffffull,0x00000007ffffffffull,0x0000000fffffffffull,
  0x0000001fffffffffull,0x0000003fffffffffull,0x0000007fffffffffull,0x000000ffffffffffull,
  0x000001ffffffffffull,0x000003ffffffffffull,0x000007ffffffffffull,0x00000fffffffffffull,
  0x00001fffffffffffull,0x00003fffffffffffull,0x00007fffffffffffull,0x0000ffffffffffffull,
  0x0001ffffffffffffull,0x0003ffffffffffffull,0x0007ffffffffffffull,0x000fffffffffffffull,
  0x001fffffffffffffull,0x003fffffffffffffull,0x007fffffffffffffull,0x00ffffffffffffffull,
  0x01ffffffffffffffull,0x03ffffffffffffffull,0x07ffffffffffffffull,0x0fffffffffffffffull,
  0x1fffffffffffffffull,0x3fffffffffffffffull,0x7fffffffffffffffull,0xffffffffffffffffull,
};

/*
int dist_asci_pre (unsigned char * a, unsigned char * b, uint32_t alen, uint32_t blen, int prep) {

    static uint64_t posbits[128] = { 0 };
    uint64_t i;

    if (prep > 0) {
        for (i=0; i < 128; i++){
          posbits[i] = 0;
        }

    // 5 instr * ceil(m/w) * m
        for (i=0; i < alen; i++){
            posbits[(unsigned int)a[i]] |= 0x1ull << (i % width);
        }
    }

    uint64_t v = ~0ull;
    // 7 instr * ceil(m/w)*n
    for (i=0; i < blen; i++){
      uint64_t p = posbits[(unsigned int)b[i]];
      uint64_t u = v & p;
      v = (v + u) | (v - u);
    }
    // 12 instr * ceil(m/w)
    return count_bits_fast(~v);
}
*/


int dist_asci (const char * a, int alen, const char * b,  int blen) {

    int amin = 0;
    int amax = alen-1;
    int bmin = 0;
    int bmax = blen-1;

if (1) {
    while (amin <= amax && bmin <= bmax && a[amin] == b[bmin]) {
        amin++;
        bmin++;
    }
    while (amin <= amax && bmin <= bmax && a[amax] == b[bmax]) {
        amax--;
        bmax--;
    }
}

    // if one of the sequences is a complete subset of the other,
    // return difference of lengths.
    if ((amax < amin) || (bmax < bmin)) { return abs(alen - blen); }

    static bv_bits posbits[128] = { 0 };
    uint64_t i;

    for (i=0; i < 128; i++){ posbits[i] = 0; }

    int m = amax-amin +1;

    for (i=0; i < m; i++){
        posbits[(unsigned int)a[i+amin]] |= 0x1ull << i;
    }

    int diff = m;
    bv_bits mask = 1 << (m - 1);
    bv_bits VP   = masks[m - 1];
    bv_bits VN   = 0;

    int n = bmax-bmin +1;
    // for my $j ( $bmin .. $bmax ) {
    for (i=0; i < n; i++){
        bv_bits y = posbits[(unsigned int)b[i+bmin]];
        bv_bits X  = y | VN;
        bv_bits D0 = ((VP + (X & VP)) ^ VP) | X;
        bv_bits HN = VP & D0;
        bv_bits HP = VN | ~(VP|D0);
        X  = (HP << 1) | 1;
        VN = X & D0;
        VP = (HN << 1) | ~(X | D0);
      if (HP & mask) { diff++; }
        if (HN & mask) { diff--; }
    }
    return diff;
}

// use utf-8 sequence as uint32_t key
int dist_utf8_i (char * a, uint32_t alen, char * b, uint32_t blen) {

    Hashi hashi;
    uint32_t ikeys[alen+1];
    bv_bits bits[alen+1];
    hashi.ikeys = ikeys;
    hashi.bits  = bits;

    int32_t i;
    for (i=0;i<=alen;i++) {
        hashi.ikeys[i] = 0;
        hashi.bits[i]  = 0;
    }

    uint32_t q, keylen, m;
    m = 0;
    uint32_t key, k;
    //for (i=0,q=0; (unsigned char)a[q] != '\0'; i++,q+=keylen){
    for (i=0,q=0; q < alen; i++,q+=keylen){
        m++;
        keylen = allBytesForUTF8[(unsigned int)(unsigned char)a[q]];
        for (k=0,key=0; k < keylen; k++) {
          key = key << 8 | a[q+k];
        }
        hashi_setpos (&hashi, key, i);
    }

    int diff = m;
    bv_bits mask = 1 << (m - 1);
    bv_bits VP   = masks[m - 1];
    bv_bits VN   = 0;

    keylen = 0;
    for (i=0,q=0; q < blen; i++,q+=keylen){
        keylen = allBytesForUTF8[(unsigned int)(unsigned char)b[q]];
        for (k=0,key=0; k < keylen; k++) {
          key = key << 8 | b[q+k];
        }

        bv_bits y  = hashi_getpos (&hashi, key);
        bv_bits X  = y | VN;
        bv_bits D0 = ((VP + (X & VP)) ^ VP) | X;
        bv_bits HN = VP & D0;
        bv_bits HP = VN | ~(VP|D0);
        X  = (HP << 1) | 1;
        VN = X & D0;
        VP = (HN << 1) | ~(X | D0);
      if (HP & mask) { diff++; }
        if (HN & mask) { diff--; }
    }
    return diff;
}

// utf-8 to UCS-4 wrapper for dist_uni
int dist_utf8_ucs (char * a, uint32_t alen, char * b, uint32_t blen) {

    uint32_t a_ucs[(alen+1)*4];
    uint32_t b_ucs[(blen+1)*4];
    int a_chars;
    int b_chars;
    // int u8_toucs(u_int32_t *dest, int sz, char *src, int srcsz)
    a_chars = u8_toucs(a_ucs, (alen+1)*4, a, alen);
    b_chars = u8_toucs(b_ucs, (blen+1)*4, b, blen);

    int diff;
    diff = dist_uni(a_ucs, a_chars, b_ucs, b_chars);

    return diff;
}

// use uni codepoints as uint32_t key
//int dist_uni (const UV *a, int alen, const UV *b, int blen) {
int dist_uni (const uint32_t *a, int alen, const uint32_t *b, int blen) {
//int dist_uni (const uint32_t *a, int alen, const uint32_t *b, int blen) {

    int amin = 0;
    int amax = alen-1;
    int bmin = 0;
    int bmax = blen-1;

if (1) {
    while (amin <= amax && bmin <= bmax && a[amin] == b[bmin]) {
        amin++;
        bmin++;
    }
    while (amin <= amax && bmin <= bmax && a[amax] == b[bmax]) {
        amax--;
        bmax--;
    }
}

    // if one of the sequences is a complete subset of the other,
    // return difference of lengths.
    if ((amax < amin) || (bmax < bmin)) { return abs(alen - blen); }

    int m = amax-amin + 1;

    Hashi hashi;
    uint32_t ikeys[m+1];
    bv_bits bits[m+1];
    hashi.ikeys = ikeys;
    hashi.bits  = bits;

    int32_t i;
    for (i=0;i <= m;i++) {
        hashi.ikeys[i] = 0;
        hashi.bits[i]  = 0;
    }

    for (i=0; i < m; i++) {
        hashi_setpos (&hashi, a[i+amin], i);
    }

    int diff = m;
    bv_bits mask = 1 << (m - 1);
    bv_bits VP   = masks[m - 1];
    bv_bits VN   = 0;

    int n = bmax-bmin +1;

    for (i=0; i < n; i++){
        bv_bits y = hashi_getpos (&hashi, b[i+bmin]);
        bv_bits X  = y | VN;
        bv_bits D0 = ((VP + (X & VP)) ^ VP) | X;
        bv_bits HN = VP & D0;
        bv_bits HP = VN | ~(VP|D0);
        X  = (HP << 1) | 1;
        VN = X & D0;
        VP = (HN << 1) | ~(X | D0);
        if (HP & mask) { diff++; }
        if (HN & mask) { diff--; }
    }
    return diff;
}

#ifndef _LEVBV_TEST

int levnoop (const UV * a, int alen, const UV * b, int blen) {

    int diff = 99;

    return diff;
}

int noutf (const SV * a, const SV * b) {

    int diff = 99;

    return diff;
}

#endif
