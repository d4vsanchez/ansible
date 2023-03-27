FROM ubuntu:jammy AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible curl git build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove -y

FROM base AS ansible
ARG TAGS
RUN addgroup --gid 1000 davsanchez
RUN adduser --gecos davsanchez --uid 1000 --gid 1000 --disabled-password davsanchez
USER davsanchez
WORKDIR /home/davsanchez

FROM ansible
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
