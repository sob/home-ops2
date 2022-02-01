# Home Operations

This repository _is_ my home k8s cluster managed managed by [Flux](https://github.com/fluxcd/flux2)
based on the YAML configuration files in my [cluster](./cluster) folder.

This repository was made possible by the fine folks at [k8s-at-home/template-cluster/k3s](https://github.com/k8s-at-home/template-cluster-k3s) and their template repository.

## Cluster components

- [rook-ceph](https://rook.io/): Provides persistent storage volumes.
- [Mozilla SOPS](https://toolkit.fluxcd.io/guides/mozilla-sops): Encrypts secrets and allows for safe storage in public repositories
- [external-dns](https://github.com/kubernetes-sigs/external-dns): Automatically creates DNS records on Cloudflare when public ingress records are created.

## Hardware Overview

### Compute Hardware

| Device          | Count | OS Disk    | Data Disk   | RAM  | Purpose        |
| --------------- | ----- | ---------- | ----------- | ---- | -------------- |
| Intel NUC7i5BNH | 3     | 512GB NVMe | 1 x 2TB SSD | 32GB | k3s nodes      |
| Raspberry PI 4B | 1     | 32GB SD    |             | 4GB  | Canonical MAAS |

### Storage Hardware

| Device          | Count | Disk Size   | RAM | Purpose            |
| --------------- | ----- | ----------- | --- | ------------------ |
| Synology DS1511 | 1     | 5 x 4TB HDD | 4GB | NAS storage        |
| Synology D513   | 1     | 2 x 4TB HDD | -   | NAS expansion unit |

### Other Hardware

| Device                     | Count | Type | Purpose                 |
| -------------------------- | ----- | ---- | ----------------------- |
| CyberPower PDU41001        | 1     | PDU  | SNMP controlled PDU     |
| CyberPower OR1500LCDRTXL2U | 1     | UPS  | SNMP controlled UPS     |
| TESmart KVM Switch 16      | 1     | KVM  | 16 Port HDMI KVM Switch |
