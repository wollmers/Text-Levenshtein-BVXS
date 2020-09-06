/* levbv.c
 *
 * Copyright (C) 2020, Helmut Wollmersdorfer, all rights reserved.
 *
*/


#include <stdio.h>
#include <limits.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <nmmintrin.h>

#include "levbv.h"

static const uint64_t width = 64;


/***********************/

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

    static uint64_t posbits[128] = { 0 };
    uint64_t i;
    
    for (i=0; i < 128; i++){ posbits[i] = 0; }

    for (i=0; i < alen; i++){
      	posbits[(unsigned int)a[i]] |= 0x1ull << (i % width);
    }  
    
    int diff = alen;
    uint64_t mask = 1 << (alen - 1);
    uint64_t VP   = masks[alen - 1];
    uint64_t VN   = 0;

    for (i=0; i < blen; i++){
        uint64_t y = posbits[(unsigned int)b[i]];
        uint64_t X  = y | VN; 
        uint64_t D0 = ((VP + (X & VP)) ^ VP) | X;
        uint64_t HN = VP & D0;
        uint64_t HP = VN | ~(VP|D0);
        X  = (HP << 1) | 1;
        VN = X & D0;
        VP = (HN << 1) | ~(X | D0);
	    if (HP & mask) { diff++; }
        if (HN & mask) { diff--; }
    }
    return diff; 
}

