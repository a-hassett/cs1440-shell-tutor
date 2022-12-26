# This file is for loading the levenshtein algorithm. Works with bash and zsh.
# Adapted to be zsh compatible from: https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#Bash
# Adaptation by Jaxton Winder and Erik Falor, June 2020
#
# Tested in Bash versions 3.2, 4.0, 4.4, 5.0
# Tested in Zsh versions 5.2, 5.3.1, 5.4.2, 5.5.1, 5.6.2, 5.7, 5.8

# When the computed Levenshtein distance is between 1 and the optional
# threshold (arg 3) return True, indicating a misspelling
# 
# Otherwise the misspelling is too great and the client wants to regard it as
# the wrong command entirely
function _tutr_lev {
    if (( $# < 2 )); then
        echo "Usage: _tutr_lev word1 word2 [threshhold]" >&2
    elif (( ${#1} < ${#2} )); then
        # shellcheck disable=SC2086
        _tutr_lev "$2" "$1" $3
        return $?
    else
        local str1len=${#1}
        local str2len=${#2}
        local dl=$(( (str1len+1)*(str2len+1) ))
        local stride=$((str1len+1))

        if [[ -n $BASH_VERSION && ${BASH_VERSINFO[0]} -lt 4 ]]; then
            # Bash <= 3.2 doesn't have associative arrays
            local -a d
        else
            local -A d
        fi

        # Initialize the distance table 'd'
        for (( i=0; i<=dl; i++ )); do
            d[$i]=0
        done

        for (( i=1; i<=str1len; i++ )); do
            d[$i]=$i
        done

        for (( j=1; j<=str2len; j++ )); do
            d[$((j*stride))]=$j
        done

        local del ins alt min cost
            for (( i=1; i<=str1len; i++ )); do
        for (( j=1; j<=str2len; j++ )); do
                del=$(( d[$(((i-1) + j*stride))]+1 ))
                ins=$(( d[$((i + (j-1)*stride))]+1 ))
                # check whether the current i char in $1 == current j char in $2
                [[ "${1:${i}-1:1}" = "${2:${j}-1:1}" ]] && cost=0 || cost=1
                alt=$(( d[$(((i-1) + (j-1)*stride))]+cost ))

                # find the lowest score
                (( del < ins )) && min=$del || min=$ins
                (( alt < min )) && min=$alt
                d[$((i + j*stride))]=$min
            done
        done
        local dist=${d[$((str1len+stride*str2len))]}
        
        if (( $# == 3 )); then
            # When a threshhold is given, return True if the distance is
            # non-zero and falls within the threshhold
            (( dist != 0 && dist <= $3 ))
        else
            # Otherwise, display the computed distance
            echo $dist
        fi
    fi
}
