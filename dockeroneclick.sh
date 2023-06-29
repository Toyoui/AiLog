#!/bin/bash

# 检测操作系统类型
if [[ -e /etc/redhat-release ]]; then
    os_type="centos"
elif [[ -e /etc/debian_version ]]; then
    debian_version=$(cat /etc/debian_version)
    if [[ $debian_version == "9."* ]]; then
        os_type="debian"
    else
        os_type="ubuntu"
    fi
else
    echo "无法确定操作系统类型"
    exit 1
fi

# 判断文件是否存在
if [ -e "dockeroc.sh" ]; then
    # 如果文件存在，删除文件
    rm dockeroc.sh
    echo "dockeroc.sh文件已删除"
else
    # 如果文件不存在，输出提示信息
    echo "dockeroc.sh文件不存在"
fi

# 安装Docker和相关组件
if [[ $os_type == "centos" ]]; then
    # centos系统的安装脚本
    echo "正在安装Docker和相关组件（CentOS）..."
    sudo yum update -y
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
elif [[ $os_type == "debian" ]]; then
    # debian系统的安装脚本
    echo "正在安装Docker和相关组件（Debian）..."
    apt update
    apt upgrade -y
    apt install curl vim wget gnupg dpkg apt-transport-https lsb-release ca-certificates
    curl -sSL https://download.docker.com/linux/debian/gpg | gpg --dearmor > /usr/share/keyrings/docker-ce.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-ce.gpg] https://download.docker.com/linux/debian $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker.list
    curl -sS https://download.docker.com/linux/debian/gpg | gpg --dearmor > /usr/share/keyrings/docker-ce.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-ce.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker.list
    apt update
    apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo systemctl start docker
    sudo systemctl enable docker
elif [[ $os_type == "ubuntu" ]]; then
    # ubuntu系统的安装脚本
    echo "正在安装Docker和相关组件（Ubuntu）..."
    sudo apt update 
    sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y 
    sudo apt-get remove docker docker.io containerd runc -y 
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
    sudo apt update 
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo systemctl start docker
    sudo systemctl enable docker
else
    echo "无法确定操作系统类型"
    exit 1
fi

echo "安装完成！"
