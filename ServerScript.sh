#!/bin/bash
set -e

# Xray VLESS+REALITY 一键部署脚本
# 协议: VLESS | 传输: TCP | 安全层: REALITY
# 伪装目标: cloudflare.com

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

XRAY_CONFIG_DIR="/usr/local/etc/xray"
XRAY_CONFIG="$XRAY_CONFIG_DIR/config.json"

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 检查 root 权限
[[ $EUID -ne 0 ]] && error "请使用 root 权限运行此脚本: sudo bash $0"

# 安装 xray
install_xray() {
    if command -v xray &>/dev/null; then
        info "Xray 已安装: $(xray version | head -1)"
        return
    fi
    info "正在安装 Xray..."
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
    info "Xray 安装完成"
}

# 生成配置
generate_config() {
    UUID=$(xray uuid)
    KEYS=$(xray x25519)
    PRIVATE_KEY=$(echo "$KEYS" | grep 'Private key:' | awk '{print $3}')
    PUBLIC_KEY=$(echo "$KEYS" | grep 'Public key:' | awk '{print $3}')
    SHORT_ID=$(openssl rand -hex 8)
    SERVER_IP=$(curl -s4 ifconfig.me || curl -s4 icanhazip.com)

    mkdir -p "$XRAY_CONFIG_DIR"
    cat > "$XRAY_CONFIG" <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "1.1.1.1:443",
          "xver": 0,
          "serverNames": [
            "cloudflare.com"
          ],
          "privateKey": "$PRIVATE_KEY",
          "shortIds": [
            "$SHORT_ID"
          ]
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "tag": "block"
    }
  ]
}
EOF
    info "配置文件已写入: $XRAY_CONFIG"
}

# 启动服务
start_service() {
    systemctl enable xray
    systemctl restart xray
    sleep 1
    if systemctl is-active --quiet xray; then
        info "Xray 服务已启动"
    else
        error "Xray 启动失败，请检查日志: journalctl -u xray -n 20"
    fi
}

# 输出客户端连接信息
print_client_info() {
    echo ""
    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}  Xray VLESS+REALITY 部署成功!${NC}"
    echo -e "${GREEN}============================================${NC}"
    echo ""
    echo -e "  服务器地址:  ${YELLOW}$SERVER_IP${NC}"
    echo -e "  端口:        ${YELLOW}443${NC}"
    echo -e "  协议:        ${YELLOW}VLESS${NC}"
    echo -e "  UUID:        ${YELLOW}$UUID${NC}"
    echo -e "  Flow:        ${YELLOW}xtls-rprx-vision${NC}"
    echo -e "  传输:        ${YELLOW}TCP${NC}"
    echo -e "  安全层:      ${YELLOW}REALITY${NC}"
    echo -e "  SNI:         ${YELLOW}cloudflare.com${NC}"
    echo -e "  Public Key:  ${YELLOW}$PUBLIC_KEY${NC}"
    echo -e "  Short ID:    ${YELLOW}$SHORT_ID${NC}"
    echo -e "  Fingerprint: ${YELLOW}chrome${NC}"
    echo ""
    echo -e "${GREEN}============================================${NC}"
    echo -e "  请将以上信息填入客户端配置文件"
    echo -e "  支持: Clash Meta / v2rayN / Shadowrocket"
    echo -e "${GREEN}============================================${NC}"
    echo ""
}

# 主流程
info "开始部署 Xray VLESS+REALITY..."
install_xray
generate_config
start_service
print_client_info
