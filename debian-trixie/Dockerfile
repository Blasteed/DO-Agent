FROM debian:trixie-slim

LABEL Name="do-agent"
LABEL Version="5.278.0.1"

LABEL org.opencontainers.image.title="do-agent"
LABEL org.opencontainers.image.version="trixie-5.278.0.1"
LABEL org.opencontainers.doa.version="linux-x64-5.278.0"

# Prevent interactive prompts during package installation (e.g., timezone selection)
ENV DEBIAN_FRONTEND=noninteractive

# Update repository lists and install native dependencies required by the agent and Git
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    curl \
    git \
    libicu76 \
    libcurl4t64 \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /DOA

COPY start.sh .

RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]

# Empty CMD instruction to silence the linter
CMD []
