# ONC-certified FHIR API Module for EHRs

> By December 31, 2022, all certified EHRs need to provide a read-only HL7 FHIR® API to meet the requirements for patient and population services criterion §170.315(g)(10) - 2015 Edition Cures Update and get certified by ONC-Authorized Testing Labs.
> 
> https://www.health-samurai.io/fhir-api

This repo contains the Aidbox project, certified for (g)(10) criteria.

The solution consists of two Aidbox.One. One is for production and another one is used as a developer `sandbox`.

## Certified single-tenant on Aidbox

### Prerequisites 

#### Docker

Follow the [official Docker guide](https://docs.docker.com/compose/install/#install-compose) to install Docker and Docker Compose

#### Get Aidbox.One License 

At first, you need to get your [Aidbox.One license](https://docs.aidbox.app/getting-started/run-aidbox-locally-with-docker#get-a-license).

> Go to the [Aidbox portal](https://aidbox.app/). Sign up and click the new license button. Choose product type "Aidbox" and hosting type "on-premises".
> You'll see your license in the "My Licenses" list. Click on your new license and copy credentials. It is a long string like

#### Set up GCP CLoud Storage

GCP Cloud Storage is used in Bulk API for storing and distributing exported data. To enable bulk API, you need to create GCP Cloud Storage, set up GCP Service Account, and provide full access to the service account on this Cloud Storage. 


#### Set up Mailgun

[Mailgun](https://www.mailgun.com/) is used to communicate with users (developers, patients). It sends emails for resetting a password, email verification, etc.

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
      - "9999:8888"
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


# Client to create on startup
AIDBOX_CLIENT_ID=root
AIDBOX_CLIENT_SECRET=secret

# root user to create on startup
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

Open http://localhost:8888. You'll see the Aidbox login page. Sign in using login admin and password secret.

Now you are ready to use Aidbox.


On Aidbox run
1. create GCPServiceAccount
2. create `Client` for the portal to connect to `sandbox`

## Usage

### As a developer of SMART App

The developer's main flow is to register his/her SMART App and publish it to the `portal`. To reach the goal developer should:

1. Enroll in the `sandbox`
2. Create SMART App
3. Submit the app for publishing
4. Receive review status, update app details and re-submit
5. Get the app published

#### Enroll to the `sandbox`

1. Open the web page http://sandbox:9999 and click the `Enroll in the Developer Sandbox` link
2. Populate the form `Developer registration` and submit it
3. Receive the email and click the link to confirm your email address exists
4. Enter your password and save it
5. Sign in to the `sandbox` with your email and password

#### Create SMART App

After login developer sees the list of its Apps. Initially, it is empty. To register the new SMART App:

1. Click the `Create App` button
2. Fill in all the necessary details about the application
3. Press the `Submit` button
4. After checks `sandbox` registers the app and gets the user back to the list of applications

#### Submit app for publish

To make the app accessible to users (patients) developer should submit the app for review:

1. Click the app in the list of apps
2. Press the `Submit for review` button
3. Notice `Status` changed to `In review`

#### Receive review status, update app details and re-submit

Sometimes `administrator` can reject your publish request. If it happens the reason should be provided. To get the app published:

1. Click the app in the list of apps
2. Notice `Rejection reason` and `Status`
3. Fix your app details
4. Re-submit it one more time by pressing the `Submit for review` button

#### Get the app published

Once your app is approved, you (as a developer) receive a notification email. But you can always check the current app approval status:

1. Click the app in the list of apps
2. Notice current `Status`

### As administrator of the portal

The administrator's main flow is to receive the app publishing request of the developers and decide if they could be published.

1. Approve a publishing request
2. Reject a publishing request
3. Suspend a published app
4. Approve a suspended app
5. Enroll a patient
6. Enroll an administrator

#### Approve a publishing request

On the page containing the list of review requests:

1. Click the request in the list
2. Press the `Approve` button

#### Reject a publishing request

On the page containing the list of review requests:

1. Click the request in the list
2. Press the `Reject` button
3. Populate the `Reason` field
4. Click the `Reject` button

#### Suspend a published app

On the `Apps` page:

1. Click the `Active` app
2. Press the `Suspend access` button

#### Approve a suspended app

1. Click the `On hold` app
2. Press the `Approve access` button

#### Enroll  a patient

On the Patients list:

1. Click a patient with the grey circle (not enrolled)
2. Press the `Enroll` button
3. Fill in the email of the patient
4. Press the `Enroll` button

The patient receives the enrollment email. When the patient finishes the enrollment, the circle indicator on the list of patients becomes green (enrolled).

#### Enroll an administrator

On the Administrators list:

1. Press the `New` button
2. Fill in the email and the name of the administrator
3. Press the `Submit` button

The new administrator receives the enrollment email.

### As a patient

The flow of the patient is to manage access to it's data and to launch SMART applications:

1. Launch a SMART App
2. Revoke granted access

#### Launch a SMART App

On the Applications page:

1. Press the `Launch` button against an application
2. Mark with checkboxes what information the app is going to have
3. Uncheck the `Remember my choice` to make Aidbox show the consent screen on each launch of the app
4. Press the `Allow` button to launch the app

#### Revoke granted access

There are two options to revoke the access of the application:

1. On the Applications page
2. On the Grants page

On the Applications page:

1. Press the `Revoke access` button against an application

2. Confirm revoking the access by pressing the `Revoke` button

On the Grants page:

1. Click an application

2. Press the `Revoke access` button
