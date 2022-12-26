# vim: set expandtab tabstop=4 shiftwidth=4:


# Exit code indicating the lesson was completed successfully
_COMPLETE=7


# This function is run *BEFORE* a command.
preexec() {
    if [[ -n $BASH ]]; then
        _CMD=( $1 )
    elif [[ -n $ZSH_NAME ]]; then
        _CMD=( ${(z)1} )
    fi
}


# This function is run *AFTER* a command and *BEFORE* the prompt is drawn.
#
# Perhaps should have been called preprompt()
precmd() {
    local _RES=$?

    # This is needed for ${_CMD[0]} to work in the skill's *_test
    if [[ -n $ZSH_NAME ]]; then
        emulate -L zsh
        setopt ksh_arrays
    fi

    # This if statement prevents running all of this code when the user simply
    # hits ENTER at the prompt
    if [[ -n $_CMD ]]; then
        # Check whether the test now passes
        if $_TEST; then

            # Run this skill's _post and _epilogue functions, if extant
            _tutr_has_function $_POST && $_POST
            _tutr_has_function $_EPILOGUE && _tutr_warn $_EPILOGUE

            # Clear the command line before running the next test
            # Some skills are completed based upon the state of the system,
            # others look only at the command which was run.
            #
            # Clearing this array prevents the latter skills from passing based
            # upon the previous command text.
            _CMD=()

            # Move onto the next skill and run its tests
            _tutr_next_skill
        else
            _tutr_warn $_HINT $?
        fi
    fi

    _CMD=$1
}


# Display the contents of _CMD, numbered
_tutr_debug_CMD() {
    local I=0
    for W in ${_CMD[@]}; do
        echo "$I. $W"
        (( I++ ))
    done
}


# Set the tutor's informative output apart from a command's with a bold green
# "Tutor:" in the gutter
_tutr_info() {
    echo
    eval "$@" | sed -e $'s/.*/\x1b[1;32mTutor\x1b[0m: &/'
    echo
}


# Set the tutor's warning output apart from a command's with a bold green
# "Tutor:" in the gutter
_tutr_warn() {
    echo
    eval "$@" | sed -e $'s/.*/\x1b[1;33mTutor\x1b[0m: &/'
    echo
}

# Set the tutor's error output apart from a command's with a bold green
# "Tutor:" in the gutter
_tutr_err() {
    echo
    eval "$@" | sed -e $'s/.*/\x1b[1;31mTutor\x1b[0m: &/'
    echo
}


# Display a command's output the same as _tutr_err then exit
_tutr_die() {
    _tutr_err "$@"
    exit 1
}


# Detect when the user copies & pastes "Tutor:" from the gutter
alias Tutor:="
echo
printf \"\x1b[1;31mTutor\x1b[0m: Whoops, you pasted \\\"Tutor:\\\" as part of your command.\n\"
printf \"\x1b[1;31mTutor\x1b[0m: Be careful when copying what I say to you!\n\"
false"


# Read a single key from STDIN
_tutr_getc() {
    if [[ -n $BASH ]]; then
        read -r -n 1 -s
    elif [[ -n $ZSH_NAME ]]; then
        read -r -k -s
    fi
}


# Enable user to interact with the tutor
tutor() {
    if [[ -n $ZSH_NAME ]]; then
        emulate -L zsh
        setopt ksh_arrays
    fi
    case $1 in
        hint)
            _tutr_warn $_PROLOGUE
            ;;

        check)
            : # Intentional NO-OP - _test will be run automatically anyway
            ;;

        where)
            printf $'\x1b[1;32mTutor\x1b[0m: You are on step \x1b[1;35m%s\x1b[0m of \x1b[1;35m%s\x1b[0m\n' $_I $_MAX_SKILL
            local i
            for ((i=0; i <= _MAX_SKILL; ++i)); do
                if ((i == _I)); then
                    printf $'\x1b[1;32mTutor\x1b[0m: \x1b[1;35m%2s. \x1b[4m%s\x1b[0m\n' $i ${_SKILLS[$i]}
                else
                    printf $'\x1b[1;32mTutor\x1b[0m: %2s. %s\n' $i ${_SKILLS[$i]}
                fi
            done
            ;;

        skip)
            printf $'\x1b[1;33mTutor\x1b[0m: Skipping step \x1b[1;35m%s\x1b[0m of \x1b[1;35m%s\x1b[0m\n' $((_I + 1)) $_MAX_SKILL
            _tutr_next_skill $((_I + 1))
            ;;

        goto)
            if [[ -n "$2" && $2 -ge 0 && $2 -le $_MAX_SKILL ]]; then
                printf $'\x1b[1;33mTutor\x1b[0m: Going directly to step \x1b[1;35m%s\x1b[0m of \x1b[1;35m%s\x1b[0m\n' $2 $_MAX_SKILL
                _tutr_next_skill $(( $2 ))
            else
                printf $'\x1b[1;31mTutor\x1b[0m: Cannot go to step \x1b[1;35m%s\x1b[0m of \x1b[1;35m%s\x1b[0m\n' $2 $_MAX_SKILL
            fi
            ;;

        which|what|name)
            printf $'\x1b[1;33mTutor\x1b[0m: The name of this step is "\x1b[1;4;35m%s\x1b[0m"\n' ${_SKILLS[$((_I))]}
            ;;

        fix)
            if _tutr_has_function $_PRE; then
                printf $'\x1b[1;33mTutor\x1b[0m: Trying a fix; if this does not work, run "tutor bug"\n'
                $_PRE
            else
                printf $'\x1b[1;33mTutor\x1b[0m: I do not know how to fix this; run "tutor bug"\n'
            fi
            ;;

        exit|quit)
            printf $'\x1b[1;32mTutor\x1b[0m: Leaving tutorial...\n\nGoodbye\x1b[0m\n'
            exit 1
            ;;

        bug|stuck)
			cat <<-BUG | sed -e $'s/.*/\x1b[1;33mTutor\x1b[0m: &/'
			I'm sorry there is a bug in the tutorial, that should not have happened!
			Copy the text below the line and email it to erik.falor@usu.edu.

			In your email please explain
			  * what you tried to do
			  * what you thought should happen
			  * what actually happened
			  * any additional context that you feel is important

			Copy as much of the text on the screen preceding the problem as you can
			so I can get as much context as possible.

			Thanks in advance!
			_________________________________________________________________________
			BUG

			cat <<-MSG


			TUTR_REVISION=$_TUTR_REV
			LESSON=$_TUTR
			STEP=$_I
			SKILLS=${_SKILLS[@]}
			PWD=$PWD
			ORIG_PWD=$_ORIG_PWD
			HOME=$HOME
			PATH=$PATH
			SHLVL=$SHLVL
			LANG=$LANG
			UNAME-A=$(uname -a)
			SHELL=$SHELL
			${ZSH_VERSION:+ZSH_VERSION=$ZSH_VERSION}${BASH_VERSION:+BASH_VERSION=$BASH_VERSION}
			$(git --version)

			MSG
            ;;

        *)
            # A heredoc declared with '<<-' requires TABS (\t) in the source
            # It's a really nice feature, but I'm not sure that I want to mix
            # tabs with spaces...
			cat <<-HELP | sed -e $'s/.*/\x1b[1;32mTutor\x1b[0m: &/'
				help       This message
				bug        Use this if you find a problem in the tutorial
				hint       Give a hint about this step
				check      Re-run this step's test() function
				where      Display progress
				name       Display the name of this step
				skip       Skip to the next step (if possible)
				fix        Attempt to fix the tutorial
				quit       Quit this tutoring session
				HELP
            ;;
    esac
}


# Return TRUE when the function named by $1 exists
_tutr_has_function() {
    if [[ -z $1 ]]; then
        echo Usage: $0 FUNCTION
        return 1
    fi

    if [[ -n $BASH ]]; then
        declare -f $1 >/dev/null
        return $?

    elif [[ -n $ZSH_NAME ]]; then
        functions $1 >/dev/null
        return $?
    fi
}


# Press any key to continue prompt
_tutr_pressanykey() {
    echo $'\x1b[7m[Press any key]\x1b[0m'
    _tutr_getc
}


# Yes/no prompt
# Returns
#   0 When an affirmative response is given: "Y", "y", and ENTER are considered affirmative
#   1 When negative: "N" and "n" are negative
#   Otherwise, the prompt is repeated
_tutr_yesno() {
    while true; do
        printf "\n\x1b[1;33mTutor\x1b[0m: $@ [Y/n] "
        _tutr_getc

        case $REPLY in
            ""|[Yy])
                return 0 ;;
            [Nn])
                return 1 ;;
        esac
    done
}


# Default hint function
_tutr_hint() {
    echo "It's okay to make mistakes.  Try again!"
}


_tutr_next_skill() {
    if [[ -n $ZSH_NAME ]]; then
        emulate -L zsh
        setopt ksh_arrays
    fi

    if [[ -n $1 ]]; then
        # This is how `tutor goto N` works
        _I=$1
    else
        # In the normal case we increment _I now so as to not re-run the test
        # of a skill that's just been passed off
        (( _I++ ))
    fi

    until _tutr_is_all_done $0; do
        _PROLOGUE=${_SKILLS[$_I]}_prologue
        _PRE=${_SKILLS[$_I]}_pre
        _HINT=${_SKILLS[$_I]}_hint
        _TEST=${_SKILLS[$_I]}_test
        _EPILOGUE=${_SKILLS[$_I]}_epilogue
        _POST=${_SKILLS[$_I]}_post

        if ! _tutr_has_function $_HINT; then
            if _tutr_has_function $_PROLOGUE; then
                _HINT=$_PROLOGUE
            else
                _HINT=_tutr_hint
            fi
        fi

        if _tutr_has_function $_TEST; then

            # Run this skill's `pre_` (if extant) before testing
            _tutr_has_function $_PRE && $_PRE

            if ! $_TEST; then
                # Run this skill's `prologue_` function, if extant
                _tutr_has_function $_PROLOGUE && _tutr_info $_PROLOGUE
                break

            else
                # go on to the next skill
                (( _I++ ))
                continue
            fi

        else
            _tutr_die printf "'ERROR in $0: $_TEST does not exist'"
        fi
    done

    _tutr_is_all_done $0 && _tutr_all_done
}


# Detect when the user is all done with this tutorial (presently, when len(_SKILLS) == 0
_tutr_is_all_done() {
    (( ${#_SKILLS[@]} == 0 || _I == ${#_SKILLS[@]} ))
}


# Conclude and exit the tutorial environment
_tutr_all_done() {
    if _tutr_has_function epilogue; then
        _tutr_info epilogue
    else
        echo
        echo $'\x1b[1;32mTutor\x1b[0m: All done!'
        echo $'\x1b[1;32mTutor\x1b[0m: This concludes your lesson'
    fi
    # Indicate that the lesson was completed successfully
    exit $_COMPLETE
}


# Displays the +/- status bar before the prompt
_tutr_statusbar() {
    if (( $# < 2 )); then
        echo "ERROR: too few arguments"
        echo "USAGE: _tutr_statusbar NUMERATOR DENOMINATOR [MESSAGE]"
        return 1
    fi

    local N=$1
    shift
    local D=$1
    shift

    if (( $# > 0 )); then
        local MSG=$'\x1b[1;7m'$@$'\x1b[0m'" - Step $N of $D ["
    else
        local MSG="Step $N of $D ["
    fi

    local REMAIN=$((D - N))
    local PADDING='----------------------------------------------------------------------'
    local COMPLET='++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    while (( ${#PADDING} < D )); do
        PADDING=$PADDING$PADDING
        COMPLET=$COMPLET$COMPLET
    done

    printf "$MSG\x1b[1;32m${COMPLET:0:$N}\x1b[1;31m${PADDING:$N:$REMAIN}\x1b[0m]"
}


# Begin the tutorial by initializing the _SKILLS array to this functions arguments
_tutr_begin() {
    [[ -n $BASH ]] && source _tutr/bash-preexec.sh

    # If _BASE is defined chdir into that directory
    [[ -n $_BASE ]] && cd "$_BASE"

    # Remember where we were when we began
    _ORIG_PWD=$PWD

    _tutr_has_function prologue && _tutr_info prologue

    _SKILLS=( $@ )
    _MAX_SKILL=$((${#_SKILLS[@]} - 1))
    _I=0
    _tutr_next_skill $_I

    # add a statusbar to the PS1 prompt
    PS1=$'$(_tutr_statusbar $_I $_MAX_SKILL $(basename $_TUTR))\n'$PS1

    _tutr_is_all_done "$0" && _tutr_all_done
}


_tutr_pretty_time() {
    local seconds=${1:-$SECONDS}
    local -a backwards
    local i=1

    #convert raw seconds into array=(seconds minutes hours)
    while [[ $seconds -ne 0 ]]; do
        backwards[$i]=$(( seconds % 60 ))
        let i++
        let seconds=$(( seconds / 60))
    done

    #reverse the array
    local j=1
    [[ $i -gt 0 ]] && let i--
    local -a result
    while [[ $i -gt 1 ]]; do
        result[$j]=${backwards[$i]}
        let j++
        let i--
    done
    result[$j]=${backwards[$i]}

    #print it out
    case ${#result[@]} in
        3) printf '%02d:%02d:%02d' ${result[@]} ;;
        2) printf '%02d:%02d' ${result[@]} ;;
        1) printf '00:%02d' ${result[@]} ;;
    esac
}


# Install the shell tutorial shim (with permission) into user's RC file
_tutr_install_shim() {
    if [[ -z $1 ]]; then
        _tutr_die printf "'Usage: $0 SHELL_RC_FILE_NAME'"
    fi

    SHIM='[[ -n "$_TUTR" ]] && source $_TUTR || true  # shell tutorial shim DO NOT MODIFY'

	cat <<-ASK | sed -e $'s/.*/\x1b[1;33mTutor\x1b[0m: &/'
	Before you can begin this lesson I need to install a bit of code
	into your shell's startup file '$1'.

	In case you're curious, the code looks like this:

	  $SHIM

	This is a one-time-only edit.  I won't ask to make any more changes to your
	startup files.
	ASK

    if _tutr_yesno "May I make this one-time change to this file?"; then
        _tutr_info echo "Installing shell tutorial shim into $1..."
		cat <<-SHIM >> "$1"

		$SHIM

		SHIM

        if (( $? != 0 )); then
            _tutr_die printf "'I am unable to modify $1.  Exiting tutorial.'"
        fi
    else
        _tutr_die printf "'You cannot proceed with the tutorial without making this change.'"
    fi
}
