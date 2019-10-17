#include <stdio.h>

#include "crc32.h"
#include "utils.h"

static uint32_t crc_table[256];

int main()
{
	uint32_t crc32 = ~0;
	uint8_t all_ones[1<<10] = { 1 };
	uint8_t all_ffs[1<<5] = { 0xff };
	uint8_t all_7fs[1<<15] = { 0x7f };
	uint8_t all_zeroes[1<<8] = { 0 };
	uint8_t quick_fox[] = "The quick brown fox jumps over the lazy dog and then walks away.";

	crc32_filltable(crc_table);

	fprintf(stdout, "all_ffs=0x%x\n", cpu_to_be32(crc32_block(crc32, all_ffs, sizeof(all_ffs), crc_table)));
	fprintf(stdout, "all_7fs=0x%x\n", cpu_to_be32(crc32_block(crc32, all_7fs, sizeof(all_7fs), crc_table)));
	fprintf(stdout, "all_ones=0x%x\n", cpu_to_be32(crc32_block(crc32, all_ones, sizeof(all_ones), crc_table)));
	fprintf(stdout, "all_zeroes=0x%x\n", cpu_to_be32(crc32_block(crc32, all_zeroes, sizeof(all_zeroes), crc_table)));
	fprintf(stdout, "quick_fox=0x%x\n", cpu_to_be32(crc32_block(crc32, quick_fox, sizeof(quick_fox), crc_table)));

	return 0;
}
