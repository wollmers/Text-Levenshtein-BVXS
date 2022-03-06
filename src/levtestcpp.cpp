#ifndef _LEVBV_TEST
#define _LEVBV_TEST
#endif

#include <string.h>
#include <cwchar>
#include <codecvt>
#include <locale>

#include <ctime>
#include <cmath>

#include <cstdio>
#include <iostream>

#include "levbv.h"
#include "levbv.c"
//#include "utf8.h"
//#include "utf8.c"

//using namespace std;
int main() {

    clock_t tic;
    clock_t toc;
    double elapsed;
    double total = 0;
    double rate;

    uint64_t count;
    uint64_t megacount;
    uint32_t iters     = 1000000;
    uint32_t megaiters = 1;

    // m=10, n=11, llcs=7, sim=0.667
    const char ascii_str1[] = "Choerephon";
    const char ascii_str2[] = "Chrerrplzon";
    uint32_t ascii_len1 = strlen(ascii_str1);
    uint32_t ascii_len2 = strlen(ascii_str2);

//const char8_t * = u8"こんにちは世界";
/*
    const char utf_str1[] = u8"Choerephon";
    const char utf_str2[] = u8"Chſerſplzon";
    uint32_t utf_len1 = strlen(utf_str1);
    uint32_t utf_len2 = strlen(utf_str2);
    
    std::wstring a_ucs = std::wstring_convert<std::codecvt_utf8<wchar_t>>().from_bytes(utf_str1);
    std::wstring b_ucs = std::wstring_convert<std::codecvt_utf8<wchar_t>>().from_bytes(utf_str2);
*/
/*    // convert to ucs
    uint32_t a_ucs[(utf_len1+1)*4];
    uint32_t b_ucs[(utf_len2+1)*4];
    int a_chars;
    int b_chars;

    a_chars = u8_toucs(a_ucs, (utf_len1+1)*4, utf_str1, utf_len1);
    b_chars = u8_toucs(b_ucs, (utf_len2+1)*4, utf_str2, utf_len2);
*/

/*
    //std::wstring a_ucs = std::wstring_convert<std::codecvt_utf8<wchar_t>>().from_bytes(utf_str1);
    //std::wstring b_ucs = std::wstring_convert<std::codecvt_utf8<wchar_t>>().from_bytes(utf_str2);
    //const wchar_t a_ucs[] = std::wstring_convert<std::codecvt_utf8<wchar_t>>().from_bytes(utf_str1);
    //const wchar_t b_ucs[] = std::wstring_convert<std::codecvt_utf8<wchar_t>>().from_bytes(utf_str2);
    const wchar_t a_ucs[] = std::codecvt_utf8<wchar_t>().from_bytes(utf_str1);
    const wchar_t b_ucs[] = std::codecvt_utf8<wchar_t>().from_bytes(utf_str2);        
    int a_chars = std::wcslen (a_ucs);
	int b_chars = std::wcslen (b_ucs);
*/

    int distance;
    int distance2;
    
    distance = dist_asci (ascii_str1, ascii_len1, ascii_str2, ascii_len2);
    printf("[dist_asci]     distance: %u expect: 4\n", distance);   

    /* ########## dist_asci ########## */
if (1) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
        if (count % 2) {
          distance = dist_asci (ascii_str1, ascii_len1, ascii_str2, ascii_len2);
        }
        else {
          distance2 = dist_asci (ascii_str2, ascii_len2, ascii_str1, ascii_len1);
        }
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;

    printf("[dist_asci]     iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, ((distance+distance2)/2));
}

    /* ########## dist_utf8_ucs ########## */
/*
if (1) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_utf8_ucs (utf_str1, utf_len1, utf_str2, utf_len2);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;

    printf("[dist_utf8_ucs] iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, distance);
}
*/
    /* ########## dist_uni ########## */
/*
if (1) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_uni(a_ucs, a_chars, b_ucs, b_chars);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;

    printf("[dist_uni]      iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, distance);
}
*/
    /* ########## dist_hybrid ########## */
/*
if (1) {
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

    printf("[dist_hybrid]   iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, distance);
}

    printf("Total: %f seconds\n", total);
*/


    return 0;    
    
}

