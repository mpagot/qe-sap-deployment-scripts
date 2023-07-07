# qe-sap-deployment-scripts
Example of SUSE/qe-sap-deployment usage

## Prerequisite
- bash
- jq
- ssh and a set og keys to login to the cloud VM
- CPS credentials
- a clone or a release of https://github.com/SUSE/qe-sap-deployment
- all the qe-sap-deployment requirements (Terraform, Python, Ansible)
- some config.yaml for the qe-sap-deployment glue script `qesap.py`

## Examples

### sudo_loop
Run the `terraform apply` part of the deployment and try to connect,
as soon as possible to one of the cluster VM.
Check if the default `cloudadmin` user can use sudo without password.

#### Configuration
The script needs 3 env variables:
 - `QESAPROOT` with the path of the qe-sap-deployment code
 - `CONFIG_YAML` file name of the glue script config file
 - `qesap.py` has to be in the `PATH`

The script is using ssh to connect to the VM under test.
It expects ssh connection to use pub/priv keys.
The script expect the keys to be in `${QESAPROOT}/secret` with a specific name.
Keep in mind that same keys has to be referenced also in the config.yaml.

#### Run

Just run the script. Take care that the script implement a `trap`, you can stop it by CTRL-C
but then you need to wait that the `terraform destroy` completed. Please be patient and
not press CTRL-C multiple times.
