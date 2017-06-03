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
proc=`cat /proc/cpuinfo | grep processor | wc -l`
let procnum="${proc} / 2";
EXTLIST=("mkv" "flv" "rmvb" "wmv" "M4A" "avi")
for DIR in ${argv}
do
	for EXT in ${EXTLIST[@]}
	do
		for FILENAME in `find "${DIR}" -name "*.${EXT}"`
		do
			echo ${FILENAME}
            		#/bin/nice -n 19 ${FFMPEG} -y -i "${FILENAME}" -threads ${procnum} -strict -2 -f mp4 -vtag mp4v -q:v 4 -q:a 8 "${FILENAME%.${EXT}}.mp4" || continue
			/bin/nice -n 19 ${FFMPEG} -y -i "${FILENAME}" -threads ${procnum} -c copy "${FILENAME%.${EXT}}.mp4" \
			|| continue
            		rm -f "${FILENAME}"
		done
	done
done
