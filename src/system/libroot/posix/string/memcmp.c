/*
 * Copyright 2025, Haiku, Inc. All rights reserved.
 * Copyright 2008, Axel Dörfler, axeld@pinc-software.de.
 * Distributed under the terms of the MIT license.
 */


#include <stdint.h>
#include <string.h>


#define MISALIGNMENT(PTR, TYPE) ((addr_t)(PTR) & (sizeof(TYPE) - 1))

int
memcmp(const void *_a, const void *_b, size_t count)
{
	const unsigned char *a = (const unsigned char *)_a;
	const unsigned char *b = (const unsigned char *)_b;

	if (MISALIGNMENT(a, size_t) == 0 && MISALIGNMENT(b, size_t) == 0) {
		size_t *asz = (size_t *)a;
		size_t *bsz = (size_t *)b;

		while (count >= sizeof(size_t) && *asz == *bsz) {
			asz++;
			bsz++;
			count -= sizeof(size_t);
		}
		a = (const unsigned char *)asz;
		b = (const unsigned char *)bsz;
	}

	while (count > 0 && *a == *b) {
		a++;
		b++;
		count--;
	}

	if (count == 0)
		return 0;

	return *a - *b;
}
