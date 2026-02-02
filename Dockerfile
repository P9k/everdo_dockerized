# Pull base image.
FROM jlesage/baseimage-gui:debian-13-v4

# Install Everdo dependencies
RUN apt-get update && apt-get install -y \
    wget \
    libasound2t64 \
    libglib2.0-0 \
    libnss3 \
    libgtk-3-0 \
    libgbm1 \
    && rm -rf /var/lib/apt/lists/*

# Download and extract Everdo AppImage
RUN wget --no-verbose --timeout=30 --tries=3 \
    https://downloads.everdo.net/electron/Everdo-1.10.4.AppImage \
    -O /tmp/Everdo.AppImage \
    && chmod +x /tmp/Everdo.AppImage \
    && /tmp/Everdo.AppImage --appimage-extract \
    && mv squashfs-root /opt/Everdo \
    && chmod -R 755 /opt/Everdo  \
    && rm -f /tmp/Everdo.AppImage

# Copy the start script.
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Set the name of the application.
RUN set-cont-env APP_NAME "Everdo"
