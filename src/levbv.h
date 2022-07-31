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

typedef struct {
    void **keys;
    size_t *lens;
    size_t capacity;
    size_t elements;
} Array;

int dist_bytes    (const unsigned char * a, int alen, unsigned const char * b, int blen);
int dist_utf8_ucs (unsigned char * a, size_t alen, unsigned char * b, size_t blen);
int dist_uni      (const uint32_t *a, size_t alen, const uint32_t *b, size_t blen);
int dist_hybrid   (const uint32_t *a, size_t alen, const uint32_t *b, size_t blen);
int dist_simple   (const uint32_t *a, size_t alen, const uint32_t *b, size_t blen);
int dist_simple_utf8 (unsigned char * a, size_t alen, unsigned char * b, size_t blen);

int dist_array      ( const Array *a, const Array *b );
int dist_simple_arr ( const Array *a, const Array *b );

//void *stos_memset(void *s, int c, size_t n);

#endif

#ifdef __cplusplus
}
#endif
