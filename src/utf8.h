#ifdef __cplusplus
extern "C" {
#endif

#include <stdarg.h>

/* is c the start of a utf8 sequence? */
#define isutf(c) (((c)&0xC0)!=0x80)

/* convert UTF-8 data to wide character */
int u8_toucs(u_int32_t *dest, int sz, unsigned char *src, unsigned int srcsz);

/* returns length of next utf-8 sequence */
int u8_seqlen(char *s);

#ifdef __cplusplus
}
#endif
