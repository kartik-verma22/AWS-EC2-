FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    sudo \
    curl \
    wget \
    unzip \
    vim \
    git \
    openssh-server \
    build-essential \
    python3 \
    python3-pip \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "ubuntu:password" | chpasswd
RUN usermod -aG sudo ubuntu && usermod -aG docker ubuntu

RUN mkdir /var/run/sshd
RUN ssh-keygen -A

EXPOSE 22
EXPOSE 2375

CMD ["sh", "-c", "dockerd & service ssh start && tail -f /dev/null"]
