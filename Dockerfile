ARG REGISTRY="docker.io/"
FROM ${REGISTRY}golang:1.26-alpine AS builder

ARG GOARCH

WORKDIR /src

RUN apk --no-cache add git
COPY main.go go.mod go.sum ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=${GOARCH} go build -o /bin/prometheus-msk-discovery .

FROM ${REGISTRY}alpine:latest

RUN apk --no-cache add ca-certificates
COPY --from=builder /bin/prometheus-msk-discovery /bin/

ENTRYPOINT ["prometheus-msk-discovery"]
