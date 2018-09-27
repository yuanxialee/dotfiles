# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# make the bash history bigger
HISTSIZE=50000
HISTFILESIZE=$HISTSIZE*100

# set history time format string
HISTTIMEFORMAT="[%F %T] "

# configure command prompt
RESET=$(tput sgr0)
GREEN=$(tput setaf 2)
BOLD=$(tput bold)
DIM=$(tput dim)

# get current branch in git repo
function parse_git_branch() {
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ! "${BRANCH}" == "" ]
  then
    echo "(${GREEN}${BRANCH}${RESET})"
  else
    echo ""
  fi
}

# title a terminal tab
function title() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}


# Limit number of cores used during a make based on the number of users on the current machine
function makej(){
        LOWER_LIMIT=8
        UPPER_LIMIT=`nproc`-1
        NUMBER_OF_UNIQUE_USERS=`who | awk '{print $1}' | sort -u | wc -l`
        CORES_TO_USE=`echo "$LOWER_LIMIT+($UPPER_LIMIT-$LOWER_LIMIT)/$NUMBER_OF_UNIQUE_USERS" | bc | xargs printf "%.0f"`

        make -j $CORES_TO_USE $@
}

format()
{
    if [[ -n "$1" ]]; then
        echo "Formatting file: `clang-format -style=file "$1" -i -assume-filename=~/.clang-format`"
    else
        echo "Formatting directory: `clang-format -style=file *.cpp -i -assume-filename=~/.clang-format; clang-format -style=file *.hpp -i -assume-filename=~/.clang-format`"
    fi
}

export PS1="${BOLD}[\u@\h]:${RESET} \w \`parse_git_branch\`\\n\$ "

# LMI
export LMI_ID="e372678"
export COMPUTER_ID="sr315351"

# aliases
#alias makej="echo `nproc`-1 | bc | xargs echo | xargs make -j"
alias cmakej="clear;makej" 
alias in_use="if (( `who | grep -v pts | wc -l` > 2 )); then echo \"True\"; else echo \"False\"; fi"

# PATH updates
export GOPATH=$HOME/go
export PATH=$HOME/bin:$GOPATH/bin:$PATH
export XAUTHORITY=$HOME/.Xauthority

# Set the amount of time to wait before closing a remote connection
export TMOUT=7200 # in seconds (this is 2 hours)


# Needed it for github
PROXY="proxy3.lmco.com:80"
export HTTP_PROXY=${PROXY}
export http_proxy=${PROXY}
export HTTPS_PROXY=${PROXY}
export https_proxy=${PROXY}
export GIT_SSL_NO_VERIFY=1

# Load custom commands 
. ~/bin/switch_build_src.bsh
. ~/bin/usernames.sh
