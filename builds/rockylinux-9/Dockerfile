FROM quay.io/kairos/kairos-init:v0.4.7 AS kairos-init

FROM rockylinux/rockylinux:9
ARG VERSION=v0.0.1

RUN dnf -y install 'dnf-command(config-manager)'&& \
    dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo && \
    dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin && \
    systemctl enable docker

RUN dnf -y install \
    btop \
    dbus-daemon \
    dbus-glib-devel \
    dhcp-client \
    dosfstools \
    epel-release \
    gcc \
    git \
    grub2 \
    iproute \
    iputils \
    openssl-devel \
    openssh-server \
    parted \
    procps-ng \
    python3.12 \
    python3.12-devel \
    python3.12-pip \
    python3.12-setuptools \
    qemu-guest-agent \
    rsync \
    sudo \
    unzip \
    wget \
    which \
    vim && \
    dnf clean all && \
    rm -rf /var/cache/yum

RUN \
 pip3.12 install --no-cache-dir docker>=7.0.0 dbus-python requests

COPY root/ /

COPY --from=kairos-init /kairos-init /kairos-init
RUN /kairos-init -l debug -s install --fips --version "${VERSION}"
# Copy the custom dracut config file
COPY dracut.conf /etc/dracut.conf.d/kairos-fips.conf

RUN /kairos-init -l debug -s init --version "${VERSION}"
RUN rm /kairos-init

# Symlink kernel HMAC
RUN kernel=$(ls /boot/vmlinuz-* | head -n1) && ln -sf ."${kernel#/boot/}".hmac /boot/.vmlinuz.hmac
