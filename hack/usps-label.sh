#!/usr/bin/env bash

INPUT="label.pdf"
PNG="label.png"
PRINTER="LabelWriter-5XL"

if [ ! -f "${INPUT}" ]; then
  echo "File ${INPUT} DOES NOT EXIST";
  exit 1
fi

[ -f "${PNG}" ] && rm -f "${PNG}"

convert -density 288 -alpha off "${INPUT}" "${PNG}"
mogrify -crop 1750x1128+348+255 "${PNG}"
mogrify -rotate 90 "${PNG}"
lpr -P "${PRINTER}" -o PageSize=1744907_4_in_x_6_in -o fit-to-page "${PNG}"
