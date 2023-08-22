#!/bin/bash

############################################
# 初始化一个 node，完成后具备加入到已存在的集群中
# 下文所有的 xxx 都需要换成自己真实的地址
############################################

echo "start to init a node, wait a minute..."

# set -e

# 安装配置docker
sudo apt-get remove docker docker-engine docker.io runc -y
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo add-apt-repository \
    "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian \
  $(lsb_release -cs) \
  stable"

sudo cat >/etc/docker/daemon.json <<EOF
{
    "insecure-registries": ["hub.xxx", "hub.xxx:443"],
    "live-restore": true,
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
}
EOF

# docker 代理
sudo mkdir -p /etc/systemd/system/docker.service.d
rm -rf /etc/systemd/system/docker.service.d/proxy.conf
sudo cat >/etc/systemd/system/docker.service.d/proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=http://sys-proxy-rd-relay.xxx:8118"
Environment="HTTPS_PROXY=http://sys-proxy-rd-relay.xxx:8118"
Environment="NO_PROXY=code.xxx,127.0.0.1,localhost"
EOF

# 重启docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# 临时设置代理
export HTTP_PROXY="http://sys-proxy-rd-relay.xxx:8118"
export HTTPS_PROXY="http://sys-proxy-rd-relay.xxx:8118"
export NO_PROXY="code.xxx,127.0.0.1,localhost"

# 配一下 apt-get 的 proxy，改 apt 的配置
sudo cat >/etc/apt/apt.conf.d/proxy.conf <<EOF
Acquire {
  http::proxy "http://sys-proxy-rd-relay.xxx:8118";
  https::proxy "http://sys-proxy-rd-relay.xxx:8118";
}
EOF

echo "安装 kubeadm，kubectl，和 kubelet"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo -s cat >/etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update

# 安装某个具体版本，我使用1.22.2-00没问题
sudo apt-get install -qy kubelet=1.22.2-00 kubectl=1.22.2-00 kubeadm=1.22.2-00

# 启动 kubelet
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubelet

# 拉取安装需要的镜像
kubeadm config images pull

# 关闭交换分区 k8s 运行时不允许交换分区打开
swapoff -a

# 重置 k8s 配置
kubeadm reset -f

echo "init a node success"
