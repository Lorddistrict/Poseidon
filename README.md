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

- `$ make env`
- Fill environment files with your informations

### 2. SSH

-  Add the githosting_rsa.pub it to your GitHub / GitLab SSH settings

### 3. Start the VMs

- `$ make vagrant`

### 4. Connect to control (main VM)

- `$ vagrant control`

### 5. Launch playbook

- `$ cd Poseidon`
- `$ make play`

### 6. Others

- `$ make help` - for getting all commands available
