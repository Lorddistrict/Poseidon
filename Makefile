.DEFAULT_GOAL := help

.PHONY: help ## Generate list of targets with descriptions
help:
	@grep '##' Makefile \
	| grep -v 'grep\|sed' \
	| sed 's/^\.PHONY: \(.*\) ##[\s|\S]*\(.*\)/\1:\t\2/' \
	| sed 's/\(^##\)//' \
	| sed 's/\(##\)/\t/' \
	| expand -t14

.PHONY: env ## Create environment files & SSH keys
env:
	cp .env.example .env
	ssh-keygen -f githosting_rsa
	ssh-keygen -f ansible_rsa
	echo "Please fill environment files, then use make vagrant"

.PHONY: vagrant ## Run the infra
vagrant:
	vagrant up --provision

.PHONY: reload ## Reload the infra 
reload:
	vagrant reload --provision

.PHONY: stop ## Stop the infra 
stop:
	vagrant halt

.PHONY: play ## Run playbooks (ONLY INSIDE CONTROL)
play:
	ansible-playbook -v -i ansible_config/inventories/default ansible_config/playbook.yml

.PHONY: control ## SSH connect to control
control:
	vagrant ssh control

.PHONY: s0 ## SSH connect to s0
s0:
	vagrant ssh s0.infra

.PHONY: s1 ## SSH connect to s1
s1:
	vagrant ssh s1.infra

.PHONY: s2 ## SSH connect to s2
s2:
	vagrant ssh s2.infra

.PHONY: s3 ## SSH connect to s3
s3:
	vagrant ssh s3.infra

.PHONY: s4 ## SSH connect to s4
s4:
	vagrant ssh s4.infra

##################
# playbooks tags #
##################

.PHONY: database ## play database tagged modules
database:
	ansible-playbook -v -i ansible_config/inventories/default ansible_config/playbook.yml --tags database

.PHONY: web ## play web tagged modules
web:
	ansible-playbook -v -i ansible_config/inventories/default ansible_config/playbook.yml --tags web

.PHONY: haproxy ## play haproxy tagged modules
haproxy:
	ansible-playbook -v -i ansible_config/inventories/default ansible_config/playbook.yml --tags haproxy

.PHONY: nfs ## play nfs tagged modules
nfs:
	ansible-playbook -v -i ansible_config/inventories/default ansible_config/playbook.yml --tags nfs