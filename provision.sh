#!/bin/sh

set -e
set -u

USER_EMAIL=""
USER_NAME=""
GIT_HOST=""
GIT_REPOSITORY=""
GIT_BRANCH=""
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

if ! grep -q '^GIT_BRANCH=' /vagrant/.env ; then
	>&2 echo "ERROR: unable to find GIT_BRANCH key in /vagrant/.env file"
	exit 1
fi
eval "$(grep '^GIT_BRANCH=' /vagrant/.env)"

## Verifier que la paire de clefs pour ANSIBLE est presente avant de continuer

if [ ! -f /vagrant/ansible_rsa ]; then
	>&2 echo "ERROR: unable to find /vagrant/ansible_rsa keyfile"
	exit 1
fi
if [ ! -f /vagrant/ansible_rsa.pub ]; then
	>&2 echo "ERROR: unable to find /vagrant/ansible_rsa.pub keyfile"
	exit 1
fi

## Verifier que la paire de clefs pour GITHUB est presente avant de continuer

if [ ! -f /vagrant/githosting_rsa ]; then
	>&2 echo "ERROR: unable to find /vagrant/githosting_rsa keyfile"
	exit 1
fi
if [ ! -f /vagrant/githosting_rsa.pub ]; then
	>&2 echo "ERROR: unable to find /vagrant/githosting_rsa.pub keyfile"
	exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# Mettre à jour le catalogue des paquets debian
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
    net-tools \
    make

# Si la machine s'appelle control
if [ "$HOSTNAME" = "control" ]; then

  # setup ansible version
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
  echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main" > /etc/apt/sources.list.d/ansible-ubuntu-ansible-bionic.list
  apt update -y
  apt install ansible

  # Required for making things working
	ansible-galaxy collection install community.mysql --ignore-errors

	# J'ajoute les deux clefs sur le noeud de controle
	mkdir -p /root/.ssh
	cp /vagrant/ansible_rsa /home/vagrant/.ssh/ansible_rsa
	cp /vagrant/ansible_rsa.pub /home/vagrant/.ssh/ansible_rsa.pub
	cp /vagrant/githosting_rsa /home/vagrant/.ssh/githosting_rsa
	cp /vagrant/githosting_rsa.pub /home/vagrant/.ssh/githosting_rsa.pub

	# Configuration de SSH en fonction des hosts
	cat > /home/vagrant/.ssh/config <<-MARK
	Host $GIT_HOST
	  User git
	  IdentityFile ~/.ssh/githosting_rsa
	Host s0
	  User root
	  IdentityFile ~/.ssh/ansible_rsa
	  StrictHostKeyChecking no
	Host s1
	  User root
	  IdentityFile ~/.ssh/ansible_rsa
	  StrictHostKeyChecking no
	Host s2
	  User root
	  IdentityFile ~/.ssh/ansible_rsa
	  StrictHostKeyChecking no
	Host s3
    User root
    IdentityFile ~/.ssh/ansible_rsa
    StrictHostKeyChecking no
  Host s4
    User root
    IdentityFile ~/.ssh/ansible_rsa
    StrictHostKeyChecking no
	MARK

	# Correction des permissions
	chmod 0600 /home/vagrant/.ssh/*
	chown -R vagrant:vagrant /home/vagrant/.ssh

	# Utilisation du SSH-AGENT pour charger les clés une fois pour toute
	# et ne pas avoir à retaper les password des clefs
	sed -i \
		-e '/## BEGIN PROVISION/,/## END PROVISION/d' \
		/home/vagrant/.bashrc
	cat >> /home/vagrant/.bashrc <<-MARK
	## BEGIN PROVISION
	eval \$(ssh-agent -s)
	ssh-add ~/.ssh/githosting_rsa
	ssh-add ~/.ssh/ansible_rsa
	## END PROVISION
	MARK

	GIT_DIR="$(basename "$GIT_REPOSITORY" |sed -e 's/.git$//')"

	# Deploy git repository
	su - vagrant -c "ssh-keyscan $GIT_HOST >> .ssh/known_hosts"
	su - vagrant -c "sort -u < .ssh/known_hosts > .ssh/known_hosts.tmp && mv .ssh/known_hosts.tmp .ssh/known_hosts"
	rm -rf "/home/vagrant/$(basename "$GIT_DIR")"
  su - vagrant -c "git clone -b '$GIT_BRANCH' '$GIT_REPOSITORY' '$GIT_DIR'"
	su - vagrant -c "git config --global user.name '$USER_NAME'"
	su - vagrant -c "git config --global user.email '$USER_EMAIL'"
fi

sed -i \
	-e '/^## BEGIN PROVISION/,/^## END PROVISION/d' \
	/etc/hosts
cat >> /etc/hosts <<MARK
## BEGIN PROVISION
192.168.50.250      control
192.168.50.10       s0.infra
192.168.50.20       s1.infra
192.168.50.30       s2.infra
192.168.50.40       s3.infra
192.168.50.50       s4.infra
## END PROVISION
MARK

# J'autorise la clef sur tous les serveurs
mkdir -p /root/.ssh
cat /vagrant/ansible_rsa.pub >> /root/.ssh/authorized_keys

# Je vire les duplicata (potentiellement gênant pour SSH)
sort -u /root/.ssh/authorized_keys > /root/.ssh/authorized_keys.tmp
mv /root/.ssh/authorized_keys.tmp /root/.ssh/authorized_keys

# Je corrige les permissions
touch /root/.ssh/config
chmod 0600 /root/.ssh/*
chmod 0644 /root/.ssh/config
chmod 0700 /root/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "SUCCESS"