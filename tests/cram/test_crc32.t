set PATH for convenience:

  $ [ -n "$TEST_CRC32" ] && export PATH="$(dirname "$TEST_CRC32"):$PATH"
  $ alias test-crc32='valgrind --quiet --leak-check=full test-crc32'

check that crc32 is producing expected results:

  $ test-crc32
  all_ffs=0x44f33105
  all_7fs=0x3726dda7
  all_ones=0xbea1dbe8
  all_zeroes=0xa77a69f2
  quick_fox=0x7c7180f2
