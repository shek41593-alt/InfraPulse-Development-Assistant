# ==========================================================
# InfraPulse Docker Image
# ==========================================================

FROM ubuntu:24.04

LABEL maintainer="Abhishek"
LABEL project="InfraPulse"

ENV DEBIAN_FRONTEND=noninteractive

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
    && apt-get clean

WORKDIR /opt/infrapulse

COPY . .

RUN chmod +x install.sh || true
RUN chmod +x uninstall.sh || true

RUN find monitoring -name "*.sh" -exec chmod +x {} \;
RUN find dashboard -name "*.sh" -exec chmod +x {} \;
RUN find reports -name "*.sh" -exec chmod +x {} \;
RUN find notifications -name "*.sh" -exec chmod +x {} \;
RUN find automation -name "*.sh" -exec chmod +x {} \;
RUN find multiserver -name "*.sh" -exec chmod +x {} \;

CMD ["bash"]
