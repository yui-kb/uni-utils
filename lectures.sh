#!/bin/bash
# first defining variables which will be used later on (including lists for options/modules)
parent_dir="/Users/yui/Desktop/notes/second-year/"
date=$(date +%d-%m-%y)
template="$parent_dir/_templates/lect.tex"
lect_file="./lectures/$date.tex"

OPTIONS=("n - New lecture/Edit today's lecture"
         "e - Edit past lecture"
         "v - View compiled lectures"
         "f - Open module folder"
         "p - Practical")

MODULES=("toc - Theory of Computation"
         "prog - Programming Paradigms"
         "anal - Analysis I"
         "comp - Complex Analysis II"
         "amv - Analysis in Many Variables II"
         "ent - Elementary Number Theory II"
         "dssc - Data Science and Statistical Computing"
         "alg - Algebra II")

option=$(printf '%s\n' "${OPTIONS[@]}" | fzf --preview 'echo {}' --preview-window=up:2:wrap)

case $option in
         "n - New lecture/Edit today's lecture")

module=$(printf '%s\n' "${MODULES[@]}" | fzf --preview 'echo {}' --preview-window=up:2:wrap)

choice="${module%% *}"
cd $parent_dir$choice

if [[ ! -f ./lectures/$date.tex ]] then
        cp $template $lect_file
echo "\subfile{lectures/$date}" >> main.tex

lc=$(wc -l < ./main.tex)
linea=$lc-1
lineb=$lc
{
    printf '%dm%d\n' "$lc-1" "$lc"
    printf '%d-m%d-\n' "$lc" "$lc-1"
    printf '%s\n' w q
} | ed -s main.tex
fi
vim ./lectures/$date.tex
# generate a subfile in lectures/ subdirectory
# add the subfile to the main lecture tex file
# open the lecture subfile, ready to edit
;;
"f - Open module folder")
module=$(printf '%s\n' "${MODULES[@]}" | fzf --preview 'echo {}' --preview-window=up:2:wrap)
choice="${module%% *}"
cd $parent_dir$choice
;;
"e - Edit past lecture")
module=$(printf '%s\n' "${MODULES[@]}" | fzf --preview 'echo {}' --preview-window=up:2:wrap)
choice="${module%% *}"
cd $parent_dir$choice/lectures
lecture=$(find * | fzf --preview 'echo {}' --preview-window=up:2:wrap --tac --no-sort)
vim ./$lecture
;;
*)
        exit
esac
