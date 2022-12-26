# Return true if ${_CMD[0]} is one of a set of commands for which I don't want
# to nag the user with a hint.
#
# Extra arguments to this function augment the set of nonce commands.
_tutr_nonce() {
	while (( $# > 0 )); do
		if [[ ${_CMD[0]} = $1 ]]; then
			return 0
		else
			shift
		fi
	done

	[[ ${_CMD[0]} = ls \
		|| ${_CMD[0]} = dir \
		|| ${_CMD[0]} = pwd \
		|| ${_CMD[0]} = tutor \
		|| ${_CMD[0]} = clear \
		|| ${_CMD[0]} = reset \
		]]
}
