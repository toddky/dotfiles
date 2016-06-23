
local here=${0:h}

# --- Path ---
function addpath() { export PATH=$PATH:$1; }

# --- Source Files ---
function source_files() {
	for f in $(\ls $@); do
		source $f
	done
}

function echo_eval() {
	echo "$@"
	eval "$@"
}

# --- zsh ---
alias zshrc='source ~/.zshrc'
alias vzshrc='vi ~/.zshrc'

# --- General ---
alias a='alias'
alias ag='alias | grep'
alias h='history'
alias hg='history | grep'
alias which=type

alias cd='cd -P'
alias pwd='pwd -P'
alias mkdir='mkdir -pv'

alias findn='find . -name'

alias hostname='hostname --long'

# --- General ---
alias wrap="printf '\033[?7h'"
alias nowrap="printf '\033[?7l'"
alias tab2="expand -t2"
alias tab4="expand -t4"
alias tab8="expand -t8"
alias xterm='xterm -fg white -bg black -fa consolas -fs 10'

alias lns='ln -s'

alias catn='cat -n'
alias tailf='tail -n 100 -f'

alias echo='echo -e'

alias .tar='tar xf'
alias .tar.bz2='tar xjf'
alias .tar.gz='tar xzf'

alias ls='ls -h --color'
alias ll='ls -lrth'
alias lll='ll | grep "\->"'
alias lsd='ll -d */'
alias lla='ll -a'
alias ls1='find . -maxdepth 1'
alias ls2='find . -maxdepth 2'
alias ls3='find . -maxdepth 3'
alias ls4='find . -maxdepth 4'
alias ls5='find . -maxdepth 5'
alias ls6='find . -maxdepth 6'

alias find1='ls1 | grep -i'
alias find2='ls2 | grep -i'
alias find3='ls3 | grep -i'
alias find4='ls4 | grep -i'
alias find5='ls5 | grep -i'
alias find6='ls6 | grep -i'

alias df='df -h'
alias du='du -h'
alias du1='du --max-depth=1'
alias du2='du --max-depth=2'
alias du3='du --max-depth=3'

alias less='less -r'
alias vless="col -b | vim -c 'set ts=8 nomod nolist noma' -"

alias license='lmstat -a'

function calc() { bc -l <<< "$@"; }

function blank() { dd if=/dev/zero of=blank"$1"M.bin bs=1M count=$1; }

function setdisp() {
	[[ -n $LSB_BATCH_JID ]] && return
	[[ -z $VNCDESKTOP ]] && return
	port=$(echo $VNCDESKTOP | awk 'match($1, /.*(:[0-9]+)/, groups) {print groups[1]}')
	export DISPLAY=$port.0
}

function rmrf() {
	for f in $@; do
		f=${f%/}
		mv $f deleting.$f.$$
		rm -rf deleting.$f.$$ &
	done
}

# --- Source Files ---
source $here/my-env.zsh
source $here/my-options.zsh
source_files $here/alias.*.zsh
