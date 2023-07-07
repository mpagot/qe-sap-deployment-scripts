# qe-sap-deployment-scripts
Example of SUSE/qe-sap-deployment usage

## Prerequisite
- bash
- jq
- CPS credentials
- a clone or a release of https://github.com/SUSE/qe-sap-deployment
- all the qe-sap-deployment requirements (Terraform, Python, Ansible)
- some config.yaml for the qe-sap-deployment glue script `qesap.py`

## Examples

### sudo_loop
Run the `terraform apply` part of the deployment and try to connect as soon as possible to one of the cluster VM. Check if the default `cloudadmin` user can use sudo without password.
