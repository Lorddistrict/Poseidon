# Poseidon project : Automated provisioning on a classic infrastructure
### Principal contributors :
[Arthur][A]
& [Etienne][E]

[A]:https://github.com/adjikpo
[E]:https://github.com/Lorddistrict

---------------------------------------------------------
## Installation / Run

Launch the command  `make help` or `make` generate list of targets with descriptions

### 1. Environment config

- `make env` 
- Fill environment files with your informations
 ```bash
    USER_EMAIL=user@email.com
    USER_NAME=user
    GIT_REPOSITORY=https://host.com/name/repository
    GIT_HOST=host.com
    GIT_BRANCH=name/branch
```
-  Add the githosting_rsa.pub it to your GitHub / GitLab SSH settings

### 2. Start the infra
- `make vagrant`

### 3. Connect to control or another server

`vagrant control` or `vagrant s*`