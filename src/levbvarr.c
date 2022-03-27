/* levbv.c
 *
 * Copyright (C) 2020-2022, Helmut Wollmersdorfer, all rights reserved.
 *
 * see file LICENSE in the distribution
*/

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>
#include <limits.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

#include "levbvarr.h"

#include "utf8.h"
#include "utf8.c"

// width of type bv_bits in bits, mostly 64 bits
static const uint64_t width = _LEVBV_WIDTH;

//#define _LEVBV_DEBUG
#ifdef _LEVBV_DEBUG

#define kDisplayWidth 64

char* pBinFill( long int x, char *so, char fillChar) {
    char s[ kDisplayWidth + 1 ];
    int  i = kDisplayWidth;
    s[i--] = 0x00;   // terminate string

    do { // fill in array from right to left
        s[i--] = (x & 1) ? '1':'0';
        x >>= 1;  // shift right 1 bit
    } while ( x > 0 );
    while ( i >= 0 ) s[i--] = fillChar;    // fill with fillChar
    sprintf( so, "%s", s );
    return so;
}

#endif

/***** Array *****/
/*
typedef struct {
    void **keys;
    uint32_t *lens;
    uint32_t capacity;
    uint32_t elements;
} Array;
*/
inline Array *array_new (int len) {
    Array *array = malloc(1 * sizeof (Array));
    array->capacity = (len+1)/2;
    array->elements = 0;
    array->keys = calloc((len+1)/2, sizeof (void *));
    array->lens = calloc((len+1)/2, sizeof (uint32_t *));
    return array;
}

inline int array_key_compare(const Array *a, const Array *b, int i, int j) {

    if ( a->lens[i] != b->lens[j] || memcmp(a->keys[i], b->keys[j], a->lens[i]) ) {
        return 0;
    }

    return 1;
}

inline void array_free (Array *a) {

    if (a->keys) { free(a->keys); }
    if (a->lens) { free(a->lens); }
    if (a) { free(a); }

}

#ifdef _LEVBV_DEBUG

void array_debug_utf8 (Array *array, char *desc) {

    printf ("=====: %s %d entries\n", desc, array->elements);

    for (int i = 0; i < array->elements; i++) {
        if (array->lens[i] != 0) {
            printf ("Entry %3d:", i);
            printf (" length=%3d ", array->lens[i]);
            printf ("%s"," [");
            //char * key = (char *)array->keys[i];
            for (size_t j = 0; j < array->lens[i]; j++) {
  			    printf("%.1s", array->keys[i] + j);
  			    //printf("%.1s", key[j]);
            }
            printf ("%s  \n","]");
        }
    }
}

#endif

/***** Hash *****/

typedef struct {
    void **keys;
    uint32_t *lens;
    uint64_t *bits;
} Hash;

// memcmp; insert or return
inline int hash_index (Hash *hash, void *key, uint32_t keylen) {
    int index = 0;
    while (hash->keys[index]
           && ((uint32_t)hash->lens[index] != keylen
             || memcmp(key, hash->keys[index], keylen))) {
        index++;
    }
    return index;
}

// update bitmap
inline void hash_setpos (Hash *hash, void *key, uint32_t pos, uint32_t keylen) {
    int index = hash_index(hash, key, keylen);
    if (hash->keys[index] == 0) {
      	hash->keys[index] = key;
      	hash->lens[index] = keylen;
    }
    hash->bits[index] |= 0x1ull << (pos % 64);
}

inline void hash_setpos_k (
    Hash *hash,
    void *key,
    uint32_t pos,
    uint32_t keylen,
    uint32_t k,
    uint32_t kmax
) {
    int index = hash_index (hash, key, keylen);

    if (hash->keys[index] == 0) {
        hash->keys[index] = key;
        hash->lens[index] = keylen;
    }

    hash->bits[index * kmax + k] |= 0x1ull << (pos % _LEVBV_WIDTH);
}

// get position bitmap
inline uint64_t hash_getpos (Hash *hash, void *key, uint32_t keylen) {
    int index = hash_index(hash, key, keylen);
    return hash->bits[index];
}

inline uint64_t hash_getpos_k (Hash *hash, void *key, uint32_t keylen, uint32_t k, uint32_t kmax) {
    int index = hash_index(hash, key, keylen);

    return hash->bits[index * kmax + k];
}

/***********************/
// TODO: tables for other widths
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

// array of strings
// int dist_arr (const Array *a, int alen, const Array *b, int blen);
int dist_array (const Array *a, const Array *b ) {

    int amin = 0;
    int amax = a->elements - 1;
    int bmin = 0;
    int bmax = b->elements - 1;

if (1) {
    // int array_key_compare(Array *a, Array *b, int i, int j)
    while (amin <= amax && bmin <= bmax && array_key_compare(a, b, amin, bmin) ) {
        amin++;
        bmin++;
    }
    while (amin <= amax && bmin <= bmax && array_key_compare(a, b, amax, bmax) ) {
        amax--;
        bmax--;
    }
}

    // if one of the sequences is a complete subset of the other,
    // return difference of lengths.
    if ((amax < amin) || (bmax < bmin)) { return abs(a->elements - b->elements); }

    int m = amax-amin + 1;

  if ( 1 && ((amax - amin) < width) ) {

    #ifdef _LEVBV_DEBUG
    printf("amax: %u amin: %u bmax: %u bmin: %u \n", amax, amin, bmax, bmin );
    printf("m: %u   \n", m);
    char so[kDisplayWidth+1]; // working buffer for pBin
    unsigned char co[2] = { 0 };
    #endif

    int i;

    Hash hash;
    void     *keys[m+1];
    uint32_t lens[m+1];
    bv_bits  bits[m+1];
    hash.keys = keys;
    hash.lens = lens;
    hash.bits = bits;

    for (i = 0; i <= m; i++) {
      hash.keys[i] = 0;
      hash.lens[i] = 0;
      hash.bits[i] = 0;
    }

    // uint32_t q, keylen;
    uint32_t keylen;
    for (i=0; i < m; i++){
        keylen = a->lens[i+amin];
      	hash_setpos (&hash, a->keys[i+amin], i, keylen);
    }

    int diff = m;
    bv_bits mask = 0x1ull << (m - 1);
    bv_bits VP   = masks[m - 1];
    bv_bits VN   = 0;

    #ifdef _LEVBV_DEBUG
    printf("mask: %s \n", pBinFill(mask, so, '0'));
    printf("VP:   %s \n", pBinFill(VP, so, '0'));
    #endif

    bv_bits y;
    for (i=bmin; i <= bmax; i++) {
        y = hash_getpos (&hash, b->keys[i], b->lens[i]);

            #ifdef _LEVBV_DEBUG
            co[0] = b[i];
            printf("i: %u posbit for char: %s %s\n", i, co, pBinFill(y,so,'0'));
            #endif

        bv_bits X  = y | VN;
        bv_bits D0 = ((VP + (X & VP)) ^ VP) | X;
        bv_bits HN = VP & D0;
        bv_bits HP = VN | ~(VP|D0);
        X  = (HP << 1) | 0x1ull;
        VN = X & D0;
        VP = (HN << 1) | ~(X | D0);
        if (HP & mask) { diff++; }
        if (HN & mask) { diff--; }

        #ifdef _LEVBV_DEBUG
        printf("HP: %s \n", pBinFill(HP,so,'0'));
        printf("HN: %s \n", pBinFill(HN,so,'0'));
        printf("i: %u diff: %u \n", i, diff);
        #endif
    }
    return diff;
  }
  else {

    int diff = m;

    int kmax = (m) / width;
    if ( m % width ) { kmax++; }

    #ifdef _LEVBV_DEBUG
    printf("amax: %u amin: %u bmax: %u bmin: %u \n", amax, amin, bmax, bmin );
    printf("m: %u  kmax: %u \n", m, kmax);
    char so[kDisplayWidth+1]; // working buffer for pBin
    unsigned char co[2] = { 0 };
    #endif

    int k;

    Hash hash;
    void     *keys[m+1];
    uint32_t lens[m+1];
    //bv_bits  bits[m+1];
    bv_bits bits[ (m+1) * kmax ];
    hash.keys = keys;
    hash.lens = lens;
    hash.bits = bits;

    int32_t i;
    for (i=0; i <= m; i++) {
        hash.keys[i]         = 0;
        for (k=0; k < kmax; k++ ) {
            hash.bits[i * kmax + k] = 0;
        }
    }

    uint32_t keylen;
    for (i=0; i < m; i++) {
        //keylen = strlen(a[i+amin]);
        keylen = a->lens[i+amin];
        for (k=0; k < kmax; k++ ) {
            hash_setpos_k (&hash, a->keys[i+amin], i, keylen, k, kmax);
        }
    }

    bv_bits mask[kmax];
    for (k=0; k < kmax; k++) { mask[k] = 0; }
    mask[kmax-1] = 0x1ull << ((m-1) % width);

    // bv_bits VP   = masks[m - 1];
    bv_bits VPs[kmax];
    for (k=0; k < kmax; k++) { VPs[k] = 0xffffffffffffffffull; }
    VPs[kmax-1] =  masks[ (unsigned int)((m-1) % width) ];
    //for (i=0; i < m; i++) {
        //VPs[(unsigned int)(i/width)] |= 0x1ull << (i % width);
    //}


    bv_bits VNs[kmax];
    for (k=0; k < kmax; k++) { VNs[k] = 0; }

    #ifdef _LEVBV_DEBUG
    for (k=0; k < kmax; k++) {
    printf("k: %u ((m-1) modulo width): %u \n", k, (unsigned int)((m-1) % width));
    printf("mask: %s \n", pBinFill(mask[k], so, '0'));
    printf("VPs:  %s \n", pBinFill(VPs[k], so, '0'));
    }
    #endif

    bv_bits y, X, D0, HN, HP;

    bv_bits HNcarry;
    bv_bits HPcarry;

    for (i=bmin; i <= bmax; i++) {
        #ifdef _LEVBV_DEBUG
        co[0] = b[i];
        printf("i: %u char: %s \n", i, co );
        #endif

        HNcarry = 0;
        HPcarry = 1;
        for (int k=0; k < kmax; k++ ) {
            y = hash_getpos_k (&hash, b->keys[i], b->lens[i], k, kmax);

            #ifdef _LEVBV_DEBUG
            co[0] = b[i];
            printf("pos: %s \n", pBinFill(y,so,'0'));
            #endif

            X  = y | HNcarry | VNs[k];
            D0 = ((VPs[k] + (X & VPs[k])) ^ VPs[k]) | X;
            HN = VPs[k] & D0;
            HP = VNs[k] | ~(VPs[k] | D0);
            X  = (HP << 1) | HPcarry;
            HPcarry = HP >> (width-1) & 0x1ull;
            VNs[k]  = (X & D0);
            VPs[k]  = (HN << 1) | (HNcarry) | ~(X | D0);
            HNcarry = HN >> (width-1) & 0x1ull;

            if      (HP & mask[k]) { diff++; }
            else if (HN & mask[k]) { diff--; }

            #ifdef _LEVBV_DEBUG
            printf("HP:  %s \n", pBinFill(HP, so, '0'));
            printf("HN:  %s \n", pBinFill(HN, so, '0'));
            printf("i: %u k: %u diff: %u \n", i, k, diff);
            #endif
        }
    }
    return diff;
  }

}

#define MAX_LEVENSHTEIN_STRLEN    16384

#define Min(x, y) ((x) < (y) ? (x) : (y))

int
dist_simple_arr( const Array *a, const Array *b ) {

    int amin = 0;
    int amax = a->elements - 1;
    int bmin = 0;
    int bmax = b->elements - 1;

if (1) {
    while (amin <= amax && bmin <= bmax && array_key_compare(a, b, amin, bmin) ) {
        amin++;
        bmin++;
    }
    while (amin <= amax && bmin <= bmax && array_key_compare(a, b, amax, bmax) ) {
        amax--;
        bmax--;
    }
}

    // if one of the sequences is a complete subset of the other,
    // return difference of lengths.
    if ((amax < amin) || (bmax < bmin)) { return abs(a->elements - b->elements); }

    int m = amax - amin + 1;
    int n = bmax - bmin + 1;

    int i, j;

    int distance;

    /*
    // TODO: error handling friendly to calling programs
    // see https://stackoverflow.com/questions/385975/error-handling-in-c-code
    if (m > MAX_LEVENSHTEIN_STRLEN ||
        n > MAX_LEVENSHTEIN_STRLEN)
    {
      // croak("argument exceeds the maximum length of %d characters", MAX_LEVENSHTEIN_STRLEN);
    }
    */

    /* Previous and current rows of notional array. */
    // TODO: error handling friendly to calling programs
    // if (prev == 0)
    // fatal ("virtual memory exceeded");

    int *prev = (int *)malloc(2 * (n + 1) * sizeof(int));
    int *prev_alloc;
    prev_alloc = prev;
    int *curr;
    int *temp;
    curr = prev + (n + 1);

    for (j = 0; j <= n; j++) { prev[j] = j; }

    for ( i = 1; i <= m; i++) {

        curr[0] = i;

        for ( j = 1; j <= n; j++) {
            int            ins;
            int            del;
            int            sub;

            ins = curr[j - 1] + 1;
            del = prev[j] + 1;
            //sub = prev[j - 1] + ((a[amin + i-1] == b[bmin + j-1]) ? 0 : 1);
            sub = prev[j - 1] + ( array_key_compare(a, b, amin + i-1, bmin + j-1) ? 0 : 1);

            /* Take the one with minimum cost. */
            curr[j] = Min(ins, del);
            curr[j] = Min(curr[j], sub);
        }

        /* Swap current row with previous row. */
        temp = curr;
        curr = prev;
        prev = temp;
    }

    /*
     * Because the final value was swapped from the previous row to the
     * current row, that's where we'll find it.
     */
    distance = prev[n];

    if ( prev ) { free(prev_alloc); }

    return distance;
}

#ifdef __cplusplus
}
#endif

// integer overflow http://www.fefe.de/intof.html
