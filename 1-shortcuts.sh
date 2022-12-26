#!/bin/sh

# Lesson #1
#
# * To use the shell's History to re-use commands you have already typed
# * Line editor shortcuts to easily navigate and change command lines
# * How TAB completion can write parts of your commands for you

_HELP="
Lesson #1 Topics
================
* The shell's command history
* Line editor shortcuts
* TAB completion

Commands used in this lesson
============================
* echo
* cat
* sleep
* ls
"

source _tutr/record.sh
if [[ -n $_TUTR ]]; then
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
	$SHELL _tutr/screen_size.sh 80 42
	export _HERE=$PWD
	export _BASE=$PWD/lesson1
	[[ -d "$_BASE" ]] && rm -rf "$_BASE"
	mkdir -p "$_BASE"

	case $(uname -s) in
		Darwin)
			export _MACOSX=true
			export _BACKSPACE=$'  Delete | Erase the character to the LEFT of the cursor'
			;;
		*)
			export _MACOSX=false
			export _BACKSPACE=$'Backspace| Erase the character to the LEFT of the cursor\n  Delete | Erase the character to the RIGHT the cursor'
			;;
	esac

	cat <<-TEXT > "$_BASE/combinatorially.txt"
	[0m         .   .    |         \\    .             -o-
	  .               |       _  \\                  '     .
	                  |      / \\  \\       ______________________ 
	                  |     (0 0)  \\     ( Don't probe me, Bro! )
	TEXT

	cat <<-TEXT > "$_BASE/fragmentary.txt"
	[0m  '                        '              (   (      
	        .      .-""\`""-.          ,   .    \\  \\      
	            _/\`oOoOoOoOo\`\\_      -o-        '._'-._    .
	           '.-=-=-=-=-=-=-.'      '       .    \`\`\` 
	 .     jgs   \`-=.=-.-=.=-'                      .
	TEXT

	cat <<-TEXT > "$_BASE/disorganized.txt"
	[0m   .    -o-   .   |     \\       '      .
	         '        |      \\                    .
	                . |       \\ .                      .
	      .           |        \\            .       ,         .
	TEXT

	cat <<-TEXT > "$_BASE/nonsequential.txt"
	[0m   \\__/ .__/ \\__,_|\\___\\___|\\__,_| \\___/  \\__,_|\\__\\/   
	      |_|                        .                   . 
	        .        .                             _.._      
	  ,          .             ,        .       .' .-'\`
	 -o-               .      -o-              /  /       .
	TEXT

	cat <<-TEXT > "$_BASE/obfuscatory.txt"
	[0m        .         | (./ {,-.} \\.)   \\     (OO)\\_______ / 
	      ,      .    |     || ||    hjw \\    (__)\\       )  
	     -@-          |     || ||    \`97  \\    U  ||----w |  
	     \\|/          |   __|| ||__        \\      ||     ||  
	\\.//\\.|.~\\/.\\\\/.\\/\\.\\\`---" "---'\\/\\.\\/.\\/~.\\.\\////.\\/\\./\\.\\/
	TEXT

	cat <<-TEXT > "$_BASE/painstakingly.txt"
	[0m    __                          _     ___       _     _ 
	 . / _\\_ __   __ _  ___ ___  __| |   /___\\_   _| |_  / \\
	   \\ \\| '_ \\ / _\` |/ __/ _ \\/ _\` |  //  // | | | __|/  /
	.  _\\ \\ |_) | (_| | (_|  __/ (_| | / \\_//| |_| | |_/\\_/ 
	TEXT

	cat <<-TEXT > "$_BASE/reorganization.txt"
	[0m                ^  ^  ^      .             .
	                  | \\
	          .       |  \\   .         .      ,             .
	                 .|   \\    .    ,        -o-    .
	         ,        |    \\       -o-        ' 
	TEXT

	cat <<-TEXT > "$_BASE/sequentializing.txt"
	[0m        .         |      \\=/    \\ .  \`----------------------'
	            .     |     .-"-.    \\    O
	                  |    //\\ /\\\\    \\    o          .
	 .            .   |  _// | | \\\\_   \\    o.(__)          /
	TEXT
}


prologue() {
	clear
	echo
	cat <<-PROLOGUE
	Shell Lesson #1: Shortcuts

	In this lesson you will learn

	* To use the shell's History to re-use commands you have already typed
	* Line editor shortcuts to easily navigate and change command lines
	* How TAB completion can write parts of your commands for you

	Let's get started!

	PROLOGUE

	_tutr_pressanykey
}

_tutr_check_shortcuts() {
	if [[ $SHELL = */zsh ]]; then
		if [[ ! -f "$HOME/.zshrc" ]]; then
			_tutr_install_shortcuts "$HOME/.zshrc"
		elif ! grep -q "# DO NOT MODIFY. SHORTCUTS COMMAND ADDED BY SHELL TUTORIAL" "$HOME/.zshrc"; then
			_tutr_install_shortcuts "$HOME/.zshrc"
		fi
	elif [[ $SHELL = */bash ]]; then
		if [[ ! -f "$HOME/.bashrc" ]]; then
			_tutr_install_shortcuts "$HOME/.bashrc"
		elif ! grep -q "# DO NOT MODIFY. SHORTCUTS COMMAND ADDED BY SHELL TUTORIAL" "$HOME/.bashrc"; then
			_tutr_install_shortcuts "$HOME/.bashrc"
		fi
	else
		_tutr_die printf "'Unknown shell $SHELL: Unable to install the shortcuts command in this shell'"
	fi
}

_tutr_install_shortcuts() {
	if [[ -z $1 ]]; then
		_tutr_die "'Usage: $0 SHELL_RC_FILE_NAME'"
	fi

	cat <<-ASK | sed -e $'s/.*/\x1b[1;33mTutor\x1b[0m| &/'
	INSTALL A CHEATSHEET COMMAND

	You just learned 18 new keyboard shortcuts in this lesson.  To help you
	recall them later I can add a command called 'shortcuts' to your shell.
	This command will display the table of shortcuts shown in this lesson
	any time you need a quick refresher.

	To install this new command I must add a bit of code to your shell's
	startup script '$1'.

	This is a one-time-only edit.

	You can run 'shortcuts' after starting a new shell instance.
	ASK

	if _tutr_yesno "May I make this one-time change to' $1?"; then
		_tutr_info echo "Installing the 'shortcuts' command into $1..."
		if [[ $_MACOSX = true ]]; then
			cat <<-SHIM >> "$1"

			shortcuts() { # DO NOT MODIFY. SHORTCUTS COMMAND ADDED BY SHELL TUTORIAL
				cat <<-:
				Shortcut | Action
				---------|-----------------------------------------------
				  Up     | Bring up older commands from history
				  Down   | Bring up newer commands from history
				  Left   | Move cursor BACKWARD one character
				  Right  | Move cursor FORWARD one character
				$_BACKSPACE
				  ^A     | Move cursor to BEGINNING of line
				  ^E     | Move cursor to END of line
				  M-B    | Move cursor BACKWARD one whole word
				  M-F    | Move cursor FORWARD one whole word
				  ^C     | Cancel (terminate) the currently running process
				  TAB    | Complete the command or filename at cursor
				  ^W     | Cut BACKWARD from cursor to beginning of word
				  ^K     | Cut FORWARD from cursor to end of line (kill)
				  ^Y     | Yank (paste) text to the RIGHT the cursor
				  ^L     | Clear the screen while preserving command line
				  ^U     | Cut the entire command line
				:
			}
			SHIM
		else
			cat <<-SHIM >> "$1"

			shortcuts() { # DO NOT MODIFY. SHORTCUTS COMMAND ADDED BY SHELL TUTORIAL
				cat <<-:
				Shortcut | Action
				---------|-----------------------------------------------
				  Up     | Bring up older commands from history
				  Down   | Bring up newer commands from history
				  Left   | Move cursor BACKWARD one character
				  Right  | Move cursor FORWARD one character
				$_BACKSPACE
				  ^A     | Move cursor to BEGINNING of line
				  ^E     | Move cursor to END of line
				  M-B    | Move cursor BACKWARD one whole word
				  M-F    | Move cursor FORWARD one whole word
				  ^C     | Cancel (terminate) the currently running process
				  TAB    | Complete the command or filename at cursor
				  ^W     | Cut BACKWARD from cursor to beginning of word
				  ^K     | Cut FORWARD from cursor to end of line (kill)
				  ^Y     | Yank (paste) text to the RIGHT the cursor
				  ^L     | Clear the screen while preserving command line
				  ^U     | Cut the entire command line
				:
			}
			SHIM
		fi

		if (( $? != 0 )); then
			cat <<-: | sed -e $'s/.*/\x1b[1;31mTutor\x1b[0m| &/'
			I was unable to modify '$1'.
			Please contact erik.falor@usu.edu for support.
			:
		else
			_tutr_info echo "Now you can launch a new shell window and try running \'shortcuts\'."
		fi
	else
		_tutr_err echo "Leaving your shell\'s startup file unchanged."
	fi

	return 0
}


cleanup() {
	# Remember that this lesson has been completed
	if (( $# >= 1 && $1 == $_COMPLETE)); then
		_tutr_record_completion ${_TUTR#./}
		_tutr_check_shortcuts
	fi
	[[ -d "$_BASE" ]] && rm -rf "$_BASE"
	echo "You worked on Lesson #1 for $(_tutr_pretty_time)"
}


epilogue() {
	cat <<-EPILOGUE
	In this lesson you have learned how to save keystrokes with

	* The shell's command history
	* Line editor shortcuts
	* TAB completion

	This concludes Shell Lesson #1

	Run './2-commands.sh' to enter the next lesson

	EPILOGUE

	_tutr_pressanykey
}


# -1. Mac keyboard setup instructions
mac_keyboard_prologue() {
	cat <<-:
	It appears to me that you are using a Mac.  You need to do an extra bit
	of setup before you can begin this tutorial

	(If you have already done this once before, you can safely skip over
	this step).

	By default, the Terminal App here on Mac OS X is not set up for your
	'Option' key function within the shell.  Follow these steps to achieve
	the proper configuration:

	*   Open the 'Terminal' menu and select 'Preferences'
	*   Select the 'Profiles' page
	*   Select the 'Keyboard' tab
	*   Check the option labeled 'Use Option as Meta Key'

	Once you have done this, run the 'true' command to start the lesson.
	:
}

mac_keyboard_test() {
	_tutr_nonce && return $PASS
	_tutr_generic_test -c true
}

mac_keyboard_hint() {
	cat <<-:

	Use 'tutor hint' to review the instructions about this setting.

	Run 'true' to acknowledge that you are ready to start.
	:
}


# 0. echo disorganized.txt
echo_1_prologue() {
	cat <<-:
	In this directory are some text files with long, unhelpful names.
	You can use 'ls' to see them.

	Together these files form a text-art picture.  You could use the 'cat'
	command to display their contents all at once, but it isn't clear from
	their names which is the right order to print them.  Over the course of
	this lesson you'll figure out which order the files should be printed.

	The thought of typing all of their names over and over again into the
	shell might feel like a huge, boring task.  You'll learn a few tricks
	that let you put a big command line together quickly.

	We'll begin by simply printing the name of one of the files.  Run
	  'echo disorganized.txt'
	:
}

echo_1_test() {
	_tutr_nonce && return $PASS
	_tutr_generic_test -c echo -d "$_BASE" -a disorganized.txt
}

echo_1_hint() {
	_tutr_generic_hint $1 echo "$_BASE"

	cat <<-:
	  'echo disorganized.txt'
	:
}


# 1. echo disorganized.txt combinatorially.txt
echo_2_prologue() {
	cat <<-:
	Do that again, but with one more file name this time:
	  'echo disorganized.txt combinatorially.txt'
	:
}

echo_2_test() {
	_tutr_nonce && return $PASS
	_tutr_generic_test -c echo -d "$_BASE" -a disorganized.txt -a combinatorially.txt
}

echo_2_post() {
	_PREV=${_CMD[@]}
}

echo_2_hint() {
	_tutr_generic_hint $1 echo "$_BASE"
	cat <<-:

	  'echo disorganized.txt combinatorially.txt'
	:
}

echo_2_epilogue() {
	cat <<-:
	Phew!  That was a lot of typing!  There are still six more files to get
	through, and you don't even know in what order they go.  If this is what
	using the command line is like, you must be wondering why anybody puts
	up with it!

	Never fear, it's about to get *much* easier.

	:
	_tutr_pressanykey
}




history_echo_cat_pre() {
	shortcuts() {
		cat <<-:
		Shortcut | Action
		---------|----------------------------------------------
		  Up     | Bring up older commands from history
		  Down   | Bring up newer commands from history
		  Left   | Move cursor BACKWARD one character
		  Right  | Move cursor FORWARD one character
		$_BACKSPACE
		:
	}
}

# 2. use Up + ^A to change 'echo' into 'cat'
history_echo_cat_prologue() {
	cat <<-:
	For this step I want you to re-run the previous command, but with one
	small difference: instead of 'echo' you will use 'cat'.

	You do not need to re-type that whole command line.  The shell remembers
	your commands and can bring them back for you.

	The first shortcuts to learn are the ARROW keys (the same ones you use
	for games).

	Shortcut | Action
	---------|----------------------------------------------
	  Up     | Bring up older commands from history
	  Down   | Bring up newer commands from history
	  Left   | Move cursor BACKWARD one character
	  Right  | Move cursor FORWARD one character
	$_BACKSPACE

	You can see this table whenever you want by running a command called
	'shortcuts'.  I'll update it with new shortcuts as the lesson goes on.

	Using these shortcuts, find your last command
	  '$_PREV'
	and change the word 'echo' into 'cat'.
	:
}

history_echo_cat_post() {
	_PREV=${_CMD[@]}
}

history_echo_cat_test() {
	_tutr_nonce shortcuts && return $PASS
	_tutr_generic_test -c cat -d "$_BASE" -a disorganized.txt -a combinatorially.txt
}

history_echo_cat_hint() {
	_tutr_generic_hint $1 cat "$_BASE"

	cat <<-:

	Using these shortcuts, find your last command
	  '$_PREV'
	and change the word 'echo' into 'cat'.
	:
}

history_echo_cat_epilogue() {
	_tutr_pressanykey

	cat <<-:
	That worked!  But that picture isn't quite complete...

	If you tried to use the mouse to move your cursor to the beginning of
	the line you will have noticed that didn't work.  You must rely entirely
	on the keyboard to control the cursor.  This is due, in part, to the
	fact that mice weren't widespread when terminals were developed.

	It remains true today because there are better ways to move the cursor
	than taking your hands away from the keyboard and pointing and clicking
	with another device.

	:
	_tutr_pressanykey
}


ctrl_a_pre() {
	shortcuts() {
		cat <<-:
		Shortcut | Action
		---------|----------------------------------------------
		  Up     | Bring up older commands from history
		  Down   | Bring up newer commands from history
		  Left   | Move cursor BACKWARD one character
		  Right  | Move cursor FORWARD one character
		$_BACKSPACE
		  ^A     | Move cursor to BEGINNING of line
		  ^E     | Move cursor to END of line
		  M-B    | Move cursor BACKWARD one whole word
		  M-F    | Move cursor FORWARD one whole word
		:
	}
}

# 3. Use ^A, M-B, M-F to insert reorganization.txt before disorganized.txt
ctrl_a_prologue() {
	if [[ $_MACOSX = true ]]; then
		cat <<-:
		Using the arrow keys to move the cursor takes much too long when you are
		writing a long command line.  You can use these shortcuts instead:

		Shortcut | Action
		---------|----------------------------------------------
		   ^A  * | Move cursor to BEGINNING of line
		   ^E    | Move cursor to END of line
		   M-B **| Move cursor BACKWARD one whole word
		   M-F   | Move cursor FORWARD one whole word

		*  The caret '^' stands for the "Control" key
		   '^A' means "Press Control + A".
		   Some documentation abbreviates "Control" as 'C-'

		** 'M' represents the "Option" key
		   'M' is an abbreviation for "Meta"
		   'M-B' means "Press Option + B"

		Use these shortcuts to move your cursor within the command line
		  '$_PREV'

		Insert the filename 'reorganization.txt' in front of 'disorganized.txt'
		:
	else
		cat <<-:
		Using the arrow keys to move the cursor takes much too long when you are
		writing a long command line.  You can use these shortcuts instead:

		Shortcut | Action
		---------|----------------------------------------------
		   ^A  * | Move cursor to BEGINNING of line
		   ^E    | Move cursor to END of line
		   M-B **| Move cursor BACKWARD one whole word
		   M-F   | Move cursor FORWARD one whole word

		*  The caret '^' stands for the "Control" key
		   '^A' means "Press Control + A".
		   Some documentation abbreviates "Control" as 'C-'

		** 'M' represents the "Alt" key
		   'M' is an abbreviation for "Meta"
		   'M-B' means "Press Alt + B"

		Use these shortcuts to move your cursor within the command line
		  '$_PREV'

		Insert the filename 'reorganization.txt' in front of 'disorganized.txt'
		:
	fi
}

ctrl_a_post() {
	_PREV=${_CMD[@]}
}

ctrl_a_test() {
	_tutr_nonce shortcuts && return $PASS
	_tutr_generic_test -c cat -d "$_BASE" -a reorganization.txt -a disorganized.txt -a combinatorially.txt
}

ctrl_a_hint() {
	_tutr_generic_hint $1 cat "$_BASE"

	cat <<-:

	Insert the filename 'reorganization.txt' in front of 'disorganized.txt'
	in the command line
	  '$_PREV'
	:
}

ctrl_a_epilogue() {
	_tutr_pressanykey
	cat <<-:

	That picture is getting there...

	The '^' and 'M-" notation is a little funny, but you need to learn it
	because you'll encounter it in error messages, help files and other
	documentation.
	:

	if [[ $_MACOSX = true ]]; then
		cat <<-:
		Why does the shell call the 'Option' key 'Meta' when your keyboard
		doesn't have any such key?

		Your keyboard follows the layout Apple established for their
		personal computers in 1983.  The mainframes that the Unix command
		shell was created for on weren't made by Apple, nor were they
		"personal" computers.  The keys surrounding their spacebar were
		labeled 'Meta' and served a similar purpose to Apple's 'Option' key.

		Apple keyboards have both a "Control" key and a "Command" key, and
		the shell distinguishes between them.  These shortcuts denoted by
		'^' use the Control key:

		Shortcut | Shell Line Editor Action
		---------|---------------------------------------------
		   ^Z    | Put a process to sleep
		   ^X    | Begin chorded command & wait for another key
		   ^C    | Cancel (Terminate) a running process
		   ^V    | Verbatim; next keystroke is taken literally

		:

		_tutr_pressanykey

		cat <<-:

		Incidentally, the Command key shortcuts you learned on the Desktop
		still work as you expect in the shell.  Specifically, these combos
		do what you expect:

		Shortcut    | Action
		------------|-------
		   CMD+Z    | Undo
		   CMD+X    | Cut
		   CMD+C    | Copy
		   CMD+V    | Paste

		:
	else
		cat <<-:
		Why does the shell call the 'Alt' key 'Meta' when your keyboard
		doesn't have any such key?

		The keyboard you're using now follows the layout IBM established
		for their Personal Computers in 1981.  The mainframes that the Unix
		command shell was created for on weren't made by IBM, nor were they
		"personal" computers.  The keys surrounding their spacebar were
		labeled 'Meta' and served a similar purpose to IBM's 'Alt' key.

		Incidentally, the keyboard shortcuts you learned on the Desktop
		don't work as you would think in the shell.  Specifically, these
		keystrokes won't do what you expect:

		Shortcut | IBM-PC Action | Shell Line Editor Action
		---------|---------------|---------------------------------------------
		   ^Z    | Undo          | Put a process to sleep
		   ^X    | Cut           | Begin chorded command & wait for another key
		   ^C    | Copy          | Cancel (Terminate) a running process
		   ^V    | Paste         | Verbatim; next keystroke is taken literally

		:
	fi

	_tutr_pressanykey
}


ctrl_c_pre() {
	shortcuts() {
		cat <<-:
		Shortcut | Action
		---------|----------------------------------------------
		  Up     | Bring up older commands from history
		  Down   | Bring up newer commands from history
		  Left   | Move cursor BACKWARD one character
		  Right  | Move cursor FORWARD one character
		$_BACKSPACE
		  ^A     | Move cursor to BEGINNING of line
		  ^E     | Move cursor to END of line
		  M-B    | Move cursor BACKWARD one whole word
		  M-F    | Move cursor FORWARD one whole word
		  ^C     | Cancel (terminate) the currently running process
		:
	}
}


# 4. Cancel runaway processes with ^C
ctrl_c_prologue() {
	cat <<-:
	Why not practice using ^C right now?

	Run the command 'sleep 3600', which will pause the shell for an hour.
	Instead of waiting for the clock to run out, use ^C to stop it now.
	:
}

ctrl_c_test() {
	_tutr_nonce shortcuts && return $PASS
	if [[ ${_CMD[0]} == 'sleep' ]]; then
		(( ${#_CMD[@]} < 2 )) && return $TOO_FEW_ARGS
		(( $_RES == 0 )) && return 98
		(( ${_CMD[1]} < 100 )) && return 99
		return 0
	fi
	return $WRONG_CMD
}


ctrl_c_hint() {
	case $1 in
		99)
			echo ${_CMD[@]}
			echo "C'mon, you can let it sleep longer than that."
			echo "Go crazy and pick a really big number!"
			;;
		98)
			cat <<-:
			Did you really wait around for ${_CMD[1]} seconds just to
			see what would happen?  You must be so disappointed.
			:
			;;
		*)
			_tutr_generic_hint $1 sleep "$_BASE"
			;;
	esac

	cat <<-:

	Run 'sleep 3600' to pause the shell for an hour.
	Instead of waiting for the clock to run out, use ^C to stop it now.

	:
}

ctrl_c_epilogue() {
	cat <<-:
	Excellent!

	We've all written our share of infinite loops.  When one of your
	programs "gets away" from you, remember that ^C will "cancel" it.

	:
	_tutr_pressanykey
}




## Unused b/c Bash and Zsh each have a different notion of word boundary
transpose_pre() {
	shortcuts() {
		cat <<-:
		Shortcut | Action
		---------|----------------------------------------------
		  Up     | Bring up older commands from history
		  Down   | Bring up newer commands from history
		  Left   | Move cursor BACKWARD one character
		  Right  | Move cursor FORWARD one character
		$_BACKSPACE
		  ^A     | Move cursor to BEGINNING of line
		  ^E     | Move cursor to END of line
		  M-B    | Move cursor BACKWARD one whole word
		  M-F    | Move cursor FORWARD one whole word
		  ^C     | Cancel (terminate) the currently running process
		  M-T    | Transpose (swap) two adjacent words
		:
	}
}

# 5. use Up + M-T to swap combinatorially.txt disorganized.txt
transpose_prologue() {
	cat <<-:
	Two of the files in your command, 'combinatorially.txt' and
	'disorganized.txt', are in the wrong order.  But you can fix this without
	needing to re-type the entire command line.  The shell's line editor has a
	shortcut to swap two adjacent words.

	Shortcut | Action
	---------|----------------------------------------------
	  M-T    | Transpose (swap) two adjacent words

	Use the Up arrow to bring back the last relevant command, which should be
	  '$_PREV'

	Then, with the cursor on (or after) the word 'disorganized.txt',
	press 'M-T' to TRANSPOSE it with the word behind it.
	:
}

transpose_post() {
	_PREV=${_CMD[@]}
}

transpose_test() {
	_tutr_nonce shortcuts && return $PASS
	[[ ${_CMD[@]} == 'cat reorganization.txt disorganized.txt combinatorially.txt' ]] && return 0
	return $WRONG_CMD
}

transpose_hint() {
	_tutr_generic_hint $1 cat "$_BASE"
}



tab_pre() {
	shortcuts() {
		cat <<-:
		Shortcut | Action
		---------|----------------------------------------------
		  Up     | Bring up older commands from history
		  Down   | Bring up newer commands from history
		  Left   | Move cursor BACKWARD one character
		  Right  | Move cursor FORWARD one character
		$_BACKSPACE
		  ^A     | Move cursor to BEGINNING of line
		  ^E     | Move cursor to END of line
		  M-B    | Move cursor BACKWARD one whole word
		  M-F    | Move cursor FORWARD one whole word
		  ^C     | Cancel (terminate) the currently running process
		  TAB    | Complete the command or filename at cursor
		:
	}
}

# 6. Up + Tab to add 'sequentializing.txt', 'obfuscatory.txt' to the FRONT of the cmdline
tab_prologue() {
	cat <<-:
	These shortcuts are great, but you're still doing too much typing.

	Your phone and web browser are able to figure out what you're trying to
	say and finish your words for you.  Your IDE has code completion.  These
	21st century innovations are great time-savers.  Oh, did I say 21st
	century?  I meant 20th century.  Command shells have been doing this
	since the early 90's.

	From now on, all you'll ever need to type are first few characters of a
	file's name followed by TAB.  If the shell can find a file whose name
	begins with that sequence of characters it will finish it for you.

	Shortcut | Action
	---------|----------------------------------------------
	  TAB    | Complete the command or filename at cursor

	Try it now.  Add the filenames 'sequentializing.txt' and
	'obfuscatory.txt' right between the words 'cat' and 'reorganization.txt'
	in your previous command:
	  '$_PREV'

	Just type 'se' and press TAB and the shell will fill in
	'quentializing.txt'.  In just two keystrokes, 'o' + TAB, you can write
	'obfuscatory.txt'.

	If TAB doesn't work for you, try adding some extra spaces between the
	command 'cat' and the next argument, such that your cursor isn't on a
	blank space.
	:
}

tab_post() {
	_PREV=${_CMD[@]}
}

tab_test() {
	_tutr_nonce shortcuts && return $PASS
	_tutr_generic_test -c cat -d "$_BASE" -a sequentializing.txt -a obfuscatory.txt -a reorganization.txt -a disorganized.txt -a combinatorially.txt
}

tab_hint() {
	_tutr_generic_hint $1 cat "$_BASE"

	cat <<-:
	The command you are trying to write looks like this:
	  'cat sequentializing.txt obfuscatory.txt reorganization.txt disorganized.txt combinatorially.txt'
	:
}

tab_epilogue() {
	_tutr_pressanykey
	cat <<-:

	One little problem with TAB completion occurs when multiple file names
	begin with the same characters.  Because the shell can't read your mind
	it will complete as much as it can based on what you typed and then
	display the remaining matches.  Then it waits for you to type a little
	bit more to narrow its choices.  Eventually you will narrow things down
	to a single match.

	In some shells you must hit TAB twice to trigger this.

	When you hit TAB several times and still don't get anywhere it means
	that nothing matches.  You likely have a typo in your command line.
	Delete part of the word the cursor is on and hit TAB again to see what
	choices the shell finds.

	:
	_tutr_pressanykey
}

cutpaste_words_pre() {
	shortcuts() {
		cat <<-:
		Shortcut | Action
		---------|----------------------------------------------
		  Up     | Bring up older commands from history
		  Down   | Bring up newer commands from history
		  Left   | Move cursor BACKWARD one character
		  Right  | Move cursor FORWARD one character
		$_BACKSPACE
		  ^A     | Move cursor to BEGINNING of line
		  ^E     | Move cursor to END of line
		  M-B    | Move cursor BACKWARD one whole word
		  M-F    | Move cursor FORWARD one whole word
		  ^C     | Cancel (terminate) the currently running process
		  TAB    | Complete the command or filename at cursor
		  ^W     | Cut BACKWARD from cursor to beginning of word
		  ^K     | Cut FORWARD from cursor to end of line (kill)
		  ^Y     | Yank (paste) text to the RIGHT the cursor
		:
	}
}


# 7. M-B + M-F to move by words - ^W remove disorganized.txt, ^E goto end and ^Y to paste it there
cutpaste_words_prologue() {
	cat <<-:
	The picture is getting bigger, but it looks like the top part needs to
	move to the bottom.  What this calls for is some cut & paste.

	Instead of selecting text with the mouse and hitting ^X to cut it out,
	the line editor "kills" text from the point of the cursor.  Different
	shortcuts kill different amounts of text in different directions.

	Just like a desktop word processor the "killed" (cut) text is stored in
	the "yank buffer" (clipboard) and can be "yanked" (pasted) later.

	Shortcut | Action
	---------|----------------------------------------------
	  ^W     | Cut BACKWARD from cursor to beginning of word
	  ^K     | Cut FORWARD from cursor to end of line (kill)
	  ^Y     | Yank (paste) text to the RIGHT the cursor

	Remember, you can run 'shortcuts' to see the complete table at any time.

	Use these commands to make the old command line
	  '$_PREV'

	look like this:
	  'cat reorganization.txt disorganized.txt combinatorially.txt sequentializing.txt obfuscatory.txt'
	:
}

cutpaste_words_post() {
	_PREV=${_CMD[@]}
	_CMD=()
}

cutpaste_words_test() {
	_tutr_nonce shortcuts && return $PASS
	_tutr_generic_test -c cat -d "$_BASE" -a reorganization.txt -a disorganized.txt -a combinatorially.txt -a sequentializing.txt -a obfuscatory.txt
}

cutpaste_words_hint() {
	_tutr_generic_hint $1 cat "$_BASE"
	cat <<-:

	Make the old command line
	  '$_PREV'
	Look like this:
	  'cat reorganization.txt disorganized.txt combinatorially.txt sequentializing.txt obfuscatory.txt'
	:
}

cutpaste_words_epilogue() {
	_tutr_pressanykey
}


clear_pre() {
	shortcuts() {
		cat <<-:
		Shortcut | Action
		---------|-----------------------------------------------
		  Up     | Bring up older commands from history
		  Down   | Bring up newer commands from history
		  Left   | Move cursor BACKWARD one character
		  Right  | Move cursor FORWARD one character
		$_BACKSPACE
		  ^A     | Move cursor to BEGINNING of line
		  ^E     | Move cursor to END of line
		  M-B    | Move cursor BACKWARD one whole word
		  M-F    | Move cursor FORWARD one whole word
		  ^C     | Cancel (terminate) the currently running process
		  TAB    | Complete the command or filename at cursor
		  ^W     | Cut BACKWARD from cursor to beginning of word
		  ^K     | Cut FORWARD from cursor to end of line (kill)
		  ^Y     | Yank (paste) text to the RIGHT the cursor
		  ^L     | Clear the screen while preserving command line
		:
	}
}

# 8. clear the screen and leave command prompt intact with ^L
clear_prologue() {
	cat <<-:
	You're almost there!

	You're putting a lot of text on the screen, and that can be over-
	whelming.  In the last lesson you learned that 'clear' cleans up the
	screen and puts the prompt back up at the top.  The shortcut ^L does
	that same thing AND keeps the command you're writing in the prompt.

	Shortcut | Action
	---------|-----------------------------------------------
	  ^L     | Clear the screen while preserving command line

	This way you can clear the screen without throwing away your edits.

	Use the Up arrow to find your last command line
	  '$_PREV'
	and use ^L to clean up the screen.  Then re-run that command to proceed.
	:
}

clear_test() {
	[[ ${_CMD[0]} == clear ]] && return 99
	_tutr_nonce shortcuts && return $PASS
	_tutr_generic_test -c cat -d "$_BASE" -a reorganization.txt -a disorganized.txt -a combinatorially.txt -a sequentializing.txt -a obfuscatory.txt
}

clear_hint() {
	case $1 in
		99)
			echo "Use ^L - it's only 2 keystrokes instead of the 6 needed for 'clear'"
			;;
		*)
			_tutr_generic_hint $1 cat "$_BASE"
			;;
	esac
	cat <<-:

	Use the Up arrow to find your last command line
	  '$_PREV'
	and use ^L to clean up the screen.  Re-run that command to proceed.

	:
}

clear_epilogue() {
	_tutr_pressanykey
}


cut_line_pre() {
	shortcuts() {
		cat <<-:
		Shortcut | Action
		---------|-----------------------------------------------
		  Up     | Bring up older commands from history
		  Down   | Bring up newer commands from history
		  Left   | Move cursor BACKWARD one character
		  Right  | Move cursor FORWARD one character
		$_BACKSPACE
		  ^A     | Move cursor to BEGINNING of line
		  ^E     | Move cursor to END of line
		  M-B    | Move cursor BACKWARD one whole word
		  M-F    | Move cursor FORWARD one whole word
		  ^C     | Cancel (terminate) the currently running process
		  TAB    | Complete the command or filename at cursor
		  ^W     | Cut BACKWARD from cursor to beginning of word
		  ^K     | Cut FORWARD from cursor to end of line (kill)
		  ^Y     | Yank (paste) text to the RIGHT the cursor
		  ^L     | Clear the screen while preserving command line
		  ^U     | Cut the entire command line
		:
	}

	if [[ -n $ZSH_NAME ]]; then
		export _SH=Zsh
	else
		export _SH=Bash
	fi
}

# 9. ^U to cut the whole cmdline, run 'ls', ^Y to paste it back
#	cat painstakingly.txt nonsequential.txt fragmentary.txt reorganization.txt
#	disorganized.txt combinatorially.txt sequentializing.txt obfuscatory.txt
cut_line_prologue() {
	cat <<-:
	Awesome!

	There is one more trick I want to teach you.  Sometimes when you're in
	the middle of editing a command you really do need to set it aside for a
	moment to run something else.  Perhaps you need to 'ls' to learn the
	name of a file you need.

	Shortcut | Action
	---------|----------------------------------------------
	  ^U     | Cut the entire command line

	:
	if [[ $_SH = Zsh ]]; then
		cat <<-:
		^U cuts the entire command line into the yank buffer REGARDLESS of
		where the cursor is.  You can then run as many commands as you want
		before restoring the original command from the yank buffer with ^Y.

		Why don't you try this trick out?

		Hit the Up arrow to bring back your big command, move the cursor to
		somewhere in the middle, then use ^U to "kill" it into the yank buffer.
		:
	else
		cat <<-:
		^U cuts from the position of the cursor BACK to the beginning of the
		command line, storing the cut text into yank buffer.  You can then
		run as many commands as you want before restoring the original
		command from the yank buffer with ^Y.

		Why don't you try this trick out?

		Hit the Up arrow to bring back your big command, and with the cursor
		at the end, use ^U to "kill" it into the yank buffer.
		:
	fi

	echo
	echo "Then run 'ls' to proceed"
}

cut_line_test() {
	_tutr_generic_test -c ls -d "$_BASE"
}

cut_line_hint() {
	_tutr_generic_hint $1 ls "$_BASE"
}


paste_line_prologue() {
	cat <<-:
	Now yank your big command back into the command line with ^Y and run it.
	:
}

paste_line_test() {
	_tutr_nonce shortcuts && return $PASS
	_tutr_generic_test -c cat -d "$_BASE" -a reorganization.txt -a disorganized.txt -a combinatorially.txt -a sequentializing.txt -a obfuscatory.txt
}

paste_line_hint() {
	_tutr_generic_hint $1 cat "$_BASE"

	cat <<-:

	Yank your big command back into the command line with ^Y and run it.

	Just in case you lost it, the command you want to run is
	  cat reorganization.txt disorganized.txt combinatorially.txt sequentializing.txt obfuscatory.txt
	:
}

paste_line_epilogue() {
	_tutr_pressanykey
}



finish_prologue() {
	cat <<-:
	That's pretty slick!  Now you know how to use the shell's line editor
	like a pro.  This was a lot of new knowledge to throw on you all at
	once, but you handled it like a champ!

	The key to remembering these shortcuts is to use them often.  Pick one
	or two to practice and intentionally use them frequently as you work.
	If you catch yourself doing something "the old way", start over and use
	the new shortcut.  After a day or two of this regimen they become muscle
	memory.

	You'll know you've arrived when you catch yourself using ^W to erase
	words and ^L to clear the screen in other applications!

	You're almost done with the puzzle.  Take a look at the names of the
	other files in this directory and complete the picture.  The lesson will
	finish when you 'cat' all of the files in the correct order.  With your
	new tricks you will be able to do this quite easily.

	You can always run 'shortcuts' to review the new line editor tricks you
	learned today.
	:
}

finish_test() {
	_tutr_nonce shortcuts && return $PASS
	_tutr_generic_test -c cat -d "$_BASE" -a painstakingly.txt -a nonsequential.txt -a fragmentary.txt -a reorganization.txt -a disorganized.txt -a combinatorially.txt -a sequentializing.txt -a obfuscatory.txt
}


finish_hint() {
	_tutr_generic_hint $1 cat "$_BASE"
}

finish_epilogue() {
	cat <<-:

	That's it!  You did it!

	:
	_tutr_pressanykey
}

_STEPS=(
	echo_1
	echo_2
	history_echo_cat
	ctrl_a
	ctrl_c
	tab
	cutpaste_words
	clear
	cut_line
	paste_line
	finish
	)

if [[ $_MACOSX = true ]]; then
	_STEPS=(mac_keyboard ${_STEPS[@]})
fi


# Source _tutr.sh and begin the tutorial
# _tutr_begin takes as arguments the names of each skill in the order that the
# user will experience them.
source _tutr/main.sh && _tutr_begin ${_STEPS[@]}



# vim: set filetype=sh noexpandtab tabstop=4 shiftwidth=4 textwidth=76 colorcolumn=76:
