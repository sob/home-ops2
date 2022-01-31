#!/usr/bin/env bash

INPUT="label.pdf"
PNG="label.png"
PRINTER="LabelWriter-5XL"

if [ ! -f "${INPUT}" ]; then
  echo "File ${INPUT} DOES NOT EXIST";
  exit 1
fi

[ -f "${PNG}" ] && rm -f "${PNG}"

convert -density 300 -alpha off "${INPUT}" "${PNG}"
mogrify -crop 2100x1400+200+200 "${PNG}"
./innercrop -m crop -o white -p 1 -f 10% "${PNG}" "cropped-${PNG}"
mogrify -rotate -90 "cropped-${PNG}"
mv "cropped-${PNG}" "${PNG}"

lpr -P "${PRINTER}" -o PageSize=1744907_4_in_x_6_in -o fit-to-page "${PNG}"
