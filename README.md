# Poseidon project : Automated provisioning on a classic infrastructure
### Principal contributors :
[Arthur][A]
& [Etienne][E]

[A]:https://github.com/adjikpo
[E]:https://github.com/Lorddistrict

---------------------------------------------------------
## Installation / Requirements

A. Please install Vagrant, VirtualBox and Make for running this project

B. Please check your config inside VirtuaBox : File > Host Network Manager
> 1. if vboxnet0 is already used with DHCP --> delete it and recreate (virtualbox sometimes doesn't create the host from Vagrant)
> 2. if vboxnet0 doesn't exists, create and start the app. Vagrant will understand and turn off the DHCP. In case not, please click the checkbox manually


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

### 7. Notice

- You cannot deploy this on a VPS because of Vagrant virtualization. It requires the Hyper-V to be disabled
