# One line to test against all shells
#   for SH in $(bashes) $(zshs); do echo $SH; eval "$SH test_damlev.sh"; echo $?; done

source damlev.sh

set -e
#set -x

_tutr_damlev cat cta 1

_tutr_damlev cat act 1

_tutr_damlev us ls 1

_tutr_damlev ls sl 1

_tutr_damlev ll ls 1

_tutr_damlev t tar 2

_tutr_damlev tar t 2

_tutr_damlev atr t 2

_tutr_damlev trubble rubble 1

_tutr_damlev trubble rubbel 2

_tutr_damlev mkdir mdkir 1

_tutr_damlev mkdir kmird 3

_tutr_damlev bhas bash 2

_tutr_damlev bahs bash 1

_tutr_damlev python pyhton 1

_tutr_damlev python pyton 1

_tutr_damlev grep gerp 1

# there is a bug here
_tutr_damlev less les 1  # my impl. counts this as 0

_tutr_damlev cd dc 1
