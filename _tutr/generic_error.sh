# ENUMERATE EVERY WAY A SKILL CAN GO WRONG
WRONG_PWD=1
WRONG_CMD=2
MISSPELD_CMD=3
WRONG_ARGS=4
TOO_FEW_ARGS=5
TOO_MANY_ARGS=6
PASS=7
STATUS_FAIL=8
STATUS_WIN=9


# Spellchecking
if [[ -n $BASH_VERSION && ${BASH_VERSINFO[0]} -lt 4 ]]; then
	source _tutr/lev.sh
	SPELLCHECK=_tutr_lev
else
	source _tutr/damlev.sh
	SPELLCHECK=_tutr_damlev
fi



# Compute the longest common prefix of two paths
#
# When called with 2 arguments, store the result into $REPLY
# When called with more arguments, print the result to STDOUT
_tutr_lcp() {
	# Convert path strings into arrays of path components
	if [[ -n $ZSH_NAME ]]; then
		local O=-rA
		emulate -L zsh
		setopt ksh_arrays
	else
		local O=-ra
	fi
	local -a p1 p2
	IFS=/ read $O p1 <<< "$1"
	IFS=/ read $O p2 <<< "$2"

	## Find length of shortest array
	local end
	(( ${#p1[@]} < ${#p2[@]} )) && local end=${#p1[@]} || local end=${#p2[@]}

	## Search for the first differing component, accumulating the common prefix
	local prefix
	local i
	for (( i=0; i < end; ++i)); do
		if   [[ -z ${p1[$i]} ]]; then continue
		elif [[ ${p1[$i]} == ${p2[$i]} ]]; then
			prefix+=/${p1[$i]}
		else
			break
		fi
	done


	## Return the $result
	[[ -n $3 ]] && echo $prefix || REPLY=$prefix
}



# Display the minimal `cd` command needed to get to a target directory
# Print `cd -` if the target is $OLDPWD
# Prints a `cd` command which appropriately uses relative or absolute paths
# Wraps the directory name in single-quotes if it contains a space
#
# Input: the absolute path of the directory the user should be in
_tutr_minimal_chdir_hint() {
	if [[ -n "$1" ]]; then
		local there="$1"
		local here="${2:-$PWD}"

		local tmp=$there
		[[ $there = $HOME/* ]] && tmp="~${there#$HOME}"
		cat <<-MSG
			To proceed you need to be in the directory
			  $tmp
		MSG

		tmp=$here
		if [[ -n $tmp ]]; then
			[[ $here = $HOME/* ]] && tmp="~${here#$HOME}"
			cat <<-MSG
				instead of
				  $tmp
			MSG
		fi

		echo
		echo This command will get you back on track so you can continue the tutorial:

		# suggest 'cd -' when that will work
		if [[ $there = $OLDPWD ]]; then
			echo "  cd -"
		else
			# Elide the common prefix of $here and there
			_tutr_lcp "$here" "$there"
			local LCP=$REPLY
			local dest=""

			if [[ -z $LCP ]]; then
				# 0. no common subtree; return $there verbatim
				dest=$there
			else
				local e_here=${here#$LCP}
				local e_there=${there#$LCP}

				# n.b. this pair of param expansions remove any trailing '/' after $LCP!
				e_here=${e_here#/}
				e_there=${e_there#/}

				if [[ -z $e_here && -z $e_there ]]; then
					cat <<-ERROR

					This should not have happened.

					Run 'tutor bug' and email its output to erik.falor@usu.edu.
					Scroll back a few steps to copy some of the preceeding text for
					context.

					ERROR
					return 1
				elif [[ -z $e_here ]]; then
					# 1. $there is a subdir of $here; return $e_there sans the leading /
					dest=${e_there#/}
				else
					# 2. $here is a subdir of $there; return ../ for each component of $here ($there is empty in this case)
					# 3. $there is a cousin dir of $here; return $there prepended with ../ for each component of $here
					dest=../$e_there
					while [[ $e_here = */* ]]; do
						dest=../$dest
						e_here=${e_here#*/}
					done
				fi
			fi

			# Make the output pretty: replace $HOME with ~
			[[ "$HOME" = "$dest/*" ]] && dest="~${dest#$HOME}"

			# ... and wrap the destination directory in quotes if it contains spaces
			[[ $dest = *" "* ]] && dest="'$dest'"

			# finally, remove a trailing /
			echo "  cd ${dest%/}"
		fi
		echo

	else
		cat <<-MSG
		You are presently in the wrong directory.  Unfortunately,
		I can't tell you which directory you should be in.

		Run 'tutor bug' and email its output to erik.falor@usu.edu.
		Scroll back a few steps to copy some of the preceeding text for
		context.

		Then, I'm afraid that you'll need to restart this lesson :-(

		MSG
	fi
}



# -a = ordered args - must be present in this given order
#      This argument must be given once per positional argument
#      It is regarded as a regular expression, i.e.:
#         -a "^hint$\|^hant$"
# -d = dir - what must PWD be?
# -c = cmd - which command is acceptable?
# -l = Max acceptable Levenshtein distance for misspelled commands
#      (Default distance = 1; set to 0 to disable spellchecking)
# -n = Disregard # of command's arguments
# -i = Ignore command's exit status (default is to report on non-zero exit status)
# -f = Expect command to fail
#
# Examples:
#  
#  Validate 'ls file1.txt file2.txt' in the directory $_BASE, checking for simple typos
#    _tutr_generic_test -c ls -d $_BASE -a file1.txt -a file2.txt
#
#  Idem. but disregard misspellings of 'ls'
#    _tutr_generic_test -c ls -d $_BASE -a file1.txt -a file2.txt -l 0
#
# Validate 'systemctl restart' considering typos with lev. dist. between [1,3]
#    _tutr_generic_test -c systemctl -a restart -l 3

# TODO: when the user gives an argument with a trailing '/' this command
#       regards it as wrong, even though in most cases it works just fine
#       Use a regex to cope with this
_tutr_generic_test() {

	local -a _A=( cmd )
	local _C= _D=
	local _F= _I=  # options -f and -i are mutually exclusive
	local -i _N=0 _L=1

	local OPT
	OPTIND=1
	while getopts 'a:c:d:fil:n' OPT; do
		case $OPT in
			a) _A+=("$OPTARG") ;;
			c) _C="$OPTARG" ;;
			d) _D="$OPTARG" ;;
			f) _F=fail _I= ;;
			i) _I=ignore _F= ;;
			l) _L="$OPTARG" ;;
			n) _N=-1 ;;
			*)
				echo "_tutr_generic_test getopts parse error! 1=$1 2=$2 3=$3 4=$4" >&2
				exit 1
				;;
		esac
	done

	if [[ -z $_C ]]; then
		echo "_tutr_generic_test: Option '-c CMD' is mandatory" >&2
		exit 1
	fi

	_A[0]=$_C

	## When -n was specified don't count # of arguments on cmdline
	(( _N == 0 )) && _N=${#_A[@]}

	if [[ -n $DEBUG ]]; then
		echo "DEBUG|"
		echo "DEBUG| _A=$_N(${_A[@]})"
		echo "DEBUG| _C=$_C"
		echo "DEBUG| _D=$_D"
		echo "DEBUG| _I=$_I"
		echo "DEBUG| _F=$_F"
		echo "DEBUG| _L=$_L"
		echo "DEBUG|"
		if [[ -n "${_CMD[@]}" ]]; then
			echo "DEBUG| _CMD='${_CMD[@]}'"
			for ((i=0; i<${#_CMD[@]}; ++i)); do
					echo "DEBUG| _CMD[$i]='${_CMD[$i]}'"
			done
			echo "DEBUG| _RES=$_RES"
		fi
		echo "DEBUG|"
	fi

	# Check if the user was in the wrong dir ...
	[[ -n $_D && $PWD != $_D ]] && return $WRONG_PWD

	# if command is spelled correctly...
	if [[ ${_CMD[0]} == $_C ]]; then

		if (( _N > 0 )); then
			# ... or has too few args ...
			[[ "${#_CMD[@]}" -lt $_N ]] && return $TOO_FEW_ARGS

			# ... or too many args ...
			[[ "${#_CMD[@]}" -gt $_N ]] && return $TOO_MANY_ARGS
		fi

		# ... or the wrong args
		# (I think this will work b/c ksh_arrays should be in force for Zsh)
		for (( _J=1; _J<$_N; _J++ )); do
			# =~ works in Bash and Zsh; the regex pattern goes on RHS
			# IMPORTANT! Do NOT put quotes around the regex pattern!
			# The pattern is not a string to be quoted
			! [[ ${_CMD[$_J]} =~ ^${_A[$_J]}$ ]] && return $WRONG_ARGS
		done

		if [[ $_I = ignore ]]; then
			## When -i is specified we will ignore the exit code of the command;
			return 0
		elif [[ $_F = fail ]]; then
			## When -f is specified we expect the command to have failed
			[[ $_RES != 0 ]] && return 0 || return $STATUS_WIN
		elif [[ $_RES != 0 ]]; then
			## Otherwise, we care that the command's exit code == 0
			return $STATUS_FAIL
		else
			return 0
		fi

	elif [[ $_L != 0 && -n ${_CMD[0]} ]]; then
		# When we get down here it's because the command didn't match the expectation.
		# If spellchecking is an option, see if the user made a typo ...
		$SPELLCHECK ${_CMD[0]} $_C $_L && return $MISSPELD_CMD
	fi

	# ... If it wasn't a typo it can only be the wrong command
	return $WRONG_CMD
}



# $1 = error code
# $2 = name of cmd they should have run
# $3 = Directory user needs to get into
_tutr_generic_hint() {
	case $1 in
		$MISSPELD_CMD)  echo "It looks like you spelled '$2' wrong" ;;
		$WRONG_CMD)     echo "Use the '$2' command to proceed" ;;
		$TOO_FEW_ARGS)  echo "You gave '$2' too few arguments" ;;
		$TOO_MANY_ARGS) echo "You ran '$2' with too many arguments" ;;
        $WRONG_ARGS)    echo "'$2' got the wrong argument(s)" ;;
		$WRONG_PWD)     _tutr_minimal_chdir_hint "$3" ;;
        $PASS)          : ;;
		$STATUS_FAIL)   echo "'$2' failed unexpectedly" ;;
		$STATUS_WIN)    echo "'$2' reported success when it should have failed" ;;
		*)              printf "_tutr_generic_hint(): Why are we here? CMD=%s \%1=%s\n\n" ${_CMD[@]} $1 ;;
	esac
}


# vim: set filetype=sh noexpandtab tabstop=4 shiftwidth=4:
