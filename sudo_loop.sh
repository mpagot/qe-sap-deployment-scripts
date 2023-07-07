#!/bin/bash
set -e

if ! terraform=$(which terraform) &>/dev/null
then
  echo "Terraform command \"terraform\" doesn't seem to be installed"
  exit 1
fi

if ! jq=$(which jq) &>/dev/null
then
  echo "JQ command \"jq\" doesn't seem to be installed"
  exit 1
fi

if [[ -z ${CONFIG_YAML} ]];
then
  echo "Variable CONFIG_YAML is not set."
  exit 1
fi

if [[ -z ${QESAPROOT} ]];
then
  echo "Variable QESAPROOT is not set."
  exit 1
fi

trap 'echo "Error detected, call terraform destroy"; qesap.py --verbose  -b ${QESAPROOT} -c ${CONFIG_YAML} -d  &> terraform.destroy.log' EXIT

qesap.py --verbose  -b ${QESAPROOT} -c ${CONFIG_YAML} configure &> configure.log

for run in {1..10}; do
  echo "---- LOOP:${run} ----"
  echo "Terraform apply ..."
  SECONDS=0
  qesap.py --verbose  -b ${QESAPROOT} -c ${CONFIG_YAML} terraform &> terraform.create.log
  echo "Terraform apply DONE"
  export IP=$(terraform -chdir=${QESAPROOT}/terraform/gcp output -json | jq -r '.hana_public_ip.value[0]')

  until nc -vz -w 1 ${IP} 22
  do
    echo "22 not opened"
  done

  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${QESAPROOT}/secret/id_rsa_cloud cloudadmin@${IP} -- sudo systemctl is-system-running

  echo "Terraform destroy ..."
  qesap.py --verbose  -b ${QESAPROOT} -c ${CONFIG_YAML} terraform -d  &> terraform.destroy.log
  echo "Terraform destroy DONE"
  echo "Test loop takes ${SECONDS} seconds."

  echo "Go to sleep for 10 minutes."
  sleep 10m
done

echo "No failures"
exit 0
