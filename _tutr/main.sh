# vim: set expandtab tabstop=4 shiftwidth=4:

# Exit when launched from an unsupported shell
#   Uses expernal `expr` program b/c I can't be sure whether this is being
#   evaluated in a shell with a sane `case` statement
if ! expr $SHELL : ".*/bash" \| $SHELL : ".*/zsh" >/dev/null; then
	1>&2 echo This tutorial must be run from either Bash or Zsh
	1>&2 echo Your shell is $SHELL
	1>&2 echo
	exit 1
fi


source _tutr/stdlib.sh


if [[ -n $ZSH_NAME ]]; then
    emulate -L zsh
    # Make the statusbar appear above the prompt in Zsh on MacOS
    setopt prompt_subst
fi


# When the tutorial defines a string var _HELP, display it in response
# to command line arguments -h|-help|--help
# Otherwise, tutorials don't take command line arguments
if [[ -z $_TUTR ]] && (( $# > 0 )); then
    if [[ -n "$_HELP" ]]; then
        case $1 in
            -h|-help|--help)
                echo "$_HELP"
                exit 0
                ;;
            *)
                1>&2 echo "Usage: $0 [-h|-help|--help]"
                exit 1
                ;;
        esac
    else
        1>&2 echo "Error: This tutorial does not accept command line arguments"
        1>&2 echo "       Try again without any extra arguments after the command"
        exit 2
    fi
fi


# Detect or install the rc-file shim
if [[ -z "$_TUTR" ]]; then
    case $SHELL in
        *zsh)
            if [[ ! -f "$HOME/.zshrc" ]]; then
                _tutr_install_shim "$HOME/.zshrc"
            elif ! grep -q "# shell tutorial shim DO NOT MODIFY" "$HOME/.zshrc"; then
                _tutr_install_shim "$HOME/.zshrc"
            fi
            ;;
        *bash)
            if [[ ! -f "$HOME/.bashrc" ]]; then
                _tutr_install_shim "$HOME/.bashrc"
            elif ! grep -q "# shell tutorial shim DO NOT MODIFY" "$HOME/.bashrc"; then
                _tutr_install_shim "$HOME/.bashrc"
            fi
            ;;
        *)
            _tutr_die printf "'Unable to install tutorial shim into your shell's startup file'"
            ;;
    esac

    export _TUTR=$0 _TUTR_REV=$(git describe --always --dirty)
    # We want to run _tutr_begin() only once.  Because of the way we spawn a
    # subshell AND source the lesson script, _tutr_begin() would be invoked again
    # after the end of a lesson.
    #
    # This snippet of code returns 1 or 0 to ensure that _tutr_begin is only run
    # at the beginning of a lesson.
    if _tutr_has_function setup && ! setup ""; then
        _tutr_die printf "'$0 setup error: contact erik.falor@usu.edu for help'"
    fi
    $SHELL
    _DISPOSITION=$?
    _tutr_has_function cleanup && cleanup $_DISPOSITION
    false
else
    true
fi
##
## WARNING!!! DO NOT ADD ANY COMMANDS BELOW THIS POINT!
##
## The last thing this script should do is run either `true` or `false` above.
## Adding another command can cause the prologue to be re-displayed upon exit
