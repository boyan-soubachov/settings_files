# Path to your oh-my-zsh installation.
export ZSH=/Users/boyansoubachov/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="lambda"
#lambda
#fishy
#minimal

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(brew git docker git-extras)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

EDITOR='vim'

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa.pub"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#CUDA
export PATH=/usr/local/cuda/bin:$PATH
export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH

#Takealot git helper functions
function code-on {
    git checkout -b $1 origin/master
}

function code-push {
    local branch=`git rev-parse --abbrev-ref HEAD`
    [[ "$branch" == "master" ]] && echo "should be on feature branch" && return 1
    git push origin HEAD:$branch $@
}
function code-pr {
    local branch=`git rev-parse --abbrev-ref HEAD`
    [[ "$branch" == "master" ]] && echo "should be on feature branch" && return 1
    git push origin HEAD:$branch || return 1
    hub pull-request -h $branch
}
function code-release {
    local branch=`git rev-parse --abbrev-ref HEAD`
    [[ "$branch" == "master" ]] && echo "should be on feature branch" && return 1
    git pull --rebase || return 1
    git push origin HEAD:$branch -f || return 1
    git push origin HEAD:master || return 1
    git checkout master || return 1
    git push origin :$branch || return 1
    git branch -d $branch || return 1
    git pull
}
function tf-version() {
  if [ -z $1 ]; then
    echo "You must specify the version!"
    return
  fi
  echo "Switching to terraform version $1"
  if [ ! -f /usr/local/Cellar/terraform/$1/terraform ]; then
    echo "New version of terraform, downloading..."
    curl -S https://releases.hashicorp.com/terraform/$1/terraform_$1_darwin_amd64.zip > /tmp/tf_$1.zip \
      && cd /tmp \
      && unzip /tmp/tf_$1.zip \
      && mkdir -p /usr/local/Cellar/terraform/$1/ \
      && mv terraform /usr/local/Cellar/terraform/$1/ \
      && rm /tmp/tf_$1.zip \
      && cd -
  fi
  rm /usr/local/bin/terraform
  ln -s /usr/local/Cellar/terraform/$1/terraform /usr/local/bin/terraform
  echo "Confirming version from binary:"
  terraform --version
}
