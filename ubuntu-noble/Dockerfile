FROM ubuntu:noble

LABEL Name="do-agent"
LABEL Version="5.278.0.1"

LABEL org.opencontainers.image.title="do-agent"
LABEL org.opencontainers.image.version="noble-5.278.0.1"
LABEL org.opencontainers.doa.version="linux-x64-5.278.0"

# Update repository lists and install native dependencies required by the agent and Git
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    curl \
    git \
    libicu74 \
    libcurl4t64 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /DOA

COPY start.sh .

RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]

# Empty CMD instruction to silence the linter
CMD []
