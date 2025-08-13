# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-24.04-v4

# Install Everdo and a dependency.
RUN apt-get update && apt-get install -y wget libasound2t64
RUN wget  https://release.everdo.net/1.9.0/everdo_1.9.0_amd64.deb -O everdo_1.9.0_amd64.deb
RUN dpkg -i everdo_1.9.0_amd64.deb; apt-get install -y -f

# Copy the start script.
COPY startapp.sh /startapp.sh

# Set the name of the application.
RUN set-cont-env APP_NAME "Everdo"
