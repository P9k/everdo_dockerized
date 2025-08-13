# everdo_dockerized
Run the GTD software [Everdo](https://everdo.net) in a Docker container and access it via browser. Allows remote synchronization with the usually required (ESS protocol)[https://help.everdo.net/docs/sync/ess/]. Utilizes the amazing [Docker GUI baseimage](https://github.com/jlesage/docker-baseimage-gui) by [jlesage](https://github.com/jlesage).

## Disclaimer
[Everdo](https://everdo.net) is proprietary software that requires purchase of the (Pro version)[https://everdo.net/pricing/] (one-time purchase) for full functionality. However, the free version that possesses some restrictions regarding number of possible projects, areas etc. can be used indefinitely. [Everdo can be downloaded here.](https://everdo.net/#download-form)

I am not connected to the Everdo developer in any capacity and don't own any rights regarding this software. I am just presenting an alternative way of running the software in a Docker setup.

## Motivation
I am an [Everdo](https://everdo.net) user since a couple of years and really enjoy the clean and accessible design of this to-do-list software following the ["Getting Things Done" (GTD)]() principle.

Everdo has two ways of [synchronizing the data](https://help.everdo.net/docs/sync/): [Local network sync]([https://help.everdo.net/docs/sync/#local-network-sync](https://help.everdo.net/docs/sync/network/)), which requires that one device is the server that communicates and distributes the changes to all clients and the [Encrypted Sync Service (ESS)](https://help.everdo.net/docs/sync/ess/), which does not require a local server-client infrastructure, but costs a regular subscription fee.

The Everdo software philohophy is local-first and thus the program does not possess an online version out-of-the-box.

Since I am running a headless home-server running several Docker services, I wanted to try out if I could utilize the  [Docker GUI baseimage](https://github.com/jlesage/docker-baseimage-gui) by [jlesage](https://github.com/jlesage) to install Everdo within and get access to the software via VNC (similar to jlesage's [other](https://github.com/jlesage/docker-firefox) [projects](https://github.com/jlesage/docker-jdownloader-2)).

## Technical details
Everdo runs on several operating systems and provides installation packages for different Linux distributions. I chose the [*.deb package of the current version](https://release.everdo.net/1.9.0/everdo_1.9.0_amd64.deb) together with the newest Ubuntu image provided in jselage's repository ([Ubuntu 24.04 LTS](https://github.com/jlesage/docker-baseimage-gui?tab=readme-ov-file#images)).

## How to build your image locally and deploy the container
 1. Clone the repository: You need the files `Dockerfile`, `startapp.sh` and `compose.yaml`
 2. Use the `Dockerfile` to build your local image
 3. Use the provided `compose.yaml` as a template to deploy via Docker compose, e.g. using Portainer. Adjust the path for the persistent volume so Everdo can store the data even after restarting the container

