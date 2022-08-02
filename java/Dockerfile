FROM fukamachi/roswell:21.10.14.111-ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux && \
  apt-get update && \
  apt-get install -y curl git

# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#installing-gh-on-linux-and-bsd
RUN set -eux && \
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
  apt update && \
  apt install -y gh && \
  apt install -y openjdk-17-jdk && \
  apt install -y python3.9

RUN (cd /usr/bin && ln -nfs python3.9 python3)

RUN mkdir libs

RUN set -eux && \
  curl -o ./jdtls.tar.gz -L https://download.eclipse.org/jdtls/milestones/1.13.0/jdt-language-server-1.13.0-202206301721.tar.gz && \
  mkdir libs/jdtls && \
  tar xvf ./jdtls.tar.gz -C ./libs/jdtls

RUN curl -o ./libs/lombok.jar -L https://projectlombok.org/downloads/lombok.jar

RUN curl -o ./libs/javaparser.jar -L https://github.com/seachicken/javaparser/releases/download/javaparser-0.1.0/javaparser-0.1.0.jar

ENV INGA_HOME /

RUN ros install seachicken/inga/v0.1.11

ENTRYPOINT ["inga"]

