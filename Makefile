.PHONY: up ## it starts all the app
up:
	vagrant up --provision

.PHONY: reload ## it reloads all the app
reload:
	vagrant reload --provision
	vagrant ssh control
	puppet cert sign --all