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
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
elif [[ $os_type == "ubuntu" ]]; then
    # ubuntu系统的安装脚本
    echo "正在安装Docker和相关组件（Ubuntu）..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
else
    echo "无法确定操作系统类型"
    exit 1
fi

echo "安装完成！"
