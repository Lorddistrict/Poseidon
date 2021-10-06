.DEFAULT_GOAL := help

.PHONY: help ## Generate list of targets with descriptions
help:
	@grep '##' Makefile \
	| grep -v 'grep\|sed' \
	| sed 's/^\.PHONY: \(.*\) ##[\s|\S]*\(.*\)/\1:\t\2/' \
	| sed 's/\(^##\)//' \
	| sed 's/\(##\)/\t/' \
	| expand -t14

.PHONY: run ## Run playbooks
run:
	ansible-playbook -v -i inventories/default playbook.yml

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