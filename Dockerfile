FROM golang
ADD . $GOPATH/src/github.com/sammy007/open-ethereum-pool
RUN git config --global http.https://gopkg.in.followRedirects true
WORKDIR $GOPATH/src/github.com/sammy007/open-ethereum-pool
RUN make