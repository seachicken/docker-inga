FROM fukamachi/roswell:21.10.14.111-ubuntu

# install dependencies
RUN ros

RUN set -eux; \
  apt-get update; \
  DEBIAN_FRONTEND=noninteractive apt-get install -y curl git; \
  DEBIAN_FRONTEND=noninteractive apt-get install -y vim; \
  curl -fsSL https://deb.nodesource.com/setup_14.x | bash -; \
  DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

RUN set -eux; \
  curl -o ./inga.tar.gz \
    -L https://github.com/seachicken/inga/archive/refs/tags/v0.1.2-pre.tar.gz; \
  mkdir inga; \
  tar xvf ./inga.tar.gz -C inga --strip-components 1

RUN npm install -g typescript
RUN set -eux; \
  curl -o ./tsparser.tar.gz \
    -L https://github.com/seachicken/tsparser/archive/refs/tags/v0.0.2.tar.gz; \
  mkdir tsparser; \
  tar xvf ./tsparser.tar.gz -C tsparser --strip-components 1; \
  (cd tsparser && npm ci && npm run build); \
  npm install -g ./tsparser

#RUN ros install seachicken/inga

RUN (cd ~/.roswell/local-projects && ln -s /inga inga)

ENTRYPOINT ["/inga/roswell/inga.ros"]
#ENTRYPOINT ["inga"]

