#!/bin/bash
DIR=${1:-../lectures}

HEADER="<!DOCTYPE html>\n
    <html>\n
    <head>\n
    <meta charset='utf-8'>\n
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':\n
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],\n
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=\n
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);\n })(window,document,'script','dataLayer','GTM-M79WG8');</script>\n
    </head>\n
    <body>\n
    <noscript><iframe src='https://www.googletagmanager.com/ns.html?id=GTM-M79WG8'\n
    height='0' width='0' style='display:none;visibility:hidden'></iframe></noscript>\n
    <a href='https://github.com/hd-notes/notes/'><img style='position: absolute; top: 0; right: 0; border: 0;' src='https://camo.githubusercontent.com/e7bbb0521b397edbd5fe43e7f760759336b5e05f/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677265656e5f3030373230302e706e67' alt='Fork me on GitHub' data-canonical-src='https://s3.amazonaws.com/github/ribbons/forkme_right_green_007200.png'></a>\n
    <h1>Mitschrift Mathe / Physik</h1>\n"

FOOTER="</body>\n
    </html>\n"

LINK="<a href=https://github.com/hd-notes/pdfs/raw/master/__URL__>__NAME__</a>\n"

echo -e $HEADER > index.html
echo -e "<h2> Stand: $(date)</h2>\n" >> index.html


LINKS=""

cd $DIR
PDFS=$(find . -mindepth 2 -maxdepth 2 -name '*.org' -type f)
for pdf in $PDFS; do
    PDF_PATH=$(sed s/org/pdf/ <<< $pdf)
    URL=$(sed s/'^\.\/'//g <<< $PDF_PATH)
    NAME=$(cat $(sed s/pdf/org/ <<< $pdf) | grep '#+TITLE:' | sed s/'#+TITLE: '//)
#	echo sed 's|__NAME__|'"$NAME"'|' <<< $(sed 's|__URL__|"$URL"|' <<< $LINK)
    if [ -f $PDF_PATH ]; then
        LINKS+="$(sed 's|__NAME__|'"$NAME"'|' <<< $(sed 's|__URL__|'"$URL"'|' <<< $LINK))"
        TUTORIALS="$(echo 'pdfs/'$(dirname $pdf)'/tutorial')"
        NAME=0
        if [ -d "$TUTORIALS" ]; then
            LINKS+="<br>"
            LINKS+="Übungszettel: "
            TUTS=$(find $TUTORIALS -mindepth 1 -maxdepth 1 -type f -name '*.pdf' | sort -V)
            for tut in $TUTS; do
                URL=$(sed s/'^pdfs\/\.\/'//g <<< $tut)
                NAME=$(($NAME+1))
                LINKS+="$(sed 's|__NAME__|'"$NAME"'|' <<< $(sed 's|__URL__|'"$URL"'|' <<< $LINK)) "
            done

        fi
        LINKS+="<br><br>"
    fi
done

cd - 2>&1 > /dev/null

echo -e $LINKS >> index.html
echo -e $FOOTER >> index.html

