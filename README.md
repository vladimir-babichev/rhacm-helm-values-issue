# Helm values are not updated

Changes to Subscription manifest that deploys Helm chart under `.spec.packageOverrides[0].packageOverrides[0].value` are not reflected on the real cluster.

## Detailed problem description

Changes to Subscription manifest that deploys Helm chart under `.spec.packageOverrides[0].packageOverrides[0].value` are not reflected on the actual cluster. The Subscription resource on Hub and Managed clusters reflect correct settings, but the Helmrelease resource and as a result, actual instantiation of the helm chart does not reflect changes.

## Prerequisites

* RHACM from the 2.4 channel
* `goyq` query tool
* `kubens` tool

## Repository:

* https://github.com/vladimir-babichev/rhacm-helm-values-issue

## Steps to reproduce

Given example will try to scale out chartmuseum application from 1 to 5 pods
```bash
git clone https://github.com/vladimir-babichev/rhacm-helm-values-issue
cd rhacm-helm-values-issue
./main.sh
```
