# everdo_dockerized
Run the GTD software [Everdo](https://everdo.net) in a Docker container and access it via browser. Allows remote synchronization with the usually required (ESS protocol)[https://help.everdo.net/docs/sync/ess/]. Utilizes the amazing [Docker GUI baseimage](https://github.com/jlesage/docker-baseimage-gui) by [jlesage](https://github.com/jlesage).

 <img width="1693" height="973" alt="grafik" src="https://github.com/user-attachments/assets/63f3a3a9-4d58-4ccd-a118-2063904c742e" />

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
 3.Use the provided `compose.yaml` as a template to deploy via Docker compose, e.g. using Portainer. Adjust the path for the persistent volume so Everdo can store the data even after restarting the container. Note that the exposed ports in the compose file are `5800` and `5900` (for VNC) and `11111` (for the Everdo API, i.e. to use the synchronization feature)
 4. Go to the published port (5800) of the machine running your docker instance, e.g. (192.168.178.2:5800)[] or (my-homelab:5800)[] and you should see the program showing the Everdo "Welcome screen" via VNC like this


## How to use your dockerized Everdo instance as a synchronization server for your clients
0. Optional, but highly recommended: Activate the full version of Everdo with your purchased key file. For that, first place your key file in the `everdo` directory of the persistent volume that you've created. Then in Everdo, select `Add Product Key` from Hamburger menu in the top-right and navigate to `/config/xdg/config/everdo` where you should see your key file. Click to activate.
<img width="1687" height="980" alt="grafik" src="https://github.com/user-attachments/assets/f75f35b1-7780-4c08-bd35-059f83667568" />
<img width="411" height="177" alt="grafik" src="https://github.com/user-attachments/assets/9cdebf0d-5f99-4591-a5e6-054e83f4d292" />

1. Activate the API: Go to `Settings`, `API`, change the `IP/Hostname` to `0.0.0.0` (so it listens for every incoming traffic), change the `API Key` to something else if you like, click the checkmark in case it is not activated and restart the container in order to activate the API settings (there should be a notification that the API is listening when starting up)
<img width="436" height="335" alt="grafik" src="https://github.com/user-attachments/assets/89141c3e-8b36-481c-97ca-2eaf70fec29b" />

1.5. Optional: Forward port 11111. In order to allow your clients to communicate with the server, you need to open the port `11111` in your router and have either a static IP or a dynamic DNS service (in my opinion, (desec.io)[] is pretty good)

2. Set up syncing server: Go to `Settings`, `Sync` and select `Server` as Sync Mode, click `Apply` and restart the container

3. In your client, select `Manual Client` as Sync Mode and enter your servers hostname, the API port `11111`, the API Key and test one of the Manual Actions to see if the connection works

4. If all went well, you have successfully set up remote synchronization with your dockerized Everdo instance - enjoy! :)



