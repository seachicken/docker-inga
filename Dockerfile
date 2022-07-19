FROM fukamachi/roswell:21.10.14.111-ubuntu

RUN set -eux && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y curl git && \
  curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#installing-gh-on-linux-and-bsd
RUN set -eux && \
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
  apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -y gh && \
  DEBIAN_FRONTEND=noninteractive apt install -y openjdk-17-jdk && \
  DEBIAN_FRONTEND=noninteractive apt install -y python3.9

RUN (cd /usr/bin && ln -nfs python3.9 python3)

RUN npm install -g typescript

RUN set -eux && \
  curl -o ./tsparser.tar.gz -L https://github.com/seachicken/tsparser/archive/refs/tags/v0.0.2.tar.gz && \
  mkdir tsparser && \
  tar xvf ./tsparser.tar.gz -C tsparser --strip-components 1 && \
  (cd tsparser && npm ci && npm run build) && \
  npm install -g ./tsparser

RUN mkdir libs

RUN set -eux && \
  curl -o ./jdtls.tar.gz -L https://download.eclipse.org/jdtls/milestones/1.13.0/jdt-language-server-1.13.0-202206301721.tar.gz && \
  mkdir libs/jdtls && \
  tar xvf ./jdtls.tar.gz -C ./libs/jdtls

RUN set -eux && \
  curl -o ./libs/javaparser.jar -L https://github.com/seachicken/javaparser/releases/download/javaparser-0.1.0/javaparser-0.1.0.jar

ENV INGA_HOME /

RUN ros install seachicken/inga/v0.1.7

ENTRYPOINT ["inga"]

