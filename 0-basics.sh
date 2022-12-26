#!/bin/sh

# Lesson #0
#
# * How to execute commands
# * What command arguments are
# * How the shell and the terminal are related
# * How to clear and reset the terminal
# * Cancelling a command
# * Reading and understanding error messages

_HELP="
Lesson #0 Topics
================
* Using a Unix command line interface
* Commands and arguments
* Hidden files
* The difference between the 'shell' and the 'terminal'
* How to clear and reset the terminal
* Cancelling a runaway command
* Understanding messages and recovering from errors

Commands used in this lesson
============================
* tutor
* echo
* ls
* ls -a
* cat
* clear
* reset
"

source _tutr/record.sh
if [[ -n $_TUTR ]]; then
	source _tutr/lev.sh
	source _tutr/generic_error.sh
	source _tutr/nonce.sh
fi

setup() {
	if _tutr_record_exists ${_TUTR#./}; then
		_tutr_warn printf "'You have already completed this lesson'"
		if ! _tutr_yesno "Would you like to do it again?"; then
			_tutr_info printf "'SEE YOU SPACE COWBOY...'"
			exit 1
		fi
	fi
	$SHELL _tutr/screen_size.sh 80 30
	export _HERE=$PWD
	export _BASE=$PWD/lesson0
	[[ -d "$_BASE" ]] && rm -rf "$_BASE"
	mkdir -p "$_BASE"
	cat <<-TEXT > "$_BASE/textfile.txt"
	 _   _      _ _         __        __         _     _ _
	| | | | ___| | | ___    \\ \\      / /__  _ __| | __| | |
	| |_| |/ _ \\ | |/ _ \\    \\ \\ /\\ / / _ \\| '__| |/ _\` | |
	|  _  |  __/ | | (_) |    \\ V  V / (_) | |  | | (_| |_|
	|_| |_|\\___|_|_|\\___( )    \\_/\\_/ \\___/|_|  |_|\\__,_(_)
	                    |/

	Welcome to the CS1440 command shell tutorial!

	It is my hope that this tutorial series helps you to quickly become
	comfortable in the Unix command line environment.
	TEXT

	cat <<-TEXT > "$_BASE/markdown.md"
	# This is a Markdown file

	This is a text file written in the **Markdown** format.

	Markdown is a text-to-HTML conversion tool for web writers. Markdown allows
	you to write using an easy-to-read, easy-to-write plain text format, then
	convert it to structurally valid XHTML (or HTML).

	Markdown was created by John Gruber and is documented on his website
	[Daring Fireball](https://daringfireball.net/projects/markdown/).

	TEXT

	cat <<-TEXT > "$_BASE/.hidden"
	I am a hidden file.

	But I'm not meant to be a secret.

	Because my name begins with a dot '.' programs such as 'ls' do not list me
	by default.  The fact this dot in my name hides me is actually due to a bug
	in the code for 'ls' dating back to the earliest version of Unix.

	Unix users have come to rely on this bug to tidy up the appearance of their
	home directories.  Instead of always displaying the countless configuration
	files on your computer 'ls' helpfully hides them from view.  Today these
	unobtrusive configuration files are known as 'dotfiles'.

	This is an example of a "bug" becoming a feature.  So you shouldn't feel
	bad when you make a mistake; it's just an unrequested feature!

	https://linux-audit.com/linux-history-how-dot-files-became-hidden-files/

	TEXT

	cat <<-TEXT > "$_BASE/corrupt_terminal"
	Using 'cat' on this file will garble your screen.  Use with caution.
	Set reverse video mode [?5h
	DEC screen alignment test - fills screen with E's #8

	Pretty wild, huh?

	You can still run commands when the terminal is in this state.
	You just can't read the output.

	Try running 'ls', 'echo hello world', and 'cat textfile.txt'.

	Use 'reset' to restore your terminal when you're done. (0

	TEXT


	cat <<-TEXT > "$_BASE/permission_denied"
	You should not be able to read this message.

	You do not have permission to access this file.

	TEXT

	case $(uname -s) in
		*MINGW*)
			icacls "$_BASE/permission_denied" //deny "$USERNAME:(d)"
			;;
		*)
			chmod -r "$_BASE/permission_denied"
			;;
	esac
	return 0
}

prologue() {
	clear
	echo
	cat <<-PROLOGUE
		Shell Lesson #0: Unix Shell Basics

		In this lesson you will learn about

		* Using a Unix command line interface
		* Commands and arguments
		* The difference between the "shell" and the "terminal"
		* How to clear and reset the terminal
		* Cancelling a runaway command
		* Understanding messages and recovering from errors

		Let's get started!

	PROLOGUE

	_tutr_pressanykey
}


cleanup() {
	# Remember that this lesson has been completed
	(( $# >= 1 && $1 == $_COMPLETE)) && _tutr_record_completion ${_TUTR#./}
	[[ -d "$_BASE" ]] && rm -rf "$_BASE"
	echo "You worked on Lesson #0 for $(_tutr_pretty_time)"
}



epilogue() {
	cat <<-EPILOGUE
	Here we are at the end of your zeroth lesson.  I'm very proud of you!

	In this lesson you learned about:

	* Using a Unix command line interface
	* Commands and arguments
	* The difference between the "shell" and the "terminal"
	* How to clear and reset the terminal
	* Cancelling a runaway command
	* Understanding messages and recovering from errors

	This concludes Shell Lesson #0

	Run './1-shortcuts.sh' to enter the next lesson

	EPILOGUE

	_tutr_pressanykey
}


# -1. Introduce the 'tutor' command
tutor_hint_prologue() {
	local PLUS=$'\x1b[1;32m+\x1b[0m'
	cat <<-:
	Before we begin you should know how this thing works.

	I'll tell you to do things and you'll do your best to do them.  There
	are ${#_SKILLS[@]} things to do in this lesson.  As you do things the
	little meter down by your prompt turns from red to green.  After you
	have done enough things you'll win, which improves your self-esteem.

	You do things in the shell by running commands.  When I show you a
	command I'll put it in single quote marks, like this:
	  'tutor hint'

	When you run that command you'll copy the text INSIDE the quotes.
	DO NOT copy the quotes surrounding the command.  Got that?

	Now, if you ever find yourself in a situation where you don't know what
	thing to do, you can always use the 'tutor hint' command.

	Why don't you try it right now?  Run 'tutor hint' to earn your first $PLUS.
	:
}

tutor_hint_test() {
	_tutr_generic_test -c tutor -a hint
}

tutor_hint_hint() {
	_tutr_generic_hint $1 tutor

	echo
	echo "The command will look like this (without the quote marks)"
	echo "  'tutor hint'"
}

tutor_hint_epilogue() {
	cat <<-:
	Deja vu always creeps me out OwO

	:

	_tutr_pressanykey
	cat <<-:

	'tutor hint' displays your marching orders again.
	This will come in handy.

	:
	_tutr_pressanykey
}


# Introduce the 'tutor bug' command
tutor_bug_prologue() {
	cat <<-:
	One of the things that you will learn this semester is that it is very
	difficult to write good, correct code.  My programs are no exception.

	I don't want to alarm you, but it is quite likely that you will uncover
	a bug in this program.  It could be a crash, a glitch, or even a
	"mis-speld" word in the text.

	When that happens to you, DON'T PANIC!  Keep a level head to help me
	out.  Just remember to run this command:
	  'tutor bug'

	I want you to try this now.  The message you are about to see will
	apologize for a bug and ask you to send me an email.  THIS IS NOT A BUG!
	Please don't send me an email now!  This is just a dry-run.
	:
}

tutor_bug_test() {
	_tutr_generic_test -c tutor -a bug
}

tutor_bug_hint() {
	if [[ $1 == $MISSPELD_CMD ]]; then
		_tutr_generic_hint $1 tutor
	fi

	echo "Try again"
	echo "The command will look like this (without the quote marks)"
	echo "  'tutor bug'"
}

tutor_bug_epilogue() {
	_tutr_pressanykey

	cat <<-:

	When a REAL problem occurs I want you to run 'tutor bug', then scroll up
	and copy the text leading up to the problem all the way down through
	'tutor bug's output.  You really can't copy too much text!

	By the way, you can quit this tutorial at any time by running 'exit' or
	'tutor quit'.  But the only way to win is to stick with it to the end.

	Now you're REALLY ready to begin!

	:
	_tutr_pressanykey
}



hello_world_pre() {
	if [[ -n $ZSH_NAME ]]; then
		export _SH=Zsh
	else
		export _SH=Bash
	fi
}

# 0.  echo hello world
hello_world_prologue() {
	cat <<-:
	The Unix command shell lets you talk to the computer with a simple
	programming language.  Unlike other programming languages you have used,
	this language is primarily meant for INTERACTIVE use instead of being
	written down in programs.  Concessions were made so that it is quick and
	easy to type:

	* Commands have short names
	* Less punctuation is needed than in other languages

	Begin by saying "Hello World" the command-line way.  In Python you would
	write
	  'print("Hello, World")'

	But in the shell it looks like this:
	  'echo Hello, World'

	Notice that the arguments "Hello," and "World" don't get their own quote
	marks in this command.  Each word is an argument on its own.

	Run this command now.
	:
}

hello_world_test() {
	_PREV1=${_CMD[1]}
	_PREV2=${_CMD[2]}
	[[ $( echo "${_CMD[@]}" | tr A-Z a-z | tr -d ,) == "echo hello world" ]] && return 0
	_tutr_lev "${_CMD[0]}" "echo" 2 && return $MISSPELD_CMD
	[[ $_SH = Zsh && ${_CMD[0]} = print ]] && return 99
	[[ ${_CMD[0]} != echo ]] && return $WRONG_CMD
	[[ ${#_CMD[@]} -lt 3 ]] && return $TOO_FEW_ARGS
	[[ ${#_CMD[@]} -gt 3 ]] && return $TOO_MANY_ARGS
	return $WRONG_ARGS
}



hello_world_hint() {
	case $1 in
		99)
			cat <<-:
			Because you're using the 'Zsh' Unix shell you actually have a
			command called 'print' that is essentially the same thing as
			'echo'.

			Because most students use the 'Bash' Unix shell I choose to use
			'echo' for consistency's sake.

			:
			;;
		*)
			_tutr_generic_hint $1 echo "$_BASE"
			;;
	esac

	cat <<-:

	Run 'echo Hello, World' (but don't enter the single quotes!)
	:
}

hello_world_epilogue() {
	_tutr_pressanykey
	echo
	if [[ "echo Hello, World" != ${_CMD[@]} ]]; then
		cat <<-:
		Eh, "${_CMD[@]}" is close enough for now...

		In the shell, as with Python, details like case and punctuation do
		matter.  Try to be diligent at following instructions exactly!

		:
		_tutr_pressanykey
		echo
	fi

	cat <<-:
	Shell commands, like functions in Python, can take arguments.  The
	strings "$_PREV1" and "$_PREV2" were arguments to your 'echo' command.

	Shell commands follow this syntax:
	    command [argument...]

	The square brackets surrounding 'argument...' in the example indicate
	an optional portion.  The ellipsis (...) means that there may be more
	arguments beyond the first one.  All together, this example reads
	"'command' takes zero or more arguments".

	Unlike Python and Java, parentheses do not surround the argument list in
	the shell.  Spaces separate arguments from each other instead of commas.
	It does NOT matter how many spaces you use.  One, two or twenty - it's
	all the same.

	In the shell EVERYTHING you type is regarded as a string.  This is why
	you didn't need to put quote marks around the words "$_PREV1" and "$_PREV2".

	The comma following "Hello," in the command
	  'echo Hello, World'
	isn't special; it actually becomes part of the word "Hello,".

	Now, there will be cases where quote marks are mandatory; this just
	isn't one of them.  Of course, you can use quotes if you really want:
	  'echo "Hello, World"'

	:

	_tutr_pressanykey
}



# 1.  echo without args
echo_no_args_prologue() {
	cat <<-:
	One part of learning Python is learning which FUNCTIONS you can use and
	which arguments to use when you call them.

	The Unix shell is similar; you must learn which COMMANDS exist and how
	to call them.

	'echo' is the shell's equivalent to Python's 'print()' function.  Just
	like 'print()', 'echo' takes any number of arguments.  Zero, one, two,
	a hundred; it's all good.

	The 'echo' command has this syntax:
	  echo [WORD...]

	This means that 'echo' can take zero or more WORDs as arguments.

	Run 'echo' again, but with zero arguments this time.
	:
}

echo_no_args_test() {
	_tutr_generic_test -c echo
}


echo_no_args_hint() {
	_tutr_generic_hint $1 echo "$_BASE"

	cat <<-:

	Simply run 'echo' with no arguments to see what happens.
	:
}

echo_no_args_epilogue() {
	_tutr_pressanykey
	cat <<-:

	Just like 'print()', running 'echo' with an empty argument list results
	in a newline being printed to the screen.

	Arguments typed into the shell are passed into the command as a LIST of
	STRINGS.  It is up to each command to decide how many arguments it
	needs, what order they should appear, as well as their meanings.

	Some commands, like 'echo', are happy with ANY number of arguments.

	Other commands are particular about the number of arguments, what order
	they're given, and even how they are spelled.  Such commands usually
	display a helpful error message when given invalid input.

	In a future lesson you will learn how to find the instruction manual for
	each command.  This will help you learn what commands exist and what
	they expect from you.

	:
	_tutr_pressanykey
}


# 2.  ls # show files in cwd
ls_prologue() {
	cat <<-:
	The 'ls' command lists files.

	Run 'ls' to see what files are here.
	:
}

ls_test() {
	[[ $PWD != "$_BASE" ]] && return $WRONG_PWD
	[[ ( ${_CMD[0]} == ls || ${_CMD[0]} == dir ) && ${#_CMD[@]} -ne 1 ]] && return $TOO_MANY_ARGS
	[[ ${_CMD[@]} == ls ||  ${_CMD[@]} == dir ]] && return 0
	_tutr_lev "${_CMD[0]}" ls 1 && return $MISSPELD_CMD
	[[ ( ${_CMD[0]} != ls && ${_CMD[0]} != dir ) ]] && return $WRONG_CMD
}

ls_hint() {
	_tutr_generic_hint $1 ls "$_BASE"

	cat <<-:

	Run 'ls' with no arguments to list the files that are here
	:
}

ls_epilogue() {
	_tutr_pressanykey
	if [[ ${_CMD[@]} == dir ]]; then
		cat <<-:

		A Windows user, eh?

		Unix also has a command called 'dir', but it is not commonly used.
		One extra letter is too much for lazy Unix-folk to type.

		This tutorial will use 'ls' from now on.
		:
		_tutr_pressanykey
	fi
}


# 3.  cat textfile.txt
cat_textfile_prologue() {
	cat <<-:
	'ls' revealed that there are four files here.

	You can read files in the shell with the 'cat' command.  This name is
	short for "Concatenate".  This program is meant to join several files
	into one.  It takes as arguments names of files and prints their
	contents, one by one, onto the screen.

	Because it works just fine with only one file it has become the standard
	text viewer in Unix.

	One of the files here is called 'textfile.txt'.  Use 'cat' to print its
	contents to the screen by running 'cat' with the single argument
	'textfile.txt'.

	If you get stuck, just hit 'Ctrl-C' to cancel.
	:
}

cat_textfile_test() {
	[[ $PWD != "$_BASE" ]] && return $WRONG_PWD
	if [[ ${_CMD[0]} == cat ]]; then
		[[ ${#_CMD[@]} -eq 1 ]] && return $TOO_FEW_ARGS
		[[ ${#_CMD[@]} -gt 2 ]] && return $TOO_MANY_ARGS
		[[ ${_CMD[1]} == "textfile.txt" ]] && return 0
		return $WRONG_ARGS
	fi
	_tutr_nonce && return $PASS
	_tutr_lev "${_CMD[0]}" cat 2 && return $MISSPELD_CMD
	return $WRONG_CMD
}


cat_generic_hint() {
	case $1 in
		$TOO_FEW_ARGS)
			cat <<-:
			Well, that was weird!

			Because you didn't tell 'cat' which file to read, it started reading
			you!  If you typed anything and hit enter you saw your words echoed
			back to the screen.

			Remember that Ctrl-C (a.k.a. ^C) is your general purpose "get me
			out of this program" tool.  Use it any time a command gets "stuck".
			It usually works.
			:
			;;

		$TOO_MANY_ARGS)
			cat <<-:
			You've figured out how to concatenate many files.  Cool!
			This will actually come in handy later on in the course.

			But for now, I need you to only 'cat' the one file I asked for.
			Precision counts!
			:
			;;
		*)
			_tutr_generic_hint $1 cat "$_BASE"
			;;
	esac
}

cat_textfile_hint() {
	cat_generic_hint $1 "$_BASE"

	cat <<-:

	Use 'cat' to print the contents of 'textfile.txt' to the screen.
	If you get stuck, just hit 'Ctrl-C' to cancel.
	:
}

cat_textfile_epilogue() {
	_tutr_pressanykey
}


# 4.  cat markdown.md
cat_markdown_prologue() {
	cat <<-:
	Unix doesn't put much importance on file names like some operating
	systems.  A name ending in '.txt' does not a text document make; it's
	what's on the inside that counts.

	One kind of text file that you will use this semester is a Markdown
	file.  Markdown files usually have names ending in '.md'.  'cat' is a
	fine tool to display these files.

	Give the name of the Markdown file as an argument to 'cat'.

	You can use 'ls' to remind yourself what its exact name is.

	:
}

cat_markdown_test() {
	[[ $PWD != "$_BASE" ]] && return $WRONG_PWD
	if [[ ${_CMD[0]} == cat ]]; then
		[[ ${#_CMD[@]} -eq 1 ]] && return $TOO_FEW_ARGS
		[[ ${#_CMD[@]} -gt 2 ]] && return $TOO_MANY_ARGS
		[[ ${_CMD[1]} == "markdown.md" ]] && return 0
		return $WRONG_ARGS
	fi
	_tutr_nonce && return $PASS
	_tutr_lev "${_CMD[0]}" cat 2 && return $MISSPELD_CMD
	return $WRONG_CMD
}

cat_markdown_hint() {
	cat_generic_hint $1

	cat <<-:

	Use 'cat' to print the contents of 'markdown.md' to the screen.
	If you get stuck, just hit Ctrl-C to cancel.

	:
}

cat_markdown_epilogue() {
	_tutr_pressanykey
}


# 5.  clear
clear_prologue() {
	cat <<-:
	By now you've filled up your screen with lots of text.
	It's nice to get back to a fresh, blank slate.

	You can clear the screen with the cleverly-named 'clear' command.

	:
}

clear_test() {
	[[ ${_CMD[@]} == clear ]] && return 0
	[[ ${_CMD[0]} == clear && ${#_CMD[@]} -gt 1 ]] && return $TOO_MANY_ARGS
	_tutr_lev "${_CMD[0]}" clear 2 && return $MISSPELD_CMD
	return $WRONG_CMD
}

clear_hint() {
	_tutr_generic_hint $1 clear
}


# 6.  ls -a # show hidden files
ls_a_prologue() {
	cat <<-:
	I wasn't being completely honest with you when I said that there were
	four files here.  There is a stowaway hidden here.

	'ls' can take as an argument the option string '-a' that tells it to
	display ALL files.

	Run 'ls' with the '-a' option now.

	:
}

NEED_SPACES=99
NOT_WINDOWS=98
# TODO: on MacOS `ls --all` won't work
ls_a_test() {
	[[ ${_CMD[0]} =~ ^ls- ]] && return $NEED_SPACES
	[[ ${_CMD[0]} = dir ]] && return $NOT_WINDOWS
	_tutr_generic_test -c ls -a '^-a$|^--all$' -d "$_BASE"
}

ls_a_hint() {
	case $1 in
		$NEED_SPACES)
			cat <<-:
			Try adding a space between 'ls' and '-a'.

			:
			;;
		$NOT_WINDOWS)
			cat <<-:
			This isn't Windows.  Use 'ls' here.

			:
			;;
		*)
			_tutr_generic_hint $1 ls "$_BASE"
			;;
	esac

	cat <<-:
	Give the 'ls' command the '-a' option.

	:
}

ls_a_epilogue() {
	_tutr_pressanykey
}


# 7.  cat .hidden
cat_hidden_prologue()  {
	cat <<-:
	Do you see all of the files with names beginning with '.'?

	Their names look funny, but they are permissible filenames under Unix.

	Use 'cat' to read the file called '.hidden'.
	:
}

cat_hidden_test() {
	[[ $PWD != "$_BASE" ]] && return $WRONG_PWD
	if [[ ${_CMD[0]} == cat ]]; then
		[[ ${#_CMD[@]} -eq 1 ]] && return $TOO_FEW_ARGS
		[[ ${#_CMD[@]} -gt 2 ]] && return $TOO_MANY_ARGS
		[[ ${_CMD[1]} == ".hidden" ]] && return 0
		return $WRONG_ARGS
	fi
	_tutr_lev "${_CMD[0]}" cat 2 && return $MISSPELD_CMD
	return $WRONG_CMD

}

cat_hidden_hint() {
	cat_generic_hint $1 cat

	cat <<-:

	Use 'cat' to print the contents of '.hidden' to the screen.
	If you get stuck, just hit Ctrl-C to cancel.

	:
}

cat_hidden_epilogue() {
	_tutr_pressanykey
}


# 8.  reset # reset the display
reset_prologue() {
	cat <<-:
	So far you've seen how to put text onto the screen and clear it off
	again.

	*	'echo' prints its arguments
	*	'ls' prints a listing of files
	*	'cat' prints the contents of files
	*	'clear' erases everything on the screen

	Now you'll leave the happy path and learn what happens when things go
	wrong.

	In Unix you can use 'cat' on ANY kind of file you want.  Nothing stops
	you from cat-ing an MP3, a ZIP file, a PDF or a JPEG to the screen.  It
	is fun and you may learn something about those files that you wouldn't
	otherwise see.

	However, there is a possibility that doing this will make your terminal
	go haywire.  Don't worry, the effect is not permanent, nor can it hurt
	your computer.  It is something that can happen at any time when you're
	working with data.  Before you try it I want to show you how to fix a
	corrupted terminal.

	Run the 'reset' command.  Don't worry, this command doesn't reboot your
	computer!  It just tells the terminal to re-initialize itself so you can
	read it again.  You'll see what I mean in a moment.
	:
}

reset_test() {
	[[ ${_CMD[@]} == reset ]] && return 0
	[[ ${_CMD[0]} == reset && ${#_CMD[@]} -gt 1 ]] && return $TOO_MANY_ARGS
	_tutr_lev "${_CMD[0]}" reset 2 && return $MISSPELD_CMD
	return $WRONG_CMD
}

reset_hint() {
	_tutr_generic_hint $1 reset
}


# 9.  cat corrupt_terminal
cat_corrupt_prologue() {
	cat <<-:
	'reset' seems like a slower version of 'clear'.  What good is it?

	Here is a file called 'corrupt_terminal'.  When you display it with
	'cat' binary data is sent to the terminal where it is misinterpreted,
	resulting in unreadable, garbled text.

	You can, however, still run commands.  The results will look like
	gibberish, but will work.  This is because the shell and the terminal
	are two separate programs:

	* Terminal: Reads the keyboard and displays what the shell instructs it
	* Shell: Accepts and runs your commands

	The shell is unfazed by the terminal's confusion and is still able to
	read and execute your commands.  After this happens, try running 'echo',
	'ls' and 'clear'.

	When you're done, run 'reset' to restore the terminal to working order.

	Are you ready to 'cat corrupt_terminal'?
	:
}

cat_corrupt_test() {
	[[ $PWD != "$_BASE" ]] && return $WRONG_PWD
	if [[ ${_CMD[0]} == cat ]]; then
		[[ ${#_CMD[@]} -eq 1 ]] && return $TOO_FEW_ARGS
		[[ ${#_CMD[@]} -gt 2 ]] && return $TOO_MANY_ARGS
		[[ ${_CMD[1]} == "corrupt_terminal" ]] && return 0
		return $WRONG_ARGS
	fi
	_tutr_nonce && return $PASS
	_tutr_lev "${_CMD[0]}" cat 2 && return $MISSPELD_CMD
	return $WRONG_CMD
}

cat_corrupt_hint() {
	case $1 in
		$WRONG_CMD)
			cat <<-:
			Oh, don't be scared!
			Trust me, you'll be fine!

			:
			;;
		*)
			cat_generic_hint $1
			;;
	esac

	cat <<-:

	Use 'cat' to print the contents of 'corrupt_terminal' to the screen.
	If you get stuck, just hit Ctrl-C to cancel.
	Run 'reset' after you're done to clean up the mess

	:
}


# 10. reset the display again
reset_again_test() {
	[[ ${_CMD[@]} == reset ]] && return 0
}



# 11. cat w/o arguments # use Ctrl-C to break out
plain_cat_prologue() {
	cat <<-:
	Most Unix newcomers think they must close and restart their terminal
	when that happens to them.  That's a lot of hassle when relief is just
	six keystrokes away!

	It's important to feel in control of the computer and know that you can
	handle any situation thrown your way.  Programs often freeze and need to
	be forcibly stopped.  While you COULD close the window on a frozen
	program, it is a drastic response to a simple problem.

	Here is a better way: press 'Ctrl-C' to CANCEL the frozen program and
	regain control of the shell.

	Did you know that you can get 'cat' stuck simply by running it with zero
	arguments?

	Run 'cat' this way and stop it with 'Ctrl-C'.
	:

}

plain_cat_test() {
	[[ ${_CMD[@]} == cat ]] && return 0
	[[ ${_CMD[0]} == cat && ${#_CMD[@]} -gt 1 ]] && return $TOO_MANY_ARGS
	_tutr_lev "${_CMD[0]}" cat 2 && return $MISSPELD_CMD
	return $WRONG_CMD
}

plain_cat_hint() {
	_tutr_generic_hint $1 cat

	cat <<-:

	Run 'cat' with no arguments, then stop it with 'Ctrl-C'.
	:
}

plain_cat_epilogue() {
	cat <<-:
	That's the way!

	You may be wondering why Ctrl-C doesn't mean "Copy" in the shell.

	'Ctrl-C' as "Cancel" predates the familiar "Undo", "Cut", "Copy",
	"Paste" shortcuts by a good decade or so.  None of the shortcuts that
	you have used in other applications do what you expect at the terminal.
	You'll just have to retrain your fingers.

	The next lesson will teach you new shortcuts you can use here.

	:
	_tutr_pressanykey
}

# 12. cat not_a_file
cat_nofile_prologue() {
	cat <<-:
	Another common mistake new programmers make is to not pay attention to
	what the computer is telling them.  The command line interface is a
	conversation with your computer.  Communication goes both ways.

	Get in the habit of carefully reading all messages presented to you.
	You'll save countless hours of frustration when the answer is right in
	front of your nose.

	One of the most common errors that your computer gives is "No such file
	or directory".  You'll be seeing this one a lot, so let's get it over
	with.

	Run 'cat' with an argument that is NOT the name of any file here.
	Use 'ls' to remind yourself which files are here.
	:
}

cat_nofile_test() {
	if [[ ${_CMD[0]} == cat ]]; then
		[[ ${#_CMD[@]} -eq 1 ]] && return $TOO_FEW_ARGS
		[[ ${_CMD[1]:0:1} == - ]] && return $WRONG_ARGS
		[[ ! -f ${_CMD[1]} ]] && return 0
		return 99
	fi
	_tutr_lev "${_CMD[0]}" cat 2 && return $MISSPELD_CMD
	_tutr_nonce && return $PASS
	return $WRONG_CMD
}

cat_nofile_hint() {
	case $1 in
		99)
			cat <<-:
			For this one you need to try to 'cat' a file that DOESN'T exist here.
			"George" is the name of a file that doesn't exist here.

			Try cat-ing "George".
			:
			;;
		$WRONG_ARGS)
			cat <<-:
			While ${_CMD[1]} technically isn't the name of a file here, many
			shell commands regard arguments beginning with one or more '-' as
			OPTIONS instead of FILES.

			They're treated as a class of their own.
			:
			;;
		*)
			cat_generic_hint $1
			;;
	esac

	cat <<-:

	Run 'cat' with an argument that is NOT the name of a file.
	:
}

cat_nofile_epilogue() {
	_tutr_pressanykey
	echo
	echo "See, that wasn't so bad, was it?"
	echo
	_tutr_pressanykey
}


# 13. cat permission_denied
cat_permission_denied_prologue() {
	cat <<-:
	Another common error is "Permission denied".  I have prepared a file
	named 'permission_denied' that will cause that error when you try to
	read it with 'cat'.

	Why don't you give it a try?
	:
}

cat_permission_denied_test() {
	[[ $PWD != "$_BASE" ]] && return $WRONG_PWD
	if [[ ${_CMD[0]} == cat ]]; then
		[[ ${#_CMD[@]} -eq 1 ]] && return $TOO_FEW_ARGS
		[[ ${#_CMD[@]} -gt 2 ]] && return $TOO_MANY_ARGS
		[[ ${_CMD[1]} == "permission_denied" ]] && return 0
		return $WRONG_ARGS
	fi
	_tutr_lev "${_CMD[0]}" cat 2 && return $MISSPELD_CMD
	_tutr_nonce && return $PASS
	return $WRONG_CMD
}

cat_permission_denied_hint() {
	cat_generic_hint $1

	cat <<-:

	Try to read the file 'permission_denied' with the 'cat' tool.
	:
}

cat_permission_denied_epilogue() {
	_tutr_pressanykey
	echo

	if [[ $_RES -eq 0 ]]; then
		cat <<-:
		Huh, that actually worked on your computer?

		Rest assured that I'm just as disappointed about this as you are.

		:
	else
		cat <<-:
		Don't worry, you aren't missing anything.
		That file isn't as interesting as the others.

		:
	fi

	_tutr_pressanykey
}


command_not_found_prologue() {
	cat <<-:
	The last common error you will encounter is "command not found".
	Sometimes this occurs because you don't have a program installed.  Other
	times the program IS installed, but the shell cannot find it.

	If you're like me you make LOTS of typing mistakes.  This is the source
	of 99% of my own "command not found" errors.  You'll see me misspell
	'python' as 'pyhton' in nearly every lecture.

	Better start getting used to it.  Try running 'pyhton' (or some other
	misspelled command of your own creation) and see what the shell has to
	say about it.
	:
}

command_not_found_test() {
	if   _tutr_nonce; then return $PASS
	elif (( _RES == 0 )); then return $WRONG_CMD
	elif (( _RES == 127 )); then return 0
	else return 99
	fi
}

command_not_found_hint() {
	case $1 in
		$WRONG_CMD)
			cat <<-:
			'${_CMD[0]}' was a valid command.

			C'mon, you can screw up better than that!
			:
			;;
		*)
			_tutr_generic_hint $1 pyhton
			;;
	esac

	cat <<-:

	Try running 'pyhton' (or some other misspelled command of your own
	creation) to see how the shell responds.
	:
}

command_not_found_epilogue() {
	_tutr_pressanykey
	cat <<-:

	That's the way!

	See, nothing terrible happened.  You're gonna be okay.

	:
	_tutr_pressanykey
}


source _tutr/main.sh && _tutr_begin \
	tutor_hint \
	tutor_bug \
	hello_world \
	echo_no_args \
	ls \
	cat_textfile \
	cat_markdown \
	clear \
	ls_a \
	cat_hidden \
	reset \
	cat_corrupt \
	reset_again \
	plain_cat \
	cat_nofile \
	cat_permission_denied \
	command_not_found

# vim: set filetype=sh noexpandtab tabstop=4 shiftwidth=4 textwidth=76 colorcolumn=76:
