#!/usr/bin/bash

set -o errexit

k8s_version="1.23.3"

kubeconform_template="docs/schemas/{{.ResourceKind}}{{.KindSuffix}}.json"
kubeconform_flags="-kubernetes-version ${k8s_version} -strict -skip Certificate,VolumeSnapshotClass,Plan,Probe,Secret -schema-location default -schema-location ${kubeconform_template}"
kustomize_flags="--load-restrictor=LoadRestrictionsNone --reorder=legacy"
kustomize_config="kustomization.yaml"

echo "INFO - Validating clusters"
find ./clusters -maxdepth 2 -type f -name '*.yaml' -print0 | while IFS= read -r -d $'\0' file;
  do
    echo "       ${file}"
    kubeconform ${kubeconform_flags} ${file}
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
      exit 1
    fi
done
echo ""

echo "INFO - Validating kustomize overlays"
find ./cluster -maxdepth 2 -type f -name $kustomize_config -print0 | while IFS= read -r -d $'\0' file;
  do
    echo "     - ${file/%$kustomize_config}"
    kustomize build "${file/%$kustomize_config}" $kustomize_flags | \
      kubeconform ${kubeconform_flags}

    if [[ ${PIPESTATUS[0]} != 0 ]]; then
      exit 1
    fi
done
