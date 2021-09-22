# inferno-compliant-aidbox

## Get inferno compliant `aibox` (this repositry)

```
git clone git@github.com:Aidbox/inferno-compliant-aidbox.git
```

## Get inferno `validation service` locally

```
git clone git@github.com:onc-healthit/inferno-program.git
```

Having it done you should have 2 folders:

1. `inferno-compliant-aidbox`
2. `inferno-program`


## Update `/etc/hosts` file

Add domain `host.docker.internal`.

```
127.0.0.1 host.docker.internal
```

## Get developer license for you `Aidbox`

According to the  [instruction](https://docs.aidbox.app/getting-started/installation/setup-aidbox.dev#get-your-license). You should receive `licencer-id` and `licencer-key`.

Write them to the `inferno-compliant-aidbox/.env` file.

```
AIDBOX_LICENSE_ID=%licence-id%
AIDBOX_LICENSE_KEY=$licence-key$
```

## Start your Aidbox

By running the command under the `inferno-compliant-aidbox` folder.

```
docker-compose up
```

Started Aidbox is reachable at `http://localhost:8888`.

## Fill Aidbox with data

Open Aidbox REST console http://localhost:8888/ui/console#/rest

### Add community sample data

Load community sample data by running.

```
POST /fhir/$load

source: https://storage.googleapis.com/aidbox-public/inferno/inferno-community-fixtures.ndjson.gz
```

You should receive 200 status and the list of imported resources.

```
CarePlan: 15
Observation: 133
Group: 1
Goal: 1
DocumentReference: 99
PractitionerRole: 12
Patient: 5
DiagnosticReport: 102
Provenance: 5
Practitioner: 12
Immunization: 75
MedicationRequest: 75
Encounter: 178
Medication: 1
Condition: 36
CareTeam: 15
Procedure: 78
Location: 12
Organization: 12
Device: 3
AllergyIntolerance: 1
```


### Add needed additional resources and policies

```
PUT /

# Create FHIR extensions
## US-Core race extension
- resourceType: Attribute
  id: Patient.race
  path: ['race']
  resource: {id: 'Patient', resourceType: 'Entity'}
  extensionUrl: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race'
- resourceType: Attribute
  id: Patient.race.text
  path: ['race', 'text']
  resource: {id: 'Patient', resourceType: 'Entity'}
  type: {id: 'string', resourceType: 'Entity'}
  extensionUrl: text
- resourceType: Attribute
  id: Patient.race.category
  path: ['race', 'category']
  resource: {id: 'Patient', resourceType: 'Entity'}
  type: {id: 'Coding', resourceType: 'Entity'}
  extensionUrl: ombCategory
- resourceType: Attribute
  id: Patient.race.detailed
  path: ['race', 'detailed']
  resource: {id: 'Patient', resourceType: 'Entity'}
  type: {id: 'Coding', resourceType: 'Entity'}
  extensionUrl: detailed

## US-Core ethnicity extension
- resourceType: Attribute
  id: Patient.ethnicity
  path: ['ethnicity']
  resource: {id: 'Patient', resourceType: 'Entity'}
  extensionUrl: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity'
- resourceType: Attribute
  id: Patient.ethnicity.ombCategory
  path: ['ethnicity', 'ombCategory']
  resource: {id: 'Patient', resourceType: 'Entity'}
  type: {id: 'Coding', resourceType: 'Entity'}
  extensionUrl: ombCategory
- resourceType: Attribute
  id: Patient.ethnicity.detailed
  path: ['ethnicity', 'detailed']
  resource: {id: 'Patient', resourceType: 'Entity'}
  type: {id: 'Coding', resourceType: 'Entity'}
  extensionUrl: detailed
- resourceType: Attribute
  id: Patient.ethnicity.text
  path: ['ethnicity', 'text']
  resource: {id: 'Patient', resourceType: 'Entity'}
  type: {id: 'string', resourceType: 'Entity'}
  extensionUrl: text

## US Core birthsex extension
- resourceType: Attribute
  description: "A code classifying the person's sex assigned at birth as specified by the Office of the National Coordinator for Health IT (ONC)"
  resource: {id: Patient, resourceType: Entity}
  path: [birthsex]
  id: Patient.birthsex
  type: {id: code, resourceType: Entity}
  isCollection: false
  extensionUrl: "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex"

# Create App Client
- resourceType: Client
  id: inferno-client
  secret: inferno-secret
  auth:
    authorization_code:
      redirect_uri: http://localhost:4567/inferno/oauth2/static/redirect
      refresh_token: true
      secret_required: true
      access_token_expiration: 36000
  grant_types:
    - authorization_code
    - basic

# Create Patient
- id: pt-1
  resourceType: Patient
  gender: male
  identifier:
    - value: pt-1
      system: urn:oms
  name:
    - given:
        - John
      family: Smith
  birthDate: "1987-08-26"
  address:
    - city: Moscow
      line:
        - Presnenskaya naberezhnaya
      period:
        start: "2000-06-06"
      postalCode: "816381"
      state: Moscow
  communication:
    - language:
        coding:
          - code: russian
  telecom:
    - use: mobile
      value: "+7 999 999-99-99"
      system: phone
  race:
    text: caucasian
  birthsex: male
  ethnicity:
    text: russian
  meta:
    profile:
      - http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient

# Create User for Patient
- resourceType: User
  id: inferno-patient-user
  password: pass

# Bind admin user and Patient
- resourceType: Role
  user:
    id: admin
    resourceType: User
  name: patient
  links:
    patient:
      id: pt-1
      resourceType: Patient

# Bind patient user and patient
- resourceType: Role
  user:
    id: inferno-patient-user
    resourceType: User
  name: patient
  links:
    patient:
      id: pt-1
      resourceType: Patient

# Allow patients to search resources linked with them
- resourceType: AccessPolicy
  engine: matcho
  matcho:
    uri: '#/smart/.*'
    params:
      patient: .role.links.patient.id
  roleName: patient
  id: patient-smart

# Allow patients to read their info
- resourceType: AccessPolicy
  engine: matcho
  matcho:
    uri: '#/smart/Patient/.*'
    params:
      id: .role.links.patient.id
  roleName: patient
  id: smart-patient-read

# Allow patients to read their info
- resourceType: AccessPolicy
  engine: matcho
  matcho:
    uri: '#/smart/Patient'
    params:
      _id: .role.links.patient.id
  roleName: patient
  id: smart-patient-search-self
```


## Start Inferno validation service

Run the command under `inferno-program` folder.

```
docker-compose up
```


Running Inferno service is reachable at `http://localhost:4567`.


## Try out our example `smart` application

1. Open Inferno application at `http://localhost:4567`

2. Put Aidbox SMART FHIR API URL `http://host.docker.internal:8888/smart` to the input and press `Start testing` button


To run tests use `inferno-client` and `inferno-secret` credentials we created for `Inferno` abowe.
