# Shell Tutor

Interactive Unix command shell tutorials

## Quickstart

*In the code examples below a dollar sign `$` represents the shell prompt.  This is to distinguish commands that you will input from their output. Do not type the `$` when you run these commands yourself.*

0.  Install Git on your computer (users of Git for Windows look for special instructions at the bottom of this document).
1.  Clone this repository
    ```
    $ git clone https://gitlab.cs.usu.edu/erik.falor/shell-tutor
    Cloning into 'shell-tutor'...
    warning: redirecting to https://gitlab.cs.usu.edu/erik.falor/shell-tutor.git/
    remote: Enumerating objects: 25, done.
    remote: Counting objects: 100% (25/25), done.
    remote: Compressing objects: 100% (24/24), done.
    remote: Total 25 (delta 3), reused 0 (delta 0), pack-reused 0
    Unpacking objects: 100% (25/25), 70.62 KiB | 2.14 MiB/s, done.
    ```
2.  Enter the `shell-tutor` directory and execute one of the `.sh` files from Bash or Zsh:
    ```
    $ cd shell-tutor

    $ ./0-basics.sh

    Tutor| Shell Lesson #0: Unix Shell Basics
    Tutor| 
    Tutor| In this lesson you will learn about
    Tutor| 
    Tutor| * Using a Unix command line interface
    Tutor| * Commands and arguments
    Tutor| * The difference between the "shell" and the "terminal"
    Tutor| * How to clear and reset the terminal
    Tutor| * Cancelling a runaway command
    Tutor| * Understanding messages and recovering from errors
    Tutor| 
    Tutor| Let's get started!
    Tutor| 
    Tutor| [Press any key]
    ```


## Features

*   This is not a fake, pretend "shell" as seen on the internet.  You are
    running *real* commands in a *real* shell on your own computer and get
    *real* feedback on the results.
*   The tutor adjusts its plan as you go.  If you skip ahead in the sequence,
    so does the tutor.
*   Compatible with Bash versions >= 3.2 and Zsh versions >=5.2.


## Hints

*   Interact with the tutor through the `tutor` command.
    *   When you get lost or forget what to do next, run `tutor hint`.
*   You can leave the tutorial early by exiting the shell.  There are many
    ways to do this:
    *   The `exit` command
    *   The `tutor quit` command
    *   Type the End-Of-File character (EOF) `Ctrl-D`
*   Lessons are designed to be brief; the average student will finish a lesson
    in 20 minutes.  If you are stuck longer than 20 minutes you can seek help
    from the instructor, TAs or CS Coaching Center.


## Reporting problems

*   When you encounter a problem with a lesson, please send a bug report so I can fix it
    *   Run `tutor bug` 
        *   Scroll up a before the problem started and copy the text on your terminal, including these details:
        -   Which lesson you are running
        -   Which step of the lesson you were on
        -   The instructions for that step
        -   The command you ran
        -   The erroneous output
        -   The output of the `tutor bug` command
*   Send this text to me in an email: `erik DOT falor AT usu DOT edu`
    *   **Do not** send screenshots; plain text is much easier to work with


## Special installation instructions for **Git for Windows** users

Beginning with Lesson #2 **2-commands.sh** the Unix manual becomes an important part of the tutorial.  Git for Windows doesn't include the Unix manual, so I prepared an installer so you can have it at your fingertips.

0.  Download the installer: [install_man_pages-0.5.sh](https://gitlab.cs.usu.edu/erik.falor/shell-tutor/uploads/479a5875f005f6a351d5af3785f5572a/install_man_pages-0.5.sh)
1.  Note the location this file was saved on your computer
2.  Open a new Bash terminal as Administrator (right-click the Git+Bash icon and choose "Run as Administrator")
    *   This may open the shell into a directory outside of your home directory.  Navigate to the directory where you downloaded the installer a few moments ago
    *   To navigate to this directory, use the `cd` command to "change directory" into the folder that contains the installer. Ex: `cd Downloads`
3.  Run the installer with this command: `sh install_man_pages-0.5.sh`
4.  Open a new Bash window and test that install worked by running `man ls`
    *   Press `q` to quit the man page viewer


## Special installation instructions for **Mac OS X** users

### Installing `git`

If you haven't yet installed the command line developer tools, you will be greeted by a pop up asking you to install them the first time you try to run `git` or `python3`.  Just click `Install`, accept the license, and you're off to the races.

### Keyboard shortcuts

Keyboard shortcuts are introduced in Lesson #1 **1-shortcuts.sh** which use both the `Control` and `Option` keys.  By default, the Terminal App on Mac OS X is not set up for the `Option` key to do what is needed.  Follow these steps to achieve the proper configuration:

*   Launch the Terminal app
*   Open the `Terminal` menu and select `Preferences`
*   Select the `Profiles` page
*   Select the `Keyboard` tab
*   Check option 'Use Option as Meta Key'

This will make your `Option` key behave the same as the `Alt` key on an IBM PC.  Both of these keys stand in for the `Meta` key, which was present on keyboards of early Unix workstations.


## Table of Contents

*   **0-basics.sh**
    *   Using a Unix command line interface
    *   Commands and arguments
    *   The difference between the "shell" and the "terminal"
    *   How to clear and reset the terminal
    *   Cancelling a runaway command
    *   Understanding messages and recovering from errors
*   **1-shortcuts.sh**
    *   To use the shell's History to re-use commands you have already typed
    *   Line editor shortcuts to easily navigate and change command lines
    *   How TAB completion can write parts of your commands for you
*   **2-commands.sh**
    *   To use the 'which' command to find where a program is installed
    *   About the \$PATH variable and how the shell uses it to find programs
    *   What an absolute path is
    *   Why some programs must be run by typing './' in front of their name
    *   About different types of shell commands
    *   How to get help in the shell
*   **3-files.sh**
    *   Copy files
    *   Move and rename files
    *   Remove files
    *   Refer to multiple files with wildcards
*   **4-directories.sh**
    *   Navigate directories
    *   Create new directories
    *   Remove empty directories
    *   Forcibly remove directories without regard for their contents
*   **5-projects.sh**
    *   Move files between directories
    *   Navigate the standard DuckieCorp project structure
    *   Create and edit text files with the Nano editor
    *   Run unit tests and interpret their results
    *   Write project documentation
*   **6-git.sh**
    *   Prepare git on your computer
    *   Ask git for help about its commands
    *   Clone a git repository onto your computer
    *   Check the status of your repository
    *   Change a file and commit it to the repository
    *   View the git log
    *   Submit your homework to GitLab
