.PHONY: cert ## validate puppet certificates
cert:
	vagrant ssh -c "sudo puppet cert sign --all" control

.PHONY: up ## it starts all the app
up:
	vagrant up --provision
	make cert

.PHONY: reload ## it reloads all the app
reload:
	vagrant reload --provision
	make cert