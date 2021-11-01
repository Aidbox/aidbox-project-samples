up:
	docker-compose up -d

down:
	docker-compose down -t 0

logs:
	docker logs -f inferno-compliant-aidbox_devbox_1

pg-logs:
	docker logs -f inferno-compliant-aidbox_aidboxdb_1

exec:
	docker exec -ti inferno-compliant-aidbox_devbox_1 bash

pg-exec:
	docker exec -ti inferno-compliant-aidbox_aidboxdb_1 bash

hosts:
	scripts/modify-hosts.sh

build:
	scripts/build.sh

cleanup:
	rm -rf aidbox-project
	mkdir aidbox-project
	rm -rf pgdata

plannet-setup:
	make down
	make cleanup
	./scripts/install-aidbox-project.sh plannet
	docker-compose pull
	docker-compose up -d
	./scripts/plannet-setup.sh

smart-on-fhir-setup:
	make down
	make cleanup
	./scripts/install-aidbox-project.sh smart-on-fhir
	docker-compose pull
	docker-compose up -d
	./scripts/smart-on-fhir-setup.sh

cloud-load-plannet:
	./scripts/plannet-data-load.sh
