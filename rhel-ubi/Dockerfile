FROM redhat/ubi10-minimal:latest

LABEL Name="do-agent"
LABEL Version="5.275.0.1"

LABEL org.opencontainers.image.title="do-agent"
LABEL org.opencontainers.image.version="rhel-5.275.0.1"
LABEL org.opencontainers.doa.version="linux-x64-5.275.0"

# Update repository lists and install native dependencies required by the agent and Git
RUN microdnf update -y && microdnf install -y \
    ca-certificates \
    git \
    tar \
    procps-ng \
    libicu \
    && microdnf clean all

WORKDIR /DOA

COPY start.sh .

RUN sed -i 's/\r$//' start.sh && chmod +x start.sh

ENTRYPOINT ["./start.sh"]

# Empty CMD instruction to silence the linter
CMD []
