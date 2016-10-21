#!/bin/bash
DIR=${1:-../lectures}

HEADER="<!DOCTYPE html>\n
	<html>\n
	<head>\n
	<meta charset='utf-8'>\n
	<script>\n
	(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){\n
	(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\n
	m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\n
	})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');\n
	ga('create', 'UA-86095188-1', 'auto');\n
	ga('send', 'pageview');\n
	</script>\n
	</head>\n
	<body>\n
	<h1>Mitschrift Mathe / Physik</h1>\n"

FOOTER="</body>\n
	</html>\n"
	
LINK="<a href=https://github.com/hd-notes/notes/raw/master/__URL__>__NAME__</a><br>\n"

echo -e $HEADER > index.html
echo -e "<h2> Stand: $(date)</h2>\n" >> index.html


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
