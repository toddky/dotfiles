
# --- Ignore Files ---
ignore = Makefile README.md custom

# --- Get Files/Directories ---
dirs = $(wildcard */)
dirs := $(dirs:%/=%)
files = $(filter-out $(dirs), $(wildcard *))
links = $(addprefix $(HOME)/., $(filter-out $(ignore), $(wildcard *)))

# --- oh-my-zsh ---
zsh = $(HOME)/.oh-my-zsh
plugins := $(wildcard custom/plugins/*/)
plugins := $(addprefix $(zsh)/, $(plugins:%/=%))
themes = $(zsh)/custom/themes

# --- powerline ---
temp := $(shell mktemp -d)
fonts := $(HOME)/.fonts
fontconfig := $(HOME)/.config/fontconfig/conf.d

# --- All ---
all: zsh links vundle

# --- Symbolic Links ---
links: $(links)
$(HOME)/.%: $(PWD)/%; ln -fs $< $@

# --- oh-my-zsh ---
# zsh framework manager
zsh: $(zsh)/oh-my-zsh.sh plugins themes
$(zsh)/oh-my-zsh.sh:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
plugins: $(plugins)
themes: $(themes)
$(plugins) $(themes):
	ln -fs $(@:$(zsh)/%=$(PWD)/%) $@

# --- fzf ---
fzf: $(HOME)/.fzf
	$(HOME)/.fzf/install --no-key-bindings --no-completion --no-update-rc
	#$(HOME)/.fzf/install --no-key-bindings --completion --no-update-rc
$(HOME)/.fzf:
	git clone --depth 1 https://github.com/junegunn/fzf.git $(HOME)/.fzf

# --- Powerline Font ---
fonts: $(fonts)/fonts.dir $(fonts)/fonts.scale $(fontconfig)/10-powerline-symbols.conf
	xset q | grep -q $(fonts) || xset +fp $(fonts)
	fc-cache -fv $(fonts)
$(fonts)/fonts.dir: $(fonts)/PowerlineSymbols.otf
	mkfontdir $(fonts)
$(fonts)/fonts.scale: $(fonts)/PowerlineSymbols.otf
	mkfontscale $(fonts)
$(fonts)/PowerlineSymbols.otf:
	@mkdir -p $(fonts)
	@wget -P $(fonts) https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
$(fontconfig)/10-powerline-symbols.conf:
	mkdir -p $(fontconfig)
	wget -P $(fontconfig) https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf

# --- Vundle ---
# vim plugin manager
vundle: $(HOME)/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
$(HOME)/.vim/bundle/Vundle.vim:
	git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

# --- Clean ---
clean:
	rm $(links)
	rm $(plugins:%/=%)
	rm $(themes:%/=%)

