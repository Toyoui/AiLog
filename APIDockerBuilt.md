### 测试环境
- Debian11
- Centos7
- Ubuntu22
### 1.安装BBR加速（可选）
- 有什么作用自行搜索（不赘述）
```shell
自行访问 https://teddysun.com/489.html
```
### 2.一键安装docker
> 如果已经有docker环境请不要执行
```shell
curl -o dockeroc.sh https://raw.githubusercontent.com/Toyoui/AiLog/main/dockeroneclick.sh && chmod +x dockeroc.sh && ./dockeroc.sh
```

### 3.部署相关文件
```shell
mkdir AiTools
cd AiTools
mkdir AITools.NET.API
touch Dockerfile
```
- 把Api所有文件放入 AITools.NET.API 文件夹
- 把下面内容写入Dockerfile文件
```
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS build
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /app
COPY AITools.NET.API/ ./
WORKDIR /app
EXPOSE 5005
#安装fontconfig
RUN apt-get clean
RUN apt-get update && apt-get install -y fontconfig procps
ENTRYPOINT ["dotnet", "AITools.NET.Web.Entry.dll"]
```

### 4.运行docker启动api
```shell
cd AiTools
docker build -t myapp .
docker run -d -p 5005:5005 --name myapi myapp
```
### 5.如何更新？
- 把你增量包文件添加到AITools.NET.API 文件夹下
```shell
docker kill myapi
docker rm myapi
cd AiTools
docker build -t myapp .
docker run -d -p 5005:5005 --name myapi myapp
```
