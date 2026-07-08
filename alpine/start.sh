#!/bin/bash
# Exit immediately if any command returns a non-zero exit status
set -e

# Validation: Ensure the agent is already installed avoiding starting again the installation
if [ -f "$PWD/.agent" ]; then
  echo "Agent already configured, starting"

  export AGENT_ALLOW_RUNASROOT="1"
  source ./env.sh

  exec ./run.sh "$@"
fi

# Validation: Ensure that the organization URL for the agent has been configured
if [ -z "$DO_URL" ] || [ "$DO_URL" == "null" ]; then
  echo "error: organization url empty or not configured" >&2
  
  exit 1
fi

# Validation: Ensure the Personal Access Token (PAT) is provided
if [ -z "$DO_PAT_FILE" ]; then
  if [ -z "$DO_PAT" ]; then
    echo "error: missing DO_PAT environment variable" >&2
    
    exit 1
  fi
  # Store the token safely in a temporary file inside the container
  DO_PAT_FILE=/DOA/.token
  
  echo -n "$DO_PAT" > "$DO_PAT_FILE"
fi

# Unset the raw token variable from memory for basic security hardening and showing PAT for debug
unset DO_PAT

# Required by Microsoft to bypass the block preventing the agent from running as root
export AGENT_ALLOW_RUNASROOT="1"

# Agent download URL and download logic
DOA_DOWNLOAD_URL='https://download.agent.dev.azure.com/agent/4.274.1/vsts-agent-linux-x64-4.274.1.tar.gz'

if [ -z "$DOA_DOWNLOAD_URL" ] || [ "$DOA_DOWNLOAD_URL" == "null" ]; then
  echo "error: agent download url empty or not configured" >&2
  
  exit 1
fi

echo -e "\n1. Downloading and extracting the official agent tarball...\n"
curl -LsS $DOA_DOWNLOAD_URL | tar -xz

# Load environment variables exported by the extracted agent package
source ./env.sh

echo -e "\n2. Registering and configuring the agent against Azure DevOps...\n"
./config.sh --unattended \
  --agent "${DO_AGENT_NAME:-DOA-Docker-"$(hostname)"}" \
  --url "$DO_URL" \
  --auth PAT \
  --token $(cat "$DO_PAT_FILE") \
  --pool "${DO_POOL:-Default}" \
  --work _work \
  --replace \
  --acceptteeeula

echo -e "\n3. Agent successfully configured. Launching worker listener...\n"
# Switch execution to the listener loop (keeps the container alive and waiting for pipeline jobs)
exec ./run.sh "$@" # This adds the ability to inherit parameters from the shell; if I type “--once” when I run the script, it passes that to the “run.sh” script inside the container
