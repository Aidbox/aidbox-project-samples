# Conformant Aidbox samples

## Prerequisites

1. Docker & Docker Compose
2. npm

## Smart on FHIR Aidbox Installation
This section describes how to prepare Aidbox for running [Inferno tests](https://inferno.healthit.gov/)

Copy `.env.tpl` file to `.env` and fill in your `AIDBOX_LICENSE_ID` and `AIDBOX_LICENSE_KEY`.

Run
``` sh
make smart-on-fhir-setup
```
to initialize Aidbox, load the data neccessary for tests, and start it.

Forward your Aidbox instance to the internet. You can use services like [ngrok](https://ngrok.com/) or [localhost.run](https://localhost.run/).

## Inferno ONC Program setup
Open the Aidbox console and do a request in the REST Console to get a launch URI:
```yaml
POST /rpc
content-type: test/yaml
accept: text/yaml

method: aidbox.smart/get-launch-uri
params:
  user:
    id: inferno-patient-user
    resourceType: User
  iss: https://your-aidbox-domain/smart
  client:
    id: inferno-client
    resourceType: Client
```
You'll get a response like
```yaml
result:
 uri: https://inferno.healthit.gov/community/oauth2/static/launch?iss=https://your-aidbox-domain/smart&launch=some-jwt-token
 launch: some-jwt-token
 iss: https://your-aidbox-domain/smart
 launch-uri: https://inferno.healthit.gov/inferno/oauth2/static/launch
```
the `.result.uri` field is the launch URI you'll need to follow when Inferno asks to launch app.

### Standalone Patient App
Use client: `inferno-client` and secret: `inferno-secret`.

### Limited App
Before running limited app test you have to revoke grant provided on previous test run. Go to `http://your-aidbox-domain/auth/grants` and revoke all grants.

Once you started Limited App test, inferno will redirect you to a consent form, you have to provide there next scope `launch/patient openid fhirUser offline_access patient/Condition.read patient/Patient.read patient/Observation.read`.

### EHR Practitioner App
Use the launch URI when inferno asks to launch the application.

## Inferno Community setup
Follow the Inferno ONC Program setup section but replace `inferno-client` with `inferno-community-client`.

# PDEX PlanNet Aidbox Installation

## Prepare temporary domain name for tests

Touchstone doesn't have local version so one needs to have a special domain name to make it possible Touchstone sends its requests.

## Define `AIDBOX_BASE_URL` at `.env` file

Write down your domain name to the `AIDBOX_BASE_URL` variable. Somehow like this.

```bash
AIDBOX_BASE_URL=https://touchstone.example.com:8888
```

## Start Aidbox locally

```bash
make plannet-setup
```

## Forward traffic of the domain to 

When Aidbox starts one should forward all the traffic from the 8888 port of the domain to the Adibox instance.

## Run Touchstone tests

### Create Touchstone `Client` before start testing

So Touchstone gets access to the tested Aidbox.

Example, Touchstone client configuration

```yaml
auth:
  authorization_code:
    audience:
      - https://touchstone.example.com:8888/smart # `audience` must be equal to the `AIDBOX_BASE_URL` with `/smart` suffix

    redirect_uri: https://touchstone.aegis.net/touchstone/oauth2/authcode/redirect
    refresh_token: true
    access_token_expiration: 300
secret: touchstone-secret
grant_types:
  - code
  - basic
id: touchstone-client
resourceType: Client
```
Go to Touchstone, run tests and get you green badges :)

<!--
# Load Plannet Data Sets to Separate Aidbox Instance

Add 2 variables to your Aidbox environment and retart your instance.

``` bash
AIDBOX_ZEN_ENTRYPOINT="hl7-fhir-us-davinci-pdex-plan-net"
AIDBOX_ZEN_PATHS="url:zip:https://github.com/zen-lang/fhir/releases/latest/download/hl7-fhir-us-davinci-pdex-plan-net.zip"
```

Create `.env` file and define variables.

``` bash
AIDBOX_CLIENT_ID=$your_client_id
AIDBOX_CLIENT_SECRET=$your_client_secret
AIDBOX_BASE_URL=$your_aidbox_url
```

Populate sample Plannet data at Aidbox.

```bash
make plannet-data-load
```
-->
