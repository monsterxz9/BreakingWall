#!/bin/bash

# 更新包列表
sudo apt-get update

# 安装 Docker
sudo apt-get install -y docker.io

# 创建 Shadowsocks 配置文件
cat <<EOF > ~/server_config.json
{
    "server": "0.0.0.0",
    "server_port": 8388,
    "password": "YOUR_PASSWORD_HERE",
    "timeout": 300,
    "method": "aes-256-gcm"
}
EOF

# 运行 Shadowsocks 服务器
sudo docker run -d --name ss-server -p 8388:8388 \
  -v ~/server_config.json:/etc/shadowsocks-libev/config.json \
  shadowsocks/shadowsocks-libev ss-server -c /etc/shadowsocks-libev/config.json
