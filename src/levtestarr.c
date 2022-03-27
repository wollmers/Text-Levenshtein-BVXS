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

#include "levbvarr.h"
#include "levbvarr.c"

// non destructive split
int split_utf8 (Array *array, char *source, int srclen, const char *delim) {
    int i;
    int j = 0;
    int last_delim = 1;
    int elements = 0;
    uint32_t keylen = 0;

    for (i=0; (i < srclen && j < array->capacity); i++ ) {
        if ( (uint8_t)*source == (uint8_t)*delim) {
            if (last_delim == 0) {
                //printf ("i %2u keylen %u last_delim %u j %u char %u *  \n", i, keylen, last_delim, j, (uint8_t)*source );
                array->lens[j] = keylen;
                j++;
                last_delim = 1;
                keylen = 0;
                source++;
            }
            else {
                //printf ("i %2u keylen %u last_delim %u j %u char %u **  \n", i, keylen, last_delim, j, (uint8_t)*source );;
                source++;
                last_delim = 1;
            }
        }
        else {
            if (last_delim == 1) {
                //printf ("i %2u keylen %u last_delim %u j %u char %u ***  \n", i, keylen, last_delim, j, (uint8_t)*source );
                last_delim = 0;
                array->keys[j] = source;
                keylen = 1;
                array->lens[j] = keylen;
                elements++;
                source++;
            }
            else {
                //printf ("i %2u keylen %u last_delim %u j %u char %u ****  \n", i, keylen, last_delim, j, (uint8_t)*source );
                keylen++;
                array->lens[j] = keylen;
                source++;
            }
        }
        //*source++;
    }
    return elements;
}

int main (void) {

    // words=11, distance=5
    //char utf_str1[] = "allein schon sollte die Aufnahme von Fremdwortern in dem  ,Deutschen Wort-";
    //char utf_str2[] = "allin  schon soce   die Aufnahme von Frendworterm in dem. Deulshen   Wort-";
    //char utf_str1[] = "allein ſchon ſollte die Aufnahme von Fremdwörtern in dem  „Deutſchen Wort⸗";
    //char utf_str2[] = "allin  ſchon ſoce   die Aufnahme von Frendwörterm in dem. Deulſhen   Wort⸗";
    //char utf_str1[] = " ";
    //char utf_str2[] = "";
    char utf_str1[] = "allein ſchon ſollte die Aufnahme von Fremdwörtern in dem „Deutſchen Wort⸗";
    char utf_str2[] = "allin ſchon ſoce die Aufnahme von Frendwörterm in dem. Deulſhen Wort⸗";

    uint32_t utf_len1 = strlen(utf_str1);
    uint32_t utf_len2 = strlen(utf_str2);

    const char delim[] = " ";
    Array *array1 = array_new (utf_len1);
    array1->elements = split_utf8 (array1, utf_str1, utf_len1, delim);
    //array_debug_utf8 (array1, "array1");

    Array *array2 = array_new (utf_len2);
    array2->elements = split_utf8 (array2, utf_str2, utf_len2, delim);
    //array_debug_utf8 (array2, "array2");

    int distance;
    int distance2;

    if (1) {
    distance = dist_array ( array1, array2 );
    printf("[dist_array]      distance: %u expect: 5\n", distance);

    distance = dist_simple_arr ( array1, array2 );
    printf("[dist_simple_arr] distance: %u expect: 5\n", distance);
    }


    clock_t tic;
    clock_t toc;
    double elapsed;
    double total = 0;
    double rate;

    int bench_on = 1;

    uint64_t count;
    uint64_t megacount;
    uint32_t iters     = 1000000;
    uint32_t megaiters = 1;

    /* ########## dist_array ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
        if (count % 2) {
          distance = dist_array ( array1, array2 );
        }
        else {
          distance2 = dist_array ( array2, array1 );
        }
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;

    printf("[dist_array]      iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, ((distance+distance2)/2));
}


    /* ########## dist_simple_arr ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
        if (count % 2) {
          distance = dist_simple_arr ( array1, array2 );
        }
        else {
          distance2 = dist_simple_arr ( array2, array1 );
        }
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;

    printf("[dist_simple_arr] iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, ((distance+distance2)/2));
}


    //printf("Total: %f seconds\n", total);

    return 0;

}
