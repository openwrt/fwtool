set PATH and ARTIFACTS for convenience:

  $ [ -n "$FWTOOL" ] && export PATH="$(dirname "$FWTOOL"):$PATH"
  $ export ARTIFACTS="$TESTDIR/../artifacts"
  $ alias fwtool='valgrind --quiet --leak-check=full fwtool'

check usage:

  $ fwtool
  Usage: fwtool <options> <firmware>
  
  Options:
    -S <file>:\t\tAppend signature file to firmware image (esc)
    -I <file>:\t\tAppend metadata file to firmware image (esc)
    -s <file>:\t\tExtract signature file from firmware image (esc)
    -i <file>:\t\tExtract metadata file from firmware image (esc)
    -t:\t\t\tRemove extracted chunks from firmare image (using -s, -i) (esc)
    -T:\t\t\tOutput firmware image without extracted chunks to stdout (using -s, -i) (esc)
    -q:\t\t\tQuiet (suppress error messages) (esc)
  
  [1]

check that -T don't truncate ouput by 16 bytes and produces desired error output:

  $ dd if=/dev/urandom of=image.bin bs=512k count=1 2> /dev/null
  $ cp image.bin image.bin.stripped
  $ md5sum image.bin* > md5sums

  $ fwtool -T -i /dev/null image.bin > image.bin.stripped
  Data not found
  [1]

  $ md5sum --check md5sums
  image.bin: OK
  image.bin.stripped: OK

check metadata insertion and extraction:

  $ cp "$ARTIFACTS/metadata.json" .
  $ dd if=/dev/urandom of=image.bin bs=512k count=1 2> /dev/null
  $ md5sum image.bin metadata.json > md5sums

  $ fwtool -I metadata.json image.bin
  $ strings image.bin | grep metadata_version > metadata.json.extracted
  $ diff --unified "$ARTIFACTS/metadata.json" metadata.json.extracted
  $ rm metadata.json

  $ fwtool -t -i metadata.json image.bin
  $ md5sum --check md5sums
  image.bin: OK
  metadata.json: OK

check signature insertion and extraction:

  $ cp "$ARTIFACTS/key-build.ucert" .
  $ dd if=/dev/urandom of=image.bin bs=512k count=1 2> /dev/null
  $ md5sum image.bin key-build.ucert > md5sums

  $ fwtool -S key-build.ucert image.bin
  $ tail --bytes 532 image.bin | head --bytes 516 > key-build.ucert.extracted
  $ cmp --print-bytes "$ARTIFACTS/key-build.ucert" key-build.ucert.extracted
  $ rm key-build.ucert

  $ fwtool -t -s key-build.ucert image.bin
  $ md5sum --check md5sums
  image.bin: OK
  key-build.ucert: OK

check both signature and metadata insertion and extraction:

  $ cp "$ARTIFACTS/metadata.json" "$ARTIFACTS/key-build.ucert" .
  $ dd if=/dev/urandom of=image.bin bs=512k count=1 2> /dev/null
  $ md5sum image.bin metadata.json key-build.ucert > md5sums

  $ fwtool -I metadata.json image.bin
  $ fwtool -S key-build.ucert image.bin

  $ strings image.bin | grep metadata_version > metadata.json.extracted
  $ diff -u "$ARTIFACTS/metadata.json" metadata.json.extracted
  $ rm metadata.json

  $ tail --bytes 532 image.bin | head --bytes 516 > key-build.ucert.extracted
  $ cmp -b "$ARTIFACTS/key-build.ucert" key-build.ucert.extracted
  $ rm key-build.ucert

  $ fwtool -t -s key-build.ucert image.bin
  $ fwtool -t -i metadata.json image.bin
  $ md5sum --check md5sums
  image.bin: OK
  metadata.json: OK
  key-build.ucert: OK
