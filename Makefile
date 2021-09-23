CURRENT_PROJECT=$(shell cat )

smart-on-fhir-setup:
	./scripts/smart-on-fhir-setup.sh

inferno-setup: up
	./scripts/smart-on-fhir-setup.sh

plannet-setup: up
	./scripts/plannet-setup.sh

up:
	docker-compose pull
	docker-compose up -d

down:
	docker-compose down -t 0
logs:
	docker logs -f inferno-compliant-aidbox_devbox_1

exec:
	docker exec -ti inferno-compliant-aidbox_devbox_1 bash

hosts:
	scripts/modify-hosts.sh

build:
	scripts/build.sh

cleanup: down
	rm -rf aidbox-project
	mkdir aidbox-project
	sudo rm -rf pgdata

plannet:
	make down
	make cleanup
	make up
	make plannet-setup

inferno:
	make down
	make cleanup
	make up
	make inferno-setup
