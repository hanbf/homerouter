all: ~/.vimrc ~/.gitconfig ~/.my.zshrc /etc/systemd/system/sslocal.service /etc/iptables/rules.v4 /etc/dnscrypt-proxy/dnscrypt-proxy.toml

~/.vimrc: vimrc
	cp vimrc ~/.vimrc

~/.gitconfig: gitconfig
	cp gitconfig ~/.gitconfig

~/.my.zshrc: my.zshrc
	cp my.zshrc ~/.my.zshrc

/etc/iptables/rules.v4: init-iptables.sh
	sudo ./init-iptables.sh
	sudo iptables -L -v

/etc/dnsmasq.conf: dnsmasq.conf
	sudo cp dnsmasq.conf /etc/dnsmasq.conf
	sudo systemctl restart dnsmasq
	echo "dnsmasq updated, need to reboot"

/etc/dnscrypt-proxy/dnscrypt-proxy.toml: dnscrypt-proxy.toml
	sudo cp dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
	sudo systemctl restart dnscrypt-proxy
	echo "dnscrypt-proxy updated, need to reboot"

/etc/systemd/system/sslocal.service: sslocal.service
	sudo cp sslocal.service /etc/systemd/system/
	sudo systemctl reenable sslocal
	echo "sslocal.service updated, need to reboot"
