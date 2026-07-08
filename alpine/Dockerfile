FROM alpine:latest

LABEL Name="do-agent"
LABEL Version="4.274.1.1"

LABEL org.opencontainers.image.title="do-agent"
LABEL org.opencontainers.image.version="alpine-4.274.1.1"
LABEL org.opencontainers.doa.version="linux-amd64-4.274.1"

# Update repository lists and install native dependencies required by the agent and Git
RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    procps \
    icu-libs \
    libcurl \
    libstdc++ \
    libgcc \
    zlib \
    libc6-compat \
    gcompat

# Set the working directory inside the container
WORKDIR /DOA

# Copy the runtime bootstrap script from the host to the container
COPY start.sh .

# Grant execution permissions to the script
RUN chmod +x start.sh

# Define the script as the main entry point when the container boots up
ENTRYPOINT ["./start.sh"]

# Empty CMD instruction to silence the linter
CMD []
