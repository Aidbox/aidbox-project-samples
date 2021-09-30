# Inferno compliant Aidbox

# Prerequisites

1. Docker & Docker Compose
2. npm

# Smart on FHIR Aidbox Installation

``` sh
make smart-on-fhir-setup
```

## Run Inferno Tests

1. Clone [onc-healthit/inferno-program](https://github.com/onc-healthit/inferno-program) repo and start it with `docker-compose up -d`. Check that it has started on `http://localhost:4567`
2. Add domain `127.0.0.1 host.docker.internal` to the `/etc/hosts` file. And check that Aidbox works on this host `http://host.docker.internal:8888`
6. Open Inferno application at http://localhost:4567

### STANDALONE PATIENT APP

To run tests use `inferno-client` and `inferno-secret` credentials we created for `Inferno`.

### LIMITED APP

Before running limited app test you have to revoke grant, provided on previous test run. Go to `http://localhost:8888/auth/grants` and revoke the only grant.

Once you started Limited App test, inferno will redirect you to a consent form, you have to provide there next scope `launch/patient openid fhirUser offline_access patient/Condition.read patient/Patient.read patient/Observation.read`

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

Now one should create test system, set it up and launch the testing procedure.

# Load Plannet Data Sets to Separate Aidbox Instance

Add 2 variables to your Aidbox environment and retart your instance.

``` bash
AIDBOX_ZEN_ENTRYPOINT="hl7-fhir-us-davinci-pdex-plan-net"
AIDBOX_ZEN_PATHS="url:zip:https://github.com/zen-lang/fhir/releases/download/0.2.9/hl7-fhir-us-davinci-pdex-plan-net.zip"
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
