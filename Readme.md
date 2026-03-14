# BreakingWall

Xray VLESS+REALITY 一键部署与客户端配置方案。

**协议**: VLESS | **传输**: TCP | **安全层**: REALITY | **伪装**: cloudflare.com

相比传统 Shadowsocks，VLESS+REALITY 无需域名和证书，流量特征与正常 TLS 访问无异，抗检测能力极强。

## 文件说明

| 文件 | 用途 |
|------|------|
| `ServerScript.sh` | 服务端一键部署脚本 |
| `Client.yaml` | Clash Meta / Clash Verge Rev 客户端配置 |
| `client-config.json` | Xray / v2rayN 原生客户端配置 |

## 服务端部署

**环境要求**: Linux (Ubuntu/Debian/CentOS) + root 权限

```bash
curl -sL https://raw.githubusercontent.com/monsterxz9/BreakingWall/main/ServerScript.sh | sudo bash
```

脚本会自动完成：
- 安装 Xray
- 生成 UUID、x25519 密钥对、Short ID
- 写入 VLESS+REALITY 配置
- 启动 systemd 服务
- 输出客户端所需的连接信息

部署完成后会打印如下信息，请妥善保存：

```
  服务器地址:  xxx.xxx.xxx.xxx
  端口:        443
  UUID:        xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  Public Key:  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  Short ID:    xxxxxxxxxxxxxxxx
```

## 客户端配置

### Clash Meta / Clash Verge Rev

1. 复制 `Client.yaml` 内容
2. 将 `YOUR_SERVER_IP`、`YOUR_UUID`、`YOUR_PUBLIC_KEY`、`YOUR_SHORT_ID` 替换为服务端输出的实际值
3. 导入到 Clash Verge Rev 的 Profiles 中

### v2rayN / Xray 原生客户端

1. 复制 `client-config.json` 内容
2. 替换 `YOUR_*` 占位符
3. 导入到 v2rayN 或直接用 `xray run -c client-config.json` 启动

### Shadowrocket (iOS)

手动添加节点：
- 类型: VLESS
- 地址 / 端口: `YOUR_SERVER_IP` / `443`
- UUID: `YOUR_UUID`
- TLS: REALITY
- SNI: `cloudflare.com`
- Public Key / Short ID: 对应值
- Flow: `xtls-rprx-vision`

## 管理命令

```bash
# 查看服务状态
systemctl status xray

# 查看日志
journalctl -u xray -n 30 --no-pager

# 重启服务
systemctl restart xray

# 查看配置
cat /usr/local/etc/xray/config.json
```

## License

MIT License. See [LICENSE](LICENSE) for details.
