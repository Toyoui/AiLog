# 使用官方的Golang镜像作为基础镜像
FROM golang:latest

# 设置工作目录为/app
WORKDIR /app

# 将你的源码拷贝到工作目录中
COPY . .

# 下载所有依赖的包
RUN go mod download

# 构建可执行文件
RUN go build -o main .

# 暴露42042端口，让外部可以访问你的服务
EXPOSE 42042

# 在容器启动时运行你的服务
CMD ["./main"]
