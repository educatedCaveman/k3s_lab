#!/bin/bash

GITHUB_DIR="/home/drake/github"
K3S_ANSIBLE_DIR="${GITHUB_DIR}/k3s-ansible"

# set up cluster
cd "${K3S_ANSIBLE_DIR}" || exit 1
ansible-playbook ./site.yml -i ./inventory/my-cluster/hosts.ini
scp root@apis-1.vm:/root/.kube/config ~/.kube/config 
kubectl get nodes

# install longhorn
helm repo add longhorn https://charts.longhorn.io
helm repo update
kubectl create namespace longhorn-system
helm install longhorn longhorn/longhorn -n longhorn-system
kubectl -n longhorn-system get pod
kubectl edit service longhorn-frontend -n longhorn-system
kubectl get service longhorn-frontend -n longhorn-system