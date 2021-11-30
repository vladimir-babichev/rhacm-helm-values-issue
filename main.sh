#!/usr/bin/env bash

function info() {
    local msg=$1
    local output=$2
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") [INFO]: $msg"
    if [ "$output" != "" ]; then
        echo "$output"
        echo
    fi
}

info "Applying manifests"
cat manifests/* | kubectl apply -f -

info "Waiting for pods to come up"
NAMESPACE=$(cat manifests/03-subscription.yaml | yq e .metadata.namespace -)
kubens "$NAMESPACE"
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=chartmuseum

info "Resource BEFORE changes to Helm values deployment"

output=$(kubectl get appsub chartmuseum -o yaml)
info "Subscription RD" "$output"

CHANNEL_NAMESPACE=$(cat manifests/02-channel.yaml | yq e .metadata.namespace -)
output=$(kubectl get channel channel -n "$CHANNEL_NAMESPACE" -o yaml)
info "Channel RD" "$output"

output=$(kubectl get helmrelease chartmuseum -o yaml)
info "HelmRelease RD" "$output"

output=$(helm get values chartmuseum)
info "Helm Values" "$output"


info "Setting replicaCount value to 5"
cat manifests/03-subscription.yaml | \
    yq e .spec.packageOverrides[0].packageOverrides[0].value.replicaCount=5 - | \
    kubectl apply -f -

info "Sleep for 5 minutes to give ACM enough time to reconcile objects"
i=1
while [ $i -lt 300 ]; do
    i=$((i+1))
    sleep 1
    echo -n "."
done
echo
set -x

info "Resource AFTER changes to Helm values deployment"

output=$(kubectl get appsub chartmuseum -o yaml)
info "Subscription RD" "$output"

output=$(kubectl get channel channel -n rhacm-helm-values-issue-ch-helm -o yaml)
info "Channel RD" "$output"

output=$(kubectl get helmrelease chartmuseum -o yaml)
info "HelmRelease RD" "$output"

output=$(helm get values chartmuseum)
info "Helm Values" "$output"
