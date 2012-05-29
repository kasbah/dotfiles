#set -o vi

#editor
export EDITOR="/usr/bin/vim"
#cabal path
PATH=$PATH:~/.cabal/bin/
PATH=$PATH:~/bin/
PATH=$PATH:~/.gem/ruby/1.8/bin/
PATH=$PATH:~/.gem/ruby/1.9.1/bin/
PATH=$PATH:/var/lib/gems/1.8/bin/

#PATH=$PATH:/opt/XMOS/DesktopTools/10.4.2/bin/
# Check for an interactive session
#XMOS tools
#cd /opt/XMOS/DesktopTools/10.4.2/
#. SetEnv
#cd

#source z
source ~/bin/z.sh

function zp() {
z $1 $2 $3 $4 && pwd
}
#source f
source ~/bin/f.sh

function cdl {
cd $1;
ls;
}

alias grep="grep -I"

alias dums="du -m --max-depth=1|sort -n"

#hg mercurial 
alias hg_revert_add="hg status -an0 | xargs -0 hg revert"

alias shutat="sudo /etc/rc.d/atd start && echo 'sudo halt' | at" 

#timetrap sync
alias tup="rsync ~/.timetrap.db kaspar@kaspar.webhop.net:.timetrap.db"
alias tdown="rsync kaspar@kaspar.webhop.net:.timetrap.db ~/.timetrap.db"

#sudo bash completion
complete -cf sudo
alias sudo='sudo '

alias sync_time="sudo ntpd -qg && sudo hwclock -w"

alias sudo='A=`alias` sudo  '
[ -z "$PS1" ] && return
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias et='urxvt &'
alias web='firefox &'
alias jd='java -jar ~/JDownloader/JDownloader.jar &'
alias copy='cp -n'
alias move='mv -f'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias hist='history | grep'
alias remove='rm -f'
alias show='gpicview'
alias query='xdg-mime query filetype'
alias xdgset='xdg-mime default'
alias xp='echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\"" && xprop | grep "WM_WINDOW_ROLE\|WM_CLASS"'
alias spotify='wine "C:\Program Files\Spotify\spotify.exe"'
#alias xo='xdg-open'

function xo () {
  xdg-open "$1" &> /dev/null &
}

function o () {
$1 &> /dev/null &
}

HISTSIZE=5000
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf   $1    ;;
          *.tar.gz)    tar xvzf   $1    ;;
          *.tar.xz)    tar xvJf   $1    ;;
          *.bz2)       bunzip2    $1    ;;
          *.rar)       unrar x    $1    ;;
          *.gz)        gunzip     $1    ;;
          *.tar)       tar xvf    $1    ;;
          *.tbz2)      tar xvjf   $1    ;;
          *.tgz)       tar xvzf   $1    ;;
          *.zip)       unzip      $1    ;;
          *.Z)         uncompress $1    ;;
          *.7z)        7z x       $1    ;;
          *.xz)        unxz       $1    ;;
          *.exe)       cabextract $1    ;;
          *)           echo "\"$1\": unrecognized file compression" ;;
      esac
  else
      echo "'$1' is not a valid file"
  fi
}
#function to mkdir and cd into it
function mkcd() {
mkdir -p "$@"&& eval cd "\"\$$#\""; 
}
#functions to help extract and move things from ~/Downloads folder
function extractl() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
extract "$path";
}
function lessl() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
less $path;
}

function cpl() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
echo "copying $path to current directory"
cp $path .;
}

function vlcl() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
vlc $path;
}


function viml() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
vim $path;
}

function echol() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
echo "$path";
}
function dlast () {
$1 $(echol)
}

#working dir switching
function cwd() {
	pwd > ~/.cwd;
}


source /usr/share/git/completion/git-completion.bash
#source /etc/bash_completion

#git PS1
#GIT_PS1_SHOWDIRTYSTATE=1 #... untagged(*) and staged(+) changes
#GIT_PS1_SHOWSTASHSTATE=1 #... if something is stashed($)
#GIT_PS1_SHOWUNTRACKEDFILES=1 #... untracked files(%)

#PS1='[\u@\h \W$(_git_ps1 " (%s)")]\$ '
#cd `cat ~/.cwd`

#google calender cli
alias gcal="gcalcli"
