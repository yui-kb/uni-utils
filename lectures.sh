#!/bin/bash

parent_dir="/Users/yui/Desktop/notes/second-year/"
date=$(date +%d-%m-%y)
template="$parent_dir/_templates/lect.tex"
lect_file="./lectures/$date.tex"

MODULES=("toc - Theory of Computation"
         "prog - Programming Paradigms"
         "anal - Analysis I"
         "comp - Complex Analysis II"
         "amv - Analysis in Many Variables II"
         "ent - Elementary Number Theory II"
         "dssc - Data Science and Statistical Computing")

module=$(printf '%s\n' "${MODULES[@]}" | fzf --preview 'echo {}' --preview-window=up:2:wrap)

# there's currently a bug with the following if statement.

if [[ ! -v module ]]; then
        echo "fuck you"
        return
fi

choice="${module%% *}"
cd $parent_dir$choice

if [[ ! -f ./lectures/$date.tex ]] then
        cp $template $lect_file
fi


#ghead -n -1 ./main.tex > temp ; mv temp ./main.tex
echo "\subfile{lectures/$date}" >> main.tex
#echo "\end{document}" >> main.tex
lc=$(wc -l < ./main.tex)
linea=$lc-1
lineb=$lc
{
    printf '%dm%d\n' "$linea" "$lineb"
    printf '%d-m%d-\n' "$lineb" "$linea"
    printf '%s\n' w q
} | ed -s main.tex
echo $lc
vim ./lectures/$date.tex
# generate a subfile in lectures/ subdirectory
# add the subfile to the main lecture tex file
# open the lecture subfile, ready to edit
