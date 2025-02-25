# This file should be run as a shell script and not sourced!
#
# This is because SIGWINCH seems NOT to be caught unless trapped from a subshell

if [[ $# -lt 2 ]]; then
    echo Usage: _tutr_screen_size.sh COLS ROWS
    exit 1
fi

_DONE=

_tutr_check_scrsz() {
    local TARGET_C=$1
    local TARGET_L=$2
    local L=$(tput lines)
    local C=$(tput cols)

    local NEED=
    if (( L < $TARGET_L )); then
        BOTTOM="V"
        BOTTOM_POS=$((L - 1))
        NEED=1
    else
        BOTTOM="_"
        BOTTOM_POS=$TARGET_L
    fi

    if (( C < $TARGET_C )); then
        RIGHT=">"
        RIGHT_POS=$C
        NEED=1
    else
        RIGHT="|"
        RIGHT_POS=$TARGET_C
    fi

    if [[ -n $NEED ]]; then
        tput clear

        # Draw the right border
        for (( R=0; R<L; R++ )); do
            tput cup $R $RIGHT_POS
            printf $RIGHT
        done

        # Draw the bottom border
        tput cup $BOTTOM_POS 0
        for (( I=0; I<C; I++ )); do
            printf $BOTTOM
        done

        tput cup 1 1
        printf "Your terminal is ${C} columns wide x ${L} rows tall"
        tput cup 2 1
        printf "Resize it until it is at least ${TARGET_C}x${TARGET_L}"
        tput cup 3 1
        echo "Or press Ctrl-C to accept it as-is (some text may not fit the screen)"
    else
        _DONE=1
    fi
}


# Prime the pump; if the terminal is already big enough
# set _DONE=1 and skip the loop
_tutr_check_scrsz $1 $2

if [[ -z "$_DONE" ]]; then
    trap "_tutr_check_scrsz $1 $2" SIGWINCH
    trap break SIGINT

    while [[ -z $_DONE ]]; do
        sleep 0.125
    done

    tput cup $(( $(tput lines) - 1)) 0
    trap - SIGWINCH SIGINT
fi
