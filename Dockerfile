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
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
    libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
    libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
    libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget

RUN set -eux; \
  snap install chromium

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

