#!/bin/sh

set -x

# edit this line according to your path for extract_loudest_section binary
EXTRACT_LOUDEST_SECTION_BIN=extract_loudest_section/build/Debug/extract_loudest_section

word_list=`find oggs/* -type d | xargs basename`

for word in ${word_list}
do
  mkdir -p wavs/${word}
  find oggs/${word} -iname "*.ogg" -print | xargs basename -s .ogg  | xargs -I {} ffmpeg -i oggs/${word}/{}.ogg -ar 16000 wavs/${word}/{}.wav
  mkdir -p trimmed_wavs/${word}
  ${EXTRACT_LOUDEST_SECTION_BIN} 'wavs'/${word}/'*.wav' trimmed_wavs/${word}
done
