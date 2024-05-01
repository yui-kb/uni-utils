#!/bin/bash
# first defining variables which will be used later on (including lists for options/modules)
parent_dir="/Users/yui/schoolwork/second-year-notes/"
date=$(date +%y-%m-%d)
template="$parent_dir/_templates/lect.tex"
lect_file="./lectures/$date.tex"
pdf_viewer="/Applications/Skim.app/Contents/MacOS/Skim"

OPTIONS=("n - New lecture/Edit today's lecture"
         "e - Edit past lecture"
         "v - View compiled lecture notes"
         "f - Open module folder"
         "s - Snippet groups of lectures"
         "c - Compile full lecture notes"
         "r - Revision Notes"
         "t - Tutorials")

MODULES=("toc - Theory of Computation"
         "prog - Programming Paradigms"
         "anal - Analysis I"
         "comp - Complex Analysis II"
         "amv - Analysis in Many Variables II"
         "alg - Algebra II")

TERMS=("m - Michaelas"
       "e - Epiphany")

option=$(printf '%s\n' "${OPTIONS[@]}" | fzf --preview 'echo {}' --preview-window=up:2:wrap)

module=$(printf '%s\n' "${MODULES[@]}" | fzf --preview 'echo {}' --preview-window=up:2:wrap)
choice="${module%% *}"

cd $parent_dir$choice

if [[ $choice == toc ]] then
        submodule=$(printf "moc\nalg\nfag" | fzf --preview 'echo {}' --preview-window=up:2:wrap)
        cd $parent_dir$choice/$submodule
fi


case $option in
"n - New lecture/Edit today's lecture")
        # check if today's lecture exists yet before creating
        if [[ ! -f ./lectures/$date.tex ]] then
                # Now to get the correct date format
                datewords=$(date +%d" "%A)
                cp $template $lect_file
                echo "\subfile{../lectures/$date}" >> full/main.tex
                echo '\\textit{Lecture '"$datewords}" >> $lect_file
                # weird line swapping ed bullshit to correctly order the final 2 lines of main.tex
                mlc=$(wc -l < ./full/main.tex)
                {
                    printf '%dm%d\n' "$mlc-1" "$mlc"
                    printf '%d-m%d-\n' "$mlc" "$mlc-1"
                    printf '%s\n' w q
                } | ed -s full/main.tex

                # And the same for lecture file
                llc=$(wc -l < $lect_file)
                {
                    printf '%dm%d\n' "$llc-1" "$llc"
                    printf '%d-m%d-\n' "$llc" "$llc-1"
                    printf '%s\n' w q
                } | ed -s $lect_file
        fi
        vim $lect_file
;;

"f - Open module folder")
;;

"e - Edit past lecture")
        cd "./lectures"
        vim -p $(fzf -m --preview 'echo {}' --preview-window=up:2:wrap --tac --no-sort)
;;

"s - Snippet groups of lectures")
        # First need to select all lectures needed
        cd "./lectures"
        lectures=$(find * | fzf --preview 'echo {}' --preview-window=up:2:wrap --tac --no-sort -m)
        echo $lectures
        cp "./template.tex"
        for lecture in $lectures
        do
                echo $lecture
        done
;;

"v - View compiled lecture notes")
        if [[ $choice == toc ]] then
                $pdf_viewer full/main.pdf
        fi
        term=$(printf '%s\n' "${TERMS[@]}" | fzf --preview 'echo {}' --preview-window=up:2:wrap)
        case $term in
        "m - Michaelmas")
                $pdf_viewer michaelmas/full/main.pdf
        ;;
        "e - Epiphany")
                $pdf_viewer full/main.pdf
        ;;
        *)
                exit
        esac
;;

"r - Revision Notes")
        cd ./revision
        vim rev.tex
;;

*)
        exit
esac
