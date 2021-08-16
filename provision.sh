#!/bin/sh

set -e
set -u

USER_EMAIL=""
USER_NAME=""
GIT_HOST=""
GIT_REPOSITORY=""
HOSTNAME="$(hostname)"

if [ ! -f /vagrant/.env ]; then
	>&2 echo "ERROR: unable to find /vagrant/.env file"
	exit 1
fi
if ! grep -q '^USER_EMAIL=' /vagrant/.env ; then
	>&2 echo "ERROR: unable to find USER_EMAIL key in /vagrant/.env file"
	exit 1
fi
eval "$(grep '^USER_EMAIL=' /vagrant/.env)"

if ! grep -q '^USER_NAME=' /vagrant/.env ; then
	>&2 echo "ERROR: unable to find USER_NAME key in /vagrant/.env file"
	exit 1
fi
eval "$(grep '^USER_NAME=' /vagrant/.env)"

if ! grep -q '^GIT_HOST=' /vagrant/.env ; then
	>&2 echo "ERROR: unable to find GIT_HOST key in /vagrant/.env file"
	exit 1
fi
eval "$(grep '^GIT_HOST=' /vagrant/.env)"

if ! grep -q '^GIT_REPOSITORY=' /vagrant/.env ; then
	>&2 echo "ERROR: unable to find GIT_REPOSITORY key in /vagrant/.env file"
	exit 1
fi
eval "$(grep '^GIT_REPOSITORY=' /vagrant/.env)"

if [ ! -f /vagrant/githosting_rsa ]; then
	>&2 echo "ERROR: unable to find /vagrant/githosting_rsa keyfile"
	exit 1
fi
if [ ! -f /vagrant/githosting_rsa.pub ]; then
	>&2 echo "ERROR: unable to find /vagrant/githosting_rsa.pub keyfile"
	exit 1
fi

export DEBIAN_FRONTEND=noninteractive

apt-get update --allow-releaseinfo-change

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    git \
    curl \
    wget \
    vim \
    gnupg2 \
    software-properties-common \
    net-tools

if [ "$HOSTNAME" = "master" ]; then
  mkdir -p /root/.ssh

	cp /vagrant/githosting_rsa /home/vagrant/.ssh/githosting_rsa
	cp /vagrant/githosting_rsa.pub /home/vagrant/.ssh/githosting_rsa.pub

	cat > /home/vagrant/.ssh/config <<-MARK
	Host $GIT_HOST
	  User git
	  IdentityFile ~/.ssh/githosting_rsa
	MARK

	chmod 0600 /home/vagrant/.ssh/*
	chown -R vagrant:vagrant /home/vagrant/.ssh

	sed -i \
		-e '/## BEGIN PROVISION/,/## END PROVISION/d' \
		/home/vagrant/.bashrc

	cat >> /home/vagrant/.bashrc <<-MARK
	## BEGIN PROVISION
	eval \$(ssh-agent -s)
	ssh-add ~/.ssh/githosting_rsa
	## END PROVISION
	MARK

	su - vagrant -c "ssh-keyscan $GIT_HOST >> .ssh/known_hosts"
	su - vagrant -c "sort -u < .ssh/known_hosts > .ssh/known_hosts.tmp && mv .ssh/known_hosts.tmp .ssh/known_hosts"

	GIT_DIR="$(basename "$GIT_REPOSITORY" |sed -e 's/.git$//')"

	if [ ! -d "/home/vagrant/$(basename "$GIT_DIR")" ]; then
        	su - vagrant -c "git clone '$GIT_REPOSITORY' '$GIT_DIR'"
	fi

	su - vagrant -c "git config --global user.name '$USER_NAME'"
	su - vagrant -c "git config --global user.email '$USER_EMAIL'"

fi

sed -i \
	-e '/^## BEGIN PROVISION/,/^## END PROVISION/d' \
	/etc/hosts
cat >> /etc/hosts <<MARK
## BEGIN PROVISION
192.168.50.250      master
192.168.50.10       slave0
192.168.50.20       slave1
192.168.50.30       slave2
192.168.50.40       slave3
192.168.50.50       slave4
192.168.50.60       slave5
## END PROVISION
MARK

cat >> /etc/apt/apt.conf.d/99periodic-disable <<MARK
APT::Periodic::Enable "0";
MARK

echo "SUCCESS"