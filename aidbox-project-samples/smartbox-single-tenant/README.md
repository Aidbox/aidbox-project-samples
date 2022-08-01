# ONC-certified FHIR API Module for EHRs

> By December 31, 2022, all certified EHRs need to provide a read-only HL7 FHIR® API to meet the requirements for patient and population services criterion §170.315(g)(10) - 2015 Edition Cures Update and get certified by ONC-Authorized Testing Labs.
> 
> https://www.health-samurai.io/fhir-api

This repo contains aidbox project, certified for (g)(10) criteria.

The solution consists of two Aidbox.One. One is for production and another one is used as developer sandbox.

There are single-tenant and multi-tenant versions.

## Single Tenant on Aidbox.One

### Prerequisites 

#### Docker

Follow the [official Docker guide](https://docs.docker.com/compose/install/#install-compose) to install Docker and Docker Compose

#### Get Aidbox.One License 

At first you need to get your [Aidbox.One license](https://docs.aidbox.app/getting-started/run-aidbox-locally-with-docker#get-a-license).

> Go to the [Aidbox portal](https://aidbox.app/). Sign up and click the new license button. Choose product type "Aidbox" and hosting type "on premises".
> You'll see your license in the "My Licenses" list. Click on your new license and copy credentials. It is a long string like

#### Set up GCP CLoud Storage

GCP Cloud Storage is used in Bulk API for storing and distributing exported data. In order to enable bulk api, you need to create GCP Cloud Storage, setup GCP Service Account and provide full access for the service account on this Cloud Storage. 


#### Set up Mailgun

[Mailgun](https://www.mailgun.com/) is used to communication with users (developers, patients). It sends emails for reseting password, emal verification, etc.

### Installation

#### Create docker-compose.yaml

Let's make the configuration file. There are two services: `aidbox-db` and `aidbox`. The first one is PostgreSQL database and the second one is Aidbox itself.

```yaml
version: '3.7'
services:
  aidbox-db:
    image: "${PGIMAGE}"
    ports:
      - "${PGHOSTPORT}:${PGPORT}"
    volumes:
    - "./pgdata:/data"
    environment:
      POSTGRES_USER:     "${PGUSER}"
      POSTGRES_PASSWORD: "${PGPASSWORD}"
      POSTGRES_DB:       "${PGDATABASE}"

  portal:
    image: "${AIDBOX_IMAGE}"
    depends_on: ["aidbox-db"]
    links:
      - "aidbox-db:database"
      - "sandbox:sandbox"
    ports:
      - "8888:8888"
    env_file:
      - .env
    environment:
      PGHOST: "database"
      PGDATABASE: "portal"
      SMARTBOX_SANDBOX_HOST: "http://sandbox:8888"
      SMARTBOX_SANDBOX_BASIC: "root:password"
      BOX_AUTH_LOGIN__REDIRECT: "/admin/portal"
      BOX_PROJECT_ENTRYPOINT: "smartbox.portal/box"
      AIDBOX_LICENSE: <YOUR_AIDBOXONE_LICENSE_FOR_PORTAL>

  sandbox:
    image: "${AIDBOX_IMAGE}"
    depends_on: ["aidbox-db"]
    links:
      - "aidbox-db:database"
    ports:
      - "8889:8888"
    env_file:
      - .env
    environment:
      PGHOST: "database"
      PGDATABASE: "sandbox"
      BOX_AUTH_LOGIN__REDIRECT: "/"
      BOX_PROJECT_ENTRYPOINT: "smartbox.dev-portal/box"
      AIDBOX_LICENSE: <YOUR_AIDBOXONE_LICENSE_FOR_SANDBOX>

```


#### Create .env file

To configure Aidbox we need to pass environment variables to it. We can pass them with .env file.

```env
# postgres image to run
PGIMAGE=healthsamurai/aidboxdb:14.2

# aidbox image to run
# AIDBOX_IMAGE=healthsamurai/aidboxone:stable
AIDBOX_IMAGE=healthsamurai/aidboxone:edge


# Client to create on start up
AIDBOX_CLIENT_ID=root
AIDBOX_CLIENT_SECRET=secret

# root user to create on start up
AIDBOX_ADMIN_ID=admin
AIDBOX_ADMIN_PASSWORD=secret

# db connection params
PGPORT=5432
PGHOSTPORT=5437
PGUSER=postgres
PGPASSWORD=postgres
AIDBOX_PORT=8888


# Compliance mode
AIDBOX_COMPLIANCE=enabled
AIDBOX_CREATED_AT_URL=http://fhir.aidbox.app/extension/createdat
BOX_COMPATIBILITY_VALIDATION_JSON__SCHEMA_REGEX=#{:fhir-datetime}
AIDBOX_FHIR_VERSION=4.0.1
BOX_AUTH_GRANT__PAGE__URL=/smart-auth/grant
BOX_COMPATIBILITY_AUTH_PKCE_CODE__CHALLENGE_S256_CONFORMANT=true


# Mailgun
BOX_PROVIDER_MAILGUN__PROVIDER_TYPE=mailgun
BOX_PROVIDER_MAILGUN__PROVIDER_FROM=<YOUR_MAILGUN_FROM_EMAIL>
BOX_PROVIDER_MAILGUN__PROVIDER_USERNAME=<YOUR_MAILGUN_USERNAME>
BOX_PROVIDER_MAILGUN__PROVIDER_PASSWORD=<YOUR_MAILGUN_PASSWORD>
BOX_PROVIDER_MAILGUN__PROVIDER_URL=<YOUR_MAILGUN_URL>


# GCP Cloud Storage
BOX_BULK__STORAGE_BACKEND=gcp
BOX_BULK__STORAGE_GCP_SERVICE__ACCOUNT=gcp-acc
BOX_BULK__STORAGE_GCP_BUCKET=<YOUR_GCP_BUCKET_NAME>

# Aidbox project
BOX_PROJECT_GIT_PROTOCOL=https
BOX_PROJECT_GIT_URL=https://github.com/Aidbox/aidbox-project-samples.git
BOX_PROJECT_GIT_SUB__PATH=aidbox-project-samples/smartbox
```

#### Launch Aidbox

Start Aidbox with Docker Compose

```sh
docker compose up
```

This command will download and start Aidbox and its dependencies. This can take a few minutes.


#### Go to the Aidbox Portal Console UI

Open http://localhost:8888. You'll see Aidbox login page. Sign in using login admin and password secret.

Now you are ready to use Aidbox.


On Aidbox run
1. create GCPServiceAccount
2. create Client for portal to connect to sandbox




## Multi-Tenant on Aidbox.One



# Developer portal

``` 
AIDBOX_LICENSE_ID=<your-license-id>
AIDBOX_LICENSE_KEY=<your-license-key>

AIDBOX_BASE_URL=<your-base-url>

AIDBOX_CLIENT_ID=root
AIDBOX_CLIENT_SECRET=secret

AIDBOX_ADMIN_ID=admin
AIDBOX_ADMIN_PASSWORD=secret

AIDBOX_PORT=8888
AIDBOX_FHIR_VERSION=4.0.0
AIDBOX_COMPLIANCE=enabled

PGPORT=5432
PGHOSTPORT=5437
PGUSER=<your-pg-user>
PGPASSWORD=<your-pg-pass>
PGDATABASE=devbox

BOX_AUTH_LOGIN__REDIRECT=/

BOX_PROJECT_GIT_PROTOCOL=https
BOX_PROJECT_GIT_URL=https://github.com/Aidbox/aidbox-project-samples.git
BOX_PROJECT_GIT_SUB__PATH=aidbox-project-samples
BOX_PROJECT_ENTRYPOINT=smartbox.dev-portal/test-box

BOX_PROVIDER_MAILGUN__PROVIDER_TYPE=mailgun
BOX_PROVIDER_MAILGUN__PROVIDER_FROM=<your-provider-mail>
BOX_PROVIDER_MAILGUN__PROVIDER_USERNAME=<your-provider-username>
BOX_PROVIDER_MAILGUN__PROVIDER_PASSWORD=<your-provider-pass>
BOX_PROVIDER_MAILGUN__PROVIDER_URL=<your-provider-url>

```
