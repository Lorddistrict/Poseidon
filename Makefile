.PHONY: up ## it starts all the app
up:
	vagrant up --provision
	make cert

.PHONY: reload ## it reloads all the app
reload:
	vagrant reload --provision
	make cert

.PHONY: cert ## apply puppet certificates
	vagrant ssh control -c puppet cert sign --all