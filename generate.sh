#!/bin/bash
DIR=${1:-../lectures}

HEADER="<!DOCTYPE html>\n
	<html>\n
	<head>\n
	<meta charset='utf-8'>\n
	<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':\n
	new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],\n
	j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=\n
	'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);\n
	})(window,document,'script','dataLayer','GTM-M79WG8');</script>\n
	</head>\n
	<body>\n
	<noscript><iframe src='https://www.googletagmanager.com/ns.html?id=GTM-M79WG8'\n
	height='0' width='0' style='display:none;visibility:hidden'></iframe></noscript>\n
	<h1>Mitschrift Mathe / Physik</h1>\n"

FOOTER="</body>\n
	</html>\n"
	
LINK="<a href=https://github.com/hd-notes/notes/raw/master/__URL__>__NAME__</a><br>\n"
LINKUB="<a href=https://github.com/hd-notes/notes/raw/master/__URL__>__NAME__</a>\n"

echo -e $HEADER > index.html
echo -e "<h2> Stand: $(date)</h2>\n" >> index.html


LINKS=""

cd $DIR
PDFS=$(find . -mindepth 2 -maxdepth 2 -name '*.org' -type f)
for pdf in $PDFS; do
	URL=$(sed s/'^\.\/'//g <<< $(sed s/org/pdf/ <<< $pdf))
	NAME=$(cat $(sed s/pdf/org/ <<< $pdf) | grep '#+TITLE:' | sed s/'#+TITLE: '//)
#	echo sed 's|__NAME__|'"$NAME"'|' <<< $(sed 's|__URL__|"$URL"|' <<< $LINK)
	LINKS+="$(sed 's|__NAME__|'"$NAME"'|' <<< $(sed 's|__URL__|'"$URL"'|' <<< $LINK))" 
	TUTORIALS="$(echo $(dirname $pdf)'/tutorial')"
	NAME=0
	if [ -d "$TUTORIALS" ]; then
		LINKS+="Übungszettel: "
		TUTS=$(find $TUTORIALS -mindepth 1 -maxdepth 1 -type f -name '*.pdf' | sort)
		for tut in $TUTS; do
			URL=$(sed s/'^\.\/'//g <<< $tut)
			NAME=$(($NAME+1))
			LINKS+="$(sed 's|__NAME__|'"$NAME"'|' <<< $(sed 's|__URL__|'"$URL"'|' <<< $LINKUB)) " 
		done

		LINKS+="<br>"
	fi
done

cd - 2>&1 > /dev/null

echo -e $LINKS >> index.html
echo -e $FOOTER >> index.html

