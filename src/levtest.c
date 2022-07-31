/* levtest.c
 *
 * Copyright (C) 2020-2022, Helmut Wollmersdorfer, all rights reserved.
 *
*/

#ifndef _LEVBV_TEST
#define _LEVBV_TEST
#endif

#include <stdio.h>
#include <limits.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

#include "levbv.h"
#include "levbv.c"

int main (void) {
    clock_t tic;
    clock_t toc;
    double elapsed;
    double total = 0;
    double rate;
    double el_rate;


    int bench_on = 1;

    uint64_t count;
    uint64_t megacount;
    uint32_t iters     = 1000000;
    uint32_t megaiters = 1;

    // Failed test '[aabbc] m: 5, [aabcc] n: 5 -> 1'
    // Failed test '[aab c c] m: 5, [aab b c] n: 5 -> 1'

    // m=10, n=11, llcs=7, sim=0.667
    //char ascii_str1[] = "Choerephon";
    //char ascii_str2[] = "Chrerrplzon";
    char ascii_str1[] = "ABCDEFGH";
    char ascii_str2[] = "abcdefgh";

    uint32_t ascii_len1 = strlen(ascii_str1);
    uint32_t ascii_len2 = strlen(ascii_str2);

    // [ſhoereſhoſ] m: 10, [Choerephon] n: 10 -> 3
    //char utf_str1[] = "Choerephon";
    //char utf_str2[] = "ſhoereſhoſ";

    //char utf_str1[] = "Choerephon";
    //char utf_str2[] = "Chrerrplzon";
    char utf_str1[] = "ABCDEFGH";
    char utf_str2[] = "abcdefgh";

    //char utf_str1[] = "aabbc";
    //char utf_str2[] = "aabcc";

    //char utf_str1[] = "Choerephon";
    //char utf_str2[] = "Chſerſplzon";

    uint32_t utf_len1 = strlen(utf_str1);
    uint32_t utf_len2 = strlen(utf_str2);

    // convert to ucs
    uint32_t a_ucs[(utf_len1+1)*4];
    uint32_t b_ucs[(utf_len2+1)*4];

    int a_chars = u8_toucs(a_ucs, (utf_len1+1)*4, (unsigned char*)utf_str1, utf_len1);
    int b_chars = u8_toucs(b_ucs, (utf_len2+1)*4, (unsigned char*)utf_str2, utf_len2);

    int distance;
    int distance2;

    if (1) {
    distance = dist_bytes ((unsigned char*)ascii_str1, ascii_len1, (unsigned char*)ascii_str2, ascii_len2);
    printf("[dist_bytes_l8]    distance: %u expect: 8\n", distance);

    distance = dist_utf8_ucs ((unsigned char*)utf_str1, utf_len1, (unsigned char*)utf_str2, utf_len2);
    printf("[dist_utf8_ucs_l8] distance: %u expect: 8\n", distance);

    //distance = dist_uni(a_ucs, a_chars, b_ucs, b_chars);
    //printf("[dist_uni]      distance: %u expect: 4\n", distance);

    //printf("[dist_hybrid]   str1: 0123456789 str2: 01234567890 \n");
    //printf("[dist_hybrid]   str1: %s str2: %s \n", utf_str1, utf_str2);
    distance = dist_hybrid(a_ucs, a_chars, b_ucs, b_chars);
    printf("[dist_hybrid_l8]   distance: %u expect: 8\n", distance);
    }


    char utf_str1_l52[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY";
    char utf_str2_l52[] =  "bcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int utf_len1_l52 = strlen(utf_str1_l52);
    int utf_len2_l52 = strlen(utf_str2_l52);

    // convert to ucs
    uint32_t a_ucs_l52[(utf_len1_l52+1)*4];
    uint32_t b_ucs_l52[(utf_len2_l52+1)*4];
    int a_chars_l52;
    int b_chars_l52;

    a_chars_l52 = u8_toucs(a_ucs_l52, (utf_len1_l52+1)*4, (unsigned char*)utf_str1_l52, utf_len1_l52);
    b_chars_l52 = u8_toucs(b_ucs_l52, (utf_len2_l52+1)*4, (unsigned char*)utf_str2_l52, utf_len2_l52);

    if (1) {
    printf("strlen(utf_str1_l52): %u \n", utf_len1_l52);
    printf("strlen(utf_str2_l52): %u \n", utf_len2_l52);
    printf("a_chars_l52: %u \n", a_chars_l52);
    printf("b_chars_l52: %u \n", b_chars_l52);

    distance = dist_hybrid(a_ucs_l52, a_chars_l52, b_ucs_l52, b_chars_l52);
    printf("[dist_hybrid_l52] distance: %u expect: 2\n\n", distance);
    }


    char utf_str1_l68[] =
        "abcdefghijklmnopqrstuvwxyz0123456789!\"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVY";
    char utf_str2_l68[] =
        "bcdefghijklmnopqrstuvwxyz0123456789!\"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVYZ";
    int utf_len1_l68 = strlen(utf_str1_l68);
    int utf_len2_l68 = strlen(utf_str2_l68);

    // convert to ucs
    uint32_t a_ucs_l68[(utf_len1_l68+1)*4];
    uint32_t b_ucs_l68[(utf_len2_l68+1)*4];
    int a_chars_l68;
    int b_chars_l68;

    a_chars_l68 = u8_toucs(a_ucs_l68, (utf_len1_l68+1)*4, (unsigned char*)utf_str1_l68, utf_len1_l68);
    b_chars_l68 = u8_toucs(b_ucs_l68, (utf_len2_l68+1)*4, (unsigned char*)utf_str2_l68, utf_len2_l68);

    if (1) {
    printf("strlen(utf_str1_l68): %u \n", utf_len1_l68);
    printf("strlen(utf_str2_l68): %u \n", utf_len2_l68);
    printf("a_chars_l68: %u \n", a_chars_l68);
    printf("b_chars_l68: %u \n", b_chars_l68);

    distance = dist_hybrid(a_ucs_l68, a_chars_l68, b_ucs_l68, b_chars_l68);
    printf("[dist_hybrid_l68] distance: %u expect: 2\n\n", distance);
    }

    /* ########## dist_bytes ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
        if (count % 2) {
          distance = dist_bytes ((unsigned char*)ascii_str1, ascii_len1, (unsigned char*)ascii_str2, ascii_len2);
        }
        else {
          distance2 = dist_bytes ((unsigned char*)ascii_str2, ascii_len2, (unsigned char*)ascii_str1, ascii_len1);
        }
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;
    el_rate = rate * ascii_len2;

    printf("[dist_bytes_l8]    iters: %u M Elapsed: %f s Rate: %.1f (M/sec) elRate %.1f %u\n",
        megaiters, elapsed, rate, el_rate, ((distance+distance2)/2));
}

    /* ########## dist_utf8_ucs ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_utf8_ucs ((unsigned char*)utf_str1, utf_len1, (unsigned char*)utf_str2, utf_len2);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;
    el_rate = rate * utf_len2;

    printf("[dist_utf8_ucs_l8] iters: %u M Elapsed: %f s Rate: %.1f (M/sec) elRate %.1f %u\n",
        megaiters, elapsed, rate, el_rate, distance);
}

    /* ########## dist_hybrid ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_hybrid(a_ucs, a_chars, b_ucs, b_chars);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;
    el_rate = rate * b_chars;

    printf("[dist_hybrid_l8]   iters: %u M Elapsed: %f s Rate: %.1f (M/sec) elRate %.1f %u\n",
        megaiters, elapsed, rate, el_rate, distance);
}

    /* ########## dist_simple ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_simple(a_ucs, a_chars, b_ucs, b_chars);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;
    el_rate = rate * b_chars;

    printf("[dist_simple_l8]   iters: %u M Elapsed: %f s Rate:  %.1f (M/sec) elRate  %.1f %u\n",
        megaiters, elapsed, rate, el_rate, distance);
}

    /* ########## dist_hybrid_l52 ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 1;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_hybrid(a_ucs_l52, a_chars_l52, b_ucs_l52, b_chars_l52);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;
    el_rate = rate * b_chars_l52;

    printf("[dist_hybrid_l52]  iters:  %u M Elapsed: %f s Rate:  %.1f (M/sec) elRate %.1f %u\n",
        megaiters, elapsed, rate, el_rate, distance);
}

    /* ########## dist_simple_l52 ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 1;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_simple(a_ucs_l52, a_chars_l52, b_ucs_l52, b_chars_l52);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;
    el_rate = rate * b_chars_l52;

    printf("[dist_simple_l52]  iters:  %u M Elapsed: %f s Rate:  %.1f (M/sec) elRate  %.1f %u\n",
        megaiters, elapsed, rate, el_rate, distance);
}

    /* ########## dist_hybrid_l68 ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 1;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_hybrid(a_ucs_l68, a_chars_l68, b_ucs_l68, b_chars_l68);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;
    el_rate = rate * b_chars_l68;

    printf("[dist_hybrid_l68]  iters:  %u M Elapsed: %f s Rate:  %.1f (M/sec) elRate  %.1f %u\n",
        megaiters, elapsed, rate, el_rate, distance);
}

    /* ########## dist_simple_l68 ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 1;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_simple(a_ucs_l68, a_chars_l68, b_ucs_l68, b_chars_l68);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;
    el_rate = rate * b_chars_l68;

    printf("[dist_simple_l68]  iters:  %u M Elapsed: %f s Rate:  %.1f (M/sec) elRate  %.1f %u\n",
        megaiters, elapsed, rate, el_rate, distance);
}


    printf("Total: %f seconds\n", total);

    return 0;

}
