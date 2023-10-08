# syntax=docker/dockerfile:1

FROM golang:1.21.2 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY main.go ./
COPY cuttle/ ./cuttle

RUN CGO_ENABLED=0 go build -o cuttle.bin

FROM gcr.io/distroless/base-debian12

WORKDIR /

COPY --from=builder /app/cuttle.bin /cuttle

EXPOSE 3128

USER nonroot:nonroot

ENTRYPOINT ["/cuttle"]
