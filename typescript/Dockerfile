FROM fukamachi/roswell:21.10.14.111-ubuntu AS build

ARG VERSION
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux && \
  apt-get update && \
  apt-get install -y curl

# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#installing-gh-on-linux-and-bsd
RUN set -eux && \
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

RUN mkdir /tmp/inga

RUN set -eux && \
  curl -o /tmp/inga/setup_node -fsSL https://deb.nodesource.com/setup_14.x

RUN set -eux && \
  curl -o ./tsparser.tar.gz -L https://github.com/seachicken/tsparser/archive/refs/tags/v0.0.2.tar.gz && \
  mkdir /tmp/inga/tsparser && \
  tar xvf ./tsparser.tar.gz -C /tmp/inga/tsparser --strip-components 1

RUN set -eux && \
  curl -o ./inga.tar.gz -L https://github.com/seachicken/inga/archive/refs/tags/v$VERSION.tar.gz && \
  mkdir inga && \
  tar xvf ./inga.tar.gz -C ./inga --strip-components 1 && \
  ros && \
  cd ~/.roswell/local-projects && ln -s /inga inga && \
  ros build /inga/roswell/inga.ros


FROM ubuntu:22.04

COPY --from=build /usr/share/keyrings/githubcli-archive-keyring.gpg /usr/share/keyrings/githubcli-archive-keyring.gpg
COPY --from=build /tmp/inga /tmp/inga
COPY --from=build /inga/roswell/inga /usr/local/bin/

RUN set -eux && \
  apt-get update && \
  apt-get install -y git && \
  bash /tmp/inga/setup_node && apt-get install -y nodejs

RUN set -eux && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
  apt update && \
  apt install -y gh

RUN npm install -g typescript

RUN set -eux && \
  cd /tmp/inga/tsparser && npm ci && npm run build && \
  npm install -g .

ENV INGA_HOME /

ENTRYPOINT ["inga"]

