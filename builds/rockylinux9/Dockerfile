FROM quay.io/kairos/kairos-init:v0.4.4 AS kairos-init

FROM rockylinux/rockylinux:9
ARG VERSION=v0.0.1

RUN dnf -y install 'dnf-command(config-manager)'&& \
    dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo && \
    dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin && \
    systemctl enable docker

RUN dnf -y install \
    qemu-guest-agent
    
COPY root/ /

COPY --from=kairos-init /kairos-init /kairos-init
RUN /kairos-init -l debug -s install --fips --version "${VERSION}"
# Copy the custom dracut config file
COPY dracut.conf /etc/dracut.conf.d/kairos-fips.conf

RUN /kairos-init -l debug -s init --version "${VERSION}"
RUN rm /kairos-init

# Symlink kernel HMAC
RUN kernel=$(ls /boot/vmlinuz-* | head -n1) && ln -sf ."${kernel#/boot/}".hmac /boot/.vmlinuz.hmac
