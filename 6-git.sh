#!/bin/sh

_HELP="
Lesson #6 Topics
================
* Prepare git on your computer
* Ask git for help about its commands
* Clone a git repository onto your computer
* Check the status of your repository
* Change a file and commit it to the repository
* View the git log
* Submit your homework to GitLab

Commands used in this lesson
============================
* git
* cd
* nano
"

source _tutr/record.sh
if [[ -n $_TUTR ]]; then
	source _tutr/generic_error.sh
	source _tutr/nonce.sh
fi

README_HSH="87b82604ede8525357ad65f2500d456f66ba8adf"
# Git commit ID as given by `git rev-parse --short HEAD`
STARTER="c92dea7"


repo_warning() {
	cat <<-:
	The git repository 'cs1440-falor-erik-assn0' already exists in the
	parent directory.  This lesson involves setting that repository up,
	and so it must not exist before beginning.

	If you have already begun Assignment #0 you may not wish to delete your
	work.  In that case, it's probably best to not re-run this lesson.

	If you are okay starting over, you can simply use 'rm -rf' to delete the
	directory 'cs1440-falor-erik-assn0' and everything in it.  From here you
	can run this command:
	  rm -rf ../cs1440-falor-erik-assn0

    Otherwise, you can rename the directory with the 'mv [OLD] [NEW]' command.
    After either moving the directory or removing it, this lesson can then be
    completed.

	If you are just looking for a quick git refresher, please refer to the
	instructions in the course lecture notes online.
	:
}


cleanup() {
	# Remember that this lesson has been completed
	if (( $# >= 1 && $1 == $_COMPLETE)); then
		_tutr_record_completion ${_TUTR#./}
	fi
	echo "You worked on Lesson #6 for $(_tutr_pretty_time)"
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

	export _OS=$(uname -s)
	[[ $_OS = MINGW* ]] && _OS=Windows_NT

	export _BASE=$PWD
	# Because I can't count on GNU Coreutils realpath(1) or readlink(1) on
	# all systems
	export _PARENT=$(cd .. && pwd)
	export _REPO=$_PARENT/cs1440-falor-erik-assn0

	# See if the starter code repo already exists
	if [[ -d "$_REPO/.git" ]]; then
		_tutr_err repo_warning
		return 1
	fi
}


prologue() {
	[[ -z $DEBUG ]] && clear
	cat <<-PROLOGUE

	Shell Lesson #6: The Git Version Control System

	In this lesson you will learn how to

	* Prepare git on your computer
	* Ask git for help about its commands
	* Clone a git repository onto your computer
	* Check the status of your repository
	* Change a file and commit it to the repository
	* View the git log
	* Submit your homework to GitLab

	Let's get started!

	PROLOGUE

	_tutr_pressanykey
}


epilogue() {
	cat <<-EPILOGUE

	In this lesson you have learned how to

	* Prepare git on your computer
	* Ask git for help about its commands
	* Clone a git repository onto your computer
	* Check the status of your repository
	* Change a file and commit it to the repository
	* View the git log
	* Submit your homework to GitLab

	That was the last lesson!  w00t!

	You have joined the ranks of the 1337 Unix h4X0rZ!  Congratulations!
	Now don't go and do something that makes the NSA pay attention to you.

	If you are enrolled in CS 1440 you can now run './make-certificate.sh'
	to make a completion certificate to submit on Canvas.

	EPILOGUE

	_tutr_pressanykey
}



# 0. Learn about the 'help' command
git_help_prologue() {
	cat <<-:
	Git is a system of programs that manage a REPOSITORY of source code.

	Wh-what does that mean?  Patience, and it will all make sense.

	You don't know it yet, but Git will become one of your best friends as
	you write code.  Git has a bit of a... reputation... for not being very
	easy to learn.

	We'll take things nice and slow.

	:

	_tutr_pressanykey

	cat <<-:

	To keep things simple, everything that you do with Git happens with the
	'git' command.

	The first argument to the 'git' command is the name of a "subcommand".
	After the subcommand you may give other arguments to complete the
	command.  The syntax is:

	  git SUBCOMMAND [arguments...]

	To get you started with git I will teach you [1;7m10[0m subcommands.  Later in
	the semester when you are comfortable I will add more subcommands to
	your repertoire.

	The most important subcommand is 'help'.  If you forget everything else
	you know about git, you can figure it out again with this subcommand.

	Run 'git help' now.
	:
}

git_help_test() {
	_tutr_generic_test -c git -a help
}

git_help_hint() {
	_tutr_generic_hint $1 git

	echo "Run 'git help' to proceed"
}

git_help_epilogue() {
	_tutr_pressanykey
	cat <<-':'
	                                                         _
	Phew!  That's a lot of help!                            ( |
	                                                      ___\ \
	It's okay if that seems overwhelming right now.      (__()  `-|
	Soon, much of that will make complete sense to you.  (___()   |
	                                                     (__()    |
	Trust me!                                            (_()__.--|
	
	:
	_tutr_pressanykey
}



# 1. practice getting help
git_help_help_prologue() {
	cat <<-:
	'git help' shows a small sampling of possible subcommands that git can
	run, but it doesn't tell you HOW to use them.  You can obtain detailed
	help about a specific subcommand by giving 'git help' that subcommand's
	name as an argument.

	:

	if [[ $_OS = Windows_NT ]]; then
		cat <<-:
		Since you are on Windows, git may display the subcommand's manual page
		in your browser instead of the console.

		If nothing appears in your console, just wait a bit longer for your
		browser to pop up.

		Otherwise, the information will be presented just like a man page.
		As before, use 'q' to quit the man page viewer.
		
		:
	else
		cat <<-:
		That subcommand's manual page will appear in the terminal, just the same
		as the other manual pages you've read previously.  As before, use 'q' to
		quit the man page viewer.
		:
	fi

	cat <<-:

	Begin by viewing the manual for the 'git help' subcommand:
	  git help help
	:

}

git_help_help_test() {
	_tutr_generic_test -c git -a help -a help
}

git_help_help_hint() {
	_tutr_generic_hint $1 git

	cat <<-:

	Read the help for git's 'help' subcommand:
	  git help help
	:
	if [[ $_OS = Windows_NT ]]; then
		cat <<-:

		This command may open git's 'help' page in your browser instead of
		the console.
		:
	fi
}

git_help_help_epilogue() {
	cat <<-:
	[1;7mGit subcommand 1/10: 'help'[0m

	Whenever you are unsure how to use a git subcommand, remember to run
	  git help SUBCOMMAND
	to learn how to use it.

	Now let's begin in earnest!

	:
	_tutr_pressanykey
}



# 2.  Launch a command shell and use the `git config` command to set up your
# 	  user name and email address.
git_config_pre() {
	git config --get user.name >/dev/null
	_HAS_NAME=$?
	git config --get user.email >/dev/null
	_HAS_EMAIL=$?

	if (( _HAS_NAME == 0 && _HAS_EMAIL == 0 )); then

		printf "\x1b[1;32mTutor\x1b[0m: Git knows your name and email address, which means that\n"
		printf "\x1b[1;32mTutor\x1b[0m: you already know about the 'git config' subcommand.\n"
		printf "\x1b[1;32mTutor\x1b[0m:\n"
		printf "\x1b[1;32mTutor\x1b[0m: This isn't your first time at the rodeo, is it?\n"
		printf "\x1b[1;32mTutor\x1b[0m:\n"
		printf "\x1b[1;32mTutor\x1b[0m: Anyhow, I think you've earned this:\n"
		printf "\x1b[1;32mTutor\x1b[0m:\n"
		printf "\x1b[1;32mTutor\x1b[0m: [1;7mGit subcommand 2/10: 'config'[0m\n"
		printf "\x1b[1;32mTutor\x1b[0m:\n"

		_tutr_pressanykey
	fi
}

git_config_prologue() {
	cat <<-:
	Use the 'git config' command to set up your name and email address.
	Git needs to know who you are so that when you make commits it can
	record who was responsible.

	The command to set your user name is like this:
      git config --global user.name  "Danny Boy"

	And the command for your email goes like:
      git config --global user.email "danny.boy@houseofpain.com"

	Of course, use your own name and email address.
	:
}

git_config_test() {
	git config --get user.name >/dev/null
	_HAS_NAME=$?
	git config --get user.email >/dev/null
	_HAS_EMAIL=$?

	if   [[ ${_CMD[0]} = git && ${_CMD[1]} = config && ${_CMD[@]} != *--global* ]]; then return 97
	elif (( $_HAS_NAME == 0 && $_HAS_EMAIL == 0 )); then return 0
	elif (( $_HAS_NAME == 0 )); then return 99
	elif (( $_HAS_EMAIL == 0 )); then return 98
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = config ]]; then return 96
	else _tutr_generic_test -c git -a config -d "$_BASE"
	fi
}

git_config_hint() {
	case $1 in
		99)
			cat <<-:
			Good!  Now set your email address under the 'user.email' setting.
			:
			;;

		98)
			cat <<-:
			Almost there!  Now configure your name in the 'user.name' setting.
			:
			;;

		97)
			cat <<-:
			The '--global' option to the 'git config' command is important
			because it records that setting across your entire computer.

			Without it, you'll need to run 'git config' every time you
			create a new git repository.  And that's just a lot of
			unnecessary work.

			Try that command again, but add '--global' right after
			'git config' and before the name of the setting.
			:
			;;

		96)
			cat <<-:
			The commands you must use look like this:
			  git config --global user.name  "Danny Boy"
			  git config --global user.email "danny.boy@houseofpain.com"

			Of course, you should use your own name and email address.
			:
			;;

		*)
			_tutr_generic_hint $1 git_config "$_BASE"
			;;
	esac
}

git_config_epilogue() {
	cat <<-:
	[1;7mGit subcommand 2/10: 'config'[0m

	Because you gave 'git config' the '--global' option you will not need to
	perform this step in the future.  From now on, 'git' on this computer
	knows who you are.

	If you made a typo when entering your name and email, or want to change
	them, you may do so at any time.  You'll just use these same commands
	again.

	If you install git on another computer, it will remind you to perform
	this set up routine when you try to use git.

	:
	_tutr_pressanykey
}



# 3. see if we're presently within a git repo
git_status0_prologue() {
	cat <<-:
	One of the most important aspects of git is that it facilitates sharing
	your project with other programmers.  Git has been called "a social
	network for code".

	There are three key concepts related to sharing projects:

	*   The directory of files which make up a project and is managed by git
	    is called a [1;7mrepository[0m (or "repo" for short)
	*   [1;7mcloning[0m downloads a git repository onto your computer
	*   [1;7mpushing[0m uploads your repository to another computer

	You've already cloned at least one repository; that's how this shell
	tutorial came to be on your computer.  In a moment you are going to
	clone another repository from the internet.

	Before you clone a repository it is wise to ensure that your shell's CWD
	is NOT already inside a git repository.  Things get confusing really
	quick when a git repository is nested within another.

	The 'git status' subcommand reports information about repositories.

	*   When this command succeeds it means that your shell's CWD is in a
	    repository.
	*   When this command fails it typically means that your are NOT
	    presently in a repository.

	Run 'git status' to see which is the case for you.
	:
}

git_status0_test() {
	_tutr_generic_test -i -c git -a status -d "$_BASE"
}

git_status0_hint() {
	_tutr_generic_hint $1 git "$_BASE"
	cat <<-:

	Run 'git status'
	:
}

git_status0_epilogue() {
	_tutr_pressanykey

	if (( $_RES == 0 )); then
		cat <<-:
		This message indicates that you are presently in a repository.

		:
	else
		cat <<-:
		Huh, it looks like you're not in a repository right now.
		That's unexpected, but not a problem.

		:
	fi

	cat <<-:
	[1;7mGit subcommand 3/10: 'status'[0m

	:
	_tutr_pressanykey
}



# 4. cd .. to escape this git repository
cd_dotdot0_prologue() {
	echo Go up and out of this directory.
}

cd_dotdot0_test() {
	if   [[ $PWD = $_PARENT ]]; then return 0
	else _tutr_generic_test -c cd -a .. -d "$_PARENT"
	fi
}

cd_dotdot0_hint() {
	_tutr_generic_hint $1 cd "$_PARENT"

	cat <<-:

	Run 'cd ..' to leave this directory for its parent.
	:
}



# 5.  Ensure that you're not presently within a git repository by running `git status`.
git_status1_prologue() {
	cat <<-:
	You are now in the parent directory of the shell tutorial repository.
	But what if this directory is also a git repository?  You had better run
	'git status' to find out.

	When 'git status' is used outside of a repository it reports a "fatal"
	error.  Usually one wishes to avoid "fatal" errors, but in this case
	an error message is good news.
	:
}

git_status1_test() {
	_tutr_generic_test -f -c git -a status -d "$_PARENT"
}

git_status1_hint() {
	[[ -n $DEBUG ]] && echo "_test returns '$1'"  # DELETE ME
	case $1 in
		$STATUS_WIN)
			cat <<-:
			This directory really shouldn't be a git repository.

			Run 'tutor bug' and email the output to erik.falor@usu.edu
			before proceeding.

			:
			;;
		*)
			_tutr_generic_hint $1 git "$_PARENT"
			cat <<-:

			Run 'git status' to find out if you are still inside a repository.
			:
			;;
	esac
}

git_status1_epilogue() {
	_tutr_pressanykey
	if (( $_RES == 0 )); then
		cat <<-:

		Hmm, you're still inside a repo here?
		It might cause you trouble if you proceed.

		Please contact erik.falor@usu.edu for help.
		:
	else
		cat <<-:

		This is exactly what you want to see when you SHOULDN'T be in a git
		repository.
		:
	fi

	cat <<-:

	It never hurts to run 'git status'.  You really can't use it too much!

	:
	_tutr_pressanykey
}



# 6.  Clone the git repository containing the starter code from GitLab onto
# 	your computer using the `git clone` command.
git_clone_pre() {
	# See if the starter code repo already exists
	if [[ -d "$_REPO/.git" ]]; then
		_tutr_err repo_warning
		return 1
	fi
}

git_clone_prologue() {
	cat <<-:
	Now you will clone the starter code for Assignment #0 in CS 1440.
	Cloning a repo makes a new directory on your computer into which the
	repo's information is downloaded.

	The syntax of this command is

	  git clone URL [DIRECTORY]

	URL is the location of another git repo known as the "remote".  Most
	often the remote repo is out on the internet, but it can also be another
	repo on your computer.  When a remote repo is cloned  from the web the
	URL argument begins with 'https://' or 'git@'.

	If you leave off the optional 'DIRECTORY' argument git chooses the name
	of the new directory for you.

	Use 'git clone' to clone the remote repo at the URL
	  https://gitlab.cs.usu.edu/erik.falor/cs1440-falor-erik-assn0

	Leave off the optional 'DIRECTORY' argument for now; you can rename the
	repo after this tutorial.
	:
}

git_clone_test() {
	_tutr_generic_test -c git -a clone -a "^https://gitlab.cs.usu.edu/erik.falor/cs1440-falor-erik-assn0$|^git@gitlab.cs.usu.edu:erik.falor/cs1440-falor-erik-assn0$" -d "$_PARENT"
}

git_clone_hint() {
	case $1 in
		$STATUS_FAIL)
			cat <<-:
			'git clone' failed unexpectedly.

			If the above error message includes the phrases "fatal: unable to access"
			and "Connection refused", that indicates an issue with your network
			connection.  Ensure that you are connected to the internet and try
			again.

			If the error persists or is different, please contact
			erik.falor@usu.edu for help.  Copy the full command and all of
			its output.

			:
			;;

		*)
			_tutr_generic_hint $1 git "$_PARENT"

			cat <<-:

			To clone this repo run
			  git clone https://gitlab.cs.usu.edu/erik.falor/cs1440-falor-erik-assn0
			:
		;;
	esac
}

git_clone_epilogue() {
	if [[ $_RES -eq 0 ]]; then
		cat <<-:
		All of that is normal output for the 'clone' subcommand.

		[1;7mGit subcommand 4/10: 'clone'[0m

		:
		_tutr_pressanykey
	else
		cat <<-:
		Hmm... something went wrong while cloning that repository.

		Copy the text of the terminal and prepare a bug report for Erik.
		:
	fi
}



# 7.  Enter the newly cloned repository
cd_into_repo_prologue() {
	cat <<-:
	'git clone' created a new directory called 'cs1440-falor-erik-assn0' and
	populated it with files from the internet.

	This directory is a new git repository.
	Why not 'cd' inside and take a look around?
	:

}

cd_into_repo_test() {
	if   [[ $PWD = $_REPO ]]; then return 0
	elif _tutr_nonce; then return $PASS
	else _tutr_generic_test -c cd -a cs1440-falor-erik-assn0 -d "$_PARENT"
	fi
}

cd_into_repo_hint() {
	_tutr_generic_hint $1 cd "$_PARENT"

	cat <<-:
	Enter the new repo with the 'cd' command
	  cd cs1440-falor-erik-assn0
	:
}

cd_into_repo_post() {
	if [[ $_RES -ne 0 ]]; then
		_tutr_die printf "'Then send it to erik.falor@usu.edu.'"
	fi
	_ORIG_URL=$(git remote get-url origin)
}



# 8. See what a clean, newly cloned repo looks like with 'git status'
git_status2_prologue() {
	cat <<-:
	You can see what files and directories are here with 'ls'.  After the
	last lesson the layout of this repository should be familiar.

	Now that you're back inside of a git repository you can run 'git status'
	again to see what state the repository is in.  Since you just barely
	cloned it down from the internet, this repo should be in a clean state.

	Run 'git status' to proceed.
	:
}

git_status2_test() {
	if   _tutr_nonce; then return $PASS
	else _tutr_generic_test -c git -a status -d "$_REPO"
	fi
}

git_status2_hint() {
	_tutr_generic_hint $1 git "$_REPO"

	cat <<-:

	Run 'git status' to proceed.
	:
}

git_status2_epilogue() {
	cat <<-:
	This is what a clean repository looks like.  By "clean" I mean that
	there is no difference between the code in this local repo and the code
	stored in the remote repo.

	Let me explain what this message is telling you.

	"On branch master"
	  This message reminds you that you are working on the 'master' (A.K.A.
	  default) branch.  For the time being all of your work will be on this
	  branch.  You'll learn more about branches later in the semester.

	"Your branch is up to date with 'origin/master'."
	  The code in the 'master' branch is the same as the code on the remote
	  repo's 'master' branch.  Git doesn't automatically go out to the
	  internet to check, though; this information was up-to-date as of your
	  last 'git clone' command.

	"nothing to commit, working tree clean"
	  'Working tree' refers to the source code files in this repo.  Since
	  you have not changed anything, they are exactly as git remembers them.

	:
	_tutr_pressanykey
}



# 9.  Open "README.md" in an editor and change the file in some way.
#     Return to your command shell ask git about the status of your repository.

# The next step also wants the user to run 'git status'
edit_readme0_pre() {
	_CMD=()
}

edit_readme0_prologue() {
	cat <<-:
	Git is much more than just a slick way to download code from the 'net.

	The thing you will do the most with git is take snapshots (A.K.A.
	[1;7mcommits[0m) of your project while you work.  Commits record your project
	at various points in time.  When you make a mistake or paint yourself
	into a corner you can turn the project back to an earlier commit and try
	again.  Git is the ultimate "Undo" that transcends all other tools.

	To make a commit you first need to change something in the repository.
	There is a file here called 'README.md'.  Open this file in Nano, make a
	change and save it.  Git can tell that you changed the file.  Run
	'git status' after changing this file to see what git says about it.

	It really doesn't matter what you do to 'README.md'; you can even
	remove the whole file.  Knock yourself out!
	:
}

edit_readme0_test() {
	if   [[ $PWD != $_REPO ]]; then return $WRONG_PWD
	elif [[ ${_CMD[0]} != git && ! -f "$_REPO/README.md" ]]; then return 98
	elif [[ -f "$_REPO/README.md" && $(git hash-object "$_REPO/README.md") = $README_HSH ]]; then return 99
	elif [[ ${_CMD[0]} = nano || ${_CMD[0]} = *vim || ${_CMD[0]} = vi || ${_CMD[0]} = emacs ]]; then return 98
	else _tutr_generic_test -c git -a status
	fi
}

edit_readme0_hint() {
	case $1 in
		99)
			cat <<-:
			You won't see anything interesting until you change 'README.md'.

			Go ahead and open it in 'nano' and make a mess of it.  You can't
			really hurt anything here!
			:
			;;

		98)
			cat <<-:
			Nice!

			Now see what 'git status' has to say about your handiwork.
			:
			;;

		*)
			_tutr_generic_hint $1 git "$_REPO"
			cat <<-:

			Open 'README.md' in Nano, change it, and save it.
			Then run 'git status' to see what git says about your change.
			:
			;;
	esac
}

edit_readme0_epilogue() {
	_tutr_pressanykey

	cat <<-:

	You will see this message a lot, so you had better know what it means.

	"On branch master"
	  You are still on the master branch.

	"Your branch is up to date with 'origin/master'"
	  This repo's master branch is not different from the master branch on
	  the remote repo' named "origin".  The "origin" repo is the one you
	  cloned from.

	"Changes not staged for commit"
	  This is where git lists what files have changed.  Git knows when a
	  file is created, deleted or modified.  Right before it displays the
	  list of changed files it suggests commands you can use here:

	  * You can accept the changes by using 'git add'.
	  * You can discard the changes with 'git restore'.

	  Discarding changes is how you use git like an "Undo" button.  Whenever
	  you make a mistake, git can put things back the way they were before!

	The most important thing to remember is that 'git status' suggests one
	or more commands that move your project along.  When you unsure about
	what to do next, just run 'git status'!

	:

	_tutr_pressanykey
}


# 10. Use git restore (or checkout) to discard this change
git_restore_prologue() {
	cat <<-:
	Let's try fixing a mistake with git's 'restore' subcommand.

	The form of the 'git restore' subcommand is
	  git restore FILE...

	Use 'git restore' to discard the change to README.md you made.  This
	will put 'README.md' back to its original state no matter what you did
	to it.
	:
}

git_restore_test() {
	if   [[ $PWD != $_REPO ]]; then return $WRONG_PWD
	elif [[ -z $(git status --porcelain=v1) ]]; then return 0
	elif _tutr_nonce; then return $PASS
	else _tutr_generic_test -c git -a restore -a README.md -d "$_REPO"
	fi
}

git_restore_hint() {
	_tutr_generic_hint $1 git "$_REPO"
	cat <<-:

	Use 'git restore' to undo the change you made to README.md.
	  git restore README.md
	:
}

git_restore_epilogue() {
	cat <<-:
	[1;7mGit subcommand 5/10: 'restore'[0m

	:
	_tutr_pressanykey
}


# 11. Run 'git status' to prove that 'git restore' really worked
git_status3_prologue() {
	cat <<-:
	All better now!  Run 'git status' to see for yourself.  The state of the
	working tree should be "clean".
	:
}

git_status3_test() {
	if _tutr_nonce; then return $PASS
	else _tutr_generic_test -c git -a status -d "$_REPO"
	fi
}

git_status3_hint() {
	_tutr_generic_hint $1 git "$_REPO"
	cat <<-:

	Run 'git status' to verify that README.md has been put back to its
	original form.
	:
}

git_status3_epilogue() {
	cat <<-:
	Excellent!

	:
	_tutr_pressanykey
}



# 12.  Run `git add` to add `README.md` to your repository.
git_add0_prologue() {
	cat <<-:
	This time I will have you change 'README.md' once more, but you will
	save this change as a commit.

	Creating a git commit is a two-stage process:

	0.  Add changes to the commit with 'git add'
	1.  Permanently record the commit along with a message describing the
		changes with 'git commit'

	As suggested by 'git status', you can use 'git add' to update what
	changed files will be committed.

	The form of the 'git add' command is
	  git add FILE...

	This means you may add as many or as few files to a commit as you wish.

	Edit 'README.md' once more, then use 'git add' to prepare it to be
	committed.
	:
}

git_add0_test() {
	if   [[ $PWD != $_REPO ]]; then return $WRONG_PWD
	elif [[ $(git hash-object "$_REPO/README.md") = $README_HSH ]]; then return 99
	elif _tutr_nonce; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = status ]]; then return $PASS
	else _tutr_generic_test -c git -a add -a README.md -d "$_REPO"
	fi
}

git_add0_hint() {
	case $1 in
		99)
			cat <<-:
			You realy must change 'README.md' to proceed.

			Go ahead and open it in 'nano' and make a mess of it.  You can't
			really hurt anything here!
			:
			;;

		*)
			_tutr_generic_hint $1 git "$_REPO"
			cat <<-:

			Now use 'git add README.md'.
			:
			;;
	esac
}

git_add0_epilogue() {
	cat <<-:
	[1;7mGit subcommand 6/10: 'add'[0m

	Creating a commit is a two-stage process.

	By "adding" README.md you are halfway there.

	:
	_tutr_pressanykey
}


# 13.  Check the status of your repository again
git_status4_prologue() {
	cat <<-:
	Run 'git status' to see what your repository looks like in this state.
	:
}

git_status4_test() {
	_tutr_generic_test -c git -a status -d "$_REPO"
}

git_status4_hint() {
	_tutr_generic_hint $1 git "$_REPO"
	echo
	git_status4_prologue
}

git_status4_epilogue() {
	_tutr_pressanykey
	cat <<-:

	Files listed under the heading "Changes to be committed" are said to be
	in the "staging area".

	The staging area is a git concept; it is not a location or directory on
	your computer.  It is the "place" in between two commits.  Your files
	still right here in this directory, and you can continue to edit and use
	them.

	'git add'ing files doesn't do anything permanent.  You can go back to
	the previous state by running

	  git restore --staged README.md

	Until you use 'git commit' your changes aren't permanently recorded in
	git's timeline.

	:
	_tutr_pressanykey
}


# 14. Use the `-m` option to add a brief message (between double quotes)
#    about this change.
git_commit0_prologue() {
	cat <<-:
	Now you are ready to permanently record this change in a commit.
	A commit consists of

	0.  The changes you have made to the project
	1.  Your name
	2.  Your email address
	3.  The current date & time
	4.  A brief message explaining what you changed and why

	The 'git commit' command makes and records a commit.  It has the form
	  git commit [-m "Commit message goes here"]

	The '-m' argument is optional.  If you don't supply it git will open a
	text editor where you can write as detailed a message as you like.
	Often a short, one-line message suffices, which may be given after the
	'-m' option.

	Note that a message given on the command line with '-m' MUST be
	surrounded by quote marks; otherwise 'git' misinterprets every word
	of your message after the first as more arguments!

	Use 'git commit -m "..."' to save a new commit.
	:
}

git_commit0_test() {
	if   [[ $PWD != $_REPO ]]; then return $WRONG_PWD
	elif [[ -z $(git status --porcelain=v1) && $(git rev-parse --short HEAD) != $STARTER ]]; then return 0
	elif _tutr_nonce vi vim nano emacs; then return $PASS
	else _tutr_generic_test -c git -a commit -d "$_REPO"
	fi
}

git_commit0_hint() {
	_tutr_generic_hint $1 git "$_REPO"
	cat <<-:

	Run this command to make the command (and put some thought into the
	commit message)

	  git commit -m "Commit message goes here"
	:
}

git_commit0_epilogue() {
	_tutr_pressanykey
	cat <<-:

	[1;7mGit subcommand 7/10: 'commit'[0m

	Good job!

	These three commands are the backbone of your git workflow:

	0.  git add
	1.  git status
	2.  git commit

	You will use these commands so much that, before long, this will be as
	natural as breathing.  It just takes practice!

	:
	_tutr_pressanykey
}


# 15. Get the status of your repository once more; the directory should be
# 	"clean".
git_status5_prologue() {
	cat <<-:
	Get the status of your repository once more.
	After making a commit it should be "clean".
	:
}

git_status5_test() {
	_tutr_generic_test -c git -a status -d "$_REPO"
}

git_status5_hint() {
	_tutr_generic_hint $1 git "$_REPO"
	cat <<-:

	Get the status of your repository once more.
	  git status
	:
}

git_status5_epilogue() {
	_tutr_pressanykey
}



# 16. Review the commit history of your repository.
git_log0_prologue() {
	cat <<-:
	The 'git log' command displays the complete history of the repository.

	In its simplest form 'git log' begins from the current commit and lists
	every commits all the way back to the beginning.  The most recent commit
	is shown at the top.

	When there are too many commits to fit on the screen at once, 'git log'
	uses the same text reader as the 'man' command.  This means that you
	will use the same keyboard shortcuts to control the display.

	* Press 'j' or 'Down Arrow' to scroll down.
	* Press 'k' or 'Up Arrow' to scroll up.
	* Press 'q' to exit the text reader.

	Run 'git log' now.
	:
}

git_log0_test() {
	_tutr_generic_test -i -c git -a log -d "$_REPO"
}

git_log0_hint() {
	_tutr_generic_hint $1 git "$_REPO"
	cat <<-:

	Run 'git log' now.
	:
}

git_log0_epilogue() {
	_tutr_pressanykey
	cat <<-:

	[1;7mGit subcommand 8/10: 'log'[0m

	There are not many commits in this repo yet.  But it won't be weird for
	your own repos have dozens of commits.  In fact, many commits are better
	than few!

	:
	_tutr_pressanykey
}


# 17. Rename 'origin' to 'old-origin'
git_remote_v_prologue() {
	cat <<-:
	Turning in assignments in this class is done entirely through git.
	Besides checking your score and reading messages from the grader, there
	is nothing for you to do with assignments on Canvas.

	To submit your code, you will create a remote repository on the GitLab
	server under your account and associate this local repository with it.
	This will be done once for every assignment, and is done entirely from
	the command line.
	
	:
	_tutr_pressanykey

	cat <<-:

	The repository you are currently inside of is a "clone" from my GitLab
	account.  Like clones in Sci-Fi stories, it doesn't know it's a clone;
	it thinks it is the original.  It remembers that it came from my account
	on Gitlab, and believes that is its rightful home.

	For the next three steps you will use the 'git remote' command in a few
	different ways.  You can see for yourself that this repository is a true
	clone of mine by running
	  git remote -v

	Try it!
	:
}

git_remote_v_test() {
	if   [[ $PWD != $_REPO ]]; then return $WRONG_PWD
	elif _tutr_nonce; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = help ]]; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = status ]]; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = log ]]; then return $PASS
	else _tutr_generic_test -c git -a remote -a -v -d "$_REPO"
	fi
}

git_remote_v_hint() {
	_tutr_generic_hint $1 git "$_REPO"
	cat <<-:

	Run 'git remote -v' to see where this repo came from.
	:
}

git_remote_v_epilogue() {
	_tutr_pressanykey

	cat <<-:

	What you see here are the URLs that this repository can DOWNLOAD updates
	from (fetching) and UPLOAD updates to (push).

	Both of these URLs are nicknamed 'origin', and right now they point back
	to *MY* account on GitLab.

	There is nothing particularly special about the name 'origin'; it's just
	a git tradition.

	:
	_tutr_pressanykey
}


# 17. Rename origin -> old-origin
git_remote_rename_prologue() {
	cat <<-:
	Now, you won't be able to upload your work into my GitLab account
	without my password.

	Look, I like you and everything, but I barely know you.  You should use
	your own password to turn in your homework.

	:
	_tutr_pressanykey

	cat <<-:

	What you need to do now is give your clone its own identity based on
	your GitLab account.  Begin by teaching it that my GitLab account is not
	its "origin" anymore.

	Nicknames for remote repository URLs can be anything, but it's customary
	to use the name 'origin' for the URL that you use most often.  The URL
	you use the most should point to your own GitLab account.

	This is the form of the 'git remote' command that can rename a remote
	repository's nickname:
	  git remote rename OLD_NAME NEW_NAME

	In your case, use 'origin' as the old name and 'old-origin' as the
	new name.
	:
}

## Ensure that a remote called origin no longer exists
git_remote_rename_test() {
	if   [[ $PWD != $_REPO ]]; then return $WRONG_PWD
	elif _tutr_nonce; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = help ]]; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = status ]]; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = log ]]; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = remote && ${_CMD[2]} = -v ]]; then return $PASS
	else
		if   git remote | command grep -q -E '^old-origin$'; then return 0
		elif [[ $( git remote | wc -l ) = 0 ]] ; then return 0
		else _tutr_generic_test -c git -a remote -a rename -a origin -a old-origin -d "$_REPO"
		fi
	fi
}

git_remote_rename_hint() {
	_tutr_generic_hint $1 git "$_REPO"

	cat <<-:

	You want to use this command:
	  git remote rename origin old-origin
	:
}

git_remote_rename_post() {
	if [[ $(git remote | wc -l) = 0 ]]; then
		_REMOVED_ORIGIN=yep
	else
		_REMOVED_ORIGIN=nope
	fi
}

git_remote_rename_epilogue() {
	if [[ $_REMOVED_ORIGIN = yep ]]; then
		echo Well, that was ONE way to do it.
	else
		echo "Perfect!"
	fi

	cat <<-:

	The reason why I asked you to rename 'origin' instead of erasing it
	is so that your repository will always remember where it came from.

	There is a chance that somebody will find a bug in an assignment, and I
	will need to issue an update.  If your repository remembers it's old
	'origin', it's really simple for you to fetch the corrected code.

	I hope this never happens, but if it does I will give you complete
	instructions for getting the fix at that time.

	:

	if [[ $_REMOVED_ORIGIN = yep ]]; then
		cat <<-:
		Since you removed my URL from your repository's configuration, you would
		be on your own if I needed to make a change to the assignment's starter
		code or documentation.

		:
	fi
	_tutr_pressanykey
}


# 18. Add a new repo URL under the name 'origin'
git_remote_add_prologue() {
	cat <<-:
	You will use the 'git remote add' subcommand in this step to associate
	the name 'origin' with a new GitLab URL that includes your username.

	The new URL needs just a bit of explanation.

	:
	_tutr_pressanykey

	cat <<-:

	The URL that you cloned this repo from is
	  $_ORIG_URL

	Your new URL will basically look like that, except for these differences:

	* Replace 'erik.falor' with your GitLab username (case does not matter)
	* Replace 'falor-erik' with your own name (again, case does not matter)
	  * Use what Canvas considers to be your "real name"
	
	It is very important that you NOT change:

	* Punctuation, such as slashes '/' and colons ':'
	* gitlab.cs.usu.edu
	* cs1440
	* assn0

	When students get those wrong, we cannot locate your assignment
	submission.  If this ever happens to you, contact a TA for help.

	:

	_tutr_pressanykey

	cat <<-:

	The syntax command you will use is
	  git remote add origin NEW_URL

	When you've figured out what the NEW_URL looks like, give it a try!

	:
}

git_remote_add_test() {
	if   [[ $PWD != $_REPO ]]; then return $WRONG_PWD
	elif _tutr_nonce; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = help ]]; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = status ]]; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = log ]]; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = remote && ${_CMD[2]} = -v ]]; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} = remote && ${_CMD[2]} = remove ]]; then return $PASS
	elif [[ ${_CMD[0]} = git && ${_CMD[1]} != remote ]]; then return 95
	fi

	local URL=$(git remote get-url origin 2>/dev/null)
	if   [[ -z $URL ]]; then return 99
	elif [[ $URL != *gitlab.cs.usu.edu* ]]; then return 93
	elif [[ $URL = [/:]*erik.falor/* ]]; then return 98
	elif [[ $URL = */cs1440-falor-erik-assn0* ]]; then return 97
	elif [[ $URL != *-assn0 && $URL != *-assn0.git ]]; then return 96
	elif [[ $URL = https://gitlab.cs.usu.edu:* ]]; then return 95
	elif [[ $URL = git@gitlab.cs.usu.edu/* ]]; then return 94
	elif [[ $URL != https:* && $URL != git@* ]]; then return 91
	elif [[ $URL != */cs1440-* ]]; then return 92
	elif [[ $URL = https://gitlab.cs.usu.edu/*/cs1440-*-assn0 ||
		$URL = https://gitlab.cs.usu.edu/*/cs1440-*-assn0.git ||
		$URL = git@gitlab.cs.usu.edu:*/cs1440-*-assn0 ||
		$URL = git@gitlab.cs.usu.edu:*/cs1440-*-assn0.git ]]; then return 0
	else _tutr_generic_test -c git -n -d "$_REPO"
	fi
}

git_remote_add_hint() {
	case $1 in
		99)
			cat <<-:
			There is no remote called 'origin'.  Create it with
			  'git remote add origin NEW_URL'.

			Replace "NEW_URL" in the above command with an address as
			described above (run 'tutor hint' to review the instructions).

			:
			;;

		98)
			cat <<-:
			'origin' points to the address of MY repo, not YOURS!

			Use 'git remote remove origin' to erase this and try again.
			:
			;;

		97)
			cat <<-:
			The name you gave your repo is wrong - it still contains MY name.

			Your repository's name should include YOUR name and look like
			  cs1440-LASTNAME-FIRSTNAME-assn0

			Use 'git remote remove origin' to erase this and try again.
			:
			;;

		96)
			cat <<-:
			This repository's name must end in '-assn0', signifying that it
			is for Assignment #0.

			Use 'git remote remove origin' to erase this and try again.
			:
			;;

		95)
			cat <<-:
			The HTTPS address you entered will not work because there is a colon ':'
			between the hostname 'gitlab.cs.usu.edu' and your username.  (Use 'git
			remote -v' to see for yourself).

			Instead of a colon that character should be a front slash '/'.

			Use 'git remote remove origin' to erase this and try again.
			:
			;;

		94)
			cat <<-:
			This SSH address will not work because there is a slash '/' between the
			hostname 'gitlab.cs.usu.edu' and your username.  (Use 'git remote -v' to
			see for yourself).

			Instead of a slash that character should be a colon ':'

			Use 'git remote remove origin' to erase this and try again.
			:
			;;

		93)
			cat <<-:
			The hostname of the URL should be 'gitlab.cs.usu.edu'.

			If you push your code to the wrong Git server it will not be submitted.

			Use 'git remote remove origin' to erase this and try again.
			:
			;;

		92)
			cat <<-:
			This repository's name must contain the course number 'cs1440', followed
			by a hyphen.  This associates this repo with this course.

			If its name includes the wrong course number it won't be graded!

			Use 'git remote remove origin' to erase this and try again.
			:
			;;

		91)
			cat <<-:
			The URL must start with 'https://' (or 'git@', if you are using your
			SSH key).  Otherwise, git will be unable to talk to the server.

			Use 'git remote remove origin' to erase this and try again.
			:
			;;
		*)
			_tutr_generic_hint $1 'git remote' "$_REPO"
			;;
	esac
	cat <<-:

	After you figure out what NEW_URL should be, use this command:
	  git remote add origin NEW_URL

	Use 'tutor hint' to review the instructions about the new URL.
	:
}

git_remote_add_epilogue() {
	cat <<-:
	[1;7mGit subcommand 9/10: 'remote'[0m

	That was a big one, but you did awesome!

	Just one more subcommand to go!

	:
	_tutr_pressanykey
}


# 19. Push & refresh your browser window
git_push_all_pre() {
	_NEW_URL=$(git remote get-url origin 2>/dev/null)
}


git_push_all_prologue() {
	cat <<-:
	You are finally ready to push the commits to the remote repo on GitLab.
	This is how you will submit your work this semester.

	'git push' is the command that does this.  Its syntax is:

	  git push [-u] REPOSITORY [--all]

	In the place of the 'REPOSITORY' argument you will write 'origin'.

	The first time you push your code up to GitLab you will use all of the
	options listed above, like this:

	  git push -u origin --all

	Afterward, you can leave off '-u origin --all' from the push command.

	:

	if [[ $_NEW_URL = https:* ]]; then
		_tutr_pressanykey
		cat <<-:

		You may be prompted for your GitLab username and password.  When you
		enter your password for git, your keystrokes are not echoed to the
		screen.  Not even '*' symbols.  This is to protect your password from
		shoulder-surfers.

		Just keep typing, as usual, and git will see your password just fine.

		:
	fi
}

git_push_all_test() {
	if   [[ ${_CMD[@]} = 'git help push' ]]; then return $PASS
	elif [[ ${_CMD[@]} = 'git remote' ]]; then return $PASS
	elif [[ ${_CMD[@]} = 'git remote -v' ]]; then return $PASS
	else _tutr_generic_test -c git -a push -a -u -a origin -a --all -d "$_REPO"
	fi
}

git_push_all_hint() {
	case $1 in
		$STATUS_FAIL)
			cat <<-:
			'git push' failed unexpectedly.

			If the above error message includes the phrases [1;7munable to access[0m
			or [1;7mConnection refused[0m, that indicates an issue with your network
			connection.  Ensure that you are connected to the internet and try again.

			If you instead saw [1;7mAuthentication failed[0m, that means your username
			or password were wrong.

			If the error persists or is different, please contact
			erik.falor@usu.edu for help.  Copy the full command you ran with
			all its output.

			Otherwise, try running this command again:
			  git push -u origin --all
			:
			;;

		*)
			_tutr_generic_hint $1 git "$_REPO"
			cat <<-:

			Run this command to proceed
			  git push -u origin --all
			:
			;;
	esac
}

git_push_all_epilogue() {
	_tutr_pressanykey
	cat <<-:

	[1;7mGit subcommand 10/10: 'push'[0m

	In other words, you're all done!
	           ___   ___  _   _
	__      __/ _ \\ / _ \\| |_| |
	\\ \\ /\\ / / | | | | | | __| |
	 \\ V  V /| |_| | |_| | |_|_|
	  \\_/\\_/  \\___/ \\___/ \\__(_)

	:
	_tutr_pressanykey
}




source _tutr/main.sh && _tutr_begin \
	git_help \
	git_help_help \
	git_config \
	git_status0 \
	cd_dotdot0 \
	git_status1 \
	git_clone \
	cd_into_repo \
	git_status2 \
	edit_readme0 \
	git_restore \
	git_status3 \
	git_add0 \
	git_status4 \
	git_commit0 \
	git_status5 \
	git_log0 \
	git_remote_v \
	git_remote_rename \
	git_remote_add \
	git_push_all \


# vim: set filetype=sh noexpandtab tabstop=4 shiftwidth=4 textwidth=76 colorcolumn=76:
