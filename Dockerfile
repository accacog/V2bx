# Build go
FROM golang:1.20-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN go mod download
RUN go build -o V2bX -ldflags '-s -w' -gcflags="all=-trimpath=${PWD}" -asmflags="all=-trimpath=${PWD} -tags "xray"

# Release
FROM  alpine
# 安装必要的工具包
RUN  apk --update --no-cache add tzdata ca-certificates \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir /etc/XrayR/
COPY --from=builder /app/XrayR /usr/local/bin

ENTRYPOINT [ "XrayR", "--config", "/etc/XrayR/config.yml"]
