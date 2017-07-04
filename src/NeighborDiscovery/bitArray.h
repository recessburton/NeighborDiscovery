#ifndef BIT_ARRAY_H
#define BIT_ARRAY_H

#include <limits.h>        /* for CHAR_BIT */

#define BITMASK(b) (1 << ((b) % CHAR_BIT))
#define BITSLOT(b) ((b) / CHAR_BIT)
#define BITSET(a, b) ((a)[BITSLOT(b)] |= BITMASK(b))
#define BITCLEAR(a, b) ((a)[BITSLOT(b)] &= ~BITMASK(b))
#define BITTEST(a, b) ((a)[BITSLOT(b)] & BITMASK(b))
#define BITNSLOTS(nb) ((nb + CHAR_BIT - 1) / CHAR_BIT)

#define CLEARALLBITS(a, b) do { \
	memset(a, BITNSLOTS(b),0);\
} while (/*CONSTCOND*/0) 

#endif /* BIT_ARRAY_H */

