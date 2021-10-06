.PHONY: up ## it starts all the app
up:
	vagrant up --provision
	make cert

.PHONY: reload ## it reloads all the app
reload:
	vagrant reload --provision
	make cert

.PHONY: cert ## apply puppet certificates
cert:
	vagrant ssh -c "puppet cert sign --all" control

.PHONY: gen-cert ## apply puppet certificates
gen-cert:
	vagrant ssh -c "puppet agent --test" s0.infra