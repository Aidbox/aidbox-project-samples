

smart-on-fhir-setup:
	./scripts/smart-on-fhir-setup.sh

plannet-setup:
	./scripts/plannet-setup.sh

up:
	docker-compose up -d

down:
	docker-compose down -d
logs:
	docker logs -f inferno-compliant-aidbox_devbox_1

exec:
	docker exec -ti inferno-compliant-aidbox_devbox_1 bash


build:
	scripts/build.sh
