#!/bin/bash
export IFS=$'\n'
DIR=$(cd $(dirname $0); pwd)
cd $DIR
source ./lock.sh
DATE=`date +%Y_%m_%d`

argv=("$@")
CMDNAME=`basename $0`

if [ $# -eq 0 ]; then
    echo "Usage : ${CMDNAME} [dirname]"
    exit 1
fi


FFMPEG=/usr/local/bin/ffmpeg
#proc=`cat /proc/cpuinfo | grep processor | wc -l`
#let procnum="${proc} / 2";
EXTLIST=("mpeg" "mpg" "mkv" "flv" "rmvb" "wmv" "M4A" "avi")
for DIR in ${argv}
do
	for EXT in ${EXTLIST[@]}
	do
		for FILENAME in `find "${DIR}" -name "*.${EXT}" | sort`
		do
			ls -lh ${FILENAME}
#			/bin/nice -n 19 ${FFMPEG} -y -i "${FILENAME}" -threads ${procnum} "${FILENAME%.${EXT}}.mp4" || continue
			/bin/nice -n 19 ${FFMPEG} -y -i "${FILENAME}" "${FILENAME%.${EXT}}.mp4" || continue
			ls -lh "${FILENAME%.${EXT}}.mp4"
            		rm -f "${FILENAME}"
		done
	done
done
