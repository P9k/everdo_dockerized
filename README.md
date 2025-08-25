# everdo_dockerized

Run the GTD software [Everdo](https://everdo.net) inside a Docker container and access it via your browser. This setup enables remote synchronization and leverages the excellent [Docker GUI baseimage](https://github.com/jlesage/docker-baseimage-gui) by [jlesage](https://github.com/jlesage).  

<img width="1693" height="973" alt="grafik" src="https://github.com/user-attachments/assets/63f3a3a9-4d58-4ccd-a118-2063904c742e" />

---

## Table of Contents

- [Quickstart](#quickstart)
- [Disclaimer and Warning](#disclaimer-and-warning)
- [Motivation](#motivation)
- [Technical Details](#technical-details)
- [Build & Deploy (Detailed)](#build--deploy-detailed)
- [Synchronization Setup](#synchronization-setup)  
- [Secure Remote Access Options](#secure-remote-access-options)  
---

## Quickstart

```yaml
services:
  everdo-docker:
    image: everdo-docker
    container_name: everdo
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin # <- Change to your timezone
    ports:
      - 5800:5800
      - 5900:5900
    volumes:
      - /home/user/docker-volumes/everdo/config:/config/xdg/config # <- Change to your desired directory
    restart: unless-stopped
```

Run it:

- `git clone https://github.com/P9k/everdo_dockerized.git`
- `cd everdo_dockerized`
- Edit `compose.yaml` as necessary (`volumes:` section)
`docker compose up -d`

Then open `http://localhost:5800` (or replace localhost with your server IP). You should see the Everdo welcome screen.

For [synchronization setup](#synchronization-setup) and remote access (VPN or reverse proxy), see [this section](#synchronization-setup) below.

## Disclaimer and Warning
I am not affiliated with the developer of [Everdo](https://everdo.net) and do not own any rights to the software. This project merely provides an alternative way to run Everdo in Docker. [Everdo is proprietary software](https://everdo.net/legal/#license). While the free version can be used indefinitely with certain limitations (number of projects, areas, etc.), the full functionality requires a one-time purchase of the [Pro version](https://everdo.net/pricing/).

**Warning:** Exposing your Everdo instance to the public internet even via or a reverse proxy using TLS encryption is **risky**! Both design and implementation errors can lead to data leaks or compromise. If you require remote access to the dockerized Everdo instance, prefer methods like a VPN into your home network ([Wireguard](https://www.wireguard.com/), [Tailscale](https://tailscale.com/)). 

## Motivation

I’ve been using Everdo for years and appreciate its clean design and incorporation ofthe ["Getting Things Done" (GTD)](https://gettingthingsdone.com/) methodology.

Everdo supports two [sync methods](https://help.everdo.net/docs/sync/):
- [Local Network Sync](https://help.everdo.net/docs/sync/#local-network-sync) (free, requires one device as the sync server)
- [Encrypted Sync Service (ESS)](https://help.everdo.net/docs/sync/#encrypted-sync-service-ess) (cloud-based, subscription fee)

As Everdo is designed with a local-first philosophy, there is no official web version. Since I run a headless home server with multiple Docker services, I explored using [jlesage’s Docker GUI baseimage](https://github.com/jlesage/docker-baseimage-gui) to run Everdo in Docker and access it remotely via a browser and [noVNC](https://novnc.com/info.html).

## Technical Details
- Base image: [Ubuntu 24.04 LTS](https://github.com/jlesage/docker-baseimage-gui) from jlesage
- Everdo installation: [latest .deb package (version 1.9.0)](https://release.everdo.net/1.9.0/everdo_1.9.0_amd64.deb)

## Build & Deploy (Detailed)

- Clone this repository (requires Dockerfile, startapp.sh, compose.yaml).
- Build the local image using the Dockerfile:
    - Deploy the container using `docker compose` or a tool like [Portainer](https://www.portainer.io/).
    - Adjust the persistent volume path to retain your data across restarts.
    - Published ports:
            `5800` -> Browser-based GUI (via noVNC)
            `5900` -> VNC client

- Access Everdo in your browser:

    - Example: `http://192.168.178.2:5800` or `http://my-homelab:5800`. You should see the Everdo welcome screen.

## Synchronization Setup
0. (Optional but recommended) Unlock Pro Features

    Place your purchased key file in the everdo directory inside the persistent volume.

    In Everdo, select Add Product Key → navigate to /config/xdg/config/everdo → activate.

1. Enable the API

    Go to Settings → API

    Set IP/Hostname → `0.0.0.0`

    (Optional) Change the API Key

    Enable the checkbox and restart the container

    On startup, you should see a notification that the API is listening.

2. Configure Sync Server

    Go to Settings → Sync

    Set Sync Mode → `Server`

    Restart the container

3. Connect Client(s)

    On your Everdo client device:

        Set Sync Mode → `Manual Client`

        Enter server hostname, port and API key

        Test using “Manual Actions” to confirm the connection

Once manual sync works, switch to `Client` mode and restart the container. This enables automatic synchronization.

## Secure Remote Access Options

**Directly exposing port `11111`` on your router is discouraged.** 

Instead, use one of the following safer methods:

### Option A: VPN (Recommended)

Set up a VPN (e.g., [Wireguard](https://www.wireguard.com/) or [Tailscale](https://tailscale.com/)) to securely access your home network and the Everdo sync server. In this case, just follow the official Everdo [local sync setup documentation](https://help.everdo.net/docs/sync/network/).

### Option B: Reverse Proxy with TLS

Use a reverse proxy such as [Caddy](https://caddyserver.com/docs/quick-starts/reverse-proxy) to expose Everdo securely. You need either a static IP or a dynamic DNS service like [deSEC](https://desec.io/).

Example Caddyfile configuration for forwarding `everdosync.mydomain.com` (with TLS) to Everdo’s API within the internal Docker network:

https://everdosync.mydomain.com:443 {
    reverse_proxy everdo:11111 {
        transport http {
            tls_insecure_skip_verify
        }
    }
}

After restarting Caddy, requests to `https://everdosync.mydomain.com` → are forwarded with TLS encryption → internal Everdo API.

<img width="547" height="485" alt="grafik" src="https://github.com/user-attachments/assets/7d79e8ed-8324-493b-8b77-5051c5c0e42d" />
