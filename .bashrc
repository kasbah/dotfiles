#cabal path
PATH=$PATH:/home/kaspar/.cabal/bin/
# Check for an interactive session
alias sudo='A=`alias` sudo  '
[ -z "$PS1" ] && return
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias et='urxvt &'
alias web='firefox &'
alias x='exit'
alias q='exit'
alias :q='exit'
alias jd='java -jar ~/JDownloader/JDownloader.jar &'
alias copy='cp -n'
alias move='mv -f'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias hist='history | grep'
alias remove='rm -f'
alias mountntfs='sudo mount -t ntfs-3g /dev/sda1 /media/ntfs/ -o uid=0,gid=0,noatime,umask=000,locale=en_US.utf8 && thunar /media/ntfs &'
alias xp='echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\"" && xprop | grep "WM_WINDOW_ROLE\|WM_CLASS"'
alias spotify='wine "C:\Program Files\Spotify\spotify.exe"'
HISTSIZE=5000
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.tar.xz)    tar xvJf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "\`$1': unrecognized file compression" ;;
      esac
  else
      echo "\`$1' is not a valid file"
  fi
}
#function to mkdir and cd into it
function mkcd() {
mkdir -p "$@"&& eval cd "\"\$$#\""; 
}
#functions to help extract and move things from ~/Downloads folder
function extractl() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
extract $path;
}
function lessl() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
less $path;
}
function echol() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
echo $path;
}
function dlast () {
$1 $(echol)
}
function mvl() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
mv -i $path .;
}
function rml() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
rm -i $path;
} 
function tmpl() {
path=~/Downloads/$(ls -cr ~/Downloads | tail --lines=1);
mv -i $path ~/Downloads/store/ && echo "mv -i $path ~/Downloads/store/";
} 
function untmpl() {
path=~/Downloads/store/$(ls -cr ~/Downloads/store/ | tail --lines=1);
cp -i $path ~/Downloads && echo "mv -i $path ~/Downloads/";
rm $path
} 
