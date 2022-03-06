#ifdef __cplusplus
extern "C" {
#endif

#ifndef _LEVBV_H
#define _LEVBV_H

#include <stdint.h>

#ifdef __x86_64__
    #if SIZE_MAX == 0xFFFFFFFF
        typedef uint32_t bv_bits;
        #define _LEVBV_WIDTH 32
    #else
        typedef uint64_t bv_bits;
        #define _LEVBV_WIDTH 64
    #endif
#else
    typedef uint32_t bv_bits;
    #define _LEVBV_WIDTH 32
#endif

int dist_asci (const char * a, int alen, const char * b,  int blen);
//int dist_uni (const UV * a, int alen, const UV * b, int blen);
//int dist_uni (const uint64_t * a, int alen, const uint64_t * b, int blen);
int dist_utf8_ucs (char * a, uint32_t alen, char * b, uint32_t blen);
int dist_uni (const uint32_t *a, int alen, const uint32_t *b, int blen);
int dist_hybrid (const uint32_t *a, int alen, const uint32_t *b, int blen);
//int levbv (const UV * a, int alen, const UV * b, int blen);

#ifndef _LEVBV_TEST
int levnoop (const UV * a, int alen, const UV * b, int blen);
int noutf (const SV * a, const SV * b);
#endif

#endif

#ifdef __cplusplus
}
#endif
