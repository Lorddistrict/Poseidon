.PHONY: run-manifests ## run manifests & run services
run-manifests:
	vagrant ssh -c "sudo puppet apply Poseidon/puppet/manifests/default.pp --modulepath=Poseidon/puppet/modules" control

.PHONY: cert ## validate puppet certificates
cert:
	vagrant ssh -c "sudo puppet cert sign --all" control

.PHONY: setup ## setup environment for working
setup:
	make cert
	make run-manifests

.PHONY: up ## it starts all the app
up:
	vagrant up --provision
	make setup

.PHONY: reload ## it reloads all the app
reload:
	vagrant reload --provision
	make setup