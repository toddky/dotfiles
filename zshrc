
# TODO: Investigate antibody: https://github.com/getantibody/antibody

# --- oh-my-zsh ---
export ZSH=$HOME/.oh-my-zsh
export EDITOR=emacs
export SHELL=$(builtin which zsh)
export ZSH_CUSTOM=$HOME/.zsh/custom

DISABLE_AUTO_TITLE=true
COMPLETION_WAITING_DOTS="true"

# --- Setup .zcompdump Directory ---
[[ -z $ZSH_COMPDIR ]] && ZSH_COMPDIR=~/.zcompdir
mkdir -p $ZSH_COMPDIR
ZSH_COMPDUMP=$ZSH_COMPDIR/$(hostname --long)

# --- Setup Theme ---
ZSH_THEME_DEFAULT="my-theme"
[[ -z $ZSH_THEME ]] && ZSH_THEME=$ZSH_THEME_DEFAULT

if [[ $(hostname --long) =~ arm.com$ ]]; then
    plugins=(arm lsf eda)
else
    function module(){}
fi

#plugins+=(bin modules my-zsh cd vim xclip tmux regex math setup vcs)
plugins+=(bin modules my-zsh cd vim xclip tmux math setup vcs)
[[ -f ~/.fzf.zsh ]] && plugins+=(fzf)
plugins+=(history-substring-search)

# --- Source Files ---
function source_files() {
    for f in $(command ls $@); do
	source $f
    done
}

#function source() {
#	local start_ms=$(date +%s%3N)
#	builtin source $1
#	echo "$(($(date +%s%3N)-$start_ms)) $1"
#}
#alias pastebin='echo "paste_text=$(cat -)" | curl -X POST --netrc-file ~/.netrc -s --data-binary @- http://p.arm.com | grep -o "http[^\"]*"'
#alias pastebin='awk '"'"'BEGIN{print "paste_text=$("} {print} END{print ")"}'"'"' | curl -X POST --netrc-file ~/.netrc -s --data-binary @- http://p.arm.com | grep -o "http[^\"]*" | xclip && xclip -o'

function pastebin() {
    local input="paste_text=$(xargs echo)"
    echo $input
    echo $input |sed 's/\x1b\[[0-9;]*m//g'| curl -s -X POST --netrc-file ~/.netrc --data-binary @- http://p.arm.com | grep -o "http[^\"]*" | xclip && xclip -o
}


source $ZSH/oh-my-zsh.sh

alias mongo_haps='/arm/tools/setup/bin/mrun +util +mongodb/mongodb/3.2.1 mongo --authenticationDatabase admin -u haps_user -p h4p3n5t4nc3 armprod/mongodb1.nahpc.arm.com,mongodb2.nahpc.arm.com,mongodb-arb.nahpc.arm.com/haps_nahpc'

# 0 . Enter
bindkey -s "^[Op" "0"
bindkey -s "^[Ol" "."
bindkey -s "^[OM" "^M"

alias -g -- '-velconf'="-conf /home/lsf/scheduler_prod/configs/NAHPCVEL/NAHPCVEL.conf"
alias -g -- '-zs3conf'="-conf /home/lsf/scheduler_prod/configs/NAHPCPRODZS3/NAHPCPRODZS3.conf"


alias emacs='emacs -nw'

_set-display

alias build-sched-fast='/arm/devsys-tools/abs/pbuild --perform build,collect'
alias build-sched='/arm/devsys-tools/abs/pbuild TOEF:scheduler:0.1 --update-xml --set-state spotless --use-tool=go:go:MODULES:google/golang/1.6'
alias pretty-json='ruby -e "require '\''json'\''; puts (JSON.pretty_generate JSON.parse(STDIN.read))"'
#alias pretty-json='ruby -e "require '\''yaml'\''; puts YAML.load(STDIN.read).to_json"'
