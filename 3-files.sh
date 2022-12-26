#!/bin/sh

_HELP="
Lesson #3 Topics
================
* Make copies of files
* Move and rename files
* Remove files
* Refer to many files at once

Commands used in this lesson
============================
* cp
* mv
* rm
"

source _tutr/record.sh
if [[ -n $_TUTR ]]; then
	source _tutr/generic_error.sh
	source _tutr/nonce.sh
fi

create_copy0_txt() {
	cat <<-TEXT > "$_BASE/copy0.txt"
	Use the copy command 'cp' to make two copies of this file.
	When you're done you will have three files:
	* copy0.txt
	* copy1.txt
	* copy2.txt
	TEXT
}

create_move0_txt() {
	cat <<-TEXT > "$_BASE/move0.txt"
	Use the move command 'mv' to rename this file.
	When you're done you will only have this one file, but it won't be
	named move0.txt anymore.
	TEXT
}

create_different_txt() {
	cat <<-TEXT > "$_BASE/different.txt"
	This file is not like the others!
	TEXT
}

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
	export _BASE=$PWD/lesson3
	[[ -d $_BASE ]] && rm -rf "$_BASE"
	mkdir -p "$_BASE"

	create_copy0_txt
	create_move0_txt
	create_different_txt
}


prologue() {
	clear
	echo
	cat <<-PROLOGUE
	Shell Lesson #3: Manipulating Files

	In this lesson you will learn to

	* Copy files
	* Move and rename files
	* Remove files
	* Refer to multiple files with wildcards

	Let's get started!

	PROLOGUE

	_tutr_pressanykey
}


cleanup() {
	# Remember that this lesson has been completed
	(( $# >= 1 && $1 == $_COMPLETE)) && _tutr_record_completion ${_TUTR#./}
	[[ -d $_BASE ]] && rm -rf "$_BASE"
	echo "You worked on Lesson #3 for $(_tutr_pretty_time)"
}


epilogue() {
	cat <<-EPILOGUE
	That wraps things up for now.  Before long the people looking over your
	shoulder will ask what you're hacking into and when the FBI will get
	here.  On that day you will be a true shell user.

	In this lesson you learned how to

	* Copy files
	* Move and rename files
	* Remove files
	* Refer to multiple files with wildcards

	This concludes Shell Lesson #3

	Run './4-directories.sh' to enter the next lesson

	EPILOGUE

	_tutr_pressanykey
}


# Case- and whitespace-insensitively compare a one line file with a specimen string
# Return 0 if the file contains only the specimen
# Return 1 otherwise
compare() {
	if (( $# < 2 )); then
		cat <<-:
		Usage:
		compare filename "string"
		:
		return 1
	fi

	eval 'tr A-Z a-z < $1 | tr -s "[[:blank:]]" | cmp - <(echo $2) >/dev/null 2>/dev/null'
}


copy01_prologue() {
	cat <<-:
	Do you remember when I told you that shell commands are short and easy
	to type?  I hope that you aren't too attached to vowels...

	The Unix file copy command is named 'cp'.  It makes a copy of a file
	SOURCE named DESTINATION:

	  cp SOURCE DESTINATION

	Example: to make a copy of a file "hello.txt" named "world.doc"
	  cp hello.txt world.doc

	There are a few files here; see for yourself with 'ls'.
	Use 'cp' to copy 'copy0.txt' to 'copy1.txt'
	:
}

copy01_test() {
	if   _tutr_nonce; then return $PASS
	elif [[ -f $_BASE/copy0.txt && -f $_BASE/copy1.txt ]]; then return 0
	elif [[ ! -f $_BASE/copy0.txt ]]; then return 99
	else _tutr_generic_test -c cp -a copy0.txt -a copy1.txt -d "$_BASE"
	fi
}

copy01_hint() {
	case $1 in
		99)
			create_copy0_txt

			cat <<-:
			What happened to 'copy0.txt'?
			No worries, I've replaced it for you.  Please try again.
			:
			;;
		*)
			_tutr_generic_hint $1 cp "$_BASE"
			;;
	esac

	cat <<-:

	Use 'cp' to make a copy of 'copy0.txt' called 'copy1.txt'.
	Your command should look like this:
	  cp copy0.txt copy1.txt
	:
}


copy02_prologue() {
	cat <<-:
	Use 'cp' again to make another copy of 'copy0.txt' called 'copy2.txt'.

	Recall the command-line shortcuts from the earlier lesson to save
	yourself some typing.
	:
}

copy02_test() {
	if   _tutr_nonce; then return $PASS
	elif [[ -f $_BASE/copy0.txt && -f $_BASE/copy2.txt ]]; then return 0
	elif [[ ! -f $_BASE/copy0.txt ]]; then return 99
	else _tutr_generic_test -c cp -a copy0.txt -a copy2.txt -d "$_BASE"
	fi
}

copy02_hint() {
	case $1 in
		99)
			create_copy0_txt

			cat <<-:
			What happened to 'copy0.txt'?
			Never mind, I've already replaced it for you.  Please try again.
			:
			;;
		*)
			_tutr_generic_hint $1 cp "$_BASE"
			;;
	esac

	cat <<-:

	Use 'cp' to make a copy of 'copy0.txt' called 'copy2.txt'.
	Your command should look like this:
	  cp copy0.txt copy2.txt
	:
}


list1_prologue() {
	cat <<-:
	Check out your work with the 'ls' command
	:
}

list1_test() {
	_tutr_generic_test -c ls -d "$_BASE"
}

list1_hint() {
	_tutr_generic_hint $1 ls "$_BASE"
}

list1_epilogue() {
	_tutr_pressanykey
	cat <<-:

	It's a good idea to frequently use 'ls' to make sure that your files are
	just as you expect.  Caution pays off as there is no 'undo' button in
	the shell.

	:
	_tutr_pressanykey
}


cp_clobber_pre() {
	[[ ! -f $_BASE/copy0.txt ]] && create_copy0_txt
}

cp_clobber_prologue() {
	cat <<-:
	To recap, you have made two copies of 'copy0.txt':
	*   'copy1.txt'
	*   'copy2.txt'
	All three files are identical.

	When you ran 'cp' there weren't already files named 'copy1.txt' and
	'copy2.txt'.  If those files had already existed they would have been
	overwritten, permanently losing their original contents.

	As a precaution the 'cp' command MAY prompt you for confirmation before
	overwriting a file.  Or, it might SILENTLY overwrite the destination
	file with the source.  It depends on how your shell is set up.

	You should know which way 'cp' behaves in your shell.

	Copy 'copy0.txt' onto 'different.txt' to find out if 'cp' stops and asks
	you to proceed.

	If 'cp' does ask for permission, just hit ENTER.
	:
}

cp_clobber_test() {
	_tutr_generic_test -c cp -a copy0.txt -a different.txt -d "$_BASE"
}

cp_clobber_hint() {
	_tutr_generic_hint $1 cp "$_BASE"

	cat <<-:
	Copy 'copy0.txt' onto 'different.txt' to see whether 'cp' stops and asks
	you to proceed.

	The command you need to run is
	  cp copy0.txt different.txt

	If 'cp' asks for permission, just hit ENTER.
	:
}

cp_clobber_epilogue() {
	_tutr_pressanykey

	cat <<-:

	That was enlightening!

	When 'cp' asks for confirmation you may respond in the affirmative with
	any string that begins with "Y" or "y".  Each of these strings are
	understood as affirmative responses:

	*   "YES"
	*   "yup"
	*   "yippee"
	*   "Yancy yearns for yesterday's yarrow yogurt"
	
	For the sake of brevity, you can just enter "y".

	Any other string (including ENTER by itself) is a negative response.

	Once a file is overwritten there is no EASY way to get it back.  In the
	last lesson of this tutorial I'll teach you about a program that can
	help with this, but caution is always the best policy.
	:
	_tutr_pressanykey
}


move01_prologue() {
	cat <<-:
	The Unix command to move files is named 'mv'.
	Its syntax is just like 'cp':

	  mv SOURCE DESTINATION

	Example: move a file "hello.txt" to "world.doc"
	  mv hello.txt world.doc

	After running 'mv' the SOURCE file no longer exists.

	Use 'mv' to move the file 'move0.txt' to 'move1.txt'.
	:
}

move01_test() {
	[[ ! -f $_BASE/move0.txt && -f $_BASE/move1.txt ]] && return 0
	[[ ! -f $_BASE/move0.txt ]] && return 99
	_tutr_generic_test -c mv -a move0.txt -a move1.txt -d "$_BASE"
}

move01_hint() {
	case $1 in
		99)
			create_move0_txt

			cat <<-:
			What happened to 'move0.txt'?
			No matter, I've replaced it for you.  Please try again.
			:
			;;
		*)
			_tutr_generic_hint $1 mv "$_BASE"
			;;
	esac

	cat <<-:

	Use 'mv' to move the file 'move0.txt' to 'move1.txt'.
	Your command should look like this:
	  mv move0.txt move1.txt
	:
}


move02_err_prologue() {
	cat <<-:
	Now use the move command to move the file 'move0.txt' to 'move2.txt'.
	:
}

move02_err_test() {
	_tutr_generic_test -f -c mv -a move0.txt -a move2.txt -d "$_BASE"
}

move02_err_hint() {
	_tutr_generic_hint $1 mv "$_BASE"

	cat <<-:

	Use 'mv' to move the file 'move0.txt' to 'move2.txt'.
	Your command should look like this:
	  mv move0.txt move2.txt
	:
}

move02_err_epilogue() {
	_tutr_pressanykey

	cat <<-:

	What happened here?

	You previously moved 'move0.txt' to the name 'move1.txt', so 'move0.txt'
	was not available to be moved to 'move2.txt'.

	Another way to think of this is to consider moving a file to be
	equivalent to COPYING a file and then REMOVING the original.

	Essentially, moving a file gives it a new name.  For this reason Unix
	does not have a dedicated command to rename files.  Renaming a file is
	the same thing as moving it to a new name.

	:
	_tutr_pressanykey
}



move12_prologue() {
	cat <<-:
	Let's try that again, but with a file that exists.

	Use the 'mv' command to rename 'move1.txt' to 'move2.txt'.
	:
}

move12_test() {
	_tutr_nonce && return $PASS
	[[ ! -f $_BASE/move1.txt && -f $_BASE/move2.txt ]] && return 0
	[[ ! -f $_BASE/move1.txt ]] && return 99
	_tutr_generic_test -c mv -a move1.txt -a move2.txt -d "$_BASE"
}

move12_hint() {
	case $1 in
		99)
			create_move0_txt
			mv $_BASE/move0.txt $_BASE/move1.txt 

			cat <<-:
			What happened to 'move1.txt'?
			It doesn't matter, I've replaced it for you.  Please try again.
			:
			;;

		*)
			_tutr_generic_hint $1 mv "$_BASE"
			;;
	esac

	cat <<-:

	Try running
	  mv move1.txt move2.txt
	:
}


mv_clobber_pre() {
	[[ ! -f $_BASE/different.txt ]] && create_different_txt
	if [[ ! -f $_BASE/move2.txt ]]; then
		create_move0_txt
		mv $_BASE/move0.txt $_BASE/move2.txt
	fi
}

mv_clobber_prologue() {
	cat <<-:
	By now you will have noticed that these commands don't output messages
	when they succeed.  As we say in Unix, no news is good news!

	But when a command does have something to say, you should pay attention.

	The move command also carries a risk of overwriting the destination
	file.  As with 'cp', 'mv' MAY stop and ask for confirmation before doing
	anything destructive.

	Find out what happens in your shell when you move the file 'move2.txt'
	onto 'different.txt'.
	:
}

mv_clobber_test() {
	_tutr_nonce && return $PASS
	[[ ! -f $_BASE/move2.txt && ! -f $_BASE/different.txt ]] && return 99
	_tutr_generic_test -c mv -a move2.txt -a different.txt -d "$_BASE"
}

mv_clobber_hint() {
	case $1 in
		99)
			mv_clobber_pre
			cat <<-:
			Huh, what happened to those files?
			Oh well, I've replaced them.  Do try again.
			:
			;;
		*)
			_tutr_generic_hint $1 mv "$_BASE"
			mv_clobber_pre
			;;
	esac

	cat <<-:

	Find out what happens on your computer when you overwrite the file
	'different.txt' with 'move2.txt':

	  mv move2.txt different.txt
	:
}

mv_clobber_epilogue() {
	cat <<-:
	It should scare you a little bit that these commands can so easily
	clobber other files.

	I hope that you get into the habit of closely considering your commands
	before hitting ENTER and reading all prompts before answering.

	:
	_tutr_pressanykey
}


rm_1file_pre() {
	create_copy0_txt
}

rm_1file_prologue() {
	cat <<-:
	The Unix command to delete or remove files is called 'rm'.
	This is its syntax:

	  rm [-f] FILENAME...

	Example: remove the files "hello.txt" and "world.doc"
	  rm "hello.txt" "world.doc"

	'rm' expects at least one argument that is the name of a file, but
	several filenames may be given.  'rm' may also take the '-f' option,
	which will be explained shortly.

	Files removed by 'rm' are PERMANENTLY gone.  There is no recycle bin or
	"undelete" feature on Unix; these commands are serious business.  Like
	'cp' and 'mv', 'rm' may ask for confirmation before making permanent
	changes.  If it does, you will respond in the same way as the other
	commands you just learned.

	We'll start small by removing a single file.
	Remove the file 'copy0.txt'.
	:
}

rm_1file_test() {
	if   _tutr_nonce; then return $PASS
	elif [[ ! -f $_BASE/copy0.txt ]]; then return 0
	elif [[ ${_CMD[@]} = "rm copy0.txt" && -f $_BASE/copy0.txt ]]; then return 99
	else _tutr_generic_test -c rm -a copy0.txt -d "$_BASE"
	fi
}

rm_1file_hint() {
	case $1 in
		99)
			cat <<-:
			Hmm, your command looks okay, but 'copy0.txt' is still here.
			Did 'rm' prompt you but you didn't respond affirmatively?

			Why don't you try this again.
			:
			;;
		*)
			_tutr_generic_hint $1 rm "$_BASE"
			;;
	esac

	cat <<-:

	Remove the file 'copy0.txt'.
	  rm copy0.txt
	:
}


rm_star0_prologue() {
	cat <<-:
	Suppose you need to delete 100 .txt files from a directory.

	To delete multiple files in a graphical file browser you would highlight
	them with the mouse and either hit the DELETE key or drag them into some
	representation of a garbage can.

	To remove files in the shell you run 'rm' with each target file's name
	as arguments.  Even with TAB completion this would be tedious to do for
	100 different files.  What you need is a way to tell the shell to run
	'rm' on every file with a name ending in '.txt'.

	The shell feature that lets you do this is called "wildcards".  When
	given a wildcard the shell substitutes it with all matching filenames
	and THEN runs your command.  The shell has a few wildcards up its sleeve,
	but I will teach you the one that serves 90% of your needs.

	The asterisk '*' (a.k.a. "glob", a.k.a. "star") matches ANY number of
	characters in a file's name:

	  rm *.txt   => run 'rm' on all files with the ".txt" extension
	  rm l*.txt  => run 'rm' on all files beginning with the letter 'l' and
	                ending in ".txt"
	  rm *t*     => run 'rm' on all files with a 't' anywhere in their names
	  rm *       => run 'rm' on all files here; very dangerous!

	Use a glob pattern with 'rm' to remove all files with the ".txt"
	extension from this directory.
	:
}


rm_star0_test() {
	if [[ -n $ZSH_NAME ]]; then
		setopt local_options nullglob
	fi
	if   _tutr_nonce; then return $PASS
	elif [[ -n $ZSH_NAME  && -z $(echo *.txt) ]]; then return 0
	elif [[ -n $BASH_VERSION && $(echo *.txt) = "*.txt" ]]; then return 0
	elif [[ ${_CMD[0]} = rm ]]; then return 99
	else _tutr_generic_test -c rm -a *.txt -d "$_BASE"
	fi
}

rm_star0_hint() {
	case $1 in
		99)
			cat <<-:
			There still exist one or more ".txt" files after that command.
			You'll need to try again.
			:
			;;
		*)
			_tutr_generic_hint $1 rm "$_BASE"
			;;
	esac

	cat <<-:

	Use a glob pattern to run 'rm' on all files whose names end in ".txt".
	
	Run 'tutor hint' to see the shell wildcard explanation again.
	:
}

rm_star0_epilogue() {
	cat <<-:
	Wildcards can let you be more efficient at removing many related files
	than with a GUI.
	
	But being efficient when it comes to deleting files cuts both ways;
	in just a few keystrokes you can obliterate ALL of your precious work!  

	:
	_tutr_pressanykey
}


rm_star1_pre() {
	# re-create any missing JPG or WAV files
	for I in {a..z}; do
		touch "$_BASE/$I.jpg"
	done

	for I in {0..9}; do
		touch "$_BASE/$I.wav"
	done
}

rm_star1_prologue() {
	cat <<-:
	I just created 26 ".jpg" and 10 ".wav" files in this directory.

	You can use 'ls' to see their names.  

	Use 'rm' with a wildcard to remove all of the ".wav" files with a single
	command.  Leave the ".jpg" files alone.
	:
}

rm_star1_test() {
	if   _tutr_nonce; then return $PASS
	elif [[ -n $ZSH_NAME ]]; then
		setopt local_options nullglob
		if   [[ -n $(echo *.jpg) && -z $(echo *.wav) ]]; then return 0
		elif [[ -z $(echo *.jpg) && -n $(echo *.wav) ]]; then return 98
		elif [[ ${_CMD[0]} = rm ]]; then return 99
		else _tutr_generic_test -c rm -a *.wav -d "$_BASE"
		fi
	elif [[ -n $BASH_VERSION ]]; then
		if   [[ $(echo *.jpg) != "*.jpg" && $(echo *.wav)  = "*.wav" ]]; then return 0
		elif [[ $(echo *.jpg)  = "*.jpg" && $(echo *.wav) != "*.wav" ]]; then return 98
		elif [[ ${_CMD[0]} = rm ]]; then return 99
		else _tutr_generic_test -c rm -a *.wav -d "$_BASE"
		fi
	else _tutr_generic_test -c rm -a *.wav -d "$_BASE"
	fi
}

rm_star1_hint() {
	case $1 in
		99)
			cat <<-:
			That command left some .wav files behind.
			You'll need to try again.
			:
			;;

		98)
			rm_star1_pre
			cat <<-:
			I think that you deleted the wrong files!
			I've put things back so you can try again.
			:
			;;
		*)
			_tutr_generic_hint $1 rm "$_BASE"
			;;
	esac

	cat <<-:

	Use 'rm' with a wildcard to remove all ".wav" files in a single
	command.  Leave the ".jpg" files alone.
	:
}



rm_star2_pre() {
	rm -rf $_BASE/{a..z}{a..z}.png $_BASE/{0..9}{0..9}.mp4
	touch $_BASE/{a..z}{a..z}.png $_BASE/{0..9}{0..9}.mp4
}

rm_star2_prologue() {
	cat <<-:
	To simulate your Downloads folder (a.k.a. the junk-drawer for computers)
	I have just created 100 ".mp4" and 676 ".png" files.  You can count them
	if you don't believe me.  I'm going to be a big jerk and make YOU clean
	up MY mess.

	Does 'rm' prompt for confirmation on your computer?  If so, you're
	looking at pressing 'y' 776 times.  That is exactly the sort of tedious,
	repetitive thing that a computer ought to do for you.

	This is where 'rm's "force" option '-f' comes in handy.
	'rm -f' temporarily disables confirmation prompts in favor of a
	"silent-but-deadly" mode of operation.

	Example: to forcibly remove all Markdown files in one command:
	  rm -f *.md

	BE VERY CAREFUL WITH 'rm -f'!!!

	Every Unix hacker has their own harrowing story about this command.
	Don't become another statistic!  Think before you type, and think again
	before you hit ENTER.  Check yourself before you wreck yourself.

	If you do find yourself answering hundreds of prompts, cancel the
	command with '^C' and try again.  Understand that all files for which
	you answered "yes" are already deleted.

	Are you ready to get dangerous?
	Remove all ".png" and ".mp4" files, leaving all other files unscathed.
	:
}

rm_star2_test() {
	if [[ -n $ZSH_NAME ]]; then
		setopt local_options nullglob
	fi
	if   _tutr_nonce; then return $PASS
	elif [[ -n $ZSH_NAME && -z $(echo *.png) && -z $(echo *.mp4) ]]; then return 0
	elif [[ -n $BASH_VERSION && $(echo *.png *.mp4) = "*.png *.mp4" ]]; then return 0
	elif [[ ${_CMD[0]} = rm ]]; then return 99
	else _tutr_generic_test -c rm -a *.png -a *.mp4 -d "$_BASE"
	fi
}

rm_star2_hint() {
	case $1 in
		99)
			cat <<-:
			There are still some .png or .mp4 files here.
			You'll need to try again.
			:
			;;
		*)
			_tutr_generic_hint $1 rm "$_BASE"
			;;
	esac

	cat <<-:

	Use 'rm' with a wildcard to remove all 776 of the ".png" and ".mp4"
	files that I have created.

	  rm -f *.png *.mp4

	The '-f' option will let you avoid pressing "y" 776 times.
	:
}

rm_star2_epilogue() {
	cat <<-:
	How is THAT for brute efficiency?

	Imagine doing that same task in a graphical file manager.  How much
	scrolling and dragging would it take to select that many files?

	And what if you accidentally highlighted a few .pdf or .docx files?

	I hope this gives you a glimpse of the power of the command shell.

	:
	_tutr_pressanykey
}


rm_star3_prologue() {
	cat <<-:
	For your last trick, use a bare glob '*' to delete EVERYTHING else in
	here.

	The '*' pattern matches EVERY file except for hidden ones.  Recall from
	Lesson #0 that hidden files have names that begin with a dot ('.').

	Add the '-f' option so you don't need to press "y" so many times.
	:
}

rm_star3_test() {
	if [[ -n $ZSH_NAME ]]; then
		setopt local_options nullglob
	fi

	if   _tutr_nonce; then return $PASS
	elif [[ -n $ZSH_NAME && -z $(echo *) ]]; then return 0
	elif [[ -n $BASH_VERSION && $(echo *) = "*" ]]; then return 0
	elif [[ ${_CMD[0]} = rm ]]; then return 99
	else _tutr_generic_test -c rm -a -f -a * -d "$_BASE"
	fi
}

rm_star3_hint() {
	case $1 in
		99)
			cat <<-:
			There are still files in here.
			These files are all junk anyway.  What are you waiting for?
			:
			;;
		*)
			_tutr_generic_hint $1 rm "$_BASE"
			;;
	esac

	cat <<-:

	Use a bare glob '*' to delete all non-hidden files in this directory.
	You can combine this with the '-f' option to avoid pressing "y" so many
	times:
	  rm -f *
	:
}


rm_star3_epilogue() {
	cat <<-:
	Now that you've run that command, be careful the next time you feel it 
	go out of your fingertips.  That is one command that should give you a
	sinking feeling each time you see it.

	Remember, in Unix file deletion is forever!

	:
	_tutr_pressanykey
}


source _tutr/main.sh && _tutr_begin ${_STEPS[@]} \
	copy01 \
	copy02 \
	list1 \
	cp_clobber \
	move01 \
	move02_err \
	move12 \
	mv_clobber \
	rm_1file \
	rm_star0 \
	rm_star1 \
	rm_star2 \
	rm_star3

# vim: set filetype=sh noexpandtab tabstop=4 shiftwidth=4 textwidth=76 colorcolumn=76:
