# Build container
FROM golang:1.12-alpine as builder

RUN apk update && apk add git
RUN go get -u github.com/golang/dep/cmd/dep

WORKDIR $GOPATH/src/github.com/parrotmac/httplab

COPY . .

RUN dep ensure -v

ENV CGO_ENABLED=0
RUN go build -o /tmp/httplab cmd/httplab/main.go

# Run container
FROM alpine

WORKDIR /opt/httplab

COPY --from=builder /tmp/httplab /opt/httplab/httplab

# Sleep may be needed to allocate a pseudo-tty
# (Issue https://github.com/docker/for-linux/issues/314 may not be resolved?)
CMD ["/bin/sh", "-c", "sleep 0.1; /opt/httplab/httplab"]
