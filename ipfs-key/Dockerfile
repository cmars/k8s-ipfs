FROM golang:1.15 AS build
ENV GOPATH /gopath
COPY . /gopath/src/ipfs-key
WORKDIR /gopath/src/ipfs-key
RUN go install -a .

FROM debian:buster
COPY --from=build /gopath/bin/ipfs-key /bin/ipfs-key
ENTRYPOINT '/bin/ipfs-key'
