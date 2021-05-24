#!/bin/sh

set -x

# Edit this line according to your path for extract_loudest_section binary
# This one is for Mac OS - depends on your installation
#EXTRACT_LOUDEST_SECTION_BIN=extract_loudest_section/build/Debug/extract_loudest_section
# This one is for Linux
EXTRACT_LOUDEST_SECTION_BIN=/tmp/extract_loudest_section/gen/bin/extract_loudest_section

word_list=`find oggs/* -type d | xargs -n 1 basename`

for word in ${word_list}
do
  mkdir -p wavs/${word}
  find oggs/${word} -iname "*.ogg" -print | xargs -n 1 basename -s .ogg  | xargs -I {} ffmpeg -i oggs/${word}/{}.ogg -ar 16000 wavs/${word}/{}.wav
  mkdir -p trimmed_wavs/${word}
  ${EXTRACT_LOUDEST_SECTION_BIN} 'wavs'/${word}/'*.wav' trimmed_wavs/${word}
done
