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

``` sh
make plannet-setup
```

todo:
- load touchstone's fixtures
- update logic
