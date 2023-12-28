# 基础镜像
FROM golang:latest

# 使用 Go Modules
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.io,direct

# 设置工作目录
WORKDIR /app

# 将代码和 go.mod 文件复制到容器中
COPY . .
COPY go.mod .

# 初始化Go modules
RUN go mod init example.com/okapi

# 下载依赖
RUN go mod download

# 编译Go程序
RUN go build -o main .

# 暴露42042端口，让外部可以访问你的服务
EXPOSE 42042

# 运行Go程序
CMD ["./main"]
