#!/bin/sh

_HELP="
Lesson #2 Topics
================
Find where a program is installed
Discover the type of a command
Reading a command's built-in help text
Find and read the system manual
How to run programs anywhere on your computer

Commands used in this lesson
============================
* which
* type
* man
"

source _tutr/record.sh
if [[ -n $_TUTR ]]; then
	source _tutr/generic_error.sh
	source _tutr/lev.sh
fi

_man_not_found() {
	case $(uname -s) in
		*MINGW*)
			cat<<-MNF
			The command 'man' was not found.  It is required for this lesson.

			Read the section "Special installation instructions for Git for
			Windows users" in README.md to get this set up.

			If this doesn't prevent this message, contact erik.falor@usu.edu
			MNF
			;;
		*)
		cat<<-MNF
			The command 'man' was not found.  It is required for this lesson.

			Contact erik.falor@usu.edu for help
			MNF
			;;
	esac
}

setup() {
	if _tutr_record_exists ${_TUTR#./}; then
		_tutr_warn printf "'You have already completed this lesson'"
		if ! _tutr_yesno "Would you like to do it again?"; then
			_tutr_info printf "'SEE YOU SPACE COWBOY...'"
			exit 1
		fi
	fi

	if ! which man &>/dev/null; then
		_tutr_die _man_not_found
	fi

	$SHELL _tutr/screen_size.sh 80 30
	export _HERE=$PWD
	export _BASE=$PWD/lesson2
	[[ -d "$_BASE" ]] && rm -rf "$_BASE"
	mkdir -p "$_BASE"
}

prologue() {
	clear
	echo
	cat <<-PROLOGUE
	Shell Lesson #2: Running Commands in the Shell

	In this lesson you will learn

	* To use the 'which' command to find where a program is installed
	* About the \$PATH variable and how the shell uses it to find programs
	* What an absolute path is
	* Why some programs must be run by typing './' in front of their name
	* Internal vs. External commands
	* The 'type' command is like 'which', but for internal commands
	* How to get help in the shell

	You may find it helpful to open a second terminal besides this one so
	you can read the manual while running commands in this window.

	Let's get started!

	PROLOGUE

	_tutr_pressanykey
}


cleanup() {
	# Remember that this lesson has been completed
	(( $# >= 1 && $1 == $_COMPLETE)) && _tutr_record_completion ${_TUTR#./}
	[[ -d "$_BASE" ]] && rm -rf "$_BASE"
	echo "You worked on Lesson #2 for $(_tutr_pretty_time)"
}


epilogue() {
	cat <<-EPILOGUE
	And that wraps up Lesson #2.  In this lesson you have learned:

	* To use the 'which' command to find where a program is installed
	* About the \$PATH variable and how the shell uses it to find programs
	* What an absolute path is
	* Why some programs must be run by typing './' in front of their name
	* Internal vs. External commands
	* The 'type' command is like 'which', but for internal commands
	* How to get help in the shell

	Run './3-files.sh' to enter the next lesson

	EPILOGUE

	_tutr_pressanykey
}


which_ls_pre() {
    if [[ -n $ZSH_NAME ]]; then
		export _SH=Zsh
	else
		export _SH=Bash
	fi
	_LS=$(which ls)
}

which_ls_prologue() {
	cat <<-:
	The 'ls' command that you know & love is not a part of your shell.
	It is actually a separate program installed somewhere on your computer.

	Each time you enter a command $_SH searches for a program with a
	matching name and runs it.  If that search comes up empty you will see a
	"command not found" error.  You can learn where $_SH will find 'ls' on
	your computer by using the 'which' command.

	'which' takes the name of a program as an argument.  It either prints
	the full path to the program OR a message saying that program could not
	be found.  Programmers use 'which' to test whether a program is
	installed or to see which version $_SH will run.

	Use 'which' to find out where the 'ls' command resides on your computer.
	:
}

which_ls_test() {
	_tutr_generic_test -c which -a ls
}

which_ls_hint() {
	_tutr_generic_hint $1 which

	cat <<-:

	Use 'which' to see where 'ls' command resides on your computer.
	:
}

which_ls_epilogue() {
	_tutr_pressanykey

	cat <<-:

	The output of 'which' shows you exactly where you can find the 'ls'
	program on your computer.  The "${_LS%/ls}" part of the output
	names the directory (or directories) that contain the 'ls' program.

	The string "$_LS" is called the "path" to the 'ls' program.  In this
	case the path starts with a front-slash '/' character, which instructs
	the shell to start its search at the very beginning of the directory
	structure of the computer.

	Because a path starting with a '/' symbol contains ABSOLUTELY all of the
	information needed to locate the file, it is called an "absolute" path.

	Every file on a computer has its own, unique absolute path.
	An absolute path unambiguously identifies a file.

	:
	_tutr_pressanykey
}


which_cat_pre() {
	_CAT=$(which cat)
}

which_cat_prologue() {
	cat <<-:
	Use 'which' to see where 'cat' resides on your computer.
	:
}

which_cat_test() {
	_tutr_generic_test -c which -a cat
}

which_cat_hint() {
	_tutr_generic_hint $1 which

	cat <<-:

	Use 'which' to see where 'cat' resides on your computer.
	:
}

which_cat_epilogue() {
	_tutr_pressanykey
}



which_which_pre() {
	_WHICH=$(which which)
}

which_which_prologue() {
	cat <<-:
	I wonder where the 'which' command is installed.

	Why not ask 'which' which 'which' the shell will run?
	:
}

which_which_test() {
	_tutr_generic_test -c which -a which
}

which_which_hint() {
	_tutr_generic_hint $1 which

	cat <<-:

	Use 'which' to find out where 'which' lives on your computer.
	:
}

which_which_epilogue() {
	_tutr_pressanykey
	echo

	if [[ $_WHICH != /* ]]; then
		cat <<-:
		You'll notice that on your computer 'which' is built-in to the shell,
		:
		if [[ ${_LS%/ls} == ${_CAT%/cat} ]]; then
			cat <<-:
			and that 'ls' and 'cat' are installed under the same path
			"${_LS%/ls}".
			:
		else
			cat <<-:
			and that 'ls' and 'cat' are not installed together in the same location.
			:
		fi
	elif [[ ${_LS%/ls} == ${_CAT%/cat} && ${_LS%/ls} == ${_WHICH%/which} ]]; then
		cat <<-:
		You'll notice that on your computer all three of these commands are
		installed into the same location of "${_LS%/ls}".
		:
	else
		cat <<-:
		You'll notice that these three commands are not all installed together
		in the directory "${_WHICH%/which}".
		:
	fi

	cat <<-:

	All along you have been running these commands without telling $_SH
	their absolute paths.  How did $_SH know where to find them?

	:
	_tutr_pressanykey
}


echo_path_prologue() {
	cat <<-:
	$_SH consults a list of directories when matching your commands with
	programs it may run.  Otherwise, it would need to search the ENTIRE
	hard drive every time you gave a command.  That would be terribly slow!

	This list is kept in a shell variable called '\$PATH'.

	The shell reads the list from start to finish.  In each directory of
	\$PATH the shell looks for a program whose name matches your command.
	As soon as it finds a match it runs that program.  If it exhausts the
	list without finding a match you'll get an error: "command not found".

	This mechanism means that there can be multiple versions of 'ls'
	installed on your computer.  The shell ALWAYS runs the first one it
	finds.  To use another version, put its directory at the front of \$PATH
	so the shell will find it first.

	You can view your shell's \$PATH with the 'echo' command.  The '$' is
	part of the name of the variable, so don't leave it off!

	Run 'echo \$PATH' now.
	:
}

echo_path_test() {
	_tutr_generic_test -c echo -a '\$PATH'
}

echo_path_hint() {
	case $1 in
		$WRONG_ARGS)
			if ! expr index ${_CMD[1]} '$' >/dev/null; then
				echo "Don't leave the '$' off from the front of '\$PATH'"
			elif [[ '$PATH' != ${_CMD[1]} && '$PATH' = $(echo ${_CMD[1]} | tr a-z A-Z) ]]; then
				echo "You should capitalize the entire word '\$PATH'"
			else
				echo "${_CMD[1]} is not the right variable to look at now."
			fi
			;;
		*)
			_tutr_generic_hint $1 echo
			;;
	esac
	cat <<-:

	Run 'echo \$PATH'.
	:
}

echo_path_epilogue() {
	_tutr_pressanykey

	cat <<-:

	\$PATH is a funny-looking list because it uses colons ':' instead of
	commas to separate its elements.  This makes it hard to read, but if you
	look closely you'll find '${_WHICH%/which}' in there.  Somewhere.

	When $_SH tells you "command not found" it means that it failed to find
	your command in all of the directories of \$PATH.

	If you're sure that the program IS installed, check your spelling.  If
	you didn't make a mistake it may be a matter of adding its directory to
	\$PATH.  This is one way to promote your own programs into shell
	commands; just add the name of their directory to this variable.

	\$PATH is also the reason why you must type './lesson2.sh' to launch
	this lesson: the directory containing 'lesson2.sh' is not a part of
	\$PATH, and so the shell won't find it.  Prefixing a command with './'
	tells $_SH to find it in the CURRENT directory instead of scanning all
	of \$PATH.

	:
	_tutr_pressanykey
}


which_cd_pre() {
	_CD=$(which cd 2>/dev/null)
}

which_cd_prologue() {
	cat <<-:
	Now use 'which' to find out where the 'cd' command is installed.
	:
}

which_cd_test() {
	_tutr_generic_test -i -c which -a cd
}

which_cd_hint() {
	_tutr_generic_hint $1 which

	cat <<-:

	Use 'which' to find out where the 'cd' command is installed:
	  'which cd'
	:
}

which_cd_epilogue() {
	_tutr_pressanykey

	if [[ $_CD == /* ]]; then
		cat <<-:

		Congratulations, your computer has a useless program!

		Well, there's likely more than one, but $_CD is certainly
		among them.
		:
	else
		cat <<-:

		If the 'cd' command is not found, how is it that you've been able to
		run it all this time?
		:
	fi

	cat <<-:

	Some commands are stored in files separate from the shell.  These
	are called "external" commands.  'ls' and 'cat' are examples of
	external commands which belong in their own files.

	"Internal" commands are built-in to $_SH itself.  Internal commands are
	created for a variety of reasons, including speed & efficiency.  It
	turns out that it is impossible for 'cd' to work as an external command.
	(If you take CS3100 - Operating Systems & Concurrency you'll learn why
	this is so).

	:

	# TODO: remove this bit - we don't know about the 'cd' command yet
	if [[ $_CD == /* ]]; then
		cat <<-:
		Despite the fact that there is an external 'cd' command on this
		computer, it is never actually used when you run 'cd' at the command
		line.  The shell prefers to run its own built-in version.

		And even if you did run it, it couldn't possibly do anything.

		You can try it!  This command will never take you to the parent
		directory:

		    $_CD ..

		:
	fi
	_tutr_pressanykey

	cat <<-:

	Most of the time the distinction between EXTERNAL and INTERNAL doesn't
	matter: you can just enter commands and the shell will run them.  But
	when something doesn't work as expected it's helpful to understand why.

	The upside is that you can easily add new commands to the shell by
	writing new programs and changing \$PATH so the shell can find them.
	Your own programs are just as "real" as any other command.

	Later on in CS 1440 you will create your own command line tools and
	"install" them this way.

		:

	_tutr_pressanykey
}


type_cd_prologue() {
	if [[ $_WHICH != /* ]]; then
		cat <<-:
		'type' is another built-in command that operates like 'which'.

		On some systems it is capable of displaying more information about
		commands, both INTERNAL and EXTERNAL.
		:

	else
		cat <<-:
		Because 'which' is an EXTERNAL program it cannot tell you about commands
		that are built in to $_SH.  You need an INTERNAL command to detect
		other INTERNAL commands.

		'type' is the internal command that does this.
	:

	fi

	cat <<-:

	'type' works just like 'which', by taking the name of a command as its
	argument.  'type' can tell you whether a command is

	  0. An EXTERNAL program
	  1. A shell built-in command (INTERNAL)
	  2. An alias                 (INTERNAL)
	  3. A shell function         (INTERNAL)
	  4. None of the above        (Command not found)

	Of the 3 kinds of internal commands we will cover #1 and #2 in more
	depth.  For now you can understand that shell functions are just small
	bits of code written in the $_SH language.

	What kind of internal command is 'cd'?
	Use the 'type' command to find out now.
	:
}

type_cd_test() {
	_tutr_generic_test -c type -a cd
}

type_cd_hint() {
	_tutr_generic_hint $1 type
	cat <<-:

	What kind of internal command is 'cd'?
	Use the 'type' command to find out now.
	:
}

type_cd_epilogue() {
	_tutr_pressanykey
}


type_ls_prologue() {
	cat <<-:
	What kind of command is 'ls'?

	It may be an alias, a function, or an external program.

	An alias can be a shorthand for a longer command, or a nickname.

	When 'ls' is an alias...
	  $_SH rewrites your command by replacing the word 'ls' with whatever
	  text the alias expands into.  It then runs THAT command as though you
	  had typed it in.

	When 'ls' is a shell function...
	  $_SH runs the code defined within the function instead of the program
	  by that name.  The function may call upon the real 'ls' program as
	  part of its code.

	When 'ls' is an external program...
	  $_SH looks for an executable program named 'ls' in each directory
	  listed in \$PATH, stopping as soon as it is found.  It then runs that
	  'ls' program as though you had typed in the absolute path yourself.

	Find out which is the case for your 'ls' command with the 'type'
	command.
	:
}

type_ls_test() {
	_tutr_generic_test -c type -a ls
}

type_ls_hint() {
	_tutr_generic_hint $1 type
	cat <<-:

	What sort of command is 'ls'?
	:
}

type_ls_epilogue() {
	_tutr_pressanykey
}



type_cat_prologue() {
	cat <<-:
	What kind of command is 'cat'?
	Use the 'type' command to find out now.
	:
}

type_cat_test() {
	_tutr_generic_test -c type -a cat
}

type_cat_hint() {
	_tutr_generic_hint $1 type
	cat <<-:

	What sort of command is 'cat'?
	:
}

type_cat_epilogue() {
	_tutr_pressanykey
	cat <<-:

	Another way to learn about commands is to ask them how they want to be
	used.

	:
	_tutr_pressanykey
}



# TODO Cut these skills out - it is too fraught with trouble b/c Mac OS
# doesn't respect GNU long options
cat_help_prologue() {
	cat <<-:
	Command-line arguments beginning with a dash '-' (A.K.A. minus sign) are
	called "options".  There's nothing magic about the dash; it is just a
	convention because folks USUALLY don't give files names beginning with
	'-'.  When a program sees an argument that begins with '-' it assumes it
	does not refer to a file.  Of course, this causes problems if you
	"accidentally" create files with weird names, so try not to do that,
	okay?

	The '-h' option suggests the word "Help", and sometimes that's even what
	it means to a program.

	An argument that has double-dashes, like '--help', is called a "long
	option".  I don't need to explain that one to you, do I?

	While many programs display a help message in response to either of
	these options, it isn't foolproof because it depends on that command
	being specially written to play along.  Each program gets to interpret
	its command line arguments as it sees fit.  Some programs do not
	recognize the '--help' long option at all.  Other programs do something
	else entirely when given '-h'.

	I know this is safe to try with the 'cat' program: try either
	  'cat -h'
	or
	  'cat --help'

	You don't need to give 'cat' both '-h' AND '--help'; just one option is
	enough.
	:
}

cat_help_test() {
	if [[ ${_CMD[0]} == cat ]]; then
		if   [[ "${#_CMD[@]}" -lt 2 ]]; then return $TOO_FEW_ARGS
		elif [[ "${#_CMD[@]}" -gt 2 ]]; then return $TOO_MANY_ARGS
		elif [[ ${_CMD[1]} = '--help' || ${_CMD[1]} = '-h' ]]; then return 0
		else return $WRONG_ARGS
		fi
	elif _tutr_lev "${_CMD[0]}" cat 2; then return $MISSPELD_CMD
	else return $WRONG_CMD
	fi
}

cat_help_hint() {
	_tutr_generic_hint $1 cat
	cat <<-:

	Another way to learn about commands is to run them with the '--help' or
	'-h' arguments.  Try this with the 'cat' program: run
	  'cat --help'
	or
	  'cat -h'
	:
}

cat_help_epilogue() {
	_tutr_pressanykey
	case $_RES in
		0)
			cat <<-:
			That worked like a charm!

			:
			;;
		*)
			cat <<-':'
			So what if 'cat' didn't like the option you gave it?
			At least it told you what you could try next time!

			:
			;;
	esac
	cat <<-':'
	You've got to be a little careful when blindly giving random short
	options to programs.  To you '-h' might signify "HELP!", but some
	programs may interpret '-h' to mean "Erase the HARD drive, drain the
	battery and shutdown the system".

	The '--help' long option is probably safer to try since it's name is not
	ambiguous.  Though it only takes one maniac to ruin things for everyone.

	For the sake of computer users everywhere it is a good idea for your own
	programs to print a helpful message in response to the '--help' long
	option AND the '-h' short option.

	Soon I'll show you a much safer way to get help than handing out random
	command-line options to every command you encounter.
	:
	_tutr_pressanykey
}



# TODO: what if 'cd' is an alias or function in their shell?
cd_help_prologue() {
	cat <<-:
	Because 'cd' is a built-in command the presence or absence of a '--help'
	option depends on which shell you're running.

	:

	if [[ $_SH = 'Zsh' ]]; then
		cat <<- :
		Since you're running Zsh, your 'cd' command doesn't respect the
		'--help' option.  It interprets '--help' as the name of a directory.

		It doesn't hurt to try, though.
		:
	elif (( ${BASH_VERSINFO} >= 5 )); then
		cat <<- :
		You are using a recent version of Bash.  Your 'cd' command responds to
		the '--help' option by displaying a comprehensive usage message.

		Check it out!
		:
	else
		cat <<- :
		Since you're running an older version of Bash, your built-in 'cd'
		command does not respect the '--help' option.  Nevertheless, it will
		print a brief usage message anyway.

		Give it a try!
		:
	fi

	cat <<-:

	Run 'cd --help' to see what this looks like in your shell.
	:
}

cd_help_test() {
	_tutr_generic_test -f -c cd -a --help
}

cd_help_hint() {
	_tutr_generic_hint $1 cd

	cat <<-:

	Try running 'cd --help' to see what this looks like in your shell.
	:
}

cd_help_epilogue() {
	_tutr_pressanykey
}



man_ls_prologue() {
	cat <<-:
	Commands supporting the '--help' flag are a nice convenience, but what
	do you do when that option is not available (or you don't dare to try it
	on a whim)?

	You're probably thinking "Google it"!  That *can* work, but consider:

	*   There are many different versions of shells and commands out there.
	    How can you be sure the article you found on the web applies to the
	    version on your computer right now?
	*   The command shell long predates the world-wide-web, and more so
	    Google.  How did people get help before the internet?
	*   What would you do if the WiFi were down?  Give up and call it a day?

	The official way to get help on Unix systems is through the system
	manual accessed through the 'man' command.  'man' takes as an argument
	the name of another command.  If that command is installed on your
	computer its instructions are displayed in a text reader.

	* Press 'q' to exit the text reader.
	* Press 'j' or 'Down Arrow' to scroll down by one line.
	* Press 'k' or 'Up Arrow' to scroll up by one line.
	* Press 'spacebar' to scroll down by one page.

	Run 'man ls' now.
	:
}

man_ls_test() {
	_tutr_generic_test -c man -a ls
}

man_ls_hint() {
	_tutr_generic_hint $1 man

	cat <<-:
	Run 'man ls' now.

	* Press 'q' to exit the text reader.
	* Press 'j' or 'Down Arrow' to scroll down by one line.
	* Press 'k' or 'Up Arrow' to scroll up by one line.
	* Press 'spacebar' to scroll down by one page.
	:
}

man_ls_epilogue() {
	cat <<-:
	Besides being accessible even when the internet is down, the biggest
	advantage of "man pages" is that they EXACTLY match the software on
	your computer right now.

	You must ALWAYS be aware of version mismatches when looking for help
	online.  It is way too easy to find obsolete or inaccurate information
	online.  Mac users will find that Linux-specific webpages give advice
	that doesn't work on your computer, and vice versa.

	:
	_tutr_pressanykey
}

man_cat_prologue() {
	cat <<-:
	Open the manual for the 'cat' program.

	As a reminder, these are the shortcut keys for the man page viewer:

	* Press 'q' to exit the text reader.
	* Press 'j' or 'Down Arrow' to scroll down by one line.
	* Press 'k' or 'Up Arrow' to scroll up by one line.
	* Press 'spacebar' to scroll down by one page.
	:
}

man_cat_test() {
	_tutr_generic_test -c man -a cat
}

man_cat_hint() {
	_tutr_generic_hint $1 man
	man_cat_prologue
}

man_cat_epilogue() {
	cat <<-:
	Who knew that a simple program such as 'cat' could have so many options?

	http://gaul.org/files/cat_-v_considered_harmful.html

	:
	_tutr_pressanykey
}


man_cd_prologue() {
	cat <<-:
	Is there a manual page for the builtin command 'cd'?

	There's only one way to find out!
	:
}

man_cd_test() {
	_tutr_generic_test -c man -a cd -i
}

man_cd_hint() {
	_tutr_generic_hint $1 man

	cat <<-:

	Run 'man cd'
	:
}

man_cd_epilogue() {
	case $_RES in
		0)
			cat <<-:
			It is likely that 'man cd' brought up a manual page titled
			BASH_BUILTINS.  On many systems the Bash shell registers this man page
			in the name of each of its built-in commands.

			You can also find this man page by running
			  'man builtins'

			:

			if [[ $_SH = Zsh ]]; then
				cat <<-:
				Sorry Zsh user, but that's not terribly helpful to you.  The man page
				you are looking for is called 'zshbuiltins':

				  'man zshbuiltins'

				:
			fi
			;;
		*)
			cat <<-:
			That's okay.  $_SH's built-in commands don't each have their own man 
			page, but are instead documented together in one man page accessed as
			:
			if [[ $_SH = Zsh ]]; then
				echo "  'man zshbuiltins'"
			else
				echo "  'man builtins' or 'man bash_builtins'"
			fi
			;;
	esac

	_tutr_pressanykey
}


man_man_prologue() {
	cat <<-:
	The manual is great when you already know the name of the command you
	need help with.  But what can you do when you don't know what you are
	looking for?

	What you need is a way to quickly search ALL of the manual pages.

	The 'man' command itself has a manual page.  Read it and look for a
	SHORT OPTION that is equivalent to "apropos" (whatever THAT is... looks
	pretty Frenchy to me).

	Recall that a SHORT OPTION is a dash '-' followed by another character.

	Be prepared to scroll down a few screens.
	:
}

man_man_test() {
	_tutr_generic_test -c man -a man
}

man_man_hint() {
	_tutr_generic_hint $1 man

	cat <<-:

	Now I want you to read the manual page for the 'man' command itself and
	look for a particular option to use in the next step of this tutorial.  
	This means that you want to run
	  'man man'

	The option you are looking for is equivalent to the 'apropos' command.

	As a reminder, these are the shortcut keys for the man page viewer:

	* Press 'q' to exit the text reader.
	* Press 'j' or 'Down Arrow' to scroll down by one line.
	* Press 'k' or 'Up Arrow' to scroll up by one line.
	* Press 'spacebar' to scroll down by one page.
	:
}

man_man_epilogue() {
	cat <<-:
	You think you found the right short option, don't you?

	We'll see.

	:
	_tutr_pressanykey
}


man_k_prologue() {
	cat <<-:
	Your goal is to cause 'man' to perform a keyword search over the library
	of manual pages to match the keyword 'manual'.

	Run 'man' with the short option you just discovered.  The command you
	will run will look something like this:
	  man -X manual
	where 'X' is replaced by the letter that represents the keyword search
	option you found in the last step.
	:
}

man_k_test() {
	[[ ${_CMD[@]} = 'man -k printf' ]] && return 99
	[[ ${_CMD[@]} = 'man -f smail' ]]  && return 98
	_tutr_generic_test -c man -a -k -a manual
}

man_k_hint() {

	case $1 in
		99)
			cat <<-:
			So close!  You even found the right part of the manual!

			What you just ran,
			  ${_CMD[@]}
			is given as an example of 'man's keyword search feature (get it?
			'-k' is for "keyword").

			Try that again, but use 'manual' as the keyword instead of
			'${_CMD[2]}'
			:
			;;
		*)
			_tutr_generic_hint $1 man
			echo
			man_k_prologue
			cat <<-:

			You might to go back into the 'man' command's manual and look again.
			The option you are looking for is equivalent to another command named
			with for the French word "apropos".
			:
			;;
	esac

}

man_k_epilogue() {
	_tutr_pressanykey
	cat <<-:

	The 'man -k' command (or the equivalent 'apropos' command if you're
	feeling fancy) is a quick replacement for Google when you don't quite
	know which command you are looking for.

	As I said before, one big advantage man pages have over Google is that
	'man -k' KNOWS which commands are are installed on this very computer.
	That's something that even Google doesn't know (probably).

	:
	_tutr_pressanykey
}

source _tutr/main.sh && _tutr_begin \
	which_ls \
	which_cat \
	which_which \
	echo_path \
	which_cd \
	type_cd \
	type_ls \
	type_cat \
	cat_help \
	cd_help \
	man_ls \
	man_cat \
	man_cd \
	man_man \
	man_k

# vim: set filetype=sh noexpandtab tabstop=4 shiftwidth=4 textwidth=76 colorcolumn=76:
