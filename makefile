all: ~/.vimrc ~/.gitconfig ~/.my.zshrc /etc/systemd/system/sslocal.service

~/.vimrc: vimrc
	cp vimrc ~/.vimrc

~/.gitconfig: gitconfig
	cp gitconfig ~/.gitconfig

~/.my.zshrc: my.zshrc
	cp my.zshrc ~/.my.zshrc

/etc/systemd/system/sslocal.service: sslocal.service
	sudo cp sslocal.service /etc/systemd/system/
	sudo systemctl reenable sslocal
	echo "sslocal.service updated, need to reboot"
