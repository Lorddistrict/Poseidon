.PHONY: run-manifests ## it reloads all the app
run-manifests:
	vagrant ssh -c "puppet apply Poseidon/puppet/manifests/sX.pp --modulepath=Poseidon/puppet/modules" control

.PHONY: cert ## validate puppet certificates
cert:
	vagrant ssh -c "sudo puppet cert sign --all" control

.PHONY: up ## it starts all the app
up:
	vagrant up --provision
	make cert
	make run-manifests

.PHONY: reload ## it reloads all the app
reload:
	vagrant reload --provision
	make cert