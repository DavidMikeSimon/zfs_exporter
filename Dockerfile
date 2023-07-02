FROM golang:1.18-alpine AS builder
WORKDIR /opt/zfs_exporter
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN go build -v -o /usr/local/bin/zfs_exporter

FROM ubuntu:23.04
RUN apt update && apt install -y zfsutils-linux && rm -rf /var/lib/apt/lists/*
WORKDIR /
COPY --from=builder /usr/local/bin/zfs_exporter /usr/bin/zfs_exporter
ENTRYPOINT ["zfs_exporter"]
