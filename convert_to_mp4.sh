#!/bin/bash
export IFS=$'\n'
DATE=`date +%Y_%m_%d`

argv=("$@")
CMDNAME=`basename $0`

if [ $# -eq 0 ]; then
    echo "Usage : ${CMDNAME} [dirname]"
    exit 1
fi

## https://qiita.com/hit/items/e95298f689a1ee70ae4a                                                                                                                                                               
_pcnt=`pgrep -fo ${CMDNAME} | wc -l`               
if [ ${_pcnt} -gt 1 ]; then                        
	echo "This script has been running now. proc : ${_pcnt}"
	exit 1                                           
fi

EXTLIST=( "mkv" "wmv.mp4" "flv.mp4" "ts" "mpeg" "mpg" "flv" "rmvb" "wmv" "M4A" "avi" )

for ARG_DIR in ${argv}
do
	DIR=`readlink -f ${ARG_DIR}`
	for EXT in ${EXTLIST[@]}
	do
		echo "${EXT}"
		for FILENAME in `find "${DIR}" -name "*.${EXT}" | sort`
		do
			echo "${FILENAME}"
			nice -n 19 ffmpeg -y -i "${FILENAME}" "${FILENAME%.${EXT}}.mp4" || continue
      rm -f "${FILENAME}"
		done
	done
done
