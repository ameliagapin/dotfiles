# prompt
# https://github.com/jimeh/git-aware-prompt
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"

# No emoji
# PS1="[\u@:$(scutil --get ComputerName) \W \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]]\$ "
# emoji!
ME_EMOJI=(🙄 🙏 ☠️ 💩 🔪 🖕)
INDEX=$[RANDOM%6]
RANDOM_ME_EMOJI=${ME_EMOJI[$INDEX]}
PS1="\[👩‍💻‍\]  \u 💻  $(scutil --get ComputerName) 🤷  \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\] $RANDOM_ME_EMOJI  "

# GO
export GOPATH=$HOME/Projects/go
export GOPATH=/bitly
export PATH=$PATH:$(go env GOPATH)/bin

# bash completion
# http://blog.taylormcgann.com/tag/gitconfig/
# https://github.com/bobthecow/git-flow-completion/wiki/Install-Bash-git-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# This makes nvm available on login
# if [ -x "$(command -v brew)" ]; then
#  export NVM_DIR=~/.nvm
#  source $(brew --prefix nvm)/nvm.sh
# fi

# mysql
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

# aliases
alias p="atom ~/.bash_profile"
alias s="source ~/.bash_profile"

# directory aliases
alias dev="cd ~/Projects/devvm"
alias bitly="cd /bitly"
alias data="cd /data"
alias mountall="sudo mount /bitly && sudo mount /data"

## vagrant
alias vp="vagrant provision"

## git
alias gdelmerged="git branch --merged | grep -v \* | grep -v '^\s*master$' | grep -v '^\s*develop$' | xargs -t -n 1 git branch -d"
alias gp='git pull'
alias gc="git checkout"
alias gcm="git checkout master"
alias gpm="git pull origin master"
alias gnb="git checkout -b"
alias gcmp="git checkout master && git pull"

# Setting PATH for Python 3.5
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
