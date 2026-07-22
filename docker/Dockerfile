# ==========================================================
# InfraPulse Docker Image
# ==========================================================

FROM ubuntu:24.04

LABEL maintainer="Abhishek"
LABEL project="InfraPulse"
LABEL description="InfraPulse - Linux Monitoring and Automation Toolkit"

ENV DEBIAN_FRONTEND=noninteractive

# ----------------------------------------------------------
# Install Required Packages
# ----------------------------------------------------------
RUN apt-get update && apt-get install -y \
    bash \
    procps \
    iproute2 \
    iputils-ping \
    net-tools \
    curl \
    openssh-client \
    cron \
    jq \
    bc \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------
# Application Directory
# ----------------------------------------------------------
WORKDIR /opt/infrapulse

# ----------------------------------------------------------
# Copy Project Files
# ----------------------------------------------------------
COPY . .

# ----------------------------------------------------------
# Copy Entrypoint
# ----------------------------------------------------------
COPY docker/entrypoint.sh /entrypoint.sh

# ----------------------------------------------------------
# Make Scripts Executable
# ----------------------------------------------------------
RUN chmod +x /entrypoint.sh && \
    chmod +x install.sh || true && \
    chmod +x uninstall.sh || true && \
    find monitoring -type f -name "*.sh" -exec chmod +x {} \; && \
    find dashboard -type f -name "*.sh" -exec chmod +x {} \; && \
    find reports -type f -name "*.sh" -exec chmod +x {} \; && \
    find notifications -type f -name "*.sh" -exec chmod +x {} \; && \
    find automation -type f -name "*.sh" -exec chmod +x {} \; && \
    find multiserver -type f -name "*.sh" -exec chmod +x {} \;

# ----------------------------------------------------------
# Entrypoint
# ----------------------------------------------------------
ENTRYPOINT ["/entrypoint.sh"]

# Default container command
CMD ["bash"]
