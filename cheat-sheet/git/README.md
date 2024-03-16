<hr>
<p align="center">
    <img alt="Git" src="./Img/git-logo.png" height="190" width="455">
</p>
<hr>

<hr>

Git Cheat Sheet
===============

* [Git by Atlassian - PDF](./Img/atlassian-git-cheatsheet.pdf)
### Table of contents
* [Setup & Customization](#setup)
* [Configuration Files](#configuration-files)
* [Create](#create)
* [Local Changes](#local-changes)
* [Search](#search)
* [Commit History](#commit-history)
* [Move / Rename](#move--rename)
* [Branches & Tags](#branches--tags)
* [Update & Publish](#update--publish)
* [Merge & Rebase](#merge--rebase)
* [Undo Changes](#undo)

<hr>

<a name="setup"></a>

## Setup & Customization

**Show current repository git configuration.**

```bash
git config --list
```

**Show local repository git configuration.**

```bash
git config --local --list
```

**Show global git configuration.**

```bash
git config --global --list
```

**Show system git configuration.**

```bash
git config --system --list
```

**Define author name to be used for all commits in current repo. Use `--global flag` to set config options for the current user on global level.**

```bash
git config user.name "firstname lastname"
git config --global user.name "firstname lastname"
```

**Set an email address that will be associated with the author name. Use `--global flag` to set config options for the current user on global level.**

```bash
git config user.email "valid-email"
git config --global user.email "valid-email"
```

**Git supports colored terminal output which helps with rapidly reading Git output. You can customize your Git output to use a personalized color theme. The `git config` command is used to set these color values. Use `--global flag` to set the coloring on global level.**

```bash
git config color.ui auto
git config --global color.ui auto


# `color.ui` is the master variable for Git colors. Setting it to false will disable all Git's colored terminal output.
git config --global color.ui false
```

**Set editor for viewing commit history and editing git configurations. Use `--global flag` to set the desired editor on global level.**

```bash
# Use "nano"
git config core.editor "nano -w"
git config --global core.editor "nano -w"

# Use "vi" as default editor
git config core.editor vi
git config --global core.editor vi

# Use "vim" as default editor
git config core.editor vim
git config --global core.editor vim

# Use "Visual Studio Code" as default editor
git config core.editor "code --wait
git config --global core.editor "code --wait

# Use "Atom" as default editor
git config core.editor "atom --wait"
git config --global core.editor "atom --wait"

# Use "emacs" as default editor
git config core.editor "emacs"
git config --global core.editor "emacs"

# Use "Sublime Text (Mac)" as default editor
git config core.editor "subl -n -w"
git config --global core.editor "subl -n -w"
```

**You may be familiar with the concept of aliases from your operating system command-line; if not, they're custom shortcuts that define which command will expand to longer or combined commands. Aliases save you the time and energy cost of typing frequently used commands. Git provides its own alias system. A common use case for Git aliases is shortening the commit command. Git aliases are stored in Git configuration files. This means you can use the `git config` command to configure aliases.**

```bash
# This example creates a ci alias for the git commit command. You can then invoke git commit by executing git ci. Aliases can also reference other aliases to create powerful combos.
git config --global alias.ci commit

# Other examples for aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.st status

# Git Log in a Pretty Format (git lg
git config --global alias.lg 'log --oneline --decorate --all --graph'

# Git Checkout to a New Branch (git cob)
git config --global alias.cob 'checkout -b'

# Git Amend the Last Commit (git amend)
git config --global alias.amend 'commit --amend'

# Git Stash Changes (git save)
git config --global alias.save 'stash save'

# Git List Stashes (git sl)
git config --global alias.sl 'stash list'

# Git Remove Stash (git drop)
git config --global alias.drop 'stash drop'

# Git Reset Hard (git rh)
git config --global alias.rh 'reset --hard'


# However, maybe you want to run an external command, rather than a Git subcommand. In that case, you start the command with a ! character. This is useful if you write your own tools that work with a Git repository. We can demonstrate by aliasing git visual to run gitk.**
git config --global alias.ca '!git add -A && git commit'
```

**You can also open the global or local config with your editor and add all aliases in the section for them.**

```bash
[alias]
	p = push
	s = status
	logp = log --decorate --all --graph
	last = log -1 HEAD --decorate --graph
	fs = !git fetch && git status -uno
	tags = show-ref --tags
	c = commit -am
	ca = !git add -A && git commit -m
```

<br>

<hr>

<a name="configuration-files"></a>

## Configuration Files

**Repository specific configuration file [--local].**

```bash
<repo>/.git/config
```

****User-specific configuration file [--global].**

```bash
~/.gitconfig
```

****System-wide configuration file [--system].**

```bash
/etc/gitconfig
```

<br>

<hr>

<a name="create"></a>

## Create

**Clone an existing repository.**

There are two ways

Via SSH

```bash
git clone ssh.**//user@domain.com/repo.git
```

Via HTTP

```bash
git clone http.**//domain.com/user/repo.git
```

**Create a new local repository in the current directory.**

```bash
git init
```

**Create a new local repository in a specific directory.**

```bash
git init <directory>
```

<br>

<hr>

<a name="local-changes"></a>

## Local Changes

**Changes in working directory.**

```bash
git status
```

**Changes to tracked files.**

```bash
git diff
```

**See changes/difference of a specific file.**

```bash
git diff <file>
```

**Add all current changes to the next commit.**

```bash
git add .
```

**Add some changes in &lt;file&gt; to the next commit.**

```bash
git add -p <file>
```

**Add only the mentioned files to the next commit.**

```bash
git add <filename1> <filename2>
```

**Commit all local changes in tracked files.**

```bash
git commit -a
```

**Commit previously staged changes.**

```bash
git commit
```

**Commit with message.**

```bash
git commit -m 'message here'
```

**Commit skipping the staging area and adding message.**

```bash
git commit -am 'message here'
```

**Commit to some previous date.**

```bash
git commit --date="`date --date='n day ago'`" -am "<Commit Message Here>"
```

**Change last commit.**<br>
<em><sub>Don't amend published commits!</sub></em>

```bash
git commit -a --amend
```

**Amend with last commit but use the previous commit log message**
<em><sub>Don't amend published commits!</sub></em>

```bash
git commit --amend --no-edit
```

**Change committer date of last commit.**

```bash
GIT_COMMITTER_DATE="date" git commit --amend
```

**Change Author date of last commit.**

```bash
git commit --amend --date="date"
```

**Move uncommitted changes from current branch to some other branch.**

<br>

```bash
git stash
git checkout branch2
git stash pop
```

**Restore stashed changes back to current branch.**

```bash
git stash apply
```

**Restore particular stash back to current branch.**

* *{stash_number}* can be obtained from `git stash list`

```bash
git stash apply stash@{stash_number}
```

**Remove the last set of stashed changes.**

```bash
git stash drop
```

<br>

<hr>

<a name="search"></a>

## Search

**A text search on all files in the directory.**

```bash
git grep "Hello"
```

**In any version of a text search.**

```bash
git grep "Hello" v2.5
```

**Show commits that introduced a specific keyword.**

```bash
git log -S 'keyword'
```

**Show commits that introduced a specific keyword (using a regular expression).**

```bash
git log -S 'keyword' --pickaxe-regex
```

<br>

<hr>

<a name="commit-history"></a>

## Commit History

**Show all commits, starting with newest (it'll show the hash, author information, date of commit and title of the commit).**

```bash
git log
```

**Show all the commits(it'll show just the commit hash and the commit message).**

```bash
git log --oneline
```

**Show all commits of a specific user.**

```bash
git log --author="username"
```

**Show changes over time for a specific file.**

```bash
git log -p <file>
```

**Display commits that are present only in remote/branch in right side

```bash
git log --oneline <origin/master>..<remote/master> --left-right
```

**Who changed, what and when in &lt;file&gt;.**

```bash
git blame <file>
```

**Show Reference log.**

```bash
git reflog show
```

**Delete Reference log.**

```bash
git reflog delete
```

**Show the last commit on HEAD of the current branch.**

```bash
git show HEAD
```

**You can use ^ to select the parent of a commit and ~ to select the grandparent of a commit.**

```bash
git show HEAD^   # Show the parent commit of HEAD
git show HEAD^^ # Show the grandparent commit of HEAD (HEAD^^^ for great-grandparent)
git show HEAD~ # Same as HEAD^
git show HEAD~2 # Same as HEAD^^
git show HEAD~3 # Same as HEAD^^^
```

**See the changes of the last commit before certain desired time.**

```bash
git show 'HEAD@{1 month ago}' # See the last commit before a month
git show 'HEAD@{1 week ago}' # See the last commit before a week
git show 'HEAD@{1 day ago}' # See the last commit before a day
```

<br>

<hr>

<a name="move--rename"></a>

## Move / Rename

**Rename a file.**

Rename Index.txt to Index.html


```bash
git mv Index.txt Index.html
```

<br>

<hr>

<a name="branches--tags"></a>

## Branches & Tags

**List all local branches.**

```bash
git branch
```

**List local/remote branches.**

```bash
git branch -a
```

**List all remote branches.**

```bash
git branch -r
```

**Switch HEAD branch.**

```bash
git checkout <branch>
```

**Checkout single file from different branch.**

```bash
git checkout <branch> -- <filename>
```

**Create and switch new branch.**

```bash
git checkout -b <branch>
```

**Switch to the previous branch, without saying the name explicitly.**

```bash
git checkout -
```

**Create a new branch from an exiting branch and switch to new branch.**

```bash
git checkout -b <new_branch> <existing_branch>
```


**Checkout and create a new branch from existing commit.**

```bash
git checkout <commit-hash> -b <new_branch_name>
```

**Create a new branch based on your current HEAD.**

```bash
git branch <new-branch>
```

**Create a new tracking branch based on a remote branch.**

```bash
git branch --track <new-branch> <remote-branch>
```

**Delete a local branch.**

```bash
git branch -d <branch>
```

**Rename current branch to new branch name.**

```bash
git branch -m <new_branch_name>
```

**Force delete a local branch.**
<em><sub>You will lose unmerged changes!</sub></em>


```bash
git branch -D <branch>
```

**Mark `HEAD` with a tag.**

```bash
git tag <tag-name>
```

**Mark `HEAD` with a tag and open the editor to include a message.**

```bash
git tag -a <tag-name>
```

**Mark `HEAD` with a tag that includes a message.**

```bash
git tag <tag-name> -am 'message here'
```

**List all tags.**

```bash
git tag
```

**List all tags with their messages (tag message or commit message if tag has no message).**

```bash
git tag -n
```

<br>

<hr>

<a name="update--publish"></a>

## Update & Publish

**List all current configured remotes.**

```bash
git remote -v
```

**Show information about a remote.**

```bash
git remote show <remote>
```

**Add new remote repository, named &lt;remote&gt;.**

```bash
git remote add <remote> <url>
```

**Rename a remote repository, from &lt;remote&gt; to &lt;new_remote&gt;.**

```bash
git remote rename <remote> <new_remote>
```

**Remove a remote.**

```bash
git remote rm <remote>
```

<em><sub>Note.** git remote rm does not delete the remote repository from the server. It simply removes the remote and its references from your local repository.</sub></em>

**Download all changes from &lt;remote&gt;, but don't integrate into HEAD.**

```bash
git fetch <remote>
```

**Download changes and directly merge/integrate into HEAD.**

```bash
git remote pull <remote> <url>
```

**Get all changes from HEAD to local repository.**

```bash
git pull origin master
```

**Get all changes from remote HEAD to local repository and put local changes on top of the pulled one - rebase instead of merge.**

```bash
git pull --rebase <remote> <branch>
```

**Publish local changes on a remote.**

```bash
git push <remote> <branch>
```

**Delete a branch on the remote. Don't delete branches on remote that other developers/team members work on, always agree with the team before deleting a branch on remote!**

```bash
git push <remote> .**<branch> (since Git v1.5.0)
```
OR

```bash
git push <remote> --delete <branch> (since Git v1.7.0)
```

**Publish your tags on remote.**

```bash
git push --tags
```

<hr>

**Configure the merge tool globally to meld (editor).**

```bash
git config --global merge.tool meld
```

**Use your configured merge tool to solve conflicts.**

```bash
git mergetool
```

<br>

<hr>

<a name="merge--rebase"></a>

## Merge & Rebase

**Merge branch into your current HEAD.**

```bash
git merge <branch>
```

**List merged branches.**

```bash
git branch --merged
```

**Rebase your current HEAD onto &lt;branch&gt;.**<br>
<em><sub>Don't rebase published commit!</sub></em>


```bash
git rebase <branch>
```

**Abort a rebase.**

```bash
git rebase --abort
```

**Continue a rebase after resolving conflicts.**

```bash
git rebase --continue
```

**Use your editor to manually solve conflicts and (after resolving) mark file as resolved.**

```bash
git add <resolved-file>
```

```bash
git rm <resolved-file>
```

**Squashing commits.**

```bash
git rebase -i <commit-just-before-first>
```

Now replace this,

```bash
pick <commit_id>
pick <commit_id2>
pick <commit_id3>
```

to this,

```bash
pick <commit_id>
squash <commit_id2>
squash <commit_id3>
```

<br>

<hr>

<a name="undo"></a>

## Undo Changes

**Discard all local changes in your index and working directory. This command will copy the latest state of the files from the repository into your index and working area.**

```bash
git reset --hard HEAD
```

**Discard all local changes in your index stage phase. This command will copy the latest state of the files from the repository into your index only. Because of the soft paramater it will not copy/replace the files within your working area.**

```bash
git reset --soft HEAD
```

**Discard all local changes in your index stage phase for a particular file. This command will copy the latest state of a chosen file from the repository into your index, but it will not overwrite the content of that file into your working directory.**

```bash
git reset HEAD <filename>
```

**Discard all local changes for a particular file, you CAN'T use `git reset --hard` on single file. To do the tricke here you need to use `git checkout` command. This command will overwrite the latest state of a chosen file from the repository into your index and working area.**

* Use this command with caution as it will overwrite your file in all stages and you will lose the content even in your working area. Use it only if you want to do a full revert on the file!

```bash
git checkout HEAD <filename>
```

**Discard all local changes in your working directory. This command will copy the latest state of the files from the repository into your index only, because of the soft paramater it will not copy/replace the files within working area.**

```bash
git reset --soft HEAD
```

**Get all the files out of the staging area(i.e. undo the last `git add`).**

```bash
git reset HEAD
```

**Discard local changes in a specific file.**

```bash
git checkout HEAD <file>
```

**Revert a commit (by producing a new commit with contrary changes).**

```bash
git revert <commit>
```

**Reset your HEAD pointer to a previous commit and discard all changes since then. This will reset your local repository, index and working area to the last head state of a choosen commit id.**

```bash
git reset --hard <commit>
```

**Reset your HEAD pointer to a remote branch current state. This will reset your local repository, index and working area to the last head state of the remote repository.**

```bash
git reset --hard <remote/branch> e.g., upstream/master, origin/my-feature
```

**Reset your HEAD pointer to a previous commit and preserve all changes as unstaged changes.**

```bash
git reset <commit>
```

**Reset your HEAD pointer to a previous commit and preserve uncommitted local changes.**

```bash
git reset --keep <commit>
```

**Remove files that were accidentally committed before they were added to .gitignore**

```bash
$ git rm -r --cached .
$ git add .
$ git commit -m "remove xyz file"
```