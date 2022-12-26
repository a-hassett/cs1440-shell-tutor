#!/bin/sh


CERT=certificate.txt

validate_completion() {
	LESSONS=( [0-9]-*.sh )
    MISSING=()
    for L in ${LESSONS[@]}; do
        if ! [[ -s .$L ]]; then
            MISSING+=($L)
        fi
    done

    case ${#MISSING[@]} in
        0)
            # "Here, The Cheat, have a trophy!"
            return 0
            ;;

        1)
			cat <<-:
            
			Wait a minute there!  Aren't you forgetting something?
			You still need to do lesson ${MISSING[0]}.

			Come back when you have done that.
			:
            exit 1
            ;;

        ${#LESSONS[@]})
			cat <<-:

			Um... it's customary to start at the beginning.

			That would be ${LESSONS[0]}.
			:
            exit ${#LESSONS[@]}
            ;;

        *)
			cat <<-:
			Hold up! If my calculations are correct, you still need
			to finish ${#MISSING[@]} lessons before you can have your certificate.
            
			Don't come back until you have completed
			:

			for ((I=0; I < ${#MISSING[@]} - 1; I++)); do
                printf "${MISSING[I]}, "
            done
			printf "\b\b and ${MISSING[${#MISSING[@]} - 1]}\n"
            exit ${#MISSING[@]}
            ;;
    esac
}


congrats() {
	cat <<':'
   _______________________________________________________________________
 / \                                                                      \.
|   |  _____                        __       __     __  _               __|.
 \_ | / ___/__  ___  ___ ________ _/ /___ __/ /__ _/ /_(_)__  ___  ___ / /|.
    |/ /__/ _ \/ _ \/ _ `/ __/ _ `/ __/ // / / _ `/ __/ / _ \/ _ \(_-</_/ |.
    |\___/\___/_//_/\_, /_/  \_,_/\__/\_,_/_/\_,_/\__/_/\___/_//_/___(_)  |.
    |              /___/                                                  |.
    |   _.-'`'-._                                           ________      |.
    |.-'    _    '-.   You completed the shell tutorial! (`\        `\    |.
    | `-.__  `\_.-'                                       `-\ DIPLOMA \   |.
    |   |  `-``\|   I am so proud of you right now that this \   (@)   \  |.
    |   `-.....-A    ASCII art doesn't capture my emotions.  _\   |\    \ |.
    | jgs       #                                           ( _)_________)|.
    |           #         This isn't much to look at,        `----------` |.
    |                     but I suppose you can print                     |.
    |               this screen and hang it on your fridge.               |.
    |   __________________________________________________________________|__.
    |  /                                                                     /.
    \_/dc___________________________________________________________________/.

:
}


make_certificate() {
	cat <<-: > $CERT
	TUTR_REVISION=$_TUTR_REV
	UNAME=$(uname -s)
	SHELL=$SHELL
	${ZSH_VERSION:+ZSH_VERSION=$ZSH_VERSION}${BASH_VERSION:+BASH_VERSION=$BASH_VERSION}
	$(git --version)

	:

	cat .[0-7]-*.sh >> $CERT
	git hash-object $CERT >> $CERT
}


instructions() {
	cat <<-:

	Your certificate is the file named '$CERT'.
	Submit it to Canvas to get credit for this assignment in CS 1440.
	:
}


cert_test() {
    validate_completion
    congrats
    make_certificate
    instructions
    exit 0
}


source _tutr/main.sh && _tutr_begin cert

# vim: set filetype=sh noexpandtab tabstop=4 shiftwidth=4 textwidth=76 colorcolumn=76:
