FROM quay.io/kairos/kairos-init:v0.7.0 AS kairos-init

FROM debian:13
ARG VERSION=v0.0.1

RUN apt-get update && \
    apt-get -y install ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
       $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

COPY root/ /

COPY --from=kairos-init /kairos-init /kairos-init
RUN /kairos-init -l debug -s install --version "${VERSION}"

RUN /kairos-init -l debug -s init --version "${VERSION}"
RUN rm /kairos-init

# Symlink kernel HMAC
RUN kernel=$(ls /boot/vmlinuz-* | head -n1) && ln -sf ."${kernel#/boot/}".hmac /boot/.vmlinuz.hmac
