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
			/bin/nice -n 19 ${FFMPEG} -y -i "${FILENAME}" "${FILENAME%.${EXT}}.mp4" || continue
            		rm -f "${FILENAME}"
		done
	done
done
