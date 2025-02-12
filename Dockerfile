# syntax=docker/dockerfile:1

FROM golang:1.24.0 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY main.go ./
COPY cuttle/ ./cuttle

RUN CGO_ENABLED=0 go build -o cuttle.bin

FROM gcr.io/distroless/base-debian12

COPY --from=builder /app/cuttle.bin /usr/local/bin/cuttle

EXPOSE 3128

USER nonroot:nonroot

ENTRYPOINT ["/usr/local/bin/cuttle"]
