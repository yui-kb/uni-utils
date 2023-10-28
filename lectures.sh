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
         "s - Snippet groups of lectures")

MODULES=("toc - Theory of Computation"
         "prog - Programming Paradigms"
         "anal - Analysis I"
         "comp - Complex Analysis II"
         "amv - Analysis in Many Variables II"
         "ent - Elementary Number Theory II"
         "dssc - Data Science and Statistical Computing"
         "alg - Algebra II")

option=$(printf '%s\n' "${OPTIONS[@]}" | fzf --preview 'echo {}' --preview-window=up:2:wrap)

module=$(printf '%s\n' "${MODULES[@]}" | fzf --preview 'echo {}' --preview-window=up:2:wrap)
choice="${module%% *}"

cd $parent_dir$choice

case $option in
"n - New lecture/Edit today's lecture")
        # check if today's lecture exists yet before creating
        if [[ ! -f ./lectures/$date.tex ]] then
                cp $template $lect_file
                echo "\subfile{lectures/$date}" >> main.tex

                # weird line swapping ed bullshit to correctly order the final 2 lines of main.tex
                lc=$(wc -l < ./main.tex)
                {
                    printf '%dm%d\n' "$lc-1" "$lc"
                    printf '%d-m%d-\n' "$lc" "$lc-1"
                    printf '%s\n' w q
                } | ed -s main.tex
        fi
        vim ./lectures/$date.tex
;;

"f - Open module folder")
;;

"e - Edit past lecture")
        cd "./lectures"
        lecture=$(find * | fzf --preview 'echo {}' --preview-window=up:2:wrap --tac --no-sort)
        vim ./$lecture
;;

"s - Snippet groups of lectures")
;;

*)
        exit
esac
