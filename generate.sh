#!/bin/bash
DIR=${1:-../lectures}

HEADER="<!DOCTYPE html>\n
	<html>\n
	<head>\n
	</head>\n
	<body>\n
	<h1>Mitschrift Mathe / Physik</h1>\n"

FOOTER="</body>\n
	</html>\n"
	
LINK="<a href=https://github.com/hd-notes/notes/raw/master/__URL__>__NAME__</a><br>\n"

echo -e $HEADER > index.html

LINKS=""

cd $DIR
PDFS=$(find . -name '*.pdf' -type f)
for pdf in $PDFS; do
	URL=$(sed s/'^\.\/'//g <<< $pdf)
	NAME=$(cat $(sed s/pdf/org/ <<< $pdf) | grep '#+TITLE:' | sed s/'#+TITLE: '//)
#	echo sed 's|__NAME__|'"$NAME"'|' <<< $(sed 's|__URL__|"$URL"|' <<< $LINK)
	LINKS+="$(sed 's|__NAME__|'"$NAME"'|' <<< $(sed 's|__URL__|'"$URL"'|' <<< $LINK))" 
done
cd - 2>&1 > /dev/null

echo -e $LINKS >> index.html
echo -e $FOOTER >> index.html
