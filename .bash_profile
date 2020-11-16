alias dpice='cd ~/dp/fork/data-platform-iceberg'
alias dpconf='cd ~/dp/data-platform'
alias kconf='cd ~/code/deployment-config'

ssh-add -A 2> /dev/null

export BASH_SILENCE_DEPRECATION_WARNING=1
export BASE_PKI_PATH=~/certs

alias setLocalGithub='git config --local user.name "johnclara" && git config --local user.email john.anthony.clara@gmail.com'
alias copybara="/Users/jclara/code/copybara/bazel-bin/java/com/google/copybara/copybara"
export VAULT_ADDR="https://vault.dsv31.boxdc.net:8200"

export PATH=$PATH:/box/www/devtools/bin

__kapply () { scp ~/code/deployment-config/release/dsv31/dev/$1/app.json jclara@compute-jump7001.dsv31.boxdc.net:~; ssh jclara@compute-jump7001.dsv31.boxdc.net 'kubectl apply -f ~/app.json'; }
__kapply2 () { scp ~/code/deployment-config/release/dsv31-k8s-c1/dev/$1/app.json jclara@compute-jump7001.dsv31.boxdc.net:~; ssh jclara@compute-jump7001.dsv31.boxdc.net 'kubectl apply -f ~/app.json'; }
__kapply_staging () { scp ~/code/deployment-config/release/dsv31/staging/$1/app.json jclara@compute-jump7001.dsv31.boxdc.net:~; ssh jclara@compute-jump7001.dsv31.boxdc.net 'kubectl apply -f ~/app.json'; }
__kapply_staging2 () { scp ~/code/deployment-config/release/dsv31-k8s-c1/staging/$1/app.json jclara@compute-jump7001.dsv31.boxdc.net:~; ssh jclara@compute-jump7001.dsv31.boxdc.net 'kubectl apply -f ~/app.json'; }
__kapply_prod () { scp ~/dcode/eployment-config/release/$2/prod/$1/app.json jclara@bastion:~; ssh jclara@bastion 'kubectl apply -f ~/app.json'; }
alias kapply=__kapply
alias kapply2=__kapply2
alias kapply_staging=__kapply_staging
alias kapply_staging2=__kapply_staging2
alias kapply_prod=__kapply_prod

__ubd () {
  searchterm=$(echo "$1" | sed "s/ /%20/g")
  curl http://api.urbandictionary.com/v0/define?term=$searchterm | python -m json.tool;
}
alias ubd=__ubd

export JAVA_HOME=$(/usr/libexec/java_home)

export GOPATH="$HOME/code/go"
export PATH="$PATH:$GOPATH/bin"

export SBT_OPTS="-Xmx2G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=2G -Xss2M  -Duser.timezone=GMT"

# Private for stuff not on github (if exists)
[ -f ~/.bash_private ] && source ~/.bash_private

# Colors for LS and Grep
export CLICOLOR=1 # LS Color
alias grep="grep --color=auto"
export GREP_COLOR='1;32'

# Better Bash History
shopt -s histappend # session appends not overwrites to history
HISTFILESIZE=10000
HISTSIZE=10000
HISTCONTROL=ignoreboth # ignore dup commands, commands starting with space
# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# export PROMPT_COMMAND="history -a; history -c; $PROMPT_COMMAND"

# Use nvim or vim as editor
if hash nvim 2>/dev/null;
then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

if [ -e ~/dev/util/lesspipe.sh ];
then
  export LESS='-R'
  export LESSOPEN='|~/dev/util/lesspipe.sh %s'
fi

# ------------------------------------------------------
#            OSX Only
# ------------------------------------------------------
# Use Terminal's colors for emacs (Mac OS X)
[[ "$OSTYPE" == "darwin"* ]] && export TERM='xterm-256color'
# Disable brew analytics
[[ "$OSTYPE" == "darwin"* ]] && export HOMEBREW_NO_ANALYTICS=1
# pbcopy / pbpaste for OSX clipboard
if [[ "$OSTYPE" == "darwin"* ]]
then
    alias pp=pbpaste
    alias pc=pbcopy
fi
# Load bash completions from brew
if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
fi

# ------------------------------------------------------
#            Custom Prompt
# ------------------------------------------------------
GIT_PS1_SHOWDIRTYSTATE=true
BLUE="\[\e[0;34m\]"
NORMAL="\[\e[0m\]"

# Construct PS1
# Commands need to be in single quotes or they will expand on PS1 creation, not each time the prompt
# runs
PS1="${BLUE}"
[ -n "$SSH_CLIENT" ] && PS1+="\u@\h :: "
PS1+="\W/"
hash __git_ps1 2>/dev/null && PS1+='$(__git_ps1)'
PS1+=" > ${NORMAL}"

# ------------------------------------------------------
#            Command Aliases / Functions
# ------------------------------------------------------
alias la="ls -lah"
alias igrep="grep -ir"
if hash rg 2>/dev/null; then alias rgi="rg -i"; fi
alias aliases="cat ~/.bash_private ~/.bash_profile | grep '^alias\|^function'";

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }
# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'"${1:-}"'*' -exec ${2:-file} {} \;  ; }

sorted-du () {
  paste -d '#' <(du -cs $1) <(du -chs $1) | sort -rn | cut -d '#' -f 2
}

# ------------------------------------------------------
#                       PATH
# ------------------------------------------------------
# Include
# - local executables
# - util
export PATH="/usr/local/opt/php@7.1/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/sbin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jclara/access_stats/google-cloud-sdk/path.bash.inc' ]; then . '/Users/jclara/access_stats/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jclara/access_stats/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/jclara/access_stats/google-cloud-sdk/completion.bash.inc'; fi
export PATH="/usr/local/opt/terraform@0.11/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

__zeppelin_export () { ssh -A -t bastion -A scp $1:/tmp/export.tar.gz . && scp bastion:~/export.tar.gz . ; }
alias zeppelin_export=__zeppelin_export

source .promptline.sh
