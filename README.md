# Helm values are not updated

Changes to Subscription manifest that deploys Helm chart under `.spec.packageOverrides[0].packageOverrides[0].value` are not reflected on the real cluster.

## Detailed problem description

When introducing changes to Subscription manifest that deploys Helm chart under `.spec.packageOverrides[0].packageOverrides[0].value` are not reflected on the actual cluster. The Subscription resource on Hub and Managed clusters reflect correct settings, but Helmrelease resource and as a result actual instantiation of the helm chart do not reflect changes.

## Prerequisits

* RHACM from the 2.4 channel
* `goyq` query tool
* `kubens` tool

## Repository:

* https://github.com/vladimir-babichev/rhacm-helm-values-issue

## Steps to reproduce

```bash
git clone https://github.com/vladimir-babichev/rhacm-helm-values-issue
cd rhacm-helm-values-issue
./main.sh
```
