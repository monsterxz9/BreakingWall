# BreakingWall

BreakingWall is an automated script designed to quickly configure and start a Shadowsocks proxy server. This script will install Docker, create a Shadowsocks configuration file, and start a Shadowsocks server container.



## Prerequisites

- You need `sudo` privileges to install software and execute the script.
- Ensure your system can access the internet to download the script from GitHub.

## Usage

1. **Run the Script**

   Use the following command to download and execute the script from GitHub:

   ```bash
   curl -sL https://raw.githubusercontent.com/monsterxz9/BreakingWall/main/ServerScript.sh | sudo bash
   ```

   This command will automatically:
   - Update package lists
   - Install Docker
   - Create a Shadowsocks configuration file
   - Start the Shadowsocks server container

2. **Configure Clash Verge**

   After setting up your Shadowsocks server, you need to configure Clash Verge to use it. Create or edit your Clash Verge configuration file (`config.yaml`) with the following content:

   ```yaml
   # Profile Template for Clash Verge

   proxies:
     - name: "Shadowsocks-Server"
       type: ss
       server: "YOUR_SERVER_IP_ADDRESS"
       port: 8388
       cipher: "aes-256-gcm"
       password: "YOUR_PASSWORD_HERE"

   proxy-groups: []

   rules:
     - DOMAIN-SUFFIX,google.com,Shadowsocks-Server
     - DOMAIN-KEYWORD,facebook,Shadowsocks-Server
     - GEOIP,CN,DIRECT
     - MATCH,Shadowsocks-Server
   ```

   - Replace `YOUR_SERVER_IP_ADDRESS` with the IP address of your Shadowsocks server.
   - Replace `YOUR_PASSWORD_HERE` with the password you set for your Shadowsocks server.

3. **Verify the Setup**

   - **Check Docker Container**: Verify that the Shadowsocks server container is running:

     ```bash
     sudo docker ps
     ```

   - **Check Clash Verge**: Ensure Clash Verge is properly configured and running with the updated `config.yaml`.

## Configuration File Explanation

- **`proxies`**: Defines the Shadowsocks proxy with the necessary connection details.
- **`proxy-groups`**: (Empty in this template) Allows you to define groups of proxies for more advanced routing.
- **`rules`**: Defines routing rules for different types of traffic:
  - `DOMAIN-SUFFIX` and `DOMAIN-KEYWORD` rules route specific traffic through the Shadowsocks server.
  - `GEOIP` rule routes traffic from China directly without using the proxy.
  - `MATCH` rule routes all other traffic through the Shadowsocks server.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please submit feedback via GitHub Issues, and we will address them as soon as possible.


## Summary of Additions:
- **Clash Verge Configuration**: Instructions for setting up the Clash Verge configuration file.
- **Configuration File Explanation**: A brief description of what each section in the `config.yaml` does.
- **Verify the Setup**: Instructions on how to check that both Docker and Clash Verge are running correctly.

Feel free to adjust or add any specific details relevant to your project.
