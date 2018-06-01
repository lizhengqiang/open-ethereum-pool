FROM golang
ADD . $GOPATH/src/github.com/sammy007/open-ethereum-pool
# golang
RUN git config --global http.https://gopkg.in.followRedirects true
WORKDIR $GOPATH/src/github.com/sammy007/open-ethereum-pool
RUN make
# npm
WORKDIR $GOPATH/src/github.com/sammy007/open-ethereum-pool/www
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        ca-certificates \
        build-essential \
        libsodium-dev \
        npm \
        curl \
        wget \
        git \
    && rm -rf /var/lib/apt/lists/*
RUN npm install n -g \ 
    && n 4.8.7
RUN npm install -g ember-cli@2.9.1 \
    && npm install -g bower \
    && npm install \
    && bower install \
    && ./build.sh
# cmd
WORKDIR $GOPATH/src/github.com/sammy007/open-ethereum-pool
CMD ./build/bin/open-ethereum-pool config.json