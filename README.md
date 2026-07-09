[![Build and Push on DockerHub](https://img.shields.io/github/actions/workflow/status/Blasteed/DO-Agent/.github%2Fworkflows%2Fdocker-build-and-publish.yaml?logo=github&logoColor=white&label=Build%20and%20Push%20on%20DockerHub&maxAge=0)]()
[![Trivy Scan](https://img.shields.io/github/actions/workflow/status/Blasteed/DO-Agent/.github%2Fworkflows%2Ftrivy-scan.yaml?logo=github&logoColor=white&label=Trivy%20scan&maxAge=0)]()
[![Pulls](https://img.shields.io/docker/pulls/karfee111/do-agent?logo=docker&logoColor=white&color=1d63ed&label=Pulls&maxAge=0&cacheBuster=1783589431)](https://hub.docker.com/r/karfee111/do-agent)
[![Latest DOA Version](https://img.shields.io/badge/dynamic/json?logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0ndXRmLTgnPz4KPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxOCIgaGVpZ2h0PSIxOCIgdmlld0JveD0iMCAwIDE4IDE4Ij48dGl0bGU%2BSWNvbi1kZXZvcHMtMjYxPC90aXRsZT48cGF0aCBkPSJNMTcsNHY5Ljc0bC00LDMuMjgtNi4yLTIuMjZWMTdMMy4yOSwxMi40MWwxMC4yMy44VjQuNDRabS0zLjQxLjQ5TDcuODUsMVYzLjI5TDIuNTgsNC44NCwxLDYuODd2NC42MWwyLjI2LDFWNi41N1oiIGZpbGw9IiNGRkZGRkYiIC8%2BPC9zdmc%2B&color=0078d4&label=Latest%20DOA%20Version&query=%24.doa_version&url=https%3A%2F%2Fraw.githubusercontent.com%2FBlasteed%2FDO-Agent%2Fmain%2Fmisc%2Fbuild-metadata.json&maxAge=0)]()

[![Noble Image](https://img.shields.io/docker/image-size/karfee111/do-agent/noble-latest?logo=ubuntu&logoColor=white&color=e95420&label=Noble%20Image&maxAge=0)](https://hub.docker.com/r/karfee111/do-agent/tags)
[![Trixie Image](https://img.shields.io/docker/image-size/karfee111/do-agent/trixie-latest?logo=debian&logoColor=white&color=a81d33&label=Trixie%20Image&maxAge=0)](https://hub.docker.com/r/karfee111/do-agent/tags)
[![RHEL Image](https://img.shields.io/docker/image-size/karfee111/do-agent/rhel-latest?logo=redhat&logoColor=white&color=e5141f&label=RHEL%20Image&maxAge=0)](https://hub.docker.com/r/karfee111/do-agent/tags)

[![Noble Vulnerabilities](https://img.shields.io/badge/dynamic/json?logo=ubuntu&logoColor=white&color=e95420&label=Noble%20CVEs&query=%24.noble_cves&url=https%3A%2F%2Fraw.githubusercontent.com%2FBlasteed%2FDO-Agent%2Fmain%2Fmisc%2Fsecurity-metadata.json&maxAge=0)](https://github.com/Blasteed/DO-Agent/blob/main/security-reports/noble-vulns.txt)
[![Trixie Vulnerabilities](https://img.shields.io/badge/dynamic/json?logo=debian&logoColor=white&color=a81d33&label=Trixie%20CVEs&query=%24.trixie_cves&url=https%3A%2F%2Fraw.githubusercontent.com%2FBlasteed%2FDO-Agent%2Fmain%2Fmisc%2Fsecurity-metadata.json&maxAge=0)](https://github.com/Blasteed/DO-Agent/blob/main/security-reports/trixie-vulns.txt)
[![RHEL Vulnerabilities](https://img.shields.io/badge/dynamic/json?logo=redhat&logoColor=white&color=a81d33&label=RHEL%20CVEs&query=%24.rhel_cves&url=https%3A%2F%2Fraw.githubusercontent.com%2FBlasteed%2FDO-Agent%2Fmain%2Fmisc%2Fsecurity-metadata.json&maxAge=0)](https://github.com/Blasteed/DO-Agent/blob/main/security-reports/rhel-vulns.txt)

# Azure DevOps Agent

A lightweight, self-hosted Azure DevOps build agent based on **Linux** — available across multiple distributions and variants:

| Tag prefix | Base | libicu | Description |
| :--- | :--- | :---: | :--- |
| `trixie-*` | `debian:trixie-slim` | 76 | Debian-based build |
| `noble-*` | `ubuntu:noble` (24.04 LTS) | 74 | Ubuntu-based build |

> **Note:** These images are intentionally minimal — they include only what is required to run the Azure DevOps agent (`git`, `curl`, `ca-certificates`, and .NET runtime libraries). No Python, Node.js, or other build tools are pre-installed. See [Extending the image](#-extending-the-image) below.

---

## 🚀 Quick Start

Launch the agent with automatic restart:

### Debian Trixie

```bash
docker run -d \
  --name doa-agent-prod \
  --restart unless-stopped \
  -e DO_URL="https://dev.azure.com/your-organization" \
  -e DO_PAT="your_personal_access_token" \
  -e DO_POOL="your_pool_name" \
  -e DO_AGENT_NAME="DOA-Agent" \
  karfee111/do-agent:trixie-latest
```

### Ubuntu Noble

```bash
docker run -d \
  --name doa-agent-prod \
  --restart unless-stopped \
  -e DO_URL="https://dev.azure.com/your-organization" \
  -e DO_PAT="your_personal_access_token" \
  -e DO_POOL="your_pool_name" \
  -e DO_AGENT_NAME="DOA-Agent" \
  karfee111/do-agent:noble-latest
```

Monitor startup logs and registration:

```bash
docker logs -f doa-agent-prod
```

---

## ⚙️ Configuration Variables

The container automatically configures and registers the agent at boot using these environment variables:

| Variable | Description | Default | Required |
| :--- | :--- | :---: | :---: |
| `DO_URL` | Full URL of your Azure DevOps organization | — | ✅ |
| `DO_PAT` | Personal Access Token with **Agent Pools (Read & Manage)** scope | — | ✅ |
| `DO_POOL` | Name of the target agent pool | `Default` | ❌ |
| `DO_AGENT_NAME` | Display name in the Azure DevOps panel | `DOA-Agent-$(hostname)` | ❌ |

---

## 💓 Healthcheck

To ensure accurate container health monitoring without adding unnecessary overhead or packages, the native Linux `/proc` filesystem virtual directory is used to safely track the core `Agent.Listener` lifecycle. A `start_period` of 3 minutes is recommended to allow the `./start.sh` entrypoint script to safely download updates and register with Azure DevOps before monitoring begins.

### Docker Run Example

To deploy with health monitoring via CLI:

```bash
docker run -d \
  --name doa-agent-prod \
  --restart unless-stopped \
  -e DO_URL="https://dev.azure.com/your-organization" \
  -e DO_PAT="your_personal_access_token" \
  -e DO_POOL="your_pool_name" \
  -e DO_AGENT_NAME="DOA-Agent" \
  --health-cmd='grep -aq "Agent.Listener" /proc/[0-9]*/cmdline || exit 1' \
  --health-interval=45s \
  --health-timeout=10s \
  --health-retries=4 \
  --health-start-period=180s \
  karfee111/do-agent:noble-latest
```

---

## 📦 Docker Compose

```yaml
services:
  azure-agent:
    image: karfee111/do-agent:trixie-latest
    container_name: doa-agent-prod
    restart: unless-stopped
    environment:
      - DO_URL=https://dev.azure.com/your-organization
      - DO_PAT=your_personal_access_token
      - DO_POOL=your_pool_name
      - DO_AGENT_NAME=DOA-Agent
    healthcheck:
      test: ["CMD-SHELL", "grep -aq 'Agent.Listener' /proc/[0-9]*/cmdline || exit 1"]
      interval: 45s
      timeout: 10s
      retries: 4
      start_period: 180s
```

```bash
docker compose up -d
```

> **Ubuntu variant:** replace the tag with `noble-latest` to use the Ubuntu 24.04 based image.

---

## 🛠️ Pass-through Arguments

This image forwards extra arguments directly to Microsoft's native `run.sh`. For example, to run a single job and exit:

```bash
docker run -d \
  --name doa-agent-once \
  -e DO_URL="https://dev.azure.com/your-organization" \
  -e DO_PAT="your_personal_access_token" \
  -e DO_POOL="your_pool_name" \
  -e DO_AGENT_NAME="DOA-Agent" \
  karfee111/do-agent:trixie-latest --once
```

---

## 🔧 Extending the Image

These images ship with the bare minimum to run the agent. If your pipelines require additional tools (Python, Node.js, .NET SDK, etc.), extend the image with your own Dockerfile:

```dockerfile
FROM karfee111/do-agent:trixie-latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

USER agent
```

Alternatively, you can override the entrypoint at runtime to install packages or run setup commands dynamically before the agent starts.

⚠️ **Important:** When overriding the entrypoint, you must end your execution chain with `exec ./start.sh`.

**Via Docker Run:**

```bash
docker run -d \
  --name doa-agent-prod \
  --restart unless-stopped \
  -e DO_URL="https://dev.azure.com/your-organization" \
  -e DO_PAT="your_personal_access_token" \
  -e DO_POOL="your_pool_name" \
  -e DO_AGENT_NAME="DOA-Agent" \
  --entrypoint /bin/bash \
  karfee111/do-agent:trixie-latest \
  -c "apt-get update && apt-get install -y --no-install-recommends python3 && ln -sf /usr/bin/python3 /usr/bin/python && exec ./start.sh"
```

**Via Docker Compose:**

```yaml
services:
  azure-agent:
    image: karfee111/do-agent:trixie-latest
    restart: unless-stopped
    entrypoint: >
      /bin/bash -c "
      apt-get update && 
      apt-get install -y --no-install-recommends python3 && 
      ln -sf /usr/bin/python3 /usr/bin/python && 
      exec ./start.sh
      "
    environment:
      - DO_URL=https://dev.azure.com/your-organization
      - DO_PAT=your_personal_access_token
      - DO_POOL=your_pool_name
      - DO_AGENT_NAME=DOA-Agent
```

> **Tip:** For production use, prefer extending via Dockerfile rather than runtime installation — it keeps startup fast, independent of external package mirrors, and fully reproducible.

---

## 🏷️ Tag Convention

```
trixie-{agent_version}.{build_number}       # Debian Trixie
noble-{agent_version}.{build_number}        # Ubuntu 24.04 LTS
```

Examples: `trixie-4.274.1.1`, `noble-4.274.1.1`

### `latest` Tags

| Tag | Points to |
| :--- | :--- |
| `trixie-latest` | most recent `trixie-*` build |
| `noble-latest` | most recent `noble-*` build |
| `latest` | global alias pointing to the most recent `noble-*` build |

Floating tags always resolve to the most recent build for their respective distribution or the global default.
