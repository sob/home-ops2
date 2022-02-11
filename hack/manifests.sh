#!/usr/bin/bash

set -o errexit
set -o nounset
set -o pipefail

tmp_dir=$(mktemp -d)
echo "Creating ${tmp_dir}"
#trap 'rm -rf -- "$tmp_dir"' EXIT

function crd_to_json_schema() {
  local api_version crd_group crd_kind crd_version document input kind index

  mkdir -p "${tmp_dir}/manifests"

  echo "Processing ${1}..."
  input="${tmp_dir}/manifests/${1}.yaml"
  curl --show-error -sL "${@:2}" > "${input}"

  for document in $(seq 0 $(($(yq ea '[.] | length' "${input}") -1))); do
    api_version=$(yq eval 'select(documentIndex == '"${document}"') | .apiVersion' "${input}" | cut --delimiter=/ --fields=2)
    kind=$(yq eval 'select(documentIndex == '"${document}"') | .kind' "${input}")
    crd_kind=$(yq eval 'select(documentIndex == '"${document}"') | .spec.names.kind' "${input}" | tr '[:upper:]' '[:lower:]')
    crd_group=$(yq eval 'select(documentIndex == '"${document}"') | .spec.group' "${input}" | cut --delimiter=. --fields=1)

    if [[ "${kind}" != CustomResourceDefinition ]]; then
      continue
    fi

    case "${api_version}" in
      v1)
        for crd_version in $(yq eval 'select(documentIndex == '"${document}"') | .spec.versions.[].name' "${input}"); do
          yq eval --prettyPrint --output-format json 'select(documentIndex == '"${document}"') | .spec.versions.[] | select(.name == "'${crd_version}'") | .schema.openAPIV3Schema' "${input}" | write_schema "${crd_kind}-${crd_group}-${crd_version}.json"
        done
        ;;
      *)
        echo "Unknown API version: ${api_version}" >&2
        # return 1
        ;;
    esac
  done
}

function write_schema() {
  mkdir -p "docs/schemas"
  sponge "docs/schemas/${1}"
  jq '. * {properties: {spec: .properties.spec }}' "docs/schemas/${1}" | sponge "docs/schemas/${1}"
}

crd_to_json_schema cert-manager-clusterissuer https://raw.githubusercontent.com/cert-manager/cert-manager/master/deploy/crds/crd-clusterissuers.yaml
crd_to_json_schema cert-manager-certificate https://raw.githubusercontent.com/cert-manager/cert-manager/master/deploy/crds/crd-certificates.yaml

crd_to_json_schema helm-controller https://github.com/fluxcd/helm-controller/releases/download/v0.16.0/helm-controller.crds.yaml
crd_to_json_schema source-controller https://github.com/fluxcd/source-controller/releases/download/v0.21.2/source-controller.crds.yaml
crd_to_json_schema kustomize-controller https://raw.githubusercontent.com/fluxcd/kustomize-controller/main/config/crd/bases/kustomize.toolkit.fluxcd.io_kustomizations.yaml
crd_to_json_schema image-automation-controller https://github.com/fluxcd/image-automation-controller/releases/download/v0.20.0/image-automation-controller.crds.yaml
crd_to_json_schema image-reflector-controller https://github.com/fluxcd/image-reflector-controller/releases/download/v0.16.0/image-reflector-controller.crds.yaml
crd_to_json_schema notification-controller https://github.com/fluxcd/notification-controller/releases/download/v0.21.0/notification-controller.crds.yaml

crd_to_json_schema traefik https://raw.githubusercontent.com/traefik/traefik/93de7cf0c0ed478600021ce81eb487c0d6717f69/integration/fixtures/k8s/01-traefik-crd.yml
crd_to_json_schema prometheus-operator https://github.com/prometheus-operator/prometheus-operator/releases/latest/download/bundle.yaml

crd_to_json_schema external-snapshotter-volume-snapshot-class https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
crd_to_json_schema external-snapshotter-volume-snapshot-contents https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
crd_to_json_schema external-snapshotter-volume-snapshot https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
