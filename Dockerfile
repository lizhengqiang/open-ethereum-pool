FROM ubuntu as www
ENV POOL_VERSION O_SR_1.0.0
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
    && n latest

ADD . /go/src/github.com/sammy007/open-ethereum-pool
WORKDIR /go/src/github.com/sammy007/open-ethereum-pool/www

RUN npm install -g ember-cli@2.9.1 \
    && npm install -g bower \
    && npm install \
    && bower install --allow-root \
    && ./build.sh

FROM golang
ADD . $GOPATH/src/github.com/sammy007/open-ethereum-pool
# golang
RUN git config --global http.https://gopkg.in.followRedirects true
WORKDIR $GOPATH/src/github.com/sammy007/open-ethereum-pool
RUN make
# npm
COPY --from=www /go/src/github.com/sammy007/open-ethereum-pool/www /go/src/github.com/sammy007/open-ethereum-pool/www
# cmd
WORKDIR $GOPATH/src/github.com/sammy007/open-ethereum-pool
CMD ./build/bin/open-ethereum-pool config.json