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
    net-tools \
    make

sed -i \
	-e '/^## BEGIN PROVISION/,/^## END PROVISION/d' \
	/etc/hosts
cat >> /etc/hosts <<MARK
## BEGIN PROVISION
192.168.50.250      control, puppet
192.168.50.10       s0.infra
192.168.50.20       s1.infra
192.168.50.30       s2.infra
192.168.50.40       s3.infra
192.168.50.50       s4.infra
## END PROVISION
MARK

if [ "$HOSTNAME" = "control" ]; then
  apt-get install -y \
		puppet-master

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

  rm -rf "/home/vagrant/$(basename "$GIT_DIR")"

	if [ ! -d "/home/vagrant/$(basename "$GIT_DIR")" ]; then
        	su - vagrant -c "git clone -b '$GIT_BRANCH' '$GIT_REPOSITORY' '$GIT_DIR'"
	fi

	su - vagrant -c "git config --global user.name '$USER_NAME'"
	su - vagrant -c "git config --global user.email '$USER_EMAIL'"

else
  apt-get install -y \
  		puppet

  cat > /etc/puppet/puppet.conf <<-MARK
[main]
ssldir = /var/lib/puppet/ssl
certname = $HOSTNAME
server = control
environment = production

[master]
vardir = /var/lib/puppet
cadir = /var/lib/puppet/ssl/ca
dns_alt_names = puppet
MARK

  systemctl restart puppet
  puppet agent --test || true
fi

cat >> /etc/apt/apt.conf.d/99periodic-disable <<MARK
APT::Periodic::Enable "0";
MARK

echo "SUCCESS"