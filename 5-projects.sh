#!/bin/sh

_HELP="
Lesson #5 Topics
================
* Edit files with the GNU Nano text editor
* Learn the structure of assignments
* Organize files into directories
* Run unit tests and interpret their results
* Write project documentation

Commands used in this lesson
============================
* nano
* mkdir
* rm
* cd
* mv
* python
"

source _tutr/record.sh
if [[ -n $_TUTR ]]; then
	source _tutr/generic_error.sh
	source _tutr/nonce.sh
fi


# git hash-object FILENAME
README_HSH="1fca181f37013f17c825332cb2fdcd322dba3599"
PLAN_HSH="b67c94e1e2ddb90afdc357fb61bc6fab444fe373"
MAIN_HSH="cda181d43b66461abde44f792d4f82cce28b41e5"

_nano_not_found() {
	cat <<-NNF
	The command 'nano' was not found.  It is required for this lesson.
	
	Contact erik.falor@usu.edu for help
	NNF
}

_python_not_found() {
	cat <<-PNF
	I could not find a working Python 3 interpreter on your computer.
	It is required for this lesson.

	Contact erik.falor@usu.edu for help
	PNF
}

setup() {
	if _tutr_record_exists ${_TUTR#./}; then
		_tutr_warn printf "'You have already completed this lesson'"
		if ! _tutr_yesno "Would you like to do it again?"; then
			_tutr_info printf "'SEE YOU SPACE COWBOY...'"
			exit 1
		fi
	fi

	if ! which nano &>/dev/null; then
		_tutr_die _nano_not_found
	fi

	if   which python &>/dev/null && [[ $(python -V 2>&1) = "Python 3"* ]]; then
		export _PY=python
	elif which python3 &>/dev/null && [[ $(python3 -V 2>&1) = "Python 3"* ]]; then
		export _PY=python3
	else
		_tutr_die _python_not_found
    fi


	if [[ -z $_HERE ]]; then
		$SHELL _tutr/screen_size.sh 80 30
		export _HERE=$PWD
		export _BASE=$PWD/lesson5
		[[ -d "$_BASE" ]] && rm -rf "$_BASE"

		mkdir -p "$_BASE"
	fi

    if [[ -n $ZSH_NAME ]]; then
		export _SH=Zsh
	else
		export _SH=Bash
	fi

	cat <<-TEXT > "$_BASE/main.py"
	import sys

	def main(args):
	    if len(args) == 0:
	        print("Usage: main.py FILE...")
	        sys.exit(1)

	    for filename in args:
	        f = open(filename)
	        print(f.read())
	        f.close()

	def return_one():
	    return 1

	def return_two():
	    return 2

	def return_true():
	    return True

	def return_false():
	    return True

	if __name__ == '__main__':
	    main(sys.argv[1:])
	TEXT


	cat <<-TEXT > "$_BASE/runTests.py"
	import unittest, sys
	from Testing import test_numbers, test_booleans

	suite = unittest.TestSuite()

	for test in (test_numbers.TestNumbers, test_booleans.TestBooleans):
	    suite.addTest(unittest.makeSuite(test))

	runner = unittest.TextTestRunner(verbosity=2)
	if not runner.run(suite).wasSuccessful():
	    sys.exit(1)
	TEXT


	cat <<-TEXT > "$_BASE/test_booleans.py"
	import unittest
	import main

	class TestBooleans(unittest.TestCase):
	    def test_true(self):
	        self.assertTrue(main.return_true())

	    def test_false(self):
	        self.assertFalse(main.return_false())

	if __name__ == '__main__':
	    unittest.main()
	TEXT


	cat <<-TEXT > "$_BASE/test_numbers.py"
	import unittest
	import main

	class TestNumbers(unittest.TestCase):
	    def test_one(self):
	        self.assertEqual(main.return_one(), 1)

	    def test_two(self):
	        self.assertEqual(main.return_two(), 2)

	if __name__ == '__main__':
	    unittest.main()
	TEXT


	cat <<-TEXT > "$_BASE/README.md"
	# Welcome to the Nano text editor!

	Nano aims to be a user friendly editor with a simple interface.  You'll
	find hints at the bottom of the screen for the most common commands.
	Do you remember the "^" and "M-" mnemonics you learned in back in the
	second lesson?  That is how Nano describes its shortcut keys to you.

	As a refresher:

	*   "^"  means "Control"
	*   "M-" stands for the "Meta" key, which corresponds to "Alt" on your
	         keyboard.

	Besides Nano there are other popular text editors such as Vim and Emacs.
	While most developers prefer to work in an IDE, it is not uncommon to
	see others work almost exclusively in a text editor.  You are free to
	use whichever text editor you are most comfortable with in this class
	(and in this lesson).  If you don't have a preference, Nano is a great
	place to start.

	Use your editor to complete the following tasks:

	* Write your A-Number somewhere in this file.  Your A-Number should
	  begin with a capital 'A' and be followed by eight digits.  Write it as
	  a free-standing word that is not connected to other text.
	* Delete this line of text that mentions Brown M&M's.  There is a hint
	  at the bottom of the screen describing a command that can delete an
	  entire line of text in one stroke.
	* Exit Nano, saving your changes to this file as you leave.  Again,
	  there is a hint down below explaining which command exits this
	  program.
	  * When you exit you will be asked "Save modified buffer?".  "Buffer"
	    is the name for text on the screen before it is written to the disk.
	    Answer "Yes" to this question.
	  * You will then be asked "File Name to Write" with a suggestion of
	    "README.md".  This is how you perform a "Save As..." in Nano.
	    For now leave this filename as "README.md"
	TEXT

	cat <<-TEXT > "$_BASE/data0.txt"
	This is some data for the Python script to use
	TEXT

	cat <<-TEXT > "$_BASE/data1.txt"
	Hello World!
	TEXT

	cat <<-TEXT > "$_BASE/song.mp3"
	This file is junk and should be deleted
	TEXT

	cat <<-TEXT > "$_BASE/image.png"
	This file is junk and should be deleted
	TEXT

	cat <<-TEXT > "$_BASE/movie.mkv"
	This file is junk and should be deleted
	TEXT

	cat <<-TEXT > "$_BASE/Plan.md"
	# Software Dev Plan

	*	Design
	*	Testing
	*	Implement
	TEXT

	cat <<-TEXT > "$_BASE/Instructions.md"
	# CS 1440 Assignment 1 Instructions

	## Description

	In this assignment you will write your own versions of classic Unix
	text-processing programs.  The tools you write for this assignment are
	not intended to be perfect clones of the programs they are mimicking.  I
	have relaxed requirements that your code should meet.

	This assignment is essentially a re-implementation of simple Unix
	text-processing programs in Python.  Each tool will be a Python function
	which takes as input a list of arguments supplied by the user from the
	command line.
	TEXT

	cat <<-TEXT > "$_BASE/Rubric.md"
	# CS 1440 Assignment 1 Rubric

	| Points | Criteria
	|:------:|--------------------------------------------------------------------------------
	| 5      | Eligible error messages are displayed with 'usage()'<br/> Errors that can reasonably be detected by your code are reported with 'usage()'<br/> others are left to Python's error reporting
	| 10     | cat & tac
	| 10     | head & tail
	| 10     | wc
	| 10     | grep
	| 10     | sort
	| 15     | cut
	| 15     | paste

	**Total points: 85**
	TEXT

}



prologue() {
	clear
	echo
	cat <<-PROLOGUE
	Shell Lesson #5: Working in Projects

	In this lesson you will learn how to

	* Move files between directories
	* Navigate the standard DuckieCorp project structure
	* Create and edit text files with the Nano editor
	* Run unit tests and interpret their results
	* Write project documentation

	Let's get started!

	PROLOGUE

	_tutr_pressanykey
}


cleanup() {
	# Remember that this lesson has been completed
	(( $# >= 1 && $1 == $_COMPLETE)) && _tutr_record_completion ${_TUTR#./}
	[[ -d "$_BASE" ]] && rm -rf "$_BASE"
	echo "You worked on Lesson #5 for $(_tutr_pretty_time)"
}


epilogue() {
	cat <<-EPILOGUE
	Way to go!  You're almost done!  Do you feel smarter yet?
	You sure are getting there!

	In this lesson you have learned how to

	* Move files between directories
	* Navigate the standard DuckieCorp project structure
	* Create and edit text files with the Nano editor
	* Run unit tests and interpret their results
	* Write project documentation

	This concludes Shell Lesson #5

	Run './6-git.sh' to begin the final lesson

	EPILOGUE

	_tutr_pressanykey
}




# nano README.md
nano_readme_prologue() {
	cat <<-:
	Nano is a small and friendly text editor.  Nano can edit any program
	regardless of the language it is written in.  This is in contrast to
	PyCharm, which is an Integrated Development Environment (IDE).
	PyCharm's text editor is just a small part of a larger tool and
	specializes in editing Python and code in a few related languages.

	In industry a majority of professionals use an IDE like PyCharm
	exclusively.  However, there are tasks for which a simple text editor
	like Nano are more appropriate.  Additionally, Nano is likely already
	installed on any workstations and servers that you will use in your job.
	When you learn Nano you are at home on ANY computer.

	The syntax for running Nano from the command line is
	  nano [FILENAME]...

	This means that nano can take 0 or more filenames as arguments.
	The files DO NOT need to already exist to open them with Nano.

	Example: edit the file "hello.txt"
	  nano hello.txt

	Example: open a fresh, empty editor (choose a filename when you save)
	  nano

	Open 'README.md' in Nano and follow the instructions found therein.
	You will move on to the next step when 'README.md' has been changed
	appropriately.
	:
}

_T=0
_F=1



nano_readme_test() {
	if   [[ "$PWD" != "$_BASE" ]]; then return $WRONG_PWD
	elif _tutr_nonce; then return $PASS
	elif [[ $(git hash-object "$_BASE/README.md") = $README_HSH ]]; then return 97
	fi

	egrep -qw 'A[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' "$_BASE/README.md" >/dev/null
	_HAS_ANUM=$?
	! grep -q "Brown M&M's" "$_BASE/README.md" >/dev/null
	_NO_BROWN_MMS=$?
	egrep -iqw 'A[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' "$_BASE/README.md" >/dev/null
	_LOWERCASE_ANUM=$?

	if   (( $_HAS_ANUM == $_T && $_NO_BROWN_MMS == $_T )); then return 0
	elif (( $_HAS_ANUM == $_F )); then return 99
	elif (( $_NO_BROWN_MMS == $_F )); then return 98
	elif (( $_LOWERCASE_ANUM == $_T )); then return 96
	else return $WRONG_CMD
	fi
}

nano_readme_hint() {
	case $1 in

		97)
			cat <<-:
			It looks like the file 'README.md' is unchanged.
			Were you able to save it in your text editor?

			Start by writing your A-Number in the file.  It should be a
			capital 'A' followed by eight digits.

			:
			;;

		96)
			cat <<-:
			You didn't write that A-Number with a lower-case 'A', did you?

			:
			;;

		99)
			cat <<-:
			Start by writing your A-Number in the file.  Remember, what I'm
			looking for is a capital 'A' and be followed by eight digits.

			:
			;;

		98)
			cat <<-:
			Delete the line of text from 'README.md' that mentions Brown M&M's.

			Try putting the cursor on that line and executing the 'Cut Text'
			command.

			:
			;;

		$WRONG_CMD)
			cat <<-:
			The command "${_CMD[0]}" wasn't the right thing to do at this time.

			:
			;;
		*)
			_tutr_generic_hint $1 nano "$_BASE"
			;;
	esac

	cat <<-:
	Open 'README.md' in Nano and follow the instructions found therein.
	  nano README.md

	You will move on to the next step when 'README.md' has been changed
	appropriately.
	:
}



# mkdir to create necessary dirs + junk/
mkdirs_prologue() {
	cat <<-:
	For each assignment in this class I will provide you with starter code.
	The starter code will be organized into a few standard directories.  To
	help you become familiar with how starter code will be organized and to
	give you more practice with commands you learned in previous lessons,
	you will create these directories and sort the files into their proper
	place.

	Take as many commands as you need to make the following new
	subdirectories here:

	*	src/
	*	src/Testing/
	*	doc/
	*	data/
	*	instructions/
	*	junk/
	:
}

mkdirs_test() {
	if   [[ -d "$_BASE/src" && -d "$_BASE/src/Testing" \
		&& -d "$_BASE/doc" && -d "$_BASE/data" \
		&& -d "$_BASE/junk" && -d "$_BASE/instructions" ]]; then return 0
	elif _tutr_nonce rmdir; then return $PASS
	elif [[ ! -d "$_BASE/src" ]]; then return 99
	elif [[ ! -d "$_BASE/doc" ]]; then return 98
	elif [[ ! -d "$_BASE/data" ]]; then return 97
	elif [[ ! -d "$_BASE/junk" ]]; then return 96
	elif [[ ! -d "$_BASE/src/Testing" ]]; then return 95
	elif [[ ! -d "$_BASE/instructions" ]]; then return 94
	else _tutr_generic_test -c mkdir -d "$_BASE"
	fi
}

mkdirs_hint() {
	case $1 in
		99) echo "It seems that you lack the subdirectory 'src/'" ;;
		98) echo "It seems that you lack the subdirectory 'doc/'" ;;
		97) echo "It seems that you lack the subdirectory 'data/'" ;;
		96) echo "It seems that you lack the subdirectory 'junk/'" ;;
		95) echo "It seems that you lack the subdirectory 'src/Testing/'" ;;
		94) echo "It seems that you lack the subdirectory 'instructions/'" ;;
		*) _tutr_generic_hint $1 mkdir $_BASE ;;
	esac
}


# use cp, rm & mv to sort files into their correct locations
sort_files_prologue() {
	cat <<-:
	Next, move all of the files in this directory into their correct
	location.

	*   .py files with names beginning with 'test_' go in src/Testing/
	*   All other .py files go under src/
	*   Plan.md and README.md belong in doc/
	*   Rubric.md and Instructions.md fit in instructions/
	*   .txt files go in data/
	*   Move anything that doesn't fit into junk/

	Use the commands 'cp', 'rm' & 'mv' to put everything into place.  If you
	accidentally delete the wrong file or otherwise get stuck there are two
	ways to fix it:

	*   Run the command 'setup' to re-create all files
	*   Exit and then re-start this lesson
	:
}

sort_files_test() {
	if   [[ -f "$_BASE/src/main.py" \
		&& -f "$_BASE/src/runTests.py" \
		&& -f "$_BASE/src/Testing/test_booleans.py" \
		&& -f "$_BASE/src/Testing/test_numbers.py" \
		&& -f "$_BASE/doc/Plan.md" \
		&& -f "$_BASE/doc/README.md" \
		&& -f "$_BASE/instructions/Rubric.md" \
		&& -f "$_BASE/instructions/Instructions.md" \
		&& -f "$_BASE/data/data0.txt" \
		&& -f "$_BASE/data/data1.txt" \
		&& -f "$_BASE/junk/song.mp3" \
		&& -f "$_BASE/junk/movie.mkv" \
		&& -f "$_BASE/junk/image.png" \
		]]; then return 0
	elif _tutr_nonce; then return $PASS
	elif [[ $PWD != $_BASE ]]; then return $WRONG_PWD
	elif [[ ! -f $_BASE/src/main.py ]]; then return 99
	elif [[ ! -f "$_BASE/src/runTests.py" ]]; then return 98
	elif [[ ! -f "$_BASE/src/Testing/test_booleans.py" ]]; then return 97
	elif [[ ! -f "$_BASE/src/Testing/test_numbers.py" ]]; then return 96
	elif [[ ! -f "$_BASE/doc/Plan.md" ]]; then return 95
	elif [[ ! -f "$_BASE/doc/README.md" ]]; then return 94
	elif [[ ! -f "$_BASE/instructions/Rubric.md" ]]; then return 88
	elif [[ ! -f "$_BASE/instructions/Instructions.md" ]]; then return 87
	elif [[ ! -f "$_BASE/data/data0.txt" ]]; then return 93
	elif [[ ! -f "$_BASE/data/data1.txt" ]]; then return 92
	elif [[ ! -f "$_BASE/junk/song.mp3" ]]; then return 91
	elif [[ ! -f "$_BASE/junk/movie.mkv" ]]; then return 90
	elif [[ ! -f "$_BASE/junk/image.png" ]]; then return 89
	else _tutr_generic_test -c sort_files
	fi
}

sort_files_hint() {
	case $1 in
		99) echo "Now move main.py under src" ;;
		98) echo "runTests.py should go under src" ;;
		97) echo "Now move test_booleans.py into src/Testing" ;;
		96) echo "Now move test_numbers.py to src/Testing" ;;
		95) echo "Now move Plan.md to doc" ;;
		94) echo "Now move README.md into doc" ;;
		93) echo "data0.txt should go into data" ;;
		92) echo "data1.txt belongs in data" ;;
		91) echo "song.mp3 seems like junk" ;;
		90) echo "movie.mkv is a junk file" ;;
		89) echo "image.png is another junk file" ;;
		88) echo "Rubric.md goes in instructions" ;;
		87) echo "Instructions.md goes under instructions" ;;
		*) _tutr_generic_hint $1 mkdir "$_BASE" ;;
	esac
}

# rm -rf junk/
remove_junk_prologue() {
	cat <<-:
	That's better!  A clean project directory will help you to avoid a lot
	of confusion.

	Before I remove files I like to first move them into a temporary junk/
	folder so I can double-check them before they are gone forever.

	Unlike the graphical desktop systems you are familiar with, file
	deletion in the Unix shell is forever; there is no undelete command
	here.  This extra step is something that I learned years ago to prevent
	a disaster.

	Feel free to take one last look at the contents of junk/ before you get
	rid of it.  Then run a command that will permanently wipe junk/ and all
	of its contents off of your hard disk.
	:
}

remove_junk_test() {
	if   [[ -n $_BAD_CMD ]]; then return 97
	elif [[ ! -d "$_BASE/src" ]]; then
		_BAD_CMD="${_CMD[@]}"
		return 97
	elif [[ -d "$_BASE/src" && ! -d "$_BASE/junk" ]]; then return 0
	# if _BASE is NOT a substring of the current dir, then report an error
	elif ! [[ $PWD = $_BASE* ]]; then return $WRONG_PWD
	elif _tutr_nonce man cd; then return $PASS
	elif [[ ${_CMD[0]} = rmdir ]]; then return 98
	elif [[ ${_CMD[0]} != rm ]]; then return $WRONG_CMD
	elif [[ -d "$_BASE/junk" ]]; then return 99
	fi
}

remove_junk_hint() {
	case $1 in
		99)
			cat <<-:
			Try using the 'rm' command with the options that cause it to
			forcefully remove all files and subdirectories recursively.

			You can read the manpage for 'rm' if you need a refresher.
			:
			;;

		98)
			cat <<-:
			'rmdir' isn't the right command for this job.  Try using the 'rm'
			command with the options that cause it to forcefully remove all
			files and subdirectories recursively.

			You can read the manpage for 'rm' if you need a refresher.
			:
			;;

		97)
			cat <<-:
			Whoops, you've accidentally removed the src/ directory!
			You needed that to complete the lesson.

			Quit and re-start this lesson so I can put everything back as it
			was before so you can try again.
			
			The command which got you into trouble was
			  $_BAD_CMD

			...maybe don't do that next time ;)
			:
			;;

		*)
			_tutr_generic_hint $1 rm "$_BASE"
			cat <<-:

			Are you ready to get rid of the junk files?

			Run the command that will permanently erase junk/ and its
			contents from the hard disk.
			:
			;;
	esac
}


# Fix a bug in the Python program so the tests pass
# 	*	Read & update the software dev plan with Nano
# 	*	Edit the code with Python



cd_into_src_prologue() {
	cat <<-:
	Now that the files are sorted into the proper directories, cd into the
	'src/' directory.
	:
}

cd_into_src_test() {
	if   [[ "$PWD" == "$_BASE/src" ]]; then return 0
	elif _tutr_nonce; then return $PASS
	else _tutr_generic_test -c cd -a src -d "$_BASE/src"
	fi
}

cd_into_src_hint() {
	_tutr_generic_hint $1 cd "$_BASE/src"
}


run_tests_prologue() {
	cat <<-:
	This directory contains a Python program called 'main.py' as well as
	another file named 'runTests.py' which performs a set of "unit tests" on
	'main.py' to check for bugs.

	Python programs can be run on the command line by invoking the '$_PY'
	command with the name of a Python file as its argument.

	See for yourself whether there are any problems in 'main.py' by running
	'runTests.py' with the '$_PY' command.

	If you accidentally enter Python's interactive mode (you'll see Python's
	characteristic '>>>' prompt) press '^D' or run the 'exit()' function to
	return to $_SH.
	:
}

run_tests_test() {
	if   _tutr_nonce man; then return $PASS
	elif [[ ${_CMD[@]} = $_PY ]]; then return 99
	else _tutr_generic_test -f -c $_PY -a runTests.py -d "$_BASE/src"
	fi
}

run_tests_hint() {
	case $1 in
		99)
			cat <<-:
			That wasn't a bad thing to do!  By the end of this class you
			will be as comfortable in Python's interactive mode as you
			are in the shell.

			This time be sure to give 'runTests.py' as the argument to the
			'${_CMD[0]}' command.
			:
			;;

		$WRONG_ARGS)
			cat <<-:
			The Python program you need to run is called 'runTests.py'.
			:
			;;
		*)
			_tutr_generic_hint $1 $_PY "$_BASE"

			cat <<-:

			  $_PY runTests.py
			:
			;;
	esac
}

run_tests_epilogue() {
	_tutr_pressanykey
	cat <<-:

	WOW!!! That wall of text sure looks scary!

	In time you'll learn to appreciate how useful this information is.  The
	output generated by automated tests save you loads of time as it lets
	you zero in on bugs in your programs.

	Allow me to translate.  Four automated tests were run against the
	program 'main.py', and one test failed.

	When a test fails you are shown:

	0.  Which file contains the failing test
	    '...lesson5/src/Testing/test_booleans.py'
	1.  The line number and function where the failure occurred
	    'line 9, in test_false'
	2.  You are even shown the very line of code that failed
	    'self.assertFalse(main.return_false())'
	3.  The specific error is named
	    'AssertionError: True is not false'

	In other words, a test named 'test_false' expected the function
	'main.return_false()' to return 'False'.  Instead, that function
	returned 'True'.

	Now that you have identified which test failed, you can work to uncover
	the root cause.  This means taking a look at the function
	'return_false()' defined in 'main.py'.

	:
	_tutr_pressanykey
}


nano_main_py_prologue() {
	cat <<-:
	Use 'nano' to take a look at 'main.py'.  Your goal is to find the error
	the automated test is alerting you about.

	!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	!!! DON'T TOUCH ANYTHING !!!
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	Resist the urge to fix the error and leave 'main.py' unchanged.
	This is just a recon mission.
	:
}

nano_main_py_test() {
	_tutr_generic_test -c nano -a main.py -d "$_BASE/src"
}

nano_main_py_hint() {
	_tutr_generic_hint $1 nano "$_BASE/src"
}

nano_main_py_epilogue() {
	# check SHA-1 sum of main.py - if the match fails, say something
	if [[ $(git hash-object "$_BASE/src/main.py") != $MAIN_HSH ]]; then
		cat <<-:
		You just couldn't resist, could you?

		:
	fi
	cat <<-:
	Now that you found the problem you can make a plan to fix it.

	:
	_tutr_pressanykey
}



edit_plan_prologue() {
	cat <<-:
	It is a good habit to document your efforts in a Software Development
	Plan.  As you work on a project over the course of months or years this
	information will serve you and your teammates well.

	A Software Development Plan (SDP) is required for every assignment in
	this class.  I'll spend time in a lecture explaining what this document
	entails and how it helps you to design better software.

	Leave this directory and go back into ../doc.

	There you will edit 'Plan.md' with Nano and write a brief description of
	the problem you found and what you will do to fix it.  Add your remarks
	under the "Testing" heading.

	Finally, save the file to proceed with the lesson.
	:
}


edit_plan_test() {
	if   [[ "$PWD" == "$_BASE/src" ]]; then return 99
	elif [[ ${_CMD[0]} == cd && "$PWD" == "$_BASE/doc" ]]; then return 98
	elif [[ "$PWD" = "$_BASE" ]]; then return 96
	elif [[ "$PWD" != "$_BASE/doc" ]]; then return $WRONG_PWD
	# elif _tutr_nonce; then return $PASS
	fi

	[[ $(git hash-object "$_BASE/doc/Plan.md") = $PLAN_HSH ]]
	_UNCHANGED=$?

	if   (( $_UNCHANGED == $_T )); then return 97
	else _tutr_generic_test -c nano -a Plan.md -d "$_BASE/doc"
	fi
}

edit_plan_hint() {
	case $1 in
		99)
			cat <<-:
			From here you need to go up one directory, then into 'doc'.

			Try
			  'cd ../doc'
			:
			;;

		98)
			cat <<-:
			Now that you're here, open 'Plan.md' in 'nano' and add your
			remarks under the "Testing" heading.

			Follow the on-screen instructions to save your changes back into
			the file.
			:
			;;

		97)
			cat <<-:
			It doesn't look like you changed 'Plan.md' at all.  Were you
			able to save it in your text editor?

			Try again, and make sure that you don't accidentally save the
			file under a new name.
			:
			;;

		96)
			cat <<-:
			Now go into 'doc'
			  'cd doc'
			:
			;;

		$WRONG_ARGS)
			cat <<-:
			The name of the file you should edit is 'Plan.md'.
			:
			;;

		*)
			_tutr_generic_hint $1 nano "$_BASE/doc"
			;;
	esac
}


fix_bug_prologue() {
	cat <<-:
	Return to the 'src/' directory and use Nano to edit 'main.py' to fix the
	bug according to your plan.

	Re-run the tests with '$_PY runTests.py'.

	This step will be complete when all four unit tests pass.
	:
}

fix_bug_test() {
	if   _tutr_nonce cd pushd popd; then return $PASS
	elif [[ "$PWD" = "$_BASE" ]]; then return 97
	elif [[ "$PWD" != "$_BASE/src" ]]; then return $WRONG_PWD
	elif [[ ${_CMD[0]} == nano || ${_CMD[0]} == emacs || ${_CMD[0]} == *vim ]]; then

		[[ $(git hash-object "$_BASE/src/main.py") != $MAIN_HSH ]]
		_CHANGED=$?

		if   (( $_CHANGED == $_T )); then return 98
		else return 96
		fi

	elif [[ ${_CMD[@]} == "$_PY runTests.py" && $_RES != 0 ]]; then return 99
	else _tutr_generic_test -c $_PY -a runTests.py -d "$_BASE/src"
	fi
}

fix_bug_hint() {
	case $1 in
		99)
			cat <<-:
			Hmm, that didn't quite fix it.  Try again.
			:
			;;

		98)
			cat <<-:

			Now try re-running the test to make sure the bug is fixed
			   '$_PY runTests.py'
			:
			;;

		97)
			cat <<-:
			Go into the 'src/' subdirectory of this lesson to proceed.

			When you get there edit 'main.py' in 'nano'.
			:
			;;


		96)
			cat <<-:
			Edit 'main.py' in 'nano' to fix the bug.

			Once you've done that, re-run the automated test
			   '$_PY runTests.py'
			:
			;;

		*)
			_tutr_generic_hint $1 $_PY "$_BASE/src"

			cat <<-:
			Edit 'main.py' in 'nano' to fix the bug.

			Re-run the test to see that the bug is fixed
			   '$_PY runTests.py'
			:
			;;
	esac
}

fix_bug_epilogue() {
	cat <<-:
	Great!  You fixed it!
	:
}


signature_prologue() {
	cat <<-:
	Return to the '../doc' subdirectory to finalize your documentation.
	There you will create a daily log of your software development efforts
	in a file called 'Signature.md'.

	The sprint signature file is composed of brief, dated entries describing
	what you did each day.  One or two lines of description are plenty.

	You'll notice that this file doesn't yet exist.  You will create it by
	running 'nano Signature.md' and saving it as usual.
	:
}

signature_test() {
	if   _tutr_nonce cd pushd popd; then return $PASS
	elif [[ $PWD = "$_BASE" ]]; then return 97
	elif [[ $PWD != "$_BASE/doc" ]]; then return $WRONG_PWD
	elif [[ -s "$_BASE/doc/Signature.md" ]]; then return 0
	elif [[ -f "$_BASE/doc/Signature.md" ]]; then return 99
	else _tutr_generic_test -c nano -a Signature.md -d "$_BASE/doc"
	fi
}

signature_hint() {
	case $1 in
		99)
			cat <<-:
			Uh, your 'Signature.md' is empty.  You need to write something!
			:
			;;

		97)
			cat <<-:
			Go into the 'doc/' subdirectory of this lesson to proceed.

			When you get there create 'Signature.md' with 'nano'.
			:
			;;

		*)
			_tutr_generic_hint $1 nano "$_BASE/doc"
			;;
	esac

	cat <<-:

	Write a brief description of your work on this project in a new file
	'Signature.md'.  Include today's date in your write-up.
	:
}

signature_epilogue() {
	cat <<-:
	Good job!

	This is essentially the workflow that professional programmers follow:

	* Set up your work environment
	* Run tests
	* Locate a bug
	* Plan and document the fix
	* Perform the fix
	* Re-run tests to see that the bug is truly squashed and to ensure
	  no new bugs were introduced
	* Update the project's documentation

	The importance of maintaining up-to-date documentation cannot be
	overemphasized.

	:
	_tutr_pressanykey
}

# Source _tutr.sh and begin the tutorial
# _tutr_begin takes as arguments the names of each skill in the order that the
# user will experience them.

source _tutr/main.sh && _tutr_begin \
	nano_readme \
	mkdirs \
	sort_files \
	remove_junk \
	cd_into_src \
	run_tests \
	nano_main_py \
	edit_plan \
	fix_bug \
	signature \


# vim: set filetype=sh noexpandtab tabstop=4 shiftwidth=4 textwidth=76 colorcolumn=76:
