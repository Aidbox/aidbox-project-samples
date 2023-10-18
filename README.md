# Aidbox project template

This repository contains a template for Aidbox project. You can use to bootsrap your project with Aidbox.

# How to init Aidbox project

In order to run Aidbox locally, you need to have [Docker & Docker compose installed](https://docs.docker.com/engine/install/). To begin with new aidbox project, run the following command.

```sh
git clone --depth=1 --branch=open-telemetry-fhir-r5 git@github.com:Aidbox/aidbox-project-template.git aidbox-project && cd aidbox-project && rm -rf .git
```

Get your Aidbox license on [aidbox.app](https://aidbox.app/). And then set `AIDBOX_LICENSE` env variable in [.env file](.env#L1).

Once you set the license key, you may run Aidbox service with Docker compose by running:

``` sh
docker compose up
```

# What's next

You may learn more on Aidbox project in Aidbox documentation. For production read another doc
