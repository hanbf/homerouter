all: ~/.vimrc ~/.gitconfig ~/.my.zshrc \
	/etc/systemd/system/sslocal.service \
	/etc/iptables/rules.v4 \
	/etc/dnscrypt-proxy/dnscrypt-proxy.toml \
	/etc/dnsmasq.conf \
	/etc/systemd/resolved.conf.d/00-use-dnsmasq.conf \
	/lib/systemd/system/dnscrypt-proxy.socket \
	/etc/systemd/system/systemd-networkd-wait-online.service \
	/etc/netplan/99-netplan-setup.yaml

~/.vimrc: vimrc
	cp vimrc ~/.vimrc

~/.gitconfig: gitconfig
	cp gitconfig ~/.gitconfig

~/.my.zshrc: my.zshrc
	cp my.zshrc ~/.my.zshrc

/etc/iptables/rules.v4: init-iptables.sh
	sudo ./init-iptables.sh
	sudo iptables -L -v
	sudo iptables -t nat -L -v
	sudo iptables -t mangle -L -v

/etc/dnsmasq.conf: dnsmasq.conf
	sudo cp dnsmasq.conf /etc/dnsmasq.conf
	sudo systemctl restart dnsmasq
	echo "dnsmasq updated, need to reboot"

/etc/dnscrypt-proxy/dnscrypt-proxy.toml: dnscrypt-proxy.toml
	sudo cp dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
	sudo systemctl restart dnscrypt-proxy
	echo "dnscrypt-proxy updated, need to reboot"

/etc/systemd/resolved.conf.d/00-use-dnsmasq.conf: 00-use-dnsmasq.conf
	sudo mkdir -p /etc/systemd/resolved.conf.d
	sudo cp 00-use-dnsmasq.conf /etc/systemd/resolved.conf.d
	sudo systemctl restart systemd-resolved.service
	echo "systemd-resolved updated, need to reboot"

/etc/systemd/system/systemd-networkd-wait-online.service: systemd-networkd-wait-online.service
	sudo cp systemd-networkd-wait-online.service /etc/systemd/system/

/lib/systemd/system/dnscrypt-proxy.socket: dnscrypt-proxy.socket
	sudo cp dnscrypt-proxy.socket /lib/systemd/system/dnscrypt-proxy.socket
	sudo systemctl daemon-reload
	sudo systemctl restart dnscrypt-proxy
	echo "dnscrypt-proxy updated, need to reboot"

/etc/systemd/system/sslocal.service: sslocal.service
	sudo cp sslocal.service /etc/systemd/system/
	sudo systemctl daemon-reload
	sudo systemctl restart sslocal
	echo "sslocal.service updated, need to reboot"

/etc/netplan/99-netplan-setup.yaml: 99-netplan-setup.yaml
	sudo cp 99-netplan-setup.yaml /etc/netplan/
	echo "netplan updated, restarting networkd, be prepared to be offline"
	sudo systemctl restart systemd-networkd.service
	sudo netplan apply

