FROM debian:bullseye-slim

## Install dependencies.
RUN apt-get update && apt-get install -y \
  curl git iproute2 jq lsof man neovim netcat procps qrencode xxd sudo tmux unzip

## Install Postgres
RUN apt-get install -y postgresql postgresql-contrib

## Install Bun
RUN curl -fsSL https://bun.sh/install | bash

## Copy over filesystem.
COPY img /

## Create a src folder.
RUN mkdir -p /root/src

## Make sure scripts are executable.
RUN chmod a+x /entrypoint.sh
RUN test "$(ls -A /scripts)" && \
  for FILE in /scripts/* ; do chmod a+x $FILE; done

## Add custom profile to bashrc.
RUN printf "\n[ -f /profile ] && . /profile\n\n" >> /root/.bashrc

## Setup Environment.
ENV PATH="/root/.local/bin:/root/.bun/bin:$PATH"
ENV DATA="/data"

WORKDIR /root

ENTRYPOINT [ "/entrypoint.sh" ]
