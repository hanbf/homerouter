all: ~/.vimrc ~/.gitconfig ~/.my.zshrc

~/.vimrc: vimrc
	cp vimrc ~/.vimrc

~/.gitconfig: gitconfig
	cp gitconfig ~/.gitconfig

~/.my.zshrc: my.zshrc
	cp my.zshrc ~/.my.zshrc
