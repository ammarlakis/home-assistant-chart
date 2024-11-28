# homeassistant

A Helm chart for deploying Home Assistant on Kubernetes

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2024.11.2](https://img.shields.io/badge/AppVersion-2024.11.2-informational?style=flat-square)

## Overview

This Helm chart enables the deployment of a Home Assistant instance on Kubernetes. It supports:
- Restoring Home Assistant backups during fresh installations.
- Reloading configurations dynamically using ConfigMaps and Secrets.

## Usage

### Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm repo add homeassistant https://ammarlakis.github.io/home-assistant-chart
helm install my-release homeassistant/homeassistant
```

### Restoring Backups

To restore a backup during installation:
1. Set the URL where the backup archive can be downloaded in `.Values.reloader.url`.
2. Enable the reloader by setting `.Values.reloader.enabled` to `true`.

> **Note**: Backup restoration is only supported during fresh installations.

### Reloading Configuration

Configurations can be reloaded dynamically by creating `ConfigMaps` or `Secrets` with specific labels. The labels are defined in `.Values.homeassistant.reloader.*.label` and default to:
- `homeassistant.automations`
- `homeassistant.scenes`
- `homeassistant.themes`
- `homeassistant.scripts`

#### Example ConfigMap

Below is an example `ConfigMap` for Home Assistant automations:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: homeassistant-config-mct9kb5d72
  labels:
    homeassistant.automations: homeassistant
data:
  bathroom-light-brightness-adjustment.yaml: |
    alias: Bathroom light brightness adjustment
    description: ''
    trigger:
      - platform: state
        entity_id:
          - input_number.bathroom_light_brightness
    condition:
      - condition: state
        entity_id: light.bathroom_light
        state: 'on'
    action:
      - service: automation.trigger
        data:
          skip_condition: true
        target:
          entity_id: automation.bathroom_light_brightness
    mode: single
```

## Values

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `nil` |  |
| fullnameOverride | string | `nil` |  |
| homeassistant.adminSecret | string | `nil` | The reference to a secret containing admin credentials Should have two keys USERNAME and PASSWORD |
| homeassistant.hostname | string | `"homeassistant.home"` | The hostname for Home Assistant |
| homeassistant.image.path | string | `"ghcr.io/home-assistant/home-assistant"` | The Home Assistant image to use |
| homeassistant.image.tag | string | `"latest"` | The Home Assistang image tag @default `{{ .Chart.AppVersion }}` |
| homeassistant.zigbeeDevice | string | `nil` | The reference to the Zigbee device to use with Home Assistant |
| homeassistant.storage | string | `"1Gi"` | The storage size for Home Assistant |
| homeassistant.reloader.image | string | `"kiwigrid/k8s-sidecar:latest"` | The reloader image to use for applying changes |
| homeassistant.reloader.webhook_id | string | `nil` | The webhook ID for the reloader Generate a random value to be used for reloading webhooks. |
| homeassistant.reloader.automations.enabled | bool | `true` | Whether to enable automations |
| homeassistant.reloader.automations.label | string | `"homeassistant.automations"` | The label for automations |
| homeassistant.reloader.scripts.enabled | bool | `true` | Whether to enable scripts |
| homeassistant.reloader.scripts.label | string | `"homeassistant.scripts"` | The label for scripts |
| homeassistant.reloader.scenes.enabled | bool | `true` | Whether to enable scenes |
| homeassistant.reloader.scenes.label | string | `"homeassistant.scenes"` | The label for scenes |
| homeassistant.reloader.themes.enabled | bool | `true` | Whether to enable themes |
| homeassistant.reloader.themes.label | string | `"homeassistant.themes"` | The label for themes |
| homeassistant.config | string | `"default_config:\n\nhomeassistant:\n  name: Home\n  latitude: 31.7780191\n  longitude: 35.2354079\n  elevation: 747\n  unit_system: metric\n  currency: PAL\n  country: PS\n  time_zone: \"Asia/Jerusalem\"\n  language: \"en\"\n\nfrontend:\n  themes: !include_dir_merge_named themes\n\ntts:\n  - platform: google_translate\n\nautomation: !include_dir_list automations\nautomation ui: !include automations.yaml\nscript: !include_dir_list scripts\nscript ui: !include scripts.yaml\nscene: !include_dir_list scenes\nscene ui: !include scenes.yaml\n\nhttp:\n  use_x_forwarded_for: true\n  trusted_proxies:\n    - 10.42.0.0/24\n    - 0.0.0.0/0\n"` | The configuration for Home Assistant |
| homeassistant.ingress.enabled | bool | `false` | Whether to create an ingress resource |
| homeassistant.ingress.annotations | object | `{}` | Ingress annotations |
| homeassistant.persistence | object | `{"enabled":false,"size":"10Gi","storageClass":"standard"}` | Persistent storage configuration |
| homeassistant.persistence.enabled | bool | `false` | Enable persistent storage |
| homeassistant.persistence.size | string | `"10Gi"` | Persistent storage size |
| homeassistant.persistence.storageClass | string | `"standard"` | Persistent storage class |
| restore.enabled | bool | `false` | Whether to enable restore functionality |
| restore.url | string | `""` | The URL for a Home Assistant backup to be downloaded and restored |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
